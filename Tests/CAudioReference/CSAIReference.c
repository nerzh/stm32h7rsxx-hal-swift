#include "SAIInternal.h"
CAUDIO_THREAD_LOCAL CSAIState *CSAI_Active;
size_t CSAI_Size(void){return sizeof(CSAIState);}
void CSAI_Activate(CSAIState *s){CSAI_Active=s;}
uint8_t *CSAI_Buffer(CSAIState *s,uint32_t i){return (uint8_t *)s->buffers[i];}
uintptr_t CSAI_GetPointer(CSAIState *s,uint32_t i){switch(i){case 0:return (uintptr_t)s->h.pBuffPtr;default:assert(0);return 0;}}
void CSAI_SetPointer(CSAIState *s,uint32_t i,uintptr_t v){switch(i){case 0:s->h.pBuffPtr=(void *)v;break;default:assert(0);break;}}
uint32_t CSAI_TickFor(CSAIState *s){uint32_t v=s->control[2];s->control[2]+=s->control[3];s->control[4]++;if(s->control[10]&&s->control[4]==s->control[10])((volatile uint32_t *)s->h.Instance)[s->control[11]]=s->control[12];return v;}
uint32_t CSAI_Tick(void){return CSAI_TickFor(CSAI_Active);}
uint32_t CSAI_ClockFor(CSAIState *s,uint32_t v){s->control[7]++;s->control[17]=v;return s->control[5];}
uint32_t CSAI_Clock(uint32_t v){return CSAI_ClockFor(CSAI_Active,v);}
uint32_t CSAI_Run(CSAIState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CSAIState *old=CSAI_Active;CSAI_Active=s;uint32_t r=s->control[63]?CSAI1_Run(s,op,a,b,c):CSAI0_Run(s,op,a,b,c);CSAI_Active=old;return r;}
uint32_t CSAI_Get(CSAIState *s,uint32_t g,uint32_t i){switch(g){
case 0:assert(i<8);return ((volatile uint32_t *)s->h.Instance)[i];
case 1:return s->control[63]?CSAI1_GetWord(s,i):CSAI0_GetWord(s,i);
case 2:assert(i<64);return s->control[i];
case 3:case 4:{uint32_t d=g-3;assert(i<16);switch(i){case 1:return s->dma[d].Init.Mode;case 2:return s->dma[d].Mode;case 3:return s->dma[d].ErrorCode;case 4:return s->dma[d].State;default:return s->settings[d][i];}}
case 5:case 6:assert(i<8);return s->node[g-5].LinkRegisters[i];
case 7:assert(i<1024);return s->trace[i];
case 8:assert(i<1024);return s->dmaTrace[i];
case 9:case 10:return s->control[63]?CSAI1_GetDMA(s,g-9,i):CSAI0_GetDMA(s,g-9,i);
case 11:assert(i<38);return ((volatile uint32_t *)s->global)[i];
default:assert(0);return 0;}}
void CSAI_Set(CSAIState *s,uint32_t g,uint32_t i,uint32_t v){switch(g){
case 0:assert(i<8);((volatile uint32_t *)s->h.Instance)[i]=v;break;
case 1:if(s->control[63])CSAI1_SetWord(s,i,v);else CSAI0_SetWord(s,i,v);break;
case 2:assert(i<64);s->control[i]=v;if(i==0){assert(v<4);s->h.Instance=&s->regs[v];}break;
case 3:case 4:{uint32_t d=g-3;assert(i<16);s->settings[d][i]=v;switch(i){
case 0:if(d)s->h.hdmarx=v?&s->dma[d]:NULL;else s->h.hdmatx=v?&s->dma[d]:NULL;break;
case 1:s->dma[d].Init.Mode=v;break;case 2:s->dma[d].Mode=v;break;case 3:s->dma[d].ErrorCode=v;break;case 4:s->dma[d].State=v;break;case 5:s->dma[d].LinkedListQueue=v?&s->queue[d]:NULL;break;case 6:s->queue[d].Head=v?&s->node[d]:NULL;break;default:break;}break;}
case 5:case 6:assert(i<8);s->node[g-5].LinkRegisters[i]=v;break;
case 7:assert(i<1024);s->trace[i]=v;break;case 8:assert(i<1024);s->dmaTrace[i]=v;break;
case 9:case 10:if(s->control[63])CSAI1_SetDMA(s,g-9,i,v);else CSAI0_SetDMA(s,g-9,i,v);break;
case 11:assert(i<38);((volatile uint32_t *)s->global)[i]=v;break;
default:assert(0);break;}}
static void traceCallback(SAI_HandleTypeDef *h,uint32_t id,uint32_t custom){CSAIState *s=(CSAIState *)h;uint32_t *n=&s->control[8];assert(*n+10<=1024);s->trace[(*n)++]=id;s->trace[(*n)++]=custom;s->trace[(*n)++]=h->State;s->trace[(*n)++]=h->ErrorCode;s->trace[(*n)++]=h->Lock;s->trace[(*n)++]=h->XferCount;s->trace[(*n)++]=0;s->trace[(*n)++]=h->Instance->CR1;s->trace[(*n)++]=s->control[7];s->trace[(*n)++]=s->control[4];if(s->control[20]&&s->control[20]-1==id){CSAI_Set(s,1,s->control[21],s->control[22]);s->control[20]=0;}}
void HAL_SAI_RxCpltCallback(SAI_HandleTypeDef *h){traceCallback(h,0,0);}
static void Custom0(SAI_HandleTypeDef *h){traceCallback(h,0,1);}
void HAL_SAI_RxHalfCpltCallback(SAI_HandleTypeDef *h){traceCallback(h,1,0);}
static void Custom1(SAI_HandleTypeDef *h){traceCallback(h,1,1);}
void HAL_SAI_TxCpltCallback(SAI_HandleTypeDef *h){traceCallback(h,2,0);}
static void Custom2(SAI_HandleTypeDef *h){traceCallback(h,2,1);}
void HAL_SAI_TxHalfCpltCallback(SAI_HandleTypeDef *h){traceCallback(h,3,0);}
static void Custom3(SAI_HandleTypeDef *h){traceCallback(h,3,1);}
void HAL_SAI_ErrorCallback(SAI_HandleTypeDef *h){traceCallback(h,4,0);}
static void Custom4(SAI_HandleTypeDef *h){traceCallback(h,4,1);}
void HAL_SAI_MspInit(SAI_HandleTypeDef *h){traceCallback(h,5,0);}
static void Custom5(SAI_HandleTypeDef *h){traceCallback(h,5,1);}
void HAL_SAI_MspDeInit(SAI_HandleTypeDef *h){traceCallback(h,6,0);}
static void Custom6(SAI_HandleTypeDef *h){traceCallback(h,6,1);}
static void Mute(void){traceCallback(&CSAI_Active->h,7,0);}
static void CustomMute(void){traceCallback(&CSAI_Active->h,7,1);}
uintptr_t CSAI_Callback(uint32_t id,uint32_t custom){if(!custom)return 0;switch(id){
case 0:return (uintptr_t)(custom==1?HAL_SAI_RxCpltCallback:Custom0);
case 1:return (uintptr_t)(custom==1?HAL_SAI_RxHalfCpltCallback:Custom1);
case 2:return (uintptr_t)(custom==1?HAL_SAI_TxCpltCallback:Custom2);
case 3:return (uintptr_t)(custom==1?HAL_SAI_TxHalfCpltCallback:Custom3);
case 4:return (uintptr_t)(custom==1?HAL_SAI_ErrorCallback:Custom4);
case 5:return (uintptr_t)(custom==1?HAL_SAI_MspInit:Custom5);
case 6:return (uintptr_t)(custom==1?HAL_SAI_MspDeInit:Custom6);
case 7:return (uintptr_t)(custom==1?Mute:CustomMute);
default:assert(0);return 0;}}
uintptr_t CSAI_GetCallback(CSAIState *s,uint32_t i){switch(i){
case 0:return (uintptr_t)s->h.RxCpltCallback;
case 1:return (uintptr_t)s->h.RxHalfCpltCallback;
case 2:return (uintptr_t)s->h.TxCpltCallback;
case 3:return (uintptr_t)s->h.TxHalfCpltCallback;
case 4:return (uintptr_t)s->h.ErrorCallback;
case 5:return (uintptr_t)s->h.MspInitCallback;
case 6:return (uintptr_t)s->h.MspDeInitCallback;
case 7:return (uintptr_t)s->h.mutecallback;
default:assert(0);return 0;}}
void CSAI_SetCallback(CSAIState *s,uint32_t i,uintptr_t v){switch(i){
case 0:s->h.RxCpltCallback=(pSAI_CallbackTypeDef)v;break;
case 1:s->h.RxHalfCpltCallback=(pSAI_CallbackTypeDef)v;break;
case 2:s->h.TxCpltCallback=(pSAI_CallbackTypeDef)v;break;
case 3:s->h.TxHalfCpltCallback=(pSAI_CallbackTypeDef)v;break;
case 4:s->h.ErrorCallback=(pSAI_CallbackTypeDef)v;break;
case 5:s->h.MspInitCallback=(pSAI_CallbackTypeDef)v;break;
case 6:s->h.MspDeInitCallback=(pSAI_CallbackTypeDef)v;break;
case 7:s->h.mutecallback=(SAIcallback)v;break;
default:assert(0);break;}}
static uint32_t normalize(CSAIState *s,uintptr_t value){uint32_t v=(uint32_t)value;for(uint32_t i=0;i<2;i++){uint32_t b=(uint32_t)(uintptr_t)s->buffers[i];if((uint32_t)(v-b)<4096)return 0xABC00000U+i*0x10000U+v-b;}const uint32_t bases[4]={0x42005804,0x42005824,0x42005c04,0x42005c24};for(uint32_t i=0;i<4;i++){uint32_t b=(uint32_t)(uintptr_t)&s->regs[i];if((uint32_t)(v-b)<sizeof(s->regs[i]))return bases[i]+v-b;}return v;}
uint32_t CSAI_RecordDMA(CSAIState *s,uint32_t d,uint32_t op,uint32_t src,uint32_t dst,uint32_t size){uint32_t *n=&s->control[9];assert(*n+8<=1024);s->dmaTrace[(*n)++]=d;s->dmaTrace[(*n)++]=op;s->dmaTrace[(*n)++]=normalize(s,src);s->dmaTrace[(*n)++]=normalize(s,dst);s->dmaTrace[(*n)++]=size;s->dmaTrace[(*n)++]=s->h.State;s->dmaTrace[(*n)++]=s->h.Lock;s->dmaTrace[(*n)++]=s->h.Instance->CR1;return s->settings[d][7+op];}
static HAL_StatusTypeDef action(DMA_HandleTypeDef *h,uint32_t op,uint32_t a,uint32_t b,uint32_t n){CSAIState *s=CSAI_Active;uint32_t d=h==&s->dma[1]?1:0;CSAI_RecordDMA(s,d,op,a,b,n);if(op==3&&s->settings[d][11]&&h->XferAbortCallback)h->XferAbortCallback(h);return (HAL_StatusTypeDef)s->settings[d][7+op];}
HAL_StatusTypeDef CSAI_DMAStart(DMA_HandleTypeDef *h,uint32_t a,uint32_t b,uint32_t n){return action(h,0,a,b,n);}
HAL_StatusTypeDef CSAI_DMAList(DMA_HandleTypeDef *h){return action(h,1,0,0,0);}
HAL_StatusTypeDef CSAI_DMAAbort(DMA_HandleTypeDef *h){return action(h,2,0,0,0);}
HAL_StatusTypeDef CSAI_DMAAbortIT(DMA_HandleTypeDef *h){return action(h,3,0,0,0);}
void CSAI_Reset(CSAIState *s,uint32_t callbacks){memset(s,0,sizeof(*s));s->h.Instance=&s->regs[0];s->control[3]=1;s->control[5]=64000000;s->control[6]=64000000;s->control[63]=callbacks;for(uint32_t i=0;i<7;i++)CSAI_SetCallback(s,i,CSAI_Callback(i,1));for(uint32_t d=0;d<2;d++){s->dma[d].Instance=&s->dmaRegs[d];s->dma[d].Parent=&s->h;s->queue[d].Head=&s->node[d];}}
uint32_t CSAI_Compare(CSAIState *a,CSAIState *b){
for(uint32_t i=0;i<8;i++)if(CSAI_Get(a,0,i)!=CSAI_Get(b,0,i))return 0x100+i;
for(uint32_t i=0;i<35;i++)if(CSAI_Get(a,1,i)!=CSAI_Get(b,1,i))return 0x200+i;
for(uint32_t i=0;i<64;i++)if(a->control[i]!=b->control[i])return 0x300+i;
for(uint32_t i=0;i<1;i++)if(normalize(a,CSAI_GetPointer(a,i))!=normalize(b,CSAI_GetPointer(b,i)))return 0x400+i;
for(uint32_t i=0;i<2048;i++)if(((uint32_t *)a->buffers)[i]!=((uint32_t *)b->buffers)[i])return 0x1000+i;
for(uint32_t i=0;i<1024;i++){if(a->trace[i]!=b->trace[i])return 0x2000+i;if(a->dmaTrace[i]!=b->dmaTrace[i])return 0x3000+i;}
for(uint32_t i=0;i<8;i++)if(CSAI_GetCallback(a,i)!=CSAI_GetCallback(b,i))return 0x4000+i;
for(uint32_t d=0;d<2;d++){for(uint32_t i=0;i<16;i++)if(CSAI_Get(a,3+d,i)!=CSAI_Get(b,3+d,i))return 0x4100+d*32+i;for(uint32_t i=0;i<8;i++)if(normalize(a,a->node[d].LinkRegisters[i])!=normalize(b,b->node[d].LinkRegisters[i]))return 0x4200+d*8+i;for(uint32_t i=0;i<4;i++)if(CSAI_Get(a,9+d,i)!=CSAI_Get(b,9+d,i))return 0x4300+d*4+i;}
for(uint32_t i=0;i<38;i++)if(CSAI_Get(a,11,i)!=CSAI_Get(b,11,i))return 0x4400+i;return 0;}
uint32_t CSAI_Constant(uint32_t i){switch(i){
case 0:return HAL_SAI_ERROR_AFSDET;
case 1:return HAL_SAI_ERROR_CB_ID;
case 2:return HAL_SAI_ERROR_CNREADY;
case 3:return HAL_SAI_ERROR_DMA;
case 4:return HAL_SAI_ERROR_INVALID_CALLBACK;
case 5:return HAL_SAI_ERROR_LFSDET;
case 6:return HAL_SAI_ERROR_NONE;
case 7:return HAL_SAI_ERROR_OVR;
case 8:return HAL_SAI_ERROR_TIMEOUT;
case 9:return HAL_SAI_ERROR_UDR;
case 10:return HAL_SAI_ERROR_WCKCFG;
case 11:return HAL_SAI_MSPDEINIT_CB_ID;
case 12:return HAL_SAI_MSPINIT_CB_ID;
case 13:return HAL_SAI_RX_COMPLETE_CB_ID;
case 14:return HAL_SAI_RX_HALFCOMPLETE_CB_ID;
case 15:return HAL_SAI_STATE_BUSY;
case 16:return HAL_SAI_STATE_BUSY_RX;
case 17:return HAL_SAI_STATE_BUSY_TX;
case 18:return HAL_SAI_STATE_READY;
case 19:return HAL_SAI_STATE_RESET;
case 20:return HAL_SAI_TX_COMPLETE_CB_ID;
case 21:return HAL_SAI_TX_HALFCOMPLETE_CB_ID;
case 22:return SAI_AC97_PROTOCOL;
case 23:return SAI_ALAW_1CPL_COMPANDING;
case 24:return SAI_ALAW_2CPL_COMPANDING;
case 25:return SAI_ASYNCHRONOUS;
case 26:return SAI_AUDIO_FREQUENCY_11K;
case 27:return SAI_AUDIO_FREQUENCY_16K;
case 28:return SAI_AUDIO_FREQUENCY_192K;
case 29:return SAI_AUDIO_FREQUENCY_22K;
case 30:return SAI_AUDIO_FREQUENCY_32K;
case 31:return SAI_AUDIO_FREQUENCY_44K;
case 32:return SAI_AUDIO_FREQUENCY_48K;
case 33:return SAI_AUDIO_FREQUENCY_8K;
case 34:return SAI_AUDIO_FREQUENCY_96K;
case 35:return SAI_AUDIO_FREQUENCY_MCKDIV;
case 36:return SAI_CLOCKSTROBING_FALLINGEDGE;
case 37:return SAI_CLOCKSTROBING_RISINGEDGE;
case 38:return SAI_DATASIZE_10;
case 39:return SAI_DATASIZE_16;
case 40:return SAI_DATASIZE_20;
case 41:return SAI_DATASIZE_24;
case 42:return SAI_DATASIZE_32;
case 43:return SAI_DATASIZE_8;
case 44:return SAI_FIFOSTATUS_1QUARTERFULL;
case 45:return SAI_FIFOSTATUS_3QUARTERFULL;
case 46:return SAI_FIFOSTATUS_EMPTY;
case 47:return SAI_FIFOSTATUS_FULL;
case 48:return SAI_FIFOSTATUS_HALFFULL;
case 49:return SAI_FIFOSTATUS_LESS1QUARTERFULL;
case 50:return SAI_FIFOTHRESHOLD_1QF;
case 51:return SAI_FIFOTHRESHOLD_3QF;
case 52:return SAI_FIFOTHRESHOLD_EMPTY;
case 53:return SAI_FIFOTHRESHOLD_FULL;
case 54:return SAI_FIFOTHRESHOLD_HF;
case 55:return SAI_FIRSTBIT_LSB;
case 56:return SAI_FIRSTBIT_MSB;
case 57:return SAI_FLAG_AFSDET;
case 58:return SAI_FLAG_CNRDY;
case 59:return SAI_FLAG_FREQ;
case 60:return SAI_FLAG_LFSDET;
case 61:return SAI_FLAG_MUTEDET;
case 62:return SAI_FLAG_OVRUDR;
case 63:return SAI_FLAG_WCKCFG;
case 64:return SAI_FREE_PROTOCOL;
case 65:return SAI_FS_ACTIVE_HIGH;
case 66:return SAI_FS_ACTIVE_LOW;
case 67:return SAI_FS_BEFOREFIRSTBIT;
case 68:return SAI_FS_CHANNEL_IDENTIFICATION;
case 69:return SAI_FS_FIRSTBIT;
case 70:return SAI_FS_STARTFRAME;
case 71:return SAI_I2S_LSBJUSTIFIED;
case 72:return SAI_I2S_MSBJUSTIFIED;
case 73:return SAI_I2S_STANDARD;
case 74:return SAI_IT_AFSDET;
case 75:return SAI_IT_CNRDY;
case 76:return SAI_IT_FREQ;
case 77:return SAI_IT_LFSDET;
case 78:return SAI_IT_MUTEDET;
case 79:return SAI_IT_OVRUDR;
case 80:return SAI_IT_WCKCFG;
case 81:return SAI_LAST_SENT_VALUE;
case 82:return SAI_MASTERDIVIDER_DISABLE;
case 83:return SAI_MASTERDIVIDER_ENABLE;
case 84:return SAI_MCK_OUTPUT_DISABLE;
case 85:return SAI_MCK_OUTPUT_ENABLE;
case 86:return SAI_MCK_OVERSAMPLING_DISABLE;
case 87:return SAI_MCK_OVERSAMPLING_ENABLE;
case 88:return SAI_MODEMASTER_RX;
case 89:return SAI_MODEMASTER_TX;
case 90:return SAI_MODESLAVE_RX;
case 91:return SAI_MODESLAVE_TX;
case 92:return SAI_MONOMODE;
case 93:return SAI_NOCOMPANDING;
case 94:return SAI_OUTPUTDRIVE_DISABLE;
case 95:return SAI_OUTPUTDRIVE_ENABLE;
case 96:return SAI_OUTPUT_NOTRELEASED;
case 97:return SAI_OUTPUT_RELEASED;
case 98:return SAI_PCM_LONG;
case 99:return SAI_PCM_SHORT;
case 100:return SAI_PDM_CLOCK1_ENABLE;
case 101:return SAI_PDM_CLOCK2_ENABLE;
case 102:return SAI_PROTOCOL_DATASIZE_16BIT;
case 103:return SAI_PROTOCOL_DATASIZE_16BITEXTENDED;
case 104:return SAI_PROTOCOL_DATASIZE_24BIT;
case 105:return SAI_PROTOCOL_DATASIZE_32BIT;
case 106:return SAI_SLOTACTIVE_0;
case 107:return SAI_SLOTACTIVE_1;
case 108:return SAI_SLOTACTIVE_10;
case 109:return SAI_SLOTACTIVE_11;
case 110:return SAI_SLOTACTIVE_12;
case 111:return SAI_SLOTACTIVE_13;
case 112:return SAI_SLOTACTIVE_14;
case 113:return SAI_SLOTACTIVE_15;
case 114:return SAI_SLOTACTIVE_2;
case 115:return SAI_SLOTACTIVE_3;
case 116:return SAI_SLOTACTIVE_4;
case 117:return SAI_SLOTACTIVE_5;
case 118:return SAI_SLOTACTIVE_6;
case 119:return SAI_SLOTACTIVE_7;
case 120:return SAI_SLOTACTIVE_8;
case 121:return SAI_SLOTACTIVE_9;
case 122:return SAI_SLOTACTIVE_ALL;
case 123:return SAI_SLOTSIZE_16B;
case 124:return SAI_SLOTSIZE_32B;
case 125:return SAI_SLOTSIZE_DATASIZE;
case 126:return SAI_SLOT_NOTACTIVE;
case 127:return SAI_SPDIF_PROTOCOL;
case 128:return SAI_STEREOMODE;
case 129:return SAI_SYNCEXT_DISABLE;
case 130:return SAI_SYNCEXT_OUTBLOCKA_ENABLE;
case 131:return SAI_SYNCEXT_OUTBLOCKB_ENABLE;
case 132:return SAI_SYNCHRONOUS;
case 133:return SAI_SYNCHRONOUS_EXT_SAI1;
case 134:return SAI_SYNCHRONOUS_EXT_SAI2;
case 135:return SAI_ULAW_1CPL_COMPANDING;
case 136:return SAI_ULAW_2CPL_COMPANDING;
case 137:return SAI_ZERO_VALUE;
default:assert(0);return 0;}}
