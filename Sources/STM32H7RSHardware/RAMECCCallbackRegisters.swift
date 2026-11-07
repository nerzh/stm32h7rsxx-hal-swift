import STM32H7RSHAL
import _Volatile

public struct STM32RAMECCCallbackRegisters: RAMECCCallbackIO {
    private let storageAddress: UInt
    public let context: UnsafeMutableRawPointer?

    // Four initially zero, native-pointer-width slots: MSP init, MSP deinit,
    // single error, double error. Functions, context and storage are unowned.
    public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
        precondition(storage.count >= 4)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
        self.context = context
    }

    public func read(_ id: RAMECCCallbackID) -> RAMECCCallback? {
        precondition(id != .all)
        let address = storageAddress + UInt(id.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits: UInt
        if MemoryLayout<UInt>.size == 4 {
            bits = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
        } else { bits = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load()) }
        return bits == 0 ? nil : unsafeBitCast(bits, to: RAMECCCallback.self)
    }

    public func write(_ id: RAMECCCallbackID, value: RAMECCCallback?) {
        precondition(id != .all)
        let address = storageAddress + UInt(id.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits = value.map { unsafeBitCast($0, to: UInt.self) } ?? 0
        if MemoryLayout<UInt>.size == 4 {
            VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
        } else { VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits)) }
    }
}
