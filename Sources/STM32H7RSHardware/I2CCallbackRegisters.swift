import STM32H7RSHAL
import _Volatile

public struct STM32I2CCallbackRegisters: I2CCallbackIO {
  private let storageAddress: UInt
  public let context: UnsafeMutableRawPointer?

  // Twelve initially nil native-width slots: 11 I2CCallbackID functions,
  // followed by the differently typed address callback. Storage is unowned.
  public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
    precondition(storage.count >= 12)
    storageAddress = UInt(bitPattern: storage.baseAddress!)
    precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
    self.context = context
  }
  private func readBits(_ index: UInt32) -> UInt {
    let address = storageAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
    if MemoryLayout<UInt>.size == 4 {
      return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    }
    return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
  }
  private func writeBits(_ index: UInt32, _ bits: UInt) {
    let address = storageAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
    if MemoryLayout<UInt>.size == 4 {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
    } else {
      VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits))
    }
  }
  public func read(_ id: I2CCallbackID) -> I2CCallback? {
    let bits = readBits(id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I2CCallback.self)
  }
  public func write(_ id: I2CCallbackID, value: I2CCallback?) {
    writeBits(id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readAddress() -> I2CAddressCallback? {
    let bits = readBits(11)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I2CAddressCallback.self)
  }
  public func writeAddress(_ value: I2CAddressCallback?) {
    writeBits(11, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
}
