import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

final class MCERegisterLayoutTests: XCTestCase {
    #if STM32H7S
    func testAllInstanceRegionKeyAndContextAddresses() {
        for instance in MCEInstance.allCases {
            let io = STM32MCERegisters(instance: instance)
            let base: UInt = 0x5200B800 + UInt(instance.rawValue - 1) * 0x400
            for (reg, offset): (MCERegister, UInt) in [(.cr,0),(.sr,4),(.iasr,8),(.iacr,12),(.iaier,16),(.privcfgr,28),(.iaesr,32),(.iaddr,36)] {
                XCTAssertEqual(io.address(of: reg), base + offset)
            }
            for i: UInt32 in 0..<4 {
                XCTAssertEqual(io.address(of: .masterKey(i)), base + 0x200 + UInt(i) * 4)
                XCTAssertEqual(io.address(of: .fastMasterKey(i)), base + 0x220 + UInt(i) * 4)
                for field in MCERegionRegister.allCases {
                    XCTAssertEqual(io.address(of: .region(i, field)), base + 0x40 + UInt(i) * 0x10 + UInt(field.rawValue))
                }
            }
            if instance == .mce1 {
                for i: UInt32 in 0..<2 { for field in MCEContextRegister.allCases {
                    XCTAssertEqual(io.address(of: .context(i, field)), base + 0x240 + UInt(i) * 0x30 + UInt(field.rawValue))
                } }
            }
        }
    }
    #endif
    func testHandleUsesThreeVolatileWordsWithGuards() {
        let storage = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 5)
        storage.initialize(repeating: 0); defer { storage.deallocate() }
        storage[0] = 0x1234; storage[4] = 0x5678
        let io = STM32MCEHandleRegisters(storage: .init(rebasing: storage[1..<4]))
        for word in MCEHandleWord.allCases {
            io.write(word, value: UInt32(word.rawValue) + 42)
            XCTAssertEqual(io.read(word), UInt32(word.rawValue) + 42)
            XCTAssertEqual(storage[word.rawValue + 1], UInt32(word.rawValue) + 42)
        }
        XCTAssertEqual(storage[0], 0x1234); XCTAssertEqual(storage[4], 0x5678)
    }
    func testCallbacksUseNativeFunctionPointersWithGuards() {
        let storage = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 5)
        storage.initialize(repeating: 0)
        let counter = UnsafeMutablePointer<UInt32>.allocate(capacity: 1); counter.initialize(to: 0)
        defer { storage.deallocate(); counter.deallocate() }
        storage[0] = 0x1234; storage[4] = 0x5678
        let io = STM32MCECallbackRegisters(storage: .init(rebasing: storage[1..<4]), context: counter)
        let callback: MCECallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for id in MCECallbackID.allCases {
            XCTAssertNil(io.read(id)); io.write(id, value: callback)
            XCTAssertEqual(storage[Int(id.rawValue) + 1], unsafeBitCast(callback, to: UInt.self))
            io.read(id)!(io.context); io.write(id, value: nil); XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(counter.pointee, 3); XCTAssertEqual(storage[0], 0x1234); XCTAssertEqual(storage[4], 0x5678)
    }
}
