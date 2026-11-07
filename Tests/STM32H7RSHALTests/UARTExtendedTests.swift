import XCTest
@testable import STM32H7RSHAL

final class UARTExtendedTests: XCTestCase {
  private func fixture() -> UARTDMAFixture {
    let io = UARTDMAFixture()
    io.words[.globalState] = 0x20
    io.words[.receiveState] = 0x20
    io.configuration[.wordLength] = 0
    io.configuration[.parity] = 0
    return io
  }

  private func withBuffer(_ body: (UnsafeMutableRawPointer) -> Void) {
    let data = UnsafeMutableRawPointer.allocate(byteCount: 64, alignment: 2)
    data.initializeMemory(as: UInt8.self, repeating: 0, count: 64)
    defer { data.deallocate() }
    body(data)
  }

  func testFIFOThresholdsUseSixteenEntryDepthAndPreserveCR1() {
    let expected: [UInt16] = [2, 4, 8, 12, 14, 16]
    for rx in 0..<6 {
      for tx in 0..<6 {
        let io = fixture()
        io.registers[.cr1] = 0x145
        io.registers[.cr3] = UInt32(rx) << 25 | UInt32(tx) << 29 | 0x1234
        XCTAssertEqual(io.uart.enableFIFOMode(), .ok)
        XCTAssertEqual(io.halves[.rxDataToProcess], expected[rx])
        XCTAssertEqual(io.halves[.txDataToProcess], expected[tx])
        XCTAssertEqual(io.registers[.cr1], 0x2000_0145)
        XCTAssertEqual(io.words[.fifoMode], 0x2000_0000)
        XCTAssertEqual(io.words[.globalState], 0x20)
        XCTAssertEqual(io.words[.lock], 0)
        XCTAssertEqual(io.uart.setTransmitFIFOThreshold(UInt32(5 - tx) << 29), .ok)
        XCTAssertEqual(io.uart.setReceiveFIFOThreshold(UInt32(5 - rx) << 25), .ok)
        XCTAssertEqual(io.halves[.rxDataToProcess], expected[5 - rx])
        XCTAssertEqual(io.halves[.txDataToProcess], expected[5 - tx])
        XCTAssertEqual(io.registers[.cr1], 0x2000_0145)
        XCTAssertEqual(io.registers[.cr3]! & 0x1FF_FFFF, 0x1234)
      }
    }
  }

  func testDisableFIFODoesNotRecomputeCountsAndDisabledThresholdSetsOne() {
    let io = fixture()
    io.registers[.cr1] = 0x2000_0041
    io.words[.fifoMode] = 0x2000_0000
    io.halves[.rxDataToProcess] = 14
    io.halves[.txDataToProcess] = 12
    XCTAssertEqual(io.uart.disableFIFOMode(), .ok)
    XCTAssertEqual(io.halves[.rxDataToProcess], 14)
    XCTAssertEqual(io.halves[.txDataToProcess], 12)
    XCTAssertEqual(io.registers[.cr1], 0x41)
    XCTAssertEqual(io.uart.setReceiveFIFOThreshold(0x0A00_0000), .ok)
    XCTAssertEqual(io.halves[.rxDataToProcess], 1)
    XCTAssertEqual(io.halves[.txDataToProcess], 1)
    for raw in UInt32(6)...7 {
      let reserved = fixture()
      reserved.registers[.cr3] = raw << 25 | raw << 29
      XCTAssertEqual(reserved.uart.enableFIFOMode(), .ok)
      XCTAssertEqual(reserved.halves[.rxDataToProcess], 0)
      XCTAssertEqual(reserved.halves[.txDataToProcess], 0)
    }
  }

  func testLockedExtendedOperationsHaveNoRegisterEffects() {
    let io = fixture()
    io.words[.lock] = 1
    XCTAssertEqual(io.uart.enableStopMode(), .busy)
    XCTAssertEqual(io.uart.disableStopMode(), .busy)
    XCTAssertEqual(io.uart.enableFIFOMode(), .busy)
    XCTAssertEqual(io.uart.disableFIFOMode(), .busy)
    XCTAssertEqual(io.uart.setTransmitFIFOThreshold(0), .busy)
    XCTAssertEqual(io.uart.setReceiveFIFOThreshold(0), .busy)
    XCTAssertEqual(io.uart.configureStopModeWakeup(.init(), getTick: io.getTick), .busy)
    XCTAssertTrue(io.registers.isEmpty)
    XCTAssertEqual(io.words[.globalState], 0x20)
    XCTAssertEqual(io.tickCalls, 0)
  }

  func testStopModeAndAddressWakeupConfiguration() {
    for event: UInt32 in [0, 0x0020_0000, 0x0030_0000] {
      let io = fixture()
      io.registers[.cr1] = 0x101
      io.registers[.cr2] = 0x5512_3420
      io.registers[.cr3] = 0xFFFF_FFFF
      io.registers[.isr] = 0x0040_0000
      XCTAssertEqual(io.uart.configureStopModeWakeup(
        .init(event: event, addressLength: 0x10, address: 0xAB), getTick: io.getTick), .ok)
      XCTAssertEqual(io.registers[.cr1], 0x101)
      XCTAssertEqual(io.registers[.cr3], 0xFFCF_FFFF | event)
      XCTAssertEqual(io.registers[.cr2], event == 0 ? 0xAB12_3430 : 0x5512_3420)
      XCTAssertEqual(io.words[.globalState], 0x20)
      XCTAssertEqual(io.words[.lock], 0)
      XCTAssertEqual(io.uart.enableStopMode(), .ok)
      XCTAssertEqual(io.registers[.cr1], 0x103)
      XCTAssertEqual(io.uart.disableStopMode(), .ok)
      XCTAssertEqual(io.registers[.cr1], 0x101)
    }
  }

  func testWakeupMapsWaitOverrunErrorToTimeoutAndUnlocks() {
    let io = fixture()
    io.registers[.cr1] = 5
    io.registers[.isr] = 8
    XCTAssertEqual(io.uart.configureStopModeWakeup(.init(event: 0x0020_0000), getTick: io.getTick), .timeout)
    XCTAssertEqual(io.words[.globalState], 0x24)
    XCTAssertEqual(io.words[.receiveState], 0x20)
    XCTAssertEqual(io.words[.errorCode], 8)
    XCTAssertEqual(io.words[.lock], 0)
    XCTAssertEqual(io.registers[.icr], 8)
  }

  func testSetAddressLengthHasNoLockGuardAndChecksIdleState() {
    let io = fixture()
    io.words[.lock] = 1
    io.configuration[.mode] = 0
    io.registers[.cr1] = 0x81
    io.registers[.cr2] = 0xAB00_0020
    XCTAssertEqual(io.uart.setAddressLength(0x10, getTick: io.getTick), .ok)
    XCTAssertEqual(io.registers[.cr1], 0x81)
    XCTAssertEqual(io.registers[.cr2], 0xAB00_0030)
    XCTAssertEqual(io.words[.globalState], 0x20)
    XCTAssertEqual(io.words[.lock], 0)
  }

  func testReceiveToIdleCompleteMasksDataAndLeavesHandlePointerUntouched() {
    for (wordLength, parity, expected, byteCount): (UInt32, UInt32, UInt16, Int) in [
      (0, 0, 0xFF, 1), (0x1000, 0, 0x1FF, 2), (0x1000, 0x400, 0xFF, 1),
      (0x1000_0000, 0, 0x7F, 1), (0, 0x400, 0x7F, 1), (0x1000_0000, 0x400, 0x3F, 1)
    ] {
      withBuffer { data in
        let io = fixture()
        io.configuration[.wordLength] = wordLength
        io.configuration[.parity] = parity
        io.registers[.isr] = 0x20
        io.registers[.rdr] = 0xFFFF_FFFF
        var received: UInt16 = 99
        XCTAssertEqual(io.uart.receiveToIdle(data, size: 2, receivedCount: &received,
                                           timeout: .max, getTick: io.getTick), .ok)
        XCTAssertEqual(received, 2)
        if byteCount == 2 {
          XCTAssertEqual(data.load(as: UInt16.self), expected)
          XCTAssertEqual(data.advanced(by: 2).load(as: UInt16.self), expected)
        } else {
          XCTAssertEqual(data.load(as: UInt8.self), UInt8(expected))
          XCTAssertEqual(data.advanced(by: 1).load(as: UInt8.self), UInt8(expected))
        }
        XCTAssertNil(io.pointers[.receive])
        XCTAssertEqual(io.halves[.receiveCount], 0)
        XCTAssertEqual(io.words[.receptionType], 1)
        XCTAssertEqual(io.uart.getRxEventType(), 0)
        XCTAssertEqual(io.tickCalls, 1)
      }
    }
  }

  func testReceiveToIdleClearsInitialIdleAndReturnsOnlyAfterData() {
    withBuffer { data in
      let io = fixture()
      io.scriptedReads[.isr] = [0x10, 0x20, 0x10]
      io.registers[.rdr] = 0xA5
      var received: UInt16 = 99
      XCTAssertEqual(io.uart.receiveToIdle(data, size: 4, receivedCount: &received,
                                         timeout: .max, getTick: io.getTick), .ok)
      XCTAssertEqual(received, 1)
      XCTAssertEqual(data.load(as: UInt8.self), 0xA5)
      XCTAssertEqual(io.halves[.receiveCount], 3)
      XCTAssertEqual(io.uart.getRxEventType(), 2)
      XCTAssertEqual(io.words[.receiveState], 0x20)
    }
  }

  func testReceiveToIdleChecksTimeoutEvenAfterLastElement() {
    withBuffer { data in
      for timeout: UInt32 in [0, 1] {
        let io = fixture()
        io.registers[.isr] = 0x20
        io.registers[.rdr] = 0x35
        io.tick = UInt32.max
        io.tickStep = timeout &+ 1
        var received: UInt16 = 0
        XCTAssertEqual(io.uart.receiveToIdle(data, size: 1, receivedCount: &received,
                                           timeout: timeout, getTick: io.getTick), .timeout)
        XCTAssertEqual(received, 1)
        XCTAssertEqual(io.halves[.receiveCount], 0)
        XCTAssertEqual(io.words[.receiveState], 0x20)
        XCTAssertEqual(io.words[.receptionType], 1)
        XCTAssertEqual(io.uart.getRxEventType(), 0)
      }
    }
  }

  func testReceiveToIdleValidatesBusyBeforePointerAndPreservesOutput() {
    let io = fixture()
    var received: UInt16 = 0xCAFE
    XCTAssertEqual(io.uart.receiveToIdle(nil, size: 1, receivedCount: &received,
                                       timeout: 0, getTick: io.getTick), .error)
    io.words[.receiveState] = 0x22
    XCTAssertEqual(io.uart.receiveToIdle(nil, size: 0, receivedCount: &received,
                                       timeout: 0, getTick: io.getTick), .busy)
    XCTAssertEqual(received, 0xCAFE)
    XCTAssertEqual(io.tickCalls, 0)
    io.words[.rxEventType] = 0xFEDC_BA98
    XCTAssertEqual(io.uart.getRxEventType(), 0xFEDC_BA98)
  }

  func testReceiveToIdleInterruptDetectsSynchronousAbortDuringEnable() {
    withBuffer { data in
      let io = fixture()
      io.registers[.cr2] = 0x0080_0000
      io.onAtomic = { register, _, set in
        if register == .cr3 && set == 1 { io.words[.receptionType] = 0 }
      }
      XCTAssertEqual(io.uart.receiveToIdleInterrupt(data, size: 2), .error)
      XCTAssertEqual(io.registers[.cr1, default: 0] & 0x0400_0010, 0)
      XCTAssertNil(io.registers[.icr])
      let normal = fixture()
      normal.registers[.cr2] = 0x0080_0000
      XCTAssertEqual(normal.uart.receiveToIdleInterrupt(data, size: 2), .ok)
      XCTAssertEqual(normal.registers[.icr], 0x10)
      XCTAssertEqual(normal.registers[.cr1, default: 0] & 0x0400_0010, 0x10)
    }
  }

  func testFIFOEnableAndThresholdRestoreExactRegisterOrder() {
    let io = fixture()
    io.registers[.cr1] = 0x41
    io.registers[.cr3] = 0
    XCTAssertEqual(io.uart.enableFIFOMode(), .ok)
    XCTAssertEqual(io.registerEffects, [
      .read(.cr1), .read(.cr1), .write(.cr1, 0x40), .write(.cr1, 0x2000_0041),
      .read(.cr3), .read(.cr3)])
    io.trace = []
    XCTAssertEqual(io.uart.setTransmitFIFOThreshold(0x6000_0000), .ok)
    XCTAssertEqual(io.registerEffects, [
      .read(.cr1), .read(.cr1), .write(.cr1, 0x2000_0040),
      .read(.cr3), .write(.cr3, 0x6000_0000), .read(.cr3), .read(.cr3),
      .write(.cr1, 0x2000_0041)])
  }

  func testWakeupTimeoutKeepsBusyStateAndPeripheralEnabled() {
    let io = fixture()
    io.registers[.cr1] = 0
    io.tick = 0xFFFF_FFFE
    io.tickStep = 0x0200_0000
    XCTAssertEqual(io.uart.configureStopModeWakeup(.init(event: 0x0030_0000), getTick: io.getTick), .timeout)
    XCTAssertEqual(io.words[.globalState], 0x24)
    XCTAssertEqual(io.words[.lock], 0)
    XCTAssertEqual(io.registers[.cr1], 1)
    XCTAssertEqual(io.tickCalls, 2)
  }

}
