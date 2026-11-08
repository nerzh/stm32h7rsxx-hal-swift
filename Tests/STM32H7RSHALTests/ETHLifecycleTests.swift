import CETHReference
import STM32H7RSHAL
import XCTest

final class ETHLifecycleTests: XCTestCase {
  func testBufferLayoutMatchesC() {
    XCTAssertEqual(MemoryLayout<ETHBuffer>.stride, Int(CETH_Layout(0)))
    XCTAssertEqual(MemoryLayout<ETHBuffer>.offset(of: \.buffer), Int(CETH_Layout(1)))
    XCTAssertEqual(MemoryLayout<ETHBuffer>.offset(of: \.length), Int(CETH_Layout(2)))
    XCTAssertEqual(MemoryLayout<ETHBuffer>.offset(of: \.next), Int(CETH_Layout(3)))
  }
  func testInitializeTimeoutAndBufferAlignmentFailure() {
    for cb: UInt32 in 0...1 {
      for state: UInt32 in [0, 0x10, 0x40] {
        for mode: UInt32 in 0...1 {
          let p = ETHRegisterPair(callbacks: cb, ptp: 1)
          p.word(.state, state)
          p.word(.mediaInterface, mode)
          p.run(0)
          let q = ETHRegisterPair(callbacks: cb, ptp: 1)
          q.word(.state, state)
          q.word(.mediaInterface, mode)
          q.word(.receiveBufferLength, 255)
          for s in [q.c, q.swift.state] { CETH_Event(s, 0, 2, ETHRegister.dmamr.rawValue, 0) }
          q.run(0)
        }
      }
    }
  }
  func testStopAndTransferStateGates() {
    for state: UInt32 in [0, 0x10, 0x20, 0x40, 0xE0] {
      let p = ETHRegisterPair()
      p.word(.state, state)
      p.seed(0xA55A_A55A)
      p.run(6)
      for op: UInt32 in [8, 9, 10] {
        let q = ETHRegisterPair()
        q.word(.state, state)
        q.run(op, 0, 0, 1)
      }
      if state != 0x40 {
        for op: UInt32 in [7, 8, 9, 10] {
          let q = ETHRegisterPair()
          q.word(.state, state)
          q.run(op)
        }
      }
      if state != 0x10 {
        for op: UInt32 in [4, 5] {
          let q = ETHRegisterPair()
          q.word(.state, state)
          q.run(op)
        }
      }
    }
    let p = ETHRegisterPair()
    p.word(.lastReceiveDescriptor, 0xFFFF_FFFF)
    p.run(16)
  }
}
