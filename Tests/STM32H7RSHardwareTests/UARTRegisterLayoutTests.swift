import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

final class UARTRegisterLayoutTests: XCTestCase {
    func testAllEightCMSISInstancesAndTypedRegisterOffsets() {
        let instances: [(UARTInstance, UInt)] = [
            (.usart1, 0x42001000), (.usart2, 0x40004400), (.usart3, 0x40004800),
            (.uart4, 0x40004C00), (.uart5, 0x40005000), (.uart7, 0x40007800),
            (.uart8, 0x40007C00), (.lpuart1, 0x58000C00),
        ]
        let offsets: [(UARTRegister, UInt)] = [
            (.cr1, 0), (.cr2, 4), (.cr3, 8), (.brr, 12), (.gtpr, 16), (.rtor, 20),
            (.rqr, 24), (.isr, 28), (.icr, 32), (.rdr, 36), (.tdr, 40), (.presc, 44),
        ]
        XCTAssertEqual(UARTInstance.allCases.count, 8)
        for (instance, base) in instances {
            XCTAssertEqual(UInt(instance.rawValue), base)
            let io = STM32UARTRegisters(instance: instance)
            for (register, offset) in offsets {
                if instance == .lpuart1 && (register == .gtpr || register == .rtor) { continue }
                XCTAssertEqual(io.address(of: register), base + offset, "\(instance) \(register)")
            }
        }
    }

    func testSharedConfigurationStateHalfwordPaddingAndNativePointers() {
        withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 37) { words in
            withUnsafeTemporaryAllocation(of: UInt.self, capacity: 4) { pointers in
                words.initialize(repeating: 0xA55AA55A); pointers.initialize(repeating: 0xC001C0DE)
                let io = STM32UARTHandleRegisters(
                    words: .init(start: words.baseAddress! + 1, count: 35),
                    pointers: .init(start: pointers.baseAddress! + 1, count: 2))
                let copy = io
                for field in UARTConfigurationWord.allCases {
                    let value = UInt32(field.rawValue) | 0x80000000
                    io.write(field, value: value)
                    XCTAssertEqual(copy.read(field), value)
                    XCTAssertEqual(words[1 + field.rawValue], value)
                }
                for field in UARTAdvancedConfigurationWord.allCases {
                    let value = UInt32(field.rawValue) | 0x40000000
                    copy.write(field, value: value)
                    XCTAssertEqual(io.read(field), value)
                    XCTAssertEqual(words[10 + field.rawValue], value)
                }
                for field in UARTHandleHalfWord.allCases {
                    io.write(field, value: UInt16(field.rawValue) | 0xFFF0)
                    XCTAssertEqual(copy.read(field), UInt16(field.rawValue) | 0xFFF0)
                    XCTAssertEqual(words[20 + field.rawValue], 0xA55AFFF0 | UInt32(field.rawValue))
                }
                for field in UARTHandleWord.allCases {
                    let value = UInt32(field.rawValue) | 0x20000000
                    io.write(field, value: value)
                    XCTAssertEqual(copy.read(field), value)
                    XCTAssertEqual(words[27 + field.rawValue], value)
                }
                for field in UARTBufferPointer.allCases {
                    let address: UInt = MemoryLayout<UInt>.size == 8 ? 0x123456789ABC0000 : 0x24038000
                    let pointer = UnsafeMutableRawPointer(bitPattern: address + UInt(field.rawValue) * 8)
                    copy.writePointer(field, value: pointer)
                    XCTAssertEqual(io.readPointer(field), pointer)
                    XCTAssertEqual(pointers[1 + field.rawValue], UInt(bitPattern: pointer))
                    io.writePointer(field, value: nil)
                    XCTAssertNil(copy.readPointer(field))
                }
                XCTAssertEqual(words[0], 0xA55AA55A); XCTAssertEqual(words[36], 0xA55AA55A)
                XCTAssertEqual(pointers[0], 0xC001C0DE); XCTAssertEqual(pointers[3], 0xC001C0DE)
            }
        }
    }

    func testBothCallbackSignaturesUseSharedNativeSlotsAndForwardContext() {
        withUnsafeTemporaryAllocation(of: UInt.self, capacity: 16) { storage in
            withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 2) { context in
                storage.initialize(repeating: 0)
                storage[0] = 0xABCDEF01; storage[15] = 0xABCDEF02
                context.initialize(repeating: 0)
                let io = STM32UARTCallbackRegisters(storage: .init(start: storage.baseAddress! + 1, count: 14),
                    context: UnsafeMutableRawPointer(context.baseAddress!))
                let copy = io
                let callback: UARTCallback = { $0!.assumingMemoryBound(to: UInt32.self)[0] &+= 1 }
                let rxEvent: UARTRxEventCallback = { $0!.assumingMemoryBound(to: UInt32.self)[1] = UInt32($1) }
                for field in UARTCallbackID.allCases {
                    XCTAssertNil(copy.read(field))
                    io.write(field, value: callback)
                    XCTAssertEqual(storage[1 + Int(field.rawValue)], unsafeBitCast(callback, to: UInt.self))
                    copy.read(field)!(copy.context)
                    copy.write(field, value: nil)
                    XCTAssertNil(io.read(field))
                }
                XCTAssertEqual(context[0], 13)
                io.writeRxEventCallback(rxEvent)
                XCTAssertEqual(storage[14], unsafeBitCast(rxEvent, to: UInt.self))
                copy.readRxEventCallback()!(copy.context, .max)
                XCTAssertEqual(context[1], 0xFFFF)
                copy.writeRxEventCallback(nil)
                XCTAssertNil(io.readRxEventCallback())
                XCTAssertEqual(storage[0], 0xABCDEF01); XCTAssertEqual(storage[15], 0xABCDEF02)
            }
        }
    }

    func testDMAParentReaderUsesLiveExistingParentSlot() {
        withUnsafeTemporaryAllocation(of: UInt.self, capacity: 6) { storage in
            storage.initialize(repeating: 0)
            let dmaCallbacks = STM32DMACallbackRegisters(storage: storage)
            let reader: UARTDMAParentReader = stm32UARTDMAReadParent
            let context = UnsafeMutableRawPointer(storage.baseAddress!)
            XCTAssertNil(reader(context))
            for bits: UInt in [0x24030100, 0x24030200, 0] {
                dmaCallbacks.writeParent(UnsafeMutableRawPointer(bitPattern: bits))
                XCTAssertEqual(UInt(bitPattern: reader(context)), bits)
                XCTAssertEqual(storage[5], bits)
            }
        }
    }
}
