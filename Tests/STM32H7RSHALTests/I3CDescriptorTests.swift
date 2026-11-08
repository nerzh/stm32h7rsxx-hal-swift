import CI3CReference
import STM32H7RSHAL
import XCTest

func prepareI3CBuffers(_ f: I3CFixture, state: UInt32 = 0x10, mode: UInt32 = 1, count: UInt32 = 3) {
  f.write(.state, value: state)
  f.write(.previousState, value: state)
  f.write(.mode, value: mode)
  f.write(.errorCode, value: 0xABC)
  f.write(.controlTransferCount, value: 1)
  f.write(.transmitTransferCount, value: count)
  f.write(.receiveTransferCount, value: count)
  for i: UInt32 in 0..<8 {
    for j in 0..<256 { f.buffer(i)[j] = UInt8(truncatingIfNeeded: i * 31 + UInt32(j)) }
  }
  f.set(30, 0, 0xABC0_0000)
  f.set(30, 1, 16)
  f.set(30, 2, 0xABC1_0000)
  f.set(30, 3, 16)
  f.set(30, 4, 0xABC2_0000)
  f.set(30, 5, 64)
  f.set(30, 6, 0xABC3_0000)
  f.set(30, 7, 64)
  for i: UInt32 in 0..<8 {
    f.set(28, i * 5, 0x20 + i)
    f.set(28, i * 5 + 1, 0x80 + i)
    f.set(28, i * 5 + 2, 0xABC4_0000 + i * 16)
    f.set(28, i * 5 + 3, count)
    f.set(28, i * 5 + 4, 0)
    f.set(29, i * 6, 0x30 + i)
    f.set(29, i * 6 + 1, 0xABC5_0000 + i * 16)
    f.set(29, i * 6 + 2, count)
    f.set(29, i * 6 + 3, 0xABC6_0000 + i * 16)
    f.set(29, i * 6 + 4, count)
    f.set(29, i * 6 + 5, 0)
  }
}

final class I3CDescriptorTests: XCTestCase {
  func testAllDescriptorOperationKinds() {
    for option: UInt32 in [
      0x1800_0001, 0x9800_0001, 0x1800_0000, 0x9800_0000, 0x3000_0001, 0xB000_0001,
      0x3000_0000, 0xB000_0000, 0x1000_0000, 0x9000_0000, 0x1000_0004, 0x9000_0004,
      0x2000_0000, 0xA000_0000, 0x2000_0004, 0xA000_0004,
    ] {
      for frames: UInt32 in [1, 2, 4, 8] {
        for pattern: UInt32 in [0, 1, 2] {
          checkI3C(
            { f in
              prepareI3CBuffers(f)
              for i: UInt32 in 0..<8 {
                let direction: UInt32 = pattern == 1 || (pattern == 2 && i & 1 != 0) ? 0x10000 : 0
                f.set(28, i * 5 + 4, direction)
                f.set(29, i * 6 + 5, direction)
              }
            }, operation: 17, frames, option)
        }
      }
    }
  }

  func testDescriptorCapacityFailuresPreservePartialState() {
    for option: UInt32 in [0x9800_0001, 0x9800_0000, 0xB000_0000, 0x9000_0004] {
      for controlSize: UInt32 in [0, 1, 3, 4, 8] {
        for txSize: UInt32 in [0, 1, 5, 6, 9, 12] {
          for rxSize: UInt32 in [0, 3, 12] {
            checkI3C(
              { f in
                prepareI3CBuffers(f)
                f.set(30, 1, controlSize)
                f.set(30, 5, txSize)
                f.set(30, 7, rxSize)
                f.set(28, 5 + 4, 0x10000)
                f.set(29, 6 + 5, 0x10000)
              }, operation: 17, 3, option)
          }
        }
      }
    }
  }

  func testDescriptorArgumentAndStateFailures() {
    for state: UInt32 in [0, 0x10, 0x20, 0x30, 0x60] {
      for option: UInt32 in [0x9800_0001, 0xB000_0000, 0x9000_0000] {
        for missing: UInt32 in 0..<7 {
          for count: UInt32 in [0, 1, 2] {
            checkI3C(
              { f in
                prepareI3CBuffers(f, state: state)
                if missing == 1 { f.control(10, 1) }
                if missing == 2 { f.control(11, 1) }
                if missing == 3 { f.control(12, 1) }
                if missing == 4 { f.set(30, 0, 0) }
                if missing == 5 { f.set(30, 4, 0) }
                if missing == 6 { f.set(28, 3, 0) }
              }, operation: 17, count, option)
          }
        }
      }
    }
  }

  func testWordThresholdAndDescriptorAliasing() {
    for frames: UInt32 in [1, 2, 3] {
      for option: UInt32 in [0x9800_0001, 0xB000_0000, 0x9000_0000] {
        checkI3C(
          { f in
            prepareI3CBuffers(f)
            f.set(0, 1, I3CConstants.HAL_I3C_TXFIFO_THRESHOLD_4_4)
            // C copies forward even if a descriptor overlaps the destination.
            f.set(28, 2, 0xABC2_0001)
            f.set(29, 1, 0xABC2_0001)
          }, operation: 17, frames, option)
      }
    }
  }
}
