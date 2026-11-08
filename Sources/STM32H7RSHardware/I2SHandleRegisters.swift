import STM32H7RSHAL
import _Volatile

public struct STM32I2SHandleRegisters: I2SHandleIO {
  private let wordsAddress: UInt
  private let pointersAddress: UInt

  // Caller-owned storage: 19 zeroed UInt32 slots and two zeroed UInt slots.
  // Halfword fields occupy the low 16 bits of slots 10...13; padding is untouched.
  // Keep both buffers alive across all foreground, IRQ and DMA calls.
  public init(words: UnsafeMutableBufferPointer<UInt32>, pointers: UnsafeMutableBufferPointer<UInt>)
  {
    precondition(words.count >= 19 && pointers.count >= 2)
    wordsAddress = UInt(bitPattern: words.baseAddress!)
    pointersAddress = UInt(bitPattern: pointers.baseAddress!)
    precondition(wordsAddress & 3 == 0)
    precondition(pointersAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
  }
  private func slot(_ index: Int) -> VolatileMappedRegister<UInt32> {
    .init(unsafeBitPattern: wordsAddress + UInt(index) * 4)
  }
  public func read(_ word: I2SConfigurationWord) -> UInt32 { slot(word.rawValue).load() }
  public func write(_ word: I2SConfigurationWord, value: UInt32) {
    slot(word.rawValue).store(value)
  }
  public func read(_ word: I2SHandleHalfWord) -> UInt16 {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: wordsAddress + UInt(10 + word.rawValue) * 4)
      .load()
  }
  public func write(_ word: I2SHandleHalfWord, value: UInt16) {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: wordsAddress + UInt(10 + word.rawValue) * 4)
      .store(value)
  }
  public func read(_ word: I2SHandleWord) -> UInt32 { slot(14 + word.rawValue).load() }
  public func write(_ word: I2SHandleWord, value: UInt32) {
    slot(14 + word.rawValue).store(value)
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
