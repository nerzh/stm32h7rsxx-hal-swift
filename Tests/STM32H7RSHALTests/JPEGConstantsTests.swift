import XCTest
import STM32H7RSHAL
import CJPEGReference

final class JPEGConstantsTests: XCTestCase {
    func testPublicEncodingsMatchPinnedHeaderIncludingOFNEAlias() {
        let values: [UInt32] = [
            JPEGInterrupts.inputThreshold.rawValue,
            JPEGInterrupts.inputNotFull.rawValue,
            JPEGInterrupts.outputThreshold.rawValue,
            JPEGInterrupts.outputNotEmpty.rawValue,
            JPEGInterrupts.endOfConversion.rawValue,
            JPEGInterrupts.headerParsingDone.rawValue,
            JPEGFlags.inputThreshold.rawValue,
            JPEGFlags.inputNotFull.rawValue,
            JPEGFlags.outputThreshold.rawValue,
            JPEGFlags.outputNotEmpty.rawValue,
            JPEGFlags.endOfConversion.rawValue,
            JPEGFlags.headerParsingDone.rawValue,
            JPEGFlags.operationOngoing.rawValue,
            JPEGFlags.all.rawValue,
            JPEGTransferSelection.input.rawValue,
            JPEGTransferSelection.output.rawValue,
            JPEGTransferSelection.inputAndOutput.rawValue,
            JPEGState.reset.rawValue,
            JPEGState.ready.rawValue,
            JPEGState.busy.rawValue,
            JPEGState.encoding.rawValue,
            JPEGState.decoding.rawValue,
            JPEGState.timeout.rawValue,
            JPEGState.error.rawValue,
            JPEGError.huffmanTable.rawValue,
            JPEGError.quantizationTable.rawValue,
            JPEGError.dma.rawValue,
            JPEGError.timeout.rawValue,
            JPEGError.invalidCallback.rawValue,
            JPEGColorSpace.grayscale.rawValue,
            JPEGColorSpace.ycbcr.rawValue,
            JPEGColorSpace.cmyk.rawValue,
            JPEGChromaSubsampling.sampling444.rawValue,
            JPEGChromaSubsampling.sampling420.rawValue,
            JPEGChromaSubsampling.sampling422.rawValue,
            JPEGCallbackID.encodeComplete.rawValue,
            JPEGCallbackID.decodeComplete.rawValue,
            JPEGCallbackID.error.rawValue,
            JPEGCallbackID.mspInitialize.rawValue,
            JPEGCallbackID.mspDeinitialize.rawValue,
            JPEGConfiguration.minimumQuality,
            JPEGConfiguration.maximumQuality,
            UInt32(JPEGConfiguration.quantizationTableSize)
        ]
        for (i,value) in values.enumerated() { XCTAssertEqual(value,CJPEG_Constant(UInt32(i)),"constant \(i)") }
    }
}
