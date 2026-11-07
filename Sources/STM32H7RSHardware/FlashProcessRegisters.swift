import STM32H7RSHAL
import _Volatile

public struct STM32FlashProcessRegisters: FlashProcessIO {
    private let storageAddress: UInt

    // One shared six-word buffer replaces the C driver's global pFlash object.
    // Initialize it to zero and retain it across foreground and interrupt calls.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 6)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress & 3 == 0)
    }
    public func read(_ word: FlashProcessWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }
    public func write(_ word: FlashProcessWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}
