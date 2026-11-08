import STM32H7RSHAL
import _Volatile

public struct STM32NORSharedRegisters: NORSharedIO {
  private let address: UInt
  // One initially zero word shared by every NOR handle, including different banks.
  // The caller retains this storage for the lifetime of all wrappers.
  public init(memoryDataWidth: UnsafeMutablePointer<UInt32>) {
    address = UInt(bitPattern: memoryDataWidth)
    precondition(address & 3 == 0)
  }
  public func readMemoryDataWidth() -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load()
  }
  public func writeMemoryDataWidth(_ value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(value)
  }
}
