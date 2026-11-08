import STM32H7RSHAL
import _Volatile

public struct STM32JPEGCallbackRegisters: JPEGCallbackIO {
    private let storageAddress: UInt
    public let context: UnsafeMutableRawPointer?
    // Nine initially zero native-width slots: slot 0 unused, IDs 1...5, info/get/data in 6...8.
    public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
        precondition(storage.count >= 9)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
        self.context = context
    }
    public func read(_ id: JPEGCallbackID) -> JPEGCallback? {
        let bits = readBits(Int(id.rawValue)); return bits == 0 ? nil : unsafeBitCast(bits, to: JPEGCallback.self)
    }
    public func write(_ id: JPEGCallbackID, value: JPEGCallback?) { writeBits(Int(id.rawValue), value: value.map { unsafeBitCast($0, to: UInt.self) } ?? 0) }
    public func readInfoReady() -> JPEGInfoReadyCallback? {
        let bits = readBits(6); return bits == 0 ? nil : unsafeBitCast(bits, to: JPEGInfoReadyCallback.self)
    }
    public func writeInfoReady(_ value: JPEGInfoReadyCallback?) { writeBits(6, value: value.map { unsafeBitCast($0, to: UInt.self) } ?? 0) }
    public func readGetData() -> JPEGGetDataCallback? {
        let bits = readBits(7); return bits == 0 ? nil : unsafeBitCast(bits, to: JPEGGetDataCallback.self)
    }
    public func writeGetData(_ value: JPEGGetDataCallback?) { writeBits(7, value: value.map { unsafeBitCast($0, to: UInt.self) } ?? 0) }
    public func readDataReady() -> JPEGDataReadyCallback? {
        let bits = readBits(8); return bits == 0 ? nil : unsafeBitCast(bits, to: JPEGDataReadyCallback.self)
    }
    public func writeDataReady(_ value: JPEGDataReadyCallback?) { writeBits(8, value: value.map { unsafeBitCast($0, to: UInt.self) } ?? 0) }
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
