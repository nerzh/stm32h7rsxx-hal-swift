import STM32H7RSHAL
import _Volatile

public struct STM32ETHCallbackRegisters: ETHCallbackIO {
  private let storageAddress: UInt
  public let context: UnsafeMutableRawPointer?

  // Thirteen initially nil native-width slots; slot 5 is reserved. Storage is unowned.
  public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
    precondition(storage.count >= 13)
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
  public func read(_ id: ETHCallbackID) -> ETHCallback? {
    let bits = readBits(id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: ETHCallback.self)
  }
  public func write(_ id: ETHCallbackID, value: ETHCallback?) {
    writeBits(id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readReceiveAllocate() -> ETHReceiveAllocateCallback? {
    let bits = readBits(9)
    return bits == 0 ? nil : unsafeBitCast(bits, to: ETHReceiveAllocateCallback.self)
  }
  public func writeReceiveAllocate(_ value: ETHReceiveAllocateCallback?) {
    writeBits(9, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readReceiveLink() -> ETHReceiveLinkCallback? {
    let bits = readBits(10)
    return bits == 0 ? nil : unsafeBitCast(bits, to: ETHReceiveLinkCallback.self)
  }
  public func writeReceiveLink(_ value: ETHReceiveLinkCallback?) {
    writeBits(10, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readTransmitFree() -> ETHTransmitFreeCallback? {
    let bits = readBits(11)
    return bits == 0 ? nil : unsafeBitCast(bits, to: ETHTransmitFreeCallback.self)
  }
  public func writeTransmitFree(_ value: ETHTransmitFreeCallback?) {
    writeBits(11, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readTransmitPTP() -> ETHTransmitPTPCallback? {
    let bits = readBits(12)
    return bits == 0 ? nil : unsafeBitCast(bits, to: ETHTransmitPTPCallback.self)
  }
  public func writeTransmitPTP(_ value: ETHTransmitPTPCallback?) {
    writeBits(12, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
}
