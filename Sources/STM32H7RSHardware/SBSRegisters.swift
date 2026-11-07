import MMIO
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32SBSRegisters: SBSRegisterIO {
    public init() {}
    public func read(_ register: SBSRegister) -> UInt32 {
        switch register {
        case .bootsr: return sbs.bootsr.read().raw.storage
        case .hdplcr: return sbs.hdplcr.read().raw.storage
        case .hdplsr: return sbs.hdplsr.read().raw.storage
        case .dbgcr: return sbs.dbgcr.read().raw.storage
        case .dbglockr: return sbs.dbglockr.read().raw.storage
        case .rsscmdr: return sbs.rsscmdr.read().raw.storage
        case .pmcr: return sbs.pmcr.read().raw.storage
        case .fpuimr: return sbs.fpuimr.read().raw.storage
        case .mesr: return sbs.mesr.read().raw.storage
        case .cccsr: return sbs.cccsr.read().raw.storage
        case .ccvalr: return sbs.ccvalr.read().raw.storage
        case .ccswvalr: return sbs.ccswvalr.read().raw.storage
        case .bklockr: return sbs.bklockr.read().raw.storage
        case .extiConfiguration(let index): return SBSGPIOSelection.read(index)
        }
    }
    public func write(_ register: SBSRegister, value: UInt32) {
        switch register {
        case .hdplcr: sbs.hdplcr.write { $0.raw.storage = value }
        case .dbgcr: sbs.dbgcr.write { $0.raw.storage = value }
        case .dbglockr: sbs.dbglockr.write { $0.raw.storage = value }
        case .rsscmdr: sbs.rsscmdr.write { $0.raw.storage = value }
        case .pmcr: sbs.pmcr.write { $0.raw.storage = value }
        case .fpuimr: sbs.fpuimr.write { $0.raw.storage = value }
        case .cccsr: sbs.cccsr.write { $0.raw.storage = value }
        case .ccswvalr: sbs.ccswvalr.write { $0.raw.storage = value }
        case .bklockr: sbs.bklockr.write { $0.raw.storage = value }
        case .extiConfiguration(let index): SBSGPIOSelection.write(index, value: value)
        case .bootsr, .hdplsr, .mesr, .ccvalr:
            preconditionFailure("SBS status registers are read-only")
        }
    }
    func address(of register: SBSRegister) -> UInt {
        switch register {
        case .bootsr: return sbs.bootsr.unsafeAddress
        case .hdplcr: return sbs.hdplcr.unsafeAddress
        case .hdplsr: return sbs.hdplsr.unsafeAddress
        case .dbgcr: return sbs.dbgcr.unsafeAddress
        case .dbglockr: return sbs.dbglockr.unsafeAddress
        case .rsscmdr: return sbs.rsscmdr.unsafeAddress
        case .pmcr: return sbs.pmcr.unsafeAddress
        case .fpuimr: return sbs.fpuimr.unsafeAddress
        case .mesr: return sbs.mesr.unsafeAddress
        case .cccsr: return sbs.cccsr.unsafeAddress
        case .ccvalr: return sbs.ccvalr.unsafeAddress
        case .ccswvalr: return sbs.ccswvalr.unsafeAddress
        case .bklockr: return sbs.bklockr.unsafeAddress
        case .extiConfiguration(let index):
            precondition((0..<4).contains(index))
            return sbs.exticr1.unsafeAddress + UInt(index) * 4
        }
    }
}

public extension STM32H7RSHAL.SBS where IO == STM32SBSRegisters {
    init() { self.init(registers: STM32SBSRegisters()) }
}
