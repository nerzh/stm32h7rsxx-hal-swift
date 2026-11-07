#define CL_JOIN_INNER(a,b) a##b
#define CL_JOIN(a,b) CL_JOIN_INNER(a,b)
#include "Upstream/LTDCNamespace.h"
#include "LTDCInternal.h"
#undef USE_HAL_LTDC_REGISTER_CALLBACKS
#define USE_HAL_LTDC_REGISTER_CALLBACKS CL_MODE
#define assert_param(expression) ((void)0)
#define READ_REG(reg) (reg)
#define WRITE_REG(reg,value) ((reg)=(value))
#define READ_BIT(reg,mask) ((reg)&(mask))
#define HAL_GetTick() CLTDC_Tick(CLTDC_Active)
#define LTDC_TIMEOUT_VALUE 100U
/* The production macro narrows pointers to uint32_t. Only this host boundary
   uses uintptr_t, retaining the original layer offsets and stride. */
#undef LTDC_LAYER
#define LTDC_LAYER(h,layer) ((LTDC_Layer_TypeDef *)((uintptr_t)(h)->Instance+0x84U+0x80U*(layer)))
static void LTDC_SetConfig(LTDC_HandleTypeDef *,const LTDC_LayerCfgTypeDef *,uint32_t);
