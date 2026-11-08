import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

extension RegisterLayoutTests {
    func testMDIOSControlAndAllDataRegisterAddresses() {
        let io = STM32MDIOSRegisters()
        for register in MDIOSRegister.allCases { XCTAssertEqual(io.address(of: register), 0x40009400 + UInt(register.rawValue)) }
        for i: UInt32 in 0..<32 {
            XCTAssertEqual(io.inputAddress(i), 0x40009500 + UInt(i) * 4)
            XCTAssertEqual(io.outputAddress(i), 0x40009580 + UInt(i) * 4)
        }
    }
    func testMDIOSWakeupRegistersUseCMSISOffsetsInsteadOfIncompleteSVD() {
        let io = STM32MDIOSRegisters()
        XCTAssertEqual(io.wakeupIMR2.unsafeAddress, 0x58000090)
        XCTAssertEqual(io.wakeupPR2.unsafeAddress, 0x58000098)
        XCTAssertEqual(io.wakeupRTSR2.unsafeAddress, 0x58000020)
        XCTAssertEqual(io.wakeupFTSR2.unsafeAddress, 0x58000024)
        XCTAssertEqual(io.wakeupSWIER2.unsafeAddress, 0x58000028)
    }
    func testCECRegisterAddresses() {
        let io = STM32CECRegisters()
        for register in CECRegister.allCases { XCTAssertEqual(io.address(of: register), 0x40006C00 + UInt(register.rawValue)) }
    }
    func testMDIOSSharedHandleAndNativeCallbackSlots() {
        let words = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 7)
        let pointers = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 8)
        words.initialize(repeating: .max); pointers.initialize(repeating: 0)
        defer { words.deallocate(); pointers.deallocate() }
        let h = STM32MDIOSHandleRegisters(storage: .init(rebasing: words[1..<6])), alias = h
        for word in MDIOSHandleWord.allCases {
            h.write(word, value: UInt32(word.rawValue)); XCTAssertEqual(alias.read(word), UInt32(word.rawValue))
            XCTAssertEqual(words[word.rawValue + 1], UInt32(word.rawValue))
        }
        let c = STM32MDIOSCallbackRegisters(storage: .init(rebasing: pointers[1..<7]), context: words.baseAddress)
        let callback: MDIOSCallback = { $0!.assumingMemoryBound(to: UInt32.self)[1] &+= 1 }
        for id in MDIOSCallbackID.allCases {
            XCTAssertNil(c.read(id)); c.write(id, value: callback)
            XCTAssertEqual(pointers[Int(id.rawValue) + 1], unsafeBitCast(callback, to: UInt.self))
            c.read(id)!(c.context); c.write(id, value: nil); XCTAssertNil(c.read(id))
        }
        XCTAssertEqual(words[1], 6); XCTAssertEqual(words[0], .max); XCTAssertEqual(words[6], .max)
        XCTAssertEqual(pointers[0], 0); XCTAssertEqual(pointers[7], 0)
    }
    func testCECWordHalfwordAndPointerStorageRemainDisjoint() {
        let words = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 17)
        let pointers = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 4)
        words.initialize(repeating: .max); pointers.initialize(repeating: 0xABCD)
        defer { words.deallocate(); pointers.deallocate() }
        let h = STM32CECHandleRegisters(storage: .init(rebasing: words[1..<16]), pointers: .init(rebasing: pointers[1..<3])), alias = h
        XCTAssertEqual(CECHandleWord.allCases.count, 12); XCTAssertEqual(CECHandleHalfWord.allCases.count, 3)
        for word in CECHandleWord.allCases {
            h.write(word, value: UInt32(word.rawValue)); XCTAssertEqual(alias.read(word), UInt32(word.rawValue))
            XCTAssertEqual(words[word.rawValue + 1], UInt32(word.rawValue))
        }
        for word in CECHandleHalfWord.allCases {
            XCTAssertEqual(h.read(word), 0xFFFF); h.write(word, value: 0x1234)
            XCTAssertEqual(words[word.rawValue + 13], 0x1234); XCTAssertEqual(alias.read(word), 0x1234)
        }
        for pointer in CECBufferPointer.allCases {
            let address = UnsafeMutableRawPointer(bitPattern: 0x12340000 + pointer.rawValue * 0x100)
            h.writePointer(pointer, value: address); XCTAssertEqual(alias.readPointer(pointer), address)
            XCTAssertEqual(pointers[pointer.rawValue + 1], UInt(bitPattern: address))
            h.writePointer(pointer, value: nil); XCTAssertNil(alias.readPointer(pointer))
        }
        XCTAssertEqual(words[0], .max); XCTAssertEqual(words[16], .max)
        XCTAssertEqual(pointers[0], 0xABCD); XCTAssertEqual(pointers[3], 0xABCD)
    }
    func testCECDistinctReceiveCallbackSignatureAndNativeSlots() {
        let pointers = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 7)
        let counter = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        pointers.initialize(repeating: 0); counter.initialize(to: 0)
        defer { pointers.deallocate(); counter.deallocate() }
        let c = STM32CECCallbackRegisters(storage: .init(rebasing: pointers[1..<6]), context: counter)
        let normal: CECCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        let receive: CECReceiveCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= $1 }
        for id in CECCallbackID.allCases where id != .receiveComplete {
            XCTAssertNil(c.read(id)); c.write(id, value: normal); c.read(id)!(c.context)
            XCTAssertEqual(pointers[Int(id.rawValue) + 1], unsafeBitCast(normal, to: UInt.self))
            c.write(id, value: nil); XCTAssertNil(c.read(id))
        }
        XCTAssertNil(c.readReceive()); c.writeReceive(receive); c.readReceive()!(c.context, 16)
        XCTAssertEqual(pointers[2], unsafeBitCast(receive, to: UInt.self))
        c.writeReceive(nil); XCTAssertNil(c.readReceive()); XCTAssertEqual(counter.pointee, 20)
        XCTAssertEqual(pointers[0], 0); XCTAssertEqual(pointers[6], 0)
    }
}
