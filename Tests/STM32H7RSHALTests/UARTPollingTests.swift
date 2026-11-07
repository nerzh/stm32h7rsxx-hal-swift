import XCTest

@testable import STM32H7RSHAL

final class UARTPollingTests: XCTestCase {
  func testTransmitWrites32BitTDRFromByteAndNineBitElementBuffers() {
    for wide in [false, true] {
      let io = UARTDMAFixture()
      io.configuration[.wordLength] = wide ? 0x1000 : 0
      io.registers[.isr] = 0xC0
      io.pointers[.transmit] = UnsafeMutableRawPointer(bitPattern: 0x1234)
      let status: HALStatus
      if wide {
        status = [UInt16(0x1FF), 0x2AA, 0xFFFF].withUnsafeBufferPointer {
          io.uart.transmit($0, timeout: 0, getTick: io.getTick)
        }
      } else {
        status = [UInt8(0xFF), 0xAA, 0].withUnsafeBufferPointer {
          io.uart.transmit($0, timeout: 0, getTick: io.getTick)
        }
      }
      XCTAssertEqual(status, .ok)
      XCTAssertEqual(
        io.registerWrites,
        wide
          ? [.write(.tdr, 0x1FF), .write(.tdr, 0xAA), .write(.tdr, 0x1FF)]
          : [.write(.tdr, 0xFF), .write(.tdr, 0xAA), .write(.tdr, 0)])
      XCTAssertEqual(io.halves[.transmitSize], 3)
      XCTAssertEqual(io.halves[.transmitCount], 0)
      XCTAssertEqual(io.words[.globalState], 0x20)
      XCTAssertEqual(
        io.pointers[.transmit], UnsafeMutableRawPointer(bitPattern: 0x1234),
        "Polling uses a local cursor")
      XCTAssertEqual(io.tickCalls, 1)
    }
  }

  func testReceiveMaskMatrixPreservesBufferCanariesAndLocalCursor() {
    for wordLength: UInt32 in [0, 0x1000, 0x1000_0000] {
      for parity: UInt32 in [0, 0x400, 0x600] {
        let io = UARTDMAFixture()
        io.configuration[.wordLength] = wordLength
        io.configuration[.parity] = parity
        io.registers[.isr] = 0x20
        io.registers[.rdr] = .max
        io.pointers[.receive] = UnsafeMutableRawPointer(bitPattern: 0x1234)
        let mask: UInt16 =
          wordLength == 0x1000
          ? (parity == 0 ? 0x1FF : 0xFF)
          : wordLength == 0 ? (parity == 0 ? 0xFF : 0x7F) : (parity == 0 ? 0x7F : 0x3F)
        if wordLength == 0x1000 && parity == 0 {
          var data = [UInt16](repeating: 0xAAAA, count: 5)
          data.withUnsafeMutableBufferPointer { buffer in
            let destination = UnsafeMutableBufferPointer(start: buffer.baseAddress! + 1, count: 3)
            XCTAssertEqual(io.uart.receive(destination, timeout: 0, getTick: io.getTick), .ok)
          }
          XCTAssertEqual(data, [0xAAAA, mask, mask, mask, 0xAAAA])
        } else {
          var data = [UInt8](repeating: 0xA5, count: 5)
          data.withUnsafeMutableBufferPointer { buffer in
            let destination = UnsafeMutableBufferPointer(start: buffer.baseAddress! + 1, count: 3)
            XCTAssertEqual(io.uart.receive(destination, timeout: 0, getTick: io.getTick), .ok)
          }
          XCTAssertEqual(data, [0xA5, UInt8(mask), UInt8(mask), UInt8(mask), 0xA5])
        }
        XCTAssertEqual(io.halves[.mask], mask)
        XCTAssertEqual(io.halves[.receiveCount], 0)
        XCTAssertEqual(io.words[.receiveState], 0x20)
        XCTAssertEqual(io.pointers[.receive], UnsafeMutableRawPointer(bitPattern: 0x1234))
        XCTAssertEqual(io.registerEffects.filter { $0 == .read(.rdr) }.count, 3)
      }
    }
    let invalid = UARTDMAFixture()
    invalid.configuration[.wordLength] = 0xDEAD
    invalid.uart.computeMask()
    XCTAssertEqual(invalid.halves[.mask], 0)
  }

  func testNilAndZeroInputsAreCheckedAfterDirectionStateAndDoNotAcquireLock() {
    let io = UARTDMAFixture()
    io.words[.lock] = 1
    XCTAssertEqual(io.uart.transmit(nil, size: 1, timeout: 0, getTick: io.getTick), .error)
    XCTAssertEqual(io.uart.receive(nil, size: 1, timeout: 0, getTick: io.getTick), .error)
    XCTAssertEqual(
      io.uart.transmit(UnsafeRawPointer(bitPattern: 1), size: 0, timeout: 0, getTick: io.getTick),
      .error)
    XCTAssertEqual(
      io.uart.receive(
        UnsafeMutableRawPointer(bitPattern: 1), size: 0, timeout: 0, getTick: io.getTick), .error)
    io.words[.globalState] = 0x21
    io.words[.receiveState] = 0x22
    XCTAssertEqual(io.uart.transmit(nil, size: 0, timeout: 0, getTick: io.getTick), .busy)
    XCTAssertEqual(io.uart.receive(nil, size: 0, timeout: 0, getTick: io.getTick), .busy)
    XCTAssertEqual(io.trace, [])
    XCTAssertEqual(io.words[.lock], 1)
  }

  func testPollingTimeoutUsesOneSharedStartAndWrapsTickArithmetic() {
    let io = UARTDMAFixture()
    io.tick = .max - 1
    io.registers[.isr] = 0x80  // TXE stays ready, TC never arrives.
    [UInt8(1), 2].withUnsafeBufferPointer { data in
      XCTAssertEqual(io.uart.transmit(data, timeout: 2, getTick: io.getTick), .timeout)
    }
    XCTAssertEqual(io.registerWrites, [.write(.tdr, 1), .write(.tdr, 2)])
    XCTAssertEqual(io.halves[.transmitCount], 0)
    XCTAssertEqual(io.words[.globalState], 0x20)
    XCTAssertEqual(io.tickCalls, 4)
    XCTAssertEqual(io.tick, 2)
  }

  func testWaitTimeoutDoesNotRecheckFlagAndZeroTimeoutStillReadsTick() {
    let io = UARTDMAFixture()
    io.onTick = { _ in io.registers[.isr] = 0x80 }
    XCTAssertEqual(
      io.uart.waitOnFlagUntilTimeout(
        flag: 0x80, status: false, tickStart: 0,
        timeout: 0, getTick: io.getTick), .timeout)
    XCTAssertEqual(io.registerEffects, [.read(.isr)])
    XCTAssertEqual(io.tickCalls, 1)
    XCTAssertEqual(io.registers[.isr], 0x80)
  }

  func testInfiniteWaitSkipsTickAndOverrunChecksEntirely() {
    let io = UARTDMAFixture()
    io.registers[.cr1] = 4
    io.scriptedReads[.isr] = [8, 8, 0x28]
    XCTAssertEqual(
      io.uart.waitOnFlagUntilTimeout(
        flag: 0x20, status: false, tickStart: 0,
        timeout: .max, getTick: io.getTick), .ok)
    XCTAssertEqual(io.registerEffects, [.read(.isr), .read(.isr), .read(.isr)])
    XCTAssertEqual(io.tickCalls, 0)
  }

  func testReceiveOverrunAndReceiverTimeoutBecomeOuterTimeoutWithOriginalErrorCode() {
    for (flag, error): (UInt32, UInt32) in [(8, 8), (0x800, 0x20)] {
      let io = UARTDMAFixture()
      io.registers[.cr1] = 4 | 0x120
      io.registers[.cr3] = 1 | 0x1000_0000
      io.registers[.isr] = flag
      io.words[.lock] = 1
      var bytes = [UInt8](repeating: 0xA5, count: 2)
      bytes.withUnsafeMutableBufferPointer {
        XCTAssertEqual(io.uart.receive($0, timeout: 100, getTick: io.getTick), .timeout)
      }
      XCTAssertEqual(bytes, [0xA5, 0xA5])
      XCTAssertEqual(io.words[.receiveState], 0x20)
      XCTAssertEqual(io.words[.errorCode], error)
      XCTAssertEqual(io.words[.lock], 0)
      XCTAssertEqual(io.halves[.receiveCount], 2)
      XCTAssertEqual(io.registerWrites.first, .write(.icr, flag))
      XCTAssertEqual(
        io.registerWrites.suffix(2), [.atomic(.cr1, 0x120, 0), .atomic(.cr3, 0x1000_0001, 0)])
    }
  }

  func testForegroundTransferObservesAbortAfterDataAccessWithoutDecrementingCount() {
    let tx = UARTDMAFixture()
    tx.registers[.isr] = 0xC0
    tx.onRead = { register in if register == .isr { tx.words[.globalState] = 0x20 } }
    [UInt8(0x11), 0x22].withUnsafeBufferPointer {
      XCTAssertEqual(tx.uart.transmit($0, timeout: 0, getTick: tx.getTick), .error)
    }
    XCTAssertEqual(tx.registerWrites, [.write(.tdr, 0x11)])
    XCTAssertEqual(tx.halves[.transmitCount], 2)
    let rx = UARTDMAFixture()
    rx.registers[.isr] = 0x20
    rx.registers[.rdr] = 0x5A
    rx.onRead = { register in if register == .isr { rx.words[.receiveState] = 0x20 } }
    var bytes = [UInt8](repeating: 0xA5, count: 2)
    bytes.withUnsafeMutableBufferPointer {
      XCTAssertEqual(rx.uart.receive($0, timeout: 0, getTick: rx.getTick), .error)
    }
    XCTAssertEqual(bytes, [0x5A, 0xA5])
    XCTAssertEqual(rx.halves[.receiveCount], 2)
  }
}
