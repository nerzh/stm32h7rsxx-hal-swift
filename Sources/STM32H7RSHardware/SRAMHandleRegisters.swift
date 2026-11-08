import STM32H7RSHAL
import _Volatile

public struct STM32SRAMHandleRegisters: SRAMHandleIO {
  private let storageAddress: UInt
  // 17 caller-owned words: configuration (15), followed by lock/state.
  // Storage must outlive every foreground/interrupt wrapper.
  public init(storage: UnsafeMutableBufferPointer<UInt32>) {
    precondition(storage.count >= 17)
    storageAddress = UInt(bitPattern: storage.baseAddress!)
    precondition(storageAddress & 3 == 0)
  }
  public func read(_ word: SRAMConfigurationWord) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(0 + word.rawValue) * 4)
      .load()
  }
  public func write(_ word: SRAMConfigurationWord, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(0 + word.rawValue) * 4)
      .store(value)
  }
  public func read(_ word: SRAMHandleWord) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(15 + word.rawValue) * 4)
      .load()
  }
  public func write(_ word: SRAMHandleWord, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(15 + word.rawValue) * 4)
      .store(value)
  }
}
