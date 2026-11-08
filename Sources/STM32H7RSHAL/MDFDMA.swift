// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MDF operations and definitions from stm32h7rsxx_hal_mdf.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MDF {
    @discardableResult
    public func startAcquisitionDMA(_ config: MDFFilterConfiguration?, dmaConfiguration: MDFDMAConfiguration?) -> HALStatus {
        guard let config, let dmaConfiguration else { return .error }
        precondition(dmaConfiguration.msbOnly <= 1)
        guard canStart(config) else { return .error }
        enableFilterInterrupts(config)
        registers.write(.dfltcr, value: 2)
        dma.writeCallback(.transferComplete, value: dma.callback(.complete))
        dma.writeCallback(.halfTransfer, value: dma.callback(.halfComplete))
        dma.writeCallback(.error, value: dma.callback(.error))
        let source = registers.dataAddress() &+ (dmaConfiguration.msbOnly == 1 ? 2 : 0)
        var status: HALStatus
        if dma.read(.mode) & 0x80 == 0x80 {
            if dma.read(.queueAddress) != 0 {
                dma.writeMemory32(at: dmaHead() &+ 8, value: dmaConfiguration.dataLength)
                dma.writeMemory32(at: dmaHead() &+ 12, value: source)
                dma.writeMemory32(at: dmaHead() &+ 16, value: dmaConfiguration.address)
                status = dma.startLinkedListInterrupt()
            } else { status = .error }
        } else {
            status = dma.startInterrupt(sourceAddress: source, destinationAddress: dmaConfiguration.address, sourceDataSize: dmaConfiguration.dataLength)
        }
        if status != .ok { handle.write(.state, value: 255); status = .error }
        else { configureAndEnable(config) }
        return status
    }
    func dmaHead() -> UInt32 { dma.readMemory32(at: dma.read(.queueAddress)) }
    @discardableResult
    public func stopAcquisitionDMA(getTick: () -> UInt32) -> HALStatus {
        if handle.read(.state) == 1 {
            if registers.read(.dfltcr) & 0x80000000 != 0x80000000 { return .error }
        } else {
            if handle.read(.state) != 2 { return .error }
            if dma.abort(getTick: getTick) != .ok { handle.write(.state, value: 255); return .error }
        }
        if registers.read(.sadcr) & 0x80000000 != 0 { modify(.sadcr, clear: 1) }
        modify(.dfltcr, clear: 1); modify(.dfltier, clear: 0x3A00); modify(.dfltisr, set: 0x3A00)
        modify(.dfltcr, clear: 2); handle.write(.state, value: 1); return .ok
    }
    public func handleDMAEvent(_ kind: MDFDMACallbackKind, dmaMode: UInt32) {
        switch kind {
        case .complete:
            if dmaMode != 0x81 { handle.write(.state, value: 1) }
            invoke(.acquisitionComplete)
        case .halfComplete: invoke(.acquisitionHalfComplete)
        case .error: addError(64); invoke(.error)
        }
    }
}
