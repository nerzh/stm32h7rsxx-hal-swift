import STM32H7RSHAL
import _Volatile
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32IWDGRegisters: IWDGRegisterIO {
    public init() {}

    // The pinned SVD describes 16-bit registers here, while every field of
    // CMSIS IWDG_TypeDef is volatile uint32_t. Keep the C HAL's 32-bit
    // access width and use swift-stm32 to supply the verified register addresses.
    // CMSIS revision: 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
    static func address(_ register: IWDGRegister) -> UInt {
        switch register {
        case .kr: return iwdg.kr.unsafeAddress
        case .pr: return iwdg.pr.unsafeAddress
        case .rlr: return iwdg.rlr.unsafeAddress
        case .sr: return iwdg.sr.unsafeAddress
        case .winr: return iwdg.winr.unsafeAddress
        case .ewcr: return iwdg.ewcr.unsafeAddress
        }
    }

    public func read(_ register: IWDGRegister) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: Self.address(register)).load()
    }

    public func write(_ register: IWDGRegister, value: UInt32) {
        precondition(register != .sr, "IWDG status register is read-only")
        VolatileMappedRegister<UInt32>(unsafeBitPattern: Self.address(register)).store(value)
    }
}

public struct STM32IWDGConfigurationRegisters: IWDGConfigurationIO {
    private let storageAddress: UInt

    // Four caller-owned UInt32 words, in IWDGConfigurationWord order.
    // Initialize them before use; immutable wrapper copies share these words.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 4)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition((storageAddress & 3) == 0)
    }

    public func read(_ word: IWDGConfigurationWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }

    public func write(_ word: IWDGConfigurationWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}

public struct STM32IWDGCallbackRegisters: IWDGCallbackIO {
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

    public func read(_ id: IWDGCallbackID) -> IWDGCallback? {
        let address = storageAddress + UInt(id.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits: UInt
        if MemoryLayout<UInt>.size == 4 {
            bits = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
        } else {
            bits = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
        }
        return bits == 0 ? nil : unsafeBitCast(bits, to: IWDGCallback.self)
    }

    public func write(_ id: IWDGCallbackID, value: IWDGCallback?) {
        let address = storageAddress + UInt(id.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits = value.map { unsafeBitCast($0, to: UInt.self) } ?? 0
        if MemoryLayout<UInt>.size == 4 {
            VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
        } else {
            VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits))
        }
    }
}

public extension STM32H7RSHAL.IWDG where Registers == STM32IWDGRegisters {
    init(configuration: Configuration, timing: IWDGTiming = .init()) {
        self.init(registers: STM32IWDGRegisters(), configuration: configuration, timing: timing)
    }
}
