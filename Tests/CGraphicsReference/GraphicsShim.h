#define CGRAPH_JOIN_INNER(a,b) a##b
#define CGRAPH_JOIN(a,b) CGRAPH_JOIN_INNER(a,b)
#include "Upstream/GFXMMUNamespace.h"
#include "Upstream/GPU2DNamespace.h"
#include "GraphicsInternal.h"
#undef USE_HAL_GFXMMU_REGISTER_CALLBACKS
#undef USE_HAL_GPU2D_REGISTER_CALLBACKS
#define USE_HAL_GFXMMU_REGISTER_CALLBACKS CGRAPH_MODE
#define USE_HAL_GPU2D_REGISTER_CALLBACKS CGRAPH_MODE
#define assert_param(expression) ((void)0)
#define READ_REG(reg) CGraphics_GPUReadAddress(&(reg))
#define WRITE_REG(reg,value) CGraphics_GPUWriteAddress(&(reg),(value))
#define CLEAR_BIT(reg,bits) WRITE_REG(reg,READ_REG(reg) & ~(bits))
#define GPU2D_ReadReg(instance,offset) READ_REG(*(volatile uint32_t *)((instance)+(offset)))
#define GPU2D_WriteReg(instance,offset,value) WRITE_REG(*(volatile uint32_t *)((instance)+(offset)),value)
#define GFXMMU_LUTXL_FVB_OFFSET 8U
#define GFXMMU_LUTXL_LVB_OFFSET 16U
#define GFXMMU_CR_ITS_MASK 0x1FU
#define __get_PRIMASK() CGraphics_Mask(CGraphics_Active,0,0)
#define __disable_irq() ((void)CGraphics_Mask(CGraphics_Active,1,0))
#define __set_PRIMASK(value) ((void)CGraphics_Mask(CGraphics_Active,2,value))
/* Header macros depend on the compile-time mode, so redefine the two reset
 * variants with the original header statements after selecting that mode. */
#undef __HAL_GFXMMU_RESET_HANDLE_STATE
#undef __HAL_GPU2D_RESET_HANDLE_STATE
#if CGRAPH_MODE
#define __HAL_GFXMMU_RESET_HANDLE_STATE(h) do { (h)->State=HAL_GFXMMU_STATE_RESET; (h)->MspInitCallback=NULL; (h)->MspDeInitCallback=NULL; } while(0)
#define __HAL_GPU2D_RESET_HANDLE_STATE(h) do { (h)->State=HAL_GPU2D_STATE_RESET; (h)->MspInitCallback=NULL; (h)->MspDeInitCallback=NULL; (h)->CommandListCpltCallback=NULL; } while(0)
#else
#define __HAL_GFXMMU_RESET_HANDLE_STATE(h) ((h)->State=HAL_GFXMMU_STATE_RESET)
#define __HAL_GPU2D_RESET_HANDLE_STATE(h) ((h)->State=HAL_GPU2D_STATE_RESET)
#endif

#define customMMUError CGRAPH_JOIN(CGRAPH_VARIANT,_customMMUError)
#define customMMUInit CGRAPH_JOIN(CGRAPH_VARIANT,_customMMUInit)
#define customMMUDeinit CGRAPH_JOIN(CGRAPH_VARIANT,_customMMUDeinit)
#define customGPUInit CGRAPH_JOIN(CGRAPH_VARIANT,_customGPUInit)
#define customGPUDeinit CGRAPH_JOIN(CGRAPH_VARIANT,_customGPUDeinit)
#define customGPUComplete CGRAPH_JOIN(CGRAPH_VARIANT,_customGPUComplete)
