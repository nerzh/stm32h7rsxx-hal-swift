import CUARTReference
import XCTest
@testable import STM32H7RSHAL

final class UARTExtendedDifferentialTests: XCTestCase {
  private func pair(registered: Bool = false,
                    setup: (UnsafeMutablePointer<CUARTState>) -> Void = { _ in }) -> UARTReferencePair {
    UARTReferencePair(registered: registered) { state in
      for uart: UInt32 in 0..<2 {
        for id: UInt32 in 0..<14 { CUART_SetCallback(state, uart, id, 1) }
      }
      setup(state)
    }
  }

  private func registerAction(_ register: CUARTRegister, _ value: UInt32) -> CUARTAction {
    .init(kind: CUART_ActionRegister, target: 0, index: register.rawValue, value: value, args: (0, 0, 0, 0))
  }

  func testAllFIFOThresholdPairsAndEnableDisableCountPersistence() {
    for rx: UInt32 in 0..<6 {
      for tx: UInt32 in 0..<6 {
        let p = pair(registered: tx & 1 != 0) { s in
          CUART_SetRegister(s, 0, CUART_CR1, 0x145)
          CUART_SetRegister(s, 0, CUART_CR3, rx << 25 | tx << 29 | 0x1234)
        }
        p.run(CUART_EnableFIFOMode)
        p.run(CUART_SetTransmitFIFOThreshold, a: (5 - tx) << 29)
        p.run(CUART_SetReceiveFIFOThreshold, a: (5 - rx) << 25)
        p.run(CUART_DisableFIFOMode)
        p.run(CUART_SetReceiveFIFOThreshold, a: rx << 25)
      }
    }
    for raw: UInt32 in 6...7 {
      let p = pair { s in CUART_SetRegister(s, 0, CUART_CR3, raw << 25 | raw << 29) }
      p.run(CUART_EnableFIFOMode)
    }
  }

  func testLockGuardsStopAndFIFOAndAddressLengthIgnoresLockGuard() {
    let operations = [CUART_EnableStopMode, CUART_DisableStopMode, CUART_EnableFIFOMode,
      CUART_DisableFIFOMode, CUART_SetTransmitFIFOThreshold, CUART_SetReceiveFIFOThreshold,
      CUART_ConfigureStopModeWakeup]
    for lock: UInt32 in [0, 1, 2] {
      for operation in operations {
        let p = pair { s in
          CUART_SetWord(s, 0, 29, lock)
          CUART_SetRegister(s, 0, CUART_ISR, 0x0040_0000)
        }
        p.run(operation)
      }
      let p = pair { s in
        CUART_SetWord(s, 0, 29, lock)
        CUART_SetRegister(s, 0, CUART_CR1, 0x81)
        CUART_SetRegister(s, 0, CUART_CR2, 0xAB00_0020)
      }
      p.run(CUART_SetAddressLength, a: 0x10)
      p.run(CUART_SetAddressLength, a: 0)
    }
  }

  func testStopModeWakeupSelectionAddressAndLowPower() {
    for instance in [UARTInstance.usart1, .uart8, .lpuart1] {
      for event: UInt32 in [0, 0x0020_0000, 0x0030_0000] {
        for addressLength: UInt32 in [0, 0x10] {
          for address: UInt32 in [0, 0x7F, 0xFF] {
            let p = pair(registered: true) { s in
              CUART_SetInstance(s, 0, instance.rawValue)
              CUART_SetRegister(s, 0, CUART_CR1, 0x101)
              CUART_SetRegister(s, 0, CUART_CR2, 0x5512_3420)
              CUART_SetRegister(s, 0, CUART_CR3, 0xFFFF_FFFF)
              CUART_SetRegister(s, 0, CUART_ISR, 0x0040_0000)
            }
            p.run(CUART_ConfigureStopModeWakeup, a: event, b: addressLength, c: address)
            p.run(CUART_EnableStopMode)
            p.run(CUART_DisableStopMode)
          }
        }
      }
    }
  }

  func testWakeupREACKTimeoutOverrunAndReceiverTimeoutBranches() {
    for flag: UInt32 in [0, 8, 0x800] {
      for reack in [false, true] {
        let p = pair { s in
          CUART_SetRegister(s, 0, CUART_CR1, 5)
          CUART_SetRegister(s, 0, CUART_ISR, flag)
          s.pointee.tick = 0xFFFF_FFFE
          s.pointee.tickStep = flag == 0 && !reack ? 0x0200_0000 : 1
          if reack {
            CUART_ScheduleTick(s, 1, self.registerAction(CUART_ISR, 0x0040_0000))
          }
        }
        p.run(CUART_ConfigureStopModeWakeup, a: 0x0020_0000)
      }
    }
  }

  func testReceiveToIdleAllWordParityMasksAndCompletion() {
    let modes: [(UInt32, UInt32)] = [(0, 0), (0, 0x400), (0x1000, 0),
      (0x1000, 0x600), (0x1000_0000, 0), (0x1000_0000, 0x400)]
    for (word, parity) in modes {
      for size: UInt32 in [1, 3, 16] {
        for timeout: UInt32 in [100, .max] {
          let p = pair(registered: parity != 0) { s in
            CUART_SetWord(s, 0, 1, word)
            CUART_SetWord(s, 0, 3, parity)
            CUART_SetRegister(s, 0, CUART_ISR, 0x20)
            CUART_SetRegister(s, 0, CUART_RDR, 0xFFFF_FFFF)
            CUART_SetPointer(s, 0, 1, CUART_BufferAddress(0, 1) + 100)
          }
          p.run(CUART_ReceiveToIdle, a: size, b: timeout, c: 4)
          p.run(CUART_GetRxEventType)
        }
      }
    }
  }

  func testReceiveToIdleTickDrivenIdleBeforeAndAfterFirstData() {
    for initialIdle in [false, true] {
      for half in [false, true] {
        let p = pair { s in
          CUART_SetWord(s, 0, 1, half ? 0x1000 : 0)
          CUART_SetRegister(s, 0, CUART_ISR, initialIdle ? 0x10 : 0x20)
          CUART_SetRegister(s, 0, CUART_RDR, 0x1A5)
          if initialIdle {
            CUART_ScheduleTick(s, 2, self.registerAction(CUART_ISR, 0x20))
            CUART_ScheduleTick(s, 3, self.registerAction(CUART_ISR, 0x10))
          } else {
            CUART_ScheduleTick(s, 2, self.registerAction(CUART_ISR, 0x10))
          }
        }
        p.run(CUART_ReceiveToIdle, a: 4, b: 100)
        p.run(CUART_GetRxEventType)
      }
    }
  }

  func testReceiveToIdleTimeoutZeroStrictBoundaryWrapAndLastByte() {
    for flags: UInt32 in [0, 0x20] {
      for timeout: UInt32 in [0, 1, 3] {
        for step: UInt32 in [1, timeout + 1] {
          let p = pair { s in
            CUART_SetRegister(s, 0, CUART_ISR, flags)
            CUART_SetRegister(s, 0, CUART_RDR, 0xA7)
            s.pointee.tick = 0xFFFF_FFFE
            s.pointee.tickStep = step
          }
          p.run(CUART_ReceiveToIdle, a: 1, b: timeout)
        }
      }
    }
  }

  func testReceiveToIdleValidatesStateNullAndZeroBeforeAnyBufferAccess() {
    for state: UInt32 in [0, 0x20, 0x22, 0xFF] {
      for size: UInt32 in [0, 1] {
        for nilData: UInt32 in [0, 1] {
          let p = pair { s in
            CUART_SetWord(s, 0, 31, state)
            CUART_SetRegister(s, 0, CUART_ISR, 0x20)
            CUART_SetRegister(s, 0, CUART_RDR, 0x7D)
          }
          p.run(CUART_ReceiveToIdle, a: size, b: 0, d: nilData)
        }
      }
    }
    let p = pair { CUART_SetWord($0, 0, 28, 0xFEDC_BA98) }
    p.run(CUART_GetRxEventType)
  }

  func testReceiveToIdleInterruptSynchronousAbortWhileEnablingErrorIRQ() {
    for registered in [false, true] {
      for abort in [false, true] {
        let p = pair(registered: registered) { s in
          CUART_SetRegister(s, 0, CUART_CR2, 0x0080_0000)
          if abort {
            let action = CUARTAction(kind: CUART_ActionCall, target: 0,
              index: CUART_AbortReceiveInterrupt.rawValue, value: 0, args: (0, 0, 0, 0))
            CUART_ScheduleAtomic(s, 1, action)
          }
        }
        p.run(CUART_ReceiveToIdleInterrupt, a: 3)
      }
    }
  }
}
