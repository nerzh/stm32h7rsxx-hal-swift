import XCTest
import STM32H7RSHAL
import CDCMIPPReference

final class DCMIPPConstantsTests: XCTestCase {
    func testEveryPublicEncodingMatchesThePinnedCHeader() {
        var values: [UInt32] = []
        values += DCMIPPState.allCases.map(\.rawValue)
        values += DCMIPPPipeState.allCases.map(\.rawValue)
        values += DCMIPPCaptureMode.allCases.map(\.rawValue)
        values += DCMIPPFrameRate.allCases.map(\.rawValue)
        values += DCMIPPFormat.allCases.map(\.rawValue)
        values += DCMIPPDataWidth.allCases.map(\.rawValue)
        values += DCMIPPHorizontalSyncPolarity.allCases.map(\.rawValue)
        values += DCMIPPVerticalSyncPolarity.allCases.map(\.rawValue)
        values += DCMIPPPixelClockPolarity.allCases.map(\.rawValue)
        values += DCMIPPSynchronization.allCases.map(\.rawValue)
        values += DCMIPPSwapBits.allCases.map(\.rawValue)
        values += DCMIPPSwapCycles.allCases.map(\.rawValue)
        values += DCMIPPMemoryPageSize.allCases.map(\.rawValue)
        values += DCMIPPTrafficBurstSize.allCases.map(\.rawValue)
        values += DCMIPPOutstandingTransactions.allCases.map(\.rawValue)
        values += DCMIPPCropArea.allCases.map(\.rawValue)
        values += DCMIPPByteSelection.allCases.map(\.rawValue)
        values += DCMIPPByteSelectionStart.allCases.map(\.rawValue)
        values += DCMIPPLineSelection.allCases.map(\.rawValue)
        values += DCMIPPLineSelectionStart.allCases.map(\.rawValue)
        values += DCMIPPMemory.allCases.map(\.rawValue)
        values += DCMIPPLineEventInterval.allCases.map(\.rawValue)
        values += DCMIPPCallbackID.allCases.map(\.rawValue)
        values += DCMIPPPipeCallbackID.allCases.map(\.rawValue)
        values += [DCMIPPError.axiTransfer.rawValue, DCMIPPError.parallelSync.rawValue, DCMIPPError.pipeLimit.rawValue, DCMIPPError.pipeOverrun.rawValue, DCMIPPError.invalidCallback.rawValue]
        values += [DCMIPPInterrupts.axiTransferError.rawValue, DCMIPPInterrupts.parallelSyncError.rawValue, DCMIPPInterrupts.frame.rawValue, DCMIPPInterrupts.vsync.rawValue, DCMIPPInterrupts.line.rawValue, DCMIPPInterrupts.limit.rawValue, DCMIPPInterrupts.overrun.rawValue]
        values += [DCMIPPFlags.axiTransferError.rawValue, DCMIPPFlags.parallelSyncError.rawValue, DCMIPPFlags.frame.rawValue, DCMIPPFlags.vsync.rawValue, DCMIPPFlags.line.rawValue, DCMIPPFlags.limit.rawValue, DCMIPPFlags.overrun.rawValue]
        XCTAssertEqual(values.count, Int(CDCMIPP_ConstantCount()))
        for (index, value) in values.enumerated() { XCTAssertEqual(value, CDCMIPP_Constant(UInt32(index)), "Constant \(index)") }
    }
}
