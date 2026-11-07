import CUARTReference
import XCTest
@testable import STM32H7RSHAL

final class UARTInterruptDifferentialTests: XCTestCase {
  private func pair(registered: Bool = false,
                    setup: (UnsafeMutablePointer<CUARTState>) -> Void = { _ in }) -> UARTReferencePair {
    UARTReferencePair(registered: registered) { state in
      for uart: UInt32 in 0..<2 {
        for id: UInt32 in 0..<14 { CUART_SetCallback(state, uart, id, 1) }
        for offset: UInt32 in 0..<64 {
          CUART_SetBufferByte(state, uart, 0, offset, UInt8(truncatingIfNeeded: offset &* 37 &+ 0xA5))
        }
      }
      setup(state)
    }
  }

  private func wordAction(_ word: UInt32, _ value: UInt32) -> CUARTAction {
    .init(kind: CUART_ActionWord, target: 0, index: word, value: value, args: (0, 0, 0, 0))
  }
  private func registerAction(_ register: CUARTRegister, _ value: UInt32) -> CUARTAction {
    .init(kind: CUART_ActionRegister, target: 0, index: register.rawValue, value: value, args: (0, 0, 0, 0))
  }
  private func callAction(_ operation: CUARTOperation, size: UInt32, offset: UInt32 = 0) -> CUARTAction {
    .init(kind: CUART_ActionCall, target: 0, index: operation.rawValue, value: 0, args: (size, 0, offset, 0))
  }

  func testInterruptStartAllWidthsParityFIFOAndValidation() {
    for registered in [false, true] {
      for word: UInt32 in [0, 0x1000, 0x1000_0000] {
        for parity: UInt32 in [0, 0x400, 0x600] {
          for fifo: UInt32 in [0, 0x2000_0000] {
            for size: UInt32 in [3, 4] {
              let p = pair(registered: registered) { s in
                CUART_SetWord(s, 0, 1, word)
                CUART_SetWord(s, 0, 3, parity)
                CUART_SetWord(s, 0, 26, fifo)
                CUART_SetWord(s, 0, 24, 4)
                CUART_SetRegister(s, 0, CUART_CR2, 0x0080_0000)
              }
              p.run(CUART_TransmitInterrupt, a: size)
              p.run(CUART_TransmitInterrupt, a: 0, d: 1)
              p.run(CUART_ReceiveInterrupt, a: size)
              p.run(CUART_ReceiveInterrupt, a: 0, d: 1)
            }
          }
        }
      }
      for size: UInt32 in [0, 1] {
        let p = pair(registered: registered)
        p.run(CUART_TransmitInterrupt, a: size, d: 1)
        p.run(CUART_ReceiveInterrupt, a: size, d: 1)
      }
    }
  }

  func testByteAndHalfwordTransmitIRQCompletionAndRearm() {
    for registered in [false, true] {
      for half in [false, true] {
        let p = pair(registered: registered) { s in
          CUART_SetWord(s, 0, 1, half ? 0x1000 : 0)
          CUART_SetCallbackAction(s, 0, 1, 0, self.callAction(CUART_TransmitInterrupt, size: 2, offset: 16))
        }
        p.run(CUART_TransmitInterrupt, a: 2)
        p.configureBoth { CUART_SetRegister($0, 0, CUART_ISR, 0x80) }
        p.run(CUART_HandleInterrupt)
        p.run(CUART_HandleInterrupt)
        p.run(CUART_HandleInterrupt)
        p.configureBoth { CUART_SetRegister($0, 0, CUART_ISR, 0x40) }
        p.run(CUART_HandleInterrupt)
        p.configureBoth { CUART_SetRegister($0, 0, CUART_ISR, 0x80) }
        p.run(CUART_HandleInterrupt)
      }
    }
  }

  func testFIFOTransmitCountsIterationsAndNotOnlySuccessfulWrites() {
    for half in [false, true] {
      for threshold: UInt32 in [0, 1, 3, 16] {
        let p = pair(registered: true) { s in
          CUART_SetWord(s, 0, 1, half ? 0x1000 : 0)
          CUART_SetWord(s, 0, 26, 0x2000_0000)
          CUART_SetWord(s, 0, 25, threshold)
          CUART_SetRegister(s, 0, CUART_ISR, 0x80)
        }
        p.scriptedRegisters = [.isr]
        p.run(CUART_TransmitInterrupt, a: 2)
        p.configureBoth { s in
          for flags: UInt32 in [0x80, 0x80, 0, 0x80] { CUART_AppendRead(s, 0, CUART_ISR, flags) }
        }
        p.run(CUART_HandleInterrupt)
        p.run(CUART_HandleInterrupt)
      }
    }
  }

  func testReceiveIRQWidthsMasksIdleCompletionAndLowPower() {
    let modes: [(UInt32, UInt32)] = [(0, 0), (0, 0x400), (0x1000, 0),
      (0x1000, 0x600), (0x1000_0000, 0), (0x1000_0000, 0x400)]
    for registered in [false, true] {
      for (word, parity) in modes {
        for idle in [false, true] {
          for lowPower in [false, true] {
            let p = pair(registered: registered) { s in
              CUART_SetInstance(s, 0, lowPower ? UARTInstance.lpuart1.rawValue : UARTInstance.usart3.rawValue)
              CUART_SetWord(s, 0, 1, word)
              CUART_SetWord(s, 0, 3, parity)
              CUART_SetRegister(s, 0, CUART_CR2, 0x0080_0000)
              CUART_SetRegister(s, 0, CUART_RDR, 0xFFFF_FFFF)
            }
            p.run(idle ? CUART_ReceiveToIdleInterrupt : CUART_ReceiveInterrupt, a: 2)
            p.configureBoth { CUART_SetRegister($0, 0, CUART_ISR, 0x30) }
            p.run(CUART_HandleInterrupt)
            p.run(CUART_HandleInterrupt)
          }
        }
      }
    }
  }

  func testFIFOReceiveProcessesMoreThanThresholdAndFallsBackWhenEmpty() {
    for registered in [false, true] {
      for half in [false, true] {
        for draining in [false, true] {
          let p = pair(registered: registered) { s in
            CUART_SetWord(s, 0, 1, half ? 0x1000 : 0)
            CUART_SetWord(s, 0, 26, 0x2000_0000)
            CUART_SetWord(s, 0, 24, draining ? 2 : 4)
            CUART_SetRegister(s, 0, CUART_ISR, 0x20)
            CUART_SetRegister(s, 0, CUART_RDR, 0x1A5)
          }
          p.scriptedRegisters = [.isr, .rdr]
          p.run(CUART_ReceiveInterrupt, a: 6)
          if !draining {
            p.configureBoth { s in
              for flags: UInt32 in [0x20, 0x20, 0x20, 0x20, 0] {
                CUART_AppendRead(s, 0, CUART_ISR, flags)
              }
            }
          }
          p.run(CUART_HandleInterrupt)
        }
      }
    }
  }

  func testFIFOErrorsKeepEntryMaskAndInterruptSnapshotsAcrossCallbacks() {
    for registered in [false, true] {
      let p = pair(registered: registered) { s in
        CUART_SetWord(s, 0, 3, 0x400)
        CUART_SetWord(s, 0, 26, 0x2000_0000)
        CUART_SetWord(s, 0, 24, 1)
        CUART_SetCallbackAction(s, 0, 4, 0, self.wordAction(23, 1))
        CUART_SetCallbackAction(s, 0, 4, 1, self.registerAction(CUART_CR1, 0))
        CUART_SetCallbackAction(s, 0, 4, 2, self.registerAction(CUART_CR3, 0))
        CUART_SetCallbackAction(s, 0, 4, 3, self.wordAction(32, 0xBAD))
      }
      p.scriptedRegisters = [.isr, .rdr]
      p.run(CUART_ReceiveInterrupt, a: 2)
      p.configureBoth { s in
        for flags: UInt32 in [0x20, 0x20, 0x27, 7] { CUART_AppendRead(s, 0, CUART_ISR, flags) }
        for data: UInt32 in [0xFF, 0xAA] { CUART_AppendRead(s, 0, CUART_RDR, data) }
      }
      p.run(CUART_HandleInterrupt)
    }
  }

  func testFIFOCompletionRearmChangesPostLoopFallback() {
    for registered in [false, true] {
      let p = pair(registered: registered) { s in
        CUART_SetWord(s, 0, 26, 0x2000_0000)
        CUART_SetWord(s, 0, 24, 1)
        CUART_SetRegister(s, 0, CUART_ISR, 0x20)
        CUART_SetRegister(s, 0, CUART_RDR, 0xA5)
        CUART_SetCallbackAction(s, 0, 3, 0, self.wordAction(24, 4))
        CUART_SetCallbackAction(s, 0, 3, 1, self.callAction(CUART_ReceiveInterrupt, size: 2, offset: 16))
      }
      p.run(CUART_ReceiveInterrupt, a: 1)
      p.run(CUART_HandleInterrupt)
    }
  }

  func testEveryErrorFlagEnableCombinationAndOuterEarlyReturn() {
    let bits: [UInt32] = [1, 2, 4, 8, 0x800]
    for flags in 0..<32 {
      for enables in 0..<32 {
        let p = pair(registered: flags & 1 != 0) { s in
          let rawFlags = bits.enumerated().reduce(UInt32(0)) {
            $0 | (flags & (1 << $1.offset) != 0 ? $1.element : 0)
          }
          let cr1: UInt32 = (enables & 1 != 0 ? 0x100 : 0)
            | (enables & 2 != 0 ? 0x20 : 0) | (enables & 4 != 0 ? 0x0400_0000 : 0)
          let cr3: UInt32 = (enables & 8 != 0 ? 1 : 0) | (enables & 16 != 0 ? 0x1000_0000 : 0)
          CUART_SetRegister(s, 0, CUART_ISR, rawFlags | 0x0080_0000)
          CUART_SetRegister(s, 0, CUART_CR1, cr1 | 0x4000_0000)
          CUART_SetRegister(s, 0, CUART_CR3, cr3)
          CUART_SetWord(s, 0, 31, 0x22)
        }
        p.run(CUART_HandleInterrupt)
      }
    }
  }

  func testErrorCallbackStillRunsAfterReceiveCompletionRearms() {
    for registered in [false, true] {
      let p = pair(registered: registered) { s in
        CUART_SetRegister(s, 0, CUART_RDR, 0xB7)
        CUART_SetCallbackAction(s, 0, 3, 0, self.callAction(CUART_ReceiveInterrupt, size: 2, offset: 16))
        CUART_SetCallbackAction(s, 0, 4, 0, self.wordAction(32, 0xDEAD))
      }
      p.run(CUART_ReceiveInterrupt, a: 1)
      p.configureBoth { CUART_SetRegister($0, 0, CUART_ISR, 0x24) }
      p.run(CUART_HandleInterrupt)
    }
  }

  func testIRQPriorityAndUnexpectedReceiveFlushAcrossSelectors() {
    let cases: [(UInt32, UInt32, UInt32)] = [
      (0x0190_00E0, 0xC000_00E0, 0x0040_0000),
      (0x0190_00C0, 0xC000_00C0, 0x0040_0000),
      (0x0180_00C0, 0xC000_00C0, 0), (0x0180_0040, 0xC000_0040, 0),
      (0x0180_0000, 0xC000_0000, 0), (0x0100_0000, 0x8000_0000, 0)]
    for (flags, cr1, cr3) in cases {
      let p = pair { s in
        CUART_SetRegister(s, 0, CUART_ISR, flags)
        CUART_SetRegister(s, 0, CUART_CR1, cr1)
        CUART_SetRegister(s, 0, CUART_CR3, cr3)
      }
      p.run(CUART_HandleInterrupt)
    }
    for selector: UInt32 in 1...4 {
      let p = pair { s in
        CUART_SetWord(s, 0, 33, selector)
        CUART_SetRegister(s, 0, CUART_ISR, 0x20)
        CUART_SetRegister(s, 0, CUART_CR1, 0x20)
        CUART_SetRegister(s, 0, CUART_RQR, 0x10)
      }
      p.run(CUART_HandleInterrupt)
    }
  }

  func testIdleIRQNormalAndCircularDMAIncludingCounterTruncation() {
    for mode: UInt32 in [0, 0x80, 0x81] {
      for counter: UInt32 in [0, 3, 8, 9, 0x1_0003] {
        for registered in [false, true] {
          let p = pair(registered: registered) { s in
            CUART_SetWord(s, 0, 27, 1)
            CUART_SetWord(s, 0, 31, 0x22)
            CUART_SetWord(s, 0, 21, 8)
            CUART_SetWord(s, 0, 22, 8)
            CUART_SetRegister(s, 0, CUART_ISR, 0x10)
            CUART_SetRegister(s, 0, CUART_CR1, 0x110)
            CUART_SetRegister(s, 0, CUART_CR3, 0x41)
            CUART_LinkDMA(s, 0, 1, 1)
            CUART_SetDMAWord(s, 1, CUART_DMAMode, mode)
            CUART_SetDMAWord(s, 1, CUART_DMACounter, counter)
            CUART_SetDMAStatus(s, 1, CUART_DMAAbort, HALStatus.error.rawValue)
          }
          p.run(CUART_HandleInterrupt)
        }
      }
    }
    for count: UInt32 in [0, 3, 8] {
      let p = pair { s in
        CUART_SetWord(s, 0, 27, 1)
        CUART_SetWord(s, 0, 31, 0x22)
        CUART_SetWord(s, 0, 33, 1)
        CUART_SetWord(s, 0, 21, 8)
        CUART_SetWord(s, 0, 22, count)
        CUART_SetRegister(s, 0, CUART_ISR, 0x10)
        CUART_SetRegister(s, 0, CUART_CR1, 0x130)
        CUART_SetRegister(s, 0, CUART_CR3, 0x1000_0001)
      }
      p.run(CUART_HandleInterrupt)
    }
  }

  func testDMAErrorAbortFallbackAndLiveParentSelection() {
    for registered in [false, true] {
      for present in [false, true] {
        for status in [HALStatus.ok, .error, .busy] {
          for parent: UInt32 in [0, 1] {
            let p = pair(registered: registered) { s in
              CUART_SetWord(s, 0, 27, 1)
              CUART_SetWord(s, 0, 31, 0x22)
              CUART_SetWord(s, 0, 20, 7)
              CUART_SetWord(s, 0, 22, 5)
              CUART_SetRegister(s, 0, CUART_ISR, 4)
              CUART_SetRegister(s, 0, CUART_CR1, 0x110)
              CUART_SetRegister(s, 0, CUART_CR3, 0x41)
              CUART_LinkDMA(s, 0, 1, present ? 1 : -1)
              CUART_SetDMAWord(s, 1, CUART_DMAParent, parent)
              CUART_SetDMAStatus(s, 1, CUART_DMAAbortInterrupt, status.rawValue)
            }
            p.run(CUART_HandleInterrupt)
          }
        }
      }
    }
  }

  func testFIFOReceiveAtFullFixtureCapacityPreservesOnePastEndPointer() {
    for registered in [false, true] {
      for halfWord in [false, true] {
        let p = pair(registered: registered) { state in
          CUART_SetWord(state, 0, 1, halfWord ? 0x1000 : 0)
          CUART_SetWord(state, 0, 26, 0x2000_0000)
          CUART_SetWord(state, 0, 24, 1)
          CUART_SetRegister(state, 0, CUART_ISR, 0x20)
          CUART_SetRegister(state, 0, CUART_RDR, 0x1AB)
        }
        p.run(CUART_ReceiveInterrupt, a: halfWord ? 256 : 512)
        p.run(CUART_HandleInterrupt)
        XCTAssertEqual(CUART_GetPointer(p.actual, 0, 1), CUART_BufferAddress(0, 1) + 512)
        XCTAssertEqual(CUART_GetWord(p.actual, 0, 22), 0)
      }
    }
  }

}
