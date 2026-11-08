#include "XSPIPrototypes.h"
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#endif
static void (*ISRPointer(uint32_t i))(XSPI_HandleTypeDef *){switch(i){case 0:return NULL;
default:assert(0);return NULL;}}
uint32_t F_JOIN(F_VARIANT,_GetWord)(CXSPIState *s,uint32_t i){switch(i){
case 0:return s->h.Init.FifoThresholdByte;
case 1:return s->h.Init.MemoryMode;
case 2:return s->h.Init.MemoryType;
case 3:return s->h.Init.MemorySize;
case 4:return s->h.Init.ChipSelectHighTimeCycle;
case 5:return s->h.Init.FreeRunningClock;
case 6:return s->h.Init.ClockMode;
case 7:return s->h.Init.WrapSize;
case 8:return s->h.Init.ClockPrescaler;
case 9:return s->h.Init.SampleShifting;
case 10:return s->h.Init.DelayHoldQuarterCycle;
case 11:return s->h.Init.ChipSelectBoundary;
case 12:return s->h.Init.MaxTran;
case 13:return s->h.Init.Refresh;
case 14:return s->h.Init.MemorySelect;
case 15:return s->h.XferSize;
case 16:return s->h.XferCount;
case 17:return s->h.State;
case 18:return s->h.ErrorCode;
case 19:return s->h.Timeout;
default:assert(0);return 0;}}
void F_JOIN(F_VARIANT,_SetWord)(CXSPIState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->h.Init.FifoThresholdByte=v;break;
case 1:s->h.Init.MemoryMode=v;break;
case 2:s->h.Init.MemoryType=v;break;
case 3:s->h.Init.MemorySize=v;break;
case 4:s->h.Init.ChipSelectHighTimeCycle=v;break;
case 5:s->h.Init.FreeRunningClock=v;break;
case 6:s->h.Init.ClockMode=v;break;
case 7:s->h.Init.WrapSize=v;break;
case 8:s->h.Init.ClockPrescaler=v;break;
case 9:s->h.Init.SampleShifting=v;break;
case 10:s->h.Init.DelayHoldQuarterCycle=v;break;
case 11:s->h.Init.ChipSelectBoundary=v;break;
case 12:s->h.Init.MaxTran=v;break;
case 13:s->h.Init.Refresh=v;break;
case 14:s->h.Init.MemorySelect=v;break;
case 15:s->h.XferSize=v;break;
case 16:s->h.XferCount=v;break;
case 17:s->h.State=v;break;
case 18:s->h.ErrorCode=v;break;
case 19:s->h.Timeout=v;break;
default:assert(0);break;}}
static void (*DMAPointer(uint32_t i))(DMA_HandleTypeDef *){switch(i){case 0:return NULL;
case 1:return XSPI_DMACplt;
case 2:return XSPI_DMAHalfCplt;
case 3:return XSPI_DMAError;
case 4:return XSPI_DMAAbortCplt;
default:assert(0);return NULL;}}
uint32_t F_JOIN(F_VARIANT,_GetDMA)(CXSPIState *s,uint32_t d,uint32_t id){void (*f)(DMA_HandleTypeDef *)=NULL;switch(id){
case 0:f=s->dma[d].XferCpltCallback;break;
case 1:f=s->dma[d].XferHalfCpltCallback;break;
case 2:f=s->dma[d].XferErrorCallback;break;
case 3:f=s->dma[d].XferAbortCallback;break;
default:assert(0);break;}for(uint32_t k=0;k<=4;k++)if(f==DMAPointer(k))return k;assert(0);return 0;}
void F_JOIN(F_VARIANT,_SetDMA)(CXSPIState *s,uint32_t d,uint32_t id,uint32_t v){switch(id){
case 0:s->dma[d].XferCpltCallback=DMAPointer(v);break;
case 1:s->dma[d].XferHalfCpltCallback=DMAPointer(v);break;
case 2:s->dma[d].XferErrorCallback=DMAPointer(v);break;
case 3:s->dma[d].XferAbortCallback=DMAPointer(v);break;
default:assert(0);break;}}
uint32_t F_JOIN(F_VARIANT,_Run)(CXSPIState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){
uint8_t *data=s->control[13]?NULL:(uint8_t *)s->buffers[0]+s->control[14];
uint8_t *rx=s->control[15]?NULL:(uint8_t *)s->buffers[1]+s->control[16];
switch(op){
case 0:return HAL_XSPI_Init(&s->h);
case 1:return HAL_XSPI_DeInit(&s->h);
case 2:HAL_XSPI_IRQHandler(&s->h);return 0;
case 3:return HAL_XSPI_Command(&s->h,(const void *)&s->global[1],b);
case 4:return HAL_XSPI_Command_IT(&s->h,(const void *)&s->global[1]);
case 5:return HAL_XSPI_HyperbusCfg(&s->h,(void *)&s->global[1],b);
case 6:return HAL_XSPI_HyperbusCmd(&s->h,(const void *)&s->global[1],b);
case 7:return HAL_XSPI_Transmit(&s->h,data,b);
case 8:return HAL_XSPI_Receive(&s->h,data,b);
case 9:return HAL_XSPI_Transmit_IT(&s->h,data);
case 10:return HAL_XSPI_Receive_IT(&s->h,data);
case 11:return HAL_XSPI_Transmit_DMA(&s->h,data);
case 12:return HAL_XSPI_Receive_DMA(&s->h,data);
case 13:return HAL_XSPI_AutoPolling(&s->h,(void *)&s->global[1],b);
case 14:return HAL_XSPI_AutoPolling_IT(&s->h,(void *)&s->global[1]);
case 15:return HAL_XSPI_MemoryMapped(&s->h,(void *)&s->global[1]);
case 16:return HAL_XSPI_IsMemoryMapped(&s->h);
#if F_MODE
case 17:return HAL_XSPI_RegisterCallback(&s->h,(HAL_XSPI_CallbackIDTypeDef)a,(pXSPI_CallbackTypeDef)CXSPI_Callback(a<12?a:0,b));
#endif
#if F_MODE
case 18:return HAL_XSPI_UnRegisterCallback(&s->h,(HAL_XSPI_CallbackIDTypeDef)a);
#endif
case 19:return HAL_XSPI_Abort(&s->h);
case 20:return HAL_XSPI_Abort_IT(&s->h);
case 21:return HAL_XSPI_SetFifoThreshold(&s->h,a);
case 22:return HAL_XSPI_GetFifoThreshold(&s->h);
case 23:return HAL_XSPI_SetMemoryType(&s->h,a);
case 24:return HAL_XSPI_SetDeviceSize(&s->h,a);
case 25:return HAL_XSPI_SetClockPrescaler(&s->h,a);
case 26:return HAL_XSPI_SetTimeout(&s->h,b);
case 27:return HAL_XSPI_GetError(&s->h);
case 28:return HAL_XSPI_GetState(&s->h);
case 29:return HAL_XSPIM_Config(&s->h,(void *)&s->global[1],b);
case 30:return HAL_XSPI_GetDelayValue(&s->h,(void *)&s->global[1]);
case 31:return HAL_XSPI_SetDelayValue(&s->h,(void *)&s->global[1]);
case 32:XSPI_DMACplt(&s->dma[a&1]);return 0;
case 33:XSPI_DMAHalfCplt(&s->dma[a&1]);return 0;
case 34:XSPI_DMAError(&s->dma[a&1]);return 0;
case 35:XSPI_DMAAbortCplt(&s->dma[a&1]);return 0;
case 36:return XSPI_WaitFlagStateUntilTimeout(&s->h,a,(FlagStatus)b,c,s->control[18]);
case 37:return XSPI_ConfigCmd(&s->h,(const void *)&s->global[1]);
case 38:XSPIM_GetConfig((uint8_t)a,(void *)&s->global[1]);return 0;
case 39:HAL_XSPI_ENABLE(&s->h);return 0;
case 40:HAL_XSPI_DISABLE(&s->h);return 0;
case 41:HAL_XSPI_ENABLE_IT(&s->h,a);return 0;
case 42:HAL_XSPI_DISABLE_IT(&s->h,a);return 0;
case 43:return HAL_XSPI_GET_FLAG(&s->h,a);
case 44:return HAL_XSPI_GET_IT_SOURCE(&s->h,a);
case 45:HAL_XSPI_CLEAR_FLAG(&s->h,a);return 0;
case 46:s->h.State=HAL_XSPI_STATE_RESET;
#if F_MODE
s->h.MspInitCallback=NULL;s->h.MspDeInitCallback=NULL;
#endif
return 0;
default:assert(0);return 0;}}
