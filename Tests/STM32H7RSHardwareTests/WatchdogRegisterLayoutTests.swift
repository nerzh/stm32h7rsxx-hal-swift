import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

final class WatchdogRegisterLayoutTests: XCTestCase {
    func testAddressesAndFourByteStrideMatchCMSIS() {
        // CMSIS at 7e6e213ddc397c76622a0aca2f623ccc3b34c010 defines
        // uint32_t register fields despite the pinned SVD's 16-bit size tags.
        XCTAssertEqual(iwdg.unsafeAddress, 0x5800_4800)
        XCTAssertEqual(wwdg.unsafeAddress, 0x4000_2C00)
        let iwdgRegisters: [IWDGRegister] = [.kr, .pr, .rlr, .sr, .winr, .ewcr]
        let wwdgRegisters: [WWDGRegister] = [.cr, .cfr, .sr]
        XCTAssertEqual(iwdgRegisters.map(STM32IWDGRegisters.address),
                       [0x5800_4800, 0x5800_4804, 0x5800_4808, 0x5800_480C, 0x5800_4810, 0x5800_4814])
        XCTAssertEqual(wwdgRegisters.map(STM32WWDGRegisters.address), [0x4000_2C00, 0x4000_2C04, 0x4000_2C08])
    }

    func testIWDGConfigurationCopiesShareFourVolatileWordsAndPreserveSentinels() {
        var words: [UInt32] = [0x1122_3344, 0, 0, 0, 0, 0x5566_7788]
        words.withUnsafeMutableBufferPointer { buffer in
            let storage = STM32IWDGConfigurationRegisters(storage: .init(start: buffer.baseAddress! + 1, count: 4))
            let copy = storage
            IWDGConfiguration(prescaler: 8, reload: 0xABC, window: 0xDEF, earlyWakeup: 0x123).store(in: storage)
            XCTAssertEqual(IWDGConfigurationWord.allCases.map(copy.read), [8, 0xABC, 0xDEF, 0x123])
            copy.write(.reload, value: 0xFFFF_FFFF)
            XCTAssertEqual(storage.read(.reload), UInt32.max)
        }
        XCTAssertEqual(words, [0x1122_3344, 8, .max, 0xDEF, 0x123, 0x5566_7788])
    }

    func testWWDGConfigurationCopiesShareFourVolatileWordsAndPreserveSentinels() {
        var words: [UInt32] = [0x1122_3344, 0, 0, 0, 0, 0x5566_7788]
        words.withUnsafeMutableBufferPointer { buffer in
            let storage = STM32WWDGConfigurationRegisters(storage: .init(start: buffer.baseAddress! + 1, count: 4))
            let copy = storage
            WWDGConfiguration(prescaler: 0x3800, window: 0x7F, counter: 0x6A, earlyWakeupMode: 0x200).store(in: storage)
            XCTAssertEqual(WWDGConfigurationWord.allCases.map(copy.read), [0x3800, 0x7F, 0x6A, 0x200])
            copy.write(.counter, value: 0xFFFF_FFFF)
            XCTAssertEqual(storage.read(.counter), UInt32.max)
        }
        XCTAssertEqual(words, [0x1122_3344, 0x3800, 0x7F, .max, 0x200, 0x5566_7788])
    }

    func testBothCallbackAdaptersShareTwoPointersAndForwardContext() {
        var slots: [UInt] = [0x1234, 0, 0, 0x5678]
        var count: UInt32 = 0
        let iwdgCallback: IWDGCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        let wwdgCallback: WWDGCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 10 }
        withUnsafeMutablePointer(to: &count) { context in
            slots.withUnsafeMutableBufferPointer { buffer in
                let storage = UnsafeMutableBufferPointer(start: buffer.baseAddress! + 1, count: 2)
                let iwdg = STM32IWDGCallbackRegisters(storage: storage, context: context)
                let iwdgCopy = iwdg
                for id in IWDGCallbackID.allCases {
                    XCTAssertNil(iwdg.read(id))
                    iwdg.write(id, value: iwdgCallback)
                    iwdgCopy.read(id)?(iwdgCopy.context)
                    iwdgCopy.write(id, value: nil)
                    XCTAssertNil(iwdg.read(id))
                }
                let wwdg = STM32WWDGCallbackRegisters(storage: storage, context: context)
                let wwdgCopy = wwdg
                for id in WWDGCallbackID.allCases {
                    XCTAssertNil(wwdg.read(id))
                    wwdg.write(id, value: wwdgCallback)
                    wwdgCopy.read(id)?(wwdgCopy.context)
                    wwdgCopy.write(id, value: nil)
                    XCTAssertNil(wwdg.read(id))
                }
            }
        }
        XCTAssertEqual(count, 22)
        XCTAssertEqual(slots, [0x1234, 0, 0, 0x5678])
    }
}
