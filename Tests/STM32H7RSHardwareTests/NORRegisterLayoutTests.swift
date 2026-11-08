import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class NORRegisterLayoutTests: XCTestCase {
  func testSharedWidthWordIsLiveAcrossWrappers() {
    let word = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
    word.initialize(to: 0)
    defer { word.deallocate() }
    let a = STM32NORSharedRegisters(memoryDataWidth: word)
    let b = STM32NORSharedRegisters(memoryDataWidth: word)
    XCTAssertEqual(a.readMemoryDataWidth(), 0)
    a.writeMemoryDataWidth(1)
    XCTAssertEqual(b.readMemoryDataWidth(), 1)
    word.pointee = 0xDEAD_BEEF
    XCTAssertEqual(a.readMemoryDataWidth(), 0xDEAD_BEEF)
    b.writeMemoryDataWidth(0)
    XCTAssertEqual(word.pointee, 0)
  }

  func testLiveHandleFieldsAndSharedStorage() {
    let storage = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 20)
    storage.initialize(repeating: 0xC001_C0DE)
    defer { storage.deallocate() }
    let live = UnsafeMutableBufferPointer(start: storage.baseAddress! + 1, count: 18)
    let a = STM32NORHandleRegisters(storage: live)
    let b = STM32NORHandleRegisters(storage: live)
    for field in NORConfigurationWord.allCases {
      a.write(field, value: UInt32(field.rawValue) | 0x1000)
      XCTAssertEqual(b.read(field), UInt32(field.rawValue) | 0x1000)
      XCTAssertEqual(live[field.rawValue], UInt32(field.rawValue) | 0x1000)
    }
    for field in NORHandleWord.allCases {
      a.write(field, value: UInt32(field.rawValue) | 0x2000)
      XCTAssertEqual(b.read(field), UInt32(field.rawValue) | 0x2000)
      XCTAssertEqual(live[15 + field.rawValue], UInt32(field.rawValue) | 0x2000)
    }
    live[16] = 3
    XCTAssertEqual(a.read(NORHandleWord.state), 3)
    live[17] = 2
    XCTAssertEqual(a.read(NORHandleWord.commandSet), 2)
    XCTAssertEqual(storage[0], 0xC001_C0DE)
    XCTAssertEqual(storage[19], 0xC001_C0DE)
  }

  func testCallbacksUseNativeWidthUnownedSharedStorage() {
    let storage = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 4)
    storage.initialize(repeating: 0xA55A_A55A)
    defer { storage.deallocate() }
    let live = UnsafeMutableBufferPointer(start: storage.baseAddress! + 1, count: 2)
    live.update(repeating: 0)
    let counter = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
    counter.initialize(to: 0)
    defer { counter.deallocate() }
    let a = STM32NORCallbackRegisters(storage: live, context: counter)
    let b = STM32NORCallbackRegisters(storage: live, context: counter)
    let callback: NORCallback = { context in
      context!.assumingMemoryBound(to: UInt32.self).pointee &+= 1
    }
    for id in NORCallbackID.allCases {
      XCTAssertNil(a.read(id))
      a.write(id, value: callback)
      XCTAssertEqual(live[Int(id.rawValue)], unsafeBitCast(callback, to: UInt.self))
      b.read(id)!(b.context)
      b.write(id, value: nil)
      XCTAssertNil(a.read(id))
    }
    XCTAssertEqual(counter.pointee, 2)
    XCTAssertEqual(storage[0], 0xA55A_A55A)
    XCTAssertEqual(storage[3], 0xA55A_A55A)
  }
}
