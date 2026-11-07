import XCTest
import STM32H7RSHAL
import STM32H7RSHardware
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

final class RNGRegisterLayoutTests: XCTestCase {
    func testPeripheralAddressesMatchCMSISIncludingReservedWord() {
        // All four stm32h7{r,s}{3,7}xx.h layouts at CMSIS revision
        // 7e6e213ddc397c76622a0aca2f623ccc3b34c010 agree with both pinned SVDs.
        XCTAssertEqual(rng.unsafeAddress, 0x4802_0000)
        XCTAssertEqual([rng.cr.unsafeAddress, rng.sr.unsafeAddress,
                        rng.dr.unsafeAddress, rng.htcr.unsafeAddress],
                       [0x4802_0000, 0x4802_0004, 0x4802_0008, 0x4802_0010])
    }

    func testStateCopiesShareFiveSeparateVolatileWords() {
        var words: [UInt32] = [0x1234_5678, 0, 0, 0, 0, 0, 0x8765_4321]
        words.withUnsafeMutableBufferPointer { buffer in
            let state = STM32RNGStateRegisters(storage: .init(start: buffer.baseAddress! + 1, count: 5))
            let copy = state
            let fields: [RNGHandleWord] = [.clockErrorDetection, .lock, .state, .errorCode, .randomNumber]
            for (index, field) in fields.enumerated() {
                state.write(field, value: UInt32(index + 1) * 0x1010_1010)
                XCTAssertEqual(copy.read(field), UInt32(index + 1) * 0x1010_1010)
            }
            copy.write(.randomNumber, value: 0xFFFF_FFFF)
            XCTAssertEqual(state.read(.randomNumber), 0xFFFF_FFFF)
        }
        XCTAssertEqual(words, [0x1234_5678, 0x1010_1010, 0x2020_2020, 0x3030_3030,
                               0x4040_4040, 0xFFFF_FFFF, 0x8765_4321])
    }

    func testCallbackCopiesSharePointersAndForwardContextAndReadyValue() {
        var storage: [UInt] = [0xA5A5, 0, 0, 0, 0, 0x5A5A]
        var count: UInt32 = 0
        let callback: RNGCallback = { context in
            context!.assumingMemoryBound(to: UInt32.self).pointee &+= 1
        }
        let ready: RNGReadyDataCallback = { context, value in
            context!.assumingMemoryBound(to: UInt32.self).pointee &+= value
        }
        withUnsafeMutablePointer(to: &count) { context in
            storage.withUnsafeMutableBufferPointer { buffer in
                let callbacks = STM32RNGCallbackRegisters(
                    storage: .init(start: buffer.baseAddress! + 1, count: 4), context: context)
                let copy = callbacks
                for id in [RNGCallbackID.error, .mspInitialize, .mspDeinitialize] {
                    XCTAssertNil(callbacks.read(id))
                    callbacks.write(id, value: callback)
                    let retrieved = copy.read(id)
                    XCTAssertNotNil(retrieved)
                    retrieved?(copy.context)
                }
                XCTAssertNil(callbacks.readReadyDataCallback())
                callbacks.writeReadyDataCallback(ready)
                copy.readReadyDataCallback()?(copy.context, 0x1020_3040)
                for id in [RNGCallbackID.error, .mspInitialize, .mspDeinitialize] {
                    copy.write(id, value: nil)
                    XCTAssertNil(callbacks.read(id))
                }
                copy.writeReadyDataCallback(nil)
                XCTAssertNil(callbacks.readReadyDataCallback())
            }
        }
        XCTAssertEqual(count, 0x1020_3043)
        XCTAssertEqual(storage, [0xA5A5, 0, 0, 0, 0, 0x5A5A])
    }
}
