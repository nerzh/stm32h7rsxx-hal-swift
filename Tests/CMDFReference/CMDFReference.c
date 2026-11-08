#include "MDFInternal.h"
CMDFState *CMDF_Active;
size_t CMDF_Size(void) { return sizeof(CMDFState); }
static uint32_t handleGet(CMDFState *s,uint32_t i) { switch(i) {case 0:return s->h.Init.CommonParam.ProcClockDivider;case 1:return s->h.Init.CommonParam.OutputClock.Activation;case 2:return s->h.Init.CommonParam.OutputClock.Pins;case 3:return s->h.Init.CommonParam.OutputClock.Divider;case 4:return s->h.Init.CommonParam.OutputClock.Trigger.Activation;case 5:return s->h.Init.CommonParam.OutputClock.Trigger.Source;case 6:return s->h.Init.CommonParam.OutputClock.Trigger.Edge;case 7:return s->h.Init.SerialInterface.Activation;case 8:return s->h.Init.SerialInterface.Mode;case 9:return s->h.Init.SerialInterface.ClockSource;case 10:return s->h.Init.SerialInterface.Threshold;case 11:return s->h.Init.FilterBistream;case 12:return s->h.State;case 13:return s->h.ErrorCode;default:assert(0);return 0;} }
static void handleSet(CMDFState *s,uint32_t i,uint32_t v) { switch(i) {case 0:s->h.Init.CommonParam.ProcClockDivider=v;break;case 1:s->h.Init.CommonParam.OutputClock.Activation=v;break;case 2:s->h.Init.CommonParam.OutputClock.Pins=v;break;case 3:s->h.Init.CommonParam.OutputClock.Divider=v;break;case 4:s->h.Init.CommonParam.OutputClock.Trigger.Activation=v;break;case 5:s->h.Init.CommonParam.OutputClock.Trigger.Source=v;break;case 6:s->h.Init.CommonParam.OutputClock.Trigger.Edge=v;break;case 7:s->h.Init.SerialInterface.Activation=v;break;case 8:s->h.Init.SerialInterface.Mode=v;break;case 9:s->h.Init.SerialInterface.ClockSource=v;break;case 10:s->h.Init.SerialInterface.Threshold=v;break;case 11:s->h.Init.FilterBistream=v;break;case 12:s->h.State=v;break;case 13:s->h.ErrorCode=v;break;default:assert(0);} }
static uint32_t filterGet(CMDFState *s,uint32_t i) { switch(i) {case 0:return s->config.DataSource;case 1:return s->config.Delay;case 2:return s->config.CicMode;case 3:return s->config.DecimationRatio;case 4:return s->config.Gain;case 5:return s->config.ReshapeFilter.Activation;case 6:return s->config.ReshapeFilter.DecimationRatio;case 7:return s->config.HighPassFilter.Activation;case 8:return s->config.HighPassFilter.CutOffFrequency;case 9:return s->config.SoundActivity.Activation;case 10:return s->config.SoundActivity.Mode;case 11:return s->config.SoundActivity.FrameSize;case 12:return s->config.SoundActivity.Hysteresis;case 13:return s->config.SoundActivity.SoundTriggerEvent;case 14:return s->config.SoundActivity.DataMemoryTransfer;case 15:return s->config.SoundActivity.MinNoiseLevel;case 16:return s->config.SoundActivity.HangoverWindow;case 17:return s->config.SoundActivity.LearningFrames;case 18:return s->config.SoundActivity.AmbientNoiseSlope;case 19:return s->config.SoundActivity.SignalNoiseThreshold;case 20:return s->config.SoundActivity.SoundLevelInterrupt;case 21:return s->config.AcquisitionMode;case 22:return s->config.FifoThreshold;case 23:return s->config.DiscardSamples;case 24:return s->config.Trigger.Source;case 25:return s->config.Trigger.Edge;default:assert(0);return 0;} }
static void filterSet(CMDFState *s,uint32_t i,uint32_t v) { switch(i) {case 0:s->config.DataSource=v;break;case 1:s->config.Delay=v;break;case 2:s->config.CicMode=v;break;case 3:s->config.DecimationRatio=v;break;case 4:s->config.Gain=v;break;case 5:s->config.ReshapeFilter.Activation=v;break;case 6:s->config.ReshapeFilter.DecimationRatio=v;break;case 7:s->config.HighPassFilter.Activation=v;break;case 8:s->config.HighPassFilter.CutOffFrequency=v;break;case 9:s->config.SoundActivity.Activation=v;break;case 10:s->config.SoundActivity.Mode=v;break;case 11:s->config.SoundActivity.FrameSize=v;break;case 12:s->config.SoundActivity.Hysteresis=v;break;case 13:s->config.SoundActivity.SoundTriggerEvent=v;break;case 14:s->config.SoundActivity.DataMemoryTransfer=v;break;case 15:s->config.SoundActivity.MinNoiseLevel=v;break;case 16:s->config.SoundActivity.HangoverWindow=v;break;case 17:s->config.SoundActivity.LearningFrames=v;break;case 18:s->config.SoundActivity.AmbientNoiseSlope=v;break;case 19:s->config.SoundActivity.SignalNoiseThreshold=v;break;case 20:s->config.SoundActivity.SoundLevelInterrupt=v;break;case 21:s->config.AcquisitionMode=v;break;case 22:s->config.FifoThreshold=v;break;case 23:s->config.DiscardSamples=v;break;case 24:s->config.Trigger.Source=v;break;case 25:s->config.Trigger.Edge=v;break;default:assert(0);} }
static uint32_t configGet(CMDFState *s,uint32_t i) { switch(i) {case 0:return s->dmaConfig.Address;case 1:return s->dmaConfig.DataLength;case 2:return s->dmaConfig.MsbOnly;default:assert(0);return 0;} }
static void configSet(CMDFState *s,uint32_t i,uint32_t v) { switch(i) {case 0:s->dmaConfig.Address=v;break;case 1:s->dmaConfig.DataLength=v;break;case 2:s->dmaConfig.MsbOnly=v;break;default:assert(0);} }
static uint32_t normalize(CMDFState *s,uint32_t address) {
 uint32_t base=(uint32_t)(uintptr_t)s->regs;
 if(address-base<sizeof(s->regs))return 0x4002F000U+(address-base);
 return address;
}
void CMDF_Reset(CMDFState *s,uint32_t mode) {
 memset(s,0,sizeof(*s));s->mode=mode;s->h.Instance=(MDF_Filter_TypeDef*)(s->regs+32);
 s->h.hdma=&s->dma;s->dma.Parent=&s->h;s->dma.LinkedListQueue=&s->queue;s->queue.Head=&s->node;
 s->control[0]=1;s->control[1]=1;s->control[2]=1;
 s->h.Init.CommonParam.ProcClockDivider=1;s->h.Init.CommonParam.OutputClock.Divider=1;
 s->h.Init.CommonParam.OutputClock.Pins=0x20;s->h.Init.SerialInterface.Threshold=4;
 s->config.CicMode=0x40;s->config.DecimationRatio=2;s->dmaConfig.Address=0x24001000;s->dmaConfig.DataLength=32;
 for(uint32_t i=1;i<=7;i++)CMDF_SetCallback(s,i,1);
}
uint32_t CMDF_Get(CMDFState *s,uint32_t area,uint32_t i) {
 switch(area) {
 case 0:assert(i<64);return s->regs[i];case 1:return handleGet(s,i);case 2:return filterGet(s,i);case 3:return configGet(s,i);
 case 4:switch(i) {case 0:return s->dma.Mode;case 1:return s->dma.LinkedListQueue!=NULL;case 2:return s->queue.Head!=NULL;
 case 3:return s->node.LinkRegisters[2];case 4:return normalize(s,s->node.LinkRegisters[3]);case 5:return normalize(s,s->node.LinkRegisters[4]);
 default:assert(i<9);return s->mode?CMDF1_GetDMA(s,i-6):CMDF0_GetDMA(s,i-6);}
 case 5:assert(i<12);return s->control[i];case 6:assert(i<6);return s->calls[i];case 7:assert(i<3);return s->output[i];
 case 8:return s->owner==NULL?0:s->owner==&s->h?1:2;case 9:return i?s->tickCalls:s->tick;
 case 10:return s->traceCount;case 11:return s->mode;default:assert(0);return 0;
 }
}
void CMDF_Set(CMDFState *s,uint32_t area,uint32_t i,uint32_t v) {
 switch(area) {
 case 0:assert(i<64);s->regs[i]=v;break;case 1:handleSet(s,i,v);break;case 2:filterSet(s,i,v);break;case 3:configSet(s,i,v);break;
 case 4:switch(i) {case 0:s->dma.Mode=v;break;case 1:s->dma.LinkedListQueue=v?&s->queue:NULL;break;case 2:s->queue.Head=v?&s->node:NULL;break;
 case 3:s->node.LinkRegisters[2]=v;break;case 4:s->node.LinkRegisters[3]=v;break;case 5:s->node.LinkRegisters[4]=v;break;
 default:assert(i<9);if(s->mode)CMDF1_SetDMA(s,i-6,v);else CMDF0_SetDMA(s,i-6,v);break;}break;
 case 5:assert(i<12);s->control[i]=v;break;case 6:assert(i<6);s->calls[i]=v;break;case 7:assert(i<3);s->output[i]=v;break;
 case 8:s->owner=v==0?NULL:v==1?&s->h:&s->other;break;case 9:if(i)s->tickCalls=v;else s->tick=v;break;
 case 10:s->traceCount=v;break;default:assert(0);
 }
}
static void trace(CMDFState *s,uint32_t id,uint32_t token,uint32_t sound,uint32_t ambient) {
 assert(s->traceCount<32);uint32_t *out=s->trace[s->traceCount++],n=0;out[n++]=id;out[n++]=token;out[n++]=sound;out[n++]=ambient;
 const uint32_t counts[]={64,14,26,3,9,12,6,3,1,2};
 for(uint32_t a=0;a<10;a++)for(uint32_t i=0;i<counts[a];i++)out[n++]=CMDF_Get(s,a,i);
 for(uint32_t i=1;i<=7;i++)out[n++]=CMDF_GetCallback(s,i);
 assert(n<=160);while(n<160)out[n++]=0;
}
void CMDF_Callback(CMDFState *s,uint32_t id,uint32_t token,uint32_t sound,uint32_t ambient) {
 trace(s,id,token,sound,ambient);
 if(s->control[7]) {s->h.State=255;s->h.ErrorCode=0x8000;s->regs[0x88/4]=0;s->regs[0xAC/4]=0;for(uint32_t i=1;i<=7;i++)CMDF_SetCallback(s,i,2);}
 if(s->control[8] && id==6) {s->h.Init.CommonParam.ProcClockDivider=128;s->h.Init.SerialInterface.Activation=1;s->h.Init.SerialInterface.Mode=0x10;}
}
uint32_t CMDF_Tick(CMDFState *s) {
 uint32_t result=s->tick;s->tick+=s->control[2];s->tickCalls++;
 if(s->control[3] && s->tickCalls>=s->control[3])s->regs[0xB0/4]=s->control[4];return result;
}
uint32_t CMDF_Start(CMDFState *s,uint32_t linked,uint32_t src,uint32_t dst,uint32_t size) {
 s->calls[0]++;s->calls[1]=linked;s->calls[2]=normalize(s,src);s->calls[3]=normalize(s,dst);s->calls[4]=size;
 trace(s,20,linked,0,0);return s->control[5];
}
uint32_t CMDF_Abort(CMDFState *s) {s->calls[5]++;trace(s,21,0,0,0);return s->control[6];}
uint32_t CMDF_Run(CMDFState *s,uint32_t op,uint32_t a,uint32_t b) {return s->mode?CMDF1_Run(s,op,a,b):CMDF0_Run(s,op,a,b);}
uint32_t CMDF_TraceWord(CMDFState *s,uint32_t e,uint32_t w) {assert(e<32 && w<160);return s->trace[e][w];}
uint32_t *CMDF_Output(CMDFState *s,uint32_t i) {assert(i<3);return s->output+i;}
