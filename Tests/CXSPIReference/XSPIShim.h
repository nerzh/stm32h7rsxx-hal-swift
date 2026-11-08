#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#define HAL_XSPI_Init F_JOIN(F_VARIANT,_HAL_XSPI_Init)
#define HAL_XSPI_DeInit F_JOIN(F_VARIANT,_HAL_XSPI_DeInit)
#define HAL_XSPI_IRQHandler F_JOIN(F_VARIANT,_HAL_XSPI_IRQHandler)
#define HAL_XSPI_Command F_JOIN(F_VARIANT,_HAL_XSPI_Command)
#define HAL_XSPI_Command_IT F_JOIN(F_VARIANT,_HAL_XSPI_Command_IT)
#define HAL_XSPI_HyperbusCfg F_JOIN(F_VARIANT,_HAL_XSPI_HyperbusCfg)
#define HAL_XSPI_HyperbusCmd F_JOIN(F_VARIANT,_HAL_XSPI_HyperbusCmd)
#define HAL_XSPI_Transmit F_JOIN(F_VARIANT,_HAL_XSPI_Transmit)
#define HAL_XSPI_Receive F_JOIN(F_VARIANT,_HAL_XSPI_Receive)
#define HAL_XSPI_Transmit_IT F_JOIN(F_VARIANT,_HAL_XSPI_Transmit_IT)
#define HAL_XSPI_Receive_IT F_JOIN(F_VARIANT,_HAL_XSPI_Receive_IT)
#define HAL_XSPI_Transmit_DMA F_JOIN(F_VARIANT,_HAL_XSPI_Transmit_DMA)
#define HAL_XSPI_Receive_DMA F_JOIN(F_VARIANT,_HAL_XSPI_Receive_DMA)
#define HAL_XSPI_AutoPolling F_JOIN(F_VARIANT,_HAL_XSPI_AutoPolling)
#define HAL_XSPI_AutoPolling_IT F_JOIN(F_VARIANT,_HAL_XSPI_AutoPolling_IT)
#define HAL_XSPI_MemoryMapped F_JOIN(F_VARIANT,_HAL_XSPI_MemoryMapped)
#define HAL_XSPI_IsMemoryMapped F_JOIN(F_VARIANT,_HAL_XSPI_IsMemoryMapped)
#define HAL_XSPI_RegisterCallback F_JOIN(F_VARIANT,_HAL_XSPI_RegisterCallback)
#define HAL_XSPI_UnRegisterCallback F_JOIN(F_VARIANT,_HAL_XSPI_UnRegisterCallback)
#define HAL_XSPI_Abort F_JOIN(F_VARIANT,_HAL_XSPI_Abort)
#define HAL_XSPI_Abort_IT F_JOIN(F_VARIANT,_HAL_XSPI_Abort_IT)
#define HAL_XSPI_SetFifoThreshold F_JOIN(F_VARIANT,_HAL_XSPI_SetFifoThreshold)
#define HAL_XSPI_GetFifoThreshold F_JOIN(F_VARIANT,_HAL_XSPI_GetFifoThreshold)
#define HAL_XSPI_SetMemoryType F_JOIN(F_VARIANT,_HAL_XSPI_SetMemoryType)
#define HAL_XSPI_SetDeviceSize F_JOIN(F_VARIANT,_HAL_XSPI_SetDeviceSize)
#define HAL_XSPI_SetClockPrescaler F_JOIN(F_VARIANT,_HAL_XSPI_SetClockPrescaler)
#define HAL_XSPI_SetTimeout F_JOIN(F_VARIANT,_HAL_XSPI_SetTimeout)
#define HAL_XSPI_GetError F_JOIN(F_VARIANT,_HAL_XSPI_GetError)
#define HAL_XSPI_GetState F_JOIN(F_VARIANT,_HAL_XSPI_GetState)
#define HAL_XSPIM_Config F_JOIN(F_VARIANT,_HAL_XSPIM_Config)
#define HAL_XSPI_GetDelayValue F_JOIN(F_VARIANT,_HAL_XSPI_GetDelayValue)
#define HAL_XSPI_SetDelayValue F_JOIN(F_VARIANT,_HAL_XSPI_SetDelayValue)
#define XSPI_DMACplt F_JOIN(F_VARIANT,_XSPI_DMACplt)
#define XSPI_DMAHalfCplt F_JOIN(F_VARIANT,_XSPI_DMAHalfCplt)
#define XSPI_DMAError F_JOIN(F_VARIANT,_XSPI_DMAError)
#define XSPI_DMAAbortCplt F_JOIN(F_VARIANT,_XSPI_DMAAbortCplt)
#define XSPI_WaitFlagStateUntilTimeout F_JOIN(F_VARIANT,_XSPI_WaitFlagStateUntilTimeout)
#define XSPI_ConfigCmd F_JOIN(F_VARIANT,_XSPI_ConfigCmd)
#define XSPIM_GetConfig F_JOIN(F_VARIANT,_XSPIM_GetConfig)
#include "XSPIInternal.h"
#undef USE_HAL_XSPI_REGISTER_CALLBACKS
#define USE_HAL_XSPI_REGISTER_CALLBACKS F_MODE
#define assert_param(x) ((void)0)
#define READ_REG(r) (r)
#define WRITE_REG(r,v) ((r)=(v))
#define READ_BIT(r,m) ((r)&(m))
#define SET_BIT(r,m) ((r)|=(m))
#define CLEAR_BIT(r,m) ((r)&=~(m))
#define MODIFY_REG(r,c,s) WRITE_REG(r,(READ_REG(r)&~(c))|(s))
#define HAL_IS_BIT_SET(r,m) (((r)&(m))==(m))
#define HAL_IS_BIT_CLR(r,m) (((r)&(m))==0U)
#define UNUSED(x) ((void)(x))
#define CLEAR_REG(r) ((r)=0U)
#define HAL_GetTick CXSPI_Tick
#define HAL_RCCEx_GetPeriphCLKFreq CXSPI_Clock
#define SystemCoreClock (CXSPI_Active->control[6])
#define HAL_DMA_Start_IT CXSPI_DMAStart
#define HAL_DMAEx_List_Start_IT CXSPI_DMAList
#define HAL_DMA_Abort CXSPI_DMAAbort
#define HAL_DMA_Abort_IT CXSPI_DMAAbortIT
#undef XSPI1
#define XSPI1 (&CXSPI_Active->regs[0])
#undef XSPI2
#define XSPI2 (&CXSPI_Active->regs[1])
#undef XSPIM
#define XSPIM ((XSPIM_TypeDef *)&CXSPI_Active->global[0])
#define IS_XSPI_ALL_INSTANCE(i) (((i)==XSPI1)||((i)==XSPI2))
#undef READ_REG
#undef WRITE_REG
#undef READ_BIT
#undef SET_BIT
#undef CLEAR_BIT
#undef MODIFY_REG
#undef CLEAR_REG
#define READ_REG(r) CXSPI_ReadAddress(&(r),4)
#define WRITE_REG(r,v) CXSPI_WriteAddress(&(r),4,(v))
#define READ_BIT(r,m) (READ_REG(r)&(m))
#define SET_BIT(r,m) WRITE_REG(r,READ_REG(r)|(m))
#define CLEAR_BIT(r,m) WRITE_REG(r,READ_REG(r)&~(m))
#define MODIFY_REG(r,c,s) WRITE_REG(r,(READ_REG(r)&~(c))|(s))
#define CLEAR_REG(r) WRITE_REG(r,0U)
