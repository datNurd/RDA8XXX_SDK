/* Copyright (C) 2016 RDA Technologies Limited and/or its affiliates("RDA").
* All rights reserved.
*
* This software is supplied "AS IS" without any warranties.
* RDA assumes no responsibility or liability for the use of the software,
* conveys no license or title under any patent, copyright, or mask work
* right to the product. RDA reserves the right to make changes in the
* software without notification.  RDA also make no representation or
* warranty that such application will be suitable for the specified use
* without further testing or modification.
*/

#ifndef _APPLICATIONP_VERSION_H_
#define _APPLICATIONP_VERSION_H_

// =============================================================================
//  MACROS
// =============================================================================

#define APPLICATION_VERSION_REVISION                     (0x88888888)

// =============================================================================
//  TYPES
// =============================================================================

#ifndef APPLICATION_VERSION_NUMBER
#define APPLICATION_VERSION_NUMBER                       (0)
#endif

#ifndef APPLICATION_VERSION_DATE
#define APPLICATION_VERSION_DATE                         (BUILD_DATE)
#endif

#ifndef APPLICATION_VERSION_STRING
#define APPLICATION_VERSION_STRING                       "APP version string not defined"
#endif

#ifndef APPLICATION_VERSION_STRING_WITH_BRANCH
#define APPLICATION_VERSION_STRING_WITH_BRANCH           APPLICATION_VERSION_STRING " Branch: " "8955.W17.44"
#endif

#define APPLICATION_VERSION_STRUCT                       {APPLICATION_VERSION_REVISION, \
                                                  APPLICATION_VERSION_NUMBER, \
                                                  APPLICATION_VERSION_DATE, \
                                                  APPLICATION_VERSION_STRING_WITH_BRANCH}

#endif // _APPLICATIONP_VERSION_H_
