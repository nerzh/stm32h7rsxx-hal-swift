import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

final class RAMECCRegisterLayoutTests: XCTestCase {
    func testAllSixCMSISMonitorsAndSharedIERWithSVDNamingDifference() {
        let addresses: [UInt] = [0x52009020, 0x52009040, 0x52009060, 0x52009080, 0x520090A0, 0x58027040]
        XCTAssertEqual(STM32RAMECCMonitor.allCases.count, 6)
        for (monitor, address) in zip(STM32RAMECCMonitor.allCases, addresses) {
            let registers = STM32RAMECCRegisters(monitor: monitor)
            XCTAssertEqual(registers.ier.unsafeAddress, address & 0xFFFFFF00)
            XCTAssertEqual([registers.cr.unsafeAddress, registers.sr.unsafeAddress, registers.far.unsafeAddress,
                            registers.fdrl.unsafeAddress, registers.fdrh.unsafeAddress, registers.fecr.unsafeAddress],
                           [address, address + 4, address + 8, address + 12, address + 16, address + 20])
        }
        XCTAssertEqual(ramcfg.unsafeAddress, 0x58027000)
        XCTAssertEqual(ramcfg.m1cr.unsafeAddress, 0x58027020)
        XCTAssertEqual(ramcfg.m2cr.unsafeAddress, UInt(STM32RAMECCMonitor.ramecc2Monitor1.rawValue))
    }

    func testStateCopiesShareTwoVolatileWordsWithoutTouchingGuards() {
        var words: [UInt32] = [0xA5A5A5A5, 0, 0, 0x5A5A5A5A]
        words.withUnsafeMutableBufferPointer { buffer in
            let state = STM32RAMECCStateRegisters(storage: .init(start: buffer.baseAddress! + 1, count: 2))
            let copy = state
            state.write(.state, value: 3)
            copy.write(.errorCode, value: 0x80000003)
            XCTAssertEqual(copy.read(.state), 3)
            XCTAssertEqual(state.read(.errorCode), 0x80000003)
        }
        XCTAssertEqual(words, [0xA5A5A5A5, 3, 0x80000003, 0x5A5A5A5A])
    }

    func testCallbackCopiesShareFourNativePointersAndUnownedContext() {
        var slots: [UInt] = [0xA5A5, 0, 0, 0, 0, 0x5A5A]
        var count: UInt32 = 0
        let callback: RAMECCCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        withUnsafeMutablePointer(to: &count) { context in
            slots.withUnsafeMutableBufferPointer { buffer in
                let io = STM32RAMECCCallbackRegisters(storage: .init(start: buffer.baseAddress! + 1, count: 4), context: context)
                let copy = io
                for id in [RAMECCCallbackID.mspInitialize, .mspDeinitialize, .singleError, .doubleError] {
                    XCTAssertNil(io.read(id))
                    io.write(id, value: callback)
                    copy.read(id)?(copy.context)
                    copy.write(id, value: nil)
                    XCTAssertNil(io.read(id))
                }
            }
        }
        XCTAssertEqual(count, 4)
        XCTAssertEqual(slots, [0xA5A5, 0, 0, 0, 0, 0x5A5A])
    }
}
