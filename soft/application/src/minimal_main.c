/* Minimal Non-UI Application for RDA8XXX
 * Designed for AT+MMI mode (CT_MODEM=2)
 * Provides basic event loop without UI components
 * CFW/System initialization is handled by AT module
 */

#include "stdio.h"
#include "stdint.h"
#include "stdbool.h"
#include "cos.h"
#include "event.h"
#include "dm.h"
#include "sxs_io.h"
#include "csw.h"

// Task configuration (from AT module)
#define MINIMAL_TASK_STACK_SIZE (2048 * 2)
#define MINIMAL_TASK_PRIORITY (COS_MMI_TASKS_PRIORITY_BASE + 9)
#define MMI_FLASHTASK_PRIORITY (COS_MMI_TASKS_PRIORITY_BASE + 10)

// Task handle
HANDLE mainTaskHandle = HNULL;

#ifdef __VDS_QUICK_FLUSH__
UINT32 g_htstVdsTask = 0;
extern VOID VDS_CacheTaskEntry(void *pData);
#endif

#include "mmi_trace.h"
#include "network_manager.h"

// AT task handle and DM handler registration (for AT+MMI mode)
#ifndef ONLY_MMI_SUPPORT
extern HANDLE COS_GetDefaultATTaskHandle(VOID);
extern BOOL DM_RegisterHandler(UINT8 nDeviceId, PFN_DEVICE_HANDLER pfnDevHandler);
#endif

// Macro for memory cleanup
#define APP_ZERO_PARAM1(pEv) do { (pEv)->nParam1 = 0; } while (0)

// Event counter for diagnostics
static uint32_t g_EventCounter = 0;

// Auto-connect timer ID
#define TIMER_AUTO_CONNECT  0xF1

#ifndef ONLY_MMI_SUPPORT
/**
 * Event forwarder callbacks for AT+MMI mode
 *
 * These functions are registered with DM_RegisterHandler() and called by the
 * framework when DM events occur. They forward events to AT task mailbox for
 * processing in the correct task context.
 *
 * Execution context: BAL_DevMonitorTask (the task that calls DM_Send*Message)
 * Target context: BAL_ATTask (where AT event handlers execute)
 */

/**
 * Forward EV_DM_POWER_ON_IND to AT task (CRITICAL)
 * This event triggers CFW_ShellControl() initialization in SA_ProcPowerOnInd()
 * Without this, CFW layer never initializes and AT commands don't work.
 */
static VOID MMI_ForwardToAT_PowerOn(COS_EVENT *pEvent)
{
    HANDLE hAtTask = COS_GetDefaultATTaskHandle();
    if (hAtTask != HNULL)
    {
        MMILOGI("[MINIMAL] Forwarding EV_DM_POWER_ON_IND to AT task");
        // COS_SendEvent() copies event structure - safe for value types
        COS_SendEvent(hAtTask, pEvent, COS_WAIT_FOREVER, COS_EVENT_PRI_NORMAL);
    }
    else
    {
        MMILOGW("[MINIMAL] Cannot forward power-on event: AT task handle is NULL");
    }
}

/**
 * Forward EV_TIM_ALRAM_IND to AT task
 * AT task sends +CALV URC when alarm triggers
 */
static VOID MMI_ForwardToAT_Alarm(COS_EVENT *pEvent)
{
    HANDLE hAtTask = COS_GetDefaultATTaskHandle();
    if (hAtTask != HNULL)
    {
        MMILOGI("[MINIMAL] Forwarding EV_TIM_ALRAM_IND to AT task");
        COS_SendEvent(hAtTask, pEvent, COS_WAIT_FOREVER, COS_EVENT_PRI_NORMAL);
    }
    else
    {
        MMILOGW("[MINIMAL] Cannot forward alarm event: AT task handle is NULL");
    }
}

/**
 * Forward EV_DM_GPADC_IND to AT task
 * AT task sends +HEADSET URC for headphone insertion/removal
 */
static VOID MMI_ForwardToAT_Gpadc(COS_EVENT *pEvent)
{
    HANDLE hAtTask = COS_GetDefaultATTaskHandle();
    if (hAtTask != HNULL)
    {
        MMILOGI("[MINIMAL] Forwarding EV_DM_GPADC_IND to AT task");
        COS_SendEvent(hAtTask, pEvent, COS_WAIT_FOREVER, COS_EVENT_PRI_NORMAL);
    }
    else
    {
        MMILOGW("[MINIMAL] Cannot forward GPADC event: AT task handle is NULL");
    }
}
#endif // ONLY_MMI_SUPPORT

/**
 * Event dispatcher - logs all system events
 * In AT+MMI mode, AT module handles CFW initialization
 * This is just for monitoring and custom application logic
 */
void MINIMAL_DispatchMessage(COS_EVENT *pev)
{
    g_EventCounter++;

    // Log all events for debugging
    MMILOGI("[MINIMAL] Event #%d: 0x%08x/0x%08x/0x%08x/0x%08x",
          g_EventCounter, pev->nEventId, pev->nParam1, pev->nParam2, pev->nParam3);

    switch (pev->nEventId)
    {
    // EV_DM_POWER_ON_IND is fully handled by AT module (SA_ProcPowerOnInd)
    // AT module calls CFW_ShellControl() and handles all power-on initialization
    // No need to handle it here to avoid conflicts with AT's handling

    case EV_TIMER:
        // Auto-connect timer
        if (pev->nParam1 == TIMER_AUTO_CONNECT) {
            MMILOGI("[MINIMAL] ==========================================");
            MMILOGI("[MINIMAL] Auto-connect timer expired");
            MMILOGI("[MINIMAL] Requesting internet connection...");
            MMILOGI("[MINIMAL] ==========================================");

            // Request connection (non-blocking)
            // BSNL APN Configuration:
            // - BSNL 2G/3G: "bsnlnet" (most common)
            // - BSNL 4G: "www" (if 4G capable)
            // - Alternative: "bsnllive" or "bsnlmms"
            NetMgr_Connect("bsnlnet", CFW_SIM_0);
        }
        break;

    case EV_NET_CONNECTED: {
        // Internet connection successful!
        UINT8 cid = (UINT8)pev->nParam1;
        UINT32 ip = pev->nParam2;

        MMILOGI("[MINIMAL] ==========================================");
        MMILOGI("[MINIMAL]  INTERNET CONNECTED!");
        MMILOGI("[MINIMAL]  CID: %d", cid);
        MMILOGI("[MINIMAL]  IP:  %d.%d.%d.%d",
               (ip >> 0) & 0xFF,
               (ip >> 8) & 0xFF,
               (ip >> 16) & 0xFF,
               (ip >> 24) & 0xFF);
        MMILOGI("[MINIMAL] ==========================================");

        // ================================================================
        // TODO: START YOUR INTERNET APPLICATION HERE!
        // ================================================================
        // At this point, you have a working internet connection.
        // You can now:
        // - Open TCP/UDP sockets
        // - Make HTTP/HTTPS requests
        // - Connect MQTT client
        // - Use any LwIP networking functions
        //
        // Example:
        // mqtt_connect("mqtt.example.com", 1883);
        // http_get("http://api.example.com/data");
        // ================================================================

        break;
    }

    case EV_NET_ERROR: {
        // Connection failed
        UINT8 error_code = (UINT8)pev->nParam1;

        MMILOGE("[MINIMAL] ==========================================");
        MMILOGE("[MINIMAL]  INTERNET CONNECTION FAILED!");
        MMILOGE("[MINIMAL]  Error code: 0x%02X", error_code);
        MMILOGE("[MINIMAL] ==========================================");

        // ================================================================
        // TODO: ADD RETRY LOGIC OR ERROR HANDLING
        // ================================================================
        // Options:
        // 1. Retry after delay:
        //    COS_SetTimer(mainTaskHandle, TIMER_AUTO_CONNECT,
        //                 COS_TIMER_MODE_SINGLE, 30000);  // Retry in 30s
        //
        // 2. Alert user (if UI available)
        //
        // 3. Log error and continue without internet
        // ================================================================

        break;
    }

    default:
        // Add your custom event handling here
        break;
    }
}

/**
 * Main task loop
 * MUST be named BAL_MmiTask (framework hardcoded check in cos_task.c:106)
 */
VOID BAL_MmiTask(VOID *pData)
{
    COS_EVENT event = {0};

    MMILOGI("[MINIMAL] ==========================================");
    MMILOGI("[MINIMAL] Task started - Minimal MMI Running");
    MMILOGI("[MINIMAL] Build: " __DATE__ " " __TIME__);
    MMILOGI("[MINIMAL] ==========================================");

    // Main event loop (runs forever)
    for (;;)
    {
        // Memory cleanup for event parameters (CRITICAL - prevents memory leak!)
        if (event.nParam1 != NULL)
        {
            if (COS_Free((VOID *)event.nParam1) == FALSE)
            {
                MMILOGW("[MINIMAL] Failed to free event param1");
                APP_ZERO_PARAM1(&event);
            }
        }

        // Wait for events indefinitely
        COS_WaitEvent(mainTaskHandle, &event, COS_WAIT_FOREVER);

        // Dispatch the event
        MINIMAL_DispatchMessage(&event);
    }
}

/**
 * Application initialization - Entry point called by bal_init.c:397
 * MUST be named BAL_ApplicationInit (framework requirement)
 */
BOOL SRVAPI BAL_ApplicationInit(VOID)
{
    MMILOGI("[MINIMAL] ==========================================");
    MMILOGI("[MINIMAL] BAL_ApplicationInit called");
    MMILOGI("[MINIMAL] ==========================================");

    // Register module with framework (required)
    application_RegisterYourself();

    // Create main task
    // MUST pass BAL_MmiTask - framework checks this in COS_CreateTask!
    mainTaskHandle = COS_CreateTask(BAL_MmiTask,
                                   NULL,
                                   NULL,
                                   MINIMAL_TASK_STACK_SIZE,
                                   MINIMAL_TASK_PRIORITY,
                                   COS_CREATE_DEFAULT,
                                   0,
                                   "MINIMAL Task");

    if (mainTaskHandle == HNULL)
    {
        MMILOGE("[MINIMAL] Failed to create main task!");
        return FALSE;
    }

    MMILOGI("[MINIMAL] Main task created, handle: 0x%08x", mainTaskHandle);

    // ========================================================================
    // Initialize Network Manager
    // ========================================================================
    // This creates a worker task that handles blocking network operations
    // Main task remains responsive while worker connects to internet
    // ========================================================================
    if (NetMgr_Init(mainTaskHandle)) {
        MMILOGI("[MINIMAL] ✓ Network manager initialized");

        // Set timer for auto-connect (5 seconds after boot)
        // This allows time for modem initialization
        COS_SetTimer(mainTaskHandle, TIMER_AUTO_CONNECT,
                     COS_TIMER_MODE_SINGLE, 5000);
        MMILOGI("[MINIMAL] Auto-connect timer set (5 seconds)");
    } else {
        MMILOGE("[MINIMAL] ✗ Network manager initialization FAILED!");
    }

    #ifndef ONLY_MMI_SUPPORT
    // Register AT event handlers for AT+MMI mode
    // This allows AT task to receive critical DM events for initialization
    MMILOGI("[MINIMAL] Registering AT event handlers...");

    // Register power-on handler (CRITICAL - triggers CFW initialization)
    // DM_DEVID_POWER_ON = 33
    DM_RegisterHandler(DM_DEVID_POWER_ON, MMI_ForwardToAT_PowerOn);
    MMILOGI("[MINIMAL] - Registered DM_DEVID_POWER_ON (33) handler");

    // Register alarm handler (for +CALV alarm URCs)
    // DM_DEVID_ALARM = 35
    DM_RegisterHandler(DM_DEVID_ALARM, MMI_ForwardToAT_Alarm);
    MMILOGI("[MINIMAL] - Registered DM_DEVID_ALARM (35) handler");

    // Register GPADC handler (for +HEADSET insertion/removal URCs)
    // DM_DEVID_GPADC = 38
    DM_RegisterHandler(DM_DEVID_GPADC, MMI_ForwardToAT_Gpadc);
    MMILOGI("[MINIMAL] - Registered DM_DEVID_GPADC (38) handler");

    MMILOGI("[MINIMAL] AT event handlers registered successfully");
    #endif

    #ifdef __VDS_QUICK_FLUSH__
    // VDS cache flush task - REQUIRED even in AT+MMI mode
    // AT module only creates this when MMI_ONLY_AT is defined (CT_MODEM=1)
    // In AT+MMI mode (CT_MODEM=2), MMI must create it for flash operations
    g_htstVdsTask = COS_CreateTask(VDS_CacheTaskEntry,
                                   NULL, NULL,
                                   1024,
                                   MMI_FLASHTASK_PRIORITY,
                                   COS_CREATE_DEFAULT,
                                   0,
                                   "VDS Flush Task");

    if (g_htstVdsTask == 0)
    {
        MMILOGW("[MINIMAL] Failed to create VDS flush task");
    }
    else
    {
        MMILOGI("[MINIMAL] VDS flush task created: 0x%08x", g_htstVdsTask);
    }
    #endif

    MMILOGI("[MINIMAL] Initialization complete");
    return TRUE;
}
