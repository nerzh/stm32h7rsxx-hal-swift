#include "TIMPrototypes.h"
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
static void (*DMAPointer(uint32_t i))(DMA_HandleTypeDef *) { switch(i) { case 0:return NULL;
case 1:return TIM_DMAError;
case 2:return TIM_DMADelayPulseCplt;
case 3:return TIM_DMADelayPulseHalfCplt;
case 4:return TIM_DMACaptureCplt;
case 5:return TIM_DMACaptureHalfCplt;
case 6:return TIM_DMAPeriodElapsedCplt;
case 7:return TIM_DMAPeriodElapsedHalfCplt;
case 8:return TIM_DMATriggerCplt;
case 9:return TIM_DMATriggerHalfCplt;
case 10:return TIMEx_DMACommutationCplt;
case 11:return TIMEx_DMACommutationHalfCplt;
case 12:return TIM_DMADelayPulseNCplt;
case 13:return TIM_DMAErrorCCxN;
default:assert(0);return NULL;} }
uint32_t F_JOIN(F_VARIANT,_GetDMACallback)(CTIMState *s,uint32_t d,uint32_t i) { void (*cb)(DMA_HandleTypeDef *)=NULL;switch(i){case 0:cb=s->dma[d].XferCpltCallback;break;case 1:cb=s->dma[d].XferHalfCpltCallback;break;case 2:cb=s->dma[d].XferErrorCallback;break;case 3:cb=s->dma[d].XferAbortCallback;break;default:assert(0);}for(uint32_t k=0;k<=13;k++)if(cb==DMAPointer(k))return k;assert(0);return 0;}
void F_JOIN(F_VARIANT,_SetDMACallback)(CTIMState *s,uint32_t d,uint32_t i,uint32_t v) {switch(i){case 0:s->dma[d].XferCpltCallback=DMAPointer(v);break;case 1:s->dma[d].XferHalfCpltCallback=DMAPointer(v);break;case 2:s->dma[d].XferErrorCallback=DMAPointer(v);break;case 3:s->dma[d].XferAbortCallback=DMAPointer(v);break;default:assert(0);}}
uint32_t F_JOIN(F_VARIANT,_Run)(CTIMState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c,uint32_t d) {
switch(op){
case 0:{return HAL_TIM_Base_Init(&s->h);}
case 1:{return HAL_TIM_Base_DeInit(&s->h);}
case 2:{return HAL_TIM_Base_Start(&s->h);}
case 3:{return HAL_TIM_Base_Stop(&s->h);}
case 4:{return HAL_TIM_Base_Start_IT(&s->h);}
case 5:{return HAL_TIM_Base_Stop_IT(&s->h);}
case 6:{return HAL_TIM_Base_Start_DMA(&s->h,(s->control[13]?NULL:s->buffers[0]),a);}
case 7:{return HAL_TIM_Base_Stop_DMA(&s->h);}
case 8:{return HAL_TIM_OC_Init(&s->h);}
case 9:{return HAL_TIM_OC_DeInit(&s->h);}
case 10:{return HAL_TIM_OC_Start(&s->h,a);}
case 11:{return HAL_TIM_OC_Stop(&s->h,a);}
case 12:{return HAL_TIM_OC_Start_IT(&s->h,a);}
case 13:{return HAL_TIM_OC_Stop_IT(&s->h,a);}
case 14:{return HAL_TIM_OC_Start_DMA(&s->h,a,(s->control[13]?NULL:s->buffers[0]),b);}
case 15:{return HAL_TIM_OC_Stop_DMA(&s->h,a);}
case 16:{return HAL_TIM_PWM_Init(&s->h);}
case 17:{return HAL_TIM_PWM_DeInit(&s->h);}
case 18:{return HAL_TIM_PWM_Start(&s->h,a);}
case 19:{return HAL_TIM_PWM_Stop(&s->h,a);}
case 20:{return HAL_TIM_PWM_Start_IT(&s->h,a);}
case 21:{return HAL_TIM_PWM_Stop_IT(&s->h,a);}
case 22:{return HAL_TIM_PWM_Start_DMA(&s->h,a,(s->control[13]?NULL:s->buffers[0]),b);}
case 23:{return HAL_TIM_PWM_Stop_DMA(&s->h,a);}
case 24:{return HAL_TIM_IC_Init(&s->h);}
case 25:{return HAL_TIM_IC_DeInit(&s->h);}
case 26:{return HAL_TIM_IC_Start(&s->h,a);}
case 27:{return HAL_TIM_IC_Stop(&s->h,a);}
case 28:{return HAL_TIM_IC_Start_IT(&s->h,a);}
case 29:{return HAL_TIM_IC_Stop_IT(&s->h,a);}
case 30:{return HAL_TIM_IC_Start_DMA(&s->h,a,(s->control[13]?NULL:s->buffers[0]),b);}
case 31:{return HAL_TIM_IC_Stop_DMA(&s->h,a);}
case 32:{return HAL_TIM_OnePulse_Init(&s->h,a);}
case 33:{return HAL_TIM_OnePulse_DeInit(&s->h);}
case 34:{return HAL_TIM_OnePulse_Start(&s->h,a);}
case 35:{return HAL_TIM_OnePulse_Stop(&s->h,a);}
case 36:{return HAL_TIM_OnePulse_Start_IT(&s->h,a);}
case 37:{return HAL_TIM_OnePulse_Stop_IT(&s->h,a);}
case 38:{TIM_Encoder_InitTypeDef config={0};config.EncoderMode=s->configuration[0];config.IC1Polarity=s->configuration[1];config.IC1Selection=s->configuration[2];config.IC1Prescaler=s->configuration[3];config.IC1Filter=s->configuration[4];config.IC2Polarity=s->configuration[5];config.IC2Selection=s->configuration[6];config.IC2Prescaler=s->configuration[7];config.IC2Filter=s->configuration[8];return HAL_TIM_Encoder_Init(&s->h,&config);}
case 39:{return HAL_TIM_Encoder_DeInit(&s->h);}
case 40:{return HAL_TIM_Encoder_Start(&s->h,a);}
case 41:{return HAL_TIM_Encoder_Stop(&s->h,a);}
case 42:{return HAL_TIM_Encoder_Start_IT(&s->h,a);}
case 43:{return HAL_TIM_Encoder_Stop_IT(&s->h,a);}
case 44:{return HAL_TIM_Encoder_Start_DMA(&s->h,a,(s->control[13]?NULL:s->buffers[0]),(s->control[15]?NULL:s->buffers[1]),b);}
case 45:{return HAL_TIM_Encoder_Stop_DMA(&s->h,a);}
case 46:{HAL_TIM_IRQHandler(&s->h);return 0;}
case 47:{TIM_OC_InitTypeDef config={0};config.OCMode=s->configuration[0];config.Pulse=s->configuration[1];config.OCPolarity=s->configuration[2];config.OCNPolarity=s->configuration[3];config.OCFastMode=s->configuration[4];config.OCIdleState=s->configuration[5];config.OCNIdleState=s->configuration[6];return HAL_TIM_OC_ConfigChannel(&s->h,&config,a);}
case 48:{TIM_IC_InitTypeDef config={0};config.ICPolarity=s->configuration[0];config.ICSelection=s->configuration[1];config.ICPrescaler=s->configuration[2];config.ICFilter=s->configuration[3];return HAL_TIM_IC_ConfigChannel(&s->h,&config,a);}
case 49:{TIM_OC_InitTypeDef config={0};config.OCMode=s->configuration[0];config.Pulse=s->configuration[1];config.OCPolarity=s->configuration[2];config.OCNPolarity=s->configuration[3];config.OCFastMode=s->configuration[4];config.OCIdleState=s->configuration[5];config.OCNIdleState=s->configuration[6];return HAL_TIM_PWM_ConfigChannel(&s->h,&config,a);}
case 50:{TIM_OnePulse_InitTypeDef config={0};config.OCMode=s->configuration[0];config.Pulse=s->configuration[1];config.OCPolarity=s->configuration[2];config.OCNPolarity=s->configuration[3];config.OCIdleState=s->configuration[4];config.OCNIdleState=s->configuration[5];config.ICPolarity=s->configuration[6];config.ICSelection=s->configuration[7];config.ICFilter=s->configuration[8];return HAL_TIM_OnePulse_ConfigChannel(&s->h,&config,a,b);}
case 51:{return HAL_TIM_DMABurst_WriteStart(&s->h,a,b,(s->control[13]?NULL:s->buffers[0]),c);}
case 52:{return HAL_TIM_DMABurst_MultiWriteStart(&s->h,a,b,(s->control[13]?NULL:s->buffers[0]),c,d);}
case 53:{return HAL_TIM_DMABurst_WriteStop(&s->h,a);}
case 54:{return HAL_TIM_DMABurst_ReadStart(&s->h,a,b,(s->control[13]?NULL:s->buffers[0]),c);}
case 55:{return HAL_TIM_DMABurst_MultiReadStart(&s->h,a,b,(s->control[13]?NULL:s->buffers[0]),c,d);}
case 56:{return HAL_TIM_DMABurst_ReadStop(&s->h,a);}
case 57:{return HAL_TIM_GenerateEvent(&s->h,a);}
case 58:{TIM_ClearInputConfigTypeDef config={0};config.ClearInputState=s->configuration[0];config.ClearInputSource=s->configuration[1];config.ClearInputPolarity=s->configuration[2];config.ClearInputPrescaler=s->configuration[3];config.ClearInputFilter=s->configuration[4];return HAL_TIM_ConfigOCrefClear(&s->h,&config,a);}
case 59:{TIM_ClockConfigTypeDef config={0};config.ClockSource=s->configuration[0];config.ClockPolarity=s->configuration[1];config.ClockPrescaler=s->configuration[2];config.ClockFilter=s->configuration[3];return HAL_TIM_ConfigClockSource(&s->h,&config);}
case 60:{return HAL_TIM_ConfigTI1Input(&s->h,a);}
case 61:{TIM_SlaveConfigTypeDef config={0};config.SlaveMode=s->configuration[0];config.InputTrigger=s->configuration[1];config.TriggerPolarity=s->configuration[2];config.TriggerPrescaler=s->configuration[3];config.TriggerFilter=s->configuration[4];return HAL_TIM_SlaveConfigSynchro(&s->h,&config);}
case 62:{TIM_SlaveConfigTypeDef config={0};config.SlaveMode=s->configuration[0];config.InputTrigger=s->configuration[1];config.TriggerPolarity=s->configuration[2];config.TriggerPrescaler=s->configuration[3];config.TriggerFilter=s->configuration[4];return HAL_TIM_SlaveConfigSynchro_IT(&s->h,&config);}
case 63:{return HAL_TIM_ReadCapturedValue(&s->h,a);}
case 64:{return TIM_DMA_Start_IT(&s->dma[s->control[30]],a,b,c);}
#if F_MODE
case 65:{return HAL_TIM_RegisterCallback(&s->h,a,(pTIM_CallbackTypeDef)CTIM_Callback(a<32?a:0,b));}
#endif
#if F_MODE
case 66:{return HAL_TIM_UnRegisterCallback(&s->h,a);}
#endif
case 67:{return HAL_TIM_Base_GetState(&s->h);}
case 68:{return HAL_TIM_OC_GetState(&s->h);}
case 69:{return HAL_TIM_PWM_GetState(&s->h);}
case 70:{return HAL_TIM_IC_GetState(&s->h);}
case 71:{return HAL_TIM_OnePulse_GetState(&s->h);}
case 72:{return HAL_TIM_Encoder_GetState(&s->h);}
case 73:{return HAL_TIM_GetActiveChannel(&s->h);}
case 74:{return HAL_TIM_GetChannelState(&s->h,a);}
case 75:{return HAL_TIM_DMABurstState(&s->h);}
case 76:{TIM_DMAError(&s->dma[s->control[30]]);return 0;}
case 77:{TIM_DMADelayPulseCplt(&s->dma[s->control[30]]);return 0;}
case 78:{TIM_DMADelayPulseHalfCplt(&s->dma[s->control[30]]);return 0;}
case 79:{TIM_DMACaptureCplt(&s->dma[s->control[30]]);return 0;}
case 80:{TIM_DMACaptureHalfCplt(&s->dma[s->control[30]]);return 0;}
case 81:{TIM_DMAPeriodElapsedCplt(&s->dma[s->control[30]]);return 0;}
case 82:{TIM_DMAPeriodElapsedHalfCplt(&s->dma[s->control[30]]);return 0;}
case 83:{TIM_DMATriggerCplt(&s->dma[s->control[30]]);return 0;}
case 84:{TIM_DMATriggerHalfCplt(&s->dma[s->control[30]]);return 0;}
case 85:{TIM_Base_InitTypeDef config={0};config.Prescaler=s->configuration[0];config.CounterMode=s->configuration[1];config.Period=s->configuration[2];config.ClockDivision=s->configuration[3];config.RepetitionCounter=s->configuration[4];config.AutoReloadPreload=s->configuration[5];TIM_Base_SetConfig(s->h.Instance,&config);return 0;}
case 86:{TIM_OC_InitTypeDef config={0};config.OCMode=s->configuration[0];config.Pulse=s->configuration[1];config.OCPolarity=s->configuration[2];config.OCNPolarity=s->configuration[3];config.OCFastMode=s->configuration[4];config.OCIdleState=s->configuration[5];config.OCNIdleState=s->configuration[6];TIM_OC1_SetConfig(s->h.Instance,&config);return 0;}
case 87:{TIM_OC_InitTypeDef config={0};config.OCMode=s->configuration[0];config.Pulse=s->configuration[1];config.OCPolarity=s->configuration[2];config.OCNPolarity=s->configuration[3];config.OCFastMode=s->configuration[4];config.OCIdleState=s->configuration[5];config.OCNIdleState=s->configuration[6];TIM_OC2_SetConfig(s->h.Instance,&config);return 0;}
case 88:{TIM_OC_InitTypeDef config={0};config.OCMode=s->configuration[0];config.Pulse=s->configuration[1];config.OCPolarity=s->configuration[2];config.OCNPolarity=s->configuration[3];config.OCFastMode=s->configuration[4];config.OCIdleState=s->configuration[5];config.OCNIdleState=s->configuration[6];TIM_OC3_SetConfig(s->h.Instance,&config);return 0;}
case 89:{TIM_OC_InitTypeDef config={0};config.OCMode=s->configuration[0];config.Pulse=s->configuration[1];config.OCPolarity=s->configuration[2];config.OCNPolarity=s->configuration[3];config.OCFastMode=s->configuration[4];config.OCIdleState=s->configuration[5];config.OCNIdleState=s->configuration[6];TIM_OC4_SetConfig(s->h.Instance,&config);return 0;}
case 90:{TIM_OC_InitTypeDef config={0};config.OCMode=s->configuration[0];config.Pulse=s->configuration[1];config.OCPolarity=s->configuration[2];config.OCNPolarity=s->configuration[3];config.OCFastMode=s->configuration[4];config.OCIdleState=s->configuration[5];config.OCNIdleState=s->configuration[6];TIM_OC5_SetConfig(s->h.Instance,&config);return 0;}
case 91:{TIM_OC_InitTypeDef config={0};config.OCMode=s->configuration[0];config.Pulse=s->configuration[1];config.OCPolarity=s->configuration[2];config.OCNPolarity=s->configuration[3];config.OCFastMode=s->configuration[4];config.OCIdleState=s->configuration[5];config.OCNIdleState=s->configuration[6];TIM_OC6_SetConfig(s->h.Instance,&config);return 0;}
case 92:{TIM_SlaveConfigTypeDef config={0};config.SlaveMode=s->configuration[0];config.InputTrigger=s->configuration[1];config.TriggerPolarity=s->configuration[2];config.TriggerPrescaler=s->configuration[3];config.TriggerFilter=s->configuration[4];return TIM_SlaveTimer_SetConfig(&s->h,&config);}
case 93:{TIM_TI1_SetConfig(s->h.Instance,a,b,c);return 0;}
case 94:{TIM_TI1_ConfigInputStage(s->h.Instance,a,b);return 0;}
case 95:{TIM_TI2_SetConfig(s->h.Instance,a,b,c);return 0;}
case 96:{TIM_TI2_ConfigInputStage(s->h.Instance,a,b);return 0;}
case 97:{TIM_TI3_SetConfig(s->h.Instance,a,b,c);return 0;}
case 98:{TIM_TI4_SetConfig(s->h.Instance,a,b,c);return 0;}
case 99:{TIM_ITRx_SetConfig(s->h.Instance,a);return 0;}
case 100:{TIM_ETR_SetConfig(s->h.Instance,a,b,c);return 0;}
case 101:{TIM_CCxChannelCmd(s->h.Instance,a,b);return 0;}
#if F_MODE
case 102:{TIM_ResetCallback(&s->h);return 0;}
#endif
case 103:{TIM_HallSensor_InitTypeDef config={0};config.IC1Polarity=s->configuration[0];config.IC1Prescaler=s->configuration[1];config.IC1Filter=s->configuration[2];config.Commutation_Delay=s->configuration[3];return HAL_TIMEx_HallSensor_Init(&s->h,&config);}
case 104:{return HAL_TIMEx_HallSensor_DeInit(&s->h);}
case 105:{return HAL_TIMEx_HallSensor_Start(&s->h);}
case 106:{return HAL_TIMEx_HallSensor_Stop(&s->h);}
case 107:{return HAL_TIMEx_HallSensor_Start_IT(&s->h);}
case 108:{return HAL_TIMEx_HallSensor_Stop_IT(&s->h);}
case 109:{return HAL_TIMEx_HallSensor_Start_DMA(&s->h,(s->control[13]?NULL:s->buffers[0]),a);}
case 110:{return HAL_TIMEx_HallSensor_Stop_DMA(&s->h);}
case 111:{return HAL_TIMEx_OCN_Start(&s->h,a);}
case 112:{return HAL_TIMEx_OCN_Stop(&s->h,a);}
case 113:{return HAL_TIMEx_OCN_Start_IT(&s->h,a);}
case 114:{return HAL_TIMEx_OCN_Stop_IT(&s->h,a);}
case 115:{return HAL_TIMEx_OCN_Start_DMA(&s->h,a,(s->control[13]?NULL:s->buffers[0]),b);}
case 116:{return HAL_TIMEx_OCN_Stop_DMA(&s->h,a);}
case 117:{return HAL_TIMEx_PWMN_Start(&s->h,a);}
case 118:{return HAL_TIMEx_PWMN_Stop(&s->h,a);}
case 119:{return HAL_TIMEx_PWMN_Start_IT(&s->h,a);}
case 120:{return HAL_TIMEx_PWMN_Stop_IT(&s->h,a);}
case 121:{return HAL_TIMEx_PWMN_Start_DMA(&s->h,a,(s->control[13]?NULL:s->buffers[0]),b);}
case 122:{return HAL_TIMEx_PWMN_Stop_DMA(&s->h,a);}
case 123:{return HAL_TIMEx_OnePulseN_Start(&s->h,a);}
case 124:{return HAL_TIMEx_OnePulseN_Stop(&s->h,a);}
case 125:{return HAL_TIMEx_OnePulseN_Start_IT(&s->h,a);}
case 126:{return HAL_TIMEx_OnePulseN_Stop_IT(&s->h,a);}
case 127:{return HAL_TIMEx_ConfigCommutEvent(&s->h,a,b);}
case 128:{return HAL_TIMEx_ConfigCommutEvent_IT(&s->h,a,b);}
case 129:{return HAL_TIMEx_ConfigCommutEvent_DMA(&s->h,a,b);}
case 130:{TIM_MasterConfigTypeDef config={0};config.MasterOutputTrigger=s->configuration[0];config.MasterOutputTrigger2=s->configuration[1];config.MasterSlaveMode=s->configuration[2];return HAL_TIMEx_MasterConfigSynchronization(&s->h,&config);}
case 131:{TIM_BreakDeadTimeConfigTypeDef config={0};config.OffStateRunMode=s->configuration[0];config.OffStateIDLEMode=s->configuration[1];config.LockLevel=s->configuration[2];config.DeadTime=s->configuration[3];config.BreakState=s->configuration[4];config.BreakPolarity=s->configuration[5];config.BreakFilter=s->configuration[6];config.BreakAFMode=s->configuration[7];config.Break2State=s->configuration[8];config.Break2Polarity=s->configuration[9];config.Break2Filter=s->configuration[10];config.Break2AFMode=s->configuration[11];config.AutomaticOutput=s->configuration[12];return HAL_TIMEx_ConfigBreakDeadTime(&s->h,&config);}
case 132:{TIMEx_BreakInputConfigTypeDef config={0};config.Source=s->configuration[0];config.Enable=s->configuration[1];config.Polarity=s->configuration[2];return HAL_TIMEx_ConfigBreakInput(&s->h,a,&config);}
case 133:{return HAL_TIMEx_RemapConfig(&s->h,a);}
case 134:{return HAL_TIMEx_TISelection(&s->h,a,b);}
case 135:{return HAL_TIMEx_GroupChannel5(&s->h,a);}
case 136:{return HAL_TIMEx_DisarmBreakInput(&s->h,a);}
case 137:{return HAL_TIMEx_ReArmBreakInput(&s->h,a);}
case 138:{return HAL_TIMEx_DitheringEnable(&s->h);}
case 139:{return HAL_TIMEx_DitheringDisable(&s->h);}
case 140:{return HAL_TIMEx_OC_ConfigPulseOnCompare(&s->h,a,b);}
case 141:{return HAL_TIMEx_ConfigSlaveModePreload(&s->h,a);}
case 142:{return HAL_TIMEx_EnableSlaveModePreload(&s->h);}
case 143:{return HAL_TIMEx_DisableSlaveModePreload(&s->h);}
case 144:{return HAL_TIMEx_EnableDeadTimePreload(&s->h);}
case 145:{return HAL_TIMEx_DisableDeadTimePreload(&s->h);}
case 146:{return HAL_TIMEx_ConfigDeadTime(&s->h,a);}
case 147:{return HAL_TIMEx_ConfigAsymmetricalDeadTime(&s->h,a);}
case 148:{return HAL_TIMEx_EnableAsymmetricalDeadTime(&s->h);}
case 149:{return HAL_TIMEx_DisableAsymmetricalDeadTime(&s->h);}
case 150:{TIMEx_EncoderIndexConfigTypeDef config={0};config.Polarity=s->configuration[0];config.Prescaler=s->configuration[1];config.Filter=s->configuration[2];config.Blanking=s->configuration[3];config.FirstIndexEnable=s->configuration[4];config.Position=s->configuration[5];config.Direction=s->configuration[6];return HAL_TIMEx_ConfigEncoderIndex(&s->h,&config);}
case 151:{return HAL_TIMEx_EnableEncoderIndex(&s->h);}
case 152:{return HAL_TIMEx_DisableEncoderIndex(&s->h);}
case 153:{return HAL_TIMEx_EnableEncoderFirstIndex(&s->h);}
case 154:{return HAL_TIMEx_DisableEncoderFirstIndex(&s->h);}
case 155:{return HAL_TIMEx_HallSensor_GetState(&s->h);}
case 156:{return HAL_TIMEx_GetChannelNState(&s->h,a);}
case 157:{TIMEx_DMACommutationCplt(&s->dma[s->control[30]]);return 0;}
case 158:{TIMEx_DMACommutationHalfCplt(&s->dma[s->control[30]]);return 0;}
case 159:{TIM_DMADelayPulseNCplt(&s->dma[s->control[30]]);return 0;}
case 160:{TIM_DMAErrorCCxN(&s->dma[s->control[30]]);return 0;}
case 161:{TIM_CCxNChannelCmd(s->h.Instance,a,b);return 0;}
case 200:__HAL_TIM_RESET_HANDLE_STATE(&s->h);return 0;
case 201:__HAL_TIM_ENABLE(&s->h);return 0;
case 202:__HAL_TIM_DISABLE(&s->h);return 0;
case 203:__HAL_TIM_MOE_ENABLE(&s->h);return 0;
case 204:__HAL_TIM_MOE_DISABLE(&s->h);return 0;
case 205:__HAL_TIM_MOE_DISABLE_UNCONDITIONALLY(&s->h);return 0;
case 206:__HAL_TIM_ENABLE_IT(&s->h,a);return 0;
case 207:__HAL_TIM_DISABLE_IT(&s->h,a);return 0;
case 208:__HAL_TIM_ENABLE_DMA(&s->h,a);return 0;
case 209:__HAL_TIM_DISABLE_DMA(&s->h,a);return 0;
case 210:return __HAL_TIM_GET_FLAG(&s->h,a);
case 211:__HAL_TIM_CLEAR_FLAG(&s->h,a);return 0;
case 212:return __HAL_TIM_GET_IT_SOURCE(&s->h,a);
case 213:__HAL_TIM_CLEAR_IT(&s->h,a);return 0;
case 214:__HAL_TIM_UIFREMAP_ENABLE(&s->h);return 0;
case 215:__HAL_TIM_UIFREMAP_DISABLE(&s->h);return 0;
case 216:return __HAL_TIM_IS_TIM_COUNTING_DOWN(&s->h);
case 217:__HAL_TIM_SET_PRESCALER(&s->h,a);return 0;
case 218:__HAL_TIM_SET_COUNTER(&s->h,a);return 0;
case 219:return __HAL_TIM_GET_COUNTER(&s->h);
case 220:__HAL_TIM_SET_AUTORELOAD(&s->h,a);return 0;
case 221:return __HAL_TIM_GET_AUTORELOAD(&s->h);
case 222:__HAL_TIM_SET_CLOCKDIVISION(&s->h,a);return 0;
case 223:return __HAL_TIM_GET_CLOCKDIVISION(&s->h);
case 224:__HAL_TIM_SET_ICPRESCALER(&s->h,a,b);return 0;
case 225:return __HAL_TIM_GET_ICPRESCALER(&s->h,a);
case 226:__HAL_TIM_SET_COMPARE(&s->h,a,b);return 0;
case 227:return __HAL_TIM_GET_COMPARE(&s->h,a);
case 228:__HAL_TIM_ENABLE_OCxPRELOAD(&s->h,a);return 0;
case 229:__HAL_TIM_DISABLE_OCxPRELOAD(&s->h,a);return 0;
case 230:__HAL_TIM_ENABLE_OCxFAST(&s->h,a);return 0;
case 231:__HAL_TIM_DISABLE_OCxFAST(&s->h,a);return 0;
case 232:__HAL_TIM_URS_ENABLE(&s->h);return 0;
case 233:__HAL_TIM_URS_DISABLE(&s->h);return 0;
case 234:__HAL_TIM_SET_CAPTUREPOLARITY(&s->h,a,b);return 0;
case 235:__HAL_TIM_SELECT_CCDMAREQUEST(&s->h,a);return 0;
case 300:return __HAL_TIM_GET_UIFCPY(a);
case 301:return __HAL_TIM_CALC_PSC(a,b);
case 302:return __HAL_TIM_CALC_PERIOD(a,b,c);
case 303:return __HAL_TIM_CALC_PERIOD_DITHER(a,b,c);
case 304:return __HAL_TIM_CALC_PULSE(a,b,c);
case 305:return __HAL_TIM_CALC_PULSE_DITHER(a,b,c);
case 306:return __HAL_TIM_CALC_PERIOD_BY_DELAY(a,b,c,d);
case 307:return __HAL_TIM_CALC_PERIOD_DITHER_BY_DELAY(a,b,c,d);
default:assert(0);return 0;} }
