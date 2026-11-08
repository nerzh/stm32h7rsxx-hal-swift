#include "ADCInternal.h"
uint32_t F_JOIN(F_VARIANT,_Run)(CADCState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
ADC_ChannelConfTypeDef config0;
config0.Channel=s->params[0][0];
config0.Rank=s->params[0][1];
config0.SamplingTime=s->params[0][2];
config0.SingleDiff=s->params[0][3];
config0.OffsetNumber=s->params[0][4];
config0.Offset=s->params[0][5];
config0.OffsetSign=s->params[0][6];
config0.OffsetSaturation=s->params[0][7];
ADC_AnalogWDGConfTypeDef config1;
config1.WatchdogNumber=s->params[1][0];
config1.WatchdogMode=s->params[1][1];
config1.Channel=s->params[1][2];
config1.ITMode=s->params[1][3];
config1.HighThreshold=s->params[1][4];
config1.LowThreshold=s->params[1][5];
config1.FilteringConfig=s->params[1][6];
ADC_InjectionConfTypeDef config2;
config2.InjectedChannel=s->params[2][0];
config2.InjectedRank=s->params[2][1];
config2.InjectedSamplingTime=s->params[2][2];
config2.InjectedSingleDiff=s->params[2][3];
config2.InjectedOffsetNumber=s->params[2][4];
config2.InjectedOffset=s->params[2][5];
config2.InjectedOffsetSign=s->params[2][6];
config2.InjectedOffsetSaturation=s->params[2][7];
config2.InjectedNbrOfConversion=s->params[2][8];
config2.InjectedDiscontinuousConvMode=s->params[2][9];
config2.AutoInjectedConv=s->params[2][10];
config2.QueueInjectedContext=s->params[2][11];
config2.ExternalTrigInjecConv=s->params[2][12];
config2.ExternalTrigInjecConvEdge=s->params[2][13];
config2.InjecOversamplingMode=s->params[2][14];
config2.InjecOversampling.Ratio=s->params[2][15];
config2.InjecOversampling.RightBitShift=s->params[2][16];
ADC_MultiModeTypeDef multi={a,b,c};
switch(op) {
case 0:return HAL_ADC_Init(&s->h);
case 1:return HAL_ADC_DeInit(&s->h);
case 2:
#if F_MODE
return HAL_ADC_RegisterCallback(&s->h,(HAL_ADC_CallbackIDTypeDef)a,CADC_CallbackPointer(a<11?a:0,b));
#else
return UINT32_MAX;
#endif
case 3:
#if F_MODE
return HAL_ADC_UnRegisterCallback(&s->h,(HAL_ADC_CallbackIDTypeDef)a);
#else
return UINT32_MAX;
#endif
case 4:return HAL_ADC_Start(&s->h);
case 5:return HAL_ADC_Stop(&s->h);
case 6:return HAL_ADC_PollForConversion(&s->h,a);
case 7:return HAL_ADC_PollForEvent(&s->h,a,b);
case 8:return HAL_ADC_Start_IT(&s->h);
case 9:return HAL_ADC_Stop_IT(&s->h);
case 10:return HAL_ADC_Start_DMA(&s->h,(uint32_t *)(uintptr_t)a,b);
case 11:return HAL_ADC_Stop_DMA(&s->h);
case 12:return HAL_ADC_GetValue(&s->h);
case 13:return HAL_ADC_StartSampling(&s->h);
case 14:return HAL_ADC_StopSampling(&s->h);
case 15:HAL_ADC_IRQHandler(&s->h);return 0;
case 16:return HAL_ADC_ConfigChannel(&s->h,&config0);
case 17:return HAL_ADC_AnalogWDGConfig(&s->h,&config1);
case 18:return HAL_ADC_GetState(&s->h);
case 19:return HAL_ADC_GetError(&s->h);
case 20:return ADC_ConversionStop(&s->h,a);
case 21:return ADC_Enable(&s->h);
case 22:return ADC_Disable(&s->h);
case 23:ADC_DMAConvCplt(&s->dma);return 0;
case 24:ADC_DMAHalfConvCplt(&s->dma);return 0;
case 25:ADC_DMAError(&s->dma);return 0;
case 26:return HAL_ADCEx_Calibration_Start(&s->h,a);
case 27:return HAL_ADCEx_Calibration_GetValue(&s->h,a);
case 28:return HAL_ADCEx_Calibration_SetValue(&s->h,a,b);
case 29:return HAL_ADCEx_InjectedStart(&s->h);
case 30:return HAL_ADCEx_InjectedStop(&s->h);
case 31:return HAL_ADCEx_InjectedPollForConversion(&s->h,a);
case 32:return HAL_ADCEx_InjectedStart_IT(&s->h);
case 33:return HAL_ADCEx_InjectedStop_IT(&s->h);
case 34:return HAL_ADCEx_MultiModeStart_DMA(&s->h,(uint32_t *)(uintptr_t)a,b);
case 35:return HAL_ADCEx_MultiModeStop_DMA(&s->h);
case 36:return HAL_ADCEx_MultiModeGetValue(&s->h);
case 37:return HAL_ADCEx_InjectedGetValue(&s->h,a);
case 38:return HAL_ADCEx_RegularStop(&s->h);
case 39:return HAL_ADCEx_RegularStop_IT(&s->h);
case 40:return HAL_ADCEx_RegularStop_DMA(&s->h);
case 41:return HAL_ADCEx_RegularMultiModeStop_DMA(&s->h);
case 42:return HAL_ADCEx_InjectedConfigChannel(&s->h,&config2);
case 43:return HAL_ADCEx_MultiModeConfigChannel(&s->h,&multi);
case 44:return HAL_ADCEx_EnableInjectedQueue(&s->h);
case 45:return HAL_ADCEx_DisableInjectedQueue(&s->h);
case 46:return HAL_ADCEx_DisableVoltageRegulator(&s->h);
case 47:return HAL_ADCEx_EnterADCDeepPowerDownMode(&s->h);
default:assert(0);return 0;}}
