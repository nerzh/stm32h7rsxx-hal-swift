import CSPIReference
import STM32H7RSHAL
import XCTest

final class SPITransferTests: XCTestCase {
  func testTransmitPackingUsesExactByteHalfwordAndWordAccesses() {
    for crc in [false, true] {
      for instance: UInt32 in [0, 3] {
        for size: UInt32 in [3, 7, 8, 15, 16, 31] {
          for threshold: UInt32 in [0, 1, 2, 3, 7] {
            for count: UInt32 in 1...9 {
              let p = SPIPair(crc: crc)
              p.setup {
                $0.control(0, instance)
                $0.write(.state, value: 1)
                $0.write(.mode, value: SPIConstants.SPI_MODE_MASTER)
                $0.write(.dataSize, value: size)
                $0.write(.fifoThreshold, value: threshold << 5)
                $0.raw(.sr, SPIConstants.SPI_FLAG_TXP | SPIConstants.SPI_FLAG_EOT)
                $0.raw(.txdr, 0xF0E0_D0C0)
                for i in 0..<64 { $0.buffer()[i] = UInt8(truncatingIfNeeded: i &* 73 &+ 19) }
              }
              p.verify(4, count, 5)
            }
          }
        }
      }
    }
  }

  func testReceiveAndDuplexWidthsAndCRCCompletion() {
    for callbacks in [false, true] {
      for crc in [false, true] {
        for size: UInt32 in [3, 7, 15, 31] {
          for count: UInt32 in [1, 2, 3, 4, 7, 9] {
            for op: UInt32 in [5, 6] {
              let p = SPIPair(callbacks: callbacks, crc: crc)
              p.setup {
                $0.write(.state, value: 1)
                $0.write(.dataSize, value: size)
                $0.write(.mode, value: SPIConstants.SPI_MODE_MASTER)
                $0.write(.crcCalculation, value: SPIConstants.SPI_CRCCALCULATION_ENABLE)
                $0.raw(
                  .sr,
                  SPIConstants.SPI_FLAG_TXP | SPIConstants.SPI_FLAG_RXP | SPIConstants.SPI_FLAG_EOT)
                $0.raw(.rxdr, 0x1234_56AB)
                $0.control(33, 1)
                for i in 0..<64 { $0.buffer()[i] = UInt8(truncatingIfNeeded: i &* 37 &+ 1) }
              }
              p.verify(op, count, 5)
            }
          }
        }
      }
    }
  }

  func testReceiveResidualFIFOWordAndPacketBranches() {
    for op: UInt32 in [5, 6] {
      for size: UInt32 in [7, 15, 31] {
        for word in [false, true] {
          let p = SPIPair()
          p.setup {
            $0.write(.state, value: 1)
            $0.write(.dataSize, value: size)
            $0.write(.fifoThreshold, value: (size == 7 ? 7 : 3) << 5)
            $0.raw(
              .sr,
              SPIConstants.SPI_FLAG_TXP
                | (word ? SPIConstants.SPI_FLAG_RXWNE : SPIConstants.SPI_RX_FIFO_1PACKET))
            $0.raw(.rxdr, 0x5678_ABCD)
            $0.control(33, 1)
            // 32-bit data has no RXPLVL-only fallback; let it time out there.
          }
          p.verify(op, word ? (size == 7 ? 4 : size == 15 ? 2 : 3) : 1, 3)
        }
      }
    }
  }

  func testPollingTimeoutErrorFlagsAndTickWrap() {
    for crc in [false, true] {
      for op: UInt32 in [4, 5, 6] {
        for timeout: UInt32 in [0, 1, 3] {
          for flags: UInt32 in [0, 0x1F0, SPIConstants.SPI_FLAG_TXP] {
            let p = SPIPair(crc: crc)
            p.setup {
              $0.write(.state, value: 1)
              $0.write(.dataSize, value: 7)
              $0.write(.crcCalculation, value: SPIConstants.SPI_CRCCALCULATION_ENABLE)
              $0.raw(.sr, flags)
              $0.control(2, UInt32.max - 1)
            }
            p.verify(op, 3, timeout)
          }
        }
      }
    }
  }

  func testPollingAndInterruptEntryValidationOrder() {
    for op: UInt32 in 4...12 {
      for state: UInt32 in [0, 1, 3, 7] {
        for locked: UInt32 in [0, 1] {
          for nilBuffer: UInt32 in [0, 1] {
            let p = SPIPair()
            p.setup {
              $0.write(.state, value: state)
              $0.write(.lock, value: locked)
              $0.control(13, nilBuffer)
            }
            p.verify(op, 0, 0)
          }
        }
      }
    }
  }

  func testWaitFlagUsesGreaterOrEqualAndReadsTickForInfiniteTimeout() {
    for timeout: UInt32 in [0, 1, 3, UInt32.max] {
      let p = SPIPair()
      p.setup {
        $0.raw(.sr, 0)
        $0.control(2, UInt32.max - 1)
        $0.control(18, UInt32.max - 1)
        $0.control(10, 3)
        $0.control(11, 5)
        $0.control(12, SPIConstants.SPI_FLAG_EOT)
      }
      p.verify(39, SPIConstants.SPI_FLAG_EOT, 0, timeout)
    }
  }
}
