/* ARM-only: upstream uses actual 32-bit pointer arithmetic for global IER. */
#include <stdint.h>
#if defined(__arm__) && UINTPTR_MAX == UINT32_MAX
#include "Upstream/RAMECCReferenceShim.h"
#include "Upstream/RAMECC1Prototypes.h"
#include "Upstream/RAMECC1Namespace.h"
#include "Upstream/RAMECCFunctions.inc"
#endif
