import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class USARTRegisterLayoutTests: XCTestCase {
  func testSharedConfigurationStateHalfwordPaddingAndNativePointers() {
    withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 25) { words in
      withUnsafeTemporaryAllocation(of: UInt.self, capacity: 4) { pointers in
        words.initialize(repeating: 0xA55A_A55A)
        pointers.initialize(repeating: 0xC001_C0DE)
        let io = STM32USARTHandleRegisters(
          words: .init(start: words.baseAddress! + 1, count: 23),
          pointers: .init(start: pointers.baseAddress! + 1, count: 2))
        let copy = io
        for field in USARTConfigurationWord.allCases {
          let value = UInt32(field.rawValue) | 0x8000_0000
          io.write(field, value: value)
          XCTAssertEqual(copy.read(field), value)
          XCTAssertEqual(words[1 + field.rawValue], value)
        }
        for field in UARTHandleHalfWord.allCases {
          io.write(field, value: UInt16(field.rawValue) | 0xFFF0)
          XCTAssertEqual(copy.read(field), UInt16(field.rawValue) | 0xFFF0)
          XCTAssertEqual(words[10 + field.rawValue], 0xA55A_FFF0 | UInt32(field.rawValue))
        }
        for field in USARTHandleWord.allCases {
          let value = UInt32(field.rawValue) | 0x2000_0000
          io.write(field, value: value)
          XCTAssertEqual(copy.read(field), value)
          XCTAssertEqual(words[17 + field.rawValue], value)
        }
        for field in UARTBufferPointer.allCases {
          let address: UInt = MemoryLayout<UInt>.size == 8 ? 0x1234_5678_9ABC_0000 : 0x2403_8000
          let pointer = UnsafeMutableRawPointer(bitPattern: address + UInt(field.rawValue) * 8)
          copy.writePointer(field, value: pointer)
          XCTAssertEqual(io.readPointer(field), pointer)
          XCTAssertEqual(pointers[1 + field.rawValue], UInt(bitPattern: pointer))
          io.writePointer(field, value: nil)
          XCTAssertNil(copy.readPointer(field))
        }
        XCTAssertEqual(words[0], 0xA55A_A55A)
        XCTAssertEqual(words[24], 0xA55A_A55A)
        XCTAssertEqual(pointers[0], 0xC001_C0DE)
        XCTAssertEqual(pointers[3], 0xC001_C0DE)
      }
    }
  }

  func testCallbackSlotsShareNativeWidthAndForwardContext() {
    withUnsafeTemporaryAllocation(of: UInt.self, capacity: 13) { storage in
      withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 2) { context in
        storage.initialize(repeating: 0)
        storage[0] = 0xABCD_EF01
        storage[12] = 0xABCD_EF02
        context.initialize(repeating: 0)
        let io = STM32USARTCallbackRegisters(
          storage: .init(start: storage.baseAddress! + 1, count: 11),
          context: UnsafeMutableRawPointer(context.baseAddress!))
        let copy = io
        let callback: USARTCallback = { $0!.assumingMemoryBound(to: UInt32.self)[0] &+= 1 }
        for field in USARTCallbackID.allCases {
          XCTAssertNil(copy.read(field))
          io.write(field, value: callback)
          XCTAssertEqual(storage[1 + Int(field.rawValue)], unsafeBitCast(callback, to: UInt.self))
          copy.read(field)!(copy.context)
          copy.write(field, value: nil)
          XCTAssertNil(io.read(field))
        }
        XCTAssertEqual(context[0], 11)
        XCTAssertEqual(storage[0], 0xABCD_EF01)
        XCTAssertEqual(storage[12], 0xABCD_EF02)
      }
    }
  }

}
