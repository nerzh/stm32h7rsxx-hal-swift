#include "DCMIPPInternal.h"
_Static_assert(sizeof(((CDCMIPPState *)0)->parameters)==24*4,"parameter word layout");
CDCMIPPState *CDCMIPP_Active;
static const uint32_t offsets[]={
    offsetof(DCMIPP_TypeDef,IPGR1),
    offsetof(DCMIPP_TypeDef,IPGR2),
    offsetof(DCMIPP_TypeDef,IPGR3),
    offsetof(DCMIPP_TypeDef,IPC1R1),
    offsetof(DCMIPP_TypeDef,IPC1R2),
    offsetof(DCMIPP_TypeDef,IPC1R3),
    offsetof(DCMIPP_TypeDef,PRCR),
    offsetof(DCMIPP_TypeDef,PRESCR),
    offsetof(DCMIPP_TypeDef,PRESUR),
    offsetof(DCMIPP_TypeDef,CMCR),
    offsetof(DCMIPP_TypeDef,CMFRCR),
    offsetof(DCMIPP_TypeDef,CMIER),
    offsetof(DCMIPP_TypeDef,CMSR1),
    offsetof(DCMIPP_TypeDef,CMSR2),
    offsetof(DCMIPP_TypeDef,CMFCR),
    offsetof(DCMIPP_TypeDef,P0FSCR),
    offsetof(DCMIPP_TypeDef,P0FCTCR),
    offsetof(DCMIPP_TypeDef,P0SCSTR),
    offsetof(DCMIPP_TypeDef,P0SCSZR),
    offsetof(DCMIPP_TypeDef,P0DCCNTR),
    offsetof(DCMIPP_TypeDef,P0DCLMTR),
    offsetof(DCMIPP_TypeDef,P0PPCR),
    offsetof(DCMIPP_TypeDef,P0PPM0AR1),
    offsetof(DCMIPP_TypeDef,P0PPM0AR2),
};
size_t CDCMIPP_Size(void) { return sizeof(CDCMIPPState); }
void CDCMIPP_Reset(CDCMIPPState *s,uint32_t mode) { memset(s,0,sizeof(*s));s->mode=mode;s->handle.Instance=&s->registers; }
static volatile uint32_t *word(CDCMIPPState *s,uint32_t area,uint32_t index) {
    if(area==0) { assert(index<sizeof(s->registers)/4);return (volatile uint32_t *)&s->registers+index; }
    if(area==1) { assert(index<3);return (volatile uint32_t *)&s->handle.State+index; }
    if(area==2) { assert(index<6);return s->control+index; }
    if(area==3) { assert(index==0);return &s->traceCount; }
    assert(area==4 && index<24);return (volatile uint32_t *)&s->parameters+index;
}
uint32_t CDCMIPP_Get(CDCMIPPState *s,uint32_t area,uint32_t index) { return *word(s,area,index); }
void CDCMIPP_Set(CDCMIPPState *s,uint32_t area,uint32_t index,uint32_t value) { *word(s,area,index)=value; }
static void event(CDCMIPPState *s,uint32_t kind,uint32_t a,uint32_t b) {
    assert(s->traceCount<32);uint32_t *t=s->trace[s->traceCount++];t[0]=kind;t[1]=a;t[2]=b;
    for(uint32_t i=0;i<24;i++)t[3+i]=CDCMIPP_Get(s,0,offsets[i]/4);
    for(uint32_t i=0;i<3;i++)t[27+i]=CDCMIPP_Get(s,1,i);
    for(uint32_t i=0;i<8;i++)t[30+i]=CDCMIPP_GetCallback(s,i);
    for(uint32_t i=0;i<6;i++)t[38+i]=s->control[i];
}
/* Idle/capture-active transitions are scheduled at tick boundaries. */
uint32_t CDCMIPP_Tick(CDCMIPPState *s) {
    uint32_t value=s->control[0];s->control[0]+=s->control[1];s->control[2]++;
    if(s->control[3] && s->control[2]==s->control[3]) {
        if(s->control[4]&1)s->registers.IPGR3|=1;
        if(s->control[4]&2)s->registers.CMSR1&=~0x8000U;
    }
    event(s,0,value,0);return value;
}
static void mutate(CDCMIPPState *s) {
    if(s->control[5]) {
        s->handle.State=HAL_DCMIPP_STATE_BUSY;s->handle.PipeState[0]=HAL_DCMIPP_PIPE_STATE_SUSPEND;
        s->handle.ErrorCode|=0x80;s->registers.CMIER=0;s->registers.CMSR2=0;s->registers.P0FCTCR|=4;
        CDCMIPP_SetCallback(s,2,2);CDCMIPP_SetCallback(s,5,2);CDCMIPP_SetCallback(s,7,2);
    }
}
void CDCMIPP_Callback(CDCMIPPState *s,uint32_t id,uint32_t token) { event(s,1,id,token);mutate(s); }
void CDCMIPP_PipeCallback(CDCMIPPState *s,uint32_t id,uint32_t token,uint32_t pipe) { event(s,2+pipe,id+2,token);mutate(s); }
uint32_t CDCMIPP_TraceCount(CDCMIPPState *s) { return s->traceCount; }
uint32_t CDCMIPP_TraceWord(CDCMIPPState *s,uint32_t e,uint32_t w) { assert(e<s->traceCount && w<44);return s->trace[e][w]; }
uint32_t CDCMIPP_Run(CDCMIPPState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
    CDCMIPPState *old=CDCMIPP_Active;CDCMIPP_Active=s;
    uint32_t result=s->mode?CDCMIPP1_Run(s,op,a,b,c):CDCMIPP0_Run(s,op,a,b,c);
    CDCMIPP_Active=old;return result;
}
