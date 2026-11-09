#include "include/CLLSerialReference.h"
#include <stdlib.h>
#include <assert.h>
#include "Upstream/Serial/RCCNamespace.h"
#include "Upstream/Serial/Trace/stm32h7rsxx_ll_rcc.h"
#include "Upstream/Serial/Trace/stm32h7rsxx_ll_rcc.inc"
#include "Upstream/Serial/Trace/stm32h7rsxx_ll_usart.h"
#include "Upstream/Serial/Trace/stm32h7rsxx_ll_lpuart.h"
#include "Upstream/Serial/Trace/stm32h7rsxx_ll_usart.inc"
#include "Upstream/Serial/Trace/stm32h7rsxx_ll_lpuart.inc"
struct CL54State {uint32_t cells[1024],count,reads,salt,instance,failures,mode;CL54Access trace[512];};
_Thread_local uint32_t *CL54_Cells;
static _Thread_local CL54State *current;
CL54State *CL54_Create(void){return calloc(1,sizeof(CL54State));}
void CL54_Destroy(CL54State *s){free(s);}
void CL54_Reset(CL54State *s,uint32_t seed,uint32_t salt,uint32_t instance,uint32_t failures,uint32_t mode){
 current=s;CL54_Cells=s->cells;
 for(uint32_t i=0;i<1024;i++)s->cells[i]=seed^(i*0x9E3779B9U);
 for(uint32_t i=256;i<512;i++)s->cells[i]=0;
 s->cells[256]=(mode&256U?0U:0x2a020124)|(((mode>>6U)&3U)<<3U);
 s->cells[260]=((mode>>4U)&3U)<<3U;
 s->cells[266]=(6U<<4U)|(6U<<12U)|(6U<<20U);s->cells[267]=0xFFFFFFFFU;
 s->cells[268]=s->cells[270]=s->cells[272]=47U|(7U<<9U)|(3U<<16U)|(3U<<24U);
 s->cells[276]=s->cells[277]=s->cells[278]=mode&7U;
 s->cells[284]=(mode&256U)?0U:RCC_BDCR_LSERDY;
 s->count=0;s->reads=0;s->salt=salt;s->instance=instance;s->failures=failures;s->mode=mode;
}
static void record(uint32_t index,uint32_t value,uint32_t kind){assert(index<1024 && current->count<512);current->trace[current->count++]=(CL54Access){index,value,kind};}
static uint32_t indexOf(volatile const uint32_t *p){uintptr_t d=(uintptr_t)p-(uintptr_t)CL54_Cells;assert(d<4096 && d%4==0);return (uint32_t)d/4;}
uint32_t CL54_Read(volatile const uint32_t *p){uint32_t i=indexOf(p),v=*p ^ (i<256U?current->salt*current->reads:0U);current->reads++;record(i,v,0);return v;}
void CL54_Write(volatile uint32_t *p,uint32_t v){record(indexOf(p),v,1);*p=v;}
uint32_t CL54_LoadExclusive(volatile uint32_t *p){uint32_t i=indexOf(p),v=*p ^ (current->salt*current->reads++);record(i,v,2);return v;}
uint32_t CL54_StoreExclusive(uint32_t v,volatile uint32_t *p){uint32_t i=indexOf(p);if(current->failures){current->failures--;record(i,v,4);*p^=0x01010101U;return 1;}record(i,v,3);*p=v;return 0;}
uint32_t CL54_Address(volatile const uint32_t *p){static const uint32_t bases[8]={0x42001000U,0x40004400U,0x40004800U,0x40004C00U,0x40005000U,0x40007800U,0x40007C00U,0x58000C00U};uint32_t i=indexOf(p);assert(i<128);return bases[i/16]+(i%16)*4;}
uint32_t CL54_Oscillator(uint32_t i){static const uint32_t v[7]={64000000,4000000,24000000,32768,32000,48000000,12288000};assert(i<7);return v[i]+(current->mode&512U?17U:0U);}
uint32_t *CL54_GetCells(CL54State *s){return s->cells;}
const CL54Access *CL54_GetTrace(CL54State *s){return s->trace;}
uint32_t CL54_GetTraceCount(CL54State *s){return s->count;}
uint32_t CL54_Run(CL54State *s,uint32_t op,const uint32_t *args){current=s;CL54_Cells=s->cells;USART_TypeDef *uart=(USART_TypeDef *)(s->cells+s->instance*16);
 switch(op){
 case 0: { LL_USART_Enable(uart); return 0; }
 case 1: { LL_USART_Disable(uart); return 0; }
 case 2: { uint32_t result=LL_USART_IsEnabled(uart); return result; }
 case 3: { LL_USART_EnableFIFO(uart); return 0; }
 case 4: { LL_USART_DisableFIFO(uart); return 0; }
 case 5: { uint32_t result=LL_USART_IsEnabledFIFO(uart); return result; }
 case 6: { LL_USART_SetTXFIFOThreshold(uart, (uint32_t)args[0]); return 0; }
 case 7: { uint32_t result=LL_USART_GetTXFIFOThreshold(uart); return result; }
 case 8: { LL_USART_SetRXFIFOThreshold(uart, (uint32_t)args[0]); return 0; }
 case 9: { uint32_t result=LL_USART_GetRXFIFOThreshold(uart); return result; }
 case 10: { LL_USART_ConfigFIFOsThreshold(uart, (uint32_t)args[0], (uint32_t)args[1]); return 0; }
 case 11: { LL_USART_EnableInStopMode(uart); return 0; }
 case 12: { LL_USART_DisableInStopMode(uart); return 0; }
 case 13: { uint32_t result=LL_USART_IsEnabledInStopMode(uart); return result; }
 case 14: { LL_USART_EnableDirectionRx(uart); return 0; }
 case 15: { LL_USART_DisableDirectionRx(uart); return 0; }
 case 16: { LL_USART_EnableDirectionTx(uart); return 0; }
 case 17: { LL_USART_DisableDirectionTx(uart); return 0; }
 case 18: { LL_USART_SetTransferDirection(uart, (uint32_t)args[0]); return 0; }
 case 19: { uint32_t result=LL_USART_GetTransferDirection(uart); return result; }
 case 20: { LL_USART_SetParity(uart, (uint32_t)args[0]); return 0; }
 case 21: { uint32_t result=LL_USART_GetParity(uart); return result; }
 case 22: { LL_USART_SetWakeUpMethod(uart, (uint32_t)args[0]); return 0; }
 case 23: { uint32_t result=LL_USART_GetWakeUpMethod(uart); return result; }
 case 24: { LL_USART_SetDataWidth(uart, (uint32_t)args[0]); return 0; }
 case 25: { uint32_t result=LL_USART_GetDataWidth(uart); return result; }
 case 26: { LL_USART_EnableMuteMode(uart); return 0; }
 case 27: { LL_USART_DisableMuteMode(uart); return 0; }
 case 28: { uint32_t result=LL_USART_IsEnabledMuteMode(uart); return result; }
 case 29: { LL_USART_SetOverSampling(uart, (uint32_t)args[0]); return 0; }
 case 30: { uint32_t result=LL_USART_GetOverSampling(uart); return result; }
 case 31: { LL_USART_SetLastClkPulseOutput(uart, (uint32_t)args[0]); return 0; }
 case 32: { uint32_t result=LL_USART_GetLastClkPulseOutput(uart); return result; }
 case 33: { LL_USART_SetClockPhase(uart, (uint32_t)args[0]); return 0; }
 case 34: { uint32_t result=LL_USART_GetClockPhase(uart); return result; }
 case 35: { LL_USART_SetClockPolarity(uart, (uint32_t)args[0]); return 0; }
 case 36: { uint32_t result=LL_USART_GetClockPolarity(uart); return result; }
 case 37: { LL_USART_ConfigClock(uart, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2]); return 0; }
 case 38: { LL_USART_SetPrescaler(uart, (uint32_t)args[0]); return 0; }
 case 39: { uint32_t result=LL_USART_GetPrescaler(uart); return result; }
 case 40: { LL_USART_EnableSCLKOutput(uart); return 0; }
 case 41: { LL_USART_DisableSCLKOutput(uart); return 0; }
 case 42: { uint32_t result=LL_USART_IsEnabledSCLKOutput(uart); return result; }
 case 43: { LL_USART_SetStopBitsLength(uart, (uint32_t)args[0]); return 0; }
 case 44: { uint32_t result=LL_USART_GetStopBitsLength(uart); return result; }
 case 45: { LL_USART_ConfigCharacter(uart, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2]); return 0; }
 case 46: { LL_USART_SetTXRXSwap(uart, (uint32_t)args[0]); return 0; }
 case 47: { uint32_t result=LL_USART_GetTXRXSwap(uart); return result; }
 case 48: { LL_USART_SetRXPinLevel(uart, (uint32_t)args[0]); return 0; }
 case 49: { uint32_t result=LL_USART_GetRXPinLevel(uart); return result; }
 case 50: { LL_USART_SetTXPinLevel(uart, (uint32_t)args[0]); return 0; }
 case 51: { uint32_t result=LL_USART_GetTXPinLevel(uart); return result; }
 case 52: { LL_USART_SetBinaryDataLogic(uart, (uint32_t)args[0]); return 0; }
 case 53: { uint32_t result=LL_USART_GetBinaryDataLogic(uart); return result; }
 case 54: { LL_USART_SetTransferBitOrder(uart, (uint32_t)args[0]); return 0; }
 case 55: { uint32_t result=LL_USART_GetTransferBitOrder(uart); return result; }
 case 56: { LL_USART_EnableAutoBaudRate(uart); return 0; }
 case 57: { LL_USART_DisableAutoBaudRate(uart); return 0; }
 case 58: { uint32_t result=LL_USART_IsEnabledAutoBaud(uart); return result; }
 case 59: { LL_USART_SetAutoBaudRateMode(uart, (uint32_t)args[0]); return 0; }
 case 60: { uint32_t result=LL_USART_GetAutoBaudRateMode(uart); return result; }
 case 61: { LL_USART_EnableRxTimeout(uart); return 0; }
 case 62: { LL_USART_DisableRxTimeout(uart); return 0; }
 case 63: { uint32_t result=LL_USART_IsEnabledRxTimeout(uart); return result; }
 case 64: { LL_USART_ConfigNodeAddress(uart, (uint32_t)args[0], (uint32_t)args[1]); return 0; }
 case 65: { uint32_t result=LL_USART_GetNodeAddress(uart); return result; }
 case 66: { uint32_t result=LL_USART_GetNodeAddressLen(uart); return result; }
 case 67: { LL_USART_EnableRTSHWFlowCtrl(uart); return 0; }
 case 68: { LL_USART_DisableRTSHWFlowCtrl(uart); return 0; }
 case 69: { LL_USART_EnableCTSHWFlowCtrl(uart); return 0; }
 case 70: { LL_USART_DisableCTSHWFlowCtrl(uart); return 0; }
 case 71: { LL_USART_SetHWFlowCtrl(uart, (uint32_t)args[0]); return 0; }
 case 72: { uint32_t result=LL_USART_GetHWFlowCtrl(uart); return result; }
 case 73: { LL_USART_EnableOneBitSamp(uart); return 0; }
 case 74: { LL_USART_DisableOneBitSamp(uart); return 0; }
 case 75: { uint32_t result=LL_USART_IsEnabledOneBitSamp(uart); return result; }
 case 76: { LL_USART_EnableOverrunDetect(uart); return 0; }
 case 77: { LL_USART_DisableOverrunDetect(uart); return 0; }
 case 78: { uint32_t result=LL_USART_IsEnabledOverrunDetect(uart); return result; }
 case 79: { LL_USART_SetWKUPType(uart, (uint32_t)args[0]); return 0; }
 case 80: { uint32_t result=LL_USART_GetWKUPType(uart); return result; }
 case 81: { LL_USART_SetBaudRate(uart, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3]); return 0; }
 case 82: { uint32_t result=LL_USART_GetBaudRate(uart, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2]); return result; }
 case 83: { LL_USART_SetRxTimeout(uart, (uint32_t)args[0]); return 0; }
 case 84: { uint32_t result=LL_USART_GetRxTimeout(uart); return result; }
 case 85: { LL_USART_SetBlockLength(uart, (uint32_t)args[0]); return 0; }
 case 86: { uint32_t result=LL_USART_GetBlockLength(uart); return result; }
 case 87: { LL_USART_EnableIrda(uart); return 0; }
 case 88: { LL_USART_DisableIrda(uart); return 0; }
 case 89: { uint32_t result=LL_USART_IsEnabledIrda(uart); return result; }
 case 90: { LL_USART_SetIrdaPowerMode(uart, (uint32_t)args[0]); return 0; }
 case 91: { uint32_t result=LL_USART_GetIrdaPowerMode(uart); return result; }
 case 92: { LL_USART_SetIrdaPrescaler(uart, (uint32_t)args[0]); return 0; }
 case 93: { uint32_t result=LL_USART_GetIrdaPrescaler(uart); return result; }
 case 94: { LL_USART_EnableSmartcardNACK(uart); return 0; }
 case 95: { LL_USART_DisableSmartcardNACK(uart); return 0; }
 case 96: { uint32_t result=LL_USART_IsEnabledSmartcardNACK(uart); return result; }
 case 97: { LL_USART_EnableSmartcard(uart); return 0; }
 case 98: { LL_USART_DisableSmartcard(uart); return 0; }
 case 99: { uint32_t result=LL_USART_IsEnabledSmartcard(uart); return result; }
 case 100: { LL_USART_SetSmartcardAutoRetryCount(uart, (uint32_t)args[0]); return 0; }
 case 101: { uint32_t result=LL_USART_GetSmartcardAutoRetryCount(uart); return result; }
 case 102: { LL_USART_SetSmartcardPrescaler(uart, (uint32_t)args[0]); return 0; }
 case 103: { uint32_t result=LL_USART_GetSmartcardPrescaler(uart); return result; }
 case 104: { LL_USART_SetSmartcardGuardTime(uart, (uint32_t)args[0]); return 0; }
 case 105: { uint32_t result=LL_USART_GetSmartcardGuardTime(uart); return result; }
 case 106: { LL_USART_EnableHalfDuplex(uart); return 0; }
 case 107: { LL_USART_DisableHalfDuplex(uart); return 0; }
 case 108: { uint32_t result=LL_USART_IsEnabledHalfDuplex(uart); return result; }
 case 109: { LL_USART_EnableSPISlave(uart); return 0; }
 case 110: { LL_USART_DisableSPISlave(uart); return 0; }
 case 111: { uint32_t result=LL_USART_IsEnabledSPISlave(uart); return result; }
 case 112: { LL_USART_EnableSPISlaveSelect(uart); return 0; }
 case 113: { LL_USART_DisableSPISlaveSelect(uart); return 0; }
 case 114: { uint32_t result=LL_USART_IsEnabledSPISlaveSelect(uart); return result; }
 case 115: { LL_USART_SetLINBrkDetectionLen(uart, (uint32_t)args[0]); return 0; }
 case 116: { uint32_t result=LL_USART_GetLINBrkDetectionLen(uart); return result; }
 case 117: { LL_USART_EnableLIN(uart); return 0; }
 case 118: { LL_USART_DisableLIN(uart); return 0; }
 case 119: { uint32_t result=LL_USART_IsEnabledLIN(uart); return result; }
 case 120: { LL_USART_SetDEDeassertionTime(uart, (uint32_t)args[0]); return 0; }
 case 121: { uint32_t result=LL_USART_GetDEDeassertionTime(uart); return result; }
 case 122: { LL_USART_SetDEAssertionTime(uart, (uint32_t)args[0]); return 0; }
 case 123: { uint32_t result=LL_USART_GetDEAssertionTime(uart); return result; }
 case 124: { LL_USART_EnableDEMode(uart); return 0; }
 case 125: { LL_USART_DisableDEMode(uart); return 0; }
 case 126: { uint32_t result=LL_USART_IsEnabledDEMode(uart); return result; }
 case 127: { LL_USART_SetDESignalPolarity(uart, (uint32_t)args[0]); return 0; }
 case 128: { uint32_t result=LL_USART_GetDESignalPolarity(uart); return result; }
 case 129: { LL_USART_ConfigAsyncMode(uart); return 0; }
 case 130: { LL_USART_ConfigSyncMode(uart); return 0; }
 case 131: { LL_USART_ConfigLINMode(uart); return 0; }
 case 132: { LL_USART_ConfigHalfDuplexMode(uart); return 0; }
 case 133: { LL_USART_ConfigSmartcardMode(uart); return 0; }
 case 134: { LL_USART_ConfigIrdaMode(uart); return 0; }
 case 135: { LL_USART_ConfigMultiProcessMode(uart); return 0; }
 case 136: { uint32_t result=LL_USART_IsActiveFlag_PE(uart); return result; }
 case 137: { uint32_t result=LL_USART_IsActiveFlag_FE(uart); return result; }
 case 138: { uint32_t result=LL_USART_IsActiveFlag_NE(uart); return result; }
 case 139: { uint32_t result=LL_USART_IsActiveFlag_ORE(uart); return result; }
 case 140: { uint32_t result=LL_USART_IsActiveFlag_IDLE(uart); return result; }
 case 141: { uint32_t result=LL_USART_IsActiveFlag_RXNE_RXFNE(uart); return result; }
 case 142: { uint32_t result=LL_USART_IsActiveFlag_TC(uart); return result; }
 case 143: { uint32_t result=LL_USART_IsActiveFlag_TXE_TXFNF(uart); return result; }
 case 144: { uint32_t result=LL_USART_IsActiveFlag_LBD(uart); return result; }
 case 145: { uint32_t result=LL_USART_IsActiveFlag_nCTS(uart); return result; }
 case 146: { uint32_t result=LL_USART_IsActiveFlag_CTS(uart); return result; }
 case 147: { uint32_t result=LL_USART_IsActiveFlag_RTO(uart); return result; }
 case 148: { uint32_t result=LL_USART_IsActiveFlag_EOB(uart); return result; }
 case 149: { uint32_t result=LL_USART_IsActiveFlag_UDR(uart); return result; }
 case 150: { uint32_t result=LL_USART_IsActiveFlag_ABRE(uart); return result; }
 case 151: { uint32_t result=LL_USART_IsActiveFlag_ABR(uart); return result; }
 case 152: { uint32_t result=LL_USART_IsActiveFlag_BUSY(uart); return result; }
 case 153: { uint32_t result=LL_USART_IsActiveFlag_CM(uart); return result; }
 case 154: { uint32_t result=LL_USART_IsActiveFlag_SBK(uart); return result; }
 case 155: { uint32_t result=LL_USART_IsActiveFlag_RWU(uart); return result; }
 case 156: { uint32_t result=LL_USART_IsActiveFlag_WKUP(uart); return result; }
 case 157: { uint32_t result=LL_USART_IsActiveFlag_TEACK(uart); return result; }
 case 158: { uint32_t result=LL_USART_IsActiveFlag_REACK(uart); return result; }
 case 159: { uint32_t result=LL_USART_IsActiveFlag_TXFE(uart); return result; }
 case 160: { uint32_t result=LL_USART_IsActiveFlag_RXFF(uart); return result; }
 case 161: { uint32_t result=LL_USART_IsActiveFlag_TCBGT(uart); return result; }
 case 162: { uint32_t result=LL_USART_IsActiveFlag_TXFT(uart); return result; }
 case 163: { uint32_t result=LL_USART_IsActiveFlag_RXFT(uart); return result; }
 case 164: { LL_USART_ClearFlag_PE(uart); return 0; }
 case 165: { LL_USART_ClearFlag_FE(uart); return 0; }
 case 166: { LL_USART_ClearFlag_NE(uart); return 0; }
 case 167: { LL_USART_ClearFlag_ORE(uart); return 0; }
 case 168: { LL_USART_ClearFlag_IDLE(uart); return 0; }
 case 169: { LL_USART_ClearFlag_TXFE(uart); return 0; }
 case 170: { LL_USART_ClearFlag_TC(uart); return 0; }
 case 171: { LL_USART_ClearFlag_TCBGT(uart); return 0; }
 case 172: { LL_USART_ClearFlag_LBD(uart); return 0; }
 case 173: { LL_USART_ClearFlag_nCTS(uart); return 0; }
 case 174: { LL_USART_ClearFlag_RTO(uart); return 0; }
 case 175: { LL_USART_ClearFlag_EOB(uart); return 0; }
 case 176: { LL_USART_ClearFlag_UDR(uart); return 0; }
 case 177: { LL_USART_ClearFlag_CM(uart); return 0; }
 case 178: { LL_USART_ClearFlag_WKUP(uart); return 0; }
 case 179: { LL_USART_EnableIT_IDLE(uart); return 0; }
 case 180: { LL_USART_EnableIT_RXNE_RXFNE(uart); return 0; }
 case 181: { LL_USART_EnableIT_TC(uart); return 0; }
 case 182: { LL_USART_EnableIT_TXE_TXFNF(uart); return 0; }
 case 183: { LL_USART_EnableIT_PE(uart); return 0; }
 case 184: { LL_USART_EnableIT_CM(uart); return 0; }
 case 185: { LL_USART_EnableIT_RTO(uart); return 0; }
 case 186: { LL_USART_EnableIT_EOB(uart); return 0; }
 case 187: { LL_USART_EnableIT_TXFE(uart); return 0; }
 case 188: { LL_USART_EnableIT_RXFF(uart); return 0; }
 case 189: { LL_USART_EnableIT_LBD(uart); return 0; }
 case 190: { LL_USART_EnableIT_ERROR(uart); return 0; }
 case 191: { LL_USART_EnableIT_CTS(uart); return 0; }
 case 192: { LL_USART_EnableIT_WKUP(uart); return 0; }
 case 193: { LL_USART_EnableIT_TXFT(uart); return 0; }
 case 194: { LL_USART_EnableIT_TCBGT(uart); return 0; }
 case 195: { LL_USART_EnableIT_RXFT(uart); return 0; }
 case 196: { LL_USART_DisableIT_IDLE(uart); return 0; }
 case 197: { LL_USART_DisableIT_RXNE_RXFNE(uart); return 0; }
 case 198: { LL_USART_DisableIT_TC(uart); return 0; }
 case 199: { LL_USART_DisableIT_TXE_TXFNF(uart); return 0; }
 case 200: { LL_USART_DisableIT_PE(uart); return 0; }
 case 201: { LL_USART_DisableIT_CM(uart); return 0; }
 case 202: { LL_USART_DisableIT_RTO(uart); return 0; }
 case 203: { LL_USART_DisableIT_EOB(uart); return 0; }
 case 204: { LL_USART_DisableIT_TXFE(uart); return 0; }
 case 205: { LL_USART_DisableIT_RXFF(uart); return 0; }
 case 206: { LL_USART_DisableIT_LBD(uart); return 0; }
 case 207: { LL_USART_DisableIT_ERROR(uart); return 0; }
 case 208: { LL_USART_DisableIT_CTS(uart); return 0; }
 case 209: { LL_USART_DisableIT_WKUP(uart); return 0; }
 case 210: { LL_USART_DisableIT_TXFT(uart); return 0; }
 case 211: { LL_USART_DisableIT_TCBGT(uart); return 0; }
 case 212: { LL_USART_DisableIT_RXFT(uart); return 0; }
 case 213: { uint32_t result=LL_USART_IsEnabledIT_IDLE(uart); return result; }
 case 214: { uint32_t result=LL_USART_IsEnabledIT_RXNE_RXFNE(uart); return result; }
 case 215: { uint32_t result=LL_USART_IsEnabledIT_TC(uart); return result; }
 case 216: { uint32_t result=LL_USART_IsEnabledIT_TXE_TXFNF(uart); return result; }
 case 217: { uint32_t result=LL_USART_IsEnabledIT_PE(uart); return result; }
 case 218: { uint32_t result=LL_USART_IsEnabledIT_CM(uart); return result; }
 case 219: { uint32_t result=LL_USART_IsEnabledIT_RTO(uart); return result; }
 case 220: { uint32_t result=LL_USART_IsEnabledIT_EOB(uart); return result; }
 case 221: { uint32_t result=LL_USART_IsEnabledIT_TXFE(uart); return result; }
 case 222: { uint32_t result=LL_USART_IsEnabledIT_RXFF(uart); return result; }
 case 223: { uint32_t result=LL_USART_IsEnabledIT_LBD(uart); return result; }
 case 224: { uint32_t result=LL_USART_IsEnabledIT_ERROR(uart); return result; }
 case 225: { uint32_t result=LL_USART_IsEnabledIT_CTS(uart); return result; }
 case 226: { uint32_t result=LL_USART_IsEnabledIT_WKUP(uart); return result; }
 case 227: { uint32_t result=LL_USART_IsEnabledIT_TXFT(uart); return result; }
 case 228: { uint32_t result=LL_USART_IsEnabledIT_TCBGT(uart); return result; }
 case 229: { uint32_t result=LL_USART_IsEnabledIT_RXFT(uart); return result; }
 case 230: { LL_USART_EnableDMAReq_RX(uart); return 0; }
 case 231: { LL_USART_DisableDMAReq_RX(uart); return 0; }
 case 232: { uint32_t result=LL_USART_IsEnabledDMAReq_RX(uart); return result; }
 case 233: { LL_USART_EnableDMAReq_TX(uart); return 0; }
 case 234: { LL_USART_DisableDMAReq_TX(uart); return 0; }
 case 235: { uint32_t result=LL_USART_IsEnabledDMAReq_TX(uart); return result; }
 case 236: { LL_USART_EnableDMADeactOnRxErr(uart); return 0; }
 case 237: { LL_USART_DisableDMADeactOnRxErr(uart); return 0; }
 case 238: { uint32_t result=LL_USART_IsEnabledDMADeactOnRxErr(uart); return result; }
 case 239: { uint32_t result=LL_USART_DMA_GetRegAddr(uart, (uint32_t)args[0]); return result; }
 case 240: { uint32_t result=LL_USART_ReceiveData8(uart); return result; }
 case 241: { uint32_t result=LL_USART_ReceiveData9(uart); return result; }
 case 242: { LL_USART_TransmitData8(uart, (uint8_t)args[0]); return 0; }
 case 243: { LL_USART_TransmitData9(uart, (uint16_t)args[0]); return 0; }
 case 244: { LL_USART_RequestAutoBaudRate(uart); return 0; }
 case 245: { LL_USART_RequestBreakSending(uart); return 0; }
 case 246: { LL_USART_RequestEnterMuteMode(uart); return 0; }
 case 247: { LL_USART_RequestRxDataFlush(uart); return 0; }
 case 248: { LL_USART_RequestTxDataFlush(uart); return 0; }
 case 249: { uint32_t result=LL_USART_DeInit(uart); return result; }
 case 250: { LL_USART_InitTypeDef v1={args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]}; uint32_t result=LL_USART_Init(uart, &v1); s->cells[512]=v1.PrescalerValue; s->cells[513]=v1.BaudRate; s->cells[514]=v1.DataWidth; s->cells[515]=v1.StopBits; s->cells[516]=v1.Parity; s->cells[517]=v1.TransferDirection; s->cells[518]=v1.HardwareFlowControl; s->cells[519]=v1.OverSampling; return result; }
 case 251: { LL_USART_InitTypeDef v0={args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]}; LL_USART_StructInit(&v0); s->cells[512]=v0.PrescalerValue; s->cells[513]=v0.BaudRate; s->cells[514]=v0.DataWidth; s->cells[515]=v0.StopBits; s->cells[516]=v0.Parity; s->cells[517]=v0.TransferDirection; s->cells[518]=v0.HardwareFlowControl; s->cells[519]=v0.OverSampling; return 0; }
 case 252: { LL_USART_ClockInitTypeDef v1={args[0], args[1], args[2], args[3]}; uint32_t result=LL_USART_ClockInit(uart, &v1); s->cells[512]=v1.ClockOutput; s->cells[513]=v1.ClockPolarity; s->cells[514]=v1.ClockPhase; s->cells[515]=v1.LastBitClockPulse; return result; }
 case 253: { LL_USART_ClockInitTypeDef v0={args[0], args[1], args[2], args[3]}; LL_USART_ClockStructInit(&v0); s->cells[512]=v0.ClockOutput; s->cells[513]=v0.ClockPolarity; s->cells[514]=v0.ClockPhase; s->cells[515]=v0.LastBitClockPulse; return 0; }
 case 254: { LL_LPUART_Enable(uart); return 0; }
 case 255: { LL_LPUART_Disable(uart); return 0; }
 case 256: { uint32_t result=LL_LPUART_IsEnabled(uart); return result; }
 case 257: { LL_LPUART_EnableFIFO(uart); return 0; }
 case 258: { LL_LPUART_DisableFIFO(uart); return 0; }
 case 259: { uint32_t result=LL_LPUART_IsEnabledFIFO(uart); return result; }
 case 260: { LL_LPUART_SetTXFIFOThreshold(uart, (uint32_t)args[0]); return 0; }
 case 261: { uint32_t result=LL_LPUART_GetTXFIFOThreshold(uart); return result; }
 case 262: { LL_LPUART_SetRXFIFOThreshold(uart, (uint32_t)args[0]); return 0; }
 case 263: { uint32_t result=LL_LPUART_GetRXFIFOThreshold(uart); return result; }
 case 264: { LL_LPUART_ConfigFIFOsThreshold(uart, (uint32_t)args[0], (uint32_t)args[1]); return 0; }
 case 265: { LL_LPUART_EnableInStopMode(uart); return 0; }
 case 266: { LL_LPUART_DisableInStopMode(uart); return 0; }
 case 267: { uint32_t result=LL_LPUART_IsEnabledInStopMode(uart); return result; }
 case 268: { LL_LPUART_EnableDirectionRx(uart); return 0; }
 case 269: { LL_LPUART_DisableDirectionRx(uart); return 0; }
 case 270: { LL_LPUART_EnableDirectionTx(uart); return 0; }
 case 271: { LL_LPUART_DisableDirectionTx(uart); return 0; }
 case 272: { LL_LPUART_SetTransferDirection(uart, (uint32_t)args[0]); return 0; }
 case 273: { uint32_t result=LL_LPUART_GetTransferDirection(uart); return result; }
 case 274: { LL_LPUART_SetParity(uart, (uint32_t)args[0]); return 0; }
 case 275: { uint32_t result=LL_LPUART_GetParity(uart); return result; }
 case 276: { LL_LPUART_SetWakeUpMethod(uart, (uint32_t)args[0]); return 0; }
 case 277: { uint32_t result=LL_LPUART_GetWakeUpMethod(uart); return result; }
 case 278: { LL_LPUART_SetDataWidth(uart, (uint32_t)args[0]); return 0; }
 case 279: { uint32_t result=LL_LPUART_GetDataWidth(uart); return result; }
 case 280: { LL_LPUART_EnableMuteMode(uart); return 0; }
 case 281: { LL_LPUART_DisableMuteMode(uart); return 0; }
 case 282: { uint32_t result=LL_LPUART_IsEnabledMuteMode(uart); return result; }
 case 283: { LL_LPUART_SetPrescaler(uart, (uint32_t)args[0]); return 0; }
 case 284: { uint32_t result=LL_LPUART_GetPrescaler(uart); return result; }
 case 285: { LL_LPUART_SetStopBitsLength(uart, (uint32_t)args[0]); return 0; }
 case 286: { uint32_t result=LL_LPUART_GetStopBitsLength(uart); return result; }
 case 287: { LL_LPUART_ConfigCharacter(uart, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2]); return 0; }
 case 288: { LL_LPUART_SetTXRXSwap(uart, (uint32_t)args[0]); return 0; }
 case 289: { uint32_t result=LL_LPUART_GetTXRXSwap(uart); return result; }
 case 290: { LL_LPUART_SetRXPinLevel(uart, (uint32_t)args[0]); return 0; }
 case 291: { uint32_t result=LL_LPUART_GetRXPinLevel(uart); return result; }
 case 292: { LL_LPUART_SetTXPinLevel(uart, (uint32_t)args[0]); return 0; }
 case 293: { uint32_t result=LL_LPUART_GetTXPinLevel(uart); return result; }
 case 294: { LL_LPUART_SetBinaryDataLogic(uart, (uint32_t)args[0]); return 0; }
 case 295: { uint32_t result=LL_LPUART_GetBinaryDataLogic(uart); return result; }
 case 296: { LL_LPUART_SetTransferBitOrder(uart, (uint32_t)args[0]); return 0; }
 case 297: { uint32_t result=LL_LPUART_GetTransferBitOrder(uart); return result; }
 case 298: { LL_LPUART_ConfigNodeAddress(uart, (uint32_t)args[0], (uint32_t)args[1]); return 0; }
 case 299: { uint32_t result=LL_LPUART_GetNodeAddress(uart); return result; }
 case 300: { uint32_t result=LL_LPUART_GetNodeAddressLen(uart); return result; }
 case 301: { LL_LPUART_EnableRTSHWFlowCtrl(uart); return 0; }
 case 302: { LL_LPUART_DisableRTSHWFlowCtrl(uart); return 0; }
 case 303: { LL_LPUART_EnableCTSHWFlowCtrl(uart); return 0; }
 case 304: { LL_LPUART_DisableCTSHWFlowCtrl(uart); return 0; }
 case 305: { LL_LPUART_SetHWFlowCtrl(uart, (uint32_t)args[0]); return 0; }
 case 306: { uint32_t result=LL_LPUART_GetHWFlowCtrl(uart); return result; }
 case 307: { LL_LPUART_EnableOverrunDetect(uart); return 0; }
 case 308: { LL_LPUART_DisableOverrunDetect(uart); return 0; }
 case 309: { uint32_t result=LL_LPUART_IsEnabledOverrunDetect(uart); return result; }
 case 310: { LL_LPUART_SetWKUPType(uart, (uint32_t)args[0]); return 0; }
 case 311: { uint32_t result=LL_LPUART_GetWKUPType(uart); return result; }
 case 312: { LL_LPUART_SetBaudRate(uart, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2]); return 0; }
 case 313: { uint32_t result=LL_LPUART_GetBaudRate(uart, (uint32_t)args[0], (uint32_t)args[1]); return result; }
 case 314: { LL_LPUART_EnableHalfDuplex(uart); return 0; }
 case 315: { LL_LPUART_DisableHalfDuplex(uart); return 0; }
 case 316: { uint32_t result=LL_LPUART_IsEnabledHalfDuplex(uart); return result; }
 case 317: { LL_LPUART_SetDEDeassertionTime(uart, (uint32_t)args[0]); return 0; }
 case 318: { uint32_t result=LL_LPUART_GetDEDeassertionTime(uart); return result; }
 case 319: { LL_LPUART_SetDEAssertionTime(uart, (uint32_t)args[0]); return 0; }
 case 320: { uint32_t result=LL_LPUART_GetDEAssertionTime(uart); return result; }
 case 321: { LL_LPUART_EnableDEMode(uart); return 0; }
 case 322: { LL_LPUART_DisableDEMode(uart); return 0; }
 case 323: { uint32_t result=LL_LPUART_IsEnabledDEMode(uart); return result; }
 case 324: { LL_LPUART_SetDESignalPolarity(uart, (uint32_t)args[0]); return 0; }
 case 325: { uint32_t result=LL_LPUART_GetDESignalPolarity(uart); return result; }
 case 326: { uint32_t result=LL_LPUART_IsActiveFlag_PE(uart); return result; }
 case 327: { uint32_t result=LL_LPUART_IsActiveFlag_FE(uart); return result; }
 case 328: { uint32_t result=LL_LPUART_IsActiveFlag_NE(uart); return result; }
 case 329: { uint32_t result=LL_LPUART_IsActiveFlag_ORE(uart); return result; }
 case 330: { uint32_t result=LL_LPUART_IsActiveFlag_IDLE(uart); return result; }
 case 331: { uint32_t result=LL_LPUART_IsActiveFlag_RXNE_RXFNE(uart); return result; }
 case 332: { uint32_t result=LL_LPUART_IsActiveFlag_TC(uart); return result; }
 case 333: { uint32_t result=LL_LPUART_IsActiveFlag_TXE_TXFNF(uart); return result; }
 case 334: { uint32_t result=LL_LPUART_IsActiveFlag_nCTS(uart); return result; }
 case 335: { uint32_t result=LL_LPUART_IsActiveFlag_CTS(uart); return result; }
 case 336: { uint32_t result=LL_LPUART_IsActiveFlag_BUSY(uart); return result; }
 case 337: { uint32_t result=LL_LPUART_IsActiveFlag_CM(uart); return result; }
 case 338: { uint32_t result=LL_LPUART_IsActiveFlag_SBK(uart); return result; }
 case 339: { uint32_t result=LL_LPUART_IsActiveFlag_RWU(uart); return result; }
 case 340: { uint32_t result=LL_LPUART_IsActiveFlag_WKUP(uart); return result; }
 case 341: { uint32_t result=LL_LPUART_IsActiveFlag_TEACK(uart); return result; }
 case 342: { uint32_t result=LL_LPUART_IsActiveFlag_REACK(uart); return result; }
 case 343: { uint32_t result=LL_LPUART_IsActiveFlag_TXFE(uart); return result; }
 case 344: { uint32_t result=LL_LPUART_IsActiveFlag_RXFF(uart); return result; }
 case 345: { uint32_t result=LL_LPUART_IsActiveFlag_TXFT(uart); return result; }
 case 346: { uint32_t result=LL_LPUART_IsActiveFlag_RXFT(uart); return result; }
 case 347: { LL_LPUART_ClearFlag_PE(uart); return 0; }
 case 348: { LL_LPUART_ClearFlag_FE(uart); return 0; }
 case 349: { LL_LPUART_ClearFlag_NE(uart); return 0; }
 case 350: { LL_LPUART_ClearFlag_ORE(uart); return 0; }
 case 351: { LL_LPUART_ClearFlag_IDLE(uart); return 0; }
 case 352: { LL_LPUART_ClearFlag_TC(uart); return 0; }
 case 353: { LL_LPUART_ClearFlag_nCTS(uart); return 0; }
 case 354: { LL_LPUART_ClearFlag_CM(uart); return 0; }
 case 355: { LL_LPUART_ClearFlag_WKUP(uart); return 0; }
 case 356: { LL_LPUART_EnableIT_IDLE(uart); return 0; }
 case 357: { LL_LPUART_EnableIT_RXNE_RXFNE(uart); return 0; }
 case 358: { LL_LPUART_EnableIT_TC(uart); return 0; }
 case 359: { LL_LPUART_EnableIT_TXE_TXFNF(uart); return 0; }
 case 360: { LL_LPUART_EnableIT_PE(uart); return 0; }
 case 361: { LL_LPUART_EnableIT_CM(uart); return 0; }
 case 362: { LL_LPUART_EnableIT_TXFE(uart); return 0; }
 case 363: { LL_LPUART_EnableIT_RXFF(uart); return 0; }
 case 364: { LL_LPUART_EnableIT_ERROR(uart); return 0; }
 case 365: { LL_LPUART_EnableIT_CTS(uart); return 0; }
 case 366: { LL_LPUART_EnableIT_WKUP(uart); return 0; }
 case 367: { LL_LPUART_EnableIT_TXFT(uart); return 0; }
 case 368: { LL_LPUART_EnableIT_RXFT(uart); return 0; }
 case 369: { LL_LPUART_DisableIT_IDLE(uart); return 0; }
 case 370: { LL_LPUART_DisableIT_RXNE_RXFNE(uart); return 0; }
 case 371: { LL_LPUART_DisableIT_TC(uart); return 0; }
 case 372: { LL_LPUART_DisableIT_TXE_TXFNF(uart); return 0; }
 case 373: { LL_LPUART_DisableIT_PE(uart); return 0; }
 case 374: { LL_LPUART_DisableIT_CM(uart); return 0; }
 case 375: { LL_LPUART_DisableIT_TXFE(uart); return 0; }
 case 376: { LL_LPUART_DisableIT_RXFF(uart); return 0; }
 case 377: { LL_LPUART_DisableIT_ERROR(uart); return 0; }
 case 378: { LL_LPUART_DisableIT_CTS(uart); return 0; }
 case 379: { LL_LPUART_DisableIT_WKUP(uart); return 0; }
 case 380: { LL_LPUART_DisableIT_TXFT(uart); return 0; }
 case 381: { LL_LPUART_DisableIT_RXFT(uart); return 0; }
 case 382: { uint32_t result=LL_LPUART_IsEnabledIT_IDLE(uart); return result; }
 case 383: { uint32_t result=LL_LPUART_IsEnabledIT_RXNE_RXFNE(uart); return result; }
 case 384: { uint32_t result=LL_LPUART_IsEnabledIT_TC(uart); return result; }
 case 385: { uint32_t result=LL_LPUART_IsEnabledIT_TXE_TXFNF(uart); return result; }
 case 386: { uint32_t result=LL_LPUART_IsEnabledIT_PE(uart); return result; }
 case 387: { uint32_t result=LL_LPUART_IsEnabledIT_CM(uart); return result; }
 case 388: { uint32_t result=LL_LPUART_IsEnabledIT_TXFE(uart); return result; }
 case 389: { uint32_t result=LL_LPUART_IsEnabledIT_RXFF(uart); return result; }
 case 390: { uint32_t result=LL_LPUART_IsEnabledIT_ERROR(uart); return result; }
 case 391: { uint32_t result=LL_LPUART_IsEnabledIT_CTS(uart); return result; }
 case 392: { uint32_t result=LL_LPUART_IsEnabledIT_WKUP(uart); return result; }
 case 393: { uint32_t result=LL_LPUART_IsEnabledIT_TXFT(uart); return result; }
 case 394: { uint32_t result=LL_LPUART_IsEnabledIT_RXFT(uart); return result; }
 case 395: { LL_LPUART_EnableDMAReq_RX(uart); return 0; }
 case 396: { LL_LPUART_DisableDMAReq_RX(uart); return 0; }
 case 397: { uint32_t result=LL_LPUART_IsEnabledDMAReq_RX(uart); return result; }
 case 398: { LL_LPUART_EnableDMAReq_TX(uart); return 0; }
 case 399: { LL_LPUART_DisableDMAReq_TX(uart); return 0; }
 case 400: { uint32_t result=LL_LPUART_IsEnabledDMAReq_TX(uart); return result; }
 case 401: { LL_LPUART_EnableDMADeactOnRxErr(uart); return 0; }
 case 402: { LL_LPUART_DisableDMADeactOnRxErr(uart); return 0; }
 case 403: { uint32_t result=LL_LPUART_IsEnabledDMADeactOnRxErr(uart); return result; }
 case 404: { uint32_t result=LL_LPUART_DMA_GetRegAddr(uart, (uint32_t)args[0]); return result; }
 case 405: { uint32_t result=LL_LPUART_ReceiveData8(uart); return result; }
 case 406: { uint32_t result=LL_LPUART_ReceiveData9(uart); return result; }
 case 407: { LL_LPUART_TransmitData8(uart, (uint8_t)args[0]); return 0; }
 case 408: { LL_LPUART_TransmitData9(uart, (uint16_t)args[0]); return 0; }
 case 409: { LL_LPUART_RequestBreakSending(uart); return 0; }
 case 410: { LL_LPUART_RequestEnterMuteMode(uart); return 0; }
 case 411: { LL_LPUART_RequestRxDataFlush(uart); return 0; }
 case 412: { LL_LPUART_RequestTxDataFlush(uart); return 0; }
 case 413: { uint32_t result=LL_LPUART_DeInit(uart); return result; }
 case 414: { LL_LPUART_InitTypeDef v1={args[0], args[1], args[2], args[3], args[4], args[5], args[6]}; uint32_t result=LL_LPUART_Init(uart, &v1); s->cells[512]=v1.PrescalerValue; s->cells[513]=v1.BaudRate; s->cells[514]=v1.DataWidth; s->cells[515]=v1.StopBits; s->cells[516]=v1.Parity; s->cells[517]=v1.TransferDirection; s->cells[518]=v1.HardwareFlowControl; return result; }
 case 415: { LL_LPUART_InitTypeDef v0={args[0], args[1], args[2], args[3], args[4], args[5], args[6]}; LL_LPUART_StructInit(&v0); s->cells[512]=v0.PrescalerValue; s->cells[513]=v0.BaudRate; s->cells[514]=v0.DataWidth; s->cells[515]=v0.StopBits; s->cells[516]=v0.Parity; s->cells[517]=v0.TransferDirection; s->cells[518]=v0.HardwareFlowControl; return 0; }
 case 416: { return LL_USART_IsActiveFlag_RXNE(uart); }
 case 417: { return LL_USART_IsActiveFlag_TXE(uart); }
 case 418: { LL_USART_EnableIT_RXNE(uart);return 0; }
 case 419: { LL_USART_EnableIT_TXE(uart);return 0; }
 case 420: { LL_USART_DisableIT_RXNE(uart);return 0; }
 case 421: { LL_USART_DisableIT_TXE(uart);return 0; }
 case 422: { return LL_USART_IsEnabledIT_RXNE(uart); }
 case 423: { return LL_USART_IsEnabledIT_TXE(uart); }
 case 424: { return LL_LPUART_IsActiveFlag_RXNE(uart); }
 case 425: { return LL_LPUART_IsActiveFlag_TXE(uart); }
 case 426: { LL_LPUART_EnableIT_RXNE(uart);return 0; }
 case 427: { LL_LPUART_EnableIT_TXE(uart);return 0; }
 case 428: { LL_LPUART_DisableIT_RXNE(uart);return 0; }
 case 429: { LL_LPUART_DisableIT_TXE(uart);return 0; }
 case 430: { return LL_LPUART_IsEnabledIT_RXNE(uart); }
 case 431: { return LL_LPUART_IsEnabledIT_TXE(uart); }
 case 432: { LL_USART_WriteReg(uart,CR2,args[0]);return LL_USART_ReadReg(uart,CR2); }
 case 433: { LL_LPUART_WriteReg(uart,CR2,args[0]);return LL_LPUART_ReadReg(uart,CR2); }
 case 434: { return __LL_USART_DIV_SAMPLING8(args[0],args[1],args[2]); }
 case 435: { return __LL_USART_DIV_SAMPLING16(args[0],args[1],args[2]); }
 case 436: { return __LL_LPUART_DIV(args[0],args[1],args[2]); }
default:abort();}}
uint32_t CL54_Constant(uint32_t i){switch(i){
case 0:return LL_USART_ICR_PECF;
case 1:return LL_USART_ICR_FECF;
case 2:return LL_USART_ICR_NECF;
case 3:return LL_USART_ICR_ORECF;
case 4:return LL_USART_ICR_IDLECF;
case 5:return LL_USART_ICR_TXFECF;
case 6:return LL_USART_ICR_TCCF;
case 7:return LL_USART_ICR_TCBGTCF;
case 8:return LL_USART_ICR_LBDCF;
case 9:return LL_USART_ICR_CTSCF;
case 10:return LL_USART_ICR_RTOCF;
case 11:return LL_USART_ICR_EOBCF;
case 12:return LL_USART_ICR_UDRCF;
case 13:return LL_USART_ICR_CMCF;
case 14:return LL_USART_ICR_WUCF;
case 15:return LL_USART_ISR_PE;
case 16:return LL_USART_ISR_FE;
case 17:return LL_USART_ISR_NE;
case 18:return LL_USART_ISR_ORE;
case 19:return LL_USART_ISR_IDLE;
case 20:return LL_USART_ISR_RXNE_RXFNE;
case 21:return LL_USART_ISR_TC;
case 22:return LL_USART_ISR_TXE_TXFNF;
case 23:return LL_USART_ISR_LBDF;
case 24:return LL_USART_ISR_CTSIF;
case 25:return LL_USART_ISR_CTS;
case 26:return LL_USART_ISR_RTOF;
case 27:return LL_USART_ISR_EOBF;
case 28:return LL_USART_ISR_UDR;
case 29:return LL_USART_ISR_ABRE;
case 30:return LL_USART_ISR_ABRF;
case 31:return LL_USART_ISR_BUSY;
case 32:return LL_USART_ISR_CMF;
case 33:return LL_USART_ISR_SBKF;
case 34:return LL_USART_ISR_RWU;
case 35:return LL_USART_ISR_WUF;
case 36:return LL_USART_ISR_TEACK;
case 37:return LL_USART_ISR_REACK;
case 38:return LL_USART_ISR_TXFE;
case 39:return LL_USART_ISR_RXFF;
case 40:return LL_USART_ISR_TCBGT;
case 41:return LL_USART_ISR_RXFT;
case 42:return LL_USART_ISR_TXFT;
case 43:return LL_USART_CR1_IDLEIE;
case 44:return LL_USART_CR1_RXNEIE_RXFNEIE;
case 45:return LL_USART_CR1_TCIE;
case 46:return LL_USART_CR1_TXEIE_TXFNFIE;
case 47:return LL_USART_CR1_PEIE;
case 48:return LL_USART_CR1_CMIE;
case 49:return LL_USART_CR1_RTOIE;
case 50:return LL_USART_CR1_EOBIE;
case 51:return LL_USART_CR1_TXFEIE;
case 52:return LL_USART_CR1_RXFFIE;
case 53:return LL_USART_CR2_LBDIE;
case 54:return LL_USART_CR3_EIE;
case 55:return LL_USART_CR3_CTSIE;
case 56:return LL_USART_CR3_WUFIE;
case 57:return LL_USART_CR3_TXFTIE;
case 58:return LL_USART_CR3_TCBGTIE;
case 59:return LL_USART_CR3_RXFTIE;
case 60:return LL_USART_FIFOTHRESHOLD_1_8;
case 61:return LL_USART_FIFOTHRESHOLD_1_4;
case 62:return LL_USART_FIFOTHRESHOLD_1_2;
case 63:return LL_USART_FIFOTHRESHOLD_3_4;
case 64:return LL_USART_FIFOTHRESHOLD_7_8;
case 65:return LL_USART_FIFOTHRESHOLD_8_8;
case 66:return LL_USART_DIRECTION_NONE;
case 67:return LL_USART_DIRECTION_RX;
case 68:return LL_USART_DIRECTION_TX;
case 69:return LL_USART_DIRECTION_TX_RX;
case 70:return LL_USART_PARITY_NONE;
case 71:return LL_USART_PARITY_EVEN;
case 72:return LL_USART_PARITY_ODD;
case 73:return LL_USART_WAKEUP_IDLELINE;
case 74:return LL_USART_WAKEUP_ADDRESSMARK;
case 75:return LL_USART_DATAWIDTH_7B;
case 76:return LL_USART_DATAWIDTH_8B;
case 77:return LL_USART_DATAWIDTH_9B;
case 78:return LL_USART_OVERSAMPLING_16;
case 79:return LL_USART_OVERSAMPLING_8;
case 80:return LL_USART_CLOCK_DISABLE;
case 81:return LL_USART_CLOCK_ENABLE;
case 82:return LL_USART_LASTCLKPULSE_NO_OUTPUT;
case 83:return LL_USART_LASTCLKPULSE_OUTPUT;
case 84:return LL_USART_PHASE_1EDGE;
case 85:return LL_USART_PHASE_2EDGE;
case 86:return LL_USART_POLARITY_LOW;
case 87:return LL_USART_POLARITY_HIGH;
case 88:return LL_USART_PRESCALER_DIV1;
case 89:return LL_USART_PRESCALER_DIV2;
case 90:return LL_USART_PRESCALER_DIV4;
case 91:return LL_USART_PRESCALER_DIV6;
case 92:return LL_USART_PRESCALER_DIV8;
case 93:return LL_USART_PRESCALER_DIV10;
case 94:return LL_USART_PRESCALER_DIV12;
case 95:return LL_USART_PRESCALER_DIV16;
case 96:return LL_USART_PRESCALER_DIV32;
case 97:return LL_USART_PRESCALER_DIV64;
case 98:return LL_USART_PRESCALER_DIV128;
case 99:return LL_USART_PRESCALER_DIV256;
case 100:return LL_USART_STOPBITS_0_5;
case 101:return LL_USART_STOPBITS_1;
case 102:return LL_USART_STOPBITS_1_5;
case 103:return LL_USART_STOPBITS_2;
case 104:return LL_USART_TXRX_STANDARD;
case 105:return LL_USART_TXRX_SWAPPED;
case 106:return LL_USART_RXPIN_LEVEL_STANDARD;
case 107:return LL_USART_RXPIN_LEVEL_INVERTED;
case 108:return LL_USART_TXPIN_LEVEL_STANDARD;
case 109:return LL_USART_TXPIN_LEVEL_INVERTED;
case 110:return LL_USART_BINARY_LOGIC_POSITIVE;
case 111:return LL_USART_BINARY_LOGIC_NEGATIVE;
case 112:return LL_USART_BITORDER_LSBFIRST;
case 113:return LL_USART_BITORDER_MSBFIRST;
case 114:return LL_USART_AUTOBAUD_DETECT_ON_STARTBIT;
case 115:return LL_USART_AUTOBAUD_DETECT_ON_FALLINGEDGE;
case 116:return LL_USART_AUTOBAUD_DETECT_ON_7F_FRAME;
case 117:return LL_USART_AUTOBAUD_DETECT_ON_55_FRAME;
case 118:return LL_USART_ADDRESS_DETECT_4B;
case 119:return LL_USART_ADDRESS_DETECT_7B;
case 120:return LL_USART_HWCONTROL_NONE;
case 121:return LL_USART_HWCONTROL_RTS;
case 122:return LL_USART_HWCONTROL_CTS;
case 123:return LL_USART_HWCONTROL_RTS_CTS;
case 124:return LL_USART_WAKEUP_ON_ADDRESS;
case 125:return LL_USART_WAKEUP_ON_STARTBIT;
case 126:return LL_USART_WAKEUP_ON_RXNE;
case 127:return LL_USART_IRDA_POWER_NORMAL;
case 128:return LL_USART_IRDA_POWER_LOW;
case 129:return LL_USART_LINBREAK_DETECT_10B;
case 130:return LL_USART_LINBREAK_DETECT_11B;
case 131:return LL_USART_DE_POLARITY_HIGH;
case 132:return LL_USART_DE_POLARITY_LOW;
case 133:return LL_USART_DMA_REG_DATA_TRANSMIT;
case 134:return LL_USART_DMA_REG_DATA_RECEIVE;
case 135:return LL_LPUART_ICR_PECF;
case 136:return LL_LPUART_ICR_FECF;
case 137:return LL_LPUART_ICR_NCF;
case 138:return LL_LPUART_ICR_ORECF;
case 139:return LL_LPUART_ICR_IDLECF;
case 140:return LL_LPUART_ICR_TCCF;
case 141:return LL_LPUART_ICR_CTSCF;
case 142:return LL_LPUART_ICR_CMCF;
case 143:return LL_LPUART_ICR_WUCF;
case 144:return LL_LPUART_ISR_PE;
case 145:return LL_LPUART_ISR_FE;
case 146:return LL_LPUART_ISR_NE;
case 147:return LL_LPUART_ISR_ORE;
case 148:return LL_LPUART_ISR_IDLE;
case 149:return LL_LPUART_ISR_RXNE_RXFNE;
case 150:return LL_LPUART_ISR_TC;
case 151:return LL_LPUART_ISR_TXE_TXFNF;
case 152:return LL_LPUART_ISR_CTSIF;
case 153:return LL_LPUART_ISR_CTS;
case 154:return LL_LPUART_ISR_BUSY;
case 155:return LL_LPUART_ISR_CMF;
case 156:return LL_LPUART_ISR_SBKF;
case 157:return LL_LPUART_ISR_RWU;
case 158:return LL_LPUART_ISR_WUF;
case 159:return LL_LPUART_ISR_TEACK;
case 160:return LL_LPUART_ISR_REACK;
case 161:return LL_LPUART_ISR_TXFE;
case 162:return LL_LPUART_ISR_RXFF;
case 163:return LL_LPUART_ISR_RXFT;
case 164:return LL_LPUART_ISR_TXFT;
case 165:return LL_LPUART_CR1_IDLEIE;
case 166:return LL_LPUART_CR1_RXNEIE_RXFNEIE;
case 167:return LL_LPUART_CR1_TCIE;
case 168:return LL_LPUART_CR1_TXEIE_TXFNFIE;
case 169:return LL_LPUART_CR1_PEIE;
case 170:return LL_LPUART_CR1_CMIE;
case 171:return LL_LPUART_CR1_TXFEIE;
case 172:return LL_LPUART_CR1_RXFFIE;
case 173:return LL_LPUART_CR3_EIE;
case 174:return LL_LPUART_CR3_CTSIE;
case 175:return LL_LPUART_CR3_WUFIE;
case 176:return LL_LPUART_CR3_TXFTIE;
case 177:return LL_LPUART_CR3_RXFTIE;
case 178:return LL_LPUART_FIFOTHRESHOLD_1_8;
case 179:return LL_LPUART_FIFOTHRESHOLD_1_4;
case 180:return LL_LPUART_FIFOTHRESHOLD_1_2;
case 181:return LL_LPUART_FIFOTHRESHOLD_3_4;
case 182:return LL_LPUART_FIFOTHRESHOLD_7_8;
case 183:return LL_LPUART_FIFOTHRESHOLD_8_8;
case 184:return LL_LPUART_DIRECTION_NONE;
case 185:return LL_LPUART_DIRECTION_RX;
case 186:return LL_LPUART_DIRECTION_TX;
case 187:return LL_LPUART_DIRECTION_TX_RX;
case 188:return LL_LPUART_PARITY_NONE;
case 189:return LL_LPUART_PARITY_EVEN;
case 190:return LL_LPUART_PARITY_ODD;
case 191:return LL_LPUART_WAKEUP_IDLELINE;
case 192:return LL_LPUART_WAKEUP_ADDRESSMARK;
case 193:return LL_LPUART_DATAWIDTH_7B;
case 194:return LL_LPUART_DATAWIDTH_8B;
case 195:return LL_LPUART_DATAWIDTH_9B;
case 196:return LL_LPUART_PRESCALER_DIV1;
case 197:return LL_LPUART_PRESCALER_DIV2;
case 198:return LL_LPUART_PRESCALER_DIV4;
case 199:return LL_LPUART_PRESCALER_DIV6;
case 200:return LL_LPUART_PRESCALER_DIV8;
case 201:return LL_LPUART_PRESCALER_DIV10;
case 202:return LL_LPUART_PRESCALER_DIV12;
case 203:return LL_LPUART_PRESCALER_DIV16;
case 204:return LL_LPUART_PRESCALER_DIV32;
case 205:return LL_LPUART_PRESCALER_DIV64;
case 206:return LL_LPUART_PRESCALER_DIV128;
case 207:return LL_LPUART_PRESCALER_DIV256;
case 208:return LL_LPUART_STOPBITS_1;
case 209:return LL_LPUART_STOPBITS_2;
case 210:return LL_LPUART_TXRX_STANDARD;
case 211:return LL_LPUART_TXRX_SWAPPED;
case 212:return LL_LPUART_RXPIN_LEVEL_STANDARD;
case 213:return LL_LPUART_RXPIN_LEVEL_INVERTED;
case 214:return LL_LPUART_TXPIN_LEVEL_STANDARD;
case 215:return LL_LPUART_TXPIN_LEVEL_INVERTED;
case 216:return LL_LPUART_BINARY_LOGIC_POSITIVE;
case 217:return LL_LPUART_BINARY_LOGIC_NEGATIVE;
case 218:return LL_LPUART_BITORDER_LSBFIRST;
case 219:return LL_LPUART_BITORDER_MSBFIRST;
case 220:return LL_LPUART_ADDRESS_DETECT_4B;
case 221:return LL_LPUART_ADDRESS_DETECT_7B;
case 222:return LL_LPUART_HWCONTROL_NONE;
case 223:return LL_LPUART_HWCONTROL_RTS;
case 224:return LL_LPUART_HWCONTROL_CTS;
case 225:return LL_LPUART_HWCONTROL_RTS_CTS;
case 226:return LL_LPUART_WAKEUP_ON_ADDRESS;
case 227:return LL_LPUART_WAKEUP_ON_STARTBIT;
case 228:return LL_LPUART_WAKEUP_ON_RXNE;
case 229:return LL_LPUART_DE_POLARITY_HIGH;
case 230:return LL_LPUART_DE_POLARITY_LOW;
case 231:return LL_LPUART_DMA_REG_DATA_TRANSMIT;
case 232:return LL_LPUART_DMA_REG_DATA_RECEIVE;
case 233:return USART_PRESCALER_TAB[0];
case 234:return USART_PRESCALER_TAB[1];
case 235:return USART_PRESCALER_TAB[2];
case 236:return USART_PRESCALER_TAB[3];
case 237:return USART_PRESCALER_TAB[4];
case 238:return USART_PRESCALER_TAB[5];
case 239:return USART_PRESCALER_TAB[6];
case 240:return USART_PRESCALER_TAB[7];
case 241:return USART_PRESCALER_TAB[8];
case 242:return USART_PRESCALER_TAB[9];
case 243:return USART_PRESCALER_TAB[10];
case 244:return USART_PRESCALER_TAB[11];
case 245:return LPUART_PRESCALER_TAB[0];
case 246:return LPUART_PRESCALER_TAB[1];
case 247:return LPUART_PRESCALER_TAB[2];
case 248:return LPUART_PRESCALER_TAB[3];
case 249:return LPUART_PRESCALER_TAB[4];
case 250:return LPUART_PRESCALER_TAB[5];
case 251:return LPUART_PRESCALER_TAB[6];
case 252:return LPUART_PRESCALER_TAB[7];
case 253:return LPUART_PRESCALER_TAB[8];
case 254:return LPUART_PRESCALER_TAB[9];
case 255:return LPUART_PRESCALER_TAB[10];
case 256:return LPUART_PRESCALER_TAB[11];
default:abort();}}
