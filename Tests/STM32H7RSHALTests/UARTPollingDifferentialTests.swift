import XCTest
import CUARTReference
@testable import STM32H7RSHAL

final class UARTPollingDifferentialTests: XCTestCase {
  private func registerAction(_ register: CUARTRegister, _ value: UInt32) -> CUARTAction {
    .init(kind: CUART_ActionRegister, target: 0, index: register.rawValue, value: value, args: (0, 0, 0, 0))
  }

  func testBlockingTransmitAndReceiveAllWordLengthsParityAndBufferCanaries() {
    for registered in [false, true] {
      for wordLength: UInt32 in [0x1000_0000, 0, 0x1000] {
        for parity: UInt32 in [0, 0x400, 0x600] {
          for size: UInt32 in [1, 2, 7, 19] {
            for operation in [CUART_Transmit, CUART_Receive] {
              let pair = UARTReferencePair(registered: registered) { state in
                CUART_SetWord(state, 0, 1, wordLength)
                CUART_SetWord(state, 0, 3, parity)
                CUART_SetWord(state, 0, 29, 1)
                CUART_SetWord(state, 0, 32, 0xAB)
                CUART_SetPointer(state, 0, 0, CUART_BufferAddress(0, 0) + 200)
                CUART_SetPointer(state, 0, 1, CUART_BufferAddress(0, 1) + 300)
                CUART_SetRegister(state, 0, CUART_ISR, 0xE0)
                CUART_SetRegister(state, 0, CUART_RDR, 0xA55A_01AB)
                for offset in UInt32(0)..<512 {
                  CUART_SetBufferByte(state, 0, 0, offset, UInt8(truncatingIfNeeded: offset &* 71 &+ 0xC3))
                  CUART_SetBufferByte(state, 0, 1, offset, 0xCD)
                }
              }
              pair.run(operation, a: size, b: 100, c: 8)
            }
          }
        }
      }
    }
  }

  func testBusyNilAndZeroOrderingDoesNotTouchBuffersOrTicks() {
    for operation in [CUART_Transmit, CUART_Receive] {
      for stateValue: UInt32 in [0, 0x20, 0x21, 0x22, 0x24, 0xE0] {
        for size: UInt32 in [0, 2] {
          for nullData: UInt32 in [0, 1] {
            let pair = UARTReferencePair(registered: false) { state in
              CUART_SetWord(state, 0, operation == CUART_Transmit ? 30 : 31, stateValue)
              CUART_SetWord(state, 0, 32, 0x1234)
              CUART_SetRegister(state, 0, CUART_ISR, 0xE0)
              CUART_SetRegister(state, 0, CUART_RDR, 0x77)
            }
            pair.run(operation, a: size, b: 2, d: nullData)
          }
        }
      }
    }
  }

  func testPollingTimeoutZeroStrictBoundaryAndTickWrap() {
    for operation in [CUART_Transmit, CUART_Receive] {
      for timeout: UInt32 in [0, 1, 3, 8] {
        for start: UInt32 in [0, UInt32.max - 2] {
          let pair = UARTReferencePair(registered: true) { state in
            state.pointee.tick = start
            CUART_SetRegister(state, 0, CUART_ISR, 0)
            CUART_SetWord(state, 0, 29, 1)
            CUART_SetWord(state, 0, 32, 8)
          }
          pair.run(operation, a: 3, b: timeout)
          XCTAssertEqual(CUART_GetWord(pair.actual, 0, operation == CUART_Transmit ? 20 : 22), 3)
        }
      }
    }
  }

  func testFlagArrivalAtExpiredDeadlineIsNotRechecked() {
    for operation in [CUART_Transmit, CUART_Receive] {
      let pair = UARTReferencePair(registered: false) { state in
        state.pointee.tick = 0xFFFF_FFFF
        CUART_SetRegister(state, 0, CUART_ISR, 0)
        CUART_ScheduleTick(state, 3, self.registerAction(CUART_ISR, 0xE0))
      }
      pair.run(operation, a: 1, b: 1)
      XCTAssertEqual(CUART_GetRegister(pair.actual, 0, CUART_ISR), 0xE0)
      XCTAssertEqual(CUART_GetWord(pair.actual, 0, operation == CUART_Transmit ? 20 : 22), 1)
    }
  }

  func testTransmitCompleteWaitSharesTheOriginalTickStart() {
    for start: UInt32 in [0, UInt32.max - 1] {
      let pair = UARTReferencePair(registered: true) { state in
        state.pointee.tick = start
        CUART_SetRegister(state, 0, CUART_ISR, 0)
        CUART_SetBufferByte(state, 0, 0, 0, 0xA5)
        CUART_ScheduleTick(state, 2, self.registerAction(CUART_ISR, 0x80))
        CUART_ScheduleTick(state, 5, self.registerAction(CUART_ISR, 0xC0))
      }
      pair.run(CUART_Transmit, a: 1, b: 2)
      XCTAssertEqual(CUART_GetRegister(pair.actual, 0, CUART_TDR), 0xA5)
      XCTAssertEqual(CUART_GetWord(pair.actual, 0, 20), 0)
    }
  }

  func testOREAndReceiverTimeoutKeepSourceErrorMappingAndCleanup() {
    for flags: UInt32 in [8, 0x800, 0x808] {
      for receiverEnabled in [false, true] {
        let pair = UARTReferencePair(registered: true) { state in
          CUART_SetRegister(state, 0, CUART_CR1, receiverEnabled ? 0x13C : 0x138)
          CUART_SetRegister(state, 0, CUART_CR3, 0x1000_0001)
          CUART_SetRegister(state, 0, CUART_ISR, flags)
          CUART_SetWord(state, 0, 27, 1)
          CUART_SetWord(state, 0, 29, 1)
          CUART_SetWord(state, 0, 33, 3)
        }
        pair.run(CUART_Receive, a: 4, b: 3)
      }
      for flag: UInt32 in [0x20, 0x80, 0x40, 0x400000] {
        let pair = UARTReferencePair(registered: false) { state in
          CUART_SetRegister(state, 0, CUART_CR1, 0x13C)
          CUART_SetRegister(state, 0, CUART_CR3, 1)
          CUART_SetRegister(state, 0, CUART_ISR, flags)
          CUART_SetWord(state, 0, 31, 0x22)
          CUART_SetWord(state, 0, 32, 0x10)
        }
        pair.run(CUART_WaitOnFlag, a: flag, b: 0, c: 0, d: 3)
      }
    }
  }

  func testAbortDuringFlagWaitIsObservedAfterTheDataAccess() {
    for operation in [CUART_Transmit, CUART_Receive] {
      let pair = UARTReferencePair(registered: false) { state in
        CUART_SetRegister(state, 0, CUART_ISR, 0)
        CUART_SetRegister(state, 0, CUART_RDR, 0xAB)
        CUART_SetBufferByte(state, 0, 0, 0, 0xCD)
        CUART_ScheduleTick(state, 2, self.registerAction(CUART_ISR, 0xE0))
        CUART_ScheduleTick(state, 2,
          .init(kind: CUART_ActionWord, target: 0,
            index: operation == CUART_Transmit ? 30 : 31, value: 0x20, args: (0, 0, 0, 0)))
      }
      pair.run(operation, a: 2, b: 10)
      XCTAssertEqual(CUART_GetWord(pair.actual, 0, operation == CUART_Transmit ? 20 : 22), 2)
      if operation == CUART_Transmit {
        XCTAssertEqual(CUART_GetRegister(pair.actual, 0, CUART_TDR), 0xCD)
      } else {
        XCTAssertEqual(CUART_GetBufferByte(pair.actual, 0, 1, 0), 0xAB)
      }
    }
  }

  func testInfiniteTimeoutSuccessfulTransfersAndAlreadyReadyFlagsDoNotReadTicks() {
    for operation in [CUART_Transmit, CUART_Receive] {
      let pair = UARTReferencePair(registered: true) { state in
        CUART_SetRegister(state, 0, CUART_CR1, 4)
        CUART_SetRegister(state, 0, CUART_ISR, 0x8E8)
        CUART_SetRegister(state, 0, CUART_RDR, 0xA5)
      }
      pair.run(operation, a: 3, b: .max)
      XCTAssertEqual(pair.actual.pointee.tickCalls, 1)
      pair.run(CUART_WaitOnFlag, a: 0x20, b: 0, d: .max)
      XCTAssertEqual(pair.actual.pointee.tickCalls, 1)
    }
  }
}
