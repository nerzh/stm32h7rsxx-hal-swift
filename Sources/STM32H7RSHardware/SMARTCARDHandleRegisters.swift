import STM32H7RSHAL
import _Volatile

public struct STM32SMARTCARDHandleRegisters: SMARTCARDHandleIO {
  private let wordsAddress: UInt
  private let pointersAddress: UInt
  // Caller-owned storage: 39 zeroed UInt32 slots plus two native-width pointer slots.
  // Narrow C fields occupy the low byte/halfword of their slot; padding is untouched.
  public init(words: UnsafeMutableBufferPointer<UInt32>, pointers: UnsafeMutableBufferPointer<UInt>)
  {
    precondition(words.count >= 39 && pointers.count >= 2)
    wordsAddress = UInt(bitPattern: words.baseAddress!)
    pointersAddress = UInt(bitPattern: pointers.baseAddress!)
    precondition(wordsAddress & 3 == 0)
    precondition(pointersAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
  }
  public func read(_ word: SMARTCARDConfigurationWord) -> UInt32 {
    let address = wordsAddress + UInt(0 + word.rawValue) * 4
    if word == .prescaler || word == .guardTime || word == .blockLength || word == .autoRetryCount {
      return UInt32(VolatileMappedRegister<UInt8>(unsafeBitPattern: address).load())
    }
    if word == .parity || word == .mode || word == .clockPolarity || word == .clockPhase
      || word == .clockLastBit || word == .oneBitSampling || word == .nackEnable
    {
      return UInt32(VolatileMappedRegister<UInt16>(unsafeBitPattern: address).load())
    }
    if word == .baudRate || word == .wordLength || word == .stopBits || word == .timeoutEnable
      || word == .timeoutValue || word == .clockPrescaler
    {
      return UInt32(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    }
    preconditionFailure("Unknown field")
  }
  public func write(_ word: SMARTCARDConfigurationWord, value: UInt32) {
    let address = wordsAddress + UInt(0 + word.rawValue) * 4
    if word == .prescaler || word == .guardTime || word == .blockLength || word == .autoRetryCount {
      VolatileMappedRegister<UInt8>(unsafeBitPattern: address).store(
        UInt8(truncatingIfNeeded: value))
      return
    }
    if word == .parity || word == .mode || word == .clockPolarity || word == .clockPhase
      || word == .clockLastBit || word == .oneBitSampling || word == .nackEnable
    {
      VolatileMappedRegister<UInt16>(unsafeBitPattern: address).store(
        UInt16(truncatingIfNeeded: value))
      return
    }
    if word == .baudRate || word == .wordLength || word == .stopBits || word == .timeoutEnable
      || word == .timeoutValue || word == .clockPrescaler
    {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(
        UInt32(truncatingIfNeeded: value))
      return
    }
  }
  public func read(_ word: SMARTCARDAdvancedConfigurationWord) -> UInt32 {
    let address = wordsAddress + UInt(17 + word.rawValue) * 4
    if word == .transmitCompletionIndication {
      return UInt32(VolatileMappedRegister<UInt16>(unsafeBitPattern: address).load())
    }
    if word == .features || word == .txPinLevelInvert || word == .rxPinLevelInvert
      || word == .dataInvert || word == .swap || word == .overrunDisable
      || word == .dmaDisableOnReceiveError || word == .mostSignificantBitFirst
    {
      return UInt32(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    }
    preconditionFailure("Unknown field")
  }
  public func write(_ word: SMARTCARDAdvancedConfigurationWord, value: UInt32) {
    let address = wordsAddress + UInt(17 + word.rawValue) * 4
    if word == .transmitCompletionIndication {
      VolatileMappedRegister<UInt16>(unsafeBitPattern: address).store(
        UInt16(truncatingIfNeeded: value))
      return
    }
    if word == .features || word == .txPinLevelInvert || word == .rxPinLevelInvert
      || word == .dataInvert || word == .swap || word == .overrunDisable
      || word == .dmaDisableOnReceiveError || word == .mostSignificantBitFirst
    {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(
        UInt32(truncatingIfNeeded: value))
      return
    }
  }
  public func read(_ word: SMARTCARDHandleHalfWord) -> UInt16 {
    let address = wordsAddress + UInt(26 + word.rawValue) * 4
    return UInt16(VolatileMappedRegister<UInt16>(unsafeBitPattern: address).load())
  }
  public func write(_ word: SMARTCARDHandleHalfWord, value: UInt16) {
    let address = wordsAddress + UInt(26 + word.rawValue) * 4
    VolatileMappedRegister<UInt16>(unsafeBitPattern: address).store(
      UInt16(truncatingIfNeeded: value))
  }
  public func read(_ word: SMARTCARDHandleWord) -> UInt32 {
    let address = wordsAddress + UInt(32 + word.rawValue) * 4
    return UInt32(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
  }
  public func write(_ word: SMARTCARDHandleWord, value: UInt32) {
    let address = wordsAddress + UInt(32 + word.rawValue) * 4
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
