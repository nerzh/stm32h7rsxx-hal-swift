import XCTest
@testable import STM32H7RSHAL

private enum FlashAccess: Equatable {
  case read(FlashRegister, UInt32), write(FlashRegister, UInt32)
  case readProcess(FlashProcessWord, UInt32), writeProcess(FlashProcessWord, UInt32)
  case read8(UInt32, UInt8), write8(UInt32, UInt8)
  case read16(UInt32, UInt16), write16(UInt32, UInt16)
  case read32(UInt32, UInt32), write32(UInt32, UInt32)
  case getPRIMASK(UInt32), disableIRQ, setPRIMASK(UInt32), isb, dsb, tick(UInt32)
  case callback(UInt32, UInt32)
}
private struct FlashCallbackSnapshot: Equatable {
  let id, value, lock, error, procedure, address, sector, remaining, cr, ier, icr, opticr: UInt32
}
private final class FlashTestIO: FlashRegisterIO, FlashProcessIO, FlashMemoryIO {
  var registers: [FlashRegister: UInt32] = [:]
  var words: [FlashProcessWord: UInt32] = [:]
  var bytes: [UInt32: UInt8] = [:]
  var trace: [FlashAccess] = []
  var snapshots: [FlashCallbackSnapshot] = []
  var acr: UInt32 = 0
  var primask: UInt32 = 0
  var tick: UInt32 = 0
  var tickStep: UInt32 = 1
  var tickCalls: UInt32 = 0
  var readCounts: [FlashRegister: Int] = [:]
  var scriptedReads: [FlashRegister: [UInt32]] = [:]
  var onRead: ((FlashRegister, Int) -> Void)?
  var onWrite: ((FlashRegister, UInt32) -> Void)?
  var onMemoryWrite: (() -> Void)?
  var onTick: ((UInt32) -> Void)?
  var onCallback: ((UInt32, UInt32) -> Void)?
  var clearFlags = true

  var driver: Flash<FlashTestIO, FlashTestIO, FlashTestIO> {
    .init(registers: self, process: self, memory: self,
      callbacks: .init(context: Unmanaged.passUnretained(self).toOpaque(),
        endOfOperation: { context, value in FlashTestIO.from(context).callback(0, value) },
        operationError: { context, value in FlashTestIO.from(context).callback(1, value) },
        eccCorrection: { context in FlashTestIO.from(context).callback(2, 0) },
        eccDetection: { context in FlashTestIO.from(context).callback(3, 0) }))
  }
  private static func from(_ context: UnsafeMutableRawPointer?) -> FlashTestIO {
    Unmanaged<FlashTestIO>.fromOpaque(context!).takeUnretainedValue()
  }
  private func callback(_ id: UInt32, _ value: UInt32) {
    trace.append(.callback(id, value))
    snapshots.append(.init(id: id, value: value, lock: words[.lock, default: 0],
      error: words[.errorCode, default: 0], procedure: words[.procedure, default: 0],
      address: words[.address, default: 0], sector: words[.sector, default: 0],
      remaining: words[.sectorsRemaining, default: 0], cr: registers[.cr, default: 0],
      ier: registers[.ier, default: 0], icr: registers[.icr, default: 0], opticr: registers[.opticr, default: 0]))
    onCallback?(id, value)
  }
  func read(_ register: FlashRegister) -> UInt32 {
    readCounts[register, default: 0] += 1
    onRead?(register, readCounts[register, default: 0])
    let value: UInt32
    if var values = scriptedReads[register], !values.isEmpty {
      value = values.removeFirst(); scriptedReads[register] = values
    } else { value = registers[register, default: 0] }
    trace.append(.read(register, value)); return value
  }
  func write(_ register: FlashRegister, value: UInt32) {
    registers[register] = value
    trace.append(.write(register, value))
    if clearFlags {
      if register == .icr { registers[.isr, default: 0] &= ~value }
      if register == .opticr { registers[.optisr, default: 0] &= ~value }
    }
    onWrite?(register, value)
  }
  func read(_ register: FlashTimingRegister) -> UInt32 { acr }
  func write(_ register: FlashTimingRegister, value: UInt32) { acr = value }
  func read(_ word: FlashProcessWord) -> UInt32 {
    let value = words[word, default: 0]; trace.append(.readProcess(word, value)); return value
  }
  func write(_ word: FlashProcessWord, value: UInt32) {
    words[word] = value; trace.append(.writeProcess(word, value))
  }
  func read8(at address: UInt32) -> UInt8 {
    let value = bytes[address, default: 0]; trace.append(.read8(address, value)); return value
  }
  func write8(at address: UInt32, value: UInt8) {
    bytes[address] = value; trace.append(.write8(address, value)); onMemoryWrite?()
  }
  func read16(at address: UInt32) -> UInt16 {
    let value = UInt16(bytes[address, default: 0]) | UInt16(bytes[address &+ 1, default: 0]) << 8
    trace.append(.read16(address, value)); return value
  }
  func write16(at address: UInt32, value: UInt16) {
    bytes[address] = UInt8(truncatingIfNeeded: value)
    bytes[address &+ 1] = UInt8(truncatingIfNeeded: value >> 8)
    trace.append(.write16(address, value)); onMemoryWrite?()
  }
  func read32(at address: UInt32) -> UInt32 {
    var value: UInt32 = 0
    for offset in UInt32(0)..<4 { value |= UInt32(bytes[address &+ offset, default: 0]) << (offset * 8) }
    trace.append(.read32(address, value)); return value
  }
  func write32(at address: UInt32, value: UInt32) {
    for offset in UInt32(0)..<4 { bytes[address &+ offset] = UInt8(truncatingIfNeeded: value >> (offset * 8)) }
    trace.append(.write32(address, value)); onMemoryWrite?()
  }
  func getPRIMASK() -> UInt32 { trace.append(.getPRIMASK(primask)); return primask }
  func disableIRQ() { trace.append(.disableIRQ); primask = 1 }
  func setPRIMASK(_ value: UInt32) { trace.append(.setPRIMASK(value)); primask = value }
  func instructionSynchronizationBarrier() { trace.append(.isb) }
  func dataSynchronizationBarrier() { trace.append(.dsb) }
  func getTick() -> UInt32 {
    let value = tick; tick &+= tickStep; tickCalls &+= 1
    trace.append(.tick(value)); onTick?(tickCalls); return value
  }
  var writes: [FlashAccess] {
    trace.filter { if case .write = $0 { return true }; return false }
  }
  var memoryWrites: [FlashAccess] {
    trace.filter { switch $0 { case .write8, .write16, .write32: return true; default: return false } }
  }
}

final class FlashTests: XCTestCase {
  func testAllProgramWidthsPreserveInterleavedHalfWordBusAccessAndCriticalSection() {
    let source: UInt32 = 0x2400_1000
    for type in FlashProgramType.allCases {
      for initialMask: UInt32 in [0, 1] {
        let io = FlashTestIO()
        io.primask = initialMask
        let otp = type == .otpHalfWord || type == .otpWord
        let destination: UInt32 = otp ? 0x08FF_F000 : 0x0800_0020
        let count: UInt32
        switch type {
        case .byte: count = 1
        case .halfWord, .otpHalfWord: count = 2
        case .word, .otpWord: count = 4
        case .doubleWord: count = 8
        case .quadWord: count = 16
        }
        for offset in UInt32(0)..<20 {
          io.bytes[source + offset] = UInt8(truncatingIfNeeded: 0xA5 + offset * 13)
          io.bytes[destination + offset] = 0xCC
        }
        XCTAssertEqual(io.driver.program(type, address: destination, dataAddress: source, getTick: io.getTick), .ok)
        var expected: [FlashAccess] = [.getPRIMASK(initialMask), .disableIRQ]
        if type == .byte {
          expected += [.read8(source, 0xA5), .write8(destination, 0xA5)]
        } else {
          for offset in stride(from: UInt32(0), to: count, by: 2) {
            let value = UInt16(io.bytes[source + offset]!) | UInt16(io.bytes[source + offset + 1]!) << 8
            expected += [.read16(source + offset, value), .write16(destination + offset, value)]
          }
        }
        expected += [.isb, .dsb]
        let programBit: UInt32 = otp ? 0x10000 : 2
        if type != .quadWord { expected += [.read(.cr, programBit), .write(.cr, programBit | 0x10)] }
        expected.append(.setPRIMASK(initialMask))
        let first = io.trace.firstIndex(of: .getPRIMASK(initialMask))!
        let last = io.trace.firstIndex(of: .setPRIMASK(initialMask))!
        XCTAssertEqual(Array(io.trace[first...last]), expected)
        XCTAssertEqual(io.primask, initialMask)
        XCTAssertEqual(io.words[.lock], 0)
        XCTAssertEqual(io.words[.errorCode], 0)
        XCTAssertEqual(io.registers[.cr], 0)
        XCTAssertEqual(io.tickCalls, 2)
        for offset in UInt32(0)..<count { XCTAssertEqual(io.bytes[destination + offset], io.bytes[source + offset]) }
        XCTAssertEqual(io.bytes[destination + count], 0xCC)
      }
    }
  }

  func testSoftwareBusyAndInitialWaitErrorPreventAnyMemoryAccess() {
    for interrupt in [false, true] {
      let busy = FlashTestIO()
      busy.words[.lock] = 1; busy.words[.errorCode] = 0x1234
      let result = interrupt
        ? busy.driver.programInterrupt(.word, address: 0x08000000, dataAddress: 0x24000000, getTick: busy.getTick)
        : busy.driver.program(.word, address: 0x08000000, dataAddress: 0x24000000, getTick: busy.getTick)
      XCTAssertEqual(result, .busy)
      XCTAssertEqual(busy.trace, [.readProcess(.lock, 1)])
      let error = FlashTestIO()
      error.words[.errorCode] = 0x80000000
      error.registers[.isr] = 0x00040000
      error.registers[.optisr] = 0x40000000
      let failed = interrupt
        ? error.driver.programInterrupt(.word, address: 0x08000000, dataAddress: 0x24000000, getTick: error.getTick)
        : error.driver.program(.word, address: 0x08000000, dataAddress: 0x24000000, getTick: error.getTick)
      XCTAssertEqual(failed, .error)
      XCTAssertEqual(error.words[.errorCode], 0x40040000)
      XCTAssertEqual(error.words[.lock], 0)
      XCTAssertTrue(error.memoryWrites.isEmpty)
      XCTAssertEqual(error.writes, [.write(.icr, 0x40000), .write(.opticr, 0x40000000)])
    }
  }

  func testInitialTimeoutUnlocksAndSecondTimeoutStillClearsProgramBits() {
    for failAfterWrite in [false, true] {
      let io = FlashTestIO()
      io.primask = 1; io.tickStep = 1001
      if failAfterWrite { io.onMemoryWrite = { io.registers[.sr] = 4 } }
      else { io.registers[.sr] = 4 }
      XCTAssertEqual(io.driver.program(.word, address: 0x08000000, dataAddress: 0x24000000, getTick: io.getTick), .timeout)
      XCTAssertEqual(io.words[.lock], 0)
      XCTAssertEqual(io.words[.errorCode], 0)
      XCTAssertEqual(io.primask, 1)
      XCTAssertEqual(io.memoryWrites.count, failAfterWrite ? 2 : 0)
      if failAfterWrite { XCTAssertEqual(io.registers[.cr], 0) }
      else { XCTAssertNil(io.registers[.cr]) }
    }
  }

  func testWaitUsesQueueWaitFlagStrictTimeoutWrapAndNoFinalRecheck() {
    let notQueueWait = FlashTestIO(); notQueueWait.registers[.sr] = 1
    XCTAssertEqual(notQueueWait.driver.waitForLastOperation(timeout: 0, getTick: notQueueWait.getTick), .ok)
    XCTAssertEqual(notQueueWait.tickCalls, 1)
    for timeout: UInt32 in [0, 1, 3] {
      let io = FlashTestIO(); io.tick = .max - 1; io.registers[.sr] = 4
      io.onTick = { calls in if calls == timeout + 2 { io.registers[.sr] = 0 } }
      XCTAssertEqual(io.driver.waitForLastOperation(timeout: timeout, getTick: io.getTick), .timeout)
      XCTAssertEqual(io.tickCalls, timeout == 0 ? 2 : timeout + 2)
      XCTAssertNil(io.readCounts[.isr])
    }
    let forever = FlashTestIO(); forever.scriptedReads[.sr] = [4, 4, 0]
    XCTAssertEqual(forever.driver.waitForLastOperation(timeout: .max, getTick: forever.getTick), .ok)
    XCTAssertEqual(forever.tickCalls, 1)
    XCTAssertEqual(forever.readCounts[.sr], 3)
  }

  func testWaitErrorORClearsBothRegistersAndExcludesECC() {
    let io = FlashTestIO()
    io.words[.errorCode] = 0x55
    io.registers[.isr] = 0x02050000
    io.registers[.optisr] = 0x08000000
    XCTAssertEqual(io.driver.waitForLastOperation(timeout: 100, getTick: io.getTick), .error)
    XCTAssertEqual(io.words[.errorCode], 0x08040055)
    XCTAssertEqual(io.writes, [.write(.icr, 0x40000), .write(.opticr, 0x08000000)])
    XCTAssertEqual(io.registers[.isr], 0x02010000)
    io.trace.removeAll()
    XCTAssertEqual(io.driver.waitForLastOperation(timeout: 100, getTick: io.getTick), .ok)
    XCTAssertEqual(io.writes, [.write(.icr, 0x10000)])
    XCTAssertEqual(io.words[.errorCode], 0x08040055)
  }

  func testHardwareLocksUseExactKeysAndVerifyReadback() {
    for options in [false, true] {
      let register: FlashRegister = options ? .optcr : .cr
      let keyRegister: FlashRegister = options ? .optkeyr : .keyr
      let first: UInt32 = options ? 0x08192A3B : 0x45670123
      let second: UInt32 = options ? 0x4C5D6E7F : 0xCDEF89AB
      for acceptsKeys in [false, true] {
        let io = FlashTestIO(); io.registers[register] = 0xA501
        io.onWrite = { reg, value in if acceptsKeys && reg == keyRegister && value == second { io.registers[register] = 0xA500 } }
        XCTAssertEqual(options ? io.driver.unlockOptionBytes() : io.driver.unlock(), acceptsKeys ? .ok : .error)
        XCTAssertEqual(io.trace, [.read(register, 0xA501), .write(keyRegister, first), .write(keyRegister, second), .read(register, acceptsKeys ? 0xA500 : 0xA501)])
      }
      let unlocked = FlashTestIO()
      XCTAssertEqual(options ? unlocked.driver.unlockOptionBytes() : unlocked.driver.unlock(), .ok)
      XCTAssertEqual(unlocked.trace, [.read(register, 0)])
      for acceptsLock in [false, true] {
        let io = FlashTestIO()
        io.onWrite = { reg, _ in if reg == register && !acceptsLock { io.registers[register] = 0 } }
        XCTAssertEqual(options ? io.driver.lockOptionBytes() : io.driver.lock(), acceptsLock ? .ok : .error)
      }
    }
  }

  func testInterruptProgrammingSharesProcessAndKeepsLockUntilCompletion() {
    let io = FlashTestIO()
    let foreground = io.driver
    let interrupt = io.driver
    XCTAssertEqual(foreground.programInterrupt(.word, address: 0x08000020, dataAddress: 0x24000000, getTick: io.getTick), .ok)
    XCTAssertEqual(io.words[.lock], 1)
    XCTAssertEqual(io.words[.procedure], 0x80000012)
    XCTAssertEqual(io.words[.address], 0x08000020)
    XCTAssertEqual(io.registers[.ier], 0x2F0000)
    XCTAssertEqual(io.registers[.cr], 0x12)
    XCTAssertEqual(io.tickCalls, 1)
    XCTAssertEqual(interrupt.programInterrupt(.byte, address: 0x08000030, dataAddress: 0x24000000, getTick: io.getTick), .busy)
    io.registers[.isr] = 0x10000
    interrupt.handleInterrupt()
    XCTAssertEqual(io.words[.lock], 0)
    XCTAssertEqual(io.words[.procedure], 0)
    XCTAssertEqual(io.snapshots.map(\.value), [0x08000020])
    XCTAssertEqual(io.snapshots.first?.lock, 1)
    XCTAssertEqual(io.registers[.ier], 0)
  }

  func testIRQProgramCallbackParameterUsesPGAndOTPReportsZero() {
    for type in FlashProgramType.allCases {
      let io = FlashTestIO()
      io.words[.procedure] = type.rawValue; io.words[.address] = 0x08FFF000
      io.words[.lock] = 1; io.registers[.cr] = type.rawValue & 0x3FFFFFFF
      io.registers[.ier] = 0x2F0000; io.registers[.isr] = 0x10000
      io.driver.handleInterrupt()
      XCTAssertEqual(io.snapshots.map(\.value), [type.rawValue & 2 != 0 ? 0x08FFF000 : 0])
      XCTAssertEqual(io.snapshots.first?.procedure, 0)
      XCTAssertEqual(io.snapshots.first?.lock, 1)
      XCTAssertEqual(io.registers[.cr], 0)
      XCTAssertEqual(io.words[.lock], 0)
    }
  }

  func testIRQErrorAndEOPCallbacksKeepInitialParameterAndUnlockAfterBoth() {
    let io = FlashTestIO()
    io.words[.procedure] = 0x80000012; io.words[.address] = 0x08001234
    io.words[.lock] = 1; io.words[.errorCode] = 0x80
    io.registers[.cr] = 0x112; io.registers[.ier] = 0x2F0000
    io.registers[.isr] = 0x50000; io.registers[.optisr] = 0x40000000
    io.driver.handleInterrupt()
    XCTAssertEqual(io.snapshots.map(\.id), [1, 0])
    XCTAssertEqual(io.snapshots.map(\.value), [0x08001234, 0x08001234])
    XCTAssertEqual(io.snapshots.map(\.lock), [1, 1])
    XCTAssertEqual(io.snapshots.map(\.error), [0x40040080, 0x40040080])
    XCTAssertEqual(io.words[.lock], 0)
    XCTAssertEqual(io.registers[.cr], 0x100)
  }

  func testIRQSectorContinuationFinalMarkerAndUnsignedRemainingWrap() {
    for remaining: UInt32 in [0, 1, 3] {
      let io = FlashTestIO()
      io.words[.procedure] = 4; io.words[.sector] = 2
      io.words[.sectorsRemaining] = remaining; io.words[.lock] = 1
      io.registers[.cr] = 0xA4; io.registers[.ier] = 0x2F0000; io.registers[.isr] = 0x10000
      io.driver.handleInterrupt()
      XCTAssertEqual(io.words[.sectorsRemaining], remaining &- 1)
      XCTAssertEqual(io.words[.procedure], remaining == 1 ? 0 : 4)
      XCTAssertEqual(io.words[.lock], remaining == 1 ? 0 : 1)
      XCTAssertEqual(io.snapshots.first?.value, remaining == 1 ? .max : 2)
      if remaining != 1 {
        XCTAssertEqual(io.words[.sector], 3)
        XCTAssertEqual(io.registers[.cr], 0xE4)
      }
    }
  }

  func testErrorCallbackMutationChangesFollowingEOPAndCompletionObservesLock() {
    let io = FlashTestIO()
    io.words[.procedure] = 2; io.words[.address] = 0x08000000; io.words[.lock] = 1
    io.registers[.isr] = 0x50000
    io.onCallback = { id, _ in
      if id == 1 {
        io.words[.procedure] = 4; io.words[.sector] = 6; io.words[.sectorsRemaining] = 1
      } else if id == 0 {
        XCTAssertEqual(io.driver.programInterrupt(.byte, address: 0x08000020, dataAddress: 0x24000000, getTick: io.getTick), .busy)
      }
    }
    io.driver.handleInterrupt()
    XCTAssertEqual(io.snapshots.map(\.value), [0x08000000, UInt32.max])
    XCTAssertEqual(io.words[.sectorsRemaining], 0)
    XCTAssertEqual(io.words[.lock], 0)
  }

  func testECCCallbacksRunAfterUnlockAndFreshEnablesFlagsAllowReentry() {
    let io = FlashTestIO()
    io.words[.lock] = 1
    io.registers[.ier] = 0x02000000; io.registers[.isr] = 0x02000000
    io.onCallback = { id, _ in
      if id == 2 {
        XCTAssertEqual(io.words[.lock], 0)
        io.registers[.ier, default: 0] |= 0x04000000
        io.registers[.isr, default: 0] |= 0x04000000
      } else if id == 3 {
        XCTAssertEqual(io.driver.programInterrupt(.quadWord, address: 0x08000040, dataAddress: 0x24000000, getTick: io.getTick), .ok)
      }
    }
    io.driver.handleInterrupt()
    XCTAssertEqual(io.snapshots.map(\.id), [2, 3])
    XCTAssertEqual(io.words[.lock], 1)
    XCTAssertEqual(io.words[.procedure], 2)
    XCTAssertEqual(io.registers[.icr], 0x04000000)
    XCTAssertEqual(io.registers[.isr], 0)
  }

  func testFlagAndInterruptMacrosRetainOverlappingISRAndOptionEncodings() {
    let io = FlashTestIO()
    io.registers[.isr] = 0x10010000
    XCTAssertEqual(io.driver.getFlag(0x10000000), 0)
    XCTAssertEqual(io.trace, [.read(.optisr, 0)])
    io.trace.removeAll()
    XCTAssertEqual(io.driver.getFlag(0), 1)
    XCTAssertEqual(io.trace, [.read(.isr, 0x10010000)])
    io.trace.removeAll()
    io.driver.enableInterrupts(UInt32(0x18000000))
    XCTAssertEqual(io.writes, [.write(.ier, 0x18000000), .write(.optcr, 0x18000000)])
    io.trace.removeAll()
    io.driver.clearFlag(UInt32(0x18010000))
    XCTAssertEqual(io.writes, [.write(.opticr, 0x18000000), .write(.icr, 0x10010000)])
    io.trace.removeAll()
    io.driver.clearFlag(UInt32(0)); io.driver.enableInterrupts(UInt32(0)); io.driver.disableInterrupts(UInt32(0))
    XCTAssertTrue(io.trace.isEmpty)
  }

  func testLatencyReusesExistingCombinedLatencyAndWriteFrequencyEncoding() {
    let io = FlashTestIO(); io.acr = .max
    io.driver.setLatency(.waitStates7)
    XCTAssertEqual(io.acr, 0xFFFF_FFF7)
    XCTAssertEqual(io.driver.getLatency(), 0x37)
    io.words[.errorCode] = 0x5F3E0000
    XCTAssertEqual(io.driver.getError(), 0x5F3E0000)
  }
}
