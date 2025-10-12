/* Network Manager - Simplified RTOS Design
 *
 * Purpose: Auto-connect to internet after modem registers to network
 * Design: Worker task handles blocking startGprsLink() operation
 *
 * RTOS Principles:
 * - Main task never blocks (remains responsive)
 * - Worker task handles long-running network operations
 * - Event-driven communication between tasks
 * - No over-engineering: minimal code, core functionality only
 */

#ifndef __NETWORK_MANAGER_H__
#define __NETWORK_MANAGER_H__

#include "cos.h"
#include "cfw.h"
#include "event.h"

// ============================================================================
// Event IDs (sent from NetMgr task to Main task)
// ============================================================================

// Connection successful - nParam1=CID, nParam2=IP address (uint32)
#define EV_NET_CONNECTED      (EV_DM_BASE + 101)

// Connection failed - nParam1=error code
#define EV_NET_ERROR          (EV_DM_BASE + 102)

// ============================================================================
// Public API
// ============================================================================

/**
 * Initialize network manager
 * Creates worker task that handles blocking network operations
 *
 * @param main_task_handle Handle of main task (for status notifications)
 * @return TRUE on success, FALSE if task creation fails
 *
 * Must be called during application initialization (BAL_ApplicationInit)
 */
BOOL NetMgr_Init(HANDLE main_task_handle);

/**
 * Request internet connection (non-blocking)
 * Sends command to worker task, returns immediately
 * Main task will receive EV_NET_CONNECTED or EV_NET_ERROR event
 *
 * @param apn APN name (e.g., "CMNET", "CMWAP")
 * @param sim_id SIM card identifier (CFW_SIM_0 or CFW_SIM_1)
 * @return ERR_SUCCESS if command sent, error code otherwise
 *
 * Worker task will:
 * 1. Wait for network registration (via startGprsLink)
 * 2. Attach to GPRS
 * 3. Activate PDP context
 * 4. Wait for IP address assignment
 * 5. Send EV_NET_CONNECTED event to main task
 */
UINT32 NetMgr_Connect(const char *apn, CFW_SIM_ID sim_id);

#endif // __NETWORK_MANAGER_H__
