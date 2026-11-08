import STM32H7RSHAL
import _Volatile

public struct STM32MDFSharedRegisters: MDFSharedIO {
    private let address: UInt
    // One initially zero native-width slot, shared by every MDF handle.
    // The slot and every registered handle's storage remain caller-owned.
    public init(registeredHandle: UnsafeMutablePointer<UInt>) {
        address = UInt(bitPattern: registeredHandle)
        precondition(address % UInt(MemoryLayout<UInt>.alignment) == 0)
    }
    public func readRegisteredHandle() -> UInt {
        if MemoryLayout<UInt>.size == 4 { return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load()) }
        return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }
    public func writeRegisteredHandle(_ identity: UInt) {
        if MemoryLayout<UInt>.size == 4 { VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(identity)) }
        else { VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(identity)) }
    }
}
