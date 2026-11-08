#include "USARTInternal.h"
_Thread_local CUSARTState *CUSART_Active;
uint32_t CUSART0_GetWord(CUSARTState *,uint32_t);
uint32_t CUSART0_Run(CUSARTState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CUSART0_GetDMA(CUSARTState *,uint32_t,uint32_t);
void CUSART0_SetWord(CUSARTState *,uint32_t,uint32_t);
void CUSART0_SetDMA(CUSARTState *,uint32_t,uint32_t,uint32_t);
uint32_t CUSART1_GetWord(CUSARTState *,uint32_t);
uint32_t CUSART1_Run(CUSARTState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CUSART1_GetDMA(CUSARTState *,uint32_t,uint32_t);
void CUSART1_SetWord(CUSARTState *,uint32_t,uint32_t);
void CUSART1_SetDMA(CUSARTState *,uint32_t,uint32_t,uint32_t);
size_t CUSART_Size(void) { return sizeof(CUSARTState); }
USART_TypeDef *CUSART_Instance(uint32_t address) { return address==CUSART_Active->control[3]?&CUSART_Active->regs:(USART_TypeDef *)(uintptr_t)address; }
void *CUSART_Buffer(CUSARTState *s,uint32_t i) { assert(i<2);return s->buffers[i]; }
void *CUSART_GetPointer(CUSARTState *s,uint32_t i) { return i?(void *)s->h.pRxBuffPtr:(void *)s->h.pTxBuffPtr; }
void CUSART_SetPointer(CUSARTState *s,uint32_t i,void *p) { if(i)s->h.pRxBuffPtr=p;else s->h.pTxBuffPtr=p; }
uint32_t CUSART_TickFor(CUSARTState *s) {
    uint32_t value=s->control[0];s->control[0]+=s->control[1];s->control[2]++;
    if(s->control[10] && s->control[2]==s->control[10])s->regs.ISR=s->control[11];
    return value;
}
uint32_t CUSART_Tick(void) { return CUSART_TickFor(CUSART_Active); }
uint32_t CUSART_Run(CUSARTState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
    CUSARTState *old=CUSART_Active;CUSART_Active=s;
    uint32_t r=s->control[31]?CUSART1_Run(s,op,a,b,c):CUSART0_Run(s,op,a,b,c);CUSART_Active=old;return r;
}
uint32_t CUSART_Get(CUSARTState *s,uint32_t group,uint32_t i) {
    switch(group) {
    case 0:assert(i<12);return ((volatile uint32_t *)&s->regs)[i];
    case 1:return s->control[31]?CUSART1_GetWord(s,i):CUSART0_GetWord(s,i);
    case 2:assert(i<32);return s->control[i];
    case 3:case 4: { uint32_t d=group-3;assert(i<16);switch(i) {
      case 1:return s->dma[d].Mode;case 2:return s->dma[d].ErrorCode;case 3:return s->dma[d].State;
      default:return s->settings[d][i];} }
    case 5:case 6:assert(i<8);return s->node[group-5].LinkRegisters[i];
    case 7:assert(i<1024);return s->callbackTrace[i];
    case 8:assert(i<1024);return s->dmaTrace[i];
    default:assert(0);return 0;}
}
void CUSART_Set(CUSARTState *s,uint32_t group,uint32_t i,uint32_t v) {
    switch(group) {
    case 0:assert(i<12);((volatile uint32_t *)&s->regs)[i]=v;break;
    case 1:if(s->control[31])CUSART1_SetWord(s,i,v);else CUSART0_SetWord(s,i,v);break;
    case 2:assert(i<32);s->control[i]=v;break;
    case 3:case 4: { uint32_t d=group-3;assert(i<16);s->settings[d][i]=v;switch(i) {
      case 0:if(d)s->h.hdmarx=v?&s->dma[d]:NULL;else s->h.hdmatx=v?&s->dma[d]:NULL;break;
      case 1:s->dma[d].Mode=v;break;case 2:s->dma[d].ErrorCode=v;break;case 3:s->dma[d].State=v;break;
      case 4:s->dma[d].LinkedListQueue=v?&s->queue[d]:NULL;break;
      case 5:s->queue[d].Head=v?&s->node[d]:NULL;break;default:break;}break; }
    case 5:case 6:assert(i<8);s->node[group-5].LinkRegisters[i]=v;break;
    case 7:assert(i<1024);s->callbackTrace[i]=v;break;
    case 8:assert(i<1024);s->dmaTrace[i]=v;break;
    default:assert(0);break;}
}
void CUSART_Callback(CUSARTState *s,uint32_t id,uint32_t implementation) {
    uint32_t *n=&s->control[8];assert(*n+7<=1024);
    s->callbackTrace[(*n)++]=id;s->callbackTrace[(*n)++]=implementation;
    s->callbackTrace[(*n)++]=s->h.State;s->callbackTrace[(*n)++]=s->h.ErrorCode;
    s->callbackTrace[(*n)++]=s->h.Lock;s->callbackTrace[(*n)++]=s->h.TxXferCount;s->callbackTrace[(*n)++]=s->h.RxXferCount;
    if(s->control[13] && id==s->control[14])s->h.State=s->control[15];
}
void HAL_USART_TxHalfCpltCallback(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,0,1); }
static void CB0_2(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,0,2); }
static void CB0_3(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,0,3); }
void HAL_USART_TxCpltCallback(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,1,1); }
static void CB1_2(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,1,2); }
static void CB1_3(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,1,3); }
void HAL_USART_RxHalfCpltCallback(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,2,1); }
static void CB2_2(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,2,2); }
static void CB2_3(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,2,3); }
void HAL_USART_RxCpltCallback(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,3,1); }
static void CB3_2(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,3,2); }
static void CB3_3(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,3,3); }
void HAL_USART_TxRxCpltCallback(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,4,1); }
static void CB4_2(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,4,2); }
static void CB4_3(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,4,3); }
void HAL_USART_ErrorCallback(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,5,1); }
static void CB5_2(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,5,2); }
static void CB5_3(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,5,3); }
void HAL_USART_AbortCpltCallback(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,6,1); }
static void CB6_2(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,6,2); }
static void CB6_3(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,6,3); }
void HAL_USARTEx_RxFifoFullCallback(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,7,1); }
static void CB7_2(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,7,2); }
static void CB7_3(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,7,3); }
void HAL_USARTEx_TxFifoEmptyCallback(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,8,1); }
static void CB8_2(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,8,2); }
static void CB8_3(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,8,3); }
void HAL_USART_MspInit(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,9,1); }
static void CB9_2(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,9,2); }
static void CB9_3(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,9,3); }
void HAL_USART_MspDeInit(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,10,1); }
static void CB10_2(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,10,2); }
static void CB10_3(USART_HandleTypeDef *h) { CUSART_Callback((CUSARTState *)h,10,3); }
pUSART_CallbackTypeDef CUSART_CallbackPointer(uint32_t id,uint32_t v) { if(!v)return NULL;switch(id) {
case 0:return v==1?HAL_USART_TxHalfCpltCallback:v==2?CB0_2:CB0_3;
case 1:return v==1?HAL_USART_TxCpltCallback:v==2?CB1_2:CB1_3;
case 2:return v==1?HAL_USART_RxHalfCpltCallback:v==2?CB2_2:CB2_3;
case 3:return v==1?HAL_USART_RxCpltCallback:v==2?CB3_2:CB3_3;
case 4:return v==1?HAL_USART_TxRxCpltCallback:v==2?CB4_2:CB4_3;
case 5:return v==1?HAL_USART_ErrorCallback:v==2?CB5_2:CB5_3;
case 6:return v==1?HAL_USART_AbortCpltCallback:v==2?CB6_2:CB6_3;
case 7:return v==1?HAL_USARTEx_RxFifoFullCallback:v==2?CB7_2:CB7_3;
case 8:return v==1?HAL_USARTEx_TxFifoEmptyCallback:v==2?CB8_2:CB8_3;
case 9:return v==1?HAL_USART_MspInit:v==2?CB9_2:CB9_3;
case 10:return v==1?HAL_USART_MspDeInit:v==2?CB10_2:CB10_3;
default:assert(0);return NULL;} }
uint32_t CUSART_GetCallback(CUSARTState *s,uint32_t id) {pUSART_CallbackTypeDef f=NULL;switch(id) {
case 0:f=s->h.TxHalfCpltCallback;break;
case 1:f=s->h.TxCpltCallback;break;
case 2:f=s->h.RxHalfCpltCallback;break;
case 3:f=s->h.RxCpltCallback;break;
case 4:f=s->h.TxRxCpltCallback;break;
case 5:f=s->h.ErrorCallback;break;
case 6:f=s->h.AbortCpltCallback;break;
case 7:f=s->h.RxFifoFullCallback;break;
case 8:f=s->h.TxFifoEmptyCallback;break;
case 9:f=s->h.MspInitCallback;break;
case 10:f=s->h.MspDeInitCallback;break;
default:assert(0);break;}for(uint32_t v=0;v<=3;v++)if(f==CUSART_CallbackPointer(id,v))return v;assert(0);return 0;}
void CUSART_SetCallback(CUSARTState *s,uint32_t id,uint32_t v) {switch(id) {
case 0:s->h.TxHalfCpltCallback=CUSART_CallbackPointer(id,v);break;
case 1:s->h.TxCpltCallback=CUSART_CallbackPointer(id,v);break;
case 2:s->h.RxHalfCpltCallback=CUSART_CallbackPointer(id,v);break;
case 3:s->h.RxCpltCallback=CUSART_CallbackPointer(id,v);break;
case 4:s->h.TxRxCpltCallback=CUSART_CallbackPointer(id,v);break;
case 5:s->h.ErrorCallback=CUSART_CallbackPointer(id,v);break;
case 6:s->h.AbortCpltCallback=CUSART_CallbackPointer(id,v);break;
case 7:s->h.RxFifoFullCallback=CUSART_CallbackPointer(id,v);break;
case 8:s->h.TxFifoEmptyCallback=CUSART_CallbackPointer(id,v);break;
case 9:s->h.MspInitCallback=CUSART_CallbackPointer(id,v);break;
case 10:s->h.MspDeInitCallback=CUSART_CallbackPointer(id,v);break;
default:assert(0);break;} }
uint32_t CUSART_GetDMACallback(CUSARTState *s,uint32_t d,uint32_t id) { return s->control[31]?CUSART1_GetDMA(s,d,id):CUSART0_GetDMA(s,d,id); }
void CUSART_SetDMACallback(CUSARTState *s,uint32_t d,uint32_t id,uint32_t v) { if(s->control[31])CUSART1_SetDMA(s,d,id,v);else CUSART0_SetDMA(s,d,id,v); }
uint32_t CUSART_Normalize(CUSARTState *s,uint32_t v) {
    for(uint32_t d=0;d<2;d++) { uint32_t base=(uint32_t)(uintptr_t)s->buffers[d];
        if(v-base<sizeof(s->buffers[d]))return 0x20000000+d*0x1000+(v-base); }
    uint32_t base=(uint32_t)(uintptr_t)&s->regs;
    if(v-base<sizeof(s->regs))return s->control[3]+(v-base);
    return v;
}
uint32_t CUSART_DMAAction(CUSARTState *s,uint32_t d,uint32_t op,uint32_t src,uint32_t dst,uint32_t count) {
    uint32_t *n=&s->control[9];assert(*n+5<=1024);
    s->dmaTrace[(*n)++]=d;s->dmaTrace[(*n)++]=op;s->dmaTrace[(*n)++]=CUSART_Normalize(s,src);
    s->dmaTrace[(*n)++]=CUSART_Normalize(s,dst);s->dmaTrace[(*n)++]=count;
    return s->settings[d][6+op];
}
static uint32_t DMAIndex(DMA_HandleTypeDef *h) { if(h==&CUSART_Active->dma[0])return 0;assert(h==&CUSART_Active->dma[1]);return 1; }
HAL_StatusTypeDef CUSART_DMAStart(DMA_HandleTypeDef *h,uint32_t src,uint32_t dst,uint32_t n) {return CUSART_DMAAction(CUSART_Active,DMAIndex(h),0,src,dst,n);}
HAL_StatusTypeDef CUSART_DMAList(DMA_HandleTypeDef *h) {return CUSART_DMAAction(CUSART_Active,DMAIndex(h),1,0,0,0);}
HAL_StatusTypeDef CUSART_DMAAbort(DMA_HandleTypeDef *h) {return CUSART_DMAAction(CUSART_Active,DMAIndex(h),2,0,0,0);}
HAL_StatusTypeDef CUSART_DMAAbortIT(DMA_HandleTypeDef *h) {return CUSART_DMAAction(CUSART_Active,DMAIndex(h),3,0,0,0);}
HAL_StatusTypeDef CUSART_DMASuspend(DMA_HandleTypeDef *h) {return CUSART_DMAAction(CUSART_Active,DMAIndex(h),4,0,0,0);}
HAL_StatusTypeDef CUSART_DMAResume(DMA_HandleTypeDef *h) {return CUSART_DMAAction(CUSART_Active,DMAIndex(h),5,0,0,0);}
void CUSART_Reset(CUSARTState *s,uint32_t registered) {
    memset(s,0,sizeof(*s));s->h.Instance=&s->regs;s->control[31]=registered;
    s->control[1]=1;s->control[3]=0x40004800;s->control[4]=64000000;
    s->h.Init.BaudRate=115200;s->h.Init.Mode=12;s->h.State=HAL_USART_STATE_READY;
    s->h.NbTxDataToProcess=1;s->h.NbRxDataToProcess=1;
    for(uint32_t d=0;d<2;d++) {
        s->dma[d].Parent=&s->h;s->dma[d].Instance=&s->dmaRegs[d];
        CUSART_Set(s,3+d,0,1);CUSART_Set(s,3+d,3,1);CUSART_Set(s,3+d,4,1);CUSART_Set(s,3+d,5,1);
        for(uint32_t i=0;i<128;i++)s->buffers[d][i]=0xA53CC35A+i;
    }
    for(uint32_t id=0;id<11;id++)CUSART_SetCallback(s,id,1);
}
uint32_t CUSART_Constant(uint32_t i) {switch(i) {
case 0:return HAL_USART_ERROR_RTO;
case 1:return HAL_USART_ABORT_COMPLETE_CB_ID;
case 2:return HAL_USART_ERROR_CB_ID;
case 3:return HAL_USART_ERROR_DMA;
case 4:return HAL_USART_ERROR_FE;
case 5:return HAL_USART_ERROR_INVALID_CALLBACK;
case 6:return HAL_USART_ERROR_NE;
case 7:return HAL_USART_ERROR_NONE;
case 8:return HAL_USART_ERROR_ORE;
case 9:return HAL_USART_ERROR_PE;
case 10:return HAL_USART_ERROR_UDR;
case 11:return HAL_USART_MSPDEINIT_CB_ID;
case 12:return HAL_USART_MSPINIT_CB_ID;
case 13:return HAL_USART_RX_COMPLETE_CB_ID;
case 14:return HAL_USART_RX_FIFO_FULL_CB_ID;
case 15:return HAL_USART_RX_HALFCOMPLETE_CB_ID;
case 16:return HAL_USART_STATE_BUSY;
case 17:return HAL_USART_STATE_BUSY_RX;
case 18:return HAL_USART_STATE_BUSY_TX;
case 19:return HAL_USART_STATE_BUSY_TX_RX;
case 20:return HAL_USART_STATE_ERROR;
case 21:return HAL_USART_STATE_READY;
case 22:return HAL_USART_STATE_RESET;
case 23:return HAL_USART_STATE_TIMEOUT;
case 24:return HAL_USART_TX_COMPLETE_CB_ID;
case 25:return HAL_USART_TX_FIFO_EMPTY_CB_ID;
case 26:return HAL_USART_TX_HALFCOMPLETE_CB_ID;
case 27:return HAL_USART_TX_RX_COMPLETE_CB_ID;
case 28:return USART_CLEAR_FEF;
case 29:return USART_CLEAR_IDLEF;
case 30:return USART_CLEAR_NEF;
case 31:return USART_CLEAR_OREF;
case 32:return USART_CLEAR_PEF;
case 33:return USART_CLEAR_RTOF;
case 34:return USART_CLEAR_TCF;
case 35:return USART_CLEAR_TXFECF;
case 36:return USART_CLEAR_UDRF;
case 37:return USART_CLOCKSOURCE_CSI;
case 38:return USART_CLOCKSOURCE_HSI;
case 39:return USART_CLOCKSOURCE_LSE;
case 40:return USART_CLOCKSOURCE_PCLK1;
case 41:return USART_CLOCKSOURCE_PCLK2;
case 42:return USART_CLOCKSOURCE_PLL2Q;
case 43:return USART_CLOCKSOURCE_PLL3Q;
case 44:return USART_CLOCKSOURCE_UNDEFINED;
case 45:return USART_CLOCK_DISABLE;
case 46:return USART_CLOCK_ENABLE;
case 47:return USART_CR_MASK;
case 48:return USART_CR_POS;
case 49:return USART_FIFOMODE_DISABLE;
case 50:return USART_FIFOMODE_ENABLE;
case 51:return USART_FLAG_BUSY;
case 52:return USART_FLAG_FE;
case 53:return USART_FLAG_IDLE;
case 54:return USART_FLAG_NE;
case 55:return USART_FLAG_ORE;
case 56:return USART_FLAG_PE;
case 57:return USART_FLAG_REACK;
case 58:return USART_FLAG_RTOF;
case 59:return USART_FLAG_RXFF;
case 60:return USART_FLAG_RXFNE;
case 61:return USART_FLAG_RXFT;
case 62:return USART_FLAG_RXNE;
case 63:return USART_FLAG_TC;
case 64:return USART_FLAG_TEACK;
case 65:return USART_FLAG_TXE;
case 66:return USART_FLAG_TXFE;
case 67:return USART_FLAG_TXFNF;
case 68:return USART_FLAG_TXFT;
case 69:return USART_FLAG_UDR;
case 70:return USART_ISR_MASK;
case 71:return USART_ISR_POS;
case 72:return USART_IT_ERR;
case 73:return USART_IT_FE;
case 74:return USART_IT_IDLE;
case 75:return USART_IT_MASK;
case 76:return USART_IT_NE;
case 77:return USART_IT_ORE;
case 78:return USART_IT_PE;
case 79:return USART_IT_RXFF;
case 80:return USART_IT_RXFNE;
case 81:return USART_IT_RXFT;
case 82:return USART_IT_RXNE;
case 83:return USART_IT_TC;
case 84:return USART_IT_TXE;
case 85:return USART_IT_TXFE;
case 86:return USART_IT_TXFNF;
case 87:return USART_IT_TXFT;
case 88:return USART_LASTBIT_DISABLE;
case 89:return USART_LASTBIT_ENABLE;
case 90:return USART_MODE_RX;
case 91:return USART_MODE_TX;
case 92:return USART_MODE_TX_RX;
case 93:return USART_NSS_HARD;
case 94:return USART_NSS_SOFT;
case 95:return USART_PARITY_EVEN;
case 96:return USART_PARITY_NONE;
case 97:return USART_PARITY_ODD;
case 98:return USART_PHASE_1EDGE;
case 99:return USART_PHASE_2EDGE;
case 100:return USART_POLARITY_HIGH;
case 101:return USART_POLARITY_LOW;
case 102:return USART_PRESCALER_DIV1;
case 103:return USART_PRESCALER_DIV10;
case 104:return USART_PRESCALER_DIV12;
case 105:return USART_PRESCALER_DIV128;
case 106:return USART_PRESCALER_DIV16;
case 107:return USART_PRESCALER_DIV2;
case 108:return USART_PRESCALER_DIV256;
case 109:return USART_PRESCALER_DIV32;
case 110:return USART_PRESCALER_DIV4;
case 111:return USART_PRESCALER_DIV6;
case 112:return USART_PRESCALER_DIV64;
case 113:return USART_PRESCALER_DIV8;
case 114:return USART_RXDATA_FLUSH_REQUEST;
case 115:return USART_RXFIFO_THRESHOLD_1_2;
case 116:return USART_RXFIFO_THRESHOLD_1_4;
case 117:return USART_RXFIFO_THRESHOLD_1_8;
case 118:return USART_RXFIFO_THRESHOLD_3_4;
case 119:return USART_RXFIFO_THRESHOLD_7_8;
case 120:return USART_RXFIFO_THRESHOLD_8_8;
case 121:return USART_SLAVEMODE_DISABLE;
case 122:return USART_SLAVEMODE_ENABLE;
case 123:return USART_STOPBITS_0_5;
case 124:return USART_STOPBITS_1;
case 125:return USART_STOPBITS_1_5;
case 126:return USART_STOPBITS_2;
case 127:return USART_TXDATA_FLUSH_REQUEST;
case 128:return USART_TXFIFO_THRESHOLD_1_2;
case 129:return USART_TXFIFO_THRESHOLD_1_4;
case 130:return USART_TXFIFO_THRESHOLD_1_8;
case 131:return USART_TXFIFO_THRESHOLD_3_4;
case 132:return USART_TXFIFO_THRESHOLD_7_8;
case 133:return USART_TXFIFO_THRESHOLD_8_8;
case 134:return USART_WORDLENGTH_7B;
case 135:return USART_WORDLENGTH_8B;
case 136:return USART_WORDLENGTH_9B;
default:assert(0);return 0;} }
