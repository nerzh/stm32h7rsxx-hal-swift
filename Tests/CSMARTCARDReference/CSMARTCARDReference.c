#include "SMARTCARDInternal.h"
#include "SMARTCARDPrivate.h"
_Thread_local CSMARTCARDState *CSMARTCARD_Active;
uint32_t CSMARTCARD0_GetWord(CSMARTCARDState *,uint32_t);
uint32_t CSMARTCARD0_Run(CSMARTCARDState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSMARTCARD0_GetDMA(CSMARTCARDState *,uint32_t,uint32_t);
void CSMARTCARD0_SetWord(CSMARTCARDState *,uint32_t,uint32_t);
void CSMARTCARD0_SetDMA(CSMARTCARDState *,uint32_t,uint32_t,uint32_t);
uint32_t CSMARTCARD1_GetWord(CSMARTCARDState *,uint32_t);
uint32_t CSMARTCARD1_Run(CSMARTCARDState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSMARTCARD1_GetDMA(CSMARTCARDState *,uint32_t,uint32_t);
void CSMARTCARD1_SetWord(CSMARTCARDState *,uint32_t,uint32_t);
void CSMARTCARD1_SetDMA(CSMARTCARDState *,uint32_t,uint32_t,uint32_t);
size_t CSMARTCARD_Size(void) { return sizeof(CSMARTCARDState); }
USART_TypeDef *CSMARTCARD_Instance(uint32_t address) { return address==CSMARTCARD_Active->control[3]?&CSMARTCARD_Active->regs:(USART_TypeDef *)(uintptr_t)address; }
void *CSMARTCARD_Buffer(CSMARTCARDState *s,uint32_t i) { assert(i<2);return s->buffers[i]; }
void *CSMARTCARD_GetPointer(CSMARTCARDState *s,uint32_t i) { return i?(void *)s->h.pRxBuffPtr:(void *)s->h.pTxBuffPtr; }
void CSMARTCARD_SetPointer(CSMARTCARDState *s,uint32_t i,void *p) { if(i)s->h.pRxBuffPtr=p;else s->h.pTxBuffPtr=p; }
uint32_t CSMARTCARD_TickFor(CSMARTCARDState *s) {
    uint32_t value=s->control[0];s->control[0]+=s->control[1];s->control[2]++;
    if(s->control[10] && s->control[2]==s->control[10])s->regs.ISR=s->control[11];
    return value;
}
uint32_t CSMARTCARD_Tick(void) { return CSMARTCARD_TickFor(CSMARTCARD_Active); }
uint32_t CSMARTCARD_Run(CSMARTCARDState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
    CSMARTCARDState *old=CSMARTCARD_Active;CSMARTCARD_Active=s;
    uint32_t r=s->control[31]?CSMARTCARD1_Run(s,op,a,b,c):CSMARTCARD0_Run(s,op,a,b,c);CSMARTCARD_Active=old;return r;
}
uint32_t CSMARTCARD_Get(CSMARTCARDState *s,uint32_t group,uint32_t i) {
    switch(group) {
    case 0:assert(i<12);return ((volatile uint32_t *)&s->regs)[i];
    case 1:return s->control[31]?CSMARTCARD1_GetWord(s,i):CSMARTCARD0_GetWord(s,i);
    case 2:assert(i<32);return s->control[i];
    case 3:case 4: { uint32_t d=group-3;assert(i<16);switch(i) {
      case 1:return s->dma[d].Mode;case 2:return s->dma[d].ErrorCode;case 3:return s->dma[d].State;
      default:return s->settings[d][i];} }
    case 5:case 6:assert(i<8);return s->node[group-5].LinkRegisters[i];
    case 7:assert(i<1024);return s->callbackTrace[i];
    case 8:assert(i<1024);return s->dmaTrace[i];
    default:assert(0);return 0;}
}
void CSMARTCARD_Set(CSMARTCARDState *s,uint32_t group,uint32_t i,uint32_t v) {
    switch(group) {
    case 0:assert(i<12);((volatile uint32_t *)&s->regs)[i]=v;break;
    case 1:if(s->control[31])CSMARTCARD1_SetWord(s,i,v);else CSMARTCARD0_SetWord(s,i,v);break;
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
void CSMARTCARD_Callback(CSMARTCARDState *s,uint32_t id,uint32_t implementation) {
    uint32_t *n=&s->control[8];assert(*n+8<=1024);
    s->callbackTrace[(*n)++]=id;s->callbackTrace[(*n)++]=implementation;
    s->callbackTrace[(*n)++]=s->h.gState;s->callbackTrace[(*n)++]=s->h.RxState;s->callbackTrace[(*n)++]=s->h.ErrorCode;
    s->callbackTrace[(*n)++]=s->h.Lock;s->callbackTrace[(*n)++]=s->h.TxXferCount;s->callbackTrace[(*n)++]=s->h.RxXferCount;
    if(s->control[13] && id==s->control[14])s->h.gState=s->control[15];
    if(s->control[16] && id==s->control[17])s->h.RxState=s->control[18];
}
void HAL_SMARTCARD_TxCpltCallback(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,0,1); }
static void CB0_2(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,0,2); }
static void CB0_3(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,0,3); }
void HAL_SMARTCARD_RxCpltCallback(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,1,1); }
static void CB1_2(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,1,2); }
static void CB1_3(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,1,3); }
void HAL_SMARTCARD_ErrorCallback(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,2,1); }
static void CB2_2(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,2,2); }
static void CB2_3(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,2,3); }
void HAL_SMARTCARD_AbortCpltCallback(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,3,1); }
static void CB3_2(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,3,2); }
static void CB3_3(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,3,3); }
void HAL_SMARTCARD_AbortTransmitCpltCallback(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,4,1); }
static void CB4_2(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,4,2); }
static void CB4_3(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,4,3); }
void HAL_SMARTCARD_AbortReceiveCpltCallback(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,5,1); }
static void CB5_2(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,5,2); }
static void CB5_3(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,5,3); }
void HAL_SMARTCARDEx_RxFifoFullCallback(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,6,1); }
static void CB6_2(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,6,2); }
static void CB6_3(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,6,3); }
void HAL_SMARTCARDEx_TxFifoEmptyCallback(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,7,1); }
static void CB7_2(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,7,2); }
static void CB7_3(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,7,3); }
void HAL_SMARTCARD_MspInit(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,8,1); }
static void CB8_2(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,8,2); }
static void CB8_3(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,8,3); }
void HAL_SMARTCARD_MspDeInit(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,9,1); }
static void CB9_2(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,9,2); }
static void CB9_3(SMARTCARD_HandleTypeDef *h) { CSMARTCARD_Callback((CSMARTCARDState *)h,9,3); }
pSMARTCARD_CallbackTypeDef CSMARTCARD_CallbackPointer(uint32_t id,uint32_t v) { if(!v)return NULL;switch(id) {
case 0:return v==1?HAL_SMARTCARD_TxCpltCallback:v==2?CB0_2:CB0_3;
case 1:return v==1?HAL_SMARTCARD_RxCpltCallback:v==2?CB1_2:CB1_3;
case 2:return v==1?HAL_SMARTCARD_ErrorCallback:v==2?CB2_2:CB2_3;
case 3:return v==1?HAL_SMARTCARD_AbortCpltCallback:v==2?CB3_2:CB3_3;
case 4:return v==1?HAL_SMARTCARD_AbortTransmitCpltCallback:v==2?CB4_2:CB4_3;
case 5:return v==1?HAL_SMARTCARD_AbortReceiveCpltCallback:v==2?CB5_2:CB5_3;
case 6:return v==1?HAL_SMARTCARDEx_RxFifoFullCallback:v==2?CB6_2:CB6_3;
case 7:return v==1?HAL_SMARTCARDEx_TxFifoEmptyCallback:v==2?CB7_2:CB7_3;
case 8:return v==1?HAL_SMARTCARD_MspInit:v==2?CB8_2:CB8_3;
case 9:return v==1?HAL_SMARTCARD_MspDeInit:v==2?CB9_2:CB9_3;
default:assert(0);return NULL;} }
uint32_t CSMARTCARD_GetCallback(CSMARTCARDState *s,uint32_t id) {pSMARTCARD_CallbackTypeDef f=NULL;switch(id) {
case 0:f=s->h.TxCpltCallback;break;
case 1:f=s->h.RxCpltCallback;break;
case 2:f=s->h.ErrorCallback;break;
case 3:f=s->h.AbortCpltCallback;break;
case 4:f=s->h.AbortTransmitCpltCallback;break;
case 5:f=s->h.AbortReceiveCpltCallback;break;
case 6:f=s->h.RxFifoFullCallback;break;
case 7:f=s->h.TxFifoEmptyCallback;break;
case 8:f=s->h.MspInitCallback;break;
case 9:f=s->h.MspDeInitCallback;break;
default:assert(0);break;}for(uint32_t v=0;v<=3;v++)if(f==CSMARTCARD_CallbackPointer(id,v))return v;assert(0);return 0;}
void CSMARTCARD_SetCallback(CSMARTCARDState *s,uint32_t id,uint32_t v) {switch(id) {
case 0:s->h.TxCpltCallback=CSMARTCARD_CallbackPointer(id,v);break;
case 1:s->h.RxCpltCallback=CSMARTCARD_CallbackPointer(id,v);break;
case 2:s->h.ErrorCallback=CSMARTCARD_CallbackPointer(id,v);break;
case 3:s->h.AbortCpltCallback=CSMARTCARD_CallbackPointer(id,v);break;
case 4:s->h.AbortTransmitCpltCallback=CSMARTCARD_CallbackPointer(id,v);break;
case 5:s->h.AbortReceiveCpltCallback=CSMARTCARD_CallbackPointer(id,v);break;
case 6:s->h.RxFifoFullCallback=CSMARTCARD_CallbackPointer(id,v);break;
case 7:s->h.TxFifoEmptyCallback=CSMARTCARD_CallbackPointer(id,v);break;
case 8:s->h.MspInitCallback=CSMARTCARD_CallbackPointer(id,v);break;
case 9:s->h.MspDeInitCallback=CSMARTCARD_CallbackPointer(id,v);break;
default:assert(0);break;} }
uint32_t CSMARTCARD_GetDMACallback(CSMARTCARDState *s,uint32_t d,uint32_t id) { return s->control[31]?CSMARTCARD1_GetDMA(s,d,id):CSMARTCARD0_GetDMA(s,d,id); }
void CSMARTCARD_SetDMACallback(CSMARTCARDState *s,uint32_t d,uint32_t id,uint32_t v) { if(s->control[31])CSMARTCARD1_SetDMA(s,d,id,v);else CSMARTCARD0_SetDMA(s,d,id,v); }
uint32_t CSMARTCARD_Normalize(CSMARTCARDState *s,uint32_t v) {
    for(uint32_t d=0;d<2;d++) { uint32_t base=(uint32_t)(uintptr_t)s->buffers[d];
        if(v-base<sizeof(s->buffers[d]))return 0x20000000+d*0x1000+(v-base); }
    uint32_t base=(uint32_t)(uintptr_t)&s->regs;
    if(v-base<sizeof(s->regs))return s->control[3]+(v-base);
    return v;
}
uint32_t CSMARTCARD_DMAAction(CSMARTCARDState *s,uint32_t d,uint32_t op,uint32_t src,uint32_t dst,uint32_t count) {
    uint32_t *n=&s->control[9];assert(*n+5<=1024);
    s->dmaTrace[(*n)++]=d;s->dmaTrace[(*n)++]=op;s->dmaTrace[(*n)++]=CSMARTCARD_Normalize(s,src);
    s->dmaTrace[(*n)++]=CSMARTCARD_Normalize(s,dst);s->dmaTrace[(*n)++]=count;
    return s->settings[d][6+op];
}
static uint32_t DMAIndex(DMA_HandleTypeDef *h) { if(h==&CSMARTCARD_Active->dma[0])return 0;assert(h==&CSMARTCARD_Active->dma[1]);return 1; }
HAL_StatusTypeDef CSMARTCARD_DMAStart(DMA_HandleTypeDef *h,uint32_t src,uint32_t dst,uint32_t n) {return CSMARTCARD_DMAAction(CSMARTCARD_Active,DMAIndex(h),0,src,dst,n);}
HAL_StatusTypeDef CSMARTCARD_DMAList(DMA_HandleTypeDef *h) {return CSMARTCARD_DMAAction(CSMARTCARD_Active,DMAIndex(h),1,0,0,0);}
HAL_StatusTypeDef CSMARTCARD_DMAAbort(DMA_HandleTypeDef *h) {return CSMARTCARD_DMAAction(CSMARTCARD_Active,DMAIndex(h),2,0,0,0);}
HAL_StatusTypeDef CSMARTCARD_DMAAbortIT(DMA_HandleTypeDef *h) {return CSMARTCARD_DMAAction(CSMARTCARD_Active,DMAIndex(h),3,0,0,0);}
HAL_StatusTypeDef CSMARTCARD_DMASuspend(DMA_HandleTypeDef *h) {return CSMARTCARD_DMAAction(CSMARTCARD_Active,DMAIndex(h),4,0,0,0);}
HAL_StatusTypeDef CSMARTCARD_DMAResume(DMA_HandleTypeDef *h) {return CSMARTCARD_DMAAction(CSMARTCARD_Active,DMAIndex(h),5,0,0,0);}
void CSMARTCARD_Reset(CSMARTCARDState *s,uint32_t registered) {
    memset(s,0,sizeof(*s));s->h.Instance=&s->regs;s->control[31]=registered;
    s->control[1]=1;s->control[3]=0x40004800;s->control[4]=64000000;
    s->h.Init.BaudRate=9600;
    s->h.Init.WordLength=4096;
    s->h.Init.StopBits=12288;
    s->h.Init.Parity=1024;
    s->h.Init.Mode=12;
    s->h.Init.CLKPolarity=0;
    s->h.Init.CLKPhase=0;
    s->h.Init.CLKLastBit=0;
    s->h.Init.OneBitSampling=0;
    s->h.Init.Prescaler=1;
    s->h.Init.GuardTime=0;
    s->h.Init.NACKEnable=0;
    s->h.Init.TimeOutEnable=0;
    s->h.Init.TimeOutValue=0;
    s->h.Init.BlockLength=0;
    s->h.Init.AutoRetryCount=0;
    s->h.Init.ClockPrescaler=0;
    s->h.AdvancedInit.AdvFeatureInit=0;
    s->h.AdvancedInit.TxPinLevelInvert=0;
    s->h.AdvancedInit.RxPinLevelInvert=0;
    s->h.AdvancedInit.DataInvert=0;
    s->h.AdvancedInit.Swap=0;
    s->h.AdvancedInit.OverrunDisable=0;
    s->h.AdvancedInit.DMADisableonRxError=0;
    s->h.AdvancedInit.MSBFirst=0;
    s->h.AdvancedInit.TxCompletionIndication=1574;
    s->h.gState=HAL_SMARTCARD_STATE_READY;s->h.RxState=HAL_SMARTCARD_STATE_READY;
    s->h.NbTxDataToProcess=1;s->h.NbRxDataToProcess=1;
    for(uint32_t d=0;d<2;d++) {
        s->dma[d].Parent=&s->h;s->dma[d].Instance=&s->dmaRegs[d];
        CSMARTCARD_Set(s,3+d,0,1);CSMARTCARD_Set(s,3+d,3,1);CSMARTCARD_Set(s,3+d,4,1);CSMARTCARD_Set(s,3+d,5,1);
        for(uint32_t i=0;i<128;i++)s->buffers[d][i]=0xA53CC35A+i;
    }
    for(uint32_t id=0;id<10;id++)CSMARTCARD_SetCallback(s,id,1);
}
uint32_t CSMARTCARD_Constant(uint32_t i) {switch(i) {
case 0:return HAL_SMARTCARD_ABORT_COMPLETE_CB_ID;
case 1:return HAL_SMARTCARD_ABORT_RECEIVE_COMPLETE_CB_ID;
case 2:return HAL_SMARTCARD_ABORT_TRANSMIT_COMPLETE_CB_ID;
case 3:return HAL_SMARTCARD_ERROR_CB_ID;
case 4:return HAL_SMARTCARD_ERROR_DMA;
case 5:return HAL_SMARTCARD_ERROR_FE;
case 6:return HAL_SMARTCARD_ERROR_INVALID_CALLBACK;
case 7:return HAL_SMARTCARD_ERROR_NE;
case 8:return HAL_SMARTCARD_ERROR_NONE;
case 9:return HAL_SMARTCARD_ERROR_ORE;
case 10:return HAL_SMARTCARD_ERROR_PE;
case 11:return HAL_SMARTCARD_ERROR_RTO;
case 12:return HAL_SMARTCARD_MSPDEINIT_CB_ID;
case 13:return HAL_SMARTCARD_MSPINIT_CB_ID;
case 14:return HAL_SMARTCARD_RX_COMPLETE_CB_ID;
case 15:return HAL_SMARTCARD_RX_FIFO_FULL_CB_ID;
case 16:return HAL_SMARTCARD_STATE_BUSY;
case 17:return HAL_SMARTCARD_STATE_BUSY_RX;
case 18:return HAL_SMARTCARD_STATE_BUSY_TX;
case 19:return HAL_SMARTCARD_STATE_BUSY_TX_RX;
case 20:return HAL_SMARTCARD_STATE_ERROR;
case 21:return HAL_SMARTCARD_STATE_READY;
case 22:return HAL_SMARTCARD_STATE_RESET;
case 23:return HAL_SMARTCARD_STATE_TIMEOUT;
case 24:return HAL_SMARTCARD_TX_COMPLETE_CB_ID;
case 25:return HAL_SMARTCARD_TX_FIFO_EMPTY_CB_ID;
case 26:return SMARTCARD_ADVFEATURE_DATAINVERT_INIT;
case 27:return SMARTCARD_ADVFEATURE_DATAINV_DISABLE;
case 28:return SMARTCARD_ADVFEATURE_DATAINV_ENABLE;
case 29:return SMARTCARD_ADVFEATURE_DMADISABLEONERROR_INIT;
case 30:return SMARTCARD_ADVFEATURE_DMA_DISABLEONRXERROR;
case 31:return SMARTCARD_ADVFEATURE_DMA_ENABLEONRXERROR;
case 32:return SMARTCARD_ADVFEATURE_MSBFIRST_DISABLE;
case 33:return SMARTCARD_ADVFEATURE_MSBFIRST_ENABLE;
case 34:return SMARTCARD_ADVFEATURE_MSBFIRST_INIT;
case 35:return SMARTCARD_ADVFEATURE_NO_INIT;
case 36:return SMARTCARD_ADVFEATURE_OVERRUN_DISABLE;
case 37:return SMARTCARD_ADVFEATURE_OVERRUN_ENABLE;
case 38:return SMARTCARD_ADVFEATURE_RXINVERT_INIT;
case 39:return SMARTCARD_ADVFEATURE_RXINV_DISABLE;
case 40:return SMARTCARD_ADVFEATURE_RXINV_ENABLE;
case 41:return SMARTCARD_ADVFEATURE_RXOVERRUNDISABLE_INIT;
case 42:return SMARTCARD_ADVFEATURE_SWAP_DISABLE;
case 43:return SMARTCARD_ADVFEATURE_SWAP_ENABLE;
case 44:return SMARTCARD_ADVFEATURE_SWAP_INIT;
case 45:return SMARTCARD_ADVFEATURE_TXCOMPLETION;
case 46:return SMARTCARD_ADVFEATURE_TXINVERT_INIT;
case 47:return SMARTCARD_ADVFEATURE_TXINV_DISABLE;
case 48:return SMARTCARD_ADVFEATURE_TXINV_ENABLE;
case 49:return SMARTCARD_CLEAR_EOBF;
case 50:return SMARTCARD_CLEAR_FEF;
case 51:return SMARTCARD_CLEAR_IDLEF;
case 52:return SMARTCARD_CLEAR_NEF;
case 53:return SMARTCARD_CLEAR_OREF;
case 54:return SMARTCARD_CLEAR_PEF;
case 55:return SMARTCARD_CLEAR_RTOF;
case 56:return SMARTCARD_CLEAR_TCBGTF;
case 57:return SMARTCARD_CLEAR_TCF;
case 58:return SMARTCARD_CLEAR_TXFECF;
case 59:return SMARTCARD_CLOCKSOURCE_CSI;
case 60:return SMARTCARD_CLOCKSOURCE_HSI;
case 61:return SMARTCARD_CLOCKSOURCE_LSE;
case 62:return SMARTCARD_CLOCKSOURCE_PCLK1;
case 63:return SMARTCARD_CLOCKSOURCE_PCLK2;
case 64:return SMARTCARD_CLOCKSOURCE_PLL2Q;
case 65:return SMARTCARD_CLOCKSOURCE_PLL3Q;
case 66:return SMARTCARD_CLOCKSOURCE_UNDEFINED;
case 67:return SMARTCARD_CR_MASK;
case 68:return SMARTCARD_CR_POS;
case 69:return SMARTCARD_FIFOMODE_DISABLE;
case 70:return SMARTCARD_FIFOMODE_ENABLE;
case 71:return SMARTCARD_FLAG_BUSY;
case 72:return SMARTCARD_FLAG_EOBF;
case 73:return SMARTCARD_FLAG_FE;
case 74:return SMARTCARD_FLAG_IDLE;
case 75:return SMARTCARD_FLAG_NE;
case 76:return SMARTCARD_FLAG_ORE;
case 77:return SMARTCARD_FLAG_PE;
case 78:return SMARTCARD_FLAG_REACK;
case 79:return SMARTCARD_FLAG_RTOF;
case 80:return SMARTCARD_FLAG_RXFF;
case 81:return SMARTCARD_FLAG_RXFNE;
case 82:return SMARTCARD_FLAG_RXFT;
case 83:return SMARTCARD_FLAG_RXNE;
case 84:return SMARTCARD_FLAG_TC;
case 85:return SMARTCARD_FLAG_TCBGT;
case 86:return SMARTCARD_FLAG_TEACK;
case 87:return SMARTCARD_FLAG_TXE;
case 88:return SMARTCARD_FLAG_TXFE;
case 89:return SMARTCARD_FLAG_TXFNF;
case 90:return SMARTCARD_FLAG_TXFT;
case 91:return SMARTCARD_ISR_MASK;
case 92:return SMARTCARD_ISR_POS;
case 93:return SMARTCARD_IT_EOB;
case 94:return SMARTCARD_IT_ERR;
case 95:return SMARTCARD_IT_FE;
case 96:return SMARTCARD_IT_IDLE;
case 97:return SMARTCARD_IT_MASK;
case 98:return SMARTCARD_IT_NE;
case 99:return SMARTCARD_IT_ORE;
case 100:return SMARTCARD_IT_PE;
case 101:return SMARTCARD_IT_RTO;
case 102:return SMARTCARD_IT_RXFF;
case 103:return SMARTCARD_IT_RXFNE;
case 104:return SMARTCARD_IT_RXFT;
case 105:return SMARTCARD_IT_RXNE;
case 106:return SMARTCARD_IT_TC;
case 107:return SMARTCARD_IT_TCBGT;
case 108:return SMARTCARD_IT_TXE;
case 109:return SMARTCARD_IT_TXFE;
case 110:return SMARTCARD_IT_TXFNF;
case 111:return SMARTCARD_IT_TXFT;
case 112:return SMARTCARD_LASTBIT_DISABLE;
case 113:return SMARTCARD_LASTBIT_ENABLE;
case 114:return SMARTCARD_MODE_RX;
case 115:return SMARTCARD_MODE_TX;
case 116:return SMARTCARD_MODE_TX_RX;
case 117:return SMARTCARD_NACK_DISABLE;
case 118:return SMARTCARD_NACK_ENABLE;
case 119:return SMARTCARD_ONE_BIT_SAMPLE_DISABLE;
case 120:return SMARTCARD_ONE_BIT_SAMPLE_ENABLE;
case 121:return SMARTCARD_PARITY_EVEN;
case 122:return SMARTCARD_PARITY_ODD;
case 123:return SMARTCARD_PHASE_1EDGE;
case 124:return SMARTCARD_PHASE_2EDGE;
case 125:return SMARTCARD_POLARITY_HIGH;
case 126:return SMARTCARD_POLARITY_LOW;
case 127:return SMARTCARD_PRESCALER_DIV1;
case 128:return SMARTCARD_PRESCALER_DIV10;
case 129:return SMARTCARD_PRESCALER_DIV12;
case 130:return SMARTCARD_PRESCALER_DIV128;
case 131:return SMARTCARD_PRESCALER_DIV16;
case 132:return SMARTCARD_PRESCALER_DIV2;
case 133:return SMARTCARD_PRESCALER_DIV256;
case 134:return SMARTCARD_PRESCALER_DIV32;
case 135:return SMARTCARD_PRESCALER_DIV4;
case 136:return SMARTCARD_PRESCALER_DIV6;
case 137:return SMARTCARD_PRESCALER_DIV64;
case 138:return SMARTCARD_PRESCALER_DIV8;
case 139:return SMARTCARD_RXDATA_FLUSH_REQUEST;
case 140:return SMARTCARD_RXFIFO_THRESHOLD_1_2;
case 141:return SMARTCARD_RXFIFO_THRESHOLD_1_4;
case 142:return SMARTCARD_RXFIFO_THRESHOLD_1_8;
case 143:return SMARTCARD_RXFIFO_THRESHOLD_3_4;
case 144:return SMARTCARD_RXFIFO_THRESHOLD_7_8;
case 145:return SMARTCARD_RXFIFO_THRESHOLD_8_8;
case 146:return SMARTCARD_STOPBITS_0_5;
case 147:return SMARTCARD_STOPBITS_1_5;
case 148:return SMARTCARD_TC;
case 149:return SMARTCARD_TCBGT;
case 150:return SMARTCARD_TIMEOUT_DISABLE;
case 151:return SMARTCARD_TIMEOUT_ENABLE;
case 152:return SMARTCARD_TXDATA_FLUSH_REQUEST;
case 153:return SMARTCARD_TXFIFO_THRESHOLD_1_2;
case 154:return SMARTCARD_TXFIFO_THRESHOLD_1_4;
case 155:return SMARTCARD_TXFIFO_THRESHOLD_1_8;
case 156:return SMARTCARD_TXFIFO_THRESHOLD_3_4;
case 157:return SMARTCARD_TXFIFO_THRESHOLD_7_8;
case 158:return SMARTCARD_TXFIFO_THRESHOLD_8_8;
case 159:return SMARTCARD_WORDLENGTH_9B;
default:assert(0);return 0;} }
