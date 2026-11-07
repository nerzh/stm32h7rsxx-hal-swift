import XCTest
@testable import STM32H7RSHAL

final class HASHPollingTests: XCTestCase {
  func testStartAllAlgorithmsLengthsAndPreservedErrors() {
    for algorithm in HASHAlgorithm.allCases {
      for size: UInt32 in [0, 1, 2, 3, 4, 7, 64, 65] {
        let io = HASHTestIO()
        io.words[.algorithm] = algorithm.rawValue; io.words[.errorCode] = 0x80
        io.registers[.cr] = algorithm.rawValue | 0x40
        XCTAssertEqual(io.driver.start(inputAddress: 0x1000, size: size, outputAddress: 0x4000,
          timeout: 0, getTick: io.getTick), .ok)
        XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.phase], 1)
        XCTAssertEqual(io.words[.lock], 0); XCTAssertEqual(io.words[.errorCode], 0x80)
        XCTAssertEqual(io.words[.inputCount], ((size + 3) / 4) * 4)
        XCTAssertEqual(io.registers[.str], 0x100 | (8 * (size % 4)))
        XCTAssertEqual(io.registers[.cr], algorithm.rawValue | 4)
        XCTAssertEqual(io.rawRead(0x4000), UInt32(0x1234_5600).byteSwapped)
        XCTAssertTrue(io.events.isEmpty); XCTAssertEqual(io.ticks, [0])
      }
    }
  }

  func testBusyLockAndMisalignedAccumulationRejectBeforeIO() {
    let io = HASHTestIO(); io.words[.state] = 2; io.words[.errorCode] = 0x80
    XCTAssertEqual(io.driver.start(inputAddress: 0, size: 0, outputAddress: 0, timeout: 1, getTick: io.getTick), .busy)
    XCTAssertEqual(io.trace, [.handleRead(.state)])
    io.trace = []
    XCTAssertEqual(io.driver.accumulate(inputAddress: 0, size: 3, timeout: 1, getTick: io.getTick), .error)
    XCTAssertEqual(io.driver.accumulateHMAC(inputAddress: 0, size: 3, timeout: 1, getTick: io.getTick), .error)
    XCTAssertTrue(io.trace.isEmpty)
    io.words[.state] = 1; io.words[.lock] = 1
    XCTAssertEqual(io.driver.start(inputAddress: 0, size: 0, outputAddress: 0, timeout: 1, getTick: io.getTick), .busy)
    XCTAssertEqual(io.trace, [.handleRead(.state), .handleRead(.lock)])
    XCTAssertEqual(io.words[.errorCode], 0x80)
  }

  func testAccumulationStartsOnceAcceptsSuspendedAndLastResetsAccumulation() {
    let io = HASHTestIO()
    XCTAssertEqual(io.driver.accumulate(inputAddress: 0x1000, size: 8, timeout: 0, getTick: io.getTick), .ok)
    XCTAssertEqual(io.words[.phase], 2); XCTAssertEqual(io.words[.inputCount], 8)
    XCTAssertEqual(io.inputWrites, [0x0403_0201, 0x0807_0605])
    io.trace = []; io.words[.state] = 3; io.words[.accumulation] = 1
    XCTAssertEqual(io.driver.accumulate(inputAddress: 0x1008, size: 4, timeout: 0, getTick: io.getTick), .ok)
    XCTAssertEqual(io.inputWrites, [0x0C0B_0A09]); XCTAssertEqual(io.words[.inputCount], 4)
    XCTAssertFalse(io.mmio.contains { if case .write(.cr, _) = $0 { return true }; return false })
    io.trace = []; io.words[.state] = 3
    XCTAssertEqual(io.driver.accumulateLast(inputAddress: 0x100C, size: 3, outputAddress: 0x4000,
      timeout: 0, getTick: io.getTick), .ok)
    XCTAssertEqual(io.inputWrites, [0x000F_0E0D])
    XCTAssertEqual(io.words[.phase], 1); XCTAssertEqual(io.words[.accumulation], 0)
    XCTAssertEqual(io.words[.inputCount], 4); XCTAssertEqual(io.words[.lock], 0)
    XCTAssertEqual(io.registers[.str], 0x118)
  }

  func testPollingTimeoutLeavesTransferredDataAndProcessingPhase() {
    let io = HASHTestIO(); io.registers[.sr] = 0
    io.words[.errorCode] = 0x80
    XCTAssertEqual(io.driver.start(inputAddress: 0x1000, size: 3, outputAddress: 0x4000,
      timeout: 0, getTick: io.getTick), .error)
    XCTAssertEqual(io.inputWrites, [0x0003_0201])
    XCTAssertEqual(io.words[.phase], 2); XCTAssertEqual(io.words[.inputCount], 4)
    XCTAssertEqual(io.words[.errorCode], 0x84); XCTAssertEqual(io.words[.state], 1)
    XCTAssertEqual(io.words[.lock], 0); XCTAssertEqual(io.rawRead(0x4000), 0)
    XCTAssertTrue(io.events.isEmpty)
  }

  func testHMACKeyMessageKeyOrderAndLongKeyThresholds() {
    for algorithm in HASHAlgorithm.allCases {
      let block: UInt32 = [UInt32(0), 0x40000, 0x60000].contains(algorithm.rawValue) ? 64 : 128
      for keySize in [UInt32(0), 3, block, block + 1] {
        let io = HASHTestIO()
        io.words[.algorithm] = algorithm.rawValue; io.words[.keySize] = keySize
        io.registers[.cr] = algorithm.rawValue | 0x10000
        XCTAssertEqual(io.driver.startHMAC(inputAddress: 0x1000, size: 5, outputAddress: 0x4000,
          timeout: 0, getTick: io.getTick), .ok)
        let expectedKeyWords = Int((keySize + 3) / 4)
        XCTAssertEqual(io.inputWrites.count, expectedKeyWords * 2 + 2)
        let first = Array(io.inputWrites.prefix(expectedKeyWords))
        XCTAssertEqual(Array(io.inputWrites.suffix(expectedKeyWords)), first)
        XCTAssertEqual(Array(io.inputWrites.dropFirst(expectedKeyWords).prefix(2)), [0x0403_0201, 5])
        XCTAssertEqual(io.words[.inputCount], UInt32(expectedKeyWords * 8 + 8))
        XCTAssertEqual(io.registers[.cr], algorithm.rawValue | 0x44 | (keySize > block ? 0x10000 : 0))
        XCTAssertEqual(io.words[.phase], 1); XCTAssertEqual(io.words[.state], 1)
        XCTAssertEqual(io.words[.keyBufferAddress], 0x2000)
        XCTAssertEqual(io.ticks.count, 3)
      }
    }
  }

  func testHMACAccumulationKeepsCounterAndSkipsFinalBusyWait() {
    let io = HASHTestIO(); io.words[.keySize] = 3
    XCTAssertEqual(io.driver.accumulateHMAC(inputAddress: 0x1000, size: 4, timeout: 0, getTick: io.getTick), .ok)
    XCTAssertEqual(io.inputWrites, [0x00A2_A1A0, 0x0403_0201])
    XCTAssertEqual(io.words[.inputCount], 8); XCTAssertEqual(io.words[.phase], 2)
    XCTAssertEqual(io.ticks.count, 1)
    io.trace = []; io.registers[.sr] = 8
    XCTAssertEqual(io.driver.accumulateHMAC(inputAddress: 0x1004, size: 4, timeout: 0, getTick: io.getTick), .ok)
    XCTAssertEqual(io.inputWrites, [0x0807_0605]); XCTAssertEqual(io.words[.inputCount], 12)
    XCTAssertTrue(io.ticks.isEmpty)
    io.trace = []; io.registers[.sr] = 3
    XCTAssertEqual(io.driver.accumulateHMACLast(inputAddress: 0x1008, size: 1, outputAddress: 0x4000,
      timeout: 0, getTick: io.getTick), .ok)
    XCTAssertEqual(io.inputWrites, [9, 0x00A2_A1A0]); XCTAssertEqual(io.words[.inputCount], 20)
    XCTAssertEqual(io.words[.phase], 1); XCTAssertEqual(io.ticks.count, 2)
  }

  func testHMACLastWithoutProcessPhaseRetainsBusyAndLock() {
    let io = HASHTestIO(); io.words[.errorCode] = 0x80
    XCTAssertEqual(io.driver.accumulateHMACLast(inputAddress: 0x1100, size: 7, outputAddress: 0x4100,
      timeout: 0, getTick: io.getTick), .error)
    XCTAssertEqual(io.words[.state], 2); XCTAssertEqual(io.words[.lock], 1)
    XCTAssertEqual(io.words[.phase], 1); XCTAssertEqual(io.words[.errorCode], 0x80)
    XCTAssertEqual(io.words[.inputAddress], 0x1100); XCTAssertEqual(io.words[.outputAddress], 0x4100)
    XCTAssertTrue(io.mmio.isEmpty); XCTAssertTrue(io.ticks.isEmpty)
  }
}
