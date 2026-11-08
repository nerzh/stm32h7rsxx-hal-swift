#include "SDIOInternal.h"
CSDIO_THREAD_LOCAL CSDIOState *CSDIO_Active;
size_t CSDIO_Size(void){return sizeof(CSDIOState);}
static void CommandHook(void *context,uint32_t command){
 CSDIOState *s=context;uint32_t arg=s->ll.regs.ARG;
 if(s->control[24]&&(command&0x1000U)&&(command&63U)==52&&((arg>>28)&7)==0){
  uint32_t address=(arg>>9)&0x1FFFFU;
  if(address<2048){
   if(arg&0x80000000U){s->cardMemory[address]=(uint8_t)arg;s->control[27]++;}
   s->ll.regs.RESP1=(s->ll.regs.RESP1&~255U)|s->cardMemory[address];
  }
 }
}
void CSDIO_Activate(CSDIOState *s){CSDIO_Active=s;s->h.Instance=&s->ll.regs;CSDMMC_Bind(s->h.Instance,s->ll.control,&s->ll.responses[0][0],s->ll.commandTrace);CSDMMC_SetCommandHook(CommandHook,s);}
uint32_t CSDIO_ClockFor(CSDIOState *s){CSDIO_Activate(s);return CSDMMC_CoreClock();}
uint32_t CSDIO_TickFor(CSDIOState *s){
 uint32_t result=s->control[2];s->control[2]+=s->control[3];s->control[4]++;
 if(s->control[16]&&s->control[4]==s->control[16])s->h.Instance->STA=s->control[17];
 return result;
}
uint32_t CSDIO_FrequencyFor(CSDIOState *s,uint32_t selection){assert(selection==0x00200000U);s->control[6]++;return s->control[5];}
void CSDIO_DelayFor(CSDIOState *s,uint32_t delay){s->control[7]++;s->control[8]=delay;s->control[2]+=delay;}
uint8_t *CSDIO_Buffer(CSDIOState *s,uint32_t i){assert(i<4);return (uint8_t *)s->buffers[i];}
static uint32_t Normalize(CSDIOState *s,uintptr_t p){
 if(!p)return 0;
 for(uint32_t i=0;i<4;i++){uintptr_t base=(uintptr_t)s->buffers[i];if(p>=base&&p<=base+4096)return 0xABC00000U+i*0x10000U+(uint32_t)(p-base);}
 for(uint32_t i=0;i<4;i++){uint32_t base=(uint32_t)(uintptr_t)s->buffers[i];if((uint32_t)p-base<=4096)return 0xABC00000U+i*0x10000U+((uint32_t)p-base);}
 assert(0);return 0;
}
static uint32_t NormalizeWord(CSDIOState *s,uint32_t p){
 if(!p)return 0;
 for(uint32_t i=0;i<4;i++){uint32_t base=(uint32_t)(uintptr_t)s->buffers[i];if(p-base<=4096)return 0xABC00000U+i*0x10000U+(p-base);}
 for(uint32_t i=0;i<4;i++){uint32_t base=(uint32_t)(uintptr_t)s->buffers[i];int32_t delta=(int32_t)(p-base);if(delta>=-4096&&delta<=4096)return 0xABC00000U+i*0x10000U+(p-base);}
 uint32_t node=(uint32_t)(uintptr_t)s->ll.nodes;if(p-node<96)return 0x24030100U+(p-node);
 return p;
}
uintptr_t CSDIO_GetPointer(CSDIOState *s,uint32_t i){return i?(uintptr_t)s->h.pRxBuffPtr:(uintptr_t)s->h.pTxBuffPtr;}
void CSDIO_SetPointer(CSDIOState *s,uint32_t i,uintptr_t p){if(i)s->h.pRxBuffPtr=(uint8_t *)p;else s->h.pTxBuffPtr=(uint8_t *)p;}
uint32_t CSDIO_Read(CSDIOState *s,uint32_t offset){CSDIO_Activate(s);assert(offset<sizeof(s->ll.regs)&&!(offset&3));if(offset==0x80)return SDMMC_ReadFIFO(&s->ll.regs);return *(uint32_t *)((uint8_t *)&s->ll.regs+offset);}
void CSDIO_Write(CSDIOState *s,uint32_t offset,uint32_t value){CSDIO_Activate(s);assert(offset<sizeof(s->ll.regs)&&!(offset&3));CSDIO_WriteVolatile((uint32_t *)((uint8_t *)&s->ll.regs+offset),value);}
uint32_t CSDIO_ReadMemory(CSDIOState *s,uint32_t a){return CSDMMC_ReadMemory(&s->ll,a);}
void CSDIO_WriteMemory(CSDIOState *s,uint32_t a,uint32_t v){CSDMMC_WriteMemory(&s->ll,a,v);}
uint32_t CSDIO_Get(CSDIOState *s,uint32_t g,uint32_t i){switch(g){
case 0:{assert(i<sizeof(s->ll.regs)/4*2);uint32_t count=sizeof(s->ll.regs)/4;if(i>=count)return ((uint32_t *)&s->unusedRegs)[i-count];uint32_t v=((uint32_t *)&s->ll.regs)[i];return (i==0x58/4||i==0x68/4)?NormalizeWord(s,v):v;}
case 1:switch(i){case 0:return s->h.Init.ClockEdge;case 1:return s->h.Init.ClockPowerSave;case 2:return s->h.Init.BusWide;case 3:return s->h.Init.HardwareFlowControl;case 4:return s->h.Init.ClockDiv;case 5:return s->h.Init.TranceiverPresent;case 6:return s->h.Lock;case 7:return s->h.TxXferSize;case 8:return s->h.RxXferSize;case 9:return s->h.remaining_data;case 10:return NormalizeWord(s,s->h.next_data_addr);case 11:return s->h.next_reg_addr;case 12:return s->h.Context;case 13:return s->h.State;case 14:return s->h.ErrorCode;case 15:return s->h.block_size;case 16:return s->h.IOFunctionMask;case 17:return s->h.IOInterruptNbr;}break;
case 2:assert(i<64);return s->control[i];
case 3:return CSDMMC_Get(&s->ll,1,i);
case 4:return CSDMMC_Get(&s->ll,9,i);
case 5:return CSDMMC_Get(&s->ll,10,i);
case 6:assert(i<16384);return ((uint8_t *)s->buffers)[i];
case 7:return CSDMMC_Get(&s->ll,6,i);
case 8:return CSDMMC_Get(&s->ll,7,i);
case 9:assert(i<1024);return s->callbackTrace[i];
case 10:switch(i){case 0:return s->commonControl.sdio_revision;case 1:return s->commonControl.cccr_revision;case 2:return s->commonControl.sd_spec_revision;case 3:return s->commonControl.bus_width_8Bit;case 4:return s->commonControl.card_capability;case 5:return s->commonControl.commonCISPointer;}break;
case 11:assert(i<35);switch(i%5){case 0:return s->functions[i/5].flags;case 1:return s->functions[i/5].ioStdFunctionCode;case 2:return s->functions[i/5].ioExtFunctionCode;case 3:return s->functions[i/5].ioPointerToCIS;case 4:return s->functions[i/5].ioPointerToCSA;}break;
case 12:switch(i){case 0:return s->directCommand.Reg_Addr;case 1:return s->directCommand.ReadAfterWrite;case 2:return s->directCommand.IOFunctionNbr;}break;
case 13:switch(i){case 0:return s->extendedCommand.Reg_Addr;case 1:return s->extendedCommand.OpCode;case 2:return s->extendedCommand.Block_Mode;case 3:return s->extendedCommand.IOFunctionNbr;}break;
case 14:assert(i<16);return s->output[i];
case 15:assert(i<2048);return s->cardMemory[i];
case 17:assert(i<1024);return s->fifoOutput[i];
case 16:return CSDMMC_Get(&s->ll,5,i);
}assert(0);return 0;}
void CSDIO_Set(CSDIOState *s,uint32_t g,uint32_t i,uint32_t v){switch(g){
case 0:{assert(i<sizeof(s->ll.regs)/4*2);uint32_t count=sizeof(s->ll.regs)/4;if(i>=count)((uint32_t *)&s->unusedRegs)[i-count]=v;else ((uint32_t *)&s->ll.regs)[i]=v;return;}
case 1:switch(i){case 0:s->h.Init.ClockEdge=v;return;case 1:s->h.Init.ClockPowerSave=v;return;case 2:s->h.Init.BusWide=v;return;case 3:s->h.Init.HardwareFlowControl=v;return;case 4:s->h.Init.ClockDiv=v;return;case 5:s->h.Init.TranceiverPresent=v;return;case 6:s->h.Lock=v;return;case 7:s->h.TxXferSize=v;return;case 8:s->h.RxXferSize=v;return;case 9:s->h.remaining_data=v;return;case 10:s->h.next_data_addr=v;return;case 11:s->h.next_reg_addr=v;return;case 12:s->h.Context=v;return;case 13:s->h.State=v;return;case 14:s->h.ErrorCode=v;return;case 15:s->h.block_size=v;return;case 16:s->h.IOFunctionMask=v;return;case 17:s->h.IOInterruptNbr=v;return;}break;
case 2:assert(i<64);s->control[i]=v;return;
case 3:CSDMMC_Set(&s->ll,1,i,v);return;
case 4:CSDMMC_Set(&s->ll,9,i,v);return;
case 5:CSDMMC_Set(&s->ll,10,i,v);return;
case 6:assert(i<16384);((uint8_t *)s->buffers)[i]=v;return;
case 7:CSDMMC_Set(&s->ll,6,i,v);return;
case 8:CSDMMC_Set(&s->ll,7,i,v);return;
case 9:assert(i<1024);s->callbackTrace[i]=v;return;
case 10:switch(i){case 0:s->commonControl.sdio_revision=v;return;case 1:s->commonControl.cccr_revision=v;return;case 2:s->commonControl.sd_spec_revision=v;return;case 3:s->commonControl.bus_width_8Bit=v;return;case 4:s->commonControl.card_capability=v;return;case 5:s->commonControl.commonCISPointer=v;return;}break;
case 11:assert(i<35);switch(i%5){case 0:s->functions[i/5].flags=v;return;case 1:s->functions[i/5].ioStdFunctionCode=v;return;case 2:s->functions[i/5].ioExtFunctionCode=v;return;case 3:s->functions[i/5].ioPointerToCIS=v;return;case 4:s->functions[i/5].ioPointerToCSA=v;return;}break;
case 12:switch(i){case 0:s->directCommand.Reg_Addr=v;return;case 1:s->directCommand.ReadAfterWrite=v;return;case 2:s->directCommand.IOFunctionNbr=v;return;}break;
case 13:switch(i){case 0:s->extendedCommand.Reg_Addr=v;return;case 1:s->extendedCommand.OpCode=v;return;case 2:s->extendedCommand.Block_Mode=v;return;case 3:s->extendedCommand.IOFunctionNbr=v;return;}break;
case 14:assert(i<16);s->output[i]=v;return;
case 15:assert(i<2048);s->cardMemory[i]=v;return;
case 17:assert(i<1024);s->fifoOutput[i]=v;return;
case 16:CSDMMC_Set(&s->ll,5,i,v);return;
}assert(0);}
void CSDIO_Record(CSDIOState *s,uint32_t id,uint32_t custom,uint32_t value){
 uint32_t i=s->control[14];assert(i+12<=1024);
 uint32_t values[]={id,custom,value,s->h.State,s->h.Context,s->h.ErrorCode,s->h.Lock,s->h.TxXferSize,s->h.RxXferSize,s->h.Instance->DCTRL,s->h.Instance->IDMACTRL,s->h.IOFunctionMask};
 for(uint32_t j=0;j<12;j++)s->callbackTrace[i++]=values[j];s->control[14]=i;
 if(s->control[20]==id+1)CSDIO_Set(s,1,s->control[21],s->control[22]);
}
void CSDIO_Default0(SDIO_HandleTypeDef *h){CSDIO_Record((CSDIOState *)h,0,1,0);}
void CSDIO_Custom0(SDIO_HandleTypeDef *h){CSDIO_Record((CSDIOState *)h,0,2,0);}
void CSDIO_Default1(SDIO_HandleTypeDef *h){CSDIO_Record((CSDIOState *)h,1,1,0);}
void CSDIO_Custom1(SDIO_HandleTypeDef *h){CSDIO_Record((CSDIOState *)h,1,2,0);}
void CSDIO_Default2(SDIO_HandleTypeDef *h){CSDIO_Record((CSDIOState *)h,2,1,0);}
void CSDIO_Custom2(SDIO_HandleTypeDef *h){CSDIO_Record((CSDIOState *)h,2,2,0);}
void CSDIO_Default16(SDIO_HandleTypeDef *h){CSDIO_Record((CSDIOState *)h,16,1,0);}
void CSDIO_Custom16(SDIO_HandleTypeDef *h){CSDIO_Record((CSDIOState *)h,16,2,0);}
void CSDIO_Default17(SDIO_HandleTypeDef *h){CSDIO_Record((CSDIOState *)h,17,1,0);}
void CSDIO_Custom17(SDIO_HandleTypeDef *h){CSDIO_Record((CSDIOState *)h,17,2,0);}
void CSDIO_Default18(SDIO_HandleTypeDef *h,FlagStatus status){CSDIO_Record((CSDIOState *)h,18,1,status);}
void CSDIO_Custom18(SDIO_HandleTypeDef *h,FlagStatus status){CSDIO_Record((CSDIOState *)h,18,2,status);}
uintptr_t CSDIO_Callback(uint32_t id,uint32_t custom){if(custom==0)return 0;if(id==18)return custom==1?(uintptr_t)CSDIO_Default18:(uintptr_t)CSDIO_Custom18;if(id==19)return (uintptr_t)CSDIO_IdentifyCustom;if(id>=20&&id<27)return (uintptr_t)CSDIO_FunctionCustom;switch(id){case 0:return custom==1?(uintptr_t)CSDIO_Default0:(uintptr_t)CSDIO_Custom0;case 1:return custom==1?(uintptr_t)CSDIO_Default1:(uintptr_t)CSDIO_Custom1;case 2:return custom==1?(uintptr_t)CSDIO_Default2:(uintptr_t)CSDIO_Custom2;case 16:return custom==1?(uintptr_t)CSDIO_Default16:(uintptr_t)CSDIO_Custom16;case 17:return custom==1?(uintptr_t)CSDIO_Default17:(uintptr_t)CSDIO_Custom17;default:return 0;}}
uintptr_t CSDIO_GetCallback(CSDIOState *s,uint32_t id){if(id==19)return (uintptr_t)s->h.SDIO_IdentifyCard;if(id>=20&&id<27)return (uintptr_t)s->h.SDIO_IOFunction_Callback[id-20];switch(id){case 0:return (uintptr_t)s->h.TxCpltCallback;case 1:return (uintptr_t)s->h.RxCpltCallback;case 2:return (uintptr_t)s->h.ErrorCallback;case 16:return (uintptr_t)s->h.MspInitCallback;case 17:return (uintptr_t)s->h.MspDeInitCallback;case 18:return (uintptr_t)s->h.DriveTransceiver_1_8V_Callback;default:assert(0);return 0;}}
void CSDIO_SetCallback(CSDIOState *s,uint32_t id,uintptr_t v){if(id==19){s->h.SDIO_IdentifyCard=(pSDIO_IdentifyCardCallbackTypeDef)v;return;}if(id>=20&&id<27){s->h.SDIO_IOFunction_Callback[id-20]=(HAL_SDIO_IOFunction_CallbackTypeDef)v;return;}switch(id){case 0:s->h.TxCpltCallback=(pSDIO_CallbackTypeDef)v;return;case 1:s->h.RxCpltCallback=(pSDIO_CallbackTypeDef)v;return;case 2:s->h.ErrorCallback=(pSDIO_CallbackTypeDef)v;return;case 16:s->h.MspInitCallback=(pSDIO_CallbackTypeDef)v;return;case 17:s->h.MspDeInitCallback=(pSDIO_CallbackTypeDef)v;return;case 18:s->h.DriveTransceiver_1_8V_Callback=(pSDIO_TransceiverCallbackTypeDef)v;return;default:assert(0);}}
void CSDIO_Reset(CSDIOState *s,uint32_t variant){
 memset(s,0,sizeof(*s));CSDMMC_Reset(&s->ll);s->control[0]=variant;s->control[1]=1;s->control[3]=1;s->control[5]=64000000;
 for(uint32_t i=0;i<16384;i++)((uint8_t *)s->buffers)[i]=(uint8_t)(i*37+11);
 CSDIO_Activate(s);s->h.pTxBuffPtr=(uint8_t *)s->buffers[0];s->h.pRxBuffPtr=(uint8_t *)s->buffers[1];
CSDIO_SetCallback(s,0,CSDIO_Callback(0,1));
CSDIO_SetCallback(s,1,CSDIO_Callback(1,1));
CSDIO_SetCallback(s,2,CSDIO_Callback(2,1));
CSDIO_SetCallback(s,16,CSDIO_Callback(16,1));
CSDIO_SetCallback(s,17,CSDIO_Callback(17,1));
}
uint32_t CSDIO_Compare(CSDIOState *a,CSDIOState *b){const uint32_t counts[]={66,18,64,16,384,1024,16384,3,24,1024,6,35,3,4,16,2048,2,1024};for(uint32_t g=0;g<18;g++)for(uint32_t i=0;i<counts[g];i++)if(CSDIO_Get(a,g,i)!=CSDIO_Get(b,g,i))return ((g+1)<<16)|i;
for(uint32_t i=0;i<2;i++)if(Normalize(a,CSDIO_GetPointer(a,i))!=Normalize(b,CSDIO_GetPointer(b,i)))return 0x400000|i;
if(CSDIO_GetCallback(a,0)!=CSDIO_GetCallback(b,0))return 0x410000|0;
if(CSDIO_GetCallback(a,1)!=CSDIO_GetCallback(b,1))return 0x410000|1;
if(CSDIO_GetCallback(a,2)!=CSDIO_GetCallback(b,2))return 0x410000|2;
if(CSDIO_GetCallback(a,16)!=CSDIO_GetCallback(b,16))return 0x410000|16;
if(CSDIO_GetCallback(a,17)!=CSDIO_GetCallback(b,17))return 0x410000|17;
for(uint32_t id=18;id<27;id++)if(CSDIO_GetCallback(a,id)!=CSDIO_GetCallback(b,id))return 0x410000|id;return 0;}
uint32_t CSDIO_Constant(uint32_t i){switch(i){case 0:return HAL_SDIOS_DATA_RATE_DDR50;case 1:return HAL_SDIOS_DATA_RATE_SDR12;case 2:return HAL_SDIOS_DATA_RATE_SDR25;case 3:return HAL_SDIOS_DATA_RATE_SDR50;case 4:return HAL_SDIO_1_WIRE_MODE;case 5:return HAL_SDIO_4_WIRES_MODE;case 6:return HAL_SDIO_BUS_WIDTH_8BIT_NOT_SUPPORTED;case 7:return HAL_SDIO_BUS_WIDTH_8BIT_SUPPORTED;case 8:return HAL_SDIO_DATA_BLOCK_SIZE_1024BYTE;case 9:return HAL_SDIO_DATA_BLOCK_SIZE_128BYTE;case 10:return HAL_SDIO_DATA_BLOCK_SIZE_16BYTE;case 11:return HAL_SDIO_DATA_BLOCK_SIZE_1BYTE;case 12:return HAL_SDIO_DATA_BLOCK_SIZE_2048BYTE;case 13:return HAL_SDIO_DATA_BLOCK_SIZE_256BYTE;case 14:return HAL_SDIO_DATA_BLOCK_SIZE_2BYTE;case 15:return HAL_SDIO_DATA_BLOCK_SIZE_32BYTE;case 16:return HAL_SDIO_DATA_BLOCK_SIZE_4BYTE;case 17:return HAL_SDIO_DATA_BLOCK_SIZE_512BYTE;case 18:return HAL_SDIO_DATA_BLOCK_SIZE_64BYTE;case 19:return HAL_SDIO_DATA_BLOCK_SIZE_8BYTE;case 20:return HAL_SDIO_ERROR_CB_ID;case 21:return HAL_SDIO_ERROR_DATA_CRC_FAIL;case 22:return HAL_SDIO_ERROR_DATA_TIMEOUT;case 23:return HAL_SDIO_ERROR_INVALID_CALLBACK;case 24:return HAL_SDIO_ERROR_NONE;case 25:return HAL_SDIO_ERROR_RX_OVERRUN;case 26:return HAL_SDIO_ERROR_TIMEOUT;case 27:return HAL_SDIO_ERROR_TX_UNDERRUN;case 28:return HAL_SDIO_FBR_SUPPORT_CSA;case 29:return HAL_SDIO_FBR_SUPPORT_POWER_SELECTION;case 30:return HAL_SDIO_FUNCTION_0;case 31:return HAL_SDIO_FUNCTION_1;case 32:return HAL_SDIO_FUNCTION_2;case 33:return HAL_SDIO_FUNCTION_3;case 34:return HAL_SDIO_FUNCTION_4;case 35:return HAL_SDIO_FUNCTION_5;case 36:return HAL_SDIO_FUNCTION_6;case 37:return HAL_SDIO_FUNCTION_7;case 38:return HAL_SDIO_MODE_BLOCK;case 39:return HAL_SDIO_MODE_BYTE;case 40:return HAL_SDIO_MSP_DEINIT_CB_ID;case 41:return HAL_SDIO_MSP_INIT_CB_ID;case 42:return HAL_SDIO_OP_CODE_AUTO_INC;case 43:return HAL_SDIO_OP_CODE_NO_INC;case 44:return HAL_SDIO_READ_AFTER_WRITE;case 45:return HAL_SDIO_RX_CPLT_CB_ID;case 46:return HAL_SDIO_STATE_BUSY;case 47:return HAL_SDIO_STATE_READY;case 48:return HAL_SDIO_STATE_RESET;case 49:return HAL_SDIO_TX_CPLT_CB_ID;case 50:return HAL_SDIO_WRITE_ONLY;case 51:return SDIO_CONTEXT_DMA;case 52:return SDIO_CONTEXT_IT;case 53:return SDIO_CONTEXT_NONE;case 54:return SDIO_CONTEXT_READ_MULTIPLE_BLOCK;case 55:return SDIO_CONTEXT_READ_SINGLE_BLOCK;case 56:return SDIO_CONTEXT_WRITE_MULTIPLE_BLOCK;case 57:return SDIO_CONTEXT_WRITE_SINGLE_BLOCK;case 58:return SDIO_MAX_IO_NUMBER;default:assert(0);return 0;}}
uint32_t CSDIO0_Run(CSDIOState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSDIO1_Run(CSDIOState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSDIO2_Run(CSDIOState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSDIO3_Run(CSDIOState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSDIO_Run(CSDIOState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CSDIO_Activate(s);switch(s->control[0]){case 0:return CSDIO0_Run(s,op,a,b,c);case 1:return CSDIO1_Run(s,op,a,b,c);case 2:return CSDIO2_Run(s,op,a,b,c);case 3:return CSDIO3_Run(s,op,a,b,c);default:assert(0);return 0;}}

uint32_t CSDIO_GetHandleRaw(CSDIOState *s,uint32_t i){return i==10?s->h.next_data_addr:CSDIO_Get(s,1,i);}
void CSDIO_WriteVolatile(volatile uint32_t *p,uint32_t v){
 CSDIOState *s=CSDIO_Active;
 if(p==&s->ll.regs.FIFO&&s->control[25]){uint32_t index=s->control[26]++;assert(index<1024);s->fifoOutput[index]=v;}
 CSDMMC_WriteVolatile(p,v);
}
HAL_StatusTypeDef CSDIO_IdentifyCustom(SDIO_HandleTypeDef *h){
 CSDIOState *s=(CSDIOState *)h;CSDIO_Record(s,19,2,s->control[30]);return (HAL_StatusTypeDef)s->control[30];
}
void CSDIO_FunctionCustom(SDIO_HandleTypeDef *h,uint32_t index){CSDIO_Record((CSDIOState *)h,20,2,index);}
uintptr_t CSDIO0_DefaultIdentify(void);
uintptr_t CSDIO1_DefaultIdentify(void);
uintptr_t CSDIO2_DefaultIdentify(void);
uintptr_t CSDIO3_DefaultIdentify(void);
uintptr_t CSDIO_DefaultIdentify(uint32_t variant){switch(variant){case 0:return CSDIO0_DefaultIdentify();case 1:return CSDIO1_DefaultIdentify();case 2:return CSDIO2_DefaultIdentify();case 3:return CSDIO3_DefaultIdentify();default:assert(0);return 0;}}
