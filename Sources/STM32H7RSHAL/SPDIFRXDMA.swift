// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPDIFRX operations and definitions from stm32h7rsxx_hal_spdifrx.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SPDIFRX {
    @discardableResult
    public func receiveDMA(_ stream: SPDIFRXStream, data: UnsafeMutablePointer<UInt32>?, count: UInt16,
                           systemCoreClock: UInt32) -> HALStatus {
        let budget = 10 &* (systemCoreClock / 24 / 1000), state = handle.read(.state)
        guard let data, count != 0 else { return .error }
        guard state == 1 || state == (stream == .data ? 4 : 3) else { return .busy }
        // The control-flow routine publishes its buffer and counts before locking.
        if stream == .control { setBuffer(stream, data: data, count: count) }
        guard lock() else { return .busy }
        if stream == .data { setBuffer(stream, data: data, count: count) }
        handle.write(.errorCode, value: 0); handle.write(.state, value: stream == .data ? 3 : 4)
        dma.writeCallback(stream, id: .halfTransfer, value: dma.callback(stream == .data ? .receiveHalf : .controlHalf))
        dma.writeCallback(stream, id: .transferComplete, value: dma.callback(stream == .data ? .receiveComplete : .controlComplete))
        dma.writeCallback(stream, id: .error, value: dma.callback(.error))
        let status: HALStatus
        if dma.read(stream, word: .mode) & 0x80 == 0x80 {
            if dma.read(stream, word: .queueAddress) != 0 {
                dma.writeMemory32(stream, at: dmaHead(stream) &+ 8, value: UInt32(count) * 4)
                dma.writeMemory32(stream, at: dmaHead(stream) &+ 12, value: registers.dataAddress(stream))
                dma.writeMemory32(stream, at: dmaHead(stream) &+ 16, value: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer(stream))))
                status = dma.startLinkedListInterrupt(stream)
            } else { return dmaStartError() }
        } else {
            status = dma.startInterrupt(stream, sourceAddress: registers.dataAddress(stream),
                                        destinationAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer(stream))), sourceDataSize: UInt32(count) * 4)
        }
        guard status == .ok else { return dmaStartError() }
        modify(.cr, set: stream == .data ? 4 : 0x400)
        if synchronizeBeforeReception(budget: budget) != .ok { return .timeout }
        unlock(); return .ok
    }
    func dmaHead(_ stream: SPDIFRXStream) -> UInt32 { dma.readMemory32(stream, at: dma.read(stream, word: .queueAddress)) }
    func dmaStartError() -> HALStatus {
        handle.write(.errorCode, value: 8); handle.write(.state, value: 7); unlock(); return .error
    }
    @discardableResult
    public func stopDMA() -> HALStatus {
        guard lock() else { return .busy }
        clearDMARequest(4); clearDMARequest(0x400)
        if dma.isPresent(.data) { dma.disable(.data) }
        if dma.isPresent(.control) { dma.disable(.control) }
        idle(); handle.write(.state, value: 1); unlock(); return .ok
    }
    func clearDMARequest(_ mask: UInt32) {
        // Preserve the uint16_t complement in the pinned C implementation.
        registers.write(.cr, value: registers.read(.cr) & UInt32(UInt16(truncatingIfNeeded: ~mask)))
    }
    public func handleDMAEvent(_ kind: SPDIFRXDMACallbackKind, dmaMode: UInt32) {
        switch kind {
        case .receiveComplete:
            if dmaMode != 0x81 { clearDMARequest(4); handle.write(.receiveCount, value: 0); handle.write(.state, value: 1) }
            invoke(.receiveComplete)
        case .receiveHalf: invoke(.receiveHalf)
        case .controlComplete:
            clearDMARequest(0x400); handle.write(.controlCount, value: 0); handle.write(.state, value: 1); invoke(.controlComplete)
        case .controlHalf: invoke(.controlHalf)
        case .error:
            clearDMARequest(0x404); handle.write(.receiveCount, value: 0); handle.write(.state, value: 1); addError(8); invoke(.error)
        }
    }
}
