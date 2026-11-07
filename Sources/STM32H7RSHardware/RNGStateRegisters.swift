import STM32H7RSHAL
import _Volatile

public struct STM32RNGStateRegisters: RNGStateIO {
    private let storageAddress: UInt

    // Five caller-owned, word-aligned words: clock error detection, lock, state,
    // error code, last random number. Initialize all to zero before first use.
    // Keep storage alive for foreground and ISR handles; copies share storage.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 5)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition((storageAddress & 3) == 0)
    }

    public func read(_ word: RNGHandleWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }

    public func write(_ word: RNGHandleWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}
