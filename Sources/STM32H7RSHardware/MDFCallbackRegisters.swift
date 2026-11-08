import STM32H7RSHAL
import _Volatile

public struct STM32MDFCallbackRegisters: MDFCallbackIO {
    private let storageAddress: UInt
    public let context: UnsafeMutableRawPointer?
    // Eight initially nil native-width slots in MDFCallbackID order.
    public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
        precondition(storage.count >= 8)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
        self.context = context
    }
    public func read(_ id: MDFCallbackID) -> MDFCallback? {
        precondition(id != .soundLevel)
        let bits = readBits(id)
        return bits == 0 ? nil : unsafeBitCast(bits, to: MDFCallback.self)
    }
    public func write(_ id: MDFCallbackID, value: MDFCallback?) {
        precondition(id != .soundLevel)
        writeBits(id, value: value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
    }
    public func readSoundLevel() -> MDFSoundLevelCallback? {
        let bits = readBits(.soundLevel)
        return bits == 0 ? nil : unsafeBitCast(bits, to: MDFSoundLevelCallback.self)
    }
    public func writeSoundLevel(_ value: MDFSoundLevelCallback?) {
        writeBits(.soundLevel, value: value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
    }
    private func readBits(_ id: MDFCallbackID) -> UInt {
        let address = storageAddress + UInt(id.rawValue) * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 { return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load()) }
        return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }
    private func writeBits(_ id: MDFCallbackID, value: UInt) {
        let address = storageAddress + UInt(id.rawValue) * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 { VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(value)) }
        else { VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(value)) }
    }
}
