#include "ETHInternal.h"
CETH_THREAD_LOCAL CETHState *CETH_Active;
struct CETH_SBS CETH_SBS;
struct CETH_EXTI CETH_EXTI;
_Static_assert(sizeof(ETH_DMADescTypeDef)==24,"ETH descriptor stride");
size_t CETH_Size(void){return sizeof(CETHState);}
uint32_t *CETH_Control(CETHState *s){return s->control;}
uint32_t *CETH_Trace(CETHState *s){return s->trace;}
uint32_t CETH_RegisterSize(void){return sizeof(ETH_TypeDef);}
uint32_t CETH_GetRegister(CETHState *s,uint32_t o){assert((o&3)==0&&o<sizeof(s->registers));return *(volatile uint32_t *)((uint8_t *)&s->registers+o);}
void CETH_SetRegister(CETHState *s,uint32_t o,uint32_t v){assert((o&3)==0&&o<sizeof(s->registers));*(volatile uint32_t *)((uint8_t *)&s->registers+o)=v;}
uint32_t CETH_TickFor(CETHState *s){uint32_t v=s->control[3];s->control[3]+=s->control[4];s->control[5]++;for(uint32_t i=0;i<32;i++)if(s->events[i][0]&&s->events[i][1]==s->control[5]){s->events[i][0]=0;if(s->events[i][2]&0x80000000U){uint32_t offset=s->events[i][2]&0x7FFFFFFFU;assert(offset+4<=sizeof(*s));*(volatile uint32_t *)((uint8_t *)s+offset)=s->events[i][3];}else CETH_SetRegister(s,s->events[i][2],s->events[i][3]);}return v;}
uint32_t CETH_Tick(void){return CETH_TickFor(CETH_Active);}
static void trace(CETHState *s,uint32_t kind,uint32_t a){uint32_t *n=&s->control[8];assert(*n+8<=2048);s->trace[(*n)++]=kind;s->trace[(*n)++]=a;s->trace[(*n)++]=s->h.gState;s->trace[(*n)++]=s->h.ErrorCode;s->trace[(*n)++]=s->h.MACErrorCode;s->trace[(*n)++]=s->h.MACWakeUpEvent;s->trace[(*n)++]=s->h.MACLPIEvent;s->trace[(*n)++]=s->h.DMAErrorCode;}
static void invoke(CETHState *s,uint32_t kind,uint32_t token){trace(s,kind,token);if(s->control[10]&&s->control[11]==kind)s->h.gState=s->control[12];if(s->control[13]&&s->control[14]==kind)CETH_SetRegister(s,s->control[15],s->control[16]);}
uint32_t CETH_HCLK(void){trace(CETH_Active,104,0);return CETH_Active->control[7];}
void CETH_EnableSBS(void){trace(CETH_Active,105,0);}
void CETH_ConfigurePHY(uint32_t v){trace(CETH_Active,106,v);CETH_SBS.PMCR=(CETH_SBS.PMCR&~0xE00000U)|v;}
void CETH_Barrier(uint32_t kind){trace(CETH_Active,kind,0);}
void CETH_SetMask(uint32_t v){trace(CETH_Active,102,v);CETH_Active->control[6]=v;}
void HAL_ETH_MspInit(ETH_HandleTypeDef *h){invoke((CETHState *)h,0,1);}
void HAL_ETH_MspDeInit(ETH_HandleTypeDef *h){invoke((CETHState *)h,1,1);}
void HAL_ETH_TxCpltCallback(ETH_HandleTypeDef *h){invoke((CETHState *)h,2,1);}
void HAL_ETH_RxCpltCallback(ETH_HandleTypeDef *h){invoke((CETHState *)h,3,1);}
void HAL_ETH_ErrorCallback(ETH_HandleTypeDef *h){invoke((CETHState *)h,4,1);}
void HAL_ETH_PMTCallback(ETH_HandleTypeDef *h){invoke((CETHState *)h,6,1);}
void HAL_ETH_EEECallback(ETH_HandleTypeDef *h){invoke((CETHState *)h,7,1);}
void HAL_ETH_WakeUpCallback(ETH_HandleTypeDef *h){invoke((CETHState *)h,8,1);}
static void allocate(CETHState *s,uint8_t **buff,uint32_t token){trace(s,9,token);if(s->control[19]<s->control[18]){assert(s->control[19]<16);*buff=(uint8_t *)s->buffers[s->control[19]++];}else if(!s->control[20])*buff=NULL;}
void HAL_ETH_RxAllocateCallback(uint8_t **buff){allocate(CETH_Active,buff,1);}
void HAL_ETH_RxLinkCallback(void **start,void **end,uint8_t *buff,uint16_t length){if(!*start)*start=buff;*end=buff;trace(CETH_Active,10,length);}
void HAL_ETH_TxFreeCallback(uint32_t *buff){CETH_Active->control[24]=CETH_Normalize(CETH_Active,(uintptr_t)buff);trace(CETH_Active,11,1);}
void HAL_ETH_TxPtpCallback(uint32_t *buff,ETH_TimeStampTypeDef *ts){(void)buff;trace(CETH_Active,12,ts->TimeStampLow);}
uint32_t CETH_GetWord(CETHState *s,uint32_t i){switch(i){
case 0:return s->h.Init.MediaInterface;
case 1:return s->h.Init.RxBuffLen;
case 2:return s->h.gState;
case 3:return s->h.ErrorCode;
case 4:return s->h.DMAErrorCode;
case 5:return s->h.MACErrorCode;
case 6:return s->h.MACWakeUpEvent;
case 7:return s->h.MACLPIEvent;
case 8:return s->h.IsPtpConfigured;
case 9:return s->h.TxDescList.CurTxDesc;
case 10:return s->h.TxDescList.BuffersInUse;
case 11:return s->h.TxDescList.releaseIndex;
case 12:return s->h.RxDescList.ItMode;
case 13:return s->h.RxDescList.RxDescIdx;
case 14:return s->h.RxDescList.RxDescCnt;
case 15:return s->h.RxDescList.RxDataLength;
case 16:return s->h.RxDescList.RxBuildDescIdx;
case 17:return s->h.RxDescList.RxBuildDescCnt;
case 18:return s->h.RxDescList.pRxLastRxDesc;
case 19:return s->h.TxTimestamp.TimeStampLow;
case 20:return s->h.TxTimestamp.TimeStampHigh;
case 21:return s->h.RxDescList.TimeStamp.TimeStampLow;
case 22:return s->h.RxDescList.TimeStamp.TimeStampHigh;
default:assert(0);return 0;}}
void CETH_SetWord(CETHState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->h.Init.MediaInterface=v;break;
case 1:s->h.Init.RxBuffLen=v;break;
case 2:s->h.gState=v;break;
case 3:s->h.ErrorCode=v;break;
case 4:s->h.DMAErrorCode=v;break;
case 5:s->h.MACErrorCode=v;break;
case 6:s->h.MACWakeUpEvent=v;break;
case 7:s->h.MACLPIEvent=v;break;
case 8:s->h.IsPtpConfigured=v;break;
case 9:s->h.TxDescList.CurTxDesc=v;break;
case 10:s->h.TxDescList.BuffersInUse=v;break;
case 11:s->h.TxDescList.releaseIndex=v;break;
case 12:s->h.RxDescList.ItMode=v;break;
case 13:s->h.RxDescList.RxDescIdx=v;break;
case 14:s->h.RxDescList.RxDescCnt=v;break;
case 15:s->h.RxDescList.RxDataLength=v;break;
case 16:s->h.RxDescList.RxBuildDescIdx=v;break;
case 17:s->h.RxDescList.RxBuildDescCnt=v;break;
case 18:s->h.RxDescList.pRxLastRxDesc=v;break;
case 19:s->h.TxTimestamp.TimeStampLow=v;break;
case 20:s->h.TxTimestamp.TimeStampHigh=v;break;
case 21:s->h.RxDescList.TimeStamp.TimeStampLow=v;break;
case 22:s->h.RxDescList.TimeStamp.TimeStampHigh=v;break;
default:assert(0);}}
void *CETH_GetPointer(CETHState *s,uint32_t i){switch(i){
case 0:return s->h.Init.MACAddr;
case 1:return s->h.Init.TxDesc;
case 2:return s->h.Init.RxDesc;
case 3:return s->h.TxDescList.CurrentPacketAddress;
case 4:return s->h.RxDescList.pRxStart;
case 5:return s->h.RxDescList.pRxEnd;
default:assert(0);return NULL;}}
void CETH_SetPointer(CETHState *s,uint32_t i,void *v){switch(i){
case 0:s->h.Init.MACAddr=v;break;
case 1:s->h.Init.TxDesc=v;break;
case 2:s->h.Init.RxDesc=v;break;
case 3:s->h.TxDescList.CurrentPacketAddress=v;break;
case 4:s->h.RxDescList.pRxStart=v;break;
case 5:s->h.RxDescList.pRxEnd=v;break;
default:assert(0);}}
void **CETH_PointerStorage(CETHState *s,uint32_t i){switch(i){
case 0:return (void **)&s->h.Init.MACAddr;
case 1:return (void **)&s->h.Init.TxDesc;
case 2:return (void **)&s->h.Init.RxDesc;
case 3:return (void **)&s->h.TxDescList.CurrentPacketAddress;
case 4:return (void **)&s->h.RxDescList.pRxStart;
case 5:return (void **)&s->h.RxDescList.pRxEnd;
default:assert(0);return NULL;}}
uint32_t CETH_GetDescriptorAddress(CETHState *s,uint32_t ring,uint32_t i){assert(i<8);return ring?s->h.RxDescList.RxDesc[i]:s->h.TxDescList.TxDesc[i];}
void CETH_SetDescriptorAddress(CETHState *s,uint32_t ring,uint32_t i,uint32_t v){assert(i<8);if(ring)s->h.RxDescList.RxDesc[i]=v;else s->h.TxDescList.TxDesc[i]=v;}
uint32_t *CETH_GetTransmitPacket(CETHState *s,uint32_t i){assert(i<8);return s->h.TxDescList.PacketAddress[i];}
void CETH_SetTransmitPacket(CETHState *s,uint32_t i,uint32_t *v){assert(i<8);s->h.TxDescList.PacketAddress[i]=v;}
uint32_t *CETH_TransmitTimestamp(CETHState *s){return &s->h.TxTimestamp.TimeStampLow;}
uint32_t CETH_GetConfiguration(CETHState *s,uint32_t k,uint32_t i){switch(k){
case 0:switch(i){
case 0:return s->configuration0.SourceAddrControl;
case 1:return s->configuration0.ChecksumOffload;
case 2:return s->configuration0.InterPacketGapVal;
case 3:return s->configuration0.GiantPacketSizeLimitControl;
case 4:return s->configuration0.Support2KPacket;
case 5:return s->configuration0.CRCStripTypePacket;
case 6:return s->configuration0.AutomaticPadCRCStrip;
case 7:return s->configuration0.Watchdog;
case 8:return s->configuration0.Jabber;
case 9:return s->configuration0.JumboPacket;
case 10:return s->configuration0.Speed;
case 11:return s->configuration0.DuplexMode;
case 12:return s->configuration0.LoopbackMode;
case 13:return s->configuration0.CarrierSenseBeforeTransmit;
case 14:return s->configuration0.ReceiveOwn;
case 15:return s->configuration0.CarrierSenseDuringTransmit;
case 16:return s->configuration0.RetryTransmission;
case 17:return s->configuration0.BackOffLimit;
case 18:return s->configuration0.DeferralCheck;
case 19:return s->configuration0.PreambleLength;
case 20:return s->configuration0.UnicastSlowProtocolPacketDetect;
case 21:return s->configuration0.SlowProtocolDetect;
case 22:return s->configuration0.CRCCheckingRxPackets;
case 23:return s->configuration0.GiantPacketSizeLimit;
case 24:return s->configuration0.ExtendedInterPacketGap;
case 25:return s->configuration0.ExtendedInterPacketGapVal;
case 26:return s->configuration0.ProgrammableWatchdog;
case 27:return s->configuration0.WatchdogTimeout;
case 28:return s->configuration0.PauseTime;
case 29:return s->configuration0.ZeroQuantaPause;
case 30:return s->configuration0.PauseLowThreshold;
case 31:return s->configuration0.TransmitFlowControl;
case 32:return s->configuration0.UnicastPausePacketDetect;
case 33:return s->configuration0.ReceiveFlowControl;
case 34:return s->configuration0.TransmitQueueMode;
case 35:return s->configuration0.ReceiveQueueMode;
case 36:return s->configuration0.DropTCPIPChecksumErrorPacket;
case 37:return s->configuration0.ForwardRxErrorPacket;
case 38:return s->configuration0.ForwardRxUndersizedGoodPacket;
default:assert(0);return 0;}
case 1:switch(i){
case 0:return s->configuration1.DMAArbitration;
case 1:return s->configuration1.AddressAlignedBeats;
case 2:return s->configuration1.BurstMode;
case 3:return s->configuration1.RebuildINCRxBurst;
case 4:return s->configuration1.PBLx8Mode;
case 5:return s->configuration1.TxDMABurstLength;
case 6:return s->configuration1.SecondPacketOperate;
case 7:return s->configuration1.RxDMABurstLength;
case 8:return s->configuration1.FlushRxPacket;
case 9:return s->configuration1.TCPSegmentation;
case 10:return s->configuration1.MaximumSegmentSize;
default:assert(0);return 0;}
case 2:switch(i){
case 0:return s->configuration2.Timestamp;
case 1:return s->configuration2.TimestampUpdateMode;
case 2:return s->configuration2.TimestampInitialize;
case 3:return s->configuration2.TimestampUpdate;
case 4:return s->configuration2.TimestampAddendUpdate;
case 5:return s->configuration2.TimestampAll;
case 6:return s->configuration2.TimestampRolloverMode;
case 7:return s->configuration2.TimestampV2;
case 8:return s->configuration2.TimestampEthernet;
case 9:return s->configuration2.TimestampIPv6;
case 10:return s->configuration2.TimestampIPv4;
case 11:return s->configuration2.TimestampEvent;
case 12:return s->configuration2.TimestampMaster;
case 13:return s->configuration2.TimestampSnapshots;
case 14:return s->configuration2.TimestampFilter;
case 15:return s->configuration2.TimestampChecksumCorrection;
case 16:return s->configuration2.TimestampStatusMode;
case 17:return s->configuration2.TimestampAddend;
case 18:return s->configuration2.TimestampSubsecondInc;
default:assert(0);return 0;}
case 3:switch(i){
case 0:return s->configuration3.PromiscuousMode;
case 1:return s->configuration3.ReceiveAllMode;
case 2:return s->configuration3.HachOrPerfectFilter;
case 3:return s->configuration3.HashUnicast;
case 4:return s->configuration3.HashMulticast;
case 5:return s->configuration3.PassAllMulticast;
case 6:return s->configuration3.SrcAddrFiltering;
case 7:return s->configuration3.SrcAddrInverseFiltering;
case 8:return s->configuration3.DestAddrInverseFiltering;
case 9:return s->configuration3.BroadcastFilter;
case 10:return s->configuration3.ControlPacketsFilter;
default:assert(0);return 0;}
case 4:switch(i){
case 0:return s->configuration4.WakeUpPacket;
case 1:return s->configuration4.MagicPacket;
case 2:return s->configuration4.GlobalUnicast;
case 3:return s->configuration4.WakeUpForward;
default:assert(0);return 0;}
case 5:switch(i){
case 0:return s->configuration5.InnerVLANTagInStatus;
case 1:return s->configuration5.StripInnerVLANTag;
case 2:return s->configuration5.InnerVLANTag;
case 3:return s->configuration5.DoubleVLANProcessing;
case 4:return s->configuration5.VLANTagHashTableMatch;
case 5:return s->configuration5.VLANTagInStatus;
case 6:return s->configuration5.StripVLANTag;
case 7:return s->configuration5.VLANTypeCheck;
case 8:return s->configuration5.VLANTagInverceMatch;
default:assert(0);return 0;}
case 6:switch(i){
case 0:return s->configuration6.SourceTxDesc;
case 1:return s->configuration6.SVLANType;
case 2:return s->configuration6.VLANTagControl;
default:assert(0);return 0;}
case 7:switch(i){
case 0:return s->configuration7.Protocol;
case 1:return s->configuration7.SrcAddrFilterMatch;
case 2:return s->configuration7.DestAddrFilterMatch;
case 3:return s->configuration7.SrcAddrHigherBitsMatch;
case 4:return s->configuration7.DestAddrHigherBitsMatch;
case 5:return s->configuration7.Ip4SrcAddr;
case 6:return s->configuration7.Ip4DestAddr;
case 7:return s->configuration7.Ip6Addr[0];
case 8:return s->configuration7.Ip6Addr[1];
case 9:return s->configuration7.Ip6Addr[2];
case 10:return s->configuration7.Ip6Addr[3];
default:assert(0);return 0;}
case 8:switch(i){
case 0:return s->configuration8.Protocol;
case 1:return s->configuration8.SrcPortFilterMatch;
case 2:return s->configuration8.DestPortFilterMatch;
case 3:return s->configuration8.SourcePort;
case 4:return s->configuration8.DestinationPort;
default:assert(0);return 0;}
case 9:switch(i){
case 0:return s->configuration9.TimeStampLow;
case 1:return s->configuration9.TimeStampHigh;
default:assert(0);return 0;}
case 10:switch(i){
case 0:return s->configuration10.Seconds;
case 1:return s->configuration10.NanoSeconds;
default:assert(0);return 0;}
default:assert(0);return 0;}}
void CETH_SetConfiguration(CETHState *s,uint32_t k,uint32_t i,uint32_t v){switch(k){
case 0:switch(i){
case 0:s->configuration0.SourceAddrControl=v;return;
case 1:s->configuration0.ChecksumOffload=v;return;
case 2:s->configuration0.InterPacketGapVal=v;return;
case 3:s->configuration0.GiantPacketSizeLimitControl=v;return;
case 4:s->configuration0.Support2KPacket=v;return;
case 5:s->configuration0.CRCStripTypePacket=v;return;
case 6:s->configuration0.AutomaticPadCRCStrip=v;return;
case 7:s->configuration0.Watchdog=v;return;
case 8:s->configuration0.Jabber=v;return;
case 9:s->configuration0.JumboPacket=v;return;
case 10:s->configuration0.Speed=v;return;
case 11:s->configuration0.DuplexMode=v;return;
case 12:s->configuration0.LoopbackMode=v;return;
case 13:s->configuration0.CarrierSenseBeforeTransmit=v;return;
case 14:s->configuration0.ReceiveOwn=v;return;
case 15:s->configuration0.CarrierSenseDuringTransmit=v;return;
case 16:s->configuration0.RetryTransmission=v;return;
case 17:s->configuration0.BackOffLimit=v;return;
case 18:s->configuration0.DeferralCheck=v;return;
case 19:s->configuration0.PreambleLength=v;return;
case 20:s->configuration0.UnicastSlowProtocolPacketDetect=v;return;
case 21:s->configuration0.SlowProtocolDetect=v;return;
case 22:s->configuration0.CRCCheckingRxPackets=v;return;
case 23:s->configuration0.GiantPacketSizeLimit=v;return;
case 24:s->configuration0.ExtendedInterPacketGap=v;return;
case 25:s->configuration0.ExtendedInterPacketGapVal=v;return;
case 26:s->configuration0.ProgrammableWatchdog=v;return;
case 27:s->configuration0.WatchdogTimeout=v;return;
case 28:s->configuration0.PauseTime=v;return;
case 29:s->configuration0.ZeroQuantaPause=v;return;
case 30:s->configuration0.PauseLowThreshold=v;return;
case 31:s->configuration0.TransmitFlowControl=v;return;
case 32:s->configuration0.UnicastPausePacketDetect=v;return;
case 33:s->configuration0.ReceiveFlowControl=v;return;
case 34:s->configuration0.TransmitQueueMode=v;return;
case 35:s->configuration0.ReceiveQueueMode=v;return;
case 36:s->configuration0.DropTCPIPChecksumErrorPacket=v;return;
case 37:s->configuration0.ForwardRxErrorPacket=v;return;
case 38:s->configuration0.ForwardRxUndersizedGoodPacket=v;return;
default:assert(0);return;}
case 1:switch(i){
case 0:s->configuration1.DMAArbitration=v;return;
case 1:s->configuration1.AddressAlignedBeats=v;return;
case 2:s->configuration1.BurstMode=v;return;
case 3:s->configuration1.RebuildINCRxBurst=v;return;
case 4:s->configuration1.PBLx8Mode=v;return;
case 5:s->configuration1.TxDMABurstLength=v;return;
case 6:s->configuration1.SecondPacketOperate=v;return;
case 7:s->configuration1.RxDMABurstLength=v;return;
case 8:s->configuration1.FlushRxPacket=v;return;
case 9:s->configuration1.TCPSegmentation=v;return;
case 10:s->configuration1.MaximumSegmentSize=v;return;
default:assert(0);return;}
case 2:switch(i){
case 0:s->configuration2.Timestamp=v;return;
case 1:s->configuration2.TimestampUpdateMode=v;return;
case 2:s->configuration2.TimestampInitialize=v;return;
case 3:s->configuration2.TimestampUpdate=v;return;
case 4:s->configuration2.TimestampAddendUpdate=v;return;
case 5:s->configuration2.TimestampAll=v;return;
case 6:s->configuration2.TimestampRolloverMode=v;return;
case 7:s->configuration2.TimestampV2=v;return;
case 8:s->configuration2.TimestampEthernet=v;return;
case 9:s->configuration2.TimestampIPv6=v;return;
case 10:s->configuration2.TimestampIPv4=v;return;
case 11:s->configuration2.TimestampEvent=v;return;
case 12:s->configuration2.TimestampMaster=v;return;
case 13:s->configuration2.TimestampSnapshots=v;return;
case 14:s->configuration2.TimestampFilter=v;return;
case 15:s->configuration2.TimestampChecksumCorrection=v;return;
case 16:s->configuration2.TimestampStatusMode=v;return;
case 17:s->configuration2.TimestampAddend=v;return;
case 18:s->configuration2.TimestampSubsecondInc=v;return;
default:assert(0);return;}
case 3:switch(i){
case 0:s->configuration3.PromiscuousMode=v;return;
case 1:s->configuration3.ReceiveAllMode=v;return;
case 2:s->configuration3.HachOrPerfectFilter=v;return;
case 3:s->configuration3.HashUnicast=v;return;
case 4:s->configuration3.HashMulticast=v;return;
case 5:s->configuration3.PassAllMulticast=v;return;
case 6:s->configuration3.SrcAddrFiltering=v;return;
case 7:s->configuration3.SrcAddrInverseFiltering=v;return;
case 8:s->configuration3.DestAddrInverseFiltering=v;return;
case 9:s->configuration3.BroadcastFilter=v;return;
case 10:s->configuration3.ControlPacketsFilter=v;return;
default:assert(0);return;}
case 4:switch(i){
case 0:s->configuration4.WakeUpPacket=v;return;
case 1:s->configuration4.MagicPacket=v;return;
case 2:s->configuration4.GlobalUnicast=v;return;
case 3:s->configuration4.WakeUpForward=v;return;
default:assert(0);return;}
case 5:switch(i){
case 0:s->configuration5.InnerVLANTagInStatus=v;return;
case 1:s->configuration5.StripInnerVLANTag=v;return;
case 2:s->configuration5.InnerVLANTag=v;return;
case 3:s->configuration5.DoubleVLANProcessing=v;return;
case 4:s->configuration5.VLANTagHashTableMatch=v;return;
case 5:s->configuration5.VLANTagInStatus=v;return;
case 6:s->configuration5.StripVLANTag=v;return;
case 7:s->configuration5.VLANTypeCheck=v;return;
case 8:s->configuration5.VLANTagInverceMatch=v;return;
default:assert(0);return;}
case 6:switch(i){
case 0:s->configuration6.SourceTxDesc=v;return;
case 1:s->configuration6.SVLANType=v;return;
case 2:s->configuration6.VLANTagControl=v;return;
default:assert(0);return;}
case 7:switch(i){
case 0:s->configuration7.Protocol=v;return;
case 1:s->configuration7.SrcAddrFilterMatch=v;return;
case 2:s->configuration7.DestAddrFilterMatch=v;return;
case 3:s->configuration7.SrcAddrHigherBitsMatch=v;return;
case 4:s->configuration7.DestAddrHigherBitsMatch=v;return;
case 5:s->configuration7.Ip4SrcAddr=v;return;
case 6:s->configuration7.Ip4DestAddr=v;return;
case 7:s->configuration7.Ip6Addr[0]=v;return;
case 8:s->configuration7.Ip6Addr[1]=v;return;
case 9:s->configuration7.Ip6Addr[2]=v;return;
case 10:s->configuration7.Ip6Addr[3]=v;return;
default:assert(0);return;}
case 8:switch(i){
case 0:s->configuration8.Protocol=v;return;
case 1:s->configuration8.SrcPortFilterMatch=v;return;
case 2:s->configuration8.DestPortFilterMatch=v;return;
case 3:s->configuration8.SourcePort=v;return;
case 4:s->configuration8.DestinationPort=v;return;
default:assert(0);return;}
case 9:switch(i){
case 0:s->configuration9.TimeStampLow=v;return;
case 1:s->configuration9.TimeStampHigh=v;return;
default:assert(0);return;}
case 10:switch(i){
case 0:s->configuration10.Seconds=v;return;
case 1:s->configuration10.NanoSeconds=v;return;
default:assert(0);return;}
default:assert(0);return;}}
void CETH_Reset(CETHState *s,uint32_t callbacks,uint32_t ptp,uint32_t rings){
 assert(callbacks<2&&ptp<2&&(rings==3||rings==4||rings==8));
 memset(s,0,sizeof(*s));s->control[0]=callbacks;s->control[1]=ptp;s->control[2]=rings;s->control[4]=1;s->control[7]=240000000;
 for(uint32_t i=2;i<=12;i++)if(i!=5)CETH_SetCallback(s,i,CETH_Callback(i,1));
 s->packet.TxBuffer=s->links;s->packet.pData=s->buffers[15];s->packet.Length=64;s->links[0].buffer=(uint8_t *)s->buffers[0];s->links[0].len=64;
 s->h.Instance=&s->registers;s->h.Init.MACAddr=s->mac;s->h.Init.TxDesc=s->tx;s->h.Init.RxDesc=s->rx;s->h.Init.RxBuffLen=256;
 for(uint32_t i=0;i<8;i++){s->h.TxDescList.TxDesc[i]=(uint32_t)(uintptr_t)&s->tx[i];s->h.RxDescList.RxDesc[i]=(uint32_t)(uintptr_t)&s->rx[i];}
}
static uint32_t dispatch(CETHState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CETH_Active=s;switch(s->control[0]*100+s->control[1]*10+s->control[2]){
case 3:return CETH003_Run(s,op,a,b,c);
case 4:return CETH004_Run(s,op,a,b,c);
case 8:return CETH008_Run(s,op,a,b,c);
case 13:return CETH013_Run(s,op,a,b,c);
case 14:return CETH014_Run(s,op,a,b,c);
case 18:return CETH018_Run(s,op,a,b,c);
case 103:return CETH103_Run(s,op,a,b,c);
case 104:return CETH104_Run(s,op,a,b,c);
case 108:return CETH108_Run(s,op,a,b,c);
case 113:return CETH113_Run(s,op,a,b,c);
case 114:return CETH114_Run(s,op,a,b,c);
case 118:return CETH118_Run(s,op,a,b,c);
default:assert(0);return UINT32_MAX;}}
uint32_t CETH_Constant(uint32_t i){switch(i){
case 0:return 4U;
case 1:return 4U;
case 2:return ETH_SWRESET_TIMEOUT;
case 3:return ETH_MDIO_BUS_TIMEOUT;
case 4:return ETH_MAC_US_TICK;
case 5:return ETH_DMATXNDESCRF_B1AP;
case 6:return ETH_DMATXNDESCRF_B2AP;
case 7:return ETH_DMATXNDESCRF_IOC;
case 8:return ETH_DMATXNDESCRF_TTSE;
case 9:return ETH_DMATXNDESCRF_B2L;
case 10:return ETH_DMATXNDESCRF_VTIR;
case 11:return ETH_DMATXNDESCRF_VTIR_DISABLE;
case 12:return ETH_DMATXNDESCRF_VTIR_REMOVE;
case 13:return ETH_DMATXNDESCRF_VTIR_INSERT;
case 14:return ETH_DMATXNDESCRF_VTIR_REPLACE;
case 15:return ETH_DMATXNDESCRF_B1L;
case 16:return ETH_DMATXNDESCRF_HL;
case 17:return ETH_DMATXNDESCRF_OWN;
case 18:return ETH_DMATXNDESCRF_CTXT;
case 19:return ETH_DMATXNDESCRF_FD;
case 20:return ETH_DMATXNDESCRF_LD;
case 21:return ETH_DMATXNDESCRF_CPC;
case 22:return ETH_DMATXNDESCRF_CPC_CRCPAD_INSERT;
case 23:return ETH_DMATXNDESCRF_CPC_CRC_INSERT;
case 24:return ETH_DMATXNDESCRF_CPC_DISABLE;
case 25:return ETH_DMATXNDESCRF_CPC_CRC_REPLACE;
case 26:return ETH_DMATXNDESCRF_SAIC;
case 27:return ETH_DMATXNDESCRF_SAIC_DISABLE;
case 28:return ETH_DMATXNDESCRF_SAIC_INSERT;
case 29:return ETH_DMATXNDESCRF_SAIC_REPLACE;
case 30:return ETH_DMATXNDESCRF_THL;
case 31:return ETH_DMATXNDESCRF_TSE;
case 32:return ETH_DMATXNDESCRF_CIC;
case 33:return ETH_DMATXNDESCRF_CIC_DISABLE;
case 34:return ETH_DMATXNDESCRF_CIC_IPHDR_INSERT;
case 35:return ETH_DMATXNDESCRF_CIC_IPHDR_PAYLOAD_INSERT;
case 36:return ETH_DMATXNDESCRF_CIC_IPHDR_PAYLOAD_INSERT_PHDR_CALC;
case 37:return ETH_DMATXNDESCRF_TPL;
case 38:return ETH_DMATXNDESCRF_FL;
case 39:return ETH_DMATXNDESCWBF_TTSL;
case 40:return ETH_DMATXNDESCWBF_TTSH;
case 41:return ETH_DMATXNDESCWBF_OWN;
case 42:return ETH_DMATXNDESCWBF_CTXT;
case 43:return ETH_DMATXNDESCWBF_FD;
case 44:return ETH_DMATXNDESCWBF_LD;
case 45:return ETH_DMATXNDESCWBF_TTSS;
case 46:return ETH_DMATXNDESCWBF_DP;
case 47:return ETH_DMATXNDESCWBF_TTSE;
case 48:return ETH_DMATXNDESCWBF_ES;
case 49:return ETH_DMATXNDESCWBF_JT;
case 50:return ETH_DMATXNDESCWBF_FF;
case 51:return ETH_DMATXNDESCWBF_PCE;
case 52:return ETH_DMATXNDESCWBF_LCA;
case 53:return ETH_DMATXNDESCWBF_NC;
case 54:return ETH_DMATXNDESCWBF_LCO;
case 55:return ETH_DMATXNDESCWBF_EC;
case 56:return ETH_DMATXNDESCWBF_CC;
case 57:return ETH_DMATXNDESCWBF_ED;
case 58:return ETH_DMATXNDESCWBF_UF;
case 59:return ETH_DMATXNDESCWBF_DB;
case 60:return ETH_DMATXNDESCWBF_IHE;
case 61:return ETH_DMATXCDESC_TTSL;
case 62:return ETH_DMATXCDESC_TTSH;
case 63:return ETH_DMATXCDESC_IVT;
case 64:return ETH_DMATXCDESC_MSS;
case 65:return ETH_DMATXCDESC_OWN;
case 66:return ETH_DMATXCDESC_CTXT;
case 67:return ETH_DMATXCDESC_OSTC;
case 68:return ETH_DMATXCDESC_TCMSSV;
case 69:return ETH_DMATXCDESC_CDE;
case 70:return ETH_DMATXCDESC_IVTIR;
case 71:return ETH_DMATXCDESC_IVTIR_DISABLE;
case 72:return ETH_DMATXCDESC_IVTIR_REMOVE;
case 73:return ETH_DMATXCDESC_IVTIR_INSERT;
case 74:return ETH_DMATXCDESC_IVTIR_REPLACE;
case 75:return ETH_DMATXCDESC_IVLTV;
case 76:return ETH_DMATXCDESC_VLTV;
case 77:return ETH_DMATXCDESC_VT;
case 78:return ETH_DMARXNDESCRF_BUF1AP;
case 79:return ETH_DMARXNDESCRF_BUF2AP;
case 80:return ETH_DMARXNDESCRF_OWN;
case 81:return ETH_DMARXNDESCRF_IOC;
case 82:return ETH_DMARXNDESCRF_BUF2V;
case 83:return ETH_DMARXNDESCRF_BUF1V;
case 84:return ETH_DMARXNDESCWBF_IVT;
case 85:return ETH_DMARXNDESCWBF_OVT;
case 86:return ETH_DMARXNDESCWBF_OPC;
case 87:return ETH_DMARXNDESCWBF_TD;
case 88:return ETH_DMARXNDESCWBF_TSA;
case 89:return ETH_DMARXNDESCWBF_PV;
case 90:return ETH_DMARXNDESCWBF_PFT;
case 91:return ETH_DMARXNDESCWBF_PMT_NO;
case 92:return ETH_DMARXNDESCWBF_PMT_SYNC;
case 93:return ETH_DMARXNDESCWBF_PMT_FUP;
case 94:return ETH_DMARXNDESCWBF_PMT_DREQ;
case 95:return ETH_DMARXNDESCWBF_PMT_DRESP;
case 96:return ETH_DMARXNDESCWBF_PMT_PDREQ;
case 97:return ETH_DMARXNDESCWBF_PMT_PDRESP;
case 98:return ETH_DMARXNDESCWBF_PMT_PDRESPFUP;
case 99:return ETH_DMARXNDESCWBF_PMT_ANNOUNCE;
case 100:return ETH_DMARXNDESCWBF_PMT_MANAG;
case 101:return ETH_DMARXNDESCWBF_PMT_SIGN;
case 102:return ETH_DMARXNDESCWBF_PMT_RESERVED;
case 103:return ETH_DMARXNDESCWBF_IPCE;
case 104:return ETH_DMARXNDESCWBF_IPCB;
case 105:return ETH_DMARXNDESCWBF_IPV6;
case 106:return ETH_DMARXNDESCWBF_IPV4;
case 107:return ETH_DMARXNDESCWBF_IPHE;
case 108:return ETH_DMARXNDESCWBF_PT;
case 109:return ETH_DMARXNDESCWBF_PT_UNKNOWN;
case 110:return ETH_DMARXNDESCWBF_PT_UDP;
case 111:return ETH_DMARXNDESCWBF_PT_TCP;
case 112:return ETH_DMARXNDESCWBF_PT_ICMP;
case 113:return ETH_DMARXNDESCWBF_L3L4FM;
case 114:return ETH_DMARXNDESCWBF_L4FM;
case 115:return ETH_DMARXNDESCWBF_L3FM;
case 116:return ETH_DMARXNDESCWBF_MADRM;
case 117:return ETH_DMARXNDESCWBF_HF;
case 118:return ETH_DMARXNDESCWBF_DAF;
case 119:return ETH_DMARXNDESCWBF_SAF;
case 120:return ETH_DMARXNDESCWBF_VF;
case 121:return ETH_DMARXNDESCWBF_ARPNR;
case 122:return ETH_DMARXNDESCWBF_OWN;
case 123:return ETH_DMARXNDESCWBF_CTXT;
case 124:return ETH_DMARXNDESCWBF_FD;
case 125:return ETH_DMARXNDESCWBF_LD;
case 126:return ETH_DMARXNDESCWBF_RS2V;
case 127:return ETH_DMARXNDESCWBF_RS1V;
case 128:return ETH_DMARXNDESCWBF_RS0V;
case 129:return ETH_DMARXNDESCWBF_CE;
case 130:return ETH_DMARXNDESCWBF_GP;
case 131:return ETH_DMARXNDESCWBF_RWT;
case 132:return ETH_DMARXNDESCWBF_OE;
case 133:return ETH_DMARXNDESCWBF_RE;
case 134:return ETH_DMARXNDESCWBF_DE;
case 135:return ETH_DMARXNDESCWBF_LT;
case 136:return ETH_DMARXNDESCWBF_LT_LP;
case 137:return ETH_DMARXNDESCWBF_LT_TP;
case 138:return ETH_DMARXNDESCWBF_LT_ARP;
case 139:return ETH_DMARXNDESCWBF_LT_VLAN;
case 140:return ETH_DMARXNDESCWBF_LT_DVLAN;
case 141:return ETH_DMARXNDESCWBF_LT_MAC;
case 142:return ETH_DMARXNDESCWBF_LT_OAM;
case 143:return ETH_DMARXNDESCWBF_ES;
case 144:return ETH_DMARXNDESCWBF_PL;
case 145:return ETH_DMARXCDESC_RTSL;
case 146:return ETH_DMARXCDESC_RTSH;
case 147:return ETH_DMARXCDESC_OWN;
case 148:return ETH_DMARXCDESC_CTXT;
case 149:return ETH_MAX_PACKET_SIZE;
case 150:return ETH_HEADER;
case 151:return ETH_CRC;
case 152:return ETH_VLAN_TAG;
case 153:return ETH_MIN_PAYLOAD;
case 154:return ETH_MAX_PAYLOAD;
case 155:return ETH_JUMBO_FRAME_PAYLOAD;
case 156:return HAL_ETH_ERROR_NONE;
case 157:return HAL_ETH_ERROR_PARAM;
case 158:return HAL_ETH_ERROR_BUSY;
case 159:return HAL_ETH_ERROR_TIMEOUT;
case 160:return HAL_ETH_ERROR_DMA;
case 161:return HAL_ETH_ERROR_MAC;
case 162:return HAL_ETH_ERROR_INVALID_CALLBACK;
case 163:return ETH_TX_PACKETS_FEATURES_CSUM;
case 164:return ETH_TX_PACKETS_FEATURES_SAIC;
case 165:return ETH_TX_PACKETS_FEATURES_VLANTAG;
case 166:return ETH_TX_PACKETS_FEATURES_INNERVLANTAG;
case 167:return ETH_TX_PACKETS_FEATURES_TSO;
case 168:return ETH_TX_PACKETS_FEATURES_CRCPAD;
case 169:return ETH_SRC_ADDR_CONTROL_DISABLE;
case 170:return ETH_SRC_ADDR_INSERT;
case 171:return ETH_SRC_ADDR_REPLACE;
case 172:return ETH_CRC_PAD_DISABLE;
case 173:return ETH_CRC_PAD_INSERT;
case 174:return ETH_CRC_INSERT;
case 175:return ETH_CRC_REPLACE;
case 176:return ETH_CHECKSUM_DISABLE;
case 177:return ETH_CHECKSUM_IPHDR_INSERT;
case 178:return ETH_CHECKSUM_IPHDR_PAYLOAD_INSERT;
case 179:return ETH_CHECKSUM_IPHDR_PAYLOAD_INSERT_PHDR_CALC;
case 180:return ETH_VLAN_DISABLE;
case 181:return ETH_VLAN_REMOVE;
case 182:return ETH_VLAN_INSERT;
case 183:return ETH_VLAN_REPLACE;
case 184:return ETH_INNER_VLAN_DISABLE;
case 185:return ETH_INNER_VLAN_REMOVE;
case 186:return ETH_INNER_VLAN_INSERT;
case 187:return ETH_INNER_VLAN_REPLACE;
case 188:return ETH_CHECKSUM_BYPASSED;
case 189:return ETH_CHECKSUM_IP_HEADER_ERROR;
case 190:return ETH_CHECKSUM_IP_PAYLOAD_ERROR;
case 191:return ETH_IP_HEADER_IPV4;
case 192:return ETH_IP_HEADER_IPV6;
case 193:return ETH_IP_PAYLOAD_UNKNOWN;
case 194:return ETH_IP_PAYLOAD_UDP;
case 195:return ETH_IP_PAYLOAD_TCP;
case 196:return ETH_IP_PAYLOAD_ICMPN;
case 197:return ETH_HASH_FILTER_PASS;
case 198:return ETH_VLAN_FILTER_PASS;
case 199:return ETH_DEST_ADDRESS_FAIL;
case 200:return ETH_SOURCE_ADDRESS_FAIL;
case 201:return ETH_L3_FILTER0_MATCH;
case 202:return ETH_L3_FILTER1_MATCH;
case 203:return ETH_L4_FILTER0_MATCH;
case 204:return ETH_L4_FILTER1_MATCH;
case 205:return ETH_DRIBBLE_BIT_ERROR;
case 206:return ETH_RECEIVE_ERROR;
case 207:return ETH_RECEIVE_OVERFLOW;
case 208:return ETH_WATCHDOG_TIMEOUT;
case 209:return ETH_GIANT_PACKET;
case 210:return ETH_CRC_ERROR;
case 211:return ETH_DMAARBITRATION_RX;
case 212:return ETH_DMAARBITRATION_RX1_TX1;
case 213:return ETH_DMAARBITRATION_RX2_TX1;
case 214:return ETH_DMAARBITRATION_RX3_TX1;
case 215:return ETH_DMAARBITRATION_RX4_TX1;
case 216:return ETH_DMAARBITRATION_RX5_TX1;
case 217:return ETH_DMAARBITRATION_RX6_TX1;
case 218:return ETH_DMAARBITRATION_RX7_TX1;
case 219:return ETH_DMAARBITRATION_RX8_TX1;
case 220:return ETH_DMAARBITRATION_TX;
case 221:return ETH_DMAARBITRATION_TX1_RX1;
case 222:return ETH_DMAARBITRATION_TX2_RX1;
case 223:return ETH_DMAARBITRATION_TX3_RX1;
case 224:return ETH_DMAARBITRATION_TX4_RX1;
case 225:return ETH_DMAARBITRATION_TX5_RX1;
case 226:return ETH_DMAARBITRATION_TX6_RX1;
case 227:return ETH_DMAARBITRATION_TX7_RX1;
case 228:return ETH_DMAARBITRATION_TX8_RX1;
case 229:return ETH_BURSTLENGTH_FIXED;
case 230:return ETH_BURSTLENGTH_MIXED;
case 231:return ETH_BURSTLENGTH_UNSPECIFIED;
case 232:return ETH_TXDMABURSTLENGTH_1BEAT;
case 233:return ETH_TXDMABURSTLENGTH_2BEAT;
case 234:return ETH_TXDMABURSTLENGTH_4BEAT;
case 235:return ETH_TXDMABURSTLENGTH_8BEAT;
case 236:return ETH_TXDMABURSTLENGTH_16BEAT;
case 237:return ETH_TXDMABURSTLENGTH_32BEAT;
case 238:return ETH_RXDMABURSTLENGTH_1BEAT;
case 239:return ETH_RXDMABURSTLENGTH_2BEAT;
case 240:return ETH_RXDMABURSTLENGTH_4BEAT;
case 241:return ETH_RXDMABURSTLENGTH_8BEAT;
case 242:return ETH_RXDMABURSTLENGTH_16BEAT;
case 243:return ETH_RXDMABURSTLENGTH_32BEAT;
case 244:return ETH_DMA_NORMAL_IT;
case 245:return ETH_DMA_ABNORMAL_IT;
case 246:return ETH_DMA_CONTEXT_DESC_ERROR_IT;
case 247:return ETH_DMA_FATAL_BUS_ERROR_IT;
case 248:return ETH_DMA_EARLY_RX_IT;
case 249:return ETH_DMA_EARLY_TX_IT;
case 250:return ETH_DMA_RX_WATCHDOG_TIMEOUT_IT;
case 251:return ETH_DMA_RX_PROCESS_STOPPED_IT;
case 252:return ETH_DMA_RX_BUFFER_UNAVAILABLE_IT;
case 253:return ETH_DMA_RX_IT;
case 254:return ETH_DMA_TX_BUFFER_UNAVAILABLE_IT;
case 255:return ETH_DMA_TX_PROCESS_STOPPED_IT;
case 256:return ETH_DMA_TX_IT;
case 257:return ETH_DMA_RX_NO_ERROR_FLAG;
case 258:return ETH_DMA_RX_DESC_READ_ERROR_FLAG;
case 259:return ETH_DMA_RX_DESC_WRITE_ERROR_FLAG;
case 260:return ETH_DMA_RX_BUFFER_READ_ERROR_FLAG;
case 261:return ETH_DMA_RX_BUFFER_WRITE_ERROR_FLAG;
case 262:return ETH_DMA_TX_NO_ERROR_FLAG;
case 263:return ETH_DMA_TX_DESC_READ_ERROR_FLAG;
case 264:return ETH_DMA_TX_DESC_WRITE_ERROR_FLAG;
case 265:return ETH_DMA_TX_BUFFER_READ_ERROR_FLAG;
case 266:return ETH_DMA_TX_BUFFER_WRITE_ERROR_FLAG;
case 267:return ETH_DMA_CONTEXT_DESC_ERROR_FLAG;
case 268:return ETH_DMA_FATAL_BUS_ERROR_FLAG;
case 269:return ETH_DMA_EARLY_TX_IT_FLAG;
case 270:return ETH_DMA_RX_WATCHDOG_TIMEOUT_FLAG;
case 271:return ETH_DMA_RX_PROCESS_STOPPED_FLAG;
case 272:return ETH_DMA_RX_BUFFER_UNAVAILABLE_FLAG;
case 273:return ETH_DMA_TX_PROCESS_STOPPED_FLAG;
case 274:return ETH_TRANSMITSTOREFORWARD;
case 275:return ETH_TRANSMITTHRESHOLD_32;
case 276:return ETH_TRANSMITTHRESHOLD_64;
case 277:return ETH_TRANSMITTHRESHOLD_96;
case 278:return ETH_TRANSMITTHRESHOLD_128;
case 279:return ETH_TRANSMITTHRESHOLD_192;
case 280:return ETH_TRANSMITTHRESHOLD_256;
case 281:return ETH_TRANSMITTHRESHOLD_384;
case 282:return ETH_TRANSMITTHRESHOLD_512;
case 283:return ETH_RECEIVESTOREFORWARD;
case 284:return ETH_RECEIVETHRESHOLD8_64;
case 285:return ETH_RECEIVETHRESHOLD8_32;
case 286:return ETH_RECEIVETHRESHOLD8_96;
case 287:return ETH_RECEIVETHRESHOLD8_128;
case 288:return ETH_PAUSELOWTHRESHOLD_MINUS_4;
case 289:return ETH_PAUSELOWTHRESHOLD_MINUS_28;
case 290:return ETH_PAUSELOWTHRESHOLD_MINUS_36;
case 291:return ETH_PAUSELOWTHRESHOLD_MINUS_144;
case 292:return ETH_PAUSELOWTHRESHOLD_MINUS_256;
case 293:return ETH_PAUSELOWTHRESHOLD_MINUS_512;
case 294:return ETH_WATCHDOGTIMEOUT_2KB;
case 295:return ETH_WATCHDOGTIMEOUT_3KB;
case 296:return ETH_WATCHDOGTIMEOUT_4KB;
case 297:return ETH_WATCHDOGTIMEOUT_5KB;
case 298:return ETH_WATCHDOGTIMEOUT_6KB;
case 299:return ETH_WATCHDOGTIMEOUT_7KB;
case 300:return ETH_WATCHDOGTIMEOUT_8KB;
case 301:return ETH_WATCHDOGTIMEOUT_9KB;
case 302:return ETH_WATCHDOGTIMEOUT_10KB;
case 303:return ETH_WATCHDOGTIMEOUT_11KB;
case 304:return ETH_WATCHDOGTIMEOUT_12KB;
case 305:return ETH_WATCHDOGTIMEOUT_13KB;
case 306:return ETH_WATCHDOGTIMEOUT_14KB;
case 307:return ETH_WATCHDOGTIMEOUT_15KB;
case 308:return ETH_WATCHDOGTIMEOUT_16KB;
case 309:return ETH_INTERPACKETGAP_96BIT;
case 310:return ETH_INTERPACKETGAP_88BIT;
case 311:return ETH_INTERPACKETGAP_80BIT;
case 312:return ETH_INTERPACKETGAP_72BIT;
case 313:return ETH_INTERPACKETGAP_64BIT;
case 314:return ETH_INTERPACKETGAP_56BIT;
case 315:return ETH_INTERPACKETGAP_48BIT;
case 316:return ETH_INTERPACKETGAP_40BIT;
case 317:return ETH_SPEED_10M;
case 318:return ETH_SPEED_100M;
case 319:return ETH_FULLDUPLEX_MODE;
case 320:return ETH_HALFDUPLEX_MODE;
case 321:return ETH_BACKOFFLIMIT_10;
case 322:return ETH_BACKOFFLIMIT_8;
case 323:return ETH_BACKOFFLIMIT_4;
case 324:return ETH_BACKOFFLIMIT_1;
case 325:return ETH_PREAMBLELENGTH_7;
case 326:return ETH_PREAMBLELENGTH_5;
case 327:return ETH_PREAMBLELENGTH_3;
case 328:return ETH_SOURCEADDRESS_DISABLE;
case 329:return ETH_SOURCEADDRESS_INSERT_ADDR0;
case 330:return ETH_SOURCEADDRESS_INSERT_ADDR1;
case 331:return ETH_SOURCEADDRESS_REPLACE_ADDR0;
case 332:return ETH_SOURCEADDRESS_REPLACE_ADDR1;
case 333:return ETH_CTRLPACKETS_BLOCK_ALL;
case 334:return ETH_CTRLPACKETS_FORWARD_ALL_EXCEPT_PA;
case 335:return ETH_CTRLPACKETS_FORWARD_ALL;
case 336:return ETH_CTRLPACKETS_FORWARD_PASSED_ADDR_FILTER;
case 337:return ETH_VLANTAGCOMPARISON_16BIT;
case 338:return ETH_VLANTAGCOMPARISON_12BIT;
case 339:return ETH_MAC_ADDRESS0;
case 340:return ETH_MAC_ADDRESS1;
case 341:return ETH_MAC_ADDRESS2;
case 342:return ETH_MAC_ADDRESS3;
case 343:return ETH_MAC_RX_STATUS_IT;
case 344:return ETH_MAC_TX_STATUS_IT;
case 345:return ETH_MAC_TIMESTAMP_IT;
case 346:return ETH_MAC_LPI_IT;
case 347:return ETH_MAC_PMT_IT;
case 348:return ETH_MAC_PHY_IT;
case 349:return ETH_WAKEUP_PACKET_RECIEVED;
case 350:return ETH_MAGIC_PACKET_RECIEVED;
case 351:return ETH_RECEIVE_WATCHDOG_TIMEOUT;
case 352:return ETH_EXECESSIVE_COLLISIONS;
case 353:return ETH_LATE_COLLISIONS;
case 354:return ETH_EXECESSIVE_DEFERRAL;
case 355:return ETH_LOSS_OF_CARRIER;
case 356:return ETH_NO_CARRIER;
case 357:return ETH_TRANSMIT_JABBR_TIMEOUT;
case 358:return HAL_ETH_STATE_RESET;
case 359:return HAL_ETH_STATE_READY;
case 360:return HAL_ETH_STATE_BUSY;
case 361:return HAL_ETH_STATE_STARTED;
case 362:return HAL_ETH_STATE_ERROR;
case 363:return HAL_ETH_PTP_NOT_CONFIGURED;
case 364:return HAL_ETH_PTP_CONFIGURED;
case 365:return ETH_WAKEUP_EXTI_LINE;
case 366:return ETH_TX_LPI_ENTRY;
case 367:return ETH_TX_LPI_EXIT;
case 368:return ETH_RX_LPI_ENTRY;
case 369:return ETH_RX_LPI_EXIT;
case 370:return ETH_L3_FILTER_0;
case 371:return ETH_L3_FILTER_1;
case 372:return ETH_L4_FILTER_0;
case 373:return ETH_L4_FILTER_1;
case 374:return ETH_L3_IPV6_MATCH;
case 375:return ETH_L3_IPV4_MATCH;
case 376:return ETH_L3_SRC_ADDR_PERFECT_MATCH_ENABLE;
case 377:return ETH_L3_SRC_ADDR_INVERSE_MATCH_ENABLE;
case 378:return ETH_L3_SRC_ADDR_MATCH_DISABLE;
case 379:return ETH_L3_DEST_ADDR_PERFECT_MATCH_ENABLE;
case 380:return ETH_L3_DEST_ADDR_INVERSE_MATCH_ENABLE;
case 381:return ETH_L3_DEST_ADDR_MATCH_DISABLE;
case 382:return ETH_L4_UDP_MATCH;
case 383:return ETH_L4_TCP_MATCH;
case 384:return ETH_L4_SRC_PORT_PERFECT_MATCH_ENABLE;
case 385:return ETH_L4_SRC_PORT_INVERSE_MATCH_ENABLE;
case 386:return ETH_L4_SRC_PORT_MATCH_DISABLE;
case 387:return ETH_L4_DEST_PORT_PERFECT_MATCH_ENABLE;
case 388:return ETH_L4_DEST_PORT_INVERSE_MATCH_ENABLE;
case 389:return ETH_L4_DEST_PORT_MATCH_DISABLE;
case 390:return ETH_INNERVLANTAGRXSTRIPPING_NONE;
case 391:return ETH_INNERVLANTAGRXSTRIPPING_IFPASS;
case 392:return ETH_INNERVLANTAGRXSTRIPPING_IFFAILS;
case 393:return ETH_INNERVLANTAGRXSTRIPPING_ALWAYS;
case 394:return ETH_VLANTAGRXSTRIPPING_NONE;
case 395:return ETH_VLANTAGRXSTRIPPING_IFPASS;
case 396:return ETH_VLANTAGRXSTRIPPING_IFFAILS;
case 397:return ETH_VLANTAGRXSTRIPPING_ALWAYS;
case 398:return ETH_VLANTYPECHECK_DISABLE;
case 399:return ETH_VLANTYPECHECK_SVLAN;
case 400:return ETH_VLANTYPECHECK_CVLAN;
case 401:return ETH_VLANTAGCONTROL_NONE;
case 402:return ETH_VLANTAGCONTROL_DELETE;
case 403:return ETH_VLANTAGCONTROL_INSERT;
case 404:return ETH_VLANTAGCONTROL_REPLACE;
case 405:return ETH_INNER_TX_VLANTAG;
case 406:return ETH_OUTER_TX_VLANTAG;
default:assert(0);return 0;}}

uint32_t *CETH_Buffer(CETHState *s,uint32_t index){assert(index<16);return s->buffers[index];}
uint32_t CETH_HCLKFor(CETHState *s){CETH_Active=s;return CETH_HCLK();}

void CETH_WriteGlobal(CETHState *s,uint32_t o,uint32_t v){assert((o&3)==0&&o<sizeof(s->globalRegisters));if(s->control[9])*(volatile uint32_t *)((uint8_t *)&s->globalRegisters+o)=v;else CETH_SetRegister(s,o,v);}
uint32_t CETH_ReadGlobal(CETHState *s,uint32_t o){assert((o&3)==0&&o<sizeof(s->globalRegisters));return *(volatile uint32_t *)((uint8_t *)&s->globalRegisters+o);}
void CETH_Event(CETHState *s,uint32_t i,uint32_t due,uint32_t o,uint32_t v){assert(i<32);s->events[i][0]=1;s->events[i][1]=due;s->events[i][2]=o;s->events[i][3]=v;}

static void CETH_CB0_2(ETH_HandleTypeDef *h){invoke((CETHState *)h,0,2);}

static void CETH_CB1_2(ETH_HandleTypeDef *h){invoke((CETHState *)h,1,2);}

static void CETH_CB2_2(ETH_HandleTypeDef *h){invoke((CETHState *)h,2,2);}

static void CETH_CB3_2(ETH_HandleTypeDef *h){invoke((CETHState *)h,3,2);}

static void CETH_CB4_2(ETH_HandleTypeDef *h){invoke((CETHState *)h,4,2);}

static void CETH_CB6_2(ETH_HandleTypeDef *h){invoke((CETHState *)h,6,2);}

static void CETH_CB7_2(ETH_HandleTypeDef *h){invoke((CETHState *)h,7,2);}

static void CETH_CB8_2(ETH_HandleTypeDef *h){invoke((CETHState *)h,8,2);}
static void CETH_CB9_2(uint8_t **buff){allocate(CETH_Active,buff,2);}
static void CETH_CB10_2(void **start,void **end,uint8_t *buff,uint16_t length){if(!*start)*start=buff;*end=buff;trace(CETH_Active,10,length);}
static void CETH_CB11_2(uint32_t *buff){CETH_Active->control[24]=CETH_Normalize(CETH_Active,(uintptr_t)buff);trace(CETH_Active,11,2);}
static void CETH_CB12_2(uint32_t *buff,ETH_TimeStampTypeDef *ts){(void)buff;trace(CETH_Active,12,ts->TimeStampLow);}
void *CETH_Callback(uint32_t id,uint32_t token){if(!token)return NULL;assert(token<=2);switch(id){
case 0:return token==1?(void *)HAL_ETH_MspInit:(void *)CETH_CB0_2;
case 1:return token==1?(void *)HAL_ETH_MspDeInit:(void *)CETH_CB1_2;
case 2:return token==1?(void *)HAL_ETH_TxCpltCallback:(void *)CETH_CB2_2;
case 3:return token==1?(void *)HAL_ETH_RxCpltCallback:(void *)CETH_CB3_2;
case 4:return token==1?(void *)HAL_ETH_ErrorCallback:(void *)CETH_CB4_2;
case 6:return token==1?(void *)HAL_ETH_PMTCallback:(void *)CETH_CB6_2;
case 7:return token==1?(void *)HAL_ETH_EEECallback:(void *)CETH_CB7_2;
case 8:return token==1?(void *)HAL_ETH_WakeUpCallback:(void *)CETH_CB8_2;
case 9:return token==1?(void *)HAL_ETH_RxAllocateCallback:(void *)CETH_CB9_2;
case 10:return token==1?(void *)HAL_ETH_RxLinkCallback:(void *)CETH_CB10_2;
case 11:return token==1?(void *)HAL_ETH_TxFreeCallback:(void *)CETH_CB11_2;
case 12:return token==1?(void *)HAL_ETH_TxPtpCallback:(void *)CETH_CB12_2;
default:assert(0);return NULL;}}
void *CETH_GetCallback(CETHState *s,uint32_t id){switch(id){
case 0:return (void *)s->h.MspInitCallback;
case 1:return (void *)s->h.MspDeInitCallback;
case 2:return (void *)s->h.TxCpltCallback;
case 3:return (void *)s->h.RxCpltCallback;
case 4:return (void *)s->h.ErrorCallback;
case 6:return (void *)s->h.PMTCallback;
case 7:return (void *)s->h.EEECallback;
case 8:return (void *)s->h.WakeUpCallback;
case 9:return (void *)s->h.rxAllocateCallback;
case 10:return (void *)s->h.rxLinkCallback;
case 11:return (void *)s->h.txFreeCallback;
case 12:return (void *)s->h.txPtpCallback;
default:assert(0);return NULL;}}
void CETH_SetCallback(CETHState *s,uint32_t id,void *value){switch(id){
case 0:s->h.MspInitCallback=value;break;
case 1:s->h.MspDeInitCallback=value;break;
case 2:s->h.TxCpltCallback=value;break;
case 3:s->h.RxCpltCallback=value;break;
case 4:s->h.ErrorCallback=value;break;
case 6:s->h.PMTCallback=value;break;
case 7:s->h.EEECallback=value;break;
case 8:s->h.WakeUpCallback=value;break;
case 9:s->h.rxAllocateCallback=value;break;
case 10:s->h.rxLinkCallback=value;break;
case 11:s->h.txFreeCallback=value;break;
case 12:s->h.txPtpCallback=value;break;
default:assert(0);}}
void CETH_Activate(CETHState *s){CETH_Active=s;}
uint32_t CETH_GetEXTI(CETHState *s,uint32_t i){assert(i<5);return s->exti[i];}
void CETH_SetEXTI(CETHState *s,uint32_t i,uint32_t v){assert(i<5);s->exti[i]=v;}
uint32_t CETH_Platform(CETHState *s,uint32_t op,uint32_t a){CETH_Active=s;switch(op){
case 0:CETH_EnableSBS();return 0;
case 1:CETH_ConfigurePHY(a);s->control[17]=CETH_SBS.PMCR;return 0;
case 2:return s->control[17];
case 3:CETH_Barrier(100);return 0;
case 4:CETH_Barrier(101);return 0;
case 5:return s->control[6];
case 6:CETH_SetMask(a);return 0;
default:assert(0);return 0;}}
uint32_t CETH_Run(CETHState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){
 CETH_SBS.PMCR=s->control[17];CETH_EXTI.IMR2=s->exti[0];CETH_EXTI.PR2=s->exti[1];CETH_EXTI.FTSR2=s->exti[2];CETH_EXTI.RTSR2=s->exti[3];CETH_EXTI.SWIER2=s->exti[4];
 uint32_t result=dispatch(s,op,a,b,c);
 s->control[17]=CETH_SBS.PMCR;s->exti[0]=CETH_EXTI.IMR2;s->exti[1]=CETH_EXTI.PR2;s->exti[2]=CETH_EXTI.FTSR2;s->exti[3]=CETH_EXTI.RTSR2;s->exti[4]=CETH_EXTI.SWIER2;return result;
}
uint32_t CETH_GetPacketWord(CETHState *s,uint32_t i){switch(i){case 0:return s->packet.Attributes;case 1:return s->packet.Length;case 2:return s->packet.SrcAddrCtrl;case 3:return s->packet.CRCPadCtrl;case 4:return s->packet.ChecksumCtrl;case 5:return s->packet.MaxSegmentSize;case 6:return s->packet.PayloadLen;case 7:return s->packet.TCPHeaderLen;case 8:return s->packet.VlanTag;case 9:return s->packet.VlanCtrl;case 10:return s->packet.InnerVlanTag;case 11:return s->packet.InnerVlanCtrl;default:assert(0);return 0;}}
void CETH_SetPacketWord(CETHState *s,uint32_t i,uint32_t v){switch(i){case 0:s->packet.Attributes=v;break;case 1:s->packet.Length=v;break;case 2:s->packet.SrcAddrCtrl=v;break;case 3:s->packet.CRCPadCtrl=v;break;case 4:s->packet.ChecksumCtrl=v;break;case 5:s->packet.MaxSegmentSize=v;break;case 6:s->packet.PayloadLen=v;break;case 7:s->packet.TCPHeaderLen=v;break;case 8:s->packet.VlanTag=v;break;case 9:s->packet.VlanCtrl=v;break;case 10:s->packet.InnerVlanTag=v;break;case 11:s->packet.InnerVlanCtrl=v;break;default:assert(0);}}
void *CETH_PacketBuffer(CETHState *s){return s->packet.TxBuffer;}
void *CETH_PacketData(CETHState *s){return s->packet.pData;}
uint32_t CETH_Normalize(CETHState *s,uintptr_t value){uintptr_t start=(uintptr_t)s;if(value>=start&&value<start+sizeof(*s))return 0x20000000U+(uint32_t)(value-start);return (uint32_t)value;}
uint32_t CETH_Layout(uint32_t i){switch(i){case 0:return sizeof(ETH_BufferTypeDef);case 1:return offsetof(ETH_BufferTypeDef,buffer);case 2:return offsetof(ETH_BufferTypeDef,len);case 3:return offsetof(ETH_BufferTypeDef,next);case 4:return sizeof(ETH_DMADescTypeDef);default:assert(0);return 0;}}
void CETH_SetPacketData(CETHState *s,void *p){s->packet.pData=p;}
