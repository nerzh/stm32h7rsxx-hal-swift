// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PKA operations and definitions from stm32h7rsxx_hal_pka.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension PKA {
    public func getModExpResult(_ output: UnsafeMutablePointer<UInt8>?) {
        let size = handle.read(.operandSize)
        readBytes(fromRAM: 0x10E, to: output, count: size)
    }
    public func getECDSASignResult(_ output: PKAECDSASignOutput?, extended: PKAECDSASignExtendedOutput? = nil) {
        let size = handle.read(.primeOrderSize)
        if let output {
            readBytes(fromRAM: 0xCC, to: output.rSign, count: size)
            readBytes(fromRAM: 0xE2, to: output.sSign, count: size)
        }
        if let extended {
            readBytes(fromRAM: 0x400, to: extended.ptX, count: size)
            readBytes(fromRAM: 0x416, to: extended.ptY, count: size)
        }
    }
    public func isValidECDSASignature() -> Bool { registers.readRAM(0x74) == 0xD60D }
    public func getRSACRTExpResult(_ output: UnsafeMutablePointer<UInt8>?) {
        let size = (registers.readRAM(0x2) &+ 7) / 8
        readBytes(fromRAM: 0x10E, to: output, count: size)
    }
    public func isPointOnCurve() -> Bool { registers.readRAM(0xA0) == 0xD60D }
    public func getECCMulResult(_ output: PKAECCMulOutput?) {
        let size = handle.read(.modulusSize)
        if let output {
            readBytes(fromRAM: 0x5E, to: output.ptX, count: size)
            readBytes(fromRAM: 0x74, to: output.ptY, count: size)
        }
    }
    public func getArithmeticResult(_ output: UnsafeMutablePointer<UInt32>?) {
        let mode = (registers.read(.cr) & 0x3F00) >> 0x8
        var size: UInt32 = 0
        switch mode {
        case 0x1, 0xA, 0xE, 0xD, 0x8, 0x10:
            size = registers.readRAM(2) / 32
        case 0x9, 0xF:
            size = registers.readRAM(0x2) / 32
            if registers.readRAM(0x29E &+ size) != 0 { size &+= 1 }
        case 0xC: size = 1
        case 0xB: size = registers.readRAM(0x2) / 32 &* 2
        default: break
        }
        if let output {
            switch mode {
            case 0xA, 0xE, 0xD, 0x8, 0xF, 0x10, 0x9, 0xC, 0xB:
                readWords(fromRAM: 0x29E, to: output, count: size)
            default: break
            }
        }
    }
    public func getMontgomeryParamResult(_ output: UnsafeMutablePointer<UInt32>?) {
        let size = (registers.readRAM(0x2) &+ 31) / 32
        readWords(fromRAM: 0x88, to: output, count: size)
    }
    public func getECCDoubleBaseLadderResult(_ output: PKAECCDoubleBaseLadderOutput?) {
        let size = registers.readRAM(0x2) / 8
        if let output {
            readBytes(fromRAM: 0x5E, to: output.ptX, count: size)
            readBytes(fromRAM: 0x74, to: output.ptY, count: size)
        }
    }
    public func getECCProjectiveToAffineResult(_ output: PKAECCProjective2AffineOutput?) {
        let size = registers.readRAM(0x2) / 8
        if let output {
            readBytes(fromRAM: 0x5E, to: output.ptX, count: size)
            readBytes(fromRAM: 0x74, to: output.ptY, count: size)
        }
    }
    public func getECCCompleteAdditionResult(_ output: PKAECCCompleteAdditionOutput?) {
        let size = (registers.readRAM(0x2) &+ 7) / 8
        if let output {
            readBytes(fromRAM: 0x258, to: output.ptX, count: size)
            readBytes(fromRAM: 0x26E, to: output.ptY, count: size)
            readBytes(fromRAM: 0x284, to: output.ptZ, count: size)
        }
    }
}
