import STM32H7RSHAL
import _Volatile

public struct STM32SMBUSCallbackRegisters: SMBUSCallbackIO {
  private let storageAddress: UInt
  public let context: UnsafeMutableRawPointer?

  // Nine initially nil native-width slots: 8 SMBUSCallbackID functions,
  // followed by the differently typed address callback. Storage is unowned.
  public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
    precondition(storage.count >= 9)
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
  public func read(_ id: SMBUSCallbackID) -> SMBUSCallback? {
    let bits = readBits(id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SMBUSCallback.self)
  }
  public func write(_ id: SMBUSCallbackID, value: SMBUSCallback?) {
    writeBits(id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readAddress() -> SMBUSAddressCallback? {
    let bits = readBits(8)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SMBUSAddressCallback.self)
  }
  public func writeAddress(_ value: SMBUSAddressCallback?) {
    writeBits(8, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
}
