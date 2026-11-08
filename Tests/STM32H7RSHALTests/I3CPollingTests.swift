import STM32H7RSHAL
import XCTest

final class I3CPollingTests: XCTestCase {
  func testControllerAndTargetPollingWidths() {
    for op: UInt32 in [27, 30, 33, 36, 47, 50] {
      for previous: UInt32 in [0x10, 0x30] {
        for count: UInt32 in [1, 3, 4, 5, 8] {
          for word in [false, true] {
            for fifo in [false, true] {
              checkI3C(
                { f in
                  prepareI3CBuffers(f, state: previous, mode: op >= 47 ? 2 : 1, count: count)
                  f.set(30, 5, count)
                  f.set(30, 7, count)
                  f.set(
                    0, 1,
                    (word
                      ? I3CConstants.HAL_I3C_TXFIFO_THRESHOLD_4_4
                        | I3CConstants.HAL_I3C_RXFIFO_THRESHOLD_4_4 : 0)
                      | (fifo ? I3CConstants.HAL_I3C_CONTROLFIFO_ENABLE : 0))
                  f.set(0, 0x50 / 4, 0x200 | 0x10 | 0x20 | 0x4)
                  f.set(0, 0x60 / 4, 1)
                  f.set(0, 0x30 / 4, count)
                  f.set(0, 0x10 / 4, 0x1234_56A7)
                  f.set(0, 0x14 / 4, 0x89AB_CDEF)
                  f.control(7, word ? (count + 3) / 4 : count)
                  f.control(8, word ? (count + 3) / 4 : count)
                  f.control(9, 1)
                }, operation: op, 100)
            }
          }
        }
      }
    }
  }

  func testPollingTimeoutAndErrorCleanup() {
    for op: UInt32 in [27, 30, 33, 36, 47, 50] {
      for timeout: UInt32 in [0, 1, 3] {
        for flags: UInt32 in [0, 0x8, 0x800, 0xA00] {
          checkI3C(
            { f in
              prepareI3CBuffers(f, mode: op >= 47 ? 2 : 1)
              f.set(0, 0x60 / 4, 1)
              f.set(0, 0x50 / 4, flags)
              f.set(0, 0x34 / 4, 0xFFFF_FFFF)
              f.control(1, UInt32.max - 1)
            }, operation: op, timeout)
        }
      }
    }
  }

  func testTransferValidationOrder() {
    for op: UInt32 in [
      27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 47, 48, 49, 50, 51, 52,
    ] {
      for state: UInt32 in [0, 0x20, 0x60] {
        for mode: UInt32 in [0, 1, 2] {
          for missing: UInt32 in [0, 1, 2, 3] {
            checkI3C(
              { f in
                prepareI3CBuffers(f, state: state, mode: mode)
                if missing == 1 { f.control(10, 1) }
                if missing == 2 { f.set(30, 4, 0) }
                if missing == 3 { f.set(30, 6, 0) }
                f.control(1, UInt32.max - 2)
              }, operation: op, 0)
          }
        }
      }
    }
  }

  func testDynamicAddressAssignmentAndPayloadWidths() {
    for state: UInt32 in [0, 0x10, 0x20, 0x24, 0x30] {
      for option: UInt32 in [0, 1, 2] {
        for flags: UInt32 in [0, 0x200, 0x10, 0x800, 0x210] {
          for word in [false, true] {
            checkI3C(
              { f in
                prepareI3CBuffers(f, state: state)
                f.set(0, 1, word ? I3CConstants.HAL_I3C_RXFIFO_THRESHOLD_4_4 : 0)
                f.set(0, 0x50 / 4, flags)
                f.set(0, 0x10 / 4, 0xAB)
                f.set(0, 0x14 / 4, 0x89AB_CDEF)
                f.set(0, 0x34 / 4, 0x12345)
              }, operation: 41, option, 3)
          }
        }
      }
    }
    for flags: UInt32 in [0, 0x10] {
      for address: UInt32 in [0, 1, 0x7F, 0xFF] {
        checkI3C(
          { f in
            prepareI3CBuffers(f)
            f.set(0, 0x50 / 4, flags)
          }, operation: 43, address)
      }
    }
  }

  func testReadinessTrialsAndArbitrationRestoration() {
    for op: UInt32 in [44, 45, 46] {
      for trials: UInt32 in [0, 1, 3] {
        for flags: UInt32 in [0, 0x200, 0x800, 0xA00] {
          for noArbitration in [false, true] {
            checkI3C(
              { f in
                prepareI3CBuffers(f, state: 0x30)
                f.set(0, 1, noArbitration ? 0x8000_0000 : 0)
                f.set(0, 0x50 / 4, flags)
                f.set(0, 0x34 / 4, UInt32.max)
                f.control(1, UInt32.max - 2)
              }, operation: op, op == 46 ? 3 : 0xA5, trials, 3)
          }
        }
      }
    }
  }

  func testTargetRequestsAndIBIPayload() {
    for op: UInt32 in [53, 54, 55, 56, 57, 58] {
      for size: UInt32 in [0, 1, 2, 3, 4] {
        for permission: UInt32 in [0, 1, 0x71, 0xF1] {
          for flags: UInt32 in [0, 0x200, 0x800, 0xFFFF_F000] {
            checkI3C(
              { f in
                prepareI3CBuffers(f, state: 0x30, mode: 2)
                f.set(0, 0x60 / 4, permission | 0x2A0000)
                f.set(0, 0xC0 / 4, 4)
                f.set(0, 0x50 / 4, flags)
              }, operation: op, op >= 57 ? size : 3, 3)
          }
        }
      }
    }
  }
}
