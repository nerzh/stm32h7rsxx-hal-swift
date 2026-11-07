import XCTest
import CGFXTIMReference
import STM32H7RSHAL

final class GFXTIMConstantsTests: XCTestCase {
    func testEveryPublicEncodingMatchesThePinnedCHeader() {
        var values: [UInt32] = []
        values += GFXTIMSynchronizationSource.allCases.map(\.rawValue)
        values += GFXTIMTearingEffectSource.allCases.map(\.rawValue)
        values += GFXTIMTearingEffectPolarity.allCases.map(\.rawValue)
        values += GFXTIMLineCounterReloadSource.allCases.map(\.rawValue)
        values += GFXTIMLineCounterClock.allCases.map(\.rawValue)
        values += GFXTIMLineClockSource.allCases.map(\.rawValue)
        values += GFXTIMFrameCounterReloadSource.allCases.map(\.rawValue)
        values += GFXTIMFrameCounterClock.allCases.map(\.rawValue)
        values += GFXTIMFrameClockSource.allCases.map(\.rawValue)
        values += GFXTIMAbsoluteTime.allCases.map(\.rawValue)
        values += GFXTIMAbsoluteLineComparator.allCases.map(\.rawValue)
        values += GFXTIMCounterMode.allCases.map(\.rawValue)
        values += GFXTIMRelativeTimer.allCases.map(\.rawValue)
        values += GFXTIMLineEvent.allCases.map(\.rawValue)
        values += GFXTIMFrameEvent.allCases.map(\.rawValue)
        values += GFXTIMEventGenerator.allCases.map(\.rawValue)
        values += GFXTIMWatchdogHardwareReload.allCases.map(\.rawValue)
        values += GFXTIMWatchdogClock.allCases.map(\.rawValue)
        values += [GFXTIMClockCalibration.line.rawValue, GFXTIMClockCalibration.frame.rawValue]
        values += [GFXTIMClockGeneratorCounters.line.rawValue, GFXTIMClockGeneratorCounters.frame.rawValue]
        values += [GFXTIMFlags.absoluteFrameOverflow.rawValue, GFXTIMFlags.absoluteLineOverflow.rawValue, GFXTIMFlags.tearingEffect.rawValue, GFXTIMFlags.absoluteFrameCompare1.rawValue, GFXTIMFlags.absoluteLineCompare1.rawValue, GFXTIMFlags.absoluteLineCompare2.rawValue, GFXTIMFlags.relativeFrame1Reload.rawValue, GFXTIMFlags.relativeFrame2Reload.rawValue, GFXTIMFlags.event1.rawValue, GFXTIMFlags.event2.rawValue, GFXTIMFlags.event3.rawValue, GFXTIMFlags.event4.rawValue, GFXTIMFlags.watchdogAlarm.rawValue, GFXTIMFlags.watchdogPreAlarm.rawValue]
        values += GFXTIMState.allCases.map(\.rawValue)
        values += [GFXTIMError.state.rawValue, GFXTIMError.invalidCallback.rawValue]
        values += GFXTIMCallbackID.allCases.map(\.rawValue)
        XCTAssertEqual(values.count, Int(CGFXTIM_ConstantCount()))
        for (index, value) in values.enumerated() {
            XCTAssertEqual(value, CGFXTIM_Constant(UInt32(index)), "Constant \(index)")
        }
    }
}
