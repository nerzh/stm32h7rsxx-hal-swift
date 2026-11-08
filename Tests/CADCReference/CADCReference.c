#include "ADCInternal.h"
CADCState *CADC_Active;
ADC_TypeDef *CADC_ADC1,*CADC_ADC2;
ADC_Common_TypeDef *CADC_Common;
uint32_t SystemCoreClock;
size_t CADC_Size(void) { return sizeof(CADCState); }
void CADC_Activate(CADCState *s) {
 CADC_Active=s;CADC_ADC1=&s->regs[0];CADC_ADC2=&s->regs[1];CADC_Common=&s->common;SystemCoreClock=s->control[11];
}
uint32_t CADC_Get(CADCState *s,uint32_t area,uint32_t i) {
 switch(area) {
 case 0:assert(i<102);return ((volatile uint32_t *)s->regs)[i];
 case 1:assert(i<4);return ((volatile uint32_t *)&s->common)[i];
 case 2:switch(i) {
case 0:return s->h.Init.ClockPrescaler;
case 1:return s->h.Init.Resolution;
case 2:return s->h.Init.DataAlign;
case 3:return s->h.Init.ScanConvMode;
case 4:return s->h.Init.EOCSelection;
case 5:return s->h.Init.LowPowerAutoWait;
case 6:return s->h.Init.ContinuousConvMode;
case 7:return s->h.Init.NbrOfConversion;
case 8:return s->h.Init.DiscontinuousConvMode;
case 9:return s->h.Init.NbrOfDiscConversion;
case 10:return s->h.Init.ExternalTrigConv;
case 11:return s->h.Init.ExternalTrigConvEdge;
case 12:return s->h.Init.SamplingMode;
case 13:return s->h.Init.ConversionDataManagement;
case 14:return s->h.Init.Overrun;
case 15:return s->h.Init.OversamplingMode;
case 16:return s->h.Init.Oversampling.Ratio;
case 17:return s->h.Init.Oversampling.RightBitShift;
case 18:return s->h.Init.Oversampling.TriggeredMode;
case 19:return s->h.Init.Oversampling.OversamplingStopReset;
case 20:return s->h.Lock;
case 21:return s->h.State;
case 22:return s->h.ErrorCode;
case 23:return s->h.InjectionConfig.ContextQueue;
case 24:return s->h.InjectionConfig.ChannelCount;
default:assert(0);return 0;}
 case 3:assert(i<60);return s->params[i/20][i%20];
 case 4:assert(i<16);return s->control[i];
 case 5:switch(i) {case 0:return s->tick;case 1:return s->tickCalls;case 2:return s->instance;case 3:return s->traceCount;case 4:return s->calibrationReads;default:assert(0);return 0;}
 case 6:switch(i) {case 0:return s->dma.Init.SrcDataWidth;case 1:return s->dma.Mode;case 2:return s->dma.State;case 3:return s->dma.LinkedListQueue!=NULL;case 4:return s->queue.Head!=NULL;case 5:return s->nodeWidth;default:assert(i<14);return s->node.LinkRegisters[i-6];}
 case 7:assert(i<512);return s->trace[i/16][i%16];
 default:assert(0);return 0;
 }
}
void CADC_Set(CADCState *s,uint32_t area,uint32_t i,uint32_t v) {
 switch(area) {
 case 0:assert(i<102);((volatile uint32_t *)s->regs)[i]=v;break;
 case 1:assert(i<4);((volatile uint32_t *)&s->common)[i]=v;break;
 case 2:switch(i) {
case 0:s->h.Init.ClockPrescaler=v;break;
case 1:s->h.Init.Resolution=v;break;
case 2:s->h.Init.DataAlign=v;break;
case 3:s->h.Init.ScanConvMode=v;break;
case 4:s->h.Init.EOCSelection=v;break;
case 5:s->h.Init.LowPowerAutoWait=v;break;
case 6:s->h.Init.ContinuousConvMode=v;break;
case 7:s->h.Init.NbrOfConversion=v;break;
case 8:s->h.Init.DiscontinuousConvMode=v;break;
case 9:s->h.Init.NbrOfDiscConversion=v;break;
case 10:s->h.Init.ExternalTrigConv=v;break;
case 11:s->h.Init.ExternalTrigConvEdge=v;break;
case 12:s->h.Init.SamplingMode=v;break;
case 13:s->h.Init.ConversionDataManagement=v;break;
case 14:s->h.Init.Overrun=v;break;
case 15:s->h.Init.OversamplingMode=v;break;
case 16:s->h.Init.Oversampling.Ratio=v;break;
case 17:s->h.Init.Oversampling.RightBitShift=v;break;
case 18:s->h.Init.Oversampling.TriggeredMode=v;break;
case 19:s->h.Init.Oversampling.OversamplingStopReset=v;break;
case 20:s->h.Lock=v;break;
case 21:s->h.State=v;break;
case 22:s->h.ErrorCode=v;break;
case 23:s->h.InjectionConfig.ContextQueue=v;break;
case 24:s->h.InjectionConfig.ChannelCount=v;break;
default:assert(0);}break;
 case 3:assert(i<60);s->params[i/20][i%20]=v;break;
 case 4:assert(i<16);s->control[i]=v;break;
 case 5:switch(i) {case 0:s->tick=v;break;case 1:s->tickCalls=v;break;case 2:assert(v<2);s->instance=v;s->h.Instance=&s->regs[v];break;case 3:s->traceCount=v;break;case 4:s->calibrationReads=v;break;default:assert(0);}break;
 case 6:switch(i) {case 0:s->dma.Init.SrcDataWidth=v;break;case 1:s->dma.Mode=v;break;case 2:s->dma.State=v;break;case 3:s->dma.LinkedListQueue=v?&s->queue:NULL;break;case 4:s->queue.Head=v?&s->node:NULL;break;case 5:s->nodeWidth=v;break;default:assert(i<14);s->node.LinkRegisters[i-6]=v;break;}break;
 default:assert(0);
 }
}
void CADC_Reset(CADCState *s,uint32_t mode,uint32_t instance) {
 memset(s,0,sizeof(*s));s->mode=mode;s->instance=instance;s->h.Instance=&s->regs[instance];
 s->h.State=HAL_ADC_STATE_READY;s->h.Init.NbrOfConversion=1;s->h.Init.NbrOfDiscConversion=1;
 s->h.Init.EOCSelection=ADC_EOC_SINGLE_CONV;s->h.Init.ExternalTrigConv=ADC_SOFTWARE_START;
 s->control[0]=3;s->control[11]=64000000;s->regs[instance].ISR=1;s->regs[instance].CFGR=ADC_CFGR_JQDIS;
 s->dma.Parent=&s->h;s->dma.LinkedListQueue=&s->queue;s->queue.Head=&s->node;s->dma.Init.SrcDataWidth=2;s->nodeWidth=2;
 s->h.DMA_Handle=&s->dma;
 for(uint32_t i=0;i<11;i++)CADC_SetCallback(s,i,1);
 for(uint32_t i=0;i<3;i++)CADC_SetDMACallback(s,i,1);
 CADC_Activate(s);
}
uint32_t CADC_TickFor(CADCState *s) {
 s->tick+=s->control[0];s->tickCalls++;
 if(s->control[1] && s->tickCalls==s->control[1]) {
  s->regs[s->instance].ISR|=s->control[2];s->regs[s->instance].CR&=~s->control[3];
  s->regs[s->instance].CR|=s->control[4];s->regs[1-s->instance].CR&=~s->control[5];
 }
 assert(s->tickCalls<10000);return s->tick;
}
uint32_t CADC_Tick(void) { return CADC_TickFor(CADC_Active); }
static uint32_t calibrationRead(CADCState *s,volatile uint32_t *r) {
 if(s->control[10] && (*r & ADC_CR_ADCAL)) {
  s->calibrationReads++;if(s->calibrationReads==s->control[10])*r&=~ADC_CR_ADCAL;
 }
 return *r;
}
uint32_t CADC_ReadBits(const volatile uint32_t *r,uint32_t bits) {
 if(CADC_Active && bits==ADC_CR_ADCAL && r==&CADC_Active->h.Instance->CR)
  return calibrationRead(CADC_Active,(volatile uint32_t *)r)&bits;
 return *r&bits;
}
uint32_t CADC_ReadRegister(CADCState *s,uint32_t instance,uint32_t offset) {
 volatile uint32_t *r=(volatile uint32_t *)((uintptr_t)&s->regs[instance]+offset);
 if(offset==8 && instance==s->instance && s->control[10])return calibrationRead(s,r);
 return *r;
}
static void trace(CADCState *s,uint32_t id,uint32_t token) {
 assert(s->traceCount<32);uint32_t *t=s->trace[s->traceCount++];t[0]=id;t[1]=token;
 t[2]=s->h.State;t[3]=s->h.ErrorCode;t[4]=s->h.Lock;
 t[5]=s->h.Instance->ISR;t[6]=s->h.Instance->IER;t[7]=s->h.Instance->CR;t[8]=s->h.Instance->CFGR;
 t[9]=s->common.CCR;t[10]=s->tick;t[11]=s->tickCalls;
 t[12]=s->h.InjectionConfig.ContextQueue;t[13]=s->h.InjectionConfig.ChannelCount;
}
void CADC_Callback(CADCState *s,uint32_t id,uint32_t token) {
 trace(s,id,token);
 if(s->control[6]&1U) {s->h.Instance->ISR=0;s->h.State|=HAL_ADC_STATE_ERROR_INTERNAL;}
 if(s->control[6]&2U)CADC_SetCallback(s,0,2);
}
uint32_t CADC_DMADataAddress(CADCState *s,uint32_t common) {
 return (uint32_t)(uintptr_t)(common?&s->common.CDR:&s->h.Instance->DR);
}
uint32_t CADC_DMAAction(CADCState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 trace(s,20+op,0);uint32_t *t=s->trace[s->traceCount-1];t[13]=a;t[14]=b;t[15]=c;
 switch(op) {case 0:case 1:return s->control[7];case 2:return s->control[8];case 3:return s->control[9];default:return 0;}
}
HAL_StatusTypeDef HAL_DMA_Start_IT(DMA_HandleTypeDef *h,uint32_t a,uint32_t b,uint32_t c) {
 (void)h;return (HAL_StatusTypeDef)CADC_DMAAction(CADC_Active,0,a,b,c);
}
HAL_StatusTypeDef HAL_DMAEx_List_Start_IT(DMA_HandleTypeDef *h) {
 (void)h;return (HAL_StatusTypeDef)CADC_DMAAction(CADC_Active,1,0,0,0);
}
HAL_StatusTypeDef HAL_DMAEx_List_GetNodeConfig(DMA_NodeConfTypeDef *c,DMA_NodeTypeDef *n) {
 (void)n;uint32_t status=CADC_DMAAction(CADC_Active,3,0,0,0);if(!status)c->Init.SrcDataWidth=CADC_Active->nodeWidth;return (HAL_StatusTypeDef)status;
}
HAL_StatusTypeDef HAL_DMA_Abort(DMA_HandleTypeDef *h) {
 (void)h;return (HAL_StatusTypeDef)CADC_DMAAction(CADC_Active,2,0,0,0);
}
uint32_t CADC_Run(CADCState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 CADC_Activate(s);return s->mode?CADC1_Run(s,op,a,b,c):CADC0_Run(s,op,a,b,c);
}
