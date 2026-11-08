// Copyright (c) 2024 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MCE operations and definitions from stm32h7rsxx_hal_mce.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum MCEInstance: UInt32, CaseIterable, Sendable { case mce1 = 1, mce2 = 2, mce3 = 3 }
public enum MCERegionRegister: UInt32, CaseIterable, Sendable { case regcr = 0, saddr = 4, eaddr = 8, attr = 12 }
public enum MCEContextRegister: UInt32, CaseIterable, Sendable { case cccfgr = 0, ccnr0 = 4, ccnr1 = 8, cckeyr0 = 12, cckeyr1 = 16, cckeyr2 = 20, cckeyr3 = 24 }
public enum MCERegister: Hashable, Sendable {
    case cr, sr, iasr, iacr, iaier, privcfgr, iaesr, iaddr
    case masterKey(UInt32), fastMasterKey(UInt32)
    case region(UInt32, MCERegionRegister), context(UInt32, MCEContextRegister)
}
public protocol MCERegisterIO {
    var instance: MCEInstance { get }
    func read(_ register: MCERegister) -> UInt32
    func write(_ register: MCERegister, value: UInt32)
}
public enum MCEHandleWord: Int, CaseIterable { case state = 0, lock = 1, errorCode = 2 }
public protocol MCEHandleIO {
    func read(_ word: MCEHandleWord) -> UInt32
    func write(_ word: MCEHandleWord, value: UInt32)
}
public enum MCEState: UInt32, CaseIterable, Sendable { case reset = 0, ready = 1, busy = 2 }
public enum MCERegion: UInt32, CaseIterable, Sendable { case region1 = 0, region2 = 1, region3 = 2, region4 = 3 }
public enum MCEContext: UInt32, CaseIterable, Sendable { case none = 0, context1 = 0x200, context2 = 0x400 }
public enum MCECipher: UInt32, CaseIterable, Sendable { case none = 0, stream = 0x4000, block = 0x8000, fastBlock = 0xC000 }
public enum MCERegionPrivilege: UInt32, CaseIterable, Sendable { case unprivileged = 0, privileged = 0x10000 }
public enum MCERegionAccess: UInt32, CaseIterable, Sendable { case readOnly = 0, readWrite = 0x10000 }
public enum MCEConfigurationPrivilege: UInt32, CaseIterable, Sendable { case unprivileged = 0, privileged = 1 }
public enum MCEKeyType: UInt32, CaseIterable, Sendable { case master = 0, fastMaster = 1 }
public struct MCEError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let configurationAccess = Self(rawValue: 1)
    public static let privilegedRead = Self(rawValue: 2)
    public static let unprivilegedRead = Self(rawValue: 4)
    public static let privilegedWrite = Self(rawValue: 8)
    public static let unprivilegedWrite = Self(rawValue: 16)
    public static let masterKey = Self(rawValue: 32)
    public static let fastMasterKey = Self(rawValue: 64)
    public static let contextKey = Self(rawValue: 128)
    public static let invalidCallback = Self(rawValue: 256)
}
public struct MCEInterrupts: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let configurationAccess = Self(rawValue: 1)
    public static let illegalAccess = Self(rawValue: 2)
}
public enum MCEFlag: UInt32, CaseIterable, Sendable {
    case configurationAccess = 1, unprivilegedRead = 2, privilegedRead = 0x12, unprivilegedWrite = 0x82, privilegedWrite = 0x92
}
public struct MCERegionConfiguration: Equatable, Sendable {
    public var context: UInt32
    public var startAddress: UInt32
    public var endAddress: UInt32
    public var cipher: UInt32
    public var access: UInt32
    public var privilege: UInt32
    public init(context: UInt32 = 0, startAddress: UInt32, endAddress: UInt32,
                cipher: UInt32 = 0, access: UInt32 = 0, privilege: UInt32 = 0) {
        self.context = context; self.startAddress = startAddress; self.endAddress = endAddress
        self.cipher = cipher; self.access = access; self.privilege = privilege
    }
}
public struct MCEAESConfiguration {
    public var nonce0: UInt32
    public var nonce1: UInt32
    public var version: UInt32
    public var key: UnsafePointer<UInt32>?
    public init(nonce0: UInt32, nonce1: UInt32, version: UInt32, key: UnsafePointer<UInt32>? = nil) {
        self.nonce0 = nonce0; self.nonce1 = nonce1; self.version = version; self.key = key
    }
}
public struct MCE<Registers: MCERegisterIO, Handle: MCEHandleIO, Callbacks: MCECallbackIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let defaults: MCECallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks,
                defaults: MCECallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
