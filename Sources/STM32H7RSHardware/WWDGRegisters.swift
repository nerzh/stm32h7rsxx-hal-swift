import STM32H7RSHAL
import _Volatile
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32WWDGRegisters: WWDGRegisterIO {
    public init() {}

    // The pinned SVD describes 16-bit registers here, while every field of
    // CMSIS WWDG_TypeDef is volatile uint32_t. Keep the C HAL's 32-bit
    // access width and use swift-stm32 to supply the verified register addresses.
    // CMSIS revision: 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
    static func address(_ register: WWDGRegister) -> UInt {
        switch register {
        case .cr: return wwdg.cr.unsafeAddress
        case .cfr: return wwdg.cfr.unsafeAddress
        case .sr: return wwdg.sr.unsafeAddress
        }
    }

    public func read(_ register: WWDGRegister) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: Self.address(register)).load()
    }

    public func write(_ register: WWDGRegister, value: UInt32) {

        VolatileMappedRegister<UInt32>(unsafeBitPattern: Self.address(register)).store(value)
    }
}

public struct STM32WWDGConfigurationRegisters: WWDGConfigurationIO {
    private let storageAddress: UInt

    // Four caller-owned UInt32 words, in WWDGConfigurationWord order.
    // Initialize them before use; immutable wrapper copies share these words.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 4)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition((storageAddress & 3) == 0)
    }

    public func read(_ word: WWDGConfigurationWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }

    public func write(_ word: WWDGConfigurationWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}

public struct STM32WWDGCallbackRegisters: WWDGCallbackIO {
    private let storageAddress: UInt
    public let context: UnsafeMutableRawPointer?

    // Two caller-owned, pointer-aligned words, initially zero: EWI and MSP init.
    // Slots and the opaque context must remain alive throughout callback use.
    public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
        precondition(storage.count >= 2)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
        self.context = context
    }

    public func read(_ id: WWDGCallbackID) -> WWDGCallback? {
        let address = storageAddress + UInt(id.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits: UInt
        if MemoryLayout<UInt>.size == 4 {
            bits = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
        } else {
            bits = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
        }
        return bits == 0 ? nil : unsafeBitCast(bits, to: WWDGCallback.self)
    }

    public func write(_ id: WWDGCallbackID, value: WWDGCallback?) {
        let address = storageAddress + UInt(id.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits = value.map { unsafeBitCast($0, to: UInt.self) } ?? 0
        if MemoryLayout<UInt>.size == 4 {
            VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
        } else {
            VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits))
        }
    }
}

public extension STM32H7RSHAL.WWDG where Registers == STM32WWDGRegisters {
    init(configuration: Configuration) {
        self.init(registers: STM32WWDGRegisters(), configuration: configuration)
    }
}
