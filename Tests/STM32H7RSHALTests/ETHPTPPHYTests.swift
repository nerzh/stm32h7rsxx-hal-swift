import CETHReference
import STM32H7RSHAL
import XCTest

final class ETHPTPPHYTests: XCTestCase {
  func testPTPConfigurationPreservesOriginalGetterAndSetterAsymmetry() {
    for bits: UInt32 in [0, 1, 0xA55A, 0xFFFF] {
      let pair = ETHRegisterPair(ptp: 1)
      pair.seed(0x1234_5678)
      for i: UInt32 in 0..<19 { pair.configuration(2, i, (bits >> (i % 16)) & 1) }
      pair.configuration(2, 4, 0)  // No hardware-driven addend completion on the host.
      pair.configuration(2, 17, 0x7654_3210)
      pair.configuration(2, 18, 0x1234_5678)
      pair.run(20)
      pair.run(21)
      // The source reads TSCFUPDT (bit 1) then shifts by TSUPDT_Pos (3).
      XCTAssertEqual(CETH_GetConfiguration(pair.swift.state, 2, 3), 0)
    }
    let pair = ETHRegisterPair(ptp: 1)
    pair.seed(0xFFFF_FFFF)
    pair.run(20, 0, 0, 1)
    pair.run(21, 0, 0, 1)
  }

  func testPTPTimeAndReceiveTimestampStateGates() {
    for configured: UInt32 in [0, 1, 2] {
      for value: UInt32 in [0, 1, 0xFFFF_FFFF, 0x8000_0000] {
        let pair = ETHRegisterPair(ptp: 1)
        pair.seed(value)
        pair.word(.isPTPConfigured, configured)
        pair.word(.receiveTimestampLow, value)
        pair.word(.receiveTimestampHigh, value ^ 0x1234_5678)
        pair.configuration(10, 0, value)
        pair.configuration(10, 1, value ^ 0xA55A_A55A)
        pair.run(22)
        pair.run(23)
        pair.run(28)
        if configured != ETHConstants.HAL_ETH_PTP_CONFIGURED {
          for op: UInt32 in [24, 25, 26, 27] { pair.run(op, value) }
        }
      }
    }
  }

  func testPHYBusyAndTimeoutIncludingTickWrap() {
    for op: UInt32 in [32, 33] {
      let busy = ETHRegisterPair()
      busy.register(.macmdioar, 0xA55A_0001)
      XCTAssertEqual(busy.run(op, 31, 31, 0xDEAD_BEEF), HALStatus.error.rawValue)
      XCTAssertEqual(busy.swift.control[5], 0)
      for tick: UInt32 in [0, 0xFFFF_FFF0] {
        let timeout = ETHRegisterPair()
        timeout.register(.macmdioar, 0x1234_5678)
        timeout.swift.control[3] = tick
        CETH_Control(timeout.c)![3] = tick
        XCTAssertEqual(timeout.run(op, 31, 31, 0xDEAD_BEEF), HALStatus.error.rawValue)
        XCTAssertEqual(timeout.swift.control[5], 1002)
      }
    }
  }

  func testPHYCompletionAndFixedInstanceWrites() {
    for op: UInt32 in [32, 33] {
      for due: UInt32 in [1, 2, 1001] {
        let pair = ETHRegisterPair()
        pair.register(.macmdioar, 0xA5A5_5A5A)
        pair.register(.macmdiodr, 0xDEAD_BEEF)
        CETH_Event(pair.c, 0, due, ETHRegister.macmdioar.rawValue, 0x1234_5678)
        CETH_Event(pair.swift.state, 0, due, ETHRegister.macmdioar.rawValue, 0x1234_5678)
        XCTAssertEqual(pair.run(op, 0xFFFF_FFFF, 0x1234, 0xFEDC_BA98), HALStatus.ok.rawValue)
        if op == 32 { XCTAssertEqual(CETH_Buffer(pair.swift.state, 0)![0], 0xBEEF) }
      }
    }
    let pair = ETHRegisterPair()
    pair.swift.control[9] = 1
    CETH_Control(pair.c)![9] = 1
    pair.register(.macmdioar, 0x1234_5678)
    XCTAssertEqual(pair.run(33, 5, 17, 0xFEDC_BA98), HALStatus.ok.rawValue)
    XCTAssertEqual(pair.swift.read(.macmdioar), 0x1234_5678)
    XCTAssertEqual(CETH_ReadGlobal(pair.swift.state, ETHRegister.macmdiodr.rawValue), 0xBA98)
  }
}
