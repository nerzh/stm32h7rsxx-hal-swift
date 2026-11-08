import STM32H7RSHAL
import _Volatile

public struct STM32I3CHandleRegisters: I3CHandleIO {
  private let wordsAddress: UInt
  private let pointersAddress: UInt

  // Caller-owned storage: 20 zeroed UInt32 slots and three zeroed UInt slots.
  // Configuration slots 2...8 contain bytes; their upper padding is untouched.
  // Transfer and descriptor pointers must outlive pending operations and callbacks.
  public init(words: UnsafeMutableBufferPointer<UInt32>, pointers: UnsafeMutableBufferPointer<UInt>)
  {
    precondition(words.count >= 20 && pointers.count >= 3)
    wordsAddress = UInt(bitPattern: words.baseAddress!)
    pointersAddress = UInt(bitPattern: pointers.baseAddress!)
    precondition(wordsAddress & 3 == 0)
    precondition(pointersAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
  }
  private func slot(_ index: Int) -> VolatileMappedRegister<UInt32> {
    .init(unsafeBitPattern: wordsAddress + UInt(index) * 4)
  }
  public func read(_ word: I3CConfigurationWord) -> UInt32 {
    if word.rawValue >= 2 {
      return UInt32(
        VolatileMappedRegister<UInt8>(unsafeBitPattern: wordsAddress + UInt(word.rawValue) * 4)
          .load())
    }
    return slot(word.rawValue).load()
  }
  public func write(_ word: I3CConfigurationWord, value: UInt32) {
    if word.rawValue >= 2 {
      VolatileMappedRegister<UInt8>(unsafeBitPattern: wordsAddress + UInt(word.rawValue) * 4).store(
        UInt8(truncatingIfNeeded: value))
    } else {
      slot(word.rawValue).store(value)
    }
  }
  public func read(_ word: I3CHandleWord) -> UInt32 { slot(9 + word.rawValue).load() }
  public func write(_ word: I3CHandleWord, value: UInt32) { slot(9 + word.rawValue).store(value) }
  private func readPointer(_ index: Int) -> UInt {
    let address = pointersAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
    if MemoryLayout<UInt>.size == 4 {
      return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    }
    return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
  }
  private func writePointer(_ index: Int, _ bits: UInt) {
    let address = pointersAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
    if MemoryLayout<UInt>.size == 4 {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
    } else {
      VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits))
    }
  }
  public func readTransfer() -> UnsafeMutablePointer<I3CTransfer>? {
    UnsafeMutablePointer<I3CTransfer>(bitPattern: readPointer(0))
  }
  public func writeTransfer(_ value: UnsafeMutablePointer<I3CTransfer>?) {
    writePointer(0, UInt(bitPattern: value))
  }
  public func readCCCDescriptors() -> UnsafePointer<I3CCCCDescriptor>? {
    UnsafePointer<I3CCCCDescriptor>(bitPattern: readPointer(1))
  }
  public func writeCCCDescriptors(_ value: UnsafePointer<I3CCCCDescriptor>?) {
    writePointer(1, UInt(bitPattern: value))
  }
  public func readPrivateDescriptors() -> UnsafePointer<I3CPrivateDescriptor>? {
    UnsafePointer<I3CPrivateDescriptor>(bitPattern: readPointer(2))
  }
  public func writePrivateDescriptors(_ value: UnsafePointer<I3CPrivateDescriptor>?) {
    writePointer(2, UInt(bitPattern: value))
  }
}
