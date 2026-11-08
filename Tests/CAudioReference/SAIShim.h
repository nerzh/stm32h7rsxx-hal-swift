#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#define HAL_SAI_InitProtocol F_JOIN(F_VARIANT,_HAL_SAI_InitProtocol)
#define HAL_SAI_Init F_JOIN(F_VARIANT,_HAL_SAI_Init)
#define HAL_SAI_DeInit F_JOIN(F_VARIANT,_HAL_SAI_DeInit)
#define HAL_SAI_RegisterCallback F_JOIN(F_VARIANT,_HAL_SAI_RegisterCallback)
#define HAL_SAI_UnRegisterCallback F_JOIN(F_VARIANT,_HAL_SAI_UnRegisterCallback)
#define HAL_SAI_Transmit F_JOIN(F_VARIANT,_HAL_SAI_Transmit)
#define HAL_SAI_Receive F_JOIN(F_VARIANT,_HAL_SAI_Receive)
#define HAL_SAI_Transmit_IT F_JOIN(F_VARIANT,_HAL_SAI_Transmit_IT)
#define HAL_SAI_Receive_IT F_JOIN(F_VARIANT,_HAL_SAI_Receive_IT)
#define HAL_SAI_DMAPause F_JOIN(F_VARIANT,_HAL_SAI_DMAPause)
#define HAL_SAI_DMAResume F_JOIN(F_VARIANT,_HAL_SAI_DMAResume)
#define HAL_SAI_DMAStop F_JOIN(F_VARIANT,_HAL_SAI_DMAStop)
#define HAL_SAI_Abort F_JOIN(F_VARIANT,_HAL_SAI_Abort)
#define HAL_SAI_Transmit_DMA F_JOIN(F_VARIANT,_HAL_SAI_Transmit_DMA)
#define HAL_SAI_Receive_DMA F_JOIN(F_VARIANT,_HAL_SAI_Receive_DMA)
#define HAL_SAI_EnableTxMuteMode F_JOIN(F_VARIANT,_HAL_SAI_EnableTxMuteMode)
#define HAL_SAI_DisableTxMuteMode F_JOIN(F_VARIANT,_HAL_SAI_DisableTxMuteMode)
#define HAL_SAI_EnableRxMuteMode F_JOIN(F_VARIANT,_HAL_SAI_EnableRxMuteMode)
#define HAL_SAI_DisableRxMuteMode F_JOIN(F_VARIANT,_HAL_SAI_DisableRxMuteMode)
#define HAL_SAI_IRQHandler F_JOIN(F_VARIANT,_HAL_SAI_IRQHandler)
#define HAL_SAI_GetState F_JOIN(F_VARIANT,_HAL_SAI_GetState)
#define HAL_SAI_GetError F_JOIN(F_VARIANT,_HAL_SAI_GetError)
#define SAI_InitI2S F_JOIN(F_VARIANT,_SAI_InitI2S)
#define SAI_InitPCM F_JOIN(F_VARIANT,_SAI_InitPCM)
#define SAI_FillFifo F_JOIN(F_VARIANT,_SAI_FillFifo)
#define SAI_InterruptFlag F_JOIN(F_VARIANT,_SAI_InterruptFlag)
#define SAI_Disable F_JOIN(F_VARIANT,_SAI_Disable)
#define SAI_Transmit_IT8Bit F_JOIN(F_VARIANT,_SAI_Transmit_IT8Bit)
#define SAI_Transmit_IT16Bit F_JOIN(F_VARIANT,_SAI_Transmit_IT16Bit)
#define SAI_Transmit_IT32Bit F_JOIN(F_VARIANT,_SAI_Transmit_IT32Bit)
#define SAI_Receive_IT8Bit F_JOIN(F_VARIANT,_SAI_Receive_IT8Bit)
#define SAI_Receive_IT16Bit F_JOIN(F_VARIANT,_SAI_Receive_IT16Bit)
#define SAI_Receive_IT32Bit F_JOIN(F_VARIANT,_SAI_Receive_IT32Bit)
#define SAI_DMATxCplt F_JOIN(F_VARIANT,_SAI_DMATxCplt)
#define SAI_DMATxHalfCplt F_JOIN(F_VARIANT,_SAI_DMATxHalfCplt)
#define SAI_DMARxCplt F_JOIN(F_VARIANT,_SAI_DMARxCplt)
#define SAI_DMARxHalfCplt F_JOIN(F_VARIANT,_SAI_DMARxHalfCplt)
#define SAI_DMAError F_JOIN(F_VARIANT,_SAI_DMAError)
#define SAI_DMAAbort F_JOIN(F_VARIANT,_SAI_DMAAbort)
#define HAL_SAIEx_ConfigPdmMicDelay F_JOIN(F_VARIANT,_HAL_SAIEx_ConfigPdmMicDelay)
#include "SAIInternal.h"
#undef USE_HAL_SAI_REGISTER_CALLBACKS
#define USE_HAL_SAI_REGISTER_CALLBACKS F_MODE
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
#define HAL_GetTick CSAI_Tick
#define HAL_RCCEx_GetPeriphCLKFreq CSAI_Clock
#define SystemCoreClock (CSAI_Active->control[6])
#define HAL_DMA_Start_IT CSAI_DMAStart
#define HAL_DMAEx_List_Start_IT CSAI_DMAList
#define HAL_DMA_Abort CSAI_DMAAbort
#define HAL_DMA_Abort_IT CSAI_DMAAbortIT
#undef SAI1_Block_A
#define SAI1_Block_A (&CSAI_Active->regs[0])
#undef SAI1_Block_B
#define SAI1_Block_B (&CSAI_Active->regs[1])
#undef SAI2_Block_A
#define SAI2_Block_A (&CSAI_Active->regs[2])
#undef SAI2_Block_B
#define SAI2_Block_B (&CSAI_Active->regs[3])
#undef SAI1
#define SAI1 (&CSAI_Active->global[0])
#undef SAI2
#define SAI2 (&CSAI_Active->global[1])
