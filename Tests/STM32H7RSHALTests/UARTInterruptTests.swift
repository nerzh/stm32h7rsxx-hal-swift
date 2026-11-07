import XCTest
@testable import STM32H7RSHAL

final class UARTInterruptTests: XCTestCase {
  private func withBuffer(_ body: (UnsafeMutableRawPointer) -> Void) {
    let data = UnsafeMutableRawPointer.allocate(byteCount: 64, alignment: 2)
    data.initializeMemory(as: UInt8.self, repeating: 0, count: 64)
    defer { data.deallocate() }
    body(data)
  }

  func testTransmitStartChoosesWidthAndFIFOAndValidatesStateFirst() {
    withBuffer { data in
      for fifo in [false, true] {
        for word: UInt32 in [0, 0x1000, 0x1000_0000] {
          for parity: UInt32 in [0, 0x400, 0x600] {
            let io = UARTDMAFixture()
            io.configuration[.wordLength] = word
            io.configuration[.parity] = parity
            io.words[.fifoMode] = fifo ? 0x2000_0000 : 0
            XCTAssertEqual(io.uart.transmitInterrupt(data, size: 3), .ok)
            let half = word == 0x1000 && parity == 0
            XCTAssertEqual(io.words[.txISR], fifo ? (half ? 4 : 3) : (half ? 2 : 1))
            XCTAssertEqual(io.words[.globalState], 0x21)
            XCTAssertEqual(io.halves[.transmitSize], 3)
            XCTAssertEqual(io.halves[.transmitCount], 3)
            XCTAssertEqual(io.pointers[.transmit], data)
            XCTAssertEqual(io.registerWrites, [fifo ? .atomic(.cr3, 0, 0x0080_0000) : .atomic(.cr1, 0, 0x80)])
            XCTAssertEqual(io.uart.transmitInterrupt(nil, size: 0), .busy)
          }
        }
      }
      let io = UARTDMAFixture()
      XCTAssertEqual(io.uart.transmitInterrupt(nil, size: 3), .error)
      XCTAssertEqual(io.uart.transmitInterrupt(data, size: 0), .error)
      XCTAssertTrue(io.trace.isEmpty)
    }
  }

  func testTransmitDataIs32BitRegisterWriteAndCompletionCanRearm() {
    withBuffer { data in
      for half in [false, true] {
        for registered in [false, true] {
          let io = UARTDMAFixture(registered: registered)
          io.configuration[.wordLength] = half ? 0x1000 : 0
          data.storeBytes(of: UInt16(0xFFA5), as: UInt16.self)
          XCTAssertEqual(io.uart.transmitInterrupt(data, size: 1), .ok)
          io.trace = []
          io.uart.invokeTransmitISR()
          XCTAssertEqual(io.registerWrites, [.write(.tdr, half ? 0x1A5 : 0xA5)])
          XCTAssertEqual(io.pointers[.transmit], data.advanced(by: half ? 2 : 1))
          XCTAssertEqual(io.halves[.transmitCount], 0)
          io.trace = []
          io.uart.invokeTransmitISR()
          XCTAssertEqual(io.registerWrites, [.atomic(.cr1, 0x80, 0), .atomic(.cr1, 0, 0x40)])
          io.onCallback = { id in
            if id == .transmitComplete {
              XCTAssertEqual(io.words[.globalState], 0x20)
              XCTAssertEqual(io.words[.txISR], 0)
              XCTAssertEqual(io.uart.transmitInterrupt(data, size: 2), .ok)
            }
          }
          io.registers[.isr] = 0x40
          io.uart.handleInterrupt(getTick: io.getTick)
          XCTAssertEqual(io.events, [.callback(.transmitComplete)])
          XCTAssertEqual(io.snapshots.last?.globalState, 0x20)
          XCTAssertEqual(io.snapshots.last?.txISR, 0)
          XCTAssertEqual(io.words[.globalState], 0x21)
          XCTAssertEqual(io.halves[.transmitCount], 2)
        }
      }
    }
  }

  func testFIFOTransmitCountsAttemptsAndSwitchesToCompleteOnNextIteration() {
    withBuffer { data in
      data.storeBytes(of: UInt16(0xFFFF), as: UInt16.self)
      data.advanced(by: 2).storeBytes(of: UInt16(0x1357), as: UInt16.self)
      let io = UARTDMAFixture()
      io.configuration[.wordLength] = 0x1000
      io.words[.fifoMode] = 0x2000_0000
      io.halves[.txDataToProcess] = 3
      XCTAssertEqual(io.uart.transmitInterrupt(data, size: 2), .ok)
      io.scriptedReads[.isr] = [0x80, 0, 0x80]
      io.trace = []
      io.uart.invokeTransmitISR()
      XCTAssertEqual(io.registerWrites, [.write(.tdr, 0x1FF), .write(.tdr, 0x157)])
      XCTAssertEqual(io.halves[.transmitCount], 0)
      XCTAssertEqual(io.registers[.cr3, default: 0] & 0x0080_0000, 0x0080_0000)
      io.trace = []
      io.uart.invokeTransmitISR()
      XCTAssertEqual(io.registerEffects, [.atomic(.cr3, 0x0080_0000, 0), .atomic(.cr1, 0, 0x40)])
      io.words[.globalState] = 0x20
      io.trace = []
      io.uart.invokeTransmitISR()
      XCTAssertTrue(io.trace.isEmpty)
    }
  }

  func testReceiveStartSelectsMaskWidthThresholdAndLowPowerTimeoutBehavior() {
    withBuffer { data in
      let cases: [(UInt32, UInt32, UInt16, Bool)] = [
        (0, 0, 0xFF, false), (0, 0x400, 0x7F, false),
        (0x1000, 0, 0x1FF, true), (0x1000, 0x600, 0xFF, false),
        (0x1000_0000, 0, 0x7F, false), (0x1000_0000, 0x400, 0x3F, false)
      ]
      for (word, parity, mask, half) in cases {
        for fifo in [false, true] {
          for size: UInt16 in [3, 4] {
            for instance in [UARTInstance.usart1, .lpuart1] {
              let io = UARTDMAFixture(instance: instance)
              io.configuration[.wordLength] = word
              io.configuration[.parity] = parity
              io.words[.fifoMode] = fifo ? 0x2000_0000 : 0
              io.halves[.rxDataToProcess] = 4
              io.registers[.cr2] = 0x0080_0000
              XCTAssertEqual(io.uart.receiveInterrupt(data, size: size), .ok)
              let selectedFIFO = fifo && size >= 4
              XCTAssertEqual(io.words[.rxISR], selectedFIFO ? (half ? 4 : 3) : (half ? 2 : 1))
              XCTAssertEqual(io.halves[.mask], mask)
              XCTAssertEqual(io.words[.receptionType], 0)
              XCTAssertEqual(io.words[.receiveState], 0x22)
              XCTAssertEqual(io.registers[.cr1, default: 0] & 0x0400_0000,
                             instance == .lpuart1 ? 0 : 0x0400_0000)
              XCTAssertEqual(io.registers[.cr1, default: 0] & 0x100, parity == 0 ? 0 : 0x100)
              XCTAssertEqual(io.registers[.cr3, default: 0] & 0x1000_0001, selectedFIFO ? 0x1000_0001 : 1)
            }
          }
        }
      }
    }
  }

  func testReceiveCompleteMasksDataAndClearsInterruptsBeforeCallback() {
    withBuffer { data in
      for half in [false, true] {
        for idle in [false, true] {
          let io = UARTDMAFixture(registered: true)
          io.configuration[.wordLength] = half ? 0x1000 : 0
          io.registers[.cr2] = 0x0080_0000
          if idle { XCTAssertEqual(io.uart.receiveToIdleInterrupt(data, size: 1), .ok) }
          else { XCTAssertEqual(io.uart.receiveInterrupt(data, size: 1), .ok) }
          io.registers[.isr] = 0x10
          io.registers[.rdr] = 0xFFFF
          io.trace = []
          io.uart.invokeReceiveISR()
          XCTAssertEqual(data.load(as: UInt8.self), 0xFF)
          if half { XCTAssertEqual(data.load(as: UInt16.self), 0x1FF) }
          XCTAssertEqual(io.words[.receiveState], 0x20)
          XCTAssertEqual(io.words[.rxISR], 0)
          XCTAssertEqual(io.halves[.receiveCount], 0)
          XCTAssertEqual(io.pointers[.receive], data.advanced(by: half ? 2 : 1))
          var writes: [UARTDMAAccess] = [.atomic(.cr1, 0x120, 0), .atomic(.cr3, 1, 0), .atomic(.cr1, 0x0400_0000, 0)]
          if idle { writes += [.atomic(.cr1, 0x10, 0), .write(.icr, 0x10)] }
          XCTAssertEqual(io.registerWrites, writes)
          XCTAssertEqual(io.events, idle ? [.rxEvent(1)] : [.callback(.receiveComplete)])
          XCTAssertEqual(io.snapshots.last?.receiveState, 0x20)
          XCTAssertEqual(io.snapshots.last?.rxISR, 0)
          XCTAssertEqual(io.snapshots.last?.eventType, 0)
          XCTAssertEqual(io.snapshots.last?.receptionType, 0)
        }
      }
    }
  }

  func testUnexpectedReceiveInterruptFlushesDataAndFIFOStillReadsSnapshots() {
    for selector: UInt32 in [1, 2, 3, 4] {
      let io = UARTDMAFixture()
      io.words[.rxISR] = selector
      io.registers[.rqr] = 0x10
      io.uart.invokeReceiveISR()
      let prefix: [UARTDMAAccess] = selector >= 3 ? [.read(.isr), .read(.cr1), .read(.cr3)] : []
      XCTAssertEqual(io.registerEffects, prefix + [.read(.rqr), .write(.rqr, 0x18)])
      XCTAssertTrue(io.events.isEmpty)
    }
  }

  func testFIFOReceiveDoesNotBoundReadCountByThreshold() {
    withBuffer { data in
      for half in [false, true] {
        let io = UARTDMAFixture()
        io.configuration[.wordLength] = half ? 0x1000 : 0
        io.words[.fifoMode] = 0x2000_0000
        io.halves[.rxDataToProcess] = 2
        XCTAssertEqual(io.uart.receiveInterrupt(data, size: 6), .ok)
        io.scriptedReads[.isr] = Array(repeating: 0x20, count: 7)
        io.scriptedReads[.rdr] = [0x101, 0x102, 0x103, 0x104, 0x105, 0x106]
        io.trace = []
        io.uart.invokeReceiveISR()
        XCTAssertEqual(io.registerEffects.filter { $0 == .read(.rdr) }.count, 6)
        XCTAssertEqual(io.halves[.receiveCount], 0)
        XCTAssertEqual(io.events, [.callback(.receiveComplete)])
        for index in 0..<6 {
          if half { XCTAssertEqual(data.advanced(by: index * 2).load(as: UInt16.self), UInt16(0x101 + index)) }
          else { XCTAssertEqual(data.advanced(by: index).load(as: UInt8.self), UInt8(1 + index)) }
        }
      }
    }
  }

  func testFIFOReceiveErrorUsesCapturedMaskAndInterruptSources() {
    withBuffer { data in
      let io = UARTDMAFixture()
      io.words[.receiveState] = 0x22
      io.words[.rxISR] = 3
      io.halves[.mask] = 0x7F
      io.halves[.receiveSize] = 2
      io.halves[.receiveCount] = 2
      io.halves[.rxDataToProcess] = 1
      io.pointers[.receive] = data
      io.registers[.cr1] = 0x100
      io.registers[.cr3] = 1
      io.scriptedReads[.isr] = [0x20, 0x27, 7]
      io.scriptedReads[.rdr] = [0xFF, 0xAA]
      io.onCallback = { id in
        if id == .error {
          io.halves[.mask] = 1
          io.registers[.cr1] = 0
          io.registers[.cr3] = 0
          io.words[.errorCode] = 0xBAD
        }
      }
      io.uart.invokeReceiveISR()
      XCTAssertEqual(data.load(as: UInt8.self), 0x7F)
      XCTAssertEqual(data.advanced(by: 1).load(as: UInt8.self), 0x2A)
      XCTAssertEqual(io.events, [.callback(.error), .callback(.error), .callback(.receiveComplete)])
      XCTAssertEqual(io.snapshots.filter { $0.callback == .error }.map(\.error), [7, 7])
      XCTAssertEqual(io.words[.errorCode], 0)
      XCTAssertEqual(io.registerWrites.filter { if case .write(.icr, _) = $0 { return true }; return false },
                     [.write(.icr, 1), .write(.icr, 2), .write(.icr, 4), .write(.icr, 1), .write(.icr, 2), .write(.icr, 4)])
    }
  }

  func testFIFOReceiveSwitchesToSingleFrameAfterFIFOEmpties() {
    withBuffer { data in
      for half in [false, true] {
        let io = UARTDMAFixture()
        io.configuration[.wordLength] = half ? 0x1000 : 0
        io.words[.fifoMode] = 0x2000_0000
        io.halves[.rxDataToProcess] = 4
        XCTAssertEqual(io.uart.receiveInterrupt(data, size: 6), .ok)
        io.scriptedReads[.isr] = [0x20, 0x20, 0x20, 0]
        io.registers[.rdr] = 0x5A
        io.trace = []
        io.uart.invokeReceiveISR()
        XCTAssertEqual(io.halves[.receiveCount], 3)
        XCTAssertEqual(io.words[.rxISR], half ? 2 : 1)
        XCTAssertEqual(io.registerWrites, [.atomic(.cr3, 0x1000_0000, 0), .atomic(.cr1, 0, 0x20)])
      }
    }
  }

  func testFIFOCompletionRearmIsObservedByPostLoopFallback() {
    withBuffer { data in
      let io = UARTDMAFixture()
      io.words[.fifoMode] = 0x2000_0000
      io.halves[.rxDataToProcess] = 1
      XCTAssertEqual(io.uart.receiveInterrupt(data, size: 1), .ok)
      io.scriptedReads[.isr] = [0x20, 0]
      io.onCallback = { id in
        if id == .receiveComplete {
          io.halves[.rxDataToProcess] = 4
          XCTAssertEqual(io.uart.receiveInterrupt(data.advanced(by: 4), size: 2), .ok)
        }
      }
      io.trace = []
      io.uart.invokeReceiveISR()
      XCTAssertEqual(io.words[.receiveState], 0x22)
      XCTAssertEqual(io.halves[.receiveCount], 2)
      XCTAssertEqual(Array(io.registerWrites.suffix(2)), [.atomic(.cr3, 0x1000_0000, 0), .atomic(.cr1, 0, 0x20)])
    }
  }

  func testIRQErrorFlagsAndEnablesExhaustivelyPreserveCMapping() {
    let flagBits: [UInt32] = [1, 2, 4, 8, 0x800]
    for flags in 0..<32 {
      for enabled in 0..<32 {
        let io = UARTDMAFixture()
        io.words[.receiveState] = 0x22
        let isr = flagBits.enumerated().reduce(UInt32(0)) { $0 | (flags & (1 << $1.offset) == 0 ? 0 : $1.element) }
        let cr1: UInt32 = (enabled & 1 != 0 ? 0x100 : 0) | (enabled & 2 != 0 ? 0x20 : 0) | (enabled & 4 != 0 ? 0x0400_0000 : 0)
        let cr3: UInt32 = (enabled & 8 != 0 ? 1 : 0) | (enabled & 16 != 0 ? 0x1000_0000 : 0)
        io.registers[.isr] = isr | 0x0080_0000
        io.registers[.cr1] = cr1 | 0x4000_0000
        io.registers[.cr3] = cr3
        var expected: UInt32 = 0
        var clears: [UARTDMAAccess] = []
        for (flag, error, active) in [
          (UInt32(1), UInt32(1), cr1 & 0x100 != 0), (2, 4, cr3 & 1 != 0),
          (4, 2, cr3 & 1 != 0), (8, 8, cr1 & 0x20 != 0 || cr3 & 0x1000_0001 != 0),
          (0x800, 0x20, cr1 & 0x0400_0000 != 0)
        ] {
          if isr & flag != 0 && active { expected |= error; clears.append(.write(.icr, flag)) }
        }
        io.uart.handleInterrupt(getTick: io.getTick)
        XCTAssertEqual(io.registerWrites.filter { if case .write(.icr, _) = $0 { return true }; return false }, clears)
        let takesErrorBranch = flags != 0 && enabled != 0
        XCTAssertEqual(io.events, expected != 0 ? [.callback(.error)] : (takesErrorBranch ? [] : [.callback(.transmitFIFOEmpty)]))
        let blocking = expected & 0x28 != 0
        XCTAssertEqual(io.words[.errorCode, default: 0], blocking ? expected : 0)
        XCTAssertEqual(io.words[.receiveState], blocking ? 0x20 : 0x22)
        if expected != 0 { XCTAssertEqual(io.snapshots.last?.error, expected) }
      }
    }
  }

  func testIRQPriorityUsesEntrySnapshotAndOneBranch() {
    let cases: [(UInt32, UInt32, UInt32, [UARTDMAAccess])] = [
      (0x0190_00E0, 0xC000_00E0, 0x0040_0000, []),
      (0x0190_00C0, 0xC000_00C0, 0x0040_0000, [.callback(.wakeup)]),
      (0x0180_00C0, 0xC000_00C0, 0, []),
      (0x0180_0040, 0xC000_0040, 0, [.callback(.transmitComplete)]),
      (0x0180_0000, 0xC000_0000, 0, [.callback(.transmitFIFOEmpty)]),
      (0x0100_0000, 0x8000_0000, 0, [.callback(.receiveFIFOFull)])
    ]
    for (flags, cr1, cr3, events) in cases {
      let io = UARTDMAFixture()
      io.registers[.isr] = flags
      io.registers[.cr1] = cr1
      io.registers[.cr3] = cr3
      io.uart.handleInterrupt(getTick: io.getTick)
      XCTAssertEqual(io.events, events)
      XCTAssertEqual(Array(io.registerEffects.prefix(3)), [.read(.isr), .read(.cr1), .read(.cr3)])
    }
  }

  func testIDLENonDMAReportsOnlyPartialReceptionAndClearsBeforeCallback() {
    for count: UInt16 in [0, 3, 8] {
      let io = UARTDMAFixture()
      io.words[.receptionType] = 1
      io.words[.receiveState] = 0x22
      io.words[.rxISR] = 1
      io.halves[.receiveSize] = 8
      io.halves[.receiveCount] = count
      io.registers[.isr] = 0x10
      io.registers[.cr1] = 0x130
      io.registers[.cr3] = 0x1000_0001
      io.uart.handleInterrupt(getTick: io.getTick)
      if count == 3 {
        XCTAssertEqual(io.events, [.rxEvent(5)])
        XCTAssertEqual(io.registerWrites, [.write(.icr, 0x10), .atomic(.cr1, 0x120, 0),
          .atomic(.cr3, 0x1000_0001, 0), .atomic(.cr1, 0x10, 0)])
        XCTAssertEqual(io.snapshots.last?.rxISR, 0)
        XCTAssertEqual(io.snapshots.last?.receiveState, 0x20)
        XCTAssertEqual(io.snapshots.last?.eventType, 2)
      } else {
        XCTAssertTrue(io.events.isEmpty)
        XCTAssertEqual(io.registerWrites, [.write(.icr, 0x10)])
        XCTAssertEqual(io.words[.receiveState], 0x22)
      }
    }
  }

  func testIDLEDMAHandlesCircularFullPartialAndCounterTruncation() {
    for mode: UInt32 in [0, 0x80, 0x81] {
      for counter: UInt32 in [0, 3, 8, 9, 0x1_0003] {
        let io = UARTDMAFixture(registered: true)
        io.words[.receptionType] = 1
        io.words[.receiveState] = 0x22
        io.halves[.receiveSize] = 8
        io.halves[.receiveCount] = 8
        io.rx.mode = mode
        io.rx.counter = counter
        io.rx.statuses[.abort] = .error
        io.registers[.isr] = 0x10
        io.registers[.cr1] = 0x110
        io.registers[.cr3] = 0x41
        io.uart.handleInterrupt(getTick: io.getTick)
        let remaining = UInt16(truncatingIfNeeded: counter)
        let partial = remaining > 0 && remaining < 8
        let event = partial || (remaining == 8 && mode == 0x81)
        XCTAssertEqual(io.events, event ? [.rxEvent(partial ? 8 - remaining : 8)] : [])
        XCTAssertEqual(io.operations, partial && mode != 0x81 ? [.operation(.receive, .abort, 0, 0, 0)] : [])
        XCTAssertEqual(io.words[.receiveState], partial && mode != 0x81 ? 0x20 : 0x22)
        XCTAssertEqual(io.halves[.receiveCount], partial ? remaining : 8)
        if partial && mode != 0x81 {
          XCTAssertEqual(io.snapshots.last?.cr1, 0)
          XCTAssertEqual(io.snapshots.last?.cr3, 0)
          XCTAssertEqual(io.snapshots.last?.receptionType, 0)
        }
      }
    }
  }

  func testDMAErrorAbortFailureInvokesInstalledCallbackAndNoDMAStillNotifies() {
    for present in [false, true] {
      for abortStatus in [HALStatus.ok, .error] {
        let io = UARTDMAFixture()
        io.rx.present = present
        io.rx.statuses[.abortInterrupt] = abortStatus
        io.words[.receiveState] = 0x22
        io.words[.receptionType] = 1
        io.halves[.receiveCount] = 5
        io.halves[.transmitCount] = 7
        io.registers[.isr] = 4
        io.registers[.cr1] = 0x110
        io.registers[.cr3] = 0x41
        io.uart.handleInterrupt(getTick: io.getTick)
        XCTAssertEqual(io.words[.errorCode], 2)
        XCTAssertEqual(io.words[.receiveState], 0x20)
        XCTAssertEqual(io.words[.receptionType], 0)
        XCTAssertEqual(io.registers[.cr3], 0)
        XCTAssertEqual(io.events, !present || abortStatus != .ok ? [.callback(.error)] : [])
        if present {
          XCTAssertTrue(io.trace.contains(.dmaCallbackWrite(.receive, .abort, .abortOnError)))
          XCTAssertEqual(io.trace.contains(.dmaInvoke(.receive, .abort)), abortStatus != .ok)
          if abortStatus != .ok {
            XCTAssertEqual(io.halves[.receiveCount], 5)
            XCTAssertEqual(io.halves[.transmitCount], 7)
          }
        }
      }
    }
  }

  func testIRQErrorStillNotifiesAfterReceiveCallbackRearmsAndClearsError() {
    withBuffer { data in
      let io = UARTDMAFixture()
      XCTAssertEqual(io.uart.receiveInterrupt(data, size: 1), .ok)
      io.registers[.isr] = 0x24
      io.registers[.rdr] = 0xAB
      io.onCallback = { id in
        if id == .receiveComplete {
          XCTAssertEqual(io.uart.receiveInterrupt(data.advanced(by: 4), size: 2), .ok)
        } else if id == .error {
          XCTAssertEqual(io.words[.errorCode], 0)
          io.words[.errorCode] = 0xDEAD
        }
      }
      io.trace = []
      io.uart.handleInterrupt(getTick: io.getTick)
      XCTAssertEqual(io.events, [.callback(.receiveComplete), .callback(.error)])
      XCTAssertEqual(io.words[.receiveState], 0x22)
      XCTAssertEqual(io.halves[.receiveCount], 2)
      XCTAssertEqual(io.words[.errorCode], 0)
    }
  }

}
