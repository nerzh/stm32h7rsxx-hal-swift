import XCTest
import STM32H7RSHAL
import CMCEReference

final class MCEConstantsTests: XCTestCase {
    func testPublicEncodingsMatchPinnedHeader() {
        let values: [UInt32] = [
            MCEState.reset.rawValue,
            MCEState.ready.rawValue,
            MCEState.busy.rawValue,
            MCEError.configurationAccess.rawValue,
            MCEError.privilegedRead.rawValue,
            MCEError.unprivilegedRead.rawValue,
            MCEError.privilegedWrite.rawValue,
            MCEError.unprivilegedWrite.rawValue,
            MCEError.masterKey.rawValue,
            MCEError.fastMasterKey.rawValue,
            MCEError.contextKey.rawValue,
            MCEError.invalidCallback.rawValue,
            MCEFlag.configurationAccess.rawValue,
            MCEFlag.unprivilegedRead.rawValue,
            MCEFlag.privilegedRead.rawValue,
            MCEFlag.unprivilegedWrite.rawValue,
            MCEFlag.privilegedWrite.rawValue,
            MCERegion.region1.rawValue,
            MCERegion.region2.rawValue,
            MCERegion.region3.rawValue,
            MCERegion.region4.rawValue,
            MCEContext.none.rawValue,
            MCEContext.context1.rawValue,
            MCEContext.context2.rawValue,
            MCECipher.none.rawValue,
            MCECipher.stream.rawValue,
            MCECipher.block.rawValue,
            MCECipher.fastBlock.rawValue,
            MCERegionPrivilege.unprivileged.rawValue,
            MCERegionPrivilege.privileged.rawValue,
            MCERegionAccess.readOnly.rawValue,
            MCERegionAccess.readWrite.rawValue,
            MCEConfigurationPrivilege.unprivileged.rawValue,
            MCEConfigurationPrivilege.privileged.rawValue,
            MCEKeyType.master.rawValue,
            MCEKeyType.fastMaster.rawValue,
            MCEInterrupts.configurationAccess.rawValue,
            MCEInterrupts.illegalAccess.rawValue,
            MCECallbackID.error.rawValue,
            MCECallbackID.mspInitialize.rawValue,
            MCECallbackID.mspDeinitialize.rawValue
        ]
        for (i, value) in values.enumerated() { XCTAssertEqual(value, CMCE_Constant(UInt32(i)), "constant \(i)") }
    }
}
