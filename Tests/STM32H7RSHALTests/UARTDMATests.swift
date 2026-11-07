import XCTest
@testable import STM32H7RSHAL

final class UARTDMATests: XCTestCase {
  private var data: UnsafeMutableRawPointer { UnsafeMutableRawPointer(bitPattern: 0x2400_2000)! }

  func testStartValidationChecksStateBeforePointerAndDoesNotUseUARTLock() {
    for state in [UInt32(0), 0x21, 0x22, 0x23, 0x24, 0xA0, 0xE0, .max] {
      let io = UARTDMAFixture()
      io.words[.globalState] = state; io.words[.receiveState] = state
      XCTAssertEqual(io.uart.transmitDMA(nil, size: 0), .busy)
      XCTAssertEqual(io.uart.receiveDMA(nil, size: 0), .busy)
      XCTAssertEqual(io.uart.receiveToIdleDMA(nil, size: 0), .busy)
      XCTAssertTrue(io.trace.isEmpty)
    }
    for receive in [false, true] {
      for missing in [false, true] {
        let io = UARTDMAFixture()
        let pointer = missing ? nil : data
        let size: UInt16 = missing ? 1 : 0
        XCTAssertEqual(receive ? io.uart.receiveDMA(pointer, size: size)
          : io.uart.transmitDMA(pointer.map(UnsafeRawPointer.init), size: size), .error)
        XCTAssertTrue(io.trace.isEmpty)
      }
    }
    let io = UARTDMAFixture()
    io.words[.lock] = 1
    XCTAssertEqual(io.uart.transmitDMA(data, size: 4), .ok)
    XCTAssertEqual(io.words[.lock], 1)
  }

  func testTransmitNormalExactOrderAndNoDMAHandleBehavior() {
    let io = UARTDMAFixture()
    io.registers[.cr3] = 0x4321_0040
    XCTAssertEqual(io.uart.transmitDMA(data, size: 7), .ok)
    XCTAssertEqual(io.trace, [
      .pointer(.transmit, 0x2400_2000), .half(.transmitSize, 7), .half(.transmitCount, 7),
      .word(.errorCode, 0), .word(.globalState, 0x21),
      .dmaCallbackWrite(.transmit, .transferComplete, .transmitComplete),
      .dmaCallbackWrite(.transmit, .halfTransfer, .transmitHalfComplete),
      .dmaCallbackWrite(.transmit, .error, .error), .dmaCallbackWrite(.transmit, .abort, nil),
      .dmaRead(.transmit, .mode), .operation(.transmit, .start, 0x2400_2000, 0x4000_4428, 7),
      .write(.icr, 0x40), .atomic(.cr3, 0, 0x80)])
    XCTAssertEqual(io.registers[.cr3], 0x4321_00C0)
    let absent = UARTDMAFixture()
    absent.tx.present = false
    XCTAssertEqual(absent.uart.transmitDMA(data, size: 4), .ok)
    XCTAssertTrue(absent.operations.isEmpty)
    XCTAssertEqual(absent.registerWrites, [.write(.icr, 0x40), .atomic(.cr3, 0, 0x80)])
    XCTAssertEqual(absent.words[.globalState], 0x21)
  }

  func testDMAByteCountsKeepUInt16WrappingAndLinkedNodeWriteOrder() {
    for direction in [UARTDMADirection.transmit, .receive] {
      for mode: UInt32 in [0, 0x80, 0x81, 0x180] {
        for size: UInt16 in [1, 0x7FFF, 0x8000, 0xFFFF] {
          let io = UARTDMAFixture()
          io.configuration[.wordLength] = 0x1000
          io.configuration[.parity] = 0
          let channel = io.channel(direction)
          channel.mode = mode; channel.queueAddress = 0x2400_3000
          io.memory[0x2400_3000] = 0x2400_4000
          let status = direction == .transmit ? io.uart.transmitDMA(data, size: size)
            : io.uart.receiveDMA(data, size: size)
          XCTAssertEqual(status, .ok)
          let bytes = UInt32(size &* 2)
          let source: UInt32 = direction == .transmit ? 0x2400_2000 : 0x4000_4424
          let destination: UInt32 = direction == .transmit ? 0x4000_4428 : 0x2400_2000
          if mode & 0x80 != 0 {
            XCTAssertEqual(io.operations, [.operation(direction, .startLinkedList, 0, 0, 0)])
            XCTAssertEqual(io.trace.filter { if case .memoryWrite = $0 { return true }; return false }, [
              .memoryWrite(direction, 0x2400_4008, bytes),
              .memoryWrite(direction, 0x2400_400C, source),
              .memoryWrite(direction, 0x2400_4010, destination)])
            XCTAssertEqual(io.trace.filter { $0 == .memoryRead(direction, 0x2400_3000) }.count, 4)
          } else {
            XCTAssertEqual(io.operations, [.operation(direction, .start, source, destination, bytes)])
          }
        }
      }
    }
  }

  func testStartFailuresRetainBuffersCountsCallbacksAndReceptionType() {
    for direction in [UARTDMADirection.transmit, .receive] {
      for failure in 0..<5 {
        let io = UARTDMAFixture()
        io.halves[.receiveCount] = 19
        let channel = io.channel(direction)
        if failure < 2 {
          channel.mode = 0x80
          channel.queueAddress = failure == 0 ? 0 : 0x2400_3000
        } else {
          channel.statuses[.start] = failure == 2 ? .error : failure == 3 ? .busy : .timeout
        }
        let result = direction == .transmit ? io.uart.transmitDMA(data, size: 8)
          : io.uart.receiveToIdleDMA(data, size: 8)
        XCTAssertEqual(result, .error)
        XCTAssertEqual(io.words[.errorCode], 0x10)
        XCTAssertEqual(io.words[direction == .transmit ? .globalState : .receiveState], 0x20)
        XCTAssertEqual(io.pointers[direction == .transmit ? .transmit : .receive], data)
        XCTAssertEqual(io.halves[direction == .transmit ? .transmitCount : .receiveCount], direction == .transmit ? 8 : 19)
        XCTAssertNotNil(channel.callbacks[.transferComplete])
        XCTAssertNil(channel.callbacks[.abort])
        XCTAssertTrue(io.registerWrites.isEmpty)
        if direction == .receive { XCTAssertEqual(io.words[.receptionType], 1) }
      }
    }
  }

  func testReceiveStartRTOParityAndCountForEveryInstance() {
    for instance in UARTInstance.allCases {
      for parity: UInt32 in [0, 0x400, 0x600] {
        let io = UARTDMAFixture(instance: instance)
        io.configuration[.wordLength] = 0x1000; io.configuration[.parity] = parity
        io.halves[.receiveCount] = 77
        io.registers[.cr2] = 0x0080_0000
        XCTAssertEqual(io.uart.receiveDMA(data, size: 9), .ok)
        XCTAssertEqual(io.halves[.receiveCount], 77)
        XCTAssertEqual(io.words[.receptionType], 0)
        XCTAssertEqual(io.operations, [.operation(.receive, .start, instance.rawValue + 0x24,
          0x2400_2000, parity == 0 ? 18 : 9)])
        var expected: [UARTDMAAccess] = []
        if !instance.isLowPower { expected += [.read(.cr2), .atomic(.cr1, 0, 0x0400_0000)] }
        if parity != 0 { expected += [.atomic(.cr1, 0, 0x100)] }
        expected += [.atomic(.cr3, 0, 1), .atomic(.cr3, 0, 0x40)]
        XCTAssertEqual(io.registerEffects, expected)
      }
    }
    let noDMA = UARTDMAFixture()
    noDMA.rx.present = false
    XCTAssertEqual(noDMA.uart.receiveDMA(data, size: 3), .ok)
    XCTAssertTrue(noDMA.operations.isEmpty)
    XCTAssertEqual(noDMA.registers[.cr3], 0x41)
  }

  func testReceiveToIdleChecksReceptionAfterDMAEnableAndDoesNotEnableRTO() {
    for interrupted in [false, true] {
      let io = UARTDMAFixture()
      io.registers[.cr2] = 0x0080_0000
      io.onAtomic = { register, _, set in
        if interrupted && register == .cr3 && set == 0x40 { io.words[.receptionType] = 0 }
      }
      XCTAssertEqual(io.uart.receiveToIdleDMA(data, size: 16), interrupted ? .error : .ok)
      XCTAssertEqual(io.words[.rxEventType], 0)
      XCTAssertFalse(io.trace.contains(.read(.cr2)))
      XCTAssertEqual(io.registerWrites, interrupted
        ? [.atomic(.cr3, 0, 1), .atomic(.cr3, 0, 0x40)]
        : [.atomic(.cr3, 0, 1), .atomic(.cr3, 0, 0x40), .write(.icr, 0x10), .atomic(.cr1, 0, 0x10)])
    }
  }

  func testPauseUsesStateSnapshotsAndExactTimeoutEquality() {
    let io = UARTDMAFixture()
    io.prepareBusy()
    io.onOperation = { direction, operation in
      if direction == .transmit && operation == .suspend { io.words[.receiveState] = 0x20 }
    }
    XCTAssertEqual(io.uart.pauseDMA(getTick: io.getTick), .ok)
    XCTAssertEqual(io.operations, [.operation(.transmit, .suspend, 0, 0, 0), .operation(.receive, .suspend, 0, 0, 0)])
    XCTAssertEqual(io.registerEffects, [.read(.cr3), .read(.cr3), .atomic(.cr1, 0x100, 0), .atomic(.cr3, 1, 0)])
    XCTAssertEqual(io.registers[.cr3]! & 0xC0, 0xC0)
    for direction in [UARTDMADirection.transmit, .receive] {
      for error: UInt32 in [0, 0x10, 0x11, 0x20] {
        for status in [HALStatus.ok, .error, .busy, .timeout] {
          let io = UARTDMAFixture(); io.prepareBusy()
          io.channel(direction).errorCode = error
          io.channel(direction).statuses[.suspend] = status
          XCTAssertEqual(io.uart.pauseDMA(getTick: io.getTick), status != .ok && error == 0x10 ? .timeout : .ok)
          XCTAssertEqual(io.words[.errorCode], status != .ok && error == 0x10 ? 0x10 : 8)
          XCTAssertNil(io.channel(direction).callbacks[.suspend])
        }
      }
    }
  }

  func testResumeClearsOverrunBeforeEnablingErrorsAndShortCircuitsTXFailure() {
    for parity: UInt32 in [0, 0x400] {
      let io = UARTDMAFixture(); io.prepareBusy(); io.configuration[.parity] = parity
      io.rx.present = false
      XCTAssertEqual(io.uart.resumeDMA(), .ok)
      XCTAssertEqual(io.operations, [.operation(.transmit, .resume, 0, 0, 0)])
      XCTAssertEqual(io.registerWrites, parity == 0
        ? [.write(.icr, 8), .atomic(.cr3, 0, 1)]
        : [.write(.icr, 8), .atomic(.cr1, 0, 0x100), .atomic(.cr3, 0, 1)])
    }
    for direction in [UARTDMADirection.transmit, .receive] {
      let io = UARTDMAFixture(); io.prepareBusy()
      io.channel(direction).statuses[.resume] = .busy
      XCTAssertEqual(io.uart.resumeDMA(), .error)
      XCTAssertEqual(io.words[.errorCode], 0x10)
      XCTAssertEqual(io.operations.count, direction == .transmit ? 1 : 2)
      if direction == .transmit { XCTAssertTrue(io.registerWrites.isEmpty) }
    }
  }

  func testStopClearsRequestsBeforeAbortAndUsesCapturedReceiveState() {
    let io = UARTDMAFixture(); io.prepareBusy()
    io.onOperation = { direction, operation in
      if operation == .abort {
        XCTAssertEqual(io.registers[.cr3]! & (direction == .transmit ? 0x80 : 0x40), 0)
        if direction == .transmit { io.words[.receiveState] = 0x20 }
      }
    }
    XCTAssertEqual(io.uart.stopDMA(getTick: io.getTick), .ok)
    XCTAssertEqual(io.operations.count, 2)
    XCTAssertEqual(io.words[.globalState], 0x20); XCTAssertEqual(io.words[.receiveState], 0x20)
    XCTAssertEqual(io.words[.rxISR], 0); XCTAssertEqual(io.words[.txISR], 4)
    XCTAssertEqual(io.halves[.transmitCount], 9); XCTAssertEqual(io.halves[.receiveCount], 7)
    XCTAssertEqual(io.words[.errorCode], 8)
    XCTAssertEqual(io.registerWrites, [
      .atomic(.cr3, 0x80, 0), .atomic(.cr1, 0xC0, 0), .atomic(.cr3, 0x0080_0000, 0),
      .atomic(.cr3, 0x40, 0), .atomic(.cr1, 0x120, 0), .atomic(.cr3, 0x1000_0001, 0),
      .atomic(.cr1, 0x10, 0)])
  }

  func testBlockingAbortVariantsKeepISRAndCountsAndClearOnlySpecifiedState() {
    for operation in 0..<3 {
      let io = UARTDMAFixture(); io.prepareBusy(); io.registers[.rqr] = 0x4000
      let result = operation == 0 ? io.uart.abort(getTick: io.getTick)
        : operation == 1 ? io.uart.abortTransmit(getTick: io.getTick)
        : io.uart.abortReceive(getTick: io.getTick)
      XCTAssertEqual(result, .ok)
      XCTAssertEqual(io.words[.globalState], operation == 2 ? 0x21 : 0x20)
      XCTAssertEqual(io.words[.receiveState], operation == 1 ? 0x22 : 0x20)
      XCTAssertEqual(io.words[.errorCode], operation == 0 ? 0 : 8)
      XCTAssertEqual(io.words[.rxISR], 3); XCTAssertEqual(io.words[.txISR], 4)
      XCTAssertEqual(io.halves[.transmitCount], 9); XCTAssertEqual(io.halves[.receiveCount], 7)
      XCTAssertEqual(io.registers[.rqr], operation == 0 ? 0x4018 : operation == 1 ? 0x4010 : 0x4008)
      XCTAssertTrue(io.events.isEmpty)
      XCTAssertEqual(io.operations.count, operation == 0 ? 2 : 1)
      XCTAssertNil(io.channel(operation == 2 ? .receive : .transmit).callbacks[.abort])
    }
  }

  func testBlockingAbortAndStopTimeoutsLeavePartiallyAbortedStateExactly() {
    for operation in 0..<4 {
      for error: UInt32 in [0x10, 0x11, 0x20] {
        let io = UARTDMAFixture(); io.prepareBusy()
        let direction: UARTDMADirection = operation == 2 ? .receive : .transmit
        io.channel(direction).statuses[.abort] = .error
        io.channel(direction).errorCode = error
        let result: HALStatus
        switch operation {
        case 0: result = io.uart.abort(getTick: io.getTick)
        case 1: result = io.uart.abortTransmit(getTick: io.getTick)
        case 2: result = io.uart.abortReceive(getTick: io.getTick)
        default: result = io.uart.stopDMA(getTick: io.getTick)
        }
        XCTAssertEqual(result, error == 0x10 ? .timeout : .ok)
        if error == 0x10 {
          XCTAssertEqual(io.words[.errorCode], 0x10)
          XCTAssertEqual(io.words[.globalState], 0x21); XCTAssertEqual(io.words[.receiveState], 0x22)
          XCTAssertFalse(io.trace.contains(.write(.icr, 0xF)))
          XCTAssertEqual(io.registers[.cr3]! & (direction == .transmit ? 0x80 : 0x40), 0)
        }
      }
    }
  }

  func testAbortInterruptInstallsBothCallbacksBeforeEitherAbortAndPreservesFailureQuirk() {
    for txSuccess in [false, true] {
      for rxSuccess in [false, true] {
        let io = UARTDMAFixture(registered: true); io.prepareBusy()
        io.tx.statuses[.abortInterrupt] = txSuccess ? .ok : .error
        io.rx.statuses[.abortInterrupt] = rxSuccess ? .ok : .error
        io.onOperation = { direction, operation in
          if direction == .transmit && operation == .abortInterrupt {
            XCTAssertNotNil(io.tx.callbacks[.abort]); XCTAssertNotNil(io.rx.callbacks[.abort])
          }
        }
        XCTAssertEqual(io.uart.abortInterrupt(), .ok)
        // The RX failure explicitly sets abortcplt=1, even after successful TX.
        XCTAssertEqual(io.events, rxSuccess ? [] : [.callback(.abortComplete)])
        XCTAssertEqual(io.words[.rxISR], rxSuccess ? 3 : 0)
        XCTAssertEqual(io.words[.txISR], rxSuccess ? 4 : 0)
        if txSuccess { XCTAssertNotNil(io.tx.callbacks[.abort]) } else { XCTAssertNil(io.tx.callbacks[.abort]) }
        if rxSuccess { XCTAssertNotNil(io.rx.callbacks[.abort]) } else { XCTAssertNil(io.rx.callbacks[.abort]) }
      }
    }
  }

  func testCombinedAbortCallbacksWaitForOtherDirectionAndFlushOnlyLastDirection() {
    for transmitLast in [false, true] {
      let io = UARTDMAFixture(); io.prepareBusy()
      XCTAssertEqual(io.uart.abortInterrupt(), .ok)
      XCTAssertTrue(io.events.isEmpty)
      let first: UARTDMADirection = transmitLast ? .receive : .transmit
      let last: UARTDMADirection = transmitLast ? .transmit : .receive
      io.trace = []
      io.invokeCallback(first, id: .abort)
      XCTAssertTrue(io.events.isEmpty)
      XCTAssertTrue(io.registerWrites.isEmpty)
      io.invokeCallback(last, id: .abort)
      XCTAssertEqual(io.events, [.callback(.abortComplete)])
      XCTAssertEqual(io.registers[.rqr], transmitLast ? 0x10 : 8)
      XCTAssertEqual(io.words[.rxISR], 3); XCTAssertEqual(io.words[.txISR], 4)
      XCTAssertEqual(io.snapshots.last?.error, 0)
      XCTAssertEqual(io.snapshots.last?.receiveState, 0x20)
    }
  }

  func testImmediateAbortInterruptClearsBothISRsBeforeCallbackAndAllowsRearm() {
    let io = UARTDMAFixture(); io.prepareBusy(); io.tx.present = false; io.rx.present = false
    io.onCallback = { id in
      if id == .abortComplete { XCTAssertEqual(io.uart.receiveDMA(self.data, size: 5), .ok) }
    }
    XCTAssertEqual(io.uart.abortInterrupt(), .ok)
    XCTAssertEqual(io.snapshots.first?.rxISR, 0); XCTAssertEqual(io.snapshots.first?.txISR, 0)
    XCTAssertEqual(io.snapshots.first?.error, 0); XCTAssertEqual(io.snapshots.first?.receiveState, 0x20)
    XCTAssertEqual(io.words[.receiveState], 0x22)
    XCTAssertEqual(io.halves[.receiveSize], 5)
  }

  func testSingleDirectionAbortInterruptNilAndNoRequestBranchesRetainCAsymmetries() {
    for request in [false, true] {
      let tx = UARTDMAFixture(); tx.prepareBusy(); tx.tx.present = false
      tx.registers[.cr3] = request ? 0x80 : 0
      XCTAssertEqual(tx.uart.abortTransmitInterrupt(), .ok)
      XCTAssertEqual(tx.registers[.rqr, default: 0], request ? 0 : 0x10)
      XCTAssertEqual(tx.words[.txISR], 0)
      XCTAssertEqual(tx.events, [.callback(.abortTransmitComplete)])
      let rx = UARTDMAFixture(); rx.prepareBusy(); rx.rx.present = false
      rx.registers[.cr3] = request ? 0x40 : 0
      XCTAssertEqual(rx.uart.abortReceiveInterrupt(), .ok)
      XCTAssertNil(rx.pointers[.receive])
      XCTAssertEqual(rx.words[.rxISR], 3)
      XCTAssertEqual(rx.registers[.rqr, default: 0], request ? 8 : 0)
      XCTAssertEqual(rx.events, [.callback(.abortReceiveComplete)])
      XCTAssertEqual(rx.words[.errorCode], 8)
    }
  }

  func testSingleDirectionAbortFailureCallsInstalledThunkWithoutClearingSlotOrISRs() {
    for direction in [UARTDMADirection.transmit, .receive] {
      for status in [HALStatus.error, .busy, .timeout] {
        let io = UARTDMAFixture(registered: true); io.prepareBusy()
        io.channel(direction).statuses[.abortInterrupt] = status
        XCTAssertEqual(direction == .transmit ? io.uart.abortTransmitInterrupt() : io.uart.abortReceiveInterrupt(), .ok)
        XCTAssertEqual(io.events, [.callback(direction == .transmit ? .abortTransmitComplete : .abortReceiveComplete)])
        XCTAssertNotNil(io.channel(direction).callbacks[.abort])
        XCTAssertEqual(io.trace.filter { $0 == .dmaCallbackRead(direction, .abort) }.count, 1)
        XCTAssertEqual(io.words[.rxISR], 3); XCTAssertEqual(io.words[.txISR], 4)
        XCTAssertNotNil(io.pointers[.receive])
        XCTAssertEqual(io.words[.errorCode], 8)
      }
    }
  }

  func testTransmitCompletionUsesExactCircularValueAndWaitsForUARTTC() {
    for registered in [false, true] {
      for mode: UInt32 in [0, 0x80, 0x81, 0x181] {
        let io = UARTDMAFixture(registered: registered); io.prepareBusy(); io.tx.mode = mode
        io.uart.handleDMAEvent(.transmitComplete, source: io.tx)
        if mode == 0x81 {
          XCTAssertEqual(io.events, [.callback(.transmitComplete)])
          XCTAssertEqual(io.halves[.transmitCount], 9)
          XCTAssertTrue(io.registerWrites.isEmpty)
        } else {
          XCTAssertTrue(io.events.isEmpty)
          XCTAssertEqual(io.halves[.transmitCount], 0)
          XCTAssertEqual(io.registerWrites, [.atomic(.cr3, 0x80, 0), .atomic(.cr1, 0, 0x40)])
        }
        XCTAssertEqual(io.words[.globalState], 0x21)
      }
    }
  }

  func testReceiveCompletionAndHalfEventCounterBoundariesKeepSizeSemantics() {
    for registered in [false, true] {
      for mode: UInt32 in [0, 0x80, 0x81, 0x181] {
        for kind in [UARTDMACallbackKind.receiveComplete, .receiveHalfComplete] {
          for remaining: UInt32 in [0, 4, 9, 10, 0x1_0004] {
            let io = UARTDMAFixture(registered: registered); io.prepareBusy()
            io.halves[.receiveSize] = 9; io.rx.counter = remaining; io.rx.mode = mode
            io.uart.handleDMAEvent(kind, source: io.rx)
            let count = UInt16(truncatingIfNeeded: remaining)
            let complete = kind == .receiveComplete
            let expectedCount: UInt16 = complete ? (count < 9 ? count : 0) : (count <= 9 ? count : 4)
            XCTAssertEqual(io.events, [.rxEvent(9 - expectedCount)])
            XCTAssertEqual(io.halves[.receiveCount], expectedCount)
            XCTAssertEqual(io.words[.receptionType], 1)
            XCTAssertEqual(io.words[.rxEventType], complete ? 0 : 1)
            XCTAssertEqual(io.words[.receiveState], complete && mode != 0x81 ? 0x20 : 0x22)
            XCTAssertEqual(io.words[.rxISR], 3)
            if complete && mode != 0x81 {
              XCTAssertEqual(io.registerWrites, [.atomic(.cr1, 0x100, 0), .atomic(.cr3, 1, 0),
                .atomic(.cr3, 0x40, 0), .atomic(.cr1, 0x10, 0)])
            } else { XCTAssertTrue(io.registerWrites.isEmpty) }
          }
        }
      }
    }
  }

  func testOrdinaryHalfCompleteAndReceiveCompleteDispatchBothCallbackConfigurations() {
    for registered in [false, true] {
      for pair: (UARTDMACallbackKind, UARTCallbackID) in [
        (.transmitHalfComplete, .transmitHalfComplete), (.receiveHalfComplete, .receiveHalfComplete),
        (.receiveComplete, .receiveComplete), (.abortOnError, .error)] {
        let io = UARTDMAFixture(registered: registered); io.prepareBusy(); io.words[.receptionType] = 0
        io.uart.handleDMAEvent(pair.0, source: io.rx)
        XCTAssertEqual(io.events, [.callback(pair.1)])
        XCTAssertFalse(io.trace.contains(.counter(.receive)))
      }
    }
  }

  func testDMAErrorEndsBusyTransfersButLeavesDMARequestsSetBeforeCallback() {
    for txBusy in [false, true] {
      for rxBusy in [false, true] {
        let io = UARTDMAFixture(); io.prepareBusy()
        io.words[.globalState] = txBusy ? 0x21 : 0x20
        io.words[.receiveState] = rxBusy ? 0x22 : 0x20
        io.uart.handleDMAEvent(.error, source: io.tx)
        XCTAssertEqual(io.events, [.callback(.error)])
        XCTAssertEqual(io.snapshots.first?.error, 0x18)
        XCTAssertEqual(io.snapshots.first?.cr3, io.registers[.cr3])
        XCTAssertEqual(io.registers[.cr3]! & 0xC0, 0xC0)
        XCTAssertEqual(io.words[.rxISR], rxBusy ? 0 : 3)
        XCTAssertEqual(io.words[.txISR], 4)
        XCTAssertEqual(io.words[.globalState], 0x20); XCTAssertEqual(io.words[.receiveState], 0x20)
      }
    }
  }

  func testDMAThunkReadsLiveParentAndOriginalSourceModeAndCounter() {
    let original = UARTDMAFixture()
    let redirected = UARTDMAFixture(); redirected.prepareBusy()
    original.rx.mode = 0; redirected.rx.mode = 0x81
    original.rx.counter = 6; redirected.rx.counter = 15
    original.rx.callbacks[.transferComplete] = original.callback(.receiveComplete)
    original.rx.parent = redirected.context
    redirected.onAtomic = { register, clear, _ in
      if register == .cr3 && clear == 0x40 { original.rx.counter = 3 }
    }
    original.invokeCallback(.receive, id: .transferComplete)
    XCTAssertTrue(original.events.isEmpty)
    XCTAssertEqual(redirected.events, [.rxEvent(13)])
    XCTAssertEqual(redirected.words[.receiveState], 0x20)
    XCTAssertEqual(redirected.halves[.receiveCount], 3)
    XCTAssertTrue(original.trace.contains(.dmaRead(.receive, .mode)))
    XCTAssertTrue(original.trace.contains(.counter(.receive)))
    XCTAssertFalse(redirected.trace.contains(.counter(.receive)))
    original.rx.parent = original.context
    original.words[.receptionType] = 0
    original.invokeCallback(.receive, id: .transferComplete)
    XCTAssertEqual(original.events, [.callback(.receiveComplete)])
  }

  func testReceiveCompleteCallbackCanRearmBeforeOriginalHelperReturns() {
    let io = UARTDMAFixture(registered: true); io.prepareBusy(); io.words[.receptionType] = 0
    io.onCallback = { id in
      if id == .receiveComplete { XCTAssertEqual(io.uart.receiveToIdleDMA(self.data, size: 32), .ok) }
    }
    io.uart.handleDMAEvent(.receiveComplete, source: io.rx)
    XCTAssertEqual(io.snapshots.first?.receiveState, 0x20)
    XCTAssertEqual(io.words[.receiveState], 0x22)
    XCTAssertEqual(io.words[.receptionType], 1)
    XCTAssertEqual(io.halves[.receiveSize], 32)
    XCTAssertEqual(io.registers[.cr3]! & 0x41, 0x41)
  }
}
