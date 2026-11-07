#define CD2_VARIANT CDMA2D1
#define CD2_MODE 1
#include "DMA2DShim.h"
#if defined(__clang__)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#endif
#include "Upstream/DMA2DFunctions.inc"
#if defined(__clang__)
#pragma clang diagnostic pop
#endif
#include "DMA2DVariant.inc"
