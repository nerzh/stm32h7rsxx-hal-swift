import STM32H7RSHAL
import _Volatile

public struct STM32DMACallbackRegisters: DMACallbackIO {
    private let storageAddress: UInt
    public let context: UnsafeMutableRawPointer?

    // Six initially zero, native-pointer-width slots: complete, half complete,
    // error, abort, suspend, Parent. Context is separate and is never reset by
    // deinitialize. Function pointers, context, Parent and storage are unowned.
    public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
        precondition(storage.count >= 6)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
        self.context = context
    }

    public func read(_ id: DMACallbackID) -> DMACallback? {
        precondition(id != .all)
        let bits = readSlot(Int(id.rawValue))
        return bits == 0 ? nil : unsafeBitCast(bits, to: DMACallback.self)
    }

    public func write(_ id: DMACallbackID, value: DMACallback?) {
        precondition(id != .all)
        writeSlot(Int(id.rawValue), value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
    }

    public func readParent() -> UnsafeMutableRawPointer? {
        UnsafeMutableRawPointer(bitPattern: readSlot(5))
    }

    public func writeParent(_ value: UnsafeMutableRawPointer?) {
        writeSlot(5, value.map { UInt(bitPattern: $0) } ?? 0)
    }

    private func readSlot(_ index: Int) -> UInt {
        let address = storageAddress + UInt(index * MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 {
            return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
        }
        return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }

    private func writeSlot(_ index: Int, _ value: UInt) {
        let address = storageAddress + UInt(index * MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 {
            VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(value))
        } else {
            VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(value))
        }
    }
}
