#include "I2CInternal.h"
CI2C_THREAD_LOCAL CI2CState *CI2C_Active;
size_t CI2C_Size(void){return sizeof(CI2CState);}
uint8_t *CI2C_Buffer(CI2CState *s){return s->buffer;}
uint8_t *CI2C_GetBuffer(CI2CState *s){return s->h.pBuffPtr;}
void CI2C_SetBuffer(CI2CState *s,uint8_t *p){s->h.pBuffPtr=p;}
uint32_t CI2C_TickFor(CI2CState *s){uint32_t v=s->control[0];s->control[0]+=s->control[1];s->control[2]++;if(s->control[10]&&s->control[2]==s->control[10])s->regs.ISR=s->control[11];return v;}
uint32_t CI2C_Tick(void){return CI2C_TickFor(CI2C_Active);}
uint32_t CI2C_Run(CI2CState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CI2CState *old=CI2C_Active;CI2C_Active=s;uint32_t r=s->control[31]?CI2C1_Run(s,op,a,b,c):CI2C0_Run(s,op,a,b,c);CI2C_Active=old;return r;}
uint32_t CI2C_Get(CI2CState *s,uint32_t group,uint32_t i){switch(group){
case 0:assert(i<11);return ((volatile uint32_t *)&s->regs)[i];
case 1:return s->control[31]?CI2C1_GetWord(s,i):CI2C0_GetWord(s,i);
case 2:assert(i<64);return s->control[i];
case 3:case 4:{uint32_t d=group-3;assert(i<16);switch(i){case 1:return s->dma[d].Mode;case 2:return s->dma[d].ErrorCode;case 3:return s->dma[d].State;case 9:return s->dmaRegs[d].CBR1;default:return s->settings[d][i];}}
case 5:case 6:assert(i<8);return s->node[group-5].LinkRegisters[i];
case 7:assert(i<1024);return s->trace[i];
case 8:assert(i<1024);return s->dmaTrace[i];
case 9:case 10:return s->control[31]?CI2C1_GetDMA(s,group-9,i):CI2C0_GetDMA(s,group-9,i);
default:assert(0);return 0;}}
void CI2C_Set(CI2CState *s,uint32_t group,uint32_t i,uint32_t v){switch(group){
case 0:assert(i<11);((volatile uint32_t *)&s->regs)[i]=v;break;
case 1:if(s->control[31])CI2C1_SetWord(s,i,v);else CI2C0_SetWord(s,i,v);break;
case 2:assert(i<64);s->control[i]=v;break;
case 3:case 4:{uint32_t d=group-3;assert(i<16);s->settings[d][i]=v;switch(i){
case 0:if(d)s->h.hdmarx=v?&s->dma[d]:NULL;else s->h.hdmatx=v?&s->dma[d]:NULL;break;
case 1:s->dma[d].Mode=v;break;case 2:s->dma[d].ErrorCode=v;break;case 3:s->dma[d].State=v;break;
case 4:s->dma[d].LinkedListQueue=v?&s->queue[d]:NULL;break;case 5:s->queue[d].Head=v?&s->node[d]:NULL;break;
case 9:s->dmaRegs[d].CBR1=v;break;default:break;}break;}
case 5:case 6:assert(i<8);s->node[group-5].LinkRegisters[i]=v;break;
case 7:assert(i<1024);s->trace[i]=v;break;case 8:assert(i<1024);s->dmaTrace[i]=v;break;
case 9:case 10:if(s->control[31])CI2C1_SetDMA(s,group-9,i,v);else CI2C0_SetDMA(s,group-9,i,v);break;
default:assert(0);break;}}
static void traceCallback(I2C_HandleTypeDef *h,uint32_t id,uint32_t custom,uint32_t direction,uint32_t match){
CI2CState *s=(CI2CState *)h;uint32_t *n=&s->control[8];assert(*n+11<=1024);
s->trace[(*n)++]=id;s->trace[(*n)++]=custom;s->trace[(*n)++]=direction;s->trace[(*n)++]=match;
s->trace[(*n)++]=h->State;s->trace[(*n)++]=h->Mode;s->trace[(*n)++]=h->ErrorCode;s->trace[(*n)++]=h->Lock;
s->trace[(*n)++]=h->XferCount;s->trace[(*n)++]=h->XferOptions;s->trace[(*n)++]=h->PreviousState;
if(s->control[20]&&s->control[20]-1==id){CI2C_Set(s,1,s->control[21],s->control[22]);s->control[20]=0;}
}
void HAL_I2C_MasterTxCpltCallback(I2C_HandleTypeDef *h){traceCallback(h,0,0,0,0);}
static void Custom0(I2C_HandleTypeDef *h){traceCallback(h,0,1,0,0);}
void HAL_I2C_MasterRxCpltCallback(I2C_HandleTypeDef *h){traceCallback(h,1,0,0,0);}
static void Custom1(I2C_HandleTypeDef *h){traceCallback(h,1,1,0,0);}
void HAL_I2C_SlaveTxCpltCallback(I2C_HandleTypeDef *h){traceCallback(h,2,0,0,0);}
static void Custom2(I2C_HandleTypeDef *h){traceCallback(h,2,1,0,0);}
void HAL_I2C_SlaveRxCpltCallback(I2C_HandleTypeDef *h){traceCallback(h,3,0,0,0);}
static void Custom3(I2C_HandleTypeDef *h){traceCallback(h,3,1,0,0);}
void HAL_I2C_ListenCpltCallback(I2C_HandleTypeDef *h){traceCallback(h,4,0,0,0);}
static void Custom4(I2C_HandleTypeDef *h){traceCallback(h,4,1,0,0);}
void HAL_I2C_MemTxCpltCallback(I2C_HandleTypeDef *h){traceCallback(h,5,0,0,0);}
static void Custom5(I2C_HandleTypeDef *h){traceCallback(h,5,1,0,0);}
void HAL_I2C_MemRxCpltCallback(I2C_HandleTypeDef *h){traceCallback(h,6,0,0,0);}
static void Custom6(I2C_HandleTypeDef *h){traceCallback(h,6,1,0,0);}
void HAL_I2C_ErrorCallback(I2C_HandleTypeDef *h){traceCallback(h,7,0,0,0);}
static void Custom7(I2C_HandleTypeDef *h){traceCallback(h,7,1,0,0);}
void HAL_I2C_AbortCpltCallback(I2C_HandleTypeDef *h){traceCallback(h,8,0,0,0);}
static void Custom8(I2C_HandleTypeDef *h){traceCallback(h,8,1,0,0);}
void HAL_I2C_MspInit(I2C_HandleTypeDef *h){traceCallback(h,9,0,0,0);}
static void Custom9(I2C_HandleTypeDef *h){traceCallback(h,9,1,0,0);}
void HAL_I2C_MspDeInit(I2C_HandleTypeDef *h){traceCallback(h,10,0,0,0);}
static void Custom10(I2C_HandleTypeDef *h){traceCallback(h,10,1,0,0);}
void HAL_I2C_AddrCallback(I2C_HandleTypeDef *h,uint8_t d,uint16_t m){traceCallback(h,11,0,d,m);}
static void Custom11(I2C_HandleTypeDef *h,uint8_t d,uint16_t m){traceCallback(h,11,1,d,m);}
uintptr_t CI2C_Callback(uint32_t id,uint32_t custom){if(!custom)return 0;switch(id){
case 0:return (uintptr_t)(custom==1?HAL_I2C_MasterTxCpltCallback:Custom0);
case 1:return (uintptr_t)(custom==1?HAL_I2C_MasterRxCpltCallback:Custom1);
case 2:return (uintptr_t)(custom==1?HAL_I2C_SlaveTxCpltCallback:Custom2);
case 3:return (uintptr_t)(custom==1?HAL_I2C_SlaveRxCpltCallback:Custom3);
case 4:return (uintptr_t)(custom==1?HAL_I2C_ListenCpltCallback:Custom4);
case 5:return (uintptr_t)(custom==1?HAL_I2C_MemTxCpltCallback:Custom5);
case 6:return (uintptr_t)(custom==1?HAL_I2C_MemRxCpltCallback:Custom6);
case 7:return (uintptr_t)(custom==1?HAL_I2C_ErrorCallback:Custom7);
case 8:return (uintptr_t)(custom==1?HAL_I2C_AbortCpltCallback:Custom8);
case 9:return (uintptr_t)(custom==1?HAL_I2C_MspInit:Custom9);
case 10:return (uintptr_t)(custom==1?HAL_I2C_MspDeInit:Custom10);
case 11:return (uintptr_t)(custom==1?HAL_I2C_AddrCallback:Custom11);default:assert(0);return 0;}}
uintptr_t CI2C_GetCallback(CI2CState *s,uint32_t i){switch(i){
case 0:return (uintptr_t)s->h.MasterTxCpltCallback;
case 1:return (uintptr_t)s->h.MasterRxCpltCallback;
case 2:return (uintptr_t)s->h.SlaveTxCpltCallback;
case 3:return (uintptr_t)s->h.SlaveRxCpltCallback;
case 4:return (uintptr_t)s->h.ListenCpltCallback;
case 5:return (uintptr_t)s->h.MemTxCpltCallback;
case 6:return (uintptr_t)s->h.MemRxCpltCallback;
case 7:return (uintptr_t)s->h.ErrorCallback;
case 8:return (uintptr_t)s->h.AbortCpltCallback;
case 9:return (uintptr_t)s->h.MspInitCallback;
case 10:return (uintptr_t)s->h.MspDeInitCallback;
case 11:return (uintptr_t)s->h.AddrCallback;default:assert(0);return 0;}}
void CI2C_SetCallback(CI2CState *s,uint32_t i,uintptr_t v){switch(i){
case 0:s->h.MasterTxCpltCallback=(pI2C_CallbackTypeDef)v;break;
case 1:s->h.MasterRxCpltCallback=(pI2C_CallbackTypeDef)v;break;
case 2:s->h.SlaveTxCpltCallback=(pI2C_CallbackTypeDef)v;break;
case 3:s->h.SlaveRxCpltCallback=(pI2C_CallbackTypeDef)v;break;
case 4:s->h.ListenCpltCallback=(pI2C_CallbackTypeDef)v;break;
case 5:s->h.MemTxCpltCallback=(pI2C_CallbackTypeDef)v;break;
case 6:s->h.MemRxCpltCallback=(pI2C_CallbackTypeDef)v;break;
case 7:s->h.ErrorCallback=(pI2C_CallbackTypeDef)v;break;
case 8:s->h.AbortCpltCallback=(pI2C_CallbackTypeDef)v;break;
case 9:s->h.MspInitCallback=(pI2C_CallbackTypeDef)v;break;
case 10:s->h.MspDeInitCallback=(pI2C_CallbackTypeDef)v;break;
case 11:s->h.AddrCallback=(pI2C_AddrCallbackTypeDef)v;break;default:assert(0);break;}}
static uint32_t normalize(CI2CState *s,uintptr_t value){uint32_t v=(uint32_t)value,b=(uint32_t)(uintptr_t)s->buffer,r=(uint32_t)(uintptr_t)&s->regs;
if((uint32_t)(v-b)<sizeof(s->buffer))return 0xABC00000U+v-b;
if((uint32_t)(v-r)<sizeof(s->regs))return 0x40005400U+v-r;
return v;}
static uint32_t dmaIndex(DMA_HandleTypeDef *h){return h==&CI2C_Active->dma[1]?1:0;}
uint32_t CI2C_RecordDMA(CI2CState *s,uint32_t d,uint32_t op,uint32_t src,uint32_t dst,uint32_t size){
uint32_t *n=&s->control[9];assert(*n+8<=1024);
s->dmaTrace[(*n)++]=d;s->dmaTrace[(*n)++]=op;s->dmaTrace[(*n)++]=normalize(s,src);s->dmaTrace[(*n)++]=normalize(s,dst);s->dmaTrace[(*n)++]=size;
s->dmaTrace[(*n)++]=s->h.State;s->dmaTrace[(*n)++]=s->h.Lock;s->dmaTrace[(*n)++]=s->regs.CR1;
return s->settings[d][6+op];}
static HAL_StatusTypeDef dmaAction(DMA_HandleTypeDef *h,uint32_t op,uint32_t src,uint32_t dst,uint32_t size){
CI2CState *s=CI2C_Active;uint32_t d=dmaIndex(h);
CI2C_RecordDMA(s,d,op,src,dst,size);
if(op==2&&s->settings[d][11]&&h->XferAbortCallback)h->XferAbortCallback(h);
return (HAL_StatusTypeDef)s->settings[d][6+op];}

HAL_StatusTypeDef CI2C_DMAStart(DMA_HandleTypeDef *h,uint32_t a,uint32_t b,uint32_t n){return dmaAction(h,0,a,b,n);}
HAL_StatusTypeDef CI2C_DMAList(DMA_HandleTypeDef *h){return dmaAction(h,1,0,0,0);}
HAL_StatusTypeDef CI2C_DMAAbortIT(DMA_HandleTypeDef *h){return dmaAction(h,2,0,0,0);}
uint32_t CI2C_DMAFIFO(DMA_HandleTypeDef *h){return CI2C_Active->settings[dmaIndex(h)][10];}
void CI2C_Reset(CI2CState *s,uint32_t callbacks){memset(s,0,sizeof(*s));s->h.Instance=&s->regs;s->h.pBuffPtr=s->buffer;s->control[1]=1;s->control[31]=callbacks;s->control[16]=1;
for(uint32_t i=0;i<12;i++)CI2C_SetCallback(s,i,CI2C_Callback(i,1));
for(uint32_t d=0;d<2;d++){s->dma[d].Instance=&s->dmaRegs[d];s->dma[d].Parent=&s->h;s->queue[d].Head=&s->node[d];}
}
uint32_t CI2C_Compare(CI2CState *a,CI2CState *b){
for(uint32_t i=0;i<11;i++)if(CI2C_Get(a,0,i)!=CI2C_Get(b,0,i))return 0x100+i;
for(uint32_t i=0;i<20;i++)if(CI2C_Get(a,1,i)!=CI2C_Get(b,1,i))return 0x200+i;
for(uint32_t i=0;i<64;i++)if(a->control[i]!=b->control[i])return 0x300+i;
if(normalize(a,(uintptr_t)a->h.pBuffPtr)!=normalize(b,(uintptr_t)b->h.pBuffPtr))return 0x400;
for(uint32_t i=0;i<4096;i++)if(a->buffer[i]!=b->buffer[i])return 0x1000+i;
for(uint32_t i=0;i<1024;i++){if(a->trace[i]!=b->trace[i])return 0x2000+i;if(a->dmaTrace[i]!=b->dmaTrace[i])return 0x3000+i;}
for(uint32_t i=0;i<12;i++)if(CI2C_GetCallback(a,i)!=CI2C_GetCallback(b,i))return 0x4000+i;
for(uint32_t d=0;d<2;d++){
for(uint32_t i=0;i<16;i++)if(CI2C_Get(a,3+d,i)!=CI2C_Get(b,3+d,i))return 0x4100+d*32+i;
for(uint32_t i=0;i<8;i++)if(normalize(a,a->node[d].LinkRegisters[i])!=normalize(b,b->node[d].LinkRegisters[i]))return 0x4200+d*8+i;
for(uint32_t i=0;i<4;i++)if(CI2C_Get(a,9+d,i)!=CI2C_Get(b,9+d,i))return 0x4300+d*4+i;
}
return 0;}
uint32_t CI2C_Constant(uint32_t i){switch(i){
case 0:return HAL_I2C_ABORT_CB_ID;
case 1:return HAL_I2C_ERROR_AF;
case 2:return HAL_I2C_ERROR_ARLO;
case 3:return HAL_I2C_ERROR_BERR;
case 4:return HAL_I2C_ERROR_CB_ID;
case 5:return HAL_I2C_ERROR_DMA;
case 6:return HAL_I2C_ERROR_DMA_PARAM;
case 7:return HAL_I2C_ERROR_INVALID_CALLBACK;
case 8:return HAL_I2C_ERROR_INVALID_PARAM;
case 9:return HAL_I2C_ERROR_NONE;
case 10:return HAL_I2C_ERROR_OVR;
case 11:return HAL_I2C_ERROR_SIZE;
case 12:return HAL_I2C_ERROR_TIMEOUT;
case 13:return HAL_I2C_LISTEN_COMPLETE_CB_ID;
case 14:return HAL_I2C_MASTER_RX_COMPLETE_CB_ID;
case 15:return HAL_I2C_MASTER_TX_COMPLETE_CB_ID;
case 16:return HAL_I2C_MEM_RX_COMPLETE_CB_ID;
case 17:return HAL_I2C_MEM_TX_COMPLETE_CB_ID;
case 18:return HAL_I2C_MODE_MASTER;
case 19:return HAL_I2C_MODE_MEM;
case 20:return HAL_I2C_MODE_NONE;
case 21:return HAL_I2C_MODE_SLAVE;
case 22:return HAL_I2C_MSPDEINIT_CB_ID;
case 23:return HAL_I2C_MSPINIT_CB_ID;
case 24:return HAL_I2C_SLAVE_RX_COMPLETE_CB_ID;
case 25:return HAL_I2C_SLAVE_TX_COMPLETE_CB_ID;
case 26:return HAL_I2C_STATE_ABORT;
case 27:return HAL_I2C_STATE_BUSY;
case 28:return HAL_I2C_STATE_BUSY_RX;
case 29:return HAL_I2C_STATE_BUSY_RX_LISTEN;
case 30:return HAL_I2C_STATE_BUSY_TX;
case 31:return HAL_I2C_STATE_BUSY_TX_LISTEN;
case 32:return HAL_I2C_STATE_LISTEN;
case 33:return HAL_I2C_STATE_READY;
case 34:return HAL_I2C_STATE_RESET;
case 35:return I2C_ADDRESSINGMODE_10BIT;
case 36:return I2C_ADDRESSINGMODE_7BIT;
case 37:return I2C_ANALOGFILTER_DISABLE;
case 38:return I2C_ANALOGFILTER_ENABLE;
case 39:return I2C_AUTOEND_MODE;
case 40:return I2C_DIRECTION_RECEIVE;
case 41:return I2C_DIRECTION_TRANSMIT;
case 42:return I2C_DUALADDRESS_DISABLE;
case 43:return I2C_DUALADDRESS_ENABLE;
case 44:return I2C_FASTMODEPLUS_DISABLE;
case 45:return I2C_FASTMODEPLUS_ENABLE;
case 46:return I2C_FIRST_AND_LAST_FRAME;
case 47:return I2C_FIRST_AND_NEXT_FRAME;
case 48:return I2C_FIRST_FRAME;
case 49:return I2C_FLAG_ADDR;
case 50:return I2C_FLAG_AF;
case 51:return I2C_FLAG_ALERT;
case 52:return I2C_FLAG_ARLO;
case 53:return I2C_FLAG_BERR;
case 54:return I2C_FLAG_BUSY;
case 55:return I2C_FLAG_DIR;
case 56:return I2C_FLAG_MASK;
case 57:return I2C_FLAG_OVR;
case 58:return I2C_FLAG_PECERR;
case 59:return I2C_FLAG_RXNE;
case 60:return I2C_FLAG_STOPF;
case 61:return I2C_FLAG_TC;
case 62:return I2C_FLAG_TCR;
case 63:return I2C_FLAG_TIMEOUT;
case 64:return I2C_FLAG_TXE;
case 65:return I2C_FLAG_TXIS;
case 66:return I2C_GENERALCALL_DISABLE;
case 67:return I2C_GENERALCALL_ENABLE;
case 68:return I2C_GENERATE_START_READ;
case 69:return I2C_GENERATE_START_WRITE;
case 70:return I2C_GENERATE_STOP;
case 71:return I2C_IT_ADDRI;
case 72:return I2C_IT_ERRI;
case 73:return I2C_IT_NACKI;
case 74:return I2C_IT_RXI;
case 75:return I2C_IT_STOPI;
case 76:return I2C_IT_TCI;
case 77:return I2C_IT_TXI;
case 78:return I2C_LAST_FRAME;
case 79:return I2C_LAST_FRAME_NO_STOP;
case 80:return I2C_MEMADD_SIZE_16BIT;
case 81:return I2C_MEMADD_SIZE_8BIT;
case 82:return I2C_NEXT_FRAME;
case 83:return I2C_NOSTRETCH_DISABLE;
case 84:return I2C_NOSTRETCH_ENABLE;
case 85:return I2C_NO_STARTSTOP;
case 86:return I2C_OA2_MASK01;
case 87:return I2C_OA2_MASK02;
case 88:return I2C_OA2_MASK03;
case 89:return I2C_OA2_MASK04;
case 90:return I2C_OA2_MASK05;
case 91:return I2C_OA2_MASK06;
case 92:return I2C_OA2_MASK07;
case 93:return I2C_OA2_NOMASK;
case 94:return I2C_OTHER_AND_LAST_FRAME;
case 95:return I2C_OTHER_FRAME;
case 96:return I2C_RELOAD_MODE;
case 97:return I2C_SOFTEND_MODE;
default:assert(0);return 0;}}
