#include "SPIInternal.h"
static uint32_t (*const CSPIRunTable[4])(CSPIState *,uint32_t,uint32_t,uint32_t,uint32_t)={CSPI0_Run,CSPI1_Run,CSPI2_Run,CSPI3_Run};
static uint32_t (*const CSPIGetWordTable[4])(CSPIState *,uint32_t)={CSPI0_GetWord,CSPI1_GetWord,CSPI2_GetWord,CSPI3_GetWord};
static void (*const CSPISetWordTable[4])(CSPIState *,uint32_t,uint32_t)={CSPI0_SetWord,CSPI1_SetWord,CSPI2_SetWord,CSPI3_SetWord};
static uint32_t (*const CSPIGetDMATable[4])(CSPIState *,uint32_t,uint32_t)={CSPI0_GetDMA,CSPI1_GetDMA,CSPI2_GetDMA,CSPI3_GetDMA};
static void (*const CSPISetDMATable[4])(CSPIState *,uint32_t,uint32_t,uint32_t)={CSPI0_SetDMA,CSPI1_SetDMA,CSPI2_SetDMA,CSPI3_SetDMA};

CSPI_THREAD_LOCAL CSPIState *CSPI_Active;
size_t CSPI_Size(void){return sizeof(CSPIState);}
void CSPI_Activate(CSPIState *s){CSPI_Active=s;}
uint8_t *CSPI_Buffer(CSPIState *s,uint32_t i){return (uint8_t *)s->buffers[i];}
uintptr_t CSPI_GetPointer(CSPIState *s,uint32_t i){switch(i){case 0:return (uintptr_t)s->h.pTxBuffPtr;case 1:return (uintptr_t)s->h.pRxBuffPtr;default:assert(0);return 0;}}
void CSPI_SetPointer(CSPIState *s,uint32_t i,uintptr_t v){switch(i){case 0:s->h.pTxBuffPtr=(void *)v;break;case 1:s->h.pRxBuffPtr=(void *)v;break;default:assert(0);break;}}
uint32_t CSPI_TickFor(CSPIState *s){uint32_t v=s->control[2];s->control[2]+=s->control[3];s->control[4]++;if(s->control[10]&&s->control[4]==s->control[10])((volatile uint32_t *)s->h.Instance)[s->control[11]]=s->control[12];return v;}
uint32_t CSPI_Tick(void){return CSPI_TickFor(CSPI_Active);}
uint32_t CSPI_ClockFor(CSPIState *s,uint32_t v){s->control[7]++;s->control[17]=v;return s->control[5];}
uint32_t CSPI_Clock(uint32_t v){return CSPI_ClockFor(CSPI_Active,v);}
uint32_t CSPI_Run(CSPIState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CSPIState *old=CSPI_Active;CSPI_Active=s;uint32_t r=(CSPIRunTable[s->control[63] | (s->control[62] << 1)])(s,op,a,b,c);CSPI_Active=old;return r;}
uint32_t CSPI_Get(CSPIState *s,uint32_t g,uint32_t i){switch(g){
case 0:assert(i<21);return ((volatile uint32_t *)s->h.Instance)[i];
case 1:return (CSPIGetWordTable[s->control[63] | (s->control[62] << 1)])(s,i);
case 2:assert(i<64);return s->control[i];
case 3:case 4:{uint32_t d=g-3;assert(i<16);switch(i){case 1:return s->dma[d].Init.Mode;case 2:return s->dma[d].Mode;case 3:return s->dma[d].ErrorCode;case 4:return s->dma[d].State;case 13:return s->dma[d].Init.SrcDataWidth;case 14:return s->dma[d].Init.DestDataWidth;default:return s->settings[d][i];}}
case 5:case 6:assert(i<8);return s->node[g-5].LinkRegisters[i];
case 7:assert(i<1024);return s->trace[i];
case 8:assert(i<1024);return s->dmaTrace[i];
case 9:case 10:return (CSPIGetDMATable[s->control[63] | (s->control[62] << 1)])(s,g-9,i);
case 12:assert(i<2048);return s->access[i];case 11:assert(i<38);return ((volatile uint32_t *)s->global)[i];
default:assert(0);return 0;}}
void CSPI_Set(CSPIState *s,uint32_t g,uint32_t i,uint32_t v){switch(g){
case 0:assert(i<21);((volatile uint32_t *)s->h.Instance)[i]=v;break;
case 1:(CSPISetWordTable[s->control[63] | (s->control[62] << 1)])(s,i,v);break;
case 2:assert(i<64);s->control[i]=v;if(i==0){assert(v<6);s->h.Instance=&s->regs[v];}break;
case 3:case 4:{uint32_t d=g-3;assert(i<16);s->settings[d][i]=v;switch(i){
case 0:if(d)s->h.hdmarx=v?&s->dma[d]:NULL;else s->h.hdmatx=v?&s->dma[d]:NULL;break;
case 1:s->dma[d].Init.Mode=v;break;case 2:s->dma[d].Mode=v;break;case 3:s->dma[d].ErrorCode=v;break;case 4:s->dma[d].State=v;break;case 13:s->dma[d].Init.SrcDataWidth=v;break;case 14:s->dma[d].Init.DestDataWidth=v;break;case 5:s->dma[d].LinkedListQueue=v?&s->queue[d]:NULL;break;case 6:s->queue[d].Head=v?&s->node[d]:NULL;break;default:break;}break;}
case 5:case 6:assert(i<8);s->node[g-5].LinkRegisters[i]=v;break;
case 7:assert(i<1024);s->trace[i]=v;break;case 8:assert(i<1024);s->dmaTrace[i]=v;break;
case 9:case 10:(CSPISetDMATable[s->control[63] | (s->control[62] << 1)])(s,g-9,i,v);break;
case 12:assert(i<2048);s->access[i]=v;break;case 11:assert(i<38);((volatile uint32_t *)s->global)[i]=v;break;
default:assert(0);break;}}
static void traceCallback(SPI_HandleTypeDef *h,uint32_t id,uint32_t custom){CSPIState *s=(CSPIState *)h;uint32_t *n=&s->control[8];assert(*n+10<=1024);s->trace[(*n)++]=id;s->trace[(*n)++]=custom;s->trace[(*n)++]=h->State;s->trace[(*n)++]=h->ErrorCode;s->trace[(*n)++]=h->Lock;s->trace[(*n)++]=h->TxXferCount;s->trace[(*n)++]=h->RxXferCount;s->trace[(*n)++]=h->Instance->CR1;s->trace[(*n)++]=s->control[7];s->trace[(*n)++]=s->control[4];if(s->control[20]&&s->control[20]-1==id){CSPI_Set(s,1,s->control[21],s->control[22]);s->control[20]=0;}}
void HAL_SPI_TxCpltCallback(SPI_HandleTypeDef *h){traceCallback(h,0,0);}
static void Custom0(SPI_HandleTypeDef *h){traceCallback(h,0,1);}
void HAL_SPI_RxCpltCallback(SPI_HandleTypeDef *h){traceCallback(h,1,0);}
static void Custom1(SPI_HandleTypeDef *h){traceCallback(h,1,1);}
void HAL_SPI_TxRxCpltCallback(SPI_HandleTypeDef *h){traceCallback(h,2,0);}
static void Custom2(SPI_HandleTypeDef *h){traceCallback(h,2,1);}
void HAL_SPI_TxHalfCpltCallback(SPI_HandleTypeDef *h){traceCallback(h,3,0);}
static void Custom3(SPI_HandleTypeDef *h){traceCallback(h,3,1);}
void HAL_SPI_RxHalfCpltCallback(SPI_HandleTypeDef *h){traceCallback(h,4,0);}
static void Custom4(SPI_HandleTypeDef *h){traceCallback(h,4,1);}
void HAL_SPI_TxRxHalfCpltCallback(SPI_HandleTypeDef *h){traceCallback(h,5,0);}
static void Custom5(SPI_HandleTypeDef *h){traceCallback(h,5,1);}
void HAL_SPI_ErrorCallback(SPI_HandleTypeDef *h){traceCallback(h,6,0);}
static void Custom6(SPI_HandleTypeDef *h){traceCallback(h,6,1);}
void HAL_SPI_AbortCpltCallback(SPI_HandleTypeDef *h){traceCallback(h,7,0);}
static void Custom7(SPI_HandleTypeDef *h){traceCallback(h,7,1);}
void HAL_SPI_SuspendCallback(SPI_HandleTypeDef *h){traceCallback(h,8,0);}
static void Custom8(SPI_HandleTypeDef *h){traceCallback(h,8,1);}
void HAL_SPI_MspInit(SPI_HandleTypeDef *h){traceCallback(h,9,0);}
static void Custom9(SPI_HandleTypeDef *h){traceCallback(h,9,1);}
void HAL_SPI_MspDeInit(SPI_HandleTypeDef *h){traceCallback(h,10,0);}
static void Custom10(SPI_HandleTypeDef *h){traceCallback(h,10,1);}
uintptr_t CSPI_Callback(uint32_t id,uint32_t custom){if(!custom)return 0;switch(id){
case 0:return (uintptr_t)(custom==1?HAL_SPI_TxCpltCallback:Custom0);
case 1:return (uintptr_t)(custom==1?HAL_SPI_RxCpltCallback:Custom1);
case 2:return (uintptr_t)(custom==1?HAL_SPI_TxRxCpltCallback:Custom2);
case 3:return (uintptr_t)(custom==1?HAL_SPI_TxHalfCpltCallback:Custom3);
case 4:return (uintptr_t)(custom==1?HAL_SPI_RxHalfCpltCallback:Custom4);
case 5:return (uintptr_t)(custom==1?HAL_SPI_TxRxHalfCpltCallback:Custom5);
case 6:return (uintptr_t)(custom==1?HAL_SPI_ErrorCallback:Custom6);
case 7:return (uintptr_t)(custom==1?HAL_SPI_AbortCpltCallback:Custom7);
case 8:return (uintptr_t)(custom==1?HAL_SPI_SuspendCallback:Custom8);
case 9:return (uintptr_t)(custom==1?HAL_SPI_MspInit:Custom9);
case 10:return (uintptr_t)(custom==1?HAL_SPI_MspDeInit:Custom10);
default:assert(0);return 0;}}
uintptr_t CSPI_GetCallback(CSPIState *s,uint32_t i){switch(i){
case 0:return (uintptr_t)s->h.TxCpltCallback;
case 1:return (uintptr_t)s->h.RxCpltCallback;
case 2:return (uintptr_t)s->h.TxRxCpltCallback;
case 3:return (uintptr_t)s->h.TxHalfCpltCallback;
case 4:return (uintptr_t)s->h.RxHalfCpltCallback;
case 5:return (uintptr_t)s->h.TxRxHalfCpltCallback;
case 6:return (uintptr_t)s->h.ErrorCallback;
case 7:return (uintptr_t)s->h.AbortCpltCallback;
case 8:return (uintptr_t)s->h.SuspendCallback;
case 9:return (uintptr_t)s->h.MspInitCallback;
case 10:return (uintptr_t)s->h.MspDeInitCallback;
default:assert(0);return 0;}}
void CSPI_SetCallback(CSPIState *s,uint32_t i,uintptr_t v){switch(i){
case 0:s->h.TxCpltCallback=(pSPI_CallbackTypeDef)v;break;
case 1:s->h.RxCpltCallback=(pSPI_CallbackTypeDef)v;break;
case 2:s->h.TxRxCpltCallback=(pSPI_CallbackTypeDef)v;break;
case 3:s->h.TxHalfCpltCallback=(pSPI_CallbackTypeDef)v;break;
case 4:s->h.RxHalfCpltCallback=(pSPI_CallbackTypeDef)v;break;
case 5:s->h.TxRxHalfCpltCallback=(pSPI_CallbackTypeDef)v;break;
case 6:s->h.ErrorCallback=(pSPI_CallbackTypeDef)v;break;
case 7:s->h.AbortCpltCallback=(pSPI_CallbackTypeDef)v;break;
case 8:s->h.SuspendCallback=(pSPI_CallbackTypeDef)v;break;
case 9:s->h.MspInitCallback=(pSPI_CallbackTypeDef)v;break;
case 10:s->h.MspDeInitCallback=(pSPI_CallbackTypeDef)v;break;
default:assert(0);break;}}
static uint32_t normalize(CSPIState *s,uintptr_t value){uint32_t v=(uint32_t)value;for(uint32_t i=0;i<2;i++){uint32_t b=(uint32_t)(uintptr_t)s->buffers[i];if((uint32_t)(v-b)<4096)return 0xABC00000U+i*0x10000U+v-b;}const uint32_t bases[6]={0x42003000,0x40003800,0x40003c00,0x42003400,0x42005000,0x58001400};for(uint32_t i=0;i<6;i++){uint32_t b=(uint32_t)(uintptr_t)&s->regs[i];if((uint32_t)(v-b)<sizeof(s->regs[i]))return bases[i]+v-b;}return v;}
uint32_t CSPI_RecordDMA(CSPIState *s,uint32_t d,uint32_t op,uint32_t src,uint32_t dst,uint32_t size){uint32_t *n=&s->control[9];assert(*n+8<=1024);s->dmaTrace[(*n)++]=d;s->dmaTrace[(*n)++]=op;s->dmaTrace[(*n)++]=normalize(s,src);s->dmaTrace[(*n)++]=normalize(s,dst);s->dmaTrace[(*n)++]=size;s->dmaTrace[(*n)++]=s->h.State;s->dmaTrace[(*n)++]=s->h.Lock;s->dmaTrace[(*n)++]=s->h.Instance->CR1;return s->settings[d][7+op];}
static HAL_StatusTypeDef action(DMA_HandleTypeDef *h,uint32_t op,uint32_t a,uint32_t b,uint32_t n){CSPIState *s=CSPI_Active;uint32_t d=h==&s->dma[1]?1:0;CSPI_RecordDMA(s,d,op,a,b,n);if(op==3&&s->settings[d][11]&&h->XferAbortCallback)h->XferAbortCallback(h);return (HAL_StatusTypeDef)s->settings[d][7+op];}
HAL_StatusTypeDef CSPI_DMAStart(DMA_HandleTypeDef *h,uint32_t a,uint32_t b,uint32_t n){return action(h,0,a,b,n);}
HAL_StatusTypeDef CSPI_DMAList(DMA_HandleTypeDef *h){return action(h,1,0,0,0);}
HAL_StatusTypeDef CSPI_DMAAbort(DMA_HandleTypeDef *h){return action(h,2,0,0,0);}
HAL_StatusTypeDef CSPI_DMAAbortIT(DMA_HandleTypeDef *h){return action(h,3,0,0,0);}
void CSPI_Reset(CSPIState *s,uint32_t callbacks){memset(s,0,sizeof(*s));s->h.Instance=&s->regs[0];s->control[3]=1;s->control[5]=64000000;s->control[6]=64000000;s->control[63]=callbacks;s->control[62]=1;for(uint32_t i=0;i<11;i++)CSPI_SetCallback(s,i,CSPI_Callback(i,1));for(uint32_t d=0;d<2;d++){s->dma[d].Instance=&s->dmaRegs[d];s->dma[d].Parent=&s->h;s->queue[d].Head=&s->node[d];}}
uint32_t CSPI_Compare(CSPIState *a,CSPIState *b){
for(uint32_t i=0;i<21;i++)if(CSPI_Get(a,0,i)!=CSPI_Get(b,0,i))return 0x100+i;
for(uint32_t i=0;i<34;i++)if(CSPI_Get(a,1,i)!=CSPI_Get(b,1,i))return 0x200+i;
for(uint32_t i=0;i<64;i++)if(a->control[i]!=b->control[i])return 0x300+i;
for(uint32_t i=0;i<2;i++)if(normalize(a,CSPI_GetPointer(a,i))!=normalize(b,CSPI_GetPointer(b,i)))return 0x400+i;
for(uint32_t i=0;i<2048;i++)if(((uint32_t *)a->buffers)[i]!=((uint32_t *)b->buffers)[i])return 0x1000+i;
for(uint32_t i=0;i<1024;i++){if(a->trace[i]!=b->trace[i])return 0x2000+i;if(a->dmaTrace[i]!=b->dmaTrace[i])return 0x3000+i;}
for(uint32_t i=0;i<11;i++)if(CSPI_GetCallback(a,i)!=CSPI_GetCallback(b,i))return 0x4000+i;
for(uint32_t d=0;d<2;d++){for(uint32_t i=0;i<16;i++)if(CSPI_Get(a,3+d,i)!=CSPI_Get(b,3+d,i))return 0x4100+d*32+i;for(uint32_t i=0;i<8;i++)if(normalize(a,a->node[d].LinkRegisters[i])!=normalize(b,b->node[d].LinkRegisters[i]))return 0x4200+d*8+i;for(uint32_t i=0;i<4;i++)if(CSPI_Get(a,9+d,i)!=CSPI_Get(b,9+d,i))return 0x4300+d*4+i;}
for(uint32_t i=0;i<38;i++)if(CSPI_Get(a,11,i)!=CSPI_Get(b,11,i))return 0x4400+i;for(uint32_t i=0;i<2048;i++)if(a->access[i]!=b->access[i])return 0x10000+i;return 0;}
uint32_t CSPI_Constant(uint32_t i){switch(i){
case 0:return HAL_SPI_ABORT_CB_ID;
case 1:return HAL_SPI_ERROR_ABORT;
case 2:return HAL_SPI_ERROR_CB_ID;
case 3:return HAL_SPI_ERROR_CRC;
case 4:return HAL_SPI_ERROR_DMA;
case 5:return HAL_SPI_ERROR_FLAG;
case 6:return HAL_SPI_ERROR_FRE;
case 7:return HAL_SPI_ERROR_INVALID_CALLBACK;
case 8:return HAL_SPI_ERROR_MODF;
case 9:return HAL_SPI_ERROR_NONE;
case 10:return HAL_SPI_ERROR_NOT_SUPPORTED;
case 11:return HAL_SPI_ERROR_OVR;
case 12:return HAL_SPI_ERROR_TIMEOUT;
case 13:return HAL_SPI_ERROR_UDR;
case 14:return HAL_SPI_ERROR_UNKNOW;
case 15:return HAL_SPI_MSPDEINIT_CB_ID;
case 16:return HAL_SPI_MSPINIT_CB_ID;
case 17:return HAL_SPI_RX_COMPLETE_CB_ID;
case 18:return HAL_SPI_RX_HALF_COMPLETE_CB_ID;
case 19:return HAL_SPI_STATE_ABORT;
case 20:return HAL_SPI_STATE_BUSY;
case 21:return HAL_SPI_STATE_BUSY_RX;
case 22:return HAL_SPI_STATE_BUSY_TX;
case 23:return HAL_SPI_STATE_BUSY_TX_RX;
case 24:return HAL_SPI_STATE_ERROR;
case 25:return HAL_SPI_STATE_READY;
case 26:return HAL_SPI_STATE_RESET;
case 27:return HAL_SPI_SUSPEND_CB_ID;
case 28:return HAL_SPI_TX_COMPLETE_CB_ID;
case 29:return HAL_SPI_TX_HALF_COMPLETE_CB_ID;
case 30:return HAL_SPI_TX_RX_COMPLETE_CB_ID;
case 31:return HAL_SPI_TX_RX_HALF_COMPLETE_CB_ID;
case 32:return SPI_BAUDRATEPRESCALER_128;
case 33:return SPI_BAUDRATEPRESCALER_16;
case 34:return SPI_BAUDRATEPRESCALER_2;
case 35:return SPI_BAUDRATEPRESCALER_256;
case 36:return SPI_BAUDRATEPRESCALER_32;
case 37:return SPI_BAUDRATEPRESCALER_4;
case 38:return SPI_BAUDRATEPRESCALER_64;
case 39:return SPI_BAUDRATEPRESCALER_8;
case 40:return SPI_BAUDRATEPRESCALER_BYPASS;
case 41:return SPI_CRCCALCULATION_DISABLE;
case 42:return SPI_CRCCALCULATION_ENABLE;
case 43:return SPI_CRC_INITIALIZATION_ALL_ONE_PATTERN;
case 44:return SPI_CRC_INITIALIZATION_ALL_ZERO_PATTERN;
case 45:return SPI_CRC_LENGTH_10BIT;
case 46:return SPI_CRC_LENGTH_11BIT;
case 47:return SPI_CRC_LENGTH_12BIT;
case 48:return SPI_CRC_LENGTH_13BIT;
case 49:return SPI_CRC_LENGTH_14BIT;
case 50:return SPI_CRC_LENGTH_15BIT;
case 51:return SPI_CRC_LENGTH_16BIT;
case 52:return SPI_CRC_LENGTH_17BIT;
case 53:return SPI_CRC_LENGTH_18BIT;
case 54:return SPI_CRC_LENGTH_19BIT;
case 55:return SPI_CRC_LENGTH_20BIT;
case 56:return SPI_CRC_LENGTH_21BIT;
case 57:return SPI_CRC_LENGTH_22BIT;
case 58:return SPI_CRC_LENGTH_23BIT;
case 59:return SPI_CRC_LENGTH_24BIT;
case 60:return SPI_CRC_LENGTH_25BIT;
case 61:return SPI_CRC_LENGTH_26BIT;
case 62:return SPI_CRC_LENGTH_27BIT;
case 63:return SPI_CRC_LENGTH_28BIT;
case 64:return SPI_CRC_LENGTH_29BIT;
case 65:return SPI_CRC_LENGTH_30BIT;
case 66:return SPI_CRC_LENGTH_31BIT;
case 67:return SPI_CRC_LENGTH_32BIT;
case 68:return SPI_CRC_LENGTH_4BIT;
case 69:return SPI_CRC_LENGTH_5BIT;
case 70:return SPI_CRC_LENGTH_6BIT;
case 71:return SPI_CRC_LENGTH_7BIT;
case 72:return SPI_CRC_LENGTH_8BIT;
case 73:return SPI_CRC_LENGTH_9BIT;
case 74:return SPI_CRC_LENGTH_DATASIZE;
case 75:return SPI_DATASIZE_10BIT;
case 76:return SPI_DATASIZE_11BIT;
case 77:return SPI_DATASIZE_12BIT;
case 78:return SPI_DATASIZE_13BIT;
case 79:return SPI_DATASIZE_14BIT;
case 80:return SPI_DATASIZE_15BIT;
case 81:return SPI_DATASIZE_16BIT;
case 82:return SPI_DATASIZE_17BIT;
case 83:return SPI_DATASIZE_18BIT;
case 84:return SPI_DATASIZE_19BIT;
case 85:return SPI_DATASIZE_20BIT;
case 86:return SPI_DATASIZE_21BIT;
case 87:return SPI_DATASIZE_22BIT;
case 88:return SPI_DATASIZE_23BIT;
case 89:return SPI_DATASIZE_24BIT;
case 90:return SPI_DATASIZE_25BIT;
case 91:return SPI_DATASIZE_26BIT;
case 92:return SPI_DATASIZE_27BIT;
case 93:return SPI_DATASIZE_28BIT;
case 94:return SPI_DATASIZE_29BIT;
case 95:return SPI_DATASIZE_30BIT;
case 96:return SPI_DATASIZE_31BIT;
case 97:return SPI_DATASIZE_32BIT;
case 98:return SPI_DATASIZE_4BIT;
case 99:return SPI_DATASIZE_5BIT;
case 100:return SPI_DATASIZE_6BIT;
case 101:return SPI_DATASIZE_7BIT;
case 102:return SPI_DATASIZE_8BIT;
case 103:return SPI_DATASIZE_9BIT;
case 104:return SPI_DIRECTION_1LINE;
case 105:return SPI_DIRECTION_2LINES;
case 106:return SPI_DIRECTION_2LINES_RXONLY;
case 107:return SPI_DIRECTION_2LINES_TXONLY;
case 108:return SPI_FIFO_THRESHOLD_01DATA;
case 109:return SPI_FIFO_THRESHOLD_02DATA;
case 110:return SPI_FIFO_THRESHOLD_03DATA;
case 111:return SPI_FIFO_THRESHOLD_04DATA;
case 112:return SPI_FIFO_THRESHOLD_05DATA;
case 113:return SPI_FIFO_THRESHOLD_06DATA;
case 114:return SPI_FIFO_THRESHOLD_07DATA;
case 115:return SPI_FIFO_THRESHOLD_08DATA;
case 116:return SPI_FIFO_THRESHOLD_09DATA;
case 117:return SPI_FIFO_THRESHOLD_10DATA;
case 118:return SPI_FIFO_THRESHOLD_11DATA;
case 119:return SPI_FIFO_THRESHOLD_12DATA;
case 120:return SPI_FIFO_THRESHOLD_13DATA;
case 121:return SPI_FIFO_THRESHOLD_14DATA;
case 122:return SPI_FIFO_THRESHOLD_15DATA;
case 123:return SPI_FIFO_THRESHOLD_16DATA;
case 124:return SPI_FIRSTBIT_LSB;
case 125:return SPI_FIRSTBIT_MSB;
case 126:return SPI_FLAG_CRCERR;
case 127:return SPI_FLAG_DXP;
case 128:return SPI_FLAG_EOT;
case 129:return SPI_FLAG_FRE;
case 130:return SPI_FLAG_FRLVL;
case 131:return SPI_FLAG_MODF;
case 132:return SPI_FLAG_OVR;
case 133:return SPI_FLAG_RXP;
case 134:return SPI_FLAG_RXWNE;
case 135:return SPI_FLAG_SUSP;
case 136:return SPI_FLAG_TXC;
case 137:return SPI_FLAG_TXP;
case 138:return SPI_FLAG_TXTF;
case 139:return SPI_FLAG_UDR;
case 140:return SPI_HIGHEND_FIFO_SIZE;
case 141:return SPI_IO_SWAP_DISABLE;
case 142:return SPI_IO_SWAP_ENABLE;
case 143:return SPI_IT_CRCERR;
case 144:return SPI_IT_DXP;
case 145:return SPI_IT_EOT;
case 146:return SPI_IT_ERR;
case 147:return SPI_IT_FRE;
case 148:return SPI_IT_MODF;
case 149:return SPI_IT_OVR;
case 150:return SPI_IT_RXP;
case 151:return SPI_IT_TXP;
case 152:return SPI_IT_TXTF;
case 153:return SPI_IT_UDR;
case 154:return SPI_LOWEND_FIFO_SIZE;
case 155:return SPI_MASTER_INTERDATA_IDLENESS_00CYCLE;
case 156:return SPI_MASTER_INTERDATA_IDLENESS_01CYCLE;
case 157:return SPI_MASTER_INTERDATA_IDLENESS_02CYCLE;
case 158:return SPI_MASTER_INTERDATA_IDLENESS_03CYCLE;
case 159:return SPI_MASTER_INTERDATA_IDLENESS_04CYCLE;
case 160:return SPI_MASTER_INTERDATA_IDLENESS_05CYCLE;
case 161:return SPI_MASTER_INTERDATA_IDLENESS_06CYCLE;
case 162:return SPI_MASTER_INTERDATA_IDLENESS_07CYCLE;
case 163:return SPI_MASTER_INTERDATA_IDLENESS_08CYCLE;
case 164:return SPI_MASTER_INTERDATA_IDLENESS_09CYCLE;
case 165:return SPI_MASTER_INTERDATA_IDLENESS_10CYCLE;
case 166:return SPI_MASTER_INTERDATA_IDLENESS_11CYCLE;
case 167:return SPI_MASTER_INTERDATA_IDLENESS_12CYCLE;
case 168:return SPI_MASTER_INTERDATA_IDLENESS_13CYCLE;
case 169:return SPI_MASTER_INTERDATA_IDLENESS_14CYCLE;
case 170:return SPI_MASTER_INTERDATA_IDLENESS_15CYCLE;
case 171:return SPI_MASTER_KEEP_IO_STATE_DISABLE;
case 172:return SPI_MASTER_KEEP_IO_STATE_ENABLE;
case 173:return SPI_MASTER_RX_AUTOSUSP_DISABLE;
case 174:return SPI_MASTER_RX_AUTOSUSP_ENABLE;
case 175:return SPI_MASTER_SS_IDLENESS_00CYCLE;
case 176:return SPI_MASTER_SS_IDLENESS_01CYCLE;
case 177:return SPI_MASTER_SS_IDLENESS_02CYCLE;
case 178:return SPI_MASTER_SS_IDLENESS_03CYCLE;
case 179:return SPI_MASTER_SS_IDLENESS_04CYCLE;
case 180:return SPI_MASTER_SS_IDLENESS_05CYCLE;
case 181:return SPI_MASTER_SS_IDLENESS_06CYCLE;
case 182:return SPI_MASTER_SS_IDLENESS_07CYCLE;
case 183:return SPI_MASTER_SS_IDLENESS_08CYCLE;
case 184:return SPI_MASTER_SS_IDLENESS_09CYCLE;
case 185:return SPI_MASTER_SS_IDLENESS_10CYCLE;
case 186:return SPI_MASTER_SS_IDLENESS_11CYCLE;
case 187:return SPI_MASTER_SS_IDLENESS_12CYCLE;
case 188:return SPI_MASTER_SS_IDLENESS_13CYCLE;
case 189:return SPI_MASTER_SS_IDLENESS_14CYCLE;
case 190:return SPI_MASTER_SS_IDLENESS_15CYCLE;
case 191:return SPI_MODE_MASTER;
case 192:return SPI_MODE_SLAVE;
case 193:return SPI_NSS_HARD_INPUT;
case 194:return SPI_NSS_HARD_OUTPUT;
case 195:return SPI_NSS_POLARITY_HIGH;
case 196:return SPI_NSS_POLARITY_LOW;
case 197:return SPI_NSS_PULSE_DISABLE;
case 198:return SPI_NSS_PULSE_ENABLE;
case 199:return SPI_NSS_SOFT;
case 200:return SPI_PHASE_1EDGE;
case 201:return SPI_PHASE_2EDGE;
case 202:return SPI_POLARITY_HIGH;
case 203:return SPI_POLARITY_LOW;
case 204:return SPI_RDY_MASTER_MANAGEMENT_EXTERNALLY;
case 205:return SPI_RDY_MASTER_MANAGEMENT_INTERNALLY;
case 206:return SPI_RDY_POLARITY_HIGH;
case 207:return SPI_RDY_POLARITY_LOW;
case 208:return SPI_RX_FIFO_0PACKET;
case 209:return SPI_RX_FIFO_1PACKET;
case 210:return SPI_RX_FIFO_2PACKET;
case 211:return SPI_RX_FIFO_3PACKET;
case 212:return SPI_TIMODE_DISABLE;
case 213:return SPI_TIMODE_ENABLE;
case 214:return SPI_UNDERRUN_BEHAV_LAST_RECEIVED;
case 215:return SPI_UNDERRUN_BEHAV_REGISTER_PATTERN;
default:assert(0);return 0;}}

static void recordAccess(CSPIState *s,uint32_t offset,uint32_t width,uint32_t write,uint32_t v){
 uint32_t *n=&s->control[23];assert(*n+3<=2048);
 s->access[(*n)++]=offset|(width<<8)|(write<<16);s->access[(*n)++]=v;s->access[(*n)++]=s->h.State;
}
uint32_t CSPI_ReadRegister(CSPIState *s,uint32_t offset,uint32_t width){
 assert(offset<sizeof(SPI_TypeDef));volatile uint8_t *p=(volatile uint8_t *)s->h.Instance+offset;
 if(offset==20){s->control[24]++;if(s->control[25]&&s->control[24]==s->control[25])s->h.Instance->SR=s->control[26];}
 uint32_t v=width==1?*p:width==2?*(volatile uint16_t *)p:*(volatile uint32_t *)p;
 recordAccess(s,offset,width,0,v);
 if(offset==48){s->control[27]++;if(s->control[28]&&s->control[27]==s->control[28])s->h.Instance->SR=s->control[29];if(s->control[33])s->h.Instance->RXDR=(s->h.Instance->RXDR>>8)|(s->h.Instance->RXDR<<24);}
 return v;
}
void CSPI_WriteRegister(CSPIState *s,uint32_t offset,uint32_t width,uint32_t v){
 assert(offset<sizeof(SPI_TypeDef));volatile uint8_t *p=(volatile uint8_t *)s->h.Instance+offset;
 if(width==1)*p=(uint8_t)v;else if(width==2)*(volatile uint16_t *)p=(uint16_t)v;else *(volatile uint32_t *)p=v;
 recordAccess(s,offset,width,1,width==1?(uint8_t)v:width==2?(uint16_t)v:v);
 if(offset==32){s->control[30]++;if(s->control[31]&&s->control[30]==s->control[31])s->h.Instance->SR=s->control[32];}
}
uint32_t CSPI_ReadAddress(const volatile void *p,uint32_t width){
 uintptr_t delta=(uintptr_t)p-(uintptr_t)CSPI_Active->h.Instance;
 if(delta<sizeof(SPI_TypeDef))return CSPI_ReadRegister(CSPI_Active,(uint32_t)delta,width);
 return *(const volatile uint32_t *)p;
}
void CSPI_WriteAddress(volatile void *p,uint32_t width,uint32_t v){
 uintptr_t delta=(uintptr_t)p-(uintptr_t)CSPI_Active->h.Instance;
 if(delta<sizeof(SPI_TypeDef))CSPI_WriteRegister(CSPI_Active,(uint32_t)delta,width,v);else *(volatile uint32_t *)p=v;
}
