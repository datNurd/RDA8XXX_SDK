/* Copyright (C) 2025 RDA Technologies Limited and/or its affiliates("RDA").
* All rights reserved.
*
* Modern MMI trace macros matching AT module pattern
* Replaces legacy Trace() function with efficient macro-based logging
*/

#ifndef _MMI_TRACE_H_
#define _MMI_TRACE_H_

#include "cos.h"
#include "sxs_io.h"  // For _MMI definition

// MMI Trace ID (uses _MMI from sxs_io.h, matches AT_TRACE_ID pattern)
#define MMI_TRACE_ID (_MMI | TLEVEL(1))

// Standard log level macros (matches ATLOGI/D/E/W/V pattern)
#define MMILOGV(...) COS_TRACE_V(MMI_TRACE_ID, __VA_ARGS__)
#define MMILOGD(...) COS_TRACE_D(MMI_TRACE_ID, __VA_ARGS__)
#define MMILOGI(...) COS_TRACE_I(MMI_TRACE_ID, __VA_ARGS__)
#define MMILOGW(...) COS_TRACE_W(MMI_TRACE_ID, __VA_ARGS__)
#define MMILOGE(...) COS_TRACE_E(MMI_TRACE_ID, __VA_ARGS__)

// Forced output (bypass runtime filtering)
#define MMILOG_FORCE(...) COS_TRACE_I(MMI_TRACE_ID | TSTDOUT, __VA_ARGS__)

#endif /* _MMI_TRACE_H_ */
