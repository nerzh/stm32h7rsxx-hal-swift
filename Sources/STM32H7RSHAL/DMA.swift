// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_dma.c/.h at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct DMA<Registers: DMARegisterIO, Handle: DMAHandleIO,
                  Callbacks: DMACallbackIO, Memory: DMAMemoryIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let memory: Memory

    public init(registers: Registers, handle: Handle, callbacks: Callbacks, memory: Memory) {
        self.registers = registers
        self.handle = handle
        self.callbacks = callbacks
        self.memory = memory
    }

    @discardableResult
    public func initialize(_ configuration: DMAConfiguration, getTick: () -> UInt32) -> HALStatus {
        let start = getTick()
        validate(configuration)
        unlock()
        if hasState(.reset) { clearCallbacks() }
        setState(.busy)
        disable()
        while (registers.read(.ccr) & 1) != 0 {
            if (getTick() &- start) > 5 {
                setError(.timeout)
                setState(.error)
                return .error
            }
        }
        initializeRegisters(configuration)
        handle.write(.mode, value: configuration.mode)
        setError([])
        setState(.ready)
        return .ok
    }

    @discardableResult
    public func deinitialize(getTick: () -> UInt32) -> HALStatus {
        let start = getTick()
        disable()
        while (registers.read(.ccr) & 1) != 0 {
            if (getTick() &- start) > 5 {
                setError(.timeout)
                setState(.error)
                return .error
            }
        }
        registers.write(.clbar, value: 0)
        registers.write(.ccr, value: 0)
        registers.write(.ctr1, value: 0)
        registers.write(.ctr2, value: 0)
        registers.write(.cbr1, value: 0)
        registers.write(.csar, value: 0)
        registers.write(.cdar, value: 0)
        registers.write(.cllr, value: 0)
        if registers.channel.supports2DAddressing {
            registers.write(.ctr3, value: 0)
            registers.write(.cbr2, value: 0)
        }
        clearFlag(0x7F00)
        clearCallbacks()
        handle.write(.queueAddress, value: 0)
        if callbacks.readParent() != nil { callbacks.writeParent(nil) }
        handle.write(.mode, value: 0)
        setError([])
        setState(.reset)
        unlock()
        return .ok
    }

    @discardableResult
    public func start(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
        precondition(sourceDataSize > 0 && sourceDataSize <= 0xFFFF)
        if !tryLock() { return .busy }
        if hasState(.ready) {
            setState(.busy)
            setError([])
            setTransferConfiguration(sourceAddress: sourceAddress, destinationAddress: destinationAddress,
                                     sourceDataSize: sourceDataSize)
            enable()
        } else {
            setError(.busy)
            unlock()
            return .error
        }
        return .ok
    }

    @discardableResult
    public func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32,
                               sourceDataSize: UInt32) -> HALStatus {
        precondition(sourceDataSize > 0 && sourceDataSize <= 0xFFFF)
        if !tryLock() { return .busy }
        if hasState(.ready) {
            setState(.busy)
            setError([])
            setTransferConfiguration(sourceAddress: sourceAddress, destinationAddress: destinationAddress,
                                     sourceDataSize: sourceDataSize)
            enableInterrupts(0x5D00)
            if callbacks.read(.halfTransfer) != nil { enableInterrupts(0x0200) }
            if callbacks.read(.suspend) != nil { enableInterrupts(0x2000) }
            enable()
        } else {
            setError(.busy)
            unlock()
            return .error
        }
        return .ok
    }

    @discardableResult
    public func abort(getTick: () -> UInt32) -> HALStatus {
        let start = getTick()
        if !hasState(.busy) {
            setError(.noTransfer)
            unlock()
            return .error
        }
        modify(.ccr, clear: 0, set: 4)
        setState(.suspend)
        while (registers.read(.csr) & 0x2000) == 0 {
            if (getTick() &- start) > 5 {
                addError(.timeout)
                setState(.error)
                if (handle.read(.mode) & 0x80) == 0x80 { setQueueState(.ready) }
                unlock()
                return .error
            }
        }
        modify(.ccr, clear: 0, set: 2)
        setState(.abort)
        clearFlag(0x7F00)
        setState(.ready)
        if (handle.read(.mode) & 0x80) == 0x80 {
            setQueueState(.ready)
            registers.write(.cbr1, value: 0)
        }
        unlock()
        return .ok
    }

    @discardableResult
    public func abortInterrupt() -> HALStatus {
        if !hasState(.busy) {
            setError(.noTransfer)
            return .error
        }
        setState(.abort)
        modify(.ccr, clear: 0, set: 0x2004)
        return .ok
    }

    @discardableResult
    public func pollForTransfer(_ level: DMATransferCompleteLevel, timeout: UInt32,
                                getTick: () -> UInt32) -> HALStatus {
        let start = getTick()
        if !hasState(.busy) {
            setError(.noTransfer)
            unlock()
            return .error
        }
        if (handle.read(.mode) & 0x81) == 0x81 {
            setError(.notSupported)
            return .error
        }
        // Full transfer polling waits for IDLE, not the transfer-complete flag.
        let levelFlag: UInt32 = level == .full ? 1 : 0x200
        var status = registers.read(.csr)
        while (status & levelFlag) == 0 {
            if timeout != UInt32.max {
                if (getTick() &- start) > timeout || timeout == 0 {
                    addError(.timeout)
                    _ = abort(getTick: getTick)
                    return .error
                }
            }
            status = registers.read(.csr)
        }
        if (status & 0x4000) != 0 {
            addError(.triggerOverrun)
            clearFlag(0x4000)
        }
        if (status & 0x1C00) != 0 {
            if (status & 0x0400) != 0 {
                addError(.dataTransfer)
                clearFlag(0x0400)
            }
            if (status & 0x0800) != 0 {
                addError(.linkedListUpdate)
                clearFlag(0x0800)
            }
            if (status & 0x1000) != 0 {
                addError(.userSetting)
                clearFlag(0x1000)
            }
            modify(.ccr, clear: 0, set: 2)
            setState(.ready)
            if (handle.read(.mode) & 0x80) == 0x80 { setQueueState(.ready) }
            unlock()
            return .error
        }
        if level == .half {
            clearFlag(0x200)
        } else {
            clearFlag(0x300)
            setState(.ready)
            if (handle.read(.mode) & 0x80) == 0x80 { setQueueState(.ready) }
            unlock()
        }
        return .ok
    }

    public func handleInterrupt() {
        let channelFlag = UInt32(1) << (UInt32(registers.channel.index) & 0x1F)
        if (registers.read(.misr) & channelFlag) == 0 { return }

        if getFlag(0x0400) != 0 {
            if getInterruptSource(0x0400) != 0 {
                clearFlag(0x0400)
                addError(.dataTransfer)
            }
        }
        if getFlag(0x0800) != 0 {
            if getInterruptSource(0x0800) != 0 {
                clearFlag(0x0800)
                addError(.linkedListUpdate)
            }
        }
        if getFlag(0x1000) != 0 {
            if getInterruptSource(0x1000) != 0 {
                clearFlag(0x1000)
                addError(.userSetting)
            }
        }
        if getFlag(0x4000) != 0 {
            if getInterruptSource(0x4000) != 0 {
                clearFlag(0x4000)
                addError(.triggerOverrun)
            }
        }
        if getFlag(0x0200) != 0 {
            if getInterruptSource(0x0200) != 0 {
                clearFlag(0x0200)
                invokeCallback(.halfTransfer)
            }
        }
        if getFlag(0x2000) != 0 {
            if getInterruptSource(0x2000) != 0 {
                clearFlag(0x2000)
                if hasState(.abort) {
                    disableInterrupts(0x2000)
                    modify(.ccr, clear: 0, set: 2)
                    setState(.ready)
                    if (handle.read(.mode) & 0x80) == 0x80 {
                        setQueueState(.ready)
                        registers.write(.cbr1, value: 0)
                    }
                    unlock()
                    invokeCallback(.abort)
                    return
                } else {
                    setState(.suspend)
                    invokeCallback(.suspend)
                }
            }
        }
        if getFlag(0x0100) != 0 {
            if getInterruptSource(0x0100) != 0 {
                if (handle.read(.mode) & 0x80) == 0x80 {
                    if registers.read(.cllr) == 0 {
                        if registers.read(.cbr1) == 0 {
                            setState(.ready)
                            setQueueState(.ready)
                        }
                    }
                } else {
                    if registers.read(.cbr1) == 0 { setState(.ready) }
                }
                clearFlag(0x0300)
                unlock()
                invokeCallback(.transferComplete)
            }
        }
        // Callbacks may have rearmed a transfer and changed ErrorCode. The C
        // handler checks the live value here, after all preceding callbacks.
        if handle.read(.errorCode) != 0 {
            modify(.ccr, clear: 0, set: 2)
            setState(.ready)
            if (handle.read(.mode) & 0x80) == 0x80 { setQueueState(.ready) }
            unlock()
            invokeCallback(.error)
        }
    }

    @discardableResult
    public func registerCallback(id: UInt32, callback: DMACallback?) -> HALStatus {
        if hasState(.ready), let id = DMACallbackID(rawValue: id), id != .all {
            // Unlike RNG, the upstream DMA API accepts a null callback here.
            callbacks.write(id, value: callback)
            return .ok
        }
        return .error
    }

    @discardableResult
    public func registerCallback(id: DMACallbackID, callback: DMACallback?) -> HALStatus {
        registerCallback(id: id.rawValue, callback: callback)
    }

    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        if hasState(.ready), let id = DMACallbackID(rawValue: id) {
            if id == .all { clearCallbacks() } else { callbacks.write(id, value: nil) }
            return .ok
        }
        return .error
    }

    @discardableResult
    public func unregisterCallback(id: DMACallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }

    public func getState() -> DMAState { DMAState(rawValue: handle.read(.state))! }
    public func getError() -> DMAError { DMAError(rawValue: handle.read(.errorCode)) }

    @discardableResult
    public func configureChannelAttributes(_ attributes: UInt32) -> HALStatus {
        precondition(attributes == 0x0100_0000 || attributes == 0x0100_0001)
        let channelFlag = UInt32(1) << (UInt32(registers.channel.index) & 0x1F)
        if (attributes & 0x0100_0000) == 0x0100_0000 {
            if (attributes & 0x0100_0001) == 0x0100_0001 {
                modify(.privcfgr, clear: 0, set: channelFlag)
            } else {
                modify(.privcfgr, clear: channelFlag, set: 0)
            }
        }
        return .ok
    }

    @discardableResult
    public func getChannelAttributes(_ output: inout UInt32?) -> HALStatus {
        guard output != nil else { return .error }
        let channelFlag = UInt32(1) << (UInt32(registers.channel.index) & 0x1F)
        output = (registers.read(.privcfgr) & channelFlag) == 0 ? 0x0100_0000 : 0x0100_0001
        return .ok
    }

    @discardableResult
    public func getChannelAttributes(_ output: inout UInt32) -> HALStatus {
        var value: UInt32? = output
        let status = getChannelAttributes(&value)
        output = value!
        return status
    }

    @discardableResult
    public func lockChannelAttributes() -> HALStatus {
        let channelFlag = UInt32(1) << (UInt32(registers.channel.index) & 0x1F)
        modify(.rcfglockr, clear: 0, set: channelFlag)
        return .ok
    }

    @discardableResult
    public func getChannelAttributeLock(_ output: inout UInt32?) -> HALStatus {
        guard output != nil else { return .error }
        let channelFlag = UInt32(1) << (UInt32(registers.channel.index) & 0x1F)
        output = (registers.read(.rcfglockr) & channelFlag) == 0 ? 0 : 1
        return .ok
    }

    @discardableResult
    public func getChannelAttributeLock(_ output: inout UInt32) -> HALStatus {
        var value: UInt32? = output
        let status = getChannelAttributeLock(&value)
        output = value!
        return status
    }

    public func resetHandleState() { setState(.reset) }
    public func enable() { modify(.ccr, clear: 0, set: 1) }
    public func disable() { modify(.ccr, clear: 0, set: 6) }
    public func getFlag(_ flag: UInt32) -> UInt32 { registers.read(.csr) & flag }
    public func clearFlag(_ flag: UInt32) { registers.write(.cfcr, value: flag) }
    public func enableInterrupts(_ interrupts: UInt32) { modify(.ccr, clear: 0, set: interrupts) }
    public func disableInterrupts(_ interrupts: UInt32) { modify(.ccr, clear: interrupts, set: 0) }
    public func getInterruptSource(_ interrupts: UInt32) -> UInt32 { registers.read(.ccr) & interrupts }
    public func setCounter(_ counter: UInt32) { modify(.cbr1, clear: 0xFFFF, set: counter) }
    public func getCounter() -> UInt32 { registers.read(.cbr1) & 0xFFFF }

    func modify(_ register: DMARegister, clear: UInt32, set: UInt32) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }
    func hasState(_ state: DMAState) -> Bool { handle.read(.state) == state.rawValue }
    func setState(_ state: DMAState) { handle.write(.state, value: state.rawValue) }
    func setError(_ error: DMAError) { handle.write(.errorCode, value: error.rawValue) }
    func addError(_ error: DMAError) { handle.write(.errorCode, value: handle.read(.errorCode) | error.rawValue) }
    func tryLock() -> Bool {
        if handle.read(.lock) == 1 { return false }
        handle.write(.lock, value: 1)
        return true
    }
    func unlock() { handle.write(.lock, value: 0) }
    func setQueueState(_ state: DMAQueueState) {
        memory.write32(at: handle.read(.queueAddress) &+ DMAQueueWord.state.rawValue, value: state.rawValue)
    }
    func clearCallbacks() {
        callbacks.write(.transferComplete, value: nil)
        callbacks.write(.halfTransfer, value: nil)
        callbacks.write(.error, value: nil)
        callbacks.write(.abort, value: nil)
        callbacks.write(.suspend, value: nil)
    }
    func invokeCallback(_ id: DMACallbackID) {
        if callbacks.read(id) != nil { callbacks.read(id)!(callbacks.context) }
    }

    func setTransferConfiguration(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) {
        modify(.cbr1, clear: 0xFFFF, set: sourceDataSize & 0xFFFF)
        clearFlag(0x7F00)
        registers.write(.csar, value: sourceAddress)
        registers.write(.cdar, value: destinationAddress)
    }

    func initializeRegisters(_ configuration: DMAConfiguration) {
        modify(.ccr, clear: 0x00C3_0000, set: configuration.priority)
        var value = configuration.destinationIncrement | configuration.destinationDataWidth
            | configuration.sourceIncrement | configuration.sourceDataWidth
        value |= configuration.transferAllocatedPort
            | (((configuration.destinationBurstLength &- 1) << 20) & 0x03F0_0000)
            | (((configuration.sourceBurstLength &- 1) << 4) & 0x03F0)
        registers.write(.ctr1, value: value)
        value = configuration.blockHardwareRequest | (configuration.request & 0x7F) | configuration.transferEventMode
        if configuration.direction == 0x400 {
            value |= 0x400
        } else if configuration.direction == 0x200 {
            value |= 0x200
        }
        value |= configuration.mode
        modify(.ctr2, clear: 0xC33F_DE7F, set: value)
        registers.write(.cbr1, value: 0)
        if registers.channel.supports2DAddressing {
            registers.write(.ctr3, value: 0)
            registers.write(.cbr2, value: 0)
        }
        registers.write(.cllr, value: 0)
    }

    func validate(_ configuration: DMAConfiguration) {
        precondition(configuration.direction == 0 || configuration.direction == 0x400 || configuration.direction == 0x200)
        if configuration.direction != 0x200 {
            precondition(configuration.request == 0x200 || configuration.request <= 109)
        }
        precondition(configuration.blockHardwareRequest == 0 || configuration.blockHardwareRequest == 0x800)
        precondition(configuration.sourceIncrement == 0 || configuration.sourceIncrement == 8)
        precondition(configuration.destinationIncrement == 0 || configuration.destinationIncrement == 0x80000)
        precondition(configuration.sourceDataWidth <= 3)
        precondition((configuration.destinationDataWidth & ~UInt32(0x30000)) == 0)
        precondition((configuration.priority & ~UInt32(0x00C0_0000)) == 0)
        precondition((configuration.transferEventMode & ~UInt32(0xC000_0000)) == 0)
        precondition(configuration.mode == 0 || configuration.mode == 0x1000)
        if configuration.mode == 0x1000 { precondition(registers.channel.supportsPeripheralFlowControl) }
        precondition(configuration.sourceBurstLength >= 1 && configuration.sourceBurstLength <= 64)
        precondition(configuration.destinationBurstLength >= 1 && configuration.destinationBurstLength <= 64)
        precondition((configuration.transferAllocatedPort & ~UInt32(0x4000_4000)) == 0)
    }
}
