import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class NANDRegisterLayoutTests: XCTestCase {
  func testLiveHandleFieldsAndSharedStorage() {
    let storage = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 18)
    storage.initialize(repeating: 0xC001_C0DE)
    defer { storage.deallocate() }
    let live = UnsafeMutableBufferPointer(start: storage.baseAddress! + 1, count: 16)
    let a = STM32NANDHandleRegisters(storage: live)
    let b = STM32NANDHandleRegisters(storage: live)
    for field in NANDConfigurationWord.allCases {
      a.write(field, value: UInt32(field.rawValue) | 0x1000)
      XCTAssertEqual(b.read(field), UInt32(field.rawValue) | 0x1000)
      XCTAssertEqual(live[field.rawValue], UInt32(field.rawValue) | 0x1000)
    }
    for field in NANDHandleWord.allCases {
      a.write(field, value: UInt32(field.rawValue) | 0x2000)
      XCTAssertEqual(b.read(field), UInt32(field.rawValue) | 0x2000)
      XCTAssertEqual(live[7 + field.rawValue], UInt32(field.rawValue) | 0x2000)
    }
    for field in NANDDeviceConfigurationWord.allCases {
      a.write(field, value: UInt32(field.rawValue) | 0x3000)
      XCTAssertEqual(b.read(field), UInt32(field.rawValue) | 0x3000)
      XCTAssertEqual(live[9 + field.rawValue], UInt32(field.rawValue) | 0x3000)
    }
    live[8] = 3
    XCTAssertEqual(a.read(NANDHandleWord.state), 3)
    live[9] = 2048
    XCTAssertEqual(a.read(NANDDeviceConfigurationWord.pageSize), 2048)
    XCTAssertEqual(storage[0], 0xC001_C0DE)
    XCTAssertEqual(storage[17], 0xC001_C0DE)
  }

  func testCallbacksUseNativeWidthUnownedSharedStorage() {
    let storage = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 5)
    storage.initialize(repeating: 0xA55A_A55A)
    defer { storage.deallocate() }
    let live = UnsafeMutableBufferPointer(start: storage.baseAddress! + 1, count: 3)
    live.update(repeating: 0)
    let counter = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
    counter.initialize(to: 0)
    defer { counter.deallocate() }
    let a = STM32NANDCallbackRegisters(storage: live, context: counter)
    let b = STM32NANDCallbackRegisters(storage: live, context: counter)
    let callback: NANDCallback = { context in
      context!.assumingMemoryBound(to: UInt32.self).pointee &+= 1
    }
    for id in NANDCallbackID.allCases {
      XCTAssertNil(a.read(id))
      a.write(id, value: callback)
      XCTAssertEqual(live[Int(id.rawValue)], unsafeBitCast(callback, to: UInt.self))
      b.read(id)!(b.context)
      b.write(id, value: nil)
      XCTAssertNil(a.read(id))
    }
    XCTAssertEqual(counter.pointee, 3)
    XCTAssertEqual(storage[0], 0xA55A_A55A)
    XCTAssertEqual(storage[4], 0xA55A_A55A)
  }
}
