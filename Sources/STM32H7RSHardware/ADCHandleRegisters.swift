import STM32H7RSHAL
import _Volatile

public struct STM32ADCHandleRegisters: ADCHandleIO {
    private let storageAddress: UInt
    // Twenty-five caller-owned UInt32 words in ADCHandleWord order.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 25)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress & 3 == 0)
    }
    public func read(_ word: ADCHandleWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }
    public func write(_ word: ADCHandleWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}
