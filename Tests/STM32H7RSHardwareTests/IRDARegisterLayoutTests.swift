import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class IRDARegisterLayoutTests: XCTestCase {
  func testNarrowFieldsPaddingAndSharedNativePointers() {
    withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 18) { words in
      withUnsafeTemporaryAllocation(of: UInt.self, capacity: 4) { pointers in
        words.initialize(repeating: 0xA55A_A55A)
        pointers.initialize(repeating: 0xC001_C0DE)
        let io = STM32IRDAHandleRegisters(
          words: .init(start: words.baseAddress! + 1, count: 16),
          pointers: .init(start: pointers.baseAddress! + 1, count: 2))
        let copy = io
        io.write(IRDAConfigurationWord.baudRate, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(IRDAConfigurationWord.baudRate), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[1], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(IRDAConfigurationWord.wordLength, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(IRDAConfigurationWord.wordLength), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[2], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(IRDAConfigurationWord.parity, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(IRDAConfigurationWord.parity), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[3], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(IRDAConfigurationWord.mode, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(IRDAConfigurationWord.mode), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[4], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(IRDAConfigurationWord.prescaler, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(IRDAConfigurationWord.prescaler), 0xFECD_AB98 & 0xFF)
        XCTAssertEqual(words[5], (0xA55A_A55A & ~UInt32(0xFF)) | (0xFECD_AB98 & 0xFF))
        io.write(IRDAConfigurationWord.powerMode, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(IRDAConfigurationWord.powerMode), 0xFECD_AB98 & 0xFFFF)
        XCTAssertEqual(words[6], (0xA55A_A55A & ~UInt32(0xFFFF)) | (0xFECD_AB98 & 0xFFFF))
        io.write(IRDAConfigurationWord.clockPrescaler, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(IRDAConfigurationWord.clockPrescaler), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[7], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(IRDAHandleHalfWord.transmitSize, value: 0xFEDC)
        XCTAssertEqual(copy.read(IRDAHandleHalfWord.transmitSize), 0xFEDC)
        XCTAssertEqual(words[8], 0xA55A_FEDC)
        io.write(IRDAHandleHalfWord.transmitCount, value: 0xFEDC)
        XCTAssertEqual(copy.read(IRDAHandleHalfWord.transmitCount), 0xFEDC)
        XCTAssertEqual(words[9], 0xA55A_FEDC)
        io.write(IRDAHandleHalfWord.receiveSize, value: 0xFEDC)
        XCTAssertEqual(copy.read(IRDAHandleHalfWord.receiveSize), 0xFEDC)
        XCTAssertEqual(words[10], 0xA55A_FEDC)
        io.write(IRDAHandleHalfWord.receiveCount, value: 0xFEDC)
        XCTAssertEqual(copy.read(IRDAHandleHalfWord.receiveCount), 0xFEDC)
        XCTAssertEqual(words[11], 0xA55A_FEDC)
        io.write(IRDAHandleHalfWord.mask, value: 0xFEDC)
        XCTAssertEqual(copy.read(IRDAHandleHalfWord.mask), 0xFEDC)
        XCTAssertEqual(words[12], 0xA55A_FEDC)
        io.write(IRDAHandleWord.lock, value: 0xFEDC_BA98)
        XCTAssertEqual(copy.read(IRDAHandleWord.lock), 0xFEDC_BA98)
        XCTAssertEqual(words[13], 0xFEDC_BA98)
        io.write(IRDAHandleWord.globalState, value: 0xFEDC_BA98)
        XCTAssertEqual(copy.read(IRDAHandleWord.globalState), 0xFEDC_BA98)
        XCTAssertEqual(words[14], 0xFEDC_BA98)
        io.write(IRDAHandleWord.receiveState, value: 0xFEDC_BA98)
        XCTAssertEqual(copy.read(IRDAHandleWord.receiveState), 0xFEDC_BA98)
        XCTAssertEqual(words[15], 0xFEDC_BA98)
        io.write(IRDAHandleWord.errorCode, value: 0xFEDC_BA98)
        XCTAssertEqual(copy.read(IRDAHandleWord.errorCode), 0xFEDC_BA98)
        XCTAssertEqual(words[16], 0xFEDC_BA98)
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
        XCTAssertEqual(words[17], 0xA55A_A55A)
        XCTAssertEqual(pointers[0], 0xC001_C0DE)
        XCTAssertEqual(pointers[3], 0xC001_C0DE)
      }
    }
  }
  func testCallbackSlotsShareNativeWidthAndForwardContext() {
    withUnsafeTemporaryAllocation(of: UInt.self, capacity: 12) { storage in
      withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 2) { context in
        storage.initialize(repeating: 0)
        storage[0] = 0xABCD_EF01
        storage[11] = 0xABCD_EF02
        context.initialize(repeating: 0)
        let io = STM32IRDACallbackRegisters(
          storage: .init(start: storage.baseAddress! + 1, count: 10),
          context: UnsafeMutableRawPointer(context.baseAddress!))
        let copy = io
        let callback: IRDACallback = { $0!.assumingMemoryBound(to: UInt32.self)[0] &+= 1 }
        for field in IRDACallbackID.allCases {
          XCTAssertNil(copy.read(field))
          io.write(field, value: callback)
          XCTAssertEqual(storage[1 + Int(field.rawValue)], unsafeBitCast(callback, to: UInt.self))
          copy.read(field)!(copy.context)
          copy.write(field, value: nil)
          XCTAssertNil(io.read(field))
        }
        XCTAssertEqual(context[0], 10)
        XCTAssertEqual(storage[0], 0xABCD_EF01)
        XCTAssertEqual(storage[11], 0xABCD_EF02)
      }
    }
  }

}
