import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class MMCRegisterLayoutTests: XCTestCase {
  func testSharedHandleStorageAndPointers() {
    withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 158) { words in
      withUnsafeTemporaryAllocation(of: UInt.self, capacity: 4) { pointers in
        words.initialize(repeating: 0xA55A_A55A)
        pointers.initialize(repeating: 0xC001_C0DE)
        let io = STM32MMCHandleRegisters(
          words: .init(start: words.baseAddress! + 1, count: 156),
          pointers: .init(start: pointers.baseAddress! + 1, count: 2))
        let copy = io
        for item in MMCConfigurationWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[1 + item.rawValue], copy.read(item))
        }
        for item in MMCHandleWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[7 + item.rawValue], copy.read(item))
        }
        for item in MMCCardWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[14 + item.rawValue], copy.read(item))
        }
        for register in MMCCardRegister.allCases {
          for i in 0..<4 {
            io.writeCardRegister(
              register, index: i, value: 0x1234_0000 | UInt32(register.rawValue * 4 + i))
            XCTAssertEqual(
              copy.readCardRegister(register, index: i),
              0x1234_0000 | UInt32(register.rawValue * 4 + i))
            XCTAssertEqual(
              words[21 + register.rawValue * 4 + i], copy.readCardRegister(register, index: i))
          }
        }
        io.writeRPMBErrorCode(0x1234)
        XCTAssertEqual(copy.readRPMBErrorCode(), 0x1234)
        XCTAssertEqual(words[13], 0xA55A_1234)
        for i in 0..<128 {
          io.extendedCSDPointer()[i] = UInt32(i) | 0xABCD_0000
          XCTAssertEqual(words[29 + i], UInt32(i) | 0xABCD_0000)
          XCTAssertEqual(copy.extendedCSDPointer()[i], UInt32(i) | 0xABCD_0000)
        }
        let bits: UInt = MemoryLayout<UInt>.size == 8 ? 0x1234_5678_ABC0_0000 : 0x2403_8000
        io.writeTransmitBuffer(.init(bitPattern: bits))
        io.writeReceiveBuffer(.init(bitPattern: bits + 4))
        XCTAssertEqual(UInt(bitPattern: copy.readTransmitBuffer()), bits)
        XCTAssertEqual(UInt(bitPattern: copy.readReceiveBuffer()), bits + 4)
        XCTAssertEqual(pointers[1], bits)
        XCTAssertEqual(pointers[2], bits + 4)
        copy.writeTransmitBuffer(nil)
        copy.writeReceiveBuffer(nil)
        XCTAssertNil(io.readTransmitBuffer())
        XCTAssertNil(io.readReceiveBuffer())
        XCTAssertEqual(words[0], 0xA55A_A55A)
        XCTAssertEqual(words[157], 0xA55A_A55A)
        XCTAssertEqual(pointers[0], 0xC001_C0DE)
        XCTAssertEqual(pointers[3], 0xC001_C0DE)
      }
    }
  }
  func testCallbackSlotsAndSignatures() {
    withUnsafeTemporaryAllocation(of: UInt.self, capacity: 10) { storage in
      withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 1) { context in
        storage.initialize(repeating: 0)
        context.initialize(repeating: 0)
        storage[0] = 0x1234
        storage[9] = 0x5678
        let io = STM32MMCCallbackRegisters(
          storage: .init(start: storage.baseAddress! + 1, count: 8),
          context: UnsafeMutableRawPointer(context.baseAddress!))
        let copy = io
        let callback: MMCCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for (slot, id) in MMCCallbackID.allCases.enumerated() {
          XCTAssertNil(io.read(id))
          io.write(id, value: callback)
          XCTAssertEqual(storage[slot + 1], unsafeBitCast(callback, to: UInt.self))
          copy.read(id)!(copy.context)
          copy.write(id, value: nil)
          XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(context[0], 8)
        XCTAssertEqual(storage[0], 0x1234)
        XCTAssertEqual(storage[9], 0x5678)
      }
    }
  }
}
