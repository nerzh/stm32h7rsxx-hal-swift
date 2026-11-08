import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class SMARTCARDRegisterLayoutTests: XCTestCase {
  func testNarrowFieldsPaddingAndSharedNativePointers() {
    withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 41) { words in
      withUnsafeTemporaryAllocation(of: UInt.self, capacity: 4) { pointers in
        words.initialize(repeating: 0xA55A_A55A)
        pointers.initialize(repeating: 0xC001_C0DE)
        let io = STM32SMARTCARDHandleRegisters(
          words: .init(start: words.baseAddress! + 1, count: 39),
          pointers: .init(start: pointers.baseAddress! + 1, count: 2))
        let copy = io
        io.write(SMARTCARDConfigurationWord.baudRate, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.baudRate), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[1], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(SMARTCARDConfigurationWord.wordLength, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.wordLength), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[2], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(SMARTCARDConfigurationWord.stopBits, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.stopBits), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[3], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(SMARTCARDConfigurationWord.parity, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.parity), 0xFECD_AB98 & 0xFFFF)
        XCTAssertEqual(words[4], (0xA55A_A55A & ~UInt32(0xFFFF)) | (0xFECD_AB98 & 0xFFFF))
        io.write(SMARTCARDConfigurationWord.mode, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.mode), 0xFECD_AB98 & 0xFFFF)
        XCTAssertEqual(words[5], (0xA55A_A55A & ~UInt32(0xFFFF)) | (0xFECD_AB98 & 0xFFFF))
        io.write(SMARTCARDConfigurationWord.clockPolarity, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.clockPolarity), 0xFECD_AB98 & 0xFFFF)
        XCTAssertEqual(words[6], (0xA55A_A55A & ~UInt32(0xFFFF)) | (0xFECD_AB98 & 0xFFFF))
        io.write(SMARTCARDConfigurationWord.clockPhase, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.clockPhase), 0xFECD_AB98 & 0xFFFF)
        XCTAssertEqual(words[7], (0xA55A_A55A & ~UInt32(0xFFFF)) | (0xFECD_AB98 & 0xFFFF))
        io.write(SMARTCARDConfigurationWord.clockLastBit, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.clockLastBit), 0xFECD_AB98 & 0xFFFF)
        XCTAssertEqual(words[8], (0xA55A_A55A & ~UInt32(0xFFFF)) | (0xFECD_AB98 & 0xFFFF))
        io.write(SMARTCARDConfigurationWord.oneBitSampling, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.oneBitSampling), 0xFECD_AB98 & 0xFFFF)
        XCTAssertEqual(words[9], (0xA55A_A55A & ~UInt32(0xFFFF)) | (0xFECD_AB98 & 0xFFFF))
        io.write(SMARTCARDConfigurationWord.prescaler, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.prescaler), 0xFECD_AB98 & 0xFF)
        XCTAssertEqual(words[10], (0xA55A_A55A & ~UInt32(0xFF)) | (0xFECD_AB98 & 0xFF))
        io.write(SMARTCARDConfigurationWord.guardTime, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.guardTime), 0xFECD_AB98 & 0xFF)
        XCTAssertEqual(words[11], (0xA55A_A55A & ~UInt32(0xFF)) | (0xFECD_AB98 & 0xFF))
        io.write(SMARTCARDConfigurationWord.nackEnable, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.nackEnable), 0xFECD_AB98 & 0xFFFF)
        XCTAssertEqual(words[12], (0xA55A_A55A & ~UInt32(0xFFFF)) | (0xFECD_AB98 & 0xFFFF))
        io.write(SMARTCARDConfigurationWord.timeoutEnable, value: 0xFECD_AB98)
        XCTAssertEqual(
          copy.read(SMARTCARDConfigurationWord.timeoutEnable), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[13], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(SMARTCARDConfigurationWord.timeoutValue, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.timeoutValue), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[14], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(SMARTCARDConfigurationWord.blockLength, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.blockLength), 0xFECD_AB98 & 0xFF)
        XCTAssertEqual(words[15], (0xA55A_A55A & ~UInt32(0xFF)) | (0xFECD_AB98 & 0xFF))
        io.write(SMARTCARDConfigurationWord.autoRetryCount, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDConfigurationWord.autoRetryCount), 0xFECD_AB98 & 0xFF)
        XCTAssertEqual(words[16], (0xA55A_A55A & ~UInt32(0xFF)) | (0xFECD_AB98 & 0xFF))
        io.write(SMARTCARDConfigurationWord.clockPrescaler, value: 0xFECD_AB98)
        XCTAssertEqual(
          copy.read(SMARTCARDConfigurationWord.clockPrescaler), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[17], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(SMARTCARDAdvancedConfigurationWord.features, value: 0xFECD_AB98)
        XCTAssertEqual(
          copy.read(SMARTCARDAdvancedConfigurationWord.features), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[18], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(SMARTCARDAdvancedConfigurationWord.txPinLevelInvert, value: 0xFECD_AB98)
        XCTAssertEqual(
          copy.read(SMARTCARDAdvancedConfigurationWord.txPinLevelInvert), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[19], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(SMARTCARDAdvancedConfigurationWord.rxPinLevelInvert, value: 0xFECD_AB98)
        XCTAssertEqual(
          copy.read(SMARTCARDAdvancedConfigurationWord.rxPinLevelInvert), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[20], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(SMARTCARDAdvancedConfigurationWord.dataInvert, value: 0xFECD_AB98)
        XCTAssertEqual(
          copy.read(SMARTCARDAdvancedConfigurationWord.dataInvert), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[21], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(SMARTCARDAdvancedConfigurationWord.swap, value: 0xFECD_AB98)
        XCTAssertEqual(copy.read(SMARTCARDAdvancedConfigurationWord.swap), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[22], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(SMARTCARDAdvancedConfigurationWord.overrunDisable, value: 0xFECD_AB98)
        XCTAssertEqual(
          copy.read(SMARTCARDAdvancedConfigurationWord.overrunDisable), 0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[23], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(SMARTCARDAdvancedConfigurationWord.dmaDisableOnReceiveError, value: 0xFECD_AB98)
        XCTAssertEqual(
          copy.read(SMARTCARDAdvancedConfigurationWord.dmaDisableOnReceiveError),
          0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[24], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(SMARTCARDAdvancedConfigurationWord.mostSignificantBitFirst, value: 0xFECD_AB98)
        XCTAssertEqual(
          copy.read(SMARTCARDAdvancedConfigurationWord.mostSignificantBitFirst),
          0xFECD_AB98 & UInt32.max)
        XCTAssertEqual(words[25], (0xA55A_A55A & ~UInt32(UInt32.max)) | (0xFECD_AB98 & UInt32.max))
        io.write(
          SMARTCARDAdvancedConfigurationWord.transmitCompletionIndication, value: 0xFECD_AB98)
        XCTAssertEqual(
          copy.read(SMARTCARDAdvancedConfigurationWord.transmitCompletionIndication),
          0xFECD_AB98 & 0xFFFF)
        XCTAssertEqual(words[26], (0xA55A_A55A & ~UInt32(0xFFFF)) | (0xFECD_AB98 & 0xFFFF))
        io.write(SMARTCARDHandleHalfWord.transmitSize, value: 0xFEDC)
        XCTAssertEqual(copy.read(SMARTCARDHandleHalfWord.transmitSize), 0xFEDC)
        XCTAssertEqual(words[27], 0xA55A_FEDC)
        io.write(SMARTCARDHandleHalfWord.transmitCount, value: 0xFEDC)
        XCTAssertEqual(copy.read(SMARTCARDHandleHalfWord.transmitCount), 0xFEDC)
        XCTAssertEqual(words[28], 0xA55A_FEDC)
        io.write(SMARTCARDHandleHalfWord.receiveSize, value: 0xFEDC)
        XCTAssertEqual(copy.read(SMARTCARDHandleHalfWord.receiveSize), 0xFEDC)
        XCTAssertEqual(words[29], 0xA55A_FEDC)
        io.write(SMARTCARDHandleHalfWord.receiveCount, value: 0xFEDC)
        XCTAssertEqual(copy.read(SMARTCARDHandleHalfWord.receiveCount), 0xFEDC)
        XCTAssertEqual(words[30], 0xA55A_FEDC)
        io.write(SMARTCARDHandleHalfWord.rxDataToProcess, value: 0xFEDC)
        XCTAssertEqual(copy.read(SMARTCARDHandleHalfWord.rxDataToProcess), 0xFEDC)
        XCTAssertEqual(words[31], 0xA55A_FEDC)
        io.write(SMARTCARDHandleHalfWord.txDataToProcess, value: 0xFEDC)
        XCTAssertEqual(copy.read(SMARTCARDHandleHalfWord.txDataToProcess), 0xFEDC)
        XCTAssertEqual(words[32], 0xA55A_FEDC)
        io.write(SMARTCARDHandleWord.fifoMode, value: 0xFEDC_BA98)
        XCTAssertEqual(copy.read(SMARTCARDHandleWord.fifoMode), 0xFEDC_BA98)
        XCTAssertEqual(words[33], 0xFEDC_BA98)
        io.write(SMARTCARDHandleWord.rxISR, value: 0xFEDC_BA98)
        XCTAssertEqual(copy.read(SMARTCARDHandleWord.rxISR), 0xFEDC_BA98)
        XCTAssertEqual(words[34], 0xFEDC_BA98)
        io.write(SMARTCARDHandleWord.txISR, value: 0xFEDC_BA98)
        XCTAssertEqual(copy.read(SMARTCARDHandleWord.txISR), 0xFEDC_BA98)
        XCTAssertEqual(words[35], 0xFEDC_BA98)
        io.write(SMARTCARDHandleWord.lock, value: 0xFEDC_BA98)
        XCTAssertEqual(copy.read(SMARTCARDHandleWord.lock), 0xFEDC_BA98)
        XCTAssertEqual(words[36], 0xFEDC_BA98)
        io.write(SMARTCARDHandleWord.globalState, value: 0xFEDC_BA98)
        XCTAssertEqual(copy.read(SMARTCARDHandleWord.globalState), 0xFEDC_BA98)
        XCTAssertEqual(words[37], 0xFEDC_BA98)
        io.write(SMARTCARDHandleWord.receiveState, value: 0xFEDC_BA98)
        XCTAssertEqual(copy.read(SMARTCARDHandleWord.receiveState), 0xFEDC_BA98)
        XCTAssertEqual(words[38], 0xFEDC_BA98)
        io.write(SMARTCARDHandleWord.errorCode, value: 0xFEDC_BA98)
        XCTAssertEqual(copy.read(SMARTCARDHandleWord.errorCode), 0xFEDC_BA98)
        XCTAssertEqual(words[39], 0xFEDC_BA98)
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
        XCTAssertEqual(words[40], 0xA55A_A55A)
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
        let io = STM32SMARTCARDCallbackRegisters(
          storage: .init(start: storage.baseAddress! + 1, count: 10),
          context: UnsafeMutableRawPointer(context.baseAddress!))
        let copy = io
        let callback: SMARTCARDCallback = { $0!.assumingMemoryBound(to: UInt32.self)[0] &+= 1 }
        for field in SMARTCARDCallbackID.allCases {
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
