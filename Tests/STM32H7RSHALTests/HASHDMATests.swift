import XCTest
@testable import STM32H7RSHAL

final class HASHDMATests: XCTestCase {
  func testDMAWordRoundingWrapCallbackInstallationAndMDMAT() {
    for size: UInt32 in [0, 1, 2, 3, 4, 7, 0xFFFF_FFFC, 0xFFFF_FFFF] {
      for multiple in [false, true] {
        let io = HASHTestIO(); io.registers[.cr] = multiple ? 0x2000 : 0
        XCTAssertEqual(io.driver.startDMA(inputAddress: 0x1000, size: size, outputAddress: 0x4000), .ok)
        let rounded = size % 4 == 0 ? size : size &+ (4 - size % 4)
        let start = HASHTestAccess.dmaStart(0x1000, 0x4802_0404, rounded)
        XCTAssertTrue(io.trace.contains(start))
        XCTAssertLessThan(io.trace.firstIndex(of: .dmaCallback(.transferComplete))!, io.trace.firstIndex(of: start)!)
        XCTAssertLessThan(io.trace.firstIndex(of: .dmaCallback(.error))!, io.trace.firstIndex(of: start)!)
        XCTAssertEqual(io.registers[.str], multiple ? 0 : 8 * (size % 4))
        XCTAssertEqual(io.registers[.cr], multiple ? 0x200C : 0xC)
        XCTAssertEqual(io.words[.state], 2); XCTAssertEqual(io.words[.lock], 1)
        XCTAssertTrue(io.memoryReads.isEmpty); XCTAssertTrue(io.events.isEmpty)
      }
    }
  }

  func testDMAFailureKeepsBusyLockAndCallsErrorBeforeAnyDMAEnable() {
    for status: HALStatus in [.error, .busy, .timeout] {
      let io = HASHTestIO(registered: true)
      io.startStatus = status; io.words[.errorCode] = 0x80
      XCTAssertEqual(io.driver.startDMA(inputAddress: 0x1000, size: 7, outputAddress: 0x4000), status)
      XCTAssertEqual(io.events, [.error]); XCTAssertEqual(io.words[.errorCode], 0x82)
      XCTAssertEqual(io.snapshots[0].words[.state], 2); XCTAssertEqual(io.snapshots[0].words[.lock], 1)
      XCTAssertEqual(io.registers[.cr], 4)
    }
  }

  func testSuspendedNormalAndLinkedListUseDifferentSourcePointers() {
    for hmac in [false, true] {
      for linked in [false, true] {
        let io = HASHTestIO()
        io.words[.state] = 3; io.words[.inputAddress] = 0x1100
        io.words[.inputCount] = 7; io.words[.size] = 100
        io.words[.phase] = hmac ? 4 : 2
        if linked {
          io.dmaWords[.mode] = 0x80; io.dmaWords[.queueAddress] = 0x8000
          io.rawWrite(0x8000, value: 0x9000)
        }
        let result = hmac
          ? io.driver.startHMACDMA(inputAddress: 0x1200, size: 99, outputAddress: 0x4100)
          : io.driver.startDMA(inputAddress: 0x1200, size: 99, outputAddress: 0x4100)
        XCTAssertEqual(result, .ok)
        XCTAssertEqual(io.words[.size], 7); XCTAssertEqual(io.words[.inputAddress], 0x1100)
        XCTAssertEqual(io.words[.outputAddress], 0x4000)
        if linked {
          XCTAssertEqual(io.rawRead(0x9008), 8)
          XCTAssertEqual(io.rawRead(0x900C), 0x1100)
          XCTAssertEqual(io.rawRead(0x9010), 0x4802_0404)
          XCTAssertTrue(io.trace.contains(.dmaListStart))
        } else {
          XCTAssertTrue(io.trace.contains(.dmaStart(hmac ? 0x1100 : 0x1200, 0x4802_0404, 8)))
        }
      }
    }
  }

  func testMissingLinkedQueueOrHeadRetainsInstalledCallbacksAndReportsError() {
    for queue: UInt32 in [0, 0x8000] {
      let io = HASHTestIO(); io.dmaWords[.mode] = 0x80; io.dmaWords[.queueAddress] = queue
      XCTAssertEqual(io.driver.startDMA(inputAddress: 0x1000, size: 4, outputAddress: 0x4000), .error)
      XCTAssertEqual(io.events, [.error]); XCTAssertNotNil(io.dmaSlots[.transferComplete])
      XCTAssertNotNil(io.dmaSlots[.error]); XCTAssertEqual(io.words[.lock], 1)
      XCTAssertFalse(io.trace.contains(.dmaListStart))
      XCTAssertFalse(io.trace.contains { if case .memoryWrite = $0 { return true }; return false })
    }
  }

  func testDMACompleteCallbackOrderAndFreshOutputPointerAfterInputCallback() {
    for registered in [false, true] {
      let io = HASHTestIO(registered: registered)
      io.words[.state] = 2; io.words[.lock] = 1; io.words[.phase] = 2
      io.registers[.cr] = 8
      io.onCallback = { id in if id == .inputComplete { io.words[.outputAddress] = 0x4100 } }
      io.driver.handleDMAEvent(.inputComplete)
      XCTAssertEqual(io.events, [.inputComplete, .digestComplete])
      XCTAssertEqual(io.snapshots[0].words[.state], 2); XCTAssertEqual(io.snapshots[0].words[.lock], 1)
      XCTAssertEqual(io.snapshots[0].registers[.cr], 0)
      XCTAssertEqual(io.snapshots[1].words[.state], 1); XCTAssertEqual(io.snapshots[1].words[.lock], 0)
      XCTAssertEqual(io.rawRead(0x4000), 0)
      XCTAssertEqual(io.rawRead(0x4100), UInt32(0x1234_5600).byteSwapped)
    }
  }

  func testDMACompletionTimeoutCallbackContinuesAndUsesDifferentHMACError() {
    for hmac in [false, true] {
      let io = HASHTestIO(registered: true)
      io.words[.state] = 2; io.words[.lock] = 1; io.words[.phase] = hmac ? 4 : 2
      io.words[.errorCode] = 0x80; io.words[.keySize] = 1
      io.registers[.cr] = hmac ? 0x48 : 8; io.registers[.sr] = 0
      io.onCallback = { id in if id == .error { io.registers[.sr] = 2 } }
      io.driver.handleDMAEvent(.inputComplete)
      XCTAssertEqual(io.events, hmac ? [.error, .digestComplete] : [.error, .inputComplete, .digestComplete])
      XCTAssertEqual(io.words[.errorCode], hmac ? 0x82 : 0x84)
      XCTAssertEqual(io.trace.filter { $0 == .read(.sr) }.count, 1000)
      XCTAssertEqual(io.snapshots[0].words[.state], 1); XCTAssertEqual(io.snapshots[0].words[.lock], 0)
      XCTAssertEqual(io.snapshots[0].registers[.cr]! & 8, 0)
      XCTAssertEqual(io.words[.phase], 1); XCTAssertEqual(io.rawRead(0x4000), UInt32(0x1234_5600).byteSwapped)
      XCTAssertTrue(io.ticks.isEmpty)
    }
  }

  func testMultipleDMACompletionPreservesPhaseAndDMAEnableWithoutCallbacks() {
    for hmac in [false, true] {
      let io = HASHTestIO()
      io.words[.state] = 2; io.words[.lock] = 1; io.words[.phase] = hmac ? 4 : 2
      io.registers[.cr] = hmac ? 0x2048 : 0x2008
      io.driver.handleDMAEvent(.inputComplete)
      XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.lock], 0)
      XCTAssertEqual(io.words[.phase], hmac ? 4 : 2)
      XCTAssertEqual(io.words[.accumulation, default: 0], hmac ? 1 : 0)
      XCTAssertEqual(io.registers[.cr], hmac ? 0x2048 : 0x2008)
      XCTAssertTrue(io.events.isEmpty); XCTAssertTrue(io.memoryReads.isEmpty)
    }
  }

  func testDMAErrorDoesNotUnlockAndCallbackCanChangeFinalState() {
    let io = HASHTestIO(registered: true)
    io.words[.state] = 2; io.words[.lock] = 1; io.words[.phase] = 5; io.words[.errorCode] = 0x80
    io.onCallback = { id in if id == .error { io.words[.state] = 3; io.words[.errorCode] = 0x100 } }
    io.driver.handleDMAEvent(.error)
    XCTAssertEqual(io.events, [.error]); XCTAssertEqual(io.snapshots[0].words[.state], 1)
    XCTAssertEqual(io.snapshots[0].words[.lock], 1); XCTAssertEqual(io.snapshots[0].words[.errorCode], 0x82)
    XCTAssertEqual(io.words[.state], 3); XCTAssertEqual(io.words[.errorCode], 0x100)
    XCTAssertEqual(io.words[.phase], 5); XCTAssertTrue(io.mmio.isEmpty)
  }

  func testHMACDMAWaitsForBusySetAndTimeoutPrecedesDMASetup() {
    let timeout = HASHTestIO(); timeout.registers[.sr] = 2; timeout.words[.keySize] = 1
    XCTAssertEqual(timeout.driver.startHMACDMA(inputAddress: 0x1000, size: 8, outputAddress: 0x4000), .error)
    XCTAssertEqual(timeout.trace.filter { $0 == .read(.sr) }.count, 999)
    XCTAssertEqual(timeout.words[.errorCode], 4); XCTAssertEqual(timeout.words[.state], 1)
    XCTAssertEqual(timeout.words[.lock], 0); XCTAssertEqual(timeout.words[.phase], 3)
    XCTAssertTrue(timeout.dmaSlots.isEmpty); XCTAssertTrue(timeout.events.isEmpty)
    let io = HASHTestIO(); io.registers[.sr] = 8; io.words[.keySize] = 1
    XCTAssertEqual(io.driver.startHMACDMA(inputAddress: 0x1000, size: 5, outputAddress: 0x4000), .ok)
    XCTAssertEqual(io.inputWrites, [0xA0]); XCTAssertEqual(io.words[.phase], 4)
    XCTAssertTrue(io.trace.contains(.dmaStart(0x1000, 0x4802_0404, 8)))
    XCTAssertEqual(io.registers[.cr], 0x4C)
  }
}
