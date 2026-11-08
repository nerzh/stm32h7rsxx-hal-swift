import XCTest
import STM32H7RSHAL
import CPKAReference

final class PKAConstantsTests: XCTestCase {
    func testPublicEncodingsAgainstOriginalHeaders() {
        let values: [UInt32] = [
            PKAState.reset.rawValue,
            PKAState.ready.rawValue,
            PKAState.busy.rawValue,
            PKAState.error.rawValue,
            PKAError.address.rawValue,
            PKAError.ram.rawValue,
            PKAError.timeout.rawValue,
            PKAError.operation.rawValue,
            PKAError.invalidCallback.rawValue,
            PKAMode.modularExponentiation.rawValue,
            PKAMode.montgomeryParameter.rawValue,
            PKAMode.modularExponentiationFast.rawValue,
            PKAMode.modularExponentiationProtected.rawValue,
            PKAMode.rsaCRTExponentiation.rawValue,
            PKAMode.modularInversion.rawValue,
            PKAMode.addition.rawValue,
            PKAMode.subtraction.rawValue,
            PKAMode.multiplication.rawValue,
            PKAMode.comparison.rawValue,
            PKAMode.modularReduction.rawValue,
            PKAMode.modularAddition.rawValue,
            PKAMode.modularSubtraction.rawValue,
            PKAMode.montgomeryMultiplication.rawValue,
            PKAMode.eccMultiplication.rawValue,
            PKAMode.eccCompleteAddition.rawValue,
            PKAMode.ecdsaSignature.rawValue,
            PKAMode.ecdsaVerification.rawValue,
            PKAMode.eccDoubleBaseLadder.rawValue,
            PKAMode.pointCheck.rawValue,
            PKAMode.eccProjectiveToAffine.rawValue,
            PKAInterrupt.processEnd.rawValue,
            PKAInterrupt.ramError.rawValue,
            PKAInterrupt.addressError.rawValue,
            PKAInterrupt.operationError.rawValue,
            PKAFlag.processEnd.rawValue,
            PKAFlag.ramError.rawValue,
            PKAFlag.addressError.rawValue,
            PKAFlag.operationError.rawValue,
            PKACallbackID.operationComplete.rawValue,
            PKACallbackID.error.rawValue,
            PKACallbackID.mspInitialize.rawValue,
            PKACallbackID.mspDeinitialize.rawValue,
            PKAOperationStatus.noError.rawValue, PKAOperationStatus.failedComputation.rawValue,
            PKAOperationStatus.signatureRZero.rawValue, PKAOperationStatus.signatureSZero.rawValue
        ]
        for (index,value) in values.enumerated() { XCTAssertEqual(value,CPKA_Constant(UInt32(index)),"encoding \(index)") }
    }
}
