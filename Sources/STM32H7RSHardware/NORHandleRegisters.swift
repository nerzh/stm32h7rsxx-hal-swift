import STM32H7RSHAL
import _Volatile

public struct STM32NORHandleRegisters: NORHandleIO {
  private let storageAddress: UInt
  // Eighteen caller-owned words: configuration (15), lock/state/command set (3).
  // Storage is shared with interrupt handlers and must outlive every wrapper.
  public init(storage: UnsafeMutableBufferPointer<UInt32>) {
    precondition(storage.count >= 18)
    storageAddress = UInt(bitPattern: storage.baseAddress!)
    precondition(storageAddress & 3 == 0)
  }
  public func read(_ word: NORConfigurationWord) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(0 + word.rawValue) * 4)
      .load()
  }
  public func write(_ word: NORConfigurationWord, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(0 + word.rawValue) * 4)
      .store(value)
  }
  public func read(_ word: NORHandleWord) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(15 + word.rawValue) * 4)
      .load()
  }
  public func write(_ word: NORHandleWord, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(15 + word.rawValue) * 4)
      .store(value)
  }
}
