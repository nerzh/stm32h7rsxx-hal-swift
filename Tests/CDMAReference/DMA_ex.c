#include "Upstream/DMAReferenceShim.h"
/* Preserve the upstream ARM32 casts on the host; pointer-walking entry points
 * are never called there. Diagnostics remain enabled for the model/shim. */
#if defined(__clang__) && !defined(CDMA_REFERENCE_ARM)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#pragma clang diagnostic ignored "-Wint-to-pointer-cast"
#pragma clang diagnostic ignored "-Wconstant-conversion"
#endif
#include "Upstream/DMA_EXFunctions.inc"
#if defined(__clang__) && !defined(CDMA_REFERENCE_ARM)
#pragma clang diagnostic pop
#endif
