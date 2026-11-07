import STM32H7RSHAL
import _Volatile

public struct STM32RAMECCStateRegisters: RAMECCStateIO {
    private let storageAddress: UInt

    // Two caller-owned, word-aligned words: state and error code, initially zero.
    // Keep storage alive for every foreground and interrupt wrapper copy.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 2)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress & 3 == 0)
    }

    public func read(_ word: RAMECCHandleWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }
    public func write(_ word: RAMECCHandleWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}
