import STM32H7RSHAL
import XCTest

final class MMCDeviceControlTests: XCTestCase {
  func testFourKilobyteSectorAlignment() {
    for operation: UInt32 in [3, 4, 5, 6, 7, 8, 52, 53] {
      for address: UInt32 in [0, 1, 7, 8, 9] {
        for count: UInt32 in [0, 1, 7, 8, 9] {
          checkMMC(
            { f in
              prepareMMCCard(f)
              f.extendedCSDPointer()[15] = 0x100
              // Successful eight-sector polling would exceed the bounded trace buffer.
              f.set(4, 18 * 6, 4)
              f.set(4, 25 * 6, 4)
            }, operation: operation, address, count, 10)
        }
      }
    }
  }

  func testEraseSequenceTypesBoundariesAndBusyRelease() {
    for type: UInt32 in [0, 1, 3, 0x8000_0000, 0x8000_8000, UInt32.max] {
      for sector: UInt32 in [0, 0x100] {
        for state: UInt32 in [0, 1, 3] {
          for address: UInt32 in [0, 1, 8, 8193] {
            checkMMC(
              { f in
                prepareMMCCard(f)
                f.write(.state, value: state)
                f.extendedCSDPointer()[15] = sector
                f.set(2, 3, 100000)
                f.set(4, 38 * 6, 0x200040)
              }, operation: 24, type, address, address + 8)
          }
        }
      }
    }
    for command: UInt32 in [35, 36, 38] {
      for flag: UInt32 in [1, 4, 0x40] {
        checkMMC(
          { f in
            prepareMMCCard(f)
            f.set(2, 3, 100000)
            f.set(4, command * 6, flag)
          }, operation: 24, 0x8000_0000, 0, 8)
      }
    }
  }

  func testSecureRemovalBitSelectionAndPartitionSwitch() {
    for state: UInt32 in [0, 1, 3] {
      for supported: UInt32 in 0..<16 {
        for mode: UInt32 in [0, 1, 2, 4, 8, 3, 15, UInt32.max] {
          checkMMC(
            { f in
              prepareMMCCard(f)
              f.write(.state, value: state)
              f.extendedCSDPointer()[4] = 0xA5A5_0000 | supported
            }, operation: 26, mode)
        }
        checkMMC(
          { f in
            prepareMMCCard(f)
            f.write(.state, value: state)
            f.extendedCSDPointer()[4] = supported
          }, operation: 27)
      }
      for partition: UInt32 in [0, 1, 2, 3, 4, 7, 8, UInt32.max] {
        checkMMC(
          { f in
            prepareMMCCard(f)
            f.write(.state, value: state)
            f.extendedCSDPointer()[44] = 0xA5A5_FFFF
          }, operation: 40, partition)
      }
    }
  }

  func testSleepAwakeSanitizeAndCommandFailureStates() {
    for operation: UInt32 in [25, 26, 28, 29, 40] {
      for state: UInt32 in [0, 1, 3] {
        for timeout: UInt32 in [0, 1, 14, 23, 24, 255] {
          checkMMC(
            { f in
              prepareMMCCard(f)
              f.write(.state, value: state)
              f.extendedCSDPointer()[4] = 15
              f.extendedCSDPointer()[54] = timeout << 8
              f.set(2, 3, 100000)
              f.set(4, 6 * 6, 0x200040)
              f.set(4, 5 * 6, 0x200040)
              f.set(2, 28, 1)
              for i: UInt32 in 0..<16 {
                f.set(2, 32 + i, operation == 29 && i == 0 ? 0x700 : 0x900)
              }
            }, operation: operation, 1)
        }
      }
      for command: UInt32 in [5, 6, 7, 13] {
        for flags: UInt32 in [1, 4, 0x40, 0x200040] {
          checkMMC(
            { f in
              prepareMMCCard(f)
              f.extendedCSDPointer()[4] = 15
              f.set(2, 3, 100000)
              f.set(4, command * 6, flags)
            }, operation: operation, 1)
        }
      }
    }
  }
}
