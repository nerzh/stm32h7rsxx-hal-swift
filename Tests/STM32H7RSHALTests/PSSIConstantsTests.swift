import XCTest
import STM32H7RSHAL
import CPSSIReference
final class PSSIConstantsTests: XCTestCase {
    func testPublicEncodingsMatchOriginalHeader() {
        var values: [UInt32] = []
        values += PSSIDataWidth.allCases.map(\.rawValue)
        values += PSSIBusWidth.allCases.map(\.rawValue)
        values += PSSIDirection.allCases.map(\.rawValue)
        values += PSSIControlSignal.allCases.map(\.rawValue)
        values += PSSIClockPolarity.allCases.map(\.rawValue)
        values += PSSIClockSource.allCases.map(\.rawValue)
        values += PSSIDataEnablePolarity.allCases.map(\.rawValue)
        values += PSSIReadyPolarity.allCases.map(\.rawValue)
        values += PSSIState.allCases.map(\.rawValue)
        values += PSSICallbackID.allCases.map(\.rawValue)
        values += [PSSIConstants.maximumByteCount, PSSIConstants.transmitTimeout, PSSIConstants.readyOneByte, PSSIConstants.readyFourBytes, PSSIConstants.rawOverrunUnderrun, PSSIConstants.maskedOverrunUnderrun, PSSIError.notSupported.rawValue, PSSIError.underrun.rawValue, PSSIError.overrun.rawValue, PSSIError.dma.rawValue, PSSIError.timeout.rawValue, PSSIError.invalidCallback.rawValue]
        XCTAssertEqual(values.count, Int(CPSSI_ConstantCount()))
        for (i,v) in values.enumerated() { XCTAssertEqual(v, CPSSI_Constant(UInt32(i)), "Constant \(i)") }
    }
}
