import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class I2CRegisterLayoutTests: XCTestCase {
  func testAllCMSISInstancesAndSVDRegisterOffsets() {
    XCTAssertEqual(I2CInstance.allCases.count, 3)
    for (instance, base): (I2CInstance, UInt32) in [
      (.i2c1, 0x4000_5400), (.i2c2, 0x4000_5800), (.i2c3, 0x4000_5C00),
    ] {
      let registers = STM32I2CRegisters(instance)
      for register in I2CRegister.allCases {
        XCTAssertEqual(registers.address(of: register), base + register.rawValue)
      }
    }
  }
  func testSharedStorageHalfwordPaddingAndNativeBufferPointer() {
    withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 22) { words in
      withUnsafeTemporaryAllocation(of: UInt.self, capacity: 3) { pointers in
        words.initialize(repeating: 0xA55A_A55A)
        pointers.initialize(repeating: 0xC001_C0DE)
        let io = STM32I2CHandleRegisters(
          words: .init(start: words.baseAddress! + 1, count: 20),
          pointers: .init(start: pointers.baseAddress! + 1, count: 1))
        let copy = io
        for word in I2CConfigurationWord.allCases {
          io.write(word, value: 0x8000_0000 | UInt32(word.rawValue))
          XCTAssertEqual(copy.read(word), 0x8000_0000 | UInt32(word.rawValue))
          XCTAssertEqual(words[1 + word.rawValue], copy.read(word))
        }
        for word in I2CHandleHalfWord.allCases {
          copy.write(word, value: 0xFFF0 | UInt16(word.rawValue))
          XCTAssertEqual(io.read(word), 0xFFF0 | UInt16(word.rawValue))
          XCTAssertEqual(words[9 + word.rawValue], 0xA55A_FFF0 | UInt32(word.rawValue))
        }
        for word in I2CHandleWord.allCases {
          io.write(word, value: 0x4000_0000 | UInt32(word.rawValue))
          XCTAssertEqual(copy.read(word), 0x4000_0000 | UInt32(word.rawValue))
          XCTAssertEqual(words[11 + word.rawValue], copy.read(word))
        }
        let address: UInt = MemoryLayout<UInt>.size == 8 ? 0x1234_5678_ABC0_0000 : 0x2403_8000
        let pointer = UnsafeMutablePointer<UInt8>(bitPattern: address)
        io.writeBuffer(pointer)
        XCTAssertEqual(copy.readBuffer(), pointer)
        XCTAssertEqual(pointers[1], address)
        copy.writeBuffer(nil)
        XCTAssertNil(io.readBuffer())
        XCTAssertEqual(words[0], 0xA55A_A55A)
        XCTAssertEqual(words[21], 0xA55A_A55A)
        XCTAssertEqual(pointers[0], 0xC001_C0DE)
        XCTAssertEqual(pointers[2], 0xC001_C0DE)
      }
    }
  }
  func testBothCallbackSignaturesAndContext() {
    withUnsafeTemporaryAllocation(of: UInt.self, capacity: 14) { storage in
      withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 3) { context in
        storage.initialize(repeating: 0)
        storage[0] = 0x1234
        storage[13] = 0x5678
        context.initialize(repeating: 0)
        let io = STM32I2CCallbackRegisters(
          storage: .init(start: storage.baseAddress! + 1, count: 12),
          context: UnsafeMutableRawPointer(context.baseAddress!))
        let copy = io
        let callback: I2CCallback = { $0!.assumingMemoryBound(to: UInt32.self)[0] &+= 1 }
        let addressCallback: I2CAddressCallback = { context, direction, match in
          context!.assumingMemoryBound(to: UInt32.self)[1] = UInt32(direction)
          context!.assumingMemoryBound(to: UInt32.self)[2] = UInt32(match)
        }
        for id in I2CCallbackID.allCases {
          XCTAssertNil(copy.read(id))
          io.write(id, value: callback)
          copy.read(id)!(copy.context)
          copy.write(id, value: nil)
          XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(context[0], 11)
        io.writeAddress(addressCallback)
        copy.readAddress()!(copy.context, 0xFF, 0xABCD)
        XCTAssertEqual(context[1], 0xFF)
        XCTAssertEqual(context[2], 0xABCD)
        copy.writeAddress(nil)
        XCTAssertNil(io.readAddress())
        XCTAssertEqual(storage[0], 0x1234)
        XCTAssertEqual(storage[13], 0x5678)
      }
    }
  }
}
