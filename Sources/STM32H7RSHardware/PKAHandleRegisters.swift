import STM32H7RSHAL
import _Volatile

public struct STM32PKAHandleRegisters: PKAHandleIO {
    private let storageAddress: UInt
    // Five caller-owned UInt32 words in PKAHandleWord order.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 5)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress & 3 == 0)
    }
    public func read(_ word: PKAHandleWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }
    public func write(_ word: PKAHandleWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}
