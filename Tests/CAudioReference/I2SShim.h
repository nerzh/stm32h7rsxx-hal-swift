#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#define HAL_I2S_Init F_JOIN(F_VARIANT,_HAL_I2S_Init)
#define HAL_I2S_DeInit F_JOIN(F_VARIANT,_HAL_I2S_DeInit)
#define HAL_I2S_RegisterCallback F_JOIN(F_VARIANT,_HAL_I2S_RegisterCallback)
#define HAL_I2S_UnRegisterCallback F_JOIN(F_VARIANT,_HAL_I2S_UnRegisterCallback)
#define HAL_I2S_Transmit F_JOIN(F_VARIANT,_HAL_I2S_Transmit)
#define HAL_I2S_Receive F_JOIN(F_VARIANT,_HAL_I2S_Receive)
#define HAL_I2SEx_TransmitReceive F_JOIN(F_VARIANT,_HAL_I2SEx_TransmitReceive)
#define HAL_I2S_Transmit_IT F_JOIN(F_VARIANT,_HAL_I2S_Transmit_IT)
#define HAL_I2S_Receive_IT F_JOIN(F_VARIANT,_HAL_I2S_Receive_IT)
#define HAL_I2SEx_TransmitReceive_IT F_JOIN(F_VARIANT,_HAL_I2SEx_TransmitReceive_IT)
#define HAL_I2S_Transmit_DMA F_JOIN(F_VARIANT,_HAL_I2S_Transmit_DMA)
#define HAL_I2S_Receive_DMA F_JOIN(F_VARIANT,_HAL_I2S_Receive_DMA)
#define HAL_I2SEx_TransmitReceive_DMA F_JOIN(F_VARIANT,_HAL_I2SEx_TransmitReceive_DMA)
#define HAL_I2S_DMAPause F_JOIN(F_VARIANT,_HAL_I2S_DMAPause)
#define HAL_I2S_DMAResume F_JOIN(F_VARIANT,_HAL_I2S_DMAResume)
#define HAL_I2S_DMAStop F_JOIN(F_VARIANT,_HAL_I2S_DMAStop)
#define HAL_I2S_EnableIOSwap F_JOIN(F_VARIANT,_HAL_I2S_EnableIOSwap)
#define HAL_I2S_DisableIOSwap F_JOIN(F_VARIANT,_HAL_I2S_DisableIOSwap)
#define HAL_I2S_IsEnabledIOSwap F_JOIN(F_VARIANT,_HAL_I2S_IsEnabledIOSwap)
#define HAL_I2S_IRQHandler F_JOIN(F_VARIANT,_HAL_I2S_IRQHandler)
#define HAL_I2S_GetState F_JOIN(F_VARIANT,_HAL_I2S_GetState)
#define HAL_I2S_GetError F_JOIN(F_VARIANT,_HAL_I2S_GetError)
#define I2S_DMATxCplt F_JOIN(F_VARIANT,_I2S_DMATxCplt)
#define I2S_DMATxHalfCplt F_JOIN(F_VARIANT,_I2S_DMATxHalfCplt)
#define I2S_DMARxCplt F_JOIN(F_VARIANT,_I2S_DMARxCplt)
#define I2S_DMARxHalfCplt F_JOIN(F_VARIANT,_I2S_DMARxHalfCplt)
#define I2SEx_DMATxRxCplt F_JOIN(F_VARIANT,_I2SEx_DMATxRxCplt)
#define I2SEx_DMATxRxHalfCplt F_JOIN(F_VARIANT,_I2SEx_DMATxRxHalfCplt)
#define I2S_DMAError F_JOIN(F_VARIANT,_I2S_DMAError)
#define I2S_Transmit_16Bit_IT F_JOIN(F_VARIANT,_I2S_Transmit_16Bit_IT)
#define I2S_Transmit_32Bit_IT F_JOIN(F_VARIANT,_I2S_Transmit_32Bit_IT)
#define I2S_Receive_16Bit_IT F_JOIN(F_VARIANT,_I2S_Receive_16Bit_IT)
#define I2S_Receive_32Bit_IT F_JOIN(F_VARIANT,_I2S_Receive_32Bit_IT)
#define I2S_WaitFlagStateUntilTimeout F_JOIN(F_VARIANT,_I2S_WaitFlagStateUntilTimeout)
#include "I2SInternal.h"
#undef USE_HAL_I2S_REGISTER_CALLBACKS
#define USE_HAL_I2S_REGISTER_CALLBACKS F_MODE
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
#define HAL_GetTick CI2S_Tick
#define HAL_RCCEx_GetPeriphCLKFreq CI2S_Clock
#define SystemCoreClock (CI2S_Active->control[6])
#define HAL_DMA_Start_IT CI2S_DMAStart
#define HAL_DMAEx_List_Start_IT CI2S_DMAList
#define HAL_DMA_Abort CI2S_DMAAbort
#define HAL_DMA_Abort_IT CI2S_DMAAbortIT
#undef SPI1
#define SPI1 (&CI2S_Active->regs[0])
#undef SPI2
#define SPI2 (&CI2S_Active->regs[1])
#undef SPI3
#define SPI3 (&CI2S_Active->regs[2])
#undef SPI6
#define SPI6 (&CI2S_Active->regs[3])
