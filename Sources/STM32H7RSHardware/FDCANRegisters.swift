import STM32H7RSHAL
import _Volatile
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32FDCANRegisters: FDCANRegisterIO {
    public let instance: FDCANInstance
    public init(instance: FDCANInstance) { self.instance = instance }
    private var block: FDCAN1 { instance == .fdcan1 ? fdcan1 : fdcan2 }
    public func read(_ register: FDCANRegister) -> UInt32 {
        switch register {
        case .crel: return block.crel.read().raw.storage
        case .endn: return block.endn.read().raw.storage
        case .dbtp: return block.dbtp.read().raw.storage
        case .test: return block.test.read().raw.storage
        case .rwd: return block.rwd.read().raw.storage
        case .cccr: return block.cccr.read().raw.storage
        case .nbtp: return block.nbtp.read().raw.storage
        case .tscc: return block.tscc.read().raw.storage
        case .tscv: return block.tscv.read().raw.storage
        case .tocc: return block.tocc.read().raw.storage
        case .tocv: return block.tocv.read().raw.storage
        case .ecr: return block.ecr.read().raw.storage
        case .psr: return block.psr.read().raw.storage
        case .tdcr: return block.tdcr.read().raw.storage
        case .ir: return block.ir.read().raw.storage
        case .ie: return block.ie.read().raw.storage
        case .ils: return block.ils.read().raw.storage
        case .ile: return block.ile.read().raw.storage
        case .rxgfc: return block.rxgfc.read().raw.storage
        case .xidam: return block.xidam.read().raw.storage
        case .hpms: return block.hpms.read().raw.storage
        case .rxf0s: return block.rxf0s.read().raw.storage
        case .rxf0a: return block.rxf0a.read().raw.storage
        case .rxf1s: return block.rxf1s.read().raw.storage
        case .rxf1a: return block.rxf1a.read().raw.storage
        case .txbc: return block.txbc.read().raw.storage
        case .txfqs: return block.txfqs.read().raw.storage
        case .txbrp: return block.txbrp.read().raw.storage
        case .txbar: return block.txbar.read().raw.storage
        case .txbcr: return block.txbcr.read().raw.storage
        case .txbto: return block.txbto.read().raw.storage
        case .txbcf: return block.txbcf.read().raw.storage
        case .txbtie: return block.txbtie.read().raw.storage
        case .txbcie: return block.txbcie.read().raw.storage
        case .txefs: return block.txefs.read().raw.storage
        case .txefa: return block.txefa.read().raw.storage
        }
    }
    public func write(_ register: FDCANRegister, value: UInt32) {
        switch register {
        case .crel: preconditionFailure("FDCAN register is read-only")
        case .endn: preconditionFailure("FDCAN register is read-only")
        case .dbtp: block.dbtp.write { $0.raw.storage = value }
        case .test: block.test.write { $0.raw.storage = value }
        case .rwd: block.rwd.write { $0.raw.storage = value }
        case .cccr: block.cccr.write { $0.raw.storage = value }
        case .nbtp: block.nbtp.write { $0.raw.storage = value }
        case .tscc: block.tscc.write { $0.raw.storage = value }
        case .tscv: block.tscv.write { $0.raw.storage = value }
        case .tocc: block.tocc.write { $0.raw.storage = value }
        case .tocv: block.tocv.write { $0.raw.storage = value }
        case .ecr: preconditionFailure("FDCAN register is read-only")
        case .psr: preconditionFailure("FDCAN register is read-only")
        case .tdcr: block.tdcr.write { $0.raw.storage = value }
        case .ir: block.ir.write { $0.raw.storage = value }
        case .ie: block.ie.write { $0.raw.storage = value }
        case .ils: block.ils.write { $0.raw.storage = value }
        case .ile: block.ile.write { $0.raw.storage = value }
        case .rxgfc: block.rxgfc.write { $0.raw.storage = value }
        case .xidam: block.xidam.write { $0.raw.storage = value }
        case .hpms: preconditionFailure("FDCAN register is read-only")
        case .rxf0s: preconditionFailure("FDCAN register is read-only")
        case .rxf0a: block.rxf0a.write { $0.raw.storage = value }
        case .rxf1s: preconditionFailure("FDCAN register is read-only")
        case .rxf1a: block.rxf1a.write { $0.raw.storage = value }
        case .txbc: block.txbc.write { $0.raw.storage = value }
        case .txfqs: preconditionFailure("FDCAN register is read-only")
        case .txbrp: preconditionFailure("FDCAN register is read-only")
        case .txbar: block.txbar.write { $0.raw.storage = value }
        case .txbcr: block.txbcr.write { $0.raw.storage = value }
        case .txbto: preconditionFailure("FDCAN register is read-only")
        case .txbcf: preconditionFailure("FDCAN register is read-only")
        case .txbtie: block.txbtie.write { $0.raw.storage = value }
        case .txbcie: block.txbcie.write { $0.raw.storage = value }
        case .txefs: preconditionFailure("FDCAN register is read-only")
        case .txefa: block.txefa.write { $0.raw.storage = value }
        }
    }
    // The divider belongs to FDCAN_CONFIG at the first instance, including when operating FDCAN2.
    public func readClockDivider() -> UInt32 { fdcan1.ckdiv.read().raw.storage }
    public func writeClockDivider(_ value: UInt32) { fdcan1.ckdiv.write { $0.raw.storage = value } }
    public func messageRAMBase() -> UInt32 { 0x4000AC00 }
    public func readMemory32(at address: UInt32) -> UInt32 { VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address)).load() }
    public func writeMemory32(at address: UInt32, value: UInt32) { VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address)).store(value) }
    public func readMemory8(at address: UInt32) -> UInt8 { VolatileMappedRegister<UInt8>(unsafeBitPattern: UInt(address)).load() }
    func clockDividerAddress() -> UInt { fdcan1.ckdiv.unsafeAddress }
    func address(of register: FDCANRegister) -> UInt {
        switch register {
        case .crel: return block.crel.unsafeAddress
        case .endn: return block.endn.unsafeAddress
        case .dbtp: return block.dbtp.unsafeAddress
        case .test: return block.test.unsafeAddress
        case .rwd: return block.rwd.unsafeAddress
        case .cccr: return block.cccr.unsafeAddress
        case .nbtp: return block.nbtp.unsafeAddress
        case .tscc: return block.tscc.unsafeAddress
        case .tscv: return block.tscv.unsafeAddress
        case .tocc: return block.tocc.unsafeAddress
        case .tocv: return block.tocv.unsafeAddress
        case .ecr: return block.ecr.unsafeAddress
        case .psr: return block.psr.unsafeAddress
        case .tdcr: return block.tdcr.unsafeAddress
        case .ir: return block.ir.unsafeAddress
        case .ie: return block.ie.unsafeAddress
        case .ils: return block.ils.unsafeAddress
        case .ile: return block.ile.unsafeAddress
        case .rxgfc: return block.rxgfc.unsafeAddress
        case .xidam: return block.xidam.unsafeAddress
        case .hpms: return block.hpms.unsafeAddress
        case .rxf0s: return block.rxf0s.unsafeAddress
        case .rxf0a: return block.rxf0a.unsafeAddress
        case .rxf1s: return block.rxf1s.unsafeAddress
        case .rxf1a: return block.rxf1a.unsafeAddress
        case .txbc: return block.txbc.unsafeAddress
        case .txfqs: return block.txfqs.unsafeAddress
        case .txbrp: return block.txbrp.unsafeAddress
        case .txbar: return block.txbar.unsafeAddress
        case .txbcr: return block.txbcr.unsafeAddress
        case .txbto: return block.txbto.unsafeAddress
        case .txbcf: return block.txbcf.unsafeAddress
        case .txbtie: return block.txbtie.unsafeAddress
        case .txbcie: return block.txbcie.unsafeAddress
        case .txefs: return block.txefs.unsafeAddress
        case .txefa: return block.txefa.unsafeAddress
        }
    }
}
