import XCTest

@testable import STM32H7RSHAL

private final class UARTConfigurationClock: UARTClockIO {
  var selected: UARTClockSource = .pclk1
  var hertz: UInt32 = 48_000_000
  var sourceCalls: [UARTInstance] = []
  var frequencyCalls: [UARTClockSource] = []
  func source(for instance: UARTInstance) -> UARTClockSource {
    sourceCalls.append(instance)
    return selected
  }
  func frequency(_ source: UARTClockSource) -> UInt32 {
    frequencyCalls.append(source)
    return hertz
  }
}

final class UARTConfigurationTests: XCTestCase {
  private func fixture(_ instance: UARTInstance = .usart3, registered: Bool = false)
    -> UARTDMAFixture
  {
    let io = UARTDMAFixture(instance: instance, registered: registered)
    io.setConfiguration(.init())
    io.registers[.isr] = 0x600000
    return io
  }

  func testAllPrescalersAndBothSamplingModesUseOriginalIntegerRounding() {
    let expected16: [UInt32] = [5000, 2500, 1250, 833, 625, 500, 417, 313, 156, 78, 39, 20]
    let expected8: [UInt32] = [10000, 4996, 2498, 1665, 1249, 996, 832, 624, 308, 150, 71, 35]
    for instance in UARTInstance.allCases where !instance.isLowPower {
      for (sampling, expected) in [(UInt32(0), expected16), (UInt32(0x8000), expected8)] {
        for prescaler in UInt32(0)...11 {
          let io = fixture(instance)
          io.configuration[.baudRate] = 9600
          io.configuration[.clockPrescaler] = prescaler
          io.configuration[.overSampling] = sampling
          io.registers[.cr1] = .max
          io.registers[.cr2] = .max
          io.registers[.cr3] = .max
          io.registers[.presc] = .max
          io.words[.fifoMode] = 0x2000_0000
          io.words[.rxISR] = 4
          io.words[.txISR] = 3
          let clocks = UARTConfigurationClock()
          XCTAssertEqual(io.uart.setConfiguration(clocks: clocks), .ok)
          XCTAssertEqual(io.registers[.brr], expected[Int(prescaler)])
          XCTAssertEqual(io.registers[.cr1], (~UInt32(0x3000_960C)) | 0xC | sampling)
          XCTAssertEqual(io.registers[.cr3], ~UInt32(0xEE00_0B00))
          XCTAssertEqual(io.registers[.presc], 0xFFFF_FFF0 | prescaler)
          XCTAssertEqual(io.words[.fifoMode], 0x2000_0000, "SetConfig clears hardware FIFOEN only")
          XCTAssertEqual(io.halves[.txDataToProcess], 1)
          XCTAssertEqual(io.halves[.rxDataToProcess], 1)
          XCTAssertEqual(io.words[.rxISR], 0)
          XCTAssertEqual(io.words[.txISR], 0)
          XCTAssertEqual(clocks.sourceCalls, [instance])
          XCTAssertEqual(clocks.frequencyCalls, [.pclk1])
        }
      }
    }
  }

  func testClockSourceErrorsKeepEarlierWritesAndRecognizedZeroClockSkipsBRR() {
    for instance in [UARTInstance.usart1, .usart3, .lpuart1] {
      for source in [
        UARTClockSource.pclk1, .pclk2, .pclk4, .pll2Q, .pll3Q, .hsi, .csi, .lse, .undefined,
      ] {
        for frequency: UInt32 in [0, 48_000_000] {
          let io = fixture(instance)
          io.registers[.brr] = 0x1234_5678
          let clocks = UARTConfigurationClock()
          clocks.selected = source
          clocks.hertz = frequency
          let valid =
            source != .undefined
            && (instance.isLowPower
              ? source != .pclk1 && source != .pclk2 : source != .pclk4)
          XCTAssertEqual(io.uart.setConfiguration(clocks: clocks), valid ? .ok : .error)
          XCTAssertEqual(clocks.frequencyCalls, valid ? [source] : [])
          if !valid || frequency == 0 { XCTAssertEqual(io.registers[.brr], 0x1234_5678) }
          XCTAssertEqual(
            io.registerWrites.prefix(4),
            [
              .write(.cr1, 0xC), .write(.cr2, 0), .write(.cr3, 0), .write(.presc, 0),
            ])
        }
      }
    }
  }

  func testLPUARTUsesUInt64RoundingBoundsAndUInt32RangeProductWrap() {
    let cases: [(UInt32, UInt32, HALStatus, UInt32)] = [
      (48_000_000, 115_200, .ok, 106667),
      (2_999, 1_000, .error, 0xABC),
      (3_000, 1_000, .ok, 0x300),
      (4_096_000, 1_000, .error, 0xABC),
      (4_095_995, 1_000, .ok, 0xFFFFF),
      (3_145_728, 1_048_576, .error, 0xABC),
    ]
    for (frequency, baud, status, brr) in cases {
      let io = fixture(.lpuart1)
      io.configuration[.baudRate] = baud
      io.configuration[.oneBitSampling] = .max  // Not checked or applied for LPUART.
      io.registers[.brr] = 0xABC
      let clocks = UARTConfigurationClock()
      clocks.selected = .pclk4
      clocks.hertz = frequency
      XCTAssertEqual(io.uart.setConfiguration(clocks: clocks), status)
      XCTAssertEqual(io.registers[.brr], brr)
      XCTAssertEqual(io.registers[.cr3], 0)
    }
  }

  func testAdvancedFeatureSelectionAndExactInversionBits() {
    let io = fixture()
    io.setAdvancedConfiguration(
      .init(
        features: 0xFF, txPinLevelInvert: 0x20000, rxPinLevelInvert: 0x10000,
        dataInvert: 0x40000, swap: 0x8000, overrunDisable: 0x1000,
        dmaDisableOnReceiveError: 0x2000, autoBaudRateEnable: 0x100000,
        autoBaudRateMode: 0x600000, mostSignificantBitFirst: 0x80000))
    io.uart.configureAdvancedFeatures()
    XCTAssertEqual(
      io.registerWrites,
      [
        .write(.cr2, 0x8000), .write(.cr2, 0x28000), .write(.cr2, 0x38000),
        .write(.cr2, 0x78000), .write(.cr3, 0x1000), .write(.cr3, 0x3000),
        .write(.cr2, 0x178000), .write(.cr2, 0x778000), .write(.cr2, 0x7F8000),
      ])
    io.trace.removeAll()
    io.advanced[.features] = 0x40
    io.advanced[.autoBaudRateEnable] = 0
    io.uart.configureAdvancedFeatures()
    XCTAssertEqual(io.registerWrites, [.write(.cr2, 0x6F8000)])
    io.trace.removeAll()
    io.advanced[.features] = 0
    io.uart.configureAdvancedFeatures()
    XCTAssertEqual(io.registerEffects, [])
  }

  func testMSPHookMutatesSharedConfigurationBeforeInitializationForBothCallbackModes() {
    for registered in [false, true] {
      let io = fixture(registered: registered)
      io.words[.globalState] = 0
      io.words[.receiveState] = 0
      io.words[.lock] = 1
      io.callbackSlots[.transmitComplete] = io.defaults.error
      let retainedMSP = io.defaults.mspInitialize
      io.callbackSlots[.mspInitialize] = retainedMSP
      io.onCallback = { id in
        if id == .mspInitialize {
          XCTAssertEqual(io.words[.globalState], 0)
          XCTAssertEqual(io.words[.lock], 0)
          io.configuration[.baudRate] = 1_000_000
          io.advanced[.features] = 1
          io.advanced[.txPinLevelInvert] = 0x20000
        }
      }
      XCTAssertEqual(io.uart.initialize(clocks: UARTConfigurationClock(), getTick: io.getTick), .ok)
      XCTAssertEqual(io.events, [.callback(.mspInitialize)])
      XCTAssertEqual(io.registers[.brr], 48)
      XCTAssertEqual(io.registers[.cr2], 0x20000)
      XCTAssertEqual(io.words[.globalState], 0x20)
      XCTAssertEqual(io.words[.receiveState], 0x20)
      XCTAssertEqual(io.words[.lock], 0)
      if registered {
        XCTAssertEqual(
          unsafeBitCast(io.callbackSlots[.transmitComplete]!, to: UInt.self),
          unsafeBitCast(io.defaults.transmitComplete, to: UInt.self))
        XCTAssertEqual(
          unsafeBitCast(io.callbackSlots[.mspInitialize]!, to: UInt.self),
          unsafeBitCast(retainedMSP, to: UInt.self))
      }
    }
  }

  func testAllInitializationModesAndEarlyLINValidation() {
    let clocks = UARTConfigurationClock()
    let half = fixture()
    half.registers[.cr2] = 0x4800
    half.registers[.cr3] = 0x22
    XCTAssertEqual(half.uart.initializeHalfDuplex(clocks: clocks, getTick: half.getTick), .ok)
    XCTAssertEqual(half.registers[.cr2], 0)
    XCTAssertEqual(half.registers[.cr3], 8)
    let lin = fixture()
    XCTAssertEqual(
      lin.uart.initializeLIN(breakDetectLength: 0x20, clocks: clocks, getTick: lin.getTick), .ok)
    XCTAssertEqual(lin.registers[.cr2], 0x4020)
    for (word, sampling) in [(UInt32(0), UInt32(0x8000)), (UInt32(0x1000), UInt32(0))] {
      let invalid = fixture()
      invalid.configuration[.wordLength] = word
      invalid.configuration[.overSampling] = sampling
      XCTAssertEqual(
        invalid.uart.initializeLIN(breakDetectLength: 0, clocks: clocks, getTick: invalid.getTick),
        .error)
      XCTAssertEqual(invalid.trace, [])
    }
    for wakeup: UInt32 in [0, 0x800] {
      let multi = fixture()
      multi.registers[.cr2] = 0x5500_0000
      XCTAssertEqual(
        multi.uart.initializeMultiProcessor(
          address: 0xAB, wakeupMethod: wakeup,
          clocks: clocks, getTick: multi.getTick), .ok)
      XCTAssertEqual(multi.registers[.cr2], wakeup == 0 ? 0x5500_0000 : 0xAB00_0000)
      XCTAssertEqual(multi.registers[.cr1], 0xD | wakeup)
    }
    let rs485 = fixture(.lpuart1)
    clocks.selected = .pclk4
    XCTAssertEqual(
      rs485.uart.initializeRS485(
        polarity: 0x8000, assertionTime: 31, deassertionTime: 17,
        clocks: clocks, getTick: rs485.getTick), .ok)
    XCTAssertEqual(rs485.registers[.cr3], 0xC000)
    XCTAssertEqual(rs485.registers[.cr1], 0x03F1_000D)
  }

  func testFailedConfigurationRetainsBusyAndDisabledPeripheral() {
    let io = fixture()
    io.registers[.cr1] = 1
    io.words[.receiveState] = 0x22
    let clocks = UARTConfigurationClock()
    clocks.selected = .undefined
    XCTAssertEqual(io.uart.initialize(clocks: clocks, getTick: io.getTick), .error)
    XCTAssertEqual(io.words[.globalState], 0x24)
    XCTAssertEqual(io.words[.receiveState], 0x22)
    XCTAssertEqual(io.registers[.cr1], 0xC)
    XCTAssertEqual(io.tickCalls, 0)
  }

  func testIdleAcknowledgementTimeoutCleansOnlyTheMatchingDirection() {
    for mode: UInt32 in [8, 4] {
      let io = fixture()
      io.words[.globalState] = 0x24
      io.words[.receiveState] = 0x22
      io.words[.lock] = 1
      io.words[.errorCode] = 0x55
      io.registers[.cr1] = mode | 0x1A0
      io.registers[.cr3] = 1
      io.registers[.isr] = 0
      io.tickStep = 0x0200_0000
      XCTAssertEqual(io.uart.checkIdleState(getTick: io.getTick), .timeout)
      XCTAssertEqual(io.tickCalls, 2)
      XCTAssertEqual(io.words[.errorCode], 0)
      XCTAssertEqual(io.words[.lock], 0)
      XCTAssertEqual(io.words[.globalState], mode == 8 ? 0x20 : 0x24)
      XCTAssertEqual(io.words[.receiveState], mode == 4 ? 0x20 : 0x22)
      XCTAssertEqual(
        io.registerWrites,
        mode == 8
          ? [.atomic(.cr1, 0x80, 0)]
          : [
            .atomic(.cr1, 0x120, 0), .atomic(.cr3, 1, 0),
          ])
    }
  }

  func testDeinitializePreservesTransferMetadataAndMSPObservesBusy() {
    for registered in [false, true] {
      let io = fixture(registered: registered)
      io.prepareBusy()
      io.callbackSlots[.mspDeinitialize] = nil
      XCTAssertEqual(io.uart.deinitialize(), .ok)
      XCTAssertEqual(io.registerWrites, [.write(.cr1, 0), .write(.cr2, 0), .write(.cr3, 0)])
      XCTAssertEqual(io.events, [.callback(.mspDeinitialize)])
      XCTAssertEqual(io.snapshots[0].globalState, 0x24)
      XCTAssertEqual(io.snapshots[0].receiveState, 0x22)
      XCTAssertEqual(io.words[.globalState], 0)
      XCTAssertEqual(io.words[.receiveState], 0)
      XCTAssertEqual(io.halves[.transmitCount], 9)
      XCTAssertEqual(io.halves[.receiveCount], 7)
      XCTAssertEqual(io.words[.rxISR], 3)
      XCTAssertNotNil(io.pointers[.receive])
    }
  }

  func testControlFunctionsKeepSourceLockRulesAndAtomicOperationBoundaries() {
    let io = fixture()
    io.words[.lock] = 1
    XCTAssertEqual(io.uart.enableTransmitter(), .busy)
    XCTAssertEqual(io.uart.enableReceiverTimeout(), .busy)
    XCTAssertEqual(io.registerEffects, [])
    io.words[.lock] = 0
    XCTAssertEqual(io.uart.enableTransmitter(), .ok)
    XCTAssertEqual(io.uart.enableReceiver(), .ok)
    XCTAssertEqual(
      io.registerWrites,
      [
        .atomic(.cr1, 0xC, 0), .atomic(.cr1, 0, 8),
        .atomic(.cr1, 0xC, 0), .atomic(.cr1, 0, 4),
      ])
    io.trace.removeAll()
    XCTAssertEqual(io.uart.enableMuteMode(getTick: io.getTick), .ok)
    XCTAssertEqual(io.uart.disableMuteMode(getTick: io.getTick), .ok)
    io.uart.enterMuteMode()
    XCTAssertEqual(io.uart.sendBreak(), .ok)
    XCTAssertEqual(
      io.registerWrites,
      [
        .atomic(.cr1, 0, 0x2000), .atomic(.cr1, 0x2000, 0), .write(.rqr, 4), .write(.rqr, 6),
      ])
    io.registers[.rtor] = 0xAB00_0000
    io.uart.configureReceiverTimeout(0x123456)
    XCTAssertEqual(io.registers[.rtor], 0xAB12_3456)
    XCTAssertEqual(io.uart.enableReceiverTimeout(), .ok)
    XCTAssertEqual(io.uart.disableReceiverTimeout(), .ok)
    let low = fixture(.lpuart1)
    low.uart.configureReceiverTimeout(.max)
    XCTAssertEqual(low.uart.enableReceiverTimeout(), .error)
    XCTAssertEqual(low.uart.disableReceiverTimeout(), .error)
    XCTAssertEqual(low.trace, [])
  }

  func testPublicRegisterMacrosPreserveRawEncodingsAndSharedFlowConfiguration() {
    let io = fixture()
    io.uart.enableCTS()
    io.uart.enableRTS()
    XCTAssertEqual(io.configuration[.hardwareFlowControl], 0x300)
    io.uart.disableCTS()
    io.uart.disableRTS()
    XCTAssertEqual(io.configuration[.hardwareFlowControl], 0)
    io.uart.enableOneBitSampling()
    io.uart.disableOneBitSampling()
    io.uart.flushDataRegisters()
    io.uart.sendRequest(0xABCD_0001)
    XCTAssertEqual(io.registers[.rqr], 0x19)
    for (encoding, register, bit): (UInt32, UARTRegister, UInt32) in [
      (0x0626, .cr1, 0x40), (0x0846, .cr2, 0x40), (0x0060, .cr3, 1),
    ] {
      io.uart.enableInterrupt(encoding)
      XCTAssertEqual(io.uart.getInterruptSource(encoding), 1)
      XCTAssertEqual(io.registers[register, default: 0] & bit, bit)
      io.uart.disableInterrupt(encoding)
      XCTAssertEqual(io.uart.getInterruptSource(encoding), 0)
    }
    io.registers[.isr] = 0x40
    XCTAssertEqual(io.uart.getInterrupt(0x0626), 1)
    XCTAssertEqual(io.uart.getFlag(0xC0), 0)
    XCTAssertEqual(io.uart.getFlag(0), 1)
    io.uart.clearFlag(0x40)
    XCTAssertEqual(io.registers[.isr], 0)
    io.words[.globalState] = 0x21
    io.words[.receiveState] = 0x22
    XCTAssertEqual(io.uart.getState(), 0x23)
  }
}
