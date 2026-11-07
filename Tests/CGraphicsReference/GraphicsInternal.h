#ifndef CGRAPHICS_INTERNAL_H
#define CGRAPHICS_INTERNAL_H
#include "include/CGraphicsReference.h"
#include "stm32h7rsxx_hal_def.h"
#include <assert.h>
#include <string.h>
#define USE_HAL_GFXMMU_REGISTER_CALLBACKS 1
#define USE_HAL_GPU2D_REGISTER_CALLBACKS 1
#define GFXMMU 1
#define GPU2D 1
#include "Upstream/GFXMMUBits.h"
#include "Upstream/stm32h7rsxx_hal_gfxmmu.h"
#include "Upstream/stm32h7rsxx_hal_gpu2d.h"
/* Both variants retain callback slots in test storage. Legacy C never accesses
 * them; the functions themselves are compiled with their original #if mode. */
struct CGraphicsState {
    GFXMMU_TypeDef mmu;
    uint32_t gpu[1024], input[2048];
    GFXMMU_HandleTypeDef mmuHandle;
    GPU2D_HandleTypeDef gpuHandle;
    uint32_t mode, primask, callbackAction;
    uint32_t traceCount, trace[64][20];
};
extern CGraphicsState *CGraphics_Active;
void CGraphics_Event(CGraphicsState *state, uint32_t kind, uint32_t a, uint32_t b);
uint32_t CGraphics_GPUReadAddress(const volatile uint32_t *address);
void CGraphics_GPUWriteAddress(volatile uint32_t *address, uint32_t value);
uint32_t CGraphics0_Run(CGraphicsState *, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t);
uint32_t CGraphics1_Run(CGraphicsState *, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t);
void CGraphics0_SetCallback(CGraphicsState *, uint32_t, uint32_t, uint32_t);
void CGraphics1_SetCallback(CGraphicsState *, uint32_t, uint32_t, uint32_t);
uint32_t CGraphics0_GetCallback(CGraphicsState *, uint32_t, uint32_t);
uint32_t CGraphics1_GetCallback(CGraphicsState *, uint32_t, uint32_t);
#endif
