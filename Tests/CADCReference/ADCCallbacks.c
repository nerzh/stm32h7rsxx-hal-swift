#include "ADCInternal.h"
void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,0,1); }
static void custom0(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,0,2); }
void HAL_ADC_ConvHalfCpltCallback(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,1,1); }
static void custom1(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,1,2); }
void HAL_ADC_LevelOutOfWindowCallback(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,2,1); }
static void custom2(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,2,2); }
void HAL_ADC_ErrorCallback(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,3,1); }
static void custom3(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,3,2); }
void HAL_ADCEx_InjectedConvCpltCallback(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,4,1); }
static void custom4(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,4,2); }
void HAL_ADCEx_InjectedQueueOverflowCallback(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,5,1); }
static void custom5(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,5,2); }
void HAL_ADCEx_LevelOutOfWindow2Callback(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,6,1); }
static void custom6(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,6,2); }
void HAL_ADCEx_LevelOutOfWindow3Callback(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,7,1); }
static void custom7(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,7,2); }
void HAL_ADCEx_EndOfSamplingCallback(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,8,1); }
static void custom8(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,8,2); }
void HAL_ADC_MspInit(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,9,1); }
static void custom9(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,9,2); }
void HAL_ADC_MspDeInit(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,10,1); }
static void custom10(ADC_HandleTypeDef *h) { (void)h; CADC_Callback(CADC_Active,10,2); }
pADC_CallbackTypeDef CADC_CallbackPointer(uint32_t id,uint32_t token) { if(!token)return NULL; switch(id) {
case 0:return token==1?HAL_ADC_ConvCpltCallback:custom0;
case 1:return token==1?HAL_ADC_ConvHalfCpltCallback:custom1;
case 2:return token==1?HAL_ADC_LevelOutOfWindowCallback:custom2;
case 3:return token==1?HAL_ADC_ErrorCallback:custom3;
case 4:return token==1?HAL_ADCEx_InjectedConvCpltCallback:custom4;
case 5:return token==1?HAL_ADCEx_InjectedQueueOverflowCallback:custom5;
case 6:return token==1?HAL_ADCEx_LevelOutOfWindow2Callback:custom6;
case 7:return token==1?HAL_ADCEx_LevelOutOfWindow3Callback:custom7;
case 8:return token==1?HAL_ADCEx_EndOfSamplingCallback:custom8;
case 9:return token==1?HAL_ADC_MspInit:custom9;
case 10:return token==1?HAL_ADC_MspDeInit:custom10;
default:assert(0);return NULL;}}
uint32_t CADC_GetCallback(CADCState *s,uint32_t id) { pADC_CallbackTypeDef p=NULL; switch(id) {
case 0:p=s->h.ConvCpltCallback;break;
case 1:p=s->h.ConvHalfCpltCallback;break;
case 2:p=s->h.LevelOutOfWindowCallback;break;
case 3:p=s->h.ErrorCallback;break;
case 4:p=s->h.InjectedConvCpltCallback;break;
case 5:p=s->h.InjectedQueueOverflowCallback;break;
case 6:p=s->h.LevelOutOfWindow2Callback;break;
case 7:p=s->h.LevelOutOfWindow3Callback;break;
case 8:p=s->h.EndOfSamplingCallback;break;
case 9:p=s->h.MspInitCallback;break;
case 10:p=s->h.MspDeInitCallback;break;
default:assert(0);}return !p?0:(p==CADC_CallbackPointer(id,1)?1:2);}
void CADC_SetCallback(CADCState *s,uint32_t id,uint32_t token) {pADC_CallbackTypeDef p=CADC_CallbackPointer(id,token);switch(id) {
case 0:s->h.ConvCpltCallback=p;break;
case 1:s->h.ConvHalfCpltCallback=p;break;
case 2:s->h.LevelOutOfWindowCallback=p;break;
case 3:s->h.ErrorCallback=p;break;
case 4:s->h.InjectedConvCpltCallback=p;break;
case 5:s->h.InjectedQueueOverflowCallback=p;break;
case 6:s->h.LevelOutOfWindow2Callback=p;break;
case 7:s->h.LevelOutOfWindow3Callback=p;break;
case 8:s->h.EndOfSamplingCallback=p;break;
case 9:s->h.MspInitCallback=p;break;
case 10:s->h.MspDeInitCallback=p;break;
default:assert(0);}}

uint32_t CADC_Mode(CADCState *s) { return s->mode; }
void CADC0_ADC_DMAConvCplt(DMA_HandleTypeDef *);
void CADC1_ADC_DMAConvCplt(DMA_HandleTypeDef *);
static void dmaCustom0(DMA_HandleTypeDef *h) { (void)h;CADC_Callback(CADC_Active,30,2); }
void CADC0_ADC_DMAHalfConvCplt(DMA_HandleTypeDef *);
void CADC1_ADC_DMAHalfConvCplt(DMA_HandleTypeDef *);
static void dmaCustom1(DMA_HandleTypeDef *h) { (void)h;CADC_Callback(CADC_Active,31,2); }
void CADC0_ADC_DMAError(DMA_HandleTypeDef *);
void CADC1_ADC_DMAError(DMA_HandleTypeDef *);
static void dmaCustom2(DMA_HandleTypeDef *h) { (void)h;CADC_Callback(CADC_Active,32,2); }
typedef void (*CADCDMACallback)(DMA_HandleTypeDef *);
static CADCDMACallback dmaPointer(CADCState *s,uint32_t id,uint32_t token) {if(!token)return NULL;switch(id) {
case 0:return token==2?dmaCustom0:(s->mode?CADC1_ADC_DMAConvCplt:CADC0_ADC_DMAConvCplt);
case 1:return token==2?dmaCustom1:(s->mode?CADC1_ADC_DMAHalfConvCplt:CADC0_ADC_DMAHalfConvCplt);
case 2:return token==2?dmaCustom2:(s->mode?CADC1_ADC_DMAError:CADC0_ADC_DMAError);
default:assert(0);return NULL;}}
uint32_t CADC_GetDMACallback(CADCState *s,uint32_t id) {CADCDMACallback p=NULL;switch(id) {
case 0:p=s->dma.XferCpltCallback;break;
case 1:p=s->dma.XferHalfCpltCallback;break;
case 2:p=s->dma.XferErrorCallback;break;
default:assert(0);}return !p?0:(p==dmaPointer(s,id,1)?1:2);}
void CADC_SetDMACallback(CADCState *s,uint32_t id,uint32_t token) {CADCDMACallback p=dmaPointer(s,id,token);switch(id) {
case 0:s->dma.XferCpltCallback=p;break;
case 1:s->dma.XferHalfCpltCallback=p;break;
case 2:s->dma.XferErrorCallback=p;break;
default:assert(0);}}
