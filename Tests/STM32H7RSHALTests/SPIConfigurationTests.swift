import CSPIReference
import STM32H7RSHAL
import XCTest

final class SPIConfigurationTests: XCTestCase {
  func testInitializationCapabilitiesCRCAndStateTransitions() {
    for callbacks in [false, true] {
      for crc in [false, true] {
        for instance: UInt32 in 0..<6 {
          for size: UInt32 in [3, 7, 15, 16, 23, 31] {
            for threshold: UInt32 in [0, 1, 3, 7, 15] {
              let p = SPIPair(callbacks: callbacks, crc: crc)
              p.setup {
                $0.control(0, instance)
                $0.setConfiguration(
                  .init(
                    mode: SPIConstants.SPI_MODE_MASTER, dataSize: size,
                    nss: SPIConstants.SPI_NSS_SOFT, baudRatePrescaler: 0x3000_0000,
                    crcCalculation: SPIConstants.SPI_CRCCALCULATION_ENABLE,
                    crcPolynomial: 7, crcLength: SPIConstants.SPI_CRC_LENGTH_DATASIZE,
                    fifoThreshold: threshold << 5, transmitCRCInitializationPattern: 1,
                    receiveCRCInitializationPattern: 1, masterReceiverAutoSuspend: 0x100,
                    masterKeepIOState: 0x8000_0000, readyMasterManagement: 0x400,
                    readyPolarity: 0x2000))
                $0.raw(.cr1, 0xFFFF_FFFF)
                $0.raw(.cfg1, 0xABCD_EF12)
                $0.raw(.cfg2, 0x1234_5678)
                $0.raw(.i2scfgr, 0xA5A5_A5A5)
                $0.write(.crcSize, value: 0xDEAD_BEEF)
                $0.write(.lock, value: 1)
              }
              p.verify(0)
            }
          }
        }
      }
    }
  }

  func testCRCExplicitLengthsPolynomialAndSlaveInitialization() {
    for callbacks in [false, true] {
      for crc in [false, true] {
        for instance: UInt32 in [0, 3] {
          for length: UInt32 in [0, 3 << 16, 7 << 16, 15 << 16, 23 << 16, 31 << 16] {
            for data: UInt32 in [3, 7, 15] {
              for enabled: UInt32 in [0, SPIConstants.SPI_CRCCALCULATION_ENABLE] {
                let p = SPIPair(callbacks: callbacks, crc: crc)
                p.setup {
                  $0.control(0, instance)
                  $0.setConfiguration(
                    .init(
                      mode: SPIConstants.SPI_MODE_SLAVE, dataSize: data,
                      clockPolarity: 0x4000_000, clockPhase: 0x2000_000,
                      nss: SPIConstants.SPI_NSS_SOFT, firstBit: 0x8000_00,
                      crcCalculation: enabled, crcPolynomial: 0x8005, crcLength: length,
                      nssPolarity: SPIConstants.SPI_NSS_POLARITY_HIGH,
                      transmitCRCInitializationPattern: 0, receiveCRCInitializationPattern: 1))
                  $0.write(.state, value: 1)
                  $0.raw(.cr1, 0xFFFF_FFFF)
                  $0.raw(.cfg1, 0xBABA_BABA)
                }
                p.verify(0)
              }
            }
          }
        }
      }
    }
  }

  func testDeinitializationAndCallbackRegistration() {
    for callbacks in [false, true] {
      for state: UInt32 in 0...7 {
        let p = SPIPair(callbacks: callbacks)
        p.setup {
          $0.write(.state, value: state)
          $0.write(.errorCode, value: 0xA5)
          $0.write(.lock, value: 1)
          $0.raw(.cr1, 0xFFFF_FFFF)
          $0.write(.mspDeinitialize, value: nil)
        }
        p.verify(1)
        if !callbacks { continue }
        for id: UInt32 in 0...12 {
          for custom: UInt32 in 0...2 {
            for locked: UInt32 in [0, 1] {
              let q = SPIPair()
              q.setup {
                $0.write(.state, value: state)
                $0.write(.lock, value: locked)
              }
              q.verify(2, id, custom)
              q.verify(3, id)
            }
          }
        }
      }
    }
  }

  func testExtendedLockAndUnderrunPreserveReadyTransitionOnBusy() {
    for state: UInt32 in 0...7 {
      for locked: UInt32 in [0, 1] {
        for enabled: UInt32 in [0, 1] {
          for mode: UInt32 in [SPIConstants.SPI_MODE_MASTER, SPIConstants.SPI_MODE_SLAVE] {
            for op: UInt32 in [42, 43] {
              let p = SPIPair()
              p.setup {
                $0.write(.state, value: state)
                $0.write(.lock, value: locked)
                $0.write(.mode, value: mode)
                $0.raw(.cr1, 0x10000 | enabled)
                $0.raw(.cfg1, 0xABCD_EF12)
              }
              p.verify(op, 0xFFFF_FFFF, 0x600)
            }
          }
        }
      }
    }
  }

  func testFlushFIFOEmptyBoundaryAndCachedWordFlag() {
    for instance: UInt32 in 0..<6 {
      for flags: UInt32 in [0, SPIConstants.SPI_RX_FIFO_1PACKET, SPIConstants.SPI_FLAG_RXWNE] {
        for drain: UInt32 in [0, 1, 2, 4, 8, 9] {
          let p = SPIPair()
          p.setup {
            $0.control(0, instance)
            $0.raw(.sr, flags)
            $0.raw(.rxdr, 0xAABB_CCDD)
            $0.control(28, drain)
            $0.control(29, 0)
          }
          p.verify(41)
        }
      }
    }
  }

  func testPacketSizeUnsignedMathAndUnsupportedDMAControls() {
    for size: UInt32 in [0, 3, 7, 15, 31, UInt32.max] {
      for threshold: UInt32 in [0, 0xE0, 0x1E0, UInt32.max] {
        let p = SPIPair()
        p.setup {
          $0.write(.dataSize, value: size)
          $0.write(.fifoThreshold, value: threshold)
        }
        p.verify(40)
      }
    }
    let p = SPIPair()
    p.setup {
      $0.write(.state, value: 5)
      $0.write(.lock, value: 1)
      $0.write(.errorCode, value: 3)
    }
    for op: UInt32 in [15, 16, 17, 19, 20] { p.verify(op) }
  }
}
