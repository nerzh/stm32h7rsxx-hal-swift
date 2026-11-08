import CPKAReference
import STM32H7RSHAL

struct PKAModel: PKARegisterIO, PKAHandleIO, PKACallbackIO, PKASystemIO {
    let state: OpaquePointer
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func get(_ area: UInt32, _ i: UInt32) -> UInt32 { CPKA_Get(state,area,i) }
    func set(_ area: UInt32, _ i: UInt32, _ value: UInt32) { CPKA_Set(state,area,i,value) }
    func words(_ index: UInt32) -> UnsafeMutablePointer<UInt32> { CPKA_Buffer(state,index)! }
    func bytes(_ index: UInt32) -> UnsafeMutablePointer<UInt8> { UnsafeMutableRawPointer(words(index)).assumingMemoryBound(to:UInt8.self) }
    func read(_ register: PKARegister) -> UInt32 { get(0,register.rawValue/4) }
    func write(_ register: PKARegister, value: UInt32) { set(0,register.rawValue/4,value) }
    func readRAM(_ index: UInt32) -> UInt32 { get(1,index) }
    func writeRAM(_ index: UInt32, value: UInt32) { set(1,index,value) }
    func readOperandWord(_ pointer: UnsafePointer<UInt32>) -> UInt32 { pointer.pointee }
    func writeResultWord(_ pointer: UnsafeMutablePointer<UInt32>, value: UInt32) { pointer.pointee=value }
    func read(_ word: PKAHandleWord) -> UInt32 { get(2,UInt32(word.rawValue)) }
    func write(_ word: PKAHandleWord, value: UInt32) { set(2,UInt32(word.rawValue),value) }
    func read(_ id: PKACallbackID) -> PKACallback? { Self.callback(id.rawValue,CPKA_GetCallback(state,id.rawValue)) }
    func write(_ id: PKACallbackID, value: PKACallback?) {
        let token: UInt32 = value.map { unsafeBitCast($0,to:UInt.self)==unsafeBitCast(Self.callback(id.rawValue,1)!,to:UInt.self) ? 1 : 2 } ?? 0
        CPKA_SetCallback(state,id.rawValue,token)
    }
    static func callback(_ id: UInt32, _ token: UInt32) -> PKACallback? {
        if token==0 { return nil }
        switch (id,token) {
        case (0,1): return { CPKA_Callback(OpaquePointer($0!),0,1) }
        case (0,2): return { CPKA_Callback(OpaquePointer($0!),0,2) }
        case (1,1): return { CPKA_Callback(OpaquePointer($0!),1,1) }
        case (1,2): return { CPKA_Callback(OpaquePointer($0!),1,2) }
        case (2,1): return { CPKA_Callback(OpaquePointer($0!),2,1) }
        case (2,2): return { CPKA_Callback(OpaquePointer($0!),2,2) }
        case (3,1): return { CPKA_Callback(OpaquePointer($0!),3,1); let m=PKAModel(state:OpaquePointer($0!)); m.driver.deinitializeMSP(system:m,getTick:m.tick) }
        case (3,2): return { CPKA_Callback(OpaquePointer($0!),3,2) }
        default: return nil
        }
    }
    var defaults: PKACallbackDefaults { .init(operationComplete:Self.callback(0,1)!,error:Self.callback(1,1)!,mspInitialize:Self.callback(2,1)!,mspDeinitialize:Self.callback(3,1)!) }
    var driver: PKA<Self,Self,Self> { .init(registers:self,handle:self,callbacks:self,defaults:defaults,useRegisteredCallbacks:get(5,2) != 0) }
    func tick() -> UInt32 { CPKA_TickFor(state) }
    func forceReset() { CPKA_System(state,0) }
    func releaseReset() { CPKA_System(state,1) }
    func disableClock() { CPKA_System(state,2) }
    func disableInterrupt() { CPKA_System(state,3) }
    var input0: PKAECCMulInput {
        var v=PKAECCMulInput()
        v.scalarMulSize=get(3,0)
        v.modulusSize=get(3,1)
        v.coefSign=get(3,2)
        v.coefA=get(4,6)&(1<<3) != 0 ? nil : UnsafePointer(bytes(3))
        v.coefB=get(4,6)&(1<<4) != 0 ? nil : UnsafePointer(bytes(4))
        v.modulus=get(4,6)&(1<<5) != 0 ? nil : UnsafePointer(bytes(5))
        v.pointX=get(4,6)&(1<<6) != 0 ? nil : UnsafePointer(bytes(6))
        v.pointY=get(4,6)&(1<<7) != 0 ? nil : UnsafePointer(bytes(7))
        v.scalarMul=get(4,6)&(1<<8) != 0 ? nil : UnsafePointer(bytes(8))
        v.primeOrder=get(4,6)&(1<<9) != 0 ? nil : UnsafePointer(bytes(9))
        return v
    }
    var input1: PKAECCMulExInput {
        var v=PKAECCMulExInput()
        v.primeOrderSize=get(3,20)
        v.scalarMulSize=get(3,21)
        v.modulusSize=get(3,22)
        v.coefSign=get(3,23)
        v.coefA=get(4,6)&(1<<4) != 0 ? nil : UnsafePointer(bytes(4))
        v.coefB=get(4,6)&(1<<5) != 0 ? nil : UnsafePointer(bytes(5))
        v.modulus=get(4,6)&(1<<6) != 0 ? nil : UnsafePointer(bytes(6))
        v.pointX=get(4,6)&(1<<7) != 0 ? nil : UnsafePointer(bytes(7))
        v.pointY=get(4,6)&(1<<8) != 0 ? nil : UnsafePointer(bytes(8))
        v.scalarMul=get(4,6)&(1<<9) != 0 ? nil : UnsafePointer(bytes(9))
        v.primeOrder=get(4,6)&(1<<10) != 0 ? nil : UnsafePointer(bytes(10))
        return v
    }
    var input2: PKAPointCheckInput {
        var v=PKAPointCheckInput()
        v.modulusSize=get(3,40)
        v.coefSign=get(3,41)
        v.coefA=get(4,6)&(1<<2) != 0 ? nil : UnsafePointer(bytes(2))
        v.coefB=get(4,6)&(1<<3) != 0 ? nil : UnsafePointer(bytes(3))
        v.modulus=get(4,6)&(1<<4) != 0 ? nil : UnsafePointer(bytes(4))
        v.pointX=get(4,6)&(1<<5) != 0 ? nil : UnsafePointer(bytes(5))
        v.pointY=get(4,6)&(1<<6) != 0 ? nil : UnsafePointer(bytes(6))
        v.pMontgomeryParam=get(4,6)&(1<<7) != 0 ? nil : UnsafePointer(words(7))
        return v
    }
    var input3: PKARSACRTExpInput {
        var v=PKARSACRTExpInput()
        v.size=get(3,60)
        v.pOpDp=get(4,6)&(1<<1) != 0 ? nil : UnsafePointer(bytes(1))
        v.pOpDq=get(4,6)&(1<<2) != 0 ? nil : UnsafePointer(bytes(2))
        v.pOpQinv=get(4,6)&(1<<3) != 0 ? nil : UnsafePointer(bytes(3))
        v.pPrimeP=get(4,6)&(1<<4) != 0 ? nil : UnsafePointer(bytes(4))
        v.pPrimeQ=get(4,6)&(1<<5) != 0 ? nil : UnsafePointer(bytes(5))
        v.popA=get(4,6)&(1<<6) != 0 ? nil : UnsafePointer(bytes(6))
        return v
    }
    var input4: PKAECDSAVerifInput {
        var v=PKAECDSAVerifInput()
        v.primeOrderSize=get(3,80)
        v.modulusSize=get(3,81)
        v.coefSign=get(3,82)
        v.coef=get(4,6)&(1<<3) != 0 ? nil : UnsafePointer(bytes(3))
        v.modulus=get(4,6)&(1<<4) != 0 ? nil : UnsafePointer(bytes(4))
        v.basePointX=get(4,6)&(1<<5) != 0 ? nil : UnsafePointer(bytes(5))
        v.basePointY=get(4,6)&(1<<6) != 0 ? nil : UnsafePointer(bytes(6))
        v.pPubKeyCurvePtX=get(4,6)&(1<<7) != 0 ? nil : UnsafePointer(bytes(7))
        v.pPubKeyCurvePtY=get(4,6)&(1<<8) != 0 ? nil : UnsafePointer(bytes(8))
        v.rSign=get(4,6)&(1<<9) != 0 ? nil : UnsafePointer(bytes(9))
        v.sSign=get(4,6)&(1<<10) != 0 ? nil : UnsafePointer(bytes(10))
        v.hash=get(4,6)&(1<<11) != 0 ? nil : UnsafePointer(bytes(11))
        v.primeOrder=get(4,6)&(1<<12) != 0 ? nil : UnsafePointer(bytes(12))
        return v
    }
    var input5: PKAECDSASignInput {
        var v=PKAECDSASignInput()
        v.primeOrderSize=get(3,100)
        v.modulusSize=get(3,101)
        v.coefSign=get(3,102)
        v.coef=get(4,6)&(1<<3) != 0 ? nil : UnsafePointer(bytes(3))
        v.coefB=get(4,6)&(1<<4) != 0 ? nil : UnsafePointer(bytes(4))
        v.modulus=get(4,6)&(1<<5) != 0 ? nil : UnsafePointer(bytes(5))
        v.integer=get(4,6)&(1<<6) != 0 ? nil : UnsafePointer(bytes(6))
        v.basePointX=get(4,6)&(1<<7) != 0 ? nil : UnsafePointer(bytes(7))
        v.basePointY=get(4,6)&(1<<8) != 0 ? nil : UnsafePointer(bytes(8))
        v.hash=get(4,6)&(1<<9) != 0 ? nil : UnsafePointer(bytes(9))
        v.privateKey=get(4,6)&(1<<10) != 0 ? nil : UnsafePointer(bytes(10))
        v.primeOrder=get(4,6)&(1<<11) != 0 ? nil : UnsafePointer(bytes(11))
        return v
    }
    var input6: PKAECDSASignOutput {
        var v=PKAECDSASignOutput()
        v.rSign=get(4,6)&(1<<0) != 0 ? nil : bytes(0)
        v.sSign=get(4,6)&(1<<1) != 0 ? nil : bytes(1)
        return v
    }
    var input7: PKAECDSASignExtendedOutput {
        var v=PKAECDSASignExtendedOutput()
        v.ptX=get(4,6)&(1<<0) != 0 ? nil : bytes(0)
        v.ptY=get(4,6)&(1<<1) != 0 ? nil : bytes(1)
        return v
    }
    var input8: PKAECCCompleteAdditionOutput {
        var v=PKAECCCompleteAdditionOutput()
        v.ptX=get(4,6)&(1<<0) != 0 ? nil : bytes(0)
        v.ptY=get(4,6)&(1<<1) != 0 ? nil : bytes(1)
        v.ptZ=get(4,6)&(1<<2) != 0 ? nil : bytes(2)
        return v
    }
    var input9: PKAModExpInput {
        var v=PKAModExpInput()
        v.expSize=get(3,180)
        v.opSize=get(3,181)
        v.pExp=get(4,6)&(1<<2) != 0 ? nil : UnsafePointer(bytes(2))
        v.pOp1=get(4,6)&(1<<3) != 0 ? nil : UnsafePointer(bytes(3))
        v.pMod=get(4,6)&(1<<4) != 0 ? nil : UnsafePointer(bytes(4))
        return v
    }
    var input10: PKAModExpProtectModeInput {
        var v=PKAModExpProtectModeInput()
        v.expSize=get(3,200)
        v.opSize=get(3,201)
        v.pOp1=get(4,6)&(1<<2) != 0 ? nil : UnsafePointer(bytes(2))
        v.pExp=get(4,6)&(1<<3) != 0 ? nil : UnsafePointer(bytes(3))
        v.pMod=get(4,6)&(1<<4) != 0 ? nil : UnsafePointer(bytes(4))
        v.pPhi=get(4,6)&(1<<5) != 0 ? nil : UnsafePointer(bytes(5))
        return v
    }
    var input11: PKAModExpFastModeInput {
        var v=PKAModExpFastModeInput()
        v.expSize=get(3,220)
        v.opSize=get(3,221)
        v.pExp=get(4,6)&(1<<2) != 0 ? nil : UnsafePointer(bytes(2))
        v.pOp1=get(4,6)&(1<<3) != 0 ? nil : UnsafePointer(bytes(3))
        v.pMod=get(4,6)&(1<<4) != 0 ? nil : UnsafePointer(bytes(4))
        v.pMontgomeryParam=get(4,6)&(1<<5) != 0 ? nil : UnsafePointer(words(5))
        return v
    }
    var input12: PKAMontgomeryParamInput {
        var v=PKAMontgomeryParamInput()
        v.size=get(3,240)
        v.pOp1=get(4,6)&(1<<1) != 0 ? nil : UnsafePointer(bytes(1))
        return v
    }
    var input13: PKAAddInput {
        var v=PKAAddInput()
        v.size=get(3,260)
        v.pOp1=get(4,6)&(1<<1) != 0 ? nil : UnsafePointer(words(1))
        v.pOp2=get(4,6)&(1<<2) != 0 ? nil : UnsafePointer(words(2))
        return v
    }
    var input14: PKAModInvInput {
        var v=PKAModInvInput()
        v.size=get(3,280)
        v.pOp1=get(4,6)&(1<<1) != 0 ? nil : UnsafePointer(words(1))
        v.pMod=get(4,6)&(1<<2) != 0 ? nil : UnsafePointer(bytes(2))
        return v
    }
    var input15: PKAModRedInput {
        var v=PKAModRedInput()
        v.opSize=get(3,300)
        v.modSize=get(3,301)
        v.pOp1=get(4,6)&(1<<2) != 0 ? nil : UnsafePointer(words(2))
        v.pMod=get(4,6)&(1<<3) != 0 ? nil : UnsafePointer(bytes(3))
        return v
    }
    var input16: PKAModAddInput {
        var v=PKAModAddInput()
        v.size=get(3,320)
        v.pOp1=get(4,6)&(1<<1) != 0 ? nil : UnsafePointer(words(1))
        v.pOp2=get(4,6)&(1<<2) != 0 ? nil : UnsafePointer(words(2))
        v.pOp3=get(4,6)&(1<<3) != 0 ? nil : UnsafePointer(bytes(3))
        return v
    }
    var input17: PKAECCDoubleBaseLadderInput {
        var v=PKAECCDoubleBaseLadderInput()
        v.primeOrderSize=get(3,340)
        v.modulusSize=get(3,341)
        v.coefSign=get(3,342)
        v.coefA=get(4,6)&(1<<3) != 0 ? nil : UnsafePointer(bytes(3))
        v.modulus=get(4,6)&(1<<4) != 0 ? nil : UnsafePointer(bytes(4))
        v.integerK=get(4,6)&(1<<5) != 0 ? nil : UnsafePointer(bytes(5))
        v.integerM=get(4,6)&(1<<6) != 0 ? nil : UnsafePointer(bytes(6))
        v.basePointX1=get(4,6)&(1<<7) != 0 ? nil : UnsafePointer(bytes(7))
        v.basePointY1=get(4,6)&(1<<8) != 0 ? nil : UnsafePointer(bytes(8))
        v.basePointZ1=get(4,6)&(1<<9) != 0 ? nil : UnsafePointer(bytes(9))
        v.basePointX2=get(4,6)&(1<<10) != 0 ? nil : UnsafePointer(bytes(10))
        v.basePointY2=get(4,6)&(1<<11) != 0 ? nil : UnsafePointer(bytes(11))
        v.basePointZ2=get(4,6)&(1<<12) != 0 ? nil : UnsafePointer(bytes(12))
        return v
    }
    var input18: PKAECCProjective2AffineInput {
        var v=PKAECCProjective2AffineInput()
        v.modulusSize=get(3,360)
        v.modulus=get(4,6)&(1<<1) != 0 ? nil : UnsafePointer(bytes(1))
        v.basePointX=get(4,6)&(1<<2) != 0 ? nil : UnsafePointer(bytes(2))
        v.basePointY=get(4,6)&(1<<3) != 0 ? nil : UnsafePointer(bytes(3))
        v.basePointZ=get(4,6)&(1<<4) != 0 ? nil : UnsafePointer(bytes(4))
        v.pMontgomeryParam=get(4,6)&(1<<5) != 0 ? nil : UnsafePointer(words(5))
        return v
    }
    var input19: PKAECCCompleteAdditionInput {
        var v=PKAECCCompleteAdditionInput()
        v.modulusSize=get(3,380)
        v.coefSign=get(3,381)
        v.modulus=get(4,6)&(1<<2) != 0 ? nil : UnsafePointer(bytes(2))
        v.coefA=get(4,6)&(1<<3) != 0 ? nil : UnsafePointer(bytes(3))
        v.basePointX1=get(4,6)&(1<<4) != 0 ? nil : UnsafePointer(bytes(4))
        v.basePointY1=get(4,6)&(1<<5) != 0 ? nil : UnsafePointer(bytes(5))
        v.basePointZ1=get(4,6)&(1<<6) != 0 ? nil : UnsafePointer(bytes(6))
        v.basePointX2=get(4,6)&(1<<7) != 0 ? nil : UnsafePointer(bytes(7))
        v.basePointY2=get(4,6)&(1<<8) != 0 ? nil : UnsafePointer(bytes(8))
        v.basePointZ2=get(4,6)&(1<<9) != 0 ? nil : UnsafePointer(bytes(9))
        return v
    }
    func run(_ op: UInt32,_ a: UInt32=0,_ b: UInt32=0,_ c: UInt32=0) -> UInt32 {
        let d=driver
        switch op {
        case 0: return d.initialize(getTick: tick).rawValue
        case 1: return d.deinitialize().rawValue
        case 2: return get(5,2)==0 ? 0 : d.registerCallback(id: a, callback: Self.callback(a<4 ? a : 0,b)).rawValue
        case 3: return get(5,2)==0 ? 0 : d.unregisterCallback(id: a).rawValue
        case 4: return d.modExp(input9, timeout: b, getTick: tick).rawValue
        case 5: return d.modExpIT(input9).rawValue
        case 6: return d.modExpFastMode(input11, timeout: b, getTick: tick).rawValue
        case 7: return d.modExpFastModeIT(input11).rawValue
        case 8: return d.modExpProtectMode(input10, timeout: b, getTick: tick).rawValue
        case 9: return d.modExpProtectModeIT(input10).rawValue
        case 10: d.getModExpResult(b != 0 ? nil : bytes(16)); return 0
        case 11: return d.ecdsaSign(input5, timeout: b, getTick: tick).rawValue
        case 12: return d.ecdsaSignIT(input5).rawValue
        case 13: d.getECDSASignResult(b&1 != 0 ? nil : .init(rSign: bytes(16),sSign: bytes(17)),extended: b&2 != 0 ? nil : .init(ptX: bytes(18),ptY: bytes(19))); return 0
        case 14: return d.ecdsaVerify(input4, timeout: b, getTick: tick).rawValue
        case 15: return d.ecdsaVerifyIT(input4).rawValue
        case 16: return d.isValidECDSASignature() ? 1 : 0
        case 17: return d.rsaCRTExp(input3, timeout: b, getTick: tick).rawValue
        case 18: return d.rsaCRTExpIT(input3).rawValue
        case 19: d.getRSACRTExpResult(b != 0 ? nil : bytes(16)); return 0
        case 20: return d.pointCheck(input2, timeout: b, getTick: tick).rawValue
        case 21: return d.pointCheckIT(input2).rawValue
        case 22: return d.isPointOnCurve() ? 1 : 0
        case 23: return d.eccMul(input0, timeout: b, getTick: tick).rawValue
        case 24: return d.eccMulIT(input0).rawValue
        case 25: return d.eccMulEx(input1, timeout: b, getTick: tick).rawValue
        case 26: return d.eccMulExIT(input1).rawValue
        case 27: d.getECCMulResult(b != 0 ? nil : .init(ptX: bytes(16),ptY: bytes(17))); return 0
        case 28: return d.add(input13, timeout: b, getTick: tick).rawValue
        case 29: return d.addIT(input13).rawValue
        case 30: return d.subtract(input13, timeout: b, getTick: tick).rawValue
        case 31: return d.subtractIT(input13).rawValue
        case 32: return d.multiply(input13, timeout: b, getTick: tick).rawValue
        case 33: return d.multiplyIT(input13).rawValue
        case 34: return d.compare(input13, timeout: b, getTick: tick).rawValue
        case 35: return d.compareIT(input13).rawValue
        case 36: return d.modAdd(input16, timeout: b, getTick: tick).rawValue
        case 37: return d.modAddIT(input16).rawValue
        case 38: return d.modInv(input14, timeout: b, getTick: tick).rawValue
        case 39: return d.modInvIT(input14).rawValue
        case 40: return d.modSub(input16, timeout: b, getTick: tick).rawValue
        case 41: return d.modSubIT(input16).rawValue
        case 42: return d.modRed(input15, timeout: b, getTick: tick).rawValue
        case 43: return d.modRedIT(input15).rawValue
        case 44: return d.montgomeryMul(input16, timeout: b, getTick: tick).rawValue
        case 45: return d.montgomeryMulIT(input16).rawValue
        case 46: d.getArithmeticResult(b != 0 ? nil : words(16)); return 0
        case 47: return d.montgomeryParam(input12, timeout: b, getTick: tick).rawValue
        case 48: return d.montgomeryParamIT(input12).rawValue
        case 49: return d.eccDoubleBaseLadder(input17, timeout: b, getTick: tick).rawValue
        case 50: return d.eccDoubleBaseLadderIT(input17).rawValue
        case 51: return d.eccProjectiveToAffine(input18, timeout: b, getTick: tick).rawValue
        case 52: return d.eccProjectiveToAffineIT(input18).rawValue
        case 53: return d.eccCompleteAddition(input19, timeout: b, getTick: tick).rawValue
        case 54: return d.eccCompleteAdditionIT(input19).rawValue
        case 55: d.getMontgomeryParamResult(b != 0 ? nil : words(16)); return 0
        case 56: return d.abort().rawValue
        case 57: d.resetRAM(); return 0
        case 58: d.handleInterrupt(); return 0
        case 59: return d.getState()
        case 60: return d.getError()
        case 61: return d.getMode()
        case 62: return d.pollEndOfOperation(timeout: b,tickStart: a,getTick: tick).rawValue
        case 63: return d.checkError(mode: a)
        case 64: return PKAEncoding.bitSize(bytes: a)
        case 65: return PKAEncoding.optimizedBitSize(bytes: a,mostSignificantByte: UInt8(truncatingIfNeeded:b))
        case 66: return PKAEncoding.bitSize(words: a)
        case 67: return PKAEncoding.byteCount(bits: a)
        case 68: d.readBytes(fromRAM: c,to: b != 0 ? nil : bytes(16),count: a); return 0
        case 69: d.writeBytes(toRAM: c,from: b != 0 ? nil : bytes(0),count: a); return 0
        case 70: if b&2 != 0 { d.readWords(fromRAM: c,to: b&1 != 0 ? nil : words(16),count: a) } else { d.writeWords(toRAM: c,from: b&1 != 0 ? nil : words(0),count: a) }; return 0
        case 71: return d.process(mode: a,timeout: b,getTick: tick).rawValue
        case 72: return d.processIT(mode: a).rawValue
        case 73: d.setModExp(input9); return 0
        case 74: d.setModExpFastMode(input11); return 0
        case 75: d.setModExpProtectMode(input10); return 0
        case 76: d.setECDSASign(input5); return 0
        case 77: d.setECDSAVerif(input4); return 0
        case 78: d.setRSACRTExp(input3); return 0
        case 79: d.setPointCheck(input2); return 0
        case 80: d.setECCMul(input0); return 0
        case 81: d.setECCMulEx(input1); return 0
        case 82: d.setModInv(input14); return 0
        case 83: d.setModRed(input15); return 0
        case 84: d.setMontgomeryParam(size: a,operand: b != 0 ? nil : bytes(0)); return 0
        case 85: d.setECCDoubleBaseLadder(input17); return 0
        case 86: d.getECCDoubleBaseLadderResult(b != 0 ? nil : .init(ptX: bytes(16),ptY: bytes(17))); return 0
        case 87: d.setECCProjective2Affine(input18); return 0
        case 88: d.getECCProjectiveToAffineResult(b != 0 ? nil : .init(ptX: bytes(16),ptY: bytes(17))); return 0
        case 89: d.setECCCompleteAddition(input19); return 0
        case 90: d.getECCCompleteAdditionResult(b != 0 ? nil : .init(ptX: bytes(16),ptY: bytes(17),ptZ: bytes(18))); return 0
        case 91: d.setArithmetic(size: a,operand1: b&1 != 0 ? nil : words(0),operand2: b&2 != 0 ? nil : words(1),modulus: b&4 != 0 ? nil : bytes(2)); return 0
        case 92: return d.waitOnFlagUntilTimeout(flag: a,status: b != 0,tickStart: get(5,0),timeout: c,getTick: tick).rawValue
        case 93: return d.resultSize(startIndex: a,maximumWords: b)
        case 94: d.deinitializeMSP(system:self,getTick:tick); return 0
        case 100: d.resetHandleState(); return 0
        case 101: d.enable(); return 0
        case 102: d.disable(); return 0
        case 103: d.start(); return 0
        case 104: d.enableInterrupts(a); return 0
        case 105: d.disableInterrupts(a); return 0
        case 106: return d.getInterruptSource(a) ? 1 : 0
        case 107: return d.getFlag(a) ? 1 : 0
        case 108: d.clearFlags(a); return 0
        default: preconditionFailure("Unknown PKA reference operation")
        }
    }
}
