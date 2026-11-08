#include "SDRAMInternal.h"
#if defined(__arm__) || defined(__thumb__)
#define CSDRAM_THREAD_LOCAL
#else
#define CSDRAM_THREAD_LOCAL _Thread_local
#endif
static CSDRAM_THREAD_LOCAL CSDRAMState *active;
size_t CSDRAM_Size(void){return sizeof(CSDRAMState);}
void CSDRAM_Activate(CSDRAMState *s){active=s;CFMC_Activate(&s->fmc);}
CSDRAMState *CSDRAM_Active(void){return active;}
uint32_t CSDRAM_ReadRegister(CSDRAMState *s,uint32_t off){return CFMC_Read(&s->fmc,off);}
void CSDRAM_WriteRegister(CSDRAMState *s,uint32_t off,uint32_t v){CFMC_Write(&s->fmc,off,v);}
void *CSDRAM_Buffer(CSDRAMState *s){return s->buffer;}
void CSDRAM_Trace(CSDRAMState *s,uint32_t kind,uint32_t address,uint32_t value){
uint32_t i=s->control[0]++;assert(i<2048);
s->trace[i][0]=kind;s->trace[i][1]=address;s->trace[i][2]=value;s->trace[i][3]=((uint32_t)s->h.State<<16)|(uint32_t)s->h.Lock;
}
uint32_t CSDRAM_ReadMemory(CSDRAMState *s,uint32_t bits,uint32_t address){
uint32_t offset=address-0x60000000U;assert(offset+bits/8<=sizeof(s->memory));assert(!(offset%(bits/8)));
uint32_t value=0;memcpy(&value,(uint8_t *)s->memory+offset,bits/8);
uint32_t i=s->control[1]++;
if(i<s->control[2])value=s->script[i];
else if(s->control[3])value^=i*0x10203041U;
if(bits==8)value&=0xFF;else if(bits==16)value&=0xFFFF;else assert(bits==32);
CSDRAM_Trace(s,bits,address,value);return value;
}
void CSDRAM_WriteMemory(CSDRAMState *s,uint32_t bits,uint32_t address,uint32_t value){
uint32_t offset=address-0x60000000U;assert(offset+bits/8<=sizeof(s->memory));assert(!(offset%(bits/8)));
assert(bits==8 || bits==16 || bits==32);
memcpy((uint8_t *)s->memory+offset,&value,bits/8);CSDRAM_Trace(s,0x100|bits,address,value);
}
void CSDRAM_CallbackEvent(CSDRAMState *s,uint32_t id,uint32_t token,void *source){
uint32_t index=source?((CSDRAMDMA *)source)->index:0xFFFFFFFFU;
CSDRAM_Trace(s,0x300|id,index,token);
if(s->control[10] && id==s->control[11]){
s->h.State=s->control[12];s->h.Lock=s->control[13];s->fmc.registers[0x158/4]=s->control[14];
}
}
void *CSDRAM_DMAContext(CSDRAMState *s,uint32_t index){assert(index<2);return &s->dma[index].h;}
void CSDRAM_SetParent(CSDRAMState *s,uint32_t index,CSDRAMState *parent){assert(index<2);s->dma[index].h.Parent=&parent->h;}
void *CSDRAM_GetParent(void *context){return ((DMA_HandleTypeDef *)context)->Parent;}
void CSDRAM_DisableDMA(void *context){
CSDRAMDMA *d=context;__HAL_DMA_DISABLE(&d->h);d->meta[2]++;
CSDRAM_Trace(d->owner,0x400,d->index,d->h.Instance->CCR);
}
void *CSDRAM0_Callback(uint32_t);
void *CSDRAM1_Callback(uint32_t);
void *CSDRAM_DMACallback(uint32_t variant,uint32_t kind){return variant?CSDRAM1_Callback(kind):CSDRAM0_Callback(kind);}
uint32_t CSDRAM_DMACallbackKind(void *p){
if(!p)return 0;
for(uint32_t v=0;v<2;v++)for(uint32_t k=0;k<3;k++)if(p==CSDRAM_DMACallback(v,k))return k+1;
assert(0);return 0;
}
void *CSDRAM_DMAGetCallback(CSDRAMState *s,uint32_t channel,uint32_t id){
assert(channel<2);DMA_HandleTypeDef *d=&s->dma[channel].h;
switch(id){case 0:return d->XferCpltCallback;case 1:return d->XferHalfCpltCallback;case 2:return d->XferErrorCallback;case 3:return d->XferAbortCallback;case 4:return d->XferSuspendCallback;}assert(0);return NULL;
}
void CSDRAM_DMASetCallback(CSDRAMState *s,uint32_t channel,uint32_t id,void *value){
assert(channel<2);DMA_HandleTypeDef *d=&s->dma[channel].h;
switch(id){case 0:d->XferCpltCallback=value;return;case 1:d->XferHalfCpltCallback=value;return;case 2:d->XferErrorCallback=value;return;case 3:d->XferAbortCallback=value;return;case 4:d->XferSuspendCallback=value;return;}assert(0);
}
uint32_t CSDRAM_DMARead(CSDRAMState *s,uint32_t channel,uint32_t word){
assert(channel<2);DMA_HandleTypeDef *d=&s->dma[channel].h;
switch(word){
case 0:return d->Mode;case 1:return d->Init.DestDataWidth;case 2:return d->LinkedListQueue!=NULL;
case 3:return s->queues[channel].Head!=NULL;case 4:return d->Instance->CCR;
case 5:return d->State;case 6:return d->Lock;case 7:return d->ErrorCode;
case 8:return CSDRAM_DMACallbackKind(d->XferCpltCallback);
case 9:return CSDRAM_DMACallbackKind(d->XferErrorCallback);
case 10:return CSDRAM_DMACallbackKind(d->XferHalfCpltCallback);
case 11:return CSDRAM_DMACallbackKind(d->XferAbortCallback);
case 12:return d->Parent==&s->h?0:1;
case 13:return s->dma[channel].meta[0];case 14:return s->dma[channel].meta[1];case 15:return s->dma[channel].meta[2];
}assert(0);return 0;
}
void CSDRAM_DMAWrite(CSDRAMState *s,uint32_t channel,uint32_t word,uint32_t value){
assert(channel<2);DMA_HandleTypeDef *d=&s->dma[channel].h;
switch(word){
case 0:d->Mode=value;return;case 1:d->Init.DestDataWidth=value;return;
case 2:d->LinkedListQueue=value?&s->queues[channel]:NULL;return;
case 3:s->queues[channel].Head=value?&s->nodes[channel]:NULL;return;
case 4:d->Instance->CCR=value;return;case 5:d->State=value;return;case 6:d->Lock=value;return;case 7:d->ErrorCode=value;return;
case 8:d->XferCpltCallback=value?CSDRAM_DMACallback(1,value-1):NULL;return;
case 9:d->XferErrorCallback=value?CSDRAM_DMACallback(1,value-1):NULL;return;
case 10:d->XferHalfCpltCallback=value?CSDRAM_DMACallback(1,value-1):NULL;return;
case 11:d->XferAbortCallback=value?CSDRAM_DMACallback(1,value-1):NULL;return;
case 13:s->dma[channel].meta[0]=value;return;case 14:s->dma[channel].meta[1]=value;return;case 15:s->dma[channel].meta[2]=value;return;
}assert(0);
}
static uint32_t normalize(CSDRAMState *s,uint32_t value){
uint32_t base=(uint32_t)(uintptr_t)s->buffer;
if(value-base<sizeof(s->buffer))return 0x24020000U+(value-base);
return value;
}
uint32_t CSDRAM_DMAReadMemory(CSDRAMState *s,uint32_t address){
for(uint32_t i=0;i<2;i++){
if(address==0x24030000U+i*0x100)return s->queues[i].Head?0x24030040U+i*0x100:0;
uint32_t offset=address-(0x24030040U+i*0x100);
if(offset<36 && !(offset&3))return ((uint32_t *)&s->nodes[i])[offset/4];
}assert(0);return 0;
}
void CSDRAM_DMAWriteMemory(CSDRAMState *s,uint32_t address,uint32_t value){
for(uint32_t i=0;i<2;i++){
uint32_t offset=address-(0x24030040U+i*0x100);
if(offset<36 && !(offset&3)){((uint32_t *)&s->nodes[i])[offset/4]=value;return;}
}assert(0);
}
uint32_t CSDRAM_Start(CSDRAMState *s,uint32_t linked,uint32_t source,uint32_t dest,uint32_t size){
uint32_t i=s->control[4];assert(i<2);CSDRAMDMA *d=&s->dma[i];d->meta[1]++;
CSDRAM_Trace(s,0x500|linked,normalize(s,source),normalize(s,dest));
CSDRAM_Trace(s,0x5010,i,size);
if(s->control[7]){
uint32_t j=s->control[8];assert(j<2);
void (*callback)(DMA_HandleTypeDef *)=CSDRAM_DMACallback(1,s->control[7]-1);
callback(&s->dma[j].h);
}
return d->meta[0];
}
static void callback10(void *p){CSDRAM_CallbackEvent(p,0,1,NULL);}
static void callback11(void *p){CSDRAM_CallbackEvent(p,1,1,NULL);}
static void callback12(void *p){CSDRAM_CallbackEvent(p,2,1,NULL);}
static void callback13(void *p){CSDRAM_CallbackEvent((CSDRAMState *)((DMA_HandleTypeDef *)p)->Parent,3,1,p);}
static void callback14(void *p){CSDRAM_CallbackEvent((CSDRAMState *)((DMA_HandleTypeDef *)p)->Parent,4,1,p);}
static void callback20(void *p){CSDRAM_CallbackEvent(p,0,2,NULL);}
static void callback21(void *p){CSDRAM_CallbackEvent(p,1,2,NULL);}
static void callback22(void *p){CSDRAM_CallbackEvent(p,2,2,NULL);}
static void callback23(void *p){CSDRAM_CallbackEvent((CSDRAMState *)((DMA_HandleTypeDef *)p)->Parent,3,2,p);}
static void callback24(void *p){CSDRAM_CallbackEvent((CSDRAMState *)((DMA_HandleTypeDef *)p)->Parent,4,2,p);}
void *CSDRAM_Callback(uint32_t id,uint32_t token){if(!token)return NULL;switch(token*8+id){
case 8:return callback10;
case 9:return callback11;
case 10:return callback12;
case 11:return callback13;
case 12:return callback14;
case 16:return callback20;
case 17:return callback21;
case 18:return callback22;
case 19:return callback23;
case 20:return callback24;
default:return callback20;}}
void *CSDRAM_GetCallback(CSDRAMState *s,uint32_t id){switch(id){
case 0:return s->h.MspInitCallback;
case 1:return s->h.MspDeInitCallback;
case 2:return s->h.RefreshErrorCallback;
case 3:return s->h.DmaXferCpltCallback;
case 4:return s->h.DmaXferErrorCallback;
default:assert(0);return NULL;}}
void CSDRAM_SetCallback(CSDRAMState *s,uint32_t id,void *p){switch(id){
case 0:s->h.MspInitCallback=p;return;
case 1:s->h.MspDeInitCallback=p;return;
case 2:s->h.RefreshErrorCallback=p;return;
case 3:s->h.DmaXferCpltCallback=p;return;
case 4:s->h.DmaXferErrorCallback=p;return;
default:assert(0);}}
static uint32_t callbackToken(CSDRAMState *s,uint32_t id){void *p=CSDRAM_GetCallback(s,id);if(!p)return 0;for(uint32_t t=1;t<=2;t++)for(uint32_t j=0;j<5;j++)if(p==CSDRAM_Callback(j,t))return (j<<8)|t;assert(0);return 0;}
uint32_t CSDRAM_Get(CSDRAMState *s,uint32_t group,uint32_t index){switch(group){
case 0:assert(index<88);return s->fmc.registers[index];
case 1:assert(index<10);return ((uint32_t *)&s->h.Init)[index];
case 2:switch(index){case 0:return s->h.Lock;case 1:return s->h.State;default:assert(0);break;}break;
case 3:assert(index<7);return ((uint32_t *)&s->timing[0])[index];
case 4:assert(index<7);return ((uint32_t *)&s->timing[1])[index];
case 5:assert(index<4);return ((uint32_t *)&s->command)[index];
case 6:assert(index<32);return s->control[index];
case 7:assert(index<256);return s->buffer[index];
case 8:assert(index<256);return s->memory[index];
case 9:assert(index<256);return s->script[index];
case 10:assert(index<5);return callbackToken(s,index);
case 11:return CSDRAM_DMARead(s,0,index);
case 12:return CSDRAM_DMARead(s,1,index);
case 13:assert(index<9);return (index==3 || index==4)?normalize(s,((uint32_t *)&s->nodes[0])[index]):((uint32_t *)&s->nodes[0])[index];
case 14:assert(index<9);return (index==3 || index==4)?normalize(s,((uint32_t *)&s->nodes[1])[index]):((uint32_t *)&s->nodes[1])[index];
case 15:assert(index<8192);return ((uint32_t *)s->trace)[index];
}assert(0);return 0;}
void CSDRAM_Set(CSDRAMState *s,uint32_t group,uint32_t index,uint32_t value){switch(group){
case 0:assert(index<88);s->fmc.registers[index]=value;return;
case 1:assert(index<10);((uint32_t *)&s->h.Init)[index]=value;return;
case 2:switch(index){case 0:s->h.Lock=value;return;case 1:s->h.State=value;return;default:assert(0);break;}break;
case 3:assert(index<7);((uint32_t *)&s->timing[0])[index]=value;return;
case 4:assert(index<7);((uint32_t *)&s->timing[1])[index]=value;return;
case 5:assert(index<4);((uint32_t *)&s->command)[index]=value;return;
case 6:assert(index<32);s->control[index]=value;if(index==4)s->h.hdma=&s->dma[value].h;return;
case 7:assert(index<256);s->buffer[index]=value;return;
case 8:assert(index<256);s->memory[index]=value;return;
case 9:assert(index<256);s->script[index]=value;return;
case 10:assert(index<5);CSDRAM_SetCallback(s,index,CSDRAM_Callback(index,value));return;
case 11:CSDRAM_DMAWrite(s,0,index,value);return;
case 12:CSDRAM_DMAWrite(s,1,index,value);return;
case 13:assert(index<9);((uint32_t *)&s->nodes[0])[index]=value;return;
case 14:assert(index<9);((uint32_t *)&s->nodes[1])[index]=value;return;
case 15:assert(index<8192);((uint32_t *)s->trace)[index]=value;return;
}assert(0);}
void CSDRAM_Reset(CSDRAMState *s){
memset(s,0,sizeof(*s));CFMC_Reset(&s->fmc);CSDRAM_Activate(s);
s->h.Instance=FMC_Bank5_6_R;
s->h.State=HAL_SDRAM_STATE_READY;
s->h.hdma=&s->dma[0].h;
for(uint32_t i=0;i<14;i++)((uint32_t *)s->timing)[i]=(i%5)+1;
for(uint32_t i=0;i<256;i++){s->buffer[i]=0x76543210U+i*0x01020408U;s->memory[i]=0xA5C39E17U+i*0x10203041U;}
for(uint32_t i=0;i<2;i++){s->dma[i].owner=s;s->dma[i].index=i;s->dma[i].h.Instance=&s->channels[i];s->dma[i].h.Parent=&s->h;s->dma[i].h.LinkedListQueue=&s->queues[i];s->queues[i].Head=&s->nodes[i];s->channels[i].CCR=0xA5A50001;s->dma[i].h.State=HAL_DMA_STATE_READY;}
for(uint32_t i=0;i<5;i++)CSDRAM_SetCallback(s,i,CSDRAM_Callback(i,2));
}
uint32_t CSDRAM_Compare(CSDRAMState *a,CSDRAMState *b){const uint32_t counts[]={88,10,2,7,7,4,32,256,256,256,5,16,16,9,9};
for(uint32_t g=0;g<15;g++)for(uint32_t i=0;i<counts[g];i++)if(CSDRAM_Get(a,g,i)!=CSDRAM_Get(b,g,i))return ((g+1)<<20)|i;
for(uint32_t i=0;i<a->control[0]*4;i++)if(CSDRAM_Get(a,15,i)!=CSDRAM_Get(b,15,i))return (16<<20)|i;
return 0;}
uint32_t CSDRAM0_Run(CSDRAMState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSDRAM1_Run(CSDRAMState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSDRAM_Run(CSDRAMState *s,uint32_t variant,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CSDRAM_Activate(s);return variant?CSDRAM1_Run(s,op,a,b,c):CSDRAM0_Run(s,op,a,b,c);}
uint32_t CSDRAM_Constant(uint32_t i){switch(i){case 0:return HAL_SDRAM_DMA_XFER_CPLT_CB_ID;case 1:return HAL_SDRAM_DMA_XFER_ERR_CB_ID;case 2:return HAL_SDRAM_MSP_DEINIT_CB_ID;case 3:return HAL_SDRAM_MSP_INIT_CB_ID;case 4:return HAL_SDRAM_REFRESH_ERR_CB_ID;case 5:return HAL_SDRAM_STATE_BUSY;case 6:return HAL_SDRAM_STATE_ERROR;case 7:return HAL_SDRAM_STATE_PRECHARGED;case 8:return HAL_SDRAM_STATE_READY;case 9:return HAL_SDRAM_STATE_RESET;case 10:return HAL_SDRAM_STATE_WRITE_PROTECTED;}assert(0);return 0;}
