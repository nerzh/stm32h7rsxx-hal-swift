#include "NANDInternal.h"
#if defined(__arm__) || defined(__thumb__)
#define CNAND_THREAD_LOCAL
#else
#define CNAND_THREAD_LOCAL _Thread_local
#endif
static CNAND_THREAD_LOCAL CNANDState *active;
size_t CNAND_Size(void){return sizeof(CNANDState);}
void CNAND_Activate(CNANDState *s){active=s;CFMC_Activate(&s->fmc);}
CNANDState *CNAND_Active(void){return active;}
uint32_t CNAND_TickFor(CNANDState *s){return CFMC_TickFor(&s->fmc);}
uint32_t CNAND_ReadRegister(CNANDState *s,uint32_t off){return CFMC_Read(&s->fmc,off);}
void CNAND_WriteRegister(CNANDState *s,uint32_t off,uint32_t value){CFMC_Write(&s->fmc,off,value);}
void *CNAND_Buffer(CNANDState *s){return s->buffer;}
void *CNAND_Value(CNANDState *s,uint32_t i){switch(i){case 0:return &s->timing[0];case 1:return &s->timing[1];case 2:return &s->device;case 3:return &s->address;case 4:return &s->id;case 5:return &s->output;}assert(0);return NULL;}
void CNAND_Trace(CNANDState *s,uint32_t kind,uint32_t address,uint32_t value){
uint32_t i=s->control[0]++;assert(i<CNAND_TRACE_CAPACITY);
s->trace[i][0]=kind;s->trace[i][1]=address;s->trace[i][2]=value;
s->trace[i][3]=((uint32_t)s->h.State<<16)|(uint32_t)s->h.Lock;
}
uint32_t CNAND_ReadMemory(CNANDState *s,uint32_t bits,uint32_t address){
assert(address==0x80000000U || address==0x80000010U);
uint32_t value;
if(s->control[1]==0x70 && bits==8){
uint32_t i=s->control[2]++;
value=i<s->control[3]?s->script[i]:s->control[4];
}else{
uint32_t i=s->control[5]++;
value=(0xA5C39E17U + i*0x10203041U)^address;
}
if(bits==8)value&=0xFF;else if(bits==16)value&=0xFFFF;else assert(bits==32);
CNAND_Trace(s,bits,address,value);return value;
}
void CNAND_WriteMemory(CNANDState *s,uint32_t bits,uint32_t address,uint32_t value){
assert(address==0x80000000U || address==0x80010000U || address==0x80020000U);
assert(bits==8 || bits==16 || bits==32);
if(address==0x80010000U)s->control[1]=value;
CNAND_Trace(s,0x100|bits,address,value);
}
void CNAND_Barrier(CNANDState *s){CNAND_Trace(s,0x200,0,0);}
void CNAND_CallbackEvent(CNANDState *s,uint32_t id,uint32_t token){
CNAND_Trace(s,0x300|id,s->fmc.registers[0x84/4],token);
if(s->control[10] && id==s->control[11]){
s->h.State=s->control[12];s->h.Lock=s->control[13];
s->fmc.registers[0x84/4]=s->control[14];
s->h.Config.PageSize=s->control[15];
}
}
static void callback10(void *p){CNAND_CallbackEvent(p,0,1);}
static void callback11(void *p){CNAND_CallbackEvent(p,1,1);}
static void callback12(void *p){CNAND_CallbackEvent(p,2,1);}
static void callback20(void *p){CNAND_CallbackEvent(p,0,2);}
static void callback21(void *p){CNAND_CallbackEvent(p,1,2);}
static void callback22(void *p){CNAND_CallbackEvent(p,2,2);}
void *CNAND_Callback(uint32_t id,uint32_t token){if(!token)return NULL;switch(token*4+id){
case 4:return callback10;
case 5:return callback11;
case 6:return callback12;
case 8:return callback20;
case 9:return callback21;
case 10:return callback22;
default:return callback20;}}
void *CNAND_GetCallback(CNANDState *s,uint32_t id){switch(id){
case 0:return s->h.MspInitCallback;
case 1:return s->h.MspDeInitCallback;
case 2:return s->h.ItCallback;
default:assert(0);return NULL;}}
void CNAND_SetCallback(CNANDState *s,uint32_t id,void *p){switch(id){
case 0:s->h.MspInitCallback=(pNAND_CallbackTypeDef)p;return;
case 1:s->h.MspDeInitCallback=(pNAND_CallbackTypeDef)p;return;
case 2:s->h.ItCallback=(pNAND_CallbackTypeDef)p;return;
default:assert(0);}}
static uint32_t callbackToken(CNANDState *s,uint32_t id){void *p=CNAND_GetCallback(s,id);if(!p)return 0;for(uint32_t t=1;t<=2;t++)for(uint32_t j=0;j<3;j++)if(p==CNAND_Callback(j,t))return (j<<8)|t;assert(0);return 0;}
uint32_t CNAND_Get(CNANDState *s,uint32_t group,uint32_t index){switch(group){
case 0:assert(index<88);return s->fmc.registers[index];
case 1:assert(index<7);return ((uint32_t *)&s->h.Init)[index];
case 2:switch(index){case 0:return s->h.Lock;case 1:return s->h.State;default:assert(0);break;}break;
case 3:assert(index<7);return ((uint32_t *)&s->h.Config)[index];
case 4:assert(index<7);return ((uint32_t *)&s->device)[index];
case 5:assert(index<3);return ((uint16_t *)&s->address)[index];
case 6:assert(index<4);return ((uint8_t *)&s->id)[index];
case 7:assert(index<4);return ((uint32_t *)&s->timing[0])[index];
case 8:assert(index<4);return ((uint32_t *)&s->timing[1])[index];
case 9:assert(index<32);return s->control[index];
case 10:assert(index<16);return s->fmc.control[index];
case 11:assert(index<4096);return s->buffer[index];
case 12:assert(index<256);return s->script[index];
case 13:assert(index<3);return callbackToken(s,index);
case 14:assert(index<1);return s->output;
case 15:assert(index<CNAND_TRACE_CAPACITY*4);return ((uint32_t *)s->trace)[index];
}assert(0);return 0;}
void CNAND_Set(CNANDState *s,uint32_t group,uint32_t index,uint32_t value){switch(group){
case 0:assert(index<88);s->fmc.registers[index]=value;return;
case 1:assert(index<7);((uint32_t *)&s->h.Init)[index]=value;return;
case 2:switch(index){case 0:s->h.Lock=value;return;case 1:s->h.State=value;return;default:assert(0);break;}break;
case 3:assert(index<7);((uint32_t *)&s->h.Config)[index]=value;return;
case 4:assert(index<7);((uint32_t *)&s->device)[index]=value;return;
case 5:assert(index<3);((uint16_t *)&s->address)[index]=value;return;
case 6:assert(index<4);((uint8_t *)&s->id)[index]=value;return;
case 7:assert(index<4);((uint32_t *)&s->timing[0])[index]=value;return;
case 8:assert(index<4);((uint32_t *)&s->timing[1])[index]=value;return;
case 9:assert(index<32);s->control[index]=value;return;
case 10:assert(index<16);s->fmc.control[index]=value;return;
case 11:assert(index<4096);s->buffer[index]=value;return;
case 12:assert(index<256);s->script[index]=value;return;
case 13:assert(index<3);CNAND_SetCallback(s,index,CNAND_Callback(index,value));return;
case 14:assert(index<1);s->output=value;return;
case 15:assert(index<CNAND_TRACE_CAPACITY*4);((uint32_t *)s->trace)[index]=value;return;
}assert(0);}
void CNAND_Reset(CNANDState *s){
memset(s,0,sizeof(*s));CFMC_Reset(&s->fmc);CNAND_Activate(s);
s->h.Instance=FMC_Bank3_R;
s->h.Init.NandBank=FMC_NAND_BANK3;
s->h.State=HAL_NAND_STATE_READY;
s->h.Config.PageSize=8;s->h.Config.SpareAreaSize=3;s->h.Config.BlockSize=4;s->h.Config.BlockNbr=8;
s->h.Config.PlaneSize=4;s->h.Config.PlaneNbr=2;
s->device=s->h.Config;
for(uint32_t i=0;i<8;i++)((uint32_t *)s->timing)[i]=i+1;
for(uint32_t i=0;i<4096;i++)s->buffer[i]=0x98765432U+i*0x1020304U;
s->control[4]=NAND_READY;s->output=0xC001C0DE;
for(uint32_t i=0;i<3;i++)CNAND_SetCallback(s,i,CNAND_Callback(i,2));
}
uint32_t CNAND_Compare(CNANDState *a,CNANDState *b){
const uint32_t counts[]={88,7,2,7,7,3,4,4,4,32,16,4096,256,3,1};
for(uint32_t g=0;g<15;g++)for(uint32_t i=0;i<counts[g];i++)if(CNAND_Get(a,g,i)!=CNAND_Get(b,g,i))return ((g+1)<<20)|i;
for(uint32_t i=0;i<a->control[0]*4;i++)if(CNAND_Get(a,15,i)!=CNAND_Get(b,15,i))return (16<<20)|i;
return 0;
}
uint32_t CNAND0_Run(CNANDState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CNAND1_Run(CNANDState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CNAND_Run(CNANDState *s,uint32_t variant,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CNAND_Activate(s);return variant?CNAND1_Run(s,op,a,b,c):CNAND0_Run(s,op,a,b,c);}
uint32_t CNAND_Constant(uint32_t i){switch(i){case 0:return ADDR_AREA;case 1:return CMD_AREA;case 2:return HAL_NAND_IT_CB_ID;case 3:return HAL_NAND_MSP_DEINIT_CB_ID;case 4:return HAL_NAND_MSP_INIT_CB_ID;case 5:return HAL_NAND_STATE_BUSY;case 6:return HAL_NAND_STATE_ERROR;case 7:return HAL_NAND_STATE_READY;case 8:return HAL_NAND_STATE_RESET;case 9:return NAND_BUSY;case 10:return NAND_CMD_AREA_A;case 11:return NAND_CMD_AREA_B;case 12:return NAND_CMD_AREA_C;case 13:return NAND_CMD_AREA_TRUE1;case 14:return NAND_CMD_ERASE0;case 15:return NAND_CMD_ERASE1;case 16:return NAND_CMD_LOCK_STATUS;case 17:return NAND_CMD_READID;case 18:return NAND_CMD_RESET;case 19:return NAND_CMD_STATUS;case 20:return NAND_CMD_WRITE0;case 21:return NAND_CMD_WRITE_TRUE1;case 22:return NAND_DEVICE;case 23:return NAND_ERROR;case 24:return NAND_INVALID_ADDRESS;case 25:return NAND_READY;case 26:return NAND_TIMEOUT_ERROR;case 27:return NAND_VALID_ADDRESS;case 28:return NAND_WRITE_TIMEOUT;}assert(0);return 0;}
