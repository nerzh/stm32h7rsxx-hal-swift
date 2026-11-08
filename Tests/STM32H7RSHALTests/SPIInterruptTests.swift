import CSPIReference
import STM32H7RSHAL
import XCTest

final class SPIInterruptTests: XCTestCase {
  func testTransmitReceiveAndDuplexInterruptSequences() {
    for callbacks in [false, true] {
      for crc in [false, true] {
        for size: UInt32 in [7, 15, 31] {
          for op: UInt32 in [7, 8, 9] {
            let p = SPIPair(callbacks: callbacks, crc: crc)
            p.setup {
              $0.write(.state, value: 1)
              $0.write(.dataSize, value: size)
              $0.write(.mode, value: SPIConstants.SPI_MODE_MASTER)
              $0.raw(.rxdr, 0xCDEF_0123)
              $0.control(33, 1)
              for i in 0..<64 { $0.buffer()[i] = UInt8(truncatingIfNeeded: i &* 31 &+ 7) }
            }
            p.verify(op, 4)
            let flag =
              op == 7
              ? SPIConstants.SPI_FLAG_TXP
              : op == 8
                ? SPIConstants.SPI_FLAG_RXP
                : SPIConstants.SPI_FLAG_DXP | SPIConstants.SPI_FLAG_RXP | SPIConstants.SPI_FLAG_TXP
            for _ in 0..<4 {
              p.setup { $0.raw(.sr, flag) }
              p.verify(18)
            }
            p.setup { $0.raw(.sr, SPIConstants.SPI_FLAG_EOT) }
            p.verify(18)
          }
        }
      }
    }
  }

  func testDuplexPreloadsFIFOAndEndInterruptDrainsRemainingReceiveData() {
    for size: UInt32 in [7, 15, 31] {
      for preload: UInt32 in [0, 1, 3, 9] {
        let p = SPIPair()
        p.setup {
          $0.write(.state, value: 1)
          $0.write(.dataSize, value: size)
          $0.raw(.sr, preload == 0 ? 0 : SPIConstants.SPI_FLAG_TXP)
          $0.control(31, preload)
          $0.control(32, 0)
          $0.raw(.rxdr, 0x1234_5678)
        }
        p.verify(9, 5)
        p.setup { $0.raw(.sr, SPIConstants.SPI_FLAG_EOT) }
        p.verify(18)
      }
    }
  }

  func testSuspendHasPriorityOverTransferAndErrorFlags() {
    for callbacks in [false, true] {
      let p = SPIPair(callbacks: callbacks)
      p.setup {
        $0.write(.state, value: 5)
        $0.raw(.ier, 0xFFFF)
        $0.raw(.sr, 0xFFFF)
        $0.raw(.cfg1, 0xC000)
        // No buffer or transfer ISR: priority must return before accessing them.
      }
      p.verify(18)
    }
  }

  func testErrorInterruptRequiresBothDMAEnableBitsForAbortPath() {
    for callbacks in [false, true] {
      for flags: UInt32 in [0x10, 0x20, 0x100, 0x200, 0x330] {
        for enables: UInt32 in [0, 0x4000, 0x8000, 0xC000] {
          for fail: UInt32 in [0, 1] {
            let p = SPIPair(callbacks: callbacks)
            p.setup {
              $0.write(.state, value: 5)
              $0.write(.transmitCount, value: 3)
              $0.write(.receiveCount, value: 4)
              $0.raw(.ier, 0x330)
              $0.raw(.sr, flags)
              $0.raw(.cfg1, enables)
              for d in [UARTDMADirection.transmit, .receive] {
                $0.setting(d, 0, 1)
                $0.setting(d, 10, fail)
              }
            }
            p.verify(18)
          }
        }
      }
    }
  }

  func testEndInterruptDMAErrorAndCapturedStateCallbackSelection() {
    for callbacks in [false, true] {
      for crc in [false, true] {
        for state: UInt32 in 0...7 {
          for flags: UInt32 in [8, 8 | 0x10, 8 | 0x20, 8 | 0x40, 8 | 0x300] {
            let p = SPIPair(callbacks: callbacks, crc: crc)
            p.setup {
              $0.write(.state, value: state)
              $0.write(.receiveCount, value: 3)
              $0.write(.crcCalculation, value: SPIConstants.SPI_CRCCALCULATION_ENABLE)
              $0.raw(.cfg1, 0xC000)
              $0.raw(.sr, flags)
              $0.raw(.ier, 8)
            }
            p.verify(18)
          }
        }
      }
    }
  }

  func testIndividualISRsPreserveAccessWidthCounterAndDisableTiming() {
    for op: UInt32 in 31...36 {
      for count: UInt16 in [1, 2, 3] {
        let p = SPIPair()
        p.setup {
          $0.write(.transmitCount, value: count)
          $0.write(.receiveCount, value: count)
          $0.writePointer(.transmit, value: UnsafeMutableRawPointer($0.buffer()))
          $0.writePointer(.receive, value: UnsafeMutableRawPointer($0.buffer(1)))
          $0.raw(.ier, 0xFFFF)
          $0.raw(.rxdr, 0xAA55_1234)
          $0.raw(.txdr, 0xCCDD_EEFF)
          for i in 0..<16 { $0.buffer()[i] = UInt8(i + 1) }
        }
        for _ in 0..<count { p.verify(op) }
        if op >= 34 { p.verify(op) }
      }
    }
  }

  func testCloseAndAbortFlagClearingWithCRCDisabledAndEnabled() {
    for crc in [false, true] {
      for state: UInt32 in 0...7 {
        for op: UInt32 in [37, 38] {
          let p = SPIPair(crc: crc)
          p.setup {
            $0.write(.state, value: state)
            $0.write(.errorCode, value: 0x8000)
            $0.write(.crcCalculation, value: SPIConstants.SPI_CRCCALCULATION_ENABLE)
            $0.write(.transmitCount, value: 3)
            $0.write(.receiveCount, value: 4)
            $0.raw(.sr, 0xFFFF)
            $0.raw(.ifcr, 0x10000)
            $0.raw(.ier, 0xFFFF)
            $0.raw(.cfg1, 0xFFFF_FFFF)
            $0.raw(.cr1, 0xFFFF_FFFF)
          }
          p.verify(op)
        }
      }
    }
  }
}
