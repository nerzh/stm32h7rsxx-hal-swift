import XCTest
import CUARTReference
@testable import STM32H7RSHAL

final class UARTCallbackDifferentialTests: XCTestCase {
  func testAllCallbackIDsStatesImplementationsAndLockedRegistration() {
    for stateValue: UInt32 in [0, 0x20, 0x21, 0x22, 0x23, 0x24, 0xA0, 0xE0] {
      for id: UInt32 in Array(0...13) + [UInt32.max] {
        for implementation in UInt32(0)...3 {
          let pair = UARTReferencePair(registered: true) { state in
            CUART_SetWord(state, 0, 30, stateValue)
            CUART_SetWord(state, 0, 31, 0x22)
            CUART_SetWord(state, 0, 29, 1)
            CUART_SetWord(state, 0, 32, 0x8000_0008)
            for callback in UInt32(0)..<14 { CUART_SetCallback(state, 0, callback, 3) }
          }
          pair.run(CUART_RegisterCallback, a: id, b: implementation)
          pair.run(CUART_UnregisterCallback, a: id)
        }
      }
    }
  }

  func testRxEventRegistrationDependsOnlyOnReceiveStateAndRejectsNil() {
    for global: UInt32 in [0, 0x20, 0x21, 0x24] {
      for receive: UInt32 in [0, 0x20, 0x22, 0xA0] {
        for implementation in UInt32(0)...3 {
          let pair = UARTReferencePair(registered: true) { state in
            CUART_SetWord(state, 0, 30, global)
            CUART_SetWord(state, 0, 31, receive)
            CUART_SetWord(state, 0, 29, 1)
            CUART_SetWord(state, 0, 32, 0x8000_0000)
            CUART_SetCallback(state, 0, 13, 3)
          }
          pair.run(CUART_RegisterRxEventCallback, a: implementation)
          pair.run(CUART_UnregisterRxEventCallback)
        }
      }
    }
  }

  func testResetInitializationResetsOnlyTransferCallbacksAndPreservesMSPChoices() {
    for mspInitialize in UInt32(0)...3 {
      for mspDeinitialize in UInt32(0)...3 {
        let pair = UARTReferencePair(registered: true) { state in
          CUART_SetRegister(state, 0, CUART_ISR, 0x600000)
          CUART_SetWord(state, 0, 30, 0)
          CUART_SetWord(state, 0, 31, 0)
          CUART_SetWord(state, 0, 29, 1)
          for id in UInt32(0)..<14 { CUART_SetCallback(state, 0, id, 3) }
          CUART_SetCallback(state, 0, 11, mspInitialize)
          CUART_SetCallback(state, 0, 12, mspDeinitialize)
        }
        pair.run(CUART_Initialize)
        pair.run(CUART_Deinitialize)
      }
    }
  }

  func testMSPCallbackCanRegisterCallbackBeforeInitializationContinues() {
    let pair = UARTReferencePair(registered: true) { state in
      CUART_SetWord(state, 0, 30, 0)
      CUART_SetRegister(state, 0, CUART_ISR, 0x600000)
      CUART_SetCallbackAction(state, 0, 11, 0,
        .init(kind: CUART_ActionCall, target: 0, index: CUART_RegisterCallback.rawValue,
          value: 0, args: (12, 2, 0, 0)))
    }
    pair.run(CUART_Initialize)
    pair.run(CUART_Deinitialize)
  }
}
