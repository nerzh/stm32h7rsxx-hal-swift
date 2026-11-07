import STM32H7RSHAL
import _Volatile

public struct STM32DMAMemory: DMAMemoryIO {
    public init() {}

    // The caller supplies real, accessible, aligned 32-bit target addresses.
    // DMA nodes and queues must remain allocated while the driver uses them.
    public func read32(at address: UInt32) -> UInt32 {
        precondition((address & 3) == 0)
        return VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address)).load()
    }

    public func write32(at address: UInt32, value: UInt32) {
        precondition((address & 3) == 0)
        VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address)).store(value)
    }
}
