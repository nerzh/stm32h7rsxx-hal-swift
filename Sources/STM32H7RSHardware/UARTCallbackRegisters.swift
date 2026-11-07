import STM32H7RSHAL
import _Volatile

public struct STM32UARTCallbackRegisters: UARTCallbackIO {
    private let storageAddress: UInt
    public let context: UnsafeMutableRawPointer?

    // Fourteen initially nil native-width slots: 13 UARTCallbackID functions,
    // followed by the differently typed RxEvent callback. Storage is unowned.
    public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
        precondition(storage.count >= 14)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
        self.context = context
    }
    private func readBits(_ index: UInt32) -> UInt {
        let address = storageAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 {
            return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
        }
        return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }
    private func writeBits(_ index: UInt32, _ bits: UInt) {
        let address = storageAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 {
            VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
        } else { VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits)) }
    }
    public func read(_ id: UARTCallbackID) -> UARTCallback? {
        let bits = readBits(id.rawValue)
        return bits == 0 ? nil : unsafeBitCast(bits, to: UARTCallback.self)
    }
    public func write(_ id: UARTCallbackID, value: UARTCallback?) {
        writeBits(id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
    }
    public func readRxEventCallback() -> UARTRxEventCallback? {
        let bits = readBits(13)
        return bits == 0 ? nil : unsafeBitCast(bits, to: UARTRxEventCallback.self)
    }
    public func writeRxEventCallback(_ value: UARTRxEventCallback?) {
        writeBits(13, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
    }
}

// UARTDMACallbackContext.dmaContext points to the existing DMA callback buffer
// (six UInt slots). Read its live Parent through the same volatile adapter.
public func stm32UARTDMAReadParent(_ storage: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    precondition(storage != nil)
    return STM32DMACallbackRegisters(storage: .init(start: storage!.assumingMemoryBound(to: UInt.self), count: 6)).readParent()
}
