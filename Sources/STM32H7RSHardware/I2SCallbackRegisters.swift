import STM32H7RSHAL
import _Volatile

public struct STM32I2SCallbackRegisters: I2SCallbackIO {
  private let storageAddress: UInt
  public let context: UnsafeMutableRawPointer?

  // Nine initially nil native-width I2SCallbackID slots. Storage is unowned.
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
  public func read(_ id: I2SCallbackID) -> I2SCallback? {
    let bits = readBits(id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I2SCallback.self)
  }
  public func write(_ id: I2SCallbackID, value: I2SCallback?) {
    writeBits(id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
}
