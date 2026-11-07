import STM32H7RSHAL

public struct STM32HASHMemory: HASHMemoryIO {
    public init() {}
    public func read8(at address: UInt32) -> UInt8 { STM32FlashMemory().read8(at: address) }
    public func read16(at address: UInt32) -> UInt16 { STM32FlashMemory().read16(at: address) }
    public func read32(at address: UInt32) -> UInt32 { STM32DMAMemory().read32(at: address) }
    public func write32(at address: UInt32, value: UInt32) {
        STM32DMAMemory().write32(at: address, value: value)
    }
}
