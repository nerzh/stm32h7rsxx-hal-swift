import STM32H7RSHAL
#if STM32H7S
import STM32H7S
private typealias DeviceMCE = STM32H7S.MCE1

public struct STM32MCERegisters: MCERegisterIO {
    public let instance: MCEInstance
    public init(instance: MCEInstance) { self.instance = instance }
    private var device: DeviceMCE {
        switch instance { case .mce1: return mce1; case .mce2: return mce2; case .mce3: return mce3 }
    }
    public func read(_ register: MCERegister) -> UInt32 {
        switch register {
        case .cr: return device.cr.read().raw.storage
        case .sr: return device.sr.read().raw.storage
        case .iasr: return device.iasr.read().raw.storage
        case .iacr: preconditionFailure("MCE IACR is write-only")
        case .iaier: return device.iaier.read().raw.storage
        case .privcfgr: return device.privcfgr.read().raw.storage
        case .iaesr: return device.iaesr.read().raw.storage
        case .iaddr: return device.iaddr.read().raw.storage
        case .masterKey, .fastMasterKey: preconditionFailure("MCE key registers are write-only")
        case .region(let i, let field):
            precondition(i < 4)
            switch field {
            case .regcr: return device.reg[Int(i)].regcr.read().raw.storage
            case .saddr: return device.reg[Int(i)].saddr.read().raw.storage
            case .eaddr: return device.reg[Int(i)].eaddr.read().raw.storage
            case .attr: return device.reg[Int(i)].attr.read().raw.storage
            }
        case .context(let i, let field):
            precondition(instance == .mce1 && i < 2)
            switch field {
            case .cccfgr: return device.cc[Int(i)].cccfgr.read().raw.storage
            case .ccnr0, .ccnr1, .cckeyr0, .cckeyr1, .cckeyr2, .cckeyr3:
                preconditionFailure("MCE nonce and key registers are write-only")
            }
        }
    }
    public func write(_ register: MCERegister, value: UInt32) {
        switch register {
        case .cr: device.cr.write { $0.raw.storage = value }
        case .sr: preconditionFailure("MCE register is read-only")
        case .iasr: preconditionFailure("MCE register is read-only")
        case .iacr: device.iacr.write { $0.raw.storage = value }
        case .iaier: device.iaier.write { $0.raw.storage = value }
        case .privcfgr: device.privcfgr.write { $0.raw.storage = value }
        case .iaesr: preconditionFailure("MCE register is read-only")
        case .iaddr: preconditionFailure("MCE register is read-only")
        case .masterKey(let i):
            precondition(i < 4)
            device.mkeyr[Int(i)].write { $0.raw.storage = value }
        case .fastMasterKey(let i):
            precondition(i < 4)
            device.fmkeyr[Int(i)].write { $0.raw.storage = value }
        case .region(let i, let field):
            precondition(i < 4)
            switch field {
            case .regcr: device.reg[Int(i)].regcr.write { $0.raw.storage = value }
            case .saddr: device.reg[Int(i)].saddr.write { $0.raw.storage = value }
            case .eaddr: device.reg[Int(i)].eaddr.write { $0.raw.storage = value }
            case .attr: device.reg[Int(i)].attr.write { $0.raw.storage = value }
            }
        case .context(let i, let field):
            precondition(instance == .mce1 && i < 2)
            switch field {
            case .cccfgr: device.cc[Int(i)].cccfgr.write { $0.raw.storage = value }
            case .ccnr0: device.cc[Int(i)].ccnr0.write { $0.raw.storage = value }
            case .ccnr1: device.cc[Int(i)].ccnr1.write { $0.raw.storage = value }
            case .cckeyr0: device.cc[Int(i)].cckeyr0.write { $0.raw.storage = value }
            case .cckeyr1: device.cc[Int(i)].cckeyr1.write { $0.raw.storage = value }
            case .cckeyr2: device.cc[Int(i)].cckeyr2.write { $0.raw.storage = value }
            case .cckeyr3: device.cc[Int(i)].cckeyr3.write { $0.raw.storage = value }
            }
        }
    }
    func address(of register: MCERegister) -> UInt {
        switch register {
        case .cr: return device.cr.unsafeAddress
        case .sr: return device.sr.unsafeAddress
        case .iasr: return device.iasr.unsafeAddress
        case .iacr: return device.iacr.unsafeAddress
        case .iaier: return device.iaier.unsafeAddress
        case .privcfgr: return device.privcfgr.unsafeAddress
        case .iaesr: return device.iaesr.unsafeAddress
        case .iaddr: return device.iaddr.unsafeAddress
        case .masterKey(let i): return device.mkeyr[Int(i)].unsafeAddress
        case .fastMasterKey(let i): return device.fmkeyr[Int(i)].unsafeAddress
        case .region(let i, let field):
            switch field {
            case .regcr: return device.reg[Int(i)].regcr.unsafeAddress
            case .saddr: return device.reg[Int(i)].saddr.unsafeAddress
            case .eaddr: return device.reg[Int(i)].eaddr.unsafeAddress
            case .attr: return device.reg[Int(i)].attr.unsafeAddress
            }
        case .context(let i, let field):
            switch field {
            case .cccfgr: return device.cc[Int(i)].cccfgr.unsafeAddress
            case .ccnr0: return device.cc[Int(i)].ccnr0.unsafeAddress
            case .ccnr1: return device.cc[Int(i)].ccnr1.unsafeAddress
            case .cckeyr0: return device.cc[Int(i)].cckeyr0.unsafeAddress
            case .cckeyr1: return device.cc[Int(i)].cckeyr1.unsafeAddress
            case .cckeyr2: return device.cc[Int(i)].cckeyr2.unsafeAddress
            case .cckeyr3: return device.cc[Int(i)].cckeyr3.unsafeAddress
            }
        }
    }
}
#endif
