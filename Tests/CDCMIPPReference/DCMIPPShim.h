#define CP_JOIN_INNER(a,b) a##b
#define CP_JOIN(a,b) CP_JOIN_INNER(a,b)
#include "Upstream/DCMIPPNamespace.h"
#include "DCMIPPInternal.h"
#undef USE_HAL_DCMIPP_REGISTER_CALLBACKS
#define USE_HAL_DCMIPP_REGISTER_CALLBACKS CP_MODE
#define assert_param(expression) ((void)0)
#define UNUSED(x) ((void)(x))
#define READ_REG(reg) (reg)
#define WRITE_REG(reg,value) ((reg)=(value))
#define SET_BIT(reg,mask) ((reg)|=(mask))
#define CLEAR_BIT(reg,mask) ((reg)&=~(mask))
#define MODIFY_REG(reg,clear,set) ((reg)=((reg)&~(clear))|(set))
#define HAL_GetTick() CDCMIPP_Tick(CDCMIPP_Active)
#define DCMIPP_TIMEOUT 1000U
static void Pipe_Config(DCMIPP_HandleTypeDef *,uint32_t,const DCMIPP_PipeConfTypeDef *);
static void DCMIPP_SetConfig(DCMIPP_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
static void DCMIPP_SetDBMConfig(DCMIPP_HandleTypeDef *,uint32_t,uint32_t,uint32_t,uint32_t);
static void DCMIPP_EnableCapture(DCMIPP_HandleTypeDef *,uint32_t);
static HAL_StatusTypeDef DCMIPP_Stop(DCMIPP_HandleTypeDef *,uint32_t);
