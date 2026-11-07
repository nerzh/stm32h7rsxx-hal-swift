import XCTest
import CUARTReference
@testable import STM32H7RSHAL

final class UARTConfigurationDifferentialTests: XCTestCase {
  private func configure(_ state: UnsafeMutablePointer<CUARTState>, instance: UARTInstance = .usart3) {
    CUART_SetInstance(state, 0, instance.rawValue)
    CUART_SetInstance(state, 1, instance == .usart2 ? UARTInstance.usart3.rawValue : UARTInstance.usart2.rawValue)
    CUART_SetRegister(state, 0, CUART_ISR, 0x0060_0000)
    CUART_SetWord(state, 0, 0, 115_200)
    CUART_SetWord(state, 0, 4, 0xC)
  }

  private func allFrequencies(_ state: UnsafeMutablePointer<CUARTState>, _ value: UInt32) {
    withUnsafeMutableBytes(of: &state.pointee.clockFrequencies) {
      for index in 0..<8 { $0.storeBytes(of: value, toByteOffset: index * 4, as: UInt32.self) }
    }
  }

  func testAllInstancesPrescalersAndOversamplingCompareOriginalBaudArithmetic() {
    for instance in UARTInstance.allCases {
      for prescaler in UInt32(0)...11 {
        for over8: UInt32 in instance.isLowPower ? [0] : [0, 0x8000] {
          let pair = UARTReferencePair(registered: false) { state in
            self.configure(state, instance: instance)
            self.allFrequencies(state, 47_999_983)
            CUART_SetWord(state, 0, 0, 9600)
            CUART_SetWord(state, 0, 6, over8)
            CUART_SetWord(state, 0, 8, prescaler)
            CUART_SetWord(state, 0, 26, 0x2000_0000)
            CUART_SetWord(state, 0, 33, 4)
            CUART_SetWord(state, 0, 34, 3)
            for register in [CUART_CR1, CUART_CR2, CUART_CR3, CUART_PRESC] {
              CUART_SetRegister(state, 0, register, .max)
            }
          }
          pair.run(CUART_SetConfiguration)
        }
      }
    }
  }

  func testAllKernelSelectionsZeroAndHSIDividerInputs() {
    for instance in [UARTInstance.usart1, .usart3, .lpuart1] {
      for selection in UInt32(0)...6 {
        for frequency: UInt32 in [0, 48_000_003] {
          for dividerReady: UInt32 in [0, 1] {
            let pair = UARTReferencePair(registered: true) { state in
              self.configure(state, instance: instance)
              self.allFrequencies(state, frequency)
              state.pointee.clockSelections = (selection, selection, selection)
              state.pointee.hsiDividerReady = dividerReady
              state.pointee.hsiDivider = 24
              CUART_SetRegister(state, 0, CUART_BRR, 0xA55A_1234)
            }
            pair.run(CUART_SetConfiguration)
          }
        }
      }
    }
  }

  func testUARTAndLPUARTBaudBoundsAndUnsignedProductWrap() {
    let inputs: [(UInt32, UInt32)] = [
      (15, 1), (16, 1), (65_535, 1), (65_536, 1),
      (2999, 1000), (3000, 1000), (4_095_995, 1000), (4_096_000, 1000),
      (3_145_728, 1_048_576), (UInt32.max, 15_625_000),
      (0x8000_0000, 8_000_000), (48_000_000, 115_200),
    ]
    for instance in [UARTInstance.usart3, .lpuart1] {
      for (frequency, baud) in inputs {
        for over8: UInt32 in instance.isLowPower ? [0] : [0, 0x8000] {
          let pair = UARTReferencePair(registered: false) { state in
            self.configure(state, instance: instance)
            self.allFrequencies(state, frequency)
            CUART_SetWord(state, 0, 0, baud)
            CUART_SetWord(state, 0, 6, over8)
            CUART_SetRegister(state, 0, CUART_BRR, 0x1234_5678)
          }
          pair.run(CUART_SetConfiguration)
        }
      }
    }
  }

  func testInitializationModesStateAndMSPCallbackMutation() {
    let operations: [(CUARTOperation, UInt32, UInt32, UInt32)] = [
      (CUART_Initialize, 0, 0, 0), (CUART_InitializeHalfDuplex, 0, 0, 0),
      (CUART_InitializeLIN, 0x20, 0, 0),
      (CUART_InitializeMultiProcessor, 0xA5, 0x800, 0),
      (CUART_InitializeRS485, 0x8000, 31, 17),
    ]
    for registered in [false, true] {
      for initialState: UInt32 in [0, 0x20, 0x24] {
        for (operation, a, b, c) in operations {
          let pair = UARTReferencePair(registered: registered) { state in
            self.configure(state)
            CUART_SetWord(state, 0, 30, initialState)
            CUART_SetWord(state, 0, 29, 1)
            CUART_SetWord(state, 0, 32, 0xAB)
            for id in UInt32(0)..<14 { CUART_SetCallback(state, 0, id, 3) }
            CUART_SetRegister(state, 0, CUART_CR1, 0xFFFF_FFFF)
            CUART_SetRegister(state, 0, CUART_CR2, 0xFFFF_FFFF)
            CUART_SetRegister(state, 0, CUART_CR3, 0xFFFF_FFFF)
            CUART_SetCallbackAction(state, 0, 11, 0,
              .init(kind: CUART_ActionWord, target: 0, index: 0, value: 9600, args: (0, 0, 0, 0)))
            CUART_SetCallbackAction(state, 0, 11, 1,
              .init(kind: CUART_ActionWord, target: 0, index: 9, value: 1, args: (0, 0, 0, 0)))
            CUART_SetCallbackAction(state, 0, 11, 2,
              .init(kind: CUART_ActionWord, target: 0, index: 10, value: 0x20000, args: (0, 0, 0, 0)))
          }
          pair.run(operation, a: a, b: b, c: c)
        }
      }
    }
  }

  func testAdvancedFeatureMasksAndAutoBaudConditionalMode() {
    for features in UInt32(0)...255 {
      let pair = UARTReferencePair(registered: false) { state in
        self.configure(state)
        let advanced: [UInt32] = [features, 0x20000, 0x10000, 0x40000, 0x8000, 0x1000,
          0x2000, features & 1 == 0 ? 0 : 0x100000, 0x600000, 0x80000]
        for (index, value) in advanced.enumerated() { CUART_SetWord(state, 0, UInt32(9 + index), value) }
        CUART_SetRegister(state, 0, CUART_CR2, 0xFF80_FFFF)
        CUART_SetRegister(state, 0, CUART_CR3, 0xFFFF_FFFF)
      }
      pair.run(CUART_Initialize)
    }
  }

  func testInitializationEarlyErrorsAndIdleTimeoutCleanup() {
    for registered in [false, true] {
      for (wordLength, overSampling): (UInt32, UInt32) in [(0, 0x8000), (0x1000, 0)] {
        let pair = UARTReferencePair(registered: registered) { state in
          self.configure(state)
          CUART_SetWord(state, 0, 30, 0)
          CUART_SetWord(state, 0, 1, wordLength)
          CUART_SetWord(state, 0, 6, overSampling)
          CUART_SetWord(state, 0, 32, 8)
        }
        pair.run(CUART_InitializeLIN, a: 0x20)
      }
      for flags: UInt32 in [0, 0x200000] {
        let pair = UARTReferencePair(registered: registered) { state in
          self.configure(state)
          state.pointee.tick = 0xFFFF_FFF0
          state.pointee.tickStep = 0x0200_0000
          CUART_SetRegister(state, 0, CUART_CR1, 0x1AC)
          CUART_SetRegister(state, 0, CUART_CR3, 1)
          CUART_SetRegister(state, 0, CUART_ISR, flags)
          CUART_SetWord(state, 0, 30, 0x24)
          CUART_SetWord(state, 0, 31, 0x22)
          CUART_SetWord(state, 0, 29, 1)
          CUART_SetWord(state, 0, 32, .max)
        }
        pair.run(CUART_CheckIdleState)
      }
      let failedConfig = UARTReferencePair(registered: registered) { state in
        self.configure(state)
        self.allFrequencies(state, 1)
        CUART_SetWord(state, 0, 30, 0)
      }
      failedConfig.run(CUART_Initialize)
    }
  }

  func testDeinitializationCallbackCanObserveBusyAndMutateConfiguration() {
    for registered in [false, true] {
      for implementation in UInt32(0)...3 {
        let pair = UARTReferencePair(registered: registered) { state in
          self.configure(state)
          CUART_SetCallback(state, 0, 12, implementation)
          CUART_SetWord(state, 0, 19, 42)
          CUART_SetWord(state, 0, 20, 11)
          CUART_SetWord(state, 0, 32, 0x80)
          CUART_SetWord(state, 0, 33, 2)
          CUART_SetWord(state, 0, 34, 1)
          CUART_SetPointer(state, 0, 0, CUART_BufferAddress(0, 0) + 4)
          CUART_SetPointer(state, 0, 1, CUART_BufferAddress(0, 1) + 8)
          CUART_SetCallbackAction(state, 0, 12, 0,
            .init(kind: CUART_ActionWord, target: 0, index: 0, value: 57600, args: (0, 0, 0, 0)))
          for register in [CUART_CR1, CUART_CR2, CUART_CR3, CUART_BRR, CUART_PRESC] {
            CUART_SetRegister(state, 0, register, .max)
          }
        }
        pair.run(CUART_Deinitialize)
      }
    }
  }

  func testControlOperationsLocksStatesAtomicRetryAndQueries() {
    let operations = [CUART_EnableReceiverTimeout, CUART_DisableReceiverTimeout,
      CUART_EnableMuteMode, CUART_DisableMuteMode, CUART_EnableTransmitter,
      CUART_EnableReceiver, CUART_SendBreak, CUART_EnterMuteMode,
      CUART_GetState, CUART_GetError]
    for registered in [false, true] {
      for globalState: UInt32 in [0, 0x20, 0x21, 0x24] {
        for lock: UInt32 in [0, 1] {
          for operation in operations {
            let pair = UARTReferencePair(registered: registered) { state in
              self.configure(state)
              CUART_SetWord(state, 0, 30, globalState)
              CUART_SetWord(state, 0, 31, 0x22)
              CUART_SetWord(state, 0, 32, 0x102)
              CUART_SetWord(state, 0, 29, lock)
              CUART_SetRegister(state, 0, CUART_CR1, 0xF)
              CUART_SetRegister(state, 0, CUART_CR2, 0x800000)
              CUART_SetRegister(state, 0, CUART_RQR, 0x13)
              state.pointee.exclusiveFailures = 2
            }
            pair.run(operation)
          }
        }
      }
    }
    for instance in [UARTInstance.usart3, .lpuart1] {
      let pair = UARTReferencePair(registered: false) { state in
        self.configure(state, instance: instance)
        CUART_SetRegister(state, 0, CUART_RTOR, 0xAA00_0000)
      }
      pair.run(CUART_ConfigureReceiverTimeout, a: 0x12_3456)
      pair.run(CUART_EnableReceiverTimeout)
      pair.run(CUART_DisableReceiverTimeout)
    }
  }
}
