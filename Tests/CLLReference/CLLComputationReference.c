#include "include/CLLComputationReference.h"
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "Upstream/Computation/Trace/stm32h7rsxx_ll_crc.h"
#include "Upstream/Computation/Trace/stm32h7rsxx_ll_cordic.h"
#include "Upstream/Computation/Trace/stm32h7rsxx_ll_rng.h"
#include "Upstream/Computation/Trace/stm32h7rsxx_ll_pka.h"
#include "Upstream/Computation/Trace/stm32h7rsxx_ll_icache.h"
#include "Upstream/Computation/Trace/stm32h7rsxx_ll_crc.inc"
#include "Upstream/Computation/Trace/stm32h7rsxx_ll_cordic.inc"
#include "Upstream/Computation/Trace/stm32h7rsxx_ll_rng.inc"
#include "Upstream/Computation/Trace/stm32h7rsxx_ll_pka.inc"

struct CL58State {uint32_t cells[512],count,reads,salt,instance;CL58Access trace[256];};
_Thread_local uint32_t *CL58_Cells;
static _Thread_local CL58State *current;
CL58State *CL58_Create(void){return calloc(1,sizeof(CL58State));}
void CL58_Destroy(CL58State *s){free(s);}
void CL58_Reset(CL58State *s,uint32_t seed,uint32_t salt,uint32_t instance){current=s;CL58_Cells=s->cells;for(uint32_t i=0;i<512;i++)s->cells[i]=seed^(i*0x9E3779B9U);s->count=0;s->reads=0;s->salt=salt;s->instance=instance;}
static void record(uint32_t i,uint32_t v,uint32_t k){assert(i<512&&current->count<256);current->trace[current->count++]=(CL58Access){i,v,k};}
static uint32_t indexOf(volatile const uint32_t *p){uintptr_t d=(uintptr_t)p-(uintptr_t)CL58_Cells;assert(d<2048&&d%4==0);return (uint32_t)d/4;}
uint32_t CL58_Read(volatile const uint32_t *p){uint32_t i=indexOf(p),v=*p^(current->salt*current->reads++);record(i,v,0);return v;}
void CL58_Write(volatile uint32_t *p,uint32_t v){record(indexOf(p),v,1);*p=v;}
void CL58_Write16(volatile uint16_t *p,uint16_t v){record(indexOf((volatile uint32_t *)p),v,2);memcpy((void *)p,&v,2);}
void CL58_Write8(volatile uint8_t *p,uint8_t v){record(indexOf((volatile uint32_t *)p),v,3);memcpy((void *)p,&v,1);}
uint32_t CL58_Address(volatile const uint32_t *p){uint32_t i=indexOf(p);assert(i>=16&&i<19);return 0x48004400U+(i-16)*4;}
uint32_t *CL58_GetCells(CL58State *s){return s->cells;}
const CL58Access *CL58_GetTrace(CL58State *s){return s->trace;}
uint32_t CL58_GetTraceCount(CL58State *s){return s->count;}
uint32_t CL58_Run(CL58State *s,uint32_t op,const uint32_t *args){current=s;CL58_Cells=s->cells;switch(op){
case 0:{LL_CRC_ResetCRCCalculationUnit(CRC); return 0;}
case 1:{LL_CRC_SetPolynomialSize(CRC, (uint32_t)args[0]); return 0;}
case 2:{uint32_t result=LL_CRC_GetPolynomialSize(CRC); return result;}
case 3:{LL_CRC_SetInputDataReverseMode(CRC, (uint32_t)args[0]); return 0;}
case 4:{uint32_t result=LL_CRC_GetInputDataReverseMode(CRC); return result;}
case 5:{LL_CRC_SetOutputDataReverseMode(CRC, (uint32_t)args[0]); return 0;}
case 6:{uint32_t result=LL_CRC_GetOutputDataReverseMode(CRC); return result;}
case 7:{LL_CRC_SetInitialData(CRC, (uint32_t)args[0]); return 0;}
case 8:{uint32_t result=LL_CRC_GetInitialData(CRC); return result;}
case 9:{LL_CRC_SetPolynomialCoef(CRC, (uint32_t)args[0]); return 0;}
case 10:{uint32_t result=LL_CRC_GetPolynomialCoef(CRC); return result;}
case 11:{LL_CRC_FeedData32(CRC, (uint32_t)args[0]); return 0;}
case 12:{LL_CRC_FeedData16(CRC, (uint16_t)args[0]); return 0;}
case 13:{LL_CRC_FeedData8(CRC, (uint8_t)args[0]); return 0;}
case 14:{uint32_t result=LL_CRC_ReadData32(CRC); return result;}
case 15:{uint32_t result=LL_CRC_ReadData16(CRC); return result;}
case 16:{uint32_t result=LL_CRC_ReadData8(CRC); return result;}
case 17:{uint32_t result=LL_CRC_ReadData7(CRC); return result;}
case 18:{uint32_t result=LL_CRC_Read_IDR(CRC); return result;}
case 19:{LL_CRC_Write_IDR(CRC, (uint32_t)args[0]); return 0;}
case 20:{uint32_t result=LL_CRC_DeInit((CRC_TypeDef *)(s->instance?s->cells+128:(uint32_t *)CRC)); return result;}
case 21:{LL_CORDIC_Config(CORDIC, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3], (uint32_t)args[4], (uint32_t)args[5], (uint32_t)args[6]); return 0;}
case 22:{LL_CORDIC_SetFunction(CORDIC, (uint32_t)args[0]); return 0;}
case 23:{uint32_t result=LL_CORDIC_GetFunction(CORDIC); return result;}
case 24:{LL_CORDIC_SetPrecision(CORDIC, (uint32_t)args[0]); return 0;}
case 25:{uint32_t result=LL_CORDIC_GetPrecision(CORDIC); return result;}
case 26:{LL_CORDIC_SetScale(CORDIC, (uint32_t)args[0]); return 0;}
case 27:{uint32_t result=LL_CORDIC_GetScale(CORDIC); return result;}
case 28:{LL_CORDIC_SetNbWrite(CORDIC, (uint32_t)args[0]); return 0;}
case 29:{uint32_t result=LL_CORDIC_GetNbWrite(CORDIC); return result;}
case 30:{LL_CORDIC_SetNbRead(CORDIC, (uint32_t)args[0]); return 0;}
case 31:{uint32_t result=LL_CORDIC_GetNbRead(CORDIC); return result;}
case 32:{LL_CORDIC_SetInSize(CORDIC, (uint32_t)args[0]); return 0;}
case 33:{uint32_t result=LL_CORDIC_GetInSize(CORDIC); return result;}
case 34:{LL_CORDIC_SetOutSize(CORDIC, (uint32_t)args[0]); return 0;}
case 35:{uint32_t result=LL_CORDIC_GetOutSize(CORDIC); return result;}
case 36:{LL_CORDIC_EnableIT(CORDIC); return 0;}
case 37:{LL_CORDIC_DisableIT(CORDIC); return 0;}
case 38:{uint32_t result=LL_CORDIC_IsEnabledIT(CORDIC); return result;}
case 39:{LL_CORDIC_EnableDMAReq_RD(CORDIC); return 0;}
case 40:{LL_CORDIC_DisableDMAReq_RD(CORDIC); return 0;}
case 41:{uint32_t result=LL_CORDIC_IsEnabledDMAReq_RD(CORDIC); return result;}
case 42:{LL_CORDIC_EnableDMAReq_WR(CORDIC); return 0;}
case 43:{LL_CORDIC_DisableDMAReq_WR(CORDIC); return 0;}
case 44:{uint32_t result=LL_CORDIC_IsEnabledDMAReq_WR(CORDIC); return result;}
case 45:{uint32_t result=LL_CORDIC_DMA_GetRegAddr(CORDIC, (uint32_t)args[0]); return result;}
case 46:{uint32_t result=LL_CORDIC_IsActiveFlag_RRDY(CORDIC); return result;}
case 47:{LL_CORDIC_WriteData(CORDIC, (uint32_t)args[0]); return 0;}
case 48:{uint32_t result=LL_CORDIC_ReadData(CORDIC); return result;}
case 49:{uint32_t result=LL_CORDIC_DeInit((CORDIC_TypeDef *)(s->instance?s->cells+128:(uint32_t *)CORDIC)); return result;}
case 50:{LL_RNG_Enable(RNG); return 0;}
case 51:{LL_RNG_Disable(RNG); return 0;}
case 52:{uint32_t result=LL_RNG_IsEnabled(RNG); return result;}
case 53:{LL_RNG_EnableClkErrorDetect(RNG); return 0;}
case 54:{LL_RNG_DisableClkErrorDetect(RNG); return 0;}
case 55:{uint32_t result=LL_RNG_IsEnabledClkErrorDetect(RNG); return result;}
case 56:{LL_RNG_EnableCondReset(RNG); return 0;}
case 57:{LL_RNG_DisableCondReset(RNG); return 0;}
case 58:{uint32_t result=LL_RNG_IsEnabledCondReset(RNG); return result;}
case 59:{LL_RNG_ConfigLock(RNG); return 0;}
case 60:{uint32_t result=LL_RNG_IsConfigLocked(RNG); return result;}
case 61:{LL_RNG_EnableNistCompliance(RNG); return 0;}
case 62:{LL_RNG_DisableNistCompliance(RNG); return 0;}
case 63:{uint32_t result=LL_RNG_IsEnabledNistCompliance(RNG); return result;}
case 64:{LL_RNG_SetConfig1(RNG, (uint32_t)args[0]); return 0;}
case 65:{uint32_t result=LL_RNG_GetConfig1(RNG); return result;}
case 66:{LL_RNG_SetConfig2(RNG, (uint32_t)args[0]); return 0;}
case 67:{uint32_t result=LL_RNG_GetConfig2(RNG); return result;}
case 68:{LL_RNG_SetConfig3(RNG, (uint32_t)args[0]); return 0;}
case 69:{uint32_t result=LL_RNG_GetConfig3(RNG); return result;}
case 70:{LL_RNG_SetClockDivider(RNG, (uint32_t)args[0]); return 0;}
case 71:{uint32_t result=LL_RNG_GetClockDivider(RNG); return result;}
case 72:{uint32_t result=LL_RNG_IsActiveFlag_DRDY(RNG); return result;}
case 73:{uint32_t result=LL_RNG_IsActiveFlag_CECS(RNG); return result;}
case 74:{uint32_t result=LL_RNG_IsActiveFlag_SECS(RNG); return result;}
case 75:{uint32_t result=LL_RNG_IsActiveFlag_CEIS(RNG); return result;}
case 76:{uint32_t result=LL_RNG_IsActiveFlag_SEIS(RNG); return result;}
case 77:{LL_RNG_ClearFlag_CEIS(RNG); return 0;}
case 78:{LL_RNG_ClearFlag_SEIS(RNG); return 0;}
case 79:{LL_RNG_EnableIT(RNG); return 0;}
case 80:{LL_RNG_DisableIT(RNG); return 0;}
case 81:{uint32_t result=LL_RNG_IsEnabledIT(RNG); return result;}
case 82:{uint32_t result=LL_RNG_ReadRandData32(RNG); return result;}
case 83:{LL_RNG_EnableArdis(RNG); return 0;}
case 84:{LL_RNG_DisableArdis(RNG); return 0;}
case 85:{uint32_t result=LL_RNG_IsEnabledArdis(RNG); return result;}
case 86:{LL_RNG_SetHealthConfig(RNG, (uint32_t)args[0]); return 0;}
case 87:{uint32_t result=LL_RNG_GetHealthConfig(RNG); return result;}
case 88:{uint32_t result=LL_RNG_DeInit((RNG_TypeDef *)(s->instance?s->cells+128:(uint32_t *)RNG)); return result;}
case 89:{LL_RNG_InitTypeDef v1={0}; v1.ClockErrorDetection=(uint32_t)args[0]; uint32_t result=LL_RNG_Init(RNG, &v1); s->cells[384]=v1.ClockErrorDetection; return result;}
case 90:{LL_RNG_InitTypeDef v0={0}; v0.ClockErrorDetection=(uint32_t)args[0]; LL_RNG_StructInit(&v0); s->cells[384]=v0.ClockErrorDetection; return 0;}
case 91:{LL_PKA_Config(PKA, (uint32_t)args[0]); return 0;}
case 92:{LL_PKA_Enable(PKA); return 0;}
case 93:{LL_PKA_Disable(PKA); return 0;}
case 94:{uint32_t result=LL_PKA_IsEnabled(PKA); return result;}
case 95:{LL_PKA_SetMode(PKA, (uint32_t)args[0]); return 0;}
case 96:{uint32_t result=LL_PKA_GetMode(PKA); return result;}
case 97:{LL_PKA_Start(PKA); return 0;}
case 98:{LL_PKA_EnableIT_ADDRERR(PKA); return 0;}
case 99:{LL_PKA_EnableIT_RAMERR(PKA); return 0;}
case 100:{LL_PKA_EnableIT_OPERR(PKA); return 0;}
case 101:{LL_PKA_EnableIT_PROCEND(PKA); return 0;}
case 102:{LL_PKA_DisableIT_ADDERR(PKA); return 0;}
case 103:{LL_PKA_DisableIT_RAMERR(PKA); return 0;}
case 104:{LL_PKA_DisableIT_PROCEND(PKA); return 0;}
case 105:{LL_PKA_DisableIT_OPERR(PKA); return 0;}
case 106:{uint32_t result=LL_PKA_IsEnabledIT_ADDRERR(PKA); return result;}
case 107:{uint32_t result=LL_PKA_IsEnabledIT_RAMERR(PKA); return result;}
case 108:{uint32_t result=LL_PKA_IsEnabledIT_OPERR(PKA); return result;}
case 109:{uint32_t result=LL_PKA_IsEnabledIT_PROCEND(PKA); return result;}
case 110:{uint32_t result=LL_PKA_IsActiveFlag_ADDRERR(PKA); return result;}
case 111:{uint32_t result=LL_PKA_IsActiveFlag_RAMERR(PKA); return result;}
case 112:{uint32_t result=LL_PKA_IsActiveFlag_OPERR(PKA); return result;}
case 113:{uint32_t result=LL_PKA_IsActiveFlag_PROCEND(PKA); return result;}
case 114:{uint32_t result=LL_PKA_IsActiveFlag_BUSY(PKA); return result;}
case 115:{uint32_t result=LL_PKA_IsActiveFlag_INITOK(PKA); return result;}
case 116:{LL_PKA_ClearFlag_ADDERR(PKA); return 0;}
case 117:{LL_PKA_ClearFlag_RAMERR(PKA); return 0;}
case 118:{LL_PKA_ClearFlag_OPERR(PKA); return 0;}
case 119:{LL_PKA_ClearFlag_PROCEND(PKA); return 0;}
case 120:{uint32_t result=LL_PKA_DeInit((PKA_TypeDef *)(s->instance?s->cells+128:(uint32_t *)PKA)); return result;}
case 121:{LL_PKA_InitTypeDef v1={0}; v1.Mode=(uint32_t)args[0]; uint32_t result=LL_PKA_Init(PKA, &v1); s->cells[384]=v1.Mode; return result;}
case 122:{LL_PKA_InitTypeDef v0={0}; v0.Mode=(uint32_t)args[0]; LL_PKA_StructInit(&v0); s->cells[384]=v0.Mode; return 0;}
case 123:{LL_ICACHE_Enable(); return 0;}
case 124:{LL_ICACHE_Disable(); return 0;}
case 125:{uint32_t result=LL_ICACHE_IsEnabled(); return result;}
case 126:{LL_ICACHE_SetMode((uint32_t)args[0]); return 0;}
case 127:{uint32_t result=LL_ICACHE_GetMode(); return result;}
case 128:{LL_ICACHE_Invalidate(); return 0;}
case 129:{LL_ICACHE_EnableMonitors((uint32_t)args[0]); return 0;}
case 130:{LL_ICACHE_DisableMonitors((uint32_t)args[0]); return 0;}
case 131:{uint32_t result=LL_ICACHE_IsEnabledMonitors((uint32_t)args[0]); return result;}
case 132:{LL_ICACHE_ResetMonitors((uint32_t)args[0]); return 0;}
case 133:{uint32_t result=LL_ICACHE_GetHitMonitor(); return result;}
case 134:{uint32_t result=LL_ICACHE_GetMissMonitor(); return result;}
case 135:{LL_ICACHE_EnableIT_BSYEND(); return 0;}
case 136:{LL_ICACHE_DisableIT_BSYEND(); return 0;}
case 137:{uint32_t result=LL_ICACHE_IsEnabledIT_BSYEND(); return result;}
case 138:{LL_ICACHE_EnableIT_ERR(); return 0;}
case 139:{LL_ICACHE_DisableIT_ERR(); return 0;}
case 140:{uint32_t result=LL_ICACHE_IsEnabledIT_ERR(); return result;}
case 141:{uint32_t result=LL_ICACHE_IsActiveFlag_BUSY(); return result;}
case 142:{uint32_t result=LL_ICACHE_IsActiveFlag_BSYEND(); return result;}
case 143:{uint32_t result=LL_ICACHE_IsActiveFlag_ERR(); return result;}
case 144:{LL_ICACHE_ClearFlag_BSYEND(); return 0;}
case 145:{LL_ICACHE_ClearFlag_ERR(); return 0;}
case 146:{LL_CRC_WriteReg(CRC,CR,args[0]);return LL_CRC_ReadReg(CRC,CR);}
case 147:{LL_CORDIC_WriteReg(CORDIC,CSR,args[0]);return LL_CORDIC_ReadReg(CORDIC,CSR);}
case 148:{LL_RNG_WriteReg(RNG,CR,args[0]);return LL_RNG_ReadReg(RNG,CR);}
case 149:{LL_PKA_WriteReg(PKA,CR,args[0]);return LL_PKA_ReadReg(PKA,CR);}
case 150:{LL_ICACHE_WriteReg(CR,args[0]);return LL_ICACHE_ReadReg(CR);}
default:abort();}}
uint32_t CL58_Constant(uint32_t i){switch(i){
case 0:return LL_CRC_POLYLENGTH_32B;
case 1:return LL_CRC_POLYLENGTH_16B;
case 2:return LL_CRC_POLYLENGTH_8B;
case 3:return LL_CRC_POLYLENGTH_7B;
case 4:return LL_CRC_INDATA_REVERSE_NONE;
case 5:return LL_CRC_INDATA_REVERSE_BYTE;
case 6:return LL_CRC_INDATA_REVERSE_HALFWORD;
case 7:return LL_CRC_INDATA_REVERSE_WORD;
case 8:return LL_CRC_OUTDATA_REVERSE_NONE;
case 9:return LL_CRC_OUTDATA_REVERSE_BIT;
case 10:return LL_CRC_DEFAULT_CRC32_POLY;
case 11:return LL_CRC_DEFAULT_CRC_INITVALUE;
case 12:return LL_CORDIC_FLAG_RRDY;
case 13:return LL_CORDIC_IT_IEN;
case 14:return LL_CORDIC_FUNCTION_COSINE;
case 15:return LL_CORDIC_FUNCTION_SINE;
case 16:return LL_CORDIC_FUNCTION_PHASE;
case 17:return LL_CORDIC_FUNCTION_MODULUS;
case 18:return LL_CORDIC_FUNCTION_ARCTANGENT;
case 19:return LL_CORDIC_FUNCTION_HCOSINE;
case 20:return LL_CORDIC_FUNCTION_HSINE;
case 21:return LL_CORDIC_FUNCTION_HARCTANGENT;
case 22:return LL_CORDIC_FUNCTION_NATURALLOG;
case 23:return LL_CORDIC_FUNCTION_SQUAREROOT;
case 24:return LL_CORDIC_PRECISION_1CYCLE;
case 25:return LL_CORDIC_PRECISION_2CYCLES;
case 26:return LL_CORDIC_PRECISION_3CYCLES;
case 27:return LL_CORDIC_PRECISION_4CYCLES;
case 28:return LL_CORDIC_PRECISION_5CYCLES;
case 29:return LL_CORDIC_PRECISION_6CYCLES;
case 30:return LL_CORDIC_PRECISION_7CYCLES;
case 31:return LL_CORDIC_PRECISION_8CYCLES;
case 32:return LL_CORDIC_PRECISION_9CYCLES;
case 33:return LL_CORDIC_PRECISION_10CYCLES;
case 34:return LL_CORDIC_PRECISION_11CYCLES;
case 35:return LL_CORDIC_PRECISION_12CYCLES;
case 36:return LL_CORDIC_PRECISION_13CYCLES;
case 37:return LL_CORDIC_PRECISION_14CYCLES;
case 38:return LL_CORDIC_PRECISION_15CYCLES;
case 39:return LL_CORDIC_SCALE_0;
case 40:return LL_CORDIC_SCALE_1;
case 41:return LL_CORDIC_SCALE_2;
case 42:return LL_CORDIC_SCALE_3;
case 43:return LL_CORDIC_SCALE_4;
case 44:return LL_CORDIC_SCALE_5;
case 45:return LL_CORDIC_SCALE_6;
case 46:return LL_CORDIC_SCALE_7;
case 47:return LL_CORDIC_NBWRITE_1;
case 48:return LL_CORDIC_NBWRITE_2;
case 49:return LL_CORDIC_NBREAD_1;
case 50:return LL_CORDIC_NBREAD_2;
case 51:return LL_CORDIC_INSIZE_32BITS;
case 52:return LL_CORDIC_INSIZE_16BITS;
case 53:return LL_CORDIC_OUTSIZE_32BITS;
case 54:return LL_CORDIC_OUTSIZE_16BITS;
case 55:return LL_CORDIC_DMA_REG_DATA_IN;
case 56:return LL_CORDIC_DMA_REG_DATA_OUT;
case 57:return LL_RNG_CED_ENABLE;
case 58:return LL_RNG_CED_DISABLE;
case 59:return LL_RNG_ARDIS_ENABLE;
case 60:return LL_RNG_ARDIS_DISABLE;
case 61:return LL_RNG_CLKDIV_BY_1;
case 62:return LL_RNG_CLKDIV_BY_2;
case 63:return LL_RNG_CLKDIV_BY_4;
case 64:return LL_RNG_CLKDIV_BY_8;
case 65:return LL_RNG_CLKDIV_BY_16;
case 66:return LL_RNG_CLKDIV_BY_32;
case 67:return LL_RNG_CLKDIV_BY_64;
case 68:return LL_RNG_CLKDIV_BY_128;
case 69:return LL_RNG_CLKDIV_BY_256;
case 70:return LL_RNG_CLKDIV_BY_512;
case 71:return LL_RNG_CLKDIV_BY_1024;
case 72:return LL_RNG_CLKDIV_BY_2048;
case 73:return LL_RNG_CLKDIV_BY_4096;
case 74:return LL_RNG_CLKDIV_BY_8192;
case 75:return LL_RNG_CLKDIV_BY_16384;
case 76:return LL_RNG_CLKDIV_BY_32768;
case 77:return LL_RNG_NIST_COMPLIANT;
case 78:return LL_RNG_CUSTOM_NIST;
case 79:return LL_RNG_SR_DRDY;
case 80:return LL_RNG_SR_CECS;
case 81:return LL_RNG_SR_SECS;
case 82:return LL_RNG_SR_CEIS;
case 83:return LL_RNG_SR_SEIS;
case 84:return LL_RNG_CR_IE;
case 85:return LL_PKA_SR_ADDRERRF;
case 86:return LL_PKA_SR_RAMERRF;
case 87:return LL_PKA_SR_PROCENDF;
case 88:return LL_PKA_SR_BUSY;
case 89:return LL_PKA_SR_INITOK;
case 90:return LL_PKA_SR_OPERRF;
case 91:return LL_PKA_CR_ADDRERRIE;
case 92:return LL_PKA_CR_RAMERRIE;
case 93:return LL_PKA_CR_PROCENDIE;
case 94:return LL_PKA_CLRFR_PROCENDFC;
case 95:return LL_PKA_CLRFR_RAMERRFC;
case 96:return LL_PKA_CLRFR_ADDRERRFC;
case 97:return LL_PKA_CR_OPERRIE;
case 98:return LL_PKA_CLRFR_OPERRFC;
case 99:return LL_PKA_MODE_MODULAR_EXP;
case 100:return LL_PKA_MODE_MONTGOMERY_PARAM;
case 101:return LL_PKA_MODE_MODULAR_EXP_FAST;
case 102:return LL_PKA_MODE_MODULAR_EXP_PROTECT;
case 103:return LL_PKA_MODE_ECC_MUL;
case 104:return LL_PKA_MODE_ECC_COMPLETE_ADD;
case 105:return LL_PKA_MODE_ECDSA_SIGNATURE;
case 106:return LL_PKA_MODE_ECDSA_VERIFICATION;
case 107:return LL_PKA_MODE_POINT_CHECK;
case 108:return LL_PKA_MODE_RSA_CRT_EXP;
case 109:return LL_PKA_MODE_MODULAR_INV;
case 110:return LL_PKA_MODE_ARITHMETIC_ADD;
case 111:return LL_PKA_MODE_ARITHMETIC_SUB;
case 112:return LL_PKA_MODE_ARITHMETIC_MUL;
case 113:return LL_PKA_MODE_COMPARISON;
case 114:return LL_PKA_MODE_MODULAR_REDUC;
case 115:return LL_PKA_MODE_MODULAR_ADD;
case 116:return LL_PKA_MODE_MODULAR_SUB;
case 117:return LL_PKA_MODE_MONTGOMERY_MUL;
case 118:return LL_PKA_MODE_DOUBLE_BASE_LADDER;
case 119:return LL_PKA_MODE_ECC_PROJECTIVE_AFF;
case 120:return LL_ICACHE_1WAY;
case 121:return LL_ICACHE_4WAYS;
case 122:return LL_ICACHE_MONITOR_HIT;
case 123:return LL_ICACHE_MONITOR_MISS;
case 124:return LL_ICACHE_MONITOR_ALL;
case 125:return LL_ICACHE_SR_BUSYF;
case 126:return LL_ICACHE_SR_BSYENDF;
case 127:return LL_ICACHE_SR_ERRF;
case 128:return LL_ICACHE_FCR_CBSYENDF;
case 129:return LL_ICACHE_FCR_CERRF;
case 130:return LL_ICACHE_IER_BSYENDIE;
case 131:return LL_ICACHE_IER_ERRIE;
default:abort();}}
