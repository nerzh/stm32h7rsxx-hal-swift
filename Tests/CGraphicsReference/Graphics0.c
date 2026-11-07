#define CGRAPH_VARIANT CGraphics0
#define CGRAPH_MODE 0
#include "GraphicsShim.h"
#if UINTPTR_MAX > UINT32_MAX
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#pragma clang diagnostic ignored "-Wint-to-pointer-cast"
#endif
#include "Upstream/GFXMMUFunctions.inc"
#include "Upstream/GPU2DFunctions.inc"
#include "GraphicsVariant.inc"
#if UINTPTR_MAX > UINT32_MAX
#pragma clang diagnostic pop
#endif
