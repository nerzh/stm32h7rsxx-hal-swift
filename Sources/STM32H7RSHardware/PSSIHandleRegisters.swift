import STM32H7RSHAL
import _Volatile

public struct STM32PSSIHandleRegisters: PSSIHandleIO {
    private let storageAddress: UInt
    private let pointerAddress: UInt
    // Eleven caller-owned words plus one native-pointer-width slot, shared with IRQ handlers.
    public init(storage: UnsafeMutableBufferPointer<UInt32>, bufferPointer: UnsafeMutablePointer<UInt>) {
        precondition(storage.count >= 11)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        pointerAddress = UInt(bitPattern: bufferPointer)
        precondition(storageAddress & 3 == 0 && pointerAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
    }
    public func read(_ word: PSSIHandleWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }
    public func write(_ word: PSSIHandleWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
    public func readBuffer() -> UnsafeMutableRawPointer? {
        let bits: UInt
        if MemoryLayout<UInt>.size == 4 { bits = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: pointerAddress).load()) }
        else { bits = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: pointerAddress).load()) }
        return UnsafeMutableRawPointer(bitPattern: bits)
    }
    public func writeBuffer(_ buffer: UnsafeMutableRawPointer?) {
        let bits = UInt(bitPattern: buffer)
        if MemoryLayout<UInt>.size == 4 { VolatileMappedRegister<UInt32>(unsafeBitPattern: pointerAddress).store(UInt32(bits)) }
        else { VolatileMappedRegister<UInt64>(unsafeBitPattern: pointerAddress).store(UInt64(bits)) }
    }
}
