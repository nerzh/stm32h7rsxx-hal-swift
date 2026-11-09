import XCTest
import STM32H7RSHAL
import CLLReference

private struct LLDMAAccess: Equatable {
    var index: UInt32
    var value: UInt32
    var kind: UInt32
}
private final class LLDMAImage: LLDMARegisterIO, DMA2DRegisterIO, DMAMemoryIO {
    var cells: [UInt32]
    var trace: [LLDMAAccess] = []
    var reads: UInt32 = 0
    let salt: UInt32
    let controllerID: UInt32
    var controller: DMAController { controllerID == 0 ? .gpdma1 : .hpdma1 }
    init(seed: UInt32, salt: UInt32, controller: UInt32) {
        cells = (0..<4096).map { seed ^ (UInt32($0) &* 0x9E3779B9) }
        self.salt = salt
        self.controllerID = controller
    }
    func readIndex(_ index: Int) -> UInt32 {
        let value = cells[index] ^ (salt &* reads)
        reads &+= 1
        trace.append(.init(index: UInt32(index), value: value, kind: 0))
        return value
    }
    func writeIndex(_ index: Int, _ value: UInt32) {
        trace.append(.init(index: UInt32(index), value: value, kind: 1))
        cells[index] = value
    }
    func read32(at address: UInt32) -> UInt32 { readIndex(3072 + Int((address - 0x24010000) / 4)) }
    func write32(at address: UInt32, value: UInt32) { writeIndex(3072 + Int((address - 0x24010000) / 4), value) }
    func read(_ register: LLBusRegister) -> UInt32 { readIndex(2304 + Int(register.rawValue / 4)) }
    func write(_ register: LLBusRegister, value: UInt32) { writeIndex(2304 + Int(register.rawValue / 4), value) }
    func read(_ register: DMA2DRegister) -> UInt32 { readIndex(2048 + Int(register.rawValue / 4)) }
    func write(_ register: DMA2DRegister, value: UInt32) { writeIndex(2048 + Int(register.rawValue / 4), value) }
    func isClockEnabled() -> Bool { preconditionFailure("Not used by LL") }
    func index(_ register: DMARegister, _ channel: UInt32) -> Int {
        let base = controllerID == 0 ? 0 : 1024
        switch register {
        case .privcfgr: return base + 1
        case .rcfglockr: return base + 2
        case .misr: return base + 3
        case .clbar: return base + 20 + Int(channel) * 32 + 0
        case .cfcr: return base + 20 + Int(channel) * 32 + 3
        case .csr: return base + 20 + Int(channel) * 32 + 4
        case .ccr: return base + 20 + Int(channel) * 32 + 5
        case .ctr1: return base + 20 + Int(channel) * 32 + 16
        case .ctr2: return base + 20 + Int(channel) * 32 + 17
        case .cbr1: return base + 20 + Int(channel) * 32 + 18
        case .csar: return base + 20 + Int(channel) * 32 + 19
        case .cdar: return base + 20 + Int(channel) * 32 + 20
        case .ctr3: return base + 20 + Int(channel) * 32 + 21
        case .cbr2: return base + 20 + Int(channel) * 32 + 22
        case .cllr: return base + 20 + Int(channel) * 32 + 31
        }
    }
    func read(_ register: DMARegister, channel: UInt32) -> UInt32 { readIndex(index(register, channel)) }
    func write(_ register: DMARegister, channel: UInt32, value: UInt32) { writeIndex(index(register, channel), value) }
}
private func runLLDMA(_ op: Int, _ io: inout LLDMAImage, _ args: [UInt32]) -> UInt32 {
    switch op {
    case 0:
        LL_DMA_EnableChannel(&io, args[0])
        return 0
    case 1:
        LL_DMA_DisableChannel(&io, args[0])
        return 0
    case 2:
        let result = LL_DMA_IsEnabledChannel(&io, args[0])
        return result
    case 3:
        LL_DMA_ResetChannel(&io, args[0])
        return 0
    case 4:
        LL_DMA_SuspendChannel(&io, args[0])
        return 0
    case 5:
        LL_DMA_ResumeChannel(&io, args[0])
        return 0
    case 6:
        let result = LL_DMA_IsSuspendedChannel(&io, args[0])
        return result
    case 7:
        LL_DMA_SetLinkedListBaseAddr(&io, args[0], args[1])
        return 0
    case 8:
        let result = LL_DMA_GetLinkedListBaseAddr(&io, args[0])
        return result
    case 9:
        LL_DMA_ConfigControl(&io, args[0], args[1])
        return 0
    case 10:
        LL_DMA_SetChannelPriorityLevel(&io, args[0], args[1])
        return 0
    case 11:
        let result = LL_DMA_GetChannelPriorityLevel(&io, args[0])
        return result
    case 12:
        LL_DMA_SetLinkAllocatedPort(&io, args[0], args[1])
        return 0
    case 13:
        let result = LL_DMA_GetLinkAllocatedPort(&io, args[0])
        return result
    case 14:
        LL_DMA_SetLinkStepMode(&io, args[0], args[1])
        return 0
    case 15:
        let result = LL_DMA_GetLinkStepMode(&io, args[0])
        return result
    case 16:
        LL_DMA_ConfigTransfer(&io, args[0], args[1])
        return 0
    case 17:
        LL_DMA_ConfigBurstLength(&io, args[0], args[1], args[2])
        return 0
    case 18:
        LL_DMA_SetDestAllocatedPort(&io, args[0], args[1])
        return 0
    case 19:
        let result = LL_DMA_GetDestAllocatedPort(&io, args[0])
        return result
    case 20:
        LL_DMA_SetDestWordExchange(&io, args[0], args[1])
        return 0
    case 21:
        let result = LL_DMA_GetDestWordExchange(&io, args[0])
        return result
    case 22:
        LL_DMA_SetDestHWordExchange(&io, args[0], args[1])
        return 0
    case 23:
        let result = LL_DMA_GetDestHWordExchange(&io, args[0])
        return result
    case 24:
        LL_DMA_SetDestByteExchange(&io, args[0], args[1])
        return 0
    case 25:
        let result = LL_DMA_GetDestByteExchange(&io, args[0])
        return result
    case 26:
        LL_DMA_SetSrcByteExchange(&io, args[0], args[1])
        return 0
    case 27:
        let result = LL_DMA_GetSrcByteExchange(&io, args[0])
        return result
    case 28:
        LL_DMA_SetDestBurstLength(&io, args[0], args[1])
        return 0
    case 29:
        let result = LL_DMA_GetDestBurstLength(&io, args[0])
        return result
    case 30:
        LL_DMA_SetDestIncMode(&io, args[0], args[1])
        return 0
    case 31:
        let result = LL_DMA_GetDestIncMode(&io, args[0])
        return result
    case 32:
        LL_DMA_SetDestDataWidth(&io, args[0], args[1])
        return 0
    case 33:
        let result = LL_DMA_GetDestDataWidth(&io, args[0])
        return result
    case 34:
        LL_DMA_SetSrcAllocatedPort(&io, args[0], args[1])
        return 0
    case 35:
        let result = LL_DMA_GetSrcAllocatedPort(&io, args[0])
        return result
    case 36:
        LL_DMA_SetDataAlignment(&io, args[0], args[1])
        return 0
    case 37:
        let result = LL_DMA_GetDataAlignment(&io, args[0])
        return result
    case 38:
        LL_DMA_SetSrcBurstLength(&io, args[0], args[1])
        return 0
    case 39:
        let result = LL_DMA_GetSrcBurstLength(&io, args[0])
        return result
    case 40:
        LL_DMA_SetSrcIncMode(&io, args[0], args[1])
        return 0
    case 41:
        let result = LL_DMA_GetSrcIncMode(&io, args[0])
        return result
    case 42:
        LL_DMA_SetSrcDataWidth(&io, args[0], args[1])
        return 0
    case 43:
        let result = LL_DMA_GetSrcDataWidth(&io, args[0])
        return result
    case 44:
        LL_DMA_ConfigChannelTransfer(&io, args[0], args[1])
        return 0
    case 45:
        LL_DMA_SetTransferEventMode(&io, args[0], args[1])
        return 0
    case 46:
        let result = LL_DMA_GetTransferEventMode(&io, args[0])
        return result
    case 47:
        LL_DMA_SetTriggerPolarity(&io, args[0], args[1])
        return 0
    case 48:
        let result = LL_DMA_GetTriggerPolarity(&io, args[0])
        return result
    case 49:
        LL_DMA_SetTriggerMode(&io, args[0], args[1])
        return 0
    case 50:
        let result = LL_DMA_GetTriggerMode(&io, args[0])
        return result
    case 51:
        LL_DMA_SetDataTransferDirection(&io, args[0], args[1])
        return 0
    case 52:
        let result = LL_DMA_GetDataTransferDirection(&io, args[0])
        return result
    case 53:
        LL_DMA_SetBlkHWRequest(&io, args[0], args[1])
        return 0
    case 54:
        let result = LL_DMA_GetBlkHWRequest(&io, args[0])
        return result
    case 55:
        LL_DMA_SetPeriphRequest(&io, args[0], args[1])
        return 0
    case 56:
        let result = LL_DMA_GetPeriphRequest(&io, args[0])
        return result
    case 57:
        LL_DMA_SetHWTrigger(&io, args[0], args[1])
        return 0
    case 58:
        let result = LL_DMA_GetHWTrigger(&io, args[0])
        return result
    case 59:
        LL_DMA_SetTransferMode(&io, args[0], args[1])
        return 0
    case 60:
        let result = LL_DMA_GetTransferMode(&io, args[0])
        return result
    case 61:
        LL_DMA_ConfigBlkRptAddrUpdate(&io, args[0], args[1])
        return 0
    case 62:
        LL_DMA_ConfigBlkCounters(&io, args[0], args[1], args[2])
        return 0
    case 63:
        LL_DMA_SetBlkRptDestAddrUpdate(&io, args[0], args[1])
        return 0
    case 64:
        let result = LL_DMA_GetBlkRptDestAddrUpdate(&io, args[0])
        return result
    case 65:
        LL_DMA_SetBlkRptSrcAddrUpdate(&io, args[0], args[1])
        return 0
    case 66:
        let result = LL_DMA_GetBlkRptSrcAddrUpdate(&io, args[0])
        return result
    case 67:
        LL_DMA_SetDestAddrUpdate(&io, args[0], args[1])
        return 0
    case 68:
        let result = LL_DMA_GetDestAddrUpdate(&io, args[0])
        return result
    case 69:
        LL_DMA_SetSrcAddrUpdate(&io, args[0], args[1])
        return 0
    case 70:
        let result = LL_DMA_GetSrcAddrUpdate(&io, args[0])
        return result
    case 71:
        LL_DMA_SetBlkRptCount(&io, args[0], args[1])
        return 0
    case 72:
        let result = LL_DMA_GetBlkRptCount(&io, args[0])
        return result
    case 73:
        LL_DMA_SetBlkDataLength(&io, args[0], args[1])
        return 0
    case 74:
        let result = LL_DMA_GetBlkDataLength(&io, args[0])
        return result
    case 75:
        LL_DMA_ConfigAddresses(&io, args[0], args[1], args[2])
        return 0
    case 76:
        LL_DMA_SetSrcAddress(&io, args[0], args[1])
        return 0
    case 77:
        let result = LL_DMA_GetSrcAddress(&io, args[0])
        return result
    case 78:
        LL_DMA_SetDestAddress(&io, args[0], args[1])
        return 0
    case 79:
        let result = LL_DMA_GetDestAddress(&io, args[0])
        return result
    case 80:
        LL_DMA_ConfigAddrUpdateValue(&io, args[0], args[1], args[2])
        return 0
    case 81:
        LL_DMA_SetDestAddrUpdateValue(&io, args[0], args[1])
        return 0
    case 82:
        let result = LL_DMA_GetDestAddrUpdateValue(&io, args[0])
        return result
    case 83:
        LL_DMA_SetSrcAddrUpdateValue(&io, args[0], args[1])
        return 0
    case 84:
        let result = LL_DMA_GetSrcAddrUpdateValue(&io, args[0])
        return result
    case 85:
        LL_DMA_ConfigBlkRptAddrUpdateValue(&io, args[0], args[1], args[2])
        return 0
    case 86:
        LL_DMA_SetBlkRptDestAddrUpdateValue(&io, args[0], args[1])
        return 0
    case 87:
        let result = LL_DMA_GetBlkRptDestAddrUpdateValue(&io, args[0])
        return result
    case 88:
        LL_DMA_SetBlkRptSrcAddrUpdateValue(&io, args[0], args[1])
        return 0
    case 89:
        let result = LL_DMA_GetBlkRptSrcAddrUpdateValue(&io, args[0])
        return result
    case 90:
        LL_DMA_ConfigLinkUpdate(&io, args[0], args[1], args[2])
        return 0
    case 91:
        LL_DMA_EnableCTR1Update(&io, args[0])
        return 0
    case 92:
        LL_DMA_DisableCTR1Update(&io, args[0])
        return 0
    case 93:
        let result = LL_DMA_IsEnabledCTR1Update(&io, args[0])
        return result
    case 94:
        LL_DMA_EnableCTR2Update(&io, args[0])
        return 0
    case 95:
        LL_DMA_DisableCTR2Update(&io, args[0])
        return 0
    case 96:
        let result = LL_DMA_IsEnabledCTR2Update(&io, args[0])
        return result
    case 97:
        LL_DMA_EnableCBR1Update(&io, args[0])
        return 0
    case 98:
        LL_DMA_DisableCBR1Update(&io, args[0])
        return 0
    case 99:
        let result = LL_DMA_IsEnabledCBR1Update(&io, args[0])
        return result
    case 100:
        LL_DMA_EnableCSARUpdate(&io, args[0])
        return 0
    case 101:
        LL_DMA_DisableCSARUpdate(&io, args[0])
        return 0
    case 102:
        let result = LL_DMA_IsEnabledCSARUpdate(&io, args[0])
        return result
    case 103:
        LL_DMA_EnableCDARUpdate(&io, args[0])
        return 0
    case 104:
        LL_DMA_DisableCDARUpdate(&io, args[0])
        return 0
    case 105:
        let result = LL_DMA_IsEnabledCDARUpdate(&io, args[0])
        return result
    case 106:
        LL_DMA_EnableCTR3Update(&io, args[0])
        return 0
    case 107:
        LL_DMA_DisableCTR3Update(&io, args[0])
        return 0
    case 108:
        let result = LL_DMA_IsEnabledCTR3Update(&io, args[0])
        return result
    case 109:
        LL_DMA_EnableCBR2Update(&io, args[0])
        return 0
    case 110:
        LL_DMA_DisableCBR2Update(&io, args[0])
        return 0
    case 111:
        let result = LL_DMA_IsEnabledCBR2Update(&io, args[0])
        return result
    case 112:
        LL_DMA_EnableCLLRUpdate(&io, args[0])
        return 0
    case 113:
        LL_DMA_DisableCLLRUpdate(&io, args[0])
        return 0
    case 114:
        let result = LL_DMA_IsEnabledCLLRUpdate(&io, args[0])
        return result
    case 115:
        LL_DMA_SetLinkedListAddrOffset(&io, args[0], args[1])
        return 0
    case 116:
        let result = LL_DMA_GetLinkedListAddrOffset(&io, args[0])
        return result
    case 117:
        let result = LL_DMA_GetFIFOLevel(&io, args[0])
        return result
    case 118:
        LL_DMA_EnableChannelPrivilege(&io, args[0])
        return 0
    case 119:
        LL_DMA_DisableChannelPrivilege(&io, args[0])
        return 0
    case 120:
        let result = LL_DMA_IsEnabledChannelPrivilege(&io, args[0])
        return result
    case 121:
        LL_DMA_EnableChannelLockAttribute(&io, args[0])
        return 0
    case 122:
        let result = LL_DMA_IsEnabledChannelLockAttribute(&io, args[0])
        return result
    case 123:
        LL_DMA_ClearFlag_TO(&io, args[0])
        return 0
    case 124:
        LL_DMA_ClearFlag_SUSP(&io, args[0])
        return 0
    case 125:
        LL_DMA_ClearFlag_USE(&io, args[0])
        return 0
    case 126:
        LL_DMA_ClearFlag_ULE(&io, args[0])
        return 0
    case 127:
        LL_DMA_ClearFlag_DTE(&io, args[0])
        return 0
    case 128:
        LL_DMA_ClearFlag_HT(&io, args[0])
        return 0
    case 129:
        LL_DMA_ClearFlag_TC(&io, args[0])
        return 0
    case 130:
        let result = LL_DMA_IsActiveFlag_TO(&io, args[0])
        return result
    case 131:
        let result = LL_DMA_IsActiveFlag_SUSP(&io, args[0])
        return result
    case 132:
        let result = LL_DMA_IsActiveFlag_USE(&io, args[0])
        return result
    case 133:
        let result = LL_DMA_IsActiveFlag_ULE(&io, args[0])
        return result
    case 134:
        let result = LL_DMA_IsActiveFlag_DTE(&io, args[0])
        return result
    case 135:
        let result = LL_DMA_IsActiveFlag_HT(&io, args[0])
        return result
    case 136:
        let result = LL_DMA_IsActiveFlag_TC(&io, args[0])
        return result
    case 137:
        let result = LL_DMA_IsActiveFlag_IDLE(&io, args[0])
        return result
    case 138:
        let result = LL_DMA_IsActiveFlag_MIS(&io, args[0])
        return result
    case 139:
        LL_DMA_EnableIT_TO(&io, args[0])
        return 0
    case 140:
        LL_DMA_EnableIT_SUSP(&io, args[0])
        return 0
    case 141:
        LL_DMA_EnableIT_USE(&io, args[0])
        return 0
    case 142:
        LL_DMA_EnableIT_ULE(&io, args[0])
        return 0
    case 143:
        LL_DMA_EnableIT_DTE(&io, args[0])
        return 0
    case 144:
        LL_DMA_EnableIT_HT(&io, args[0])
        return 0
    case 145:
        LL_DMA_EnableIT_TC(&io, args[0])
        return 0
    case 146:
        LL_DMA_DisableIT_TO(&io, args[0])
        return 0
    case 147:
        LL_DMA_DisableIT_SUSP(&io, args[0])
        return 0
    case 148:
        LL_DMA_DisableIT_USE(&io, args[0])
        return 0
    case 149:
        LL_DMA_DisableIT_ULE(&io, args[0])
        return 0
    case 150:
        LL_DMA_DisableIT_DTE(&io, args[0])
        return 0
    case 151:
        LL_DMA_DisableIT_HT(&io, args[0])
        return 0
    case 152:
        LL_DMA_DisableIT_TC(&io, args[0])
        return 0
    case 153:
        let result = LL_DMA_IsEnabledIT_TO(&io, args[0])
        return result
    case 154:
        let result = LL_DMA_IsEnabledIT_SUSP(&io, args[0])
        return result
    case 155:
        let result = LL_DMA_IsEnabledIT_USE(&io, args[0])
        return result
    case 156:
        let result = LL_DMA_IsEnabledIT_ULE(&io, args[0])
        return result
    case 157:
        let result = LL_DMA_IsEnabledIT_DTE(&io, args[0])
        return result
    case 158:
        let result = LL_DMA_IsEnabledIT_HT(&io, args[0])
        return result
    case 159:
        let result = LL_DMA_IsEnabledIT_TC(&io, args[0])
        return result
    case 160:
        let result = LL_DMA_DeInit(&io, args[0])
        return result
    case 161:
        var v2 = LL_DMA_InitTypeDef(SrcAddress: args[1], DestAddress: args[2], Direction: args[3], BlkHWRequest: args[4], DataAlignment: args[5], SrcBurstLength: args[6], DestBurstLength: args[7], SrcDataWidth: args[8], DestDataWidth: args[9], SrcIncMode: args[10], DestIncMode: args[11], Priority: args[12], BlkDataLength: args[13], BlkRptCount: args[14], TriggerMode: args[15], TriggerPolarity: args[16], TriggerSelection: args[17], Request: args[18], TransferEventMode: args[19], DestWordExchange: args[20], DestHWordExchange: args[21], DestByteExchange: args[22], SrcByteExchange: args[23], SrcAllocatedPort: args[24], DestAllocatedPort: args[25], LinkAllocatedPort: args[26], LinkStepMode: args[27], SrcAddrUpdateMode: args[28], DestAddrUpdateMode: args[29], SrcAddrOffset: args[30], DestAddrOffset: args[31], BlkRptSrcAddrUpdateMode: args[32], BlkRptDestAddrUpdateMode: args[33], BlkRptSrcAddrOffset: args[34], BlkRptDestAddrOffset: args[35], LinkedListBaseAddr: args[36], LinkedListAddrOffset: args[37], Mode: args[38])
        let result = LL_DMA_Init(&io, args[0], &v2)
        io.cells[3500] = v2.SrcAddress
        io.cells[3501] = v2.DestAddress
        io.cells[3502] = v2.Direction
        io.cells[3503] = v2.BlkHWRequest
        io.cells[3504] = v2.DataAlignment
        io.cells[3505] = v2.SrcBurstLength
        io.cells[3506] = v2.DestBurstLength
        io.cells[3507] = v2.SrcDataWidth
        io.cells[3508] = v2.DestDataWidth
        io.cells[3509] = v2.SrcIncMode
        io.cells[3510] = v2.DestIncMode
        io.cells[3511] = v2.Priority
        io.cells[3512] = v2.BlkDataLength
        io.cells[3513] = v2.BlkRptCount
        io.cells[3514] = v2.TriggerMode
        io.cells[3515] = v2.TriggerPolarity
        io.cells[3516] = v2.TriggerSelection
        io.cells[3517] = v2.Request
        io.cells[3518] = v2.TransferEventMode
        io.cells[3519] = v2.DestWordExchange
        io.cells[3520] = v2.DestHWordExchange
        io.cells[3521] = v2.DestByteExchange
        io.cells[3522] = v2.SrcByteExchange
        io.cells[3523] = v2.SrcAllocatedPort
        io.cells[3524] = v2.DestAllocatedPort
        io.cells[3525] = v2.LinkAllocatedPort
        io.cells[3526] = v2.LinkStepMode
        io.cells[3527] = v2.SrcAddrUpdateMode
        io.cells[3528] = v2.DestAddrUpdateMode
        io.cells[3529] = v2.SrcAddrOffset
        io.cells[3530] = v2.DestAddrOffset
        io.cells[3531] = v2.BlkRptSrcAddrUpdateMode
        io.cells[3532] = v2.BlkRptDestAddrUpdateMode
        io.cells[3533] = v2.BlkRptSrcAddrOffset
        io.cells[3534] = v2.BlkRptDestAddrOffset
        io.cells[3535] = v2.LinkedListBaseAddr
        io.cells[3536] = v2.LinkedListAddrOffset
        io.cells[3537] = v2.Mode
        return result
    case 162:
        var v0 = LL_DMA_InitTypeDef(SrcAddress: args[0], DestAddress: args[1], Direction: args[2], BlkHWRequest: args[3], DataAlignment: args[4], SrcBurstLength: args[5], DestBurstLength: args[6], SrcDataWidth: args[7], DestDataWidth: args[8], SrcIncMode: args[9], DestIncMode: args[10], Priority: args[11], BlkDataLength: args[12], BlkRptCount: args[13], TriggerMode: args[14], TriggerPolarity: args[15], TriggerSelection: args[16], Request: args[17], TransferEventMode: args[18], DestWordExchange: args[19], DestHWordExchange: args[20], DestByteExchange: args[21], SrcByteExchange: args[22], SrcAllocatedPort: args[23], DestAllocatedPort: args[24], LinkAllocatedPort: args[25], LinkStepMode: args[26], SrcAddrUpdateMode: args[27], DestAddrUpdateMode: args[28], SrcAddrOffset: args[29], DestAddrOffset: args[30], BlkRptSrcAddrUpdateMode: args[31], BlkRptDestAddrUpdateMode: args[32], BlkRptSrcAddrOffset: args[33], BlkRptDestAddrOffset: args[34], LinkedListBaseAddr: args[35], LinkedListAddrOffset: args[36], Mode: args[37])
        LL_DMA_StructInit(&v0)
        io.cells[3500] = v0.SrcAddress
        io.cells[3501] = v0.DestAddress
        io.cells[3502] = v0.Direction
        io.cells[3503] = v0.BlkHWRequest
        io.cells[3504] = v0.DataAlignment
        io.cells[3505] = v0.SrcBurstLength
        io.cells[3506] = v0.DestBurstLength
        io.cells[3507] = v0.SrcDataWidth
        io.cells[3508] = v0.DestDataWidth
        io.cells[3509] = v0.SrcIncMode
        io.cells[3510] = v0.DestIncMode
        io.cells[3511] = v0.Priority
        io.cells[3512] = v0.BlkDataLength
        io.cells[3513] = v0.BlkRptCount
        io.cells[3514] = v0.TriggerMode
        io.cells[3515] = v0.TriggerPolarity
        io.cells[3516] = v0.TriggerSelection
        io.cells[3517] = v0.Request
        io.cells[3518] = v0.TransferEventMode
        io.cells[3519] = v0.DestWordExchange
        io.cells[3520] = v0.DestHWordExchange
        io.cells[3521] = v0.DestByteExchange
        io.cells[3522] = v0.SrcByteExchange
        io.cells[3523] = v0.SrcAllocatedPort
        io.cells[3524] = v0.DestAllocatedPort
        io.cells[3525] = v0.LinkAllocatedPort
        io.cells[3526] = v0.LinkStepMode
        io.cells[3527] = v0.SrcAddrUpdateMode
        io.cells[3528] = v0.DestAddrUpdateMode
        io.cells[3529] = v0.SrcAddrOffset
        io.cells[3530] = v0.DestAddrOffset
        io.cells[3531] = v0.BlkRptSrcAddrUpdateMode
        io.cells[3532] = v0.BlkRptDestAddrUpdateMode
        io.cells[3533] = v0.BlkRptSrcAddrOffset
        io.cells[3534] = v0.BlkRptDestAddrOffset
        io.cells[3535] = v0.LinkedListBaseAddr
        io.cells[3536] = v0.LinkedListAddrOffset
        io.cells[3537] = v0.Mode
        return 0
    case 163:
        var v0 = LL_DMA_InitLinkedListTypeDef(Priority: args[0], LinkStepMode: args[1], LinkAllocatedPort: args[2], TransferEventMode: args[3])
        LL_DMA_ListStructInit(&v0)
        io.cells[3500] = v0.Priority
        io.cells[3501] = v0.LinkStepMode
        io.cells[3502] = v0.LinkAllocatedPort
        io.cells[3503] = v0.TransferEventMode
        return 0
    case 164:
        let result = LL_DMA_List_DeInit(&io, args[0])
        return result
    case 165:
        var v2 = LL_DMA_InitLinkedListTypeDef(Priority: args[1], LinkStepMode: args[2], LinkAllocatedPort: args[3], TransferEventMode: args[4])
        let result = LL_DMA_List_Init(&io, args[0], &v2)
        io.cells[3500] = v2.Priority
        io.cells[3501] = v2.LinkStepMode
        io.cells[3502] = v2.LinkAllocatedPort
        io.cells[3503] = v2.TransferEventMode
        return result
    case 166:
        var v0 = LL_DMA_InitNodeTypeDef(DestAllocatedPort: args[0], DestWordExchange: args[1], DestHWordExchange: args[2], DestByteExchange: args[3], DestBurstLength: args[4], DestIncMode: args[5], DestDataWidth: args[6], SrcAllocatedPort: args[7], SrcByteExchange: args[8], DataAlignment: args[9], SrcBurstLength: args[10], SrcIncMode: args[11], SrcDataWidth: args[12], TransferEventMode: args[13], TriggerPolarity: args[14], TriggerSelection: args[15], TriggerMode: args[16], BlkHWRequest: args[17], Direction: args[18], Request: args[19], Mode: args[20], BlkRptDestAddrUpdateMode: args[21], BlkRptSrcAddrUpdateMode: args[22], DestAddrUpdateMode: args[23], SrcAddrUpdateMode: args[24], BlkRptCount: args[25], BlkDataLength: args[26], SrcAddress: args[27], DestAddress: args[28], DestAddrOffset: args[29], SrcAddrOffset: args[30], BlkRptDestAddrOffset: args[31], BlkRptSrcAddrOffset: args[32], UpdateRegisters: args[33], NodeType: args[34])
        LL_DMA_NodeStructInit(&v0)
        io.cells[3500] = v0.DestAllocatedPort
        io.cells[3501] = v0.DestWordExchange
        io.cells[3502] = v0.DestHWordExchange
        io.cells[3503] = v0.DestByteExchange
        io.cells[3504] = v0.DestBurstLength
        io.cells[3505] = v0.DestIncMode
        io.cells[3506] = v0.DestDataWidth
        io.cells[3507] = v0.SrcAllocatedPort
        io.cells[3508] = v0.SrcByteExchange
        io.cells[3509] = v0.DataAlignment
        io.cells[3510] = v0.SrcBurstLength
        io.cells[3511] = v0.SrcIncMode
        io.cells[3512] = v0.SrcDataWidth
        io.cells[3513] = v0.TransferEventMode
        io.cells[3514] = v0.TriggerPolarity
        io.cells[3515] = v0.TriggerSelection
        io.cells[3516] = v0.TriggerMode
        io.cells[3517] = v0.BlkHWRequest
        io.cells[3518] = v0.Direction
        io.cells[3519] = v0.Request
        io.cells[3520] = v0.Mode
        io.cells[3521] = v0.BlkRptDestAddrUpdateMode
        io.cells[3522] = v0.BlkRptSrcAddrUpdateMode
        io.cells[3523] = v0.DestAddrUpdateMode
        io.cells[3524] = v0.SrcAddrUpdateMode
        io.cells[3525] = v0.BlkRptCount
        io.cells[3526] = v0.BlkDataLength
        io.cells[3527] = v0.SrcAddress
        io.cells[3528] = v0.DestAddress
        io.cells[3529] = v0.DestAddrOffset
        io.cells[3530] = v0.SrcAddrOffset
        io.cells[3531] = v0.BlkRptDestAddrOffset
        io.cells[3532] = v0.BlkRptSrcAddrOffset
        io.cells[3533] = v0.UpdateRegisters
        io.cells[3534] = v0.NodeType
        return 0
    case 167:
        let v0 = LL_DMA_InitNodeTypeDef(DestAllocatedPort: args[0], DestWordExchange: args[1], DestHWordExchange: args[2], DestByteExchange: args[3], DestBurstLength: args[4], DestIncMode: args[5], DestDataWidth: args[6], SrcAllocatedPort: args[7], SrcByteExchange: args[8], DataAlignment: args[9], SrcBurstLength: args[10], SrcIncMode: args[11], SrcDataWidth: args[12], TransferEventMode: args[13], TriggerPolarity: args[14], TriggerSelection: args[15], TriggerMode: args[16], BlkHWRequest: args[17], Direction: args[18], Request: args[19], Mode: args[20], BlkRptDestAddrUpdateMode: args[21], BlkRptSrcAddrUpdateMode: args[22], DestAddrUpdateMode: args[23], SrcAddrUpdateMode: args[24], BlkRptCount: args[25], BlkDataLength: args[26], SrcAddress: args[27], DestAddress: args[28], DestAddrOffset: args[29], SrcAddrOffset: args[30], BlkRptDestAddrOffset: args[31], BlkRptSrcAddrOffset: args[32], UpdateRegisters: args[33], NodeType: args[34])
        let result = LL_DMA_CreateLinkNode(v0, LL_DMA_LinkNodeTypeDef(memory: io, address: 0x24010000 &+ args[35] &* 4))
        io.cells[3500] = v0.DestAllocatedPort
        io.cells[3501] = v0.DestWordExchange
        io.cells[3502] = v0.DestHWordExchange
        io.cells[3503] = v0.DestByteExchange
        io.cells[3504] = v0.DestBurstLength
        io.cells[3505] = v0.DestIncMode
        io.cells[3506] = v0.DestDataWidth
        io.cells[3507] = v0.SrcAllocatedPort
        io.cells[3508] = v0.SrcByteExchange
        io.cells[3509] = v0.DataAlignment
        io.cells[3510] = v0.SrcBurstLength
        io.cells[3511] = v0.SrcIncMode
        io.cells[3512] = v0.SrcDataWidth
        io.cells[3513] = v0.TransferEventMode
        io.cells[3514] = v0.TriggerPolarity
        io.cells[3515] = v0.TriggerSelection
        io.cells[3516] = v0.TriggerMode
        io.cells[3517] = v0.BlkHWRequest
        io.cells[3518] = v0.Direction
        io.cells[3519] = v0.Request
        io.cells[3520] = v0.Mode
        io.cells[3521] = v0.BlkRptDestAddrUpdateMode
        io.cells[3522] = v0.BlkRptSrcAddrUpdateMode
        io.cells[3523] = v0.DestAddrUpdateMode
        io.cells[3524] = v0.SrcAddrUpdateMode
        io.cells[3525] = v0.BlkRptCount
        io.cells[3526] = v0.BlkDataLength
        io.cells[3527] = v0.SrcAddress
        io.cells[3528] = v0.DestAddress
        io.cells[3529] = v0.DestAddrOffset
        io.cells[3530] = v0.SrcAddrOffset
        io.cells[3531] = v0.BlkRptDestAddrOffset
        io.cells[3532] = v0.BlkRptSrcAddrOffset
        io.cells[3533] = v0.UpdateRegisters
        io.cells[3534] = v0.NodeType
        return result
    case 168:
        LL_DMA_ConnectLinkNode(LL_DMA_LinkNodeTypeDef(memory: io, address: 0x24010000 &+ args[0] &* 4), args[1], LL_DMA_LinkNodeTypeDef(memory: io, address: 0x24010000 &+ args[2] &* 4), args[3])
        return 0
    case 169:
        LL_DMA_DisconnectNextLinkNode(LL_DMA_LinkNodeTypeDef(memory: io, address: 0x24010000 &+ args[0] &* 4), args[1])
        return 0
    case 170:
        LL_DMA2D_Start(&io)
        return 0
    case 171:
        let result = LL_DMA2D_IsTransferOngoing(&io)
        return result
    case 172:
        LL_DMA2D_Suspend(&io)
        return 0
    case 173:
        LL_DMA2D_Resume(&io)
        return 0
    case 174:
        let result = LL_DMA2D_IsSuspended(&io)
        return result
    case 175:
        LL_DMA2D_Abort(&io)
        return 0
    case 176:
        let result = LL_DMA2D_IsAborted(&io)
        return result
    case 177:
        LL_DMA2D_SetMode(&io, args[0])
        return 0
    case 178:
        let result = LL_DMA2D_GetMode(&io)
        return result
    case 179:
        LL_DMA2D_SetOutputColorMode(&io, args[0])
        return 0
    case 180:
        let result = LL_DMA2D_GetOutputColorMode(&io)
        return result
    case 181:
        LL_DMA2D_SetOutputRBSwapMode(&io, args[0])
        return 0
    case 182:
        let result = LL_DMA2D_GetOutputRBSwapMode(&io)
        return result
    case 183:
        LL_DMA2D_SetOutputAlphaInvMode(&io, args[0])
        return 0
    case 184:
        let result = LL_DMA2D_GetOutputAlphaInvMode(&io)
        return result
    case 185:
        LL_DMA2D_SetOutputSwapMode(&io, args[0])
        return 0
    case 186:
        let result = LL_DMA2D_GetOutputSwapMode(&io)
        return result
    case 187:
        LL_DMA2D_SetLineOffsetMode(&io, args[0])
        return 0
    case 188:
        let result = LL_DMA2D_GetLineOffsetMode(&io)
        return result
    case 189:
        LL_DMA2D_SetLineOffset(&io, args[0])
        return 0
    case 190:
        let result = LL_DMA2D_GetLineOffset(&io)
        return result
    case 191:
        LL_DMA2D_SetNbrOfPixelsPerLines(&io, args[0])
        return 0
    case 192:
        let result = LL_DMA2D_GetNbrOfPixelsPerLines(&io)
        return result
    case 193:
        LL_DMA2D_SetNbrOfLines(&io, args[0])
        return 0
    case 194:
        let result = LL_DMA2D_GetNbrOfLines(&io)
        return result
    case 195:
        LL_DMA2D_SetOutputMemAddr(&io, args[0])
        return 0
    case 196:
        let result = LL_DMA2D_GetOutputMemAddr(&io)
        return result
    case 197:
        LL_DMA2D_SetOutputColor(&io, args[0])
        return 0
    case 198:
        let result = LL_DMA2D_GetOutputColor(&io)
        return result
    case 199:
        LL_DMA2D_SetLineWatermark(&io, args[0])
        return 0
    case 200:
        let result = LL_DMA2D_GetLineWatermark(&io)
        return result
    case 201:
        LL_DMA2D_SetDeadTime(&io, args[0])
        return 0
    case 202:
        let result = LL_DMA2D_GetDeadTime(&io)
        return result
    case 203:
        LL_DMA2D_EnableDeadTime(&io)
        return 0
    case 204:
        LL_DMA2D_DisableDeadTime(&io)
        return 0
    case 205:
        let result = LL_DMA2D_IsEnabledDeadTime(&io)
        return result
    case 206:
        LL_DMA2D_FGND_SetMemAddr(&io, args[0])
        return 0
    case 207:
        let result = LL_DMA2D_FGND_GetMemAddr(&io)
        return result
    case 208:
        LL_DMA2D_FGND_EnableCLUTLoad(&io)
        return 0
    case 209:
        let result = LL_DMA2D_FGND_IsEnabledCLUTLoad(&io)
        return result
    case 210:
        LL_DMA2D_FGND_SetColorMode(&io, args[0])
        return 0
    case 211:
        let result = LL_DMA2D_FGND_GetColorMode(&io)
        return result
    case 212:
        LL_DMA2D_FGND_SetAlphaMode(&io, args[0])
        return 0
    case 213:
        let result = LL_DMA2D_FGND_GetAlphaMode(&io)
        return result
    case 214:
        LL_DMA2D_FGND_SetAlpha(&io, args[0])
        return 0
    case 215:
        let result = LL_DMA2D_FGND_GetAlpha(&io)
        return result
    case 216:
        LL_DMA2D_FGND_SetRBSwapMode(&io, args[0])
        return 0
    case 217:
        let result = LL_DMA2D_FGND_GetRBSwapMode(&io)
        return result
    case 218:
        LL_DMA2D_FGND_SetAlphaInvMode(&io, args[0])
        return 0
    case 219:
        let result = LL_DMA2D_FGND_GetAlphaInvMode(&io)
        return result
    case 220:
        LL_DMA2D_FGND_SetLineOffset(&io, args[0])
        return 0
    case 221:
        let result = LL_DMA2D_FGND_GetLineOffset(&io)
        return result
    case 222:
        LL_DMA2D_FGND_SetColor(&io, args[0], args[1], args[2])
        return 0
    case 223:
        LL_DMA2D_FGND_SetRedColor(&io, args[0])
        return 0
    case 224:
        let result = LL_DMA2D_FGND_GetRedColor(&io)
        return result
    case 225:
        LL_DMA2D_FGND_SetGreenColor(&io, args[0])
        return 0
    case 226:
        let result = LL_DMA2D_FGND_GetGreenColor(&io)
        return result
    case 227:
        LL_DMA2D_FGND_SetBlueColor(&io, args[0])
        return 0
    case 228:
        let result = LL_DMA2D_FGND_GetBlueColor(&io)
        return result
    case 229:
        LL_DMA2D_FGND_SetCLUTMemAddr(&io, args[0])
        return 0
    case 230:
        let result = LL_DMA2D_FGND_GetCLUTMemAddr(&io)
        return result
    case 231:
        LL_DMA2D_FGND_SetCLUTSize(&io, args[0])
        return 0
    case 232:
        let result = LL_DMA2D_FGND_GetCLUTSize(&io)
        return result
    case 233:
        LL_DMA2D_FGND_SetCLUTColorMode(&io, args[0])
        return 0
    case 234:
        let result = LL_DMA2D_FGND_GetCLUTColorMode(&io)
        return result
    case 235:
        LL_DMA2D_FGND_SetChrSubSampling(&io, args[0])
        return 0
    case 236:
        let result = LL_DMA2D_FGND_GetChrSubSampling(&io)
        return result
    case 237:
        LL_DMA2D_BGND_SetMemAddr(&io, args[0])
        return 0
    case 238:
        let result = LL_DMA2D_BGND_GetMemAddr(&io)
        return result
    case 239:
        LL_DMA2D_BGND_EnableCLUTLoad(&io)
        return 0
    case 240:
        let result = LL_DMA2D_BGND_IsEnabledCLUTLoad(&io)
        return result
    case 241:
        LL_DMA2D_BGND_SetColorMode(&io, args[0])
        return 0
    case 242:
        let result = LL_DMA2D_BGND_GetColorMode(&io)
        return result
    case 243:
        LL_DMA2D_BGND_SetAlphaMode(&io, args[0])
        return 0
    case 244:
        let result = LL_DMA2D_BGND_GetAlphaMode(&io)
        return result
    case 245:
        LL_DMA2D_BGND_SetAlpha(&io, args[0])
        return 0
    case 246:
        let result = LL_DMA2D_BGND_GetAlpha(&io)
        return result
    case 247:
        LL_DMA2D_BGND_SetRBSwapMode(&io, args[0])
        return 0
    case 248:
        let result = LL_DMA2D_BGND_GetRBSwapMode(&io)
        return result
    case 249:
        LL_DMA2D_BGND_SetAlphaInvMode(&io, args[0])
        return 0
    case 250:
        let result = LL_DMA2D_BGND_GetAlphaInvMode(&io)
        return result
    case 251:
        LL_DMA2D_BGND_SetLineOffset(&io, args[0])
        return 0
    case 252:
        let result = LL_DMA2D_BGND_GetLineOffset(&io)
        return result
    case 253:
        LL_DMA2D_BGND_SetColor(&io, args[0], args[1], args[2])
        return 0
    case 254:
        LL_DMA2D_BGND_SetRedColor(&io, args[0])
        return 0
    case 255:
        let result = LL_DMA2D_BGND_GetRedColor(&io)
        return result
    case 256:
        LL_DMA2D_BGND_SetGreenColor(&io, args[0])
        return 0
    case 257:
        let result = LL_DMA2D_BGND_GetGreenColor(&io)
        return result
    case 258:
        LL_DMA2D_BGND_SetBlueColor(&io, args[0])
        return 0
    case 259:
        let result = LL_DMA2D_BGND_GetBlueColor(&io)
        return result
    case 260:
        LL_DMA2D_BGND_SetCLUTMemAddr(&io, args[0])
        return 0
    case 261:
        let result = LL_DMA2D_BGND_GetCLUTMemAddr(&io)
        return result
    case 262:
        LL_DMA2D_BGND_SetCLUTSize(&io, args[0])
        return 0
    case 263:
        let result = LL_DMA2D_BGND_GetCLUTSize(&io)
        return result
    case 264:
        LL_DMA2D_BGND_SetCLUTColorMode(&io, args[0])
        return 0
    case 265:
        let result = LL_DMA2D_BGND_GetCLUTColorMode(&io)
        return result
    case 266:
        let result = LL_DMA2D_IsActiveFlag_CE(&io)
        return result
    case 267:
        let result = LL_DMA2D_IsActiveFlag_CTC(&io)
        return result
    case 268:
        let result = LL_DMA2D_IsActiveFlag_CAE(&io)
        return result
    case 269:
        let result = LL_DMA2D_IsActiveFlag_TW(&io)
        return result
    case 270:
        let result = LL_DMA2D_IsActiveFlag_TC(&io)
        return result
    case 271:
        let result = LL_DMA2D_IsActiveFlag_TE(&io)
        return result
    case 272:
        LL_DMA2D_ClearFlag_CE(&io)
        return 0
    case 273:
        LL_DMA2D_ClearFlag_CTC(&io)
        return 0
    case 274:
        LL_DMA2D_ClearFlag_CAE(&io)
        return 0
    case 275:
        LL_DMA2D_ClearFlag_TW(&io)
        return 0
    case 276:
        LL_DMA2D_ClearFlag_TC(&io)
        return 0
    case 277:
        LL_DMA2D_ClearFlag_TE(&io)
        return 0
    case 278:
        LL_DMA2D_EnableIT_CE(&io)
        return 0
    case 279:
        LL_DMA2D_EnableIT_CTC(&io)
        return 0
    case 280:
        LL_DMA2D_EnableIT_CAE(&io)
        return 0
    case 281:
        LL_DMA2D_EnableIT_TW(&io)
        return 0
    case 282:
        LL_DMA2D_EnableIT_TC(&io)
        return 0
    case 283:
        LL_DMA2D_EnableIT_TE(&io)
        return 0
    case 284:
        LL_DMA2D_DisableIT_CE(&io)
        return 0
    case 285:
        LL_DMA2D_DisableIT_CTC(&io)
        return 0
    case 286:
        LL_DMA2D_DisableIT_CAE(&io)
        return 0
    case 287:
        LL_DMA2D_DisableIT_TW(&io)
        return 0
    case 288:
        LL_DMA2D_DisableIT_TC(&io)
        return 0
    case 289:
        LL_DMA2D_DisableIT_TE(&io)
        return 0
    case 290:
        let result = LL_DMA2D_IsEnabledIT_CE(&io)
        return result
    case 291:
        let result = LL_DMA2D_IsEnabledIT_CTC(&io)
        return result
    case 292:
        let result = LL_DMA2D_IsEnabledIT_CAE(&io)
        return result
    case 293:
        let result = LL_DMA2D_IsEnabledIT_TW(&io)
        return result
    case 294:
        let result = LL_DMA2D_IsEnabledIT_TC(&io)
        return result
    case 295:
        let result = LL_DMA2D_IsEnabledIT_TE(&io)
        return result
    case 296:
        let result = LL_DMA2D_DeInit(&io, isKnownInstance: io.controllerID != 2).rawValue
        return result
    case 297:
        var v1 = LL_DMA2D_InitTypeDef(Mode: args[0], ColorMode: args[1], OutputBlue: args[2], OutputGreen: args[3], OutputRed: args[4], OutputAlpha: args[5], OutputMemoryAddress: args[6], OutputSwapMode: args[7], LineOffsetMode: args[8], LineOffset: args[9], NbrOfLines: args[10], NbrOfPixelsPerLines: args[11], AlphaInversionMode: args[12], RBSwapMode: args[13])
        let result = LL_DMA2D_Init(&io, &v1).rawValue
        io.cells[3500] = v1.Mode
        io.cells[3501] = v1.ColorMode
        io.cells[3502] = v1.OutputBlue
        io.cells[3503] = v1.OutputGreen
        io.cells[3504] = v1.OutputRed
        io.cells[3505] = v1.OutputAlpha
        io.cells[3506] = v1.OutputMemoryAddress
        io.cells[3507] = v1.OutputSwapMode
        io.cells[3508] = v1.LineOffsetMode
        io.cells[3509] = v1.LineOffset
        io.cells[3510] = v1.NbrOfLines
        io.cells[3511] = v1.NbrOfPixelsPerLines
        io.cells[3512] = v1.AlphaInversionMode
        io.cells[3513] = v1.RBSwapMode
        return result
    case 298:
        var v0 = LL_DMA2D_InitTypeDef(Mode: args[0], ColorMode: args[1], OutputBlue: args[2], OutputGreen: args[3], OutputRed: args[4], OutputAlpha: args[5], OutputMemoryAddress: args[6], OutputSwapMode: args[7], LineOffsetMode: args[8], LineOffset: args[9], NbrOfLines: args[10], NbrOfPixelsPerLines: args[11], AlphaInversionMode: args[12], RBSwapMode: args[13])
        LL_DMA2D_StructInit(&v0)
        io.cells[3500] = v0.Mode
        io.cells[3501] = v0.ColorMode
        io.cells[3502] = v0.OutputBlue
        io.cells[3503] = v0.OutputGreen
        io.cells[3504] = v0.OutputRed
        io.cells[3505] = v0.OutputAlpha
        io.cells[3506] = v0.OutputMemoryAddress
        io.cells[3507] = v0.OutputSwapMode
        io.cells[3508] = v0.LineOffsetMode
        io.cells[3509] = v0.LineOffset
        io.cells[3510] = v0.NbrOfLines
        io.cells[3511] = v0.NbrOfPixelsPerLines
        io.cells[3512] = v0.AlphaInversionMode
        io.cells[3513] = v0.RBSwapMode
        return 0
    case 299:
        var v1 = LL_DMA2D_LayerCfgTypeDef(MemoryAddress: args[0], LineOffset: args[1], ColorMode: args[2], CLUTColorMode: args[3], CLUTSize: args[4], AlphaMode: args[5], Alpha: args[6], Blue: args[7], Green: args[8], Red: args[9], CLUTMemoryAddress: args[10], AlphaInversionMode: args[11], RBSwapMode: args[12], ChromaSubSampling: args[13])
        LL_DMA2D_ConfigLayer(&io, &v1, args[14])
        io.cells[3500] = v1.MemoryAddress
        io.cells[3501] = v1.LineOffset
        io.cells[3502] = v1.ColorMode
        io.cells[3503] = v1.CLUTColorMode
        io.cells[3504] = v1.CLUTSize
        io.cells[3505] = v1.AlphaMode
        io.cells[3506] = v1.Alpha
        io.cells[3507] = v1.Blue
        io.cells[3508] = v1.Green
        io.cells[3509] = v1.Red
        io.cells[3510] = v1.CLUTMemoryAddress
        io.cells[3511] = v1.AlphaInversionMode
        io.cells[3512] = v1.RBSwapMode
        io.cells[3513] = v1.ChromaSubSampling
        return 0
    case 300:
        var v0 = LL_DMA2D_LayerCfgTypeDef(MemoryAddress: args[0], LineOffset: args[1], ColorMode: args[2], CLUTColorMode: args[3], CLUTSize: args[4], AlphaMode: args[5], Alpha: args[6], Blue: args[7], Green: args[8], Red: args[9], CLUTMemoryAddress: args[10], AlphaInversionMode: args[11], RBSwapMode: args[12], ChromaSubSampling: args[13])
        LL_DMA2D_LayerCfgStructInit(&v0)
        io.cells[3500] = v0.MemoryAddress
        io.cells[3501] = v0.LineOffset
        io.cells[3502] = v0.ColorMode
        io.cells[3503] = v0.CLUTColorMode
        io.cells[3504] = v0.CLUTSize
        io.cells[3505] = v0.AlphaMode
        io.cells[3506] = v0.Alpha
        io.cells[3507] = v0.Blue
        io.cells[3508] = v0.Green
        io.cells[3509] = v0.Red
        io.cells[3510] = v0.CLUTMemoryAddress
        io.cells[3511] = v0.AlphaInversionMode
        io.cells[3512] = v0.RBSwapMode
        io.cells[3513] = v0.ChromaSubSampling
        return 0
    case 301:
        var v1 = LL_DMA2D_ColorTypeDef(ColorMode: args[0], OutputBlue: args[1], OutputGreen: args[2], OutputRed: args[3], OutputAlpha: args[4])
        LL_DMA2D_ConfigOutputColor(&io, &v1)
        io.cells[3500] = v1.ColorMode
        io.cells[3501] = v1.OutputBlue
        io.cells[3502] = v1.OutputGreen
        io.cells[3503] = v1.OutputRed
        io.cells[3504] = v1.OutputAlpha
        return 0
    case 302:
        let result = LL_DMA2D_GetOutputBlueColor(&io, args[0])
        return result
    case 303:
        let result = LL_DMA2D_GetOutputGreenColor(&io, args[0])
        return result
    case 304:
        let result = LL_DMA2D_GetOutputRedColor(&io, args[0])
        return result
    case 305:
        let result = LL_DMA2D_GetOutputAlphaColor(&io, args[0])
        return result
    case 306:
        LL_DMA2D_ConfigSize(&io, args[0], args[1])
        return 0
    case 307: return LL_DMA_GET_INSTANCE(args[0])
    case 308: return LL_DMA_GET_CHANNEL(args[0])
    case 309: return LL_DMA_GET_CHANNEL_INSTANCE(args[0], args[1])
    case 310: LL_DMA_WriteReg(&io, .ctr1, args[0], channel: 0); return LL_DMA_ReadReg(&io, .ctr1, channel: 0)
    case 311: LL_DMA2D_WriteReg(&io, .fgpfccr, args[0]); return LL_DMA2D_ReadReg(&io, .fgpfccr)
    default: preconditionFailure("Unknown operation")
    }
}
final class LLDMADifferentialTests: XCTestCase {
    private func compare(_ op: Int, _ args: [UInt32], seed: UInt32 = 0, salt: UInt32 = 0,
                         controller: UInt32 = 0, patch: [(Int, UInt32)] = [],
                         file: StaticString = #filePath, line: UInt = #line) {
        let c = CL51_Create()!
        defer { CL51_Destroy(c) }
        CL51_Reset(c, seed, salt, controller)
        var io = LLDMAImage(seed: seed, salt: salt, controller: controller)
        for (index, value) in patch { CL51_GetCells(c)![index] = value; io.cells[index] = value }
        let cr = CL51_Run(c, UInt32(op), args)
        let sr = runLLDMA(op, &io, args)
        let context = "op=\(op) args=\(args) seed=\(seed) salt=\(salt) controller=\(controller)"
        XCTAssertEqual(sr, cr, context, file: file, line: line)
        let cells = UnsafeBufferPointer(start: CL51_GetCells(c), count: 4096)
        for index in cells.indices where cells[index] != io.cells[index] {
            XCTFail("\(context) cell \(index): Swift \(io.cells[index]), C \(cells[index])", file: file, line: line)
        }
        let trace = UnsafeBufferPointer(start: CL51_GetTrace(c), count: Int(CL51_GetTraceCount(c)))
        XCTAssertEqual(io.trace, trace.map { .init(index: $0.index, value: $0.value, kind: $0.kind) }, context, file: file, line: line)
    }
    func testEveryDMAInlineFunctionOnBothControllersAndEveryChannel() {
        for controller: UInt32 in 0...1 {
            for channel: UInt32 in 0..<16 {
                for op in 0..<160 {
                    for sample: UInt32 in 0..<8 {
                        let seed = sample &* 0x9E3779B9
                        var args = (0..<8).map { seed ^ (UInt32($0) &* 0x10204081) }
                        args[0] = channel
                        compare(op, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x10204081, controller: controller)
                    }
                }
            }
        }
    }
    func testEveryDMA2DInlineFunction() {
        for op in 170..<296 {
            for sample: UInt32 in 0..<64 {
                let seed = sample &* 0x9E3779B9
                let args = (0..<8).map { seed ^ (UInt32($0) &* 0x10204081) }
                compare(op, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x10204081)
            }
        }
    }
    func testEverySourceFunctionWithChangingReads() {
        for op in Array(160..<170) + Array(296..<307) {
            for sample: UInt32 in 0..<64 {
                let seed = sample &* 0x9E3779B9
                var args = (0..<64).map { seed ^ (UInt32($0) &* 0x10204081) }
                if op == 160 { args[0] = sample % 16 }
                if op == 161 { args[0] = sample % 16 }
                if op == 164 { args[0] = sample % 16 }
                if op == 165 { args[0] = sample % 16 }
                if op == 167 { args[35] = 0 }
                if op == 168 { args[0] = 0 }
                if op == 168 { args[1] = sample % 8 }
                if op == 168 { args[2] = 32 }
                if op == 168 { args[3] = sample % 8 }
                if op == 169 { args[0] = 0 }
                if op == 169 { args[1] = sample % 8 }
                compare(op, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x10204081, controller: sample % 2)
            }
        }
        compare(160, [16], controller: 0)
        compare(160, [16], controller: 1)
        compare(164, [16], controller: 0)
        compare(164, [16], controller: 1)
        compare(296, [], controller: 2)
    }
    func testDMA2DColorModesBusyChecksAndBothLayers() {
        for mode: UInt32 in 0...6 {
            for sample: UInt32 in 0..<32 {
                let seed = sample &* 0x9E3779B9
                compare(301, [mode, sample, sample * 3, sample * 7, sample * 11], seed: seed)
                for op in 302...305 { compare(op, [mode], seed: seed, salt: 0x10204081) }
                var args = (0..<64).map { seed ^ (UInt32($0) &* 0x10204081) }
                args[1] = mode
                for busy: UInt32 in 0..<8 {
                    compare(297, args, seed: seed, patch: [(2048, busy & 1), (2055, (busy & 2) << 4), (2057, (busy & 4) << 3)])
                }
                args[2] = mode; args[14] = sample % 3
                compare(299, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x10204081)
            }
        }
    }
    func testChannelDisableRequestsSuspendAndReset() {
        var io = LLDMAImage(seed: 0, salt: 0, controller: 0)
        let index = io.index(.ccr, 15)
        io.cells[index] = 1
        LL_DMA_DisableChannel(&io, 15)
        XCTAssertEqual(io.cells[index], 7)
        XCTAssertEqual(io.trace.map(\.kind), [0, 1])
    }
    func testNodeWithoutUpdatesWritesOnlyItsNullLink() {
        let io = LLDMAImage(seed: 0, salt: 0, controller: 0)
        let node = LL_DMA_LinkNodeTypeDef(memory: io, address: 0x24010000)
        let before = Array(io.cells[3072..<3080])
        var config = LL_DMA_InitNodeTypeDef()
        LL_DMA_NodeStructInit(&config)
        config.UpdateRegisters = 0
        XCTAssertEqual(LL_DMA_CreateLinkNode(config, node), LLErrorStatus.success.rawValue)
        XCTAssertEqual(io.cells[3072], 0)
        XCTAssertEqual(Array(io.cells[3073..<3080]), Array(before[1..<8]))
        XCTAssertEqual(io.trace, [.init(index: 3072, value: 0, kind: 1)])
    }
    func testMemoryAndPeripheralRequestTriggerBranches() {
        let directions = [LL_DMA_DIRECTION_PERIPH_TO_MEMORY, LL_DMA_DIRECTION_MEMORY_TO_PERIPH, LL_DMA_DIRECTION_MEMORY_TO_MEMORY]
        let polarities = [LL_DMA_TRIG_POLARITY_MASKED, LL_DMA_TRIG_POLARITY_RISING, LL_DMA_TRIG_POLARITY_FALLING]
        for direction in directions {
            for polarity in polarities {
                for controller: UInt32 in 0...1 {
                    for channel: UInt32 in 0..<16 {
                        var args = (0..<64).map { UInt32($0) &* 0x10204081 }
                        args[0] = channel; args[3] = direction; args[16] = polarity
                        compare(161, args, seed: 0xA55A5AA5, salt: 0x10204081, controller: controller)
                    }
                }
                for nodeType in [LL_DMA_GPDMA_LINEAR_NODE, LL_DMA_GPDMA_2D_NODE, LL_DMA_HPDMA_LINEAR_NODE, LL_DMA_HPDMA_2D_NODE] {
                    var args = (0..<64).map { UInt32($0) &* 0x10204081 }
                    args[18] = direction; args[14] = polarity; args[33] = 0xFE010000; args[34] = nodeType; args[35] = 0
                    compare(167, args, seed: 0xA55A5AA5, salt: 0x10204081)
                }
            }
        }
    }

    func testEveryLinkedNodeUpdateMaskAndType() {
        let nodeTypes = [LL_DMA_HPDMA_2D_NODE, LL_DMA_GPDMA_2D_NODE, LL_DMA_HPDMA_LINEAR_NODE, LL_DMA_GPDMA_LINEAR_NODE]
        let bits: [UInt32] = [LL_DMA_UPDATE_CTR1, LL_DMA_UPDATE_CTR2, LL_DMA_UPDATE_CBR1, LL_DMA_UPDATE_CSAR,
                             LL_DMA_UPDATE_CDAR, LL_DMA_UPDATE_CTR3, LL_DMA_UPDATE_CBR2, LL_DMA_UPDATE_CLLR]
        for nodeType in nodeTypes {
            for mask: UInt32 in 0..<256 {
                for salt: UInt32 in [0, 0x10204081] {
                    var args = (0..<64).map { UInt32($0) &* 0x9E3779B9 }
                    var update: UInt32 = 0
                    for i in 0..<8 where mask & (1 << i) != 0 { update |= bits[i] }
                    args[34] = nodeType; args[33] = update; args[35] = 0
                    compare(167, args, seed: mask, salt: salt)
                }
            }
        }
    }
    func testLinkedNodeAliasingAndEveryLinkSlot() {
        for oldIndex: UInt32 in 0..<8 {
            for newIndex: UInt32 in 0..<8 {
                for offset: UInt32 in [0, 32] {
                    for salt: UInt32 in [0, 0x10204081] {
                        compare(168, [0, oldIndex, offset, newIndex], seed: 0xA5A55A5A, salt: salt)
                    }
                }
            }
        }
    }
    func testPointerConversionFallbacksAndRawRegisterMacros() {
        let bases: [UInt32] = [0x40021000, 0x52000000, 0, .max]
        for base in bases {
            for channel: UInt32 in 0...17 {
                let address = base &+ 0x50 &+ channel &* 0x80
                for delta: UInt32 in [0, 1, 3, .max] {
                    compare(307, [address &+ delta]); compare(308, [address &+ delta])
                }
                compare(309, [base, channel])
            }
        }
        for sample: UInt32 in 0..<64 {
            compare(310, [sample &* 0x9E3779B9], salt: 0x10204081)
            compare(311, [sample &* 0x9E3779B9], salt: 0x10204081)
        }
    }
    func testEveryConstantAndChannelOffsetAgainstC() {
        XCTAssertEqual(LL_DMA_CHANNEL_0, CL51_Constant(0), "LL_DMA_CHANNEL_0")
        XCTAssertEqual(LL_DMA_CHANNEL_1, CL51_Constant(1), "LL_DMA_CHANNEL_1")
        XCTAssertEqual(LL_DMA_CHANNEL_2, CL51_Constant(2), "LL_DMA_CHANNEL_2")
        XCTAssertEqual(LL_DMA_CHANNEL_3, CL51_Constant(3), "LL_DMA_CHANNEL_3")
        XCTAssertEqual(LL_DMA_CHANNEL_4, CL51_Constant(4), "LL_DMA_CHANNEL_4")
        XCTAssertEqual(LL_DMA_CHANNEL_5, CL51_Constant(5), "LL_DMA_CHANNEL_5")
        XCTAssertEqual(LL_DMA_CHANNEL_6, CL51_Constant(6), "LL_DMA_CHANNEL_6")
        XCTAssertEqual(LL_DMA_CHANNEL_7, CL51_Constant(7), "LL_DMA_CHANNEL_7")
        XCTAssertEqual(LL_DMA_CHANNEL_8, CL51_Constant(8), "LL_DMA_CHANNEL_8")
        XCTAssertEqual(LL_DMA_CHANNEL_9, CL51_Constant(9), "LL_DMA_CHANNEL_9")
        XCTAssertEqual(LL_DMA_CHANNEL_10, CL51_Constant(10), "LL_DMA_CHANNEL_10")
        XCTAssertEqual(LL_DMA_CHANNEL_11, CL51_Constant(11), "LL_DMA_CHANNEL_11")
        XCTAssertEqual(LL_DMA_CHANNEL_12, CL51_Constant(12), "LL_DMA_CHANNEL_12")
        XCTAssertEqual(LL_DMA_CHANNEL_13, CL51_Constant(13), "LL_DMA_CHANNEL_13")
        XCTAssertEqual(LL_DMA_CHANNEL_14, CL51_Constant(14), "LL_DMA_CHANNEL_14")
        XCTAssertEqual(LL_DMA_CHANNEL_15, CL51_Constant(15), "LL_DMA_CHANNEL_15")
        XCTAssertEqual(LL_DMA_CHANNEL_ALL, CL51_Constant(16), "LL_DMA_CHANNEL_ALL")
        XCTAssertEqual(LL_DMA_CLLR_OFFSET0, CL51_Constant(17), "LL_DMA_CLLR_OFFSET0")
        XCTAssertEqual(LL_DMA_CLLR_OFFSET1, CL51_Constant(18), "LL_DMA_CLLR_OFFSET1")
        XCTAssertEqual(LL_DMA_CLLR_OFFSET2, CL51_Constant(19), "LL_DMA_CLLR_OFFSET2")
        XCTAssertEqual(LL_DMA_CLLR_OFFSET3, CL51_Constant(20), "LL_DMA_CLLR_OFFSET3")
        XCTAssertEqual(LL_DMA_CLLR_OFFSET4, CL51_Constant(21), "LL_DMA_CLLR_OFFSET4")
        XCTAssertEqual(LL_DMA_CLLR_OFFSET5, CL51_Constant(22), "LL_DMA_CLLR_OFFSET5")
        XCTAssertEqual(LL_DMA_CLLR_OFFSET6, CL51_Constant(23), "LL_DMA_CLLR_OFFSET6")
        XCTAssertEqual(LL_DMA_CLLR_OFFSET7, CL51_Constant(24), "LL_DMA_CLLR_OFFSET7")
        XCTAssertEqual(LL_DMA_LOW_PRIORITY_LOW_WEIGHT, CL51_Constant(25), "LL_DMA_LOW_PRIORITY_LOW_WEIGHT")
        XCTAssertEqual(LL_DMA_LOW_PRIORITY_MID_WEIGHT, CL51_Constant(26), "LL_DMA_LOW_PRIORITY_MID_WEIGHT")
        XCTAssertEqual(LL_DMA_LOW_PRIORITY_HIGH_WEIGHT, CL51_Constant(27), "LL_DMA_LOW_PRIORITY_HIGH_WEIGHT")
        XCTAssertEqual(LL_DMA_HIGH_PRIORITY, CL51_Constant(28), "LL_DMA_HIGH_PRIORITY")
        XCTAssertEqual(LL_DMA_LINK_ALLOCATED_PORT0, CL51_Constant(29), "LL_DMA_LINK_ALLOCATED_PORT0")
        XCTAssertEqual(LL_DMA_LINK_ALLOCATED_PORT1, CL51_Constant(30), "LL_DMA_LINK_ALLOCATED_PORT1")
        XCTAssertEqual(LL_DMA_LSM_FULL_EXECUTION, CL51_Constant(31), "LL_DMA_LSM_FULL_EXECUTION")
        XCTAssertEqual(LL_DMA_LSM_1LINK_EXECUTION, CL51_Constant(32), "LL_DMA_LSM_1LINK_EXECUTION")
        XCTAssertEqual(LL_DMA_DEST_WORD_PRESERVE, CL51_Constant(33), "LL_DMA_DEST_WORD_PRESERVE")
        XCTAssertEqual(LL_DMA_DEST_WORD_EXCHANGE, CL51_Constant(34), "LL_DMA_DEST_WORD_EXCHANGE")
        XCTAssertEqual(LL_DMA_DEST_HALFWORD_PRESERVE, CL51_Constant(35), "LL_DMA_DEST_HALFWORD_PRESERVE")
        XCTAssertEqual(LL_DMA_DEST_HALFWORD_EXCHANGE, CL51_Constant(36), "LL_DMA_DEST_HALFWORD_EXCHANGE")
        XCTAssertEqual(LL_DMA_DEST_BYTE_PRESERVE, CL51_Constant(37), "LL_DMA_DEST_BYTE_PRESERVE")
        XCTAssertEqual(LL_DMA_DEST_BYTE_EXCHANGE, CL51_Constant(38), "LL_DMA_DEST_BYTE_EXCHANGE")
        XCTAssertEqual(LL_DMA_SRC_BYTE_PRESERVE, CL51_Constant(39), "LL_DMA_SRC_BYTE_PRESERVE")
        XCTAssertEqual(LL_DMA_SRC_BYTE_EXCHANGE, CL51_Constant(40), "LL_DMA_SRC_BYTE_EXCHANGE")
        XCTAssertEqual(LL_DMA_SRC_ALLOCATED_PORT0, CL51_Constant(41), "LL_DMA_SRC_ALLOCATED_PORT0")
        XCTAssertEqual(LL_DMA_SRC_ALLOCATED_PORT1, CL51_Constant(42), "LL_DMA_SRC_ALLOCATED_PORT1")
        XCTAssertEqual(LL_DMA_DEST_ALLOCATED_PORT0, CL51_Constant(43), "LL_DMA_DEST_ALLOCATED_PORT0")
        XCTAssertEqual(LL_DMA_DEST_ALLOCATED_PORT1, CL51_Constant(44), "LL_DMA_DEST_ALLOCATED_PORT1")
        XCTAssertEqual(LL_DMA_DEST_FIXED, CL51_Constant(45), "LL_DMA_DEST_FIXED")
        XCTAssertEqual(LL_DMA_DEST_INCREMENT, CL51_Constant(46), "LL_DMA_DEST_INCREMENT")
        XCTAssertEqual(LL_DMA_DEST_DATAWIDTH_BYTE, CL51_Constant(47), "LL_DMA_DEST_DATAWIDTH_BYTE")
        XCTAssertEqual(LL_DMA_DEST_DATAWIDTH_HALFWORD, CL51_Constant(48), "LL_DMA_DEST_DATAWIDTH_HALFWORD")
        XCTAssertEqual(LL_DMA_DEST_DATAWIDTH_WORD, CL51_Constant(49), "LL_DMA_DEST_DATAWIDTH_WORD")
        XCTAssertEqual(LL_DMA_DEST_DATAWIDTH_DOUBLEWORD, CL51_Constant(50), "LL_DMA_DEST_DATAWIDTH_DOUBLEWORD")
        XCTAssertEqual(LL_DMA_DATA_ALIGN_ZEROPADD, CL51_Constant(51), "LL_DMA_DATA_ALIGN_ZEROPADD")
        XCTAssertEqual(LL_DMA_DATA_ALIGN_SIGNEXTPADD, CL51_Constant(52), "LL_DMA_DATA_ALIGN_SIGNEXTPADD")
        XCTAssertEqual(LL_DMA_DATA_PACK_UNPACK, CL51_Constant(53), "LL_DMA_DATA_PACK_UNPACK")
        XCTAssertEqual(LL_DMA_SRC_FIXED, CL51_Constant(54), "LL_DMA_SRC_FIXED")
        XCTAssertEqual(LL_DMA_SRC_INCREMENT, CL51_Constant(55), "LL_DMA_SRC_INCREMENT")
        XCTAssertEqual(LL_DMA_SRC_DATAWIDTH_BYTE, CL51_Constant(56), "LL_DMA_SRC_DATAWIDTH_BYTE")
        XCTAssertEqual(LL_DMA_SRC_DATAWIDTH_HALFWORD, CL51_Constant(57), "LL_DMA_SRC_DATAWIDTH_HALFWORD")
        XCTAssertEqual(LL_DMA_SRC_DATAWIDTH_WORD, CL51_Constant(58), "LL_DMA_SRC_DATAWIDTH_WORD")
        XCTAssertEqual(LL_DMA_SRC_DATAWIDTH_DOUBLEWORD, CL51_Constant(59), "LL_DMA_SRC_DATAWIDTH_DOUBLEWORD")
        XCTAssertEqual(LL_DMA_HWREQUEST_SINGLEBURST, CL51_Constant(60), "LL_DMA_HWREQUEST_SINGLEBURST")
        XCTAssertEqual(LL_DMA_HWREQUEST_BLK, CL51_Constant(61), "LL_DMA_HWREQUEST_BLK")
        XCTAssertEqual(LL_DMA_TCEM_BLK_TRANSFER, CL51_Constant(62), "LL_DMA_TCEM_BLK_TRANSFER")
        XCTAssertEqual(LL_DMA_TCEM_RPT_BLK_TRANSFER, CL51_Constant(63), "LL_DMA_TCEM_RPT_BLK_TRANSFER")
        XCTAssertEqual(LL_DMA_TCEM_EACH_LLITEM_TRANSFER, CL51_Constant(64), "LL_DMA_TCEM_EACH_LLITEM_TRANSFER")
        XCTAssertEqual(LL_DMA_TCEM_LAST_LLITEM_TRANSFER, CL51_Constant(65), "LL_DMA_TCEM_LAST_LLITEM_TRANSFER")
        XCTAssertEqual(LL_DMA_TRIG_POLARITY_MASKED, CL51_Constant(66), "LL_DMA_TRIG_POLARITY_MASKED")
        XCTAssertEqual(LL_DMA_TRIG_POLARITY_RISING, CL51_Constant(67), "LL_DMA_TRIG_POLARITY_RISING")
        XCTAssertEqual(LL_DMA_TRIG_POLARITY_FALLING, CL51_Constant(68), "LL_DMA_TRIG_POLARITY_FALLING")
        XCTAssertEqual(LL_DMA_TRIGM_BLK_TRANSFER, CL51_Constant(69), "LL_DMA_TRIGM_BLK_TRANSFER")
        XCTAssertEqual(LL_DMA_TRIGM_RPT_BLK_TRANSFER, CL51_Constant(70), "LL_DMA_TRIGM_RPT_BLK_TRANSFER")
        XCTAssertEqual(LL_DMA_TRIGM_LLI_LINK_TRANSFER, CL51_Constant(71), "LL_DMA_TRIGM_LLI_LINK_TRANSFER")
        XCTAssertEqual(LL_DMA_TRIGM_SINGLBURST_TRANSFER, CL51_Constant(72), "LL_DMA_TRIGM_SINGLBURST_TRANSFER")
        XCTAssertEqual(LL_DMA_DIRECTION_MEMORY_TO_MEMORY, CL51_Constant(73), "LL_DMA_DIRECTION_MEMORY_TO_MEMORY")
        XCTAssertEqual(LL_DMA_DIRECTION_PERIPH_TO_MEMORY, CL51_Constant(74), "LL_DMA_DIRECTION_PERIPH_TO_MEMORY")
        XCTAssertEqual(LL_DMA_DIRECTION_MEMORY_TO_PERIPH, CL51_Constant(75), "LL_DMA_DIRECTION_MEMORY_TO_PERIPH")
        XCTAssertEqual(LL_DMA_NORMAL, CL51_Constant(76), "LL_DMA_NORMAL")
        XCTAssertEqual(LL_DMA_PFCTRL, CL51_Constant(77), "LL_DMA_PFCTRL")
        XCTAssertEqual(LL_DMA_BLKRPT_SRC_ADDR_INCREMENT, CL51_Constant(78), "LL_DMA_BLKRPT_SRC_ADDR_INCREMENT")
        XCTAssertEqual(LL_DMA_BLKRPT_SRC_ADDR_DECREMENT, CL51_Constant(79), "LL_DMA_BLKRPT_SRC_ADDR_DECREMENT")
        XCTAssertEqual(LL_DMA_BLKRPT_DEST_ADDR_INCREMENT, CL51_Constant(80), "LL_DMA_BLKRPT_DEST_ADDR_INCREMENT")
        XCTAssertEqual(LL_DMA_BLKRPT_DEST_ADDR_DECREMENT, CL51_Constant(81), "LL_DMA_BLKRPT_DEST_ADDR_DECREMENT")
        XCTAssertEqual(LL_DMA_BURST_SRC_ADDR_INCREMENT, CL51_Constant(82), "LL_DMA_BURST_SRC_ADDR_INCREMENT")
        XCTAssertEqual(LL_DMA_BURST_SRC_ADDR_DECREMENT, CL51_Constant(83), "LL_DMA_BURST_SRC_ADDR_DECREMENT")
        XCTAssertEqual(LL_DMA_BURST_DEST_ADDR_INCREMENT, CL51_Constant(84), "LL_DMA_BURST_DEST_ADDR_INCREMENT")
        XCTAssertEqual(LL_DMA_BURST_DEST_ADDR_DECREMENT, CL51_Constant(85), "LL_DMA_BURST_DEST_ADDR_DECREMENT")
        XCTAssertEqual(LL_DMA_GPDMA_LINEAR_NODE, CL51_Constant(86), "LL_DMA_GPDMA_LINEAR_NODE")
        XCTAssertEqual(LL_DMA_GPDMA_2D_NODE, CL51_Constant(87), "LL_DMA_GPDMA_2D_NODE")
        XCTAssertEqual(LL_DMA_HPDMA_LINEAR_NODE, CL51_Constant(88), "LL_DMA_HPDMA_LINEAR_NODE")
        XCTAssertEqual(LL_DMA_HPDMA_2D_NODE, CL51_Constant(89), "LL_DMA_HPDMA_2D_NODE")
        XCTAssertEqual(LL_DMA_UPDATE_CTR1, CL51_Constant(90), "LL_DMA_UPDATE_CTR1")
        XCTAssertEqual(LL_DMA_UPDATE_CTR2, CL51_Constant(91), "LL_DMA_UPDATE_CTR2")
        XCTAssertEqual(LL_DMA_UPDATE_CBR1, CL51_Constant(92), "LL_DMA_UPDATE_CBR1")
        XCTAssertEqual(LL_DMA_UPDATE_CSAR, CL51_Constant(93), "LL_DMA_UPDATE_CSAR")
        XCTAssertEqual(LL_DMA_UPDATE_CDAR, CL51_Constant(94), "LL_DMA_UPDATE_CDAR")
        XCTAssertEqual(LL_DMA_UPDATE_CTR3, CL51_Constant(95), "LL_DMA_UPDATE_CTR3")
        XCTAssertEqual(LL_DMA_UPDATE_CBR2, CL51_Constant(96), "LL_DMA_UPDATE_CBR2")
        XCTAssertEqual(LL_DMA_UPDATE_CLLR, CL51_Constant(97), "LL_DMA_UPDATE_CLLR")
        XCTAssertEqual(LL_HPDMA1_REQUEST_JPEG_RX, CL51_Constant(98), "LL_HPDMA1_REQUEST_JPEG_RX")
        XCTAssertEqual(LL_HPDMA1_REQUEST_JPEG_TX, CL51_Constant(99), "LL_HPDMA1_REQUEST_JPEG_TX")
        XCTAssertEqual(LL_HPDMA1_REQUEST_XSPI1, CL51_Constant(100), "LL_HPDMA1_REQUEST_XSPI1")
        XCTAssertEqual(LL_HPDMA1_REQUEST_XSPI2, CL51_Constant(101), "LL_HPDMA1_REQUEST_XSPI2")
        XCTAssertEqual(LL_HPDMA1_REQUEST_SPI3_RX, CL51_Constant(102), "LL_HPDMA1_REQUEST_SPI3_RX")
        XCTAssertEqual(LL_HPDMA1_REQUEST_SPI3_TX, CL51_Constant(103), "LL_HPDMA1_REQUEST_SPI3_TX")
        XCTAssertEqual(LL_HPDMA1_REQUEST_SPI4_RX, CL51_Constant(104), "LL_HPDMA1_REQUEST_SPI4_RX")
        XCTAssertEqual(LL_HPDMA1_REQUEST_SPI4_TX, CL51_Constant(105), "LL_HPDMA1_REQUEST_SPI4_TX")
        XCTAssertEqual(LL_HPDMA1_REQUEST_ADC1, CL51_Constant(106), "LL_HPDMA1_REQUEST_ADC1")
        XCTAssertEqual(LL_HPDMA1_REQUEST_ADC2, CL51_Constant(107), "LL_HPDMA1_REQUEST_ADC2")
        XCTAssertEqual(LL_HPDMA1_REQUEST_ADF1_FLT0, CL51_Constant(108), "LL_HPDMA1_REQUEST_ADF1_FLT0")
        XCTAssertEqual(LL_HPDMA1_REQUEST_UART4_RX, CL51_Constant(109), "LL_HPDMA1_REQUEST_UART4_RX")
        XCTAssertEqual(LL_HPDMA1_REQUEST_UART4_TX, CL51_Constant(110), "LL_HPDMA1_REQUEST_UART4_TX")
        XCTAssertEqual(LL_HPDMA1_REQUEST_UART5_RX, CL51_Constant(111), "LL_HPDMA1_REQUEST_UART5_RX")
        XCTAssertEqual(LL_HPDMA1_REQUEST_UART5_TX, CL51_Constant(112), "LL_HPDMA1_REQUEST_UART5_TX")
        XCTAssertEqual(LL_HPDMA1_REQUEST_UART7_RX, CL51_Constant(113), "LL_HPDMA1_REQUEST_UART7_RX")
        XCTAssertEqual(LL_HPDMA1_REQUEST_UART7_TX, CL51_Constant(114), "LL_HPDMA1_REQUEST_UART7_TX")
        XCTAssertEqual(LL_HPDMA1_REQUEST_LPTIM2_IC1, CL51_Constant(115), "LL_HPDMA1_REQUEST_LPTIM2_IC1")
        XCTAssertEqual(LL_HPDMA1_REQUEST_LPTIM2_IC2, CL51_Constant(116), "LL_HPDMA1_REQUEST_LPTIM2_IC2")
        XCTAssertEqual(LL_HPDMA1_REQUEST_LPTIM2_UE, CL51_Constant(117), "LL_HPDMA1_REQUEST_LPTIM2_UE")
        XCTAssertEqual(LL_GPDMA1_REQUEST_ADC1, CL51_Constant(118), "LL_GPDMA1_REQUEST_ADC1")
        XCTAssertEqual(LL_GPDMA1_REQUEST_ADC2, CL51_Constant(119), "LL_GPDMA1_REQUEST_ADC2")
        XCTAssertEqual(LL_GPDMA1_REQUEST_CRYP_IN, CL51_Constant(120), "LL_GPDMA1_REQUEST_CRYP_IN")
        XCTAssertEqual(LL_GPDMA1_REQUEST_CRYP_OUT, CL51_Constant(121), "LL_GPDMA1_REQUEST_CRYP_OUT")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SAES_IN, CL51_Constant(122), "LL_GPDMA1_REQUEST_SAES_IN")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SAES_OUT, CL51_Constant(123), "LL_GPDMA1_REQUEST_SAES_OUT")
        XCTAssertEqual(LL_GPDMA1_REQUEST_HASH_IN, CL51_Constant(124), "LL_GPDMA1_REQUEST_HASH_IN")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM1_CH1, CL51_Constant(125), "LL_GPDMA1_REQUEST_TIM1_CH1")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM1_CH2, CL51_Constant(126), "LL_GPDMA1_REQUEST_TIM1_CH2")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM1_CH3, CL51_Constant(127), "LL_GPDMA1_REQUEST_TIM1_CH3")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM1_CH4, CL51_Constant(128), "LL_GPDMA1_REQUEST_TIM1_CH4")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM1_UP, CL51_Constant(129), "LL_GPDMA1_REQUEST_TIM1_UP")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM1_TRIG, CL51_Constant(130), "LL_GPDMA1_REQUEST_TIM1_TRIG")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM1_COM, CL51_Constant(131), "LL_GPDMA1_REQUEST_TIM1_COM")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM2_CH1, CL51_Constant(132), "LL_GPDMA1_REQUEST_TIM2_CH1")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM2_CH2, CL51_Constant(133), "LL_GPDMA1_REQUEST_TIM2_CH2")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM2_CH3, CL51_Constant(134), "LL_GPDMA1_REQUEST_TIM2_CH3")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM2_CH4, CL51_Constant(135), "LL_GPDMA1_REQUEST_TIM2_CH4")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM2_UP, CL51_Constant(136), "LL_GPDMA1_REQUEST_TIM2_UP")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM2_TRIG, CL51_Constant(137), "LL_GPDMA1_REQUEST_TIM2_TRIG")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM3_CH1, CL51_Constant(138), "LL_GPDMA1_REQUEST_TIM3_CH1")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM3_CH2, CL51_Constant(139), "LL_GPDMA1_REQUEST_TIM3_CH2")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM3_CH3, CL51_Constant(140), "LL_GPDMA1_REQUEST_TIM3_CH3")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM3_CH4, CL51_Constant(141), "LL_GPDMA1_REQUEST_TIM3_CH4")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM3_UP, CL51_Constant(142), "LL_GPDMA1_REQUEST_TIM3_UP")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM3_TRIG, CL51_Constant(143), "LL_GPDMA1_REQUEST_TIM3_TRIG")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM4_CH1, CL51_Constant(144), "LL_GPDMA1_REQUEST_TIM4_CH1")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM4_CH2, CL51_Constant(145), "LL_GPDMA1_REQUEST_TIM4_CH2")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM4_CH3, CL51_Constant(146), "LL_GPDMA1_REQUEST_TIM4_CH3")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM4_CH4, CL51_Constant(147), "LL_GPDMA1_REQUEST_TIM4_CH4")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM4_UP, CL51_Constant(148), "LL_GPDMA1_REQUEST_TIM4_UP")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM4_TRIG, CL51_Constant(149), "LL_GPDMA1_REQUEST_TIM4_TRIG")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM5_CH1, CL51_Constant(150), "LL_GPDMA1_REQUEST_TIM5_CH1")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM5_CH2, CL51_Constant(151), "LL_GPDMA1_REQUEST_TIM5_CH2")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM5_CH3, CL51_Constant(152), "LL_GPDMA1_REQUEST_TIM5_CH3")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM5_CH4, CL51_Constant(153), "LL_GPDMA1_REQUEST_TIM5_CH4")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM5_UP, CL51_Constant(154), "LL_GPDMA1_REQUEST_TIM5_UP")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM5_TRIG, CL51_Constant(155), "LL_GPDMA1_REQUEST_TIM5_TRIG")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM6_UP, CL51_Constant(156), "LL_GPDMA1_REQUEST_TIM6_UP")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM7_UP, CL51_Constant(157), "LL_GPDMA1_REQUEST_TIM7_UP")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM15_CH1, CL51_Constant(158), "LL_GPDMA1_REQUEST_TIM15_CH1")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM15_CH2, CL51_Constant(159), "LL_GPDMA1_REQUEST_TIM15_CH2")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM15_UP, CL51_Constant(160), "LL_GPDMA1_REQUEST_TIM15_UP")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM15_TRIG, CL51_Constant(161), "LL_GPDMA1_REQUEST_TIM15_TRIG")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM15_COM, CL51_Constant(162), "LL_GPDMA1_REQUEST_TIM15_COM")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM16_CH1, CL51_Constant(163), "LL_GPDMA1_REQUEST_TIM16_CH1")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM16_UP, CL51_Constant(164), "LL_GPDMA1_REQUEST_TIM16_UP")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM16_COM, CL51_Constant(165), "LL_GPDMA1_REQUEST_TIM16_COM")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM17_CH1, CL51_Constant(166), "LL_GPDMA1_REQUEST_TIM17_CH1")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM17_UP, CL51_Constant(167), "LL_GPDMA1_REQUEST_TIM17_UP")
        XCTAssertEqual(LL_GPDMA1_REQUEST_TIM17_COM, CL51_Constant(168), "LL_GPDMA1_REQUEST_TIM17_COM")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPI1_RX, CL51_Constant(169), "LL_GPDMA1_REQUEST_SPI1_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPI1_TX, CL51_Constant(170), "LL_GPDMA1_REQUEST_SPI1_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPI2_RX, CL51_Constant(171), "LL_GPDMA1_REQUEST_SPI2_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPI2_TX, CL51_Constant(172), "LL_GPDMA1_REQUEST_SPI2_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPI3_RX, CL51_Constant(173), "LL_GPDMA1_REQUEST_SPI3_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPI3_TX, CL51_Constant(174), "LL_GPDMA1_REQUEST_SPI3_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPI4_RX, CL51_Constant(175), "LL_GPDMA1_REQUEST_SPI4_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPI4_TX, CL51_Constant(176), "LL_GPDMA1_REQUEST_SPI4_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPI5_RX, CL51_Constant(177), "LL_GPDMA1_REQUEST_SPI5_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPI5_TX, CL51_Constant(178), "LL_GPDMA1_REQUEST_SPI5_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPI6_RX, CL51_Constant(179), "LL_GPDMA1_REQUEST_SPI6_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPI6_TX, CL51_Constant(180), "LL_GPDMA1_REQUEST_SPI6_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SAI1_A, CL51_Constant(181), "LL_GPDMA1_REQUEST_SAI1_A")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SAI1_B, CL51_Constant(182), "LL_GPDMA1_REQUEST_SAI1_B")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SAI2_A, CL51_Constant(183), "LL_GPDMA1_REQUEST_SAI2_A")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SAI2_B, CL51_Constant(184), "LL_GPDMA1_REQUEST_SAI2_B")
        XCTAssertEqual(LL_GPDMA1_REQUEST_I2C1_RX, CL51_Constant(185), "LL_GPDMA1_REQUEST_I2C1_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_I2C1_TX, CL51_Constant(186), "LL_GPDMA1_REQUEST_I2C1_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_I2C2_RX, CL51_Constant(187), "LL_GPDMA1_REQUEST_I2C2_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_I2C2_TX, CL51_Constant(188), "LL_GPDMA1_REQUEST_I2C2_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_I2C3_RX, CL51_Constant(189), "LL_GPDMA1_REQUEST_I2C3_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_I2C3_TX, CL51_Constant(190), "LL_GPDMA1_REQUEST_I2C3_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_USART1_RX, CL51_Constant(191), "LL_GPDMA1_REQUEST_USART1_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_USART1_TX, CL51_Constant(192), "LL_GPDMA1_REQUEST_USART1_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_USART2_RX, CL51_Constant(193), "LL_GPDMA1_REQUEST_USART2_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_USART2_TX, CL51_Constant(194), "LL_GPDMA1_REQUEST_USART2_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_USART3_RX, CL51_Constant(195), "LL_GPDMA1_REQUEST_USART3_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_USART3_TX, CL51_Constant(196), "LL_GPDMA1_REQUEST_USART3_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_UART4_RX, CL51_Constant(197), "LL_GPDMA1_REQUEST_UART4_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_UART4_TX, CL51_Constant(198), "LL_GPDMA1_REQUEST_UART4_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_UART5_RX, CL51_Constant(199), "LL_GPDMA1_REQUEST_UART5_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_UART5_TX, CL51_Constant(200), "LL_GPDMA1_REQUEST_UART5_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_UART7_RX, CL51_Constant(201), "LL_GPDMA1_REQUEST_UART7_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_UART7_TX, CL51_Constant(202), "LL_GPDMA1_REQUEST_UART7_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_UART8_RX, CL51_Constant(203), "LL_GPDMA1_REQUEST_UART8_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_UART8_TX, CL51_Constant(204), "LL_GPDMA1_REQUEST_UART8_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_CORDIC_READ, CL51_Constant(205), "LL_GPDMA1_REQUEST_CORDIC_READ")
        XCTAssertEqual(LL_GPDMA1_REQUEST_CORDIC_WRITE, CL51_Constant(206), "LL_GPDMA1_REQUEST_CORDIC_WRITE")
        XCTAssertEqual(LL_GPDMA1_REQUEST_LPTIM1_IC1, CL51_Constant(207), "LL_GPDMA1_REQUEST_LPTIM1_IC1")
        XCTAssertEqual(LL_GPDMA1_REQUEST_LPTIM1_IC2, CL51_Constant(208), "LL_GPDMA1_REQUEST_LPTIM1_IC2")
        XCTAssertEqual(LL_GPDMA1_REQUEST_LPTIM1_UE, CL51_Constant(209), "LL_GPDMA1_REQUEST_LPTIM1_UE")
        XCTAssertEqual(LL_GPDMA1_REQUEST_LPTIM2_IC1, CL51_Constant(210), "LL_GPDMA1_REQUEST_LPTIM2_IC1")
        XCTAssertEqual(LL_GPDMA1_REQUEST_LPTIM2_IC2, CL51_Constant(211), "LL_GPDMA1_REQUEST_LPTIM2_IC2")
        XCTAssertEqual(LL_GPDMA1_REQUEST_LPTIM2_UE, CL51_Constant(212), "LL_GPDMA1_REQUEST_LPTIM2_UE")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPDIF_RX_DT, CL51_Constant(213), "LL_GPDMA1_REQUEST_SPDIF_RX_DT")
        XCTAssertEqual(LL_GPDMA1_REQUEST_SPDIF_RX_CS, CL51_Constant(214), "LL_GPDMA1_REQUEST_SPDIF_RX_CS")
        XCTAssertEqual(LL_GPDMA1_REQUEST_ADF1_FLT0, CL51_Constant(215), "LL_GPDMA1_REQUEST_ADF1_FLT0")
        XCTAssertEqual(LL_GPDMA1_REQUEST_UCPD1_TX, CL51_Constant(216), "LL_GPDMA1_REQUEST_UCPD1_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_UCPD1_RX, CL51_Constant(217), "LL_GPDMA1_REQUEST_UCPD1_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_PSSI, CL51_Constant(218), "LL_GPDMA1_REQUEST_PSSI")
        XCTAssertEqual(LL_GPDMA1_REQUEST_LPUART1_RX, CL51_Constant(219), "LL_GPDMA1_REQUEST_LPUART1_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_LPUART1_TX, CL51_Constant(220), "LL_GPDMA1_REQUEST_LPUART1_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_LPTIM3_IC1, CL51_Constant(221), "LL_GPDMA1_REQUEST_LPTIM3_IC1")
        XCTAssertEqual(LL_GPDMA1_REQUEST_LPTIM3_IC2, CL51_Constant(222), "LL_GPDMA1_REQUEST_LPTIM3_IC2")
        XCTAssertEqual(LL_GPDMA1_REQUEST_LPTIM3_UE, CL51_Constant(223), "LL_GPDMA1_REQUEST_LPTIM3_UE")
        XCTAssertEqual(LL_GPDMA1_REQUEST_I3C1_RX, CL51_Constant(224), "LL_GPDMA1_REQUEST_I3C1_RX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_I3C1_TX, CL51_Constant(225), "LL_GPDMA1_REQUEST_I3C1_TX")
        XCTAssertEqual(LL_GPDMA1_REQUEST_I3C1_TC, CL51_Constant(226), "LL_GPDMA1_REQUEST_I3C1_TC")
        XCTAssertEqual(LL_GPDMA1_REQUEST_I3C1_RS, CL51_Constant(227), "LL_GPDMA1_REQUEST_I3C1_RS")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_DCMIPP_EVT_FRAMEEND, CL51_Constant(228), "LL_HPDMA1_TRIGGER_DCMIPP_EVT_FRAMEEND")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_DCMIPP_EVT_HSYNC, CL51_Constant(229), "LL_HPDMA1_TRIGGER_DCMIPP_EVT_HSYNC")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_DCMIPP_EVT_LINEEND, CL51_Constant(230), "LL_HPDMA1_TRIGGER_DCMIPP_EVT_LINEEND")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_DCMIPP_EVT_VSYNC, CL51_Constant(231), "LL_HPDMA1_TRIGGER_DCMIPP_EVT_VSYNC")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_DMA2D_CTC_FLAG, CL51_Constant(232), "LL_HPDMA1_TRIGGER_DMA2D_CTC_FLAG")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_DMA2D_TC_FLAG, CL51_Constant(233), "LL_HPDMA1_TRIGGER_DMA2D_TC_FLAG")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_DMA2D_TW_FLAG, CL51_Constant(234), "LL_HPDMA1_TRIGGER_DMA2D_TW_FLAG")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_JPEG_EOC_FLAG, CL51_Constant(235), "LL_HPDMA1_TRIGGER_JPEG_EOC_FLAG")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_JPEG_IFNF_FLAG, CL51_Constant(236), "LL_HPDMA1_TRIGGER_JPEG_IFNF_FLAG")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_JPEG_IFT_FLAG, CL51_Constant(237), "LL_HPDMA1_TRIGGER_JPEG_IFT_FLAG")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_JPEG_OFNE_FLAG, CL51_Constant(238), "LL_HPDMA1_TRIGGER_JPEG_OFNE_FLAG")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_JPEG_OFT_FLAG, CL51_Constant(239), "LL_HPDMA1_TRIGGER_JPEG_OFT_FLAG")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_LCD, CL51_Constant(240), "LL_HPDMA1_TRIGGER_LCD")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG0, CL51_Constant(241), "LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG0")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG1, CL51_Constant(242), "LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG1")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG2, CL51_Constant(243), "LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG2")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG3, CL51_Constant(244), "LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG3")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_4, CL51_Constant(245), "LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_4")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_3, CL51_Constant(246), "LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_3")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_2, CL51_Constant(247), "LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_2")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_1, CL51_Constant(248), "LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_1")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH0_TCF, CL51_Constant(249), "LL_HPDMA1_TRIGGER_GPDMA1_CH0_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH1_TCF, CL51_Constant(250), "LL_HPDMA1_TRIGGER_GPDMA1_CH1_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH2_TCF, CL51_Constant(251), "LL_HPDMA1_TRIGGER_GPDMA1_CH2_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH3_TCF, CL51_Constant(252), "LL_HPDMA1_TRIGGER_GPDMA1_CH3_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH4_TCF, CL51_Constant(253), "LL_HPDMA1_TRIGGER_GPDMA1_CH4_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH5_TCF, CL51_Constant(254), "LL_HPDMA1_TRIGGER_GPDMA1_CH5_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH6_TCF, CL51_Constant(255), "LL_HPDMA1_TRIGGER_GPDMA1_CH6_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH7_TCF, CL51_Constant(256), "LL_HPDMA1_TRIGGER_GPDMA1_CH7_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH8_TCF, CL51_Constant(257), "LL_HPDMA1_TRIGGER_GPDMA1_CH8_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH9_TCF, CL51_Constant(258), "LL_HPDMA1_TRIGGER_GPDMA1_CH9_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH10_TCF, CL51_Constant(259), "LL_HPDMA1_TRIGGER_GPDMA1_CH10_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH11_TCF, CL51_Constant(260), "LL_HPDMA1_TRIGGER_GPDMA1_CH11_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH12_TCF, CL51_Constant(261), "LL_HPDMA1_TRIGGER_GPDMA1_CH12_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH13_TCF, CL51_Constant(262), "LL_HPDMA1_TRIGGER_GPDMA1_CH13_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH14_TCF, CL51_Constant(263), "LL_HPDMA1_TRIGGER_GPDMA1_CH14_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_GPDMA1_CH15_TCF, CL51_Constant(264), "LL_HPDMA1_TRIGGER_GPDMA1_CH15_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH0_TCF, CL51_Constant(265), "LL_HPDMA1_TRIGGER_HPDMA1_CH0_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH1_TCF, CL51_Constant(266), "LL_HPDMA1_TRIGGER_HPDMA1_CH1_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH2_TCF, CL51_Constant(267), "LL_HPDMA1_TRIGGER_HPDMA1_CH2_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH3_TCF, CL51_Constant(268), "LL_HPDMA1_TRIGGER_HPDMA1_CH3_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH4_TCF, CL51_Constant(269), "LL_HPDMA1_TRIGGER_HPDMA1_CH4_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH5_TCF, CL51_Constant(270), "LL_HPDMA1_TRIGGER_HPDMA1_CH5_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH6_TCF, CL51_Constant(271), "LL_HPDMA1_TRIGGER_HPDMA1_CH6_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH7_TCF, CL51_Constant(272), "LL_HPDMA1_TRIGGER_HPDMA1_CH7_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH8_TCF, CL51_Constant(273), "LL_HPDMA1_TRIGGER_HPDMA1_CH8_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH9_TCF, CL51_Constant(274), "LL_HPDMA1_TRIGGER_HPDMA1_CH9_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH10_TCF, CL51_Constant(275), "LL_HPDMA1_TRIGGER_HPDMA1_CH10_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH11_TCF, CL51_Constant(276), "LL_HPDMA1_TRIGGER_HPDMA1_CH11_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH12_TCF, CL51_Constant(277), "LL_HPDMA1_TRIGGER_HPDMA1_CH12_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH13_TCF, CL51_Constant(278), "LL_HPDMA1_TRIGGER_HPDMA1_CH13_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH14_TCF, CL51_Constant(279), "LL_HPDMA1_TRIGGER_HPDMA1_CH14_TCF")
        XCTAssertEqual(LL_HPDMA1_TRIGGER_HPDMA1_CH15_TCF, CL51_Constant(280), "LL_HPDMA1_TRIGGER_HPDMA1_CH15_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH0_TCF, CL51_Constant(281), "LL_GPDMA1_TRIGGER_HPDMA1_CH0_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH1_TCF, CL51_Constant(282), "LL_GPDMA1_TRIGGER_HPDMA1_CH1_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH2_TCF, CL51_Constant(283), "LL_GPDMA1_TRIGGER_HPDMA1_CH2_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH3_TCF, CL51_Constant(284), "LL_GPDMA1_TRIGGER_HPDMA1_CH3_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH4_TCF, CL51_Constant(285), "LL_GPDMA1_TRIGGER_HPDMA1_CH4_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH5_TCF, CL51_Constant(286), "LL_GPDMA1_TRIGGER_HPDMA1_CH5_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH6_TCF, CL51_Constant(287), "LL_GPDMA1_TRIGGER_HPDMA1_CH6_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH7_TCF, CL51_Constant(288), "LL_GPDMA1_TRIGGER_HPDMA1_CH7_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH8_TCF, CL51_Constant(289), "LL_GPDMA1_TRIGGER_HPDMA1_CH8_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH9_TCF, CL51_Constant(290), "LL_GPDMA1_TRIGGER_HPDMA1_CH9_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH10_TCF, CL51_Constant(291), "LL_GPDMA1_TRIGGER_HPDMA1_CH10_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH11_TCF, CL51_Constant(292), "LL_GPDMA1_TRIGGER_HPDMA1_CH11_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH12_TCF, CL51_Constant(293), "LL_GPDMA1_TRIGGER_HPDMA1_CH12_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH13_TCF, CL51_Constant(294), "LL_GPDMA1_TRIGGER_HPDMA1_CH13_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH14_TCF, CL51_Constant(295), "LL_GPDMA1_TRIGGER_HPDMA1_CH14_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_HPDMA1_CH15_TCF, CL51_Constant(296), "LL_GPDMA1_TRIGGER_HPDMA1_CH15_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_LPTIM1_CH1, CL51_Constant(297), "LL_GPDMA1_TRIGGER_LPTIM1_CH1")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_LPTIM1_CH2, CL51_Constant(298), "LL_GPDMA1_TRIGGER_LPTIM1_CH2")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_LPTIM2_CH1, CL51_Constant(299), "LL_GPDMA1_TRIGGER_LPTIM2_CH1")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_LPTIM2_CH2, CL51_Constant(300), "LL_GPDMA1_TRIGGER_LPTIM2_CH2")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_LPTIM3_CH1, CL51_Constant(301), "LL_GPDMA1_TRIGGER_LPTIM3_CH1")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_LPTIM3_CH2, CL51_Constant(302), "LL_GPDMA1_TRIGGER_LPTIM3_CH2")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_LPTIM4_OUT, CL51_Constant(303), "LL_GPDMA1_TRIGGER_LPTIM4_OUT")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_LPTIM5_OUT, CL51_Constant(304), "LL_GPDMA1_TRIGGER_LPTIM5_OUT")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_EXTIT0_SYNC, CL51_Constant(305), "LL_GPDMA1_TRIGGER_EXTIT0_SYNC")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_RTC_WKUP, CL51_Constant(306), "LL_GPDMA1_TRIGGER_RTC_WKUP")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_LPUART1_IT_R_WUP_ASYNC, CL51_Constant(307), "LL_GPDMA1_TRIGGER_LPUART1_IT_R_WUP_ASYNC")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_LPUART1_IT_T_WUP_ASYNC, CL51_Constant(308), "LL_GPDMA1_TRIGGER_LPUART1_IT_T_WUP_ASYNC")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_SPI6_IT_OR_SPI6_AIT_SYNC, CL51_Constant(309), "LL_GPDMA1_TRIGGER_SPI6_IT_OR_SPI6_AIT_SYNC")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH0_TCF, CL51_Constant(310), "LL_GPDMA1_TRIGGER_GPDMA1_CH0_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH1_TCF, CL51_Constant(311), "LL_GPDMA1_TRIGGER_GPDMA1_CH1_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH2_TCF, CL51_Constant(312), "LL_GPDMA1_TRIGGER_GPDMA1_CH2_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH3_TCF, CL51_Constant(313), "LL_GPDMA1_TRIGGER_GPDMA1_CH3_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH4_TCF, CL51_Constant(314), "LL_GPDMA1_TRIGGER_GPDMA1_CH4_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH5_TCF, CL51_Constant(315), "LL_GPDMA1_TRIGGER_GPDMA1_CH5_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH6_TCF, CL51_Constant(316), "LL_GPDMA1_TRIGGER_GPDMA1_CH6_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH7_TCF, CL51_Constant(317), "LL_GPDMA1_TRIGGER_GPDMA1_CH7_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH8_TCF, CL51_Constant(318), "LL_GPDMA1_TRIGGER_GPDMA1_CH8_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH9_TCF, CL51_Constant(319), "LL_GPDMA1_TRIGGER_GPDMA1_CH9_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH10_TCF, CL51_Constant(320), "LL_GPDMA1_TRIGGER_GPDMA1_CH10_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH11_TCF, CL51_Constant(321), "LL_GPDMA1_TRIGGER_GPDMA1_CH11_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH12_TCF, CL51_Constant(322), "LL_GPDMA1_TRIGGER_GPDMA1_CH12_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH13_TCF, CL51_Constant(323), "LL_GPDMA1_TRIGGER_GPDMA1_CH13_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH14_TCF, CL51_Constant(324), "LL_GPDMA1_TRIGGER_GPDMA1_CH14_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_GPDMA1_CH15_TCF, CL51_Constant(325), "LL_GPDMA1_TRIGGER_GPDMA1_CH15_TCF")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_TIM1_TRGO, CL51_Constant(326), "LL_GPDMA1_TRIGGER_TIM1_TRGO")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_TIM1_TRGO2, CL51_Constant(327), "LL_GPDMA1_TRIGGER_TIM1_TRGO2")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_TIM2_TRGO, CL51_Constant(328), "LL_GPDMA1_TRIGGER_TIM2_TRGO")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_TIM3_TRGO, CL51_Constant(329), "LL_GPDMA1_TRIGGER_TIM3_TRGO")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_TIM4_TRGO, CL51_Constant(330), "LL_GPDMA1_TRIGGER_TIM4_TRGO")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_TIM5_TRGO, CL51_Constant(331), "LL_GPDMA1_TRIGGER_TIM5_TRGO")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_TIM6_TRGO, CL51_Constant(332), "LL_GPDMA1_TRIGGER_TIM6_TRGO")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_TIM7_TRGO, CL51_Constant(333), "LL_GPDMA1_TRIGGER_TIM7_TRGO")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_TIM9_TRGO, CL51_Constant(334), "LL_GPDMA1_TRIGGER_TIM9_TRGO")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_TIM12_TRGO, CL51_Constant(335), "LL_GPDMA1_TRIGGER_TIM12_TRGO")
        XCTAssertEqual(LL_GPDMA1_TRIGGER_TIM15_TRGO, CL51_Constant(336), "LL_GPDMA1_TRIGGER_TIM15_TRGO")
        XCTAssertEqual(LL_DMA2D_FLAG_CEIF, CL51_Constant(337), "LL_DMA2D_FLAG_CEIF")
        XCTAssertEqual(LL_DMA2D_FLAG_CTCIF, CL51_Constant(338), "LL_DMA2D_FLAG_CTCIF")
        XCTAssertEqual(LL_DMA2D_FLAG_CAEIF, CL51_Constant(339), "LL_DMA2D_FLAG_CAEIF")
        XCTAssertEqual(LL_DMA2D_FLAG_TWIF, CL51_Constant(340), "LL_DMA2D_FLAG_TWIF")
        XCTAssertEqual(LL_DMA2D_FLAG_TCIF, CL51_Constant(341), "LL_DMA2D_FLAG_TCIF")
        XCTAssertEqual(LL_DMA2D_FLAG_TEIF, CL51_Constant(342), "LL_DMA2D_FLAG_TEIF")
        XCTAssertEqual(LL_DMA2D_IT_CEIE, CL51_Constant(343), "LL_DMA2D_IT_CEIE")
        XCTAssertEqual(LL_DMA2D_IT_CTCIE, CL51_Constant(344), "LL_DMA2D_IT_CTCIE")
        XCTAssertEqual(LL_DMA2D_IT_CAEIE, CL51_Constant(345), "LL_DMA2D_IT_CAEIE")
        XCTAssertEqual(LL_DMA2D_IT_TWIE, CL51_Constant(346), "LL_DMA2D_IT_TWIE")
        XCTAssertEqual(LL_DMA2D_IT_TCIE, CL51_Constant(347), "LL_DMA2D_IT_TCIE")
        XCTAssertEqual(LL_DMA2D_IT_TEIE, CL51_Constant(348), "LL_DMA2D_IT_TEIE")
        XCTAssertEqual(LL_DMA2D_MODE_M2M, CL51_Constant(349), "LL_DMA2D_MODE_M2M")
        XCTAssertEqual(LL_DMA2D_MODE_M2M_PFC, CL51_Constant(350), "LL_DMA2D_MODE_M2M_PFC")
        XCTAssertEqual(LL_DMA2D_MODE_M2M_BLEND, CL51_Constant(351), "LL_DMA2D_MODE_M2M_BLEND")
        XCTAssertEqual(LL_DMA2D_MODE_R2M, CL51_Constant(352), "LL_DMA2D_MODE_R2M")
        XCTAssertEqual(LL_DMA2D_MODE_M2M_BLEND_FIXED_COLOR_FG, CL51_Constant(353), "LL_DMA2D_MODE_M2M_BLEND_FIXED_COLOR_FG")
        XCTAssertEqual(LL_DMA2D_MODE_M2M_BLEND_FIXED_COLOR_BG, CL51_Constant(354), "LL_DMA2D_MODE_M2M_BLEND_FIXED_COLOR_BG")
        XCTAssertEqual(LL_DMA2D_OUTPUT_MODE_ARGB8888, CL51_Constant(355), "LL_DMA2D_OUTPUT_MODE_ARGB8888")
        XCTAssertEqual(LL_DMA2D_OUTPUT_MODE_RGB888, CL51_Constant(356), "LL_DMA2D_OUTPUT_MODE_RGB888")
        XCTAssertEqual(LL_DMA2D_OUTPUT_MODE_RGB565, CL51_Constant(357), "LL_DMA2D_OUTPUT_MODE_RGB565")
        XCTAssertEqual(LL_DMA2D_OUTPUT_MODE_ARGB1555, CL51_Constant(358), "LL_DMA2D_OUTPUT_MODE_ARGB1555")
        XCTAssertEqual(LL_DMA2D_OUTPUT_MODE_ARGB4444, CL51_Constant(359), "LL_DMA2D_OUTPUT_MODE_ARGB4444")
        XCTAssertEqual(LL_DMA2D_INPUT_MODE_ARGB8888, CL51_Constant(360), "LL_DMA2D_INPUT_MODE_ARGB8888")
        XCTAssertEqual(LL_DMA2D_INPUT_MODE_RGB888, CL51_Constant(361), "LL_DMA2D_INPUT_MODE_RGB888")
        XCTAssertEqual(LL_DMA2D_INPUT_MODE_RGB565, CL51_Constant(362), "LL_DMA2D_INPUT_MODE_RGB565")
        XCTAssertEqual(LL_DMA2D_INPUT_MODE_ARGB1555, CL51_Constant(363), "LL_DMA2D_INPUT_MODE_ARGB1555")
        XCTAssertEqual(LL_DMA2D_INPUT_MODE_ARGB4444, CL51_Constant(364), "LL_DMA2D_INPUT_MODE_ARGB4444")
        XCTAssertEqual(LL_DMA2D_INPUT_MODE_L8, CL51_Constant(365), "LL_DMA2D_INPUT_MODE_L8")
        XCTAssertEqual(LL_DMA2D_INPUT_MODE_AL44, CL51_Constant(366), "LL_DMA2D_INPUT_MODE_AL44")
        XCTAssertEqual(LL_DMA2D_INPUT_MODE_AL88, CL51_Constant(367), "LL_DMA2D_INPUT_MODE_AL88")
        XCTAssertEqual(LL_DMA2D_INPUT_MODE_L4, CL51_Constant(368), "LL_DMA2D_INPUT_MODE_L4")
        XCTAssertEqual(LL_DMA2D_INPUT_MODE_A8, CL51_Constant(369), "LL_DMA2D_INPUT_MODE_A8")
        XCTAssertEqual(LL_DMA2D_INPUT_MODE_A4, CL51_Constant(370), "LL_DMA2D_INPUT_MODE_A4")
        XCTAssertEqual(LL_DMA2D_INPUT_MODE_YCBCR, CL51_Constant(371), "LL_DMA2D_INPUT_MODE_YCBCR")
        XCTAssertEqual(LL_DMA2D_ALPHA_MODE_NO_MODIF, CL51_Constant(372), "LL_DMA2D_ALPHA_MODE_NO_MODIF")
        XCTAssertEqual(LL_DMA2D_ALPHA_MODE_REPLACE, CL51_Constant(373), "LL_DMA2D_ALPHA_MODE_REPLACE")
        XCTAssertEqual(LL_DMA2D_ALPHA_MODE_COMBINE, CL51_Constant(374), "LL_DMA2D_ALPHA_MODE_COMBINE")
        XCTAssertEqual(LL_DMA2D_SWAP_MODE_REGULAR, CL51_Constant(375), "LL_DMA2D_SWAP_MODE_REGULAR")
        XCTAssertEqual(LL_DMA2D_SWAP_MODE_TWO_BY_TWO, CL51_Constant(376), "LL_DMA2D_SWAP_MODE_TWO_BY_TWO")
        XCTAssertEqual(LL_DMA2D_RB_MODE_REGULAR, CL51_Constant(377), "LL_DMA2D_RB_MODE_REGULAR")
        XCTAssertEqual(LL_DMA2D_RB_MODE_SWAP, CL51_Constant(378), "LL_DMA2D_RB_MODE_SWAP")
        XCTAssertEqual(LL_DMA2D_ALPHA_REGULAR, CL51_Constant(379), "LL_DMA2D_ALPHA_REGULAR")
        XCTAssertEqual(LL_DMA2D_ALPHA_INVERTED, CL51_Constant(380), "LL_DMA2D_ALPHA_INVERTED")
        XCTAssertEqual(LL_DMA2D_LINE_OFFSET_PIXELS, CL51_Constant(381), "LL_DMA2D_LINE_OFFSET_PIXELS")
        XCTAssertEqual(LL_DMA2D_LINE_OFFSET_BYTES, CL51_Constant(382), "LL_DMA2D_LINE_OFFSET_BYTES")
        XCTAssertEqual(LL_DMA2D_CLUT_COLOR_MODE_ARGB8888, CL51_Constant(383), "LL_DMA2D_CLUT_COLOR_MODE_ARGB8888")
        XCTAssertEqual(LL_DMA2D_CLUT_COLOR_MODE_RGB888, CL51_Constant(384), "LL_DMA2D_CLUT_COLOR_MODE_RGB888")
        XCTAssertEqual(LL_DMA2D_CSS_444, CL51_Constant(385), "LL_DMA2D_CSS_444")
        XCTAssertEqual(LL_DMA2D_CSS_422, CL51_Constant(386), "LL_DMA2D_CSS_422")
        XCTAssertEqual(LL_DMA2D_CSS_420, CL51_Constant(387), "LL_DMA2D_CSS_420")
        for i in 0..<16 { XCTAssertEqual(LL_DMA_CH_OFFSET_TAB[i], CL51_Constant(388 + UInt32(i))) }
    }
}
