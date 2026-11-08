// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PKA operations and definitions from stm32h7rsxx_hal_pka.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension PKA {
    @discardableResult
    public func modExp(_ c: PKAModExpInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setModExp(c)
        handle.write(.operandSize, value: c.opSize)
        return process(mode: 0x0, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func modExpIT(_ c: PKAModExpInput) -> HALStatus {
        setModExp(c)
        handle.write(.operandSize, value: c.opSize)
        return processIT(mode: 0x0)
    }
    @discardableResult
    public func modExpFastMode(_ c: PKAModExpFastModeInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setModExpFastMode(c)
        handle.write(.operandSize, value: c.opSize)
        return process(mode: 0x2, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func modExpFastModeIT(_ c: PKAModExpFastModeInput) -> HALStatus {
        setModExpFastMode(c)
        handle.write(.operandSize, value: c.opSize)
        return processIT(mode: 0x2)
    }
    @discardableResult
    public func modExpProtectMode(_ c: PKAModExpProtectModeInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setModExpProtectMode(c)
        handle.write(.operandSize, value: c.opSize)
        return process(mode: 0x3, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func modExpProtectModeIT(_ c: PKAModExpProtectModeInput) -> HALStatus {
        setModExpProtectMode(c)
        handle.write(.operandSize, value: c.opSize)
        return processIT(mode: 0x3)
    }
    @discardableResult
    public func ecdsaSign(_ c: PKAECDSASignInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setECDSASign(c)
        handle.write(.primeOrderSize, value: c.primeOrderSize)
        return process(mode: 0x24, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func ecdsaSignIT(_ c: PKAECDSASignInput) -> HALStatus {
        setECDSASign(c)
        handle.write(.primeOrderSize, value: c.primeOrderSize)
        return processIT(mode: 0x24)
    }
    @discardableResult
    public func ecdsaVerify(_ c: PKAECDSAVerifInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setECDSAVerif(c)
        return process(mode: 0x26, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func ecdsaVerifyIT(_ c: PKAECDSAVerifInput) -> HALStatus {
        setECDSAVerif(c)
        return processIT(mode: 0x26)
    }
    @discardableResult
    public func rsaCRTExp(_ c: PKARSACRTExpInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setRSACRTExp(c)
        return process(mode: 0x7, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func rsaCRTExpIT(_ c: PKARSACRTExpInput) -> HALStatus {
        setRSACRTExp(c)
        return processIT(mode: 0x7)
    }
    @discardableResult
    public func pointCheck(_ c: PKAPointCheckInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        guard c.pMontgomeryParam != nil else { return .error }
        setPointCheck(c)
        return process(mode: 0x28, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func pointCheckIT(_ c: PKAPointCheckInput) -> HALStatus {
        guard c.pMontgomeryParam != nil else { return .error }
        setPointCheck(c)
        return processIT(mode: 0x28)
    }
    @discardableResult
    public func eccMul(_ c: PKAECCMulInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setECCMul(c)
        handle.write(.modulusSize, value: c.modulusSize)
        return process(mode: 0x20, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func eccMulIT(_ c: PKAECCMulInput) -> HALStatus {
        setECCMul(c)
        handle.write(.modulusSize, value: c.modulusSize)
        return processIT(mode: 0x20)
    }
    @discardableResult
    public func eccMulEx(_ c: PKAECCMulExInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setECCMulEx(c)
        handle.write(.modulusSize, value: c.modulusSize)
        return process(mode: 0x20, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func eccMulExIT(_ c: PKAECCMulExInput) -> HALStatus {
        setECCMulEx(c)
        handle.write(.modulusSize, value: c.modulusSize)
        return processIT(mode: 0x20)
    }
    @discardableResult
    public func add(_ c: PKAAddInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: nil)
        return process(mode: 0x9, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func addIT(_ c: PKAAddInput) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: nil)
        return processIT(mode: 0x9)
    }
    @discardableResult
    public func subtract(_ c: PKASubInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: nil)
        return process(mode: 0xA, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func subtractIT(_ c: PKASubInput) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: nil)
        return processIT(mode: 0xA)
    }
    @discardableResult
    public func multiply(_ c: PKAMulInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: nil)
        return process(mode: 0xB, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func multiplyIT(_ c: PKAMulInput) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: nil)
        return processIT(mode: 0xB)
    }
    @discardableResult
    public func compare(_ c: PKACmpInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: nil)
        return process(mode: 0xC, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func compareIT(_ c: PKACmpInput) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: nil)
        return processIT(mode: 0xC)
    }
    @discardableResult
    public func modAdd(_ c: PKAModAddInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: c.pOp3)
        return process(mode: 0xE, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func modAddIT(_ c: PKAModAddInput) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: c.pOp3)
        return processIT(mode: 0xE)
    }
    @discardableResult
    public func modInv(_ c: PKAModInvInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setModInv(c)
        return process(mode: 0x8, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func modInvIT(_ c: PKAModInvInput) -> HALStatus {
        setModInv(c)
        return processIT(mode: 0x8)
    }
    @discardableResult
    public func modSub(_ c: PKAModSubInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: c.pOp3)
        return process(mode: 0xF, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func modSubIT(_ c: PKAModSubInput) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: c.pOp3)
        return processIT(mode: 0xF)
    }
    @discardableResult
    public func modRed(_ c: PKAModRedInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setModRed(c)
        return process(mode: 0xD, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func modRedIT(_ c: PKAModRedInput) -> HALStatus {
        setModRed(c)
        return processIT(mode: 0xD)
    }
    @discardableResult
    public func montgomeryMul(_ c: PKAMontgomeryMulInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: c.pOp3)
        return process(mode: 0x10, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func montgomeryMulIT(_ c: PKAMontgomeryMulInput) -> HALStatus {
        setArithmetic(size: c.size, operand1: c.pOp1, operand2: c.pOp2, modulus: c.pOp3)
        return processIT(mode: 0x10)
    }
    @discardableResult
    public func montgomeryParam(_ c: PKAMontgomeryParamInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setMontgomeryParam(size: c.size, operand: c.pOp1)
        return process(mode: 0x1, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func montgomeryParamIT(_ c: PKAMontgomeryParamInput) -> HALStatus {
        setMontgomeryParam(size: c.size, operand: c.pOp1)
        return processIT(mode: 0x1)
    }
    @discardableResult
    public func eccDoubleBaseLadder(_ c: PKAECCDoubleBaseLadderInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setECCDoubleBaseLadder(c)
        return process(mode: 0x27, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func eccDoubleBaseLadderIT(_ c: PKAECCDoubleBaseLadderInput) -> HALStatus {
        setECCDoubleBaseLadder(c)
        return processIT(mode: 0x27)
    }
    @discardableResult
    public func eccProjectiveToAffine(_ c: PKAECCProjective2AffineInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setECCProjective2Affine(c)
        return process(mode: 0x2F, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func eccProjectiveToAffineIT(_ c: PKAECCProjective2AffineInput) -> HALStatus {
        setECCProjective2Affine(c)
        return processIT(mode: 0x2F)
    }
    @discardableResult
    public func eccCompleteAddition(_ c: PKAECCCompleteAdditionInput, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        setECCCompleteAddition(c)
        return process(mode: 0x23, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func eccCompleteAdditionIT(_ c: PKAECCCompleteAdditionInput) -> HALStatus {
        setECCCompleteAddition(c)
        return processIT(mode: 0x23)
    }
}
