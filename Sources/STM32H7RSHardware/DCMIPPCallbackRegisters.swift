import STM32H7RSHAL
import _Volatile

public struct STM32DCMIPPCallbackRegisters: DCMIPPCallbackIO {
    private let storageAddress: UInt
    public let context: UnsafeMutableRawPointer?

    // Eight initially nil native-width slots: three common callbacks, then five pipe callbacks.
    // Both function storage and the callback context are unowned.
    public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
        precondition(storage.count >= 8)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
        self.context = context
    }
    public func read(_ id: DCMIPPCallbackID) -> DCMIPPCallback? {
        let bits = load(UInt(id.rawValue))
        return bits == 0 ? nil : unsafeBitCast(bits, to: DCMIPPCallback.self)
    }
    public func write(_ id: DCMIPPCallbackID, value: DCMIPPCallback?) {
        store(UInt(id.rawValue), value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
    }
    public func read(_ id: DCMIPPPipeCallbackID) -> DCMIPPPipeCallback? {
        let bits = load(UInt(id.rawValue) + 2)
        return bits == 0 ? nil : unsafeBitCast(bits, to: DCMIPPPipeCallback.self)
    }
    public func write(_ id: DCMIPPPipeCallbackID, value: DCMIPPPipeCallback?) {
        store(UInt(id.rawValue) + 2, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
    }
    private func load(_ index: UInt) -> UInt {
        let address = storageAddress + index * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 {
            return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
        } else {
            return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
        }
    }
    private func store(_ index: UInt, _ bits: UInt) {
        let address = storageAddress + index * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 {
            VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
        } else {
            VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits))
        }
    }
}
