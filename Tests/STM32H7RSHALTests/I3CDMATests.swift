import STM32H7RSHAL
import XCTest

final class I3CDMATests: XCTestCase {
  func testDMAStartOrderWidthsAndPartialFailures() {
    for op: UInt32 in [29, 32, 35, 38, 40, 49, 52] {
      for state: UInt32 in [0x10, 0x30] {
        for word in [false, true] {
          for count: UInt32 in [0, 1, 3, 4, 5, 8, 65535, UInt32.max - 1] {
            for failingChannel: UInt32 in 0...3 {
              checkI3C(
                { f in
                  prepareI3CBuffers(f, state: state, mode: op >= 49 ? 2 : 1, count: count)
                  f.set(30, 5, count)
                  f.set(30, 7, count)
                  f.set(0, 0x60 / 4, 1)
                  if word {
                    f.set(
                      0, 1,
                      I3CConstants.HAL_I3C_TXFIFO_THRESHOLD_4_4
                        | I3CConstants.HAL_I3C_RXFIFO_THRESHOLD_4_4)
                  }
                  for channel: UInt32 in 0..<3 {
                    f.set(3 + channel, 0, 1)
                    f.set(3 + channel, 4, channel == failingChannel ? 1 : 0)
                    f.set(3 + channel, 5, channel & 1)
                    for slot: UInt32 in 0..<4 { f.set(6 + channel, slot, 4) }
                  }
                }, operation: op)
            }
          }
        }
      }
    }
  }

  func testMissingDMAChannelsAndZeroData() {
    for op: UInt32 in [29, 32, 35, 38, 40, 49, 52] {
      for channels: UInt32 in 0..<8 {
        for count: UInt32 in [0, 1] {
          checkI3C(
            { f in
              prepareI3CBuffers(f, mode: op >= 49 ? 2 : 1, count: count)
              f.set(0, 0x60 / 4, 1)
              for channel: UInt32 in 0..<3 { f.set(3 + channel, 0, (channels >> channel) & 1) }
            }, operation: op)
        }
      }
    }
  }

  func testDMACompletionCallbacksAndAbortCleanup() {
    for callbacks in [false, true] {
      for op: UInt32 in 85...89 {
        for state: UInt32 in [0x20, 0x21, 0x22, 0x23, 0x60] {
          for channels: UInt32 in 0..<8 {
            checkI3C(
              { f in
                prepareI3CBuffers(f, state: state)
                f.set(0, 1, UInt32.max)
                for channel: UInt32 in 0..<3 {
                  f.set(3 + channel, 0, (channels >> channel) & 1)
                  for slot: UInt32 in 0..<4 { f.set(6 + channel, slot, 5) }
                }
              }, operation: op, callbacks: callbacks)
          }
        }
      }
    }
  }
}
