import STM32H7RSHAL
import _Volatile

public struct STM32HCDCallbackRegisters: HCDCallbackIO {
  private let storageAddress: UInt
  public let context: UnsafeMutableRawPointer?

  // 8 initially nil native-width callback slots. Storage is unowned.
  public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
    precondition(storage.count >= 8)
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
  public func read(_ id: HCDCallbackID) -> USBCallback? {
    let bits = readBits(id.rawValue - 1)
    return bits == 0 ? nil : unsafeBitCast(bits, to: USBCallback.self)
  }
  public func write(_ id: HCDCallbackID, value: USBCallback?) {
    writeBits(id.rawValue - 1, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readURB() -> HCDURBCallback? {
    let bits = readBits(7)
    return bits == 0 ? nil : unsafeBitCast(bits, to: HCDURBCallback.self)
  }
  public func writeURB(_ value: HCDURBCallback?) {
    writeBits(7, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
}
