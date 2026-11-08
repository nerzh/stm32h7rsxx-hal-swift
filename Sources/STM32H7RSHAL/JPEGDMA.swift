// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// JPEG operations and definitions from stm32h7rsxx_hal_jpeg.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension JPEG {
    @discardableResult
    public func pause(_ selection: UInt32) -> HALStatus {
        precondition((1...3).contains(selection))
        var mask: UInt32 = 0
        if handle.read(.context) & 0xC == 0xC {
            if selection & 1 == 1 { modifyContext(set: 0x1000); mask |= 0x800 }
            if selection & 2 == 2 { modifyContext(set: 0x2000); mask |= 0x1000 }
            disableDMA(mask)
        } else if handle.read(.context) & 0xC == 8 {
            if selection & 1 == 1 { modifyContext(set: 0x1000); mask |= 6 }
            if selection & 2 == 2 { modifyContext(set: 0x2000); mask |= 0x28 }
            disableInterrupts(mask)
        }
        return .ok
    }
    @discardableResult
    public func resume(_ selection: UInt32) -> HALStatus {
        precondition((1...3).contains(selection))
        var mask: UInt32 = 0
        if handle.read(.context) & 0x3000 == 0 { return .error }
        if handle.read(.context) & 0xC == 0xC {
            if selection & 1 == 1 {
                modifyContext(clear: 0x1000); mask |= 0x800
                handle.write(.inputLength, value: handle.read(.inputLength) &- (handle.read(.inputLength) % 4))
                if handle.read(.inputLength) > 0 {
                    if startDMA(.input) != .ok { addError(4); handle.write(.state, value: 6); return .error }
                }
            }
            if selection & 2 == 2 {
                modifyContext(clear: 0x2000)
                if handle.read(.context) & 0x8000 != 0 { pollDMAResidualData() }
                else {
                    mask |= 0x1000
                    if startDMA(.output) != .ok { addError(4); handle.write(.state, value: 6); return .error }
                }
            }
            enableDMA(mask)
        } else if handle.read(.context) & 0xC == 8 {
            if selection & 1 == 1 { modifyContext(clear: 0x1000); mask |= 6 }
            if selection & 2 == 2 { modifyContext(clear: 0x2000); mask |= 0x28 }
            enableInterrupts(mask)
        }
        return .ok
    }
    @discardableResult
    public func abort(getTick: () -> UInt32) -> HALStatus {
        let context = handle.read(.context)
        modifyContext(clear: 0x800F)
        if context & 0xC == 0xC {
            if dma.abort(.output, getTick: getTick) != .ok && dma.read(.output, word: .errorCode) == DMAError.timeout.rawValue { addError(4) }
            if dma.abort(.input, getTick: getTick) != .ok && dma.read(.input, word: .errorCode) == DMAError.timeout.rawValue { addError(4) }
        }
        modify(.confr0, clear: 1)
        let start = getTick()
        while getFlag(0x80) != 0 {
            if getTick() &- start > 1000 { addError(8); handle.write(.state, value: 6); break }
        }
        disableInterrupts(0x7E); disableDMA(0x1800); modify(.cr, set: 0x2000); modify(.cr, set: 0x4000); clearFlags(0xFE)
        handle.write(.inputCount, value: 0); handle.write(.outputCount, value: 0); modifyContext(clear: 0x3000)
        if handle.read(.errorCode) != 0 { handle.write(.state, value: 6); unlock(); return .error }
        handle.write(.state, value: 1); unlock(); return .ok
    }
    func startDMA(_ stream: JPEGStream) -> HALStatus {
        let buffer = UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer(stream)))
        return dma.startInterrupt(stream, sourceAddress: stream == .input ? buffer : registers.dataAddress(.output),
                                  destinationAddress: stream == .input ? registers.dataAddress(.input) : buffer,
                                  sourceDataSize: handle.read(stream == .input ? .inputLength : .outputLength))
    }
    func dmaHead(_ stream: JPEGStream) -> UInt32 { dma.readMemory32(stream, at: dma.read(stream, word: .queueAddress)) }
    func startDMAProcess() -> HALStatus {
        if handle.read(.inputLength) < 4 || handle.read(.outputLength) < 4 { return .error }
        modifyContext(clear: 0x8000); disableDMA(0x1800)
        dma.writeCallback(.input, id: .transferComplete, value: dma.callback(.inputComplete))
        dma.writeCallback(.input, id: .error, value: dma.callback(.error))
        dma.writeCallback(.output, id: .transferComplete, value: dma.callback(.outputComplete))
        dma.writeCallback(.output, id: .error, value: dma.callback(.error))
        dma.writeCallback(.output, id: .abort, value: dma.callback(.outputAbort))
        handle.write(.inputLength, value: handle.read(.inputLength) &- (handle.read(.inputLength) % 4))
        handle.write(.outputLength, value: handle.read(.outputLength) &- (handle.read(.outputLength) % 4))
        if startInitialDMA(.input) != .ok { return .error }
        if startInitialDMA(.output) != .ok { return .error }
        enableDMA(0x1800); return .ok
    }
    func startInitialDMA(_ stream: JPEGStream) -> HALStatus {
        if dma.read(stream, word: .mode) & 0x80 == 0x80 {
            if dma.read(stream, word: .queueAddress) != 0 {
                dma.writeMemory32(stream, at: dmaHead(stream) &+ 8, value: handle.read(stream == .input ? .inputLength : .outputLength))
                dma.writeMemory32(stream, at: dmaHead(stream) &+ 12, value: stream == .input ? UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer(.input))) : registers.dataAddress(.output))
                dma.writeMemory32(stream, at: dmaHead(stream) &+ 16, value: stream == .input ? registers.dataAddress(.input) : UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer(.output))))
                if dma.startLinkedListInterrupt(stream) != .ok { return .error }
            } else {
                handle.write(.state, value: 1); addError(4); unlock(); return .error
            }
        } else if startDMA(stream) != .ok { addError(4); return .error }
        return .ok
    }
    func continueDMAProcess() {
        let flags = registers.read(.sr)
        if handle.read(.context) & 3 == 2 && flags & 0x40 != 0 {
            getInfoIntoHandle(); handle.write(.imageQuality, value: 0); invokeInfoReady()
            disableInterrupts(0x40); clearFlags(0x40)
        }
        if flags & 0x20 != 0 {
            disableDMA(0x1800); modifyContext(set: 0x8000); modify(.confr0, clear: 1)
            disableInterrupts(0x7E); clearFlags(0xFE)
            if dma.read(.input, word: .state) == 2 { _ = dma.abortInterrupt(.input) }
            if dma.read(.output, word: .state) == 2 { _ = dma.abortInterrupt(.output) }
            else { endDMAProcess() }
        }
    }
    func endDMAProcess() {
        handle.write(.outputCount, value: handle.read(.outputLength) &- (dma.getCounter(.output) &+ dma.getFIFOLevel(.output)))
        if handle.read(.outputCount) == handle.read(.outputLength) { invokeDataReady(); handle.write(.outputCount, value: 0) }
        if getFlag(0x10) == 0 {
            if handle.read(.outputCount) > 0 { invokeDataReady(); handle.write(.outputCount, value: 0) }
            modify(.confr0, clear: 1); finishProcess()
        } else if handle.read(.context) & 0x2000 == 0 { pollDMAResidualData() }
    }
    func pollDMAResidualData() {
        for _ in stride(from: 16, to: 0, by: -1) {
            if handle.read(.context) & 0x2000 == 0 && getFlag(0x10) != 0 {
                writeOutputWord(registers.read(.dor))
                if handle.read(.outputCount) == handle.read(.outputLength) { invokeDataReady(); handle.write(.outputCount, value: 0) }
            }
        }
        let context = handle.read(.context)
        if getFlag(0x10) == 0 || context & 0x2000 == 0 {
            modify(.confr0, clear: 1)
            if handle.read(.outputCount) > 0 { invokeDataReady(); handle.write(.outputCount, value: 0) }
            finishProcess()
        }
    }
    public func handleDMAEvent<Source: JPEGDMAEventSourceIO>(_ kind: JPEGDMACallbackKind, source: Source) {
        switch kind {
        case .inputComplete:
            disableInterrupts(0x7E)
            if handle.read(.context) & 0x800C == 0xC {
                disableDMA(0x800)
                handle.write(.inputCount, value: handle.read(.inputLength) &- (source.getCounter() &+ source.getFIFOLevel()))
                invokeGetData()
                if handle.read(.inputLength) >= 4 { handle.write(.inputLength, value: ((handle.read(.inputLength) &+ 3) / 4) &* 4) }
                if handle.read(.context) & 0x1000 == 0 && handle.read(.inputLength) > 0 {
                    if startDMA(.input) != .ok { addError(4); handle.write(.state, value: 6); invoke(.error); return }
                    enableDMA(0x800)
                }
                enableInterrupts(0x60)
            }
        case .outputComplete:
            disableInterrupts(0x7E)
            if handle.read(.context) & 0x800C == 0xC {
                if getFlag(0x20) == 0 {
                    disableDMA(0x1000)
                    handle.write(.outputCount, value: handle.read(.outputLength) &- (source.getCounter() &+ source.getFIFOLevel()))
                    invokeDataReady()
                    if handle.read(.context) & 0x2000 == 0 {
                        if startDMA(.output) != .ok { addError(4); handle.write(.state, value: 6); invoke(.error); return }
                        enableDMA(0x1000)
                    }
                }
                enableInterrupts(0x60)
            }
        case .error:
            if source.getError().rawValue != 0 {
                modify(.confr0, clear: 1); disableInterrupts(0x7E); disableDMA(0x1800)
                handle.write(.state, value: 1); addError(4); invoke(.error)
            }
        case .outputAbort:
            if handle.read(.context) & 0x8000 != 0 { endDMAProcess() }
        }
    }
}
