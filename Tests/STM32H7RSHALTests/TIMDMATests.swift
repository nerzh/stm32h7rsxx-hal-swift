import CTIMReference
import STM32H7RSHAL
import XCTest

final class TIMDMATests: XCTestCase {
  func testDMAStartsStatesNullBuffersAndLengths() {
    for registered in [false, true] {
      for op: UInt32 in [6, 14, 22, 30, 44, 109, 115, 121] {
        for channel: UInt32 in [0, 4, 8, 12, 16, 20, 60] {
          for state: UInt32 in [0, 1, 2] {
            for length: UInt32 in [0, 1, 17, 65535] {
              for missing: UInt32 in [0, 1] {
                let p = TIMPair(callbacks: registered)
                p.setup { f in
                  f.write(.state, value: state)
                  f.control(13, missing)
                  f.control(15, missing)
                  f.raw(.smcr, 0x10000)
                  for i in 0..<6 { f.writeChannelState(i, complementary: false, value: state) }
                  for i in 0..<4 { f.writeChannelState(i, complementary: true, value: state) }
                }
                p.verify(op, op == 6 || op == 109 ? length : channel, length)
              }
            }
          }
        }
      }
    }
  }
  func testDMAStartFailuresAndLinkedListRequirements() {
    for op: UInt32 in [6, 14, 22, 30, 44, 109, 115, 121] {
      for mode: UInt32 in [0, 0x80, 0x81] {
        for queue: UInt32 in [0, 1] {
          for head: UInt32 in [0, 1] {
            for failureChannel: UInt32 in [0, 1, 2, 8] {
              let p = TIMPair()
              p.setup { f in
                f.write(.state, value: 1)
                for i in 0..<6 { f.writeChannelState(i, complementary: false, value: 1) }
                for i in 0..<4 { f.writeChannelState(i, complementary: true, value: 1) }
                for d: UInt32 in 0..<7 {
                  f.dmaSetting(d, 0, mode)
                  f.dmaSetting(d, 2, queue)
                  f.dmaSetting(d, 3, head)
                  f.dmaSetting(d, 7, d == failureChannel ? 1 : 0)
                  f.dmaSetting(d, 8, d == failureChannel ? 2 : 0)
                  for i: UInt32 in 0..<8 { f.set(10 + d, i, 0xA500_0000 | i) }
                }
              }
              p.verify(op, op == 6 || op == 109 ? 7 : op == 44 ? 60 : 0, 7)
            }
          }
        }
      }
    }
  }
  func testDMAStopIgnoresAbortErrorsAndPreservesOtherChannels() {
    for op: UInt32 in [7, 15, 23, 31, 45, 110, 116, 122] {
      for channel: UInt32 in [0, 4, 8, 12, 16, 20, 60] {
        for ccer: UInt32 in [0, 1, 4, 0x5555] {
          let p = TIMPair()
          p.setup { f in
            f.raw(.cr1, 1)
            f.raw(.ccer, ccer)
            f.raw(.bdtr, 0x8000)
            f.raw(.dier, 0xFFFF_FFFF)
            for d: UInt32 in 0..<7 { f.dmaSetting(d, 9, 1) }
          }
          p.verify(op, channel)
        }
      }
    }
  }
  func testBurstRequestsCountsWidthsAndHandlePresence() {
    for op: UInt32 in [51, 54] {
      for request: UInt32 in [0, 0x100, 0x200, 0x400, 0x800, 0x1000, 0x2000, 0x4000, 0x8000] {
        for width: UInt32 in [0, 1, 2, 3] {
          for linked: UInt32 in [0, 1] {
            for absent in [false, true] {
              let p = TIMPair()
              p.setup { f in
                f.write(.dmaBurstState, value: 1)
                for ch in TIMDMAChannel.allCases {
                  let d = ch.rawValue
                  f.dmaSetting(d, 0, linked == 1 ? 0x81 : 0)
                  f.dmaSetting(d, 1, width)
                  f.dmaSetting(d, 2, linked)
                  f.set(10 + d, 0, width)
                  if absent { f.attach(ch, nil) }
                }
              }
              p.verify(op, 0xB, request, 0x1900)
            }
          }
        }
      }
    }
  }
  func testBurstMultiStartInvalidRequestsAndPartialDMAFailures() {
    for registered in [false, true] {
      for op: UInt32 in [52, 55] {
        for request: UInt32 in [0, 0x100, 0x200, 0x400, 0x800, 0x1000, 0x2000, 0x4000, 0x300] {
          for state: UInt32 in [0, 1, 2] {
            for missing: UInt32 in [0, 1] {
              for fail: UInt32 in [0, 1] {
                let p = TIMPair(callbacks: registered)
                p.setup { f in
                  f.write(.dmaBurstState, value: state)
                  f.control(13, missing)
                  f.raw(.dcr, 0xFFFF_FFFF)
                  for d: UInt32 in 0..<7 { f.dmaSetting(d, 7, fail) }
                }
                p.verify(op, 11, request, 0x100, 21)
              }
            }
          }
        }
      }
    }
  }
  func testBurstZeroLengthNullBufferAndQueueFallback() {
    for op: UInt32 in [51, 52, 54, 55] {
      for linked: UInt32 in [0, 0x80] {
        for head: UInt32 in [0, 1] {
          let p = TIMPair()
          p.setup { f in
            f.write(.dmaBurstState, value: 1)
            f.control(13, 1)
            f.dmaSetting(0, 0, linked)
            f.dmaSetting(0, 2, 1)
            f.dmaSetting(0, 3, head)
            f.dmaSetting(0, 1, 2)
          }
          p.verify(op, 0, 0x100, 0, 0)
        }
      }
    }
  }
  func testBurstStopEveryRequestAndAbortFailure() {
    for op: UInt32 in [53, 56] {
      for request: UInt32 in [0, 0x100, 0x200, 0x400, 0x800, 0x1000, 0x2000, 0x4000, 0x300] {
        let p = TIMPair()
        p.setup { f in
          f.write(.dmaBurstState, value: 2)
          f.raw(.dier, 0xFFFF_FFFF)
          for d: UInt32 in 0..<7 { f.dmaSetting(d, 9, 1) }
        }
        p.verify(op, request)
      }
    }
  }
  func testDMAHelperAndEveryCallbackSourceIdentity() {
    for registered in [false, true] {
      for op: UInt32 in Array(76...84) + Array(157...160) {
        for source: UInt32 in 0..<8 {
          for alias in [false, true] {
            let p = TIMPair(callbacks: registered)
            p.setup { f in
              f.control(30, source)
              f.write(.state, value: 2)
              f.write(.channel, value: 0x55)
              f.write(.dmaBurstState, value: 2)
              for i in 0..<6 { f.writeChannelState(i, complementary: false, value: 2) }
              for i in 0..<4 { f.writeChannelState(i, complementary: true, value: 2) }
              if alias {
                f.attach(.captureCompare1, 2)
                f.attach(.captureCompare2, 2)
                f.attach(.captureCompare3, nil)
              }
            }
            p.verify(op)
          }
        }
      }
    }
    for linked: UInt32 in [0, 0x80] {
      let p = TIMPair()
      p.setup { f in
        f.dmaSetting(0, 0, linked)
        f.dmaSetting(0, 2, 1)
      }
      p.verify(64, 0x2000_0000, 0x4000_0000, 65535)
    }
  }
  func testDMACompletionKeepsBusyAndErrorResetsOnlyMatchingChannel() {
    let p = TIMPair()
    p.setup { f in
      f.control(30, 1)
      f.write(.state, value: 2)
      f.write(.dmaBurstState, value: 2)
      f.writeChannelState(0, complementary: false, value: 2)
      f.control(20, 22)
      f.control(21, 6)
      f.control(22, 0xAA)
    }
    p.verify(77)
    XCTAssertEqual(p.swift.read(TIMHandleWord.state), 2)
    XCTAssertEqual(p.swift.readChannelState(0, complementary: false), 2)
    XCTAssertEqual(p.swift.read(TIMHandleWord.channel), 0)
    p.verify(76)
    XCTAssertEqual(p.swift.readChannelState(0, complementary: false), 1)
    XCTAssertEqual(p.swift.read(TIMHandleWord.dmaBurstState), 2)
  }
}
