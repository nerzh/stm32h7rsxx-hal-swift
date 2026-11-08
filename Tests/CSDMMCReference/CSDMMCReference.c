#include "SDMMCInternal.h"
#if defined(__arm__) || defined(__thumb__)
#define CSDMMC_THREAD_LOCAL
#else
#define CSDMMC_THREAD_LOCAL _Thread_local
#endif
static CSDMMC_THREAD_LOCAL SDMMC_TypeDef *activeRegs;
static CSDMMC_THREAD_LOCAL uint32_t *activeControl,*activeResponses,*activeTrace;
static CSDMMC_THREAD_LOCAL void (*commandHook)(void *,uint32_t);
static CSDMMC_THREAD_LOCAL void *commandHookContext;
void CSDMMC_SetCommandHook(void (*hook)(void *,uint32_t),void *context){commandHook=hook;commandHookContext=context;}
void CSDMMC_Bind(SDMMC_TypeDef *r,uint32_t *c,uint32_t *responses,uint32_t *trace){
 activeRegs=r;activeControl=c;activeResponses=responses;activeTrace=trace;commandHook=NULL;commandHookContext=NULL;
}
static void Activate(CSDMMCState *s){CSDMMC_Bind(&s->regs,s->control,&s->responses[0][0],s->commandTrace);}
uint32_t CSDMMC_CoreClock(void){activeControl[1]++;return activeControl[0];}
uint32_t CSDMMC_ClockFor(CSDMMCState *s){Activate(s);return CSDMMC_CoreClock();}
void CSDMMC_FIFOAfterWord(void){
 if(activeControl[8]){
  activeControl[7]++;
  if(activeControl[5]&&--activeControl[5]==0)activeRegs->STA=activeControl[6];
 }
}
uint32_t CSDMMC_ReadVolatile(volatile const uint32_t *p){return *p;}
void CSDMMC_WriteVolatile(volatile uint32_t *p,uint32_t v){
 *p=v;
 if(p==&activeRegs->FIFO)CSDMMC_FIFOAfterWord();
 if(p==&activeRegs->CMD){
  uint32_t i=activeControl[2];
  if(activeControl[12]&&i==1024){i=0;activeControl[13]++;}
  assert(i+4<=1024);
  activeTrace[i++]=activeRegs->ARG;activeTrace[i++]=v;
  activeTrace[i++]=activeRegs->CLKCR;activeTrace[i++]=activeRegs->DCTRL;activeControl[2]=i;
  if(activeControl[4]){
   uint32_t *r=&activeResponses[(v&63)*6];
   activeRegs->STA=r[0];activeRegs->RESPCMD=r[1];
   activeRegs->RESP1=r[2];activeRegs->RESP2=r[3];activeRegs->RESP3=r[4];activeRegs->RESP4=r[5];
   if(commandHook)commandHook(commandHookContext,v);
   if(activeControl[8]&&(r[0]&(0x4000U|0x8000U))){activeControl[5]=(activeRegs->DLEN+(activeControl[14]?3U:0U))/4;activeControl[6]=(r[0]&~(0x4000U|0x8000U|0x1000U))|0x100U;}
  }
 }
}
uint32_t CSDMMC_Read(CSDMMCState *s,uint32_t offset){assert(offset<sizeof(s->regs)&&!(offset&3));Activate(s);uint32_t v=*(uint32_t *)((uint8_t *)&s->regs+offset);if(offset==0x80)CSDMMC_FIFOAfterWord();return v;}
void CSDMMC_Write(CSDMMCState *s,uint32_t offset,uint32_t value){Activate(s);assert(offset<sizeof(s->regs)&&!(offset&3));CSDMMC_WriteVolatile((uint32_t *)((uint8_t *)&s->regs+offset),value);}
size_t CSDMMC_Size(void){return sizeof(CSDMMCState);}
void CSDMMC_Reset(CSDMMCState *s){
 memset(s,0,sizeof(*s));s->control[0]=8000;
 for(uint32_t i=0;i<64;i++){s->responses[i][0]=0x40;s->responses[i][1]=i;}
}
static SDMMC_DMALinkNodeTypeDef *Node(CSDMMCState *s,uint32_t address){
 if(!address)return NULL;
 assert(address>=0x24030100U&&address<0x24030160U&&!((address-0x24030100U)%12));
 return &s->nodes[(address-0x24030100U)/12];
}
static uint32_t NodeAddress(CSDMMCState *s,SDMMC_DMALinkNodeTypeDef *p){if(!p)return 0;assert(p>=s->nodes&&p<s->nodes+8);return 0x24030100U+(uint32_t)((uintptr_t)p-(uintptr_t)s->nodes);}
uint32_t CSDMMC_ReadMemory(CSDMMCState *s,uint32_t a){
 if(a>=0x24030000U&&a<0x2403000CU){switch(a-0x24030000U){case 0:return NodeAddress(s,s->list.pHeadNode);case 4:return NodeAddress(s,s->list.pTailNode);case 8:return s->list.NodesCounter;}}
 assert(a>=0x24030100U&&a<0x24030160U&&!(a&3));return ((uint32_t *)s->nodes)[(a-0x24030100U)/4];
}
void CSDMMC_WriteMemory(CSDMMCState *s,uint32_t a,uint32_t v){
 if(a>=0x24030000U&&a<0x2403000CU){switch(a-0x24030000U){case 0:s->list.pHeadNode=Node(s,v);return;case 4:s->list.pTailNode=Node(s,v);return;case 8:s->list.NodesCounter=v;return;}}
 assert(a>=0x24030100U&&a<0x24030160U&&!(a&3));((uint32_t *)s->nodes)[(a-0x24030100U)/4]=v;
}
uint32_t CSDMMC_Get(CSDMMCState *s,uint32_t g,uint32_t i){switch(g){
case 0:assert(i<sizeof(s->regs)/4);return ((uint32_t *)&s->regs)[i];
case 1:assert(i<16);return s->control[i];
case 2:switch(i){case 0:return s->configuration.ClockEdge;case 1:return s->configuration.ClockPowerSave;case 2:return s->configuration.BusWide;case 3:return s->configuration.HardwareFlowControl;case 4:return s->configuration.ClockDiv;case 5:return s->configuration.TranceiverPresent;}break;
case 3:switch(i){case 0:return s->command.Argument;case 1:return s->command.CmdIndex;case 2:return s->command.Response;case 3:return s->command.WaitForInterrupt;case 4:return s->command.CPSM;}break;
case 4:switch(i){case 0:return s->data.DataTimeOut;case 1:return s->data.DataLength;case 2:return s->data.DataBlockSize;case 3:return s->data.TransferDir;case 4:return s->data.TransferMode;case 5:return s->data.DPSM;}break;
case 5:switch(i){case 0:return s->nodeConfiguration.BufferAddress;case 1:return s->nodeConfiguration.BufferSize;}break;
case 6:assert(i<3);return CSDMMC_ReadMemory(s,0x24030000U+i*4);
case 7:assert(i<24);return ((uint32_t *)s->nodes)[i];
case 8:assert(i==0);return s->output;
case 9:assert(i<384);return ((uint32_t *)s->responses)[i];
case 10:assert(i<1024);return s->commandTrace[i];
}assert(0);return 0;}
void CSDMMC_Set(CSDMMCState *s,uint32_t g,uint32_t i,uint32_t v){switch(g){
case 0:assert(i<sizeof(s->regs)/4);((uint32_t *)&s->regs)[i]=v;return;
case 1:assert(i<16);s->control[i]=v;return;
case 2:switch(i){case 0:s->configuration.ClockEdge=v;return;case 1:s->configuration.ClockPowerSave=v;return;case 2:s->configuration.BusWide=v;return;case 3:s->configuration.HardwareFlowControl=v;return;case 4:s->configuration.ClockDiv=v;return;case 5:s->configuration.TranceiverPresent=v;return;}break;
case 3:switch(i){case 0:s->command.Argument=v;return;case 1:s->command.CmdIndex=v;return;case 2:s->command.Response=v;return;case 3:s->command.WaitForInterrupt=v;return;case 4:s->command.CPSM=v;return;}break;
case 4:switch(i){case 0:s->data.DataTimeOut=v;return;case 1:s->data.DataLength=v;return;case 2:s->data.DataBlockSize=v;return;case 3:s->data.TransferDir=v;return;case 4:s->data.TransferMode=v;return;case 5:s->data.DPSM=v;return;}break;
case 5:switch(i){case 0:s->nodeConfiguration.BufferAddress=v;return;case 1:s->nodeConfiguration.BufferSize=v;return;}break;
case 6:assert(i<3);CSDMMC_WriteMemory(s,0x24030000U+i*4,v);return;
case 7:assert(i<24);((uint32_t *)s->nodes)[i]=v;return;
case 8:assert(i==0);s->output=v;return;
case 9:assert(i<384);((uint32_t *)s->responses)[i]=v;return;
case 10:assert(i<1024);s->commandTrace[i]=v;return;
}assert(0);}
uint32_t CSDMMC_Run(CSDMMCState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){Activate(s);switch(op){
case 0:return SDMMC_Init(&s->regs, s->configuration);
case 1:return SDMMC_ReadFIFO(&s->regs);
case 2:return SDMMC_WriteFIFO(&s->regs, (uint32_t *)&s->output);
case 3:return SDMMC_PowerState_ON(&s->regs);
case 4:return SDMMC_PowerState_Cycle(&s->regs);
case 5:return SDMMC_PowerState_OFF(&s->regs);
case 6:return SDMMC_GetPowerState(&s->regs);
case 7:return SDMMC_SendCommand(&s->regs, &s->command);
case 8:return SDMMC_GetCommandResponse(&s->regs);
case 9:return SDMMC_GetResponse(&s->regs, a);
case 10:return SDMMC_ConfigData(&s->regs, &s->data);
case 11:return SDMMC_GetDataCounter(&s->regs);
case 12:return SDMMC_GetFIFOCount(&s->regs);
case 13:return SDMMC_SetSDMMCReadWaitMode(&s->regs, a);
case 14:return SDMMC_CmdBlockLength(&s->regs, a);
case 15:return SDMMC_CmdBlockCount(&s->regs, a);
case 16:return SDMMC_CmdReadSingleBlock(&s->regs, a);
case 17:return SDMMC_CmdReadMultiBlock(&s->regs, a);
case 18:return SDMMC_CmdWriteSingleBlock(&s->regs, a);
case 19:return SDMMC_CmdWriteMultiBlock(&s->regs, a);
case 20:return SDMMC_CmdSDEraseStartAdd(&s->regs, a);
case 21:return SDMMC_CmdSDEraseEndAdd(&s->regs, a);
case 22:return SDMMC_CmdEraseStartAdd(&s->regs, a);
case 23:return SDMMC_CmdEraseEndAdd(&s->regs, a);
case 24:return SDMMC_CmdErase(&s->regs, a);
case 25:return SDMMC_CmdStopTransfer(&s->regs);
case 26:return SDMMC_CmdSelDesel(&s->regs, a);
case 27:return SDMMC_CmdGoIdleState(&s->regs);
case 28:return SDMMC_CmdOperCond(&s->regs);
case 29:return SDMMC_CmdAppCommand(&s->regs, a);
case 30:return SDMMC_CmdAppOperCommand(&s->regs, a);
case 31:return SDMMC_CmdBusWidth(&s->regs, a);
case 32:return SDMMC_CmdSendSCR(&s->regs);
case 33:return SDMMC_CmdSendCID(&s->regs);
case 34:return SDMMC_CmdSendCSD(&s->regs, a);
case 35:return SDMMC_CmdSetRelAdd(&s->regs, (uint16_t *)&s->output);
case 36:return SDMMC_CmdSetRelAddMmc(&s->regs, a);
case 37:return SDMMC_CmdSleepMmc(&s->regs, a);
case 38:return SDMMC_CmdSendStatus(&s->regs, a);
case 39:return SDMMC_CmdStatusRegister(&s->regs);
case 40:return SDMMC_CmdOpCondition(&s->regs, a);
case 41:return SDMMC_CmdSwitch(&s->regs, a);
case 42:return SDMMC_CmdVoltageSwitch(&s->regs);
case 43:return SDMMC_CmdSendEXTCSD(&s->regs, a);
case 44:return SDMMC_SDIO_CmdReadWriteDirect(&s->regs, a, s->control[15]?NULL:(uint8_t *)&s->output);
case 45:return SDMMC_SDIO_CmdReadWriteExtended(&s->regs, a);
case 46:return SDMMC_CmdSendOperationcondition(&s->regs, a, (uint32_t *)&s->output);
case 47:return SDMMC_GetCmdResp1(&s->regs, a, b);
case 48:return SDMMC_GetCmdResp2(&s->regs);
case 49:return SDMMC_GetCmdResp3(&s->regs);
case 50:return SDMMC_GetCmdResp4(&s->regs, (uint32_t *)&s->output);
case 51:return SDMMC_GetCmdResp5(&s->regs, a, s->control[15]?NULL:(uint8_t *)&s->output);
case 52:return SDMMC_GetCmdResp6(&s->regs, a, (uint16_t *)&s->output);
case 53:return SDMMC_GetCmdResp7(&s->regs);
case 54:return SDMMC_DMALinkedList_BuildNode(Node(s,a), s->control[15]?NULL:&s->nodeConfiguration);
case 55:return SDMMC_DMALinkedList_InsertNode(a?&s->list:NULL, Node(s,b), Node(s,c));
case 56:return SDMMC_DMALinkedList_RemoveNode(a?&s->list:NULL, Node(s,b));
case 57:return SDMMC_DMALinkedList_LockNode(Node(s,a));
case 58:return SDMMC_DMALinkedList_UnlockNode(Node(s,a));
case 59:return SDMMC_DMALinkedList_EnableCircularMode(a?&s->list:NULL);
case 60:return SDMMC_DMALinkedList_DisableCircularMode(a?&s->list:NULL);
case 61:return CSDMMC_GetCmdError(&s->regs);
default:assert(0);return 0;}}
uint32_t CSDMMC_Compare(CSDMMCState *a,CSDMMCState *b){const uint32_t counts[]={sizeof(a->regs)/4,16,6,5,6,2,3,24,1,384,1024};for(uint32_t g=0;g<11;g++)for(uint32_t i=0;i<counts[g];i++)if(CSDMMC_Get(a,g,i)!=CSDMMC_Get(b,g,i))return ((g+1)<<16)|i;return 0;}
uint32_t CSDMMC_Constant(uint32_t i){switch(i){case 0:return CLKCR_CLEAR_MASK;case 1:return CMD_CLEAR_MASK;case 2:return DCTRL_CLEAR_MASK;case 3:return SDMMC_0TO7BITS;case 4:return SDMMC_16TO23BITS;case 5:return SDMMC_24TO31BITS;case 6:return SDMMC_8TO15BITS;case 7:return SDMMC_ALLZERO;case 8:return SDMMC_BUS_WIDE_1B;case 9:return SDMMC_BUS_WIDE_4B;case 10:return SDMMC_BUS_WIDE_8B;case 11:return SDMMC_CARD_LOCKED;case 12:return SDMMC_CCCC_ERASE;case 13:return SDMMC_CHECK_PATTERN;case 14:return SDMMC_CLOCK_EDGE_FALLING;case 15:return SDMMC_CLOCK_EDGE_RISING;case 16:return SDMMC_CLOCK_POWER_SAVE_DISABLE;case 17:return SDMMC_CLOCK_POWER_SAVE_ENABLE;case 18:return SDMMC_CMDTIMEOUT;case 19:return SDMMC_CMD_ALL_SEND_CID;case 20:return SDMMC_CMD_APP_CMD;case 21:return SDMMC_CMD_APP_SD_SET_BUSWIDTH;case 22:return SDMMC_CMD_CLR_WRITE_PROT;case 23:return SDMMC_CMD_ERASE;case 24:return SDMMC_CMD_ERASE_GRP_END;case 25:return SDMMC_CMD_ERASE_GRP_START;case 26:return SDMMC_CMD_FAST_IO;case 27:return SDMMC_CMD_GEN_CMD;case 28:return SDMMC_CMD_GO_IDLE_STATE;case 29:return SDMMC_CMD_GO_INACTIVE_STATE;case 30:return SDMMC_CMD_GO_IRQ_STATE;case 31:return SDMMC_CMD_HS_BUSTEST_READ;case 32:return SDMMC_CMD_HS_BUSTEST_WRITE;case 33:return SDMMC_CMD_HS_SEND_EXT_CSD;case 34:return SDMMC_CMD_HS_SWITCH;case 35:return SDMMC_CMD_LOCK_UNLOCK;case 36:return SDMMC_CMD_MMC_SLEEP_AWAKE;case 37:return SDMMC_CMD_NO_CMD;case 38:return SDMMC_CMD_PROG_CID;case 39:return SDMMC_CMD_PROG_CSD;case 40:return SDMMC_CMD_READ_MULT_BLOCK;case 41:return SDMMC_CMD_READ_SINGLE_BLOCK;case 42:return SDMMC_CMD_SDMMC_RW_DIRECT;case 43:return SDMMC_CMD_SDMMC_RW_EXTENDED;case 44:return SDMMC_CMD_SDMMC_SEN_OP_COND;case 45:return SDMMC_CMD_SD_APP_CHANGE_SECURE_AREA;case 46:return SDMMC_CMD_SD_APP_GET_CER_RES1;case 47:return SDMMC_CMD_SD_APP_GET_CER_RN2;case 48:return SDMMC_CMD_SD_APP_GET_MID;case 49:return SDMMC_CMD_SD_APP_GET_MKB;case 50:return SDMMC_CMD_SD_APP_OP_COND;case 51:return SDMMC_CMD_SD_APP_SECURE_ERASE;case 52:return SDMMC_CMD_SD_APP_SECURE_READ_MULTIPLE_BLOCK;case 53:return SDMMC_CMD_SD_APP_SECURE_WRITE_MKB;case 54:return SDMMC_CMD_SD_APP_SECURE_WRITE_MULTIPLE_BLOCK;case 55:return SDMMC_CMD_SD_APP_SEND_NUM_WRITE_BLOCKS;case 56:return SDMMC_CMD_SD_APP_SEND_SCR;case 57:return SDMMC_CMD_SD_APP_SET_CER_RES2;case 58:return SDMMC_CMD_SD_APP_SET_CER_RN1;case 59:return SDMMC_CMD_SD_APP_SET_CLR_CARD_DETECT;case 60:return SDMMC_CMD_SD_APP_STATUS;case 61:return SDMMC_CMD_SD_ERASE_GRP_END;case 62:return SDMMC_CMD_SD_ERASE_GRP_START;case 63:return SDMMC_CMD_SEL_DESEL_CARD;case 64:return SDMMC_CMD_SEND_CID;case 65:return SDMMC_CMD_SEND_CSD;case 66:return SDMMC_CMD_SEND_OP_COND;case 67:return SDMMC_CMD_SEND_STATUS;case 68:return SDMMC_CMD_SEND_WRITE_PROT;case 69:return SDMMC_CMD_SET_BLOCKLEN;case 70:return SDMMC_CMD_SET_BLOCK_COUNT;case 71:return SDMMC_CMD_SET_DSR;case 72:return SDMMC_CMD_SET_REL_ADDR;case 73:return SDMMC_CMD_SET_WRITE_PROT;case 74:return SDMMC_CMD_STOP_TRANSMISSION;case 75:return SDMMC_CMD_VOLTAGE_SWITCH;case 76:return SDMMC_CMD_WRITE_DAT_UNTIL_STOP;case 77:return SDMMC_CMD_WRITE_MULT_BLOCK;case 78:return SDMMC_CMD_WRITE_SINGLE_BLOCK;case 79:return SDMMC_CPSM_DISABLE;case 80:return SDMMC_CPSM_ENABLE;case 81:return SDMMC_DATABLOCK_SIZE_1024B;case 82:return SDMMC_DATABLOCK_SIZE_128B;case 83:return SDMMC_DATABLOCK_SIZE_16384B;case 84:return SDMMC_DATABLOCK_SIZE_16B;case 85:return SDMMC_DATABLOCK_SIZE_1B;case 86:return SDMMC_DATABLOCK_SIZE_2048B;case 87:return SDMMC_DATABLOCK_SIZE_256B;case 88:return SDMMC_DATABLOCK_SIZE_2B;case 89:return SDMMC_DATABLOCK_SIZE_32B;case 90:return SDMMC_DATABLOCK_SIZE_4096B;case 91:return SDMMC_DATABLOCK_SIZE_4B;case 92:return SDMMC_DATABLOCK_SIZE_512B;case 93:return SDMMC_DATABLOCK_SIZE_64B;case 94:return SDMMC_DATABLOCK_SIZE_8192B;case 95:return SDMMC_DATABLOCK_SIZE_8B;case 96:return SDMMC_DATATIMEOUT;case 97:return SDMMC_DDR50_SWITCH_PATTERN;case 98:return SDMMC_DISABLE_IDMA;case 99:return SDMMC_DPSM_DISABLE;case 100:return SDMMC_DPSM_ENABLE;case 101:return SDMMC_ENABLE_IDMA_DOUBLE_BUFF0;case 102:return SDMMC_ENABLE_IDMA_SINGLE_BUFF;case 103:return SDMMC_ERROR_ADDR_MISALIGNED;case 104:return SDMMC_ERROR_ADDR_OUT_OF_RANGE;case 105:return SDMMC_ERROR_AKE_SEQ_ERR;case 106:return SDMMC_ERROR_BAD_ERASE_PARAM;case 107:return SDMMC_ERROR_BLOCK_LEN_ERR;case 108:return SDMMC_ERROR_BUSY;case 109:return SDMMC_ERROR_CARD_ECC_DISABLED;case 110:return SDMMC_ERROR_CARD_ECC_FAILED;case 111:return SDMMC_ERROR_CC_ERR;case 112:return SDMMC_ERROR_CID_CSD_OVERWRITE;case 113:return SDMMC_ERROR_CMD_CRC_FAIL;case 114:return SDMMC_ERROR_CMD_RSP_TIMEOUT;case 115:return SDMMC_ERROR_COM_CRC_FAILED;case 116:return SDMMC_ERROR_DATA_CRC_FAIL;case 117:return SDMMC_ERROR_DATA_TIMEOUT;case 118:return SDMMC_ERROR_DMA;case 119:return SDMMC_ERROR_ERASE_RESET;case 120:return SDMMC_ERROR_ERASE_SEQ_ERR;case 121:return SDMMC_ERROR_GENERAL_UNKNOWN_ERR;case 122:return SDMMC_ERROR_ILLEGAL_CMD;case 123:return SDMMC_ERROR_INVALID_PARAMETER;case 124:return SDMMC_ERROR_INVALID_VOLTRANGE;case 125:return SDMMC_ERROR_LOCK_UNLOCK_FAILED;case 126:return SDMMC_ERROR_NONE;case 127:return SDMMC_ERROR_REQUEST_NOT_APPLICABLE;case 128:return SDMMC_ERROR_RX_OVERRUN;case 129:return SDMMC_ERROR_STREAM_READ_UNDERRUN;case 130:return SDMMC_ERROR_STREAM_WRITE_OVERRUN;case 131:return SDMMC_ERROR_TIMEOUT;case 132:return SDMMC_ERROR_TX_UNDERRUN;case 133:return SDMMC_ERROR_UNSUPPORTED_FEATURE;case 134:return SDMMC_ERROR_WP_ERASE_SKIP;case 135:return SDMMC_ERROR_WRITE_PROT_VIOLATION;case 136:return SDMMC_FIFO_SIZE;case 137:return SDMMC_FLAG_ACKFAIL;case 138:return SDMMC_FLAG_ACKTIMEOUT;case 139:return SDMMC_FLAG_BUSYD0;case 140:return SDMMC_FLAG_BUSYD0END;case 141:return SDMMC_FLAG_CCRCFAIL;case 142:return SDMMC_FLAG_CKSTOP;case 143:return SDMMC_FLAG_CMDACT;case 144:return SDMMC_FLAG_CMDREND;case 145:return SDMMC_FLAG_CMDSENT;case 146:return SDMMC_FLAG_CTIMEOUT;case 147:return SDMMC_FLAG_DABORT;case 148:return SDMMC_FLAG_DATAEND;case 149:return SDMMC_FLAG_DBCKEND;case 150:return SDMMC_FLAG_DCRCFAIL;case 151:return SDMMC_FLAG_DHOLD;case 152:return SDMMC_FLAG_DPSMACT;case 153:return SDMMC_FLAG_DTIMEOUT;case 154:return SDMMC_FLAG_IDMABTC;case 155:return SDMMC_FLAG_IDMATE;case 156:return SDMMC_FLAG_RXFIFOE;case 157:return SDMMC_FLAG_RXFIFOF;case 158:return SDMMC_FLAG_RXFIFOHF;case 159:return SDMMC_FLAG_RXOVERR;case 160:return SDMMC_FLAG_SDIOIT;case 161:return SDMMC_FLAG_TXFIFOE;case 162:return SDMMC_FLAG_TXFIFOF;case 163:return SDMMC_FLAG_TXFIFOHE;case 164:return SDMMC_FLAG_TXUNDERR;case 165:return SDMMC_FLAG_VSWEND;case 166:return SDMMC_HALFFIFO;case 167:return SDMMC_HALFFIFOBYTES;case 168:return SDMMC_HARDWARE_FLOW_CONTROL_DISABLE;case 169:return SDMMC_HARDWARE_FLOW_CONTROL_ENABLE;case 170:return SDMMC_HIGH_CAPACITY;case 171:return SDMMC_HSPEED_CLK_DIV;case 172:return SDMMC_INIT_CLK_DIV;case 173:return SDMMC_IT_ACKFAIL;case 174:return SDMMC_IT_ACKTIMEOUT;case 175:return SDMMC_IT_BUSYD0END;case 176:return SDMMC_IT_CCRCFAIL;case 177:return SDMMC_IT_CKSTOP;case 178:return SDMMC_IT_CMDREND;case 179:return SDMMC_IT_CMDSENT;case 180:return SDMMC_IT_CTIMEOUT;case 181:return SDMMC_IT_DABORT;case 182:return SDMMC_IT_DATAEND;case 183:return SDMMC_IT_DBCKEND;case 184:return SDMMC_IT_DCRCFAIL;case 185:return SDMMC_IT_DHOLD;case 186:return SDMMC_IT_DTIMEOUT;case 187:return SDMMC_IT_IDMABTC;case 188:return SDMMC_IT_RXFIFOF;case 189:return SDMMC_IT_RXFIFOHF;case 190:return SDMMC_IT_RXOVERR;case 191:return SDMMC_IT_SDIOIT;case 192:return SDMMC_IT_TXFIFOE;case 193:return SDMMC_IT_TXFIFOHE;case 194:return SDMMC_IT_TXUNDERR;case 195:return SDMMC_IT_VSWEND;case 196:return SDMMC_MAXERASETIMEOUT;case 197:return SDMMC_MAX_DATA_LENGTH;case 198:return SDMMC_MAX_TRIAL;case 199:return SDMMC_MAX_VOLT_TRIAL;case 200:return SDMMC_NSPEED_CLK_DIV;case 201:return SDMMC_OCR_ADDR_MISALIGNED;case 202:return SDMMC_OCR_ADDR_OUT_OF_RANGE;case 203:return SDMMC_OCR_AKE_SEQ_ERROR;case 204:return SDMMC_OCR_BAD_ERASE_PARAM;case 205:return SDMMC_OCR_BLOCK_LEN_ERR;case 206:return SDMMC_OCR_CARD_ECC_DISABLED;case 207:return SDMMC_OCR_CARD_ECC_FAILED;case 208:return SDMMC_OCR_CC_ERROR;case 209:return SDMMC_OCR_CID_CSD_OVERWRITE;case 210:return SDMMC_OCR_COM_CRC_FAILED;case 211:return SDMMC_OCR_ERASE_RESET;case 212:return SDMMC_OCR_ERASE_SEQ_ERR;case 213:return SDMMC_OCR_ERRORBITS;case 214:return SDMMC_OCR_GENERAL_UNKNOWN_ERROR;case 215:return SDMMC_OCR_ILLEGAL_CMD;case 216:return SDMMC_OCR_LOCK_UNLOCK_FAILED;case 217:return SDMMC_OCR_STREAM_READ_UNDERRUN;case 218:return SDMMC_OCR_STREAM_WRITE_OVERRUN;case 219:return SDMMC_OCR_WP_ERASE_SKIP;case 220:return SDMMC_OCR_WRITE_PROT_VIOLATION;case 221:return SDMMC_R6_COM_CRC_FAILED;case 222:return SDMMC_R6_GENERAL_UNKNOWN_ERROR;case 223:return SDMMC_R6_ILLEGAL_CMD;case 224:return SDMMC_READ_WAIT_MODE_CLK;case 225:return SDMMC_READ_WAIT_MODE_DATA2;case 226:return SDMMC_RESP1;case 227:return SDMMC_RESP2;case 228:return SDMMC_RESP3;case 229:return SDMMC_RESP4;case 230:return SDMMC_RESPONSE_LONG;case 231:return SDMMC_RESPONSE_NO;case 232:return SDMMC_RESPONSE_SHORT;case 233:return SDMMC_SDIO_AUTO_INC;case 234:return SDMMC_SDIO_CCCR0;case 235:return SDMMC_SDIO_CCCR0_SD_BYTE0;case 236:return SDMMC_SDIO_CCCR0_SD_BYTE1;case 237:return SDMMC_SDIO_CCCR0_SD_BYTE2;case 238:return SDMMC_SDIO_CCCR0_SD_BYTE3;case 239:return SDMMC_SDIO_CCCR12;case 240:return SDMMC_SDIO_CCCR12_SD_BYTE0;case 241:return SDMMC_SDIO_CCCR12_SD_BYTE1;case 242:return SDMMC_SDIO_CCCR12_SD_BYTE2;case 243:return SDMMC_SDIO_CCCR12_SD_BYTE3;case 244:return SDMMC_SDIO_CCCR16;case 245:return SDMMC_SDIO_CCCR16_SD_BYTE0;case 246:return SDMMC_SDIO_CCCR16_SD_BYTE1;case 247:return SDMMC_SDIO_CCCR16_SD_BYTE2;case 248:return SDMMC_SDIO_CCCR16_SD_BYTE3;case 249:return SDMMC_SDIO_CCCR20;case 250:return SDMMC_SDIO_CCCR20_SD_BYTE0;case 251:return SDMMC_SDIO_CCCR20_SD_BYTE1;case 252:return SDMMC_SDIO_CCCR20_SD_BYTE2;case 253:return SDMMC_SDIO_CCCR20_SD_BYTE3;case 254:return SDMMC_SDIO_CCCR4;case 255:return SDMMC_SDIO_CCCR4_SD_BYTE0;case 256:return SDMMC_SDIO_CCCR4_SD_BYTE1;case 257:return SDMMC_SDIO_CCCR4_SD_BYTE2;case 258:return SDMMC_SDIO_CCCR4_SD_BYTE3;case 259:return SDMMC_SDIO_CCCR8;case 260:return SDMMC_SDIO_CCCR8_SD_BYTE0;case 261:return SDMMC_SDIO_CCCR8_SD_BYTE1;case 262:return SDMMC_SDIO_CCCR8_SD_BYTE2;case 263:return SDMMC_SDIO_CCCR8_SD_BYTE3;case 264:return SDMMC_SDIO_F1BR0;case 265:return SDMMC_SDIO_F1BR0_SD_BYTE0;case 266:return SDMMC_SDIO_F1BR0_SD_BYTE1;case 267:return SDMMC_SDIO_F1BR0_SD_BYTE2;case 268:return SDMMC_SDIO_F1BR0_SD_BYTE3;case 269:return SDMMC_SDIO_F1BR12;case 270:return SDMMC_SDIO_F1BR12_SD_BYTE0;case 271:return SDMMC_SDIO_F1BR12_SD_BYTE1;case 272:return SDMMC_SDIO_F1BR12_SD_BYTE2;case 273:return SDMMC_SDIO_F1BR12_SD_BYTE3;case 274:return SDMMC_SDIO_F1BR16;case 275:return SDMMC_SDIO_F1BR16_SD_BYTE0;case 276:return SDMMC_SDIO_F1BR16_SD_BYTE1;case 277:return SDMMC_SDIO_F1BR16_SD_BYTE2;case 278:return SDMMC_SDIO_F1BR16_SD_BYTE3;case 279:return SDMMC_SDIO_F1BR8;case 280:return SDMMC_SDIO_F1BR8_SD_BYTE0;case 281:return SDMMC_SDIO_F1BR8_SD_BYTE1;case 282:return SDMMC_SDIO_F1BR8_SD_BYTE2;case 283:return SDMMC_SDIO_F1BR8_SD_BYTE3;case 284:return SDMMC_SDIO_MODE_BLOCK;case 285:return SDMMC_SDIO_MODE_BYTE;case 286:return SDMMC_SDIO_NO_INC;case 287:return SDMMC_SDIO_R5_COM_CRC_FAILED;case 288:return SDMMC_SDIO_R5_ERROR;case 289:return SDMMC_SDIO_R5_ERRORBITS;case 290:return SDMMC_SDIO_R5_GENERAL_UNKNOWN_ERROR;case 291:return SDMMC_SDIO_R5_ILLEGAL_CMD;case 292:return SDMMC_SDIO_R5_INVALID_FUNCTION_NUMBER;case 293:return SDMMC_SDIO_R5_IO_CURRENT_STATE;case 294:return SDMMC_SDIO_R5_OUT_OF_RANGE;case 295:return SDMMC_SDIO_RAW;case 296:return SDMMC_SDIO_WO;case 297:return SDMMC_SDR104_SWITCH_PATTERN;case 298:return SDMMC_SDR12_SWITCH_PATTERN;case 299:return SDMMC_SDR25_SWITCH_PATTERN;case 300:return SDMMC_SDR50_SWITCH_PATTERN;case 301:return SDMMC_SINGLE_BUS_SUPPORT;case 302:return SDMMC_SPEED_MODE_AUTO;case 303:return SDMMC_SPEED_MODE_DDR;case 304:return SDMMC_SPEED_MODE_DEFAULT;case 305:return SDMMC_SPEED_MODE_HIGH;case 306:return SDMMC_SPEED_MODE_ULTRA;case 307:return SDMMC_SPEED_MODE_ULTRA_SDR104;case 308:return SDMMC_SPEED_MODE_ULTRA_SDR50;case 309:return SDMMC_STATIC_CMD_FLAGS;case 310:return SDMMC_STATIC_DATA_FLAGS;case 311:return SDMMC_STATIC_FLAGS;case 312:return SDMMC_STD_CAPACITY;case 313:return SDMMC_STOPTRANSFERTIMEOUT;case 314:return SDMMC_SWDATATIMEOUT;case 315:return SDMMC_TRANSCEIVER_NOT_PRESENT;case 316:return SDMMC_TRANSCEIVER_PRESENT;case 317:return SDMMC_TRANSCEIVER_UNKNOWN;case 318:return SDMMC_TRANSFER_DIR_TO_CARD;case 319:return SDMMC_TRANSFER_DIR_TO_SDMMC;case 320:return SDMMC_TRANSFER_MODE_BLOCK;case 321:return SDMMC_TRANSFER_MODE_SDIO;case 322:return SDMMC_TRANSFER_MODE_STREAM;case 323:return SDMMC_VOLTAGE_WINDOW_SD;case 324:return SDMMC_WAIT_IT;case 325:return SDMMC_WAIT_NO;case 326:return SDMMC_WAIT_PEND;case 327:return SDMMC_WIDE_BUS_SUPPORT;case 328:return SD_SWITCH_1_8V_CAPACITY;default:assert(0);return 0;}}
