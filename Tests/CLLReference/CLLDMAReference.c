#include "include/CLLDMAReference.h"
#include <stdlib.h>
#include <assert.h>
#include "Upstream/DMA/Trace/stm32h7rsxx_ll_dma.h"
#include "Upstream/DMA/stm32h7rsxx_ll_dma2d.h"
#include "Upstream/DMA/Trace/stm32h7rsxx_ll_dma.inc"
#include "Upstream/DMA/stm32h7rsxx_ll_dma2d.inc"
struct CL51State { uint32_t cells[4096], count, reads, salt, controller; CL51Access trace[512]; };
_Thread_local uint32_t *CL51_Cells;
static _Thread_local CL51State *current;
CL51State *CL51_Create(void) { return calloc(1, sizeof(CL51State)); }
void CL51_Destroy(CL51State *s) { free(s); }
void CL51_Reset(CL51State *s, uint32_t seed, uint32_t salt, uint32_t controller) {
  current=s; CL51_Cells=s->cells;
  for (uint32_t i=0; i<4096; i++) s->cells[i]=seed ^ (i * 0x9E3779B9U);
  s->count=0; s->reads=0; s->salt=salt; s->controller=controller;
}
static void record(uint32_t index, uint32_t value, uint32_t kind) {
  assert(index < 4096 && current->count < 512);
  current->trace[current->count++] = (CL51Access){index,value,kind};
}
uint32_t CL51_Read(volatile const uint32_t *p) {
  uint32_t index=(uint32_t)(p-CL51_Cells); assert(index < 4096);
  uint32_t value=*p ^ (current->salt * current->reads++);
  record(index,value,0);return value;
}
void CL51_Write(volatile uint32_t *p,uint32_t value) {
  uint32_t index=(uint32_t)(p-CL51_Cells);record(index,value,1);*p=value;
}
uint32_t CL51_NodeAddress(const void *p) {
  return 0x24010000U + (uint32_t)((const uint32_t *)p - (CL51_Cells+3072))*4U;
}
uint32_t *CL51_GetCells(CL51State *s) {return s->cells;}
const CL51Access *CL51_GetTrace(CL51State *s) {return s->trace;}
uint32_t CL51_GetTraceCount(CL51State *s) {return s->count;}
static uint32_t conversions(uint32_t op,const uint32_t *args);
uint32_t CL51_Run(CL51State *s,uint32_t operation,const uint32_t *args) {
  current=s;CL51_Cells=s->cells;
  DMA_TypeDef *dma=s->controller == 0 ? GPDMA1 : HPDMA1;
  switch(operation) {
    case 0: { LL_DMA_EnableChannel(dma, args[0]); return 0; }
    case 1: { LL_DMA_DisableChannel(dma, args[0]); return 0; }
    case 2: { uint32_t result = LL_DMA_IsEnabledChannel(dma, args[0]); return result; }
    case 3: { LL_DMA_ResetChannel(dma, args[0]); return 0; }
    case 4: { LL_DMA_SuspendChannel(dma, args[0]); return 0; }
    case 5: { LL_DMA_ResumeChannel(dma, args[0]); return 0; }
    case 6: { uint32_t result = LL_DMA_IsSuspendedChannel(dma, args[0]); return result; }
    case 7: { LL_DMA_SetLinkedListBaseAddr(dma, args[0], args[1]); return 0; }
    case 8: { uint32_t result = LL_DMA_GetLinkedListBaseAddr(dma, args[0]); return result; }
    case 9: { LL_DMA_ConfigControl(dma, args[0], args[1]); return 0; }
    case 10: { LL_DMA_SetChannelPriorityLevel(dma, args[0], args[1]); return 0; }
    case 11: { uint32_t result = LL_DMA_GetChannelPriorityLevel(dma, args[0]); return result; }
    case 12: { LL_DMA_SetLinkAllocatedPort(dma, args[0], args[1]); return 0; }
    case 13: { uint32_t result = LL_DMA_GetLinkAllocatedPort(dma, args[0]); return result; }
    case 14: { LL_DMA_SetLinkStepMode(dma, args[0], args[1]); return 0; }
    case 15: { uint32_t result = LL_DMA_GetLinkStepMode(dma, args[0]); return result; }
    case 16: { LL_DMA_ConfigTransfer(dma, args[0], args[1]); return 0; }
    case 17: { LL_DMA_ConfigBurstLength(dma, args[0], args[1], args[2]); return 0; }
    case 18: { LL_DMA_SetDestAllocatedPort(dma, args[0], args[1]); return 0; }
    case 19: { uint32_t result = LL_DMA_GetDestAllocatedPort(dma, args[0]); return result; }
    case 20: { LL_DMA_SetDestWordExchange(dma, args[0], args[1]); return 0; }
    case 21: { uint32_t result = LL_DMA_GetDestWordExchange(dma, args[0]); return result; }
    case 22: { LL_DMA_SetDestHWordExchange(dma, args[0], args[1]); return 0; }
    case 23: { uint32_t result = LL_DMA_GetDestHWordExchange(dma, args[0]); return result; }
    case 24: { LL_DMA_SetDestByteExchange(dma, args[0], args[1]); return 0; }
    case 25: { uint32_t result = LL_DMA_GetDestByteExchange(dma, args[0]); return result; }
    case 26: { LL_DMA_SetSrcByteExchange(dma, args[0], args[1]); return 0; }
    case 27: { uint32_t result = LL_DMA_GetSrcByteExchange(dma, args[0]); return result; }
    case 28: { LL_DMA_SetDestBurstLength(dma, args[0], args[1]); return 0; }
    case 29: { uint32_t result = LL_DMA_GetDestBurstLength(dma, args[0]); return result; }
    case 30: { LL_DMA_SetDestIncMode(dma, args[0], args[1]); return 0; }
    case 31: { uint32_t result = LL_DMA_GetDestIncMode(dma, args[0]); return result; }
    case 32: { LL_DMA_SetDestDataWidth(dma, args[0], args[1]); return 0; }
    case 33: { uint32_t result = LL_DMA_GetDestDataWidth(dma, args[0]); return result; }
    case 34: { LL_DMA_SetSrcAllocatedPort(dma, args[0], args[1]); return 0; }
    case 35: { uint32_t result = LL_DMA_GetSrcAllocatedPort(dma, args[0]); return result; }
    case 36: { LL_DMA_SetDataAlignment(dma, args[0], args[1]); return 0; }
    case 37: { uint32_t result = LL_DMA_GetDataAlignment(dma, args[0]); return result; }
    case 38: { LL_DMA_SetSrcBurstLength(dma, args[0], args[1]); return 0; }
    case 39: { uint32_t result = LL_DMA_GetSrcBurstLength(dma, args[0]); return result; }
    case 40: { LL_DMA_SetSrcIncMode(dma, args[0], args[1]); return 0; }
    case 41: { uint32_t result = LL_DMA_GetSrcIncMode(dma, args[0]); return result; }
    case 42: { LL_DMA_SetSrcDataWidth(dma, args[0], args[1]); return 0; }
    case 43: { uint32_t result = LL_DMA_GetSrcDataWidth(dma, args[0]); return result; }
    case 44: { LL_DMA_ConfigChannelTransfer(dma, args[0], args[1]); return 0; }
    case 45: { LL_DMA_SetTransferEventMode(dma, args[0], args[1]); return 0; }
    case 46: { uint32_t result = LL_DMA_GetTransferEventMode(dma, args[0]); return result; }
    case 47: { LL_DMA_SetTriggerPolarity(dma, args[0], args[1]); return 0; }
    case 48: { uint32_t result = LL_DMA_GetTriggerPolarity(dma, args[0]); return result; }
    case 49: { LL_DMA_SetTriggerMode(dma, args[0], args[1]); return 0; }
    case 50: { uint32_t result = LL_DMA_GetTriggerMode(dma, args[0]); return result; }
    case 51: { LL_DMA_SetDataTransferDirection(dma, args[0], args[1]); return 0; }
    case 52: { uint32_t result = LL_DMA_GetDataTransferDirection(dma, args[0]); return result; }
    case 53: { LL_DMA_SetBlkHWRequest(dma, args[0], args[1]); return 0; }
    case 54: { uint32_t result = LL_DMA_GetBlkHWRequest(dma, args[0]); return result; }
    case 55: { LL_DMA_SetPeriphRequest(dma, args[0], args[1]); return 0; }
    case 56: { uint32_t result = LL_DMA_GetPeriphRequest(dma, args[0]); return result; }
    case 57: { LL_DMA_SetHWTrigger(dma, args[0], args[1]); return 0; }
    case 58: { uint32_t result = LL_DMA_GetHWTrigger(dma, args[0]); return result; }
    case 59: { LL_DMA_SetTransferMode(dma, args[0], args[1]); return 0; }
    case 60: { uint32_t result = LL_DMA_GetTransferMode(dma, args[0]); return result; }
    case 61: { LL_DMA_ConfigBlkRptAddrUpdate(dma, args[0], args[1]); return 0; }
    case 62: { LL_DMA_ConfigBlkCounters(dma, args[0], args[1], args[2]); return 0; }
    case 63: { LL_DMA_SetBlkRptDestAddrUpdate(dma, args[0], args[1]); return 0; }
    case 64: { uint32_t result = LL_DMA_GetBlkRptDestAddrUpdate(dma, args[0]); return result; }
    case 65: { LL_DMA_SetBlkRptSrcAddrUpdate(dma, args[0], args[1]); return 0; }
    case 66: { uint32_t result = LL_DMA_GetBlkRptSrcAddrUpdate(dma, args[0]); return result; }
    case 67: { LL_DMA_SetDestAddrUpdate(dma, args[0], args[1]); return 0; }
    case 68: { uint32_t result = LL_DMA_GetDestAddrUpdate(dma, args[0]); return result; }
    case 69: { LL_DMA_SetSrcAddrUpdate(dma, args[0], args[1]); return 0; }
    case 70: { uint32_t result = LL_DMA_GetSrcAddrUpdate(dma, args[0]); return result; }
    case 71: { LL_DMA_SetBlkRptCount(dma, args[0], args[1]); return 0; }
    case 72: { uint32_t result = LL_DMA_GetBlkRptCount(dma, args[0]); return result; }
    case 73: { LL_DMA_SetBlkDataLength(dma, args[0], args[1]); return 0; }
    case 74: { uint32_t result = LL_DMA_GetBlkDataLength(dma, args[0]); return result; }
    case 75: { LL_DMA_ConfigAddresses(dma, args[0], args[1], args[2]); return 0; }
    case 76: { LL_DMA_SetSrcAddress(dma, args[0], args[1]); return 0; }
    case 77: { uint32_t result = LL_DMA_GetSrcAddress(dma, args[0]); return result; }
    case 78: { LL_DMA_SetDestAddress(dma, args[0], args[1]); return 0; }
    case 79: { uint32_t result = LL_DMA_GetDestAddress(dma, args[0]); return result; }
    case 80: { LL_DMA_ConfigAddrUpdateValue(dma, args[0], args[1], args[2]); return 0; }
    case 81: { LL_DMA_SetDestAddrUpdateValue(dma, args[0], args[1]); return 0; }
    case 82: { uint32_t result = LL_DMA_GetDestAddrUpdateValue(dma, args[0]); return result; }
    case 83: { LL_DMA_SetSrcAddrUpdateValue(dma, args[0], args[1]); return 0; }
    case 84: { uint32_t result = LL_DMA_GetSrcAddrUpdateValue(dma, args[0]); return result; }
    case 85: { LL_DMA_ConfigBlkRptAddrUpdateValue(dma, args[0], args[1], args[2]); return 0; }
    case 86: { LL_DMA_SetBlkRptDestAddrUpdateValue(dma, args[0], args[1]); return 0; }
    case 87: { uint32_t result = LL_DMA_GetBlkRptDestAddrUpdateValue(dma, args[0]); return result; }
    case 88: { LL_DMA_SetBlkRptSrcAddrUpdateValue(dma, args[0], args[1]); return 0; }
    case 89: { uint32_t result = LL_DMA_GetBlkRptSrcAddrUpdateValue(dma, args[0]); return result; }
    case 90: { LL_DMA_ConfigLinkUpdate(dma, args[0], args[1], args[2]); return 0; }
    case 91: { LL_DMA_EnableCTR1Update(dma, args[0]); return 0; }
    case 92: { LL_DMA_DisableCTR1Update(dma, args[0]); return 0; }
    case 93: { uint32_t result = LL_DMA_IsEnabledCTR1Update(dma, args[0]); return result; }
    case 94: { LL_DMA_EnableCTR2Update(dma, args[0]); return 0; }
    case 95: { LL_DMA_DisableCTR2Update(dma, args[0]); return 0; }
    case 96: { uint32_t result = LL_DMA_IsEnabledCTR2Update(dma, args[0]); return result; }
    case 97: { LL_DMA_EnableCBR1Update(dma, args[0]); return 0; }
    case 98: { LL_DMA_DisableCBR1Update(dma, args[0]); return 0; }
    case 99: { uint32_t result = LL_DMA_IsEnabledCBR1Update(dma, args[0]); return result; }
    case 100: { LL_DMA_EnableCSARUpdate(dma, args[0]); return 0; }
    case 101: { LL_DMA_DisableCSARUpdate(dma, args[0]); return 0; }
    case 102: { uint32_t result = LL_DMA_IsEnabledCSARUpdate(dma, args[0]); return result; }
    case 103: { LL_DMA_EnableCDARUpdate(dma, args[0]); return 0; }
    case 104: { LL_DMA_DisableCDARUpdate(dma, args[0]); return 0; }
    case 105: { uint32_t result = LL_DMA_IsEnabledCDARUpdate(dma, args[0]); return result; }
    case 106: { LL_DMA_EnableCTR3Update(dma, args[0]); return 0; }
    case 107: { LL_DMA_DisableCTR3Update(dma, args[0]); return 0; }
    case 108: { uint32_t result = LL_DMA_IsEnabledCTR3Update(dma, args[0]); return result; }
    case 109: { LL_DMA_EnableCBR2Update(dma, args[0]); return 0; }
    case 110: { LL_DMA_DisableCBR2Update(dma, args[0]); return 0; }
    case 111: { uint32_t result = LL_DMA_IsEnabledCBR2Update(dma, args[0]); return result; }
    case 112: { LL_DMA_EnableCLLRUpdate(dma, args[0]); return 0; }
    case 113: { LL_DMA_DisableCLLRUpdate(dma, args[0]); return 0; }
    case 114: { uint32_t result = LL_DMA_IsEnabledCLLRUpdate(dma, args[0]); return result; }
    case 115: { LL_DMA_SetLinkedListAddrOffset(dma, args[0], args[1]); return 0; }
    case 116: { uint32_t result = LL_DMA_GetLinkedListAddrOffset(dma, args[0]); return result; }
    case 117: { uint32_t result = LL_DMA_GetFIFOLevel(dma, args[0]); return result; }
    case 118: { LL_DMA_EnableChannelPrivilege(dma, args[0]); return 0; }
    case 119: { LL_DMA_DisableChannelPrivilege(dma, args[0]); return 0; }
    case 120: { uint32_t result = LL_DMA_IsEnabledChannelPrivilege(dma, args[0]); return result; }
    case 121: { LL_DMA_EnableChannelLockAttribute(dma, args[0]); return 0; }
    case 122: { uint32_t result = LL_DMA_IsEnabledChannelLockAttribute(dma, args[0]); return result; }
    case 123: { LL_DMA_ClearFlag_TO(dma, args[0]); return 0; }
    case 124: { LL_DMA_ClearFlag_SUSP(dma, args[0]); return 0; }
    case 125: { LL_DMA_ClearFlag_USE(dma, args[0]); return 0; }
    case 126: { LL_DMA_ClearFlag_ULE(dma, args[0]); return 0; }
    case 127: { LL_DMA_ClearFlag_DTE(dma, args[0]); return 0; }
    case 128: { LL_DMA_ClearFlag_HT(dma, args[0]); return 0; }
    case 129: { LL_DMA_ClearFlag_TC(dma, args[0]); return 0; }
    case 130: { uint32_t result = LL_DMA_IsActiveFlag_TO(dma, args[0]); return result; }
    case 131: { uint32_t result = LL_DMA_IsActiveFlag_SUSP(dma, args[0]); return result; }
    case 132: { uint32_t result = LL_DMA_IsActiveFlag_USE(dma, args[0]); return result; }
    case 133: { uint32_t result = LL_DMA_IsActiveFlag_ULE(dma, args[0]); return result; }
    case 134: { uint32_t result = LL_DMA_IsActiveFlag_DTE(dma, args[0]); return result; }
    case 135: { uint32_t result = LL_DMA_IsActiveFlag_HT(dma, args[0]); return result; }
    case 136: { uint32_t result = LL_DMA_IsActiveFlag_TC(dma, args[0]); return result; }
    case 137: { uint32_t result = LL_DMA_IsActiveFlag_IDLE(dma, args[0]); return result; }
    case 138: { uint32_t result = LL_DMA_IsActiveFlag_MIS(dma, args[0]); return result; }
    case 139: { LL_DMA_EnableIT_TO(dma, args[0]); return 0; }
    case 140: { LL_DMA_EnableIT_SUSP(dma, args[0]); return 0; }
    case 141: { LL_DMA_EnableIT_USE(dma, args[0]); return 0; }
    case 142: { LL_DMA_EnableIT_ULE(dma, args[0]); return 0; }
    case 143: { LL_DMA_EnableIT_DTE(dma, args[0]); return 0; }
    case 144: { LL_DMA_EnableIT_HT(dma, args[0]); return 0; }
    case 145: { LL_DMA_EnableIT_TC(dma, args[0]); return 0; }
    case 146: { LL_DMA_DisableIT_TO(dma, args[0]); return 0; }
    case 147: { LL_DMA_DisableIT_SUSP(dma, args[0]); return 0; }
    case 148: { LL_DMA_DisableIT_USE(dma, args[0]); return 0; }
    case 149: { LL_DMA_DisableIT_ULE(dma, args[0]); return 0; }
    case 150: { LL_DMA_DisableIT_DTE(dma, args[0]); return 0; }
    case 151: { LL_DMA_DisableIT_HT(dma, args[0]); return 0; }
    case 152: { LL_DMA_DisableIT_TC(dma, args[0]); return 0; }
    case 153: { uint32_t result = LL_DMA_IsEnabledIT_TO(dma, args[0]); return result; }
    case 154: { uint32_t result = LL_DMA_IsEnabledIT_SUSP(dma, args[0]); return result; }
    case 155: { uint32_t result = LL_DMA_IsEnabledIT_USE(dma, args[0]); return result; }
    case 156: { uint32_t result = LL_DMA_IsEnabledIT_ULE(dma, args[0]); return result; }
    case 157: { uint32_t result = LL_DMA_IsEnabledIT_DTE(dma, args[0]); return result; }
    case 158: { uint32_t result = LL_DMA_IsEnabledIT_HT(dma, args[0]); return result; }
    case 159: { uint32_t result = LL_DMA_IsEnabledIT_TC(dma, args[0]); return result; }
    case 160: { uint32_t result = LL_DMA_DeInit(dma, args[0]); return result; }
    case 161: { LL_DMA_InitTypeDef v2 = {args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38]}; uint32_t result = LL_DMA_Init(dma, args[0], &v2); s->cells[3500] = v2.SrcAddress; s->cells[3501] = v2.DestAddress; s->cells[3502] = v2.Direction; s->cells[3503] = v2.BlkHWRequest; s->cells[3504] = v2.DataAlignment; s->cells[3505] = v2.SrcBurstLength; s->cells[3506] = v2.DestBurstLength; s->cells[3507] = v2.SrcDataWidth; s->cells[3508] = v2.DestDataWidth; s->cells[3509] = v2.SrcIncMode; s->cells[3510] = v2.DestIncMode; s->cells[3511] = v2.Priority; s->cells[3512] = v2.BlkDataLength; s->cells[3513] = v2.BlkRptCount; s->cells[3514] = v2.TriggerMode; s->cells[3515] = v2.TriggerPolarity; s->cells[3516] = v2.TriggerSelection; s->cells[3517] = v2.Request; s->cells[3518] = v2.TransferEventMode; s->cells[3519] = v2.DestWordExchange; s->cells[3520] = v2.DestHWordExchange; s->cells[3521] = v2.DestByteExchange; s->cells[3522] = v2.SrcByteExchange; s->cells[3523] = v2.SrcAllocatedPort; s->cells[3524] = v2.DestAllocatedPort; s->cells[3525] = v2.LinkAllocatedPort; s->cells[3526] = v2.LinkStepMode; s->cells[3527] = v2.SrcAddrUpdateMode; s->cells[3528] = v2.DestAddrUpdateMode; s->cells[3529] = v2.SrcAddrOffset; s->cells[3530] = v2.DestAddrOffset; s->cells[3531] = v2.BlkRptSrcAddrUpdateMode; s->cells[3532] = v2.BlkRptDestAddrUpdateMode; s->cells[3533] = v2.BlkRptSrcAddrOffset; s->cells[3534] = v2.BlkRptDestAddrOffset; s->cells[3535] = v2.LinkedListBaseAddr; s->cells[3536] = v2.LinkedListAddrOffset; s->cells[3537] = v2.Mode; return result; }
    case 162: { LL_DMA_InitTypeDef v0 = {args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37]}; LL_DMA_StructInit(&v0); s->cells[3500] = v0.SrcAddress; s->cells[3501] = v0.DestAddress; s->cells[3502] = v0.Direction; s->cells[3503] = v0.BlkHWRequest; s->cells[3504] = v0.DataAlignment; s->cells[3505] = v0.SrcBurstLength; s->cells[3506] = v0.DestBurstLength; s->cells[3507] = v0.SrcDataWidth; s->cells[3508] = v0.DestDataWidth; s->cells[3509] = v0.SrcIncMode; s->cells[3510] = v0.DestIncMode; s->cells[3511] = v0.Priority; s->cells[3512] = v0.BlkDataLength; s->cells[3513] = v0.BlkRptCount; s->cells[3514] = v0.TriggerMode; s->cells[3515] = v0.TriggerPolarity; s->cells[3516] = v0.TriggerSelection; s->cells[3517] = v0.Request; s->cells[3518] = v0.TransferEventMode; s->cells[3519] = v0.DestWordExchange; s->cells[3520] = v0.DestHWordExchange; s->cells[3521] = v0.DestByteExchange; s->cells[3522] = v0.SrcByteExchange; s->cells[3523] = v0.SrcAllocatedPort; s->cells[3524] = v0.DestAllocatedPort; s->cells[3525] = v0.LinkAllocatedPort; s->cells[3526] = v0.LinkStepMode; s->cells[3527] = v0.SrcAddrUpdateMode; s->cells[3528] = v0.DestAddrUpdateMode; s->cells[3529] = v0.SrcAddrOffset; s->cells[3530] = v0.DestAddrOffset; s->cells[3531] = v0.BlkRptSrcAddrUpdateMode; s->cells[3532] = v0.BlkRptDestAddrUpdateMode; s->cells[3533] = v0.BlkRptSrcAddrOffset; s->cells[3534] = v0.BlkRptDestAddrOffset; s->cells[3535] = v0.LinkedListBaseAddr; s->cells[3536] = v0.LinkedListAddrOffset; s->cells[3537] = v0.Mode; return 0; }
    case 163: { LL_DMA_InitLinkedListTypeDef v0 = {args[0], args[1], args[2], args[3]}; LL_DMA_ListStructInit(&v0); s->cells[3500] = v0.Priority; s->cells[3501] = v0.LinkStepMode; s->cells[3502] = v0.LinkAllocatedPort; s->cells[3503] = v0.TransferEventMode; return 0; }
    case 164: { uint32_t result = LL_DMA_List_DeInit(dma, args[0]); return result; }
    case 165: { LL_DMA_InitLinkedListTypeDef v2 = {args[1], args[2], args[3], args[4]}; uint32_t result = LL_DMA_List_Init(dma, args[0], &v2); s->cells[3500] = v2.Priority; s->cells[3501] = v2.LinkStepMode; s->cells[3502] = v2.LinkAllocatedPort; s->cells[3503] = v2.TransferEventMode; return result; }
    case 166: { LL_DMA_InitNodeTypeDef v0 = {args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34]}; LL_DMA_NodeStructInit(&v0); s->cells[3500] = v0.DestAllocatedPort; s->cells[3501] = v0.DestWordExchange; s->cells[3502] = v0.DestHWordExchange; s->cells[3503] = v0.DestByteExchange; s->cells[3504] = v0.DestBurstLength; s->cells[3505] = v0.DestIncMode; s->cells[3506] = v0.DestDataWidth; s->cells[3507] = v0.SrcAllocatedPort; s->cells[3508] = v0.SrcByteExchange; s->cells[3509] = v0.DataAlignment; s->cells[3510] = v0.SrcBurstLength; s->cells[3511] = v0.SrcIncMode; s->cells[3512] = v0.SrcDataWidth; s->cells[3513] = v0.TransferEventMode; s->cells[3514] = v0.TriggerPolarity; s->cells[3515] = v0.TriggerSelection; s->cells[3516] = v0.TriggerMode; s->cells[3517] = v0.BlkHWRequest; s->cells[3518] = v0.Direction; s->cells[3519] = v0.Request; s->cells[3520] = v0.Mode; s->cells[3521] = v0.BlkRptDestAddrUpdateMode; s->cells[3522] = v0.BlkRptSrcAddrUpdateMode; s->cells[3523] = v0.DestAddrUpdateMode; s->cells[3524] = v0.SrcAddrUpdateMode; s->cells[3525] = v0.BlkRptCount; s->cells[3526] = v0.BlkDataLength; s->cells[3527] = v0.SrcAddress; s->cells[3528] = v0.DestAddress; s->cells[3529] = v0.DestAddrOffset; s->cells[3530] = v0.SrcAddrOffset; s->cells[3531] = v0.BlkRptDestAddrOffset; s->cells[3532] = v0.BlkRptSrcAddrOffset; s->cells[3533] = v0.UpdateRegisters; s->cells[3534] = v0.NodeType; return 0; }
    case 167: { LL_DMA_InitNodeTypeDef v0 = {args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34]}; uint32_t result = LL_DMA_CreateLinkNode(&v0, (LL_DMA_LinkNodeTypeDef *)(s->cells+3072+args[35])); s->cells[3500] = v0.DestAllocatedPort; s->cells[3501] = v0.DestWordExchange; s->cells[3502] = v0.DestHWordExchange; s->cells[3503] = v0.DestByteExchange; s->cells[3504] = v0.DestBurstLength; s->cells[3505] = v0.DestIncMode; s->cells[3506] = v0.DestDataWidth; s->cells[3507] = v0.SrcAllocatedPort; s->cells[3508] = v0.SrcByteExchange; s->cells[3509] = v0.DataAlignment; s->cells[3510] = v0.SrcBurstLength; s->cells[3511] = v0.SrcIncMode; s->cells[3512] = v0.SrcDataWidth; s->cells[3513] = v0.TransferEventMode; s->cells[3514] = v0.TriggerPolarity; s->cells[3515] = v0.TriggerSelection; s->cells[3516] = v0.TriggerMode; s->cells[3517] = v0.BlkHWRequest; s->cells[3518] = v0.Direction; s->cells[3519] = v0.Request; s->cells[3520] = v0.Mode; s->cells[3521] = v0.BlkRptDestAddrUpdateMode; s->cells[3522] = v0.BlkRptSrcAddrUpdateMode; s->cells[3523] = v0.DestAddrUpdateMode; s->cells[3524] = v0.SrcAddrUpdateMode; s->cells[3525] = v0.BlkRptCount; s->cells[3526] = v0.BlkDataLength; s->cells[3527] = v0.SrcAddress; s->cells[3528] = v0.DestAddress; s->cells[3529] = v0.DestAddrOffset; s->cells[3530] = v0.SrcAddrOffset; s->cells[3531] = v0.BlkRptDestAddrOffset; s->cells[3532] = v0.BlkRptSrcAddrOffset; s->cells[3533] = v0.UpdateRegisters; s->cells[3534] = v0.NodeType; return result; }
    case 168: { LL_DMA_ConnectLinkNode((LL_DMA_LinkNodeTypeDef *)(s->cells+3072+args[0]), args[1], (LL_DMA_LinkNodeTypeDef *)(s->cells+3072+args[2]), args[3]); return 0; }
    case 169: { LL_DMA_DisconnectNextLinkNode((LL_DMA_LinkNodeTypeDef *)(s->cells+3072+args[0]), args[1]); return 0; }
    case 170: { LL_DMA2D_Start(DMA2D); return 0; }
    case 171: { uint32_t result = LL_DMA2D_IsTransferOngoing(DMA2D); return result; }
    case 172: { LL_DMA2D_Suspend(DMA2D); return 0; }
    case 173: { LL_DMA2D_Resume(DMA2D); return 0; }
    case 174: { uint32_t result = LL_DMA2D_IsSuspended(DMA2D); return result; }
    case 175: { LL_DMA2D_Abort(DMA2D); return 0; }
    case 176: { uint32_t result = LL_DMA2D_IsAborted(DMA2D); return result; }
    case 177: { LL_DMA2D_SetMode(DMA2D, args[0]); return 0; }
    case 178: { uint32_t result = LL_DMA2D_GetMode(DMA2D); return result; }
    case 179: { LL_DMA2D_SetOutputColorMode(DMA2D, args[0]); return 0; }
    case 180: { uint32_t result = LL_DMA2D_GetOutputColorMode(DMA2D); return result; }
    case 181: { LL_DMA2D_SetOutputRBSwapMode(DMA2D, args[0]); return 0; }
    case 182: { uint32_t result = LL_DMA2D_GetOutputRBSwapMode(DMA2D); return result; }
    case 183: { LL_DMA2D_SetOutputAlphaInvMode(DMA2D, args[0]); return 0; }
    case 184: { uint32_t result = LL_DMA2D_GetOutputAlphaInvMode(DMA2D); return result; }
    case 185: { LL_DMA2D_SetOutputSwapMode(DMA2D, args[0]); return 0; }
    case 186: { uint32_t result = LL_DMA2D_GetOutputSwapMode(DMA2D); return result; }
    case 187: { LL_DMA2D_SetLineOffsetMode(DMA2D, args[0]); return 0; }
    case 188: { uint32_t result = LL_DMA2D_GetLineOffsetMode(DMA2D); return result; }
    case 189: { LL_DMA2D_SetLineOffset(DMA2D, args[0]); return 0; }
    case 190: { uint32_t result = LL_DMA2D_GetLineOffset(DMA2D); return result; }
    case 191: { LL_DMA2D_SetNbrOfPixelsPerLines(DMA2D, args[0]); return 0; }
    case 192: { uint32_t result = LL_DMA2D_GetNbrOfPixelsPerLines(DMA2D); return result; }
    case 193: { LL_DMA2D_SetNbrOfLines(DMA2D, args[0]); return 0; }
    case 194: { uint32_t result = LL_DMA2D_GetNbrOfLines(DMA2D); return result; }
    case 195: { LL_DMA2D_SetOutputMemAddr(DMA2D, args[0]); return 0; }
    case 196: { uint32_t result = LL_DMA2D_GetOutputMemAddr(DMA2D); return result; }
    case 197: { LL_DMA2D_SetOutputColor(DMA2D, args[0]); return 0; }
    case 198: { uint32_t result = LL_DMA2D_GetOutputColor(DMA2D); return result; }
    case 199: { LL_DMA2D_SetLineWatermark(DMA2D, args[0]); return 0; }
    case 200: { uint32_t result = LL_DMA2D_GetLineWatermark(DMA2D); return result; }
    case 201: { LL_DMA2D_SetDeadTime(DMA2D, args[0]); return 0; }
    case 202: { uint32_t result = LL_DMA2D_GetDeadTime(DMA2D); return result; }
    case 203: { LL_DMA2D_EnableDeadTime(DMA2D); return 0; }
    case 204: { LL_DMA2D_DisableDeadTime(DMA2D); return 0; }
    case 205: { uint32_t result = LL_DMA2D_IsEnabledDeadTime(DMA2D); return result; }
    case 206: { LL_DMA2D_FGND_SetMemAddr(DMA2D, args[0]); return 0; }
    case 207: { uint32_t result = LL_DMA2D_FGND_GetMemAddr(DMA2D); return result; }
    case 208: { LL_DMA2D_FGND_EnableCLUTLoad(DMA2D); return 0; }
    case 209: { uint32_t result = LL_DMA2D_FGND_IsEnabledCLUTLoad(DMA2D); return result; }
    case 210: { LL_DMA2D_FGND_SetColorMode(DMA2D, args[0]); return 0; }
    case 211: { uint32_t result = LL_DMA2D_FGND_GetColorMode(DMA2D); return result; }
    case 212: { LL_DMA2D_FGND_SetAlphaMode(DMA2D, args[0]); return 0; }
    case 213: { uint32_t result = LL_DMA2D_FGND_GetAlphaMode(DMA2D); return result; }
    case 214: { LL_DMA2D_FGND_SetAlpha(DMA2D, args[0]); return 0; }
    case 215: { uint32_t result = LL_DMA2D_FGND_GetAlpha(DMA2D); return result; }
    case 216: { LL_DMA2D_FGND_SetRBSwapMode(DMA2D, args[0]); return 0; }
    case 217: { uint32_t result = LL_DMA2D_FGND_GetRBSwapMode(DMA2D); return result; }
    case 218: { LL_DMA2D_FGND_SetAlphaInvMode(DMA2D, args[0]); return 0; }
    case 219: { uint32_t result = LL_DMA2D_FGND_GetAlphaInvMode(DMA2D); return result; }
    case 220: { LL_DMA2D_FGND_SetLineOffset(DMA2D, args[0]); return 0; }
    case 221: { uint32_t result = LL_DMA2D_FGND_GetLineOffset(DMA2D); return result; }
    case 222: { LL_DMA2D_FGND_SetColor(DMA2D, args[0], args[1], args[2]); return 0; }
    case 223: { LL_DMA2D_FGND_SetRedColor(DMA2D, args[0]); return 0; }
    case 224: { uint32_t result = LL_DMA2D_FGND_GetRedColor(DMA2D); return result; }
    case 225: { LL_DMA2D_FGND_SetGreenColor(DMA2D, args[0]); return 0; }
    case 226: { uint32_t result = LL_DMA2D_FGND_GetGreenColor(DMA2D); return result; }
    case 227: { LL_DMA2D_FGND_SetBlueColor(DMA2D, args[0]); return 0; }
    case 228: { uint32_t result = LL_DMA2D_FGND_GetBlueColor(DMA2D); return result; }
    case 229: { LL_DMA2D_FGND_SetCLUTMemAddr(DMA2D, args[0]); return 0; }
    case 230: { uint32_t result = LL_DMA2D_FGND_GetCLUTMemAddr(DMA2D); return result; }
    case 231: { LL_DMA2D_FGND_SetCLUTSize(DMA2D, args[0]); return 0; }
    case 232: { uint32_t result = LL_DMA2D_FGND_GetCLUTSize(DMA2D); return result; }
    case 233: { LL_DMA2D_FGND_SetCLUTColorMode(DMA2D, args[0]); return 0; }
    case 234: { uint32_t result = LL_DMA2D_FGND_GetCLUTColorMode(DMA2D); return result; }
    case 235: { LL_DMA2D_FGND_SetChrSubSampling(DMA2D, args[0]); return 0; }
    case 236: { uint32_t result = LL_DMA2D_FGND_GetChrSubSampling(DMA2D); return result; }
    case 237: { LL_DMA2D_BGND_SetMemAddr(DMA2D, args[0]); return 0; }
    case 238: { uint32_t result = LL_DMA2D_BGND_GetMemAddr(DMA2D); return result; }
    case 239: { LL_DMA2D_BGND_EnableCLUTLoad(DMA2D); return 0; }
    case 240: { uint32_t result = LL_DMA2D_BGND_IsEnabledCLUTLoad(DMA2D); return result; }
    case 241: { LL_DMA2D_BGND_SetColorMode(DMA2D, args[0]); return 0; }
    case 242: { uint32_t result = LL_DMA2D_BGND_GetColorMode(DMA2D); return result; }
    case 243: { LL_DMA2D_BGND_SetAlphaMode(DMA2D, args[0]); return 0; }
    case 244: { uint32_t result = LL_DMA2D_BGND_GetAlphaMode(DMA2D); return result; }
    case 245: { LL_DMA2D_BGND_SetAlpha(DMA2D, args[0]); return 0; }
    case 246: { uint32_t result = LL_DMA2D_BGND_GetAlpha(DMA2D); return result; }
    case 247: { LL_DMA2D_BGND_SetRBSwapMode(DMA2D, args[0]); return 0; }
    case 248: { uint32_t result = LL_DMA2D_BGND_GetRBSwapMode(DMA2D); return result; }
    case 249: { LL_DMA2D_BGND_SetAlphaInvMode(DMA2D, args[0]); return 0; }
    case 250: { uint32_t result = LL_DMA2D_BGND_GetAlphaInvMode(DMA2D); return result; }
    case 251: { LL_DMA2D_BGND_SetLineOffset(DMA2D, args[0]); return 0; }
    case 252: { uint32_t result = LL_DMA2D_BGND_GetLineOffset(DMA2D); return result; }
    case 253: { LL_DMA2D_BGND_SetColor(DMA2D, args[0], args[1], args[2]); return 0; }
    case 254: { LL_DMA2D_BGND_SetRedColor(DMA2D, args[0]); return 0; }
    case 255: { uint32_t result = LL_DMA2D_BGND_GetRedColor(DMA2D); return result; }
    case 256: { LL_DMA2D_BGND_SetGreenColor(DMA2D, args[0]); return 0; }
    case 257: { uint32_t result = LL_DMA2D_BGND_GetGreenColor(DMA2D); return result; }
    case 258: { LL_DMA2D_BGND_SetBlueColor(DMA2D, args[0]); return 0; }
    case 259: { uint32_t result = LL_DMA2D_BGND_GetBlueColor(DMA2D); return result; }
    case 260: { LL_DMA2D_BGND_SetCLUTMemAddr(DMA2D, args[0]); return 0; }
    case 261: { uint32_t result = LL_DMA2D_BGND_GetCLUTMemAddr(DMA2D); return result; }
    case 262: { LL_DMA2D_BGND_SetCLUTSize(DMA2D, args[0]); return 0; }
    case 263: { uint32_t result = LL_DMA2D_BGND_GetCLUTSize(DMA2D); return result; }
    case 264: { LL_DMA2D_BGND_SetCLUTColorMode(DMA2D, args[0]); return 0; }
    case 265: { uint32_t result = LL_DMA2D_BGND_GetCLUTColorMode(DMA2D); return result; }
    case 266: { uint32_t result = LL_DMA2D_IsActiveFlag_CE(DMA2D); return result; }
    case 267: { uint32_t result = LL_DMA2D_IsActiveFlag_CTC(DMA2D); return result; }
    case 268: { uint32_t result = LL_DMA2D_IsActiveFlag_CAE(DMA2D); return result; }
    case 269: { uint32_t result = LL_DMA2D_IsActiveFlag_TW(DMA2D); return result; }
    case 270: { uint32_t result = LL_DMA2D_IsActiveFlag_TC(DMA2D); return result; }
    case 271: { uint32_t result = LL_DMA2D_IsActiveFlag_TE(DMA2D); return result; }
    case 272: { LL_DMA2D_ClearFlag_CE(DMA2D); return 0; }
    case 273: { LL_DMA2D_ClearFlag_CTC(DMA2D); return 0; }
    case 274: { LL_DMA2D_ClearFlag_CAE(DMA2D); return 0; }
    case 275: { LL_DMA2D_ClearFlag_TW(DMA2D); return 0; }
    case 276: { LL_DMA2D_ClearFlag_TC(DMA2D); return 0; }
    case 277: { LL_DMA2D_ClearFlag_TE(DMA2D); return 0; }
    case 278: { LL_DMA2D_EnableIT_CE(DMA2D); return 0; }
    case 279: { LL_DMA2D_EnableIT_CTC(DMA2D); return 0; }
    case 280: { LL_DMA2D_EnableIT_CAE(DMA2D); return 0; }
    case 281: { LL_DMA2D_EnableIT_TW(DMA2D); return 0; }
    case 282: { LL_DMA2D_EnableIT_TC(DMA2D); return 0; }
    case 283: { LL_DMA2D_EnableIT_TE(DMA2D); return 0; }
    case 284: { LL_DMA2D_DisableIT_CE(DMA2D); return 0; }
    case 285: { LL_DMA2D_DisableIT_CTC(DMA2D); return 0; }
    case 286: { LL_DMA2D_DisableIT_CAE(DMA2D); return 0; }
    case 287: { LL_DMA2D_DisableIT_TW(DMA2D); return 0; }
    case 288: { LL_DMA2D_DisableIT_TC(DMA2D); return 0; }
    case 289: { LL_DMA2D_DisableIT_TE(DMA2D); return 0; }
    case 290: { uint32_t result = LL_DMA2D_IsEnabledIT_CE(DMA2D); return result; }
    case 291: { uint32_t result = LL_DMA2D_IsEnabledIT_CTC(DMA2D); return result; }
    case 292: { uint32_t result = LL_DMA2D_IsEnabledIT_CAE(DMA2D); return result; }
    case 293: { uint32_t result = LL_DMA2D_IsEnabledIT_TW(DMA2D); return result; }
    case 294: { uint32_t result = LL_DMA2D_IsEnabledIT_TC(DMA2D); return result; }
    case 295: { uint32_t result = LL_DMA2D_IsEnabledIT_TE(DMA2D); return result; }
    case 296: { uint32_t result = LL_DMA2D_DeInit((s->controller == 2 ? NULL : DMA2D)); return result; }
    case 297: { LL_DMA2D_InitTypeDef v1 = {args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]}; uint32_t result = LL_DMA2D_Init(DMA2D, &v1); s->cells[3500] = v1.Mode; s->cells[3501] = v1.ColorMode; s->cells[3502] = v1.OutputBlue; s->cells[3503] = v1.OutputGreen; s->cells[3504] = v1.OutputRed; s->cells[3505] = v1.OutputAlpha; s->cells[3506] = v1.OutputMemoryAddress; s->cells[3507] = v1.OutputSwapMode; s->cells[3508] = v1.LineOffsetMode; s->cells[3509] = v1.LineOffset; s->cells[3510] = v1.NbrOfLines; s->cells[3511] = v1.NbrOfPixelsPerLines; s->cells[3512] = v1.AlphaInversionMode; s->cells[3513] = v1.RBSwapMode; return result; }
    case 298: { LL_DMA2D_InitTypeDef v0 = {args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]}; LL_DMA2D_StructInit(&v0); s->cells[3500] = v0.Mode; s->cells[3501] = v0.ColorMode; s->cells[3502] = v0.OutputBlue; s->cells[3503] = v0.OutputGreen; s->cells[3504] = v0.OutputRed; s->cells[3505] = v0.OutputAlpha; s->cells[3506] = v0.OutputMemoryAddress; s->cells[3507] = v0.OutputSwapMode; s->cells[3508] = v0.LineOffsetMode; s->cells[3509] = v0.LineOffset; s->cells[3510] = v0.NbrOfLines; s->cells[3511] = v0.NbrOfPixelsPerLines; s->cells[3512] = v0.AlphaInversionMode; s->cells[3513] = v0.RBSwapMode; return 0; }
    case 299: { LL_DMA2D_LayerCfgTypeDef v1 = {args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]}; LL_DMA2D_ConfigLayer(DMA2D, &v1, args[14]); s->cells[3500] = v1.MemoryAddress; s->cells[3501] = v1.LineOffset; s->cells[3502] = v1.ColorMode; s->cells[3503] = v1.CLUTColorMode; s->cells[3504] = v1.CLUTSize; s->cells[3505] = v1.AlphaMode; s->cells[3506] = v1.Alpha; s->cells[3507] = v1.Blue; s->cells[3508] = v1.Green; s->cells[3509] = v1.Red; s->cells[3510] = v1.CLUTMemoryAddress; s->cells[3511] = v1.AlphaInversionMode; s->cells[3512] = v1.RBSwapMode; s->cells[3513] = v1.ChromaSubSampling; return 0; }
    case 300: { LL_DMA2D_LayerCfgTypeDef v0 = {args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]}; LL_DMA2D_LayerCfgStructInit(&v0); s->cells[3500] = v0.MemoryAddress; s->cells[3501] = v0.LineOffset; s->cells[3502] = v0.ColorMode; s->cells[3503] = v0.CLUTColorMode; s->cells[3504] = v0.CLUTSize; s->cells[3505] = v0.AlphaMode; s->cells[3506] = v0.Alpha; s->cells[3507] = v0.Blue; s->cells[3508] = v0.Green; s->cells[3509] = v0.Red; s->cells[3510] = v0.CLUTMemoryAddress; s->cells[3511] = v0.AlphaInversionMode; s->cells[3512] = v0.RBSwapMode; s->cells[3513] = v0.ChromaSubSampling; return 0; }
    case 301: { LL_DMA2D_ColorTypeDef v1 = {args[0], args[1], args[2], args[3], args[4]}; LL_DMA2D_ConfigOutputColor(DMA2D, &v1); s->cells[3500] = v1.ColorMode; s->cells[3501] = v1.OutputBlue; s->cells[3502] = v1.OutputGreen; s->cells[3503] = v1.OutputRed; s->cells[3504] = v1.OutputAlpha; return 0; }
    case 302: { uint32_t result = LL_DMA2D_GetOutputBlueColor(DMA2D, args[0]); return result; }
    case 303: { uint32_t result = LL_DMA2D_GetOutputGreenColor(DMA2D, args[0]); return result; }
    case 304: { uint32_t result = LL_DMA2D_GetOutputRedColor(DMA2D, args[0]); return result; }
    case 305: { uint32_t result = LL_DMA2D_GetOutputAlphaColor(DMA2D, args[0]); return result; }
    case 306: { LL_DMA2D_ConfigSize(DMA2D, args[0], args[1]); return 0; }
    case 307: case 308: case 309: return conversions(operation,args);
    case 310: LL_DMA_WriteReg(GPDMA1_Channel0, CTR1, args[0]);return LL_DMA_ReadReg(GPDMA1_Channel0, CTR1);
    case 311: LL_DMA2D_WriteReg(DMA2D, FGPFCCR, args[0]);return LL_DMA2D_ReadReg(DMA2D, FGPFCCR);
    default:abort();
  }
}
uint32_t CL51_Constant(uint32_t index) {
  switch(index) {
    case 0: return LL_DMA_CHANNEL_0;
    case 1: return LL_DMA_CHANNEL_1;
    case 2: return LL_DMA_CHANNEL_2;
    case 3: return LL_DMA_CHANNEL_3;
    case 4: return LL_DMA_CHANNEL_4;
    case 5: return LL_DMA_CHANNEL_5;
    case 6: return LL_DMA_CHANNEL_6;
    case 7: return LL_DMA_CHANNEL_7;
    case 8: return LL_DMA_CHANNEL_8;
    case 9: return LL_DMA_CHANNEL_9;
    case 10: return LL_DMA_CHANNEL_10;
    case 11: return LL_DMA_CHANNEL_11;
    case 12: return LL_DMA_CHANNEL_12;
    case 13: return LL_DMA_CHANNEL_13;
    case 14: return LL_DMA_CHANNEL_14;
    case 15: return LL_DMA_CHANNEL_15;
    case 16: return LL_DMA_CHANNEL_ALL;
    case 17: return LL_DMA_CLLR_OFFSET0;
    case 18: return LL_DMA_CLLR_OFFSET1;
    case 19: return LL_DMA_CLLR_OFFSET2;
    case 20: return LL_DMA_CLLR_OFFSET3;
    case 21: return LL_DMA_CLLR_OFFSET4;
    case 22: return LL_DMA_CLLR_OFFSET5;
    case 23: return LL_DMA_CLLR_OFFSET6;
    case 24: return LL_DMA_CLLR_OFFSET7;
    case 25: return LL_DMA_LOW_PRIORITY_LOW_WEIGHT;
    case 26: return LL_DMA_LOW_PRIORITY_MID_WEIGHT;
    case 27: return LL_DMA_LOW_PRIORITY_HIGH_WEIGHT;
    case 28: return LL_DMA_HIGH_PRIORITY;
    case 29: return LL_DMA_LINK_ALLOCATED_PORT0;
    case 30: return LL_DMA_LINK_ALLOCATED_PORT1;
    case 31: return LL_DMA_LSM_FULL_EXECUTION;
    case 32: return LL_DMA_LSM_1LINK_EXECUTION;
    case 33: return LL_DMA_DEST_WORD_PRESERVE;
    case 34: return LL_DMA_DEST_WORD_EXCHANGE;
    case 35: return LL_DMA_DEST_HALFWORD_PRESERVE;
    case 36: return LL_DMA_DEST_HALFWORD_EXCHANGE;
    case 37: return LL_DMA_DEST_BYTE_PRESERVE;
    case 38: return LL_DMA_DEST_BYTE_EXCHANGE;
    case 39: return LL_DMA_SRC_BYTE_PRESERVE;
    case 40: return LL_DMA_SRC_BYTE_EXCHANGE;
    case 41: return LL_DMA_SRC_ALLOCATED_PORT0;
    case 42: return LL_DMA_SRC_ALLOCATED_PORT1;
    case 43: return LL_DMA_DEST_ALLOCATED_PORT0;
    case 44: return LL_DMA_DEST_ALLOCATED_PORT1;
    case 45: return LL_DMA_DEST_FIXED;
    case 46: return LL_DMA_DEST_INCREMENT;
    case 47: return LL_DMA_DEST_DATAWIDTH_BYTE;
    case 48: return LL_DMA_DEST_DATAWIDTH_HALFWORD;
    case 49: return LL_DMA_DEST_DATAWIDTH_WORD;
    case 50: return LL_DMA_DEST_DATAWIDTH_DOUBLEWORD;
    case 51: return LL_DMA_DATA_ALIGN_ZEROPADD;
    case 52: return LL_DMA_DATA_ALIGN_SIGNEXTPADD;
    case 53: return LL_DMA_DATA_PACK_UNPACK;
    case 54: return LL_DMA_SRC_FIXED;
    case 55: return LL_DMA_SRC_INCREMENT;
    case 56: return LL_DMA_SRC_DATAWIDTH_BYTE;
    case 57: return LL_DMA_SRC_DATAWIDTH_HALFWORD;
    case 58: return LL_DMA_SRC_DATAWIDTH_WORD;
    case 59: return LL_DMA_SRC_DATAWIDTH_DOUBLEWORD;
    case 60: return LL_DMA_HWREQUEST_SINGLEBURST;
    case 61: return LL_DMA_HWREQUEST_BLK;
    case 62: return LL_DMA_TCEM_BLK_TRANSFER;
    case 63: return LL_DMA_TCEM_RPT_BLK_TRANSFER;
    case 64: return LL_DMA_TCEM_EACH_LLITEM_TRANSFER;
    case 65: return LL_DMA_TCEM_LAST_LLITEM_TRANSFER;
    case 66: return LL_DMA_TRIG_POLARITY_MASKED;
    case 67: return LL_DMA_TRIG_POLARITY_RISING;
    case 68: return LL_DMA_TRIG_POLARITY_FALLING;
    case 69: return LL_DMA_TRIGM_BLK_TRANSFER;
    case 70: return LL_DMA_TRIGM_RPT_BLK_TRANSFER;
    case 71: return LL_DMA_TRIGM_LLI_LINK_TRANSFER;
    case 72: return LL_DMA_TRIGM_SINGLBURST_TRANSFER;
    case 73: return LL_DMA_DIRECTION_MEMORY_TO_MEMORY;
    case 74: return LL_DMA_DIRECTION_PERIPH_TO_MEMORY;
    case 75: return LL_DMA_DIRECTION_MEMORY_TO_PERIPH;
    case 76: return LL_DMA_NORMAL;
    case 77: return LL_DMA_PFCTRL;
    case 78: return LL_DMA_BLKRPT_SRC_ADDR_INCREMENT;
    case 79: return LL_DMA_BLKRPT_SRC_ADDR_DECREMENT;
    case 80: return LL_DMA_BLKRPT_DEST_ADDR_INCREMENT;
    case 81: return LL_DMA_BLKRPT_DEST_ADDR_DECREMENT;
    case 82: return LL_DMA_BURST_SRC_ADDR_INCREMENT;
    case 83: return LL_DMA_BURST_SRC_ADDR_DECREMENT;
    case 84: return LL_DMA_BURST_DEST_ADDR_INCREMENT;
    case 85: return LL_DMA_BURST_DEST_ADDR_DECREMENT;
    case 86: return LL_DMA_GPDMA_LINEAR_NODE;
    case 87: return LL_DMA_GPDMA_2D_NODE;
    case 88: return LL_DMA_HPDMA_LINEAR_NODE;
    case 89: return LL_DMA_HPDMA_2D_NODE;
    case 90: return LL_DMA_UPDATE_CTR1;
    case 91: return LL_DMA_UPDATE_CTR2;
    case 92: return LL_DMA_UPDATE_CBR1;
    case 93: return LL_DMA_UPDATE_CSAR;
    case 94: return LL_DMA_UPDATE_CDAR;
    case 95: return LL_DMA_UPDATE_CTR3;
    case 96: return LL_DMA_UPDATE_CBR2;
    case 97: return LL_DMA_UPDATE_CLLR;
    case 98: return LL_HPDMA1_REQUEST_JPEG_RX;
    case 99: return LL_HPDMA1_REQUEST_JPEG_TX;
    case 100: return LL_HPDMA1_REQUEST_XSPI1;
    case 101: return LL_HPDMA1_REQUEST_XSPI2;
    case 102: return LL_HPDMA1_REQUEST_SPI3_RX;
    case 103: return LL_HPDMA1_REQUEST_SPI3_TX;
    case 104: return LL_HPDMA1_REQUEST_SPI4_RX;
    case 105: return LL_HPDMA1_REQUEST_SPI4_TX;
    case 106: return LL_HPDMA1_REQUEST_ADC1;
    case 107: return LL_HPDMA1_REQUEST_ADC2;
    case 108: return LL_HPDMA1_REQUEST_ADF1_FLT0;
    case 109: return LL_HPDMA1_REQUEST_UART4_RX;
    case 110: return LL_HPDMA1_REQUEST_UART4_TX;
    case 111: return LL_HPDMA1_REQUEST_UART5_RX;
    case 112: return LL_HPDMA1_REQUEST_UART5_TX;
    case 113: return LL_HPDMA1_REQUEST_UART7_RX;
    case 114: return LL_HPDMA1_REQUEST_UART7_TX;
    case 115: return LL_HPDMA1_REQUEST_LPTIM2_IC1;
    case 116: return LL_HPDMA1_REQUEST_LPTIM2_IC2;
    case 117: return LL_HPDMA1_REQUEST_LPTIM2_UE;
    case 118: return LL_GPDMA1_REQUEST_ADC1;
    case 119: return LL_GPDMA1_REQUEST_ADC2;
    case 120: return LL_GPDMA1_REQUEST_CRYP_IN;
    case 121: return LL_GPDMA1_REQUEST_CRYP_OUT;
    case 122: return LL_GPDMA1_REQUEST_SAES_IN;
    case 123: return LL_GPDMA1_REQUEST_SAES_OUT;
    case 124: return LL_GPDMA1_REQUEST_HASH_IN;
    case 125: return LL_GPDMA1_REQUEST_TIM1_CH1;
    case 126: return LL_GPDMA1_REQUEST_TIM1_CH2;
    case 127: return LL_GPDMA1_REQUEST_TIM1_CH3;
    case 128: return LL_GPDMA1_REQUEST_TIM1_CH4;
    case 129: return LL_GPDMA1_REQUEST_TIM1_UP;
    case 130: return LL_GPDMA1_REQUEST_TIM1_TRIG;
    case 131: return LL_GPDMA1_REQUEST_TIM1_COM;
    case 132: return LL_GPDMA1_REQUEST_TIM2_CH1;
    case 133: return LL_GPDMA1_REQUEST_TIM2_CH2;
    case 134: return LL_GPDMA1_REQUEST_TIM2_CH3;
    case 135: return LL_GPDMA1_REQUEST_TIM2_CH4;
    case 136: return LL_GPDMA1_REQUEST_TIM2_UP;
    case 137: return LL_GPDMA1_REQUEST_TIM2_TRIG;
    case 138: return LL_GPDMA1_REQUEST_TIM3_CH1;
    case 139: return LL_GPDMA1_REQUEST_TIM3_CH2;
    case 140: return LL_GPDMA1_REQUEST_TIM3_CH3;
    case 141: return LL_GPDMA1_REQUEST_TIM3_CH4;
    case 142: return LL_GPDMA1_REQUEST_TIM3_UP;
    case 143: return LL_GPDMA1_REQUEST_TIM3_TRIG;
    case 144: return LL_GPDMA1_REQUEST_TIM4_CH1;
    case 145: return LL_GPDMA1_REQUEST_TIM4_CH2;
    case 146: return LL_GPDMA1_REQUEST_TIM4_CH3;
    case 147: return LL_GPDMA1_REQUEST_TIM4_CH4;
    case 148: return LL_GPDMA1_REQUEST_TIM4_UP;
    case 149: return LL_GPDMA1_REQUEST_TIM4_TRIG;
    case 150: return LL_GPDMA1_REQUEST_TIM5_CH1;
    case 151: return LL_GPDMA1_REQUEST_TIM5_CH2;
    case 152: return LL_GPDMA1_REQUEST_TIM5_CH3;
    case 153: return LL_GPDMA1_REQUEST_TIM5_CH4;
    case 154: return LL_GPDMA1_REQUEST_TIM5_UP;
    case 155: return LL_GPDMA1_REQUEST_TIM5_TRIG;
    case 156: return LL_GPDMA1_REQUEST_TIM6_UP;
    case 157: return LL_GPDMA1_REQUEST_TIM7_UP;
    case 158: return LL_GPDMA1_REQUEST_TIM15_CH1;
    case 159: return LL_GPDMA1_REQUEST_TIM15_CH2;
    case 160: return LL_GPDMA1_REQUEST_TIM15_UP;
    case 161: return LL_GPDMA1_REQUEST_TIM15_TRIG;
    case 162: return LL_GPDMA1_REQUEST_TIM15_COM;
    case 163: return LL_GPDMA1_REQUEST_TIM16_CH1;
    case 164: return LL_GPDMA1_REQUEST_TIM16_UP;
    case 165: return LL_GPDMA1_REQUEST_TIM16_COM;
    case 166: return LL_GPDMA1_REQUEST_TIM17_CH1;
    case 167: return LL_GPDMA1_REQUEST_TIM17_UP;
    case 168: return LL_GPDMA1_REQUEST_TIM17_COM;
    case 169: return LL_GPDMA1_REQUEST_SPI1_RX;
    case 170: return LL_GPDMA1_REQUEST_SPI1_TX;
    case 171: return LL_GPDMA1_REQUEST_SPI2_RX;
    case 172: return LL_GPDMA1_REQUEST_SPI2_TX;
    case 173: return LL_GPDMA1_REQUEST_SPI3_RX;
    case 174: return LL_GPDMA1_REQUEST_SPI3_TX;
    case 175: return LL_GPDMA1_REQUEST_SPI4_RX;
    case 176: return LL_GPDMA1_REQUEST_SPI4_TX;
    case 177: return LL_GPDMA1_REQUEST_SPI5_RX;
    case 178: return LL_GPDMA1_REQUEST_SPI5_TX;
    case 179: return LL_GPDMA1_REQUEST_SPI6_RX;
    case 180: return LL_GPDMA1_REQUEST_SPI6_TX;
    case 181: return LL_GPDMA1_REQUEST_SAI1_A;
    case 182: return LL_GPDMA1_REQUEST_SAI1_B;
    case 183: return LL_GPDMA1_REQUEST_SAI2_A;
    case 184: return LL_GPDMA1_REQUEST_SAI2_B;
    case 185: return LL_GPDMA1_REQUEST_I2C1_RX;
    case 186: return LL_GPDMA1_REQUEST_I2C1_TX;
    case 187: return LL_GPDMA1_REQUEST_I2C2_RX;
    case 188: return LL_GPDMA1_REQUEST_I2C2_TX;
    case 189: return LL_GPDMA1_REQUEST_I2C3_RX;
    case 190: return LL_GPDMA1_REQUEST_I2C3_TX;
    case 191: return LL_GPDMA1_REQUEST_USART1_RX;
    case 192: return LL_GPDMA1_REQUEST_USART1_TX;
    case 193: return LL_GPDMA1_REQUEST_USART2_RX;
    case 194: return LL_GPDMA1_REQUEST_USART2_TX;
    case 195: return LL_GPDMA1_REQUEST_USART3_RX;
    case 196: return LL_GPDMA1_REQUEST_USART3_TX;
    case 197: return LL_GPDMA1_REQUEST_UART4_RX;
    case 198: return LL_GPDMA1_REQUEST_UART4_TX;
    case 199: return LL_GPDMA1_REQUEST_UART5_RX;
    case 200: return LL_GPDMA1_REQUEST_UART5_TX;
    case 201: return LL_GPDMA1_REQUEST_UART7_RX;
    case 202: return LL_GPDMA1_REQUEST_UART7_TX;
    case 203: return LL_GPDMA1_REQUEST_UART8_RX;
    case 204: return LL_GPDMA1_REQUEST_UART8_TX;
    case 205: return LL_GPDMA1_REQUEST_CORDIC_READ;
    case 206: return LL_GPDMA1_REQUEST_CORDIC_WRITE;
    case 207: return LL_GPDMA1_REQUEST_LPTIM1_IC1;
    case 208: return LL_GPDMA1_REQUEST_LPTIM1_IC2;
    case 209: return LL_GPDMA1_REQUEST_LPTIM1_UE;
    case 210: return LL_GPDMA1_REQUEST_LPTIM2_IC1;
    case 211: return LL_GPDMA1_REQUEST_LPTIM2_IC2;
    case 212: return LL_GPDMA1_REQUEST_LPTIM2_UE;
    case 213: return LL_GPDMA1_REQUEST_SPDIF_RX_DT;
    case 214: return LL_GPDMA1_REQUEST_SPDIF_RX_CS;
    case 215: return LL_GPDMA1_REQUEST_ADF1_FLT0;
    case 216: return LL_GPDMA1_REQUEST_UCPD1_TX;
    case 217: return LL_GPDMA1_REQUEST_UCPD1_RX;
    case 218: return LL_GPDMA1_REQUEST_PSSI;
    case 219: return LL_GPDMA1_REQUEST_LPUART1_RX;
    case 220: return LL_GPDMA1_REQUEST_LPUART1_TX;
    case 221: return LL_GPDMA1_REQUEST_LPTIM3_IC1;
    case 222: return LL_GPDMA1_REQUEST_LPTIM3_IC2;
    case 223: return LL_GPDMA1_REQUEST_LPTIM3_UE;
    case 224: return LL_GPDMA1_REQUEST_I3C1_RX;
    case 225: return LL_GPDMA1_REQUEST_I3C1_TX;
    case 226: return LL_GPDMA1_REQUEST_I3C1_TC;
    case 227: return LL_GPDMA1_REQUEST_I3C1_RS;
    case 228: return LL_HPDMA1_TRIGGER_DCMIPP_EVT_FRAMEEND;
    case 229: return LL_HPDMA1_TRIGGER_DCMIPP_EVT_HSYNC;
    case 230: return LL_HPDMA1_TRIGGER_DCMIPP_EVT_LINEEND;
    case 231: return LL_HPDMA1_TRIGGER_DCMIPP_EVT_VSYNC;
    case 232: return LL_HPDMA1_TRIGGER_DMA2D_CTC_FLAG;
    case 233: return LL_HPDMA1_TRIGGER_DMA2D_TC_FLAG;
    case 234: return LL_HPDMA1_TRIGGER_DMA2D_TW_FLAG;
    case 235: return LL_HPDMA1_TRIGGER_JPEG_EOC_FLAG;
    case 236: return LL_HPDMA1_TRIGGER_JPEG_IFNF_FLAG;
    case 237: return LL_HPDMA1_TRIGGER_JPEG_IFT_FLAG;
    case 238: return LL_HPDMA1_TRIGGER_JPEG_OFNE_FLAG;
    case 239: return LL_HPDMA1_TRIGGER_JPEG_OFT_FLAG;
    case 240: return LL_HPDMA1_TRIGGER_LCD;
    case 241: return LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG0;
    case 242: return LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG1;
    case 243: return LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG2;
    case 244: return LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG3;
    case 245: return LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_4;
    case 246: return LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_3;
    case 247: return LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_2;
    case 248: return LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_1;
    case 249: return LL_HPDMA1_TRIGGER_GPDMA1_CH0_TCF;
    case 250: return LL_HPDMA1_TRIGGER_GPDMA1_CH1_TCF;
    case 251: return LL_HPDMA1_TRIGGER_GPDMA1_CH2_TCF;
    case 252: return LL_HPDMA1_TRIGGER_GPDMA1_CH3_TCF;
    case 253: return LL_HPDMA1_TRIGGER_GPDMA1_CH4_TCF;
    case 254: return LL_HPDMA1_TRIGGER_GPDMA1_CH5_TCF;
    case 255: return LL_HPDMA1_TRIGGER_GPDMA1_CH6_TCF;
    case 256: return LL_HPDMA1_TRIGGER_GPDMA1_CH7_TCF;
    case 257: return LL_HPDMA1_TRIGGER_GPDMA1_CH8_TCF;
    case 258: return LL_HPDMA1_TRIGGER_GPDMA1_CH9_TCF;
    case 259: return LL_HPDMA1_TRIGGER_GPDMA1_CH10_TCF;
    case 260: return LL_HPDMA1_TRIGGER_GPDMA1_CH11_TCF;
    case 261: return LL_HPDMA1_TRIGGER_GPDMA1_CH12_TCF;
    case 262: return LL_HPDMA1_TRIGGER_GPDMA1_CH13_TCF;
    case 263: return LL_HPDMA1_TRIGGER_GPDMA1_CH14_TCF;
    case 264: return LL_HPDMA1_TRIGGER_GPDMA1_CH15_TCF;
    case 265: return LL_HPDMA1_TRIGGER_HPDMA1_CH0_TCF;
    case 266: return LL_HPDMA1_TRIGGER_HPDMA1_CH1_TCF;
    case 267: return LL_HPDMA1_TRIGGER_HPDMA1_CH2_TCF;
    case 268: return LL_HPDMA1_TRIGGER_HPDMA1_CH3_TCF;
    case 269: return LL_HPDMA1_TRIGGER_HPDMA1_CH4_TCF;
    case 270: return LL_HPDMA1_TRIGGER_HPDMA1_CH5_TCF;
    case 271: return LL_HPDMA1_TRIGGER_HPDMA1_CH6_TCF;
    case 272: return LL_HPDMA1_TRIGGER_HPDMA1_CH7_TCF;
    case 273: return LL_HPDMA1_TRIGGER_HPDMA1_CH8_TCF;
    case 274: return LL_HPDMA1_TRIGGER_HPDMA1_CH9_TCF;
    case 275: return LL_HPDMA1_TRIGGER_HPDMA1_CH10_TCF;
    case 276: return LL_HPDMA1_TRIGGER_HPDMA1_CH11_TCF;
    case 277: return LL_HPDMA1_TRIGGER_HPDMA1_CH12_TCF;
    case 278: return LL_HPDMA1_TRIGGER_HPDMA1_CH13_TCF;
    case 279: return LL_HPDMA1_TRIGGER_HPDMA1_CH14_TCF;
    case 280: return LL_HPDMA1_TRIGGER_HPDMA1_CH15_TCF;
    case 281: return LL_GPDMA1_TRIGGER_HPDMA1_CH0_TCF;
    case 282: return LL_GPDMA1_TRIGGER_HPDMA1_CH1_TCF;
    case 283: return LL_GPDMA1_TRIGGER_HPDMA1_CH2_TCF;
    case 284: return LL_GPDMA1_TRIGGER_HPDMA1_CH3_TCF;
    case 285: return LL_GPDMA1_TRIGGER_HPDMA1_CH4_TCF;
    case 286: return LL_GPDMA1_TRIGGER_HPDMA1_CH5_TCF;
    case 287: return LL_GPDMA1_TRIGGER_HPDMA1_CH6_TCF;
    case 288: return LL_GPDMA1_TRIGGER_HPDMA1_CH7_TCF;
    case 289: return LL_GPDMA1_TRIGGER_HPDMA1_CH8_TCF;
    case 290: return LL_GPDMA1_TRIGGER_HPDMA1_CH9_TCF;
    case 291: return LL_GPDMA1_TRIGGER_HPDMA1_CH10_TCF;
    case 292: return LL_GPDMA1_TRIGGER_HPDMA1_CH11_TCF;
    case 293: return LL_GPDMA1_TRIGGER_HPDMA1_CH12_TCF;
    case 294: return LL_GPDMA1_TRIGGER_HPDMA1_CH13_TCF;
    case 295: return LL_GPDMA1_TRIGGER_HPDMA1_CH14_TCF;
    case 296: return LL_GPDMA1_TRIGGER_HPDMA1_CH15_TCF;
    case 297: return LL_GPDMA1_TRIGGER_LPTIM1_CH1;
    case 298: return LL_GPDMA1_TRIGGER_LPTIM1_CH2;
    case 299: return LL_GPDMA1_TRIGGER_LPTIM2_CH1;
    case 300: return LL_GPDMA1_TRIGGER_LPTIM2_CH2;
    case 301: return LL_GPDMA1_TRIGGER_LPTIM3_CH1;
    case 302: return LL_GPDMA1_TRIGGER_LPTIM3_CH2;
    case 303: return LL_GPDMA1_TRIGGER_LPTIM4_OUT;
    case 304: return LL_GPDMA1_TRIGGER_LPTIM5_OUT;
    case 305: return LL_GPDMA1_TRIGGER_EXTIT0_SYNC;
    case 306: return LL_GPDMA1_TRIGGER_RTC_WKUP;
    case 307: return LL_GPDMA1_TRIGGER_LPUART1_IT_R_WUP_ASYNC;
    case 308: return LL_GPDMA1_TRIGGER_LPUART1_IT_T_WUP_ASYNC;
    case 309: return LL_GPDMA1_TRIGGER_SPI6_IT_OR_SPI6_AIT_SYNC;
    case 310: return LL_GPDMA1_TRIGGER_GPDMA1_CH0_TCF;
    case 311: return LL_GPDMA1_TRIGGER_GPDMA1_CH1_TCF;
    case 312: return LL_GPDMA1_TRIGGER_GPDMA1_CH2_TCF;
    case 313: return LL_GPDMA1_TRIGGER_GPDMA1_CH3_TCF;
    case 314: return LL_GPDMA1_TRIGGER_GPDMA1_CH4_TCF;
    case 315: return LL_GPDMA1_TRIGGER_GPDMA1_CH5_TCF;
    case 316: return LL_GPDMA1_TRIGGER_GPDMA1_CH6_TCF;
    case 317: return LL_GPDMA1_TRIGGER_GPDMA1_CH7_TCF;
    case 318: return LL_GPDMA1_TRIGGER_GPDMA1_CH8_TCF;
    case 319: return LL_GPDMA1_TRIGGER_GPDMA1_CH9_TCF;
    case 320: return LL_GPDMA1_TRIGGER_GPDMA1_CH10_TCF;
    case 321: return LL_GPDMA1_TRIGGER_GPDMA1_CH11_TCF;
    case 322: return LL_GPDMA1_TRIGGER_GPDMA1_CH12_TCF;
    case 323: return LL_GPDMA1_TRIGGER_GPDMA1_CH13_TCF;
    case 324: return LL_GPDMA1_TRIGGER_GPDMA1_CH14_TCF;
    case 325: return LL_GPDMA1_TRIGGER_GPDMA1_CH15_TCF;
    case 326: return LL_GPDMA1_TRIGGER_TIM1_TRGO;
    case 327: return LL_GPDMA1_TRIGGER_TIM1_TRGO2;
    case 328: return LL_GPDMA1_TRIGGER_TIM2_TRGO;
    case 329: return LL_GPDMA1_TRIGGER_TIM3_TRGO;
    case 330: return LL_GPDMA1_TRIGGER_TIM4_TRGO;
    case 331: return LL_GPDMA1_TRIGGER_TIM5_TRGO;
    case 332: return LL_GPDMA1_TRIGGER_TIM6_TRGO;
    case 333: return LL_GPDMA1_TRIGGER_TIM7_TRGO;
    case 334: return LL_GPDMA1_TRIGGER_TIM9_TRGO;
    case 335: return LL_GPDMA1_TRIGGER_TIM12_TRGO;
    case 336: return LL_GPDMA1_TRIGGER_TIM15_TRGO;
    case 337: return LL_DMA2D_FLAG_CEIF;
    case 338: return LL_DMA2D_FLAG_CTCIF;
    case 339: return LL_DMA2D_FLAG_CAEIF;
    case 340: return LL_DMA2D_FLAG_TWIF;
    case 341: return LL_DMA2D_FLAG_TCIF;
    case 342: return LL_DMA2D_FLAG_TEIF;
    case 343: return LL_DMA2D_IT_CEIE;
    case 344: return LL_DMA2D_IT_CTCIE;
    case 345: return LL_DMA2D_IT_CAEIE;
    case 346: return LL_DMA2D_IT_TWIE;
    case 347: return LL_DMA2D_IT_TCIE;
    case 348: return LL_DMA2D_IT_TEIE;
    case 349: return LL_DMA2D_MODE_M2M;
    case 350: return LL_DMA2D_MODE_M2M_PFC;
    case 351: return LL_DMA2D_MODE_M2M_BLEND;
    case 352: return LL_DMA2D_MODE_R2M;
    case 353: return LL_DMA2D_MODE_M2M_BLEND_FIXED_COLOR_FG;
    case 354: return LL_DMA2D_MODE_M2M_BLEND_FIXED_COLOR_BG;
    case 355: return LL_DMA2D_OUTPUT_MODE_ARGB8888;
    case 356: return LL_DMA2D_OUTPUT_MODE_RGB888;
    case 357: return LL_DMA2D_OUTPUT_MODE_RGB565;
    case 358: return LL_DMA2D_OUTPUT_MODE_ARGB1555;
    case 359: return LL_DMA2D_OUTPUT_MODE_ARGB4444;
    case 360: return LL_DMA2D_INPUT_MODE_ARGB8888;
    case 361: return LL_DMA2D_INPUT_MODE_RGB888;
    case 362: return LL_DMA2D_INPUT_MODE_RGB565;
    case 363: return LL_DMA2D_INPUT_MODE_ARGB1555;
    case 364: return LL_DMA2D_INPUT_MODE_ARGB4444;
    case 365: return LL_DMA2D_INPUT_MODE_L8;
    case 366: return LL_DMA2D_INPUT_MODE_AL44;
    case 367: return LL_DMA2D_INPUT_MODE_AL88;
    case 368: return LL_DMA2D_INPUT_MODE_L4;
    case 369: return LL_DMA2D_INPUT_MODE_A8;
    case 370: return LL_DMA2D_INPUT_MODE_A4;
    case 371: return LL_DMA2D_INPUT_MODE_YCBCR;
    case 372: return LL_DMA2D_ALPHA_MODE_NO_MODIF;
    case 373: return LL_DMA2D_ALPHA_MODE_REPLACE;
    case 374: return LL_DMA2D_ALPHA_MODE_COMBINE;
    case 375: return LL_DMA2D_SWAP_MODE_REGULAR;
    case 376: return LL_DMA2D_SWAP_MODE_TWO_BY_TWO;
    case 377: return LL_DMA2D_RB_MODE_REGULAR;
    case 378: return LL_DMA2D_RB_MODE_SWAP;
    case 379: return LL_DMA2D_ALPHA_REGULAR;
    case 380: return LL_DMA2D_ALPHA_INVERTED;
    case 381: return LL_DMA2D_LINE_OFFSET_PIXELS;
    case 382: return LL_DMA2D_LINE_OFFSET_BYTES;
    case 383: return LL_DMA2D_CLUT_COLOR_MODE_ARGB8888;
    case 384: return LL_DMA2D_CLUT_COLOR_MODE_RGB888;
    case 385: return LL_DMA2D_CSS_444;
    case 386: return LL_DMA2D_CSS_422;
    case 387: return LL_DMA2D_CSS_420;
    case 388: return LL_DMA_CH_OFFSET_TAB[0];
    case 389: return LL_DMA_CH_OFFSET_TAB[1];
    case 390: return LL_DMA_CH_OFFSET_TAB[2];
    case 391: return LL_DMA_CH_OFFSET_TAB[3];
    case 392: return LL_DMA_CH_OFFSET_TAB[4];
    case 393: return LL_DMA_CH_OFFSET_TAB[5];
    case 394: return LL_DMA_CH_OFFSET_TAB[6];
    case 395: return LL_DMA_CH_OFFSET_TAB[7];
    case 396: return LL_DMA_CH_OFFSET_TAB[8];
    case 397: return LL_DMA_CH_OFFSET_TAB[9];
    case 398: return LL_DMA_CH_OFFSET_TAB[10];
    case 399: return LL_DMA_CH_OFFSET_TAB[11];
    case 400: return LL_DMA_CH_OFFSET_TAB[12];
    case 401: return LL_DMA_CH_OFFSET_TAB[13];
    case 402: return LL_DMA_CH_OFFSET_TAB[14];
    case 403: return LL_DMA_CH_OFFSET_TAB[15];
    default:abort();
  }
}
#undef GPDMA1
#define GPDMA1 ((DMA_TypeDef *)GPDMA1_BASE)
#undef GPDMA1_Channel0
#define GPDMA1_Channel0 ((DMA_Channel_TypeDef *)GPDMA1_Channel0_BASE)
#undef GPDMA1_Channel1
#define GPDMA1_Channel1 ((DMA_Channel_TypeDef *)GPDMA1_Channel1_BASE)
#undef GPDMA1_Channel2
#define GPDMA1_Channel2 ((DMA_Channel_TypeDef *)GPDMA1_Channel2_BASE)
#undef GPDMA1_Channel3
#define GPDMA1_Channel3 ((DMA_Channel_TypeDef *)GPDMA1_Channel3_BASE)
#undef GPDMA1_Channel4
#define GPDMA1_Channel4 ((DMA_Channel_TypeDef *)GPDMA1_Channel4_BASE)
#undef GPDMA1_Channel5
#define GPDMA1_Channel5 ((DMA_Channel_TypeDef *)GPDMA1_Channel5_BASE)
#undef GPDMA1_Channel6
#define GPDMA1_Channel6 ((DMA_Channel_TypeDef *)GPDMA1_Channel6_BASE)
#undef GPDMA1_Channel7
#define GPDMA1_Channel7 ((DMA_Channel_TypeDef *)GPDMA1_Channel7_BASE)
#undef GPDMA1_Channel8
#define GPDMA1_Channel8 ((DMA_Channel_TypeDef *)GPDMA1_Channel8_BASE)
#undef GPDMA1_Channel9
#define GPDMA1_Channel9 ((DMA_Channel_TypeDef *)GPDMA1_Channel9_BASE)
#undef GPDMA1_Channel10
#define GPDMA1_Channel10 ((DMA_Channel_TypeDef *)GPDMA1_Channel10_BASE)
#undef GPDMA1_Channel11
#define GPDMA1_Channel11 ((DMA_Channel_TypeDef *)GPDMA1_Channel11_BASE)
#undef GPDMA1_Channel12
#define GPDMA1_Channel12 ((DMA_Channel_TypeDef *)GPDMA1_Channel12_BASE)
#undef GPDMA1_Channel13
#define GPDMA1_Channel13 ((DMA_Channel_TypeDef *)GPDMA1_Channel13_BASE)
#undef GPDMA1_Channel14
#define GPDMA1_Channel14 ((DMA_Channel_TypeDef *)GPDMA1_Channel14_BASE)
#undef GPDMA1_Channel15
#define GPDMA1_Channel15 ((DMA_Channel_TypeDef *)GPDMA1_Channel15_BASE)
#undef HPDMA1
#define HPDMA1 ((DMA_TypeDef *)HPDMA1_BASE)
#undef HPDMA1_Channel0
#define HPDMA1_Channel0 ((DMA_Channel_TypeDef *)HPDMA1_Channel0_BASE)
#undef HPDMA1_Channel1
#define HPDMA1_Channel1 ((DMA_Channel_TypeDef *)HPDMA1_Channel1_BASE)
#undef HPDMA1_Channel2
#define HPDMA1_Channel2 ((DMA_Channel_TypeDef *)HPDMA1_Channel2_BASE)
#undef HPDMA1_Channel3
#define HPDMA1_Channel3 ((DMA_Channel_TypeDef *)HPDMA1_Channel3_BASE)
#undef HPDMA1_Channel4
#define HPDMA1_Channel4 ((DMA_Channel_TypeDef *)HPDMA1_Channel4_BASE)
#undef HPDMA1_Channel5
#define HPDMA1_Channel5 ((DMA_Channel_TypeDef *)HPDMA1_Channel5_BASE)
#undef HPDMA1_Channel6
#define HPDMA1_Channel6 ((DMA_Channel_TypeDef *)HPDMA1_Channel6_BASE)
#undef HPDMA1_Channel7
#define HPDMA1_Channel7 ((DMA_Channel_TypeDef *)HPDMA1_Channel7_BASE)
#undef HPDMA1_Channel8
#define HPDMA1_Channel8 ((DMA_Channel_TypeDef *)HPDMA1_Channel8_BASE)
#undef HPDMA1_Channel9
#define HPDMA1_Channel9 ((DMA_Channel_TypeDef *)HPDMA1_Channel9_BASE)
#undef HPDMA1_Channel10
#define HPDMA1_Channel10 ((DMA_Channel_TypeDef *)HPDMA1_Channel10_BASE)
#undef HPDMA1_Channel11
#define HPDMA1_Channel11 ((DMA_Channel_TypeDef *)HPDMA1_Channel11_BASE)
#undef HPDMA1_Channel12
#define HPDMA1_Channel12 ((DMA_Channel_TypeDef *)HPDMA1_Channel12_BASE)
#undef HPDMA1_Channel13
#define HPDMA1_Channel13 ((DMA_Channel_TypeDef *)HPDMA1_Channel13_BASE)
#undef HPDMA1_Channel14
#define HPDMA1_Channel14 ((DMA_Channel_TypeDef *)HPDMA1_Channel14_BASE)
#undef HPDMA1_Channel15
#define HPDMA1_Channel15 ((DMA_Channel_TypeDef *)HPDMA1_Channel15_BASE)
static uint32_t conversions(uint32_t op,const uint32_t *args) {
  switch(op) {
  case 307:return (uint32_t)(uintptr_t)LL_DMA_GET_INSTANCE(args[0]);
  case 308:return LL_DMA_GET_CHANNEL(args[0]);
  case 309:return (uint32_t)(uintptr_t)(LL_DMA_GET_CHANNEL_INSTANCE(args[0],args[1]));
  default:abort();
  }
}
