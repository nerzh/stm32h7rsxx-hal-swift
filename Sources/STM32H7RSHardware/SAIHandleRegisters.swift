import STM32H7RSHAL
import _Volatile

public struct STM32SAIHandleRegisters: SAIHandleIO {
  private let wordsAddress: UInt
  private let pointersAddress: UInt

  // Caller-owned storage: 35 zeroed words and one zeroed native pointer.
  // Halfwords occupy the low 16 bits of slots 29 and 30; padding is untouched.
  // Keep both buffers alive across foreground, IRQ and DMA calls.
  public init(words: UnsafeMutableBufferPointer<UInt32>, pointers: UnsafeMutableBufferPointer<UInt>)
  {
    precondition(words.count >= 35 && pointers.count >= 1)
    wordsAddress = UInt(bitPattern: words.baseAddress!)
    pointersAddress = UInt(bitPattern: pointers.baseAddress!)
    precondition(wordsAddress & 3 == 0)
    precondition(pointersAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
  }
  private func slot(_ index: Int) -> VolatileMappedRegister<UInt32> {
    .init(unsafeBitPattern: wordsAddress + UInt(index) * 4)
  }
  public func read(_ word: SAIConfigurationWord) -> UInt32 { slot(word.rawValue).load() }
  public func write(_ word: SAIConfigurationWord, value: UInt32) {
    slot(word.rawValue).store(value)
  }
  public func read(_ word: SAIFrameWord) -> UInt32 { slot(20 + word.rawValue).load() }
  public func write(_ word: SAIFrameWord, value: UInt32) { slot(20 + word.rawValue).store(value) }
  public func read(_ word: SAISlotWord) -> UInt32 { slot(25 + word.rawValue).load() }
  public func write(_ word: SAISlotWord, value: UInt32) { slot(25 + word.rawValue).store(value) }
  public func read(_ word: SAIHandleHalfWord) -> UInt16 {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: wordsAddress + UInt(29 + word.rawValue) * 4)
      .load()
  }
  public func write(_ word: SAIHandleHalfWord, value: UInt16) {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: wordsAddress + UInt(29 + word.rawValue) * 4)
      .store(value)
  }
  public func read(_ word: SAIHandleWord) -> UInt32 { slot(31 + word.rawValue).load() }
  public func write(_ word: SAIHandleWord, value: UInt32) { slot(31 + word.rawValue).store(value) }
  public func readBuffer() -> UnsafeMutablePointer<UInt8>? {
    let address = pointersAddress
    let bits: UInt
    if MemoryLayout<UInt>.size == 4 {
      bits = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    } else {
      bits = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }
    return UnsafeMutablePointer<UInt8>(bitPattern: bits)
  }
  public func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?) {
    let address = pointersAddress
    let bits = UInt(bitPattern: value)
    if MemoryLayout<UInt>.size == 4 {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
    } else {
      VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits))
    }
  }
}
