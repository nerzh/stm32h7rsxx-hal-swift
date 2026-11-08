import CI3CReference
import STM32H7RSHAL
import XCTest

func prepareI3CInterrupt(_ f: I3CFixture, selector: UInt32, state: UInt32, word: Bool = false) {
  prepareI3CBuffers(
    f, state: state, mode: selector == 1 || (3...9).contains(selector) ? 2 : 1, count: 4)
  f.write(.previousState, value: 0x30)
  f.write(.transferISR, value: selector)
  f.write(.transmitTreatment, value: word ? 2 : 1)
  f.write(.receiveTreatment, value: word ? 2 : 1)
  f.write(.controlTransferCount, value: 2)
  for i: UInt32 in 0..<3 {
    CI3C_SetPointer(f.state, i, 1)
    f.set(3 + i, 0, 1)
    f.set(3 + i, 1, 1)
    f.set(3 + i, 2, i + 1)
    f.set(3 + i, 3, i + 2)
  }
  f.set(30, 5, 4)
  f.set(30, 7, 4)
  f.set(0, 0x54 / 4, UInt32.max)
  f.set(0, 0x60 / 4, 0x550001)
  f.set(0, 0x10 / 4, 0xAB)
  f.set(0, 0x14 / 4, 0x1234_5678)
  f.set(0, 0x30 / 4, 4)
  if word {
    f.set(
      0, 1, I3CConstants.HAL_I3C_RXFIFO_THRESHOLD_4_4 | I3CConstants.HAL_I3C_TXFIFO_THRESHOLD_4_4)
  }
  f.control(7, 2)
  f.control(8, 2)
  f.control(9, 1)
}

final class I3CInterruptTests: XCTestCase {
  func testTransferStartAndListenSelection() {
    for callbacks in [false, true] {
      for op: UInt32 in [28, 31, 34, 37, 39, 42, 48, 51, 54, 56, 58, 59] {
        for state: UInt32 in [0x10, 0x30, 0x20, 0x21, 0x22, 0x23, 0x24] {
          for word in [false, true] {
            checkI3C(
              { f in
                prepareI3CBuffers(f, state: state, mode: op >= 48 ? 2 : 1)
                if word {
                  f.set(
                    0, 1,
                    I3CConstants.HAL_I3C_RXFIFO_THRESHOLD_4_4
                      | I3CConstants.HAL_I3C_TXFIFO_THRESHOLD_4_4)
                }
                f.set(0, 0x60 / 4, 0x71)
                f.set(0, 0xC0 / 4, 4)
              }, operation: op, 2, callbacks: callbacks)
          }
        }
      }
    }
  }

  func testEveryInterruptSelectorAndFlagPriority() {
    let states: [UInt32] = [
      0x30, 0x30, 0x20, 0x20, 0x20, 0x21, 0x22, 0x21, 0x22, 0x21, 0x22, 0x23, 0x21, 0x22, 0x23,
      0x24, 0x21, 0x22, 0x23, 0x60,
    ]
    for callbacks in [false, true] {
      for selector: UInt32 in 1...20 {
        for flags: UInt32 in [0, 0x4, 0x10, 0x20, 0x8, 0x200, 0x400, 0x800, 0xA34, UInt32.max]
          + (12..<32).map({ UInt32(1) << $0 })
        {
          for word in [false, true] {
            checkI3C(
              { f in
                prepareI3CInterrupt(
                  f, selector: selector, state: states[Int(selector - 1)], word: word)
                f.set(0, 0x50 / 4, flags)
              }, operation: 10, callbacks: callbacks)
          }
        }
      }
    }
  }

  func testIRQMaskAndInactiveState() {
    for selector: UInt32 in 1...20 {
      for state: UInt32 in [0, 0x10, 0xE0] {
        for mask: UInt32 in [0, 0x200, 0x10, 0xFFFF_0000, UInt32.max] {
          checkI3C(
            { f in
              prepareI3CInterrupt(f, selector: selector, state: state)
              f.set(0, 0x50 / 4, 0xFFFF_FFFF)
              f.set(0, 0x54 / 4, mask)
            }, operation: 10)
        }
      }
    }
    checkI3C(
      { f in
        prepareI3CBuffers(f)
        f.set(0, 0x50 / 4, UInt32.max)
        f.set(0, 0x54 / 4, UInt32.max)
      }, operation: 10)
  }

  func testCallbackMutationAndRegisteredSignatures() {
    for selector: UInt32 in [1, 2, 3, 4, 5, 13, 14, 15, 16, 20] {
      for callbackID: UInt32 in 0..<13 {
        checkI3C(
          { f in
            let state: UInt32 =
              selector == 16
              ? 0x24
              : selector == 20
                ? 0x60
                : selector <= 2
                  ? 0x30
                  : selector <= 5 ? 0x20 : selector == 13 ? 0x21 : selector == 14 ? 0x22 : 0x23
            prepareI3CInterrupt(f, selector: selector, state: state)
            f.set(0, 0x50 / 4, UInt32.max)
            for id: UInt32 in 0..<13 { CI3C_SetCallback(f.state, id, CI3C_Callback(id, 2)) }
            f.control(20, callbackID + 1)
            f.control(21, 14)
            f.control(22, 0x60)
          }, operation: 10)
      }
    }
  }

  func testErrorIRQAndDMAAbortBoundaries() {
    for callbacks in [false, true] {
      for state: UInt32 in [0x10, 0x20, 0x21, 0x22, 0x23, 0x60] {
        for mode: UInt32 in [0, 1, 2] {
          for busy in [false, true] {
            for result: UInt32 in [0, 1] {
              for synchronous: UInt32 in [0, 1] {
                // The DMA API cannot return failure after completing this abort callback.
                if result != 0 && synchronous != 0 { continue }
                checkI3C(
                  { f in
                    prepareI3CInterrupt(f, selector: 10, state: state)
                    f.write(.mode, value: mode)
                    f.set(0, 0x50 / 4, 0x800)
                    f.set(0, 0x34 / 4, 0xFFFF_FFFF)
                    for channel: UInt32 in 0..<3 {
                      f.set(3 + channel, 1, busy ? 2 : 1)
                      f.set(3 + channel, 6, result)
                      f.set(3 + channel, 7, synchronous)
                      // C does not install hdmacr's abort callback here.
                      f.set(6 + channel, 3, 5)
                    }
                  }, operation: 9, callbacks: callbacks)
              }
            }
          }
        }
      }
    }
  }
}
