import XCTest

@testable import STM32H7RSHAL

final class UARTCallbackTests: XCTestCase {
  func testRegistrationMatrixUsesGlobalStateAndPreservesTheLogicalLock() {
    for state: UInt32 in [0, 0x20, 0x21, 0x22, 0x23, 0x24, 0xA0, 0xE0] {
      for id: UInt32 in 0...13 {
        let io = UARTDMAFixture(registered: true)
        io.words[.globalState] = state
        io.words[.lock] = 1
        io.words[.errorCode] = 8
        let valid = id <= 12 && (state == 0x20 || (state == 0 && id >= 11))
        XCTAssertEqual(
          io.uart.registerCallback(id: id, callback: io.defaults.error), valid ? .ok : .error)
        XCTAssertEqual(io.words[.errorCode], valid ? 8 : 0x48)
        XCTAssertEqual(io.words[.lock], 1)
        if valid {
          XCTAssertEqual(
            unsafeBitCast(io.callbackSlots[UARTCallbackID(rawValue: id)!]!, to: UInt.self),
            unsafeBitCast(io.defaults.error, to: UInt.self))
        }
        XCTAssertEqual(io.uart.unregisterCallback(id: id), valid ? .ok : .error)
        if valid {
          let callbackID = UARTCallbackID(rawValue: id)!
          XCTAssertEqual(
            unsafeBitCast(io.callbackSlots[callbackID]!, to: UInt.self),
            unsafeBitCast(io.defaults.callback(callbackID), to: UInt.self))
        }
      }
    }
  }

  func testNilCallbackAndInvalidIdentifierORTheErrorAndKeepSlots() {
    let io = UARTDMAFixture(registered: true)
    io.words[.errorCode] = 0x8000_0000
    let original = unsafeBitCast(io.callbackSlots[.transmitComplete]!, to: UInt.self)
    XCTAssertEqual(io.uart.registerCallback(id: .transmitComplete, callback: nil), .error)
    XCTAssertEqual(io.uart.registerCallback(id: UInt32.max, callback: io.defaults.error), .error)
    XCTAssertEqual(io.uart.unregisterCallback(id: UInt32.max), .error)
    XCTAssertEqual(io.words[.errorCode], 0x8000_0040)
    XCTAssertEqual(unsafeBitCast(io.callbackSlots[.transmitComplete]!, to: UInt.self), original)
  }

  func testRxEventRegistrationUsesReceiveStateIndependently() {
    for global: UInt32 in [0, 0x20, 0x21, 0x24] {
      for receive: UInt32 in [0, 0x20, 0x22] {
        let io = UARTDMAFixture(registered: true)
        io.words[.globalState] = global
        io.words[.receiveState] = receive
        io.words[.lock] = 1
        XCTAssertEqual(
          io.uart.registerRxEventCallback(io.defaults.rxEvent), receive == 0x20 ? .ok : .error)
        XCTAssertEqual(io.uart.unregisterRxEventCallback(), receive == 0x20 ? .ok : .error)
        XCTAssertEqual(io.uart.registerRxEventCallback(nil), .error)
        XCTAssertEqual(io.words[.errorCode, default: 0] & 0x40, 0x40)
        XCTAssertEqual(io.words[.lock], 1)
      }
    }
  }

  func testResetHandleStateClearsOnlyStatesAndRegisteredMSPHooks() {
    for registered in [false, true] {
      let io = UARTDMAFixture(registered: registered)
      io.prepareBusy()
      io.uart.resetHandleState()
      XCTAssertEqual(io.words[.globalState], 0)
      XCTAssertEqual(io.words[.receiveState], 0)
      XCTAssertEqual(io.callbackSlots[.mspInitialize] == nil, registered)
      XCTAssertEqual(io.callbackSlots[.mspDeinitialize] == nil, registered)
      XCTAssertNotNil(io.callbackSlots[.transmitComplete])
      XCTAssertNotNil(io.rxEventCallback)
      XCTAssertEqual(io.words[.errorCode], 8)
      XCTAssertEqual(io.words[.rxISR], 3)
      XCTAssertEqual(io.halves[.receiveCount], 7)
    }
  }
}
