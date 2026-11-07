import STM32H7RSHAL
import _Volatile

public struct STM32RNGCallbackRegisters: RNGCallbackIO {
    private let storageAddress: UInt
    public let context: UnsafeMutableRawPointer?

    // Four caller-owned, pointer-aligned words initially zero: error, MSP init,
    // MSP deinit, ready-data callback. These are thin C function pointers, not
    // Swift closure objects. The opaque context and storage must outlive use by
    // every copied foreground/IRQ handle. Registration follows the C HAL rules;
    // volatile accesses do not turn its lock into an atomic synchronization API.
    public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
        precondition(storage.count >= 4)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
        self.context = context
    }

    public func read(_ id: RNGCallbackID) -> RNGCallback? {
        let bits = readSlot(Int(id.rawValue))
        return bits == 0 ? nil : unsafeBitCast(bits, to: RNGCallback.self)
    }

    public func write(_ id: RNGCallbackID, value: RNGCallback?) {
        let bits = value.map { unsafeBitCast($0, to: UInt.self) } ?? 0
        writeSlot(Int(id.rawValue), bits)
    }

    public func readReadyDataCallback() -> RNGReadyDataCallback? {
        let bits = readSlot(3)
        return bits == 0 ? nil : unsafeBitCast(bits, to: RNGReadyDataCallback.self)
    }

    public func writeReadyDataCallback(_ callback: RNGReadyDataCallback?) {
        let bits = callback.map { unsafeBitCast($0, to: UInt.self) } ?? 0
        writeSlot(3, bits)
    }

    private func readSlot(_ index: Int) -> UInt {
        let address = storageAddress + UInt(index * MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 {
            return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
        }
        return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }

    private func writeSlot(_ index: Int, _ bits: UInt) {
        let address = storageAddress + UInt(index * MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 {
            VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
        } else {
            VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits))
        }
    }
}
