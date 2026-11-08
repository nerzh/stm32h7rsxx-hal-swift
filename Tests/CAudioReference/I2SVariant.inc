#include "I2SPrototypes.h"
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#endif
static void (*ISRPointer(uint32_t i))(I2S_HandleTypeDef *){switch(i){case 0:return NULL;
case 1:return I2S_Transmit_16Bit_IT;
case 2:return I2S_Transmit_32Bit_IT;
case 3:return I2S_Receive_16Bit_IT;
case 4:return I2S_Receive_32Bit_IT;
default:assert(0);return NULL;}}
uint32_t F_JOIN(F_VARIANT,_GetWord)(CI2SState *s,uint32_t i){switch(i){
case 0:return s->h.Init.Mode;
case 1:return s->h.Init.Standard;
case 2:return s->h.Init.DataFormat;
case 3:return s->h.Init.MCLKOutput;
case 4:return s->h.Init.AudioFreq;
case 5:return s->h.Init.CPOL;
case 6:return s->h.Init.FirstBit;
case 7:return s->h.Init.WSInversion;
case 8:return s->h.Init.Data24BitAlignment;
case 9:return s->h.Init.MasterKeepIOState;
case 10:return s->h.TxXferSize;
case 11:return s->h.TxXferCount;
case 12:return s->h.RxXferSize;
case 13:return s->h.RxXferCount;
case 14:for(uint32_t k=0;k<=4;k++)if(s->h.RxISR==ISRPointer(k))return k;assert(0);return 0;
case 15:for(uint32_t k=0;k<=4;k++)if(s->h.TxISR==ISRPointer(k))return k;assert(0);return 0;
case 16:return s->h.Lock;
case 17:return s->h.State;
case 18:return s->h.ErrorCode;
default:assert(0);return 0;}}
void F_JOIN(F_VARIANT,_SetWord)(CI2SState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->h.Init.Mode=v;break;
case 1:s->h.Init.Standard=v;break;
case 2:s->h.Init.DataFormat=v;break;
case 3:s->h.Init.MCLKOutput=v;break;
case 4:s->h.Init.AudioFreq=v;break;
case 5:s->h.Init.CPOL=v;break;
case 6:s->h.Init.FirstBit=v;break;
case 7:s->h.Init.WSInversion=v;break;
case 8:s->h.Init.Data24BitAlignment=v;break;
case 9:s->h.Init.MasterKeepIOState=v;break;
case 10:s->h.TxXferSize=v;break;
case 11:s->h.TxXferCount=v;break;
case 12:s->h.RxXferSize=v;break;
case 13:s->h.RxXferCount=v;break;
case 14:s->h.RxISR=ISRPointer(v);break;
case 15:s->h.TxISR=ISRPointer(v);break;
case 16:s->h.Lock=v;break;
case 17:s->h.State=v;break;
case 18:s->h.ErrorCode=v;break;
default:assert(0);break;}}
static void (*DMAPointer(uint32_t i))(DMA_HandleTypeDef *){switch(i){case 0:return NULL;
case 1:return I2S_DMATxCplt;
case 2:return I2S_DMATxHalfCplt;
case 3:return I2S_DMARxCplt;
case 4:return I2S_DMARxHalfCplt;
case 5:return I2SEx_DMATxRxCplt;
case 6:return I2SEx_DMATxRxHalfCplt;
case 7:return I2S_DMAError;
default:assert(0);return NULL;}}
uint32_t F_JOIN(F_VARIANT,_GetDMA)(CI2SState *s,uint32_t d,uint32_t id){void (*f)(DMA_HandleTypeDef *)=NULL;switch(id){
case 0:f=s->dma[d].XferCpltCallback;break;
case 1:f=s->dma[d].XferHalfCpltCallback;break;
case 2:f=s->dma[d].XferErrorCallback;break;
case 3:f=s->dma[d].XferAbortCallback;break;
default:assert(0);break;}for(uint32_t k=0;k<=7;k++)if(f==DMAPointer(k))return k;assert(0);return 0;}
void F_JOIN(F_VARIANT,_SetDMA)(CI2SState *s,uint32_t d,uint32_t id,uint32_t v){switch(id){
case 0:s->dma[d].XferCpltCallback=DMAPointer(v);break;
case 1:s->dma[d].XferHalfCpltCallback=DMAPointer(v);break;
case 2:s->dma[d].XferErrorCallback=DMAPointer(v);break;
case 3:s->dma[d].XferAbortCallback=DMAPointer(v);break;
default:assert(0);break;}}
uint32_t F_JOIN(F_VARIANT,_Run)(CI2SState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){
uint8_t *data=s->control[13]?NULL:(uint8_t *)s->buffers[0]+s->control[14];
uint8_t *rx=s->control[15]?NULL:(uint8_t *)s->buffers[1]+s->control[16];
switch(op){
case 0:return HAL_I2S_Init(&s->h);
case 1:return HAL_I2S_DeInit(&s->h);
#if F_MODE
case 2:return HAL_I2S_RegisterCallback(&s->h,(HAL_I2S_CallbackIDTypeDef)a,(pI2S_CallbackTypeDef)CI2S_Callback(a<9?a:0,b));
#endif
#if F_MODE
case 3:return HAL_I2S_UnRegisterCallback(&s->h,(HAL_I2S_CallbackIDTypeDef)a);
#endif
case 4:return HAL_I2S_Transmit(&s->h,(uint16_t *)data,a,b);
case 5:return HAL_I2S_Receive(&s->h,(uint16_t *)data,a,b);
case 6:return HAL_I2SEx_TransmitReceive(&s->h,(uint16_t *)data,(uint16_t *)rx,a,b);
case 7:return HAL_I2S_Transmit_IT(&s->h,(uint16_t *)data,a);
case 8:return HAL_I2S_Receive_IT(&s->h,(uint16_t *)data,a);
case 9:return HAL_I2SEx_TransmitReceive_IT(&s->h,(uint16_t *)data,(uint16_t *)rx,a);
case 10:return HAL_I2S_Transmit_DMA(&s->h,(uint16_t *)data,a);
case 11:return HAL_I2S_Receive_DMA(&s->h,(uint16_t *)data,a);
case 12:return HAL_I2SEx_TransmitReceive_DMA(&s->h,(uint16_t *)data,(uint16_t *)rx,a);
case 13:return HAL_I2S_DMAPause(&s->h);
case 14:return HAL_I2S_DMAResume(&s->h);
case 15:return HAL_I2S_DMAStop(&s->h);
case 16:return HAL_I2S_EnableIOSwap(&s->h);
case 17:return HAL_I2S_DisableIOSwap(&s->h);
case 18:return HAL_I2S_IsEnabledIOSwap(&s->h);
case 19:HAL_I2S_IRQHandler(&s->h);return 0;
case 20:return HAL_I2S_GetState(&s->h);
case 21:return HAL_I2S_GetError(&s->h);
case 22:I2S_DMATxCplt(&s->dma[a&1]);return 0;
case 23:I2S_DMATxHalfCplt(&s->dma[a&1]);return 0;
case 24:I2S_DMARxCplt(&s->dma[a&1]);return 0;
case 25:I2S_DMARxHalfCplt(&s->dma[a&1]);return 0;
case 26:I2SEx_DMATxRxCplt(&s->dma[a&1]);return 0;
case 27:I2SEx_DMATxRxHalfCplt(&s->dma[a&1]);return 0;
case 28:I2S_DMAError(&s->dma[a&1]);return 0;
case 29:I2S_Transmit_16Bit_IT(&s->h);return 0;
case 30:I2S_Transmit_32Bit_IT(&s->h);return 0;
case 31:I2S_Receive_16Bit_IT(&s->h);return 0;
case 32:I2S_Receive_32Bit_IT(&s->h);return 0;
case 33:return I2S_WaitFlagStateUntilTimeout(&s->h,a,(FlagStatus)b,s->control[18],b);
default:assert(0);return 0;}}
