#include "include/CLLI2CReference.h"
#include <stdlib.h>
#include <assert.h>
#include "Upstream/I2C/Trace/stm32h7rsxx_ll_i2c.h"
#include "Upstream/I2C/Trace/stm32h7rsxx_ll_i3c.h"
#include "Upstream/I2C/Trace/stm32h7rsxx_ll_i2c.inc"
#include "Upstream/I2C/Trace/stm32h7rsxx_ll_i3c.inc"
struct CL56State {uint32_t cells[512],count,reads,salt,instance;CL56Access trace[256];};
_Thread_local uint32_t *CL56_Cells;
static _Thread_local CL56State *current;
CL56State *CL56_Create(void){return calloc(1,sizeof(CL56State));}
void CL56_Destroy(CL56State *s){free(s);}
void CL56_Reset(CL56State *s,uint32_t seed,uint32_t salt,uint32_t instance){current=s;CL56_Cells=s->cells;for(uint32_t i=0;i<512;i++)s->cells[i]=seed^(i*0x9E3779B9U);s->count=0;s->reads=0;s->salt=salt;s->instance=instance;}
static void record(uint32_t i,uint32_t v,uint32_t k){assert(i<512&&current->count<256);current->trace[current->count++]=(CL56Access){i,v,k};}
static uint32_t indexOf(volatile const uint32_t *p){uintptr_t d=(uintptr_t)p-(uintptr_t)CL56_Cells;assert(d<2048&&d%4==0);return (uint32_t)d/4;}
uint32_t CL56_Read(volatile const uint32_t *p){uint32_t i=indexOf(p),v=*p^(current->salt*current->reads++);record(i,v,0);return v;}
void CL56_Write(volatile uint32_t *p,uint32_t v){record(indexOf(p),v,1);*p=v;}
uint32_t CL56_Address(volatile const uint32_t *p){uint32_t i=indexOf(p);assert(i<128);if(i>=64)return 0x40005400U+(i-64)*4;uint32_t instance=i/16;return (instance<3?0x40005400U+instance*0x400U:0xFFFF0000U)+(i%16)*4;}
uint32_t *CL56_GetCells(CL56State *s){return s->cells;}
const CL56Access *CL56_GetTrace(CL56State *s){return s->trace;}
uint32_t CL56_GetTraceCount(CL56State *s){return s->count;}
uint32_t CL56_Run(CL56State *s,uint32_t op,const uint32_t *args){current=s;CL56_Cells=s->cells;I2C_TypeDef *i2c=(I2C_TypeDef *)(s->cells+s->instance*16);I3C_TypeDef *i3c=I3C1;switch(op){
case 0:{LL_I2C_Enable(i2c); return 0;}
case 1:{LL_I2C_Disable(i2c); return 0;}
case 2:{uint32_t result=LL_I2C_IsEnabled(i2c); return result;}
case 3:{LL_I2C_ConfigFilters(i2c, (uint32_t)args[0], (uint32_t)args[1]); return 0;}
case 4:{LL_I2C_SetDigitalFilter(i2c, (uint32_t)args[0]); return 0;}
case 5:{uint32_t result=LL_I2C_GetDigitalFilter(i2c); return result;}
case 6:{LL_I2C_EnableAnalogFilter(i2c); return 0;}
case 7:{LL_I2C_DisableAnalogFilter(i2c); return 0;}
case 8:{uint32_t result=LL_I2C_IsEnabledAnalogFilter(i2c); return result;}
case 9:{LL_I2C_EnableDMAReq_TX(i2c); return 0;}
case 10:{LL_I2C_DisableDMAReq_TX(i2c); return 0;}
case 11:{uint32_t result=LL_I2C_IsEnabledDMAReq_TX(i2c); return result;}
case 12:{LL_I2C_EnableDMAReq_RX(i2c); return 0;}
case 13:{LL_I2C_DisableDMAReq_RX(i2c); return 0;}
case 14:{uint32_t result=LL_I2C_IsEnabledDMAReq_RX(i2c); return result;}
case 15:{uint32_t result=LL_I2C_DMA_GetRegAddr(i2c, (uint32_t)args[0]); return result;}
case 16:{LL_I2C_EnableClockStretching(i2c); return 0;}
case 17:{LL_I2C_DisableClockStretching(i2c); return 0;}
case 18:{uint32_t result=LL_I2C_IsEnabledClockStretching(i2c); return result;}
case 19:{LL_I2C_EnableSlaveByteControl(i2c); return 0;}
case 20:{LL_I2C_DisableSlaveByteControl(i2c); return 0;}
case 21:{uint32_t result=LL_I2C_IsEnabledSlaveByteControl(i2c); return result;}
case 22:{LL_I2C_EnableWakeUpFromStop(i2c); return 0;}
case 23:{LL_I2C_DisableWakeUpFromStop(i2c); return 0;}
case 24:{uint32_t result=LL_I2C_IsEnabledWakeUpFromStop(i2c); return result;}
case 25:{LL_I2C_EnableGeneralCall(i2c); return 0;}
case 26:{LL_I2C_DisableGeneralCall(i2c); return 0;}
case 27:{uint32_t result=LL_I2C_IsEnabledGeneralCall(i2c); return result;}
case 28:{LL_I2C_EnableFastModePlus(i2c); return 0;}
case 29:{LL_I2C_DisableFastModePlus(i2c); return 0;}
case 30:{uint32_t result=LL_I2C_IsEnabledFastModePlus(i2c); return result;}
case 31:{LL_I2C_EnableAutoClearFlag_ADDR(i2c); return 0;}
case 32:{LL_I2C_DisableAutoClearFlag_ADDR(i2c); return 0;}
case 33:{uint32_t result=LL_I2C_IsEnabledAutoClearFlag_ADDR(i2c); return result;}
case 34:{LL_I2C_EnableAutoClearFlag_STOP(i2c); return 0;}
case 35:{LL_I2C_DisableAutoClearFlag_STOP(i2c); return 0;}
case 36:{uint32_t result=LL_I2C_IsEnabledAutoClearFlag_STOP(i2c); return result;}
case 37:{LL_I2C_SetMasterAddressingMode(i2c, (uint32_t)args[0]); return 0;}
case 38:{uint32_t result=LL_I2C_GetMasterAddressingMode(i2c); return result;}
case 39:{LL_I2C_SetOwnAddress1(i2c, (uint32_t)args[0], (uint32_t)args[1]); return 0;}
case 40:{LL_I2C_EnableOwnAddress1(i2c); return 0;}
case 41:{LL_I2C_DisableOwnAddress1(i2c); return 0;}
case 42:{uint32_t result=LL_I2C_IsEnabledOwnAddress1(i2c); return result;}
case 43:{LL_I2C_SetOwnAddress2(i2c, (uint32_t)args[0], (uint32_t)args[1]); return 0;}
case 44:{LL_I2C_EnableOwnAddress2(i2c); return 0;}
case 45:{LL_I2C_DisableOwnAddress2(i2c); return 0;}
case 46:{uint32_t result=LL_I2C_IsEnabledOwnAddress2(i2c); return result;}
case 47:{LL_I2C_SetTiming(i2c, (uint32_t)args[0]); return 0;}
case 48:{uint32_t result=LL_I2C_GetTimingPrescaler(i2c); return result;}
case 49:{uint32_t result=LL_I2C_GetClockLowPeriod(i2c); return result;}
case 50:{uint32_t result=LL_I2C_GetClockHighPeriod(i2c); return result;}
case 51:{uint32_t result=LL_I2C_GetDataHoldTime(i2c); return result;}
case 52:{uint32_t result=LL_I2C_GetDataSetupTime(i2c); return result;}
case 53:{LL_I2C_SetMode(i2c, (uint32_t)args[0]); return 0;}
case 54:{uint32_t result=LL_I2C_GetMode(i2c); return result;}
case 55:{LL_I2C_EnableSMBusAlert(i2c); return 0;}
case 56:{LL_I2C_DisableSMBusAlert(i2c); return 0;}
case 57:{uint32_t result=LL_I2C_IsEnabledSMBusAlert(i2c); return result;}
case 58:{LL_I2C_EnableSMBusPEC(i2c); return 0;}
case 59:{LL_I2C_DisableSMBusPEC(i2c); return 0;}
case 60:{uint32_t result=LL_I2C_IsEnabledSMBusPEC(i2c); return result;}
case 61:{LL_I2C_ConfigSMBusTimeout(i2c, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2]); return 0;}
case 62:{LL_I2C_SetSMBusTimeoutA(i2c, (uint32_t)args[0]); return 0;}
case 63:{uint32_t result=LL_I2C_GetSMBusTimeoutA(i2c); return result;}
case 64:{LL_I2C_SetSMBusTimeoutAMode(i2c, (uint32_t)args[0]); return 0;}
case 65:{uint32_t result=LL_I2C_GetSMBusTimeoutAMode(i2c); return result;}
case 66:{LL_I2C_SetSMBusTimeoutB(i2c, (uint32_t)args[0]); return 0;}
case 67:{uint32_t result=LL_I2C_GetSMBusTimeoutB(i2c); return result;}
case 68:{LL_I2C_EnableSMBusTimeout(i2c, (uint32_t)args[0]); return 0;}
case 69:{LL_I2C_DisableSMBusTimeout(i2c, (uint32_t)args[0]); return 0;}
case 70:{uint32_t result=LL_I2C_IsEnabledSMBusTimeout(i2c, (uint32_t)args[0]); return result;}
case 71:{LL_I2C_EnableIT_TX(i2c); return 0;}
case 72:{LL_I2C_DisableIT_TX(i2c); return 0;}
case 73:{uint32_t result=LL_I2C_IsEnabledIT_TX(i2c); return result;}
case 74:{LL_I2C_EnableIT_RX(i2c); return 0;}
case 75:{LL_I2C_DisableIT_RX(i2c); return 0;}
case 76:{uint32_t result=LL_I2C_IsEnabledIT_RX(i2c); return result;}
case 77:{LL_I2C_EnableIT_ADDR(i2c); return 0;}
case 78:{LL_I2C_DisableIT_ADDR(i2c); return 0;}
case 79:{uint32_t result=LL_I2C_IsEnabledIT_ADDR(i2c); return result;}
case 80:{LL_I2C_EnableIT_NACK(i2c); return 0;}
case 81:{LL_I2C_DisableIT_NACK(i2c); return 0;}
case 82:{uint32_t result=LL_I2C_IsEnabledIT_NACK(i2c); return result;}
case 83:{LL_I2C_EnableIT_STOP(i2c); return 0;}
case 84:{LL_I2C_DisableIT_STOP(i2c); return 0;}
case 85:{uint32_t result=LL_I2C_IsEnabledIT_STOP(i2c); return result;}
case 86:{LL_I2C_EnableIT_TC(i2c); return 0;}
case 87:{LL_I2C_DisableIT_TC(i2c); return 0;}
case 88:{uint32_t result=LL_I2C_IsEnabledIT_TC(i2c); return result;}
case 89:{LL_I2C_EnableIT_ERR(i2c); return 0;}
case 90:{LL_I2C_DisableIT_ERR(i2c); return 0;}
case 91:{uint32_t result=LL_I2C_IsEnabledIT_ERR(i2c); return result;}
case 92:{uint32_t result=LL_I2C_IsActiveFlag_TXE(i2c); return result;}
case 93:{uint32_t result=LL_I2C_IsActiveFlag_TXIS(i2c); return result;}
case 94:{uint32_t result=LL_I2C_IsActiveFlag_RXNE(i2c); return result;}
case 95:{uint32_t result=LL_I2C_IsActiveFlag_ADDR(i2c); return result;}
case 96:{uint32_t result=LL_I2C_IsActiveFlag_NACK(i2c); return result;}
case 97:{uint32_t result=LL_I2C_IsActiveFlag_STOP(i2c); return result;}
case 98:{uint32_t result=LL_I2C_IsActiveFlag_TC(i2c); return result;}
case 99:{uint32_t result=LL_I2C_IsActiveFlag_TCR(i2c); return result;}
case 100:{uint32_t result=LL_I2C_IsActiveFlag_BERR(i2c); return result;}
case 101:{uint32_t result=LL_I2C_IsActiveFlag_ARLO(i2c); return result;}
case 102:{uint32_t result=LL_I2C_IsActiveFlag_OVR(i2c); return result;}
case 103:{uint32_t result=LL_I2C_IsActiveSMBusFlag_PECERR(i2c); return result;}
case 104:{uint32_t result=LL_I2C_IsActiveSMBusFlag_TIMEOUT(i2c); return result;}
case 105:{uint32_t result=LL_I2C_IsActiveSMBusFlag_ALERT(i2c); return result;}
case 106:{uint32_t result=LL_I2C_IsActiveFlag_BUSY(i2c); return result;}
case 107:{LL_I2C_ClearFlag_ADDR(i2c); return 0;}
case 108:{LL_I2C_ClearFlag_NACK(i2c); return 0;}
case 109:{LL_I2C_ClearFlag_STOP(i2c); return 0;}
case 110:{LL_I2C_ClearFlag_TXE(i2c); return 0;}
case 111:{LL_I2C_ClearFlag_BERR(i2c); return 0;}
case 112:{LL_I2C_ClearFlag_ARLO(i2c); return 0;}
case 113:{LL_I2C_ClearFlag_OVR(i2c); return 0;}
case 114:{LL_I2C_ClearSMBusFlag_PECERR(i2c); return 0;}
case 115:{LL_I2C_ClearSMBusFlag_TIMEOUT(i2c); return 0;}
case 116:{LL_I2C_ClearSMBusFlag_ALERT(i2c); return 0;}
case 117:{LL_I2C_EnableAutoEndMode(i2c); return 0;}
case 118:{LL_I2C_DisableAutoEndMode(i2c); return 0;}
case 119:{uint32_t result=LL_I2C_IsEnabledAutoEndMode(i2c); return result;}
case 120:{LL_I2C_EnableReloadMode(i2c); return 0;}
case 121:{LL_I2C_DisableReloadMode(i2c); return 0;}
case 122:{uint32_t result=LL_I2C_IsEnabledReloadMode(i2c); return result;}
case 123:{LL_I2C_SetTransferSize(i2c, (uint32_t)args[0]); return 0;}
case 124:{uint32_t result=LL_I2C_GetTransferSize(i2c); return result;}
case 125:{LL_I2C_AcknowledgeNextData(i2c, (uint32_t)args[0]); return 0;}
case 126:{LL_I2C_GenerateStartCondition(i2c); return 0;}
case 127:{LL_I2C_GenerateStopCondition(i2c); return 0;}
case 128:{LL_I2C_EnableAuto10BitRead(i2c); return 0;}
case 129:{LL_I2C_DisableAuto10BitRead(i2c); return 0;}
case 130:{uint32_t result=LL_I2C_IsEnabledAuto10BitRead(i2c); return result;}
case 131:{LL_I2C_SetTransferRequest(i2c, (uint32_t)args[0]); return 0;}
case 132:{uint32_t result=LL_I2C_GetTransferRequest(i2c); return result;}
case 133:{LL_I2C_SetSlaveAddr(i2c, (uint32_t)args[0]); return 0;}
case 134:{uint32_t result=LL_I2C_GetSlaveAddr(i2c); return result;}
case 135:{LL_I2C_HandleTransfer(i2c, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3], (uint32_t)args[4]); return 0;}
case 136:{uint32_t result=LL_I2C_GetTransferDirection(i2c); return result;}
case 137:{uint32_t result=LL_I2C_GetAddressMatchCode(i2c); return result;}
case 138:{LL_I2C_EnableSMBusPECCompare(i2c); return 0;}
case 139:{uint32_t result=LL_I2C_IsEnabledSMBusPECCompare(i2c); return result;}
case 140:{uint32_t result=LL_I2C_GetSMBusPEC(i2c); return result;}
case 141:{uint32_t result=LL_I2C_ReceiveData8(i2c); return result;}
case 142:{LL_I2C_TransmitData8(i2c, (uint8_t)args[0]); return 0;}
case 143:{uint32_t result=LL_I2C_DeInit(i2c); return result;}
case 144:{LL_I2C_InitTypeDef v1={0}; v1.PeripheralMode=(uint32_t)args[0]; v1.Timing=(uint32_t)args[1]; v1.AnalogFilter=(uint32_t)args[2]; v1.DigitalFilter=(uint32_t)args[3]; v1.OwnAddress1=(uint32_t)args[4]; v1.TypeAcknowledge=(uint32_t)args[5]; v1.OwnAddrSize=(uint32_t)args[6]; uint32_t result=LL_I2C_Init(i2c, &v1); s->cells[384]=v1.PeripheralMode; s->cells[385]=v1.Timing; s->cells[386]=v1.AnalogFilter; s->cells[387]=v1.DigitalFilter; s->cells[388]=v1.OwnAddress1; s->cells[389]=v1.TypeAcknowledge; s->cells[390]=v1.OwnAddrSize; return result;}
case 145:{LL_I2C_InitTypeDef v0={0}; v0.PeripheralMode=(uint32_t)args[0]; v0.Timing=(uint32_t)args[1]; v0.AnalogFilter=(uint32_t)args[2]; v0.DigitalFilter=(uint32_t)args[3]; v0.OwnAddress1=(uint32_t)args[4]; v0.TypeAcknowledge=(uint32_t)args[5]; v0.OwnAddrSize=(uint32_t)args[6]; LL_I2C_StructInit(&v0); s->cells[384]=v0.PeripheralMode; s->cells[385]=v0.Timing; s->cells[386]=v0.AnalogFilter; s->cells[387]=v0.DigitalFilter; s->cells[388]=v0.OwnAddress1; s->cells[389]=v0.TypeAcknowledge; s->cells[390]=v0.OwnAddrSize; return 0;}
case 146:{LL_I3C_Enable(i3c); return 0;}
case 147:{LL_I3C_Disable(i3c); return 0;}
case 148:{uint32_t result=LL_I3C_IsEnabled(i3c); return result;}
case 149:{uint32_t result=LL_I3C_IsEnabledReset(i3c); return result;}
case 150:{LL_I3C_SetMode(i3c, (uint32_t)args[0]); return 0;}
case 151:{uint32_t result=LL_I3C_GetMode(i3c); return result;}
case 152:{LL_I3C_EnableArbitrationHeader(i3c); return 0;}
case 153:{LL_I3C_DisableArbitrationHeader(i3c); return 0;}
case 154:{uint32_t result=LL_I3C_IsEnabledArbitrationHeader(i3c); return result;}
case 155:{LL_I3C_EnableResetPattern(i3c); return 0;}
case 156:{LL_I3C_DisableResetPattern(i3c); return 0;}
case 157:{uint32_t result=LL_I3C_IsEnabledResetPattern(i3c); return result;}
case 158:{LL_I3C_EnableExitPattern(i3c); return 0;}
case 159:{LL_I3C_DisableExitPattern(i3c); return 0;}
case 160:{uint32_t result=LL_I3C_IsEnabledExitPattern(i3c); return result;}
case 161:{LL_I3C_EnableHighKeeperSDA(i3c); return 0;}
case 162:{LL_I3C_DisableHighKeeperSDA(i3c); return 0;}
case 163:{uint32_t result=LL_I3C_IsEnabledHighKeeperSDA(i3c); return result;}
case 164:{LL_I3C_EnableHJAck(i3c); return 0;}
case 165:{LL_I3C_DisableHJAck(i3c); return 0;}
case 166:{uint32_t result=LL_I3C_IsEnabledHJAck(i3c); return result;}
case 167:{uint32_t result=LL_I3C_DMA_GetRegAddr(i3c, (uint32_t)args[0]); return result;}
case 168:{LL_I3C_EnableDMAReq_RX(i3c); return 0;}
case 169:{LL_I3C_DisableDMAReq_RX(i3c); return 0;}
case 170:{uint32_t result=LL_I3C_IsEnabledDMAReq_RX(i3c); return result;}
case 171:{LL_I3C_SetRxFIFOThreshold(i3c, (uint32_t)args[0]); return 0;}
case 172:{uint32_t result=LL_I3C_GetRxFIFOThreshold(i3c); return result;}
case 173:{LL_I3C_EnableDMAReq_TX(i3c); return 0;}
case 174:{LL_I3C_DisableDMAReq_TX(i3c); return 0;}
case 175:{uint32_t result=LL_I3C_IsEnabledDMAReq_TX(i3c); return result;}
case 176:{LL_I3C_SetTxFIFOThreshold(i3c, (uint32_t)args[0]); return 0;}
case 177:{uint32_t result=LL_I3C_GetTxFIFOThreshold(i3c); return result;}
case 178:{LL_I3C_EnableDMAReq_Status(i3c); return 0;}
case 179:{LL_I3C_DisableDMAReq_Status(i3c); return 0;}
case 180:{uint32_t result=LL_I3C_IsEnabledDMAReq_Status(i3c); return result;}
case 181:{LL_I3C_EnableStatusFIFO(i3c); return 0;}
case 182:{LL_I3C_DisableStatusFIFO(i3c); return 0;}
case 183:{uint32_t result=LL_I3C_IsEnabledStatusFIFO(i3c); return result;}
case 184:{LL_I3C_EnableControlFIFO(i3c); return 0;}
case 185:{LL_I3C_DisableControlFIFO(i3c); return 0;}
case 186:{uint32_t result=LL_I3C_IsEnabledControlFIFO(i3c); return result;}
case 187:{LL_I3C_EnableDMAReq_Control(i3c); return 0;}
case 188:{LL_I3C_DisableDMAReq_Control(i3c); return 0;}
case 189:{uint32_t result=LL_I3C_IsEnabledDMAReq_Control(i3c); return result;}
case 190:{LL_I3C_EnableOwnDynAddress(i3c); return 0;}
case 191:{LL_I3C_DisableOwnDynAddress(i3c); return 0;}
case 192:{uint32_t result=LL_I3C_IsEnabledOwnDynAddress(i3c); return result;}
case 193:{LL_I3C_SetOwnDynamicAddress(i3c, (uint32_t)args[0]); return 0;}
case 194:{uint32_t result=LL_I3C_GetOwnDynamicAddress(i3c); return result;}
case 195:{LL_I3C_EnableIBI(i3c); return 0;}
case 196:{LL_I3C_DisableIBI(i3c); return 0;}
case 197:{uint32_t result=LL_I3C_IsEnabledIBI(i3c); return result;}
case 198:{LL_I3C_EnableControllerRoleReq(i3c); return 0;}
case 199:{LL_I3C_DisableControllerRoleReq(i3c); return 0;}
case 200:{uint32_t result=LL_I3C_IsEnabledControllerRoleReq(i3c); return result;}
case 201:{LL_I3C_EnableHotJoin(i3c); return 0;}
case 202:{LL_I3C_DisableHotJoin(i3c); return 0;}
case 203:{uint32_t result=LL_I3C_IsEnabledHotJoin(i3c); return result;}
case 204:{LL_I3C_SetMaxReadLength(i3c, (uint16_t)args[0]); return 0;}
case 205:{uint32_t result=LL_I3C_GetMaxReadLength(i3c); return result;}
case 206:{LL_I3C_ConfigNbIBIAddData(i3c, (uint32_t)args[0]); return 0;}
case 207:{uint32_t result=LL_I3C_GetConfigNbIBIAddData(i3c); return result;}
case 208:{LL_I3C_SetMaxWriteLength(i3c, (uint16_t)args[0]); return 0;}
case 209:{uint32_t result=LL_I3C_GetMaxWriteLength(i3c); return result;}
case 210:{LL_I3C_ConfigClockWaveForm(i3c, (uint32_t)args[0]); return 0;}
case 211:{uint32_t result=LL_I3C_GetClockWaveForm(i3c); return result;}
case 212:{LL_I3C_SetPeriodClockLowPP(i3c, (uint32_t)args[0]); return 0;}
case 213:{uint32_t result=LL_I3C_GetPeriodClockLowPP(i3c); return result;}
case 214:{LL_I3C_SetPeriodClockHighI3C(i3c, (uint32_t)args[0]); return 0;}
case 215:{uint32_t result=LL_I3C_GetPeriodClockHighI3C(i3c); return result;}
case 216:{LL_I3C_SetPeriodClockLowOD(i3c, (uint32_t)args[0]); return 0;}
case 217:{uint32_t result=LL_I3C_GetPeriodClockLowOD(i3c); return result;}
case 218:{LL_I3C_SetPeriodClockHighI2C(i3c, (uint32_t)args[0]); return 0;}
case 219:{uint32_t result=LL_I3C_GetPeriodClockHighI2C(i3c); return result;}
case 220:{LL_I3C_SetDataHoldTime(i3c, (uint32_t)args[0]); return 0;}
case 221:{uint32_t result=LL_I3C_GetDataHoldTime(i3c); return result;}
case 222:{LL_I3C_SetAvalTiming(i3c, (uint32_t)args[0]); return 0;}
case 223:{uint32_t result=LL_I3C_GetAvalTiming(i3c); return result;}
case 224:{LL_I3C_SetFreeTiming(i3c, (uint32_t)args[0]); return 0;}
case 225:{uint32_t result=LL_I3C_GetFreeTiming(i3c); return result;}
case 226:{LL_I3C_SetControllerActivityState(i3c, (uint32_t)args[0]); return 0;}
case 227:{uint32_t result=LL_I3C_GetControllerActivityState(i3c); return result;}
case 228:{LL_I3C_SetCtrlBusCharacteristic(i3c, (uint32_t)args[0]); return 0;}
case 229:{uint32_t result=LL_I3C_GetCtrlBusCharacteristic(i3c); return result;}
case 230:{LL_I3C_SetTgtBusCharacteristic(i3c, (uint32_t)args[0]); return 0;}
case 231:{uint32_t result=LL_I3C_GetTgtBusCharacteristic(i3c); return result;}
case 232:{LL_I3C_SetStallTime(i3c, (uint32_t)args[0]); return 0;}
case 233:{uint32_t result=LL_I3C_GetStallTime(i3c); return result;}
case 234:{LL_I3C_EnableStallACK(i3c); return 0;}
case 235:{LL_I3C_DisableStallACK(i3c); return 0;}
case 236:{uint32_t result=LL_I3C_IsEnabledStallACK(i3c); return result;}
case 237:{LL_I3C_EnableStallParityCCC(i3c); return 0;}
case 238:{LL_I3C_DisableStallParityCCC(i3c); return 0;}
case 239:{uint32_t result=LL_I3C_IsEnabledStallParityCCC(i3c); return result;}
case 240:{LL_I3C_EnableStallParityData(i3c); return 0;}
case 241:{LL_I3C_DisableStallParityData(i3c); return 0;}
case 242:{uint32_t result=LL_I3C_IsEnabledStallParityData(i3c); return result;}
case 243:{LL_I3C_EnableStallTbit(i3c); return 0;}
case 244:{LL_I3C_DisableStallTbit(i3c); return 0;}
case 245:{uint32_t result=LL_I3C_IsEnabledStallTbit(i3c); return result;}
case 246:{LL_I3C_SetDeviceCapabilityOnBus(i3c, (uint32_t)args[0]); return 0;}
case 247:{uint32_t result=LL_I3C_GetDeviceCapabilityOnBus(i3c); return result;}
case 248:{LL_I3C_SetDeviceIBIPayload(i3c, (uint32_t)args[0]); return 0;}
case 249:{uint32_t result=LL_I3C_GetDeviceIBIPayload(i3c); return result;}
case 250:{LL_I3C_SetDataSpeedLimitation(i3c, (uint32_t)args[0]); return 0;}
case 251:{uint32_t result=LL_I3C_GetDataSpeedLimitation(i3c); return result;}
case 252:{LL_I3C_SetDeviceCharacteristics(i3c, (uint32_t)args[0]); return 0;}
case 253:{uint32_t result=LL_I3C_GetDeviceCharacteristics(i3c); return result;}
case 254:{LL_I3C_SetPendingReadMDB(i3c, (uint32_t)args[0]); return 0;}
case 255:{uint32_t result=LL_I3C_GetPendingReadMDB(i3c); return result;}
case 256:{LL_I3C_SetGrpAddrHandoffSupport(i3c, (uint32_t)args[0]); return 0;}
case 257:{uint32_t result=LL_I3C_GetGrpAddrHandoffSupport(i3c); return result;}
case 258:{LL_I3C_SetControllerHandoffDelayed(i3c, (uint32_t)args[0]); return 0;}
case 259:{uint32_t result=LL_I3C_GetControllerHandoffDelayed(i3c); return result;}
case 260:{LL_I3C_SetHandoffActivityState(i3c, (uint32_t)args[0]); return 0;}
case 261:{uint32_t result=LL_I3C_GetHandoffActivityState(i3c); return result;}
case 262:{LL_I3C_SetMaxDataSpeedFormat(i3c, (uint32_t)args[0]); return 0;}
case 263:{uint32_t result=LL_I3C_GetMaxDataSpeedFormat(i3c); return result;}
case 264:{LL_I3C_SetMiddleByteTurnAround(i3c, (uint32_t)args[0]); return 0;}
case 265:{uint32_t result=LL_I3C_GetMiddleByteTurnAround(i3c); return result;}
case 266:{LL_I3C_SetDataTurnAroundTime(i3c, (uint32_t)args[0]); return 0;}
case 267:{uint32_t result=LL_I3C_GetDataTurnAroundTime(i3c); return result;}
case 268:{LL_I3C_SetMIPIInstanceID(i3c, (uint32_t)args[0]); return 0;}
case 269:{uint32_t result=LL_I3C_GetMIPIInstanceID(i3c); return result;}
case 270:{uint32_t result=LL_I3C_GetIDTypeSelector(i3c); return result;}
case 271:{uint32_t result=LL_I3C_GetMIPIManufacturerID(i3c); return result;}
case 272:{LL_I3C_RequestRxFIFOFlush(i3c); return 0;}
case 273:{LL_I3C_RequestTxFIFOFlush(i3c); return 0;}
case 274:{LL_I3C_RequestStatusFIFOFlush(i3c); return 0;}
case 275:{uint32_t result=LL_I3C_GetActivityState(i3c); return result;}
case 276:{uint32_t result=LL_I3C_GetResetAction(i3c); return result;}
case 277:{LL_I3C_RequestControlFIFOFlush(i3c); return 0;}
case 278:{LL_I3C_RequestTransfer(i3c); return 0;}
case 279:{LL_I3C_ControllerHandleMessage(i3c, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3], (uint32_t)args[4]); return 0;}
case 280:{LL_I3C_ControllerHandleCCC(i3c, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2]); return 0;}
case 281:{LL_I3C_TargetHandleMessage(i3c, (uint32_t)args[0], (uint32_t)args[1]); return 0;}
case 282:{uint32_t result=LL_I3C_ReceiveData8(i3c); return result;}
case 283:{LL_I3C_TransmitData8(i3c, (uint8_t)args[0]); return 0;}
case 284:{uint32_t result=LL_I3C_ReceiveData32(i3c); return result;}
case 285:{LL_I3C_TransmitData32(i3c, (uint32_t)args[0]); return 0;}
case 286:{LL_I3C_SetIBIPayload(i3c, (uint32_t)args[0]); return 0;}
case 287:{uint32_t result=LL_I3C_GetIBIPayload(i3c); return result;}
case 288:{uint32_t result=LL_I3C_GetNbIBIAddData(i3c); return result;}
case 289:{uint32_t result=LL_I3C_GetIBITargetAddr(i3c); return result;}
case 290:{LL_I3C_ConfigTxPreload(i3c, (uint16_t)args[0]); return 0;}
case 291:{uint32_t result=LL_I3C_IsActiveTxPreload(i3c); return result;}
case 292:{uint32_t result=LL_I3C_GetTxPreloadDataCount(i3c); return result;}
case 293:{uint32_t result=LL_I3C_GetXferDataCount(i3c); return result;}
case 294:{uint32_t result=LL_I3C_IsTargetAbortPrivateRead(i3c); return result;}
case 295:{uint32_t result=LL_I3C_GetMessageDirection(i3c); return result;}
case 296:{uint32_t result=LL_I3C_GetMessageIdentifier(i3c); return result;}
case 297:{uint32_t result=LL_I3C_GetMessageErrorCode(i3c); return result;}
case 298:{uint32_t result=LL_I3C_GetReceiveCommandCode(i3c); return result;}
case 299:{LL_I3C_SetTargetDynamicAddress(i3c, (uint32_t)args[0], (uint32_t)args[1]); return 0;}
case 300:{uint32_t result=LL_I3C_GetTargetDynamicAddress(i3c, (uint32_t)args[0]); return result;}
case 301:{LL_I3C_EnableTargetIBIAck(i3c, (uint32_t)args[0]); return 0;}
case 302:{LL_I3C_DisableTargetIBIAck(i3c, (uint32_t)args[0]); return 0;}
case 303:{uint32_t result=LL_I3C_IsEnabledTargetIBIAck(i3c, (uint32_t)args[0]); return result;}
case 304:{LL_I3C_EnableTargetCRAck(i3c, (uint32_t)args[0]); return 0;}
case 305:{LL_I3C_DisableTargetCRAck(i3c, (uint32_t)args[0]); return 0;}
case 306:{uint32_t result=LL_I3C_IsEnabledTargetCRAck(i3c, (uint32_t)args[0]); return result;}
case 307:{LL_I3C_EnableIBIAddData(i3c, (uint32_t)args[0]); return 0;}
case 308:{LL_I3C_DisableIBIAddData(i3c, (uint32_t)args[0]); return 0;}
case 309:{uint32_t result=LL_I3C_IsEnabledIBIAddData(i3c, (uint32_t)args[0]); return result;}
case 310:{LL_I3C_EnableFrameSuspend(i3c, (uint32_t)args[0]); return 0;}
case 311:{LL_I3C_DisableFrameSuspend(i3c, (uint32_t)args[0]); return 0;}
case 312:{uint32_t result=LL_I3C_IsFrameMustBeSuspended(i3c, (uint32_t)args[0]); return result;}
case 313:{uint32_t result=LL_I3C_IsAllowedPayloadUpdate(i3c, (uint32_t)args[0]); return result;}
case 314:{LL_I3C_ConfigDeviceCapabilities(i3c, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3], (uint32_t)args[4]); return 0;}
case 315:{uint32_t result=LL_I3C_IsActiveFlag_CFE(i3c); return result;}
case 316:{uint32_t result=LL_I3C_IsActiveFlag_TXFE(i3c); return result;}
case 317:{uint32_t result=LL_I3C_IsActiveFlag_CFNF(i3c); return result;}
case 318:{uint32_t result=LL_I3C_IsActiveFlag_SFNE(i3c); return result;}
case 319:{uint32_t result=LL_I3C_IsActiveFlag_TXFNF(i3c); return result;}
case 320:{uint32_t result=LL_I3C_IsActiveFlag_RXFNE(i3c); return result;}
case 321:{uint32_t result=LL_I3C_IsActiveFlag_RXLAST(i3c); return result;}
case 322:{uint32_t result=LL_I3C_IsActiveFlag_TXLAST(i3c); return result;}
case 323:{uint32_t result=LL_I3C_IsActiveFlag_FC(i3c); return result;}
case 324:{uint32_t result=LL_I3C_IsActiveFlag_RXTGTEND(i3c); return result;}
case 325:{uint32_t result=LL_I3C_IsActiveFlag_ERR(i3c); return result;}
case 326:{uint32_t result=LL_I3C_IsActiveFlag_IBI(i3c); return result;}
case 327:{uint32_t result=LL_I3C_IsActiveFlag_IBIEND(i3c); return result;}
case 328:{uint32_t result=LL_I3C_IsActiveFlag_CR(i3c); return result;}
case 329:{uint32_t result=LL_I3C_IsActiveFlag_CRUPD(i3c); return result;}
case 330:{uint32_t result=LL_I3C_IsActiveFlag_HJ(i3c); return result;}
case 331:{uint32_t result=LL_I3C_IsActiveFlag_WKP(i3c); return result;}
case 332:{uint32_t result=LL_I3C_IsActiveFlag_GET(i3c); return result;}
case 333:{uint32_t result=LL_I3C_IsActiveFlag_STA(i3c); return result;}
case 334:{uint32_t result=LL_I3C_IsActiveFlag_DAUPD(i3c); return result;}
case 335:{uint32_t result=LL_I3C_IsActiveFlag_MWLUPD(i3c); return result;}
case 336:{uint32_t result=LL_I3C_IsActiveFlag_MRLUPD(i3c); return result;}
case 337:{uint32_t result=LL_I3C_IsActiveFlag_RST(i3c); return result;}
case 338:{uint32_t result=LL_I3C_IsActiveFlag_ASUPD(i3c); return result;}
case 339:{uint32_t result=LL_I3C_IsActiveFlag_INTUPD(i3c); return result;}
case 340:{uint32_t result=LL_I3C_IsActiveFlag_DEF(i3c); return result;}
case 341:{uint32_t result=LL_I3C_IsActiveFlag_GRP(i3c); return result;}
case 342:{uint32_t result=LL_I3C_IsActiveFlag_PERR(i3c); return result;}
case 343:{uint32_t result=LL_I3C_IsActiveFlag_STALL(i3c); return result;}
case 344:{uint32_t result=LL_I3C_IsActiveFlag_DOVR(i3c); return result;}
case 345:{uint32_t result=LL_I3C_IsActiveFlag_COVR(i3c); return result;}
case 346:{uint32_t result=LL_I3C_IsActiveFlag_ANACK(i3c); return result;}
case 347:{uint32_t result=LL_I3C_IsActiveFlag_DNACK(i3c); return result;}
case 348:{uint32_t result=LL_I3C_IsActiveFlag_DERR(i3c); return result;}
case 349:{LL_I3C_EnableIT_CFNF(i3c); return 0;}
case 350:{LL_I3C_DisableIT_CFNF(i3c); return 0;}
case 351:{uint32_t result=LL_I3C_IsEnabledIT_CFNF(i3c); return result;}
case 352:{LL_I3C_EnableIT_SFNE(i3c); return 0;}
case 353:{LL_I3C_DisableIT_SFNE(i3c); return 0;}
case 354:{uint32_t result=LL_I3C_IsEnabledIT_SFNE(i3c); return result;}
case 355:{LL_I3C_EnableIT_TXFNF(i3c); return 0;}
case 356:{LL_I3C_DisableIT_TXFNF(i3c); return 0;}
case 357:{uint32_t result=LL_I3C_IsEnabledIT_TXFNF(i3c); return result;}
case 358:{LL_I3C_EnableIT_RXFNE(i3c); return 0;}
case 359:{LL_I3C_DisableIT_RXFNE(i3c); return 0;}
case 360:{uint32_t result=LL_I3C_IsEnabledIT_RXFNE(i3c); return result;}
case 361:{LL_I3C_EnableIT_FC(i3c); return 0;}
case 362:{LL_I3C_DisableIT_FC(i3c); return 0;}
case 363:{uint32_t result=LL_I3C_IsEnabledIT_FC(i3c); return result;}
case 364:{LL_I3C_EnableIT_RXTGTEND(i3c); return 0;}
case 365:{LL_I3C_DisableIT_RXTGTEND(i3c); return 0;}
case 366:{uint32_t result=LL_I3C_IsEnabledIT_RXTGTEND(i3c); return result;}
case 367:{LL_I3C_EnableIT_ERR(i3c); return 0;}
case 368:{LL_I3C_DisableIT_ERR(i3c); return 0;}
case 369:{uint32_t result=LL_I3C_IsEnabledIT_ERR(i3c); return result;}
case 370:{LL_I3C_EnableIT_IBI(i3c); return 0;}
case 371:{LL_I3C_DisableIT_IBI(i3c); return 0;}
case 372:{uint32_t result=LL_I3C_IsEnabledIT_IBI(i3c); return result;}
case 373:{LL_I3C_EnableIT_IBIEND(i3c); return 0;}
case 374:{LL_I3C_DisableIT_IBIEND(i3c); return 0;}
case 375:{uint32_t result=LL_I3C_IsEnabledIT_IBIEND(i3c); return result;}
case 376:{LL_I3C_EnableIT_CR(i3c); return 0;}
case 377:{LL_I3C_DisableIT_CR(i3c); return 0;}
case 378:{uint32_t result=LL_I3C_IsEnabledIT_CR(i3c); return result;}
case 379:{LL_I3C_EnableIT_CRUPD(i3c); return 0;}
case 380:{LL_I3C_DisableIT_CRUPD(i3c); return 0;}
case 381:{uint32_t result=LL_I3C_IsEnabledIT_CRUPD(i3c); return result;}
case 382:{LL_I3C_EnableIT_HJ(i3c); return 0;}
case 383:{LL_I3C_DisableIT_HJ(i3c); return 0;}
case 384:{uint32_t result=LL_I3C_IsEnabledIT_HJ(i3c); return result;}
case 385:{LL_I3C_EnableIT_WKP(i3c); return 0;}
case 386:{LL_I3C_DisableIT_WKP(i3c); return 0;}
case 387:{uint32_t result=LL_I3C_IsEnabledIT_WKP(i3c); return result;}
case 388:{LL_I3C_EnableIT_GET(i3c); return 0;}
case 389:{LL_I3C_DisableIT_GET(i3c); return 0;}
case 390:{uint32_t result=LL_I3C_IsEnabledIT_GET(i3c); return result;}
case 391:{LL_I3C_EnableIT_STA(i3c); return 0;}
case 392:{LL_I3C_DisableIT_STA(i3c); return 0;}
case 393:{uint32_t result=LL_I3C_IsEnabledIT_STA(i3c); return result;}
case 394:{LL_I3C_EnableIT_DAUPD(i3c); return 0;}
case 395:{LL_I3C_DisableIT_DAUPD(i3c); return 0;}
case 396:{uint32_t result=LL_I3C_IsEnabledIT_DAUPD(i3c); return result;}
case 397:{LL_I3C_EnableIT_MWLUPD(i3c); return 0;}
case 398:{LL_I3C_DisableIT_MWLUPD(i3c); return 0;}
case 399:{uint32_t result=LL_I3C_IsEnabledIT_MWLUPD(i3c); return result;}
case 400:{LL_I3C_EnableIT_MRLUPD(i3c); return 0;}
case 401:{LL_I3C_DisableIT_MRLUPD(i3c); return 0;}
case 402:{uint32_t result=LL_I3C_IsEnabledIT_MRLUPD(i3c); return result;}
case 403:{LL_I3C_EnableIT_RST(i3c); return 0;}
case 404:{LL_I3C_DisableIT_RST(i3c); return 0;}
case 405:{uint32_t result=LL_I3C_IsEnabledIT_RST(i3c); return result;}
case 406:{LL_I3C_EnableIT_ASUPD(i3c); return 0;}
case 407:{LL_I3C_DisableIT_ASUPD(i3c); return 0;}
case 408:{uint32_t result=LL_I3C_IsEnabledIT_ASUPD(i3c); return result;}
case 409:{LL_I3C_EnableIT_INTUPD(i3c); return 0;}
case 410:{LL_I3C_DisableIT_INTUPD(i3c); return 0;}
case 411:{uint32_t result=LL_I3C_IsEnabledIT_INTUPD(i3c); return result;}
case 412:{LL_I3C_EnableIT_DEF(i3c); return 0;}
case 413:{LL_I3C_DisableIT_DEF(i3c); return 0;}
case 414:{uint32_t result=LL_I3C_IsEnabledIT_DEF(i3c); return result;}
case 415:{LL_I3C_EnableIT_GRP(i3c); return 0;}
case 416:{LL_I3C_DisableIT_GRP(i3c); return 0;}
case 417:{uint32_t result=LL_I3C_IsEnabledIT_GRP(i3c); return result;}
case 418:{LL_I3C_ClearFlag_FC(i3c); return 0;}
case 419:{LL_I3C_ClearFlag_RXTGTEND(i3c); return 0;}
case 420:{LL_I3C_ClearFlag_ERR(i3c); return 0;}
case 421:{LL_I3C_ClearFlag_IBI(i3c); return 0;}
case 422:{LL_I3C_ClearFlag_IBIEND(i3c); return 0;}
case 423:{LL_I3C_ClearFlag_CR(i3c); return 0;}
case 424:{LL_I3C_ClearFlag_CRUPD(i3c); return 0;}
case 425:{LL_I3C_ClearFlag_HJ(i3c); return 0;}
case 426:{LL_I3C_ClearFlag_WKP(i3c); return 0;}
case 427:{LL_I3C_ClearFlag_GET(i3c); return 0;}
case 428:{LL_I3C_ClearFlag_STA(i3c); return 0;}
case 429:{LL_I3C_ClearFlag_DAUPD(i3c); return 0;}
case 430:{LL_I3C_ClearFlag_MWLUPD(i3c); return 0;}
case 431:{LL_I3C_ClearFlag_MRLUPD(i3c); return 0;}
case 432:{LL_I3C_ClearFlag_RST(i3c); return 0;}
case 433:{LL_I3C_ClearFlag_ASUPD(i3c); return 0;}
case 434:{LL_I3C_ClearFlag_INTUPD(i3c); return 0;}
case 435:{LL_I3C_ClearFlag_DEF(i3c); return 0;}
case 436:{LL_I3C_ClearFlag_GRP(i3c); return 0;}
case 437:{uint32_t result=LL_I3C_DeInit(i3c); return result;}
case 438:{LL_I3C_InitTypeDef v1={0}; v1.CtrlBusCharacteristic.SDAHoldTime=(uint32_t)args[0]; v1.CtrlBusCharacteristic.WaitTime=(uint32_t)args[1]; v1.CtrlBusCharacteristic.SCLPPLowDuration=(uint8_t)args[2]; v1.CtrlBusCharacteristic.SCLI3CHighDuration=(uint8_t)args[3]; v1.CtrlBusCharacteristic.SCLODLowDuration=(uint8_t)args[4]; v1.CtrlBusCharacteristic.SCLI2CHighDuration=(uint8_t)args[5]; v1.CtrlBusCharacteristic.BusFreeDuration=(uint8_t)args[6]; v1.CtrlBusCharacteristic.BusIdleDuration=(uint8_t)args[7]; v1.TgtBusCharacteristic.BusAvailableDuration=(uint8_t)args[8]; uint32_t result=LL_I3C_Init(i3c, &v1, (uint32_t)args[9]); s->cells[384]=v1.CtrlBusCharacteristic.SDAHoldTime; s->cells[385]=v1.CtrlBusCharacteristic.WaitTime; s->cells[386]=v1.CtrlBusCharacteristic.SCLPPLowDuration; s->cells[387]=v1.CtrlBusCharacteristic.SCLI3CHighDuration; s->cells[388]=v1.CtrlBusCharacteristic.SCLODLowDuration; s->cells[389]=v1.CtrlBusCharacteristic.SCLI2CHighDuration; s->cells[390]=v1.CtrlBusCharacteristic.BusFreeDuration; s->cells[391]=v1.CtrlBusCharacteristic.BusIdleDuration; s->cells[392]=v1.TgtBusCharacteristic.BusAvailableDuration; return result;}
case 439:{LL_I3C_InitTypeDef v0={0}; v0.CtrlBusCharacteristic.SDAHoldTime=(uint32_t)args[0]; v0.CtrlBusCharacteristic.WaitTime=(uint32_t)args[1]; v0.CtrlBusCharacteristic.SCLPPLowDuration=(uint8_t)args[2]; v0.CtrlBusCharacteristic.SCLI3CHighDuration=(uint8_t)args[3]; v0.CtrlBusCharacteristic.SCLODLowDuration=(uint8_t)args[4]; v0.CtrlBusCharacteristic.SCLI2CHighDuration=(uint8_t)args[5]; v0.CtrlBusCharacteristic.BusFreeDuration=(uint8_t)args[6]; v0.CtrlBusCharacteristic.BusIdleDuration=(uint8_t)args[7]; v0.TgtBusCharacteristic.BusAvailableDuration=(uint8_t)args[8]; LL_I3C_StructInit(&v0); s->cells[384]=v0.CtrlBusCharacteristic.SDAHoldTime; s->cells[385]=v0.CtrlBusCharacteristic.WaitTime; s->cells[386]=v0.CtrlBusCharacteristic.SCLPPLowDuration; s->cells[387]=v0.CtrlBusCharacteristic.SCLI3CHighDuration; s->cells[388]=v0.CtrlBusCharacteristic.SCLODLowDuration; s->cells[389]=v0.CtrlBusCharacteristic.SCLI2CHighDuration; s->cells[390]=v0.CtrlBusCharacteristic.BusFreeDuration; s->cells[391]=v0.CtrlBusCharacteristic.BusIdleDuration; s->cells[392]=v0.TgtBusCharacteristic.BusAvailableDuration; return 0;}
case 440:{LL_I2C_WriteReg(i2c,CR2,args[0]);return LL_I2C_ReadReg(i2c,CR2);}
case 441:{LL_I3C_WriteReg(i3c,TIMINGR1,args[0]);return LL_I3C_ReadReg(i3c,TIMINGR1);}
default:abort();}}
uint32_t CL56_Constant(uint32_t i){switch(i){
case 0:return LL_I2C_ICR_ADDRCF;
case 1:return LL_I2C_ICR_NACKCF;
case 2:return LL_I2C_ICR_STOPCF;
case 3:return LL_I2C_ICR_BERRCF;
case 4:return LL_I2C_ICR_ARLOCF;
case 5:return LL_I2C_ICR_OVRCF;
case 6:return LL_I2C_ICR_PECCF;
case 7:return LL_I2C_ICR_TIMOUTCF;
case 8:return LL_I2C_ICR_ALERTCF;
case 9:return LL_I2C_ISR_TXE;
case 10:return LL_I2C_ISR_TXIS;
case 11:return LL_I2C_ISR_RXNE;
case 12:return LL_I2C_ISR_ADDR;
case 13:return LL_I2C_ISR_NACKF;
case 14:return LL_I2C_ISR_STOPF;
case 15:return LL_I2C_ISR_TC;
case 16:return LL_I2C_ISR_TCR;
case 17:return LL_I2C_ISR_BERR;
case 18:return LL_I2C_ISR_ARLO;
case 19:return LL_I2C_ISR_OVR;
case 20:return LL_I2C_ISR_PECERR;
case 21:return LL_I2C_ISR_TIMEOUT;
case 22:return LL_I2C_ISR_ALERT;
case 23:return LL_I2C_ISR_BUSY;
case 24:return LL_I2C_CR1_TXIE;
case 25:return LL_I2C_CR1_RXIE;
case 26:return LL_I2C_CR1_ADDRIE;
case 27:return LL_I2C_CR1_NACKIE;
case 28:return LL_I2C_CR1_STOPIE;
case 29:return LL_I2C_CR1_TCIE;
case 30:return LL_I2C_CR1_ERRIE;
case 31:return LL_I2C_MODE_I2C;
case 32:return LL_I2C_MODE_SMBUS_HOST;
case 33:return LL_I2C_MODE_SMBUS_DEVICE;
case 34:return LL_I2C_MODE_SMBUS_DEVICE_ARP;
case 35:return LL_I2C_ANALOGFILTER_ENABLE;
case 36:return LL_I2C_ANALOGFILTER_DISABLE;
case 37:return LL_I2C_ADDRESSING_MODE_7BIT;
case 38:return LL_I2C_ADDRESSING_MODE_10BIT;
case 39:return LL_I2C_OWNADDRESS1_7BIT;
case 40:return LL_I2C_OWNADDRESS1_10BIT;
case 41:return LL_I2C_OWNADDRESS2_NOMASK;
case 42:return LL_I2C_OWNADDRESS2_MASK01;
case 43:return LL_I2C_OWNADDRESS2_MASK02;
case 44:return LL_I2C_OWNADDRESS2_MASK03;
case 45:return LL_I2C_OWNADDRESS2_MASK04;
case 46:return LL_I2C_OWNADDRESS2_MASK05;
case 47:return LL_I2C_OWNADDRESS2_MASK06;
case 48:return LL_I2C_OWNADDRESS2_MASK07;
case 49:return LL_I2C_ACK;
case 50:return LL_I2C_NACK;
case 51:return LL_I2C_ADDRSLAVE_7BIT;
case 52:return LL_I2C_ADDRSLAVE_10BIT;
case 53:return LL_I2C_REQUEST_WRITE;
case 54:return LL_I2C_REQUEST_READ;
case 55:return LL_I2C_MODE_RELOAD;
case 56:return LL_I2C_MODE_AUTOEND;
case 57:return LL_I2C_MODE_SOFTEND;
case 58:return LL_I2C_MODE_SMBUS_RELOAD;
case 59:return LL_I2C_MODE_SMBUS_AUTOEND_NO_PEC;
case 60:return LL_I2C_MODE_SMBUS_SOFTEND_NO_PEC;
case 61:return LL_I2C_MODE_SMBUS_AUTOEND_WITH_PEC;
case 62:return LL_I2C_MODE_SMBUS_SOFTEND_WITH_PEC;
case 63:return LL_I2C_GENERATE_NOSTARTSTOP;
case 64:return LL_I2C_GENERATE_STOP;
case 65:return LL_I2C_GENERATE_START_READ;
case 66:return LL_I2C_GENERATE_START_WRITE;
case 67:return LL_I2C_GENERATE_RESTART_7BIT_READ;
case 68:return LL_I2C_GENERATE_RESTART_7BIT_WRITE;
case 69:return LL_I2C_GENERATE_RESTART_10BIT_READ;
case 70:return LL_I2C_GENERATE_RESTART_10BIT_WRITE;
case 71:return LL_I2C_DIRECTION_WRITE;
case 72:return LL_I2C_DIRECTION_READ;
case 73:return LL_I2C_DMA_REG_DATA_TRANSMIT;
case 74:return LL_I2C_DMA_REG_DATA_RECEIVE;
case 75:return LL_I2C_SMBUS_TIMEOUTA_MODE_SCL_LOW;
case 76:return LL_I2C_SMBUS_TIMEOUTA_MODE_SDA_SCL_HIGH;
case 77:return LL_I2C_SMBUS_TIMEOUTA;
case 78:return LL_I2C_SMBUS_TIMEOUTB;
case 79:return LL_I2C_SMBUS_ALL_TIMEOUT;
case 80:return LL_I3C_EVR_CFEF;
case 81:return LL_I3C_EVR_TXFEF;
case 82:return LL_I3C_EVR_CFNFF;
case 83:return LL_I3C_EVR_SFNEF;
case 84:return LL_I3C_EVR_TXFNFF;
case 85:return LL_I3C_EVR_RXFNEF;
case 86:return LL_I3C_EVR_RXLASTF;
case 87:return LL_I3C_EVR_TXLASTF;
case 88:return LL_I3C_EVR_FCF;
case 89:return LL_I3C_EVR_RXTGTENDF;
case 90:return LL_I3C_EVR_ERRF;
case 91:return LL_I3C_EVR_IBIF;
case 92:return LL_I3C_EVR_IBIENDF;
case 93:return LL_I3C_EVR_CRF;
case 94:return LL_I3C_EVR_CRUPDF;
case 95:return LL_I3C_EVR_HJF;
case 96:return LL_I3C_EVR_WKPF;
case 97:return LL_I3C_EVR_GETF;
case 98:return LL_I3C_EVR_STAF;
case 99:return LL_I3C_EVR_DAUPDF;
case 100:return LL_I3C_EVR_MWLUPDF;
case 101:return LL_I3C_EVR_MRLUPDF;
case 102:return LL_I3C_EVR_RSTF;
case 103:return LL_I3C_EVR_ASUPDF;
case 104:return LL_I3C_EVR_INTUPDF;
case 105:return LL_I3C_EVR_DEFF;
case 106:return LL_I3C_EVR_GRPF;
case 107:return LL_I3C_SER_PERR;
case 108:return LL_I3C_SER_STALL;
case 109:return LL_I3C_SER_DOVR;
case 110:return LL_I3C_SER_COVR;
case 111:return LL_I3C_SER_ANACK;
case 112:return LL_I3C_SER_DNACK;
case 113:return LL_I3C_SER_DERR;
case 114:return LL_I3C_IER_CFNFIE;
case 115:return LL_I3C_IER_SFNEIE;
case 116:return LL_I3C_IER_TXFNFIE;
case 117:return LL_I3C_IER_RXFNEIE;
case 118:return LL_I3C_IER_FCIE;
case 119:return LL_I3C_IER_RXTGTENDIE;
case 120:return LL_I3C_IER_ERRIE;
case 121:return LL_I3C_IER_IBIIE;
case 122:return LL_I3C_IER_IBIENDIE;
case 123:return LL_I3C_IER_CRIE;
case 124:return LL_I3C_IER_CRUPDIE;
case 125:return LL_I3C_IER_HJIE;
case 126:return LL_I3C_IER_WKPIE;
case 127:return LL_I3C_IER_GETIE;
case 128:return LL_I3C_IER_STAIE;
case 129:return LL_I3C_IER_DAUPDIE;
case 130:return LL_I3C_IER_MWLUPDIE;
case 131:return LL_I3C_IER_MRLUPDIE;
case 132:return LL_I3C_IER_RSTIE;
case 133:return LL_I3C_IER_ASUPDIE;
case 134:return LL_I3C_IER_INTUPDIE;
case 135:return LL_I3C_IER_DEFIE;
case 136:return LL_I3C_IER_GRPIE;
case 137:return LL_I3C_MODE_CONTROLLER;
case 138:return LL_I3C_MODE_TARGET;
case 139:return LL_I3C_DMA_REG_DATA_TRANSMIT_BYTE;
case 140:return LL_I3C_DMA_REG_DATA_RECEIVE_BYTE;
case 141:return LL_I3C_DMA_REG_DATA_TRANSMIT_WORD;
case 142:return LL_I3C_DMA_REG_DATA_RECEIVE_WORD;
case 143:return LL_I3C_DMA_REG_STATUS;
case 144:return LL_I3C_DMA_REG_CONTROL;
case 145:return LL_I3C_RXFIFO_THRESHOLD_1_4;
case 146:return LL_I3C_RXFIFO_THRESHOLD_4_4;
case 147:return LL_I3C_TXFIFO_THRESHOLD_1_4;
case 148:return LL_I3C_TXFIFO_THRESHOLD_4_4;
case 149:return LL_I3C_PAYLOAD_EMPTY;
case 150:return LL_I3C_PAYLOAD_1_BYTE;
case 151:return LL_I3C_PAYLOAD_2_BYTES;
case 152:return LL_I3C_PAYLOAD_3_BYTES;
case 153:return LL_I3C_PAYLOAD_4_BYTES;
case 154:return LL_I3C_SDA_HOLD_TIME_0_5;
case 155:return LL_I3C_SDA_HOLD_TIME_1_5;
case 156:return LL_I3C_OWN_ACTIVITY_STATE_0;
case 157:return LL_I3C_OWN_ACTIVITY_STATE_1;
case 158:return LL_I3C_OWN_ACTIVITY_STATE_2;
case 159:return LL_I3C_OWN_ACTIVITY_STATE_3;
case 160:return LL_I3C_DEVICE_ROLE_AS_TARGET;
case 161:return LL_I3C_DEVICE_ROLE_AS_CONTROLLER;
case 162:return LL_I3C_IBI_NO_ADDITIONAL_DATA;
case 163:return LL_I3C_IBI_ADDITIONAL_DATA;
case 164:return LL_I3C_NO_DATA_SPEED_LIMITATION;
case 165:return LL_I3C_MAX_DATA_SPEED_LIMITATION;
case 166:return LL_I3C_MDB_NO_PENDING_READ_NOTIFICATION;
case 167:return LL_I3C_MDB_PENDING_READ_NOTIFICATION;
case 168:return LL_I3C_HANDOFF_GRP_ADDR_NOT_SUPPORTED;
case 169:return LL_I3C_HANDOFF_GRP_ADDR_SUPPORTED;
case 170:return LL_I3C_HANDOFF_NOT_DELAYED;
case 171:return LL_I3C_HANDOFF_DELAYED;
case 172:return LL_I3C_HANDOFF_ACTIVITY_STATE_0;
case 173:return LL_I3C_HANDOFF_ACTIVITY_STATE_1;
case 174:return LL_I3C_HANDOFF_ACTIVITY_STATE_2;
case 175:return LL_I3C_HANDOFF_ACTIVITY_STATE_3;
case 176:return LL_I3C_GETMXDS_FORMAT_1;
case 177:return LL_I3C_GETMXDS_FORMAT_2_LSB;
case 178:return LL_I3C_GETMXDS_FORMAT_2_MID;
case 179:return LL_I3C_GETMXDS_FORMAT_2_MSB;
case 180:return LL_I3C_TURNAROUND_TIME_TSCO_LESS_12NS;
case 181:return LL_I3C_TURNAROUND_TIME_TSCO_GREATER_12NS;
case 182:return LL_I3C_BUS_ACTIVITY_STATE_0;
case 183:return LL_I3C_BUS_ACTIVITY_STATE_1;
case 184:return LL_I3C_BUS_ACTIVITY_STATE_2;
case 185:return LL_I3C_BUS_ACTIVITY_STATE_3;
case 186:return LL_I3C_RESET_ACTION_NONE;
case 187:return LL_I3C_RESET_ACTION_PARTIAL;
case 188:return LL_I3C_RESET_ACTION_FULL;
case 189:return LL_I3C_DIRECTION_WRITE;
case 190:return LL_I3C_DIRECTION_READ;
case 191:return LL_I3C_GENERATE_STOP;
case 192:return LL_I3C_GENERATE_RESTART;
case 193:return LL_I3C_CONTROLLER_MTYPE_RELEASE;
case 194:return LL_I3C_CONTROLLER_MTYPE_HEADER;
case 195:return LL_I3C_CONTROLLER_MTYPE_PRIVATE;
case 196:return LL_I3C_CONTROLLER_MTYPE_DIRECT;
case 197:return LL_I3C_CONTROLLER_MTYPE_LEGACY_I2C;
case 198:return LL_I3C_CONTROLLER_MTYPE_CCC;
case 199:return LL_I3C_TARGET_MTYPE_HOT_JOIN;
case 200:return LL_I3C_TARGET_MTYPE_CONTROLLER_ROLE_REQ;
case 201:return LL_I3C_TARGET_MTYPE_IBI;
case 202:return LL_I3C_MESSAGE_ERROR;
case 203:return LL_I3C_MESSAGE_DIRECTION_WRITE;
case 204:return LL_I3C_MESSAGE_DIRECTION_READ;
case 205:return LL_I3C_CONTROLLER_ERROR_CE0;
case 206:return LL_I3C_CONTROLLER_ERROR_CE1;
case 207:return LL_I3C_CONTROLLER_ERROR_CE2;
case 208:return LL_I3C_CONTROLLER_ERROR_CE3;
case 209:return LL_I3C_TARGET_ERROR_TE0;
case 210:return LL_I3C_TARGET_ERROR_TE1;
case 211:return LL_I3C_TARGET_ERROR_TE2;
case 212:return LL_I3C_TARGET_ERROR_TE3;
case 213:return LL_I3C_TARGET_ERROR_TE4;
case 214:return LL_I3C_TARGET_ERROR_TE5;
case 215:return LL_I3C_TARGET_ERROR_TE6;
case 216:return LL_I3C_BCR_IN_PAYLOAD_SHIFT;
case 217:return LL_I3C_IBI_CAPABILITY;
case 218:return LL_I3C_IBI_NO_CAPABILITY;
case 219:return LL_I3C_IBI_DATA_ENABLE;
case 220:return LL_I3C_IBI_DATA_DISABLE;
case 221:return LL_I3C_CR_CAPABILITY;
case 222:return LL_I3C_CR_NO_CAPABILITY;
default:abort();}}
