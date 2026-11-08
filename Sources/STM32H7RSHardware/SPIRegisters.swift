import STM32H7RSHAL
import _Volatile

#if STM32H7R
  import STM32H7R
#else
  import STM32H7S
#endif
public struct STM32SPIRegisters: SPIRegisterIO {
  public let instance: SPIInstance
  public init(_ instance: SPIInstance) { self.instance = instance }
  private var peripheral: SPI1 {
    switch instance {
    case .spi1: return spi1
    case .spi2: return spi2
    case .spi3: return spi3
    case .spi4: return spi4
    case .spi5: return spi5
    case .spi6: return spi6
    }
  }
  public func address(of register: SPIRegister) -> UInt32 {
    switch register {
    case .cr1: return UInt32(peripheral.cr1.unsafeAddress)
    case .cr2: return UInt32(peripheral.cr2.unsafeAddress)
    case .cfg1: return UInt32(peripheral.cfg1.unsafeAddress)
    case .cfg2: return UInt32(peripheral.cfg2.unsafeAddress)
    case .ier: return UInt32(peripheral.ier.unsafeAddress)
    case .sr: return UInt32(peripheral.sr.unsafeAddress)
    case .ifcr: return UInt32(peripheral.ifcr.unsafeAddress)
    case .txdr: return UInt32(peripheral.txdr.unsafeAddress)
    case .rxdr: return UInt32(peripheral.rxdr.unsafeAddress)
    case .crcpoly: return UInt32(peripheral.crcpoly.unsafeAddress)
    case .txcrc: return UInt32(peripheral.txcrc.unsafeAddress)
    case .rxcrc: return UInt32(peripheral.rxcrc.unsafeAddress)
    case .udrdr: return UInt32(peripheral.udrdr.unsafeAddress)
    case .i2scfgr: return UInt32(peripheral.i2scfgr.unsafeAddress)
    }
  }
  public func read(_ register: SPIRegister) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write(_ register: SPIRegister, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
  public func read8(_ register: SPIRegister) -> UInt8 {
    VolatileMappedRegister<UInt8>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write8(_ register: SPIRegister, value: UInt8) {
    VolatileMappedRegister<UInt8>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
  public func read16(_ register: SPIRegister) -> UInt16 {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write16(_ register: SPIRegister, value: UInt16) {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
}
