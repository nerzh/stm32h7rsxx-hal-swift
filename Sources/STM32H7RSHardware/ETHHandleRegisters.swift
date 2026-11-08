import STM32H7RSHAL
import _Volatile

public struct STM32ETHHandleRegisters: ETHHandleIO {
  private let words: UnsafeMutableBufferPointer<UInt32>
  private let pointers: UnsafeMutableBufferPointer<UnsafeMutableRawPointer?>
  private let transmit: UnsafeMutableBufferPointer<UInt32>
  private let receive: UnsafeMutableBufferPointer<UInt32>
  private let packets: UnsafeMutableBufferPointer<UnsafeMutablePointer<UInt32>?>
  // Caller-owned, initially zero/nil storage must outlive the driver and DMA.
  // Timestamp slots 19/20 are contiguous for the transmit PTP callback.
  public init(
    words: UnsafeMutableBufferPointer<UInt32>,
    pointers: UnsafeMutableBufferPointer<UnsafeMutableRawPointer?>,
    transmitDescriptors: UnsafeMutableBufferPointer<UInt32>,
    receiveDescriptors: UnsafeMutableBufferPointer<UInt32>,
    transmitPackets: UnsafeMutableBufferPointer<UnsafeMutablePointer<UInt32>?>
  ) {
    precondition(words.count >= 23 && pointers.count >= 6)
    precondition(
      transmitDescriptors.count > 0 && receiveDescriptors.count > 0
        && transmitPackets.count >= transmitDescriptors.count)
    self.words = words
    self.pointers = pointers
    transmit = transmitDescriptors
    receive = receiveDescriptors
    packets = transmitPackets
  }
  public func read(_ word: ETHHandleWord) -> UInt32 {
    VolatileMappedRegister<UInt32>(
      unsafeBitPattern: UInt(bitPattern: words.baseAddress! + word.rawValue)
    ).load()
  }
  public func write(_ word: ETHHandleWord, value: UInt32) {
    VolatileMappedRegister<UInt32>(
      unsafeBitPattern: UInt(bitPattern: words.baseAddress! + word.rawValue)
    ).store(value)
  }
  private func readBits(_ address: UInt) -> UInt {
    if MemoryLayout<UInt>.size == 4 {
      return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    }
    return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
  }
  private func writeBits(_ address: UInt, _ value: UInt) {
    if MemoryLayout<UInt>.size == 4 {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(value))
    } else {
      VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(value))
    }
  }
  public func readPointer(_ pointer: ETHHandlePointer) -> UnsafeMutableRawPointer? {
    UnsafeMutableRawPointer(bitPattern: readBits(UInt(bitPattern: pointerStorage(pointer))))
  }
  public func writePointer(_ pointer: ETHHandlePointer, value: UnsafeMutableRawPointer?) {
    writeBits(UInt(bitPattern: pointerStorage(pointer)), UInt(bitPattern: value))
  }
  public func pointerStorage(_ pointer: ETHHandlePointer) -> UnsafeMutablePointer<
    UnsafeMutableRawPointer?
  > { pointers.baseAddress! + pointer.rawValue }
  public func descriptorAddress(_ ring: ETHDescriptorRing, index: UInt32) -> UInt32 {
    let storage = ring == .transmit ? transmit : receive
    precondition(Int(index) < storage.count)
    return VolatileMappedRegister<UInt32>(
      unsafeBitPattern: UInt(bitPattern: storage.baseAddress! + Int(index))
    ).load()
  }
  public func writeDescriptorAddress(_ ring: ETHDescriptorRing, index: UInt32, value: UInt32) {
    let storage = ring == .transmit ? transmit : receive
    precondition(Int(index) < storage.count)
    VolatileMappedRegister<UInt32>(
      unsafeBitPattern: UInt(bitPattern: storage.baseAddress! + Int(index))
    ).store(value)
  }
  public func transmitPacket(index: UInt32) -> UnsafeMutablePointer<UInt32>? {
    precondition(Int(index) < packets.count)
    return UnsafeMutablePointer<UInt32>(
      bitPattern: readBits(UInt(bitPattern: packets.baseAddress! + Int(index))))
  }
  public func writeTransmitPacket(index: UInt32, value: UnsafeMutablePointer<UInt32>?) {
    precondition(Int(index) < packets.count)
    writeBits(UInt(bitPattern: packets.baseAddress! + Int(index)), UInt(bitPattern: value))
  }
  public func transmitTimestampWords() -> UnsafeMutablePointer<UInt32> { words.baseAddress! + 19 }
}
