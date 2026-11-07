#include "GraphicsInternal.h"
CGraphicsState *CGraphics_Active;
size_t CGraphics_Size(void) { return sizeof(CGraphicsState); }
void CGraphics_Reset(CGraphicsState *s, uint32_t mode) {
    memset(s,0,sizeof(*s)); s->mode=mode; s->mmuHandle.Instance=&s->mmu;
    s->gpuHandle.Instance=0x52014000;
}
static volatile uint32_t *word(CGraphicsState *s,uint32_t area,uint32_t index) {
    switch(area) {
    case 0: assert(index<3072); return ((volatile uint32_t *)&s->mmu)+index;
    case 1: assert(index<1024); return &s->gpu[index];
    case 2: assert(index<11); return ((volatile uint32_t *)&s->mmuHandle.Init)+index;
    case 3: assert(index<3); return ((volatile uint32_t *)&s->gpuHandle.Lock)+index;
    case 4: assert(index<2048); return &s->input[index];
    case 5:
        if(index==0)return &s->primask;
        if(index==1)return &s->callbackAction;
        if(index==2)return &s->traceCount;
        break;
    }
    assert(!"Invalid graphics model word"); return NULL;
}
uint32_t CGraphics_Get(CGraphicsState *s,uint32_t area,uint32_t index) { return *word(s,area,index); }
void CGraphics_Set(CGraphicsState *s,uint32_t area,uint32_t index,uint32_t value) { *word(s,area,index)=value; }
void CGraphics_Event(CGraphicsState *s,uint32_t kind,uint32_t a,uint32_t b) {
    assert(s->traceCount<64); uint32_t *t=s->trace[s->traceCount++];
    t[0]=kind; t[1]=a; t[2]=b; t[3]=s->primask;
    for(uint32_t i=0;i<11;i++)t[4+i]=CGraphics_Get(s,2,i);
    for(uint32_t i=0;i<3;i++)t[15+i]=CGraphics_Get(s,3,i);
    t[18]=s->mmu.CR; t[19]=s->gpu[0xF8/4];
}
uint32_t CGraphics_TraceCount(CGraphicsState *s) { return s->traceCount; }
uint32_t CGraphics_TraceWord(CGraphicsState *s,uint32_t event,uint32_t index) {
    assert(event<s->traceCount && index<20); return s->trace[event][index];
}
uint32_t CGraphics_ReadGPU(CGraphicsState *s,uint32_t offset) {
    assert(offset<0x1000 && !(offset&3)); uint32_t v=s->gpu[offset/4]; CGraphics_Event(s,1,offset,v); return v;
}
void CGraphics_WriteGPU(CGraphicsState *s,uint32_t offset,uint32_t value) {
    assert(offset<0x1000 && !(offset&3)); s->gpu[offset/4]=value; CGraphics_Event(s,2,offset,value);
}
uint32_t CGraphics_GPUReadAddress(const volatile uint32_t *address) {
    return CGraphics_ReadGPU(CGraphics_Active,(uint32_t)(uintptr_t)address-0x52014000);
}
void CGraphics_GPUWriteAddress(volatile uint32_t *address,uint32_t value) {
    CGraphics_WriteGPU(CGraphics_Active,(uint32_t)(uintptr_t)address-0x52014000,value);
}
uint32_t CGraphics_Mask(CGraphicsState *s,uint32_t operation,uint32_t value) {
    uint32_t old=s->primask;
    if(operation==1)s->primask=1;
    if(operation==2)s->primask=value;
    CGraphics_Event(s,10+operation,operation==0?old:value,0);
    return old;
}
void CGraphics_EmitCallback(CGraphicsState *s,uint32_t module,uint32_t index,uint32_t token,uint32_t arg) {
    CGraphics_Event(s,100+module*10+index,token,arg);
    // A user MSP callback may change the live configuration/state before Init resumes.
    if(s->callbackAction==1) {
        s->mmuHandle.Init.BlockSize=0x40; s->mmuHandle.Init.DefaultValue=0x13579BDF;
        s->mmuHandle.Init.Buffers.Buf0Address=0x24010000;
        s->gpuHandle.Lock=HAL_LOCKED;
    }
}
uint32_t CGraphics_GetCallback(CGraphicsState *s,uint32_t module,uint32_t index) {
    return s->mode?CGraphics1_GetCallback(s,module,index):CGraphics0_GetCallback(s,module,index);
}
void CGraphics_SetCallback(CGraphicsState *s,uint32_t module,uint32_t index,uint32_t token) {
    if(s->mode)CGraphics1_SetCallback(s,module,index,token);else CGraphics0_SetCallback(s,module,index,token);
}
uint32_t CGraphics_Address(CGraphicsState *s,uint32_t area,uint32_t index) {
    assert(area==0 || area==4);
#if UINTPTR_MAX > UINT32_MAX
    return (area==0?0x10000000:0x20000000)+index*4;
#else
    return (uint32_t)(uintptr_t)word(s,area,index);
#endif
}
static volatile uint32_t *memory(CGraphicsState *s,uint32_t address) {
#if UINTPTR_MAX > UINT32_MAX
    if(address>=0x10000000 && address<0x10003000)return word(s,0,(address-0x10000000)/4);
    if(address>=0x20000000 && address<0x20002000)return word(s,4,(address-0x20000000)/4);
    assert(!"Unmapped graphics memory"); return NULL;
#else
    (void)s; return (volatile uint32_t *)(uintptr_t)address;
#endif
}
uint32_t CGraphics_ReadMemory(CGraphicsState *s,uint32_t address) { assert(!(address&3));return *memory(s,address); }
void CGraphics_WriteMemory(CGraphicsState *s,uint32_t address,uint32_t value) { assert(!(address&3));*memory(s,address)=value; }
uint32_t CGraphics_Run(CGraphicsState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c,uint32_t d) {
    CGraphicsState *old=CGraphics_Active; CGraphics_Active=s;
    uint32_t result=s->mode?CGraphics1_Run(s,op,a,b,c,d):CGraphics0_Run(s,op,a,b,c,d);
    CGraphics_Active=old; return result;
}
_Static_assert(offsetof(GFXMMU_TypeDef,LUT)==0x1000,"CMSIS LUT offset");
_Static_assert(offsetof(GFXMMU_HandleTypeDef,ErrorCode)-offsetof(GFXMMU_HandleTypeDef,Init)==40,"MMU handle words");
_Static_assert(offsetof(GPU2D_HandleTypeDef,ErrorCode)-offsetof(GPU2D_HandleTypeDef,Lock)==8,"GPU handle words");
