import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class SMBUSRegisterLayoutTests: XCTestCase {
  func testAllCMSISInstancesAndSVDRegisterOffsets() {
    XCTAssertEqual(SMBUSInstance.allCases.count, 3)
    for (instance, base): (SMBUSInstance, UInt32) in [
      (.i2c1, 0x4000_5400), (.i2c2, 0x4000_5800), (.i2c3, 0x4000_5C00),
    ] {
      let registers = STM32SMBUSRegisters(instance)
      for register in SMBUSRegister.allCases {
        XCTAssertEqual(registers.address(of: register), base + register.rawValue)
      }
    }
  }
  func testSharedStorageHalfwordPaddingAndNativeBufferPointer() {
    withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 21) { words in
      withUnsafeTemporaryAllocation(of: UInt.self, capacity: 3) { pointers in
        words.initialize(repeating: 0xA55A_A55A)
        pointers.initialize(repeating: 0xC001_C0DE)
        let io = STM32SMBUSHandleRegisters(
          words: .init(start: words.baseAddress! + 1, count: 19),
          pointers: .init(start: pointers.baseAddress! + 1, count: 1))
        let copy = io
        for word in SMBUSConfigurationWord.allCases {
          io.write(word, value: 0x8000_0000 | UInt32(word.rawValue))
          XCTAssertEqual(copy.read(word), 0x8000_0000 | UInt32(word.rawValue))
          XCTAssertEqual(words[1 + word.rawValue], copy.read(word))
        }
        for word in SMBUSHandleHalfWord.allCases {
          copy.write(word, value: 0xFFF0 | UInt16(word.rawValue))
          XCTAssertEqual(io.read(word), 0xFFF0 | UInt16(word.rawValue))
          XCTAssertEqual(words[13 + word.rawValue], 0xA55A_FFF0 | UInt32(word.rawValue))
        }
        for word in SMBUSHandleWord.allCases {
          io.write(word, value: 0x4000_0000 | UInt32(word.rawValue))
          XCTAssertEqual(copy.read(word), 0x4000_0000 | UInt32(word.rawValue))
          XCTAssertEqual(words[15 + word.rawValue], copy.read(word))
        }
        let address: UInt = MemoryLayout<UInt>.size == 8 ? 0x1234_5678_ABC0_0000 : 0x2403_8000
        let pointer = UnsafeMutablePointer<UInt8>(bitPattern: address)
        io.writeBuffer(pointer)
        XCTAssertEqual(copy.readBuffer(), pointer)
        XCTAssertEqual(pointers[1], address)
        copy.writeBuffer(nil)
        XCTAssertNil(io.readBuffer())
        XCTAssertEqual(words[0], 0xA55A_A55A)
        XCTAssertEqual(words[20], 0xA55A_A55A)
        XCTAssertEqual(pointers[0], 0xC001_C0DE)
        XCTAssertEqual(pointers[2], 0xC001_C0DE)
      }
    }
  }
  func testBothCallbackSignaturesAndContext() {
    withUnsafeTemporaryAllocation(of: UInt.self, capacity: 11) { storage in
      withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 3) { context in
        storage.initialize(repeating: 0)
        storage[0] = 0x1234
        storage[10] = 0x5678
        context.initialize(repeating: 0)
        let io = STM32SMBUSCallbackRegisters(
          storage: .init(start: storage.baseAddress! + 1, count: 9),
          context: UnsafeMutableRawPointer(context.baseAddress!))
        let copy = io
        let callback: SMBUSCallback = { $0!.assumingMemoryBound(to: UInt32.self)[0] &+= 1 }
        let addressCallback: SMBUSAddressCallback = { context, direction, match in
          context!.assumingMemoryBound(to: UInt32.self)[1] = UInt32(direction)
          context!.assumingMemoryBound(to: UInt32.self)[2] = UInt32(match)
        }
        for id in SMBUSCallbackID.allCases {
          XCTAssertNil(copy.read(id))
          io.write(id, value: callback)
          copy.read(id)!(copy.context)
          copy.write(id, value: nil)
          XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(context[0], 8)
        io.writeAddress(addressCallback)
        copy.readAddress()!(copy.context, 0xFF, 0xABCD)
        XCTAssertEqual(context[1], 0xFF)
        XCTAssertEqual(context[2], 0xABCD)
        copy.writeAddress(nil)
        XCTAssertNil(io.readAddress())
        XCTAssertEqual(storage[0], 0x1234)
        XCTAssertEqual(storage[10], 0x5678)
      }
    }
  }
}
