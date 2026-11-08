import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class SDIORegisterLayoutTests: XCTestCase {
  func testLiveHandleWordHalfwordByteAndPointerSlots() {
    withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 20) { words in
      withUnsafeTemporaryAllocation(of: UInt.self, capacity: 4) { pointers in
        words.initialize(repeating: 0xA55A_A55A)
        pointers.initialize(repeating: 0xC001_C0DE)
        let io = STM32SDIOHandleRegisters(
          words: .init(start: words.baseAddress! + 1, count: 18),
          pointers: .init(start: pointers.baseAddress! + 1, count: 2))
        let copy = io
        for field in SDIOConfigurationWord.allCases {
          io.write(field, value: UInt32(field.rawValue) | 0x8000_0000)
          XCTAssertEqual(copy.read(field), words[1 + field.rawValue])
        }
        for field in SDIOHandleWord.allCases {
          io.write(field, value: UInt32(field.rawValue) | 0x4000_0000)
          XCTAssertEqual(copy.read(field), words[7 + field.rawValue])
        }
        io.write(.blockSize, value: 512)
        XCTAssertEqual(copy.read(.blockSize), 512)
        XCTAssertEqual(words[16], 0xA55A_0200)
        for field in SDIOHandleByte.allCases {
          io.write(field, value: UInt8(field.rawValue + 0x80))
          XCTAssertEqual(copy.read(field), UInt8(field.rawValue + 0x80))
          XCTAssertEqual(words[17 + field.rawValue], 0xA55A_A500 | UInt32(field.rawValue + 0x80))
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
        XCTAssertEqual(words[19], 0xA55A_A55A)
        XCTAssertEqual(pointers[0], 0xC001_C0DE)
        XCTAssertEqual(pointers[3], 0xC001_C0DE)
      }
    }
  }

  func testCallbackSignaturesAndDefaultIdentificationStorage() {
    withUnsafeTemporaryAllocation(of: UInt.self, capacity: 16) { storage in
      withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 1) { context in
        storage.initialize(repeating: 0)
        context.initialize(repeating: 0)
        storage[0] = 0x1234
        storage[15] = 0x5678
        let io = STM32SDIOCallbackRegisters(
          storage: .init(start: storage.baseAddress! + 1, count: 14),
          context: UnsafeMutableRawPointer(context.baseAddress!))
        let copy = io
        let callback: SDIOCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for (slot, id) in SDIOCallbackID.allCases.enumerated() {
          XCTAssertNil(copy.read(id))
          io.write(id, value: callback)
          XCTAssertEqual(storage[1 + slot], unsafeBitCast(callback, to: UInt.self))
          copy.read(id)!(copy.context)
          copy.write(id, value: nil)
          XCTAssertNil(io.read(id))
        }
        let valueCallback: SDIOFunctionCallback = {
          $0!.assumingMemoryBound(to: UInt32.self).pointee &+= $1
        }
        io.writeTransceiver(valueCallback)
        copy.readTransceiver()!(copy.context, 10)
        XCTAssertEqual(storage[6], unsafeBitCast(valueCallback, to: UInt.self))
        for index: UInt32 in 0..<7 {
          io.writeIOFunction(index, value: valueCallback)
          copy.readIOFunction(index)!(copy.context, index)
          XCTAssertEqual(storage[8 + Int(index)], unsafeBitCast(valueCallback, to: UInt.self))
          copy.writeIOFunction(index, value: nil)
          XCTAssertNil(io.readIOFunction(index))
        }
        let identify: SDIOIdentifyCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee }
        io.writeIdentify(.initializeCard)
        if case .initializeCard = copy.readIdentify() {} else { XCTFail() }
        io.writeIdentify(.custom(identify))
        if case .custom(let function) = copy.readIdentify() {
          XCTAssertEqual(function(copy.context), 36)
        } else {
          XCTFail()
        }
        io.writeIdentify(.none)
        if case .none = copy.readIdentify() {} else { XCTFail() }
        copy.writeTransceiver(nil)
        XCTAssertNil(io.readTransceiver())
        XCTAssertEqual(storage[0], 0x1234)
        XCTAssertEqual(storage[15], 0x5678)
      }
    }
  }
}
