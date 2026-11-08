import CAudioReference
import STM32H7RSHAL
import XCTest

final class SAIConfigurationTests: XCTestCase {
  private func prepare(_ f: SAIFixture) {
    f.write(.frameLength, value: 64)
    f.write(.activeFrameLength, value: 32)
    f.write(.slotCount, value: 2)
    f.write(.activeSlots, value: 3)
    f.write(.dataSize, value: 0xA0)
    f.write(.fifoThreshold, value: 2)
    f.write(.pdmMicrophonePairs, value: 3)
    for i: UInt32 in 0..<38 { CSAI_Set(f.state, 11, i, 0xA5A5_A5A5) }
    f.write(.cr1, value: 0x5A5A_5A5A)
    f.write(.cr2, value: 0xA5A5_A5A5)
    f.write(.frcr, value: .max)
    f.write(.slotr, value: .max)
  }
  func testClockDividerSynchronizationFrameSlotAndPDMConfigurations() {
    for registered in [false, true] {
      for instance: UInt32 in 0..<4 {
        for mode: UInt32 in 0..<4 {
          for protocolMode: UInt32 in [0, 4, 8] {
            for frequency: UInt32 in [0, 8_000, 44_100, 48_000, 192_000] {
              for divider: UInt32 in [0, 0x80000] {
                let pair = SAIPair(callbacks: registered)
                pair.setup {
                  prepare($0)
                  $0.control(0, instance)
                  $0.write(.audioMode, value: mode)
                  $0.write(.protocolMode, value: protocolMode)
                  $0.write(.audioFrequency, value: frequency)
                  $0.write(.noDivider, value: divider)
                  $0.write(.externalSynchronization, value: mode)
                  $0.write(.synchronization, value: instance)
                  $0.write(.masterClockOversampling, value: mode & 1 == 0 ? 0 : 0x4000000)
                  $0.write(.outputDrive, value: 0x2000)
                  $0.write(.clockStrobing, value: 1)
                  $0.write(.masterClockDivider, value: 0xAB)
                }
                pair.verify(1)
                pair.verify(2)
              }
            }
          }
        }
      }
    }
  }
  func testPDMRestrictionsAreCheckedBeforeCallbackAndDisable() {
    for instance: UInt32 in 0..<4 {
      for mode: UInt32 in 0..<4 {
        for protocolMode: UInt32 in [0, 4, 8] {
          let pair = SAIPair()
          pair.setup {
            prepare($0)
            $0.control(0, instance)
            $0.write(.pdmActivation, value: 1)
            $0.write(.audioMode, value: mode)
            $0.write(.protocolMode, value: protocolMode)
            $0.write(.pdmClockEnable, value: 0x700)
          }
          pair.verify(1)
        }
      }
    }
  }
  func testDisableLoopUsesCoreClockAndPreservesEarlyTimeoutWrites() {
    for clock: UInt32 in [0, 1, 6999, 7000, 64_000_000, .max] {
      for state: UInt32 in [0, 1, 0x12] {
        let pair = SAIPair()
        pair.setup {
          prepare($0)
          $0.control(6, clock)
          $0.write(.state, value: state)
          $0.write(.errorCode, value: 0x8000_0000)
        }
        pair.verify(1)
        pair.verify(2)
      }
    }
  }
  func testDividerZeroClockAndRangeFailureRetainsConfigurationMutation() {
    for clock: UInt32 in [0, 1, 49_152_000, 64_000_000, .max] {
      for frequency: UInt32 in [1, 8_000, 48_000, 192_000] {
        let pair = SAIPair()
        pair.setup {
          prepare($0)
          $0.control(5, clock)
          $0.write(.audioFrequency, value: frequency)
          $0.write(.noDivider, value: 0)
        }
        pair.verify(1)
      }
    }
  }
}
