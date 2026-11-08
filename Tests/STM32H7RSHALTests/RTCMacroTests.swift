import XCTest
import STM32H7RSHAL

final class RTCMacroTests: XCTestCase {
    func testSelectorsIgnoredArgumentsAndRegisterMasksMatchC() {
        let parameters: [UInt32] = Array(0...15) + [0x80,0x100,0x1000,0x2000,0x3000,0x4000,0x8000,0x40000,0x45FF00FF,.max]
        for op: UInt32 in 76...136 {
            for a in parameters { for value: UInt32 in [0,0x5A5A5A5A,.max] {
                let p = RTCPair()
                p.reg(.cr,value); p.reg(.icsr,value); p.reg(.sr,value); p.reg(.misr,value)
                p.tamp(.cr1,value); p.tamp(.ier,value); p.tamp(.sr,value); p.tamp(.misr,value)
                p.run(op,a)
            } }
        }
    }
}
