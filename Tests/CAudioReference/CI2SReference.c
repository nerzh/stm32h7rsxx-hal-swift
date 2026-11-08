#include "I2SInternal.h"
CAUDIO_THREAD_LOCAL CI2SState *CI2S_Active;
size_t CI2S_Size(void){return sizeof(CI2SState);}
void CI2S_Activate(CI2SState *s){CI2S_Active=s;}
uint8_t *CI2S_Buffer(CI2SState *s,uint32_t i){return (uint8_t *)s->buffers[i];}
uintptr_t CI2S_GetPointer(CI2SState *s,uint32_t i){switch(i){case 0:return (uintptr_t)s->h.pTxBuffPtr;case 1:return (uintptr_t)s->h.pRxBuffPtr;default:assert(0);return 0;}}
void CI2S_SetPointer(CI2SState *s,uint32_t i,uintptr_t v){switch(i){case 0:s->h.pTxBuffPtr=(void *)v;break;case 1:s->h.pRxBuffPtr=(void *)v;break;default:assert(0);break;}}
uint32_t CI2S_TickFor(CI2SState *s){uint32_t v=s->control[2];s->control[2]+=s->control[3];s->control[4]++;if(s->control[10]&&s->control[4]==s->control[10])((volatile uint32_t *)s->h.Instance)[s->control[11]]=s->control[12];return v;}
uint32_t CI2S_Tick(void){return CI2S_TickFor(CI2S_Active);}
uint32_t CI2S_ClockFor(CI2SState *s,uint32_t v){s->control[7]++;s->control[17]=v;return s->control[5];}
uint32_t CI2S_Clock(uint32_t v){return CI2S_ClockFor(CI2S_Active,v);}
uint32_t CI2S_Run(CI2SState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CI2SState *old=CI2S_Active;CI2S_Active=s;uint32_t r=s->control[63]?CI2S1_Run(s,op,a,b,c):CI2S0_Run(s,op,a,b,c);CI2S_Active=old;return r;}
uint32_t CI2S_Get(CI2SState *s,uint32_t g,uint32_t i){switch(g){
case 0:assert(i<21);return ((volatile uint32_t *)s->h.Instance)[i];
case 1:return s->control[63]?CI2S1_GetWord(s,i):CI2S0_GetWord(s,i);
case 2:assert(i<64);return s->control[i];
case 3:case 4:{uint32_t d=g-3;assert(i<16);switch(i){case 1:return s->dma[d].Init.Mode;case 2:return s->dma[d].Mode;case 3:return s->dma[d].ErrorCode;case 4:return s->dma[d].State;default:return s->settings[d][i];}}
case 5:case 6:assert(i<8);return s->node[g-5].LinkRegisters[i];
case 7:assert(i<1024);return s->trace[i];
case 8:assert(i<1024);return s->dmaTrace[i];
case 9:case 10:return s->control[63]?CI2S1_GetDMA(s,g-9,i):CI2S0_GetDMA(s,g-9,i);
case 11:assert(i<38);return ((volatile uint32_t *)s->global)[i];
default:assert(0);return 0;}}
void CI2S_Set(CI2SState *s,uint32_t g,uint32_t i,uint32_t v){switch(g){
case 0:assert(i<21);((volatile uint32_t *)s->h.Instance)[i]=v;break;
case 1:if(s->control[63])CI2S1_SetWord(s,i,v);else CI2S0_SetWord(s,i,v);break;
case 2:assert(i<64);s->control[i]=v;if(i==0){assert(v<4);s->h.Instance=&s->regs[v];}break;
case 3:case 4:{uint32_t d=g-3;assert(i<16);s->settings[d][i]=v;switch(i){
case 0:if(d)s->h.hdmarx=v?&s->dma[d]:NULL;else s->h.hdmatx=v?&s->dma[d]:NULL;break;
case 1:s->dma[d].Init.Mode=v;break;case 2:s->dma[d].Mode=v;break;case 3:s->dma[d].ErrorCode=v;break;case 4:s->dma[d].State=v;break;case 5:s->dma[d].LinkedListQueue=v?&s->queue[d]:NULL;break;case 6:s->queue[d].Head=v?&s->node[d]:NULL;break;default:break;}break;}
case 5:case 6:assert(i<8);s->node[g-5].LinkRegisters[i]=v;break;
case 7:assert(i<1024);s->trace[i]=v;break;case 8:assert(i<1024);s->dmaTrace[i]=v;break;
case 9:case 10:if(s->control[63])CI2S1_SetDMA(s,g-9,i,v);else CI2S0_SetDMA(s,g-9,i,v);break;
case 11:assert(i<38);((volatile uint32_t *)s->global)[i]=v;break;
default:assert(0);break;}}
static void traceCallback(I2S_HandleTypeDef *h,uint32_t id,uint32_t custom){CI2SState *s=(CI2SState *)h;uint32_t *n=&s->control[8];assert(*n+10<=1024);s->trace[(*n)++]=id;s->trace[(*n)++]=custom;s->trace[(*n)++]=h->State;s->trace[(*n)++]=h->ErrorCode;s->trace[(*n)++]=h->Lock;s->trace[(*n)++]=h->TxXferCount;s->trace[(*n)++]=h->RxXferCount;s->trace[(*n)++]=h->Instance->CR1;s->trace[(*n)++]=s->control[7];s->trace[(*n)++]=s->control[4];if(s->control[20]&&s->control[20]-1==id){CI2S_Set(s,1,s->control[21],s->control[22]);s->control[20]=0;}}
void HAL_I2S_TxCpltCallback(I2S_HandleTypeDef *h){traceCallback(h,0,0);}
static void Custom0(I2S_HandleTypeDef *h){traceCallback(h,0,1);}
void HAL_I2S_RxCpltCallback(I2S_HandleTypeDef *h){traceCallback(h,1,0);}
static void Custom1(I2S_HandleTypeDef *h){traceCallback(h,1,1);}
void HAL_I2SEx_TxRxCpltCallback(I2S_HandleTypeDef *h){traceCallback(h,2,0);}
static void Custom2(I2S_HandleTypeDef *h){traceCallback(h,2,1);}
void HAL_I2S_TxHalfCpltCallback(I2S_HandleTypeDef *h){traceCallback(h,3,0);}
static void Custom3(I2S_HandleTypeDef *h){traceCallback(h,3,1);}
void HAL_I2S_RxHalfCpltCallback(I2S_HandleTypeDef *h){traceCallback(h,4,0);}
static void Custom4(I2S_HandleTypeDef *h){traceCallback(h,4,1);}
void HAL_I2SEx_TxRxHalfCpltCallback(I2S_HandleTypeDef *h){traceCallback(h,5,0);}
static void Custom5(I2S_HandleTypeDef *h){traceCallback(h,5,1);}
void HAL_I2S_ErrorCallback(I2S_HandleTypeDef *h){traceCallback(h,6,0);}
static void Custom6(I2S_HandleTypeDef *h){traceCallback(h,6,1);}
void HAL_I2S_MspInit(I2S_HandleTypeDef *h){traceCallback(h,7,0);}
static void Custom7(I2S_HandleTypeDef *h){traceCallback(h,7,1);}
void HAL_I2S_MspDeInit(I2S_HandleTypeDef *h){traceCallback(h,8,0);}
static void Custom8(I2S_HandleTypeDef *h){traceCallback(h,8,1);}
uintptr_t CI2S_Callback(uint32_t id,uint32_t custom){if(!custom)return 0;switch(id){
case 0:return (uintptr_t)(custom==1?HAL_I2S_TxCpltCallback:Custom0);
case 1:return (uintptr_t)(custom==1?HAL_I2S_RxCpltCallback:Custom1);
case 2:return (uintptr_t)(custom==1?HAL_I2SEx_TxRxCpltCallback:Custom2);
case 3:return (uintptr_t)(custom==1?HAL_I2S_TxHalfCpltCallback:Custom3);
case 4:return (uintptr_t)(custom==1?HAL_I2S_RxHalfCpltCallback:Custom4);
case 5:return (uintptr_t)(custom==1?HAL_I2SEx_TxRxHalfCpltCallback:Custom5);
case 6:return (uintptr_t)(custom==1?HAL_I2S_ErrorCallback:Custom6);
case 7:return (uintptr_t)(custom==1?HAL_I2S_MspInit:Custom7);
case 8:return (uintptr_t)(custom==1?HAL_I2S_MspDeInit:Custom8);
default:assert(0);return 0;}}
uintptr_t CI2S_GetCallback(CI2SState *s,uint32_t i){switch(i){
case 0:return (uintptr_t)s->h.TxCpltCallback;
case 1:return (uintptr_t)s->h.RxCpltCallback;
case 2:return (uintptr_t)s->h.TxRxCpltCallback;
case 3:return (uintptr_t)s->h.TxHalfCpltCallback;
case 4:return (uintptr_t)s->h.RxHalfCpltCallback;
case 5:return (uintptr_t)s->h.TxRxHalfCpltCallback;
case 6:return (uintptr_t)s->h.ErrorCallback;
case 7:return (uintptr_t)s->h.MspInitCallback;
case 8:return (uintptr_t)s->h.MspDeInitCallback;
default:assert(0);return 0;}}
void CI2S_SetCallback(CI2SState *s,uint32_t i,uintptr_t v){switch(i){
case 0:s->h.TxCpltCallback=(pI2S_CallbackTypeDef)v;break;
case 1:s->h.RxCpltCallback=(pI2S_CallbackTypeDef)v;break;
case 2:s->h.TxRxCpltCallback=(pI2S_CallbackTypeDef)v;break;
case 3:s->h.TxHalfCpltCallback=(pI2S_CallbackTypeDef)v;break;
case 4:s->h.RxHalfCpltCallback=(pI2S_CallbackTypeDef)v;break;
case 5:s->h.TxRxHalfCpltCallback=(pI2S_CallbackTypeDef)v;break;
case 6:s->h.ErrorCallback=(pI2S_CallbackTypeDef)v;break;
case 7:s->h.MspInitCallback=(pI2S_CallbackTypeDef)v;break;
case 8:s->h.MspDeInitCallback=(pI2S_CallbackTypeDef)v;break;
default:assert(0);break;}}
static uint32_t normalize(CI2SState *s,uintptr_t value){uint32_t v=(uint32_t)value;for(uint32_t i=0;i<2;i++){uint32_t b=(uint32_t)(uintptr_t)s->buffers[i];if((uint32_t)(v-b)<4096)return 0xABC00000U+i*0x10000U+v-b;}const uint32_t bases[4]={0x42003000,0x40003800,0x40003c00,0x58001400};for(uint32_t i=0;i<4;i++){uint32_t b=(uint32_t)(uintptr_t)&s->regs[i];if((uint32_t)(v-b)<sizeof(s->regs[i]))return bases[i]+v-b;}return v;}
uint32_t CI2S_RecordDMA(CI2SState *s,uint32_t d,uint32_t op,uint32_t src,uint32_t dst,uint32_t size){uint32_t *n=&s->control[9];assert(*n+8<=1024);s->dmaTrace[(*n)++]=d;s->dmaTrace[(*n)++]=op;s->dmaTrace[(*n)++]=normalize(s,src);s->dmaTrace[(*n)++]=normalize(s,dst);s->dmaTrace[(*n)++]=size;s->dmaTrace[(*n)++]=s->h.State;s->dmaTrace[(*n)++]=s->h.Lock;s->dmaTrace[(*n)++]=s->h.Instance->CR1;return s->settings[d][7+op];}
static HAL_StatusTypeDef action(DMA_HandleTypeDef *h,uint32_t op,uint32_t a,uint32_t b,uint32_t n){CI2SState *s=CI2S_Active;uint32_t d=h==&s->dma[1]?1:0;CI2S_RecordDMA(s,d,op,a,b,n);if(op==3&&s->settings[d][11]&&h->XferAbortCallback)h->XferAbortCallback(h);return (HAL_StatusTypeDef)s->settings[d][7+op];}
HAL_StatusTypeDef CI2S_DMAStart(DMA_HandleTypeDef *h,uint32_t a,uint32_t b,uint32_t n){return action(h,0,a,b,n);}
HAL_StatusTypeDef CI2S_DMAList(DMA_HandleTypeDef *h){return action(h,1,0,0,0);}
HAL_StatusTypeDef CI2S_DMAAbort(DMA_HandleTypeDef *h){return action(h,2,0,0,0);}
HAL_StatusTypeDef CI2S_DMAAbortIT(DMA_HandleTypeDef *h){return action(h,3,0,0,0);}
void CI2S_Reset(CI2SState *s,uint32_t callbacks){memset(s,0,sizeof(*s));s->h.Instance=&s->regs[0];s->control[3]=1;s->control[5]=64000000;s->control[6]=64000000;s->control[63]=callbacks;for(uint32_t i=0;i<9;i++)CI2S_SetCallback(s,i,CI2S_Callback(i,1));for(uint32_t d=0;d<2;d++){s->dma[d].Instance=&s->dmaRegs[d];s->dma[d].Parent=&s->h;s->queue[d].Head=&s->node[d];}}
uint32_t CI2S_Compare(CI2SState *a,CI2SState *b){
for(uint32_t i=0;i<21;i++)if(CI2S_Get(a,0,i)!=CI2S_Get(b,0,i))return 0x100+i;
for(uint32_t i=0;i<19;i++)if(CI2S_Get(a,1,i)!=CI2S_Get(b,1,i))return 0x200+i;
for(uint32_t i=0;i<64;i++)if(a->control[i]!=b->control[i])return 0x300+i;
for(uint32_t i=0;i<2;i++)if(normalize(a,CI2S_GetPointer(a,i))!=normalize(b,CI2S_GetPointer(b,i)))return 0x400+i;
for(uint32_t i=0;i<2048;i++)if(((uint32_t *)a->buffers)[i]!=((uint32_t *)b->buffers)[i])return 0x1000+i;
for(uint32_t i=0;i<1024;i++){if(a->trace[i]!=b->trace[i])return 0x2000+i;if(a->dmaTrace[i]!=b->dmaTrace[i])return 0x3000+i;}
for(uint32_t i=0;i<9;i++)if(CI2S_GetCallback(a,i)!=CI2S_GetCallback(b,i))return 0x4000+i;
for(uint32_t d=0;d<2;d++){for(uint32_t i=0;i<16;i++)if(CI2S_Get(a,3+d,i)!=CI2S_Get(b,3+d,i))return 0x4100+d*32+i;for(uint32_t i=0;i<8;i++)if(normalize(a,a->node[d].LinkRegisters[i])!=normalize(b,b->node[d].LinkRegisters[i]))return 0x4200+d*8+i;for(uint32_t i=0;i<4;i++)if(CI2S_Get(a,9+d,i)!=CI2S_Get(b,9+d,i))return 0x4300+d*4+i;}
for(uint32_t i=0;i<38;i++)if(CI2S_Get(a,11,i)!=CI2S_Get(b,11,i))return 0x4400+i;return 0;}
uint32_t CI2S_Constant(uint32_t i){switch(i){
case 0:return HAL_I2S_ERROR_CB_ID;
case 1:return HAL_I2S_ERROR_DMA;
case 2:return HAL_I2S_ERROR_FRE;
case 3:return HAL_I2S_ERROR_INVALID_CALLBACK;
case 4:return HAL_I2S_ERROR_NONE;
case 5:return HAL_I2S_ERROR_NOT_SUPPORTED;
case 6:return HAL_I2S_ERROR_NO_OGT;
case 7:return HAL_I2S_ERROR_OVR;
case 8:return HAL_I2S_ERROR_PRESCALER;
case 9:return HAL_I2S_ERROR_TIMEOUT;
case 10:return HAL_I2S_ERROR_UDR;
case 11:return HAL_I2S_MSPDEINIT_CB_ID;
case 12:return HAL_I2S_MSPINIT_CB_ID;
case 13:return HAL_I2S_RX_COMPLETE_CB_ID;
case 14:return HAL_I2S_RX_HALF_COMPLETE_CB_ID;
case 15:return HAL_I2S_STATE_BUSY;
case 16:return HAL_I2S_STATE_BUSY_RX;
case 17:return HAL_I2S_STATE_BUSY_TX;
case 18:return HAL_I2S_STATE_BUSY_TX_RX;
case 19:return HAL_I2S_STATE_ERROR;
case 20:return HAL_I2S_STATE_READY;
case 21:return HAL_I2S_STATE_RESET;
case 22:return HAL_I2S_STATE_TIMEOUT;
case 23:return HAL_I2S_TX_COMPLETE_CB_ID;
case 24:return HAL_I2S_TX_HALF_COMPLETE_CB_ID;
case 25:return HAL_I2S_TX_RX_COMPLETE_CB_ID;
case 26:return HAL_I2S_TX_RX_HALF_COMPLETE_CB_ID;
case 27:return I2S_AUDIOFREQ_11K;
case 28:return I2S_AUDIOFREQ_16K;
case 29:return I2S_AUDIOFREQ_192K;
case 30:return I2S_AUDIOFREQ_22K;
case 31:return I2S_AUDIOFREQ_32K;
case 32:return I2S_AUDIOFREQ_44K;
case 33:return I2S_AUDIOFREQ_48K;
case 34:return I2S_AUDIOFREQ_8K;
case 35:return I2S_AUDIOFREQ_96K;
case 36:return I2S_AUDIOFREQ_DEFAULT;
case 37:return I2S_CPOL_HIGH;
case 38:return I2S_CPOL_LOW;
case 39:return I2S_DATAFORMAT_16B;
case 40:return I2S_DATAFORMAT_16B_EXTENDED;
case 41:return I2S_DATAFORMAT_24B;
case 42:return I2S_DATAFORMAT_32B;
case 43:return I2S_DATA_24BIT_ALIGNMENT_LEFT;
case 44:return I2S_DATA_24BIT_ALIGNMENT_RIGHT;
case 45:return I2S_FIRSTBIT_LSB;
case 46:return I2S_FIRSTBIT_MSB;
case 47:return I2S_FLAG_DXP;
case 48:return I2S_FLAG_FRE;
case 49:return I2S_FLAG_MASK;
case 50:return I2S_FLAG_OVR;
case 51:return I2S_FLAG_RXP;
case 52:return I2S_FLAG_TXP;
case 53:return I2S_FLAG_UDR;
case 54:return I2S_IT_DXP;
case 55:return I2S_IT_ERR;
case 56:return I2S_IT_FRE;
case 57:return I2S_IT_OVR;
case 58:return I2S_IT_RXP;
case 59:return I2S_IT_TXP;
case 60:return I2S_IT_UDR;
case 61:return I2S_MASTER_KEEP_IO_STATE_DISABLE;
case 62:return I2S_MASTER_KEEP_IO_STATE_ENABLE;
case 63:return I2S_MCLKOUTPUT_DISABLE;
case 64:return I2S_MCLKOUTPUT_ENABLE;
case 65:return I2S_MODE_MASTER_FULLDUPLEX;
case 66:return I2S_MODE_MASTER_RX;
case 67:return I2S_MODE_MASTER_TX;
case 68:return I2S_MODE_SLAVE_FULLDUPLEX;
case 69:return I2S_MODE_SLAVE_RX;
case 70:return I2S_MODE_SLAVE_TX;
case 71:return I2S_STANDARD_LSB;
case 72:return I2S_STANDARD_MSB;
case 73:return I2S_STANDARD_PCM_LONG;
case 74:return I2S_STANDARD_PCM_SHORT;
case 75:return I2S_STANDARD_PHILIPS;
case 76:return I2S_WS_INVERSION_DISABLE;
case 77:return I2S_WS_INVERSION_ENABLE;
default:assert(0);return 0;}}
