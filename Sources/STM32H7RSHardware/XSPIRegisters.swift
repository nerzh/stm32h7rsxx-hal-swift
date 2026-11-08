import STM32H7RSHAL
import _Volatile

#if STM32H7R
  import STM32H7R
#else
  import STM32H7S
#endif
public struct STM32XSPIRegisters: XSPIRegisterIO {
  public let instance: XSPIInstance
  public init(_ instance: XSPIInstance) { self.instance = instance }
  private var peripheral: XSPI1 { XSPI1(unsafeAddress: UInt(instance.rawValue)) }
  public func address(of register: XSPIRegister) -> UInt32 {
    switch register {
    case .cr: return UInt32(peripheral.cr.unsafeAddress)
    case .dcr1: return UInt32(peripheral.dcr1.unsafeAddress)
    case .dcr2: return UInt32(peripheral.dcr2.unsafeAddress)
    case .dcr3: return UInt32(peripheral.dcr3.unsafeAddress)
    case .dcr4: return UInt32(peripheral.dcr4.unsafeAddress)
    case .sr: return UInt32(peripheral.sr.unsafeAddress)
    case .fcr: return UInt32(peripheral.fcr.unsafeAddress)
    case .dlr: return UInt32(peripheral.dlr.unsafeAddress)
    case .ar: return UInt32(peripheral.ar.unsafeAddress)
    case .dr: return UInt32(peripheral.dr.unsafeAddress)
    case .psmkr: return UInt32(peripheral.psmkr.unsafeAddress)
    case .psmar: return UInt32(peripheral.psmar.unsafeAddress)
    case .pir: return UInt32(peripheral.pir.unsafeAddress)
    case .ccr: return UInt32(peripheral.ccr.unsafeAddress)
    case .tcr: return UInt32(peripheral.tcr.unsafeAddress)
    case .ir: return UInt32(peripheral.ir.unsafeAddress)
    case .abr: return UInt32(peripheral.abr.unsafeAddress)
    case .lptr: return UInt32(peripheral.lptr.unsafeAddress)
    case .wpccr: return UInt32(peripheral.wpccr.unsafeAddress)
    case .wptcr: return UInt32(peripheral.wptcr.unsafeAddress)
    case .wpir: return UInt32(peripheral.wpir.unsafeAddress)
    case .wpabr: return UInt32(peripheral.wpabr.unsafeAddress)
    case .wccr: return UInt32(peripheral.wccr.unsafeAddress)
    case .wtcr: return UInt32(peripheral.wtcr.unsafeAddress)
    case .wir: return UInt32(peripheral.wir.unsafeAddress)
    case .wabr: return UInt32(peripheral.wabr.unsafeAddress)
    case .hlcr: return UInt32(peripheral.hlcr.unsafeAddress)
    case .calfcr: return UInt32(peripheral.calfcr.unsafeAddress)
    case .calmr: return UInt32(peripheral.calmr.unsafeAddress)
    case .calsor: return UInt32(peripheral.calsor.unsafeAddress)
    case .calsir: return UInt32(peripheral.calsir.unsafeAddress)
    }
  }
  public func read(_ register: XSPIRegister) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write(_ register: XSPIRegister, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
  public func read8(_ register: XSPIRegister) -> UInt8 {
    VolatileMappedRegister<UInt8>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write8(_ register: XSPIRegister, value: UInt8) {
    VolatileMappedRegister<UInt8>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
  public func readControl(_ instance: XSPIInstance) -> UInt32 {
    STM32XSPIRegisters(instance).read(.cr)
  }
  public func writeControl(_ instance: XSPIInstance, value: UInt32) {
    STM32XSPIRegisters(instance).write(.cr, value: value)
  }
  public func managerAddress() -> UInt32 { UInt32(xspim1.cr.unsafeAddress) }
  public func readManagerControl() -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(managerAddress())).load()
  }
  public func writeManagerControl(_ value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(managerAddress())).store(value)
  }
}
