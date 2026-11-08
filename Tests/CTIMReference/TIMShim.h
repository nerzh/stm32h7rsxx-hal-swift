#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#define HAL_TIM_Base_Init F_JOIN(F_VARIANT,_HAL_TIM_Base_Init)
#define HAL_TIM_Base_DeInit F_JOIN(F_VARIANT,_HAL_TIM_Base_DeInit)
#define HAL_TIM_Base_Start F_JOIN(F_VARIANT,_HAL_TIM_Base_Start)
#define HAL_TIM_Base_Stop F_JOIN(F_VARIANT,_HAL_TIM_Base_Stop)
#define HAL_TIM_Base_Start_IT F_JOIN(F_VARIANT,_HAL_TIM_Base_Start_IT)
#define HAL_TIM_Base_Stop_IT F_JOIN(F_VARIANT,_HAL_TIM_Base_Stop_IT)
#define HAL_TIM_Base_Start_DMA F_JOIN(F_VARIANT,_HAL_TIM_Base_Start_DMA)
#define HAL_TIM_Base_Stop_DMA F_JOIN(F_VARIANT,_HAL_TIM_Base_Stop_DMA)
#define HAL_TIM_OC_Init F_JOIN(F_VARIANT,_HAL_TIM_OC_Init)
#define HAL_TIM_OC_DeInit F_JOIN(F_VARIANT,_HAL_TIM_OC_DeInit)
#define HAL_TIM_OC_Start F_JOIN(F_VARIANT,_HAL_TIM_OC_Start)
#define HAL_TIM_OC_Stop F_JOIN(F_VARIANT,_HAL_TIM_OC_Stop)
#define HAL_TIM_OC_Start_IT F_JOIN(F_VARIANT,_HAL_TIM_OC_Start_IT)
#define HAL_TIM_OC_Stop_IT F_JOIN(F_VARIANT,_HAL_TIM_OC_Stop_IT)
#define HAL_TIM_OC_Start_DMA F_JOIN(F_VARIANT,_HAL_TIM_OC_Start_DMA)
#define HAL_TIM_OC_Stop_DMA F_JOIN(F_VARIANT,_HAL_TIM_OC_Stop_DMA)
#define HAL_TIM_PWM_Init F_JOIN(F_VARIANT,_HAL_TIM_PWM_Init)
#define HAL_TIM_PWM_DeInit F_JOIN(F_VARIANT,_HAL_TIM_PWM_DeInit)
#define HAL_TIM_PWM_Start F_JOIN(F_VARIANT,_HAL_TIM_PWM_Start)
#define HAL_TIM_PWM_Stop F_JOIN(F_VARIANT,_HAL_TIM_PWM_Stop)
#define HAL_TIM_PWM_Start_IT F_JOIN(F_VARIANT,_HAL_TIM_PWM_Start_IT)
#define HAL_TIM_PWM_Stop_IT F_JOIN(F_VARIANT,_HAL_TIM_PWM_Stop_IT)
#define HAL_TIM_PWM_Start_DMA F_JOIN(F_VARIANT,_HAL_TIM_PWM_Start_DMA)
#define HAL_TIM_PWM_Stop_DMA F_JOIN(F_VARIANT,_HAL_TIM_PWM_Stop_DMA)
#define HAL_TIM_IC_Init F_JOIN(F_VARIANT,_HAL_TIM_IC_Init)
#define HAL_TIM_IC_DeInit F_JOIN(F_VARIANT,_HAL_TIM_IC_DeInit)
#define HAL_TIM_IC_Start F_JOIN(F_VARIANT,_HAL_TIM_IC_Start)
#define HAL_TIM_IC_Stop F_JOIN(F_VARIANT,_HAL_TIM_IC_Stop)
#define HAL_TIM_IC_Start_IT F_JOIN(F_VARIANT,_HAL_TIM_IC_Start_IT)
#define HAL_TIM_IC_Stop_IT F_JOIN(F_VARIANT,_HAL_TIM_IC_Stop_IT)
#define HAL_TIM_IC_Start_DMA F_JOIN(F_VARIANT,_HAL_TIM_IC_Start_DMA)
#define HAL_TIM_IC_Stop_DMA F_JOIN(F_VARIANT,_HAL_TIM_IC_Stop_DMA)
#define HAL_TIM_OnePulse_Init F_JOIN(F_VARIANT,_HAL_TIM_OnePulse_Init)
#define HAL_TIM_OnePulse_DeInit F_JOIN(F_VARIANT,_HAL_TIM_OnePulse_DeInit)
#define HAL_TIM_OnePulse_Start F_JOIN(F_VARIANT,_HAL_TIM_OnePulse_Start)
#define HAL_TIM_OnePulse_Stop F_JOIN(F_VARIANT,_HAL_TIM_OnePulse_Stop)
#define HAL_TIM_OnePulse_Start_IT F_JOIN(F_VARIANT,_HAL_TIM_OnePulse_Start_IT)
#define HAL_TIM_OnePulse_Stop_IT F_JOIN(F_VARIANT,_HAL_TIM_OnePulse_Stop_IT)
#define HAL_TIM_Encoder_Init F_JOIN(F_VARIANT,_HAL_TIM_Encoder_Init)
#define HAL_TIM_Encoder_DeInit F_JOIN(F_VARIANT,_HAL_TIM_Encoder_DeInit)
#define HAL_TIM_Encoder_Start F_JOIN(F_VARIANT,_HAL_TIM_Encoder_Start)
#define HAL_TIM_Encoder_Stop F_JOIN(F_VARIANT,_HAL_TIM_Encoder_Stop)
#define HAL_TIM_Encoder_Start_IT F_JOIN(F_VARIANT,_HAL_TIM_Encoder_Start_IT)
#define HAL_TIM_Encoder_Stop_IT F_JOIN(F_VARIANT,_HAL_TIM_Encoder_Stop_IT)
#define HAL_TIM_Encoder_Start_DMA F_JOIN(F_VARIANT,_HAL_TIM_Encoder_Start_DMA)
#define HAL_TIM_Encoder_Stop_DMA F_JOIN(F_VARIANT,_HAL_TIM_Encoder_Stop_DMA)
#define HAL_TIM_IRQHandler F_JOIN(F_VARIANT,_HAL_TIM_IRQHandler)
#define HAL_TIM_OC_ConfigChannel F_JOIN(F_VARIANT,_HAL_TIM_OC_ConfigChannel)
#define HAL_TIM_IC_ConfigChannel F_JOIN(F_VARIANT,_HAL_TIM_IC_ConfigChannel)
#define HAL_TIM_PWM_ConfigChannel F_JOIN(F_VARIANT,_HAL_TIM_PWM_ConfigChannel)
#define HAL_TIM_OnePulse_ConfigChannel F_JOIN(F_VARIANT,_HAL_TIM_OnePulse_ConfigChannel)
#define HAL_TIM_DMABurst_WriteStart F_JOIN(F_VARIANT,_HAL_TIM_DMABurst_WriteStart)
#define HAL_TIM_DMABurst_MultiWriteStart F_JOIN(F_VARIANT,_HAL_TIM_DMABurst_MultiWriteStart)
#define HAL_TIM_DMABurst_WriteStop F_JOIN(F_VARIANT,_HAL_TIM_DMABurst_WriteStop)
#define HAL_TIM_DMABurst_ReadStart F_JOIN(F_VARIANT,_HAL_TIM_DMABurst_ReadStart)
#define HAL_TIM_DMABurst_MultiReadStart F_JOIN(F_VARIANT,_HAL_TIM_DMABurst_MultiReadStart)
#define HAL_TIM_DMABurst_ReadStop F_JOIN(F_VARIANT,_HAL_TIM_DMABurst_ReadStop)
#define HAL_TIM_GenerateEvent F_JOIN(F_VARIANT,_HAL_TIM_GenerateEvent)
#define HAL_TIM_ConfigOCrefClear F_JOIN(F_VARIANT,_HAL_TIM_ConfigOCrefClear)
#define HAL_TIM_ConfigClockSource F_JOIN(F_VARIANT,_HAL_TIM_ConfigClockSource)
#define HAL_TIM_ConfigTI1Input F_JOIN(F_VARIANT,_HAL_TIM_ConfigTI1Input)
#define HAL_TIM_SlaveConfigSynchro F_JOIN(F_VARIANT,_HAL_TIM_SlaveConfigSynchro)
#define HAL_TIM_SlaveConfigSynchro_IT F_JOIN(F_VARIANT,_HAL_TIM_SlaveConfigSynchro_IT)
#define HAL_TIM_ReadCapturedValue F_JOIN(F_VARIANT,_HAL_TIM_ReadCapturedValue)
#define TIM_DMA_Start_IT F_JOIN(F_VARIANT,_TIM_DMA_Start_IT)
#define HAL_TIM_RegisterCallback F_JOIN(F_VARIANT,_HAL_TIM_RegisterCallback)
#define HAL_TIM_UnRegisterCallback F_JOIN(F_VARIANT,_HAL_TIM_UnRegisterCallback)
#define HAL_TIM_Base_GetState F_JOIN(F_VARIANT,_HAL_TIM_Base_GetState)
#define HAL_TIM_OC_GetState F_JOIN(F_VARIANT,_HAL_TIM_OC_GetState)
#define HAL_TIM_PWM_GetState F_JOIN(F_VARIANT,_HAL_TIM_PWM_GetState)
#define HAL_TIM_IC_GetState F_JOIN(F_VARIANT,_HAL_TIM_IC_GetState)
#define HAL_TIM_OnePulse_GetState F_JOIN(F_VARIANT,_HAL_TIM_OnePulse_GetState)
#define HAL_TIM_Encoder_GetState F_JOIN(F_VARIANT,_HAL_TIM_Encoder_GetState)
#define HAL_TIM_GetActiveChannel F_JOIN(F_VARIANT,_HAL_TIM_GetActiveChannel)
#define HAL_TIM_GetChannelState F_JOIN(F_VARIANT,_HAL_TIM_GetChannelState)
#define HAL_TIM_DMABurstState F_JOIN(F_VARIANT,_HAL_TIM_DMABurstState)
#define TIM_DMAError F_JOIN(F_VARIANT,_TIM_DMAError)
#define TIM_DMADelayPulseCplt F_JOIN(F_VARIANT,_TIM_DMADelayPulseCplt)
#define TIM_DMADelayPulseHalfCplt F_JOIN(F_VARIANT,_TIM_DMADelayPulseHalfCplt)
#define TIM_DMACaptureCplt F_JOIN(F_VARIANT,_TIM_DMACaptureCplt)
#define TIM_DMACaptureHalfCplt F_JOIN(F_VARIANT,_TIM_DMACaptureHalfCplt)
#define TIM_DMAPeriodElapsedCplt F_JOIN(F_VARIANT,_TIM_DMAPeriodElapsedCplt)
#define TIM_DMAPeriodElapsedHalfCplt F_JOIN(F_VARIANT,_TIM_DMAPeriodElapsedHalfCplt)
#define TIM_DMATriggerCplt F_JOIN(F_VARIANT,_TIM_DMATriggerCplt)
#define TIM_DMATriggerHalfCplt F_JOIN(F_VARIANT,_TIM_DMATriggerHalfCplt)
#define TIM_Base_SetConfig F_JOIN(F_VARIANT,_TIM_Base_SetConfig)
#define TIM_OC1_SetConfig F_JOIN(F_VARIANT,_TIM_OC1_SetConfig)
#define TIM_OC2_SetConfig F_JOIN(F_VARIANT,_TIM_OC2_SetConfig)
#define TIM_OC3_SetConfig F_JOIN(F_VARIANT,_TIM_OC3_SetConfig)
#define TIM_OC4_SetConfig F_JOIN(F_VARIANT,_TIM_OC4_SetConfig)
#define TIM_OC5_SetConfig F_JOIN(F_VARIANT,_TIM_OC5_SetConfig)
#define TIM_OC6_SetConfig F_JOIN(F_VARIANT,_TIM_OC6_SetConfig)
#define TIM_SlaveTimer_SetConfig F_JOIN(F_VARIANT,_TIM_SlaveTimer_SetConfig)
#define TIM_TI1_SetConfig F_JOIN(F_VARIANT,_TIM_TI1_SetConfig)
#define TIM_TI1_ConfigInputStage F_JOIN(F_VARIANT,_TIM_TI1_ConfigInputStage)
#define TIM_TI2_SetConfig F_JOIN(F_VARIANT,_TIM_TI2_SetConfig)
#define TIM_TI2_ConfigInputStage F_JOIN(F_VARIANT,_TIM_TI2_ConfigInputStage)
#define TIM_TI3_SetConfig F_JOIN(F_VARIANT,_TIM_TI3_SetConfig)
#define TIM_TI4_SetConfig F_JOIN(F_VARIANT,_TIM_TI4_SetConfig)
#define TIM_ITRx_SetConfig F_JOIN(F_VARIANT,_TIM_ITRx_SetConfig)
#define TIM_ETR_SetConfig F_JOIN(F_VARIANT,_TIM_ETR_SetConfig)
#define TIM_CCxChannelCmd F_JOIN(F_VARIANT,_TIM_CCxChannelCmd)
#define TIM_ResetCallback F_JOIN(F_VARIANT,_TIM_ResetCallback)
#define HAL_TIMEx_HallSensor_Init F_JOIN(F_VARIANT,_HAL_TIMEx_HallSensor_Init)
#define HAL_TIMEx_HallSensor_DeInit F_JOIN(F_VARIANT,_HAL_TIMEx_HallSensor_DeInit)
#define HAL_TIMEx_HallSensor_Start F_JOIN(F_VARIANT,_HAL_TIMEx_HallSensor_Start)
#define HAL_TIMEx_HallSensor_Stop F_JOIN(F_VARIANT,_HAL_TIMEx_HallSensor_Stop)
#define HAL_TIMEx_HallSensor_Start_IT F_JOIN(F_VARIANT,_HAL_TIMEx_HallSensor_Start_IT)
#define HAL_TIMEx_HallSensor_Stop_IT F_JOIN(F_VARIANT,_HAL_TIMEx_HallSensor_Stop_IT)
#define HAL_TIMEx_HallSensor_Start_DMA F_JOIN(F_VARIANT,_HAL_TIMEx_HallSensor_Start_DMA)
#define HAL_TIMEx_HallSensor_Stop_DMA F_JOIN(F_VARIANT,_HAL_TIMEx_HallSensor_Stop_DMA)
#define HAL_TIMEx_OCN_Start F_JOIN(F_VARIANT,_HAL_TIMEx_OCN_Start)
#define HAL_TIMEx_OCN_Stop F_JOIN(F_VARIANT,_HAL_TIMEx_OCN_Stop)
#define HAL_TIMEx_OCN_Start_IT F_JOIN(F_VARIANT,_HAL_TIMEx_OCN_Start_IT)
#define HAL_TIMEx_OCN_Stop_IT F_JOIN(F_VARIANT,_HAL_TIMEx_OCN_Stop_IT)
#define HAL_TIMEx_OCN_Start_DMA F_JOIN(F_VARIANT,_HAL_TIMEx_OCN_Start_DMA)
#define HAL_TIMEx_OCN_Stop_DMA F_JOIN(F_VARIANT,_HAL_TIMEx_OCN_Stop_DMA)
#define HAL_TIMEx_PWMN_Start F_JOIN(F_VARIANT,_HAL_TIMEx_PWMN_Start)
#define HAL_TIMEx_PWMN_Stop F_JOIN(F_VARIANT,_HAL_TIMEx_PWMN_Stop)
#define HAL_TIMEx_PWMN_Start_IT F_JOIN(F_VARIANT,_HAL_TIMEx_PWMN_Start_IT)
#define HAL_TIMEx_PWMN_Stop_IT F_JOIN(F_VARIANT,_HAL_TIMEx_PWMN_Stop_IT)
#define HAL_TIMEx_PWMN_Start_DMA F_JOIN(F_VARIANT,_HAL_TIMEx_PWMN_Start_DMA)
#define HAL_TIMEx_PWMN_Stop_DMA F_JOIN(F_VARIANT,_HAL_TIMEx_PWMN_Stop_DMA)
#define HAL_TIMEx_OnePulseN_Start F_JOIN(F_VARIANT,_HAL_TIMEx_OnePulseN_Start)
#define HAL_TIMEx_OnePulseN_Stop F_JOIN(F_VARIANT,_HAL_TIMEx_OnePulseN_Stop)
#define HAL_TIMEx_OnePulseN_Start_IT F_JOIN(F_VARIANT,_HAL_TIMEx_OnePulseN_Start_IT)
#define HAL_TIMEx_OnePulseN_Stop_IT F_JOIN(F_VARIANT,_HAL_TIMEx_OnePulseN_Stop_IT)
#define HAL_TIMEx_ConfigCommutEvent F_JOIN(F_VARIANT,_HAL_TIMEx_ConfigCommutEvent)
#define HAL_TIMEx_ConfigCommutEvent_IT F_JOIN(F_VARIANT,_HAL_TIMEx_ConfigCommutEvent_IT)
#define HAL_TIMEx_ConfigCommutEvent_DMA F_JOIN(F_VARIANT,_HAL_TIMEx_ConfigCommutEvent_DMA)
#define HAL_TIMEx_MasterConfigSynchronization F_JOIN(F_VARIANT,_HAL_TIMEx_MasterConfigSynchronization)
#define HAL_TIMEx_ConfigBreakDeadTime F_JOIN(F_VARIANT,_HAL_TIMEx_ConfigBreakDeadTime)
#define HAL_TIMEx_ConfigBreakInput F_JOIN(F_VARIANT,_HAL_TIMEx_ConfigBreakInput)
#define HAL_TIMEx_RemapConfig F_JOIN(F_VARIANT,_HAL_TIMEx_RemapConfig)
#define HAL_TIMEx_TISelection F_JOIN(F_VARIANT,_HAL_TIMEx_TISelection)
#define HAL_TIMEx_GroupChannel5 F_JOIN(F_VARIANT,_HAL_TIMEx_GroupChannel5)
#define HAL_TIMEx_DisarmBreakInput F_JOIN(F_VARIANT,_HAL_TIMEx_DisarmBreakInput)
#define HAL_TIMEx_ReArmBreakInput F_JOIN(F_VARIANT,_HAL_TIMEx_ReArmBreakInput)
#define HAL_TIMEx_DitheringEnable F_JOIN(F_VARIANT,_HAL_TIMEx_DitheringEnable)
#define HAL_TIMEx_DitheringDisable F_JOIN(F_VARIANT,_HAL_TIMEx_DitheringDisable)
#define HAL_TIMEx_OC_ConfigPulseOnCompare F_JOIN(F_VARIANT,_HAL_TIMEx_OC_ConfigPulseOnCompare)
#define HAL_TIMEx_ConfigSlaveModePreload F_JOIN(F_VARIANT,_HAL_TIMEx_ConfigSlaveModePreload)
#define HAL_TIMEx_EnableSlaveModePreload F_JOIN(F_VARIANT,_HAL_TIMEx_EnableSlaveModePreload)
#define HAL_TIMEx_DisableSlaveModePreload F_JOIN(F_VARIANT,_HAL_TIMEx_DisableSlaveModePreload)
#define HAL_TIMEx_EnableDeadTimePreload F_JOIN(F_VARIANT,_HAL_TIMEx_EnableDeadTimePreload)
#define HAL_TIMEx_DisableDeadTimePreload F_JOIN(F_VARIANT,_HAL_TIMEx_DisableDeadTimePreload)
#define HAL_TIMEx_ConfigDeadTime F_JOIN(F_VARIANT,_HAL_TIMEx_ConfigDeadTime)
#define HAL_TIMEx_ConfigAsymmetricalDeadTime F_JOIN(F_VARIANT,_HAL_TIMEx_ConfigAsymmetricalDeadTime)
#define HAL_TIMEx_EnableAsymmetricalDeadTime F_JOIN(F_VARIANT,_HAL_TIMEx_EnableAsymmetricalDeadTime)
#define HAL_TIMEx_DisableAsymmetricalDeadTime F_JOIN(F_VARIANT,_HAL_TIMEx_DisableAsymmetricalDeadTime)
#define HAL_TIMEx_ConfigEncoderIndex F_JOIN(F_VARIANT,_HAL_TIMEx_ConfigEncoderIndex)
#define HAL_TIMEx_EnableEncoderIndex F_JOIN(F_VARIANT,_HAL_TIMEx_EnableEncoderIndex)
#define HAL_TIMEx_DisableEncoderIndex F_JOIN(F_VARIANT,_HAL_TIMEx_DisableEncoderIndex)
#define HAL_TIMEx_EnableEncoderFirstIndex F_JOIN(F_VARIANT,_HAL_TIMEx_EnableEncoderFirstIndex)
#define HAL_TIMEx_DisableEncoderFirstIndex F_JOIN(F_VARIANT,_HAL_TIMEx_DisableEncoderFirstIndex)
#define HAL_TIMEx_HallSensor_GetState F_JOIN(F_VARIANT,_HAL_TIMEx_HallSensor_GetState)
#define HAL_TIMEx_GetChannelNState F_JOIN(F_VARIANT,_HAL_TIMEx_GetChannelNState)
#define TIMEx_DMACommutationCplt F_JOIN(F_VARIANT,_TIMEx_DMACommutationCplt)
#define TIMEx_DMACommutationHalfCplt F_JOIN(F_VARIANT,_TIMEx_DMACommutationHalfCplt)
#define TIM_DMADelayPulseNCplt F_JOIN(F_VARIANT,_TIM_DMADelayPulseNCplt)
#define TIM_DMAErrorCCxN F_JOIN(F_VARIANT,_TIM_DMAErrorCCxN)
#define TIM_CCxNChannelCmd F_JOIN(F_VARIANT,_TIM_CCxNChannelCmd)
#include "TIMInternal.h"
#undef USE_HAL_TIM_REGISTER_CALLBACKS
#define USE_HAL_TIM_REGISTER_CALLBACKS F_MODE
#define assert_param(x) ((void)0)
#define UNUSED(x) ((void)(x))
#define READ_REG(r) CTIM_ReadAddress(&(r))
#define WRITE_REG(r,v) CTIM_WriteAddress(&(r),(v))
#define READ_BIT(r,m) (READ_REG(r)&(m))
#define SET_BIT(r,m) WRITE_REG(r,READ_REG(r)|(m))
#define CLEAR_BIT(r,m) WRITE_REG(r,READ_REG(r)&~(m))
#define MODIFY_REG(r,c,s) WRITE_REG(r,(READ_REG(r)&~(c))|(s))
#define HAL_GetTick CTIM_Tick
#define HAL_DMA_Start_IT CTIM_DMAStart
#define HAL_DMAEx_List_Start_IT CTIM_DMAList
#define HAL_DMA_Abort_IT CTIM_DMAAbortIT
#undef TIM1
#define TIM1 (&CTIM_Active->regs[0])
#undef TIM2
#define TIM2 (&CTIM_Active->regs[1])
#undef TIM3
#define TIM3 (&CTIM_Active->regs[2])
#undef TIM4
#define TIM4 (&CTIM_Active->regs[3])
#undef TIM5
#define TIM5 (&CTIM_Active->regs[4])
#undef TIM6
#define TIM6 (&CTIM_Active->regs[5])
#undef TIM7
#define TIM7 (&CTIM_Active->regs[6])
#undef TIM9
#define TIM9 (&CTIM_Active->regs[7])
#undef TIM12
#define TIM12 (&CTIM_Active->regs[8])
#undef TIM13
#define TIM13 (&CTIM_Active->regs[9])
#undef TIM14
#define TIM14 (&CTIM_Active->regs[10])
#undef TIM15
#define TIM15 (&CTIM_Active->regs[11])
#undef TIM16
#define TIM16 (&CTIM_Active->regs[12])
#undef TIM17
#define TIM17 (&CTIM_Active->regs[13])
#include "Upstream/TIMCapabilities.h"
#undef __HAL_TIM_ENABLE
#define __HAL_TIM_ENABLE(__HANDLE__) SET_BIT((__HANDLE__)->Instance->CR1,TIM_CR1_CEN)
#undef __HAL_TIM_DISABLE
#define __HAL_TIM_DISABLE(__HANDLE__)    do {      if ((CTIM_ReadAddress(&(__HANDLE__)->Instance->CCER) & TIM_CCER_CCxE_MASK) == 0UL)      {        if((CTIM_ReadAddress(&(__HANDLE__)->Instance->CCER) & TIM_CCER_CCxNE_MASK) == 0UL)        {          CTIM_WriteAddress(&(__HANDLE__)->Instance->CR1, CTIM_ReadAddress(&(__HANDLE__)->Instance->CR1) & (~(TIM_CR1_CEN)));        }      }    } while(0)
#undef __HAL_TIM_MOE_ENABLE
#define __HAL_TIM_MOE_ENABLE(__HANDLE__) SET_BIT((__HANDLE__)->Instance->BDTR,TIM_BDTR_MOE)
#undef __HAL_TIM_MOE_DISABLE
#define __HAL_TIM_MOE_DISABLE(__HANDLE__)    do {      if ((CTIM_ReadAddress(&(__HANDLE__)->Instance->CCER) & TIM_CCER_CCxE_MASK) == 0UL)      {        if((CTIM_ReadAddress(&(__HANDLE__)->Instance->CCER) & TIM_CCER_CCxNE_MASK) == 0UL)        {          CTIM_WriteAddress(&(__HANDLE__)->Instance->BDTR, CTIM_ReadAddress(&(__HANDLE__)->Instance->BDTR) & (~(TIM_BDTR_MOE)));        }      }    } while(0)
#undef __HAL_TIM_ENABLE_IT
#define __HAL_TIM_ENABLE_IT(__HANDLE__, __INTERRUPT__) SET_BIT((__HANDLE__)->Instance->DIER,__INTERRUPT__)
#undef __HAL_TIM_DISABLE_IT
#define __HAL_TIM_DISABLE_IT(__HANDLE__, __INTERRUPT__) CLEAR_BIT((__HANDLE__)->Instance->DIER,__INTERRUPT__)
#undef __HAL_TIM_ENABLE_DMA
#define __HAL_TIM_ENABLE_DMA(__HANDLE__, __DMA__) SET_BIT((__HANDLE__)->Instance->DIER,__DMA__)
#undef __HAL_TIM_DISABLE_DMA
#define __HAL_TIM_DISABLE_DMA(__HANDLE__, __DMA__) CLEAR_BIT((__HANDLE__)->Instance->DIER,__DMA__)
#undef __HAL_TIM_CLEAR_FLAG
#define __HAL_TIM_CLEAR_FLAG(__HANDLE__, __FLAG__) WRITE_REG((__HANDLE__)->Instance->SR,~(__FLAG__))

#undef __HAL_TIM_RESET_HANDLE_STATE
#if F_MODE
#define __HAL_TIM_RESET_HANDLE_STATE(__HANDLE__) do {                                                               \
                                                      (__HANDLE__)->State            = HAL_TIM_STATE_RESET;         \
                                                      (__HANDLE__)->ChannelState[0]  = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelState[1]  = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelState[2]  = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelState[3]  = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelState[4]  = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelState[5]  = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelNState[0] = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelNState[1] = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelNState[2] = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelNState[3] = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->DMABurstState    = HAL_DMA_BURST_STATE_RESET;   \
                                                      (__HANDLE__)->Base_MspInitCallback         = NULL;            \
                                                      (__HANDLE__)->Base_MspDeInitCallback       = NULL;            \
                                                      (__HANDLE__)->IC_MspInitCallback           = NULL;            \
                                                      (__HANDLE__)->IC_MspDeInitCallback         = NULL;            \
                                                      (__HANDLE__)->OC_MspInitCallback           = NULL;            \
                                                      (__HANDLE__)->OC_MspDeInitCallback         = NULL;            \
                                                      (__HANDLE__)->PWM_MspInitCallback          = NULL;            \
                                                      (__HANDLE__)->PWM_MspDeInitCallback        = NULL;            \
                                                      (__HANDLE__)->OnePulse_MspInitCallback     = NULL;            \
                                                      (__HANDLE__)->OnePulse_MspDeInitCallback   = NULL;            \
                                                      (__HANDLE__)->Encoder_MspInitCallback      = NULL;            \
                                                      (__HANDLE__)->Encoder_MspDeInitCallback    = NULL;            \
                                                      (__HANDLE__)->HallSensor_MspInitCallback   = NULL;            \
                                                      (__HANDLE__)->HallSensor_MspDeInitCallback = NULL;            \
                                                     } while(0)
#else
#define __HAL_TIM_RESET_HANDLE_STATE(__HANDLE__) do {                                                               \
                                                      (__HANDLE__)->State            = HAL_TIM_STATE_RESET;         \
                                                      (__HANDLE__)->ChannelState[0]  = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelState[1]  = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelState[2]  = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelState[3]  = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelState[4]  = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelState[5]  = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelNState[0] = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelNState[1] = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelNState[2] = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->ChannelNState[3] = HAL_TIM_CHANNEL_STATE_RESET; \
                                                      (__HANDLE__)->DMABurstState    = HAL_DMA_BURST_STATE_RESET;   \
                                                     } while(0)
#endif
#undef __HAL_TIM_MOE_DISABLE_UNCONDITIONALLY
#define __HAL_TIM_MOE_DISABLE_UNCONDITIONALLY(__HANDLE__) CLEAR_BIT((__HANDLE__)->Instance->BDTR,TIM_BDTR_MOE)
