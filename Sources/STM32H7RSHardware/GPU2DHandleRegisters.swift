import STM32H7RSHAL
import _Volatile

public struct STM32GPU2DHandleRegisters: GPU2DHandleIO {
    private let storageAddress: UInt

    // Caller-owned 3-word storage shared by foreground and IRQ callbacks.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 3)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress & 3 == 0)
    }
    public func read(_ word: GPU2DHandleWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }
    public func write(_ word: GPU2DHandleWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}
