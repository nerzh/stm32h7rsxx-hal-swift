import STM32H7RSHAL
import _Volatile

#if STM32H7R
  import STM32H7R
#else
  import STM32H7S
#endif

public struct STM32I3CRegisters: I3CRegisterIO {
  public init() {}
  public func address(of register: I3CRegister) -> UInt32 {
    // The pinned SVD exposes only the I2C view of this shared peripheral.
    // I3C offsets follow the pinned CMSIS I3C_TypeDef.
    UInt32(i2c1_i3c1.unsafeAddress) &+ register.rawValue
  }
  public func read(_ register: I3CRegister) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write(_ register: I3CRegister, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
}
