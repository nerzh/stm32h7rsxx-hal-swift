/* Host/ARM test bindings. Function bodies and register types remain unchanged. */
#ifndef C_DMA_REFERENCE_SHIM_H
#define C_DMA_REFERENCE_SHIM_H
#include "../include/DMAARMReference.h"
#include <stddef.h>

#define __IO volatile
#define RESET 0U
#define SET 1U
#define UNUSED(X) (void)X
#define HAL_MAX_DELAY 0xFFFFFFFFU
#define HAL_GetTick CDMA_HardwareTick
uint32_t CDMA_HardwareTick(void);
#define READ_REG(reg) (reg)
#define WRITE_REG(reg, value) ((reg) = (value))
#define READ_BIT(reg, mask) ((reg) & (mask))
#define SET_BIT(reg, mask) ((reg) |= (mask))
#define CLEAR_BIT(reg, mask) ((reg) &= ~(mask))
#define MODIFY_REG(reg, clear, set) WRITE_REG(reg, (READ_REG(reg) & ~(clear)) | (set))
#define __HAL_LOCK(handle) do { if ((handle)->Lock == HAL_LOCKED) { return HAL_BUSY; } else { (handle)->Lock = HAL_LOCKED; } } while (0U)
#define __HAL_UNLOCK(handle) do { (handle)->Lock = HAL_UNLOCKED; } while (0U)

#if defined(CDMA_REFERENCE_ARM)
_Static_assert(sizeof(void *) == 4, "Original DMA queue pointer arithmetic requires ARM32");
_Static_assert(sizeof(DMA_QListTypeDef) == 24, "Exact six-word ARM queue ABI");
#define assert_param(expression) ((void)0)
#else
#include <assert.h>
#include "../include/CDMAReference.h"
#include "DMAHostAddresses.h"
#define assert_param(expression) assert(expression)
/* The exact CMSIS IS_* macros use the remapped channel pointer constants.
 * These are the only pointer-derived HAL macros replaced on the 64-bit host. */
#undef GET_DMA_INSTANCE
#undef GET_DMA_CHANNEL
#define GET_DMA_INSTANCE(handle) CDMA_ControllerFor((handle)->Instance)
#define GET_DMA_CHANNEL(handle) CDMA_ChannelFor((handle)->Instance)
#endif

_Static_assert(sizeof(DMA_TypeDef) == 16, "Exact CMSIS DMA controller layout");
_Static_assert(sizeof(DMA_Channel_TypeDef) == 128, "Exact CMSIS DMA channel layout");
_Static_assert(offsetof(DMA_Channel_TypeDef, CTR1) == 0x40, "DMA CTR1 offset");
_Static_assert(offsetof(DMA_Channel_TypeDef, CLLR) == 0x7C, "DMA CLLR offset");
_Static_assert(sizeof(DMA_NodeTypeDef) == 36, "Exact nine-word DMA node ABI");
#endif
