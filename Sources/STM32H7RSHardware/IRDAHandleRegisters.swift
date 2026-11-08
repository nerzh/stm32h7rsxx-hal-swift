import STM32H7RSHAL
import _Volatile

public struct STM32IRDAHandleRegisters: IRDAHandleIO {
  private let wordsAddress: UInt
  private let pointersAddress: UInt
  // Caller-owned storage: 16 zeroed UInt32 slots plus two native-width pointer slots.
  // Narrow C fields occupy the low byte/halfword of their slot; padding is untouched.
  public init(words: UnsafeMutableBufferPointer<UInt32>, pointers: UnsafeMutableBufferPointer<UInt>)
  {
    precondition(words.count >= 16 && pointers.count >= 2)
    wordsAddress = UInt(bitPattern: words.baseAddress!)
    pointersAddress = UInt(bitPattern: pointers.baseAddress!)
    precondition(wordsAddress & 3 == 0)
    precondition(pointersAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
  }
  public func read(_ word: IRDAConfigurationWord) -> UInt32 {
    let address = wordsAddress + UInt(0 + word.rawValue) * 4
    if word == .prescaler {
      return UInt32(VolatileMappedRegister<UInt8>(unsafeBitPattern: address).load())
    }
    if word == .powerMode {
      return UInt32(VolatileMappedRegister<UInt16>(unsafeBitPattern: address).load())
    }
    if word == .baudRate || word == .wordLength || word == .parity || word == .mode
      || word == .clockPrescaler
    {
      return UInt32(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    }
    preconditionFailure("Unknown field")
  }
  public func write(_ word: IRDAConfigurationWord, value: UInt32) {
    let address = wordsAddress + UInt(0 + word.rawValue) * 4
    if word == .prescaler {
      VolatileMappedRegister<UInt8>(unsafeBitPattern: address).store(
        UInt8(truncatingIfNeeded: value))
      return
    }
    if word == .powerMode {
      VolatileMappedRegister<UInt16>(unsafeBitPattern: address).store(
        UInt16(truncatingIfNeeded: value))
      return
    }
    if word == .baudRate || word == .wordLength || word == .parity || word == .mode
      || word == .clockPrescaler
    {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(
        UInt32(truncatingIfNeeded: value))
      return
    }
  }
  public func read(_ word: IRDAHandleHalfWord) -> UInt16 {
    let address = wordsAddress + UInt(7 + word.rawValue) * 4
    return UInt16(VolatileMappedRegister<UInt16>(unsafeBitPattern: address).load())
  }
  public func write(_ word: IRDAHandleHalfWord, value: UInt16) {
    let address = wordsAddress + UInt(7 + word.rawValue) * 4
    VolatileMappedRegister<UInt16>(unsafeBitPattern: address).store(
      UInt16(truncatingIfNeeded: value))
  }
  public func read(_ word: IRDAHandleWord) -> UInt32 {
    let address = wordsAddress + UInt(12 + word.rawValue) * 4
    return UInt32(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
  }
  public func write(_ word: IRDAHandleWord, value: UInt32) {
    let address = wordsAddress + UInt(12 + word.rawValue) * 4
    VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(
      UInt32(truncatingIfNeeded: value))
  }
  public func readPointer(_ pointer: UARTBufferPointer) -> UnsafeMutableRawPointer? {
    let address = pointersAddress + UInt(pointer.rawValue) * UInt(MemoryLayout<UInt>.stride)
    let bits: UInt
    if MemoryLayout<UInt>.size == 4 {
      bits = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    } else {
      bits = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }
    return UnsafeMutableRawPointer(bitPattern: bits)
  }
  public func writePointer(_ pointer: UARTBufferPointer, value: UnsafeMutableRawPointer?) {
    let address = pointersAddress + UInt(pointer.rawValue) * UInt(MemoryLayout<UInt>.stride)
    let bits = UInt(bitPattern: value)
    if MemoryLayout<UInt>.size == 4 {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
    } else {
      VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits))
    }
  }
}
