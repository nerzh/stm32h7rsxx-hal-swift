// Copyright (c) 2024 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MCE operations and definitions from stm32h7rsxx_hal_mce.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MCE {
    @discardableResult
    public func configureNoekeon(keyType: UInt32, key: UnsafePointer<UInt32>?, getTick: () -> UInt32) -> HALStatus {
        precondition(registers.instance != .mce1)
        var result = HALStatus.ok
        let start = getTick()
        if registers.read(.cr) & 3 == 0, let key {
            guard lock() else { return .busy }
            if keyType == 0 {
                if registers.read(.sr) & 1 != 0 { registers.write(.masterKey(0), value: 0) }
                for i: UInt32 in 0..<4 { registers.write(.masterKey(i), value: key[Int(i)]) }
                while registers.read(.sr) & 1 == 0 {
                    if getTick() &- start > 255 { addError(0x20); result = .error; break }
                }
            } else if keyType == 1 {
                if registers.read(.sr) & 4 != 0 { registers.write(.fastMasterKey(0), value: 0) }
                for i: UInt32 in 0..<4 { registers.write(.fastMasterKey(i), value: key[Int(i)]) }
                while registers.read(.sr) & 4 == 0 {
                    if getTick() &- start > 255 { addError(0x40); result = .error; break }
                }
            }
            unlock()
        }
        return result
    }
    @discardableResult
    public func configureAESContext(_ config: MCEAESConfiguration?, context: UInt32) -> HALStatus {
        precondition(registers.instance == .mce1); validateContext(context)
        guard registers.read(.cr) & 1 != 1, let config, context == 0x200 || context == 0x400 else { return .error }
        let index = (context &- 0x200) >> 9
        guard registers.read(.context(index, .cccfgr)) & 2 != 2 else { return .error }
        guard registers.read(.context(index, .cccfgr)) & 4 != 4 else { return .error }
        guard lock() else { return .busy }
        registers.write(.context(index, .ccnr0), value: config.nonce0)
        registers.write(.context(index, .ccnr1), value: config.nonce1)
        if let key = config.key {
            registers.write(.context(index, .cckeyr0), value: key[0]); registers.write(.context(index, .cckeyr1), value: key[1])
            registers.write(.context(index, .cckeyr2), value: key[2]); registers.write(.context(index, .cckeyr3), value: key[3])
        }
        modify(.context(index, .cccfgr), clear: 0xFFFF0000, set: config.version << 16)
        unlock(); return .ok
    }
    @discardableResult
    public func enableAESContext(_ context: UInt32) -> HALStatus {
        validateContext(context)
        guard context == 0x200 || context == 0x400 else { return .error }
        let index = (context &- 0x200) >> 9
        if registers.read(.context(index, .cccfgr)) & 1 != 1 {
            if registers.read(.context(index, .cccfgr)) & 2 == 2 { return .error }
            if registers.read(.cr) & 1 == 1 { return .error }
        }
        guard lock() else { return .busy }
        modify(.context(index, .cccfgr), set: 1); unlock(); return .ok
    }
    @discardableResult
    public func disableAESContext(_ context: UInt32) -> HALStatus {
        validateContext(context)
        guard context == 0x200 || context == 0x400 else { return .error }
        let index = (context &- 0x200) >> 9
        if registers.read(.context(index, .cccfgr)) & 1 == 1 {
            if registers.read(.context(index, .cccfgr)) & 2 == 2 { return .error }
            if registers.read(.cr) & 1 == 1 { return .error }
        }
        guard lock() else { return .busy }
        modify(.context(index, .cccfgr), clear: 1); unlock(); return .ok
    }
    @discardableResult
    public func lockAESContextConfiguration(_ context: UInt32) -> HALStatus {
        validateContext(context)
        guard registers.read(.cr) & 1 != 1, context == 0x200 || context == 0x400 else { return .error }
        guard lock() else { return .busy }
        modify(.context((context &- 0x200) >> 9, .cccfgr), set: 2); unlock(); return .ok
    }
    @discardableResult
    public func lockAESContextKey(_ context: UInt32) -> HALStatus {
        validateContext(context)
        guard registers.read(.cr) & 1 != 1, context == 0x200 || context == 0x400 else { return .error }
        guard lock() else { return .busy }
        modify(.context((context &- 0x200) >> 9, .cccfgr), set: 4); unlock(); return .ok
    }
    @discardableResult
    public func getAESContextKeyCRC(_ context: UInt32, value: inout UInt32) -> HALStatus {
        precondition(registers.instance == .mce1); validateContext(context)
        let result: HALStatus = value == 0 ? .error : .ok
        value = registers.read(.context((context &- 0x200) >> 9, .cccfgr)) & 0xFF00
        value >>= 8
        return result
    }
}
public enum MCEKeyCRC {
    public static func compute(_ key: UnsafePointer<UInt32>) -> UInt32 {
        let polynomial: UInt8 = 0x7
        let strobe: InlineArray<4, UInt32> = [0xAA55AA55, 0x3, 0x18, 0xC0]
        var crc: UInt8 = 0
        for j in 0..<4 {
            var value = key[j]
            if j == 0 { value ^= strobe[0] }
            else { value ^= (strobe[j] << 24) | (UInt32(crc) << 16) | (strobe[j] << 8) | UInt32(crc) }
            crc = 0
            for i: UInt8 in 0..<32 {
                let k = ((UInt32(crc) >> 7) ^ ((value >> (31 - i)) & 0xF)) & 1
                crc <<= 1
                if k != 0 { crc ^= polynomial }
            }
            crc ^= 0x55
        }
        return UInt32(crc)
    }
}
