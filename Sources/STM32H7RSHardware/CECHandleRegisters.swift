import STM32H7RSHAL
import _Volatile

public struct STM32CECHandleRegisters: CECHandleIO {
    private let storageAddress: UInt
    private let pointerAddress: UInt
    // Twelve full words, three halfword values in UInt32 slots, two native pointers.
    // Both buffers are caller-owned and shared with the interrupt handler.
    public init(storage: UnsafeMutableBufferPointer<UInt32>, pointers: UnsafeMutableBufferPointer<UInt>) {
        precondition(storage.count >= 15 && pointers.count >= 2)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        pointerAddress = UInt(bitPattern: pointers.baseAddress!)
        precondition(storageAddress & 3 == 0 && pointerAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
    }
    public func read(_ word: CECHandleWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }
    public func write(_ word: CECHandleWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
    public func read(_ word: CECHandleHalfWord) -> UInt16 {
        UInt16(truncatingIfNeeded: VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue + 12) * 4).load())
    }
    public func write(_ word: CECHandleHalfWord, value: UInt16) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue + 12) * 4).store(UInt32(value))
    }
    public func readPointer(_ pointer: CECBufferPointer) -> UnsafeMutableRawPointer? {
        let address = pointerAddress + UInt(pointer.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits: UInt
        if MemoryLayout<UInt>.size == 4 { bits = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load()) }
        else { bits = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load()) }
        return UnsafeMutableRawPointer(bitPattern: bits)
    }
    public func writePointer(_ pointer: CECBufferPointer, value: UnsafeMutableRawPointer?) {
        let address = pointerAddress + UInt(pointer.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits = value.map { UInt(bitPattern: $0) } ?? 0
        if MemoryLayout<UInt>.size == 4 { VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits)) }
        else { VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits)) }
    }
}
