// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PKA operations and definitions from stm32h7rsxx_hal_pka.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension PKA {
    public func setModExp(_ c: PKAModExpInput) {
        registers.writeRAM(0x2, value: PKAEncoding.bitSize(bytes: c.opSize))
        registers.writeRAM(0x0, value: PKAEncoding.bitSize(bytes: c.expSize))
        writeBytes(toRAM: 0x21A, from: c.pOp1, count: c.opSize)
        writeParameterEnd(at: 0x21A &+ ((c.opSize &+ 3) / 4))
        writeBytes(toRAM: 0x29E, from: c.pExp, count: c.expSize)
        writeParameterEnd(at: 0x29E &+ ((c.expSize &+ 3) / 4))
        writeBytes(toRAM: 0x322, from: c.pMod, count: c.opSize)
        writeParameterEnd(at: 0x322 &+ ((c.opSize &+ 3) / 4))
    }
    public func setModExpFastMode(_ c: PKAModExpFastModeInput) {
        registers.writeRAM(0x2, value: PKAEncoding.bitSize(bytes: c.opSize))
        registers.writeRAM(0x0, value: PKAEncoding.bitSize(bytes: c.expSize))
        writeBytes(toRAM: 0x21A, from: c.pOp1, count: c.opSize)
        writeParameterEnd(at: 0x21A &+ ((c.opSize &+ 3) / 4))
        writeBytes(toRAM: 0x29E, from: c.pExp, count: c.expSize)
        writeParameterEnd(at: 0x29E &+ ((c.expSize &+ 3) / 4))
        writeBytes(toRAM: 0x322, from: c.pMod, count: c.opSize)
        writeParameterEnd(at: 0x322 &+ ((c.opSize &+ 3) / 4))
        writeWords(toRAM: 0x88, from: c.pMontgomeryParam, count: c.opSize / 4)
        writeParameterEnd(at: 0x88 &+ ((c.opSize &+ 3) / 4))
    }
    public func setModExpProtectMode(_ c: PKAModExpProtectModeInput) {
        registers.writeRAM(0x2, value: PKAEncoding.bitSize(bytes: c.opSize))
        registers.writeRAM(0x0, value: PKAEncoding.bitSize(bytes: c.expSize))
        writeBytes(toRAM: 0x4B2, from: c.pOp1, count: c.opSize)
        writeParameterEnd(at: 0x4B2 &+ ((c.opSize &+ 3) / 4))
        writeBytes(toRAM: 0x42E, from: c.pExp, count: c.expSize)
        writeParameterEnd(at: 0x42E &+ ((c.expSize &+ 3) / 4))
        writeBytes(toRAM: 0x10E, from: c.pMod, count: c.opSize)
        writeParameterEnd(at: 0x10E &+ ((c.opSize &+ 3) / 4))
        writeBytes(toRAM: 0x21A, from: c.pPhi, count: c.opSize)
        writeParameterEnd(at: 0x21A &+ ((c.opSize &+ 3) / 4))
    }
    public func setECDSASign(_ c: PKAECDSASignInput) {
        registers.writeRAM(0x0, value: PKAEncoding.optimizedBitSize(bytes: c.primeOrderSize, mostSignificantByte: c.primeOrder!.pointee))
        registers.writeRAM(0x2, value: PKAEncoding.optimizedBitSize(bytes: c.modulusSize, mostSignificantByte: c.modulus!.pointee))
        registers.writeRAM(0x4, value: c.coefSign)
        writeBytes(toRAM: 0x6, from: c.coef, count: c.modulusSize)
        writeParameterEnd(at: 0x6 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x48, from: c.coefB, count: c.modulusSize)
        writeParameterEnd(at: 0x48 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x322, from: c.modulus, count: c.modulusSize)
        writeParameterEnd(at: 0x322 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x3A8, from: c.integer, count: c.primeOrderSize)
        writeParameterEnd(at: 0x3A8 &+ ((c.primeOrderSize &+ 3) / 4))
        writeBytes(toRAM: 0x5E, from: c.basePointX, count: c.modulusSize)
        writeParameterEnd(at: 0x5E &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x1C, from: c.basePointY, count: c.modulusSize)
        writeParameterEnd(at: 0x1C &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x2FA, from: c.hash, count: c.primeOrderSize)
        writeParameterEnd(at: 0x2FA &+ ((c.primeOrderSize &+ 3) / 4))
        writeBytes(toRAM: 0x2CA, from: c.privateKey, count: c.primeOrderSize)
        writeParameterEnd(at: 0x2CA &+ ((c.primeOrderSize &+ 3) / 4))
        writeBytes(toRAM: 0x2E2, from: c.primeOrder, count: c.primeOrderSize)
        writeParameterEnd(at: 0x2E2 &+ ((c.primeOrderSize &+ 3) / 4))
    }
    public func setECDSAVerif(_ c: PKAECDSAVerifInput) {
        registers.writeRAM(0x2, value: PKAEncoding.optimizedBitSize(bytes: c.primeOrderSize, mostSignificantByte: c.primeOrder!.pointee))
        registers.writeRAM(0x32, value: PKAEncoding.optimizedBitSize(bytes: c.modulusSize, mostSignificantByte: c.modulus!.pointee))
        registers.writeRAM(0x1A, value: c.coefSign)
        writeBytes(toRAM: 0x1C, from: c.coef, count: c.modulusSize)
        writeParameterEnd(at: 0x1C &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x34, from: c.modulus, count: c.modulusSize)
        writeParameterEnd(at: 0x34 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x9E, from: c.basePointX, count: c.modulusSize)
        writeParameterEnd(at: 0x9E &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0xB4, from: c.basePointY, count: c.modulusSize)
        writeParameterEnd(at: 0xB4 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x3BE, from: c.pPubKeyCurvePtX, count: c.modulusSize)
        writeParameterEnd(at: 0x3BE &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x3D4, from: c.pPubKeyCurvePtY, count: c.modulusSize)
        writeParameterEnd(at: 0x3D4 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x338, from: c.rSign, count: c.primeOrderSize)
        writeParameterEnd(at: 0x338 &+ ((c.primeOrderSize &+ 3) / 4))
        writeBytes(toRAM: 0x21A, from: c.sSign, count: c.primeOrderSize)
        writeParameterEnd(at: 0x21A &+ ((c.primeOrderSize &+ 3) / 4))
        writeBytes(toRAM: 0x3EA, from: c.hash, count: c.primeOrderSize)
        writeParameterEnd(at: 0x3EA &+ ((c.primeOrderSize &+ 3) / 4))
        writeBytes(toRAM: 0x322, from: c.primeOrder, count: c.primeOrderSize)
        writeParameterEnd(at: 0x322 &+ ((c.primeOrderSize &+ 3) / 4))
    }
    public func setRSACRTExp(_ c: PKARSACRTExpInput) {
        registers.writeRAM(0x2, value: PKAEncoding.bitSize(bytes: c.size))
        writeBytes(toRAM: 0xCC, from: c.pOpDp, count: c.size / 2)
        writeParameterEnd(at: 0xCC &+ (c.size / 8))
        writeBytes(toRAM: 0x29E, from: c.pOpDq, count: c.size / 2)
        writeParameterEnd(at: 0x29E &+ (c.size / 8))
        writeBytes(toRAM: 0x152, from: c.pOpQinv, count: c.size / 2)
        writeParameterEnd(at: 0x152 &+ (c.size / 8))
        writeBytes(toRAM: 0x1D8, from: c.pPrimeP, count: c.size / 2)
        writeParameterEnd(at: 0x1D8 &+ (c.size / 8))
        writeBytes(toRAM: 0x322, from: c.pPrimeQ, count: c.size / 2)
        writeParameterEnd(at: 0x322 &+ (c.size / 8))
        writeBytes(toRAM: 0x3A8, from: c.popA, count: c.size)
        writeParameterEnd(at: 0x3A8 &+ (c.size / 4))
    }
    public func setPointCheck(_ c: PKAPointCheckInput) {
        registers.writeRAM(0x2, value: PKAEncoding.optimizedBitSize(bytes: c.modulusSize, mostSignificantByte: c.modulus!.pointee))
        registers.writeRAM(0x4, value: c.coefSign)
        writeBytes(toRAM: 0x6, from: c.coefA, count: c.modulusSize)
        writeParameterEnd(at: 0x6 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x48, from: c.coefB, count: c.modulusSize)
        writeParameterEnd(at: 0x48 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x1C, from: c.modulus, count: c.modulusSize)
        writeParameterEnd(at: 0x1C &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x5E, from: c.pointX, count: c.modulusSize)
        writeParameterEnd(at: 0x5E &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x74, from: c.pointY, count: c.modulusSize)
        writeParameterEnd(at: 0x74 &+ ((c.modulusSize &+ 3) / 4))
        writeWords(toRAM: 0x32, from: c.pMontgomeryParam, count: (c.modulusSize / 4))
        writeParameterEnd(at: 0x32 &+ ((c.modulusSize &+ 3) / 4))
    }
    public func setECCMul(_ c: PKAECCMulInput) {
        registers.writeRAM(0x0, value: PKAEncoding.optimizedBitSize(bytes: c.scalarMulSize, mostSignificantByte: c.primeOrder!.pointee))
        registers.writeRAM(0x2, value: PKAEncoding.optimizedBitSize(bytes: c.modulusSize, mostSignificantByte: c.modulus!.pointee))
        registers.writeRAM(0x4, value: c.coefSign)
        writeBytes(toRAM: 0x6, from: c.coefA, count: c.modulusSize)
        writeParameterEnd(at: 0x6 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x48, from: c.coefB, count: c.modulusSize)
        writeParameterEnd(at: 0x48 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x322, from: c.modulus, count: c.modulusSize)
        writeParameterEnd(at: 0x322 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x3A8, from: c.scalarMul, count: c.scalarMulSize)
        writeParameterEnd(at: 0x3A8 &+ ((c.scalarMulSize &+ 3) / 4))
        writeBytes(toRAM: 0x5E, from: c.pointX, count: c.modulusSize)
        writeParameterEnd(at: 0x5E &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x1C, from: c.pointY, count: c.modulusSize)
        writeParameterEnd(at: 0x1C &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x2E2, from: c.primeOrder, count: c.modulusSize)
        writeParameterEnd(at: 0x2E2 &+ ((c.modulusSize &+ 3) / 4))
    }
    public func setECCMulEx(_ c: PKAECCMulExInput) {
        registers.writeRAM(0x0, value: PKAEncoding.optimizedBitSize(bytes: c.primeOrderSize, mostSignificantByte: c.primeOrder!.pointee))
        registers.writeRAM(0x2, value: PKAEncoding.optimizedBitSize(bytes: c.modulusSize, mostSignificantByte: c.modulus!.pointee))
        registers.writeRAM(0x4, value: c.coefSign)
        writeBytes(toRAM: 0x6, from: c.coefA, count: c.modulusSize)
        writeParameterEnd(at: 0x6 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x48, from: c.coefB, count: c.modulusSize)
        writeParameterEnd(at: 0x48 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x322, from: c.modulus, count: c.modulusSize)
        writeParameterEnd(at: 0x322 &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x3A8, from: c.scalarMul, count: c.scalarMulSize)
        writeParameterEnd(at: 0x3A8 &+ ((c.scalarMulSize &+ 3) / 4))
        writeBytes(toRAM: 0x5E, from: c.pointX, count: c.modulusSize)
        writeParameterEnd(at: 0x5E &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x1C, from: c.pointY, count: c.modulusSize)
        writeParameterEnd(at: 0x1C &+ ((c.modulusSize &+ 3) / 4))
        writeBytes(toRAM: 0x2E2, from: c.primeOrder, count: c.modulusSize)
        writeParameterEnd(at: 0x2E2 &+ ((c.modulusSize &+ 3) / 4))
    }
    public func setModInv(_ c: PKAModInvInput) {
        registers.writeRAM(0x2, value: PKAEncoding.bitSize(words: c.size))
        writeWords(toRAM: 0x194, from: c.pOp1, count: c.size)
        writeParameterEnd(at: 0x194 &+ c.size)
        writeBytes(toRAM: 0x21A, from: c.pMod, count: c.size &* 4)
        writeParameterEnd(at: 0x21A &+ c.size)
    }
    public func setModRed(_ c: PKAModRedInput) {
        registers.writeRAM(0x0, value: PKAEncoding.bitSize(words: c.opSize))
        registers.writeRAM(0x2, value: PKAEncoding.bitSize(bytes: c.modSize))
        writeWords(toRAM: 0x194, from: c.pOp1, count: c.opSize)
        writeParameterEnd(at: 0x194 &+ c.opSize)
        writeBytes(toRAM: 0x21A, from: c.pMod, count: c.modSize)
        writeParameterEnd(at: 0x21A &+ ((c.modSize &+ 3) / 4))
    }
    public func setECCDoubleBaseLadder(_ c: PKAECCDoubleBaseLadderInput) {
        registers.writeRAM(0x0, value: PKAEncoding.bitSize(bytes: c.primeOrderSize))
        registers.writeRAM(0x2, value: PKAEncoding.bitSize(bytes: c.modulusSize))
        registers.writeRAM(0x4, value: c.coefSign)
        writeBytes(toRAM: 0x6, from: c.coefA, count: c.modulusSize)
        writeParameterEnd(at: 0x6 &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0x1C, from: c.modulus, count: c.modulusSize)
        writeParameterEnd(at: 0x1C &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0x48, from: c.integerK, count: c.modulusSize)
        writeParameterEnd(at: 0x48 &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0x5E, from: c.integerM, count: c.modulusSize)
        writeParameterEnd(at: 0x5E &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0x8A, from: c.basePointX1, count: c.modulusSize)
        writeParameterEnd(at: 0x8A &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0xA0, from: c.basePointY1, count: c.modulusSize)
        writeParameterEnd(at: 0xA0 &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0xB6, from: c.basePointZ1, count: c.modulusSize)
        writeParameterEnd(at: 0xB6 &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0xCC, from: c.basePointX2, count: c.modulusSize)
        writeParameterEnd(at: 0xCC &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0xE2, from: c.basePointY2, count: c.modulusSize)
        writeParameterEnd(at: 0xE2 &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0xF8, from: c.basePointZ2, count: c.modulusSize)
        writeParameterEnd(at: 0xF8 &+ (c.modulusSize / 4))
    }
    public func setECCProjective2Affine(_ c: PKAECCProjective2AffineInput) {
        registers.writeRAM(0x2, value: PKAEncoding.bitSize(bytes: c.modulusSize))
        writeBytes(toRAM: 0x1C, from: c.modulus, count: c.modulusSize)
        writeParameterEnd(at: 0x1C &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0x258, from: c.basePointX, count: c.modulusSize)
        writeParameterEnd(at: 0x258 &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0x26E, from: c.basePointY, count: c.modulusSize)
        writeParameterEnd(at: 0x26E &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0x284, from: c.basePointZ, count: c.modulusSize)
        writeParameterEnd(at: 0x284 &+ (c.modulusSize / 4))
        writeWords(toRAM: 0x32, from: c.pMontgomeryParam, count: (c.modulusSize / 4))
        writeParameterEnd(at: 0x32 &+ (c.modulusSize / 4))
    }
    public func setECCCompleteAddition(_ c: PKAECCCompleteAdditionInput) {
        registers.writeRAM(0x2, value: PKAEncoding.bitSize(bytes: c.modulusSize))
        registers.writeRAM(0x4, value: c.coefSign)
        writeBytes(toRAM: 0x1C, from: c.modulus, count: c.modulusSize)
        writeParameterEnd(at: 0x1C &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0x6, from: c.coefA, count: c.modulusSize)
        writeParameterEnd(at: 0x6 &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0x8A, from: c.basePointX1, count: c.modulusSize)
        writeParameterEnd(at: 0x8A &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0xA0, from: c.basePointY1, count: c.modulusSize)
        writeParameterEnd(at: 0xA0 &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0xB6, from: c.basePointZ1, count: c.modulusSize)
        writeParameterEnd(at: 0xB6 &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0xCC, from: c.basePointX2, count: c.modulusSize)
        writeParameterEnd(at: 0xCC &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0xE2, from: c.basePointY2, count: c.modulusSize)
        writeParameterEnd(at: 0xE2 &+ (c.modulusSize / 4))
        writeBytes(toRAM: 0xF8, from: c.basePointZ2, count: c.modulusSize)
        writeParameterEnd(at: 0xF8 &+ (c.modulusSize / 4))
    }
    public func setMontgomeryParam(size: UInt32, operand: UnsafePointer<UInt8>?) {
        if let operand {
            var skip: UInt32 = 0
            while skip < size && operand[Int(skip)] == 0 { skip &+= 1 }
            let newSize = size &- skip
            precondition(newSize != 0, "The PKA modulus must contain a nonzero byte")
            registers.writeRAM(0x2, value: PKAEncoding.optimizedBitSize(bytes: newSize, mostSignificantByte: operand[Int(skip)]))
            writeBytes(toRAM: 0x322, from: operand, count: size)
            writeParameterEnd(at: 0x322 &+ ((size &+ 3) / 4))
        }
    }
    public func setArithmetic(size: UInt32, operand1: UnsafePointer<UInt32>?, operand2: UnsafePointer<UInt32>?, modulus: UnsafePointer<UInt8>?) {
        registers.writeRAM(0x2, value: PKAEncoding.bitSize(words: size))
        if let operand1 {
            writeWords(toRAM: 0x194, from: operand1, count: size)
            writeParameterEnd(at: 0x194 &+ size)
        }
        if let operand2 {
            writeWords(toRAM: 0x21A, from: operand2, count: size)
            writeParameterEnd(at: 0x21A &+ size)
        }
        if let modulus {
            writeBytes(toRAM: 0x322, from: modulus, count: size &* 4)
            writeParameterEnd(at: 0x322 &+ size)
        }
    }
}
