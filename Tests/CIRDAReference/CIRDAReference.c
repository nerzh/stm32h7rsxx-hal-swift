#include "IRDAInternal.h"
#include "IRDAPrivate.h"
_Thread_local CIRDAState *CIRDA_Active;
uint32_t CIRDA0_GetWord(CIRDAState *,uint32_t);
uint32_t CIRDA0_Run(CIRDAState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CIRDA0_GetDMA(CIRDAState *,uint32_t,uint32_t);
void CIRDA0_SetWord(CIRDAState *,uint32_t,uint32_t);
void CIRDA0_SetDMA(CIRDAState *,uint32_t,uint32_t,uint32_t);
uint32_t CIRDA1_GetWord(CIRDAState *,uint32_t);
uint32_t CIRDA1_Run(CIRDAState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CIRDA1_GetDMA(CIRDAState *,uint32_t,uint32_t);
void CIRDA1_SetWord(CIRDAState *,uint32_t,uint32_t);
void CIRDA1_SetDMA(CIRDAState *,uint32_t,uint32_t,uint32_t);
size_t CIRDA_Size(void) { return sizeof(CIRDAState); }
USART_TypeDef *CIRDA_Instance(uint32_t address) { return address==CIRDA_Active->control[3]?&CIRDA_Active->regs:(USART_TypeDef *)(uintptr_t)address; }
void *CIRDA_Buffer(CIRDAState *s,uint32_t i) { assert(i<2);return s->buffers[i]; }
void *CIRDA_GetPointer(CIRDAState *s,uint32_t i) { return i?(void *)s->h.pRxBuffPtr:(void *)s->h.pTxBuffPtr; }
void CIRDA_SetPointer(CIRDAState *s,uint32_t i,void *p) { if(i)s->h.pRxBuffPtr=p;else s->h.pTxBuffPtr=p; }
uint32_t CIRDA_TickFor(CIRDAState *s) {
    uint32_t value=s->control[0];s->control[0]+=s->control[1];s->control[2]++;
    if(s->control[10] && s->control[2]==s->control[10])s->regs.ISR=s->control[11];
    return value;
}
uint32_t CIRDA_Tick(void) { return CIRDA_TickFor(CIRDA_Active); }
uint32_t CIRDA_Run(CIRDAState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
    CIRDAState *old=CIRDA_Active;CIRDA_Active=s;
    uint32_t r=s->control[31]?CIRDA1_Run(s,op,a,b,c):CIRDA0_Run(s,op,a,b,c);CIRDA_Active=old;return r;
}
uint32_t CIRDA_Get(CIRDAState *s,uint32_t group,uint32_t i) {
    switch(group) {
    case 0:assert(i<12);return ((volatile uint32_t *)&s->regs)[i];
    case 1:return s->control[31]?CIRDA1_GetWord(s,i):CIRDA0_GetWord(s,i);
    case 2:assert(i<32);return s->control[i];
    case 3:case 4: { uint32_t d=group-3;assert(i<16);switch(i) {
      case 1:return s->dma[d].Mode;case 2:return s->dma[d].ErrorCode;case 3:return s->dma[d].State;
      default:return s->settings[d][i];} }
    case 5:case 6:assert(i<8);return s->node[group-5].LinkRegisters[i];
    case 7:assert(i<1024);return s->callbackTrace[i];
    case 8:assert(i<1024);return s->dmaTrace[i];
    default:assert(0);return 0;}
}
void CIRDA_Set(CIRDAState *s,uint32_t group,uint32_t i,uint32_t v) {
    switch(group) {
    case 0:assert(i<12);((volatile uint32_t *)&s->regs)[i]=v;break;
    case 1:if(s->control[31])CIRDA1_SetWord(s,i,v);else CIRDA0_SetWord(s,i,v);break;
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
void CIRDA_Callback(CIRDAState *s,uint32_t id,uint32_t implementation) {
    uint32_t *n=&s->control[8];assert(*n+8<=1024);
    s->callbackTrace[(*n)++]=id;s->callbackTrace[(*n)++]=implementation;
    s->callbackTrace[(*n)++]=s->h.gState;s->callbackTrace[(*n)++]=s->h.RxState;s->callbackTrace[(*n)++]=s->h.ErrorCode;
    s->callbackTrace[(*n)++]=s->h.Lock;s->callbackTrace[(*n)++]=s->h.TxXferCount;s->callbackTrace[(*n)++]=s->h.RxXferCount;
    if(s->control[13] && id==s->control[14])s->h.gState=s->control[15];
    if(s->control[16] && id==s->control[17])s->h.RxState=s->control[18];
}
void HAL_IRDA_TxHalfCpltCallback(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,0,1); }
static void CB0_2(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,0,2); }
static void CB0_3(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,0,3); }
void HAL_IRDA_TxCpltCallback(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,1,1); }
static void CB1_2(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,1,2); }
static void CB1_3(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,1,3); }
void HAL_IRDA_RxHalfCpltCallback(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,2,1); }
static void CB2_2(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,2,2); }
static void CB2_3(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,2,3); }
void HAL_IRDA_RxCpltCallback(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,3,1); }
static void CB3_2(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,3,2); }
static void CB3_3(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,3,3); }
void HAL_IRDA_ErrorCallback(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,4,1); }
static void CB4_2(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,4,2); }
static void CB4_3(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,4,3); }
void HAL_IRDA_AbortCpltCallback(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,5,1); }
static void CB5_2(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,5,2); }
static void CB5_3(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,5,3); }
void HAL_IRDA_AbortTransmitCpltCallback(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,6,1); }
static void CB6_2(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,6,2); }
static void CB6_3(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,6,3); }
void HAL_IRDA_AbortReceiveCpltCallback(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,7,1); }
static void CB7_2(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,7,2); }
static void CB7_3(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,7,3); }
void HAL_IRDA_MspInit(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,8,1); }
static void CB8_2(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,8,2); }
static void CB8_3(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,8,3); }
void HAL_IRDA_MspDeInit(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,9,1); }
static void CB9_2(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,9,2); }
static void CB9_3(IRDA_HandleTypeDef *h) { CIRDA_Callback((CIRDAState *)h,9,3); }
pIRDA_CallbackTypeDef CIRDA_CallbackPointer(uint32_t id,uint32_t v) { if(!v)return NULL;switch(id) {
case 0:return v==1?HAL_IRDA_TxHalfCpltCallback:v==2?CB0_2:CB0_3;
case 1:return v==1?HAL_IRDA_TxCpltCallback:v==2?CB1_2:CB1_3;
case 2:return v==1?HAL_IRDA_RxHalfCpltCallback:v==2?CB2_2:CB2_3;
case 3:return v==1?HAL_IRDA_RxCpltCallback:v==2?CB3_2:CB3_3;
case 4:return v==1?HAL_IRDA_ErrorCallback:v==2?CB4_2:CB4_3;
case 5:return v==1?HAL_IRDA_AbortCpltCallback:v==2?CB5_2:CB5_3;
case 6:return v==1?HAL_IRDA_AbortTransmitCpltCallback:v==2?CB6_2:CB6_3;
case 7:return v==1?HAL_IRDA_AbortReceiveCpltCallback:v==2?CB7_2:CB7_3;
case 8:return v==1?HAL_IRDA_MspInit:v==2?CB8_2:CB8_3;
case 9:return v==1?HAL_IRDA_MspDeInit:v==2?CB9_2:CB9_3;
default:assert(0);return NULL;} }
uint32_t CIRDA_GetCallback(CIRDAState *s,uint32_t id) {pIRDA_CallbackTypeDef f=NULL;switch(id) {
case 0:f=s->h.TxHalfCpltCallback;break;
case 1:f=s->h.TxCpltCallback;break;
case 2:f=s->h.RxHalfCpltCallback;break;
case 3:f=s->h.RxCpltCallback;break;
case 4:f=s->h.ErrorCallback;break;
case 5:f=s->h.AbortCpltCallback;break;
case 6:f=s->h.AbortTransmitCpltCallback;break;
case 7:f=s->h.AbortReceiveCpltCallback;break;
case 8:f=s->h.MspInitCallback;break;
case 9:f=s->h.MspDeInitCallback;break;
default:assert(0);break;}for(uint32_t v=0;v<=3;v++)if(f==CIRDA_CallbackPointer(id,v))return v;assert(0);return 0;}
void CIRDA_SetCallback(CIRDAState *s,uint32_t id,uint32_t v) {switch(id) {
case 0:s->h.TxHalfCpltCallback=CIRDA_CallbackPointer(id,v);break;
case 1:s->h.TxCpltCallback=CIRDA_CallbackPointer(id,v);break;
case 2:s->h.RxHalfCpltCallback=CIRDA_CallbackPointer(id,v);break;
case 3:s->h.RxCpltCallback=CIRDA_CallbackPointer(id,v);break;
case 4:s->h.ErrorCallback=CIRDA_CallbackPointer(id,v);break;
case 5:s->h.AbortCpltCallback=CIRDA_CallbackPointer(id,v);break;
case 6:s->h.AbortTransmitCpltCallback=CIRDA_CallbackPointer(id,v);break;
case 7:s->h.AbortReceiveCpltCallback=CIRDA_CallbackPointer(id,v);break;
case 8:s->h.MspInitCallback=CIRDA_CallbackPointer(id,v);break;
case 9:s->h.MspDeInitCallback=CIRDA_CallbackPointer(id,v);break;
default:assert(0);break;} }
uint32_t CIRDA_GetDMACallback(CIRDAState *s,uint32_t d,uint32_t id) { return s->control[31]?CIRDA1_GetDMA(s,d,id):CIRDA0_GetDMA(s,d,id); }
void CIRDA_SetDMACallback(CIRDAState *s,uint32_t d,uint32_t id,uint32_t v) { if(s->control[31])CIRDA1_SetDMA(s,d,id,v);else CIRDA0_SetDMA(s,d,id,v); }
uint32_t CIRDA_Normalize(CIRDAState *s,uint32_t v) {
    for(uint32_t d=0;d<2;d++) { uint32_t base=(uint32_t)(uintptr_t)s->buffers[d];
        if(v-base<sizeof(s->buffers[d]))return 0x20000000+d*0x1000+(v-base); }
    uint32_t base=(uint32_t)(uintptr_t)&s->regs;
    if(v-base<sizeof(s->regs))return s->control[3]+(v-base);
    return v;
}
uint32_t CIRDA_DMAAction(CIRDAState *s,uint32_t d,uint32_t op,uint32_t src,uint32_t dst,uint32_t count) {
    uint32_t *n=&s->control[9];assert(*n+5<=1024);
    s->dmaTrace[(*n)++]=d;s->dmaTrace[(*n)++]=op;s->dmaTrace[(*n)++]=CIRDA_Normalize(s,src);
    s->dmaTrace[(*n)++]=CIRDA_Normalize(s,dst);s->dmaTrace[(*n)++]=count;
    return s->settings[d][6+op];
}
static uint32_t DMAIndex(DMA_HandleTypeDef *h) { if(h==&CIRDA_Active->dma[0])return 0;assert(h==&CIRDA_Active->dma[1]);return 1; }
HAL_StatusTypeDef CIRDA_DMAStart(DMA_HandleTypeDef *h,uint32_t src,uint32_t dst,uint32_t n) {return CIRDA_DMAAction(CIRDA_Active,DMAIndex(h),0,src,dst,n);}
HAL_StatusTypeDef CIRDA_DMAList(DMA_HandleTypeDef *h) {return CIRDA_DMAAction(CIRDA_Active,DMAIndex(h),1,0,0,0);}
HAL_StatusTypeDef CIRDA_DMAAbort(DMA_HandleTypeDef *h) {return CIRDA_DMAAction(CIRDA_Active,DMAIndex(h),2,0,0,0);}
HAL_StatusTypeDef CIRDA_DMAAbortIT(DMA_HandleTypeDef *h) {return CIRDA_DMAAction(CIRDA_Active,DMAIndex(h),3,0,0,0);}
HAL_StatusTypeDef CIRDA_DMASuspend(DMA_HandleTypeDef *h) {return CIRDA_DMAAction(CIRDA_Active,DMAIndex(h),4,0,0,0);}
HAL_StatusTypeDef CIRDA_DMAResume(DMA_HandleTypeDef *h) {return CIRDA_DMAAction(CIRDA_Active,DMAIndex(h),5,0,0,0);}
void CIRDA_Reset(CIRDAState *s,uint32_t registered) {
    memset(s,0,sizeof(*s));s->h.Instance=&s->regs;s->control[31]=registered;
    s->control[1]=1;s->control[3]=0x40004800;s->control[4]=64000000;
    s->h.Init.BaudRate=115200;
    s->h.Init.WordLength=0;
    s->h.Init.Parity=0;
    s->h.Init.Mode=12;
    s->h.Init.Prescaler=1;
    s->h.Init.PowerMode=0;
    s->h.Init.ClockPrescaler=0;
    s->h.gState=HAL_IRDA_STATE_READY;s->h.RxState=HAL_IRDA_STATE_READY;
    for(uint32_t d=0;d<2;d++) {
        s->dma[d].Parent=&s->h;s->dma[d].Instance=&s->dmaRegs[d];
        CIRDA_Set(s,3+d,0,1);CIRDA_Set(s,3+d,3,1);CIRDA_Set(s,3+d,4,1);CIRDA_Set(s,3+d,5,1);
        for(uint32_t i=0;i<128;i++)s->buffers[d][i]=0xA53CC35A+i;
    }
    for(uint32_t id=0;id<10;id++)CIRDA_SetCallback(s,id,1);
}
uint32_t CIRDA_Constant(uint32_t i) {switch(i) {
case 0:return HAL_IRDA_ABORT_COMPLETE_CB_ID;
case 1:return HAL_IRDA_ABORT_RECEIVE_COMPLETE_CB_ID;
case 2:return HAL_IRDA_ABORT_TRANSMIT_COMPLETE_CB_ID;
case 3:return HAL_IRDA_ERROR_BUSY;
case 4:return HAL_IRDA_ERROR_CB_ID;
case 5:return HAL_IRDA_ERROR_DMA;
case 6:return HAL_IRDA_ERROR_FE;
case 7:return HAL_IRDA_ERROR_INVALID_CALLBACK;
case 8:return HAL_IRDA_ERROR_NE;
case 9:return HAL_IRDA_ERROR_NONE;
case 10:return HAL_IRDA_ERROR_ORE;
case 11:return HAL_IRDA_ERROR_PE;
case 12:return HAL_IRDA_MSPDEINIT_CB_ID;
case 13:return HAL_IRDA_MSPINIT_CB_ID;
case 14:return HAL_IRDA_RX_COMPLETE_CB_ID;
case 15:return HAL_IRDA_RX_HALFCOMPLETE_CB_ID;
case 16:return HAL_IRDA_STATE_BUSY;
case 17:return HAL_IRDA_STATE_BUSY_RX;
case 18:return HAL_IRDA_STATE_BUSY_TX;
case 19:return HAL_IRDA_STATE_BUSY_TX_RX;
case 20:return HAL_IRDA_STATE_ERROR;
case 21:return HAL_IRDA_STATE_READY;
case 22:return HAL_IRDA_STATE_RESET;
case 23:return HAL_IRDA_STATE_TIMEOUT;
case 24:return HAL_IRDA_TX_COMPLETE_CB_ID;
case 25:return HAL_IRDA_TX_HALFCOMPLETE_CB_ID;
case 26:return IRDA_AUTOBAUD_REQUEST;
case 27:return IRDA_CLEAR_FEF;
case 28:return IRDA_CLEAR_IDLEF;
case 29:return IRDA_CLEAR_NEF;
case 30:return IRDA_CLEAR_OREF;
case 31:return IRDA_CLEAR_PEF;
case 32:return IRDA_CLEAR_TCF;
case 33:return IRDA_CLOCKSOURCE_CSI;
case 34:return IRDA_CLOCKSOURCE_HSI;
case 35:return IRDA_CLOCKSOURCE_LSE;
case 36:return IRDA_CLOCKSOURCE_PCLK1;
case 37:return IRDA_CLOCKSOURCE_PCLK2;
case 38:return IRDA_CLOCKSOURCE_PLL2Q;
case 39:return IRDA_CLOCKSOURCE_PLL3Q;
case 40:return IRDA_CLOCKSOURCE_UNDEFINED;
case 41:return IRDA_CR_MASK;
case 42:return IRDA_CR_POS;
case 43:return IRDA_DMA_RX_DISABLE;
case 44:return IRDA_DMA_RX_ENABLE;
case 45:return IRDA_DMA_TX_DISABLE;
case 46:return IRDA_DMA_TX_ENABLE;
case 47:return IRDA_FLAG_ABRE;
case 48:return IRDA_FLAG_ABRF;
case 49:return IRDA_FLAG_BUSY;
case 50:return IRDA_FLAG_FE;
case 51:return IRDA_FLAG_NE;
case 52:return IRDA_FLAG_ORE;
case 53:return IRDA_FLAG_PE;
case 54:return IRDA_FLAG_REACK;
case 55:return IRDA_FLAG_RXNE;
case 56:return IRDA_FLAG_TC;
case 57:return IRDA_FLAG_TEACK;
case 58:return IRDA_FLAG_TXE;
case 59:return IRDA_ISR_MASK;
case 60:return IRDA_ISR_POS;
case 61:return IRDA_IT_ERR;
case 62:return IRDA_IT_FE;
case 63:return IRDA_IT_IDLE;
case 64:return IRDA_IT_MASK;
case 65:return IRDA_IT_NE;
case 66:return IRDA_IT_ORE;
case 67:return IRDA_IT_PE;
case 68:return IRDA_IT_RXNE;
case 69:return IRDA_IT_TC;
case 70:return IRDA_IT_TXE;
case 71:return IRDA_MODE_DISABLE;
case 72:return IRDA_MODE_ENABLE;
case 73:return IRDA_MODE_RX;
case 74:return IRDA_MODE_TX;
case 75:return IRDA_MODE_TX_RX;
case 76:return IRDA_ONE_BIT_SAMPLE_DISABLE;
case 77:return IRDA_ONE_BIT_SAMPLE_ENABLE;
case 78:return IRDA_PARITY_EVEN;
case 79:return IRDA_PARITY_NONE;
case 80:return IRDA_PARITY_ODD;
case 81:return IRDA_POWERMODE_LOWPOWER;
case 82:return IRDA_POWERMODE_NORMAL;
case 83:return IRDA_PRESCALER_DIV1;
case 84:return IRDA_PRESCALER_DIV10;
case 85:return IRDA_PRESCALER_DIV12;
case 86:return IRDA_PRESCALER_DIV128;
case 87:return IRDA_PRESCALER_DIV16;
case 88:return IRDA_PRESCALER_DIV2;
case 89:return IRDA_PRESCALER_DIV256;
case 90:return IRDA_PRESCALER_DIV32;
case 91:return IRDA_PRESCALER_DIV4;
case 92:return IRDA_PRESCALER_DIV6;
case 93:return IRDA_PRESCALER_DIV64;
case 94:return IRDA_PRESCALER_DIV8;
case 95:return IRDA_RXDATA_FLUSH_REQUEST;
case 96:return IRDA_STATE_DISABLE;
case 97:return IRDA_STATE_ENABLE;
case 98:return IRDA_TXDATA_FLUSH_REQUEST;
case 99:return IRDA_WORDLENGTH_7B;
case 100:return IRDA_WORDLENGTH_8B;
case 101:return IRDA_WORDLENGTH_9B;
default:assert(0);return 0;} }
