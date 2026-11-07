import STM32H7RSHAL
import _Volatile

public struct STM32DCMIPPHandleRegisters: DCMIPPHandleIO {
    private let storageAddress: UInt

    // Caller-owned 3-word storage shared by foreground and IRQ callbacks.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 3)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress & 3 == 0)
    }
    public func read(_ word: DCMIPPHandleWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }
    public func write(_ word: DCMIPPHandleWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}
