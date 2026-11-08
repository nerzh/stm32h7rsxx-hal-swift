#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#define HAL_SPI_Init F_JOIN(F_VARIANT,_HAL_SPI_Init)
#define HAL_SPI_DeInit F_JOIN(F_VARIANT,_HAL_SPI_DeInit)
#define HAL_SPI_RegisterCallback F_JOIN(F_VARIANT,_HAL_SPI_RegisterCallback)
#define HAL_SPI_UnRegisterCallback F_JOIN(F_VARIANT,_HAL_SPI_UnRegisterCallback)
#define HAL_SPI_Transmit F_JOIN(F_VARIANT,_HAL_SPI_Transmit)
#define HAL_SPI_Receive F_JOIN(F_VARIANT,_HAL_SPI_Receive)
#define HAL_SPI_TransmitReceive F_JOIN(F_VARIANT,_HAL_SPI_TransmitReceive)
#define HAL_SPI_Transmit_IT F_JOIN(F_VARIANT,_HAL_SPI_Transmit_IT)
#define HAL_SPI_Receive_IT F_JOIN(F_VARIANT,_HAL_SPI_Receive_IT)
#define HAL_SPI_TransmitReceive_IT F_JOIN(F_VARIANT,_HAL_SPI_TransmitReceive_IT)
#define HAL_SPI_Transmit_DMA F_JOIN(F_VARIANT,_HAL_SPI_Transmit_DMA)
#define HAL_SPI_Receive_DMA F_JOIN(F_VARIANT,_HAL_SPI_Receive_DMA)
#define HAL_SPI_TransmitReceive_DMA F_JOIN(F_VARIANT,_HAL_SPI_TransmitReceive_DMA)
#define HAL_SPI_Abort F_JOIN(F_VARIANT,_HAL_SPI_Abort)
#define HAL_SPI_Abort_IT F_JOIN(F_VARIANT,_HAL_SPI_Abort_IT)
#define HAL_SPI_DMAPause F_JOIN(F_VARIANT,_HAL_SPI_DMAPause)
#define HAL_SPI_DMAResume F_JOIN(F_VARIANT,_HAL_SPI_DMAResume)
#define HAL_SPI_DMAStop F_JOIN(F_VARIANT,_HAL_SPI_DMAStop)
#define HAL_SPI_IRQHandler F_JOIN(F_VARIANT,_HAL_SPI_IRQHandler)
#define HAL_SPI_GetState F_JOIN(F_VARIANT,_HAL_SPI_GetState)
#define HAL_SPI_GetError F_JOIN(F_VARIANT,_HAL_SPI_GetError)
#define SPI_DMATransmitCplt F_JOIN(F_VARIANT,_SPI_DMATransmitCplt)
#define SPI_DMAReceiveCplt F_JOIN(F_VARIANT,_SPI_DMAReceiveCplt)
#define SPI_DMATransmitReceiveCplt F_JOIN(F_VARIANT,_SPI_DMATransmitReceiveCplt)
#define SPI_DMAHalfTransmitCplt F_JOIN(F_VARIANT,_SPI_DMAHalfTransmitCplt)
#define SPI_DMAHalfReceiveCplt F_JOIN(F_VARIANT,_SPI_DMAHalfReceiveCplt)
#define SPI_DMAHalfTransmitReceiveCplt F_JOIN(F_VARIANT,_SPI_DMAHalfTransmitReceiveCplt)
#define SPI_DMAError F_JOIN(F_VARIANT,_SPI_DMAError)
#define SPI_DMAAbortOnError F_JOIN(F_VARIANT,_SPI_DMAAbortOnError)
#define SPI_DMATxAbortCallback F_JOIN(F_VARIANT,_SPI_DMATxAbortCallback)
#define SPI_DMARxAbortCallback F_JOIN(F_VARIANT,_SPI_DMARxAbortCallback)
#define SPI_RxISR_8BIT F_JOIN(F_VARIANT,_SPI_RxISR_8BIT)
#define SPI_RxISR_16BIT F_JOIN(F_VARIANT,_SPI_RxISR_16BIT)
#define SPI_RxISR_32BIT F_JOIN(F_VARIANT,_SPI_RxISR_32BIT)
#define SPI_TxISR_8BIT F_JOIN(F_VARIANT,_SPI_TxISR_8BIT)
#define SPI_TxISR_16BIT F_JOIN(F_VARIANT,_SPI_TxISR_16BIT)
#define SPI_TxISR_32BIT F_JOIN(F_VARIANT,_SPI_TxISR_32BIT)
#define SPI_AbortTransfer F_JOIN(F_VARIANT,_SPI_AbortTransfer)
#define SPI_CloseTransfer F_JOIN(F_VARIANT,_SPI_CloseTransfer)
#define SPI_WaitOnFlagUntilTimeout F_JOIN(F_VARIANT,_SPI_WaitOnFlagUntilTimeout)
#define SPI_GetPacketSize F_JOIN(F_VARIANT,_SPI_GetPacketSize)
#define HAL_SPIEx_FlushRxFifo F_JOIN(F_VARIANT,_HAL_SPIEx_FlushRxFifo)
#define HAL_SPIEx_EnableLockConfiguration F_JOIN(F_VARIANT,_HAL_SPIEx_EnableLockConfiguration)
#define HAL_SPIEx_ConfigureUnderrun F_JOIN(F_VARIANT,_HAL_SPIEx_ConfigureUnderrun)
#include "SPIInternal.h"
#undef USE_HAL_SPI_REGISTER_CALLBACKS
#define USE_HAL_SPI_REGISTER_CALLBACKS F_MODE
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
#define HAL_GetTick CSPI_Tick
#define HAL_RCCEx_GetPeriphCLKFreq CSPI_Clock
#define SystemCoreClock (CSPI_Active->control[6])
#define HAL_DMA_Start_IT CSPI_DMAStart
#define HAL_DMAEx_List_Start_IT CSPI_DMAList
#define HAL_DMA_Abort CSPI_DMAAbort
#define HAL_DMA_Abort_IT CSPI_DMAAbortIT
#undef SPI1
#define SPI1 (&CSPI_Active->regs[0])
#undef SPI2
#define SPI2 (&CSPI_Active->regs[1])
#undef SPI3
#define SPI3 (&CSPI_Active->regs[2])
#undef SPI4
#define SPI4 (&CSPI_Active->regs[3])
#undef SPI5
#define SPI5 (&CSPI_Active->regs[4])
#undef SPI6
#define SPI6 (&CSPI_Active->regs[5])
#undef USE_SPI_CRC
#define USE_SPI_CRC F_CRC
#define HAL_DMA_GetError(h) ((h)->ErrorCode)
#define IS_SPI_FULL_INSTANCE(INSTANCE) (((INSTANCE) == SPI1) || \
                                        ((INSTANCE) == SPI2) || \
                                        ((INSTANCE) == SPI3) || \
                                        ((INSTANCE) == SPI6))
#define IS_SPI_LIMITED_INSTANCE(INSTANCE) (((INSTANCE) == SPI4) || \
                                           ((INSTANCE) == SPI5))
#undef READ_REG
#undef WRITE_REG
#undef READ_BIT
#undef SET_BIT
#undef CLEAR_BIT
#undef MODIFY_REG
#define READ_REG(r) CSPI_ReadAddress(&(r),4)
#define WRITE_REG(r,v) CSPI_WriteAddress(&(r),4,(v))
#define READ_BIT(r,m) (READ_REG(r)&(m))
#define SET_BIT(r,m) WRITE_REG(r,READ_REG(r)|(m))
#define CLEAR_BIT(r,m) WRITE_REG(r,READ_REG(r)&~(m))
#define MODIFY_REG(r,c,s) WRITE_REG(r,(READ_REG(r)&~(c))|(s))
#undef __HAL_SPI_ENABLE_IT
#undef __HAL_SPI_DISABLE_IT
#undef __HAL_SPI_GET_FLAG
#undef __HAL_SPI_GET_IT_SOURCE
#define __HAL_SPI_ENABLE_IT(h,m) SET_BIT((h)->Instance->IER,m)
#define __HAL_SPI_DISABLE_IT(h,m) CLEAR_BIT((h)->Instance->IER,m)
#define __HAL_SPI_GET_FLAG(h,m) ((READ_REG((h)->Instance->SR)&(m))==(m))
#define __HAL_SPI_GET_IT_SOURCE(h,m) (((READ_REG((h)->Instance->IER)&(m))==(m))?SET:RESET)
