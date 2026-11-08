import CI2CReference
import STM32H7RSHAL
import XCTest

final class I2CPollingTests: XCTestCase {
  func testSuccessfulTransfersIncludeReloadBoundariesAndUnalignedBuffers() {
    for op: UInt32 in [6, 7, 8, 9, 18, 19] {
      for size: UInt32 in [0, 1, 2, 254, 255, 256, 257, 510, 511] {
        for address: UInt32 in [0, 0xA0, 0x3FF] {
          for noStretch: UInt32 in [0, 0x20000] {
            let p = I2CPair()
            p.setup { f in
              f.write(.state, value: 0x20)
              f.write(.noStretchMode, value: noStretch)
              f.write(.addressingMode, value: address == 0x3FF ? 2 : 1)
              f.write(.isr, value: op == 8 ? 0x1003A : op == 9 ? 0x2C : 0xE6)
              f.write(.rxdr, value: 0x1234_ABCD)
              f.write(.cr2, value: .max)
              f.control(14, 3)
              f.control(15, 0xABCD)
              f.control(16, address == 0x3FF ? 2 : 1)
              for i in 0..<4096 { f.buffer[i] = UInt8(truncatingIfNeeded: i * 7) }
            }
            p.verify(op, address, size, 10)
          }
        }
      }
    }
  }
  func testTimeoutErrorsAndTickWrapRetainSourceCleanupAsymmetries() {
    for op: UInt32 in [6, 7, 8, 9, 18, 19] {
      for flags: UInt32 in [0, 0x8000, 0x10, 0x30, 0x100, 0x200, 0x400, 0x700, 0x800, 0xE2, 0xE4] {
        for tick: UInt32 in [0, 0xFFFF_FFF8] {
          for timeout: UInt32 in [0, 1, 25] {
            let p = I2CPair()
            p.setup { f in
              f.write(.state, value: 0x20)
              f.write(.mode, value: 0x20)
              f.write(.errorCode, value: 0x8000)
              f.write(.isr, value: flags)
              f.write(.rxdr, value: 0xA5)
              f.write(.cr2, value: 0xDEAD_0000)
              f.control(0, tick)
              f.control(1, 1)
            }
            p.verify(op, 0xA0, 3, timeout)
          }
        }
      }
    }
  }
  func testStateLockInvalidBufferAndZeroLengthChecksHaveOriginalOrder() {
    for op: UInt32 in [6, 7, 8, 9, 18, 19] {
      for state: UInt32 in [0, 0x20, 0x24, 0x28] {
        for locked: UInt32 in [0, 1] {
          for nilBuffer: UInt32 in [0, 1] {
            for count: UInt32 in [0, 1, 0xFFFF] {
              let p = I2CPair()
              p.setup { f in
                f.write(.state, value: state)
                f.write(.lock, value: locked)
                f.write(.errorCode, value: 0x8000)
                f.control(13, nilBuffer)
                // Missing data flags forces timeout before any buffer access.
                f.write(.isr, value: 0)
              }
              p.verify(op, 0xA0, count, 0)
            }
          }
        }
      }
    }
  }
  func testDeviceReadyRetriesModesAndTimeouts() {
    for flags: UInt32 in [0, 0x10, 0x20, 0x30, 0x100, 0x8000] {
      for trials: UInt32 in [0, 1, 2, 3] {
        for mode: UInt32 in [1, 2] {
          for timeout: UInt32 in [0, 1, 25] {
            let p = I2CPair()
            p.setup { f in
              f.write(.state, value: 0x20)
              f.write(.addressingMode, value: mode)
              f.write(.isr, value: flags)
              f.control(0, 0xFFFF_FFF8)
            }
            p.verify(24, 0xA1, trials, timeout)
          }
        }
      }
    }
  }
  func testFlagChangesAtTimeoutBoundaryAreReread() {
    for op: UInt32 in [6, 7, 18, 19] {
      for due: UInt32 in [1, 2, 3, 4, 25, 26, 27] {
        for initial: UInt32 in [0, 0x8000, 0x10] {
          let p = I2CPair()
          p.setup { f in
            f.write(.state, value: 0x20)
            f.write(.isr, value: initial)
            f.control(10, due)
            f.control(11, 0xE6)
            f.control(16, 2)
          }
          p.verify(op, 0xA0, 2, 2)
        }
      }
    }
  }
}
