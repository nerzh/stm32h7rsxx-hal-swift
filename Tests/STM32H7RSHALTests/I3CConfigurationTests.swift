import CI3CReference
import STM32H7RSHAL
import XCTest

private func configureI3C(_ f: I3CFixture, state: UInt32, mode: UInt32, seed: UInt32) {
  f.write(.state, value: state)
  f.write(.mode, value: mode)
  f.write(.previousState, value: 0x30)
  f.write(.errorCode, value: 0x2468_ACE0)
  for i: UInt32 in 0..<54 { f.set(0, i, seed &* 0x0101_0101 &+ i &* 0x10203) }
  for i: UInt32 in 0..<9 { f.set(1, i, seed &* 0x12345 &+ i) }
  for (g, n): (UInt32, UInt32) in [
    (20, 8), (21, 1), (22, 4), (23, 8), (24, 18), (26, 12), (27, 12),
  ] {
    for i in 0..<n { f.set(g, i, seed &* 0x1234567 &+ i &* 0xABCDEF) }
  }
  for i: UInt32 in 0..<4 {
    f.set(25, i * 6, i + 1)
    for j: UInt32 in 1..<6 { f.set(25, i * 6 + j, seed &+ i &+ j) }
  }
}

final class I3CConfigurationTests: XCTestCase {
  func testInitializationAndDeinitialization() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 0x10, 0x20, 0x30, 0xE0] {
        for mode: UInt32 in [0, 1, 2] {
          for op: UInt32 in [0, 1] {
            checkI3C(
              { f in
                configureI3C(f, state: state, mode: mode, seed: 7)
                for id: UInt32 in 0..<13 { CI3C_SetCallback(f.state, id, CI3C_Callback(id, 2)) }
                if state == 0 { f.write(.mspInitialize, value: nil) }
              }, operation: op, callbacks: callbacks)
          }
        }
      }
    }
  }

  func testConfigurationStateAndNullArgumentOrder() {
    for state: UInt32 in [0, 0x10, 0x20, 0x30, 0x60] {
      for mode: UInt32 in [0, 1, 2] {
        for seed: UInt32 in [0, 1, 31, 255] {
          for op: UInt32 in [11, 12, 13, 14, 15, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26] {
            for missing: UInt32 in [0, 1] {
              checkI3C(
                { f in
                  configureI3C(f, state: state, mode: mode, seed: seed)
                  f.control(13, missing)
                }, operation: op, op == 16 ? 4 : seed & 1)
            }
          }
        }
      }
    }
  }

  func testCallbackRegistrationAndUnregistration() {
    for state: UInt32 in [0, 0x10, 0x20, 0x30] {
      for id: UInt32 in 0...14 {
        for custom: UInt32 in [0, 1, 2] {
          for op: UInt32 in [2, 3, 4, 5, 6] {
            checkI3C(
              { f in
                configureI3C(f, state: state, mode: 1, seed: 2)
              }, operation: op, id, custom)
          }
        }
      }
    }
  }

  func testNotificationConfiguration() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 0x10, 0x20, 0x30] {
        for mode: UInt32 in [0, 1, 2] {
          for mask: UInt32 in [0, 1, 0x20, 0x1000, 0x1000_0000, 0x2000_0000, 0xFFFF_FFFF] {
            for missing: UInt32 in [0, 1] {
              for op: UInt32 in [7, 8] {
                checkI3C(
                  { f in
                    configureI3C(f, state: state, mode: mode, seed: 3)
                    f.control(10, missing)
                    f.set(30, 7, 11)
                  }, operation: op, mask, callbacks: callbacks)
              }
            }
          }
        }
      }
    }
  }

  func testInformationAndPayloadFields() {
    for state: UInt32 in [0, 0x10, 0x30] {
      for bit: UInt32 in 0..<32 {
        for missing: UInt32 in [0, 1] {
          checkI3C(
            { f in
              configureI3C(f, state: state, mode: 2, seed: bit + 1)
              f.control(13, missing)
            }, operation: 63, 1 << bit)
        }
      }
    }
    for payload: UInt64 in [0, UInt64.max, 0x0123_4567_89AB_CDEF]
      + (0..<64).map({ UInt64(1) << $0 })
    {
      checkI3C(
        { f in configureI3C(f, state: 0, mode: 0, seed: 11) },
        operation: 64, UInt32(truncatingIfNeeded: payload),
        UInt32(truncatingIfNeeded: payload >> 32))
    }
    for op: UInt32 in [60, 61, 62] {
      checkI3C({ f in configureI3C(f, state: 0x60, mode: 2, seed: 5) }, operation: op)
    }
  }
}
