// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PKA operations and definitions from stm32h7rsxx_hal_pka.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct PKAECCMulInput {
    public var scalarMulSize: UInt32
    public var modulusSize: UInt32
    public var coefSign: UInt32
    public var coefA: UnsafePointer<UInt8>?
    public var coefB: UnsafePointer<UInt8>?
    public var modulus: UnsafePointer<UInt8>?
    public var pointX: UnsafePointer<UInt8>?
    public var pointY: UnsafePointer<UInt8>?
    public var scalarMul: UnsafePointer<UInt8>?
    public var primeOrder: UnsafePointer<UInt8>?
    public init(scalarMulSize: UInt32 = 0, modulusSize: UInt32 = 0, coefSign: UInt32 = 0, coefA: UnsafePointer<UInt8>? = nil, coefB: UnsafePointer<UInt8>? = nil, modulus: UnsafePointer<UInt8>? = nil, pointX: UnsafePointer<UInt8>? = nil, pointY: UnsafePointer<UInt8>? = nil, scalarMul: UnsafePointer<UInt8>? = nil, primeOrder: UnsafePointer<UInt8>? = nil) {
        self.scalarMulSize = scalarMulSize
        self.modulusSize = modulusSize
        self.coefSign = coefSign
        self.coefA = coefA
        self.coefB = coefB
        self.modulus = modulus
        self.pointX = pointX
        self.pointY = pointY
        self.scalarMul = scalarMul
        self.primeOrder = primeOrder
    }
}
public struct PKAECCMulExInput {
    public var primeOrderSize: UInt32
    public var scalarMulSize: UInt32
    public var modulusSize: UInt32
    public var coefSign: UInt32
    public var coefA: UnsafePointer<UInt8>?
    public var coefB: UnsafePointer<UInt8>?
    public var modulus: UnsafePointer<UInt8>?
    public var pointX: UnsafePointer<UInt8>?
    public var pointY: UnsafePointer<UInt8>?
    public var scalarMul: UnsafePointer<UInt8>?
    public var primeOrder: UnsafePointer<UInt8>?
    public init(primeOrderSize: UInt32 = 0, scalarMulSize: UInt32 = 0, modulusSize: UInt32 = 0, coefSign: UInt32 = 0, coefA: UnsafePointer<UInt8>? = nil, coefB: UnsafePointer<UInt8>? = nil, modulus: UnsafePointer<UInt8>? = nil, pointX: UnsafePointer<UInt8>? = nil, pointY: UnsafePointer<UInt8>? = nil, scalarMul: UnsafePointer<UInt8>? = nil, primeOrder: UnsafePointer<UInt8>? = nil) {
        self.primeOrderSize = primeOrderSize
        self.scalarMulSize = scalarMulSize
        self.modulusSize = modulusSize
        self.coefSign = coefSign
        self.coefA = coefA
        self.coefB = coefB
        self.modulus = modulus
        self.pointX = pointX
        self.pointY = pointY
        self.scalarMul = scalarMul
        self.primeOrder = primeOrder
    }
}
public struct PKAPointCheckInput {
    public var modulusSize: UInt32
    public var coefSign: UInt32
    public var coefA: UnsafePointer<UInt8>?
    public var coefB: UnsafePointer<UInt8>?
    public var modulus: UnsafePointer<UInt8>?
    public var pointX: UnsafePointer<UInt8>?
    public var pointY: UnsafePointer<UInt8>?
    public var pMontgomeryParam: UnsafePointer<UInt32>?
    public init(modulusSize: UInt32 = 0, coefSign: UInt32 = 0, coefA: UnsafePointer<UInt8>? = nil, coefB: UnsafePointer<UInt8>? = nil, modulus: UnsafePointer<UInt8>? = nil, pointX: UnsafePointer<UInt8>? = nil, pointY: UnsafePointer<UInt8>? = nil, pMontgomeryParam: UnsafePointer<UInt32>? = nil) {
        self.modulusSize = modulusSize
        self.coefSign = coefSign
        self.coefA = coefA
        self.coefB = coefB
        self.modulus = modulus
        self.pointX = pointX
        self.pointY = pointY
        self.pMontgomeryParam = pMontgomeryParam
    }
}
public struct PKARSACRTExpInput {
    public var size: UInt32
    public var pOpDp: UnsafePointer<UInt8>?
    public var pOpDq: UnsafePointer<UInt8>?
    public var pOpQinv: UnsafePointer<UInt8>?
    public var pPrimeP: UnsafePointer<UInt8>?
    public var pPrimeQ: UnsafePointer<UInt8>?
    public var popA: UnsafePointer<UInt8>?
    public init(size: UInt32 = 0, pOpDp: UnsafePointer<UInt8>? = nil, pOpDq: UnsafePointer<UInt8>? = nil, pOpQinv: UnsafePointer<UInt8>? = nil, pPrimeP: UnsafePointer<UInt8>? = nil, pPrimeQ: UnsafePointer<UInt8>? = nil, popA: UnsafePointer<UInt8>? = nil) {
        self.size = size
        self.pOpDp = pOpDp
        self.pOpDq = pOpDq
        self.pOpQinv = pOpQinv
        self.pPrimeP = pPrimeP
        self.pPrimeQ = pPrimeQ
        self.popA = popA
    }
}
public struct PKAECDSAVerifInput {
    public var primeOrderSize: UInt32
    public var modulusSize: UInt32
    public var coefSign: UInt32
    public var coef: UnsafePointer<UInt8>?
    public var modulus: UnsafePointer<UInt8>?
    public var basePointX: UnsafePointer<UInt8>?
    public var basePointY: UnsafePointer<UInt8>?
    public var pPubKeyCurvePtX: UnsafePointer<UInt8>?
    public var pPubKeyCurvePtY: UnsafePointer<UInt8>?
    public var rSign: UnsafePointer<UInt8>?
    public var sSign: UnsafePointer<UInt8>?
    public var hash: UnsafePointer<UInt8>?
    public var primeOrder: UnsafePointer<UInt8>?
    public init(primeOrderSize: UInt32 = 0, modulusSize: UInt32 = 0, coefSign: UInt32 = 0, coef: UnsafePointer<UInt8>? = nil, modulus: UnsafePointer<UInt8>? = nil, basePointX: UnsafePointer<UInt8>? = nil, basePointY: UnsafePointer<UInt8>? = nil, pPubKeyCurvePtX: UnsafePointer<UInt8>? = nil, pPubKeyCurvePtY: UnsafePointer<UInt8>? = nil, rSign: UnsafePointer<UInt8>? = nil, sSign: UnsafePointer<UInt8>? = nil, hash: UnsafePointer<UInt8>? = nil, primeOrder: UnsafePointer<UInt8>? = nil) {
        self.primeOrderSize = primeOrderSize
        self.modulusSize = modulusSize
        self.coefSign = coefSign
        self.coef = coef
        self.modulus = modulus
        self.basePointX = basePointX
        self.basePointY = basePointY
        self.pPubKeyCurvePtX = pPubKeyCurvePtX
        self.pPubKeyCurvePtY = pPubKeyCurvePtY
        self.rSign = rSign
        self.sSign = sSign
        self.hash = hash
        self.primeOrder = primeOrder
    }
}
public struct PKAECDSASignInput {
    public var primeOrderSize: UInt32
    public var modulusSize: UInt32
    public var coefSign: UInt32
    public var coef: UnsafePointer<UInt8>?
    public var coefB: UnsafePointer<UInt8>?
    public var modulus: UnsafePointer<UInt8>?
    public var integer: UnsafePointer<UInt8>?
    public var basePointX: UnsafePointer<UInt8>?
    public var basePointY: UnsafePointer<UInt8>?
    public var hash: UnsafePointer<UInt8>?
    public var privateKey: UnsafePointer<UInt8>?
    public var primeOrder: UnsafePointer<UInt8>?
    public init(primeOrderSize: UInt32 = 0, modulusSize: UInt32 = 0, coefSign: UInt32 = 0, coef: UnsafePointer<UInt8>? = nil, coefB: UnsafePointer<UInt8>? = nil, modulus: UnsafePointer<UInt8>? = nil, integer: UnsafePointer<UInt8>? = nil, basePointX: UnsafePointer<UInt8>? = nil, basePointY: UnsafePointer<UInt8>? = nil, hash: UnsafePointer<UInt8>? = nil, privateKey: UnsafePointer<UInt8>? = nil, primeOrder: UnsafePointer<UInt8>? = nil) {
        self.primeOrderSize = primeOrderSize
        self.modulusSize = modulusSize
        self.coefSign = coefSign
        self.coef = coef
        self.coefB = coefB
        self.modulus = modulus
        self.integer = integer
        self.basePointX = basePointX
        self.basePointY = basePointY
        self.hash = hash
        self.privateKey = privateKey
        self.primeOrder = primeOrder
    }
}
public struct PKAECDSASignOutput {
    public var rSign: UnsafeMutablePointer<UInt8>?
    public var sSign: UnsafeMutablePointer<UInt8>?
    public init(rSign: UnsafeMutablePointer<UInt8>? = nil, sSign: UnsafeMutablePointer<UInt8>? = nil) {
        self.rSign = rSign
        self.sSign = sSign
    }
}
public struct PKAECDSASignExtendedOutput {
    public var ptX: UnsafeMutablePointer<UInt8>?
    public var ptY: UnsafeMutablePointer<UInt8>?
    public init(ptX: UnsafeMutablePointer<UInt8>? = nil, ptY: UnsafeMutablePointer<UInt8>? = nil) {
        self.ptX = ptX
        self.ptY = ptY
    }
}
public typealias PKAECCMulOutput = PKAECDSASignExtendedOutput
public typealias PKAECCProjective2AffineOutput = PKAECDSASignExtendedOutput
public typealias PKAECCDoubleBaseLadderOutput = PKAECDSASignExtendedOutput
public struct PKAECCCompleteAdditionOutput {
    public var ptX: UnsafeMutablePointer<UInt8>?
    public var ptY: UnsafeMutablePointer<UInt8>?
    public var ptZ: UnsafeMutablePointer<UInt8>?
    public init(ptX: UnsafeMutablePointer<UInt8>? = nil, ptY: UnsafeMutablePointer<UInt8>? = nil, ptZ: UnsafeMutablePointer<UInt8>? = nil) {
        self.ptX = ptX
        self.ptY = ptY
        self.ptZ = ptZ
    }
}
public struct PKAModExpInput {
    public var expSize: UInt32
    public var opSize: UInt32
    public var pExp: UnsafePointer<UInt8>?
    public var pOp1: UnsafePointer<UInt8>?
    public var pMod: UnsafePointer<UInt8>?
    public init(expSize: UInt32 = 0, opSize: UInt32 = 0, pExp: UnsafePointer<UInt8>? = nil, pOp1: UnsafePointer<UInt8>? = nil, pMod: UnsafePointer<UInt8>? = nil) {
        self.expSize = expSize
        self.opSize = opSize
        self.pExp = pExp
        self.pOp1 = pOp1
        self.pMod = pMod
    }
}
public struct PKAModExpProtectModeInput {
    public var expSize: UInt32
    public var opSize: UInt32
    public var pOp1: UnsafePointer<UInt8>?
    public var pExp: UnsafePointer<UInt8>?
    public var pMod: UnsafePointer<UInt8>?
    public var pPhi: UnsafePointer<UInt8>?
    public init(expSize: UInt32 = 0, opSize: UInt32 = 0, pOp1: UnsafePointer<UInt8>? = nil, pExp: UnsafePointer<UInt8>? = nil, pMod: UnsafePointer<UInt8>? = nil, pPhi: UnsafePointer<UInt8>? = nil) {
        self.expSize = expSize
        self.opSize = opSize
        self.pOp1 = pOp1
        self.pExp = pExp
        self.pMod = pMod
        self.pPhi = pPhi
    }
}
public struct PKAModExpFastModeInput {
    public var expSize: UInt32
    public var opSize: UInt32
    public var pExp: UnsafePointer<UInt8>?
    public var pOp1: UnsafePointer<UInt8>?
    public var pMod: UnsafePointer<UInt8>?
    public var pMontgomeryParam: UnsafePointer<UInt32>?
    public init(expSize: UInt32 = 0, opSize: UInt32 = 0, pExp: UnsafePointer<UInt8>? = nil, pOp1: UnsafePointer<UInt8>? = nil, pMod: UnsafePointer<UInt8>? = nil, pMontgomeryParam: UnsafePointer<UInt32>? = nil) {
        self.expSize = expSize
        self.opSize = opSize
        self.pExp = pExp
        self.pOp1 = pOp1
        self.pMod = pMod
        self.pMontgomeryParam = pMontgomeryParam
    }
}
public struct PKAMontgomeryParamInput {
    public var size: UInt32
    public var pOp1: UnsafePointer<UInt8>?
    public init(size: UInt32 = 0, pOp1: UnsafePointer<UInt8>? = nil) {
        self.size = size
        self.pOp1 = pOp1
    }
}
public struct PKAAddInput {
    public var size: UInt32
    public var pOp1: UnsafePointer<UInt32>?
    public var pOp2: UnsafePointer<UInt32>?
    public init(size: UInt32 = 0, pOp1: UnsafePointer<UInt32>? = nil, pOp2: UnsafePointer<UInt32>? = nil) {
        self.size = size
        self.pOp1 = pOp1
        self.pOp2 = pOp2
    }
}
public typealias PKASubInput = PKAAddInput
public typealias PKAMulInput = PKAAddInput
public typealias PKACmpInput = PKAAddInput
public struct PKAModInvInput {
    public var size: UInt32
    public var pOp1: UnsafePointer<UInt32>?
    public var pMod: UnsafePointer<UInt8>?
    public init(size: UInt32 = 0, pOp1: UnsafePointer<UInt32>? = nil, pMod: UnsafePointer<UInt8>? = nil) {
        self.size = size
        self.pOp1 = pOp1
        self.pMod = pMod
    }
}
public struct PKAModRedInput {
    public var opSize: UInt32
    public var modSize: UInt32
    public var pOp1: UnsafePointer<UInt32>?
    public var pMod: UnsafePointer<UInt8>?
    public init(opSize: UInt32 = 0, modSize: UInt32 = 0, pOp1: UnsafePointer<UInt32>? = nil, pMod: UnsafePointer<UInt8>? = nil) {
        self.opSize = opSize
        self.modSize = modSize
        self.pOp1 = pOp1
        self.pMod = pMod
    }
}
public struct PKAModAddInput {
    public var size: UInt32
    public var pOp1: UnsafePointer<UInt32>?
    public var pOp2: UnsafePointer<UInt32>?
    public var pOp3: UnsafePointer<UInt8>?
    public init(size: UInt32 = 0, pOp1: UnsafePointer<UInt32>? = nil, pOp2: UnsafePointer<UInt32>? = nil, pOp3: UnsafePointer<UInt8>? = nil) {
        self.size = size
        self.pOp1 = pOp1
        self.pOp2 = pOp2
        self.pOp3 = pOp3
    }
}
public typealias PKAModSubInput = PKAModAddInput
public typealias PKAMontgomeryMulInput = PKAModAddInput
public struct PKAECCDoubleBaseLadderInput {
    public var primeOrderSize: UInt32
    public var modulusSize: UInt32
    public var coefSign: UInt32
    public var coefA: UnsafePointer<UInt8>?
    public var modulus: UnsafePointer<UInt8>?
    public var integerK: UnsafePointer<UInt8>?
    public var integerM: UnsafePointer<UInt8>?
    public var basePointX1: UnsafePointer<UInt8>?
    public var basePointY1: UnsafePointer<UInt8>?
    public var basePointZ1: UnsafePointer<UInt8>?
    public var basePointX2: UnsafePointer<UInt8>?
    public var basePointY2: UnsafePointer<UInt8>?
    public var basePointZ2: UnsafePointer<UInt8>?
    public init(primeOrderSize: UInt32 = 0, modulusSize: UInt32 = 0, coefSign: UInt32 = 0, coefA: UnsafePointer<UInt8>? = nil, modulus: UnsafePointer<UInt8>? = nil, integerK: UnsafePointer<UInt8>? = nil, integerM: UnsafePointer<UInt8>? = nil, basePointX1: UnsafePointer<UInt8>? = nil, basePointY1: UnsafePointer<UInt8>? = nil, basePointZ1: UnsafePointer<UInt8>? = nil, basePointX2: UnsafePointer<UInt8>? = nil, basePointY2: UnsafePointer<UInt8>? = nil, basePointZ2: UnsafePointer<UInt8>? = nil) {
        self.primeOrderSize = primeOrderSize
        self.modulusSize = modulusSize
        self.coefSign = coefSign
        self.coefA = coefA
        self.modulus = modulus
        self.integerK = integerK
        self.integerM = integerM
        self.basePointX1 = basePointX1
        self.basePointY1 = basePointY1
        self.basePointZ1 = basePointZ1
        self.basePointX2 = basePointX2
        self.basePointY2 = basePointY2
        self.basePointZ2 = basePointZ2
    }
}
public struct PKAECCProjective2AffineInput {
    public var modulusSize: UInt32
    public var modulus: UnsafePointer<UInt8>?
    public var basePointX: UnsafePointer<UInt8>?
    public var basePointY: UnsafePointer<UInt8>?
    public var basePointZ: UnsafePointer<UInt8>?
    public var pMontgomeryParam: UnsafePointer<UInt32>?
    public init(modulusSize: UInt32 = 0, modulus: UnsafePointer<UInt8>? = nil, basePointX: UnsafePointer<UInt8>? = nil, basePointY: UnsafePointer<UInt8>? = nil, basePointZ: UnsafePointer<UInt8>? = nil, pMontgomeryParam: UnsafePointer<UInt32>? = nil) {
        self.modulusSize = modulusSize
        self.modulus = modulus
        self.basePointX = basePointX
        self.basePointY = basePointY
        self.basePointZ = basePointZ
        self.pMontgomeryParam = pMontgomeryParam
    }
}
public struct PKAECCCompleteAdditionInput {
    public var modulusSize: UInt32
    public var coefSign: UInt32
    public var modulus: UnsafePointer<UInt8>?
    public var coefA: UnsafePointer<UInt8>?
    public var basePointX1: UnsafePointer<UInt8>?
    public var basePointY1: UnsafePointer<UInt8>?
    public var basePointZ1: UnsafePointer<UInt8>?
    public var basePointX2: UnsafePointer<UInt8>?
    public var basePointY2: UnsafePointer<UInt8>?
    public var basePointZ2: UnsafePointer<UInt8>?
    public init(modulusSize: UInt32 = 0, coefSign: UInt32 = 0, modulus: UnsafePointer<UInt8>? = nil, coefA: UnsafePointer<UInt8>? = nil, basePointX1: UnsafePointer<UInt8>? = nil, basePointY1: UnsafePointer<UInt8>? = nil, basePointZ1: UnsafePointer<UInt8>? = nil, basePointX2: UnsafePointer<UInt8>? = nil, basePointY2: UnsafePointer<UInt8>? = nil, basePointZ2: UnsafePointer<UInt8>? = nil) {
        self.modulusSize = modulusSize
        self.coefSign = coefSign
        self.modulus = modulus
        self.coefA = coefA
        self.basePointX1 = basePointX1
        self.basePointY1 = basePointY1
        self.basePointZ1 = basePointZ1
        self.basePointX2 = basePointX2
        self.basePointY2 = basePointY2
        self.basePointZ2 = basePointZ2
    }
}
