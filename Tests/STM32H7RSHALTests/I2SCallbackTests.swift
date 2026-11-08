import CAudioReference
import STM32H7RSHAL
import XCTest

final class I2SCallbackTests: XCTestCase {
  func testRegistrationStateLockAndNullCallbackOrder() {
    for state: UInt32 in [0, 1, 2, 3, 4, 5, 0x12, 0x22] {
      for lock: UInt32 in [0, 1] {
        for id: UInt32 in 0...9 {
          for custom: UInt32 in [0, 1, 2] {
            let p = I2SPair()
            p.setup {
              $0.write(.state, value: state)
              $0.write(.lock, value: lock)
              $0.write(.errorCode, value: 0x8000_0000)
            }
            p.verify(2, id, custom)
            p.verify(3, id)
          }
        }
      }
    }
  }
  func testDisabledRegistrationDoesNotTouchStorage() {
    let f = I2SFixture(callbacks: false)
    XCTAssertEqual(f.driver.registerCallback(0, callback: nil), .error)
    XCTAssertEqual(f.driver.unregisterCallback(0), .error)
    XCTAssertEqual(f.read(.errorCode), 0)
  }
}
