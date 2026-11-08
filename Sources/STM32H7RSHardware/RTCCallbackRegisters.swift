import STM32H7RSHAL
import _Volatile

public struct STM32RTCCallbackRegisters: RTCCallbackIO {
    private let storageAddress: UInt
    public let context: UnsafeMutableRawPointer?
    // Twenty-six initially zero native-width callback slots in RTCCallbackID order.
    public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
        precondition(storage.count >= 26)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
        self.context = context
    }
    public func read(_ id: RTCCallbackID) -> RTCCallback? {
        let bits = readBits(Int(id.rawValue)); return bits == 0 ? nil : unsafeBitCast(bits, to: RTCCallback.self)
    }
    public func write(_ id: RTCCallbackID, value: RTCCallback?) { writeBits(Int(id.rawValue), value: value.map { unsafeBitCast($0, to: UInt.self) } ?? 0) }
    private func readBits(_ index: Int) -> UInt {
        let address = storageAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 { return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load()) }
        return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }
    private func writeBits(_ index: Int, value: UInt) {
        let address = storageAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 { VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(value)) }
        else { VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(value)) }
    }
}
