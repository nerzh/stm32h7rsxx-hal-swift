#include "SDInternal.h"
CSD_THREAD_LOCAL CSDState *CSD_Active;
size_t CSD_Size(void){return sizeof(CSDState);}
void CSD_Activate(CSDState *s){CSD_Active=s;s->h.Instance=&s->ll.regs;CSDMMC_Bind(s->h.Instance,s->ll.control,&s->ll.responses[0][0],s->ll.commandTrace);}
uint32_t CSD_ClockFor(CSDState *s){CSD_Activate(s);return CSDMMC_CoreClock();}
uint32_t CSD_TickFor(CSDState *s){
 uint32_t result=s->control[2];s->control[2]+=s->control[3];s->control[4]++;
 if(s->control[16]&&s->control[4]==s->control[16])s->h.Instance->STA=s->control[17];
 return result;
}
uint32_t CSD_FrequencyFor(CSDState *s,uint32_t selection){assert(selection==0x00200000U);s->control[6]++;return s->control[5];}
void CSD_DelayFor(CSDState *s,uint32_t delay){s->control[7]++;s->control[8]=delay;s->control[2]+=delay;}
uint8_t *CSD_Buffer(CSDState *s,uint32_t i){assert(i<2);return (uint8_t *)s->buffers[i];}
static uint32_t Normalize(CSDState *s,uintptr_t p){
 if(!p)return 0;
 for(uint32_t i=0;i<2;i++){uintptr_t base=(uintptr_t)s->buffers[i];if(p>=base&&p<=base+4096)return 0xABC00000U+i*0x10000U+(uint32_t)(p-base);}
 assert(0);return 0;
}
static uint32_t NormalizeWord(CSDState *s,uint32_t p){
 for(uint32_t i=0;i<2;i++){uint32_t base=(uint32_t)(uintptr_t)s->buffers[i];if(p-base<=4096)return 0xABC00000U+i*0x10000U+(p-base);}
 uint32_t node=(uint32_t)(uintptr_t)s->ll.nodes;if(p-node<96)return 0x24030100U+(p-node);
 return p;
}
uintptr_t CSD_GetPointer(CSDState *s,uint32_t i){return i?(uintptr_t)s->h.pRxBuffPtr:(uintptr_t)s->h.pTxBuffPtr;}
void CSD_SetPointer(CSDState *s,uint32_t i,uintptr_t p){if(i)s->h.pRxBuffPtr=(uint8_t *)p;else s->h.pTxBuffPtr=(uint8_t *)p;}
uint32_t CSD_Read(CSDState *s,uint32_t offset){CSD_Activate(s);return CSDMMC_Read(&s->ll,offset);}
void CSD_Write(CSDState *s,uint32_t offset,uint32_t value){CSD_Activate(s);CSDMMC_Write(&s->ll,offset,value);}
uint32_t CSD_ReadMemory(CSDState *s,uint32_t a){return CSDMMC_ReadMemory(&s->ll,a);}
void CSD_WriteMemory(CSDState *s,uint32_t a,uint32_t v){CSDMMC_WriteMemory(&s->ll,a,v);}
uint32_t CSD_Get(CSDState *s,uint32_t g,uint32_t i){switch(g){
case 0:{assert(i<sizeof(s->ll.regs)/4*2);uint32_t count=sizeof(s->ll.regs)/4;if(i>=count)return ((uint32_t *)&s->unusedRegs)[i-count];uint32_t v=((uint32_t *)&s->ll.regs)[i];return (i==0x58/4||i==0x68/4)?NormalizeWord(s,v):v;}
case 1:switch(i){case 0:return s->h.Init.ClockEdge;case 1:return s->h.Init.ClockPowerSave;case 2:return s->h.Init.BusWide;case 3:return s->h.Init.HardwareFlowControl;case 4:return s->h.Init.ClockDiv;case 5:return s->h.Init.TranceiverPresent;case 6:return s->h.Lock;case 7:return s->h.TxXferSize;case 8:return s->h.RxXferSize;case 9:return s->h.Context;case 10:return s->h.State;case 11:return s->h.ErrorCode;case 12:return s->h.SdCard.CardType;case 13:return s->h.SdCard.CardVersion;case 14:return s->h.SdCard.Class;case 15:return s->h.SdCard.RelCardAdd;case 16:return s->h.SdCard.BlockNbr;case 17:return s->h.SdCard.BlockSize;case 18:return s->h.SdCard.LogBlockNbr;case 19:return s->h.SdCard.LogBlockSize;case 20:return s->h.SdCard.CardSpeed;case 21:return s->h.CSD[0];case 22:return s->h.CSD[1];case 23:return s->h.CSD[2];case 24:return s->h.CSD[3];case 25:return s->h.CID[0];case 26:return s->h.CID[1];case 27:return s->h.CID[2];case 28:return s->h.CID[3];}break;
case 2:assert(i<64);return s->control[i];
case 3:return CSDMMC_Get(&s->ll,1,i);
case 4:return CSDMMC_Get(&s->ll,9,i);
case 5:return CSDMMC_Get(&s->ll,10,i);
case 6:assert(i<8192);return ((uint8_t *)s->buffers)[i];
case 7:return CSDMMC_Get(&s->ll,6,i);
case 8:return CSDMMC_Get(&s->ll,7,i);
case 9:assert(i<1024);return s->callbackTrace[i];
case 10:switch(i){case 0:return s->cardInfo.CardType;case 1:return s->cardInfo.CardVersion;case 2:return s->cardInfo.Class;case 3:return s->cardInfo.RelCardAdd;case 4:return s->cardInfo.BlockNbr;case 5:return s->cardInfo.BlockSize;case 6:return s->cardInfo.LogBlockNbr;case 7:return s->cardInfo.LogBlockSize;case 8:return s->cardInfo.CardSpeed;}break;
case 11:switch(i){case 0:return s->cardCSD.CSDStruct;case 1:return s->cardCSD.SysSpecVersion;case 2:return s->cardCSD.Reserved1;case 3:return s->cardCSD.TAAC;case 4:return s->cardCSD.NSAC;case 5:return s->cardCSD.MaxBusClkFrec;case 6:return s->cardCSD.CardComdClasses;case 7:return s->cardCSD.RdBlockLen;case 8:return s->cardCSD.PartBlockRead;case 9:return s->cardCSD.WrBlockMisalign;case 10:return s->cardCSD.RdBlockMisalign;case 11:return s->cardCSD.DSRImpl;case 12:return s->cardCSD.Reserved2;case 13:return s->cardCSD.DeviceSize;case 14:return s->cardCSD.MaxRdCurrentVDDMin;case 15:return s->cardCSD.MaxRdCurrentVDDMax;case 16:return s->cardCSD.MaxWrCurrentVDDMin;case 17:return s->cardCSD.MaxWrCurrentVDDMax;case 18:return s->cardCSD.DeviceSizeMul;case 19:return s->cardCSD.EraseGrSize;case 20:return s->cardCSD.EraseGrMul;case 21:return s->cardCSD.WrProtectGrSize;case 22:return s->cardCSD.WrProtectGrEnable;case 23:return s->cardCSD.ManDeflECC;case 24:return s->cardCSD.WrSpeedFact;case 25:return s->cardCSD.MaxWrBlockLen;case 26:return s->cardCSD.WriteBlockPaPartial;case 27:return s->cardCSD.Reserved3;case 28:return s->cardCSD.ContentProtectAppli;case 29:return s->cardCSD.FileFormatGroup;case 30:return s->cardCSD.CopyFlag;case 31:return s->cardCSD.PermWrProtect;case 32:return s->cardCSD.TempWrProtect;case 33:return s->cardCSD.FileFormat;case 34:return s->cardCSD.ECC;case 35:return s->cardCSD.CSD_CRC;case 36:return s->cardCSD.Reserved4;}break;
case 12:switch(i){case 0:return s->cardCID.ManufacturerID;case 1:return s->cardCID.OEM_AppliID;case 2:return s->cardCID.ProdName1;case 3:return s->cardCID.ProdName2;case 4:return s->cardCID.ProdRev;case 5:return s->cardCID.ProdSN;case 6:return s->cardCID.Reserved1;case 7:return s->cardCID.ManufactDate;case 8:return s->cardCID.CID_CRC;case 9:return s->cardCID.Reserved2;}break;
case 13:switch(i){case 0:return s->cardStatus.DataBusWidth;case 1:return s->cardStatus.SecuredMode;case 2:return s->cardStatus.CardType;case 3:return s->cardStatus.ProtectedAreaSize;case 4:return s->cardStatus.SpeedClass;case 5:return s->cardStatus.PerformanceMove;case 6:return s->cardStatus.AllocationUnitSize;case 7:return s->cardStatus.EraseSize;case 8:return s->cardStatus.EraseTimeout;case 9:return s->cardStatus.EraseOffset;case 10:return s->cardStatus.UhsSpeedGrade;case 11:return s->cardStatus.UhsAllocationUnitSize;case 12:return s->cardStatus.VideoSpeedClass;}break;
case 14:assert(i<16);return s->output[i];
case 15:assert(i<4);return ((uint32_t *)s->delay)[i];
case 16:return CSDMMC_Get(&s->ll,5,i);
}assert(0);return 0;}
void CSD_Set(CSDState *s,uint32_t g,uint32_t i,uint32_t v){switch(g){
case 0:{assert(i<sizeof(s->ll.regs)/4*2);uint32_t count=sizeof(s->ll.regs)/4;if(i>=count)((uint32_t *)&s->unusedRegs)[i-count]=v;else ((uint32_t *)&s->ll.regs)[i]=v;return;}
case 1:switch(i){case 0:s->h.Init.ClockEdge=v;return;case 1:s->h.Init.ClockPowerSave=v;return;case 2:s->h.Init.BusWide=v;return;case 3:s->h.Init.HardwareFlowControl=v;return;case 4:s->h.Init.ClockDiv=v;return;case 5:s->h.Init.TranceiverPresent=v;return;case 6:s->h.Lock=v;return;case 7:s->h.TxXferSize=v;return;case 8:s->h.RxXferSize=v;return;case 9:s->h.Context=v;return;case 10:s->h.State=v;return;case 11:s->h.ErrorCode=v;return;case 12:s->h.SdCard.CardType=v;return;case 13:s->h.SdCard.CardVersion=v;return;case 14:s->h.SdCard.Class=v;return;case 15:s->h.SdCard.RelCardAdd=v;return;case 16:s->h.SdCard.BlockNbr=v;return;case 17:s->h.SdCard.BlockSize=v;return;case 18:s->h.SdCard.LogBlockNbr=v;return;case 19:s->h.SdCard.LogBlockSize=v;return;case 20:s->h.SdCard.CardSpeed=v;return;case 21:s->h.CSD[0]=v;return;case 22:s->h.CSD[1]=v;return;case 23:s->h.CSD[2]=v;return;case 24:s->h.CSD[3]=v;return;case 25:s->h.CID[0]=v;return;case 26:s->h.CID[1]=v;return;case 27:s->h.CID[2]=v;return;case 28:s->h.CID[3]=v;return;}break;
case 2:assert(i<64);s->control[i]=v;return;
case 3:CSDMMC_Set(&s->ll,1,i,v);return;
case 4:CSDMMC_Set(&s->ll,9,i,v);return;
case 5:CSDMMC_Set(&s->ll,10,i,v);return;
case 6:assert(i<8192);((uint8_t *)s->buffers)[i]=v;return;
case 7:CSDMMC_Set(&s->ll,6,i,v);return;
case 8:CSDMMC_Set(&s->ll,7,i,v);return;
case 9:assert(i<1024);s->callbackTrace[i]=v;return;
case 10:switch(i){case 0:s->cardInfo.CardType=v;return;case 1:s->cardInfo.CardVersion=v;return;case 2:s->cardInfo.Class=v;return;case 3:s->cardInfo.RelCardAdd=v;return;case 4:s->cardInfo.BlockNbr=v;return;case 5:s->cardInfo.BlockSize=v;return;case 6:s->cardInfo.LogBlockNbr=v;return;case 7:s->cardInfo.LogBlockSize=v;return;case 8:s->cardInfo.CardSpeed=v;return;}break;
case 11:switch(i){case 0:s->cardCSD.CSDStruct=v;return;case 1:s->cardCSD.SysSpecVersion=v;return;case 2:s->cardCSD.Reserved1=v;return;case 3:s->cardCSD.TAAC=v;return;case 4:s->cardCSD.NSAC=v;return;case 5:s->cardCSD.MaxBusClkFrec=v;return;case 6:s->cardCSD.CardComdClasses=v;return;case 7:s->cardCSD.RdBlockLen=v;return;case 8:s->cardCSD.PartBlockRead=v;return;case 9:s->cardCSD.WrBlockMisalign=v;return;case 10:s->cardCSD.RdBlockMisalign=v;return;case 11:s->cardCSD.DSRImpl=v;return;case 12:s->cardCSD.Reserved2=v;return;case 13:s->cardCSD.DeviceSize=v;return;case 14:s->cardCSD.MaxRdCurrentVDDMin=v;return;case 15:s->cardCSD.MaxRdCurrentVDDMax=v;return;case 16:s->cardCSD.MaxWrCurrentVDDMin=v;return;case 17:s->cardCSD.MaxWrCurrentVDDMax=v;return;case 18:s->cardCSD.DeviceSizeMul=v;return;case 19:s->cardCSD.EraseGrSize=v;return;case 20:s->cardCSD.EraseGrMul=v;return;case 21:s->cardCSD.WrProtectGrSize=v;return;case 22:s->cardCSD.WrProtectGrEnable=v;return;case 23:s->cardCSD.ManDeflECC=v;return;case 24:s->cardCSD.WrSpeedFact=v;return;case 25:s->cardCSD.MaxWrBlockLen=v;return;case 26:s->cardCSD.WriteBlockPaPartial=v;return;case 27:s->cardCSD.Reserved3=v;return;case 28:s->cardCSD.ContentProtectAppli=v;return;case 29:s->cardCSD.FileFormatGroup=v;return;case 30:s->cardCSD.CopyFlag=v;return;case 31:s->cardCSD.PermWrProtect=v;return;case 32:s->cardCSD.TempWrProtect=v;return;case 33:s->cardCSD.FileFormat=v;return;case 34:s->cardCSD.ECC=v;return;case 35:s->cardCSD.CSD_CRC=v;return;case 36:s->cardCSD.Reserved4=v;return;}break;
case 12:switch(i){case 0:s->cardCID.ManufacturerID=v;return;case 1:s->cardCID.OEM_AppliID=v;return;case 2:s->cardCID.ProdName1=v;return;case 3:s->cardCID.ProdName2=v;return;case 4:s->cardCID.ProdRev=v;return;case 5:s->cardCID.ProdSN=v;return;case 6:s->cardCID.Reserved1=v;return;case 7:s->cardCID.ManufactDate=v;return;case 8:s->cardCID.CID_CRC=v;return;case 9:s->cardCID.Reserved2=v;return;}break;
case 13:switch(i){case 0:s->cardStatus.DataBusWidth=v;return;case 1:s->cardStatus.SecuredMode=v;return;case 2:s->cardStatus.CardType=v;return;case 3:s->cardStatus.ProtectedAreaSize=v;return;case 4:s->cardStatus.SpeedClass=v;return;case 5:s->cardStatus.PerformanceMove=v;return;case 6:s->cardStatus.AllocationUnitSize=v;return;case 7:s->cardStatus.EraseSize=v;return;case 8:s->cardStatus.EraseTimeout=v;return;case 9:s->cardStatus.EraseOffset=v;return;case 10:s->cardStatus.UhsSpeedGrade=v;return;case 11:s->cardStatus.UhsAllocationUnitSize=v;return;case 12:s->cardStatus.VideoSpeedClass=v;return;}break;
case 14:assert(i<16);s->output[i]=v;return;
case 15:assert(i<4);((uint32_t *)s->delay)[i]=v;return;
case 16:CSDMMC_Set(&s->ll,5,i,v);return;
}assert(0);}
void CSD_Record(CSDState *s,uint32_t id,uint32_t custom,uint32_t value){
 uint32_t i=s->control[14];assert(i+12<=1024);
 uint32_t values[]={id,custom,value,s->h.State,s->h.Context,s->h.ErrorCode,s->h.Lock,s->h.TxXferSize,s->h.RxXferSize,s->h.Instance->DCTRL,s->h.Instance->IDMACTRL,s->h.SdCard.CardSpeed};
 for(uint32_t j=0;j<12;j++)s->callbackTrace[i++]=values[j];s->control[14]=i;
 if(s->control[20]==id+1)CSD_Set(s,1,s->control[21],s->control[22]);
 if(id==18&&value==1&&s->control[24])s->h.Instance->STA=s->control[25];
}
void CSD_Default0(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,0,1,0);}
void CSD_Custom0(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,0,2,0);}
void CSD_Default1(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,1,1,0);}
void CSD_Custom1(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,1,2,0);}
void CSD_Default2(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,2,1,0);}
void CSD_Custom2(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,2,2,0);}
void CSD_Default3(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,3,1,0);}
void CSD_Custom3(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,3,2,0);}
void CSD_Default4(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,4,1,0);}
void CSD_Custom4(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,4,2,0);}
void CSD_Default5(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,5,1,0);}
void CSD_Custom5(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,5,2,0);}
void CSD_Default16(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,16,1,0);}
void CSD_Custom16(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,16,2,0);}
void CSD_Default17(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,17,1,0);}
void CSD_Custom17(SD_HandleTypeDef *h){CSD_Record((CSDState *)h,17,2,0);}
void CSD_Default18(FlagStatus status){CSD_Record(CSD_Active,18,1,status);}
void CSD_Custom18(FlagStatus status){CSD_Record(CSD_Active,18,2,status);}
uintptr_t CSD_Callback(uint32_t id,uint32_t custom){if(custom==0)return 0;switch(id){case 0:return custom==1?(uintptr_t)CSD_Default0:(uintptr_t)CSD_Custom0;case 1:return custom==1?(uintptr_t)CSD_Default1:(uintptr_t)CSD_Custom1;case 2:return custom==1?(uintptr_t)CSD_Default2:(uintptr_t)CSD_Custom2;case 3:return custom==1?(uintptr_t)CSD_Default3:(uintptr_t)CSD_Custom3;case 4:return custom==1?(uintptr_t)CSD_Default4:(uintptr_t)CSD_Custom4;case 5:return custom==1?(uintptr_t)CSD_Default5:(uintptr_t)CSD_Custom5;case 16:return custom==1?(uintptr_t)CSD_Default16:(uintptr_t)CSD_Custom16;case 17:return custom==1?(uintptr_t)CSD_Default17:(uintptr_t)CSD_Custom17;case 18:return custom==1?(uintptr_t)CSD_Default18:(uintptr_t)CSD_Custom18;default:return 0;}}
uintptr_t CSD_GetCallback(CSDState *s,uint32_t id){switch(id){case 0:return (uintptr_t)s->h.TxCpltCallback;case 1:return (uintptr_t)s->h.RxCpltCallback;case 2:return (uintptr_t)s->h.ErrorCallback;case 3:return (uintptr_t)s->h.AbortCpltCallback;case 4:return (uintptr_t)s->h.Read_DMALnkLstBufCpltCallback;case 5:return (uintptr_t)s->h.Write_DMALnkLstBufCpltCallback;case 16:return (uintptr_t)s->h.MspInitCallback;case 17:return (uintptr_t)s->h.MspDeInitCallback;case 18:return (uintptr_t)s->h.DriveTransceiver_1_8V_Callback;default:assert(0);return 0;}}
void CSD_SetCallback(CSDState *s,uint32_t id,uintptr_t v){switch(id){case 0:s->h.TxCpltCallback=(pSD_CallbackTypeDef)v;return;case 1:s->h.RxCpltCallback=(pSD_CallbackTypeDef)v;return;case 2:s->h.ErrorCallback=(pSD_CallbackTypeDef)v;return;case 3:s->h.AbortCpltCallback=(pSD_CallbackTypeDef)v;return;case 4:s->h.Read_DMALnkLstBufCpltCallback=(pSD_CallbackTypeDef)v;return;case 5:s->h.Write_DMALnkLstBufCpltCallback=(pSD_CallbackTypeDef)v;return;case 16:s->h.MspInitCallback=(pSD_CallbackTypeDef)v;return;case 17:s->h.MspDeInitCallback=(pSD_CallbackTypeDef)v;return;case 18:s->h.DriveTransceiver_1_8V_Callback=(pSD_TransceiverCallbackTypeDef)v;return;default:assert(0);}}
void CSD_Reset(CSDState *s,uint32_t variant){
 memset(s,0,sizeof(*s));CSDMMC_Reset(&s->ll);s->control[0]=variant;s->control[1]=1;s->control[3]=1;s->control[5]=64000000;
 for(uint32_t i=0;i<8192;i++)((uint8_t *)s->buffers)[i]=(uint8_t)(i*37+11);
 CSD_Activate(s);s->h.pTxBuffPtr=(uint8_t *)s->buffers[0];s->h.pRxBuffPtr=(uint8_t *)s->buffers[1];
CSD_SetCallback(s,0,CSD_Callback(0,1));
CSD_SetCallback(s,1,CSD_Callback(1,1));
CSD_SetCallback(s,2,CSD_Callback(2,1));
CSD_SetCallback(s,3,CSD_Callback(3,1));
CSD_SetCallback(s,4,CSD_Callback(4,1));
CSD_SetCallback(s,5,CSD_Callback(5,1));
CSD_SetCallback(s,16,CSD_Callback(16,1));
CSD_SetCallback(s,17,CSD_Callback(17,1));
CSD_SetCallback(s,18,CSD_Callback(18,1));
}
uint32_t CSD_Compare(CSDState *a,CSDState *b){const uint32_t counts[]={66,29,64,16,384,1024,8192,3,24,1024,9,37,10,13,16,4,2};for(uint32_t g=0;g<17;g++)for(uint32_t i=0;i<counts[g];i++)if(CSD_Get(a,g,i)!=CSD_Get(b,g,i))return ((g+1)<<16)|i;
for(uint32_t i=0;i<2;i++)if(Normalize(a,CSD_GetPointer(a,i))!=Normalize(b,CSD_GetPointer(b,i)))return 0x400000|i;
if(CSD_GetCallback(a,0)!=CSD_GetCallback(b,0))return 0x410000|0;
if(CSD_GetCallback(a,1)!=CSD_GetCallback(b,1))return 0x410000|1;
if(CSD_GetCallback(a,2)!=CSD_GetCallback(b,2))return 0x410000|2;
if(CSD_GetCallback(a,3)!=CSD_GetCallback(b,3))return 0x410000|3;
if(CSD_GetCallback(a,4)!=CSD_GetCallback(b,4))return 0x410000|4;
if(CSD_GetCallback(a,5)!=CSD_GetCallback(b,5))return 0x410000|5;
if(CSD_GetCallback(a,16)!=CSD_GetCallback(b,16))return 0x410000|16;
if(CSD_GetCallback(a,17)!=CSD_GetCallback(b,17))return 0x410000|17;
if(CSD_GetCallback(a,18)!=CSD_GetCallback(b,18))return 0x410000|18;
return 0;}
uint32_t CSD_Constant(uint32_t i){switch(i){case 0:return BLOCKSIZE;case 1:return CARD_HIGH_SPEED;case 2:return CARD_NORMAL_SPEED;case 3:return CARD_SDHC_SDXC;case 4:return CARD_SDSC;case 5:return CARD_SECURED;case 6:return CARD_ULTRA_HIGH_SPEED;case 7:return CARD_V1_X;case 8:return CARD_V2_X;case 9:return HAL_SD_ABORT_CB_ID;case 10:return HAL_SD_CARD_DISCONNECTED;case 11:return HAL_SD_CARD_ERROR;case 12:return HAL_SD_CARD_IDENTIFICATION;case 13:return HAL_SD_CARD_PROGRAMMING;case 14:return HAL_SD_CARD_READY;case 15:return HAL_SD_CARD_RECEIVING;case 16:return HAL_SD_CARD_SENDING;case 17:return HAL_SD_CARD_STANDBY;case 18:return HAL_SD_CARD_TRANSFER;case 19:return HAL_SD_ERROR_ADDR_MISALIGNED;case 20:return HAL_SD_ERROR_ADDR_OUT_OF_RANGE;case 21:return HAL_SD_ERROR_AKE_SEQ_ERR;case 22:return HAL_SD_ERROR_BAD_ERASE_PARAM;case 23:return HAL_SD_ERROR_BLOCK_LEN_ERR;case 24:return HAL_SD_ERROR_BUSY;case 25:return HAL_SD_ERROR_CARD_ECC_DISABLED;case 26:return HAL_SD_ERROR_CARD_ECC_FAILED;case 27:return HAL_SD_ERROR_CB_ID;case 28:return HAL_SD_ERROR_CC_ERR;case 29:return HAL_SD_ERROR_CID_CSD_OVERWRITE;case 30:return HAL_SD_ERROR_CMD_CRC_FAIL;case 31:return HAL_SD_ERROR_CMD_RSP_TIMEOUT;case 32:return HAL_SD_ERROR_COM_CRC_FAILED;case 33:return HAL_SD_ERROR_DATA_CRC_FAIL;case 34:return HAL_SD_ERROR_DATA_TIMEOUT;case 35:return HAL_SD_ERROR_DMA;case 36:return HAL_SD_ERROR_ERASE_RESET;case 37:return HAL_SD_ERROR_ERASE_SEQ_ERR;case 38:return HAL_SD_ERROR_GENERAL_UNKNOWN_ERR;case 39:return HAL_SD_ERROR_ILLEGAL_CMD;case 40:return HAL_SD_ERROR_INVALID_CALLBACK;case 41:return HAL_SD_ERROR_INVALID_VOLTRANGE;case 42:return HAL_SD_ERROR_LOCK_UNLOCK_FAILED;case 43:return HAL_SD_ERROR_NONE;case 44:return HAL_SD_ERROR_PARAM;case 45:return HAL_SD_ERROR_REQUEST_NOT_APPLICABLE;case 46:return HAL_SD_ERROR_RX_OVERRUN;case 47:return HAL_SD_ERROR_STREAM_READ_UNDERRUN;case 48:return HAL_SD_ERROR_STREAM_WRITE_OVERRUN;case 49:return HAL_SD_ERROR_TIMEOUT;case 50:return HAL_SD_ERROR_TX_UNDERRUN;case 51:return HAL_SD_ERROR_UNSUPPORTED_FEATURE;case 52:return HAL_SD_ERROR_WP_ERASE_SKIP;case 53:return HAL_SD_ERROR_WRITE_PROT_VIOLATION;case 54:return HAL_SD_MSP_DEINIT_CB_ID;case 55:return HAL_SD_MSP_INIT_CB_ID;case 56:return HAL_SD_READ_DMA_LNKLST_BUF_CPLT_CB_ID;case 57:return HAL_SD_RX_CPLT_CB_ID;case 58:return HAL_SD_STATE_BUSY;case 59:return HAL_SD_STATE_ERROR;case 60:return HAL_SD_STATE_PROGRAMMING;case 61:return HAL_SD_STATE_READY;case 62:return HAL_SD_STATE_RECEIVING;case 63:return HAL_SD_STATE_RESET;case 64:return HAL_SD_STATE_TIMEOUT;case 65:return HAL_SD_STATE_TRANSFER;case 66:return HAL_SD_TX_CPLT_CB_ID;case 67:return HAL_SD_WRITE_DMA_LNKLST_BUF_CPLT_CB_ID;case 68:return SD_CONTEXT_DMA;case 69:return SD_CONTEXT_IT;case 70:return SD_CONTEXT_NONE;case 71:return SD_CONTEXT_READ_MULTIPLE_BLOCK;case 72:return SD_CONTEXT_READ_SINGLE_BLOCK;case 73:return SD_CONTEXT_WRITE_MULTIPLE_BLOCK;case 74:return SD_CONTEXT_WRITE_SINGLE_BLOCK;default:assert(0);return 0;}}
uint32_t CSD0_Run(CSDState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSD1_Run(CSDState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSD2_Run(CSDState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSD3_Run(CSDState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSD4_Run(CSDState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSD5_Run(CSDState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSD_Run(CSDState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CSD_Activate(s);switch(s->control[0]){case 0:return CSD0_Run(s,op,a,b,c);case 1:return CSD1_Run(s,op,a,b,c);case 2:return CSD2_Run(s,op,a,b,c);case 3:return CSD3_Run(s,op,a,b,c);case 4:return CSD4_Run(s,op,a,b,c);case 5:return CSD5_Run(s,op,a,b,c);default:assert(0);return 0;}}
