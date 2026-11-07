#include "DMA2DInternal.h"
CDMA2DState *CDMA2D_Active;
size_t CDMA2D_Size(void) { return sizeof(CDMA2DState); }
void CDMA2D_Reset(CDMA2DState *s,uint32_t mode) { memset(s,0,sizeof(*s));s->mode=mode;s->handle.Instance=&s->registers; }
static volatile uint32_t *word(CDMA2DState *s,uint32_t area,uint32_t index) {
    if(area==0) { assert(index<sizeof(s->registers)/4);return (volatile uint32_t *)&s->registers+index; }
    if(area==1) {
        assert(index<24);
        if(index<3)return (volatile uint32_t *)&s->handle.Lock+index;
        if(index<10)return (volatile uint32_t *)&s->handle.Init+index-3;
        return (volatile uint32_t *)s->handle.LayerCfg+index-10;
    }
    if(area==2) { assert(index<12);return &s->control[index]; }
    assert(area==3 && index==0);return &s->traceCount;
}
uint32_t CDMA2D_Get(CDMA2DState *s,uint32_t area,uint32_t index) { return *word(s,area,index); }
void CDMA2D_Set(CDMA2DState *s,uint32_t area,uint32_t index,uint32_t value) { *word(s,area,index)=value; }
static void event(CDMA2DState *s,uint32_t kind,uint32_t a,uint32_t b) {
    assert(s->traceCount<64);uint32_t *t=s->trace[s->traceCount++];t[0]=kind;t[1]=a;t[2]=b;
    for(uint32_t i=0;i<20;i++)t[3+i]=CDMA2D_Get(s,0,i);
    for(uint32_t i=0;i<24;i++)t[23+i]=CDMA2D_Get(s,1,i);
    for(uint32_t i=0;i<6;i++)t[47+i]=CDMA2D_GetCallback(s,i);
    t[53]=s->control[1];t[54]=s->control[4];t[55]=s->control[5];
}
/* Registers are plain RAM. Hardware transitions are scheduled at HAL_GetTick
   boundaries, so the original direct register expressions remain unchanged. */
void CDMA2D_Write(CDMA2DState *s,uint32_t offset,uint32_t value) {
    CDMA2D_Set(s,0,offset/4,value);
}
void CDMA2D_WriteAddress(volatile uint32_t *p,uint32_t value) {
    CDMA2D_Write(CDMA2D_Active,(uint32_t)((uintptr_t)p-(uintptr_t)&CDMA2D_Active->registers),value);
}
uint32_t CDMA2D_Tick(CDMA2DState *s) {
    uint32_t value=s->control[2];s->control[2]+=s->control[3];s->control[4]++;
    if(s->control[4]==1) {
        if(s->control[1]==0 && (s->registers.CR&4)) {
            s->registers.CR&=~7U;s->registers.FGPFCCR&=~0x20U;s->registers.BGPFCCR&=~0x20U;
        }
        if(s->control[1]==1)s->registers.CR|=1U;
        if(s->control[1]==2)s->registers.CR=(s->registers.CR&~2U)|1U;
        if(s->control[1]==3)s->registers.CR|=3U;
    }
    if(s->control[5] && s->control[4]==s->control[5]) {
        s->registers.CR&=~s->control[6];s->registers.CR|=s->control[7];
        s->registers.ISR|=s->control[8];
        if(s->control[9]&1)s->registers.BGPFCCR&=~0x20U;
        if(s->control[9]&2)s->registers.FGPFCCR&=~0x20U;
    }
    event(s,0,value,0);return value;
}
void CDMA2D_Callback(CDMA2DState *s,uint32_t id,uint32_t token) {
    event(s,1,id,token);
    if(s->control[10]) {
        s->handle.State=HAL_DMA2D_STATE_BUSY;s->handle.Lock=HAL_LOCKED;s->handle.ErrorCode|=0x80;
        s->handle.Init.Mode=DMA2D_R2M;s->handle.Init.ColorMode=DMA2D_OUTPUT_RGB565;
        s->registers.CR=0;s->registers.ISR=0;CDMA2D_SetCallback(s,2,2);
    }
}
uint32_t CDMA2D_TraceCount(CDMA2DState *s) { return s->traceCount; }
uint32_t CDMA2D_TraceWord(CDMA2DState *s,uint32_t e,uint32_t w) { assert(e<s->traceCount && w<56);return s->trace[e][w]; }
uint32_t CDMA2D_Run(CDMA2DState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c,uint32_t d,uint32_t e) {
    CDMA2DState *old=CDMA2D_Active;CDMA2D_Active=s;
    uint32_t result=s->mode?CDMA2D1_Run(s,op,a,b,c,d,e):CDMA2D0_Run(s,op,a,b,c,d,e);
    CDMA2D_Active=old;return result;
}
