import STM32H7RSHAL
import _Volatile

#if STM32H7R
  import STM32H7R
#else
  import STM32H7S
#endif
public struct STM32TIMRegisters: TIMRegisterIO {
  public let instance: TIMInstance
  public init(_ instance: TIMInstance) { self.instance = instance }
  // Reuse the family-wide layout; CMSIS requires full-word accesses even where SVD fields are 16-bit.
  private var peripheral: TIM1 { TIM1(unsafeAddress: UInt(instance.rawValue)) }
  public func address(of register: TIMRegister) -> UInt32 {
    switch register {
    case .cr1: return UInt32(peripheral.cr1.unsafeAddress)
    case .cr2: return UInt32(peripheral.cr2.unsafeAddress)
    case .smcr: return UInt32(peripheral.smcr.unsafeAddress)
    case .dier: return UInt32(peripheral.dier.unsafeAddress)
    case .sr: return UInt32(peripheral.sr.unsafeAddress)
    case .egr: return UInt32(peripheral.egr.unsafeAddress)
    case .ccmr1: return UInt32(peripheral.ccmr1_output.unsafeAddress)
    case .ccmr2: return UInt32(peripheral.ccmr2_output.unsafeAddress)
    case .ccer: return UInt32(peripheral.ccer.unsafeAddress)
    case .cnt: return UInt32(peripheral.cnt.unsafeAddress)
    case .psc: return UInt32(peripheral.psc.unsafeAddress)
    case .arr: return UInt32(peripheral.arr.unsafeAddress)
    case .rcr: return UInt32(peripheral.rcr.unsafeAddress)
    case .ccr1: return UInt32(peripheral.ccr[0].unsafeAddress)
    case .ccr2: return UInt32(peripheral.ccr[1].unsafeAddress)
    case .ccr3: return UInt32(peripheral.ccr[2].unsafeAddress)
    case .ccr4: return UInt32(peripheral.ccr[3].unsafeAddress)
    case .bdtr: return UInt32(peripheral.bdtr.unsafeAddress)
    case .ccr5: return UInt32(peripheral.ccr5.unsafeAddress)
    case .ccr6: return UInt32(peripheral.ccr6.unsafeAddress)
    case .ccmr3: return UInt32(peripheral.ccmr3_output.unsafeAddress)
    case .dtr2: return UInt32(peripheral.dtr2.unsafeAddress)
    case .ecr: return UInt32(peripheral.ecr.unsafeAddress)
    case .tisel: return UInt32(peripheral.tisel.unsafeAddress)
    case .af1: return UInt32(peripheral.af1.unsafeAddress)
    case .af2: return UInt32(peripheral.af2.unsafeAddress)
    case .dcr: return UInt32(peripheral.dcr.unsafeAddress)
    case .dmar: return UInt32(peripheral.dmar.unsafeAddress)
    }
  }
  public func read(_ register: TIMRegister) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write(_ register: TIMRegister, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
}
