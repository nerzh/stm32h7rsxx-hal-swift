#include "GFXTIMInternal.h"
CGFXTIMState *CGFXTIM_Active;
size_t CGFXTIM_Size(void) { return sizeof(CGFXTIMState); }
void CGFXTIM_Reset(CGFXTIMState *s,uint32_t mode) {
    memset(s,0,sizeof(*s));s->mode=mode;s->handle.Instance=&s->registers;
}
static volatile uint32_t *word(CGFXTIMState *s,uint32_t area,uint32_t index) {
    switch(area) {
    case 0:assert(index<sizeof(s->registers)/4);return (volatile uint32_t *)&s->registers+index;
    case 1:assert(index<6);return (volatile uint32_t *)&s->handle.State+index;
    case 2:assert(index<10);return &s->configuration[index];
    case 3:if(index==0)return &s->output;if(index==1)return &s->action;if(index==2)return &s->traceCount;
    }
    assert(!"Invalid GFXTIM fixture word");return NULL;
}
uint32_t CGFXTIM_Get(CGFXTIMState *s,uint32_t area,uint32_t index) { return *word(s,area,index); }
void CGFXTIM_Set(CGFXTIMState *s,uint32_t area,uint32_t index,uint32_t value) { *word(s,area,index)=value; }
static void event(CGFXTIMState *s,uint32_t kind,uint32_t a,uint32_t b) {
    assert(s->traceCount<64);uint32_t *t=s->trace[s->traceCount++];t[0]=kind;t[1]=a;t[2]=b;
    for(uint32_t i=0;i<6;i++)t[3+i]=CGFXTIM_Get(s,1,i);
    t[9]=s->registers.ISR;t[10]=s->registers.IER;t[11]=s->registers.ICR;
}
uint32_t CGFXTIM_Read(CGFXTIMState *s,uint32_t offset) {
    uint32_t v=CGFXTIM_Get(s,0,offset/4);event(s,0,offset,v);return v;
}
void CGFXTIM_Write(CGFXTIMState *s,uint32_t offset,uint32_t value) {
    CGFXTIM_Set(s,0,offset/4,value);if(offset==0x34)s->registers.ISR&=~value;event(s,1,offset,value);
}
uint32_t CGFXTIM_ReadAddress(volatile uint32_t *p) {
    return CGFXTIM_Read(CGFXTIM_Active,(uint32_t)((uintptr_t)p-(uintptr_t)&CGFXTIM_Active->registers));
}
void CGFXTIM_WriteAddress(volatile uint32_t *p,uint32_t value) {
    CGFXTIM_Write(CGFXTIM_Active,(uint32_t)((uintptr_t)p-(uintptr_t)&CGFXTIM_Active->registers),value);
}
uint32_t *CGFXTIM_Output(CGFXTIMState *s,uint32_t selector) {
    if(!selector)return NULL;
    if(selector==1)return &s->output;
    if(selector>=0x100 && selector<0x106)return (uint32_t *)word(s,1,selector-0x100);
    assert(selector>=0x200 && selector<0x22B);return (uint32_t *)word(s,0,selector-0x200);
}
void CGFXTIM_Callback(CGFXTIMState *s,uint32_t id,uint32_t token) {
    event(s,2,id,token);
    if(s->action==1) {
        s->handle.State=HAL_GFXTIM_STATE_RESET;s->handle.ErrorCode|=0x80;
        s->registers.IER=0;s->registers.ISR|=0x80000000;
        CGFXTIM_SetCallback(s,3,2);
        s->handle.Init.SynchroSrc=0x300;s->handle.Init.TearingEffectSrc=3;
    }
}
uint32_t CGFXTIM_TraceCount(CGFXTIMState *s) { return s->traceCount; }
uint32_t CGFXTIM_TraceWord(CGFXTIMState *s,uint32_t eventIndex,uint32_t index) {
    assert(eventIndex<s->traceCount && index<12);return s->trace[eventIndex][index];
}
uint32_t CGFXTIM_Run(CGFXTIMState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t nulls) {
    CGFXTIMState *old=CGFXTIM_Active;CGFXTIM_Active=s;
    uint32_t result=s->mode?CGFXTIM1_Run(s,op,a,b,nulls):CGFXTIM0_Run(s,op,a,b,nulls);
    CGFXTIM_Active=old;return result;
}
_Static_assert(offsetof(GFXTIM_HandleTypeDef,Init)-offsetof(GFXTIM_HandleTypeDef,State)==8,"GFXTIM handle words");
