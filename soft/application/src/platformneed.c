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
