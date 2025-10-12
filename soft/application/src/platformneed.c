#include "stdio.h"
#include "stdint.h"
#include "stdbool.h"
#include "cos.h"
#include "event.h"
#include "dm.h"
#include "sxs_io.h"
#include "csw.h"

void* lodepng_malloc(size_t size)
{
    return COS_Malloc(size, 0x00);
}
void* lodepng_realloc(void* ptr, size_t new_size)
{
    return COS_Realloc(ptr, new_size);
}
void lodepng_free(void* ptr)
{
    COS_Free(ptr);
}

BOOL _GetACLBStatus()
{
    return FALSE;
}

void MMIDisplayWaitingAnimation(void)
{
    return;
}
VOID SRVAPI BAL_InitSysFreq(VOID)
{
    ; // do nothing
}
extern MMI_Default_Value g_MMI_Default_Value;
VOID BAL_SetMMIDefaultValue(VOID)
{
    g_MMI_Default_Value.nMinVol = 3200;
    g_MMI_Default_Value.nMemorySize = 500 * 1024;
}

void Trace(UINT16 nIndex, PCSTR fmt, ...)
{
    char uart_buf[256];
    va_list ap;
    va_start (ap, fmt);
    vsnprintf(uart_buf, sizeof(uart_buf), fmt, ap);
    va_end (ap);
    if (nIndex == 0x00)
    {
        // Forced trace
        SXS_TRACE(_MMI | TNB_ARG(0) | TSTDOUT, uart_buf);
    }
    else
    {
        // Regular trace
        SXS_TRACE(_MMI | TNB_ARG(0) | TLEVEL(nIndex), uart_buf);
    }
}

// ============================================================
// Stub implementations for AT+MMI mode (modem-only, no phone features)
// These functions are expected by AT module when building with CT_MODEM=2
// ============================================================

// 1. Earphone detection stubs (not needed for modem-only)
//    Used by AT module for audio routing detection
static UINT8 s_earphoneStatus = 0;

UINT8 GetHandsetInPhone(VOID)
{
    return s_earphoneStatus;  // Always return "not plugged"
}

VOID SetHandsetInPhone(UINT8 h_status)
{
    s_earphoneStatus = h_status;  // Accept but ignore
}

// 2. Auto Call Back status stub (AT command AT+ACLB feature)
//    Used by AT module for network communication control
static UINT8 s_aclbStatus = 0;

UINT32 _SetACLBStatus(UINT8 nACLBNWStatus)
{
    s_aclbStatus = nACLBNWStatus;
    return 0;  // ERR_SUCCESS
}

// 3. TF card detection stub (no storage for modem-only)
//    Used by AT module for PCM dump feature
BOOL checkTCardExist(void)
{
    return FALSE;  // No TF card present
}

// 4. Transport task handle (not used for modem-only)
//    Used by socket API for task routing
HANDLE g_TransportHandle = 0;  // NULL handle
