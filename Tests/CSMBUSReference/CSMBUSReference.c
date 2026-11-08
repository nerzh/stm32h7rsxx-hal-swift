#include "SMBUSInternal.h"
CSMBUS_THREAD_LOCAL CSMBUSState *CSMBUS_Active;
size_t CSMBUS_Size(void){return sizeof(CSMBUSState);}
uint8_t *CSMBUS_Buffer(CSMBUSState *s){return s->buffer;}
uint8_t *CSMBUS_GetBuffer(CSMBUSState *s){return s->h.pBuffPtr;}
void CSMBUS_SetBuffer(CSMBUSState *s,uint8_t *p){s->h.pBuffPtr=p;}
uint32_t CSMBUS_TickFor(CSMBUSState *s){uint32_t v=s->control[0];s->control[0]+=s->control[1];s->control[2]++;if(s->control[10]&&s->control[2]==s->control[10])s->regs.ISR=s->control[11];return v;}
uint32_t CSMBUS_Tick(void){return CSMBUS_TickFor(CSMBUS_Active);}
uint32_t CSMBUS_Run(CSMBUSState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CSMBUSState *old=CSMBUS_Active;CSMBUS_Active=s;uint32_t r=s->control[31]?CSMBUS1_Run(s,op,a,b,c):CSMBUS0_Run(s,op,a,b,c);CSMBUS_Active=old;return r;}
uint32_t CSMBUS_Get(CSMBUSState *s,uint32_t group,uint32_t i){switch(group){
case 0:assert(i<11);return ((volatile uint32_t *)&s->regs)[i];
case 1:switch(i){
case 0:return s->h.Init.Timing;
case 1:return s->h.Init.AnalogFilter;
case 2:return s->h.Init.OwnAddress1;
case 3:return s->h.Init.AddressingMode;
case 4:return s->h.Init.DualAddressMode;
case 5:return s->h.Init.OwnAddress2;
case 6:return s->h.Init.OwnAddress2Masks;
case 7:return s->h.Init.GeneralCallMode;
case 8:return s->h.Init.NoStretchMode;
case 9:return s->h.Init.PacketErrorCheckMode;
case 10:return s->h.Init.PeripheralMode;
case 11:return s->h.Init.SMBusTimeout;
case 12:return s->h.XferSize;
case 13:return s->h.XferCount;
case 14:return s->h.State;
case 15:return s->h.ErrorCode;
case 16:return s->h.Lock;
case 17:return s->h.XferOptions;
case 18:return s->h.PreviousState;
default:assert(0);return 0;}
case 2:assert(i<64);return s->control[i];
case 3:assert(i<4096);return s->buffer[i];
case 4:assert(i<1024);return s->trace[i];
default:assert(0);return 0;}}
void CSMBUS_Set(CSMBUSState *s,uint32_t group,uint32_t i,uint32_t v){switch(group){
case 0:assert(i<11);((volatile uint32_t *)&s->regs)[i]=v;break;
case 1:switch(i){
case 0:s->h.Init.Timing=v;break;
case 1:s->h.Init.AnalogFilter=v;break;
case 2:s->h.Init.OwnAddress1=v;break;
case 3:s->h.Init.AddressingMode=v;break;
case 4:s->h.Init.DualAddressMode=v;break;
case 5:s->h.Init.OwnAddress2=v;break;
case 6:s->h.Init.OwnAddress2Masks=v;break;
case 7:s->h.Init.GeneralCallMode=v;break;
case 8:s->h.Init.NoStretchMode=v;break;
case 9:s->h.Init.PacketErrorCheckMode=v;break;
case 10:s->h.Init.PeripheralMode=v;break;
case 11:s->h.Init.SMBusTimeout=v;break;
case 12:s->h.XferSize=v;break;
case 13:s->h.XferCount=v;break;
case 14:s->h.State=v;break;
case 15:s->h.ErrorCode=v;break;
case 16:s->h.Lock=v;break;
case 17:s->h.XferOptions=v;break;
case 18:s->h.PreviousState=v;break;
default:assert(0);break;}break;
case 2:assert(i<64);s->control[i]=v;break;
case 3:assert(i<4096);s->buffer[i]=v;break;
case 4:assert(i<1024);s->trace[i]=v;break;
default:assert(0);break;}}
static void traceCallback(SMBUS_HandleTypeDef *h,uint32_t id,uint32_t custom,uint32_t direction,uint32_t match){
 CSMBUSState *s=(CSMBUSState *)h;uint32_t *n=&s->control[8];assert(*n+11<=1024);
 s->trace[(*n)++]=id;s->trace[(*n)++]=custom;s->trace[(*n)++]=direction;s->trace[(*n)++]=match;
 s->trace[(*n)++]=h->State;s->trace[(*n)++]=h->ErrorCode;s->trace[(*n)++]=h->Lock;
 s->trace[(*n)++]=h->XferCount;s->trace[(*n)++]=h->XferSize;s->trace[(*n)++]=h->XferOptions;s->trace[(*n)++]=h->PreviousState;
 if(s->control[20]&&s->control[20]-1==id){CSMBUS_Set(s,1,s->control[21],s->control[22]);s->control[20]=0;}
}
void HAL_SMBUS_MasterTxCpltCallback(SMBUS_HandleTypeDef *h){traceCallback(h,0,0,0,0);}
static void Custom0(SMBUS_HandleTypeDef *h){traceCallback(h,0,1,0,0);}
void HAL_SMBUS_MasterRxCpltCallback(SMBUS_HandleTypeDef *h){traceCallback(h,1,0,0,0);}
static void Custom1(SMBUS_HandleTypeDef *h){traceCallback(h,1,1,0,0);}
void HAL_SMBUS_SlaveTxCpltCallback(SMBUS_HandleTypeDef *h){traceCallback(h,2,0,0,0);}
static void Custom2(SMBUS_HandleTypeDef *h){traceCallback(h,2,1,0,0);}
void HAL_SMBUS_SlaveRxCpltCallback(SMBUS_HandleTypeDef *h){traceCallback(h,3,0,0,0);}
static void Custom3(SMBUS_HandleTypeDef *h){traceCallback(h,3,1,0,0);}
void HAL_SMBUS_ListenCpltCallback(SMBUS_HandleTypeDef *h){traceCallback(h,4,0,0,0);}
static void Custom4(SMBUS_HandleTypeDef *h){traceCallback(h,4,1,0,0);}
void HAL_SMBUS_ErrorCallback(SMBUS_HandleTypeDef *h){traceCallback(h,5,0,0,0);}
static void Custom5(SMBUS_HandleTypeDef *h){traceCallback(h,5,1,0,0);}
void HAL_SMBUS_MspInit(SMBUS_HandleTypeDef *h){traceCallback(h,6,0,0,0);}
static void Custom6(SMBUS_HandleTypeDef *h){traceCallback(h,6,1,0,0);}
void HAL_SMBUS_MspDeInit(SMBUS_HandleTypeDef *h){traceCallback(h,7,0,0,0);}
static void Custom7(SMBUS_HandleTypeDef *h){traceCallback(h,7,1,0,0);}
void HAL_SMBUS_AddrCallback(SMBUS_HandleTypeDef *h,uint8_t d,uint16_t m){traceCallback(h,8,0,d,m);}
static void Custom8(SMBUS_HandleTypeDef *h,uint8_t d,uint16_t m){traceCallback(h,8,1,d,m);}
uintptr_t CSMBUS_Callback(uint32_t id,uint32_t token){if(!token)return 0;switch(id){
case 0:return (uintptr_t)(token==1?HAL_SMBUS_MasterTxCpltCallback:Custom0);
case 1:return (uintptr_t)(token==1?HAL_SMBUS_MasterRxCpltCallback:Custom1);
case 2:return (uintptr_t)(token==1?HAL_SMBUS_SlaveTxCpltCallback:Custom2);
case 3:return (uintptr_t)(token==1?HAL_SMBUS_SlaveRxCpltCallback:Custom3);
case 4:return (uintptr_t)(token==1?HAL_SMBUS_ListenCpltCallback:Custom4);
case 5:return (uintptr_t)(token==1?HAL_SMBUS_ErrorCallback:Custom5);
case 6:return (uintptr_t)(token==1?HAL_SMBUS_MspInit:Custom6);
case 7:return (uintptr_t)(token==1?HAL_SMBUS_MspDeInit:Custom7);
case 8:return (uintptr_t)(token==1?HAL_SMBUS_AddrCallback:Custom8);default:assert(0);return 0;}}
uintptr_t CSMBUS_GetCallback(CSMBUSState *s,uint32_t i){switch(i){
case 0:return (uintptr_t)s->h.MasterTxCpltCallback;
case 1:return (uintptr_t)s->h.MasterRxCpltCallback;
case 2:return (uintptr_t)s->h.SlaveTxCpltCallback;
case 3:return (uintptr_t)s->h.SlaveRxCpltCallback;
case 4:return (uintptr_t)s->h.ListenCpltCallback;
case 5:return (uintptr_t)s->h.ErrorCallback;
case 6:return (uintptr_t)s->h.MspInitCallback;
case 7:return (uintptr_t)s->h.MspDeInitCallback;
case 8:return (uintptr_t)s->h.AddrCallback;default:assert(0);return 0;}}
void CSMBUS_SetCallback(CSMBUSState *s,uint32_t i,uintptr_t v){switch(i){
case 0:s->h.MasterTxCpltCallback=(pSMBUS_CallbackTypeDef)v;break;
case 1:s->h.MasterRxCpltCallback=(pSMBUS_CallbackTypeDef)v;break;
case 2:s->h.SlaveTxCpltCallback=(pSMBUS_CallbackTypeDef)v;break;
case 3:s->h.SlaveRxCpltCallback=(pSMBUS_CallbackTypeDef)v;break;
case 4:s->h.ListenCpltCallback=(pSMBUS_CallbackTypeDef)v;break;
case 5:s->h.ErrorCallback=(pSMBUS_CallbackTypeDef)v;break;
case 6:s->h.MspInitCallback=(pSMBUS_CallbackTypeDef)v;break;
case 7:s->h.MspDeInitCallback=(pSMBUS_CallbackTypeDef)v;break;
case 8:s->h.AddrCallback=(pSMBUS_AddrCallbackTypeDef)v;break;default:assert(0);break;}}
static uintptr_t normalize(CSMBUSState *s,uintptr_t v){
 uintptr_t b=(uintptr_t)s->buffer;if(v>=b&&v<=b+sizeof(s->buffer))return 0xABC00000U+v-b;
 return v;}
void CSMBUS_Reset(CSMBUSState *s,uint32_t callbacks){memset(s,0,sizeof(*s));s->h.Instance=&s->regs;s->h.pBuffPtr=s->buffer;s->control[1]=1;s->control[31]=callbacks;
for(uint32_t i=0;i<9;i++)CSMBUS_SetCallback(s,i,CSMBUS_Callback(i,1));}
uint32_t CSMBUS_Compare(CSMBUSState *a,CSMBUSState *b){
const uint32_t sizes[]={11,19,64,4096,1024};
for(uint32_t g=0;g<5;g++)for(uint32_t i=0;i<sizes[g];i++)if(CSMBUS_Get(a,g,i)!=CSMBUS_Get(b,g,i))return ((g+1)<<20)|i;
if(normalize(a,(uintptr_t)a->h.pBuffPtr)!=normalize(b,(uintptr_t)b->h.pBuffPtr))return 0x600000;
for(uint32_t i=0;i<9;i++)if(CSMBUS_GetCallback(a,i)!=CSMBUS_GetCallback(b,i))return 0x700000+i;
return 0;}
uint32_t CSMBUS_Constant(uint32_t i){switch(i){
case 0:return HAL_SMBUS_ERROR_ACKF;
case 1:return HAL_SMBUS_ERROR_ALERT;
case 2:return HAL_SMBUS_ERROR_ARLO;
case 3:return HAL_SMBUS_ERROR_BERR;
case 4:return HAL_SMBUS_ERROR_BUSTIMEOUT;
case 5:return HAL_SMBUS_ERROR_CB_ID;
case 6:return HAL_SMBUS_ERROR_HALTIMEOUT;
case 7:return HAL_SMBUS_ERROR_INVALID_CALLBACK;
case 8:return HAL_SMBUS_ERROR_INVALID_PARAM;
case 9:return HAL_SMBUS_ERROR_NONE;
case 10:return HAL_SMBUS_ERROR_OVR;
case 11:return HAL_SMBUS_ERROR_PECERR;
case 12:return HAL_SMBUS_LISTEN_COMPLETE_CB_ID;
case 13:return HAL_SMBUS_MASTER_RX_COMPLETE_CB_ID;
case 14:return HAL_SMBUS_MASTER_TX_COMPLETE_CB_ID;
case 15:return HAL_SMBUS_MSPDEINIT_CB_ID;
case 16:return HAL_SMBUS_MSPINIT_CB_ID;
case 17:return HAL_SMBUS_SLAVE_RX_COMPLETE_CB_ID;
case 18:return HAL_SMBUS_SLAVE_TX_COMPLETE_CB_ID;
case 19:return HAL_SMBUS_STATE_BUSY;
case 20:return HAL_SMBUS_STATE_LISTEN;
case 21:return HAL_SMBUS_STATE_MASTER_BUSY_RX;
case 22:return HAL_SMBUS_STATE_MASTER_BUSY_TX;
case 23:return HAL_SMBUS_STATE_READY;
case 24:return HAL_SMBUS_STATE_RESET;
case 25:return HAL_SMBUS_STATE_SLAVE_BUSY_RX;
case 26:return HAL_SMBUS_STATE_SLAVE_BUSY_TX;
case 27:return SMBUS_ADDRESSINGMODE_7BIT;
case 28:return SMBUS_ANALOGFILTER_DISABLE;
case 29:return SMBUS_ANALOGFILTER_ENABLE;
case 30:return SMBUS_AUTOEND_MODE;
case 31:return SMBUS_DUALADDRESS_DISABLE;
case 32:return SMBUS_DUALADDRESS_ENABLE;
case 33:return SMBUS_FASTMODEPLUS_DISABLE;
case 34:return SMBUS_FASTMODEPLUS_ENABLE;
case 35:return SMBUS_FIRST_AND_LAST_FRAME_NO_PEC;
case 36:return SMBUS_FIRST_AND_LAST_FRAME_WITH_PEC;
case 37:return SMBUS_FIRST_FRAME;
case 38:return SMBUS_FIRST_FRAME_WITH_PEC;
case 39:return SMBUS_FLAG_ADDR;
case 40:return SMBUS_FLAG_AF;
case 41:return SMBUS_FLAG_ALERT;
case 42:return SMBUS_FLAG_ARLO;
case 43:return SMBUS_FLAG_BERR;
case 44:return SMBUS_FLAG_BUSY;
case 45:return SMBUS_FLAG_DIR;
case 46:return SMBUS_FLAG_MASK;
case 47:return SMBUS_FLAG_OVR;
case 48:return SMBUS_FLAG_PECERR;
case 49:return SMBUS_FLAG_RXNE;
case 50:return SMBUS_FLAG_STOPF;
case 51:return SMBUS_FLAG_TC;
case 52:return SMBUS_FLAG_TCR;
case 53:return SMBUS_FLAG_TIMEOUT;
case 54:return SMBUS_FLAG_TXE;
case 55:return SMBUS_FLAG_TXIS;
case 56:return SMBUS_GENERALCALL_DISABLE;
case 57:return SMBUS_GENERALCALL_ENABLE;
case 58:return SMBUS_GENERATE_START_READ;
case 59:return SMBUS_GENERATE_START_WRITE;
case 60:return SMBUS_GENERATE_STOP;
case 61:return SMBUS_IT_ADDR;
case 62:return SMBUS_IT_ADDRI;
case 63:return SMBUS_IT_ALERT;
case 64:return SMBUS_IT_ERRI;
case 65:return SMBUS_IT_NACKI;
case 66:return SMBUS_IT_RX;
case 67:return SMBUS_IT_RXI;
case 68:return SMBUS_IT_STOPI;
case 69:return SMBUS_IT_TCI;
case 70:return SMBUS_IT_TX;
case 71:return SMBUS_IT_TXI;
case 72:return SMBUS_LAST_FRAME_NO_PEC;
case 73:return SMBUS_LAST_FRAME_WITH_PEC;
case 74:return SMBUS_NEXT_FRAME;
case 75:return SMBUS_NOSTRETCH_DISABLE;
case 76:return SMBUS_NOSTRETCH_ENABLE;
case 77:return SMBUS_NO_STARTSTOP;
case 78:return SMBUS_OA2_MASK01;
case 79:return SMBUS_OA2_MASK02;
case 80:return SMBUS_OA2_MASK03;
case 81:return SMBUS_OA2_MASK04;
case 82:return SMBUS_OA2_MASK05;
case 83:return SMBUS_OA2_MASK06;
case 84:return SMBUS_OA2_MASK07;
case 85:return SMBUS_OA2_NOMASK;
case 86:return SMBUS_OTHER_AND_LAST_FRAME_NO_PEC;
case 87:return SMBUS_OTHER_AND_LAST_FRAME_WITH_PEC;
case 88:return SMBUS_OTHER_FRAME_NO_PEC;
case 89:return SMBUS_OTHER_FRAME_WITH_PEC;
case 90:return SMBUS_PEC_DISABLE;
case 91:return SMBUS_PEC_ENABLE;
case 92:return SMBUS_PERIPHERAL_MODE_SMBUS_HOST;
case 93:return SMBUS_PERIPHERAL_MODE_SMBUS_SLAVE;
case 94:return SMBUS_PERIPHERAL_MODE_SMBUS_SLAVE_ARP;
case 95:return SMBUS_RELOAD_MODE;
case 96:return SMBUS_SENDPEC_MODE;
case 97:return SMBUS_SOFTEND_MODE;
default:assert(0);return 0;}}
