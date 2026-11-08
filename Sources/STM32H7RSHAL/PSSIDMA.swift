// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PSSI operations and definitions from stm32h7rsxx_hal_pssi.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension PSSI {
    @discardableResult
    public func transmitDMA(_ data: UnsafeMutablePointer<UInt32>?, count: UInt32) -> HALStatus {
        precondition(dmaModuleEnabled)
        guard handle.read(.state) == 1 else { return .busy }
        guard lock() else { return .busy }
        handle.write(.state, value: 3); handle.write(.errorCode, value: 0)
        disable()
        handle.writeBuffer(data.map { UnsafeMutableRawPointer($0) }); handle.write(.transferCount, value: count)
        if handle.read(.transferCount) > PSSIConstants.maximumByteCount { handle.write(.transferSize, value: PSSIConstants.maximumByteCount) }
        else { handle.write(.transferSize, value: handle.read(.transferCount)) }
        if handle.read(.transferSize) > 0 {
            let status: HALStatus
            if dma.isPresent(.transmit) {
                if dma.readDataWidth(.transmit) == 0 {
                    modify(.cr, clear: 0xC0000020, set: 0xC0000000 | (handle.read(.clockPolarity) == 1 ? 0 : 0x20))
                } else {
                    modify(.cr, clear: 0xC0000020, set: 0xC0000000 | handle.read(.busWidth) | (handle.read(.clockPolarity) == 1 ? 0 : 0x20))
                }
                dma.writeCallback(.transmit, id: .transferComplete, value: dma.callback(.transmitComplete))
                dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))
                dma.writeCallback(.transmit, id: .halfTransfer, value: nil)
                dma.writeCallback(.transmit, id: .abort, value: nil)
                if dma.read(.transmit, word: .mode) & 0x80 == 0x80 {
                    let queue = dma.read(.transmit, word: .queueAddress)
                    if queue != 0 {
                        dma.writeMemory32(.transmit, at: dmaHead(.transmit) &+ 8, value: handle.read(.transferSize))
                        dma.writeMemory32(.transmit, at: dmaHead(.transmit) &+ 12, value: UInt32(truncatingIfNeeded: UInt(bitPattern: data)))
                        dma.writeMemory32(.transmit, at: dmaHead(.transmit) &+ 16, value: registers.dataAddress())
                        status = dma.startLinkedListInterrupt(.transmit)
                    } else { return .error }
                } else {
                    status = dma.startInterrupt(.transmit, sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: data)), destinationAddress: registers.dataAddress(), sourceDataSize: handle.read(.transferSize))
                }
            } else {
                handle.write(.state, value: 1); addError(8); unlock(); return .error
            }
            if status == .ok {
                handle.write(.transferCount, value: handle.read(.transferCount) &- handle.read(.transferSize))
                unlock(); enableInterrupts(2); modify(.cr, set: 0x40000000); enable()
            } else {
                handle.write(.state, value: 1); addError(8); unlock(); return .error
            }
        } else { unlock(); enableInterrupts(2) }
        return .ok
    }
    @discardableResult
    public func receiveDMA(_ data: UnsafeMutablePointer<UInt32>?, count: UInt32) -> HALStatus {
        precondition(dmaModuleEnabled)
        guard handle.read(.state) == 1 else { return .busy }
        disable()
        guard lock() else { return .busy }
        handle.write(.state, value: 4); handle.write(.errorCode, value: 0)
        handle.writeBuffer(data.map { UnsafeMutableRawPointer($0) }); handle.write(.transferCount, value: count)
        if handle.read(.transferCount) > PSSIConstants.maximumByteCount { handle.write(.transferSize, value: PSSIConstants.maximumByteCount) }
        else { handle.write(.transferSize, value: handle.read(.transferCount)) }
        if handle.read(.transferSize) > 0 {
            let status: HALStatus
            if dma.isPresent(.receive) {
                if dma.readDataWidth(.receive) == 0 {
                    modify(.cr, clear: 0xC0000020, set: 0x40000000 | (handle.read(.clockPolarity) == 1 ? 0x20 : 0))
                } else {
                    modify(.cr, clear: 0xC0000020, set: 0x40000000 | handle.read(.busWidth) | (handle.read(.clockPolarity) == 1 ? 0x20 : 0))
                }
                dma.writeCallback(.receive, id: .transferComplete, value: dma.callback(.receiveComplete))
                dma.writeCallback(.receive, id: .error, value: dma.callback(.error))
                dma.writeCallback(.receive, id: .halfTransfer, value: nil)
                dma.writeCallback(.receive, id: .abort, value: nil)
                if dma.read(.receive, word: .mode) & 0x80 == 0x80 {
                    let queue = dma.read(.receive, word: .queueAddress)
                    if queue != 0 {
                        dma.writeMemory32(.receive, at: dmaHead(.receive) &+ 8, value: handle.read(.transferSize))
                        dma.writeMemory32(.receive, at: dmaHead(.receive) &+ 12, value: registers.dataAddress())
                        dma.writeMemory32(.receive, at: dmaHead(.receive) &+ 16, value: UInt32(truncatingIfNeeded: UInt(bitPattern: data)))
                        status = dma.startLinkedListInterrupt(.receive)
                    } else { return .error }
                } else {
                    status = dma.startInterrupt(.receive, sourceAddress: registers.dataAddress(), destinationAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: data)), sourceDataSize: handle.read(.transferSize))
                }
            } else {
                handle.write(.state, value: 1); addError(8); unlock(); return .error
            }
            if status == .ok {
                handle.write(.transferCount, value: handle.read(.transferCount) &- handle.read(.transferSize))
                unlock(); enableInterrupts(2); modify(.cr, set: 0x40000000); enable()
            } else {
                handle.write(.state, value: 1); addError(8); unlock(); return .error
            }
        } else { unlock(); enableInterrupts(2) }
        return .ok
    }
    @discardableResult
    public func abortDMA() -> HALStatus {
        precondition(dmaModuleEnabled)
        guard lock() else { return .busy }
        disableInterrupts(2); handle.write(.state, value: 7)
        // Preserve C's live state reads after assigning ABORT.
        if registers.read(.cr) & 0x40000000 == 0x40000000 {
            if handle.read(.state) == 3 { abortAttachedDMA(.transmit, unlockBeforeAbort: false) }
            else if handle.read(.state) == 4 { abortAttachedDMA(.receive, unlockBeforeAbort: false) }
            else { invoke(.error) }
        }
        unlock(); enableInterrupts(2); return .ok
    }
    func dmaHead(_ direction: PSSIDMADirection) -> UInt32 {
        dma.readMemory32(direction, at: dma.read(direction, word: .queueAddress))
    }
    func abortAttachedDMA(_ direction: PSSIDMADirection, unlockBeforeAbort: Bool) {
        modify(.cr, clear: 0x40000000)
        if dma.isPresent(direction) {
            dma.writeCallback(direction, id: .abort, value: dma.callback(.abort))
            if unlockBeforeAbort { unlock() }
            if dma.abortInterrupt(direction) != .ok { dma.invokeCallback(direction, id: .abort) }
        }
    }
    public func handleInterrupt() {
        // C reads RIS even though this condition names the MIS mask.
        if getFlag(2) != 0 {
            handle.write(.transferCount, value: 0); disableInterrupts(2)
            if dmaModuleEnabled && registers.read(.cr) & 0x40000000 == 0x40000000 {
                if handle.read(.state) == 3 { addError(2); abortAttachedDMA(.transmit, unlockBeforeAbort: true) }
                else if handle.read(.state) == 4 { addError(4); abortAttachedDMA(.receive, unlockBeforeAbort: true) }
                else { invoke(.error) }
            }
            finishError()
        }
    }
    func handleError(_ code: UInt32) {
        handle.write(.transferCount, value: 0); addError(code); disableInterrupts(2)
        if dmaModuleEnabled && registers.read(.cr) & 0x40000000 == 0x40000000 {
            if handle.read(.state) == 3 { abortAttachedDMA(.transmit, unlockBeforeAbort: true) }
            else if handle.read(.state) == 4 { abortAttachedDMA(.receive, unlockBeforeAbort: true) }
        }
        finishError()
    }
    func finishError() {
        if handle.read(.state) == 7 {
            handle.write(.state, value: 1); unlock(); invoke(.abortComplete)
        } else {
            handle.write(.state, value: 1); unlock(); invoke(.error)
        }
    }
    public func handleDMAEvent(_ kind: PSSIDMACallbackKind) {
        precondition(dmaModuleEnabled)
        if kind == .abort {
            // The C callback requires both DMA handles, even for a one-way transfer.
            dma.writeCallback(.transmit, id: .abort, value: nil)
            dma.writeCallback(.receive, id: .abort, value: nil)
            if handle.read(.state) == 7 { handle.write(.state, value: 1); invoke(.abortComplete) }
            else { invoke(.error) }
            return
        }
        if kind == .error { disable() }
        disableInterrupts(2)
        let error = handle.read(.errorCode)
        if handle.read(.state) == 7 || error != 0 { handleError(handle.read(.errorCode)) }
        else {
            handle.write(.state, value: 1); unlock()
            switch kind {
            case .transmitComplete: invoke(.transmitComplete)
            case .receiveComplete: invoke(.receiveComplete)
            case .error: invoke(.error)
            case .abort: break
            }
        }
    }
}
