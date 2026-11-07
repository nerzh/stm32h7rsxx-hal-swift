import XCTest
@testable import STM32H7RSHAL

private enum DTSAccess: Equatable {
  case read(DTSRegister), write(DTSRegister, UInt32), state(DTSHandleWord, UInt32)
  case configuration(DTSConfigurationWord, UInt32)
  case callbackRead(DTSCallbackID), callbackWrite(DTSCallbackID, Bool), callback(DTSCallbackID)
  case tick(UInt32), delay(UInt32), pclk
  case extiRead(EXTIRegister), extiWrite(EXTIRegister, UInt32)
}
private struct DTSCallbackSnapshot {
  let id: DTSCallbackID
  let state, lock, configuration, interrupts, flags: UInt32
}
private func dtsTestObject(_ context: UnsafeMutableRawPointer?) -> DTSTestIO {
  Unmanaged<DTSTestIO>.fromOpaque(context!).takeUnretainedValue()
}
private func dtsTestEnd(_ context: UnsafeMutableRawPointer?) { dtsTestObject(context).record(.measureComplete) }
private func dtsTestAsyncEnd(_ context: UnsafeMutableRawPointer?) { dtsTestObject(context).record(.asyncMeasureComplete) }
private func dtsTestLow(_ context: UnsafeMutableRawPointer?) { dtsTestObject(context).record(.lowThreshold) }
private func dtsTestAsyncLow(_ context: UnsafeMutableRawPointer?) { dtsTestObject(context).record(.asyncLowThreshold) }
private func dtsTestHigh(_ context: UnsafeMutableRawPointer?) { dtsTestObject(context).record(.highThreshold) }
private func dtsTestAsyncHigh(_ context: UnsafeMutableRawPointer?) { dtsTestObject(context).record(.asyncHighThreshold) }
private func dtsTestMSPInit(_ context: UnsafeMutableRawPointer?) { dtsTestObject(context).record(.mspInitialize) }
private func dtsTestMSPDeinit(_ context: UnsafeMutableRawPointer?) { dtsTestObject(context).record(.mspDeinitialize) }
private func dtsTestCustom(_ context: UnsafeMutableRawPointer?) { dtsTestObject(context).customCalls += 1 }

private final class DTSTestIO: DTSRegisterIO, DTSHandleIO, DTSCallbackIO, EXTIRegisterIO {
  var registers: [DTSRegister: UInt32] = [.rampvalr: 100, .t0valr1: 10_000, .sr: 0x8000]
  var configuration: [DTSConfigurationWord: UInt32] = [:]
  var words: [DTSHandleWord: UInt32] = [.lock: 0xA5, .state: 0]
  var slots: [DTSCallbackID: DTSCallback] = [:]
  var exti: [EXTIRegister: UInt32] = [:]
  var trace: [DTSAccess] = []
  var snapshots: [DTSCallbackSnapshot] = []
  var scriptedReads: [DTSRegister: [UInt32]] = [:]
  var onRead: ((DTSRegister) -> Void)?
  var onCallback: ((DTSCallbackID) -> Void)?
  var onTick: ((UInt32) -> Void)?
  var onDelay: ((UInt32) -> Void)?
  var tick: UInt32 = 0
  var tickStep: UInt32 = 1
  var pclk: UInt32 = 48_000_000
  var registered: Bool
  var customCalls = 0
  init(registered: Bool = false) {
    self.registered = registered
    setConfiguration(.init())
    for id in DTSCallbackID.allCases { slots[id] = defaults.callback(id) }
    trace = []
  }
  var context: UnsafeMutableRawPointer? { Unmanaged.passUnretained(self).toOpaque() }
  var defaults: DTSCallbackDefaults {
    .init(measureComplete: dtsTestEnd, asyncMeasureComplete: dtsTestAsyncEnd,
      lowThreshold: dtsTestLow, asyncLowThreshold: dtsTestAsyncLow,
      highThreshold: dtsTestHigh, asyncHighThreshold: dtsTestAsyncHigh,
      mspInitialize: dtsTestMSPInit, mspDeinitialize: dtsTestMSPDeinit)
  }
  var dts: DTS<DTSTestIO, DTSTestIO, DTSTestIO> {
    .init(registers: self, handle: self, callbacks: self, defaults: defaults,
      useRegisteredCallbacks: registered)
  }
  var registerTrace: [DTSAccess] {
    trace.filter { switch $0 { case .read, .write: return true; default: return false } }
  }
  var events: [DTSCallbackID] { snapshots.map(\.id) }
  func read(_ register: DTSRegister) -> UInt32 {
    trace.append(.read(register)); onRead?(register)
    if scriptedReads[register]?.isEmpty == false { return scriptedReads[register]!.removeFirst() }
    return registers[register, default: 0]
  }
  func write(_ register: DTSRegister, value: UInt32) {
    trace.append(.write(register, value)); registers[register] = value
    if register == .icifr { registers[.sr, default: 0] &= ~value }
  }
  func read(_ word: DTSConfigurationWord) -> UInt32 { configuration[word, default: 0] }
  func write(_ word: DTSConfigurationWord, value: UInt32) {
    trace.append(.configuration(word, value)); configuration[word] = value
  }
  func read(_ word: DTSHandleWord) -> UInt32 { words[word, default: 0] }
  func write(_ word: DTSHandleWord, value: UInt32) {
    trace.append(.state(word, value)); words[word] = value
  }
  func read(_ id: DTSCallbackID) -> DTSCallback? { trace.append(.callbackRead(id)); return slots[id] }
  func write(_ id: DTSCallbackID, value: DTSCallback?) {
    trace.append(.callbackWrite(id, value != nil)); slots[id] = value
  }
  func read(_ register: EXTIRegister) -> UInt32 {
    trace.append(.extiRead(register)); return exti[register, default: 0]
  }
  func write(_ register: EXTIRegister, value: UInt32) {
    trace.append(.extiWrite(register, value)); exti[register] = value
  }
  func record(_ id: DTSCallbackID) {
    trace.append(.callback(id))
    snapshots.append(.init(id: id, state: words[.state, default: 0], lock: words[.lock, default: 0],
      configuration: registers[.cfgr1, default: 0], interrupts: registers[.itenr, default: 0],
      flags: registers[.sr, default: 0]))
    onCallback?(id)
  }
  func getTick() -> UInt32 {
    let value = tick; tick &+= tickStep; trace.append(.tick(value)); onTick?(value); return value
  }
  func delay(_ milliseconds: UInt32) { trace.append(.delay(milliseconds)); onDelay?(milliseconds) }
  func getPCLK1Frequency() -> UInt32 { trace.append(.pclk); return pclk }
}

final class DTSTests: XCTestCase {
  func testInitializationMMIOOrderAndAllUnrelatedBits() {
    let io = DTSTestIO()
    io.setConfiguration(.init(triggerInput: 0x400, samplingTime: 0xF0000,
      divider: 47, highThreshold: 0xABCD, lowThreshold: 0x1234))
    io.words[.state] = 1
    io.registers[.cfgr1] = .max; io.registers[.itr1] = .max
    io.trace = []
    XCTAssertEqual(io.dts.initialize(), .ok)
    XCTAssertEqual(io.registerTrace, [
      .read(.rampvalr), .read(.t0valr1),
      .read(.cfgr1), .write(.cfgr1, 0xFFDF_FFFF),
      .read(.cfgr1), .write(.cfgr1, 0xFFCF_FFFF),
      .read(.cfgr1), .write(.cfgr1, 0xAFCF_FFFF),
      .read(.cfgr1), .write(.cfgr1, 0xAFCF_FFFF),
      .read(.cfgr1), .write(.cfgr1, 0xAFCF_F4FF),
      .read(.itr1), .write(.itr1, 0xABCD_FFFF),
      .read(.itr1), .write(.itr1, 0xABCD_1234)])
    XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.lock], 0xA5)
    XCTAssertTrue(io.events.isEmpty)
  }

  func testInitializationUsesMSPUpdatedConfigurationAndPreservesLock() {
    for registered in [false, true] {
      let io = DTSTestIO(registered: registered)
      io.slots[.mspInitialize] = nil
      io.onCallback = { id in
        if id == .mspInitialize {
          XCTAssertEqual(io.words[.state], 0)
          io.setConfiguration(.init(quickMeasure: 0x200000, referenceClock: 0x100000,
            triggerInput: 0x300, samplingTime: 0x90000, divider: 200,
            highThreshold: 0x8888, lowThreshold: 0x2222))
        }
      }
      XCTAssertEqual(io.dts.initialize(), .ok)
      XCTAssertEqual(io.registers[.cfgr1], 0xC839_0300)
      XCTAssertEqual(io.registers[.itr1], 0x8888_2222)
      XCTAssertEqual(io.words[.lock], 0xA5)
      XCTAssertEqual(io.events, [.mspInitialize])
      if registered {
        XCTAssertEqual(Array(io.trace.prefix(6)), [
          .callbackWrite(.measureComplete, true), .callbackWrite(.lowThreshold, true),
          .callbackWrite(.highThreshold, true), .callbackWrite(.asyncMeasureComplete, true),
          .callbackWrite(.asyncLowThreshold, true), .callbackWrite(.asyncHighThreshold, true)])
      }
    }
  }

  func testInitializationCalibrationFailuresLeaveBusyEvenInQuickMode() {
    for failedRegister in [DTSRegister.rampvalr, .t0valr1] {
      let io = DTSTestIO()
      io.configuration[.quickMeasure] = 0x200000; io.configuration[.referenceClock] = 0x100000
      io.registers[failedRegister] = 0
      XCTAssertEqual(io.dts.initialize(), .error)
      XCTAssertEqual(io.words[.state], 2)
      XCTAssertEqual(io.words[.lock], 0xA5)
      XCTAssertEqual(io.registerTrace, failedRegister == .rampvalr ? [.read(.rampvalr)] : [.read(.rampvalr), .read(.t0valr1)])
    }
    let io = DTSTestIO()
    io.configuration[.quickMeasure] = 0x200000
    XCTAssertEqual(io.dts.initialize(), .error)
    XCTAssertEqual(io.words[.state], 2)
    XCTAssertEqual(io.registerTrace, [.read(.rampvalr), .read(.t0valr1)])
    let reserved = DTSTestIO()
    reserved.registers[.rampvalr] = 0x10000; reserved.registers[.t0valr1] = 0x10000
    XCTAssertEqual(reserved.dts.initialize(), .ok)
  }

  func testInitializationDoesNotCheckDividerExceptPCLKWithCalibration() {
    for quick: UInt32 in [0, 0x200000] {
      for divider: UInt32 in [0, 127, 128, 255, .max] {
        let io = DTSTestIO()
        io.configuration[.quickMeasure] = quick; io.configuration[.referenceClock] = 0x100000
        io.configuration[.divider] = divider
        XCTAssertEqual(io.dts.initialize(), .ok)
        XCTAssertEqual(io.registers[.cfgr1]! & 0xFF00_0000, divider << 24)
      }
    }
  }

  func testDeinitializeOnlyClearsConfigurationThenMSPBeforeReset() {
    for registered in [false, true] {
      let io = DTSTestIO(registered: registered)
      io.words[.state] = 4; io.registers[.cfgr1] = .max; io.registers[.itenr] = 0x77
      io.slots[.mspDeinitialize] = nil
      XCTAssertEqual(io.dts.deinitialize(), .ok)
      XCTAssertEqual(io.registerTrace, [.write(.cfgr1, 0)])
      XCTAssertEqual(io.events, [.mspDeinitialize])
      XCTAssertEqual(io.snapshots.first?.state, 4)
      XCTAssertEqual(io.snapshots.first?.configuration, 0)
      XCTAssertEqual(io.words[.state], 0); XCTAssertEqual(io.words[.lock], 0xA5)
      XCTAssertEqual(io.registers[.itenr], 0x77)
    }
  }

  func testStartStopRejectNonReadyStatesWithoutAccessOrOutputChanges() {
    for state: UInt32 in [0, 2, 3, 4, .max] {
      let io = DTSTestIO(); io.words[.state] = state
      var temperature: Int32 = -123
      XCTAssertEqual(io.dts.start(getTick: io.getTick, delay: io.delay), .busy)
      XCTAssertEqual(io.dts.startInterrupt(getTick: io.getTick, delay: io.delay), .busy)
      XCTAssertEqual(io.dts.stop(), .busy); XCTAssertEqual(io.dts.stopInterrupt(), .busy)
      XCTAssertEqual(io.dts.getTemperature(&temperature, getPCLK1Frequency: io.getPCLK1Frequency), .busy)
      XCTAssertEqual(temperature, -123)
      XCTAssertTrue(io.trace.isEmpty)
      XCTAssertEqual(io.dts.getState(), state)
    }
  }

  func testStartUsesRegisterTriggerAndDelayWhileBusy() {
    for interrupt in [false, true] {
      for clock: UInt32 in [0, 0x100000] {
        for trigger in DTSTrigger.allCases {
          let io = DTSTestIO(); io.words[.state] = 1
          io.configuration[.referenceClock] = clock
          io.configuration[.triggerInput] = trigger == .none ? 0x400 : 0
          io.registers[.cfgr1] = 0x8000_0000 | trigger.rawValue
          io.registers[.itenr] = 0x8000_0000
          io.onDelay = { delay in XCTAssertEqual(delay, 5); XCTAssertEqual(io.words[.state], 2) }
          XCTAssertEqual(interrupt ? io.dts.startInterrupt(getTick: io.getTick, delay: io.delay)
            : io.dts.start(getTick: io.getTick, delay: io.delay), .ok)
          XCTAssertEqual(io.registers[.cfgr1], 0x8000_0001 | trigger.rawValue | (trigger == .none ? 0x10 : 0))
          XCTAssertEqual(io.registers[.itenr], interrupt ? 0x8000_0000 | (clock == 0 ? 7 : 0x70) : 0x8000_0000)
          XCTAssertEqual(io.trace.filter { if case .delay = $0 { return true }; return false }, trigger == .none ? [.delay(5)] : [])
          XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.lock], 0xA5)
        }
      }
    }
  }

  func testStartTimeoutStrictBoundaryWrapAndNoLateFlagRecheck() {
    for interrupt in [false, true] {
      for initial: UInt32 in [0, .max] {
        for readyAt: UInt32 in [1, 2, 3] {
          let io = DTSTestIO(); io.words[.state] = 1; io.registers[.sr] = 0; io.tick = initial
          io.onTick = { tick in if tick &- initial == readyAt { io.registers[.sr] = 0x8000 } }
          let result = interrupt ? io.dts.startInterrupt(getTick: io.getTick, delay: io.delay)
            : io.dts.start(getTick: io.getTick, delay: io.delay)
          XCTAssertEqual(result, readyAt == 1 ? .ok : .timeout)
          XCTAssertEqual(io.words[.state], readyAt == 1 ? 1 : 2)
          XCTAssertEqual(io.trace.filter { $0 == .read(.sr) }.count, 2)
          XCTAssertEqual(io.trace.filter { if case .delay = $0 { return true }; return false }.count, readyAt == 1 ? 1 : 0)
          XCTAssertEqual(io.registers[.cfgr1]! & 1, 1)
          if interrupt { XCTAssertEqual(io.registers[.itenr]! & 7, 7) }
        }
      }
    }
  }

  func testStopOrderUsesCurrentReferenceClockAndPreservesOtherInterruptGroup() {
    for interrupt in [false, true] {
      for clock: UInt32 in [0, 0x100000] {
        for trigger: UInt32 in [0, 0x400] {
          let io = DTSTestIO(); io.words[.state] = 1; io.configuration[.referenceClock] = clock
          io.registers[.itenr] = 0xFFFF_FFFF; io.registers[.cfgr1] = 0xA000_0011 | trigger
          XCTAssertEqual(interrupt ? io.dts.stopInterrupt() : io.dts.stop(), .ok)
          var expected: [DTSAccess] = []
          if interrupt { expected += [.read(.itenr), .write(.itenr, .max & ~(clock == 0 ? 7 : UInt32(0x70)))] }
          expected += [.read(.cfgr1)]
          if trigger == 0 { expected += [.read(.cfgr1), .write(.cfgr1, 0xA000_0001)] }
          expected += [.read(.cfgr1), .write(.cfgr1, trigger == 0 ? 0xA000_0000 : 0xA000_0410)]
          XCTAssertEqual(io.registerTrace, expected)
          XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.lock], 0xA5)
        }
      }
    }
  }

  func testTemperatureFactorySelectionSignedDivisionAndExactReadOrder() {
    for factory: UInt32 in [0, 1] {
      for delta: Int32 in [-101, -100, -99, 0, 99, 100, 101] {
        let io = DTSTestIO(); io.words[.state] = 1
        io.registers[.dr] = 1; io.registers[.t0valr1] = (factory << 16) | 10_000
        io.pclk = UInt32(Int32(1_000_000) + delta)
        var temperature: Int32 = .min
        XCTAssertEqual(io.dts.getTemperature(&temperature, getPCLK1Frequency: io.getPCLK1Frequency), .ok)
        XCTAssertEqual(temperature, (factory == 0 ? 30 : 130) + delta / 100)
        XCTAssertEqual(io.trace, [.state(.state, 2), .read(.dr), .pclk,
          .read(.t0valr1), .read(.t0valr1), .read(.rampvalr), .state(.state, 1)])
        XCTAssertEqual(io.words[.lock], 0xA5)
      }
    }
  }

  func testTemperatureLSEAndUnsignedProductWrappingAndFreshFactoryReads() {
    let lse = DTSTestIO(); lse.words[.state] = 1
    lse.configuration[.referenceClock] = 0x100000; lse.configuration[.samplingTime] = 0x30000
    lse.registers[.dr] = 0xFFFF_001E; lse.registers[.t0valr1] = 0x10000 | 3200
    lse.registers[.rampvalr] = 0xFFFF_0064
    var temperature: Int32 = 0
    XCTAssertEqual(lse.dts.getTemperature(&temperature, getPCLK1Frequency: lse.getPCLK1Frequency), .ok)
    XCTAssertEqual(temperature, 206)
    XCTAssertFalse(lse.trace.contains(.pclk))

    let wrapped = DTSTestIO(); wrapped.words[.state] = 1
    wrapped.configuration[.samplingTime] = 0xF0000; wrapped.pclk = 600_000_000
    wrapped.registers[.dr] = 100; wrapped.registers[.t0valr1] = 40_000
    wrapped.registers[.rampvalr] = 100
    XCTAssertEqual(wrapped.dts.getTemperature(&temperature, getPCLK1Frequency: wrapped.getPCLK1Frequency), .ok)
    XCTAssertEqual(temperature, 1036)

    let fresh = DTSTestIO(); fresh.words[.state] = 1; fresh.registers[.dr] = 1
    fresh.pclk = 2_000_000; fresh.scriptedReads[.t0valr1] = [0, 20_000]
    XCTAssertEqual(fresh.dts.getTemperature(&temperature, getPCLK1Frequency: fresh.getPCLK1Frequency), .ok)
    XCTAssertEqual(temperature, 30)
  }

  func testTemperatureErrorBranchesPreserveOutputAndRestoreReady() {
    for failure in 0..<5 {
      let io = DTSTestIO(); io.words[.state] = 1; io.registers[.dr] = 1
      switch failure {
      case 0: io.configuration[.samplingTime] = 0
      case 1: io.registers[.dr] = 0x10000
      case 2: io.registers[.t0valr1] = 0x20000
      case 3: io.registers[.t0valr1] = 0x8000_0001
      default: io.registers[.rampvalr] = 0x10000
      }
      var temperature: Int32 = -456
      XCTAssertEqual(io.dts.getTemperature(&temperature, getPCLK1Frequency: io.getPCLK1Frequency), .error)
      XCTAssertEqual(temperature, -456)
      XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.lock], 0xA5)
      if failure < 2 { XCTAssertEqual(io.registerTrace, [.read(.dr)]) }
      if failure == 2 || failure == 3 { XCTAssertEqual(io.registerTrace, [.read(.dr), .read(.t0valr1)]) }
    }
  }

  func testTemperaturePreservesTargetWidthAtSignedAndLSEOverflowBoundaries() {
    let signed = DTSTestIO(); signed.words[.state] = 1; signed.registers[.dr] = 1
    signed.pclk = 0x8000_0000
    var temperature: Int32 = 0
    XCTAssertEqual(signed.dts.getTemperature(&temperature, getPCLK1Frequency: signed.getPCLK1Frequency), .ok)
    XCTAssertEqual(temperature, 21_464_866)
    signed.pclk = 0xF000_0000
    XCTAssertEqual(signed.dts.getTemperature(&temperature, getPCLK1Frequency: signed.getPCLK1Frequency), .ok)
    XCTAssertEqual(temperature, -2_694_324)
    let lse = DTSTestIO(); lse.words[.state] = 1; lse.registers[.dr] = 3
    lse.configuration[.referenceClock] = 0x100000; lse.configuration[.samplingTime] = 0x20000
    XCTAssertEqual(lse.dts.getTemperature(&temperature, getPCLK1Frequency: lse.getPCLK1Frequency, lseValue: .max), .ok)
    XCTAssertEqual(temperature, 21_464_866)
    XCTAssertFalse(lse.trace.contains(.pclk))
  }

  func testIRQAllFlagCombinationsIgnoresEnableAndReadsSRFreshSixTimes() {
    let masks: [UInt32] = [0x10, 0x20, 0x40, 1, 2, 4]
    let ids: [DTSCallbackID] = [.asyncMeasureComplete, .asyncLowThreshold, .asyncHighThreshold,
      .measureComplete, .lowThreshold, .highThreshold]
    for registered in [false, true] {
      for bits in 0..<64 {
        let io = DTSTestIO(registered: registered)
        io.registers[.sr] = (0..<6).reduce(UInt32(0x8000)) { $0 | (bits & (1 << $1) != 0 ? masks[$1] : 0) }
        io.registers[.itenr] = 0
        io.dts.handleInterrupt()
        XCTAssertEqual(io.events, (0..<6).filter { bits & (1 << $0) != 0 }.map { ids[$0] })
        XCTAssertEqual(io.trace.filter { $0 == .read(.sr) }.count, 6)
        XCTAssertFalse(io.trace.contains(.read(.itenr)))
        XCTAssertEqual(io.registers[.sr], 0x8000)
        XCTAssertEqual(io.words[.state], 0); XCTAssertEqual(io.words[.lock], 0xA5)
        for snapshot in io.snapshots {
          XCTAssertEqual(snapshot.flags & masks[ids.firstIndex(of: snapshot.id)!], 0)
        }
      }
    }
  }

  func testIRQCallbackCanSetLaterFlagClearPendingFlagAndReenter() {
    let io = DTSTestIO(registered: true)
    io.registers[.sr] = 0x10 | 0x40
    io.onCallback = { id in
      if id == .asyncMeasureComplete {
        io.registers[.sr] = 0x20 | 1
        io.dts.handleInterrupt()
      }
    }
    io.dts.handleInterrupt()
    XCTAssertEqual(io.events, [.asyncMeasureComplete, .asyncLowThreshold, .measureComplete])
    XCTAssertEqual(io.trace.filter { $0 == .read(.sr) }.count, 12)
    XCTAssertEqual(io.registers[.sr], 0)
  }

  func testCallbackRegistrationStatesIDsNilAndDefaultRestoration() {
    for state: UInt32 in [0, 1, 2, 3, 4, .max] {
      for rawID: UInt32 in 0...9 {
        for hasCallback in [false, true] {
          let io = DTSTestIO(registered: true); io.words[.state] = state
          let accepted = rawID < 8 && (state == 1 || (state == 0 && rawID >= 6))
          XCTAssertEqual(io.dts.registerCallback(id: rawID, callback: hasCallback ? dtsTestCustom : nil),
            accepted && hasCallback ? .ok : .error)
          XCTAssertEqual(io.dts.unregisterCallback(id: rawID), accepted ? .ok : .error)
          if accepted {
            let id = DTSCallbackID(rawValue: rawID)!
            XCTAssertEqual(unsafeBitCast(io.slots[id]!, to: UInt.self),
              unsafeBitCast(io.defaults.callback(id), to: UInt.self))
          }
          XCTAssertEqual(io.words[.state], state); XCTAssertEqual(io.words[.lock], 0xA5)
          XCTAssertTrue(io.registerTrace.isEmpty)
        }
      }
    }
  }

  func testResetHandleOnlyResetsStateAndRegisteredMSPSlots() {
    for registered in [false, true] {
      let io = DTSTestIO(registered: registered); io.words[.state] = 4
      io.dts.resetHandleState()
      XCTAssertEqual(io.words[.state], 0); XCTAssertEqual(io.words[.lock], 0xA5)
      for id in DTSCallbackID.allCases {
        if registered && (id == .mspInitialize || id == .mspDeinitialize) { XCTAssertNil(io.slots[id]) }
        else { XCTAssertNotNil(io.slots[id]) }
      }
    }
  }

  func testExportedMacrosUseAllBitsComparisonAndPreserveSourceEXTIBank() {
    var io = DTSTestIO()
    io.registers[.cfgr1] = 0xA010_0300; io.registers[.sr] = 0x13; io.registers[.itenr] = 0x13
    XCTAssertEqual(io.dts.getFlag(0), 1); XCTAssertEqual(io.dts.getFlag(0x11), 1)
    XCTAssertEqual(io.dts.getFlag(7), 0)
    XCTAssertEqual(io.dts.getInterruptSource(0x11), 1); XCTAssertEqual(io.dts.getInterruptSource(7), 0)
    XCTAssertEqual(io.dts.getReferenceClock(0), 1); XCTAssertEqual(io.dts.getReferenceClock(0x100000), 1)
    XCTAssertEqual(io.dts.getTrigger(), 0x300)
    io.dts.enable(); io.dts.disable()
    XCTAssertEqual(io.registers[.cfgr1], 0xA010_0300)
    io.dts.enableInterrupts(0x40); io.dts.disableInterrupts(2)
    XCTAssertEqual(io.registers[.itenr], 0x51)
    io.exti[.interruptMask(bank: 1)] = 0xA000_0001
    io.exti[.eventMask(bank: 1)] = 0xB000_0002
    io.exti[.interruptMask(bank: 2)] = .max
    io.trace = []
    let driver = io.dts
    driver.enableWakeupInterrupt(registers: &io); driver.disableWakeupInterrupt(registers: &io)
    driver.enableWakeupEvent(registers: &io); driver.disableWakeupEvent(registers: &io)
    XCTAssertEqual(io.trace, [
      .extiRead(.interruptMask(bank: 1)), .extiWrite(.interruptMask(bank: 1), 0xA000_2001),
      .extiRead(.interruptMask(bank: 1)), .extiWrite(.interruptMask(bank: 1), 0xA000_0001),
      .extiRead(.eventMask(bank: 1)), .extiWrite(.eventMask(bank: 1), 0xB000_2002),
      .extiRead(.eventMask(bank: 1)), .extiWrite(.eventMask(bank: 1), 0xB000_0002)])
    XCTAssertEqual(io.exti[.interruptMask(bank: 2)], .max)
  }
}
