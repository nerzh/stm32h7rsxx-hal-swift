import STM32H7RSHAL
import XCTest

final class XSPICommandTests: XCTestCase {
  func testRegularCommandBranchesAndRegisterOrder() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 2, 4, 0x14, 0x24] {
        for operation: UInt32 in [0, 1, 2, 3, 4] {
          for mask: UInt32 in 0..<16 {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: state)
              f.write(.sampleShifting, value: 0x4000_0000)
              f.write(.memoryMode, value: mask & 8 == 0 ? 0 : 0x40)
              f.setConfig(
                XSPIRegularCommand(
                  operationType: operation, ioSelect: 0x4000_0000, instruction: 0x9F,
                  instructionMode: mask & 1 != 0 ? 1 : 0, instructionWidth: 0x10,
                  instructionDTRMode: 8, address: 0x1234_5678,
                  addressMode: mask & 2 != 0 ? 0x400 : 0, addressWidth: 0x2000,
                  addressDTRMode: 0x800, alternateBytes: 0xA5, alternateBytesMode: 0x40000,
                  alternateBytesWidth: 0x100000, alternateBytesDTRMode: 0x80000,
                  dataMode: mask & 4 != 0 ? 0x4000000 : 0, dataLength: 31,
                  dataDTRMode: mask & 8 != 0 ? 0x8000000 : 0, dummyCycles: 9, dqsMode: 0x2000_0000))
              for r in XSPIRegister.allCases { f.raw(r, 0xA5A5_A5A5) }
              f.raw(.sr, 0)
            }
            p.verify(3, 0, 3)
          }
        }
      }
    }
  }
  func testInterruptCommandsAndBusyTimeout() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 2, 0x14, 0x24] {
        for mask: UInt32 in 0..<16 {
          let p = XSPIPair(callbacks: callbacks)
          p.setup { f in
            f.write(.state, value: state)
            f.write(.timeout, value: 2)
            f.write(.memoryType, value: mask & 8 == 0 ? 0 : 0x4000000)
            f.setConfig(
              XSPIRegularCommand(
                operationType: mask & 1, instruction: 0x9F, instructionMode: 1,
                dataMode: mask & 2 != 0 ? 0x1000000 : 0, dataLength: 1))
            f.raw(.sr, mask & 4 == 0 ? 0 : 0x20)
          }
          p.verify(4)
        }
      }
    }
  }
  func testHyperbusConfigurationAndCommands() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 1, 2, 4, 8] {
        for mask: UInt32 in 0..<16 {
          let p = XSPIPair(callbacks: callbacks)
          p.setup { f in
            f.write(.state, value: state)
            f.write(.memoryType, value: mask & 1 == 0 ? 0 : 0x4000000)
            f.raw(.sr, mask & 2 == 0 ? 0 : 0x20)
            f.setConfig(
              XSPIHyperbusConfiguration(
                rwRecoveryTimeCycle: 31, accessTimeCycle: 17,
                writeZeroLatency: mask & 4 != 0 ? 2 : 0, latencyMode: mask & 8 != 0 ? 1 : 0))
          }
          p.verify(5, 0, 2)
          p.setup { f in
            f.setConfig(
              XSPIHyperbusCommand(
                addressSpace: 0x1000000, address: 0x3456, addressWidth: 0x3000, dataLength: 8,
                dqsMode: 0x2000_0000, dataMode: 0x4000000))
          }
          p.verify(6, 0, 2)
        }
      }
    }
  }
  func testAutomaticPollingAndMemoryMapping() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 2, 4, 0x14, 0x24, 0x88] {
        for mask: UInt32 in 0..<16 {
          for op: UInt32 in [13, 14, 15] {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: state)
              f.write(.timeout, value: 2)
              f.write(.memoryType, value: mask & 1 == 0 ? 0 : 0x4000000)
              f.raw(.ar, 0x1234)
              f.raw(.ir, 0x9F)
              f.raw(.ccr, mask & 2 == 0 ? 0 : 0x400)
              f.raw(.sr, mask & 4 == 0 ? 8 : 0x20)
              if op == 15 {
                f.setConfig(
                  XSPIMemoryMappedConfiguration(
                    timeOutActivation: mask & 8 == 0 ? 0 : 8, timeoutPeriodClock: 0xFFFF))
              } else {
                f.setConfig(
                  XSPIAutoPollingConfiguration(
                    matchValue: 0xAA55, matchMask: 0xFF0F, matchMode: 0x800000,
                    automaticStop: mask & 8 == 0 ? 0 : 0x400000, intervalTime: 0x1234))
              }
            }
            p.verify(op, 0, 2)
            p.verify(16)
          }
        }
      }
    }
  }
}
