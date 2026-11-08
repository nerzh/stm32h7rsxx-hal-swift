#include "SAIPrototypes.h"
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#endif
static void (*ISRPointer(uint32_t i))(SAI_HandleTypeDef *){switch(i){case 0:return NULL;
case 1:return SAI_Transmit_IT8Bit;
case 2:return SAI_Transmit_IT16Bit;
case 3:return SAI_Transmit_IT32Bit;
case 4:return SAI_Receive_IT8Bit;
case 5:return SAI_Receive_IT16Bit;
case 6:return SAI_Receive_IT32Bit;
default:assert(0);return NULL;}}
uint32_t F_JOIN(F_VARIANT,_GetWord)(CSAIState *s,uint32_t i){switch(i){
case 0:return s->h.Init.AudioMode;
case 1:return s->h.Init.Synchro;
case 2:return s->h.Init.SynchroExt;
case 3:return s->h.Init.MckOutput;
case 4:return s->h.Init.OutputDrive;
case 5:return s->h.Init.NoDivider;
case 6:return s->h.Init.FIFOThreshold;
case 7:return s->h.Init.AudioFrequency;
case 8:return s->h.Init.Mckdiv;
case 9:return s->h.Init.MckOverSampling;
case 10:return s->h.Init.MonoStereoMode;
case 11:return s->h.Init.CompandingMode;
case 12:return s->h.Init.TriState;
case 13:return s->h.Init.PdmInit.Activation;
case 14:return s->h.Init.PdmInit.MicPairsNbr;
case 15:return s->h.Init.PdmInit.ClockEnable;
case 16:return s->h.Init.Protocol;
case 17:return s->h.Init.DataSize;
case 18:return s->h.Init.FirstBit;
case 19:return s->h.Init.ClockStrobing;
case 20:return s->h.FrameInit.FrameLength;
case 21:return s->h.FrameInit.ActiveFrameLength;
case 22:return s->h.FrameInit.FSDefinition;
case 23:return s->h.FrameInit.FSPolarity;
case 24:return s->h.FrameInit.FSOffset;
case 25:return s->h.SlotInit.FirstBitOffset;
case 26:return s->h.SlotInit.SlotSize;
case 27:return s->h.SlotInit.SlotNumber;
case 28:return s->h.SlotInit.SlotActive;
case 29:return s->h.XferSize;
case 30:return s->h.XferCount;
case 31:return s->h.Lock;
case 32:return s->h.State;
case 33:return s->h.ErrorCode;
case 34:for(uint32_t k=0;k<=6;k++)if(s->h.InterruptServiceRoutine==ISRPointer(k))return k;assert(0);return 0;
default:assert(0);return 0;}}
void F_JOIN(F_VARIANT,_SetWord)(CSAIState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->h.Init.AudioMode=v;break;
case 1:s->h.Init.Synchro=v;break;
case 2:s->h.Init.SynchroExt=v;break;
case 3:s->h.Init.MckOutput=v;break;
case 4:s->h.Init.OutputDrive=v;break;
case 5:s->h.Init.NoDivider=v;break;
case 6:s->h.Init.FIFOThreshold=v;break;
case 7:s->h.Init.AudioFrequency=v;break;
case 8:s->h.Init.Mckdiv=v;break;
case 9:s->h.Init.MckOverSampling=v;break;
case 10:s->h.Init.MonoStereoMode=v;break;
case 11:s->h.Init.CompandingMode=v;break;
case 12:s->h.Init.TriState=v;break;
case 13:s->h.Init.PdmInit.Activation=v;break;
case 14:s->h.Init.PdmInit.MicPairsNbr=v;break;
case 15:s->h.Init.PdmInit.ClockEnable=v;break;
case 16:s->h.Init.Protocol=v;break;
case 17:s->h.Init.DataSize=v;break;
case 18:s->h.Init.FirstBit=v;break;
case 19:s->h.Init.ClockStrobing=v;break;
case 20:s->h.FrameInit.FrameLength=v;break;
case 21:s->h.FrameInit.ActiveFrameLength=v;break;
case 22:s->h.FrameInit.FSDefinition=v;break;
case 23:s->h.FrameInit.FSPolarity=v;break;
case 24:s->h.FrameInit.FSOffset=v;break;
case 25:s->h.SlotInit.FirstBitOffset=v;break;
case 26:s->h.SlotInit.SlotSize=v;break;
case 27:s->h.SlotInit.SlotNumber=v;break;
case 28:s->h.SlotInit.SlotActive=v;break;
case 29:s->h.XferSize=v;break;
case 30:s->h.XferCount=v;break;
case 31:s->h.Lock=v;break;
case 32:s->h.State=v;break;
case 33:s->h.ErrorCode=v;break;
case 34:s->h.InterruptServiceRoutine=ISRPointer(v);break;
default:assert(0);break;}}
static void (*DMAPointer(uint32_t i))(DMA_HandleTypeDef *){switch(i){case 0:return NULL;
case 1:return SAI_DMATxCplt;
case 2:return SAI_DMATxHalfCplt;
case 3:return SAI_DMARxCplt;
case 4:return SAI_DMARxHalfCplt;
case 5:return SAI_DMAError;
case 6:return SAI_DMAAbort;
default:assert(0);return NULL;}}
uint32_t F_JOIN(F_VARIANT,_GetDMA)(CSAIState *s,uint32_t d,uint32_t id){void (*f)(DMA_HandleTypeDef *)=NULL;switch(id){
case 0:f=s->dma[d].XferCpltCallback;break;
case 1:f=s->dma[d].XferHalfCpltCallback;break;
case 2:f=s->dma[d].XferErrorCallback;break;
case 3:f=s->dma[d].XferAbortCallback;break;
default:assert(0);break;}for(uint32_t k=0;k<=6;k++)if(f==DMAPointer(k))return k;assert(0);return 0;}
void F_JOIN(F_VARIANT,_SetDMA)(CSAIState *s,uint32_t d,uint32_t id,uint32_t v){switch(id){
case 0:s->dma[d].XferCpltCallback=DMAPointer(v);break;
case 1:s->dma[d].XferHalfCpltCallback=DMAPointer(v);break;
case 2:s->dma[d].XferErrorCallback=DMAPointer(v);break;
case 3:s->dma[d].XferAbortCallback=DMAPointer(v);break;
default:assert(0);break;}}
uint32_t F_JOIN(F_VARIANT,_Run)(CSAIState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){
uint8_t *data=s->control[13]?NULL:(uint8_t *)s->buffers[0]+s->control[14];
uint8_t *rx=s->control[15]?NULL:(uint8_t *)s->buffers[1]+s->control[16];
SAIEx_PdmMicDelayParamTypeDef delay={s->control[30],s->control[31],s->control[32]};
switch(op){
case 0:return HAL_SAI_InitProtocol(&s->h,a,b,c);
case 1:return HAL_SAI_Init(&s->h);
case 2:return HAL_SAI_DeInit(&s->h);
#if F_MODE
case 3:return HAL_SAI_RegisterCallback(&s->h,(HAL_SAI_CallbackIDTypeDef)a,(pSAI_CallbackTypeDef)CSAI_Callback(a<7?a:0,b));
#endif
#if F_MODE
case 4:return HAL_SAI_UnRegisterCallback(&s->h,(HAL_SAI_CallbackIDTypeDef)a);
#endif
case 5:return HAL_SAI_Transmit(&s->h,data,a,b);
case 6:return HAL_SAI_Receive(&s->h,data,a,b);
case 7:return HAL_SAI_Transmit_IT(&s->h,data,a);
case 8:return HAL_SAI_Receive_IT(&s->h,data,a);
case 9:return HAL_SAI_DMAPause(&s->h);
case 10:return HAL_SAI_DMAResume(&s->h);
case 11:return HAL_SAI_DMAStop(&s->h);
case 12:return HAL_SAI_Abort(&s->h);
case 13:return HAL_SAI_Transmit_DMA(&s->h,data,a);
case 14:return HAL_SAI_Receive_DMA(&s->h,data,a);
case 15:return HAL_SAI_EnableTxMuteMode(&s->h,(uint16_t)a);
case 16:return HAL_SAI_DisableTxMuteMode(&s->h);
case 17:return HAL_SAI_EnableRxMuteMode(&s->h,(SAIcallback)CSAI_Callback(7,b),(uint16_t)a);
case 18:return HAL_SAI_DisableRxMuteMode(&s->h);
case 19:HAL_SAI_IRQHandler(&s->h);return 0;
case 20:return HAL_SAI_GetState(&s->h);
case 21:return HAL_SAI_GetError(&s->h);
case 22:return SAI_InitI2S(&s->h,a,b,c);
case 23:return SAI_InitPCM(&s->h,a,b,c);
case 24:SAI_FillFifo(&s->h);return 0;
case 25:return SAI_InterruptFlag(&s->h,(SAI_ModeTypedef)a);
case 26:return SAI_Disable(&s->h);
case 27:SAI_Transmit_IT8Bit(&s->h);return 0;
case 28:SAI_Transmit_IT16Bit(&s->h);return 0;
case 29:SAI_Transmit_IT32Bit(&s->h);return 0;
case 30:SAI_Receive_IT8Bit(&s->h);return 0;
case 31:SAI_Receive_IT16Bit(&s->h);return 0;
case 32:SAI_Receive_IT32Bit(&s->h);return 0;
case 33:SAI_DMATxCplt(&s->dma[a&1]);return 0;
case 34:SAI_DMATxHalfCplt(&s->dma[a&1]);return 0;
case 35:SAI_DMARxCplt(&s->dma[a&1]);return 0;
case 36:SAI_DMARxHalfCplt(&s->dma[a&1]);return 0;
case 37:SAI_DMAError(&s->dma[a&1]);return 0;
case 38:SAI_DMAAbort(&s->dma[a&1]);return 0;
case 39:return HAL_SAIEx_ConfigPdmMicDelay(&s->h,&delay);
default:assert(0);return 0;}}
