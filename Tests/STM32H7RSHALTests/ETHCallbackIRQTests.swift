import CETHReference
import STM32H7RSHAL
import XCTest

final class ETHCallbackIRQTests: XCTestCase {
  func testCallbackRegistrationStatesInvalidIDsAndNullValues() {
    for state: UInt32 in [0, 0x10, 0x20, 0x40, 0xE0] {
      for id: UInt32 in 0...10 {
        for token: UInt32 in 0...2 {
          let p = ETHRegisterPair(callbacks: 1, ptp: 1)
          p.word(.state, state)
          p.word(.errorCode, 0x8000_0000)
          p.run(2, id, token)
          p.run(3, id)
        }
      }
      for op: UInt32 in [12, 14, 17, 29] {
        for token: UInt32 in 0...2 {
          let p = ETHRegisterPair(callbacks: 1, ptp: 1)
          p.word(.state, state)
          p.word(.errorCode, 0x8000_0000)
          p.run(op, 0, token)
          p.run(op + 1)
        }
      }
    }
  }
  func testDefaultsPreserveMSPHooksAndConditionalPTP() {
    for ptp: UInt32 in 0...1 {
      let p = ETHRegisterPair(callbacks: 1, ptp: ptp)
      for id: UInt32 in 0...12 where id != 5 {
        CETH_SetCallback(p.c, id, CETH_Callback(id, 2))
        CETH_SetCallback(p.swift.state, id, CETH_Callback(id, 2))
      }
      p.run(59)
      XCTAssertEqual(CETH_GetCallback(p.c, 0), CETH_Callback(0, 2))
      XCTAssertEqual(CETH_GetCallback(p.c, 1), CETH_Callback(1, 2))
      XCTAssertEqual(CETH_GetCallback(p.c, 12), CETH_Callback(12, ptp == 1 ? 1 : 2))
    }
  }
  func testDeinitializeCallbackFallbackAndStateOrder() {
    for cb: UInt32 in 0...1 {
      for token: UInt32 in 0...2 {
        let p = ETHRegisterPair(callbacks: cb)
        p.word(.state, 0x40)
        CETH_SetCallback(p.c, 1, CETH_Callback(1, token))
        CETH_SetCallback(p.swift.state, 1, CETH_Callback(1, token))
        p.run(1)
        XCTAssertEqual(p.swift.read(.state), 0)
        XCTAssertEqual(CETH_Trace(p.c)![2], 0x20)
      }
    }
  }
  func testIRQFlagAndEnableCombinations() {
    for cb: UInt32 in 0...1 {
      for flags: UInt32 in [0, 1, 0x40, 0x8000, 0x9000, 0xC0C1, 0xFFFF] {
        for enable: UInt32 in [0, 1, 0x40, 0x8000, 0xFFFF] {
          let p = ETHRegisterPair(callbacks: cb, ptp: 1)
          p.word(.state, 0x40)
          p.word(.errorCode, 0x8000_0000)
          p.register(.dmacsr, flags)
          p.register(.dmacier, enable)
          p.register(.macisr, 0x6038)
          p.register(.macier, 0)
          p.register(.macrxtxsr, 0x1234)
          p.register(.macpcsr, 0x60)
          p.register(.maclcsr, 0xA55A)
          CETH_SetEXTI(p.c, 1, 0xC000)
          CETH_SetEXTI(p.swift.state, 1, 0xC000)
          p.run(31)
          XCTAssertEqual(p.swift.read(.macErrorCode), 0)
          XCTAssertEqual(p.swift.read(.macWakeUpEvent), 0)
          XCTAssertEqual(p.swift.read(.macLPIEvent), 0)
        }
      }
    }
  }
  func testIRQSnapshotsFlagsButRereadsDMAErrorAfterCallbacks() {
    for cb: UInt32 in 0...1 {
      let p = ETHRegisterPair(callbacks: cb)
      p.register(
        .dmacsr,
        0x5041)
      p.register(.dmacier, 0xFFFF)
      for s in [p.c, p.swift.state] {
        CETH_Control(s)![13] = 1
        CETH_Control(s)![14] = 3
        CETH_Control(s)![15] = ETHRegister.dmacsr.rawValue
        CETH_Control(s)![16] = 0xDEAD_BEEF
      }
      p.run(31)
      // RX and TX still run from the initial snapshot; the later error read sees
      // the status after TX cleared RI/TI in the register-backed fixture.
      XCTAssertEqual(CETH_Trace(p.c)![0], 3)
      XCTAssertEqual(CETH_Trace(p.c)![8], 2)
      XCTAssertEqual(CETH_Trace(p.c)![16], 4)
    }
  }
}
