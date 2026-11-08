import STM32H7RSHAL
import _Volatile

public struct STM32NANDHandleRegisters: NANDHandleIO {
  private let storageAddress: UInt
  // Sixteen caller-owned words: configuration (7), lock/state (2), device configuration (7).
  // Storage is shared with interrupt handlers and must outlive every driver wrapper.
  public init(storage: UnsafeMutableBufferPointer<UInt32>) {
    precondition(storage.count >= 16)
    storageAddress = UInt(bitPattern: storage.baseAddress!)
    precondition(storageAddress & 3 == 0)
  }
  public func read(_ word: NANDConfigurationWord) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(0 + word.rawValue) * 4)
      .load()
  }
  public func write(_ word: NANDConfigurationWord, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(0 + word.rawValue) * 4)
      .store(value)
  }
  public func read(_ word: NANDHandleWord) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(7 + word.rawValue) * 4)
      .load()
  }
  public func write(_ word: NANDHandleWord, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(7 + word.rawValue) * 4)
      .store(value)
  }
  public func read(_ word: NANDDeviceConfigurationWord) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(9 + word.rawValue) * 4)
      .load()
  }
  public func write(_ word: NANDDeviceConfigurationWord, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(9 + word.rawValue) * 4)
      .store(value)
  }
}
