import XCTest
@testable import STM32H7RSHAL

final class HASHInterruptTests: XCTestCase {
  func testIRQBetweenInterruptEnableAndInitialFeedPreservesCBusyErrorRace() {
    for registered in [false, true] {
      let io = HASHTestIO(registered: registered)
      var interrupted = false
      io.onWrite = { register, value in
        if register == .imr && value == 3 && !interrupted {
          interrupted = true
          io.driver.handleInterrupt()
        }
      }
      XCTAssertEqual(io.driver.startInterrupt(inputAddress: 0x1000, size: 0, outputAddress: 0x4000), .ok)
      XCTAssertEqual(io.events, [.digestComplete, .error])
      XCTAssertEqual(io.snapshots[0].words[.state], 1); XCTAssertEqual(io.snapshots[0].words[.lock], 0)
      XCTAssertEqual(io.snapshots[1].words[.errorCode], 1)
      XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.phase], 1)
      XCTAssertEqual(io.words[.errorCode], 1); XCTAssertEqual(io.registers[.imr], 0)
      XCTAssertTrue(io.inputWrites.isEmpty)
    }
  }

  func testInterruptFeedsPartialBlocksWithFullWordTailAndSeparateDigestCallback() {
    for registered in [false, true] {
      let io = HASHTestIO(registered: registered)
      io.registers[.sr] = 0x0002_0001
      XCTAssertEqual(io.driver.startInterrupt(inputAddress: 0x1000, size: 11, outputAddress: 0x4000), .ok)
      XCTAssertEqual(io.inputWrites, [0x0403_0201, 0x0807_0605])
      XCTAssertEqual(io.words[.inputCount], 8); XCTAssertEqual(io.words[.inputAddress], 0x1008)
      XCTAssertEqual(io.words[.state], 2); XCTAssertEqual(io.words[.lock], 1)
      io.onWrite = { register, value in
        if register == .str && value & 0x100 != 0 { io.registers[.sr] = 2 }
      }
      io.driver.handleInterrupt()
      XCTAssertEqual(io.inputWrites, [0x0403_0201, 0x0807_0605, 0x0C0B_0A09])
      XCTAssertEqual(io.memoryReads, [.memoryRead(4, 0x1000), .memoryRead(4, 0x1004), .memoryRead(4, 0x1008)])
      XCTAssertEqual(io.words[.inputCount], 12); XCTAssertEqual(io.words[.inputAddress], 0x100C)
      XCTAssertEqual(io.events, [.inputComplete])
      XCTAssertEqual(io.snapshots[0].words[.state], 2); XCTAssertEqual(io.snapshots[0].words[.lock], 1)
      io.driver.handleInterrupt()
      XCTAssertEqual(io.events, [.inputComplete, .digestComplete])
      XCTAssertEqual(io.snapshots[1].words[.state], 1); XCTAssertEqual(io.snapshots[1].words[.lock], 0)
      XCTAssertEqual(io.words[.phase], 1); XCTAssertEqual(io.registers[.imr], 0)
      XCTAssertTrue(io.ticks.isEmpty)
    }
  }

  func testDigestIRQIgnoresEnableAndUsesCachedStatusAcrossReentry() {
    let io = HASHTestIO(registered: true)
    io.words[.state] = 2; io.words[.lock] = 1; io.words[.phase] = 2
    io.registers[.imr] = 0; io.registers[.sr] = 3
    io.onCallback = { id in
      guard id == .digestComplete else { return }
      io.registers[.sr] = 0x0001_0001
      XCTAssertEqual(io.driver.startInterrupt(inputAddress: 0x1000, size: 8, outputAddress: 0x4100), .ok)
    }
    io.driver.handleInterrupt()
    XCTAssertEqual(io.events, [.digestComplete])
    XCTAssertEqual(io.inputWrites, [0x0403_0201])
    XCTAssertEqual(io.words[.state], 2); XCTAssertEqual(io.words[.lock], 1)
    XCTAssertEqual(io.words[.inputCount], 4); XCTAssertEqual(io.words[.outputAddress], 0x4100)
  }

  func testInputCallbackCanAlterAccumulationBeforeFreshBranchRead() {
    let io = HASHTestIO(registered: true)
    io.registers[.sr] = 0x0001_0003
    io.onCallback = { id in if id == .inputComplete { io.words[.accumulation] = 1 } }
    XCTAssertEqual(io.driver.startInterrupt(inputAddress: 0x1000, size: 1, outputAddress: 0x4000), .ok)
    XCTAssertEqual(io.events, [.inputComplete])
    XCTAssertEqual(io.inputWrites, [0x0403_0201])
    XCTAssertEqual(io.words[.accumulation], 0); XCTAssertEqual(io.registers[.imr], 2)
    XCTAssertEqual(io.registers[.str], 8)
    XCTAssertEqual(io.words[.state], 2); XCTAssertEqual(io.words[.lock], 1)
  }

  func testInterruptTimeoutHasExactly999PollReadsAndNoTickCalls() {
    let io = HASHTestIO(); io.registers[.sr] = 0
    io.words[.errorCode] = 0x80
    XCTAssertEqual(io.driver.startInterrupt(inputAddress: 0x1000, size: 4, outputAddress: 0x4000), .error)
    XCTAssertEqual(io.trace.filter { $0 == .read(.sr) }.count, 1000)
    XCTAssertEqual(io.registers[.imr], 0); XCTAssertEqual(io.words[.errorCode], 0x84)
    XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.lock], 0)
    XCTAssertTrue(io.events.isEmpty); XCTAssertTrue(io.ticks.isEmpty)
    let irq = HASHTestIO(); irq.words[.state] = 2; irq.words[.size] = 4
    irq.words[.lock] = 1; irq.registers[.imr] = 1; irq.registers[.sr] = 0
    irq.scriptedReads[.sr] = [1, 0]
    irq.driver.handleInterrupt()
    XCTAssertEqual(irq.events, [.error])
    XCTAssertEqual(irq.snapshots[0].words[.errorCode], 4)
    XCTAssertEqual(irq.snapshots[0].words[.state], 1); XCTAssertEqual(irq.snapshots[0].words[.lock], 0)
  }

  func testSuspendRequestOnlyAppliesToHashOrHMACInputStep() {
    for hmac in [false, true] {
      let io = HASHTestIO(suspendEnabled: true)
      io.words[.state] = 2; io.words[.lock] = 1; io.words[.size] = 8
      io.words[.suspendRequest] = 1; io.words[.phase] = hmac ? 4 : 2
      io.registers[.cr] = hmac ? 0x40 : 0; io.registers[.imr] = 0x83
      XCTAssertEqual(io.driver.writeDataInterrupt(), .ok)
      XCTAssertEqual(io.words[.suspendRequest], 0); XCTAssertEqual(io.words[.state], 3)
      XCTAssertEqual(io.words[.lock], 0); XCTAssertEqual(io.registers[.imr], 0x80)
      XCTAssertTrue(io.inputWrites.isEmpty); XCTAssertTrue(io.events.isEmpty)
      io.trace = []; io.registers[.sr] = 0x0002_0003
      let status = hmac
        ? io.driver.startHMACInterrupt(inputAddress: 0xDEAD, size: 100, outputAddress: 0xBEEF)
        : io.driver.startInterrupt(inputAddress: 0xDEAD, size: 100, outputAddress: 0xBEEF)
      XCTAssertEqual(status, .ok)
      XCTAssertEqual(io.words[.inputAddress], 0x1008)
      XCTAssertEqual(io.words[.outputAddress], 0x4000); XCTAssertEqual(io.words[.size], 8)
    }
    let io = HASHTestIO(suspendEnabled: true)
    io.words[.state] = 2; io.words[.phase] = 3; io.words[.suspendRequest] = 1
    io.registers[.cr] = 0x40
    XCTAssertEqual(io.driver.writeDataInterrupt(), .ok)
    XCTAssertEqual(io.words[.state], 2); XCTAssertEqual(io.words[.suspendRequest], 1)
    XCTAssertEqual(io.words[.phase], 4)
  }

  func testHMACInterruptKeyMessageKeyStateMachineAndAsymmetricKeyCursor() {
    for registered in [false, true] {
      let io = HASHTestIO(registered: registered)
      io.registers[.sr] = 0x0010_0003
      io.words[.keySize] = 3
      XCTAssertEqual(io.driver.startHMACInterrupt(inputAddress: 0x1000, size: 5, outputAddress: 0x4000), .ok)
      XCTAssertEqual(io.inputWrites, [0xA3A2_A1A0])
      XCTAssertEqual(io.words[.phase], 4); XCTAssertEqual(io.words[.inputCount], 0)
      XCTAssertEqual(io.words[.keyBufferAddress], 0x2004)
      io.registers[.sr] = 0x0010_0001
      io.driver.handleInterrupt()
      XCTAssertEqual(io.inputWrites, [0xA3A2_A1A0, 0x0403_0201, 0x0807_0605])
      XCTAssertEqual(io.events, [.inputComplete])
      XCTAssertEqual(io.words[.phase], 5); XCTAssertEqual(io.words[.keyBufferAddress], 0x2000)
      io.onWrite = { register, value in
        if register == .str && value & 0x100 != 0 { io.registers[.sr] = 2 }
      }
      io.driver.handleInterrupt()
      XCTAssertEqual(io.inputWrites.last, 0xA3A2_A1A0)
      XCTAssertEqual(io.words[.keyBufferAddress], 0x2000)
      XCTAssertEqual(io.words[.inputCount], 4); XCTAssertEqual(io.words[.phase], 5)
      io.driver.handleInterrupt()
      XCTAssertEqual(io.events, [.inputComplete, .digestComplete])
      XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.lock], 0)
    }
  }

  func testInterruptAccumulationPublicWrappersAndFinalCallStateQuirks() {
    let io = HASHTestIO()
    io.registers[.sr] = 0x0010_0003
    XCTAssertEqual(io.driver.accumulateInterrupt(inputAddress: 0x1000, size: 4), .ok)
    XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.phase], 2)
    XCTAssertEqual(io.words[.lock], 0); XCTAssertEqual(io.registers[.imr], 0)
    XCTAssertEqual(io.words[.accumulation], 0)
    XCTAssertEqual(io.driver.accumulateLastInterrupt(inputAddress: 0x1004, size: 3, outputAddress: 0x4000), .ok)
    XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.phase], 1)
    XCTAssertEqual(io.words[.lock], 0); XCTAssertEqual(io.registers[.imr], 3)
    let hmac = HASHTestIO(); hmac.words[.keySize] = 4; hmac.registers[.sr] = 0x0010_0003
    XCTAssertEqual(hmac.driver.accumulateHMACInterrupt(inputAddress: 0x1000, size: 4), .ok)
    XCTAssertEqual(hmac.words[.phase], 4); XCTAssertEqual(hmac.words[.accumulation], 1)
    hmac.registers[.sr] = 0x0010_0001; hmac.driver.handleInterrupt()
    XCTAssertEqual(hmac.words[.state], 1); XCTAssertEqual(hmac.words[.lock], 0)
    XCTAssertEqual(hmac.words[.phase], 4); XCTAssertEqual(hmac.words[.accumulation], 1)
    hmac.registers[.sr] = 0x0010_0003
    XCTAssertEqual(hmac.driver.accumulateHMACLastInterrupt(inputAddress: 0x1004, size: 1, outputAddress: 0x4000), .ok)
    XCTAssertEqual(hmac.words[.state], 2); XCTAssertEqual(hmac.words[.phase], 4)
    XCTAssertEqual(hmac.words[.accumulation], 0)
    // The previous helper cleared IMR, so the last wrapper enables it only
    // after the helper returns; it does not enter HMAC step 3 in this call.
    XCTAssertEqual(hmac.registers[.imr], 3)
  }

  func testUnexpectedStateReportsBusyCallbackButReturnsOK() {
    let io = HASHTestIO(); io.words[.errorCode] = 0x80
    XCTAssertEqual(io.driver.writeDataInterrupt(), .ok)
    XCTAssertEqual(io.events, [.error]); XCTAssertEqual(io.words[.errorCode], 0x81)
    io.words[.state] = 3; io.trace = []; io.snapshots = []
    XCTAssertEqual(io.driver.writeDataInterrupt(), .ok)
    XCTAssertTrue(io.events.isEmpty); XCTAssertTrue(io.inputWrites.isEmpty)
  }

  func testZeroPartialWordCountPerformsNoFeedWhileInputReadyIsSet() {
    let io = HASHTestIO(); io.registers[.sr] = 3
    XCTAssertEqual(io.driver.startInterrupt(inputAddress: 0x1000, size: 4, outputAddress: 0x4000), .ok)
    XCTAssertTrue(io.inputWrites.isEmpty); XCTAssertTrue(io.events.isEmpty)
    XCTAssertEqual(io.words[.inputAddress], 0x1000); XCTAssertEqual(io.words[.inputCount], 0)
    XCTAssertEqual(io.words[.state], 2); XCTAssertEqual(io.words[.lock], 1)
  }
}
