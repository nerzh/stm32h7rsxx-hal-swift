// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Types and encodings from stm32h7rsxx_hal_dma.h and stm32h7rsxx_hal_dma_ex.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum DMAController: UInt32, Sendable { case gpdma1 = 0, hpdma1 = 1 }

public struct DMAChannel: Equatable, Sendable {
    public let controller: DMAController
    public let index: Int

    public init(controller: DMAController, index: Int) {
        precondition(index >= 0 && index < 16)
        self.controller = controller
        self.index = index
    }

    public var supports2DAddressing: Bool { index >= 12 }
    public var supportsPeripheralFlowControl: Bool {
        index == 15 || (controller == .gpdma1 && index == 0)
    }
}

public enum DMARegister: Hashable, CaseIterable {
    case clbar, cfcr, csr, ccr, ctr1, ctr2, cbr1, csar, cdar, ctr3, cbr2, cllr
    case privcfgr, rcfglockr, misr
}

public protocol DMARegisterIO {
    var channel: DMAChannel { get }
    func read(_ register: DMARegister) -> UInt32
    func write(_ register: DMARegister, value: UInt32)
}

public enum DMAHandleWord: Int, CaseIterable {
    case lock = 0, mode = 1, state = 2, errorCode = 3, queueAddress = 4
}

// Five caller-owned words initially zero. Copies must access the same storage.
// Foreground/IRQ implementations must use volatile access, without Swift inout
// exclusivity spanning a call. The C HAL lock remains a non-atomic check/set.
public protocol DMAHandleIO {
    func read(_ word: DMAHandleWord) -> UInt32
    func write(_ word: DMAHandleWord, value: UInt32)
}

// Addresses are the target's 32-bit bus addresses, including queue metadata.
// A host model may map them to simulated memory. Hardware implementations must
// keep the caller's aligned storage alive; these operations do not maintain the
// CPU cache, allocate memory, or translate DMA-inaccessible memory automatically.
public protocol DMAMemoryIO {
    func read32(at address: UInt32) -> UInt32
    func write32(at address: UInt32, value: UInt32)
}

// The explicit ARM queue ABI is six words. Native Swift struct layout is not
// used as either a DMA node image or a queue image.
public enum DMAQueueWord: UInt32, CaseIterable {
    case head = 0, firstCircularNode = 4, nodeCount = 8, state = 12, errorCode = 16, type = 20
    public static let byteCount: UInt32 = 24
}

public enum DMANodeLayout {
    public static let registerCount = 8
    public static let wordCount = 9
    public static let byteCount: UInt32 = 36
    public static let informationOffset: UInt32 = 32
    public static let linearLinkRegisterIndex = 5
    public static let twoDimensionalLinkRegisterIndex = 7
}

public enum DMAState: UInt32, CaseIterable, Sendable {
    case reset = 0, ready = 1, busy = 2, error = 3, abort = 4, suspend = 5
}

public enum DMAQueueState: UInt32, CaseIterable, Sendable {
    case reset = 0, ready = 1, busy = 2
}

public enum DMATransferCompleteLevel: UInt32, CaseIterable, Sendable { case full = 0, half = 1 }

public struct DMAError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let dataTransfer = Self(rawValue: 0x0001)
    public static let linkedListUpdate = Self(rawValue: 0x0002)
    public static let userSetting = Self(rawValue: 0x0004)
    public static let triggerOverrun = Self(rawValue: 0x0008)
    public static let timeout = Self(rawValue: 0x0010)
    public static let noTransfer = Self(rawValue: 0x0020)
    public static let busy = Self(rawValue: 0x0040)
    public static let invalidCallback = Self(rawValue: 0x0080)
    public static let notSupported = Self(rawValue: 0x0100)
}

// Fields retain C register encodings; initialize validates the same combinations
// as IS_DMA_* macros. Transfer lengths and addresses remain UInt32 bus values.
public struct DMAConfiguration: Equatable, Sendable {
    public var request: UInt32
    public var blockHardwareRequest: UInt32
    public var direction: UInt32
    public var sourceIncrement: UInt32
    public var destinationIncrement: UInt32
    public var sourceDataWidth: UInt32
    public var destinationDataWidth: UInt32
    public var priority: UInt32
    public var sourceBurstLength: UInt32
    public var destinationBurstLength: UInt32
    public var transferAllocatedPort: UInt32
    public var transferEventMode: UInt32
    public var mode: UInt32

    public init(request: UInt32 = 0, blockHardwareRequest: UInt32 = 0, direction: UInt32 = 0,
                sourceIncrement: UInt32 = 0, destinationIncrement: UInt32 = 0,
                sourceDataWidth: UInt32 = 0, destinationDataWidth: UInt32 = 0,
                priority: UInt32 = 0, sourceBurstLength: UInt32 = 1, destinationBurstLength: UInt32 = 1,
                transferAllocatedPort: UInt32 = 0, transferEventMode: UInt32 = 0, mode: UInt32 = 0) {
        self.request = request
        self.blockHardwareRequest = blockHardwareRequest
        self.direction = direction
        self.sourceIncrement = sourceIncrement
        self.destinationIncrement = destinationIncrement
        self.sourceDataWidth = sourceDataWidth
        self.destinationDataWidth = destinationDataWidth
        self.priority = priority
        self.sourceBurstLength = sourceBurstLength
        self.destinationBurstLength = destinationBurstLength
        self.transferAllocatedPort = transferAllocatedPort
        self.transferEventMode = transferEventMode
        self.mode = mode
    }
}

public struct DMALinkedListConfiguration: Equatable, Sendable {
    public var priority: UInt32
    public var linkStepMode: UInt32
    public var linkAllocatedPort: UInt32
    public var transferEventMode: UInt32
    public var linkedListMode: UInt32

    public init(priority: UInt32 = 0, linkStepMode: UInt32 = 0, linkAllocatedPort: UInt32 = 0,
                transferEventMode: UInt32 = 0, linkedListMode: UInt32 = 0x80) {
        self.priority = priority
        self.linkStepMode = linkStepMode
        self.linkAllocatedPort = linkAllocatedPort
        self.transferEventMode = transferEventMode
        self.linkedListMode = linkedListMode
    }
}

public typealias DMACallback = @convention(c) (UnsafeMutableRawPointer?) -> Void

public enum DMACallbackID: UInt32, CaseIterable {
    case transferComplete = 0, halfTransfer = 1, error = 2, abort = 3, suspend = 4, all = 5
}

// Five initially nil thin C function pointers plus a separate native-width
// Parent pointer. Context replaces the C callback's handle argument and remains
// caller-owned. Parent is independently mutable for future peripheral drivers.
// The all ID is accepted by unregisterCallback only, never by slot accessors.
public protocol DMACallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: DMACallbackID) -> DMACallback?
    func write(_ id: DMACallbackID, value: DMACallback?)
    func readParent() -> UnsafeMutableRawPointer?
    func writeParent(_ value: UnsafeMutableRawPointer?)
}
