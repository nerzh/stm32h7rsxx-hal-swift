import XCTest
import STM32H7RSHAL

final class RTCTamperDifferentialTests: XCTestCase {
    func testPassiveConfigurationReplacesSharedFilterWithoutChangingHandle() {
        for value: UInt32 in 0..<256 {
            for interrupt: UInt32 in 0...1 {
                let p = RTCPair(); p.tamp(.cr1,.max); p.tamp(.cr2,.max); p.tamp(.fltcr,.max); p.tamp(.ier,.max)
                p.reg(.cr,(value & 1) << 25); p.set(2,10,1); p.set(2,11,255)
                let mask = UInt32(1) << (value % 8)
                let filter = (value >> 3) & 3
                p.set(6,0,mask); p.set(6,1,(value & 1) | (filter == 0 ? 0 : 2)); p.set(6,2,(value>>1)&1)
                p.set(6,3,interrupt == 0 && mask <= 4 ? (value>>2)&1 : 0)
                p.set(6,4,filter<<3); p.set(6,5,(value>>5)&7); p.set(6,6,((value>>1)&3)<<5)
                p.set(6,7,((value>>2)&1)<<7); p.set(6,8,((value>>3)&1)<<25)
                p.run(interrupt == 0 ? 54 : 55); p.run(56,mask)
            }
        }
    }
    func testInternalTamperMasksNoEraseAndPartialDeactivation() {
        for mask: UInt32 in [0x10000,0x30000,0x1000000,0x4000000,0x40000000,0x45FF0000] {
            for erase: UInt32 in 0...1 { for timestamp: UInt32 in [0,0x2000000] { for op: UInt32 in [62,63] {
                let p = RTCPair(); p.tamp(.cr3,.max); p.tamp(.ier,0xAA); p.reg(.cr,.max)
                p.set(8,0,mask); p.set(8,1,timestamp); p.set(8,2,erase)
                p.set(2,10,1); p.set(2,11,255); p.run(op); p.run(64,mask)
            } } }
        }
    }
    func testActiveTamperInputsOutputSharingAndExistingBits() {
        for variant: UInt32 in 0..<256 {
            let p = RTCPair(); p.tamp(.ator,variant & 1 == 0 ? 0 : 0x8000)
            p.tamp(.cr1,0x103); p.tamp(.cr2,0xAA0500AA); p.tamp(.atcr1,0x85); p.tamp(.ier,0x81)
            p.set(7,0,(variant & 1)<<31); p.set(7,1,(variant%8)<<16); p.set(7,2,((variant>>1)&1)<<25)
            p.set(7,3,variant%8)
            for i: UInt32 in 0..<4 { p.set(7,4+i,(variant &* 0x9E3779B9) ^ i) }
            for i: UInt32 in 0..<8 {
                let n = 8+i*5
                p.set(7,n,(variant>>i)&1); p.set(7,n+1,(variant>>(7-i))&1)
                p.set(7,n+2,(i+(variant&1))%8); p.set(7,n+3,(variant>>2)&1)
                p.set(7,n+4,i < 3 ? (variant>>3)&1 : 0)
            }
            p.run(57); p.run(60)
        }
    }
    func testActiveSeedRequiresInitializedGeneratorAndTimesOutWithoutUnlocking() {
        for flags: UInt32 in [0,0x4000,0x8000,0xC000] {
            let p = RTCPair(); p.tamp(.ator,flags); p.set(2,10,1); p.set(2,11,2)
            for i: UInt32 in 0..<4 { p.set(7,4+i,0xABCD0000+i) }
            p.run(58); p.run(57)
        }
        let p = RTCPair(); p.tamp(.ator,0xC000)
        p.set(10,2,2); p.set(10,3,1); p.set(10,4,0x18/4); p.set(10,5,0x8000)
        XCTAssertEqual(p.run(58),0)
    }
    func testBackupMonotonicSecretAndPrivilegeOperationsOnlyInRAMModel() {
        let p = RTCPair()
        for index: UInt32 in 0..<32 { p.run(67,index,index &* 0x9E3779B9); p.run(68,index) }
        for op: UInt32 in [48,49,59,69,70,71,72] {
            p.tamp(.cr2,0x12345678); p.tamp(.count1r,0xFFFFFFFF); p.tamp(.rpcfgr,0xFFFFFFFE)
            p.run(op,1)
        }
        for value: UInt32 in 0..<256 {
            let p = RTCPair(); p.tamp(.cfgr,.max)
            p.set(9,0,(value&1)<<15); p.set(9,1,value & 0xF | ((value&0x30)<<9))
            p.set(9,2,((value>>1)&1)<<31); p.set(9,3,((value>>2)&3)<<29)
            p.set(9,4,value%32); p.set(9,5,(value+17)%32); p.set(9,6,((value>>4)&1)<<15)
            p.run(73); p.run(74)
        }
    }
}
