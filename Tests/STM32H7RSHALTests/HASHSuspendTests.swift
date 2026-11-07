import XCTest
@testable import STM32H7RSHAL

final class HASHSuspendTests: XCTestCase {
  func testSuspendCopies106WordsAndSelectedHandleFieldsInOrder() {
    let io = HASHTestIO(suspendEnabled: true)
    for word in HASHHandleWord.allCases { io.words[word] = UInt32(word.rawValue) + 0xA0 }
    io.registers[.imr] = .max; io.registers[.str] = .max; io.registers[.cr] = .max
    for index in 0..<103 { io.registers[.csr(index: index)] = 0x1234_0000 + UInt32(index) }
    let original = io.words
    io.driver.suspend(contextAddress: 0x6000)
    XCTAssertEqual(io.rawRead(0x6000), 3); XCTAssertEqual(io.rawRead(0x6004), 0x1F)
    XCTAssertEqual(io.rawRead(0x6008), 0x001F_2078)
    var expected: [HASHTestAccess] = [.read(.imr), .memoryWrite(0x6000, 3),
      .read(.str), .memoryWrite(0x6004, 0x1F), .read(.cr), .memoryWrite(0x6008, 0x001F_2078)]
    for index in 0..<103 {
      expected += [.read(.csr(index: index)), .memoryWrite(0x600C + UInt32(index * 4), 0x1234_0000 + UInt32(index))]
    }
    let fields: [(HASHHandleWord, HASHHandleWord)] = [
      (.dataType, .savedDataType), (.keySize, .savedKeySize), (.keyAddress, .savedKeyAddress),
      (.algorithm, .savedAlgorithm), (.outputAddress, .savedOutputAddress), (.inputCount, .savedInputCount),
      (.size, .savedSize), (.inputAddress, .savedInputAddress), (.phase, .savedPhase),
      (.keyBufferAddress, .savedKeyBufferAddress),
    ]
    for (source, saved) in fields {
      expected += [.handleRead(source), .handleWrite(saved, original[source]!)]
      XCTAssertEqual(io.words[saved], original[source])
    }
    XCTAssertEqual(io.trace, expected)
    XCTAssertEqual(io.words[.state], original[.state]); XCTAssertEqual(io.words[.lock], original[.lock])
    XCTAssertEqual(io.words[.errorCode], original[.errorCode])
  }

  func testResumeRestoresWholeRegisterWordsAndStateBeforeKeyCursor() {
    let io = HASHTestIO(suspendEnabled: true)
    for word in HASHHandleWord.allCases { io.words[word] = UInt32(word.rawValue) + 0xA0 }
    io.rawWrite(0x6000, value: 0xFFFF_0003); io.rawWrite(0x6004, value: 0xFFFF_001F)
    io.rawWrite(0x6008, value: 0xFFFF_0000)
    for index in 0..<103 { io.rawWrite(0x600C + UInt32(index * 4), value: 0xABCD_0000 + UInt32(index)) }
    let original = io.words
    io.driver.resume(contextAddress: 0x6000)
    XCTAssertEqual(Array(io.trace.prefix(8)), [.memoryRead(4, 0x6000), .write(.imr, 0xFFFF_0003),
      .memoryRead(4, 0x6004), .write(.str, 0xFFFF_001F), .memoryRead(4, 0x6008), .write(.cr, 0xFFFF_0000),
      .read(.cr), .write(.cr, 0xFFFF_0004)])
    for index in 0..<103 { XCTAssertEqual(io.registers[.csr(index: index)], 0xABCD_0000 + UInt32(index)) }
    XCTAssertEqual(io.words[.state], 3); XCTAssertEqual(io.words[.lock], original[.lock])
    XCTAssertEqual(io.words[.errorCode], original[.errorCode]); XCTAssertEqual(io.words[.suspendRequest], original[.suspendRequest])
    XCTAssertEqual(Array(io.trace.suffix(3)), [.handleWrite(.state, 3), .handleRead(.savedKeyBufferAddress),
      .handleWrite(.keyBufferAddress, original[.savedKeyBufferAddress]!)])
    XCTAssertEqual(io.words[.inputAddress], original[.savedInputAddress])
  }

  func testProcessSuspendWithoutDMAOnlyRequestsInterruptSuspension() {
    for state: UInt32 in [0, 1, 2, 3] {
      let io = HASHTestIO(suspendEnabled: true); io.words[.state] = state; io.registers[.sr] = 0x1234_0003
      XCTAssertEqual(io.driver.processSuspend(getTick: io.getTick), .ok)
      XCTAssertEqual(io.trace, [.read(.sr), .read(.sr), .handleWrite(.suspendRequest, 1)])
      XCTAssertEqual(io.words[.state], state)
    }
  }

  func testProcessSuspendReadyDMARejectsBeforeDisablingRequests() {
    let io = HASHTestIO(suspendEnabled: true); io.registers[.sr] = 4; io.registers[.cr] = 8
    XCTAssertEqual(io.driver.processSuspend(getTick: io.getTick), .error)
    XCTAssertEqual(io.trace, [.read(.sr), .read(.sr), .handleRead(.state)])
    XCTAssertEqual(io.registers[.cr], 8)
  }

  func testProcessSuspendPreservesMixedWordByteThresholdAndLateFailures() {
    for remaining: UInt32 in [4, 5] {
      for abortStatus: HALStatus in [.ok, .error] {
        let io = HASHTestIO(suspendEnabled: true)
        io.words[.state] = 2; io.words[.lock] = 1; io.words[.size] = 64
        io.registers[.cr] = 8; io.scriptedReads[.sr] = [0x0001_0004, 4]
        io.registers[.sr] = 1; io.counter = remaining * 4; io.abortStatus = abortStatus
        let expected: HALStatus = remaining > 4 && abortStatus == .ok ? .ok : .error
        XCTAssertEqual(io.driver.processSuspend(getTick: io.getTick), expected)
        XCTAssertEqual(io.trace.contains(.dmaAbort), remaining > 4)
        XCTAssertEqual(io.registers[.cr], 0)
        if expected == .ok {
          XCTAssertEqual(io.words[.inputAddress], 0x1000 + 4 * (16 - remaining))
          XCTAssertEqual(io.words[.inputCount], remaining * 4)
          XCTAssertEqual(io.words[.state], 3); XCTAssertEqual(io.words[.lock], 0)
        } else {
          XCTAssertEqual(io.words[.state], 2); XCTAssertEqual(io.words[.lock], 1)
        }
      }
    }
    let io = HASHTestIO(suspendEnabled: true)
    io.words[.state] = 2; io.words[.lock] = 1; io.counter = 16
    io.scriptedReads[.sr] = [4, 4]; io.registers[.sr] = 2
    XCTAssertEqual(io.driver.processSuspend(getTick: io.getTick), .error)
    XCTAssertTrue(io.trace.contains(.dmaAbort)); XCTAssertEqual(io.words[.state], 2)
    XCTAssertEqual(io.words[.lock], 1); XCTAssertEqual(io.ticks.count, 1)
  }

  func testProcessSuspendUsesFIFOAndWrappingSizeAddressArithmetic() {
    let io = HASHTestIO(suspendEnabled: true)
    io.words[.state] = 2; io.words[.lock] = 1; io.words[.size] = .max
    io.words[.inputAddress] = 4; io.counter = 8; io.fifoLevel = 1
    io.scriptedReads[.sr] = [4, 4]; io.registers[.sr] = 1
    XCTAssertEqual(io.driver.processSuspend(getTick: io.getTick), .ok)
    // (UINT32_MAX + 3) / 4 is zero before subtracting the three remaining words.
    XCTAssertEqual(io.words[.inputAddress], 0xFFFF_FFF8)
    XCTAssertEqual(io.words[.inputCount], 12); XCTAssertEqual(io.words[.state], 3)
    XCTAssertEqual(io.ticks.count, 2)
  }

  func testProcessSuspendTimeoutReturnsTimeoutButStoresHashTimeoutError() {
    for secondWait in [false, true] {
      let io = HASHTestIO(suspendEnabled: true)
      io.words[.state] = 2; io.words[.lock] = 1; io.words[.errorCode] = 0x80
      io.registers[.cr] = 8; io.tickStep = 1001; io.counter = 16
      if secondWait { io.scriptedReads[.sr] = [4, 4]; io.registers[.sr] = 0 }
      else { io.registers[.sr] = 4 }
      XCTAssertEqual(io.driver.processSuspend(getTick: io.getTick), .timeout)
      XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.lock], 0)
      XCTAssertEqual(io.words[.errorCode], 0x84)
      XCTAssertEqual(io.trace.contains(.dmaAbort), secondWait)
      XCTAssertTrue(io.events.isEmpty)
    }
  }
}
