#include "include/CLLSPIReference.h"
#include <stdlib.h>
#include <assert.h>
#include "Upstream/SPI/RCCNamespace.h"
#include "Upstream/SPI/Trace/stm32h7rsxx_ll_rcc.h"
#include "Upstream/SPI/Trace/stm32h7rsxx_ll_rcc.inc"
#include "Upstream/SPI/Trace/stm32h7rsxx_ll_spi.h"
#include "Upstream/SPI/Trace/stm32h7rsxx_ll_spi.inc"
struct CL55State {uint32_t cells[1024],count,reads,salt,instance,failures,mode;CL55Access trace[512];};
_Thread_local uint32_t *CL55_Cells;
static _Thread_local CL55State *current;
CL55State *CL55_Create(void){return calloc(1,sizeof(CL55State));}
void CL55_Destroy(CL55State *s){free(s);}
void CL55_Reset(CL55State *s,uint32_t seed,uint32_t salt,uint32_t instance,uint32_t failures,uint32_t mode){
 current=s;CL55_Cells=s->cells;
 for(uint32_t i=0;i<1024;i++)s->cells[i]=seed^(i*0x9E3779B9U);
 for(uint32_t i=256;i<512;i++)s->cells[i]=0;
 s->cells[256]=(mode&256U?0U:0x2a020124)|(((mode>>6U)&3U)<<3U);
 s->cells[260]=((mode>>4U)&3U)<<3U;
 s->cells[266]=(6U<<4U)|(6U<<12U)|(6U<<20U);s->cells[267]=0xFFFFFFFFU;
 s->cells[268]=s->cells[270]=s->cells[272]=47U|(7U<<9U)|(3U<<16U)|(3U<<24U);
 s->cells[275]=((mode>>10U)&3U)<<28U;s->cells[276]=(mode&7U)<<4U;s->cells[277]=(mode&7U)<<8U;s->cells[278]=(mode&7U)<<4U;
 s->cells[284]=(mode&256U)?0U:RCC_BDCR_LSERDY;
 s->count=0;s->reads=0;s->salt=salt;s->instance=instance;s->failures=failures;s->mode=mode;
}
static void record(uint32_t index,uint32_t value,uint32_t kind){assert(index<1024 && current->count<512);current->trace[current->count++]=(CL55Access){index,value,kind};}
static uint32_t indexOf(volatile const uint32_t *p){uintptr_t d=(uintptr_t)p-(uintptr_t)CL55_Cells;assert(d<4096 && d%4==0);return (uint32_t)d/4;}
uint32_t CL55_Read(volatile const uint32_t *p){uint32_t i=indexOf(p),v=*p ^ (i<256U?current->salt*current->reads:0U);current->reads++;record(i,v,0);return v;}
void CL55_Write(volatile uint32_t *p,uint32_t v){record(indexOf(p),v,1);*p=v;}
uint32_t CL55_ReadN(volatile const void *p,uint32_t width){
 uint32_t i=indexOf((volatile const uint32_t *)p),v=width==8?*(volatile const uint8_t *)p:width==16?*(volatile const uint16_t *)p:*(volatile const uint32_t *)p;
 v^=current->salt*current->reads++;if(width<32)v&=(1U<<width)-1U;record(i,v,width==8?2:width==16?4:0);return v;
}
void CL55_WriteN(volatile void *p,uint32_t v,uint32_t width){
 uint32_t i=indexOf((volatile const uint32_t *)p);if(width<32)v&=(1U<<width)-1U;record(i,v,width==8?3:width==16?5:1);
 if(width==8)*(volatile uint8_t *)p=(uint8_t)v;else if(width==16)*(volatile uint16_t *)p=(uint16_t)v;else *(volatile uint32_t *)p=v;
}
uint32_t CL55_Address(volatile const uint32_t *p){static const uint32_t bases[6]={0x42003000U,0x40003800U,0x40003C00U,0x42003400U,0x42005000U,0x58001400U};uint32_t i=indexOf(p);assert(i<192);return bases[i/32]+(i%32)*4;}
uint32_t CL55_Oscillator(uint32_t i){static const uint32_t v[7]={64000000,4000000,24000000,32768,32000,48000000,12288000};assert(i<7);return v[i]+(current->mode&512U?17U:0U);}
uint32_t *CL55_GetCells(CL55State *s){return s->cells;}
const CL55Access *CL55_GetTrace(CL55State *s){return s->trace;}
uint32_t CL55_GetTraceCount(CL55State *s){return s->count;}
uint32_t CL55_Run(CL55State *s,uint32_t op,const uint32_t *args){current=s;CL55_Cells=s->cells;SPI_TypeDef *uart=(SPI_TypeDef *)(s->cells+s->instance*32);
 switch(op){
 case 0: { LL_SPI_Enable(uart); return 0; }
 case 1: { LL_SPI_Disable(uart); return 0; }
 case 2: { uint32_t result=LL_SPI_IsEnabled(uart); return result; }
 case 3: { LL_SPI_EnableIOSwap(uart); return 0; }
 case 4: { LL_SPI_DisableIOSwap(uart); return 0; }
 case 5: { uint32_t result=LL_SPI_IsEnabledIOSwap(uart); return result; }
 case 6: { LL_SPI_EnableGPIOControl(uart); return 0; }
 case 7: { LL_SPI_DisableGPIOControl(uart); return 0; }
 case 8: { uint32_t result=LL_SPI_IsEnabledGPIOControl(uart); return result; }
 case 9: { LL_SPI_SetMode(uart, (uint32_t)args[0]); return 0; }
 case 10: { uint32_t result=LL_SPI_GetMode(uart); return result; }
 case 11: { LL_SPI_SetMasterSSIdleness(uart, (uint32_t)args[0]); return 0; }
 case 12: { uint32_t result=LL_SPI_GetMasterSSIdleness(uart); return result; }
 case 13: { LL_SPI_SetInterDataIdleness(uart, (uint32_t)args[0]); return 0; }
 case 14: { uint32_t result=LL_SPI_GetInterDataIdleness(uart); return result; }
 case 15: { LL_SPI_SetTransferSize(uart, (uint32_t)args[0]); return 0; }
 case 16: { uint32_t result=LL_SPI_GetTransferSize(uart); return result; }
 case 17: { LL_SPI_EnableIOLock(uart); return 0; }
 case 18: { uint32_t result=LL_SPI_IsEnabledIOLock(uart); return result; }
 case 19: { LL_SPI_SetTxCRCInitPattern(uart, (uint32_t)args[0]); return 0; }
 case 20: { uint32_t result=LL_SPI_GetTxCRCInitPattern(uart); return result; }
 case 21: { LL_SPI_SetRxCRCInitPattern(uart, (uint32_t)args[0]); return 0; }
 case 22: { uint32_t result=LL_SPI_GetRxCRCInitPattern(uart); return result; }
 case 23: { LL_SPI_SetInternalSSLevel(uart, (uint32_t)args[0]); return 0; }
 case 24: { uint32_t result=LL_SPI_GetInternalSSLevel(uart); return result; }
 case 25: { LL_SPI_EnableFullSizeCRC(uart); return 0; }
 case 26: { LL_SPI_DisableFullSizeCRC(uart); return 0; }
 case 27: { uint32_t result=LL_SPI_IsEnabledFullSizeCRC(uart); return result; }
 case 28: { LL_SPI_SuspendMasterTransfer(uart); return 0; }
 case 29: { LL_SPI_StartMasterTransfer(uart); return 0; }
 case 30: { uint32_t result=LL_SPI_IsActiveMasterTransfer(uart); return result; }
 case 31: { LL_SPI_EnableMasterRxAutoSuspend(uart); return 0; }
 case 32: { LL_SPI_DisableMasterRxAutoSuspend(uart); return 0; }
 case 33: { uint32_t result=LL_SPI_IsEnabledMasterRxAutoSuspend(uart); return result; }
 case 34: { LL_SPI_SetUDRConfiguration(uart, (uint32_t)args[0]); return 0; }
 case 35: { uint32_t result=LL_SPI_GetUDRConfiguration(uart); return result; }
 case 36: { LL_SPI_SetStandard(uart, (uint32_t)args[0]); return 0; }
 case 37: { uint32_t result=LL_SPI_GetStandard(uart); return result; }
 case 38: { LL_SPI_SetClockPhase(uart, (uint32_t)args[0]); return 0; }
 case 39: { uint32_t result=LL_SPI_GetClockPhase(uart); return result; }
 case 40: { LL_SPI_SetClockPolarity(uart, (uint32_t)args[0]); return 0; }
 case 41: { uint32_t result=LL_SPI_GetClockPolarity(uart); return result; }
 case 42: { LL_SPI_SetNSSPolarity(uart, (uint32_t)args[0]); return 0; }
 case 43: { uint32_t result=LL_SPI_GetNSSPolarity(uart); return result; }
 case 44: { LL_SPI_SetBaudRatePrescaler(uart, (uint32_t)args[0]); return 0; }
 case 45: { uint32_t result=LL_SPI_GetBaudRatePrescaler(uart); return result; }
 case 46: { LL_SPI_SetTransferBitOrder(uart, (uint32_t)args[0]); return 0; }
 case 47: { uint32_t result=LL_SPI_GetTransferBitOrder(uart); return result; }
 case 48: { LL_SPI_SetTransferDirection(uart, (uint32_t)args[0]); return 0; }
 case 49: { uint32_t result=LL_SPI_GetTransferDirection(uart); return result; }
 case 50: { LL_SPI_SetHalfDuplexDirection(uart, (uint32_t)args[0]); return 0; }
 case 51: { uint32_t result=LL_SPI_GetHalfDuplexDirection(uart); return result; }
 case 52: { LL_SPI_SetDataWidth(uart, (uint32_t)args[0]); return 0; }
 case 53: { uint32_t result=LL_SPI_GetDataWidth(uart); return result; }
 case 54: { LL_SPI_SetFIFOThreshold(uart, (uint32_t)args[0]); return 0; }
 case 55: { uint32_t result=LL_SPI_GetFIFOThreshold(uart); return result; }
 case 56: { LL_SPI_EnableCRC(uart); return 0; }
 case 57: { LL_SPI_DisableCRC(uart); return 0; }
 case 58: { uint32_t result=LL_SPI_IsEnabledCRC(uart); return result; }
 case 59: { LL_SPI_SetCRCWidth(uart, (uint32_t)args[0]); return 0; }
 case 60: { uint32_t result=LL_SPI_GetCRCWidth(uart); return result; }
 case 61: { LL_SPI_SetNSSMode(uart, (uint32_t)args[0]); return 0; }
 case 62: { uint32_t result=LL_SPI_GetNSSMode(uart); return result; }
 case 63: { LL_SPI_EnableNSSPulseMgt(uart); return 0; }
 case 64: { LL_SPI_DisableNSSPulseMgt(uart); return 0; }
 case 65: { uint32_t result=LL_SPI_IsEnabledNSSPulse(uart); return result; }
 case 66: { uint32_t result=LL_SPI_IsActiveFlag_RXP(uart); return result; }
 case 67: { uint32_t result=LL_SPI_IsActiveFlag_TXP(uart); return result; }
 case 68: { uint32_t result=LL_SPI_IsActiveFlag_DXP(uart); return result; }
 case 69: { uint32_t result=LL_SPI_IsActiveFlag_EOT(uart); return result; }
 case 70: { uint32_t result=LL_SPI_IsActiveFlag_TXTF(uart); return result; }
 case 71: { uint32_t result=LL_SPI_IsActiveFlag_UDR(uart); return result; }
 case 72: { uint32_t result=LL_SPI_IsActiveFlag_CRCERR(uart); return result; }
 case 73: { uint32_t result=LL_SPI_IsActiveFlag_MODF(uart); return result; }
 case 74: { uint32_t result=LL_SPI_IsActiveFlag_OVR(uart); return result; }
 case 75: { uint32_t result=LL_SPI_IsActiveFlag_FRE(uart); return result; }
 case 76: { uint32_t result=LL_SPI_IsActiveFlag_SUSP(uart); return result; }
 case 77: { uint32_t result=LL_SPI_IsActiveFlag_TXC(uart); return result; }
 case 78: { uint32_t result=LL_SPI_IsActiveFlag_RXWNE(uart); return result; }
 case 79: { uint32_t result=LL_SPI_GetRemainingDataFrames(uart); return result; }
 case 80: { uint32_t result=LL_SPI_GetRxFIFOPackingLevel(uart); return result; }
 case 81: { LL_SPI_ClearFlag_EOT(uart); return 0; }
 case 82: { LL_SPI_ClearFlag_TXTF(uart); return 0; }
 case 83: { LL_SPI_ClearFlag_UDR(uart); return 0; }
 case 84: { LL_SPI_ClearFlag_OVR(uart); return 0; }
 case 85: { LL_SPI_ClearFlag_CRCERR(uart); return 0; }
 case 86: { LL_SPI_ClearFlag_MODF(uart); return 0; }
 case 87: { LL_SPI_ClearFlag_FRE(uart); return 0; }
 case 88: { LL_SPI_ClearFlag_SUSP(uart); return 0; }
 case 89: { LL_SPI_EnableIT_RXP(uart); return 0; }
 case 90: { LL_SPI_EnableIT_TXP(uart); return 0; }
 case 91: { LL_SPI_EnableIT_DXP(uart); return 0; }
 case 92: { LL_SPI_EnableIT_EOT(uart); return 0; }
 case 93: { LL_SPI_EnableIT_TXTF(uart); return 0; }
 case 94: { LL_SPI_EnableIT_UDR(uart); return 0; }
 case 95: { LL_SPI_EnableIT_OVR(uart); return 0; }
 case 96: { LL_SPI_EnableIT_CRCERR(uart); return 0; }
 case 97: { LL_SPI_EnableIT_FRE(uart); return 0; }
 case 98: { LL_SPI_EnableIT_MODF(uart); return 0; }
 case 99: { LL_SPI_DisableIT_RXP(uart); return 0; }
 case 100: { LL_SPI_DisableIT_TXP(uart); return 0; }
 case 101: { LL_SPI_DisableIT_DXP(uart); return 0; }
 case 102: { LL_SPI_DisableIT_EOT(uart); return 0; }
 case 103: { LL_SPI_DisableIT_TXTF(uart); return 0; }
 case 104: { LL_SPI_DisableIT_UDR(uart); return 0; }
 case 105: { LL_SPI_DisableIT_OVR(uart); return 0; }
 case 106: { LL_SPI_DisableIT_CRCERR(uart); return 0; }
 case 107: { LL_SPI_DisableIT_FRE(uart); return 0; }
 case 108: { LL_SPI_DisableIT_MODF(uart); return 0; }
 case 109: { uint32_t result=LL_SPI_IsEnabledIT_RXP(uart); return result; }
 case 110: { uint32_t result=LL_SPI_IsEnabledIT_TXP(uart); return result; }
 case 111: { uint32_t result=LL_SPI_IsEnabledIT_DXP(uart); return result; }
 case 112: { uint32_t result=LL_SPI_IsEnabledIT_EOT(uart); return result; }
 case 113: { uint32_t result=LL_SPI_IsEnabledIT_TXTF(uart); return result; }
 case 114: { uint32_t result=LL_SPI_IsEnabledIT_UDR(uart); return result; }
 case 115: { uint32_t result=LL_SPI_IsEnabledIT_OVR(uart); return result; }
 case 116: { uint32_t result=LL_SPI_IsEnabledIT_CRCERR(uart); return result; }
 case 117: { uint32_t result=LL_SPI_IsEnabledIT_FRE(uart); return result; }
 case 118: { uint32_t result=LL_SPI_IsEnabledIT_MODF(uart); return result; }
 case 119: { LL_SPI_EnableDMAReq_RX(uart); return 0; }
 case 120: { LL_SPI_DisableDMAReq_RX(uart); return 0; }
 case 121: { uint32_t result=LL_SPI_IsEnabledDMAReq_RX(uart); return result; }
 case 122: { LL_SPI_EnableDMAReq_TX(uart); return 0; }
 case 123: { LL_SPI_DisableDMAReq_TX(uart); return 0; }
 case 124: { uint32_t result=LL_SPI_IsEnabledDMAReq_TX(uart); return result; }
 case 125: { uint32_t result=LL_SPI_DMA_GetTxRegAddr(uart); return result; }
 case 126: { uint32_t result=LL_SPI_DMA_GetRxRegAddr(uart); return result; }
 case 127: { uint32_t result=LL_SPI_ReceiveData8(uart); return result; }
 case 128: { uint32_t result=LL_SPI_ReceiveData16(uart); return result; }
 case 129: { uint32_t result=LL_SPI_ReceiveData32(uart); return result; }
 case 130: { LL_SPI_TransmitData8(uart, (uint8_t)args[0]); return 0; }
 case 131: { LL_SPI_TransmitData16(uart, (uint16_t)args[0]); return 0; }
 case 132: { LL_SPI_TransmitData32(uart, (uint32_t)args[0]); return 0; }
 case 133: { LL_SPI_SetCRCPolynomial(uart, (uint32_t)args[0]); return 0; }
 case 134: { uint32_t result=LL_SPI_GetCRCPolynomial(uart); return result; }
 case 135: { LL_SPI_SetUDRPattern(uart, (uint32_t)args[0]); return 0; }
 case 136: { uint32_t result=LL_SPI_GetUDRPattern(uart); return result; }
 case 137: { uint32_t result=LL_SPI_GetRxCRC(uart); return result; }
 case 138: { uint32_t result=LL_SPI_GetTxCRC(uart); return result; }
 case 139: { LL_I2S_SetDataFormat(uart, (uint32_t)args[0]); return 0; }
 case 140: { uint32_t result=LL_I2S_GetDataFormat(uart); return result; }
 case 141: { LL_I2S_SetChannelLengthType(uart, (uint32_t)args[0]); return 0; }
 case 142: { uint32_t result=LL_I2S_GetChannelLengthType(uart); return result; }
 case 143: { LL_I2S_EnableWordSelectInversion(uart); return 0; }
 case 144: { LL_I2S_DisableWordSelectInversion(uart); return 0; }
 case 145: { uint32_t result=LL_I2S_IsEnabledWordSelectInversion(uart); return result; }
 case 146: { LL_I2S_SetClockPolarity(uart, (uint32_t)args[0]); return 0; }
 case 147: { uint32_t result=LL_I2S_GetClockPolarity(uart); return result; }
 case 148: { LL_I2S_SetStandard(uart, (uint32_t)args[0]); return 0; }
 case 149: { uint32_t result=LL_I2S_GetStandard(uart); return result; }
 case 150: { LL_I2S_SetTransferMode(uart, (uint32_t)args[0]); return 0; }
 case 151: { uint32_t result=LL_I2S_GetTransferMode(uart); return result; }
 case 152: { LL_I2S_Enable(uart); return 0; }
 case 153: { LL_I2S_Disable(uart); return 0; }
 case 154: { LL_I2S_EnableIOSwap(uart); return 0; }
 case 155: { LL_I2S_DisableIOSwap(uart); return 0; }
 case 156: { uint32_t result=LL_I2S_IsEnabledIOSwap(uart); return result; }
 case 157: { LL_I2S_EnableGPIOControl(uart); return 0; }
 case 158: { LL_I2S_DisableGPIOControl(uart); return 0; }
 case 159: { uint32_t result=LL_I2S_IsEnabledGPIOControl(uart); return result; }
 case 160: { LL_I2S_EnableIOLock(uart); return 0; }
 case 161: { uint32_t result=LL_I2S_IsEnabledIOLock(uart); return result; }
 case 162: { LL_I2S_SetTransferBitOrder(uart, (uint32_t)args[0]); return 0; }
 case 163: { uint32_t result=LL_I2S_GetTransferBitOrder(uart); return result; }
 case 164: { LL_I2S_StartTransfer(uart); return 0; }
 case 165: { uint32_t result=LL_I2S_IsActiveTransfer(uart); return result; }
 case 166: { LL_I2S_SetFIFOThreshold(uart, (uint32_t)args[0]); return 0; }
 case 167: { uint32_t result=LL_I2S_GetFIFOThreshold(uart); return result; }
 case 168: { LL_I2S_SetPrescalerLinear(uart, (uint32_t)args[0]); return 0; }
 case 169: { uint32_t result=LL_I2S_GetPrescalerLinear(uart); return result; }
 case 170: { LL_I2S_SetPrescalerParity(uart, (uint32_t)args[0]); return 0; }
 case 171: { uint32_t result=LL_I2S_GetPrescalerParity(uart); return result; }
 case 172: { LL_I2S_EnableMasterClock(uart); return 0; }
 case 173: { LL_I2S_DisableMasterClock(uart); return 0; }
 case 174: { uint32_t result=LL_I2S_IsEnabledMasterClock(uart); return result; }
 case 175: { uint32_t result=LL_I2S_IsActiveFlag_RXP(uart); return result; }
 case 176: { uint32_t result=LL_I2S_IsActiveFlag_TXP(uart); return result; }
 case 177: { uint32_t result=LL_I2S_IsActiveFlag_UDR(uart); return result; }
 case 178: { uint32_t result=LL_I2S_IsActiveFlag_OVR(uart); return result; }
 case 179: { uint32_t result=LL_I2S_IsActiveFlag_FRE(uart); return result; }
 case 180: { LL_I2S_ClearFlag_UDR(uart); return 0; }
 case 181: { LL_I2S_ClearFlag_OVR(uart); return 0; }
 case 182: { LL_I2S_ClearFlag_FRE(uart); return 0; }
 case 183: { LL_I2S_EnableIT_RXP(uart); return 0; }
 case 184: { LL_I2S_EnableIT_TXP(uart); return 0; }
 case 185: { LL_I2S_EnableIT_UDR(uart); return 0; }
 case 186: { LL_I2S_EnableIT_OVR(uart); return 0; }
 case 187: { LL_I2S_EnableIT_FRE(uart); return 0; }
 case 188: { LL_I2S_DisableIT_RXP(uart); return 0; }
 case 189: { LL_I2S_DisableIT_TXP(uart); return 0; }
 case 190: { LL_I2S_DisableIT_UDR(uart); return 0; }
 case 191: { LL_I2S_DisableIT_OVR(uart); return 0; }
 case 192: { LL_I2S_DisableIT_FRE(uart); return 0; }
 case 193: { uint32_t result=LL_I2S_IsEnabledIT_RXP(uart); return result; }
 case 194: { uint32_t result=LL_I2S_IsEnabledIT_TXP(uart); return result; }
 case 195: { uint32_t result=LL_I2S_IsEnabledIT_UDR(uart); return result; }
 case 196: { uint32_t result=LL_I2S_IsEnabledIT_OVR(uart); return result; }
 case 197: { uint32_t result=LL_I2S_IsEnabledIT_FRE(uart); return result; }
 case 198: { LL_I2S_EnableDMAReq_RX(uart); return 0; }
 case 199: { LL_I2S_DisableDMAReq_RX(uart); return 0; }
 case 200: { uint32_t result=LL_I2S_IsEnabledDMAReq_RX(uart); return result; }
 case 201: { LL_I2S_EnableDMAReq_TX(uart); return 0; }
 case 202: { LL_I2S_DisableDMAReq_TX(uart); return 0; }
 case 203: { uint32_t result=LL_I2S_IsEnabledDMAReq_TX(uart); return result; }
 case 204: { uint32_t result=LL_I2S_ReceiveData16(uart); return result; }
 case 205: { uint32_t result=LL_I2S_ReceiveData32(uart); return result; }
 case 206: { LL_I2S_TransmitData16(uart, (uint16_t)args[0]); return 0; }
 case 207: { LL_I2S_TransmitData32(uart, (uint32_t)args[0]); return 0; }
 case 208: { uint32_t result=LL_SPI_DeInit(uart); return result; }
 case 209: { LL_SPI_InitTypeDef v1={args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]}; uint32_t result=LL_SPI_Init(uart, &v1); s->cells[512]=v1.TransferDirection; s->cells[513]=v1.Mode; s->cells[514]=v1.DataWidth; s->cells[515]=v1.ClockPolarity; s->cells[516]=v1.ClockPhase; s->cells[517]=v1.NSS; s->cells[518]=v1.BaudRate; s->cells[519]=v1.BitOrder; s->cells[520]=v1.CRCCalculation; s->cells[521]=v1.CRCPoly; return result; }
 case 210: { LL_SPI_InitTypeDef v0={args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]}; LL_SPI_StructInit(&v0); s->cells[512]=v0.TransferDirection; s->cells[513]=v0.Mode; s->cells[514]=v0.DataWidth; s->cells[515]=v0.ClockPolarity; s->cells[516]=v0.ClockPhase; s->cells[517]=v0.NSS; s->cells[518]=v0.BaudRate; s->cells[519]=v0.BitOrder; s->cells[520]=v0.CRCCalculation; s->cells[521]=v0.CRCPoly; return 0; }
 case 211: { uint32_t result=LL_I2S_DeInit(uart); return result; }
 case 212: { LL_I2S_InitTypeDef v1={args[0], args[1], args[2], args[3], args[4], args[5]}; uint32_t result=LL_I2S_Init(uart, &v1); s->cells[512]=v1.Mode; s->cells[513]=v1.Standard; s->cells[514]=v1.DataFormat; s->cells[515]=v1.MCLKOutput; s->cells[516]=v1.AudioFreq; s->cells[517]=v1.ClockPolarity; return result; }
 case 213: { LL_I2S_InitTypeDef v0={args[0], args[1], args[2], args[3], args[4], args[5]}; LL_I2S_StructInit(&v0); s->cells[512]=v0.Mode; s->cells[513]=v0.Standard; s->cells[514]=v0.DataFormat; s->cells[515]=v0.MCLKOutput; s->cells[516]=v0.AudioFreq; s->cells[517]=v0.ClockPolarity; return 0; }
 case 214: { LL_I2S_ConfigPrescaler(uart, (uint32_t)args[0], (uint32_t)args[1]); return 0; }
 case 215: { LL_SPI_WriteReg(uart,CR2,args[0]);return LL_SPI_ReadReg(uart,CR2); }
 case 216: { LL_I2S_WriteReg(uart,CR2,args[0]);return LL_I2S_ReadReg(uart,CR2); }
default:abort();}}
uint32_t CL55_Constant(uint32_t i){switch(i){
case 0:return LL_SPI_SR_RXP;
case 1:return LL_SPI_SR_TXP;
case 2:return LL_SPI_SR_DXP;
case 3:return LL_SPI_SR_EOT;
case 4:return LL_SPI_SR_TXTF;
case 5:return LL_SPI_SR_UDR;
case 6:return LL_SPI_SR_CRCE;
case 7:return LL_SPI_SR_MODF;
case 8:return LL_SPI_SR_OVR;
case 9:return LL_SPI_SR_TIFRE;
case 10:return LL_SPI_SR_SUSP;
case 11:return LL_SPI_SR_TXC;
case 12:return LL_SPI_SR_RXWNE;
case 13:return LL_SPI_IER_RXPIE;
case 14:return LL_SPI_IER_TXPIE;
case 15:return LL_SPI_IER_DXPIE;
case 16:return LL_SPI_IER_EOTIE;
case 17:return LL_SPI_IER_TXTFIE;
case 18:return LL_SPI_IER_UDRIE;
case 19:return LL_SPI_IER_OVRIE;
case 20:return LL_SPI_IER_CRCEIE;
case 21:return LL_SPI_IER_TIFREIE;
case 22:return LL_SPI_IER_MODFIE;
case 23:return LL_SPI_MODE_MASTER;
case 24:return LL_SPI_MODE_SLAVE;
case 25:return LL_SPI_SS_LEVEL_HIGH;
case 26:return LL_SPI_SS_LEVEL_LOW;
case 27:return LL_SPI_SS_IDLENESS_00CYCLE;
case 28:return LL_SPI_SS_IDLENESS_01CYCLE;
case 29:return LL_SPI_SS_IDLENESS_02CYCLE;
case 30:return LL_SPI_SS_IDLENESS_03CYCLE;
case 31:return LL_SPI_SS_IDLENESS_04CYCLE;
case 32:return LL_SPI_SS_IDLENESS_05CYCLE;
case 33:return LL_SPI_SS_IDLENESS_06CYCLE;
case 34:return LL_SPI_SS_IDLENESS_07CYCLE;
case 35:return LL_SPI_SS_IDLENESS_08CYCLE;
case 36:return LL_SPI_SS_IDLENESS_09CYCLE;
case 37:return LL_SPI_SS_IDLENESS_10CYCLE;
case 38:return LL_SPI_SS_IDLENESS_11CYCLE;
case 39:return LL_SPI_SS_IDLENESS_12CYCLE;
case 40:return LL_SPI_SS_IDLENESS_13CYCLE;
case 41:return LL_SPI_SS_IDLENESS_14CYCLE;
case 42:return LL_SPI_SS_IDLENESS_15CYCLE;
case 43:return LL_SPI_ID_IDLENESS_00CYCLE;
case 44:return LL_SPI_ID_IDLENESS_01CYCLE;
case 45:return LL_SPI_ID_IDLENESS_02CYCLE;
case 46:return LL_SPI_ID_IDLENESS_03CYCLE;
case 47:return LL_SPI_ID_IDLENESS_04CYCLE;
case 48:return LL_SPI_ID_IDLENESS_05CYCLE;
case 49:return LL_SPI_ID_IDLENESS_06CYCLE;
case 50:return LL_SPI_ID_IDLENESS_07CYCLE;
case 51:return LL_SPI_ID_IDLENESS_08CYCLE;
case 52:return LL_SPI_ID_IDLENESS_09CYCLE;
case 53:return LL_SPI_ID_IDLENESS_10CYCLE;
case 54:return LL_SPI_ID_IDLENESS_11CYCLE;
case 55:return LL_SPI_ID_IDLENESS_12CYCLE;
case 56:return LL_SPI_ID_IDLENESS_13CYCLE;
case 57:return LL_SPI_ID_IDLENESS_14CYCLE;
case 58:return LL_SPI_ID_IDLENESS_15CYCLE;
case 59:return LL_SPI_TXCRCINIT_ALL_ZERO_PATTERN;
case 60:return LL_SPI_TXCRCINIT_ALL_ONES_PATTERN;
case 61:return LL_SPI_RXCRCINIT_ALL_ZERO_PATTERN;
case 62:return LL_SPI_RXCRCINIT_ALL_ONES_PATTERN;
case 63:return LL_SPI_UDR_CONFIG_REGISTER_PATTERN;
case 64:return LL_SPI_UDR_CONFIG_LAST_RECEIVED;
case 65:return LL_SPI_PROTOCOL_MOTOROLA;
case 66:return LL_SPI_PROTOCOL_TI;
case 67:return LL_SPI_PHASE_1EDGE;
case 68:return LL_SPI_PHASE_2EDGE;
case 69:return LL_SPI_POLARITY_LOW;
case 70:return LL_SPI_POLARITY_HIGH;
case 71:return LL_SPI_NSS_POLARITY_LOW;
case 72:return LL_SPI_NSS_POLARITY_HIGH;
case 73:return LL_SPI_BAUDRATEPRESCALER_BYPASS;
case 74:return LL_SPI_BAUDRATEPRESCALER_DIV2;
case 75:return LL_SPI_BAUDRATEPRESCALER_DIV4;
case 76:return LL_SPI_BAUDRATEPRESCALER_DIV8;
case 77:return LL_SPI_BAUDRATEPRESCALER_DIV16;
case 78:return LL_SPI_BAUDRATEPRESCALER_DIV32;
case 79:return LL_SPI_BAUDRATEPRESCALER_DIV64;
case 80:return LL_SPI_BAUDRATEPRESCALER_DIV128;
case 81:return LL_SPI_BAUDRATEPRESCALER_DIV256;
case 82:return LL_SPI_LSB_FIRST;
case 83:return LL_SPI_MSB_FIRST;
case 84:return LL_SPI_FULL_DUPLEX;
case 85:return LL_SPI_SIMPLEX_TX;
case 86:return LL_SPI_SIMPLEX_RX;
case 87:return LL_SPI_HALF_DUPLEX_RX;
case 88:return LL_SPI_HALF_DUPLEX_TX;
case 89:return LL_SPI_DATAWIDTH_4BIT;
case 90:return LL_SPI_DATAWIDTH_5BIT;
case 91:return LL_SPI_DATAWIDTH_6BIT;
case 92:return LL_SPI_DATAWIDTH_7BIT;
case 93:return LL_SPI_DATAWIDTH_8BIT;
case 94:return LL_SPI_DATAWIDTH_9BIT;
case 95:return LL_SPI_DATAWIDTH_10BIT;
case 96:return LL_SPI_DATAWIDTH_11BIT;
case 97:return LL_SPI_DATAWIDTH_12BIT;
case 98:return LL_SPI_DATAWIDTH_13BIT;
case 99:return LL_SPI_DATAWIDTH_14BIT;
case 100:return LL_SPI_DATAWIDTH_15BIT;
case 101:return LL_SPI_DATAWIDTH_16BIT;
case 102:return LL_SPI_DATAWIDTH_17BIT;
case 103:return LL_SPI_DATAWIDTH_18BIT;
case 104:return LL_SPI_DATAWIDTH_19BIT;
case 105:return LL_SPI_DATAWIDTH_20BIT;
case 106:return LL_SPI_DATAWIDTH_21BIT;
case 107:return LL_SPI_DATAWIDTH_22BIT;
case 108:return LL_SPI_DATAWIDTH_23BIT;
case 109:return LL_SPI_DATAWIDTH_24BIT;
case 110:return LL_SPI_DATAWIDTH_25BIT;
case 111:return LL_SPI_DATAWIDTH_26BIT;
case 112:return LL_SPI_DATAWIDTH_27BIT;
case 113:return LL_SPI_DATAWIDTH_28BIT;
case 114:return LL_SPI_DATAWIDTH_29BIT;
case 115:return LL_SPI_DATAWIDTH_30BIT;
case 116:return LL_SPI_DATAWIDTH_31BIT;
case 117:return LL_SPI_DATAWIDTH_32BIT;
case 118:return LL_SPI_FIFO_TH_01DATA;
case 119:return LL_SPI_FIFO_TH_02DATA;
case 120:return LL_SPI_FIFO_TH_03DATA;
case 121:return LL_SPI_FIFO_TH_04DATA;
case 122:return LL_SPI_FIFO_TH_05DATA;
case 123:return LL_SPI_FIFO_TH_06DATA;
case 124:return LL_SPI_FIFO_TH_07DATA;
case 125:return LL_SPI_FIFO_TH_08DATA;
case 126:return LL_SPI_FIFO_TH_09DATA;
case 127:return LL_SPI_FIFO_TH_10DATA;
case 128:return LL_SPI_FIFO_TH_11DATA;
case 129:return LL_SPI_FIFO_TH_12DATA;
case 130:return LL_SPI_FIFO_TH_13DATA;
case 131:return LL_SPI_FIFO_TH_14DATA;
case 132:return LL_SPI_FIFO_TH_15DATA;
case 133:return LL_SPI_FIFO_TH_16DATA;
case 134:return LL_SPI_CRCCALCULATION_DISABLE;
case 135:return LL_SPI_CRCCALCULATION_ENABLE;
case 136:return LL_SPI_CRC_4BIT;
case 137:return LL_SPI_CRC_5BIT;
case 138:return LL_SPI_CRC_6BIT;
case 139:return LL_SPI_CRC_7BIT;
case 140:return LL_SPI_CRC_8BIT;
case 141:return LL_SPI_CRC_9BIT;
case 142:return LL_SPI_CRC_10BIT;
case 143:return LL_SPI_CRC_11BIT;
case 144:return LL_SPI_CRC_12BIT;
case 145:return LL_SPI_CRC_13BIT;
case 146:return LL_SPI_CRC_14BIT;
case 147:return LL_SPI_CRC_15BIT;
case 148:return LL_SPI_CRC_16BIT;
case 149:return LL_SPI_CRC_17BIT;
case 150:return LL_SPI_CRC_18BIT;
case 151:return LL_SPI_CRC_19BIT;
case 152:return LL_SPI_CRC_20BIT;
case 153:return LL_SPI_CRC_21BIT;
case 154:return LL_SPI_CRC_22BIT;
case 155:return LL_SPI_CRC_23BIT;
case 156:return LL_SPI_CRC_24BIT;
case 157:return LL_SPI_CRC_25BIT;
case 158:return LL_SPI_CRC_26BIT;
case 159:return LL_SPI_CRC_27BIT;
case 160:return LL_SPI_CRC_28BIT;
case 161:return LL_SPI_CRC_29BIT;
case 162:return LL_SPI_CRC_30BIT;
case 163:return LL_SPI_CRC_31BIT;
case 164:return LL_SPI_CRC_32BIT;
case 165:return LL_SPI_NSS_SOFT;
case 166:return LL_SPI_NSS_HARD_INPUT;
case 167:return LL_SPI_NSS_HARD_OUTPUT;
case 168:return LL_SPI_RX_FIFO_0PACKET;
case 169:return LL_SPI_RX_FIFO_1PACKET;
case 170:return LL_SPI_RX_FIFO_2PACKET;
case 171:return LL_SPI_RX_FIFO_3PACKET;
case 172:return LL_I2S_DATAFORMAT_16B;
case 173:return LL_I2S_DATAFORMAT_16B_EXTENDED;
case 174:return LL_I2S_DATAFORMAT_24B;
case 175:return LL_I2S_DATAFORMAT_24B_LEFT_ALIGNED;
case 176:return LL_I2S_DATAFORMAT_32B;
case 177:return LL_I2S_SLAVE_VARIABLE_CH_LENGTH;
case 178:return LL_I2S_SLAVE_FIXED_CH_LENGTH;
case 179:return LL_I2S_POLARITY_LOW;
case 180:return LL_I2S_POLARITY_HIGH;
case 181:return LL_I2S_STANDARD_PHILIPS;
case 182:return LL_I2S_STANDARD_MSB;
case 183:return LL_I2S_STANDARD_LSB;
case 184:return LL_I2S_STANDARD_PCM_SHORT;
case 185:return LL_I2S_STANDARD_PCM_LONG;
case 186:return LL_I2S_MODE_SLAVE_TX;
case 187:return LL_I2S_MODE_SLAVE_RX;
case 188:return LL_I2S_MODE_SLAVE_FULL_DUPLEX;
case 189:return LL_I2S_MODE_MASTER_TX;
case 190:return LL_I2S_MODE_MASTER_RX;
case 191:return LL_I2S_MODE_MASTER_FULL_DUPLEX;
case 192:return LL_I2S_PRESCALER_PARITY_EVEN;
case 193:return LL_I2S_PRESCALER_PARITY_ODD;
case 194:return LL_I2S_FIFO_TH_01DATA;
case 195:return LL_I2S_FIFO_TH_02DATA;
case 196:return LL_I2S_FIFO_TH_03DATA;
case 197:return LL_I2S_FIFO_TH_04DATA;
case 198:return LL_I2S_FIFO_TH_05DATA;
case 199:return LL_I2S_FIFO_TH_06DATA;
case 200:return LL_I2S_FIFO_TH_07DATA;
case 201:return LL_I2S_FIFO_TH_08DATA;
case 202:return LL_I2S_LSB_FIRST;
case 203:return LL_I2S_MSB_FIRST;
case 204:return LL_I2S_MCLK_OUTPUT_DISABLE;
case 205:return LL_I2S_MCLK_OUTPUT_ENABLE;
case 206:return LL_I2S_AUDIOFREQ_192K;
case 207:return LL_I2S_AUDIOFREQ_96K;
case 208:return LL_I2S_AUDIOFREQ_48K;
case 209:return LL_I2S_AUDIOFREQ_44K;
case 210:return LL_I2S_AUDIOFREQ_32K;
case 211:return LL_I2S_AUDIOFREQ_22K;
case 212:return LL_I2S_AUDIOFREQ_16K;
case 213:return LL_I2S_AUDIOFREQ_11K;
case 214:return LL_I2S_AUDIOFREQ_8K;
case 215:return LL_I2S_AUDIOFREQ_DEFAULT;
default:abort();}}
