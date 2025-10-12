/* Network Manager - Worker Task Implementation
 *
 * RTOS Design:
 * - This task CAN block (it's a dedicated worker, not event dispatcher)
 * - Calls startGprsLink() which blocks until connection ready
 * - Sends status notifications to main task via COS_SendEvent()
 * - Main task remains responsive while this task handles long operations
 */

#include "network_manager.h"
#include "mmi_trace.h"
#include "csw.h"
#include "lwip/netif.h"
#include "lwip/ip_addr.h"
#include "string.h"

// ============================================================================
// External SDK Functions
// ============================================================================

// Blocking function that handles entire GPRS connection flow:
// 1. Waits for network registration (polls every 500ms)
// 2. Attaches to GPRS
// 3. Activates PDP context
// Returns CID on success, 0xFF/0 on failure
extern UINT8 startGprsLink(UINT8 *apn, UINT8 nSIMID);

// Get LwIP network interface for given SIM and CID
extern struct netif *getGprsNetIf(UINT8 nSim, UINT8 nCid);

// ============================================================================
// Task Configuration
// ============================================================================

#define NETMGR_TASK_PRIORITY  (COS_MMI_TASKS_PRIORITY_BASE + 1)  // 221
#define NETMGR_TASK_STACK     (4096)

// Internal command event (from main task to worker task)
#define NETMGR_CMD_CONNECT    (EV_DM_BASE + 50)

// ============================================================================
// Global Context (minimal - no over-engineering)
// ============================================================================

// No mutex needed:
// - Worker task is only writer
// - Main task never reads (just receives events)
// - Single-core processor
static struct {
    HANDLE task_handle;           // Worker task handle
    HANDLE main_task_handle;      // For sending notifications
} g_netmgr;

// ============================================================================
// Forward Declarations
// ============================================================================

static void NetMgr_TaskEntry(void *param);

// ============================================================================
// Public API Implementation
// ============================================================================

/**
 * Initialize network manager and create worker task
 */
BOOL NetMgr_Init(HANDLE main_task_handle)
{
    if (main_task_handle == HNULL) {
        MMILOGE("[NETMGR] Invalid main task handle");
        return FALSE;
    }

    g_netmgr.main_task_handle = main_task_handle;

    // Create worker task
    g_netmgr.task_handle = COS_CreateTask(
        NetMgr_TaskEntry,
        NULL,
        NULL,
        NETMGR_TASK_STACK,
        NETMGR_TASK_PRIORITY,
        COS_CREATE_DEFAULT,
        0,
        "NetMgr"
    );

    if (g_netmgr.task_handle == HNULL) {
        MMILOGE("[NETMGR] Failed to create worker task");
        return FALSE;
    }

    MMILOGI("[NETMGR] Initialized, task handle: 0x%08x", g_netmgr.task_handle);
    return TRUE;
}

/**
 * Request connection (non-blocking)
 *
 * ZERO-COPY DESIGN:
 * - APN parameter must be a string literal (e.g., "CMNET", "CMWAP")
 * - String literals live in .rodata section (permanent memory)
 * - Just passes pointer to worker task (no heap allocation, no copy)
 * - Worker task uses pointer immediately in startGprsLink() (synchronous)
 *
 * @param apn APN name (must be string literal or have lifetime >= connection)
 * @param sim_id SIM card identifier
 * @return ERR_SUCCESS or error code
 */
UINT32 NetMgr_Connect(const char *apn, CFW_SIM_ID sim_id)
{
    if (g_netmgr.task_handle == HNULL) {
        MMILOGE("[NETMGR] Not initialized");
        return ERR_CME_OPERATION_NOT_ALLOWED;
    }

    if (apn == NULL) {
        MMILOGE("[NETMGR] Invalid APN");
        return ERR_CFW_INVALID_PARAMETER;
    }

    // Send command to worker task
    // Just pass the APN pointer - no heap allocation needed!
    COS_EVENT ev = {
        .nEventId = NETMGR_CMD_CONNECT,
        .nParam1 = (UINT32)apn,           // APN pointer (string literal)
        .nParam2 = sim_id,                 // SIM ID
        .nParam3 = 0
    };

    MMILOGI("[NETMGR] Sending connect command: APN=%s, SIM=%d", apn, sim_id);

    return COS_SendEvent(g_netmgr.task_handle, &ev,
                         COS_WAIT_FOREVER, COS_EVENT_PRI_NORMAL);
}

// ============================================================================
// Worker Task Implementation
// ============================================================================

/**
 * Worker task entry point
 * Event loop that handles connection requests
 * This task CAN BLOCK - it's designed for long-running operations
 */
static void NetMgr_TaskEntry(void *param)
{
    COS_EVENT event = {0};

    MMILOGI("[NETMGR] ==========================================");
    MMILOGI("[NETMGR] Worker task started");
    MMILOGI("[NETMGR] Priority: %d (lower than main)", NETMGR_TASK_PRIORITY);
    MMILOGI("[NETMGR] This task CAN block - by design!");
    MMILOGI("[NETMGR] ==========================================");

    for (;;)
    {
        // Wait for connect command from main task
        COS_WaitEvent(g_netmgr.task_handle, &event, COS_WAIT_FOREVER);

        if (event.nEventId == NETMGR_CMD_CONNECT)
        {
            char *apn = (char *)event.nParam1;
            CFW_SIM_ID sim_id = (CFW_SIM_ID)event.nParam2;

            MMILOGI("[NETMGR] ==========================================");
            MMILOGI("[NETMGR] Starting connection...");
            MMILOGI("[NETMGR] APN: %s", apn);
            MMILOGI("[NETMGR] SIM: %d", sim_id);
            MMILOGI("[NETMGR] ==========================================");

            // ================================================================
            // KEY POINT: THIS BLOCKS FOR SEVERAL SECONDS
            // ================================================================
            // startGprsLink() internally:
            // 1. Waits for network registration (polls every 500ms)
            // 2. Attaches to GPRS
            // 3. Activates PDP context
            // This is OK because we're in a worker task!
            // Main task remains responsive
            // ================================================================

            MMILOGI("[NETMGR] Calling startGprsLink() - will block...");
            UINT8 cid = startGprsLink((UINT8 *)apn, sim_id);

            if (cid == 0xFF || cid == 0) {
                // Connection failed
                MMILOGE("[NETMGR] ==========================================");
                MMILOGE("[NETMGR] Connection FAILED!");
                MMILOGE("[NETMGR] startGprsLink returned: %d", cid);
                MMILOGE("[NETMGR] ==========================================");

                // Notify main task of failure
                // No heap allocation - pack error code into event param
                COS_EVENT error_ev = {
                    .nEventId = EV_NET_ERROR,
                    .nParam1 = 0xFF,  // Error code
                    .nParam2 = 0,
                    .nParam3 = 0
                };

                COS_SendEvent(g_netmgr.main_task_handle, &error_ev,
                             COS_WAIT_FOREVER, COS_EVENT_PRI_NORMAL);

                continue;
            }

            MMILOGI("[NETMGR] PDP context activated, CID: %d", cid);

            // Get LwIP network interface
            struct netif *netif = getGprsNetIf(sim_id, cid);

            if (netif == NULL) {
                MMILOGE("[NETMGR] Failed to get network interface!");

                COS_EVENT error_ev = {
                    .nEventId = EV_NET_ERROR,
                    .nParam1 = 0xFE,  // Error code: no netif
                    .nParam2 = 0,
                    .nParam3 = 0
                };

                COS_SendEvent(g_netmgr.main_task_handle, &error_ev,
                             COS_WAIT_FOREVER, COS_EVENT_PRI_NORMAL);

                continue;
            }

            // Wait for IP address assignment (up to 10 seconds)
            MMILOGI("[NETMGR] Waiting for IP address...");
            UINT8 retries = 0;
            while (ip4_addr_isany_val(*netif_ip4_addr(netif)) && retries < 20) {
                COS_Sleep(500);
                retries++;
            }

            if (ip4_addr_isany_val(*netif_ip4_addr(netif))) {
                // No IP address received
                MMILOGE("[NETMGR] No IP address assigned after 10 seconds!");

                COS_EVENT error_ev = {
                    .nEventId = EV_NET_ERROR,
                    .nParam1 = 0xFD,  // Error code: no IP
                    .nParam2 = 0,
                    .nParam3 = 0
                };

                COS_SendEvent(g_netmgr.main_task_handle, &error_ev,
                             COS_WAIT_FOREVER, COS_EVENT_PRI_NORMAL);

                continue;
            }

            // Success! We have IP address
            UINT32 ip = netif_ip4_addr(netif)->addr;

            MMILOGI("[NETMGR] ==========================================");
            MMILOGI("[NETMGR]  SUCCESS! Internet Connected");
            MMILOGI("[NETMGR]  CID: %d", cid);
            MMILOGI("[NETMGR]  IP:  %d.%d.%d.%d",
                   (ip >> 0) & 0xFF,
                   (ip >> 8) & 0xFF,
                   (ip >> 16) & 0xFF,
                   (ip >> 24) & 0xFF);
            MMILOGI("[NETMGR] ==========================================");

            // Notify main task of success
            // No heap allocation - pack data into event params
            COS_EVENT success_ev = {
                .nEventId = EV_NET_CONNECTED,
                .nParam1 = cid,     // PDP context ID
                .nParam2 = ip,      // IP address (uint32)
                .nParam3 = 0
            };

            COS_SendEvent(g_netmgr.main_task_handle, &success_ev,
                         COS_WAIT_FOREVER, COS_EVENT_PRI_NORMAL);
        }
    }
}
