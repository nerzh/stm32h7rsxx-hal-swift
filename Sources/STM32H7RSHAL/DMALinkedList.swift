// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Linked-list functions from stm32h7rsxx_hal_dma_ex.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum DMAQueueError: UInt32, CaseIterable, Sendable {
    case none = 0, busy = 1, empty = 2, unsupported = 3, invalidType = 4, outOfRange = 5, notFound = 6
}

public enum DMAQueueType: UInt32, Sendable { case `static` = 0, dynamic = 1 }

// The configuration is a Swift value. Nodes and queues themselves are explicit
// target memory images accessed through DMAMemoryIO, never Swift struct layout.
public struct DMANodeConfiguration: Equatable, Sendable {
    public var nodeType: UInt32
    public var configuration: DMAConfiguration
    public var dataHandling: DMADataHandlingConfiguration
    public var trigger: DMATriggerConfiguration
    public var repeatBlock: DMARepeatBlockConfiguration
    public var sourceAddress: UInt32
    public var destinationAddress: UInt32
    public var dataSize: UInt32

    public init(nodeType: UInt32 = 0x21, configuration: DMAConfiguration = .init(),
                dataHandling: DMADataHandlingConfiguration = .init(),
                trigger: DMATriggerConfiguration = .init(),
                repeatBlock: DMARepeatBlockConfiguration = .init(),
                sourceAddress: UInt32 = 0, destinationAddress: UInt32 = 0, dataSize: UInt32 = 0) {
        self.nodeType = nodeType
        self.configuration = configuration
        self.dataHandling = dataHandling
        self.trigger = trigger
        self.repeatBlock = repeatBlock
        self.sourceAddress = sourceAddress
        self.destinationAddress = destinationAddress
        self.dataSize = dataSize
    }
}

public struct DMALinkedList<Memory: DMAMemoryIO> {
    public let memory: Memory
    public init(memory: Memory) { self.memory = memory }

    func node(_ address: UInt32, _ index: UInt32) -> UInt32 {
        memory.read32(at: address &+ (index &* 4))
    }
    func setNode(_ address: UInt32, _ index: UInt32, _ value: UInt32) {
        memory.write32(at: address &+ (index &* 4), value: value)
    }
    func queue(_ address: UInt32, _ word: DMAQueueWord) -> UInt32 {
        memory.read32(at: address &+ word.rawValue)
    }
    func setQueue(_ address: UInt32, _ word: DMAQueueWord, _ value: UInt32) {
        memory.write32(at: address &+ word.rawValue, value: value)
    }
    func cllrInfo(_ address: UInt32) -> (mask: UInt32, offset: UInt32) {
        if node(address, 8) & 2 == 2 { return (0xFE01_0000, 7) }
        return (0xF801_0000, 5)
    }
}

extension DMA {
    @discardableResult
    public func initializeLinkedList(_ configuration: DMALinkedListConfiguration,
                                     getTick: () -> UInt32) -> HALStatus {
        let start = getTick()
        precondition(configuration.priority & ~UInt32(0x00C0_0000) == 0)
        precondition(configuration.linkStepMode == 0 || configuration.linkStepMode == 0x10000)
        precondition(configuration.transferEventMode & ~UInt32(0xC000_0000) == 0)
        precondition(configuration.linkedListMode == 0x80 || configuration.linkedListMode == 0x81)
        precondition(configuration.linkAllocatedPort & ~UInt32(0x20000) == 0)
        unlock()
        setState(.busy)
        disable()
        while registers.read(.ccr) & 1 != 0 {
            if getTick() &- start > 5 {
                setError(.timeout)
                setState(.error)
                return .error
            }
        }
        let value = configuration.priority | configuration.linkStepMode | configuration.linkAllocatedPort
        modify(.ccr, clear: 0x00C3_0000, set: value)
        registers.write(.ctr1, value: 0)
        registers.write(.ctr2, value: configuration.transferEventMode)
        registers.write(.cbr1, value: 0)
        registers.write(.csar, value: 0)
        registers.write(.cdar, value: 0)
        if registers.channel.supports2DAddressing {
            registers.write(.ctr3, value: 0)
            registers.write(.cbr2, value: 0)
        }
        registers.write(.cllr, value: 0)
        handle.write(.mode, value: configuration.linkedListMode)
        setError([])
        setState(.ready)
        return .ok
    }

    @discardableResult
    public func deinitializeLinkedList(getTick: () -> UInt32) -> HALStatus {
        let start = getTick()
        disable()
        while registers.read(.ccr) & 1 != 0 {
            if getTick() &- start > 5 {
                setError(.timeout)
                setState(.error)
                return .error
            }
        }
        registers.write(.ccr, value: 0)
        registers.write(.clbar, value: 0)
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
        if handle.read(.queueAddress) != 0 {
            setQueueState(.ready)
            memory.write32(at: handle.read(.queueAddress) &+ DMAQueueWord.errorCode.rawValue, value: 0)
            handle.write(.queueAddress, value: 0)
        }
        if callbacks.readParent() != nil { callbacks.writeParent(nil) }
        handle.write(.mode, value: 0)
        setError([])
        setState(.reset)
        unlock()
        return .ok
    }

    @discardableResult
    public func startLinkedList() -> HALStatus { startLinkedList(interrupts: false) }

    @discardableResult
    public func startLinkedListInterrupt() -> HALStatus { startLinkedList(interrupts: true) }

    private func startLinkedList(interrupts: Bool) -> HALStatus {
        guard handle.read(.queueAddress) != 0 else { return .error }
        let state = handle.read(.state)
        let ccr = registers.read(.ccr) & 0x10000
        if state == DMAState.ready.rawValue || (state == DMAState.busy.rawValue && ccr != 0) {
            if hasState(.ready) {
                if !tryLock() { return .busy }
                setState(.busy)
                setQueueState(.busy)
                setError([])
                memory.write32(at: handle.read(.queueAddress) &+ DMAQueueWord.errorCode.rawValue, value: 0)
                if interrupts {
                    enableInterrupts(0x5D00)
                    if callbacks.read(.halfTransfer) != nil { enableInterrupts(0x200) }
                    if callbacks.read(.suspend) != nil { enableInterrupts(0x2000) }
                }
                let list = DMALinkedList(memory: memory)
                let mask = list.cllrInfo(list.queue(handle.read(.queueAddress), .head)).mask
                registers.write(.clbar, value: list.queue(handle.read(.queueAddress), .head) & 0xFFFF_0000)
                registers.write(.cllr, value: (list.queue(handle.read(.queueAddress), .head) & 0xFFFC) | mask)
            }
            enable()
        } else {
            setError(.busy)
            unlock()
            return .error
        }
        return .ok
    }

    @discardableResult
    public func linkQueue(at address: UInt32) -> HALStatus {
        guard address != 0 else { return .error }
        let state = handle.read(.state)
        if hasState(.busy) || state == DMAState.suspend.rawValue {
            setError(.busy)
            unlock()
            return .error
        }
        let list = DMALinkedList(memory: memory)
        if list.queue(address, .state) == DMAQueueState.busy.rawValue {
            list.setQueue(address, .errorCode, DMAQueueError.busy.rawValue)
            return .error
        }
        if !registers.channel.supports2DAddressing && list.node(list.queue(address, .head), 8) & 2 == 2 {
            list.setQueue(address, .errorCode, DMAQueueError.unsupported.rawValue)
            return .error
        }
        if handle.read(.mode) == 0x81 {
            if list.queue(address, .firstCircularNode) == 0 {
                list.setQueue(address, .errorCode, DMAQueueError.invalidType.rawValue)
                return .error
            }
        } else if list.queue(address, .firstCircularNode) != 0 {
            list.setQueue(address, .errorCode, DMAQueueError.invalidType.rawValue)
            return .error
        }
        handle.write(.queueAddress, value: address)
        return .ok
    }

    @discardableResult
    public func unlinkQueue() -> HALStatus {
        let state = handle.read(.state)
        if hasState(.busy) || state == DMAState.suspend.rawValue {
            setError(.busy)
            unlock()
            return .error
        }
        handle.write(.queueAddress, value: 0)
        return .ok
    }
}
