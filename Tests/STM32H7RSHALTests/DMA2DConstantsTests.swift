import XCTest
import STM32H7RSHAL
import CDMA2DReference

final class DMA2DConstantsTests: XCTestCase {
    func testEveryPublicEncodingMatchesThePinnedCHeader() {
        var values: [UInt32] = []
        values += DMA2DState.allCases.map(\.rawValue)
        values += DMA2DMode.allCases.map(\.rawValue)
        values += DMA2DOutputColorMode.allCases.map(\.rawValue)
        values += DMA2DInputColorMode.allCases.map(\.rawValue)
        values += DMA2DAlphaMode.allCases.map(\.rawValue)
        values += DMA2DChromaSubsampling.allCases.map(\.rawValue)
        values += DMA2DLayer.allCases.map(\.rawValue)
        values += DMA2DLineOffsetMode.allCases.map(\.rawValue)
        values += DMA2DCLUTColorMode.allCases.map(\.rawValue)
        values += DMA2DCallbackID.allCases.map(\.rawValue)
        values += [DMA2DError.transfer.rawValue, DMA2DError.configuration.rawValue, DMA2DError.clutAccess.rawValue, DMA2DError.timeout.rawValue, DMA2DError.invalidCallback.rawValue]
        values += [DMA2DFlags.transferError.rawValue, DMA2DFlags.transferComplete.rawValue, DMA2DFlags.line.rawValue, DMA2DFlags.clutAccessError.rawValue, DMA2DFlags.clutComplete.rawValue, DMA2DFlags.configurationError.rawValue]
        values += [DMA2DInterrupts.transferError.rawValue, DMA2DInterrupts.transferComplete.rawValue, DMA2DInterrupts.line.rawValue, DMA2DInterrupts.clutAccessError.rawValue, DMA2DInterrupts.clutComplete.rawValue, DMA2DInterrupts.configurationError.rawValue]
        XCTAssertEqual(values.count, Int(CDMA2D_ConstantCount()))
        for (index, value) in values.enumerated() { XCTAssertEqual(value, CDMA2D_Constant(UInt32(index)), "Constant \(index)") }
    }
}
