import CAudioReference
import STM32H7RSHAL
import XCTest

final class SAIProtocolTests: XCTestCase {
  func testProtocolHelpersAndPartialConfigurationOnFailure() {
    for protocolValue: UInt32 in 0...6 {
      for size: UInt32 in 0...4 {
        for slots: UInt32 in [0, 1, 2, 3, 4, 8, 16] {
          for mode: UInt32 in 0..<4 {
            let p = SAIPair()
            p.setup {
              $0.write(.audioMode, value: mode)
              $0.write(.audioFrequency, value: 48000)
              $0.write(.frameLength, value: 0xA5)
              $0.write(.activeFrameLength, value: 0x5A)
              $0.write(.slotSize, value: 0x80)
              $0.write(.clockStrobing, value: 1)
            }
            p.verify(0, protocolValue, size, slots)
          }
        }
      }
    }
  }
  func testPDMMicrophoneDelayInstanceStateAndBitMasks() {
    for instance: UInt32 in 0..<4 {
      for state: UInt32 in [0, 1, 0x22] {
        for pair: UInt32 in [0, 1, 2, 3, 4, 5, UInt32.max] {
          for delay: UInt32 in [0, 1, 7, 15] {
            let p = SAIPair()
            p.setup {
              $0.control(0, instance)
              $0.write(.state, value: state)
              $0.control(30, pair)
              $0.control(31, delay)
              $0.control(32, 7)
              $0.writeGlobal(.sai1, .pdmdly, value: 0xA5A5_A5A5)
            }
            p.verify(39)
          }
        }
      }
    }
  }
}
