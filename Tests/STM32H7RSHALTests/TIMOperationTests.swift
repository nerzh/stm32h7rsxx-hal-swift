import CTIMReference
import STM32H7RSHAL
import XCTest

final class TIMOperationTests: XCTestCase {
  func testStartsStopsAndChannelStates() {
    let operations: [UInt32] = [
      2, 3, 4, 5, 10, 11, 12, 13, 18, 19, 20, 21, 26, 27, 28, 29, 34, 35, 36, 37, 40, 41, 42, 43,
      105, 106, 107, 108, 111, 112, 113, 114, 117, 118, 119, 120, 123, 124, 125, 126,
    ]
    for op in operations {
      for channel: UInt32 in [0, 4, 8, 12, 16, 20, 60] {
        for state: UInt32 in [0, 1, 2] {
          for mode: UInt32 in [0, 6, 0x10000] {
            let p = TIMPair()
            p.setup { f in
              f.write(.state, value: state)
              f.write(.lock, value: 1)
              f.raw(.smcr, mode)
              f.raw(.ccer, 0x5555)
              f.raw(.cr1, 0xFFFF)
              f.raw(.bdtr, 0x8000)
              f.raw(.dier, 0xFFFF_FFFF)
              for i in 0..<6 { f.writeChannelState(i, complementary: false, value: state) }
              for i in 0..<4 { f.writeChannelState(i, complementary: true, value: state) }
            }
            p.verify(op, channel)
          }
        }
      }
    }
  }
  func testBasicTimersAndAdvancedMainOutputStartBehavior() {
    for instance: UInt32 in 0..<14 {
      for op: UInt32 in [2, 4, 10, 18, 26, 105, 111, 117] {
        for ccer: UInt32 in [0, 1, 4, 0x10000] {
          let p = TIMPair()
          p.setup { f in
            f.control(0, instance)
            f.write(.state, value: 1)
            f.raw(.ccer, ccer)
            for i in 0..<6 { f.writeChannelState(i, complementary: false, value: 1) }
            for i in 0..<4 { f.writeChannelState(i, complementary: true, value: 1) }
          }
          p.verify(op, 0)
        }
      }
    }
  }
  func testInterruptFlagsSourcesCaptureCompareAndCallbacks() {
    let flags: [UInt32] = [
      0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 0x2000, 0x10000, 0x20000, 0x40000, 0x80000,
      0xFFFF_FFFF,
    ]
    for registered in [false, true] {
      for flag in flags {
        for enabled in [flag, ~flag, UInt32.max] {
          for capture: UInt32 in [0, 1, 0x100, 0x101] {
            let p = TIMPair(callbacks: registered)
            p.setup { f in
              f.raw(.sr, flag)
              f.raw(.dier, enabled)
              f.raw(.ccmr1, capture)
              f.raw(.ccmr2, capture)
              f.write(.state, value: 2)
              f.write(.channel, value: 0x55)
              for i in 0..<6 { f.writeChannelState(i, complementary: false, value: 2) }
            }
            p.verify(46)
          }
        }
      }
    }
  }
  func testInterruptUsesCachedFlagsAndClearsActiveChannelAfterCallback() {
    for id: UInt32 in [14, 16, 18, 20, 21, 24, 26, 27, 28, 29, 30, 31] {
      let p = TIMPair()
      p.setup { f in
        f.raw(.sr, 0xFFFF_FFFF)
        f.raw(.dier, 0xFFFF_FFFF)
        f.control(20, id + 1)
        f.control(21, 6)
        f.control(22, 0xAAAA_AAAA)
      }
      p.verify(46)
    }
  }
  func testEventGenerationAndCapturedValues() {
    for event: UInt32 in [0, 1, 2, 4, 0xFF, 0xFFFF_FFFF] {
      for locked: UInt32 in [0, 1] {
        let p = TIMPair()
        p.setup { f in
          f.write(.lock, value: locked)
          f.raw(.egr, 0xABCD)
        }
        p.verify(57, event)
      }
    }
    let p = TIMPair()
    p.setup { f in for r in TIMRegister.allCases { f.raw(r, 0xA500_0000 | r.rawValue) } }
    for channel: UInt32 in [0, 4, 8, 12, 16, 20, 24, 60] { p.verify(63, channel) }
  }
  func testExtendedConfigurationsAndLocking() {
    for op: UInt32 in Array(127...136) + Array(138...154) {
      for instance: UInt32 in [0, 1, 11] {
        for locked: UInt32 in [0, 1] {
          for argument: UInt32 in [0, 1, 2, 4, 12, 20, 0x10000] {
            let p = TIMPair()
            p.setup { f in
              f.control(0, instance)
              f.write(.lock, value: locked)
              for r in TIMRegister.allCases { f.raw(r, 0xA5A5_5A5A) }
              for i: UInt32 in 0..<16 { f.set(3, i, 0x1357 + i) }
            }
            p.verify(op, argument, 0x1000, 0x1234)
          }
        }
      }
    }
  }
  func testBreakRearmTimeoutWraparoundAndPreemptionRecheck() {
    for input: UInt32 in [0, 1, 2, 3] {
      for bdtr: UInt32 in [0, 0x1000_0000, 0x1400_0000, 0x2000_0000, 0x2800_0000, 0x3C00_0000] {
        for clearingTick: UInt32 in [0, 1, 5, 8] {
          let p = TIMPair()
          p.setup { f in
            f.raw(.bdtr, bdtr)
            f.control(2, UInt32.max - 3)
            f.control(10, clearingTick)
            f.control(11, 17)
            f.control(12, 0)
          }
          p.verify(137, input)
        }
      }
    }
    for input: UInt32 in [1, 2] {
      let p = TIMPair()
      p.setup { f in
        f.raw(.bdtr, 0x3C00_0000)
        f.control(25, 8)
        f.control(26, 0)
      }
      p.verify(137, input)
    }
  }
}
