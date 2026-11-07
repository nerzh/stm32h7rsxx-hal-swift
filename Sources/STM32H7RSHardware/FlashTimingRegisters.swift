import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32FlashTimingRegisters: FlashTimingRegisterIO {
    public init() {}

    public func read(_ register: FlashTimingRegister) -> UInt32 {
        switch register {
        case .acr: return flash.acr.read().raw.storage
        }
    }

    public func write(_ register: FlashTimingRegister, value: UInt32) {
        switch register {
        case .acr: flash.acr.write { $0.raw.storage = value }
        }
    }
}

public extension FlashTiming where IO == STM32FlashTimingRegisters {
    init() {
        self.init(registers: STM32FlashTimingRegisters())
    }
}
