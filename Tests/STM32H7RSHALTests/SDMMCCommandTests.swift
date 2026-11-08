import CSDMMCReference
import STM32H7RSHAL
import XCTest

final class SDMMCCommandTests: XCTestCase {
  func testRegisterConfigurationAndPowerMasks() {
    for seed: UInt32 in [0, 1, 0x1234_5678, UInt32.max] {
      for operation: UInt32 in 0...13 {
        for argument: UInt32 in [0, 4, 8, 12] {
          checkSDMMC(
            { f in
              for register in SDMMCRegister.allCases {
                f.set(0, register.rawValue / 4, seed &+ register.rawValue)
              }
              for (group, count): (UInt32, UInt32) in [(2, 6), (3, 5), (4, 6)] {
                for i in 0..<count { f.set(group, i, seed &+ i) }
              }
              f.set(8, 0, 0xFEDC_BA98)
            }, operation: operation, argument)
        }
      }
    }
  }

  func testEveryCommandAndResponseErrorPriority() {
    for operation: UInt32 in 14...46 {
      for argument: UInt32 in [0, 1, 0x8000_0001, UInt32.max] {
        for flags: UInt32 in [0x40, 0x1, 0x4, 0x45] {
          for response: UInt32 in [0, 0x8000_0000, UInt32.max] {
            checkSDMMC(
              { f in
                f.set(1, 4, 1)
                f.set(8, 0, 0xABCD_0100)
                for command: UInt32 in 0..<64 {
                  f.set(9, command * 6, flags)
                  f.set(9, command * 6 + 2, response)
                }
              }, operation: operation, argument, argument)
          }
        }
      }
    }
  }

  func testResponseDecodingAndCounterTimeoutBoundaries() {
    for operation: UInt32 in 47...53 {
      for flags: UInt32 in [0, 1, 4, 0x40, 0x200000, 0x45, 0x2040] {
        for coreClock: UInt32 in [0, 7999, 8000, 16000] {
          for timeout: UInt32 in [0, 1, 3] {
            checkSDMMC(
              { f in
                f.set(1, 0, coreClock)
                f.set(0, SDMMCRegister.sta.rawValue / 4, flags)
                f.set(0, SDMMCRegister.respcmd.rawValue / 4, 0x34)
                f.set(0, SDMMCRegister.resp1.rawValue / 4, 0x1234_5678)
                f.set(0, SDMMCRegister.icr.rawValue / 4, 0x55AA)
                f.set(8, 0, 0xABCD_1234)
              }, operation: operation, 0x34, timeout)
          }
        }
      }
    }
  }

  func testEachCardResponseBitAndMismatchedCommand() {
    for operation: UInt32 in [47, 50, 51, 52] {
      for bit: UInt32 in 0..<32 {
        for responseCommand: UInt32 in [0x35, 0x36, 0x135] {
          checkSDMMC(
            { f in
              f.set(0, SDMMCRegister.sta.rawValue / 4, 0x40)
              f.set(0, SDMMCRegister.respcmd.rawValue / 4, responseCommand)
              f.set(0, SDMMCRegister.resp1.rawValue / 4, 1 << bit)
              f.set(8, 0, 0xA55A_5AA5)
            }, operation: operation, 0x35, 1)
        }
      }
    }
    for missing: UInt32 in [0, 1] {
      checkSDMMC(
        { f in
          f.set(1, 15, missing)
          f.set(0, SDMMCRegister.sta.rawValue / 4, 0x40)
          f.set(0, SDMMCRegister.respcmd.rawValue / 4, 0x34)
          f.set(0, SDMMCRegister.resp1.rawValue / 4, 0x7B)
          f.set(8, 0, 0xA55A_5AA5)
        }, operation: 51, 0x34)
    }
  }

  func testCounterMultiplicationWrap() {
    for coreClock: UInt32 in [0, 8000, 16000, UInt32.max] {
      for timeout: UInt32 in [0, 1, 0x8000_0000, UInt32.max] {
        checkSDMMC(
          { f in
            f.set(1, 0, coreClock)
            f.set(0, SDMMCRegister.sta.rawValue / 4, 0x40)
            f.set(0, SDMMCRegister.respcmd.rawValue / 4, 0x12)
          }, operation: 47, 0x12, timeout)
      }
    }
  }
}
