#include "include/CWatchdogReference.h"
#define USE_HAL_WWDG_REGISTER_CALLBACKS 1
#define CWATCHDOG_VARIANT 1
#include "Upstream/WatchdogReferenceShim.h"
#include "Upstream/WWDGMacros.h"
#include "Upstream/WWDGNamespace.h"
#include "Upstream/WWDGPrototypes.inc"
/* CMSIS 1UL is 64 bits on LP64 hosts. The unchanged CLEAR_FLAG assignment
 * intentionally truncates ~1UL to the 32-bit volatile register, as on ARM. */
#if defined(__clang__) && defined(__LP64__)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconstant-conversion"
#endif
#include "Upstream/WWDGFunctions.inc"
#if defined(__clang__) && defined(__LP64__)
#pragma clang diagnostic pop
#endif
