import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

// Use the existing SwiftMMIO blocks, but preserve full raw C accesses. In the
// pinned SVD, HPDMA FIFOL/REQSEL field widths differ from common CMSIS masks;
// choosing a typed field here would change the upstream HAL behavior.
public struct STM32DMARegisters: DMARegisterIO {
    public let channel: DMAChannel

    public init(channel: DMAChannel) { self.channel = channel }

    public func read(_ register: DMARegister) -> UInt32 {
        switch channel.controller {
        case .gpdma1:
            switch register {
            case .privcfgr: return gpdma.privcfgr.read().raw.storage
            case .rcfglockr: return gpdma.rcfglockr.read().raw.storage
            case .misr: return gpdma.misr.read().raw.storage
            default:
                if channel.supports2DAddressing { return read(register, from: gpdma.ch2d[channel.index - 12]) }
                return read(register, from: gpdma.ch[channel.index])
            }
        case .hpdma1:
            switch register {
            case .privcfgr: return hpdma.privcfgr.read().raw.storage
            case .rcfglockr: return hpdma.rcfglockr.read().raw.storage
            case .misr: return hpdma.misr.read().raw.storage
            default:
                if channel.supports2DAddressing { return read(register, from: hpdma.ch2d[channel.index - 12]) }
                return read(register, from: hpdma.ch[channel.index])
            }
        }
    }

    public func write(_ register: DMARegister, value: UInt32) {
        switch channel.controller {
        case .gpdma1:
            switch register {
            case .privcfgr: gpdma.privcfgr.write { $0.raw.storage = value }
            case .rcfglockr: gpdma.rcfglockr.write { $0.raw.storage = value }
            case .misr: preconditionFailure("DMA global status is read-only")
            default:
                if channel.supports2DAddressing { write(register, value: value, to: gpdma.ch2d[channel.index - 12]) }
                else { write(register, value: value, to: gpdma.ch[channel.index]) }
            }
        case .hpdma1:
            switch register {
            case .privcfgr: hpdma.privcfgr.write { $0.raw.storage = value }
            case .rcfglockr: hpdma.rcfglockr.write { $0.raw.storage = value }
            case .misr: preconditionFailure("DMA global status is read-only")
            default:
                if channel.supports2DAddressing { write(register, value: value, to: hpdma.ch2d[channel.index - 12]) }
                else { write(register, value: value, to: hpdma.ch[channel.index]) }
            }
        }
    }

    private func read(_ register: DMARegister, from block: GPDMA.CH) -> UInt32 {
        switch register {
        case .clbar: return block.lbar.read().raw.storage
        case .cfcr: return block.fcr.read().raw.storage
        case .csr: return block.sr.read().raw.storage
        case .ccr: return block.cr.read().raw.storage
        case .ctr1: return block.tr1.read().raw.storage
        case .ctr2: return block.tr2.read().raw.storage
        case .cbr1: return block.br1.read().raw.storage
        case .csar: return block.sar.read().raw.storage
        case .cdar: return block.dar.read().raw.storage
        case .cllr: return block.llr.read().raw.storage
        case .privcfgr, .rcfglockr, .misr, .ctr3, .cbr2: preconditionFailure("Register is not present in this DMA channel block")
        }
    }

    private func write(_ register: DMARegister, value: UInt32, to block: GPDMA.CH) {
        switch register {
        case .clbar: block.lbar.write { $0.raw.storage = value }
        case .cfcr: block.fcr.write { $0.raw.storage = value }
        case .csr: preconditionFailure("DMA channel status is read-only")
        case .ccr: block.cr.write { $0.raw.storage = value }
        case .ctr1: block.tr1.write { $0.raw.storage = value }
        case .ctr2: block.tr2.write { $0.raw.storage = value }
        case .cbr1: block.br1.write { $0.raw.storage = value }
        case .csar: block.sar.write { $0.raw.storage = value }
        case .cdar: block.dar.write { $0.raw.storage = value }
        case .cllr: block.llr.write { $0.raw.storage = value }
        case .privcfgr, .rcfglockr, .misr, .ctr3, .cbr2: preconditionFailure("Register is not present in this DMA channel block")
        }
    }

    private func read(_ register: DMARegister, from block: GPDMA.CH2D) -> UInt32 {
        switch register {
        case .clbar: return block.lbar.read().raw.storage
        case .cfcr: return block.fcr.read().raw.storage
        case .csr: return block.sr.read().raw.storage
        case .ccr: return block.cr.read().raw.storage
        case .ctr1: return block.tr1.read().raw.storage
        case .ctr2: return block.tr2.read().raw.storage
        case .cbr1: return block.br1.read().raw.storage
        case .csar: return block.sar.read().raw.storage
        case .cdar: return block.dar.read().raw.storage
        case .ctr3: return block.tr3.read().raw.storage
        case .cbr2: return block.br2.read().raw.storage
        case .cllr: return block.llr.read().raw.storage
        case .privcfgr, .rcfglockr, .misr: preconditionFailure("Register is not present in this DMA channel block")
        }
    }

    private func write(_ register: DMARegister, value: UInt32, to block: GPDMA.CH2D) {
        switch register {
        case .clbar: block.lbar.write { $0.raw.storage = value }
        case .cfcr: block.fcr.write { $0.raw.storage = value }
        case .csr: preconditionFailure("DMA channel status is read-only")
        case .ccr: block.cr.write { $0.raw.storage = value }
        case .ctr1: block.tr1.write { $0.raw.storage = value }
        case .ctr2: block.tr2.write { $0.raw.storage = value }
        case .cbr1: block.br1.write { $0.raw.storage = value }
        case .csar: block.sar.write { $0.raw.storage = value }
        case .cdar: block.dar.write { $0.raw.storage = value }
        case .ctr3: block.tr3.write { $0.raw.storage = value }
        case .cbr2: block.br2.write { $0.raw.storage = value }
        case .cllr: block.llr.write { $0.raw.storage = value }
        case .privcfgr, .rcfglockr, .misr: preconditionFailure("Register is not present in this DMA channel block")
        }
    }

    private func read(_ register: DMARegister, from block: HPDMA.CH) -> UInt32 {
        switch register {
        case .clbar: return block.lbar.read().raw.storage
        case .cfcr: return block.fcr.read().raw.storage
        case .csr: return block.sr.read().raw.storage
        case .ccr: return block.cr.read().raw.storage
        case .ctr1: return block.tr1.read().raw.storage
        case .ctr2: return block.tr2.read().raw.storage
        case .cbr1: return block.br1.read().raw.storage
        case .csar: return block.sar.read().raw.storage
        case .cdar: return block.dar.read().raw.storage
        case .cllr: return block.llr.read().raw.storage
        case .privcfgr, .rcfglockr, .misr, .ctr3, .cbr2: preconditionFailure("Register is not present in this DMA channel block")
        }
    }

    private func write(_ register: DMARegister, value: UInt32, to block: HPDMA.CH) {
        switch register {
        case .clbar: block.lbar.write { $0.raw.storage = value }
        case .cfcr: block.fcr.write { $0.raw.storage = value }
        case .csr: preconditionFailure("DMA channel status is read-only")
        case .ccr: block.cr.write { $0.raw.storage = value }
        case .ctr1: block.tr1.write { $0.raw.storage = value }
        case .ctr2: block.tr2.write { $0.raw.storage = value }
        case .cbr1: block.br1.write { $0.raw.storage = value }
        case .csar: block.sar.write { $0.raw.storage = value }
        case .cdar: block.dar.write { $0.raw.storage = value }
        case .cllr: block.llr.write { $0.raw.storage = value }
        case .privcfgr, .rcfglockr, .misr, .ctr3, .cbr2: preconditionFailure("Register is not present in this DMA channel block")
        }
    }

    private func read(_ register: DMARegister, from block: HPDMA.CH2D) -> UInt32 {
        switch register {
        case .clbar: return block.lbar.read().raw.storage
        case .cfcr: return block.fcr.read().raw.storage
        case .csr: return block.sr.read().raw.storage
        case .ccr: return block.cr.read().raw.storage
        case .ctr1: return block.tr1.read().raw.storage
        case .ctr2: return block.tr2.read().raw.storage
        case .cbr1: return block.br1.read().raw.storage
        case .csar: return block.sar.read().raw.storage
        case .cdar: return block.dar.read().raw.storage
        case .ctr3: return block.tr3.read().raw.storage
        case .cbr2: return block.br2.read().raw.storage
        case .cllr: return block.llr.read().raw.storage
        case .privcfgr, .rcfglockr, .misr: preconditionFailure("Register is not present in this DMA channel block")
        }
    }

    private func write(_ register: DMARegister, value: UInt32, to block: HPDMA.CH2D) {
        switch register {
        case .clbar: block.lbar.write { $0.raw.storage = value }
        case .cfcr: block.fcr.write { $0.raw.storage = value }
        case .csr: preconditionFailure("DMA channel status is read-only")
        case .ccr: block.cr.write { $0.raw.storage = value }
        case .ctr1: block.tr1.write { $0.raw.storage = value }
        case .ctr2: block.tr2.write { $0.raw.storage = value }
        case .cbr1: block.br1.write { $0.raw.storage = value }
        case .csar: block.sar.write { $0.raw.storage = value }
        case .cdar: block.dar.write { $0.raw.storage = value }
        case .ctr3: block.tr3.write { $0.raw.storage = value }
        case .cbr2: block.br2.write { $0.raw.storage = value }
        case .cllr: block.llr.write { $0.raw.storage = value }
        case .privcfgr, .rcfglockr, .misr: preconditionFailure("Register is not present in this DMA channel block")
        }
    }
}
