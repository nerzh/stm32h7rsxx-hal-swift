import XCTest
import STM32H7RSHAL
import CSPDIFRXReference

final class SPDIFRXConstantsTests: XCTestCase {
    func testPublicEncodingsMatchPinnedHeader() {
        let values: [UInt32] = [
            SPDIFRXState.reset.rawValue,
            SPDIFRXState.ready.rawValue,
            SPDIFRXState.busy.rawValue,
            SPDIFRXState.busyReceive.rawValue,
            SPDIFRXState.busyControl.rawValue,
            SPDIFRXState.error.rawValue,
            SPDIFRXError.timeout.rawValue,
            SPDIFRXError.overrun.rawValue,
            SPDIFRXError.parity.rawValue,
            SPDIFRXError.dma.rawValue,
            SPDIFRXError.unknown.rawValue,
            SPDIFRXError.invalidCallback.rawValue,
            SPDIFRXInput.input0.rawValue,
            SPDIFRXInput.input1.rawValue,
            SPDIFRXInput.input2.rawValue,
            SPDIFRXInput.input3.rawValue,
            SPDIFRXRetries.none.rawValue,
            SPDIFRXRetries.retries3.rawValue,
            SPDIFRXRetries.retries15.rawValue,
            SPDIFRXRetries.retries63.rawValue,
            SPDIFRXChannel.channelA.rawValue,
            SPDIFRXChannel.channelB.rawValue,
            SPDIFRXDataFormat.lsb.rawValue,
            SPDIFRXDataFormat.msb.rawValue,
            SPDIFRXDataFormat.bits32.rawValue,
            SPDIFRXInterrupts.receive.rawValue,
            SPDIFRXInterrupts.control.rawValue,
            SPDIFRXInterrupts.parity.rawValue,
            SPDIFRXInterrupts.overrun.rawValue,
            SPDIFRXInterrupts.block.rawValue,
            SPDIFRXInterrupts.synchronization.rawValue,
            SPDIFRXInterrupts.interfaceError.rawValue,
            SPDIFRXFlags.receive.rawValue,
            SPDIFRXFlags.control.rawValue,
            SPDIFRXFlags.parity.rawValue,
            SPDIFRXFlags.overrun.rawValue,
            SPDIFRXFlags.block.rawValue,
            SPDIFRXFlags.synchronization.rawValue,
            SPDIFRXFlags.frameError.rawValue,
            SPDIFRXFlags.synchronizationError.rawValue,
            SPDIFRXFlags.timeoutError.rawValue,
            SPDIFRXCallbackID.receiveHalf.rawValue,
            SPDIFRXCallbackID.receiveComplete.rawValue,
            SPDIFRXCallbackID.controlHalf.rawValue,
            SPDIFRXCallbackID.controlComplete.rawValue,
            SPDIFRXCallbackID.error.rawValue,
            SPDIFRXCallbackID.mspInitialize.rawValue,
            SPDIFRXCallbackID.mspDeinitialize.rawValue
        ]
        for (i, value) in values.enumerated() { XCTAssertEqual(value, CSPDIFRX_Constant(UInt32(i)), "constant \(i)") }
    }
}
