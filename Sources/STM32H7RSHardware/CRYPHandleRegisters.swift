import STM32H7RSHAL
import _Volatile

public struct STM32CRYPHandleRegisters: CRYPHandleIO {
  private let wordsAddress: UInt
  private let pointersAddress: UInt
  private let savedAddress: UInt
  // Caller-owned storage: 40 zeroed UInt32 slots, 12 native-width pointer slots,
  // and 28 words for the saved IV[4], context[16] and key[8].
  // UInt16 fields use the low halfword of their slot; padding is untouched.
  public init(
    words: UnsafeMutableBufferPointer<UInt32>, pointers: UnsafeMutableBufferPointer<UInt>,
    saved: UnsafeMutableBufferPointer<UInt32>
  ) {
    precondition(words.count >= 40 && pointers.count >= 12 && saved.count >= 28)
    wordsAddress = UInt(bitPattern: words.baseAddress!)
    pointersAddress = UInt(bitPattern: pointers.baseAddress!)
    savedAddress = UInt(bitPattern: saved.baseAddress!)
    precondition(wordsAddress & 3 == 0 && savedAddress & 3 == 0)
    precondition(pointersAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
  }
  public func read(_ word: CRYPConfigurationWord, saved: Bool) -> UInt32 {
    VolatileMappedRegister<UInt32>(
      unsafeBitPattern: wordsAddress + UInt(word.rawValue + (saved ? 9 : 0)) * 4
    ).load()
  }
  public func write(_ word: CRYPConfigurationWord, saved: Bool, value: UInt32) {
    VolatileMappedRegister<UInt32>(
      unsafeBitPattern: wordsAddress + UInt(word.rawValue + (saved ? 9 : 0)) * 4
    ).store(value)
  }
  public func read(_ word: CRYPHandleWord) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: wordsAddress + UInt(word.rawValue + 18) * 4)
      .load()
  }
  public func write(_ word: CRYPHandleWord, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: wordsAddress + UInt(word.rawValue + 18) * 4)
      .store(value)
  }
  public func read(_ word: CRYPHandleHalfWord) -> UInt16 {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: wordsAddress + UInt(word.rawValue + 34) * 4)
      .load()
  }
  public func write(_ word: CRYPHandleHalfWord, value: UInt16) {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: wordsAddress + UInt(word.rawValue + 34) * 4)
      .store(value)
  }
  public func savedWords(_ array: CRYPSavedWords) -> UnsafeMutablePointer<UInt32> {
    let offset: UInt = array == .initialVector ? 0 : array == .context ? 4 : 20
    return UnsafeMutablePointer<UInt32>(bitPattern: savedAddress + offset * 4)!
  }
  public func readPointer(_ pointer: CRYPPointer) -> UnsafeMutablePointer<UInt32>? {
    let address = pointersAddress + UInt(pointer.rawValue) * UInt(MemoryLayout<UInt>.stride)
    let bits: UInt
    if MemoryLayout<UInt>.size == 4 {
      bits = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    } else {
      bits = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }
    return UnsafeMutablePointer<UInt32>(bitPattern: bits)
  }
  public func writePointer(_ pointer: CRYPPointer, value: UnsafeMutablePointer<UInt32>?) {
    let address = pointersAddress + UInt(pointer.rawValue) * UInt(MemoryLayout<UInt>.stride)
    let bits = UInt(bitPattern: value)
    if MemoryLayout<UInt>.size == 4 {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
    } else {
      VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits))
    }
  }
}
