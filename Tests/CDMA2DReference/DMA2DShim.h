#define CD2_JOIN_INNER(a,b) a##b
#define CD2_JOIN(a,b) CD2_JOIN_INNER(a,b)
#include "Upstream/DMA2DNamespace.h"
#include "DMA2DInternal.h"
#undef USE_HAL_DMA2D_REGISTER_CALLBACKS
#define USE_HAL_DMA2D_REGISTER_CALLBACKS CD2_MODE
#define assert_param(expression) ((void)0)
#define READ_REG(reg) (reg)
#define WRITE_REG(reg,value) CDMA2D_WriteAddress(&(reg),(value))
#define SET_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg)|(mask))
#define CLEAR_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg)&~(mask))
#define MODIFY_REG(reg,clear,set) WRITE_REG(reg,(READ_REG(reg)&~(clear))|(set))
#define HAL_GetTick() CDMA2D_Tick(CDMA2D_Active)
#define __HAL_RCC_DMA2D_IS_CLK_ENABLED() (CDMA2D_Active->control[0]!=0)
#define HAL_MAX_DELAY UINT32_MAX
#define DMA2D_TIMEOUT_ABORT 1000U
#define DMA2D_TIMEOUT_SUSPEND 1000U
static void DMA2D_SetConfig(DMA2D_HandleTypeDef *,uint32_t,uint32_t,uint32_t,uint32_t);
