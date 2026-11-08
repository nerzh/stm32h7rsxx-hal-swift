// Copyright (c) 2022 STMicroelectronics.
// SPDX-License-Identifier: Apache-2.0
// JPEG table offsets adapted from CMSIS stm32h7s3xx.h, revision
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

import MMIO
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
typealias DeviceJPEG = STM32H7R.JPEG
#else
import STM32H7S
typealias DeviceJPEG = STM32H7S.JPEG
#endif

public struct STM32JPEGRegisters: JPEGRegisterIO {
    public init() {}
    public func read(_ register: JPEGRegister) -> UInt32 {
        switch register {
        case .confr0: return jpeg.confr0.read().raw.storage
        case .confr1: return jpeg.confr1.read().raw.storage
        case .confr2: return jpeg.confr2.read().raw.storage
        case .confr3: return jpeg.confr3.read().raw.storage
        case .confr4: return jpeg.confr4.read().raw.storage
        case .confr5: return jpeg.confr5.read().raw.storage
        case .confr6: return jpeg.confr6.read().raw.storage
        case .confr7: return jpeg.confr7.read().raw.storage
        case .cr: return jpeg.cr.read().raw.storage
        case .sr: return jpeg.sr.read().raw.storage
        case .cfr: return jpeg.cfr.read().raw.storage
        case .dir: return jpeg.dir.read().raw.storage
        case .dor: return jpeg.dor.read().raw.storage
        }
    }
    public func write(_ register: JPEGRegister, value: UInt32) {
        switch register {
        case .confr0: jpeg.confr0.write { $0.raw.storage = value }
        case .confr1: jpeg.confr1.write { $0.raw.storage = value }
        case .confr2: jpeg.confr2.write { $0.raw.storage = value }
        case .confr3: jpeg.confr3.write { $0.raw.storage = value }
        case .confr4: jpeg.confr4.write { $0.raw.storage = value }
        case .confr5: jpeg.confr5.write { $0.raw.storage = value }
        case .confr6: jpeg.confr6.write { $0.raw.storage = value }
        case .confr7: jpeg.confr7.write { $0.raw.storage = value }
        case .cr: jpeg.cr.write { $0.raw.storage = value }
        case .sr: preconditionFailure("JPEG register is read-only")
        case .cfr: jpeg.cfr.write { $0.raw.storage = value }
        case .dir: jpeg.dir.write { $0.raw.storage = value }
        case .dor: preconditionFailure("JPEG register is read-only")
        }
    }
    public func readTable(_ table: JPEGTable, index: Int) -> UInt32 {
        precondition(index >= 0 && index < table.wordCount)
        switch table {
        case .quantization0: return jpeg.qmem0[index].read().raw.storage
        case .quantization1: return jpeg.qmem1[index].read().raw.storage
        case .quantization2: return jpeg.qmem2[index].read().raw.storage
        case .quantization3: return jpeg.qmem3[index].read().raw.storage
        case .huffmanMinimum: return Register<DeviceJPEG.HUFFMIN.HUFFMIN_0>(unsafeAddress: jpeg.unsafeAddress + UInt(table.rawValue) + UInt(index) * 4).read().raw.storage
        case .huffmanBase: return jpeg.huffbase[index].read().raw.storage
        case .huffmanSymbols: return jpeg.huffsymb[index].read().raw.storage
        case .dht: return jpeg.dhtmem[index].read().raw.storage
        case .ac0: return jpeg.huffenc_ac0[index].read().raw.storage
        case .ac1: return Register<DeviceJPEG.HUFFENC_AC1>(unsafeAddress: jpeg.unsafeAddress + UInt(table.rawValue) + UInt(index) * 4).read().raw.storage
        case .dc0: return jpeg.huffenc_dc0[index].read().raw.storage
        case .dc1: return Register<DeviceJPEG.HUFFENC_DC1>(unsafeAddress: jpeg.unsafeAddress + UInt(table.rawValue) + UInt(index) * 4).read().raw.storage
        }
    }
    public func writeTable(_ table: JPEGTable, index: Int, value: UInt32) {
        precondition(index >= 0 && index < table.wordCount)
        switch table {
        case .quantization0: jpeg.qmem0[index].write { $0.raw.storage = value }
        case .quantization1: jpeg.qmem1[index].write { $0.raw.storage = value }
        case .quantization2: jpeg.qmem2[index].write { $0.raw.storage = value }
        case .quantization3: jpeg.qmem3[index].write { $0.raw.storage = value }
        case .huffmanMinimum: Register<DeviceJPEG.HUFFMIN.HUFFMIN_0>(unsafeAddress: jpeg.unsafeAddress + UInt(table.rawValue) + UInt(index) * 4).write { $0.raw.storage = value }
        case .huffmanBase: jpeg.huffbase[index].write { $0.raw.storage = value }
        case .huffmanSymbols: jpeg.huffsymb[index].write { $0.raw.storage = value }
        case .dht: jpeg.dhtmem[index].write { $0.raw.storage = value }
        case .ac0: jpeg.huffenc_ac0[index].write { $0.raw.storage = value }
        case .ac1: Register<DeviceJPEG.HUFFENC_AC1>(unsafeAddress: jpeg.unsafeAddress + UInt(table.rawValue) + UInt(index) * 4).write { $0.raw.storage = value }
        case .dc0: jpeg.huffenc_dc0[index].write { $0.raw.storage = value }
        case .dc1: Register<DeviceJPEG.HUFFENC_DC1>(unsafeAddress: jpeg.unsafeAddress + UInt(table.rawValue) + UInt(index) * 4).write { $0.raw.storage = value }
        }
    }
    public func dataAddress(_ stream: JPEGStream) -> UInt32 { UInt32(stream == .input ? jpeg.dir.unsafeAddress : jpeg.dor.unsafeAddress) }
    func address(of register: JPEGRegister) -> UInt {
        switch register {
        case .confr0: return jpeg.confr0.unsafeAddress
        case .confr1: return jpeg.confr1.unsafeAddress
        case .confr2: return jpeg.confr2.unsafeAddress
        case .confr3: return jpeg.confr3.unsafeAddress
        case .confr4: return jpeg.confr4.unsafeAddress
        case .confr5: return jpeg.confr5.unsafeAddress
        case .confr6: return jpeg.confr6.unsafeAddress
        case .confr7: return jpeg.confr7.unsafeAddress
        case .cr: return jpeg.cr.unsafeAddress
        case .sr: return jpeg.sr.unsafeAddress
        case .cfr: return jpeg.cfr.unsafeAddress
        case .dir: return jpeg.dir.unsafeAddress
        case .dor: return jpeg.dor.unsafeAddress
        }
    }
    func address(of table: JPEGTable, index: Int) -> UInt {
        precondition(index >= 0 && index < table.wordCount)
        switch table {
        case .quantization0: return jpeg.qmem0[index].unsafeAddress
        case .quantization1: return jpeg.qmem1[index].unsafeAddress
        case .quantization2: return jpeg.qmem2[index].unsafeAddress
        case .quantization3: return jpeg.qmem3[index].unsafeAddress
        case .huffmanMinimum: return jpeg.unsafeAddress + UInt(table.rawValue) + UInt(index) * 4
        case .huffmanBase: return jpeg.huffbase[index].unsafeAddress
        case .huffmanSymbols: return jpeg.huffsymb[index].unsafeAddress
        case .dht: return jpeg.dhtmem[index].unsafeAddress
        case .ac0: return jpeg.huffenc_ac0[index].unsafeAddress
        case .ac1: return jpeg.unsafeAddress + UInt(table.rawValue) + UInt(index) * 4
        case .dc0: return jpeg.huffenc_dc0[index].unsafeAddress
        case .dc1: return jpeg.unsafeAddress + UInt(table.rawValue) + UInt(index) * 4
        }
    }
}
