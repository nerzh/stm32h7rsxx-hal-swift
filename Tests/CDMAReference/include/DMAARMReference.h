/* Raw unchanged HAL entry points. Compile DMA.c and DMA_ex.c with
 * CDMA_REFERENCE_ARM, and provide uint32_t CDMA_HardwareTick(void).
 * Queue/node operations retain C uint32_t pointer arithmetic and require a
 * 32-bit address space; never execute pointer-walking APIs on a 64-bit heap. */
#ifndef C_DMA_ARM_REFERENCE_H
#define C_DMA_ARM_REFERENCE_H
#include "DMAReferenceTypes.h"
#include "../Upstream/DMABits.h"
#include "../Upstream/DMADeviceAddresses.h"
#include "../Upstream/DMAMacros.h"
#include "../Upstream/DMA_EXMacros.h"
#include "../Upstream/DMANamespace.h"
#include "../Upstream/DMAPrototypes.inc"
#endif
