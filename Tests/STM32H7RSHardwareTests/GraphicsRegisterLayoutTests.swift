import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

extension RegisterLayoutTests {
    func testGFXMMULayoutIncludesEveryLUTWordAndReservedGap() {
        let io = STM32GFXMMURegisters()
        let registers: [(GFXMMURegister, UInt32)] = [(.cr, 0), (.sr, 4), (.fcr, 8), (.dvr, 0x10),
            (.dar, 0x14), (.b0cr, 0x20), (.b1cr, 0x24), (.b2cr, 0x28), (.b3cr, 0x2C)]
        for (register, offset) in registers { XCTAssertEqual(io.address(of: register), 0x5201_0000 + offset) }
        for index in 0..<2048 { XCTAssertEqual(io.address(of: .lut(index: index)), 0x5201_1000 + UInt32(index) * 4) }
    }
    func testGPU2DCMSISBaseAndHALRegisterOffsets() {
        XCTAssertEqual(STM32GPU2DRegisters.address(offset: GPU2DRegisterOffset.interruptControl), 0x5201_40F8)
        XCTAssertEqual(STM32GPU2DRegisters.address(offset: GPU2DRegisterOffset.commandListID), 0x5201_4148)
        XCTAssertEqual(STM32GPU2DRegisters.address(offset: GPU2DRegisterOffset.breakpoint), 0x5201_4080)
        XCTAssertEqual(STM32GPU2DRegisters.address(offset: GPU2DRegisterOffset.systemInterrupt), 0x5201_4FF8)
        XCTAssertEqual(STM32GPU2DRegisters.address(offset: 0xFFC), 0x5201_4FFC)
        XCTAssertEqual(GPU2DRegisterOffset.limit, 0x1000)
    }
    func testGraphicsHandlesUseSharedCallerOwnedWords() {
        let storage = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 13)
        storage.initialize(repeating: 0xA5A5_A5A5)
        defer { storage.deallocate() }
        let mmu = STM32GFXMMUHandleRegisters(storage: .init(rebasing: storage[1..<12]))
        let alias = mmu
        for word in GFXMMUHandleWord.allCases {
            mmu.write(word, value: UInt32(word.rawValue) * 17)
            XCTAssertEqual(alias.read(word), UInt32(word.rawValue) * 17)
            XCTAssertEqual(storage[word.rawValue + 1], UInt32(word.rawValue) * 17)
        }
        let gpu = STM32GPU2DHandleRegisters(storage: .init(rebasing: storage[1..<4]))
        for word in GPU2DHandleWord.allCases {
            gpu.write(word, value: 0x4000 + UInt32(word.rawValue))
            XCTAssertEqual(storage[word.rawValue + 1], 0x4000 + UInt32(word.rawValue))
            storage[word.rawValue + 1] = 0x8000 + UInt32(word.rawValue)
            XCTAssertEqual(gpu.read(word), 0x8000 + UInt32(word.rawValue))
        }
        XCTAssertEqual(storage[0], 0xA5A5_A5A5); XCTAssertEqual(storage[12], 0xA5A5_A5A5)
    }
    func testGraphicsCallbackStoragePreservesNativePointersAndCommandID() {
        let slots = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 5)
        slots.initialize(repeating: 0)
        slots[0] = 0x1234; slots[4] = 0x5678
        let context = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        context.initialize(to: 0)
        defer { context.deallocate(); slots.deallocate() }
        let buffer = UnsafeMutableBufferPointer(rebasing: slots[1..<4])
        let mmu = STM32GFXMMUCallbackRegisters(storage: buffer, context: context)
        let callback: GFXMMUCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for id in GFXMMUCallbackID.allCases {
            XCTAssertNil(mmu.read(id)); mmu.write(id, value: callback)
            XCTAssertEqual(slots[Int(id.rawValue) + 1], unsafeBitCast(callback, to: UInt.self))
            mmu.read(id)!(mmu.context); mmu.write(id, value: nil); XCTAssertNil(mmu.read(id))
        }
        XCTAssertEqual(context.pointee, 3)
        let gpu = STM32GPU2DCallbackRegisters(storage: buffer, context: context)
        for id in GPU2DCallbackID.allCases {
            gpu.write(id, value: callback); gpu.read(id)!(gpu.context)
            gpu.write(id, value: nil); XCTAssertNil(gpu.read(id))
        }
        let complete: GPU2DCommandListCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee = $1 }
        gpu.writeCommandListComplete(complete)
        XCTAssertEqual(slots[3], unsafeBitCast(complete, to: UInt.self))
        gpu.readCommandListComplete()!(gpu.context, 0xFFFF_FFFF)
        XCTAssertEqual(context.pointee, .max)
        gpu.writeCommandListComplete(nil); XCTAssertNil(gpu.readCommandListComplete())
        XCTAssertEqual(slots[0], 0x1234); XCTAssertEqual(slots[4], 0x5678)
    }
}
