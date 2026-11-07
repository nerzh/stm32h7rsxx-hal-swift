import CICacheReference
import XCTest

@testable import STM32H7RSHAL

private final class ICacheDifferentialIO: ICacheRegisterIO {
  var storage = CICacheState()
  var cache: ICache<ICacheDifferentialIO> { .init(registers: self) }

  static func register(_ register: ICacheRegister) -> CICacheRegister {
    switch register {
    case .cr: return CICache_CR
    case .sr: return CICache_SR
    case .ier: return CICache_IER
    case .fcr: return CICache_FCR
    case .hmonr: return CICache_HMONR
    case .mmonr: return CICache_MMONR
    }
  }

  func read(_ register: ICacheRegister) -> UInt32 {
    // The unchanged C getters access these two volatile fields directly,
    // bypassing READ_REG. Keep that explicit instrumentation boundary.
    if register == .hmonr || register == .mmonr {
      return CICache_Get(&storage, Self.register(register))
    }
    return CICache_Read(&storage, Self.register(register))
  }
  func write(_ register: ICacheRegister, value: UInt32) {
    CICache_Write(&storage, Self.register(register), value)
  }
  func getTick() -> UInt32 { CICache_Tick(&storage) }

  func callback(_ id: UInt32) {
    let index = CICache_RecordCallback(&storage, id)
    let action = CICache_GetCallbackAction(&storage, id)
    var status = HALStatus.ok
    switch action.action {
    case 0: break
    case 1: status = cache.invalidateInterrupt()
    case 2:
      write(.sr, value: action.argument0)
      write(.ier, value: action.argument1)
    case 3: cache.clearFlag(action.argument0)
    case 4: cache.enableInterrupts(action.argument0)
    case 5: cache.disableInterrupts(action.argument0)
    case 6: status = cache.deinitialize()
    default: preconditionFailure("Unknown callback stimulus")
    }
    CICache_SetCallbackActionStatus(&storage, index, status.rawValue)
  }

  func call(_ operation: CICacheOperation, argument: UInt32) -> UInt32 {
    switch operation {
    case CICache_ConfigureAssociativity: return cache.configureAssociativity(argument).rawValue
    case CICache_Deinitialize: return cache.deinitialize().rawValue
    case CICache_Enable: return cache.enable().rawValue
    case CICache_Disable: return cache.disable(getTick: getTick).rawValue
    case CICache_IsEnabled: return cache.isEnabled()
    case CICache_Invalidate: return cache.invalidate(getTick: getTick).rawValue
    case CICache_InvalidateInterrupt: return cache.invalidateInterrupt().rawValue
    case CICache_WaitForInvalidateComplete:
      return cache.waitForInvalidateComplete(getTick: getTick).rawValue
    case CICache_StartMonitor: return cache.startMonitor(argument).rawValue
    case CICache_StopMonitor: return cache.stopMonitor(argument).rawValue
    case CICache_ResetMonitor: return cache.resetMonitor(argument).rawValue
    case CICache_GetHitValue: return cache.getHitValue()
    case CICache_GetMissValue: return cache.getMissValue()
    case CICache_HandleInterrupt:
      cache.handleInterrupt(
        error: { _ in self.callback(0) }, invalidateComplete: { _ in self.callback(1) })
    case CICache_EnableInterrupts: cache.enableInterrupts(argument)
    case CICache_DisableInterrupts: cache.disableInterrupts(argument)
    case CICache_GetInterruptSource: return cache.getInterruptSource(argument)
    case CICache_GetFlag: return cache.getFlag(argument)
    case CICache_ClearFlag: cache.clearFlag(argument)
    default: preconditionFailure("Unknown C operation")
    }
    return HALStatus.ok.rawValue
  }
}

final class ICacheDifferentialTests: XCTestCase {
  private func compare(
    _ actual: ICacheDifferentialIO, _ reference: ICacheDifferentialIO,
    file: StaticString = #filePath, line: UInt = #line
  ) {
    for index in UInt32(0)..<CICache_RegisterCount.rawValue {
      let register = CICacheRegister(rawValue: index)
      XCTAssertEqual(
        CICache_Get(&actual.storage, register), CICache_Get(&reference.storage, register),
        "register \(index)", file: file, line: line)
      XCTAssertEqual(
        CICache_GetReadCount(&actual.storage, register),
        CICache_GetReadCount(&reference.storage, register),
        "read count \(index)", file: file, line: line)
    }
    XCTAssertEqual(
      [actual.storage.tick, actual.storage.tickCalls],
      [reference.storage.tick, reference.storage.tickCalls],
      file: file, line: line)
    XCTAssertEqual(
      actual.storage.accessCount, reference.storage.accessCount, file: file, line: line)
    for index in UInt32(0)..<min(actual.storage.accessCount, reference.storage.accessCount) {
      let a = CICache_GetAccess(&actual.storage, index)
      let e = CICache_GetAccess(&reference.storage, index)
      XCTAssertEqual(
        [a.kind.rawValue, a.reg.rawValue, a.value, a.tickCall],
        [e.kind.rawValue, e.reg.rawValue, e.value, e.tickCall],
        "access \(index)", file: file, line: line)
    }
    XCTAssertEqual(
      actual.storage.callbackCount, reference.storage.callbackCount, file: file, line: line)
    for index in UInt32(0)..<min(actual.storage.callbackCount, reference.storage.callbackCount) {
      let a = CICache_GetCallbackEvent(&actual.storage, index)
      let e = CICache_GetCallbackEvent(&reference.storage, index)
      XCTAssertEqual(
        [a.callbackID, a.tickCall, a.accessCount, a.actionStatus],
        [e.callbackID, e.tickCall, e.accessCount, e.actionStatus],
        "callback \(index)", file: file, line: line)
      for word in UInt32(0)..<CICache_RegisterCount.rawValue {
        let register = CICacheRegister(rawValue: word)
        XCTAssertEqual(
          CICache_GetCallbackRegister(&actual.storage, index, register),
          CICache_GetCallbackRegister(&reference.storage, index, register),
          "callback \(index) register \(word)", file: file, line: line)
      }
    }
  }

  private func withPair(
    setup: (inout CICacheState) -> Void = { _ in },
    body: (ICacheDifferentialIO, ICacheDifferentialIO) -> Void
  ) {
    let actual = ICacheDifferentialIO()
    CICache_Reset(&actual.storage)
    setup(&actual.storage)
    let reference = ICacheDifferentialIO()
    reference.storage = actual.storage
    body(actual, reference)
  }

  @discardableResult
  private func run(
    _ operation: CICacheOperation, _ argument: UInt32 = 0,
    actual: ICacheDifferentialIO, reference: ICacheDifferentialIO,
    file: StaticString = #filePath, line: UInt = #line
  ) -> UInt32 {
    let a = actual.call(operation, argument: argument)
    let e = CICache_Call(&reference.storage, operation, argument)
    XCTAssertEqual(a, e, "operation \(operation.rawValue)", file: file, line: line)
    compare(actual, reference, file: file, line: line)
    return a
  }

  private func check(
    _ operation: CICacheOperation, _ argument: UInt32 = 0,
    expected: UInt32? = nil, setup: (inout CICacheState) -> Void = { _ in },
    file: StaticString = #filePath, line: UInt = #line
  ) {
    withPair(setup: setup) { actual, reference in
      let result = run(
        operation, argument, actual: actual, reference: reference, file: file, line: line)
      if let expected { XCTAssertEqual(result, expected, file: file, line: line) }
    }
  }

  func testAssociativityAndEnablePreserveUnrelatedBitsAndRejectEnabledCache() {
    for cr: UInt32 in [0, 1, 2, 3, 4, 5, 6, 7, 0xF0004, 0xA5A5_FFF8, .max] {
      for mode: UInt32 in [0, 4] {
        check(CICache_ConfigureAssociativity, mode, expected: cr & 1 == 0 ? 0 : 1) {
          CICache_Set(&$0, CICache_CR, cr)
        }
      }
      withPair(setup: { CICache_Set(&$0, CICache_CR, cr) }) { actual, reference in
        XCTAssertEqual(run(CICache_IsEnabled, actual: actual, reference: reference), cr & 1)
        run(CICache_Enable, actual: actual, reference: reference)
        XCTAssertEqual(run(CICache_IsEnabled, actual: actual, reference: reference), 1)
        XCTAssertEqual(CICache_Get(&actual.storage, CICache_CR), cr | 1)
      }
    }
  }

  func testDeinitializeAndAllMonitorSelectionsPreserveExactResetPulseOrder() {
    for seed: UInt32 in [0, 4, 0x30000, 0xC0000, 0xFFFF_FFFF, 0xA5A5_5A5A] {
      let setup: (inout CICacheState) -> Void = { state in
        for index in UInt32(0)..<CICache_RegisterCount.rawValue {
          CICache_Set(&state, CICacheRegister(rawValue: index), seed ^ (index &* 0x1010_1010))
        }
      }
      check(CICache_Deinitialize, expected: 0, setup: setup)
      for monitor: UInt32 in [0x10000, 0x20000, 0x30000] {
        withPair(setup: setup) { actual, reference in
          for operation in [CICache_StartMonitor, CICache_ResetMonitor, CICache_StopMonitor] {
            XCTAssertEqual(run(operation, monitor, actual: actual, reference: reference), 0)
          }
          run(CICache_GetHitValue, actual: actual, reference: reference)
          run(CICache_GetMissValue, actual: actual, reference: reference)
        }
      }
    }
  }

  func testCounterGettersReturnAll32BitsWithoutInventingDirectReadTrace() {
    for value: UInt32 in [0, 1, 0xFFFF, 0x10000, 0x8000_0000, .max] {
      for operation in [CICache_GetHitValue, CICache_GetMissValue] {
        check(operation, expected: value) {
          CICache_Set(&$0, CICache_HMONR, value)
          CICache_Set(&$0, CICache_MMONR, value)
        }
      }
    }
  }

  func testDisableWaitsForEnableBitWithDeadlineRecheckAndTickWrap() {
    for initialTick: UInt32 in [0, .max - 1, .max] {
      for step: UInt32 in [1, 2, 5] {
        for clearRead: UInt32 in 0...6 {
          check(CICache_Disable) { state in
            state.tick = initialTick
            state.tickStep = step
            CICache_Set(&state, CICache_CR, 0xA50F_0005)
            CICache_Set(&state, CICache_SR, 5)
            // The first read is the CLEAR_BIT RMW. Reassert EN on
            // the first polling read to model delayed disable.
            CICache_ScheduleRead(&state, 2, CICache_CR, 0, 1)
            if clearRead != 0 { CICache_ScheduleRead(&state, clearRead, CICache_CR, 1, 0) }
          }
        }
        for clearTick: UInt32 in 1...4 {
          check(CICache_Disable) { state in
            state.tick = initialTick
            state.tickStep = step
            CICache_Set(&state, CICache_CR, 5)
            CICache_ScheduleTick(&state, 1, CICache_CR, 0, 1)
            CICache_ScheduleTick(&state, clearTick, CICache_CR, 1, 0)
          }
        }
      }
    }
    check(CICache_Disable, expected: HALStatus.timeout.rawValue) {
      CICache_ScheduleRead(&$0, 2, CICache_CR, 0, 1)
    }
    check(CICache_Disable, expected: HALStatus.ok.rawValue) {
      CICache_ScheduleRead(&$0, 2, CICache_CR, 0, 1)
      CICache_ScheduleRead(&$0, 4, CICache_CR, 1, 0)
    }
  }

  func testWaitCompletionUsesBusyAtEntryAndBusyEndThereafterIncludingFinalRecheck() {
    for flags: UInt32 in 0...7 {
      check(CICache_WaitForInvalidateComplete, expected: flags & 3 == 1 ? 3 : 0) {
        CICache_Set(&$0, CICache_SR, flags)
        CICache_Set(&$0, CICache_FCR, .max)
      }
    }
    for initialTick: UInt32 in [0, .max - 1, .max] {
      for step: UInt32 in [1, 2, 5] {
        for completionRead: UInt32 in 2...6 {
          check(CICache_WaitForInvalidateComplete) { state in
            state.tick = initialTick
            state.tickStep = step
            CICache_Set(&state, CICache_SR, 5)
            CICache_ScheduleRead(&state, completionRead, CICache_SR, 1, 2)
          }
        }
        for completionTick: UInt32 in 1...4 {
          check(CICache_WaitForInvalidateComplete) { state in
            state.tick = initialTick
            state.tickStep = step
            CICache_Set(&state, CICache_SR, 5)
            CICache_ScheduleTick(&state, completionTick, CICache_SR, 1, 2)
          }
        }
      }
    }
    // Merely clearing BUSY during the wait never substitutes for BSYEND.
    check(CICache_WaitForInvalidateComplete, expected: 3) {
      CICache_Set(&$0, CICache_SR, 1)
      CICache_ScheduleRead(&$0, 2, CICache_SR, 1, 0)
    }
    check(CICache_WaitForInvalidateComplete, expected: 0) {
      CICache_Set(&$0, CICache_SR, 1)
      CICache_ScheduleRead(&$0, 4, CICache_SR, 1, 2)
    }
  }

  func testInvalidateLaunchOrExistingOperationAndInterruptBusyError() {
    for flags: UInt32 in 0...7 {
      for cr: UInt32 in [0, 1, 4, 0xA5A5_FFF5] {
        check(CICache_Invalidate) {
          CICache_Set(&$0, CICache_CR, cr)
          CICache_Set(&$0, CICache_SR, flags)
        }
        check(CICache_InvalidateInterrupt, expected: flags & 1 == 0 ? 0 : 1) {
          CICache_Set(&$0, CICache_CR, cr)
          CICache_Set(&$0, CICache_SR, flags)
          CICache_Set(&$0, CICache_IER, 0x8000_0004)
        }
        for completionRead: UInt32 in 3...7 {
          check(CICache_Invalidate) {
            CICache_Set(&$0, CICache_CR, cr)
            CICache_Set(&$0, CICache_SR, flags)
            CICache_ScheduleRead(&$0, 2, CICache_SR, 2, 1)
            CICache_ScheduleRead(&$0, completionRead, CICache_SR, 1, 2)
          }
        }
      }
    }
  }

  func testInterruptSnapshotMatrixAndUnrelatedRegisterBits() {
    for flags: UInt32 in 0...7 {
      for sources: UInt32 in 0...7 {
        withPair(setup: {
          CICache_Set(&$0, CICache_SR, flags | 0x8000_0000)
          CICache_Set(&$0, CICache_IER, sources | 0x4000_0000)
          CICache_Set(&$0, CICache_FCR, .max)
        }) { actual, reference in
          run(CICache_HandleInterrupt, actual: actual, reference: reference)
          XCTAssertEqual(
            actual.storage.callbackCount, UInt32((flags & sources & 6).nonzeroBitCount))
        }
      }
    }
  }

  func testCallbacksCanRearmOrMutateFreshIERWithoutChangingCachedPendingSources() {
    for flags: UInt32 in [2, 4, 6, 7] {
      for sources: UInt32 in [2, 4, 6] {
        for errorAction: UInt32 in 0...6 {
          for completeAction: UInt32 in 0...6 {
            check(CICache_HandleInterrupt) {
              CICache_Set(&$0, CICache_CR, 5)
              CICache_Set(&$0, CICache_SR, flags)
              CICache_Set(&$0, CICache_IER, sources | 0x8000_0000)
              CICache_SetCallbackAction(&$0, 0, errorAction, 0, 0x4000_0006)
              CICache_SetCallbackAction(&$0, 1, completeAction, 6, 0x2000_0004)
            }
          }
        }
      }
    }
    // Error callback removes both pending bits and all sources. The outer
    // handler still dispatches completion from its original SR/IER pair.
    withPair(setup: {
      CICache_Set(&$0, CICache_SR, 6)
      CICache_Set(&$0, CICache_IER, 6)
      CICache_SetCallbackAction(&$0, 0, 2, 0, 0)
    }) { actual, reference in
      run(CICache_HandleInterrupt, actual: actual, reference: reference)
      XCTAssertEqual(actual.storage.callbackCount, 2)
    }
    withPair(setup: {
      CICache_Set(&$0, CICache_SR, 2)
      CICache_Set(&$0, CICache_IER, 2)
      CICache_SetCallbackAction(&$0, 1, 1, 0, 0)
    }) { actual, reference in
      run(CICache_HandleInterrupt, actual: actual, reference: reference)
      XCTAssertEqual(CICache_Get(&actual.storage, CICache_IER), 2)
      XCTAssertEqual(CICache_Get(&actual.storage, CICache_CR) & 2, 2)
    }
  }

  func testPublicMacroHelpersPreserveAllBitsVsAnyBitPredicatesAndZeroMasks() {
    for value: UInt32 in [0, 1, 2, 3, 4, 6, 7, 0x8000_0000, .max] {
      for mask: UInt32 in [0, 1, 2, 4, 6, 7, 0x8000_0000, .max] {
        for operation in [
          CICache_EnableInterrupts, CICache_DisableInterrupts, CICache_GetInterruptSource,
          CICache_GetFlag, CICache_ClearFlag,
        ] {
          check(operation, mask) {
            CICache_Set(&$0, CICache_IER, value)
            CICache_Set(&$0, CICache_SR, value)
            CICache_Set(&$0, CICache_FCR, ~value)
          }
        }
      }
    }
  }

  func testDeterministicMixedOperationSequencesWithPersistentRegisterState() {
    var random: UInt32 = 0xCACE_1234
    let operations: [CICacheOperation] = [
      CICache_ConfigureAssociativity, CICache_Deinitialize, CICache_Enable,
      CICache_Disable, CICache_IsEnabled, CICache_Invalidate, CICache_InvalidateInterrupt,
      CICache_WaitForInvalidateComplete, CICache_StartMonitor, CICache_StopMonitor,
      CICache_ResetMonitor, CICache_GetHitValue, CICache_GetMissValue, CICache_HandleInterrupt,
      CICache_EnableInterrupts, CICache_DisableInterrupts, CICache_GetInterruptSource,
      CICache_GetFlag, CICache_ClearFlag,
    ]
    for _ in 0..<32 {
      withPair(setup: { state in
        for index in UInt32(0)..<CICache_RegisterCount.rawValue {
          random = random &* 1_664_525 &+ 1_013_904_223
          CICache_Set(&state, CICacheRegister(rawValue: index), random)
        }
        state.tick = .max - 2
      }) { actual, reference in
        for _ in 0..<16 {
          random = random &* 1_664_525 &+ 1_013_904_223
          let operation = operations[Int(random % UInt32(operations.count))]
          let argument: UInt32
          switch operation {
          case CICache_ConfigureAssociativity: argument = random & 4
          case CICache_StartMonitor, CICache_StopMonitor, CICache_ResetMonitor:
            argument = ((random % 3) + 1) << 16
          default: argument = random
          }
          run(operation, argument, actual: actual, reference: reference)
        }
      }
    }
  }
}
