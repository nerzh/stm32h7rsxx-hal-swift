#include "SPIPrototypes.h"
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#endif
static void (*ISRPointer(uint32_t i))(SPI_HandleTypeDef *){switch(i){case 0:return NULL;
case 1:return SPI_TxISR_8BIT;
case 2:return SPI_TxISR_16BIT;
case 3:return SPI_TxISR_32BIT;
case 4:return SPI_RxISR_8BIT;
case 5:return SPI_RxISR_16BIT;
case 6:return SPI_RxISR_32BIT;
default:assert(0);return NULL;}}
uint32_t F_JOIN(F_VARIANT,_GetWord)(CSPIState *s,uint32_t i){switch(i){
case 0:return s->h.Init.Mode;
case 1:return s->h.Init.Direction;
case 2:return s->h.Init.DataSize;
case 3:return s->h.Init.CLKPolarity;
case 4:return s->h.Init.CLKPhase;
case 5:return s->h.Init.NSS;
case 6:return s->h.Init.BaudRatePrescaler;
case 7:return s->h.Init.FirstBit;
case 8:return s->h.Init.TIMode;
case 9:return s->h.Init.CRCCalculation;
case 10:return s->h.Init.CRCPolynomial;
case 11:return s->h.Init.CRCLength;
case 12:return s->h.Init.NSSPMode;
case 13:return s->h.Init.NSSPolarity;
case 14:return s->h.Init.FifoThreshold;
case 15:return s->h.Init.TxCRCInitializationPattern;
case 16:return s->h.Init.RxCRCInitializationPattern;
case 17:return s->h.Init.MasterSSIdleness;
case 18:return s->h.Init.MasterInterDataIdleness;
case 19:return s->h.Init.MasterReceiverAutoSusp;
case 20:return s->h.Init.MasterKeepIOState;
case 21:return s->h.Init.IOSwap;
case 22:return s->h.Init.ReadyMasterManagement;
case 23:return s->h.Init.ReadyPolarity;
case 24:return s->h.TxXferSize;
case 25:return s->h.TxXferCount;
case 26:return s->h.RxXferSize;
case 27:return s->h.RxXferCount;
case 28:return s->h.CRCSize;
case 29:for(uint32_t k=0;k<=6;k++)if(s->h.RxISR==ISRPointer(k))return k;assert(0);return 0;
case 30:for(uint32_t k=0;k<=6;k++)if(s->h.TxISR==ISRPointer(k))return k;assert(0);return 0;
case 31:return s->h.Lock;
case 32:return s->h.State;
case 33:return s->h.ErrorCode;
default:assert(0);return 0;}}
void F_JOIN(F_VARIANT,_SetWord)(CSPIState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->h.Init.Mode=v;break;
case 1:s->h.Init.Direction=v;break;
case 2:s->h.Init.DataSize=v;break;
case 3:s->h.Init.CLKPolarity=v;break;
case 4:s->h.Init.CLKPhase=v;break;
case 5:s->h.Init.NSS=v;break;
case 6:s->h.Init.BaudRatePrescaler=v;break;
case 7:s->h.Init.FirstBit=v;break;
case 8:s->h.Init.TIMode=v;break;
case 9:s->h.Init.CRCCalculation=v;break;
case 10:s->h.Init.CRCPolynomial=v;break;
case 11:s->h.Init.CRCLength=v;break;
case 12:s->h.Init.NSSPMode=v;break;
case 13:s->h.Init.NSSPolarity=v;break;
case 14:s->h.Init.FifoThreshold=v;break;
case 15:s->h.Init.TxCRCInitializationPattern=v;break;
case 16:s->h.Init.RxCRCInitializationPattern=v;break;
case 17:s->h.Init.MasterSSIdleness=v;break;
case 18:s->h.Init.MasterInterDataIdleness=v;break;
case 19:s->h.Init.MasterReceiverAutoSusp=v;break;
case 20:s->h.Init.MasterKeepIOState=v;break;
case 21:s->h.Init.IOSwap=v;break;
case 22:s->h.Init.ReadyMasterManagement=v;break;
case 23:s->h.Init.ReadyPolarity=v;break;
case 24:s->h.TxXferSize=v;break;
case 25:s->h.TxXferCount=v;break;
case 26:s->h.RxXferSize=v;break;
case 27:s->h.RxXferCount=v;break;
case 28:s->h.CRCSize=v;break;
case 29:s->h.RxISR=ISRPointer(v);break;
case 30:s->h.TxISR=ISRPointer(v);break;
case 31:s->h.Lock=v;break;
case 32:s->h.State=v;break;
case 33:s->h.ErrorCode=v;break;
default:assert(0);break;}}
static void (*DMAPointer(uint32_t i))(DMA_HandleTypeDef *){switch(i){case 0:return NULL;
case 1:return SPI_DMATransmitCplt;
case 2:return SPI_DMAReceiveCplt;
case 3:return SPI_DMATransmitReceiveCplt;
case 4:return SPI_DMAHalfTransmitCplt;
case 5:return SPI_DMAHalfReceiveCplt;
case 6:return SPI_DMAHalfTransmitReceiveCplt;
case 7:return SPI_DMAError;
case 8:return SPI_DMAAbortOnError;
case 9:return SPI_DMATxAbortCallback;
case 10:return SPI_DMARxAbortCallback;
default:assert(0);return NULL;}}
uint32_t F_JOIN(F_VARIANT,_GetDMA)(CSPIState *s,uint32_t d,uint32_t id){void (*f)(DMA_HandleTypeDef *)=NULL;switch(id){
case 0:f=s->dma[d].XferCpltCallback;break;
case 1:f=s->dma[d].XferHalfCpltCallback;break;
case 2:f=s->dma[d].XferErrorCallback;break;
case 3:f=s->dma[d].XferAbortCallback;break;
default:assert(0);break;}for(uint32_t k=0;k<=10;k++)if(f==DMAPointer(k))return k;assert(0);return 0;}
void F_JOIN(F_VARIANT,_SetDMA)(CSPIState *s,uint32_t d,uint32_t id,uint32_t v){switch(id){
case 0:s->dma[d].XferCpltCallback=DMAPointer(v);break;
case 1:s->dma[d].XferHalfCpltCallback=DMAPointer(v);break;
case 2:s->dma[d].XferErrorCallback=DMAPointer(v);break;
case 3:s->dma[d].XferAbortCallback=DMAPointer(v);break;
default:assert(0);break;}}
uint32_t F_JOIN(F_VARIANT,_Run)(CSPIState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){
uint8_t *data=s->control[13]?NULL:(uint8_t *)s->buffers[0]+s->control[14];
uint8_t *rx=s->control[15]?NULL:(uint8_t *)s->buffers[1]+s->control[16];
switch(op){
case 0:return HAL_SPI_Init(&s->h);
case 1:return HAL_SPI_DeInit(&s->h);
#if F_MODE
case 2:return HAL_SPI_RegisterCallback(&s->h,(HAL_SPI_CallbackIDTypeDef)a,(pSPI_CallbackTypeDef)CSPI_Callback(a<11?a:0,b));
#endif
#if F_MODE
case 3:return HAL_SPI_UnRegisterCallback(&s->h,(HAL_SPI_CallbackIDTypeDef)a);
#endif
case 4:return HAL_SPI_Transmit(&s->h,data,a,b);
case 5:return HAL_SPI_Receive(&s->h,data,a,b);
case 6:return HAL_SPI_TransmitReceive(&s->h,data,rx,a,b);
case 7:return HAL_SPI_Transmit_IT(&s->h,data,a);
case 8:return HAL_SPI_Receive_IT(&s->h,data,a);
case 9:return HAL_SPI_TransmitReceive_IT(&s->h,data,rx,a);
case 10:return HAL_SPI_Transmit_DMA(&s->h,data,a);
case 11:return HAL_SPI_Receive_DMA(&s->h,data,a);
case 12:return HAL_SPI_TransmitReceive_DMA(&s->h,data,rx,a);
case 13:return HAL_SPI_Abort(&s->h);
case 14:return HAL_SPI_Abort_IT(&s->h);
case 15:return HAL_SPI_DMAPause(&s->h);
case 16:return HAL_SPI_DMAResume(&s->h);
case 17:return HAL_SPI_DMAStop(&s->h);
case 18:HAL_SPI_IRQHandler(&s->h);return 0;
case 19:return HAL_SPI_GetState(&s->h);
case 20:return HAL_SPI_GetError(&s->h);
case 21:SPI_DMATransmitCplt(&s->dma[a&1]);return 0;
case 22:SPI_DMAReceiveCplt(&s->dma[a&1]);return 0;
case 23:SPI_DMATransmitReceiveCplt(&s->dma[a&1]);return 0;
case 24:SPI_DMAHalfTransmitCplt(&s->dma[a&1]);return 0;
case 25:SPI_DMAHalfReceiveCplt(&s->dma[a&1]);return 0;
case 26:SPI_DMAHalfTransmitReceiveCplt(&s->dma[a&1]);return 0;
case 27:SPI_DMAError(&s->dma[a&1]);return 0;
case 28:SPI_DMAAbortOnError(&s->dma[a&1]);return 0;
case 29:SPI_DMATxAbortCallback(&s->dma[a&1]);return 0;
case 30:SPI_DMARxAbortCallback(&s->dma[a&1]);return 0;
case 31:SPI_RxISR_8BIT(&s->h);return 0;
case 32:SPI_RxISR_16BIT(&s->h);return 0;
case 33:SPI_RxISR_32BIT(&s->h);return 0;
case 34:SPI_TxISR_8BIT(&s->h);return 0;
case 35:SPI_TxISR_16BIT(&s->h);return 0;
case 36:SPI_TxISR_32BIT(&s->h);return 0;
case 37:SPI_AbortTransfer(&s->h);return 0;
case 38:SPI_CloseTransfer(&s->h);return 0;
case 39:return SPI_WaitOnFlagUntilTimeout(&s->h,a,(FlagStatus)b,c,s->control[18]);
case 40:return SPI_GetPacketSize(&s->h);
case 41:return HAL_SPIEx_FlushRxFifo(&s->h);
case 42:return HAL_SPIEx_EnableLockConfiguration(&s->h);
case 43:return HAL_SPIEx_ConfigureUnderrun(&s->h,a,b);
default:assert(0);return 0;}}
