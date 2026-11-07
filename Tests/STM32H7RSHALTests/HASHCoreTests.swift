import XCTest
@testable import STM32H7RSHAL

final class HASHCoreTests: XCTestCase {
  func testInitializationUsesMSPMutatedConfigurationAndPreservesUnrelatedFields() {
    for registered in [false, true] {
      let io = HASHTestIO(registered: registered, suspendEnabled: true)
      io.words[.state] = 0; io.words[.lock] = 1; io.words[.errorCode] = 0xAA
      io.words[.inputCount] = 17; io.words[.accumulation] = 1; io.words[.suspendRequest] = 1
      io.registers[.cr] = 0xFFFF_FFFF
      io.slots[.inputComplete] = hashTestCustom
      io.onCallback = { id in
        guard id == .mspInitialize else { return }
        XCTAssertEqual(io.words[.lock], 0)
        io.words[.dataType] = 0x10; io.words[.algorithm] = 0x001A_0000
      }
      XCTAssertEqual(io.driver.initialize(), .ok)
      XCTAssertEqual(io.registers[.cr], (0xFFFF_FFFF & ~0x001E_0034) | 0x001A_0010)
      XCTAssertEqual(io.events, [.mspInitialize])
      XCTAssertEqual(io.snapshots[0].words[.state], 0)
      XCTAssertEqual(io.words[.phase], 1); XCTAssertEqual(io.words[.state], 1)
      XCTAssertEqual(io.words[.errorCode], 0); XCTAssertEqual(io.words[.suspendRequest], 0)
      XCTAssertEqual(io.words[.inputCount], 17); XCTAssertEqual(io.words[.accumulation], 1)
      if registered { io.slots[.inputComplete]!(io.context); XCTAssertEqual(io.events.last, .inputComplete) }
      let count = io.events.count
      io.words[.lock] = 1
      XCTAssertEqual(io.driver.initialize(), .ok)
      XCTAssertEqual(io.events.count, count); XCTAssertEqual(io.words[.lock], 1)
    }
  }

  func testDeinitializationCallbackSeesOldStateLockAndResetCounters() {
    for registered in [false, true] {
      let io = HASHTestIO(registered: registered, suspendEnabled: true)
      io.words[.state] = 2; io.words[.lock] = 1; io.words[.errorCode] = 0x80
      io.words[.phase] = 5; io.words[.inputCount] = 47; io.words[.accumulation] = 1
      io.words[.suspendRequest] = 1; io.registers[.cr] = 0xDEAD_BEEF
      io.slots[.mspDeinitialize] = nil
      XCTAssertEqual(io.driver.deinitialize(), .ok)
      let snapshot = io.snapshots[0]
      XCTAssertEqual(snapshot.id, .mspDeinitialize)
      XCTAssertEqual(snapshot.words[.state], 2); XCTAssertEqual(snapshot.words[.lock], 1)
      XCTAssertEqual(snapshot.words[.phase], 1); XCTAssertEqual(snapshot.words[.inputCount], 0)
      XCTAssertEqual(snapshot.words[.accumulation], 0)
      XCTAssertEqual(io.words[.state], 0); XCTAssertEqual(io.words[.lock], 0)
      XCTAssertEqual(io.words[.errorCode], 0x80); XCTAssertEqual(io.words[.suspendRequest], 1)
      XCTAssertEqual(io.registers[.cr], 0xDEAD_BEEF); XCTAssertTrue(io.mmio.isEmpty)
    }
  }

  func testConfigurationNullBusyAndLockOrder() {
    let io = HASHTestIO()
    XCTAssertEqual(io.driver.setConfiguration(nil), .error)
    XCTAssertEqual(io.driver.getConfiguration(nil), .error)
    XCTAssertTrue(io.trace.isEmpty)
    let value = HASHConfiguration(dataType: 0x30, keySize: 71, keyAddress: 0x1234, algorithm: 0x60000)
    for get in [false, true] {
      io.trace = []; io.words[.state] = 1; io.words[.lock] = 1
      var output = HASHConfiguration()
      let status = get ? io.driver.getConfiguration(&output) : io.driver.setConfiguration(value)
      XCTAssertEqual(status, .busy)
      XCTAssertEqual(io.words[.state], 2)
      XCTAssertEqual(io.trace, [.handleRead(.state), .handleWrite(.state, 2), .handleRead(.lock)])
      XCTAssertEqual(output, HASHConfiguration())
    }
    io.words[.state] = 3; io.words[.errorCode] = 0x80
    XCTAssertEqual(io.driver.setConfiguration(value), .error)
    XCTAssertEqual(io.words[.errorCode], 0x81); XCTAssertEqual(io.words[.state], 3)
    io.words[.state] = 1; io.words[.lock] = 0; io.registers[.cr] = 0xFFFF_FFFF
    XCTAssertEqual(io.driver.setConfiguration(value), .ok)
    var output = HASHConfiguration()
    XCTAssertEqual(io.driver.getConfiguration(&output), .ok)
    XCTAssertEqual(output, value)
    XCTAssertEqual(io.words[.errorCode], 0); XCTAssertEqual(io.words[.state], 1)
    XCTAssertEqual(io.registers[.cr], (0xFFFF_FFFF & ~0x001E_0034) | 0x60030)
  }

  func testCallbackRegistrationStateMatrixNilAndResetMacro() {
    for state: UInt32 in [0, 1, 2, 3, 0x1234] {
      for id: UInt32 in 0...5 {
        for unregister in [false, true] {
          let io = HASHTestIO(registered: true)
          io.words[.state] = state; io.words[.lock] = 1; io.words[.errorCode] = 0x80
          let valid = id < 5 && (state == 1 || (state == 0 && id < 2))
          let result = unregister ? io.driver.unregisterCallback(id: id)
            : io.driver.registerCallback(id: id, callback: hashTestCustom)
          XCTAssertEqual(result, valid ? .ok : .error)
          XCTAssertEqual(io.words[.errorCode], valid ? 0x80 : 0x90)
          XCTAssertEqual(io.words[.lock], 1)
          XCTAssertFalse(io.trace.contains(.handleRead(.lock)))
          if valid, !unregister { io.slots[HASHCallbackID(rawValue: id)!]!(io.context); XCTAssertEqual(io.customCalls, 1) }
        }
      }
    }
    let io = HASHTestIO(registered: true)
    XCTAssertEqual(io.driver.registerCallback(id: 0, callback: nil), .error)
    XCTAssertFalse(io.trace.contains(.handleRead(.state)))
    io.trace = []; io.driver.resetHandleState()
    XCTAssertEqual(io.trace, [.handleWrite(.state, 0), .callbackWrite(.mspInitialize, false),
      .callbackWrite(.mspDeinitialize, false)])
    XCTAssertNotNil(io.slots[.inputComplete]); XCTAssertEqual(io.words[.errorCode], 0x10)
  }

  func testExportedMacrosKeepAllBitMatchAndCRThreshold() {
    let io = HASHTestIO()
    io.registers[.sr] = 1; io.registers[.cr] = 0x1000; io.registers[.imr] = 1
    XCTAssertEqual(io.driver.getFlag(0), 1)
    XCTAssertEqual(io.driver.getFlag(1), 1); XCTAssertEqual(io.driver.getFlag(3), 0)
    XCTAssertEqual(io.driver.getFlag(0x1000), 1)
    XCTAssertEqual(io.driver.getInterruptSource(3), 0)
    XCTAssertEqual(io.driver.getInterruptSource(0), 1)
    io.driver.enableInterrupts(0x82); XCTAssertEqual(io.registers[.imr], 0x83)
    io.driver.disableInterrupts(2); XCTAssertEqual(io.registers[.imr], 0x81)
    io.driver.clearFlag(1); XCTAssertEqual(io.registers[.sr], 0)
    io.driver.enableMultipleDMATransfers(); XCTAssertEqual(io.registers[.cr], 0x3000)
    io.driver.disableMultipleDMATransfers(); XCTAssertEqual(io.registers[.cr], 0x1000)
    XCTAssertEqual(io.driver.getState(), 1); XCTAssertEqual(io.driver.getError(), 0)
  }

  func testDataWritesPreserveEveryTailWidthAndRoundedInputCount() {
    for type: UInt32 in [0, 0x10, 0x20, 0x30] {
      for size: UInt32 in 0...11 {
        let io = HASHTestIO(); io.words[.dataType] = type
        io.words[.inputCount] = 0xFFFF_FFFC
        io.driver.writeData(inputAddress: 0x1000, size: size)
        var reads: [HASHTestAccess] = []
        var values: [UInt32] = []
        for index in 0..<(size / 4) {
          let address = 0x1000 + index * 4
          reads.append(.memoryRead(4, address)); values.append(io.rawRead(address))
        }
        let remainder = size % 4, address = 0x1000 + (size / 4) * 4
        if remainder != 0 {
          if type == 0 || (type == 0x10 && remainder == 3) {
            reads.append(.memoryRead(4, address)); values.append(io.rawRead(address))
          } else if type == 0x10 || remainder == 2 {
            reads.append(.memoryRead(2, address)); values.append(io.rawRead(address, width: 2))
          } else {
            for offset in 0..<remainder { reads.append(.memoryRead(1, address + offset)) }
            values.append(io.rawRead(address, width: Int(remainder)))
          }
        }
        XCTAssertEqual(io.memoryReads, reads, "datatype=\(type), size=\(size)")
        XCTAssertEqual(io.inputWrites, values)
        XCTAssertEqual(io.words[.inputCount], 0xFFFF_FFFC &+ ((size + 3) / 4) * 4)
      }
    }
  }

  func testDigestLengthRepeatedReadsBanksByteOrderAndAddressWrap() {
    let algorithms: [(UInt32, UInt8)] = [(0, 20), (0x40000, 28), (0x60000, 32),
      (0x180000, 48), (0x1A0000, 28), (0x1C0000, 32), (0x1E0000, 64), (0x20000, 20)]
    for (index, item) in algorithms.enumerated() {
      let io = HASHTestIO(); io.registers[.cr] = item.0
      XCTAssertEqual(io.driver.digestLength(), item.1)
      XCTAssertEqual(io.mmio, Array(repeating: .read(.cr), count: min(index + 1, 7)))
      io.trace = []; io.driver.getDigest(outputAddress: 0xFFFF_FFF8, size: item.1)
      var expected: [HASHTestAccess] = []
      for word in 0..<(Int(item.1) / 4) {
        let register: HASHRegister = word < 5 ? .hr(index: word) : .digest(index: word)
        expected += [.read(register), .memoryWrite(0xFFFF_FFF8 &+ UInt32(word * 4),
          (0x1234_5600 + UInt32(word)).byteSwapped)]
      }
      XCTAssertEqual(io.trace, expected)
    }
    let io = HASHTestIO(); io.driver.getDigest(outputAddress: 0x4000, size: 24)
    XCTAssertTrue(io.trace.isEmpty)
  }

  func testTimeoutStrictBoundaryWrapAndNoFinalRecheck() {
    for start: UInt32 in [0, 0xFFFF_FFFE] {
      let io = HASHTestIO(); io.registers[.sr] = 0
      io.words[.state] = 2; io.words[.lock] = 1; io.words[.errorCode] = 0x80
      io.tick = start
      io.onTick = { if io.ticks.count == 4 { io.registers[.sr] = 2 } }
      XCTAssertEqual(io.driver.waitOnFlagUntilTimeout(2, status: 0, timeout: 2, getTick: io.getTick), .error)
      XCTAssertEqual(io.ticks, [start, start &+ 1, start &+ 2, start &+ 3])
      XCTAssertEqual(io.trace.filter { $0 == .read(.sr) }.count, 3)
      XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.lock], 0)
      XCTAssertEqual(io.words[.errorCode], 0x84)
      XCTAssertEqual(Array(io.trace.suffix(4)), [.handleWrite(.state, 1), .handleRead(.errorCode),
        .handleWrite(.errorCode, 0x84), .handleWrite(.lock, 0)])
    }
    let io = HASHTestIO(); io.scriptedReads[.sr] = [0, 0, 2]
    XCTAssertEqual(io.driver.waitOnFlagUntilTimeout(2, status: 0, timeout: .max, getTick: io.getTick), .ok)
    XCTAssertEqual(io.ticks, [0])
    io.trace = []; io.registers[.sr] = 0; io.tickStep = 0
    XCTAssertEqual(io.driver.waitOnFlagUntilTimeout(2, status: 0, timeout: 0, getTick: io.getTick), .error)
    XCTAssertEqual(io.ticks.count, 2)
  }
}
