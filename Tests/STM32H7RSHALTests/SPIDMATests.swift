import CSPIReference
import STM32H7RSHAL
import XCTest

final class SPIDMATests: XCTestCase {
  func testStartWidthsLinkedListsAndHalfwordByteCountTruncation() {
    for op: UInt32 in [10, 11, 12] {
      for size: UInt32 in [7, 15, 31] {
        for width: UInt32 in [0, 1, 2] {
          for mode: UInt32 in [0, 0x80, 0x81] {
            for count: UInt32 in [1, 3, 32768, 65535] {
              let p = SPIPair()
              p.setup {
                $0.write(.state, value: 1)
                $0.write(.dataSize, value: size)
                $0.write(.mode, value: SPIConstants.SPI_MODE_MASTER)
                $0.raw(.cfg1, 0xFFFF_FFFF)
                for d in [UARTDMADirection.transmit, .receive] {
                  $0.setting(d, 0, 1)
                  $0.setting(d, 2, mode)
                  $0.setting(d, 5, 1)
                  $0.setting(d, 6, 1)
                  $0.setting(d, 13, width)
                  $0.setting(d, 14, width << 16)
                }
              }
              p.verify(op, count)
            }
          }
        }
      }
    }
  }

  func testLinkedQueueMissingAndStartFailurePartialEffects() {
    for op: UInt32 in [10, 11, 12] {
      for mode: UInt32 in [0, 0x80, 0x81] {
        for txFailure: UInt32 in [0, 1, 2, 3] {
          for rxFailure: UInt32 in [0, 1, 2, 3] {
            let p = SPIPair()
            p.setup {
              $0.write(.state, value: 1)
              $0.write(.dataSize, value: 7)
              for d in [UARTDMADirection.transmit, .receive] {
                $0.setting(d, 0, 1)
                $0.setting(d, 2, mode)
                $0.setting(d, 5, 1)
                $0.setting(d, 6, 1)
                let failure = d == .transmit ? txFailure : rxFailure
                $0.setting(d, 7, failure)
                $0.setting(d, 8, failure)
              }
            }
            p.verify(op, 5)
          }
        }
      }
      let p = SPIPair()
      p.setup {
        $0.write(.state, value: 1)
        $0.write(.dataSize, value: 7)
        $0.setting(.transmit, 0, 1)
        $0.setting(.receive, 0, 1)
        $0.setting(.transmit, 2, 0x80)
        $0.setting(.receive, 2, 0x80)
      }
      p.verify(op, 3)
    }
  }

  func testCompletionUsesAttachedChannelModesAndActualSourceError() {
    for callbacks in [false, true] {
      for crc in [false, true] {
        for op: UInt32 in 21...28 {
          for state: UInt32 in [1, 3, 4, 5, 7] {
            for txMode: UInt32 in [0, 0x81] {
              for rxMode: UInt32 in [0, 0x81] {
                for source: UInt32 in [0, 1] {
                  let p = SPIPair(callbacks: callbacks, crc: crc)
                  p.setup {
                    $0.write(.state, value: state)
                    $0.write(.transmitCount, value: 5)
                    $0.write(.receiveCount, value: 7)
                    $0.raw(.sr, 0x330)
                    $0.setting(.transmit, 0, 1)
                    $0.setting(.receive, 0, 1)
                    $0.setting(.transmit, 2, txMode)
                    $0.setting(.receive, 2, rxMode)
                    $0.setting(.receive, 3, 1)
                  }
                  p.verify(op, source)
                }
              }
            }
          }
        }
      }
    }
  }

  func testAbortPollingDMAErrorsAndSoftwareSuspendTimeout() {
    for callbacks in [false, true] {
      for crc in [false, true] {
        for start: UInt32 in [0, 0x200] {
          for error: UInt32 in [0, 1, 0x10, 0x20] {
            let p = SPIPair(callbacks: callbacks, crc: crc)
            p.setup {
              $0.write(.state, value: 5)
              $0.raw(.cr1, start | 1)
              $0.raw(.cfg1, 0xC000)
              $0.raw(.ier, 0xFFFF)
              $0.control(6, 24000)
              for d in [UARTDMADirection.transmit, .receive] {
                $0.setting(d, 0, 1)
                $0.setting(d, 9, error == 0 ? 0 : 1)
                $0.setting(d, 3, error)
              }
            }
            p.verify(13)
          }
        }
      }
    }
  }

  func testAbortInterruptPendingImmediateAndNoTransferCallbacks() {
    for callbacks in [false, true] {
      for enabled: UInt32 in [0, 0x4000, 0x8000, 0xC000] {
        for immediate: UInt32 in [0, 1] {
          for failure: UInt32 in [0, 1] {
            for error: UInt32 in [0, 0x10, 0x20] {
              let p = SPIPair(callbacks: callbacks)
              p.setup {
                $0.write(.state, value: 5)
                $0.write(.lock, value: 1)
                $0.raw(.cfg1, enabled)
                for d in [UARTDMADirection.transmit, .receive] {
                  $0.setting(d, 0, 1)
                  $0.setting(d, 10, failure)
                  $0.setting(d, 11, immediate)
                  $0.setting(d, 3, error)
                }
              }
              p.verify(14)
              if immediate == 0 {
                if enabled & 0x8000 != 0 { p.verify(29, 0) }
                if enabled & 0x4000 != 0 { p.verify(30, 1) }
              }
            }
          }
        }
      }
    }
  }

  func testAbortCompletionWaitsForTheOtherAttachedCallback() {
    for callbacks in [false, true] {
      for first: UInt32 in [29, 30] {
        let p = SPIPair(callbacks: callbacks)
        p.setup {
          $0.write(.state, value: 7)
          $0.write(.errorCode, value: 0x100)
          $0.setting(.transmit, 0, 1)
          $0.setting(.receive, 0, 1)
          $0.writeCallback(.transmit, id: .abort, value: $0.callback(.transmitAbort))
          $0.writeCallback(.receive, id: .abort, value: $0.callback(.receiveAbort))
        }
        p.verify(first, first == 29 ? 0 : 1)
        p.verify(first == 29 ? 30 : 29, first == 29 ? 1 : 0)
      }
    }
  }
}
