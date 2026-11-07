// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_crc.c/.h and stm32h7rsxx_hal_crc_ex.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum CRCRegister: Hashable, CaseIterable {
    case dr, idr, cr, initialValue, polynomial
}

public protocol CRCRegisterIO {
    mutating func read(_ register: CRCRegister) -> UInt32
    mutating func write(_ register: CRCRegister, value: UInt32)
    // Each method must issue exactly one access of the indicated width to DR.
    mutating func writeData8(_ value: UInt8)
    mutating func writeData16(_ value: UInt16)
}

public enum CRCState: UInt32, CaseIterable, Sendable {
    case reset = 0, ready = 1, busy = 2, timeout = 3, error = 4
}

public enum CRCLock: UInt32, Sendable {
    case unlocked = 0, locked = 1
}

public enum CRCInputDataFormat: UInt32, CaseIterable, Sendable {
    case undefined = 0, bytes = 1, halfwords = 2, words = 3
}

public enum CRCPolynomialLength: UInt32, CaseIterable, Sendable {
    case bits32 = 0, bits16 = 0x08, bits8 = 0x10, bits7 = 0x18
}

public enum CRCInputInversion: UInt32, CaseIterable, Sendable {
    case none = 0, byte = 0x20, halfword = 0x40, word = 0x60
}

public enum CRCOutputInversion: UInt32, CaseIterable, Sendable {
    case disabled = 0, enabled = 0x80
}

public struct CRCConfiguration: Equatable, Sendable {
    public var usesDefaultPolynomial: Bool
    public var usesDefaultInitialValue: Bool
    public var generatingPolynomial: UInt32
    public var length: CRCPolynomialLength
    public var initialValue: UInt32
    public var inputInversion: CRCInputInversion
    public var outputInversion: CRCOutputInversion

    public init(usesDefaultPolynomial: Bool = true, usesDefaultInitialValue: Bool = true,
                generatingPolynomial: UInt32 = 0, length: CRCPolynomialLength = .bits32,
                initialValue: UInt32 = 0, inputInversion: CRCInputInversion = .none,
                outputInversion: CRCOutputInversion = .disabled) {
        self.usesDefaultPolynomial = usesDefaultPolynomial
        self.usesDefaultInitialValue = usesDefaultInitialValue
        self.generatingPolynomial = generatingPolynomial
        self.length = length
        self.initialValue = initialValue
        self.inputInversion = inputInversion
        self.outputInversion = outputInversion
    }
}

// A value-type handle replaces the nullable C handle. The C driver never acquires
// Lock: it only initializes/unlocks it. Preserve that behavior rather than adding
// busy returns to calculation or CRCEx. The caller must serialize peripheral use,
// including interrupts and copies of this handle; Lock is not an atomic mutex.
// There are no registered callback slots in this upstream CRC driver. MSP hooks
// receive the live handle, as the weak C hooks do, without storing a closure.
public struct CRC<IO: CRCRegisterIO> {
    public var registers: IO
    public var configuration: CRCConfiguration
    public var inputDataFormat: CRCInputDataFormat
    public var state: CRCState
    public var lock: CRCLock

    public init(registers: IO, configuration: CRCConfiguration = .init(),
                inputDataFormat: CRCInputDataFormat = .undefined) {
        self.registers = registers
        self.configuration = configuration
        self.inputDataFormat = inputDataFormat
        state = .reset
        lock = .unlocked
    }

    @discardableResult
    public mutating func initialize(mspInitialize: (inout Self) -> Void = { _ in }) -> HALStatus {
        if state == .reset {
            lock = .unlocked
            mspInitialize(&self)
        }
        state = .busy
        if configuration.usesDefaultPolynomial {
            registers.write(.polynomial, value: 0x04C1_1DB7)
            modifyControl(clear: 0x18, set: CRCPolynomialLength.bits32.rawValue)
        } else {
            if setPolynomial(configuration.generatingPolynomial, length: configuration.length) != .ok {
                return .error
            }
        }
        if configuration.usesDefaultInitialValue {
            registers.write(.initialValue, value: 0xFFFF_FFFF)
        } else {
            registers.write(.initialValue, value: configuration.initialValue)
        }
        modifyControl(clear: 0x60, set: configuration.inputInversion.rawValue)
        modifyControl(clear: 0x80, set: configuration.outputInversion.rawValue)
        // The upstream assert_param checks this after configuring the registers.
        precondition(inputDataFormat != .undefined)
        state = .ready
        return .ok
    }

    @discardableResult
    public mutating func deinitialize(mspDeinitialize: (inout Self) -> Void = { _ in }) -> HALStatus {
        if state == .busy { return .busy }
        state = .busy
        resetDataRegister()
        registers.write(.idr, value: 0)
        mspDeinitialize(&self)
        state = .reset
        lock = .unlocked
        return .ok
    }

    // Unlike the C uint32_t* API, a raw buffer's count always denotes BYTES.
    // InputDataFormat determines the element width; the buffer must contain whole,
    // naturally aligned elements. Empty buffers may have a nil base address.
    // No data is copied, allocated, or processed by a software CRC implementation.
    public mutating func accumulate(_ buffer: UnsafeRawBufferPointer) -> UInt32 {
        state = .busy
        let result = feed(buffer)
        state = .ready
        return result
    }

    public mutating func calculate(_ buffer: UnsafeRawBufferPointer) -> UInt32 {
        state = .busy
        resetDataRegister()
        let result = feed(buffer)
        state = .ready
        return result
    }

    // Typed overloads keep the same stored format and reject mismatches instead
    // of reinterpreting an element count as a count of a different element type.
    public mutating func accumulate(_ buffer: UnsafeBufferPointer<UInt8>) -> UInt32 {
        precondition(inputDataFormat == .bytes)
        return accumulate(UnsafeRawBufferPointer(buffer))
    }

    public mutating func accumulate(_ buffer: UnsafeBufferPointer<UInt16>) -> UInt32 {
        precondition(inputDataFormat == .halfwords)
        return accumulate(UnsafeRawBufferPointer(buffer))
    }

    public mutating func accumulate(_ buffer: UnsafeBufferPointer<UInt32>) -> UInt32 {
        precondition(inputDataFormat == .words)
        return accumulate(UnsafeRawBufferPointer(buffer))
    }

    public mutating func calculate(_ buffer: UnsafeBufferPointer<UInt8>) -> UInt32 {
        precondition(inputDataFormat == .bytes)
        return calculate(UnsafeRawBufferPointer(buffer))
    }

    public mutating func calculate(_ buffer: UnsafeBufferPointer<UInt16>) -> UInt32 {
        precondition(inputDataFormat == .halfwords)
        return calculate(UnsafeRawBufferPointer(buffer))
    }

    public mutating func calculate(_ buffer: UnsafeBufferPointer<UInt32>) -> UInt32 {
        precondition(inputDataFormat == .words)
        return calculate(UnsafeRawBufferPointer(buffer))
    }

    public func getState() -> CRCState { state }

    @discardableResult
    public mutating func setPolynomial(_ polynomial: UInt32, length: CRCPolynomialLength) -> HALStatus {
        var status = HALStatus.ok
        var msb: UInt32 = 31
        if (polynomial & 1) == 0 {
            status = .error
        } else {
            // Preserve C's post-decrement condition exactly. It tests bit 30 first,
            // never bit 31; replacing this with a highest-set-bit helper changes C.
            while true {
                let previous = msb
                msb &-= 1
                if !(previous > 0 && (polynomial & (UInt32(1) << (msb & 0x1F))) == 0) { break }
            }
            switch length {
            case .bits7: if msb >= 7 { status = .error }
            case .bits8: if msb >= 8 { status = .error }
            case .bits16: if msb >= 16 { status = .error }
            case .bits32: break
            }
        }
        if status == .ok {
            registers.write(.polynomial, value: polynomial)
            modifyControl(clear: 0x18, set: length.rawValue)
        }
        return status
    }

    @discardableResult
    public mutating func reverseInputData(_ mode: CRCInputInversion) -> HALStatus {
        state = .busy
        modifyControl(clear: 0x60, set: mode.rawValue)
        state = .ready
        return .ok
    }

    @discardableResult
    public mutating func reverseOutputData(_ mode: CRCOutputInversion) -> HALStatus {
        state = .busy
        modifyControl(clear: 0x80, set: mode.rawValue)
        state = .ready
        return .ok
    }

    // Direct equivalents of the exported CRC/CRCEx register macros. These do not
    // update configuration, state, or lock, except RESET_HANDLE_STATE itself.
    public mutating func resetHandleState() { state = .reset }
    public mutating func resetDataRegister() { modifyControl(clear: 0, set: 1) }
    public mutating func setInitialValue(_ value: UInt32) { registers.write(.initialValue, value: value) }
    public mutating func setIndependentData(_ value: UInt32) { registers.write(.idr, value: value) }
    public mutating func getIndependentData() -> UInt32 { registers.read(.idr) & 0xFFFF_FFFF }
    public mutating func enableOutputReversal() { modifyControl(clear: 0, set: 0x80) }
    public mutating func disableOutputReversal() { modifyControl(clear: 0x80, set: 0) }
    public mutating func configurePolynomial(_ polynomial: UInt32) { registers.write(.polynomial, value: polynomial) }

    private mutating func modifyControl(clear: UInt32, set: UInt32) {
        let value = registers.read(.cr)
        registers.write(.cr, value: (value & ~clear) | set)
    }

    private mutating func feed(_ buffer: UnsafeRawBufferPointer) -> UInt32 {
        let elementWidth: Int
        switch inputDataFormat {
        case .undefined: return 0
        case .bytes: elementWidth = 1
        case .halfwords: elementWidth = 2
        case .words: elementWidth = 4
        }
        precondition(buffer.count % elementWidth == 0)
        precondition(buffer.isEmpty || UInt(bitPattern: buffer.baseAddress!) % UInt(elementWidth) == 0)
        let count = buffer.count / elementWidth
        precondition(UInt64(count) <= UInt64(UInt32.max))
        switch inputDataFormat {
        case .words:
            for index in 0..<count {
                registers.write(.dr, value: buffer.load(fromByteOffset: index * 4, as: UInt32.self))
            }
        case .bytes:
            var index = 0
            while index < count / 4 {
                registers.write(.dr, value: (UInt32(buffer[4 * index]) << 24)
                    | (UInt32(buffer[4 * index + 1]) << 16)
                    | (UInt32(buffer[4 * index + 2]) << 8)
                    | UInt32(buffer[4 * index + 3]))
                index += 1
            }
            if count % 4 != 0 {
                if count % 4 == 1 {
                    registers.writeData8(buffer[4 * index])
                } else if count % 4 == 2 {
                    let data = (UInt16(buffer[4 * index]) << 8) | UInt16(buffer[4 * index + 1])
                    registers.writeData16(data)
                } else if count % 4 == 3 {
                    let data = (UInt16(buffer[4 * index]) << 8) | UInt16(buffer[4 * index + 1])
                    registers.writeData16(data)
                    registers.writeData8(buffer[4 * index + 2])
                }
            }
        case .halfwords:
            var index = 0
            while index < count / 2 {
                let first = buffer.load(fromByteOffset: 4 * index, as: UInt16.self)
                let second = buffer.load(fromByteOffset: 4 * index + 2, as: UInt16.self)
                registers.write(.dr, value: (UInt32(first) << 16) | UInt32(second))
                index += 1
            }
            if count % 2 != 0 {
                registers.writeData16(buffer.load(fromByteOffset: 4 * index, as: UInt16.self))
            }
        case .undefined: break
        }
        return registers.read(.dr)
    }
}
