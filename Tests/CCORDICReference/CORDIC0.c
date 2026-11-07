#define CCORDIC_VARIANT CCORDIC0
#define CCORDIC_CALLBACK_MODE 0
#include "CORDICShim.h"
/* DMA arguments intentionally retain the original uint32_t casts. */
#if defined(__clang__)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#endif
#include "Upstream/CORDICFunctions.inc"
#if defined(__clang__)
#pragma clang diagnostic pop
#endif
#include "CORDICVariantWrappers.inc"
