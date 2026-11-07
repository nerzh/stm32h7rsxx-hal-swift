import XCTest
import CUARTReference
@testable import STM32H7RSHAL

private func uartDMAReferencePrepare(_ state: UnsafeMutablePointer<CUARTState>, busy: Bool = true) {
  for uart in UInt32(0)..<2 {
    CUART_SetWord(state, uart, 26, 0x2000_0000)
    CUART_SetWord(state, uart, 27, 1)
    CUART_SetWord(state, uart, 28, 2)
    CUART_SetWord(state, uart, 29, 1)
    CUART_SetWord(state, uart, 30, busy ? 0x21 : 0x20)
    CUART_SetWord(state, uart, 31, busy ? 0x22 : 0x20)
    CUART_SetWord(state, uart, 32, 8)
    CUART_SetWord(state, uart, 33, 3)
    CUART_SetWord(state, uart, 34, 4)
    CUART_SetWord(state, uart, 19, 16); CUART_SetWord(state, uart, 20, 9)
    CUART_SetWord(state, uart, 21, 16); CUART_SetWord(state, uart, 22, 7)
    CUART_SetPointer(state, uart, 0, CUART_BufferAddress(uart, 0))
    CUART_SetPointer(state, uart, 1, CUART_BufferAddress(uart, 1))
    CUART_SetRegister(state, uart, CUART_CR1, .max)
    CUART_SetRegister(state, uart, CUART_CR3, .max)
    if state.pointee.registeredCallbacks != 0 {
      for callback in UInt32(0)..<14 { CUART_SetCallback(state, uart, callback, 1 + callback % 3) }
    }
    for direction in UInt32(0)..<2 {
      let channel = uart * 2 + direction
      CUART_LinkDMA(state, uart, direction, Int32(channel))
      CUART_SetDMAWord(state, channel, CUART_DMAMode, 0)
      CUART_SetDMAWord(state, channel, CUART_DMAState, 2)
      CUART_SetDMAWord(state, channel, CUART_DMALock, 1)
      CUART_SetDMAWord(state, channel, CUART_DMAError, 0)
      CUART_SetDMAWord(state, channel, CUART_DMACounter, 6)
      CUART_SetDMAWord(state, channel, CUART_DMAParent, uart)
      for slot in UInt32(0)..<5 { CUART_SetDMACallback(state, channel, slot, 5) }
    }
  }
}
private func uartDMAReferenceAction(_ kind: CUARTActionKind, target: UInt32 = 0,
                                    index: UInt32 = 0, value: UInt32 = 0,
                                    a: UInt32 = 0, b: UInt32 = 0,
                                    c: UInt32 = 0, d: UInt32 = 0) -> CUARTAction {
  CUARTAction(kind: kind, target: target, index: index, value: value, args: (a, b, c, d))
}

final class UARTDMADifferentialTests: XCTestCase {
  func testDMAStartStatePointerAndZeroSizeBranchesAgainstC() {
    for registered in [false, true] {
      for operation in [CUART_TransmitDMA, CUART_ReceiveDMA, CUART_ReceiveToIdleDMA] {
        for state: UInt32 in [0, 0x20, 0x21, 0x22, 0x23, 0x24, 0xA0, 0xE0, .max] {
          for invalid: UInt32 in 0..<3 {
            let pair = UARTReferencePair(registered: registered) {
              uartDMAReferencePrepare($0, busy: false)
              CUART_SetWord($0, 0, operation == CUART_TransmitDMA ? 30 : 31, state)
            }
            pair.run(operation, a: invalid == 0 ? 0 : 7, d: invalid == 1 ? 1 : 0)
          }
        }
      }
    }
  }

  func testDMAStartWordLengthParityAndUInt16ByteCountBoundariesAgainstC() {
    for registered in [false, true] {
      for operation in [CUART_TransmitDMA, CUART_ReceiveDMA, CUART_ReceiveToIdleDMA] {
        for wordLength: UInt32 in [0, 0x1000, 0x1000_0000] {
          for parity: UInt32 in [0, 0x400, 0x600] {
            for size: UInt32 in [1, 7, 0x7FFF, 0x8000, 0xFFFF] {
              let pair = UARTReferencePair(registered: registered) {
                uartDMAReferencePrepare($0, busy: false)
                CUART_SetWord($0, 0, 1, wordLength); CUART_SetWord($0, 0, 3, parity)
                CUART_SetRegister($0, 0, CUART_CR3, 0x2000_0000)
              }
              pair.run(operation, a: size, c: 4)
            }
          }
        }
      }
    }
  }

  func testReceiveRTOAndPeripheralDataAddressesForAllInstancesAgainstC() {
    for instance in UARTInstance.allCases {
      for operation in [CUART_TransmitDMA, CUART_ReceiveDMA, CUART_ReceiveToIdleDMA] {
        for rto in [false, true] {
          let pair = UARTReferencePair(registered: true) {
            uartDMAReferencePrepare($0, busy: false)
            CUART_SetInstance($0, 0, instance.rawValue)
            CUART_SetRegister($0, 0, CUART_CR2, rto ? 0x0080_0000 : 0)
          }
          pair.run(operation, a: 19)
        }
      }
    }
  }

  func testLinkedListHeadUpdatesAndAllDMAStartStatusesAgainstC() {
    for registered in [false, true] {
      for operation in [CUART_TransmitDMA, CUART_ReceiveDMA, CUART_ReceiveToIdleDMA] {
        for mode: UInt32 in [0x80, 0x81, 0x180] {
          for queue: UInt32 in 0..<3 {
            for status: UInt32 in 0..<4 {
              let pair = UARTReferencePair(registered: registered) {
                uartDMAReferencePrepare($0, busy: false)
                let channel: UInt32 = operation == CUART_TransmitDMA ? 0 : 1
                CUART_SetDMAWord($0, channel, CUART_DMAMode, mode)
                CUART_SetDMAWord($0, channel, CUART_DMAQueuePresent, queue == 0 ? 0 : 1)
                let base: UInt32 = 0x2403_0000 + channel * 0x100
                CUART_DMAWriteMemory32($0, channel, base, queue == 1 ? 0 : base + 0x40)
                for word: UInt32 in 0..<9 {
                  CUART_DMAWriteMemory32($0, channel, base + 0x40 + word * 4, 0xA55A_0000 | word)
                }
                CUART_SetDMAStatus($0, channel, CUART_DMAStartLinkedListInterrupt, status)
              }
              pair.run(operation, a: 11, c: 2)
            }
          }
        }
      }
    }
  }

  func testNormalDMAFailureAndAbsentHandleBranchesAgainstC() {
    for registered in [false, true] {
      for operation in [CUART_TransmitDMA, CUART_ReceiveDMA, CUART_ReceiveToIdleDMA] {
        for present in [false, true] {
          for status: UInt32 in 0..<4 {
            let pair = UARTReferencePair(registered: registered) {
              uartDMAReferencePrepare($0, busy: false)
              let direction: UInt32 = operation == CUART_TransmitDMA ? 0 : 1
              CUART_LinkDMA($0, 0, direction, present ? Int32(direction) : -1)
              CUART_SetDMAStatus($0, direction, CUART_DMAStartInterrupt, status)
            }
            pair.run(operation, a: 8)
          }
        }
      }
    }
  }

  func testReceiveToIdleDetectsReceptionAbortedInsideStartBoundaryAgainstC() {
    for registered in [false, true] {
      for linked in [false, true] {
        for useErrorCallback in [false, true] {
          let pair = UARTReferencePair(registered: registered) {
            uartDMAReferencePrepare($0, busy: false)
            CUART_SetDMAWord($0, 1, CUART_DMAMode, linked ? 0x80 : 0)
            CUART_SetDMAWord($0, 1, CUART_DMAQueuePresent, 1)
            let action = useErrorCallback
              ? uartDMAReferenceAction(CUART_ActionDMAEvent, target: 1,
                  index: UARTDMACallbackKind.error.rawValue)
              : uartDMAReferenceAction(CUART_ActionWord, index: 27, value: 0)
            CUART_SetDMAAction($0, 1, linked ? CUART_DMAStartLinkedListInterrupt : CUART_DMAStartInterrupt, action)
          }
          pair.run(CUART_ReceiveToIdleDMA, a: 16)
        }
      }
    }
  }

  func testPauseAndStopCapturedStatesAndFreshRequestsAgainstC() {
    for registered in [false, true] {
      for operation in [CUART_PauseDMA, CUART_StopDMA] {
        for txState: UInt32 in [0x20, 0x21, 0x24] {
          for rxState: UInt32 in [0x20, 0x22, 0x24] {
            for requests: UInt32 in 0..<4 {
              let pair = UARTReferencePair(registered: registered) {
                uartDMAReferencePrepare($0)
                CUART_SetWord($0, 0, 30, txState); CUART_SetWord($0, 0, 31, rxState)
                CUART_SetRegister($0, 0, CUART_CR3, 0x1080_0001 | requests << 6)
                CUART_SetDMAAction($0, 0, operation == CUART_PauseDMA ? CUART_DMASuspend : CUART_DMAAbort,
                  uartDMAReferenceAction(CUART_ActionWord, index: 31, value: 0x20))
              }
              pair.run(operation)
            }
          }
        }
      }
    }
  }

  func testPauseStopAndBlockingAbortsRequireExactDMAErrorTimeoutAgainstC() {
    for registered in [false, true] {
      for operation in [CUART_PauseDMA, CUART_StopDMA, CUART_Abort, CUART_AbortTransmit, CUART_AbortReceive] {
        for channel: UInt32 in 0..<2 {
          for error: UInt32 in [0, 0x10, 0x11, 0x20, .max] {
            for status: UInt32 in 0..<4 {
              let pair = UARTReferencePair(registered: registered) {
                uartDMAReferencePrepare($0)
                $0.pointee.tick = .max - 2
                CUART_SetDMAWord($0, channel, CUART_DMAError, error)
                CUART_SetDMAStatus($0, channel, operation == CUART_PauseDMA ? CUART_DMASuspend : CUART_DMAAbort, status)
              }
              pair.run(operation)
            }
          }
        }
      }
    }
  }

  func testResumeBothDirectionsFailuresParityAndMissingHandlesAgainstC() {
    for registered in [false, true] {
      for present: UInt32 in 0..<4 {
        for txStatus: UInt32 in 0..<4 {
          for rxStatus: UInt32 in 0..<4 {
            for parity: UInt32 in [0, 0x400] {
              let pair = UARTReferencePair(registered: registered) {
                uartDMAReferencePrepare($0)
                CUART_SetWord($0, 0, 3, parity)
                CUART_LinkDMA($0, 0, 0, present & 1 != 0 ? 0 : -1)
                CUART_LinkDMA($0, 0, 1, present & 2 != 0 ? 1 : -1)
                CUART_SetDMAStatus($0, 0, CUART_DMAResume, txStatus)
                CUART_SetDMAStatus($0, 1, CUART_DMAResume, rxStatus)
              }
              pair.run(CUART_ResumeDMA)
            }
          }
        }
      }
    }
  }

  func testBlockingAbortMasksFlushesAndAbsentDMAAgainstC() {
    for registered in [false, true] {
      for operation in [CUART_Abort, CUART_AbortTransmit, CUART_AbortReceive] {
        for present: UInt32 in 0..<4 {
          for requests: UInt32 in 0..<4 {
            for fifo in [false, true] {
              for reception: UInt32 in 0..<4 {
                let pair = UARTReferencePair(registered: registered) {
                  uartDMAReferencePrepare($0)
                  CUART_SetWord($0, 0, 26, fifo ? 0x2000_0000 : 0)
                  CUART_SetWord($0, 0, 27, reception)
                  CUART_SetRegister($0, 0, CUART_CR3, 0x1080_0001 | requests << 6)
                  CUART_SetRegister($0, 0, CUART_RQR, 0x4000)
                  CUART_LinkDMA($0, 0, 0, present & 1 != 0 ? 0 : -1)
                  CUART_LinkDMA($0, 0, 1, present & 2 != 0 ? 1 : -1)
                }
                pair.run(operation)
              }
            }
          }
        }
      }
    }
  }

  func testAbortInterruptStatusesBothRequestsAndAbsentHandlesAgainstC() {
    for registered in [false, true] {
      for present: UInt32 in 0..<4 {
        for requests: UInt32 in 0..<4 {
          for txStatus: UInt32 in 0..<4 {
            for rxStatus: UInt32 in 0..<4 {
              let pair = UARTReferencePair(registered: registered) {
                uartDMAReferencePrepare($0)
                CUART_SetRegister($0, 0, CUART_CR3, 0x1080_0001 | requests << 6)
                CUART_LinkDMA($0, 0, 0, present & 1 != 0 ? 0 : -1)
                CUART_LinkDMA($0, 0, 1, present & 2 != 0 ? 1 : -1)
                CUART_SetDMAStatus($0, 0, CUART_DMAAbortInterrupt, txStatus)
                CUART_SetDMAStatus($0, 1, CUART_DMAAbortInterrupt, rxStatus)
              }
              pair.run(CUART_AbortInterrupt)
            }
          }
        }
      }
    }
  }

  func testAbortInterruptCompletionDuringEitherBoundaryAgainstC() {
    for registered in [false, true] {
      for synchronous: UInt32 in 0..<4 {
        for failure: UInt32 in 0..<4 {
          let pair = UARTReferencePair(registered: registered) {
            uartDMAReferencePrepare($0)
            CUART_SetDMAStatus($0, 0, CUART_DMAAbortInterrupt, failure & 1)
            CUART_SetDMAStatus($0, 1, CUART_DMAAbortInterrupt, (failure >> 1) & 1)
            if synchronous & 1 != 0 {
              CUART_SetDMAAction($0, 0, CUART_DMAAbortInterrupt,
                uartDMAReferenceAction(CUART_ActionDMAEvent, target: 0,
                  index: UARTDMACallbackKind.transmitAbort.rawValue))
            }
            if synchronous & 2 != 0 {
              CUART_SetDMAAction($0, 1, CUART_DMAAbortInterrupt,
                uartDMAReferenceAction(CUART_ActionDMAEvent, target: 1,
                  index: UARTDMACallbackKind.receiveAbort.rawValue))
            }
          }
          pair.run(CUART_AbortInterrupt)
        }
      }
    }
  }

  func testSingleDirectionAbortInterruptDirectFallbackAndAsymmetriesAgainstC() {
    for registered in [false, true] {
      for operation in [CUART_AbortTransmitInterrupt, CUART_AbortReceiveInterrupt] {
        for present in [false, true] {
          for request in [false, true] {
            for fifo in [false, true] {
              for status: UInt32 in 0..<4 {
                let pair = UARTReferencePair(registered: registered) {
                  uartDMAReferencePrepare($0)
                  let channel: UInt32 = operation == CUART_AbortTransmitInterrupt ? 0 : 1
                  CUART_LinkDMA($0, 0, channel, present ? Int32(channel) : -1)
                  CUART_SetWord($0, 0, 26, fifo ? 0x2000_0000 : 0)
                  CUART_SetRegister($0, 0, CUART_CR3, request ? (channel == 0 ? 0x80 : 0x40) : 0)
                  CUART_SetDMAStatus($0, channel, CUART_DMAAbortInterrupt, status)
                }
                pair.run(operation)
              }
            }
          }
        }
      }
    }
  }

  func testDMACompletionModesAndReceiveCounterBoundariesAgainstC() {
    for registered in [false, true] {
      for kind in [UARTDMACallbackKind.transmitComplete, .receiveComplete, .receiveHalfComplete] {
        for mode: UInt32 in [0, 0x80, 0x81, 0x181] {
          for size: UInt32 in [0, 1, 9, 0xFFFF] {
            for counter: UInt32 in [0, 1, 8, 9, 10, 0xFFFF] {
              let pair = UARTReferencePair(registered: registered) {
                uartDMAReferencePrepare($0)
                let channel: UInt32 = kind == .transmitComplete ? 0 : 1
                CUART_SetDMAWord($0, channel, CUART_DMAMode, mode)
                CUART_SetDMAWord($0, channel, CUART_DMACounter, counter)
                CUART_SetWord($0, 0, 21, size)
              }
              pair.runDMAEvent(originalChannel: kind == .transmitComplete ? 0 : 1, kind: kind)
            }
          }
        }
      }
    }
  }

  func testEveryDMAHelperStandardAndIdleReceptionAgainstC() {
    for registered in [false, true] {
      for kind in UARTDMACallbackKind.allCases {
        for reception: UInt32 in 0..<4 {
          for pending in [false, true] {
            let pair = UARTReferencePair(registered: registered) {
              uartDMAReferencePrepare($0)
              CUART_SetWord($0, 0, 27, reception)
              CUART_SetDMACallback($0, 0, 3, pending ? 5 : 0)
              CUART_SetDMACallback($0, 1, 3, pending ? 5 : 0)
            }
            pair.runDMAEvent(originalChannel: kind == .transmitComplete || kind == .transmitHalfComplete
              || kind == .transmitAbort || kind == .transmitOnlyAbort ? 0 : 1, kind: kind)
          }
        }
      }
    }
  }

  func testDMAErrorUsesStateSnapshotsAndLeavesRequestsEnabledAgainstC() {
    for registered in [false, true] {
      for txState: UInt32 in [0x20, 0x21, 0x22, 0x24] {
        for rxState: UInt32 in [0x20, 0x21, 0x22, 0x24] {
          for requests: UInt32 in 0..<4 {
            let pair = UARTReferencePair(registered: registered) {
              uartDMAReferencePrepare($0)
              CUART_SetWord($0, 0, 30, txState); CUART_SetWord($0, 0, 31, rxState)
              CUART_SetRegister($0, 0, CUART_CR3, 0x1080_0001 | requests << 6)
            }
            pair.runDMAEvent(originalChannel: 0, kind: .error)
          }
        }
      }
    }
  }

  func testOriginalDMAModeAndLateCounterReadRemainIndependentOfParentAgainstC() {
    for registered in [false, true] {
      for kind in [UARTDMACallbackKind.transmitComplete, .receiveComplete, .receiveHalfComplete] {
        for sourceMode: UInt32 in [0, 0x81] {
          let originalChannel: UInt32 = kind == .transmitComplete ? 0 : 1
          let pair = UARTReferencePair(registered: registered) {
            uartDMAReferencePrepare($0)
            CUART_SetDMAWord($0, originalChannel, CUART_DMAParent, 1)
            CUART_SetDMAWord($0, originalChannel, CUART_DMAMode, sourceMode)
            CUART_SetDMAWord($0, originalChannel + 2, CUART_DMAMode, sourceMode == 0 ? 0x81 : 0)
            CUART_SetDMAWord($0, originalChannel, CUART_DMACounter, 3)
            CUART_SetDMAWord($0, originalChannel + 2, CUART_DMACounter, 15)
            CUART_ScheduleAtomic($0, 1, uartDMAReferenceAction(CUART_ActionDMAWord,
              target: originalChannel, index: CUART_DMACounter.rawValue, value: 5))
          }
          pair.runDMAEvent(originalChannel: originalChannel, kind: kind)
          pair.configureBoth { CUART_SetDMAWord($0, originalChannel, CUART_DMAParent, 0) }
          pair.runDMAEvent(originalChannel: originalChannel, kind: kind)
        }
      }
    }
  }

  func testCompletionErrorAndAbortCallbacksCanReenterDMAStartAgainstC() {
    let callbacks: [(UARTDMACallbackKind, UInt32, UInt32)] = [
      (.transmitComplete, 1, 0), (.receiveComplete, 3, 1),
      (.transmitHalfComplete, 0, 0), (.receiveHalfComplete, 2, 1),
      (.error, 4, 1), (.abortOnError, 4, 1),
      (.transmitAbort, 5, 0), (.receiveAbort, 5, 1),
      (.transmitOnlyAbort, 6, 0), (.receiveOnlyAbort, 7, 1)]
    for registered in [false, true] {
      for item in callbacks {
        let pair = UARTReferencePair(registered: registered) {
          uartDMAReferencePrepare($0)
          CUART_SetWord($0, 0, 27, 0)
          CUART_SetDMACallback($0, 0, 3, 0); CUART_SetDMACallback($0, 1, 3, 0)
          if item.0 == .transmitComplete { CUART_SetDMAWord($0, 0, CUART_DMAMode, 0x81) }
          CUART_SetCallbackAction($0, 0, item.1, 0,
            uartDMAReferenceAction(CUART_ActionCall, index: CUART_ReceiveToIdleDMA.rawValue, a: 23))
        }
        pair.runDMAEvent(originalChannel: item.2, kind: item.0)
      }
    }
  }
}
