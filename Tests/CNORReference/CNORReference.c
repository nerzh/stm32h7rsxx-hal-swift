#include "NORInternal.h"
#if defined(__arm__) || defined(__thumb__)
#define CNOR_THREAD_LOCAL
#else
#define CNOR_THREAD_LOCAL _Thread_local
#endif
static CNOR_THREAD_LOCAL CNORState *active;
size_t CNOR_Size(void){return sizeof(CNORState);}
void CNOR_Activate(CNORState *s){active=s;CFMC_Activate(&s->fmc);}
CNORState *CNOR_Active(void){return active;}
uint32_t CNOR_ReadShared(CNORState *s){return *s->shared;}
void CNOR_WriteShared(CNORState *s,uint32_t value){*s->shared=value;}
void CNOR_Share(CNORState *s,CNORState *other){s->shared=&other->sharedWidth;}
uint32_t CNOR_TickFor(CNORState *s){return CFMC_TickFor(&s->fmc);}
uint32_t CNOR_ReadRegister(CNORState *s,uint32_t off){return CFMC_Read(&s->fmc,off);}
void CNOR_WriteRegister(CNORState *s,uint32_t off,uint32_t value){CFMC_Write(&s->fmc,off,value);}
void *CNOR_Buffer(CNORState *s){return s->buffer;}
void *CNOR_Value(CNORState *s,uint32_t i){switch(i){case 0:return &s->timing[0];case 1:return &s->timing[1];case 2:return &s->id;case 3:return &s->cfi;}assert(0);return NULL;}
void CNOR_Trace(CNORState *s,uint32_t kind,uint32_t address,uint32_t value){
uint32_t i=s->control[0]++;assert(i<2048);
s->trace[i][0]=kind;s->trace[i][1]=address;s->trace[i][2]=value;
s->trace[i][3]=((uint32_t)s->h.State<<16)|(uint32_t)s->h.Lock;
}
uint32_t CNOR_ReadMemory(CNORState *s,uint32_t bits,uint32_t address){
assert(bits==16 || bits==32);
uint32_t i=s->control[2]++;
uint32_t value=i<s->control[1]?s->script[i]:s->control[3];
if(bits==16)value&=0xFFFF;
CNOR_Trace(s,bits,address,value);return value;
}
void CNOR_WriteMemory(CNORState *s,uint32_t bits,uint32_t address,uint32_t value){
assert(bits==16);CNOR_Trace(s,0x100|bits,address,value);
}
void CNOR_Barrier(CNORState *s){CNOR_Trace(s,0x200,0,0);}
void CNOR_CallbackEvent(CNORState *s,uint32_t id,uint32_t token){
CNOR_Trace(s,0x300|id,0,token);
if(s->control[10] && id==s->control[11]){
s->h.State=s->control[12];s->h.Lock=s->control[13];
s->h.CommandSet=s->control[14];*s->shared=s->control[15];
}
}
void CNOR_Wait(CNORState *s,uint32_t timeout){CNOR_CallbackEvent(s,2,timeout);}
static void callback10(void *p){CNOR_CallbackEvent(p,0,1);}
static void callback11(void *p){CNOR_CallbackEvent(p,1,1);}
static void callback20(void *p){CNOR_CallbackEvent(p,0,2);}
static void callback21(void *p){CNOR_CallbackEvent(p,1,2);}
void *CNOR_Callback(uint32_t id,uint32_t token){if(!token)return NULL;switch(token*4+id){
case 4:return callback10;
case 5:return callback11;
case 8:return callback20;
case 9:return callback21;
default:return callback20;}}
void *CNOR_GetCallback(CNORState *s,uint32_t id){switch(id){
case 0:return s->h.MspInitCallback;
case 1:return s->h.MspDeInitCallback;
default:assert(0);return NULL;}}
void CNOR_SetCallback(CNORState *s,uint32_t id,void *p){switch(id){
case 0:s->h.MspInitCallback=(pNOR_CallbackTypeDef)p;return;
case 1:s->h.MspDeInitCallback=(pNOR_CallbackTypeDef)p;return;
default:assert(0);}}
static uint32_t callbackToken(CNORState *s,uint32_t id){void *p=CNOR_GetCallback(s,id);if(!p)return 0;for(uint32_t t=1;t<=2;t++)for(uint32_t j=0;j<2;j++)if(p==CNOR_Callback(j,t))return (j<<8)|t;assert(0);return 0;}
uint32_t CNOR_Get(CNORState *s,uint32_t group,uint32_t index){switch(group){
case 0:assert(index<88);return s->fmc.registers[index];
case 1:assert(index<15);return ((uint32_t *)&s->h.Init)[index];
case 2:switch(index){case 0:return s->h.Lock;case 1:return s->h.State;case 2:return s->h.CommandSet;default:assert(0);break;}break;
case 3:assert(index<4);return ((uint16_t *)&s->id)[index];
case 4:assert(index<4);return ((uint16_t *)&s->cfi)[index];
case 5:assert(index<7);return ((uint32_t *)&s->timing[0])[index];
case 6:assert(index<7);return ((uint32_t *)&s->timing[1])[index];
case 7:assert(index<32);return s->control[index];
case 8:assert(index<16);return s->fmc.control[index];
case 9:assert(index<256);return s->buffer[index];
case 10:assert(index<256);return s->script[index];
case 11:assert(index<2);return callbackToken(s,index);
case 12:assert(index<1);return *s->shared;
case 13:assert(index<8192);return ((uint32_t *)s->trace)[index];
}assert(0);return 0;}
void CNOR_Set(CNORState *s,uint32_t group,uint32_t index,uint32_t value){switch(group){
case 0:assert(index<88);s->fmc.registers[index]=value;return;
case 1:assert(index<15);((uint32_t *)&s->h.Init)[index]=value;return;
case 2:switch(index){case 0:s->h.Lock=value;return;case 1:s->h.State=value;return;case 2:s->h.CommandSet=value;return;default:assert(0);break;}break;
case 3:assert(index<4);((uint16_t *)&s->id)[index]=value;return;
case 4:assert(index<4);((uint16_t *)&s->cfi)[index]=value;return;
case 5:assert(index<7);((uint32_t *)&s->timing[0])[index]=value;return;
case 6:assert(index<7);((uint32_t *)&s->timing[1])[index]=value;return;
case 7:assert(index<32);s->control[index]=value;return;
case 8:assert(index<16);s->fmc.control[index]=value;return;
case 9:assert(index<256);s->buffer[index]=value;return;
case 10:assert(index<256);s->script[index]=value;return;
case 11:assert(index<2);CNOR_SetCallback(s,index,CNOR_Callback(index,value));return;
case 12:assert(index<1);*s->shared=value;return;
case 13:assert(index<8192);((uint32_t *)s->trace)[index]=value;return;
}assert(0);}
void CNOR_Reset(CNORState *s){
memset(s,0,sizeof(*s));CFMC_Reset(&s->fmc);CNOR_Activate(s);
s->h.Instance=FMC_Bank1_R;s->h.Extended=FMC_Bank1E_R;s->shared=&s->sharedWidth;
s->h.State=HAL_NOR_STATE_READY;s->h.CommandSet=NOR_AMD_FUJITSU_COMMAND_SET;
s->h.Init.MemoryType=FMC_MEMORY_TYPE_NOR;s->h.Init.WriteOperation=FMC_WRITE_OPERATION_ENABLE;
for(uint32_t i=0;i<14;i++)((uint32_t *)s->timing)[i]=(i%6)+1;
s->timing[0].AccessMode=0;s->timing[1].AccessMode=0;
for(uint32_t i=0;i<256;i++)s->buffer[i]=(uint16_t)(0x9876+i*0x102);
s->control[3]=0x80;
for(uint32_t i=0;i<2;i++)CNOR_SetCallback(s,i,CNOR_Callback(i,2));
}
uint32_t CNOR_Compare(CNORState *a,CNORState *b){
const uint32_t counts[]={88,15,3,4,4,7,7,32,16,256,256,2,1};
for(uint32_t g=0;g<13;g++)for(uint32_t i=0;i<counts[g];i++)if(CNOR_Get(a,g,i)!=CNOR_Get(b,g,i))return ((g+1)<<20)|i;
for(uint32_t i=0;i<a->control[0]*4;i++)if(CNOR_Get(a,13,i)!=CNOR_Get(b,13,i))return (14<<20)|i;
return 0;
}
uint32_t CNOR0_Run(CNORState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CNOR1_Run(CNORState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CNOR_Run(CNORState *s,uint32_t variant,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CNOR_Activate(s);return variant?CNOR1_Run(s,op,a,b,c):CNOR0_Run(s,op,a,b,c);}
uint32_t CNOR_Constant(uint32_t i){switch(i){case 0:return CFI1_ADDRESS;case 1:return CFI2_ADDRESS;case 2:return CFI3_ADDRESS;case 3:return CFI4_ADDRESS;case 4:return DEVICE_CODE1_ADDR;case 5:return DEVICE_CODE2_ADDR;case 6:return DEVICE_CODE3_ADDR;case 7:return HAL_NOR_MSP_DEINIT_CB_ID;case 8:return HAL_NOR_MSP_INIT_CB_ID;case 9:return HAL_NOR_STATE_BUSY;case 10:return HAL_NOR_STATE_ERROR;case 11:return HAL_NOR_STATE_PROTECTED;case 12:return HAL_NOR_STATE_READY;case 13:return HAL_NOR_STATE_RESET;case 14:return HAL_NOR_STATUS_ERROR;case 15:return HAL_NOR_STATUS_ONGOING;case 16:return HAL_NOR_STATUS_SUCCESS;case 17:return HAL_NOR_STATUS_TIMEOUT;case 18:return MC_ADDRESS;case 19:return NOR_MEMORY_16B;case 20:return NOR_MEMORY_8B;case 21:return NOR_MEMORY_ADRESS1;case 22:return NOR_MEMORY_ADRESS2;case 23:return NOR_MEMORY_ADRESS3;case 24:return NOR_MEMORY_ADRESS4;case 25:return NOR_TMEOUT;}assert(0);return 0;}
