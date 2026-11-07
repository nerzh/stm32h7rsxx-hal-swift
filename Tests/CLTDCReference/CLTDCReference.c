#include "LTDCInternal.h"
CLTDCState *CLTDC_Active;
size_t CLTDC_Size(void) { return sizeof(CLTDCState); }
void CLTDC_Reset(CLTDCState *s,uint32_t mode) {
    memset(s,0,sizeof(*s));s->mode=mode;s->handle.Instance=(LTDC_TypeDef *)s->registers;
    for(uint32_t i=0;i<512;i++)s->colors[i]=0xA5000000U|(i*0x12345U);
}
static volatile uint32_t *word(CLTDCState *s,uint32_t area,uint32_t index) {
    if(area==0) { assert(index<128);return s->registers+index; }
    if(area==1) {
        assert(index<42);
        if(index<3)return (volatile uint32_t *)&s->handle.Lock+index;
        if(index<16)return (volatile uint32_t *)&s->handle.Init+index-3;
        return (volatile uint32_t *)s->handle.LayerCfg+index-16;
    }
    if(area==2) { assert(index<6);return &s->control[index]; }
    if(area==3) { assert(index==0);return &s->traceCount; }
    if(area==4) { assert(index<512);return s->colors+index; }
    assert(area==5 && index<13);return (volatile uint32_t *)&s->configuration+index;
}
uint32_t CLTDC_Get(CLTDCState *s,uint32_t area,uint32_t index) { return *word(s,area,index); }
void CLTDC_Set(CLTDCState *s,uint32_t area,uint32_t index,uint32_t value) { *word(s,area,index)=value; }
const uint32_t *CLTDC_Colors(CLTDCState *s) { return s->colors; }
static void event(CLTDCState *s,uint32_t kind,uint32_t a,uint32_t b) {
    assert(s->traceCount<128);uint32_t *t=s->trace[s->traceCount++];t[0]=kind;t[1]=a;t[2]=b;
    for(uint32_t i=0;i<128;i++)t[3+i]=CLTDC_Get(s,0,i);
    for(uint32_t i=0;i<42;i++)t[131+i]=CLTDC_Get(s,1,i);
    for(uint32_t i=0;i<5;i++)t[173+i]=CLTDC_GetCallback(s,i);
    for(uint32_t i=0;i<6;i++)t[178+i]=s->control[i];
}
/* Registers are plain RAM. VSYNC changes only at scheduled tick boundaries.
   This compares snapshots, not a simulated display pipeline. */
uint32_t CLTDC_Tick(CLTDCState *s) {
    uint32_t value=s->control[0];s->control[0]+=s->control[1];s->control[2]++;
    if(s->control[3] && s->control[2]==s->control[3])s->handle.Instance->CDSR=s->control[4];
    event(s,0,value,0);return value;
}
void CLTDC_Callback(CLTDCState *s,uint32_t id,uint32_t token) {
    event(s,1,id,token);
    if(s->control[5]) {
        s->handle.State=HAL_LTDC_STATE_BUSY;s->handle.Lock=HAL_LOCKED;s->handle.ErrorCode|=0x80;
        s->handle.Init.HSPolarity=LTDC_HSPOLARITY_AH;s->handle.Init.HorizontalSync=0x123;
        s->handle.Init.Backcolor.Blue=0xAB;s->handle.Init.Backcolor.Green=0xCD;s->handle.Init.Backcolor.Red=0xEF;
        s->handle.Instance->IER=0;s->handle.Instance->ISR=0;
        CLTDC_SetCallback(s,2,2);CLTDC_SetCallback(s,3,2);CLTDC_SetCallback(s,4,2);
    }
}
uint32_t CLTDC_TraceCount(CLTDCState *s) { return s->traceCount; }
uint32_t CLTDC_TraceWord(CLTDCState *s,uint32_t e,uint32_t w) { assert(e<s->traceCount && w<184);return s->trace[e][w]; }
uint32_t CLTDC_Run(CLTDCState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
    CLTDCState *old=CLTDC_Active;CLTDC_Active=s;
    uint32_t result=s->mode?CLTDC1_Run(s,op,a,b,c):CLTDC0_Run(s,op,a,b,c);
    CLTDC_Active=old;return result;
}
