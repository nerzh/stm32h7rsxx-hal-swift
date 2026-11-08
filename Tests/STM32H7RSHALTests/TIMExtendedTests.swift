import CTIMReference
import STM32H7RSHAL
import XCTest

final class TIMExtendedTests: XCTestCase {
  func testBreakSourceAndEncoderFirstIndexConfiguration() {
    for input: UInt32 in [1, 2] {
      for enabled: UInt32 in [0, 1] {
        for polarity: UInt32 in [0, 1] {
          let p = TIMPair()
          p.setup { f in
            f.raw(.af1, 0xAAAA_AAAA)
            f.raw(.af2, 0x5555_5555)
            f.set(3, 0, 1)
            f.set(3, 1, enabled)
            f.set(3, 2, polarity)
          }
          p.verify(132, input)
        }
      }
    }
    for first: UInt32 in [0, 1, 2] {
      for polarity: UInt32 in [0, 0x8000] {
        for prescaler: UInt32 in [0, 0x1000, 0x2000, 0x3000] {
          let p = TIMPair()
          p.setup { f in
            f.raw(.smcr, 0xFFFF_FFFF)
            f.raw(.ecr, 0xFFFF_FFFF)
            f.set(3, 0, polarity)
            f.set(3, 1, prescaler)
            f.set(3, 2, 15)
            f.set(3, 3, 0xC0)
            f.set(3, 4, first)
            f.set(3, 5, 0x6)
            f.set(3, 6, 0x18)
          }
          p.verify(150)
          XCTAssertEqual(p.swift.raw(.ecr) & 0x20, first == 1 ? 0x20 : 0)
        }
      }
    }
  }
  func testBreakRearmActuallyTimesOutAndRechecksBeforeReportingTimeout() {
    for (input, bits): (UInt32, UInt32) in [(1, 0x1400_0000), (2, 0x2800_0000)] {
      let timeout = TIMPair()
      timeout.setup { f in
        f.raw(.bdtr, bits)
        f.control(2, UInt32.max - 3)
      }
      XCTAssertEqual(timeout.verify(137, input), HALStatus.timeout.rawValue)
      XCTAssertEqual(timeout.swift.control(4), 7)
      let recovery = TIMPair()
      recovery.setup { f in
        f.raw(.bdtr, bits)
        f.control(25, 8)
        f.control(26, 0)
      }
      XCTAssertEqual(recovery.verify(137, input), HALStatus.ok.rawValue)
      XCTAssertEqual(recovery.swift.control(24), 9)
    }
  }
  func testMixedChannelStatesInOnePulseAndEncoderStarts() {
    for op: UInt32 in [34, 36, 40, 42, 44, 123, 125] {
      for channel: UInt32 in [0, 4, 60] {
        for index in 0..<4 {
          for state: UInt32 in [0, 2] {
            let p = TIMPair()
            p.setup { f in
              f.write(.state, value: 1)
              for i in 0..<6 { f.writeChannelState(i, complementary: false, value: 1) }
              for i in 0..<4 { f.writeChannelState(i, complementary: true, value: 1) }
              f.writeChannelState(index & 1, complementary: index >= 2, value: state)
            }
            p.verify(op, channel, 7)
          }
        }
      }
    }
  }
}
