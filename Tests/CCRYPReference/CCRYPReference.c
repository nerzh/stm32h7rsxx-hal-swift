#include "CRYPInternal.h"
CCRYP_THREAD_LOCAL CCRYPState *CCRYP_Active;
_Static_assert(sizeof(CRYP_TypeDef)==0x90,"CRYP register layout");
_Static_assert(sizeof(SAES_TypeDef)==0x30C,"SAES register layout");
size_t CCRYP_Size(void) { return sizeof(CCRYPState); }
uint32_t *CCRYP_Control(CCRYPState *s){ return s->control; }
uint32_t *CCRYP_Trace(CCRYPState *s){ return s->trace; }
uint32_t *CCRYP_Buffer(CCRYPState *s,uint32_t i){ assert(i<8);return s->buffers[i]; }
uint32_t CCRYP_GetRegister(CCRYPState *s,uint32_t o){ assert((o&3)==0&&o<0x310);return s->registers[o/4]; }
void CCRYP_SetRegister(CCRYPState *s,uint32_t o,uint32_t v){ assert((o&3)==0&&o<0x310);s->registers[o/4]=v; }
void CCRYP_Event(CCRYPState *s,uint32_t i,uint32_t due,uint32_t offset,uint32_t value){assert(i<32);s->events[i][0]=1;s->events[i][1]=due;s->events[i][2]=offset;s->events[i][3]=value;}
uint32_t CCRYP_TickFor(CCRYPState *s){
 uint32_t v=s->control[4];s->control[4]+=s->control[5];s->control[6]++;
 for(uint32_t i=0;i<32;i++)if(s->events[i][0]&&s->events[i][1]==s->control[6]){s->events[i][0]=0;CCRYP_SetRegister(s,s->events[i][2],s->events[i][3]);}
 return v;
}
uint32_t CCRYP_Tick(void){return CCRYP_TickFor(CCRYP_Active);}
static void trace(CCRYPState *s,uint32_t kind,uint32_t a,uint32_t b,uint32_t c,uint32_t d){uint32_t *n=&s->control[8];assert(*n+5<=1024);s->trace[(*n)++]=kind;s->trace[(*n)++]=a;s->trace[(*n)++]=b;s->trace[(*n)++]=c;s->trace[(*n)++]=d;}
void CCRYP_Invoke(CCRYPState *s,uint32_t id,uint32_t value){
 trace(s,id,value,s->h.State,s->h.ErrorCode,s->h.Lock);
 if(s->control[9]&&s->control[10]==id)s->h.State=s->control[11];
 if(s->control[12]&&s->control[15]==id)CCRYP_SetRegister(s,s->control[13],s->control[14]);
}
void HAL_CRYP_InCpltCallback(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,1,1);}
static void CB1_2(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,1,2);}
static void CB1_3(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,1,3);}
void HAL_CRYP_OutCpltCallback(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,2,1);}
static void CB2_2(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,2,2);}
static void CB2_3(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,2,3);}
void HAL_CRYP_ErrorCallback(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,3,1);}
static void CB3_2(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,3,2);}
static void CB3_3(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,3,3);}
void HAL_CRYP_MspInit(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,4,1);}
static void CB4_2(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,4,2);}
static void CB4_3(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,4,3);}
void HAL_CRYP_MspDeInit(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,5,1);}
static void CB5_2(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,5,2);}
static void CB5_3(CRYP_HandleTypeDef *h){CCRYP_Invoke((CCRYPState *)h,5,3);}
pCRYP_CallbackTypeDef CCRYP_CallbackPointer(uint32_t id,uint32_t v){if(!v)return NULL;switch(id){
case 1:return v==1?HAL_CRYP_InCpltCallback:v==2?CB1_2:CB1_3;
case 2:return v==1?HAL_CRYP_OutCpltCallback:v==2?CB2_2:CB2_3;
case 3:return v==1?HAL_CRYP_ErrorCallback:v==2?CB3_2:CB3_3;
case 4:return v==1?HAL_CRYP_MspInit:v==2?CB4_2:CB4_3;
case 5:return v==1?HAL_CRYP_MspDeInit:v==2?CB5_2:CB5_3;
default:assert(0);return NULL;} }
uint32_t CCRYP_GetCallback(CCRYPState *s,uint32_t id){pCRYP_CallbackTypeDef f=NULL;switch(id){
case 1:f=s->h.InCpltCallback;break;
case 2:f=s->h.OutCpltCallback;break;
case 3:f=s->h.ErrorCallback;break;
case 4:f=s->h.MspInitCallback;break;
case 5:f=s->h.MspDeInitCallback;break;
default:assert(0);}for(uint32_t v=0;v<4;v++)if(f==CCRYP_CallbackPointer(id,v))return v;assert(0);return 0;}
void CCRYP_SetCallback(CCRYPState *s,uint32_t id,uint32_t v){switch(id){
case 1:s->h.InCpltCallback=CCRYP_CallbackPointer(id,v);break;
case 2:s->h.OutCpltCallback=CCRYP_CallbackPointer(id,v);break;
case 3:s->h.ErrorCallback=CCRYP_CallbackPointer(id,v);break;
case 4:s->h.MspInitCallback=CCRYP_CallbackPointer(id,v);break;
case 5:s->h.MspDeInitCallback=CCRYP_CallbackPointer(id,v);break;
default:assert(0);} }
uint32_t CCRYP_GetWord(CCRYPState *s,uint32_t i){switch(i){
case 0:return s->h.Init.DataType;
case 1:return s->h.Init.KeySize;
case 2:return s->h.Init.Algorithm;
case 3:return s->h.Init.HeaderSize;
case 4:return s->h.Init.DataWidthUnit;
case 5:return s->h.Init.HeaderWidthUnit;
case 6:return s->h.Init.KeyIVConfigSkip;
case 7:return s->h.Init.KeyMode;
case 8:return s->h.Init.KeySelect;
case 9:return s->h.Init_saved.DataType;
case 10:return s->h.Init_saved.KeySize;
case 11:return s->h.Init_saved.Algorithm;
case 12:return s->h.Init_saved.HeaderSize;
case 13:return s->h.Init_saved.DataWidthUnit;
case 14:return s->h.Init_saved.HeaderWidthUnit;
case 15:return s->h.Init_saved.KeyIVConfigSkip;
case 16:return s->h.Init_saved.KeyMode;
case 17:return s->h.Init_saved.KeySelect;
case 18:return s->h.Phase;
case 19:return s->h.Lock;
case 20:return s->h.State;
case 21:return s->h.ErrorCode;
case 22:return s->h.Version;
case 23:return s->h.KeyIVConfig;
case 24:return s->h.SizesSum;
case 25:return s->h.SuspendRequest;
case 26:return s->h.CrypInCount_saved;
case 27:return s->h.CrypOutCount_saved;
case 28:return s->h.Phase_saved;
case 29:return s->h.State_saved;
case 30:return s->h.CR_saved;
case 31:return s->h.SizesSum_saved;
case 32:return s->h.ResumingFlag;
case 33:return s->h.SuspendedProcessing;
case 34:return s->h.CrypHeaderCount;
case 35:return s->h.CrypInCount;
case 36:return s->h.CrypOutCount;
case 37:return s->h.Size;
case 38:return s->h.Size_saved;
case 39:return s->h.CrypHeaderCount_saved;
default:assert(0);return 0;} }
void CCRYP_SetWord(CCRYPState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->h.Init.DataType=v;break;
case 1:s->h.Init.KeySize=v;break;
case 2:s->h.Init.Algorithm=v;break;
case 3:s->h.Init.HeaderSize=v;break;
case 4:s->h.Init.DataWidthUnit=v;break;
case 5:s->h.Init.HeaderWidthUnit=v;break;
case 6:s->h.Init.KeyIVConfigSkip=v;break;
case 7:s->h.Init.KeyMode=v;break;
case 8:s->h.Init.KeySelect=v;break;
case 9:s->h.Init_saved.DataType=v;break;
case 10:s->h.Init_saved.KeySize=v;break;
case 11:s->h.Init_saved.Algorithm=v;break;
case 12:s->h.Init_saved.HeaderSize=v;break;
case 13:s->h.Init_saved.DataWidthUnit=v;break;
case 14:s->h.Init_saved.HeaderWidthUnit=v;break;
case 15:s->h.Init_saved.KeyIVConfigSkip=v;break;
case 16:s->h.Init_saved.KeyMode=v;break;
case 17:s->h.Init_saved.KeySelect=v;break;
case 18:s->h.Phase=v;break;
case 19:s->h.Lock=v;break;
case 20:s->h.State=v;break;
case 21:s->h.ErrorCode=v;break;
case 22:s->h.Version=v;break;
case 23:s->h.KeyIVConfig=v;break;
case 24:s->h.SizesSum=v;break;
case 25:s->h.SuspendRequest=v;break;
case 26:s->h.CrypInCount_saved=v;break;
case 27:s->h.CrypOutCount_saved=v;break;
case 28:s->h.Phase_saved=v;break;
case 29:s->h.State_saved=v;break;
case 30:s->h.CR_saved=v;break;
case 31:s->h.SizesSum_saved=v;break;
case 32:s->h.ResumingFlag=v;break;
case 33:s->h.SuspendedProcessing=v;break;
case 34:s->h.CrypHeaderCount=v;break;
case 35:s->h.CrypInCount=v;break;
case 36:s->h.CrypOutCount=v;break;
case 37:s->h.Size=v;break;
case 38:s->h.Size_saved=v;break;
case 39:s->h.CrypHeaderCount_saved=v;break;
default:assert(0);} }
void *CCRYP_GetPointer(CCRYPState *s,uint32_t i){switch(i){
case 0:return s->h.Init.pKey;
case 1:return s->h.Init.pInitVect;
case 2:return s->h.Init.Header;
case 3:return s->h.Init.B0;
case 4:return s->h.pCrypInBuffPtr;
case 5:return s->h.pCrypOutBuffPtr;
case 6:return s->h.Init_saved.pKey;
case 7:return s->h.Init_saved.pInitVect;
case 8:return s->h.Init_saved.Header;
case 9:return s->h.Init_saved.B0;
case 10:return s->h.pCrypInBuffPtr_saved;
case 11:return s->h.pCrypOutBuffPtr_saved;
default:assert(0);return NULL;} }
void CCRYP_SetPointer(CCRYPState *s,uint32_t i,void *v){switch(i){
case 0:s->h.Init.pKey=v;break;
case 1:s->h.Init.pInitVect=v;break;
case 2:s->h.Init.Header=v;break;
case 3:s->h.Init.B0=v;break;
case 4:s->h.pCrypInBuffPtr=v;break;
case 5:s->h.pCrypOutBuffPtr=v;break;
case 6:s->h.Init_saved.pKey=v;break;
case 7:s->h.Init_saved.pInitVect=v;break;
case 8:s->h.Init_saved.Header=v;break;
case 9:s->h.Init_saved.B0=v;break;
case 10:s->h.pCrypInBuffPtr_saved=v;break;
case 11:s->h.pCrypOutBuffPtr_saved=v;break;
default:assert(0);} }
uint32_t *CCRYP_SavedWords(CCRYPState *s,uint32_t i){switch(i){case 0:return s->h.IV_saved;case 1:return s->h.SUSPxR_saved;case 2:return s->h.Key_saved;default:assert(0);return NULL;}}
uint32_t CCRYP_Normalize(CCRYPState *s,uintptr_t p){
 if(!p)return 0;
 for(uint32_t i=0;i<8;i++){uintptr_t base=(uintptr_t)s->buffers[i];uintptr_t d=p>UINT32_MAX?p-base:(uint32_t)p-(uint32_t)base;if(d<=1024)return 0x20000000U+i*0x1000U+(uint32_t)d;}
 for(uint32_t i=0;i<3;i++){uintptr_t base=(uintptr_t)CCRYP_SavedWords(s,i);uintptr_t d=p>UINT32_MAX?p-base:(uint32_t)p-(uint32_t)base;uint32_t size=i==0?16:i==1?64:32;if(d<size)return 0x20010000U+i*0x100U+(uint32_t)d;}
 uintptr_t base=(uintptr_t)s->registers;uintptr_t d=p>UINT32_MAX?p-base:(uint32_t)p-(uint32_t)base;if(d<sizeof(s->registers))return (s->control[3]?SAES_BASE:CRYP_BASE)+(uint32_t)d;
 return (uint32_t)p;
}
HAL_StatusTypeDef CCRYP_DMAStart(DMA_HandleTypeDef *h,uint32_t src,uint32_t dst,uint32_t count){CCRYPState *s=CCRYP_Active;uint32_t ch=(uint32_t)(h-s->dma);trace(s,100+ch,CCRYP_Normalize(s,src),CCRYP_Normalize(s,dst),count,h->State);return s->control[32+ch*4];}
HAL_StatusTypeDef CCRYP_DMAList(DMA_HandleTypeDef *h){CCRYPState *s=CCRYP_Active;uint32_t ch=(uint32_t)(h-s->dma);trace(s,110+ch,0,0,0,h->State);return s->control[33+ch*4];}
HAL_StatusTypeDef CCRYP_DMAAbort(DMA_HandleTypeDef *h){CCRYPState *s=CCRYP_Active;uint32_t ch=(uint32_t)(h-s->dma);trace(s,120+ch,0,0,0,h->State);return s->control[34+ch*4];}
void CCRYP_Reset(CCRYPState *s,uint32_t cb,uint32_t su,uint32_t en,uint32_t ip){
 memset(s,0,sizeof(*s));s->control[0]=cb;s->control[1]=su;s->control[2]=en;s->control[3]=ip;s->control[5]=1;s->control[7]=0x1000;
 s->h.Instance=s->registers;s->h.Init.Algorithm=CRYP_AES_ECB;s->h.Init.pKey=s->buffers[2];s->h.Init.pInitVect=s->buffers[3];s->h.Init.Header=s->buffers[4];s->h.Init.B0=s->buffers[5];
 s->h.pCrypInBuffPtr=s->buffers[0];s->h.pCrypOutBuffPtr=s->buffers[1];s->h.hdmain=&s->dma[0];s->h.hdmaout=&s->dma[1];
 for(uint32_t i=0;i<2;i++){s->dma[i].Instance=&s->channels[i];s->dma[i].Parent=&s->h;s->dma[i].LinkedListQueue=&s->queues[i];s->queues[i].Head=&s->nodes[i];}
 for(uint32_t i=1;i<=5;i++)CCRYP_SetCallback(s,i,1);
 for(uint32_t k=0;k<8;k++)for(uint32_t i=0;i<256;i++)s->buffers[k][i]=0x10203040U+k*0x1010101U+i*0x10203U;
 s->configuration=s->h.Init;
}
uint32_t CCRYP_Run(CCRYPState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CCRYP_Active=s;switch(s->control[0]*6+s->control[1]*3+s->control[2]){
case 0:return CCRYP000_Run(s,op,a,b,c);
case 1:return CCRYP001_Run(s,op,a,b,c);
case 2:return CCRYP002_Run(s,op,a,b,c);
case 3:return CCRYP010_Run(s,op,a,b,c);
case 4:return CCRYP011_Run(s,op,a,b,c);
case 5:return CCRYP012_Run(s,op,a,b,c);
case 6:return CCRYP100_Run(s,op,a,b,c);
case 7:return CCRYP101_Run(s,op,a,b,c);
case 8:return CCRYP102_Run(s,op,a,b,c);
case 9:return CCRYP110_Run(s,op,a,b,c);
case 10:return CCRYP111_Run(s,op,a,b,c);
case 11:return CCRYP112_Run(s,op,a,b,c);
default:assert(0);return 0;}}
uint32_t CCRYP_Constant(uint32_t i){switch(i){
case 0:return CRYP_AES_CBC;
case 1:return CRYP_AES_CCM;
case 2:return CRYP_AES_CTR;
case 3:return CRYP_AES_ECB;
case 4:return CRYP_AES_GCM;
case 5:return CRYP_AES_KEY;
case 6:return CRYP_BIT_SWAP;
case 7:return CRYP_BYTE_SWAP;
case 8:return CRYP_CLEAR_CCF;
case 9:return CRYP_CLEAR_KEIF;
case 10:return CRYP_CLEAR_RNGEIF;
case 11:return CRYP_CLEAR_RWEIF;
case 12:return CRYP_DATATYPE_16B;
case 13:return CRYP_DATATYPE_1B;
case 14:return CRYP_DATATYPE_32B;
case 15:return CRYP_DATATYPE_8B;
case 16:return CRYP_DATAWIDTHUNIT_BYTE;
case 17:return CRYP_DATAWIDTHUNIT_WORD;
case 18:return CRYP_FLAG_BUSY;
case 19:return CRYP_FLAG_CCF;
case 20:return CRYP_FLAG_IFEM;
case 21:return CRYP_FLAG_IFNF;
case 22:return CRYP_FLAG_INRIS;
case 23:return CRYP_FLAG_KEIF;
case 24:return CRYP_FLAG_KERF;
case 25:return CRYP_FLAG_KEYVALID;
case 26:return CRYP_FLAG_MASK;
case 27:return CRYP_FLAG_OFFU;
case 28:return CRYP_FLAG_OFNE;
case 29:return CRYP_FLAG_OUTRIS;
case 30:return CRYP_FLAG_RDERR;
case 31:return CRYP_FLAG_RNGEIF;
case 32:return CRYP_FLAG_RWEIF;
case 33:return CRYP_FLAG_WRERR;
case 34:return CRYP_HALFWORD_SWAP;
case 35:return CRYP_HEADERWIDTHUNIT_BYTE;
case 36:return CRYP_HEADERWIDTHUNIT_WORD;
case 37:return CRYP_IT_CCFIE;
case 38:return CRYP_IT_INI;
case 39:return CRYP_IT_KEIE;
case 40:return CRYP_IT_OUTI;
case 41:return CRYP_IT_RNGEIE;
case 42:return CRYP_IT_RWEIE;
case 43:return CRYP_KEYIVCONFIG_ALWAYS;
case 44:return CRYP_KEYIVCONFIG_ONCE;
case 45:return CRYP_KEYMODE_NORMAL;
case 46:return CRYP_KEYMODE_SHARED;
case 47:return CRYP_KEYMODE_WRAPPED;
case 48:return CRYP_KEYNOCONFIG;
case 49:return CRYP_KEYSEL_AHK;
case 50:return CRYP_KEYSEL_DUK_AHK;
case 51:return CRYP_KEYSEL_HSW;
case 52:return CRYP_KEYSEL_HW;
case 53:return CRYP_KEYSEL_NORMAL;
case 54:return CRYP_KEYSEL_SW;
case 55:return CRYP_KEYSEL_TEST_KEY;
case 56:return CRYP_KEYSHARED_CRYP;
case 57:return CRYP_KEYSIZE_128B;
case 58:return CRYP_KEYSIZE_192B;
case 59:return CRYP_KEYSIZE_256B;
case 60:return CRYP_MODE_DECRYPT;
case 61:return CRYP_MODE_ENCRYPT;
case 62:return CRYP_MODE_KEY_DERIVATION;
case 63:return CRYP_NO_SWAP;
case 64:return CRYP_OPERATINGMODE_DECRYPT;
case 65:return CRYP_OPERATINGMODE_ENCRYPT;
case 66:return HAL_CRYP_ERROR_AUTH_TAG_SEQUENCE;
case 67:return HAL_CRYP_ERROR_BUSY;
case 68:return HAL_CRYP_ERROR_CB_ID;
case 69:return HAL_CRYP_ERROR_DMA;
case 70:return HAL_CRYP_ERROR_INVALID_CALLBACK;
case 71:return HAL_CRYP_ERROR_KEY;
case 72:return HAL_CRYP_ERROR_NONE;
case 73:return HAL_CRYP_ERROR_NOT_SUPPORTED;
case 74:return HAL_CRYP_ERROR_READ;
case 75:return HAL_CRYP_ERROR_RNG;
case 76:return HAL_CRYP_ERROR_TIMEOUT;
case 77:return HAL_CRYP_ERROR_WRITE;
case 78:return HAL_CRYP_INPUT_COMPLETE_CB_ID;
case 79:return HAL_CRYP_MSPDEINIT_CB_ID;
case 80:return HAL_CRYP_MSPINIT_CB_ID;
case 81:return HAL_CRYP_OUTPUT_COMPLETE_CB_ID;
case 82:return HAL_CRYP_STATE_BUSY;
case 83:return HAL_CRYP_STATE_READY;
case 84:return HAL_CRYP_STATE_RESET;
case 85:return HAL_CRYP_STATE_SUSPENDED;
case 86:return HAL_CRYP_SUSPEND;
case 87:return HAL_CRYP_SUSPEND_NONE;
case 88:return SAES_CR_CHMOD_AES_CBC;
case 89:return SAES_CR_CHMOD_AES_CCM;
case 90:return SAES_CR_CHMOD_AES_CTR;
case 91:return SAES_CR_CHMOD_AES_ECB;
case 92:return SAES_CR_CHMOD_AES_GCM;
case 93:return SAES_FLAG_BUSY;
default:assert(0);return 0;}}
uint32_t CCRYP_GetConfigurationWord(CCRYPState *s,uint32_t i){switch(i){
case 0:return s->configuration.DataType;
case 1:return s->configuration.KeySize;
case 2:return s->configuration.Algorithm;
case 3:return s->configuration.HeaderSize;
case 4:return s->configuration.DataWidthUnit;
case 5:return s->configuration.HeaderWidthUnit;
case 6:return s->configuration.KeyIVConfigSkip;
case 7:return s->configuration.KeyMode;
case 8:return s->configuration.KeySelect;
default:assert(0);return 0;}}
void CCRYP_SetConfigurationWord(CCRYPState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->configuration.DataType=v;break;
case 1:s->configuration.KeySize=v;break;
case 2:s->configuration.Algorithm=v;break;
case 3:s->configuration.HeaderSize=v;break;
case 4:s->configuration.DataWidthUnit=v;break;
case 5:s->configuration.HeaderWidthUnit=v;break;
case 6:s->configuration.KeyIVConfigSkip=v;break;
case 7:s->configuration.KeyMode=v;break;
case 8:s->configuration.KeySelect=v;break;
default:assert(0);}}
void * CCRYP_GetConfigurationPointer(CCRYPState *s,uint32_t i){switch(i){
case 0:return s->configuration.pKey;
case 1:return s->configuration.pInitVect;
case 2:return s->configuration.Header;
case 3:return s->configuration.B0;
default:assert(0);return 0;}}
void CCRYP_SetConfigurationPointer(CCRYPState *s,uint32_t i,void * v){switch(i){
case 0:s->configuration.pKey=v;break;
case 1:s->configuration.pInitVect=v;break;
case 2:s->configuration.Header=v;break;
case 3:s->configuration.B0=v;break;
default:assert(0);}}
uint32_t CCRYP_GetDMA(CCRYPState *s,uint32_t ch,uint32_t w){assert(ch<2);DMA_HandleTypeDef *d=&s->dma[ch];switch(w){case 0:return d->Mode;case 1:return d->State;case 2:return d->ErrorCode;case 3:return d->Lock;case 4:return d->LinkedListQueue!=NULL;case 5:return s->queues[ch].Head!=NULL;case 6:return d->Instance->CBR1;case 7:return d->Instance->CSR;default:assert(0);return 0;}}
void CCRYP_SetDMA(CCRYPState *s,uint32_t ch,uint32_t w,uint32_t v){assert(ch<2);DMA_HandleTypeDef *d=&s->dma[ch];switch(w){case 0:d->Mode=v;break;case 1:d->State=v;break;case 2:d->ErrorCode=v;break;case 3:d->Lock=v;break;case 4:d->LinkedListQueue=v?&s->queues[ch]:NULL;break;case 5:s->queues[ch].Head=v?&s->nodes[ch]:NULL;break;case 6:d->Instance->CBR1=v;break;case 7:d->Instance->CSR=v;break;default:assert(0);}}
uint32_t CCRYP_GetNode(CCRYPState *s,uint32_t ch,uint32_t i){assert(ch<2&&i<8);uint32_t v=s->nodes[ch].LinkRegisters[i];return i==3||i==4?CCRYP_Normalize(s,v):v;}
void CCRYP_SetNode(CCRYPState *s,uint32_t ch,uint32_t i,uint32_t v){assert(ch<2&&i<8);s->nodes[ch].LinkRegisters[i]=v;}
uint32_t CCRYP_DMAOperation(CCRYPState *s,uint32_t ch,uint32_t op,uint32_t src,uint32_t dst,uint32_t size){CCRYP_Active=s;switch(op){case 0:return CCRYP_DMAStart(&s->dma[ch],src,dst,size);case 1:return CCRYP_DMAList(&s->dma[ch]);case 2:return CCRYP_DMAAbort(&s->dma[ch]);default:assert(0);return 0;}}
uint32_t CCRYP_GetDMACallback(CCRYPState *s,uint32_t ch,uint32_t id){switch(s->control[0]*6+s->control[1]*3+s->control[2]){
case 0:return CCRYP000_GetDMACallback(s,ch,id);
case 1:return CCRYP001_GetDMACallback(s,ch,id);
case 2:return CCRYP002_GetDMACallback(s,ch,id);
case 3:return CCRYP010_GetDMACallback(s,ch,id);
case 4:return CCRYP011_GetDMACallback(s,ch,id);
case 5:return CCRYP012_GetDMACallback(s,ch,id);
case 6:return CCRYP100_GetDMACallback(s,ch,id);
case 7:return CCRYP101_GetDMACallback(s,ch,id);
case 8:return CCRYP102_GetDMACallback(s,ch,id);
case 9:return CCRYP110_GetDMACallback(s,ch,id);
case 10:return CCRYP111_GetDMACallback(s,ch,id);
case 11:return CCRYP112_GetDMACallback(s,ch,id);
default:assert(0);return 0;}}
void CCRYP_SetDMACallback(CCRYPState *s,uint32_t ch,uint32_t id,uint32_t v){switch(s->control[0]*6+s->control[1]*3+s->control[2]){
case 0:CCRYP000_SetDMACallback(s,ch,id,v);break;
case 1:CCRYP001_SetDMACallback(s,ch,id,v);break;
case 2:CCRYP002_SetDMACallback(s,ch,id,v);break;
case 3:CCRYP010_SetDMACallback(s,ch,id,v);break;
case 4:CCRYP011_SetDMACallback(s,ch,id,v);break;
case 5:CCRYP012_SetDMACallback(s,ch,id,v);break;
case 6:CCRYP100_SetDMACallback(s,ch,id,v);break;
case 7:CCRYP101_SetDMACallback(s,ch,id,v);break;
case 8:CCRYP102_SetDMACallback(s,ch,id,v);break;
case 9:CCRYP110_SetDMACallback(s,ch,id,v);break;
case 10:CCRYP111_SetDMACallback(s,ch,id,v);break;
case 11:CCRYP112_SetDMACallback(s,ch,id,v);break;
default:assert(0);}}
