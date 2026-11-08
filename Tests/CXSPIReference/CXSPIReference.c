#include "XSPIInternal.h"
CXSPI_THREAD_LOCAL CXSPIState *CXSPI_Active;
size_t CXSPI_Size(void){return sizeof(CXSPIState);}
void CXSPI_Activate(CXSPIState *s){CXSPI_Active=s;}
uint8_t *CXSPI_Buffer(CXSPIState *s,uint32_t i){return (uint8_t *)s->buffers[i];}
uintptr_t CXSPI_GetPointer(CXSPIState *s,uint32_t i){switch(i){case 0:return (uintptr_t)s->h.pBuffPtr;default:assert(0);return 0;}}
void CXSPI_SetPointer(CXSPIState *s,uint32_t i,uintptr_t v){switch(i){case 0:s->h.pBuffPtr=(void *)v;break;default:assert(0);break;}}
uint32_t CXSPI_TickFor(CXSPIState *s){uint32_t v=s->control[2];s->control[2]+=s->control[3];s->control[4]++;if(s->control[10]&&s->control[4]==s->control[10])((volatile uint32_t *)s->h.Instance)[s->control[11]]=s->control[12];return v;}
uint32_t CXSPI_Tick(void){return CXSPI_TickFor(CXSPI_Active);}
uint32_t CXSPI_ClockFor(CXSPIState *s,uint32_t v){s->control[7]++;s->control[17]=v;return s->control[5];}
uint32_t CXSPI_Clock(uint32_t v){return CXSPI_ClockFor(CXSPI_Active,v);}
uint32_t CXSPI_Run(CXSPIState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CXSPIState *old=CXSPI_Active;CXSPI_Active=s;uint32_t r=s->control[63]?CXSPI1_Run(s,op,a,b,c):CXSPI0_Run(s,op,a,b,c);CXSPI_Active=old;return r;}
uint32_t CXSPI_Get(CXSPIState *s,uint32_t g,uint32_t i){switch(g){
case 0:assert(i<139);return ((volatile uint32_t *)s->h.Instance)[i];
case 1:return s->control[63]?CXSPI1_GetWord(s,i):CXSPI0_GetWord(s,i);
case 2:assert(i<64);return s->control[i];
case 3:case 4:{uint32_t d=g-3;assert(i<20);switch(i){case 1:return s->dma[d].Init.Mode;case 2:return s->dma[d].Mode;case 3:return s->dma[d].ErrorCode;case 4:return s->dma[d].State;case 14:return s->dma[d].Init.DestDataWidth;case 16:return s->dma[d].Init.Direction;case 17:return s->dma[d].Init.SrcInc;case 18:return s->dma[d].Init.DestInc;default:return s->settings[d][i];}}
case 5:case 6:assert(i<8);return s->node[g-5].LinkRegisters[i];
case 7:assert(i<1024);return s->trace[i];
case 8:assert(i<1024);return s->dmaTrace[i];
case 9:case 10:return s->control[63]?CXSPI1_GetDMA(s,g-9,i):CXSPI0_GetDMA(s,g-9,i);
case 12:assert(i<2048);return s->access[i];case 14:assert(i<278);return ((volatile uint32_t *)s->regs)[i];case 11:assert(i<38);return ((volatile uint32_t *)s->global)[i];
default:assert(0);return 0;}}
void CXSPI_Set(CXSPIState *s,uint32_t g,uint32_t i,uint32_t v){switch(g){
case 0:assert(i<139);((volatile uint32_t *)s->h.Instance)[i]=v;break;
case 1:if(s->control[63])CXSPI1_SetWord(s,i,v);else CXSPI0_SetWord(s,i,v);break;
case 2:assert(i<64);s->control[i]=v;if(i==0){assert(v<2);s->h.Instance=&s->regs[v];}break;
case 3:case 4:{uint32_t d=g-3;assert(i<20);s->settings[d][i]=v;switch(i){
case 0:if(d)s->h.hdmarx=v?&s->dma[d]:NULL;else s->h.hdmatx=v?&s->dma[d]:NULL;break;
case 1:s->dma[d].Init.Mode=v;break;case 2:s->dma[d].Mode=v;break;case 3:s->dma[d].ErrorCode=v;break;case 4:s->dma[d].State=v;break;case 14:s->dma[d].Init.DestDataWidth=v;break;case 16:s->dma[d].Init.Direction=v;break;case 17:s->dma[d].Init.SrcInc=v;break;case 18:s->dma[d].Init.DestInc=v;break;case 5:s->dma[d].LinkedListQueue=v?&s->queue[d]:NULL;break;case 6:s->queue[d].Head=v?&s->node[d]:NULL;break;default:break;}break;}
case 5:case 6:assert(i<8);s->node[g-5].LinkRegisters[i]=v;break;
case 7:assert(i<1024);s->trace[i]=v;break;case 8:assert(i<1024);s->dmaTrace[i]=v;break;
case 9:case 10:if(s->control[63])CXSPI1_SetDMA(s,g-9,i,v);else CXSPI0_SetDMA(s,g-9,i,v);break;
case 12:assert(i<2048);s->access[i]=v;break;case 14:assert(i<278);((volatile uint32_t *)s->regs)[i]=v;break;case 11:assert(i<38);((volatile uint32_t *)s->global)[i]=v;break;
default:assert(0);break;}}
static void traceCallback(XSPI_HandleTypeDef *h,uint32_t id,uint32_t custom){CXSPIState *s=(CXSPIState *)h;uint32_t *n=&s->control[8];assert(*n+10<=1024);s->trace[(*n)++]=id;s->trace[(*n)++]=custom;s->trace[(*n)++]=h->State;s->trace[(*n)++]=h->ErrorCode;s->trace[(*n)++]=0;s->trace[(*n)++]=h->XferCount;s->trace[(*n)++]=0;s->trace[(*n)++]=h->Instance->CR;s->trace[(*n)++]=s->control[7];s->trace[(*n)++]=s->control[4];if(s->control[20]&&s->control[20]-1==id){CXSPI_Set(s,1,s->control[21],s->control[22]);s->control[20]=0;}}
void HAL_XSPI_ErrorCallback(XSPI_HandleTypeDef *h){traceCallback(h,0,0);}
static void Custom0(XSPI_HandleTypeDef *h){traceCallback(h,0,1);}
void HAL_XSPI_AbortCpltCallback(XSPI_HandleTypeDef *h){traceCallback(h,1,0);}
static void Custom1(XSPI_HandleTypeDef *h){traceCallback(h,1,1);}
void HAL_XSPI_FifoThresholdCallback(XSPI_HandleTypeDef *h){traceCallback(h,2,0);}
static void Custom2(XSPI_HandleTypeDef *h){traceCallback(h,2,1);}
void HAL_XSPI_CmdCpltCallback(XSPI_HandleTypeDef *h){traceCallback(h,3,0);}
static void Custom3(XSPI_HandleTypeDef *h){traceCallback(h,3,1);}
void HAL_XSPI_RxCpltCallback(XSPI_HandleTypeDef *h){traceCallback(h,4,0);}
static void Custom4(XSPI_HandleTypeDef *h){traceCallback(h,4,1);}
void HAL_XSPI_TxCpltCallback(XSPI_HandleTypeDef *h){traceCallback(h,5,0);}
static void Custom5(XSPI_HandleTypeDef *h){traceCallback(h,5,1);}
void HAL_XSPI_RxHalfCpltCallback(XSPI_HandleTypeDef *h){traceCallback(h,6,0);}
static void Custom6(XSPI_HandleTypeDef *h){traceCallback(h,6,1);}
void HAL_XSPI_TxHalfCpltCallback(XSPI_HandleTypeDef *h){traceCallback(h,7,0);}
static void Custom7(XSPI_HandleTypeDef *h){traceCallback(h,7,1);}
void HAL_XSPI_StatusMatchCallback(XSPI_HandleTypeDef *h){traceCallback(h,8,0);}
static void Custom8(XSPI_HandleTypeDef *h){traceCallback(h,8,1);}
void HAL_XSPI_TimeOutCallback(XSPI_HandleTypeDef *h){traceCallback(h,9,0);}
static void Custom9(XSPI_HandleTypeDef *h){traceCallback(h,9,1);}
void HAL_XSPI_MspInit(XSPI_HandleTypeDef *h){traceCallback(h,10,0);}
static void Custom10(XSPI_HandleTypeDef *h){traceCallback(h,10,1);}
void HAL_XSPI_MspDeInit(XSPI_HandleTypeDef *h){traceCallback(h,11,0);}
static void Custom11(XSPI_HandleTypeDef *h){traceCallback(h,11,1);}
uintptr_t CXSPI_Callback(uint32_t id,uint32_t custom){if(!custom)return 0;switch(id){
case 0:return (uintptr_t)(custom==1?HAL_XSPI_ErrorCallback:Custom0);
case 1:return (uintptr_t)(custom==1?HAL_XSPI_AbortCpltCallback:Custom1);
case 2:return (uintptr_t)(custom==1?HAL_XSPI_FifoThresholdCallback:Custom2);
case 3:return (uintptr_t)(custom==1?HAL_XSPI_CmdCpltCallback:Custom3);
case 4:return (uintptr_t)(custom==1?HAL_XSPI_RxCpltCallback:Custom4);
case 5:return (uintptr_t)(custom==1?HAL_XSPI_TxCpltCallback:Custom5);
case 6:return (uintptr_t)(custom==1?HAL_XSPI_RxHalfCpltCallback:Custom6);
case 7:return (uintptr_t)(custom==1?HAL_XSPI_TxHalfCpltCallback:Custom7);
case 8:return (uintptr_t)(custom==1?HAL_XSPI_StatusMatchCallback:Custom8);
case 9:return (uintptr_t)(custom==1?HAL_XSPI_TimeOutCallback:Custom9);
case 10:return (uintptr_t)(custom==1?HAL_XSPI_MspInit:Custom10);
case 11:return (uintptr_t)(custom==1?HAL_XSPI_MspDeInit:Custom11);
default:assert(0);return 0;}}
uintptr_t CXSPI_GetCallback(CXSPIState *s,uint32_t i){switch(i){
case 0:return (uintptr_t)s->h.ErrorCallback;
case 1:return (uintptr_t)s->h.AbortCpltCallback;
case 2:return (uintptr_t)s->h.FifoThresholdCallback;
case 3:return (uintptr_t)s->h.CmdCpltCallback;
case 4:return (uintptr_t)s->h.RxCpltCallback;
case 5:return (uintptr_t)s->h.TxCpltCallback;
case 6:return (uintptr_t)s->h.RxHalfCpltCallback;
case 7:return (uintptr_t)s->h.TxHalfCpltCallback;
case 8:return (uintptr_t)s->h.StatusMatchCallback;
case 9:return (uintptr_t)s->h.TimeOutCallback;
case 10:return (uintptr_t)s->h.MspInitCallback;
case 11:return (uintptr_t)s->h.MspDeInitCallback;
default:assert(0);return 0;}}
void CXSPI_SetCallback(CXSPIState *s,uint32_t i,uintptr_t v){switch(i){
case 0:s->h.ErrorCallback=(pXSPI_CallbackTypeDef)v;break;
case 1:s->h.AbortCpltCallback=(pXSPI_CallbackTypeDef)v;break;
case 2:s->h.FifoThresholdCallback=(pXSPI_CallbackTypeDef)v;break;
case 3:s->h.CmdCpltCallback=(pXSPI_CallbackTypeDef)v;break;
case 4:s->h.RxCpltCallback=(pXSPI_CallbackTypeDef)v;break;
case 5:s->h.TxCpltCallback=(pXSPI_CallbackTypeDef)v;break;
case 6:s->h.RxHalfCpltCallback=(pXSPI_CallbackTypeDef)v;break;
case 7:s->h.TxHalfCpltCallback=(pXSPI_CallbackTypeDef)v;break;
case 8:s->h.StatusMatchCallback=(pXSPI_CallbackTypeDef)v;break;
case 9:s->h.TimeOutCallback=(pXSPI_CallbackTypeDef)v;break;
case 10:s->h.MspInitCallback=(pXSPI_CallbackTypeDef)v;break;
case 11:s->h.MspDeInitCallback=(pXSPI_CallbackTypeDef)v;break;
default:assert(0);break;}}
static uint32_t normalize(CXSPIState *s,uintptr_t value){uint32_t v=(uint32_t)value;if(v==0)return 0;for(uint32_t i=0;i<2;i++){uint32_t b=(uint32_t)(uintptr_t)s->buffers[i];if((uint32_t)(v-b)<4096)return 0xABC00000U+i*0x10000U+v-b;}const uint32_t bases[2]={0x52005000,0x5200a000};for(uint32_t i=0;i<2;i++){uint32_t b=(uint32_t)(uintptr_t)&s->regs[i];if((uint32_t)(v-b)<sizeof(s->regs[i]))return bases[i]+v-b;}return v;}
uint32_t CXSPI_RecordDMA(CXSPIState *s,uint32_t d,uint32_t op,uint32_t src,uint32_t dst,uint32_t size){uint32_t *n=&s->control[9];assert(*n+8<=1024);s->dmaTrace[(*n)++]=d;s->dmaTrace[(*n)++]=op;s->dmaTrace[(*n)++]=normalize(s,src);s->dmaTrace[(*n)++]=normalize(s,dst);s->dmaTrace[(*n)++]=size;s->dmaTrace[(*n)++]=s->h.State;s->dmaTrace[(*n)++]=0;s->dmaTrace[(*n)++]=s->h.Instance->CR;return s->settings[d][7+op];}
static HAL_StatusTypeDef action(DMA_HandleTypeDef *h,uint32_t op,uint32_t a,uint32_t b,uint32_t n){CXSPIState *s=CXSPI_Active;uint32_t d=h==&s->dma[1]?1:0;CXSPI_RecordDMA(s,d,op,a,b,n);if(op==3&&s->settings[d][11]&&h->XferAbortCallback)h->XferAbortCallback(h);return (HAL_StatusTypeDef)s->settings[d][7+op];}
HAL_StatusTypeDef CXSPI_DMAStart(DMA_HandleTypeDef *h,uint32_t a,uint32_t b,uint32_t n){return action(h,0,a,b,n);}
HAL_StatusTypeDef CXSPI_DMAList(DMA_HandleTypeDef *h){return action(h,1,0,0,0);}
HAL_StatusTypeDef CXSPI_DMAAbort(DMA_HandleTypeDef *h){return action(h,2,0,0,0);}
HAL_StatusTypeDef CXSPI_DMAAbortIT(DMA_HandleTypeDef *h){return action(h,3,0,0,0);}
void CXSPI_Reset(CXSPIState *s,uint32_t callbacks){memset(s,0,sizeof(*s));s->h.Instance=&s->regs[0];s->control[3]=1;s->control[5]=64000000;s->control[6]=64000000;s->control[63]=callbacks;for(uint32_t i=0;i<12;i++)CXSPI_SetCallback(s,i,CXSPI_Callback(i,1));for(uint32_t d=0;d<2;d++){s->dma[d].Instance=&s->dmaRegs[d];s->dma[d].Parent=&s->h;s->queue[d].Head=&s->node[d];}}
uint32_t CXSPI_Compare(CXSPIState *a,CXSPIState *b){
for(uint32_t i=0;i<139;i++)if(CXSPI_Get(a,0,i)!=CXSPI_Get(b,0,i))return 0x100+i;
for(uint32_t i=0;i<20;i++)if(CXSPI_Get(a,1,i)!=CXSPI_Get(b,1,i))return 0x200+i;
for(uint32_t i=0;i<64;i++)if(a->control[i]!=b->control[i])return 0x300+i;
for(uint32_t i=0;i<1;i++)if(normalize(a,CXSPI_GetPointer(a,i))!=normalize(b,CXSPI_GetPointer(b,i)))return 0x400+i;
for(uint32_t i=0;i<2048;i++)if(((uint32_t *)a->buffers)[i]!=((uint32_t *)b->buffers)[i])return 0x1000+i;
for(uint32_t i=0;i<1024;i++){if(a->trace[i]!=b->trace[i])return 0x2000+i;if(a->dmaTrace[i]!=b->dmaTrace[i])return 0x3000+i;}
for(uint32_t i=0;i<12;i++)if(CXSPI_GetCallback(a,i)!=CXSPI_GetCallback(b,i))return 0x4000+i;
for(uint32_t d=0;d<2;d++){for(uint32_t i=0;i<20;i++)if(CXSPI_Get(a,3+d,i)!=CXSPI_Get(b,3+d,i))return 0x4100+d*32+i;for(uint32_t i=0;i<8;i++)if(normalize(a,a->node[d].LinkRegisters[i])!=normalize(b,b->node[d].LinkRegisters[i]))return 0x4200+d*8+i;for(uint32_t i=0;i<4;i++)if(CXSPI_Get(a,9+d,i)!=CXSPI_Get(b,9+d,i))return 0x4300+d*4+i;}
for(uint32_t i=0;i<38;i++)if(CXSPI_Get(a,11,i)!=CXSPI_Get(b,11,i))return 0x4400+i;for(uint32_t i=0;i<2048;i++)if(a->access[i]!=b->access[i])return 0x10000+i;for(uint32_t i=0;i<278;i++)if(CXSPI_Get(a,14,i)!=CXSPI_Get(b,14,i))return 0x11000+i;return 0;}
uint32_t CXSPI_Constant(uint32_t i){switch(i){
case 0:return HAL_XSPIM_IOPORT_1;
case 1:return HAL_XSPIM_IOPORT_2;
case 2:return HAL_XSPI_ABORT_CB_ID;
case 3:return HAL_XSPI_ADDRESS_16_BITS;
case 4:return HAL_XSPI_ADDRESS_1_LINE;
case 5:return HAL_XSPI_ADDRESS_24_BITS;
case 6:return HAL_XSPI_ADDRESS_2_LINES;
case 7:return HAL_XSPI_ADDRESS_32_BITS;
case 8:return HAL_XSPI_ADDRESS_4_LINES;
case 9:return HAL_XSPI_ADDRESS_8_BITS;
case 10:return HAL_XSPI_ADDRESS_8_LINES;
case 11:return HAL_XSPI_ADDRESS_DTR_DISABLE;
case 12:return HAL_XSPI_ADDRESS_DTR_ENABLE;
case 13:return HAL_XSPI_ADDRESS_NONE;
case 14:return HAL_XSPI_ALT_BYTES_16_BITS;
case 15:return HAL_XSPI_ALT_BYTES_1_LINE;
case 16:return HAL_XSPI_ALT_BYTES_24_BITS;
case 17:return HAL_XSPI_ALT_BYTES_2_LINES;
case 18:return HAL_XSPI_ALT_BYTES_32_BITS;
case 19:return HAL_XSPI_ALT_BYTES_4_LINES;
case 20:return HAL_XSPI_ALT_BYTES_8_BITS;
case 21:return HAL_XSPI_ALT_BYTES_8_LINES;
case 22:return HAL_XSPI_ALT_BYTES_DTR_DISABLE;
case 23:return HAL_XSPI_ALT_BYTES_DTR_ENABLE;
case 24:return HAL_XSPI_ALT_BYTES_NONE;
case 25:return HAL_XSPI_AUTOMATIC_STOP_DISABLE;
case 26:return HAL_XSPI_AUTOMATIC_STOP_ENABLE;
case 27:return HAL_XSPI_BONDARYOF_128B;
case 28:return HAL_XSPI_BONDARYOF_128KB;
case 29:return HAL_XSPI_BONDARYOF_128MB;
case 30:return HAL_XSPI_BONDARYOF_16B;
case 31:return HAL_XSPI_BONDARYOF_16GB;
case 32:return HAL_XSPI_BONDARYOF_16KB;
case 33:return HAL_XSPI_BONDARYOF_16MB;
case 34:return HAL_XSPI_BONDARYOF_1GB;
case 35:return HAL_XSPI_BONDARYOF_1KB;
case 36:return HAL_XSPI_BONDARYOF_1MB;
case 37:return HAL_XSPI_BONDARYOF_256B;
case 38:return HAL_XSPI_BONDARYOF_256KB;
case 39:return HAL_XSPI_BONDARYOF_256MB;
case 40:return HAL_XSPI_BONDARYOF_2GB;
case 41:return HAL_XSPI_BONDARYOF_2KB;
case 42:return HAL_XSPI_BONDARYOF_2MB;
case 43:return HAL_XSPI_BONDARYOF_32B;
case 44:return HAL_XSPI_BONDARYOF_32KB;
case 45:return HAL_XSPI_BONDARYOF_32MB;
case 46:return HAL_XSPI_BONDARYOF_4GB;
case 47:return HAL_XSPI_BONDARYOF_4KB;
case 48:return HAL_XSPI_BONDARYOF_4MB;
case 49:return HAL_XSPI_BONDARYOF_512B;
case 50:return HAL_XSPI_BONDARYOF_512KB;
case 51:return HAL_XSPI_BONDARYOF_512MB;
case 52:return HAL_XSPI_BONDARYOF_64B;
case 53:return HAL_XSPI_BONDARYOF_64KB;
case 54:return HAL_XSPI_BONDARYOF_64MB;
case 55:return HAL_XSPI_BONDARYOF_8GB;
case 56:return HAL_XSPI_BONDARYOF_8KB;
case 57:return HAL_XSPI_BONDARYOF_8MB;
case 58:return HAL_XSPI_BONDARYOF_NONE;
case 59:return HAL_XSPI_CAL_DATA_OUTPUT_DELAY;
case 60:return HAL_XSPI_CAL_DQS_INPUT_DELAY;
case 61:return HAL_XSPI_CAL_FEEDBACK_CLK_DELAY;
case 62:return HAL_XSPI_CAL_FULL_CYCLE_DELAY;
case 63:return HAL_XSPI_CLOCK_MODE_0;
case 64:return HAL_XSPI_CLOCK_MODE_3;
case 65:return HAL_XSPI_CMD_CPLT_CB_ID;
case 66:return HAL_XSPI_CSSEL_NCS1;
case 67:return HAL_XSPI_CSSEL_NCS2;
case 68:return HAL_XSPI_CSSEL_OVR_DISABLED;
case 69:return HAL_XSPI_CSSEL_OVR_NCS1;
case 70:return HAL_XSPI_CSSEL_OVR_NCS2;
case 71:return HAL_XSPI_DATA_16_LINES;
case 72:return HAL_XSPI_DATA_1_LINE;
case 73:return HAL_XSPI_DATA_2_LINES;
case 74:return HAL_XSPI_DATA_4_LINES;
case 75:return HAL_XSPI_DATA_8_LINES;
case 76:return HAL_XSPI_DATA_DTR_DISABLE;
case 77:return HAL_XSPI_DATA_DTR_ENABLE;
case 78:return HAL_XSPI_DATA_NONE;
case 79:return HAL_XSPI_DHQC_DISABLE;
case 80:return HAL_XSPI_DHQC_ENABLE;
case 81:return HAL_XSPI_DQS_DISABLE;
case 82:return HAL_XSPI_DQS_ENABLE;
case 83:return HAL_XSPI_DUAL_MEM;
case 84:return HAL_XSPI_ERROR_CB_ID;
case 85:return HAL_XSPI_ERROR_DMA;
case 86:return HAL_XSPI_ERROR_INVALID_CALLBACK;
case 87:return HAL_XSPI_ERROR_INVALID_PARAM;
case 88:return HAL_XSPI_ERROR_INVALID_SEQUENCE;
case 89:return HAL_XSPI_ERROR_NONE;
case 90:return HAL_XSPI_ERROR_TIMEOUT;
case 91:return HAL_XSPI_ERROR_TRANSFER;
case 92:return HAL_XSPI_FIFO_THRESHOLD_CB_ID;
case 93:return HAL_XSPI_FIXED_LATENCY;
case 94:return HAL_XSPI_FLAG_BUSY;
case 95:return HAL_XSPI_FLAG_FT;
case 96:return HAL_XSPI_FLAG_SM;
case 97:return HAL_XSPI_FLAG_TC;
case 98:return HAL_XSPI_FLAG_TE;
case 99:return HAL_XSPI_FLAG_TO;
case 100:return HAL_XSPI_FREERUNCLK_DISABLE;
case 101:return HAL_XSPI_FREERUNCLK_ENABLE;
case 102:return HAL_XSPI_INSTRUCTION_16_BITS;
case 103:return HAL_XSPI_INSTRUCTION_1_LINE;
case 104:return HAL_XSPI_INSTRUCTION_24_BITS;
case 105:return HAL_XSPI_INSTRUCTION_2_LINES;
case 106:return HAL_XSPI_INSTRUCTION_32_BITS;
case 107:return HAL_XSPI_INSTRUCTION_4_LINES;
case 108:return HAL_XSPI_INSTRUCTION_8_BITS;
case 109:return HAL_XSPI_INSTRUCTION_8_LINES;
case 110:return HAL_XSPI_INSTRUCTION_DTR_DISABLE;
case 111:return HAL_XSPI_INSTRUCTION_DTR_ENABLE;
case 112:return HAL_XSPI_INSTRUCTION_NONE;
case 113:return HAL_XSPI_IT_FT;
case 114:return HAL_XSPI_IT_SM;
case 115:return HAL_XSPI_IT_TC;
case 116:return HAL_XSPI_IT_TE;
case 117:return HAL_XSPI_IT_TO;
case 118:return HAL_XSPI_LATENCY_ON_WRITE;
case 119:return HAL_XSPI_MATCH_MODE_AND;
case 120:return HAL_XSPI_MATCH_MODE_OR;
case 121:return HAL_XSPI_MAXCAL_NOT_REACHED;
case 122:return HAL_XSPI_MAXCAL_REACHED;
case 123:return HAL_XSPI_MEMORY_ADDRESS_SPACE;
case 124:return HAL_XSPI_MEMTYPE_APMEM;
case 125:return HAL_XSPI_MEMTYPE_APMEM_16BITS;
case 126:return HAL_XSPI_MEMTYPE_HYPERBUS;
case 127:return HAL_XSPI_MEMTYPE_MACRONIX;
case 128:return HAL_XSPI_MEMTYPE_MACRONIX_RAM;
case 129:return HAL_XSPI_MEMTYPE_MICRON;
case 130:return HAL_XSPI_MSP_DEINIT_CB_ID;
case 131:return HAL_XSPI_MSP_INIT_CB_ID;
case 132:return HAL_XSPI_NO_LATENCY_ON_WRITE;
case 133:return HAL_XSPI_OPTYPE_COMMON_CFG;
case 134:return HAL_XSPI_OPTYPE_READ_CFG;
case 135:return HAL_XSPI_OPTYPE_WRAP_CFG;
case 136:return HAL_XSPI_OPTYPE_WRITE_CFG;
case 137:return HAL_XSPI_REGISTER_ADDRESS_SPACE;
case 138:return HAL_XSPI_RX_CPLT_CB_ID;
case 139:return HAL_XSPI_RX_HALF_CPLT_CB_ID;
case 140:return HAL_XSPI_SAMPLE_SHIFT_HALFCYCLE;
case 141:return HAL_XSPI_SAMPLE_SHIFT_NONE;
case 142:return HAL_XSPI_SELECT_IO_11_8;
case 143:return HAL_XSPI_SELECT_IO_15_12;
case 144:return HAL_XSPI_SELECT_IO_15_8;
case 145:return HAL_XSPI_SELECT_IO_3_0;
case 146:return HAL_XSPI_SELECT_IO_7_0;
case 147:return HAL_XSPI_SELECT_IO_7_4;
case 148:return HAL_XSPI_SINGLE_MEM;
case 149:return HAL_XSPI_SIZE_128B;
case 150:return HAL_XSPI_SIZE_128KB;
case 151:return HAL_XSPI_SIZE_128MB;
case 152:return HAL_XSPI_SIZE_16B;
case 153:return HAL_XSPI_SIZE_16GB;
case 154:return HAL_XSPI_SIZE_16KB;
case 155:return HAL_XSPI_SIZE_16MB;
case 156:return HAL_XSPI_SIZE_1GB;
case 157:return HAL_XSPI_SIZE_1KB;
case 158:return HAL_XSPI_SIZE_1MB;
case 159:return HAL_XSPI_SIZE_256B;
case 160:return HAL_XSPI_SIZE_256KB;
case 161:return HAL_XSPI_SIZE_256MB;
case 162:return HAL_XSPI_SIZE_2GB;
case 163:return HAL_XSPI_SIZE_2KB;
case 164:return HAL_XSPI_SIZE_2MB;
case 165:return HAL_XSPI_SIZE_32B;
case 166:return HAL_XSPI_SIZE_32GB;
case 167:return HAL_XSPI_SIZE_32KB;
case 168:return HAL_XSPI_SIZE_32MB;
case 169:return HAL_XSPI_SIZE_4GB;
case 170:return HAL_XSPI_SIZE_4KB;
case 171:return HAL_XSPI_SIZE_4MB;
case 172:return HAL_XSPI_SIZE_512B;
case 173:return HAL_XSPI_SIZE_512KB;
case 174:return HAL_XSPI_SIZE_512MB;
case 175:return HAL_XSPI_SIZE_64B;
case 176:return HAL_XSPI_SIZE_64KB;
case 177:return HAL_XSPI_SIZE_64MB;
case 178:return HAL_XSPI_SIZE_8GB;
case 179:return HAL_XSPI_SIZE_8KB;
case 180:return HAL_XSPI_SIZE_8MB;
case 181:return HAL_XSPI_STATE_ABORT;
case 182:return HAL_XSPI_STATE_BUSY_AUTO_POLLING;
case 183:return HAL_XSPI_STATE_BUSY_CMD;
case 184:return HAL_XSPI_STATE_BUSY_MEM_MAPPED;
case 185:return HAL_XSPI_STATE_BUSY_RX;
case 186:return HAL_XSPI_STATE_BUSY_TX;
case 187:return HAL_XSPI_STATE_CMD_CFG;
case 188:return HAL_XSPI_STATE_ERROR;
case 189:return HAL_XSPI_STATE_HYPERBUS_INIT;
case 190:return HAL_XSPI_STATE_READY;
case 191:return HAL_XSPI_STATE_READ_CMD_CFG;
case 192:return HAL_XSPI_STATE_RESET;
case 193:return HAL_XSPI_STATE_WRITE_CMD_CFG;
case 194:return HAL_XSPI_STATUS_MATCH_CB_ID;
case 195:return HAL_XSPI_TIMEOUT_CB_ID;
case 196:return HAL_XSPI_TIMEOUT_COUNTER_DISABLE;
case 197:return HAL_XSPI_TIMEOUT_COUNTER_ENABLE;
case 198:return HAL_XSPI_TIMEOUT_DEFAULT_VALUE;
case 199:return HAL_XSPI_TX_CPLT_CB_ID;
case 200:return HAL_XSPI_TX_HALF_CPLT_CB_ID;
case 201:return HAL_XSPI_VARIABLE_LATENCY;
case 202:return HAL_XSPI_WRAP_128_BYTES;
case 203:return HAL_XSPI_WRAP_16_BYTES;
case 204:return HAL_XSPI_WRAP_32_BYTES;
case 205:return HAL_XSPI_WRAP_64_BYTES;
case 206:return HAL_XSPI_WRAP_NOT_SUPPORTED;
default:assert(0);return 0;}}

static void recordAccess(CXSPIState *s,uint32_t bank,uint32_t offset,uint32_t width,uint32_t write,uint32_t v){
 uint32_t *n=&s->control[23];assert(*n+3<=2048);
 s->access[(*n)++]=offset|(width<<12)|(write<<16)|(bank<<20);s->access[(*n)++]=v;s->access[(*n)++]=s->h.State;
}
uint32_t CXSPI_ReadRegister(CXSPIState *s,uint32_t bank,uint32_t offset,uint32_t width){
 assert(bank<=2 && offset<(bank==2?4:sizeof(XSPI_TypeDef)));
 volatile uint8_t *p=(volatile uint8_t *)(bank==2?(void *)&s->global[0]:(void *)&s->regs[bank])+offset;
 if(bank==s->control[0]&&offset==32){s->control[24]++;if(s->control[25]&&s->control[24]==s->control[25])s->h.Instance->SR=s->control[26];}
 uint32_t v=width==1?*p:*(volatile uint32_t *)p;
 recordAccess(s,bank,offset,width,0,v);
 if(bank==s->control[0]&&offset==80){s->control[27]++;if(s->control[28]&&s->control[27]==s->control[28])s->h.Instance->SR=s->control[29];if(s->control[33])s->h.Instance->DR=(s->h.Instance->DR>>8)|(s->h.Instance->DR<<24);}
 return v;
}
void CXSPI_WriteRegister(CXSPIState *s,uint32_t bank,uint32_t offset,uint32_t width,uint32_t v){
 assert(bank<=2 && offset<(bank==2?4:sizeof(XSPI_TypeDef)));
 volatile uint8_t *p=(volatile uint8_t *)(bank==2?(void *)&s->global[0]:(void *)&s->regs[bank])+offset;
 if(width==1)*p=(uint8_t)v;else *(volatile uint32_t *)p=v;
 recordAccess(s,bank,offset,width,1,width==1?(uint8_t)v:v);
 if(bank==s->control[0]&&offset==80){s->control[30]++;if(s->control[31]&&s->control[30]==s->control[31])s->h.Instance->SR=s->control[32];}
}
uint32_t CXSPI_ReadAddress(const volatile void *p,uint32_t width){
 CXSPIState *s=CXSPI_Active;
 for(uint32_t bank=0;bank<3;bank++) {uintptr_t delta=(uintptr_t)p-(uintptr_t)(bank==2?(void *)&s->global[0]:(void *)&s->regs[bank]);
 if(delta<(bank==2?4:sizeof(XSPI_TypeDef)))return CXSPI_ReadRegister(s,bank,(uint32_t)delta,width);}
 return *(const volatile uint32_t *)p;
}
void CXSPI_WriteAddress(volatile void *p,uint32_t width,uint32_t v){
 CXSPIState *s=CXSPI_Active;
 for(uint32_t bank=0;bank<3;bank++) {uintptr_t delta=(uintptr_t)p-(uintptr_t)(bank==2?(void *)&s->global[0]:(void *)&s->regs[bank]);
 if(delta<(bank==2?4:sizeof(XSPI_TypeDef))) {CXSPI_WriteRegister(s,bank,(uint32_t)delta,width,v);return;}}
 *(volatile uint32_t *)p=v;
}
