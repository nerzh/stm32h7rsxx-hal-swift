import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

final class FlashRegisterLayoutTests: XCTestCase {
    func testFlashRegisterAddressesMatchCMSISIncludingSparseOptionRegisters() {
        let registers = STM32FlashRegisters()
        let layout: [(FlashRegister, UInt)] = [
            (.keyr, 0x04), (.cr, 0x10), (.sr, 0x14), (.ier, 0x20),
            (.isr, 0x24), (.icr, 0x28), (.crccr, 0x30), (.crcsaddr, 0x34),
            (.crceaddr, 0x38), (.crcdatar, 0x3C), (.eccsfaddr, 0x40), (.eccdfaddr, 0x44),
            (.optkeyr, 0x100), (.optcr, 0x104), (.optisr, 0x108), (.opticr, 0x10C),
            (.obkcr, 0x110), (.nvsr, 0x200), (.nvsrp, 0x204), (.rotsr, 0x208),
            (.otplsr, 0x210), (.otplsrp, 0x214), (.wrpsr, 0x218), (.wrpsrp, 0x21C),
            (.hdpsr, 0x230), (.hdpsrp, 0x234), (.epochsr, 0x250),
            (.obw1sr, 0x260), (.obw1srp, 0x264), (.obw2sr, 0x268), (.obw2srp, 0x26C),
        ]
        for (register, offset) in layout {
            XCTAssertEqual(registers.address(of: register), 0x5200_2000 + offset)
        }
        for index in 0..<8 {
            XCTAssertEqual(registers.address(of: .obkdr(index: index)), 0x5200_2118 + UInt(index) * 4)
        }
    }

    func testFlashProcessCopiesShareAllSixWordsWithoutOverwritingAdjacentStorage() {
        let allocation = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 8)
        allocation.initialize(repeating: 0)
        defer { allocation.deinitialize(); allocation.deallocate() }
        allocation[0] = 0x1234_5678
        allocation[7] = 0x8765_4321
        let storage = UnsafeMutableBufferPointer(rebasing: allocation[1..<7])
        let foreground = STM32FlashProcessRegisters(storage: storage)
        let interrupt = foreground
        for word in FlashProcessWord.allCases {
            foreground.write(word, value: 0xABCD_0000 | UInt32(word.rawValue))
            XCTAssertEqual(storage[word.rawValue], 0xABCD_0000 | UInt32(word.rawValue))
            XCTAssertEqual(interrupt.read(word), storage[word.rawValue])
        }
        interrupt.write(.lock, value: 0)
        interrupt.write(.sectorsRemaining, value: 0)
        XCTAssertEqual(foreground.read(.lock), 0)
        XCTAssertEqual(foreground.read(.sectorsRemaining), 0)
        XCTAssertEqual(allocation[0], 0x1234_5678)
        XCTAssertEqual(allocation[7], 0x8765_4321)
    }
}
