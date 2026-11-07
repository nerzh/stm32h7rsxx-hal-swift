import XCTest
import STM32H7RSHAL
import CLTDCReference

final class LTDCConstantsTests: XCTestCase {
    func testEveryPublicEncodingMatchesThePinnedCHeader() {
        var values: [UInt32] = []
        values += LTDCState.allCases.map(\.rawValue)
        values += LTDCPixelFormat.allCases.map(\.rawValue)
        values += LTDCReload.allCases.map(\.rawValue)
        values += LTDCBlendingFactor1.allCases.map(\.rawValue)
        values += LTDCBlendingFactor2.allCases.map(\.rawValue)
        values += LTDCCallbackID.allCases.map(\.rawValue)
        values += LTDCHorizontalSyncPolarity.allCases.map(\.rawValue)
        values += LTDCVerticalSyncPolarity.allCases.map(\.rawValue)
        values += LTDCDataEnablePolarity.allCases.map(\.rawValue)
        values += LTDCPixelClockPolarity.allCases.map(\.rawValue)
        values += LTDCLayer.allCases.map(\.rawValue)
        values += [LTDCError.transfer.rawValue, LTDCError.fifoUnderrun.rawValue, LTDCError.timeout.rawValue, LTDCError.invalidCallback.rawValue]
        values += [LTDCInterrupts.line.rawValue, LTDCInterrupts.fifoUnderrun.rawValue, LTDCInterrupts.transferError.rawValue, LTDCInterrupts.reload.rawValue]
        values += [LTDCFlags.line.rawValue, LTDCFlags.fifoUnderrun.rawValue, LTDCFlags.transferError.rawValue, LTDCFlags.reload.rawValue]
        XCTAssertEqual(values.count, Int(CLTDC_ConstantCount()))
        for (index, value) in values.enumerated() { XCTAssertEqual(value, CLTDC_Constant(UInt32(index)), "Constant \(index)") }
    }
}
