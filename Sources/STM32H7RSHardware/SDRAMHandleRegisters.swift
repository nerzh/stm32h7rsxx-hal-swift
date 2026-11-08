import STM32H7RSHAL
import _Volatile

public struct STM32SDRAMHandleRegisters: SDRAMHandleIO {
  private let storageAddress: UInt
  // 12 caller-owned words: configuration (10), followed by lock/state.
  // Storage must outlive every foreground/interrupt wrapper.
  public init(storage: UnsafeMutableBufferPointer<UInt32>) {
    precondition(storage.count >= 12)
    storageAddress = UInt(bitPattern: storage.baseAddress!)
    precondition(storageAddress & 3 == 0)
  }
  public func read(_ word: SDRAMConfigurationWord) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(0 + word.rawValue) * 4)
      .load()
  }
  public func write(_ word: SDRAMConfigurationWord, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(0 + word.rawValue) * 4)
      .store(value)
  }
  public func read(_ word: SDRAMHandleWord) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(10 + word.rawValue) * 4)
      .load()
  }
  public func write(_ word: SDRAMHandleWord, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(10 + word.rawValue) * 4)
      .store(value)
  }
}
