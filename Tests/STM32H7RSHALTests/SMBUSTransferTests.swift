import STM32H7RSHAL
import XCTest

final class SMBUSTransferTests: XCTestCase {
  func testMasterAndSlaveStateLockGuards() {
    for callbacks in [false, true] {
      for op: UInt32 in 8...16 {
        for state: UInt32 in [0, 1, 2, 8, 0x12, 0x22, 0x32, 0x42, 0x3A, 0x4A] {
          for lock: UInt32 in [0, 1] {
            let p = SMBUSPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: state)
              f.write(.lock, value: lock)
              f.write(.errorCode, value: 0x400)
              f.write(.cr1, value: 0xA5A5_00FF)
              f.write(.cr2, value: 0x5A5A_FFFF)
              f.control(17, 0x6000000)
            }
            p.verify(op, 0xA4, 3)
          }
        }
      }
    }
  }

  func testCountsPECQuickCommandsAndRepeatedStartOptions() {
    for callbacks in [false, true] {
      for op: UInt32 in [8, 9, 11, 12] {
        for count: UInt32 in [0, 1, 2, 254, 255, 256, 511, 65535] {
          for option: UInt32 in [
            0, 0x1000000, 0x2000000, 0x4000000, 0x6000000, 0x5000000, 0xAA, 0xAA00, 0xAA0000,
            0xAA00_0000,
          ] {
            for previous: UInt32 in [1, op == 8 ? 0x12 : 0x22] {
              for absent: UInt32 in [0, 1] {
                let p = SMBUSPair(callbacks: callbacks)
                p.setup { f in
                  f.write(.state, value: op < 10 ? 1 : 8)
                  f.write(.previousState, value: previous)
                  f.write(.cr1, value: 0x0080_0080)
                  f.write(.cr2, value: 0xA5A5_FFFF)
                  f.control(13, absent)
                  f.control(17, option)
                }
                p.verify(op, 0xA4, count)
              }
            }
          }
        }
      }
    }
  }

  func testDeviceProbeTimeoutWrapNACKAndTickDrivenStop() {
    for callbacks in [false, true] {
      for flags: UInt32 in [0, 0x10, 0x20, 0x30, 0x8000] {
        for timeout: UInt32 in [0, 1, 3] {
          for tick: UInt32 in [0, 0xFFFF_FFFE] {
            for trials: UInt32 in [0, 1, 3] {
              let p = SMBUSPair(callbacks: callbacks)
              p.setup { f in
                f.write(.state, value: 1)
                f.write(.addressingMode, value: 1)
                f.write(.isr, value: flags)
                f.control(0, tick)
                f.control(10, 3)
                f.control(11, 0x20)
              }
              p.verify(17, 0xA4, trials, timeout)
            }
          }
        }
      }
    }
  }

  func testWaitHelperUsesStrictTimeoutAndPreservesStateDifferences() {
    for flag: UInt32 in [1, 0x20, 0x8000, 0x8000_0000] {
      for status: UInt32 in [0, 1] {
        for timeout: UInt32 in [0, 1, 3, .max] {
          for tick: UInt32 in [0, 0xFFFF_FFFE] {
            let p = SMBUSPair()
            p.setup { f in
              f.write(.state, value: 0x4A)
              f.write(.lock, value: 1)
              f.control(0, tick)
              f.control(10, timeout == .max ? 1 : 3)
              f.control(11, status == 0 ? flag : 0)
              f.write(.isr, value: status == 0 ? 0 : flag)
            }
            // A zero masked flag is always SET; avoid an unbounded UINT32_MAX wait.
            if flag == 0x8000_0000 && status == 1 && timeout == .max { continue }
            p.verify(27, flag, status, timeout)
          }
        }
      }
    }
  }

  func testAbortRetainsLockedErrorForUnsupportedPreviousState() {
    for previous: UInt32 in [0, 1, 8, 0x12, 0x22, 0x3A] {
      let p = SMBUSPair()
      p.setup { f in
        f.write(.state, value: 1)
        f.write(.previousState, value: previous)
        f.write(.errorCode, value: 0x8000)
      }
      p.verify(10, 0xA4)
      XCTAssertEqual(p.swift.read(.lock), previous == 0x12 || previous == 0x22 ? 0 : 1)
      if previous != 0x12 && previous != 0x22 {
        XCTAssertEqual(p.swift.read(.state), 1)
        XCTAssertEqual(p.swift.read(.errorCode), 0x8000)
      }
    }
  }
}
