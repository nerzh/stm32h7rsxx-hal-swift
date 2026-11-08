import STM32H7RSHAL
import _Volatile

public struct STM32CECCallbackRegisters: CECCallbackIO {
    private let storageAddress: UInt
    public let context: UnsafeMutableRawPointer?
    // Five initially nil native-width slots in CECCallbackID order.
    public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
        precondition(storage.count >= 5)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
        self.context = context
    }
    public func read(_ id: CECCallbackID) -> CECCallback? {
        precondition(id != .receiveComplete)
        let bits = readBits(id)
        return bits == 0 ? nil : unsafeBitCast(bits, to: CECCallback.self)
    }
    public func write(_ id: CECCallbackID, value: CECCallback?) {
        precondition(id != .receiveComplete)
        writeBits(id, value: value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
    }
    public func readReceive() -> CECReceiveCallback? {
        let bits = readBits(.receiveComplete)
        return bits == 0 ? nil : unsafeBitCast(bits, to: CECReceiveCallback.self)
    }
    public func writeReceive(_ value: CECReceiveCallback?) {
        writeBits(.receiveComplete, value: value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
    }
    private func readBits(_ id: CECCallbackID) -> UInt {
        let address = storageAddress + UInt(id.rawValue) * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 { return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load()) }
        return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }
    private func writeBits(_ id: CECCallbackID, value: UInt) {
        let address = storageAddress + UInt(id.rawValue) * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 { VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(value)) }
        else { VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(value)) }
    }
}
