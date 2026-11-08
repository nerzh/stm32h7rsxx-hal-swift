import CCRYPReference
import XCTest

@testable import STM32H7RSHAL

final class CRYPDifferentialTests: XCTestCase {
  func testInitializeAndDeinitializeAcrossBuildVariants() {
    for cb: UInt32 in 0...1 {
      for su: UInt32 in 0...1 {
        for engines: UInt32 in 0...2 {
          for instance: UInt32 in 0...1 {
            let p = CRYPPair(cb, su, engines, instance)
            for algorithm: UInt32 in [0x20, 0x28, 0x30, 0x80000, 0x80008, 0xFFFF_FFFF] {
              for keySize: UInt32 in [0, 0x100, 0x200, 0x300] {
                p.reset()
                p.configuration(.algorithm, algorithm)
                p.configuration(.keySize, keySize)
                p.configuration(.keyMode, CRYPConstants.CRYP_KEYMODE_WRAPPED)
                p.configuration(.keySelection, CRYPConstants.CRYP_KEYSEL_TEST_KEY)
                p.configuration(.dataType, 0xC0)
                p.configuration(.headerWidthUnit, 1)
                p.register(.cr, 0x5577_AADD)
                p.word(.errorCode, 0x1234)
                p.word(.keyIVConfiguration, 5)
                p.word(.lock, 1)
                p.callback(4, 0)
                p.callback(5, 0)
                p.run(0)
                p.run(17)
                p.run(18)
                p.run(1)
              }
            }
            for state: UInt32 in [0, 1, 2, 3] {
              p.reset()
              p.word(.state, state)
              p.callback(4, 2)
              p.callback(5, 3)
              p.control(9, 1)
              p.control(10, 4)
              p.control(11, 3)
              p.run(0)
              p.run(1)
            }
          }
        }
      }
    }
  }
  func testSAESResetTimeoutAndTickWrap() {
    for cb: UInt32 in 0...1 {
      for start: UInt32 in [0, UInt32.max - 3] {
        for completion: UInt32 in [0, 2, 6] {
          let p = CRYPPair(cb, 0, 0, 1)
          p.register(.sr, 8)
          p.register(.cr, 0x10203)
          p.control(4, start)
          p.control(5, 100)
          p.word(.errorCode, 0x80)
          p.word(.version, 0x123)
          p.word(.phase, 7)
          if completion != 0 { p.event(0, completion, .sr, 0) }
          p.run(0)
        }
      }
    }
  }
  func testConfigurationStateBeforeLockAndKeyModeMask() {
    for cb: UInt32 in 0...1 {
      for engines: UInt32 in 0...2 {
        for instance: UInt32 in 0...1 {
          let p = CRYPPair(cb, 0, engines, instance)
          for state: UInt32 in [0, 1, 2, 3] {
            for lock: UInt32 in [0, 1] {
              for op: UInt32 in [2, 3] {
                p.reset()
                p.word(.state, state)
                p.word(.lock, lock)
                p.word(.errorCode, 0x100)
                p.register(.cr, 0xAAAA_AAAA)
                p.suppliedConfiguration(.keyMode, CRYPConstants.CRYP_KEYMODE_WRAPPED)
                p.suppliedConfiguration(.keySelection, CRYPConstants.CRYP_KEYSEL_HW)
                p.suppliedConfiguration(.algorithm, 0x80008)
                p.suppliedConfiguration(.keySize, 0x200)
                p.suppliedConfiguration(.dataType, 0x80)
                p.suppliedConfiguration(.headerWidthUnit, 1)
                p.run(op)
              }
            }
          }
          for op: UInt32 in 0...3 {
            p.reset()
            p.word(.state, 1)
            p.word(.lock, 1)
            p.run(op, 0, 0, 1)
          }
        }
      }
    }
  }
  func testCallbackRegistrationAndResetMacro() {
    let p = CRYPPair(1)
    for state: UInt32 in [0, 1, 2, 3] {
      for lock: UInt32 in [0, 1] {
        for id: UInt32 in 0...6 {
          for value: UInt32 in 0...3 {
            p.reset()
            p.word(.state, state)
            p.word(.lock, lock)
            p.word(.errorCode, 0x100)
            p.run(4, id, value)
            p.run(5, id)
          }
        }
      }
    }
    for cb: UInt32 in 0...1 {
      let p = CRYPPair(cb)
      p.word(.state, 3)
      for id: UInt32 in 1...5 { p.callback(id, 2) }
      p.run(105)
    }
  }
  func testRegisterMacrosAndConversionsMatchOriginal() {
    for instance: UInt32 in 0...1 {
      let p = CRYPPair(0, 0, 0, instance)
      for op: UInt32 in [100, 101, 102, 103, 104, 106, 107, 108, 109, 110, 111, 112] {
        for value: UInt32 in [
          0, 1, 2, 4, 8, 16, 32, 128, 0x1000001, 0x1000002, 0x8000_0002, 0x8000_0004, 0xA5A5_FFFF,
        ] {
          p.reset()
          p.register(.cr, 0xD5D5_D5D5)
          p.register(.sr, 0xA5)
          p.register(.risr, 0x5A)
          p.register(.misr, 0x1234)
          p.register(.isr, 0x53)
          p.register(.ier, 0xAA55)
          p.run(op, value)
        }
      }
      for op: UInt32 in [41, 42, 43, 44] {
        for timeout: UInt32 in [0, 1, 4] {
          p.reset()
          p.register(.sr, op == 42 ? 0x18 : 0)
          p.control(4, UInt32.max - 1)
          p.run(op, timeout)
          p.reset()
          p.register(.sr, op == 42 ? 0 : 0x5)
          p.run(op, UInt32.max)
        }
      }
      for algorithm: UInt32 in [0, 0x20, 0x28, 0x30, 0x80000, 0x80008, 0xFFFF_FFFF] {
        for order: UInt32 in [0, 1, 2] {
          p.reset()
          p.run(50, algorithm, order)
        }
      }
    }
  }

  func testAESKeyRegisterOrderAndUnsupportedWidths() {
    for engines: UInt32 in 0...2 {
      for instance: UInt32 in 0...1 {
        let p = CRYPPair(0, 0, engines, instance)
        for size: UInt32 in [0, 0x100, 0x200, 0x300, 0xFFFF_FFFF] {
          p.reset()
          for offset: UInt32 in stride(from: 0x10, to: 0x40, by: 4) {
            p.register(.init(rawValue: offset), 0xA5A5_A5A5)
          }
          p.run(30, size)
          if instance == 1 {
            for model in [p.c, p.swift] { model.writePointer(.key, value: nil) }
            p.run(30, size)
          }
        }
      }
    }
  }
  func testAESCipherSetupAndPollingCounts() {
    for cb: UInt32 in 0...1 {
      for instance: UInt32 in 0...1 {
        let p = CRYPPair(cb, 1, 0, instance)
        for op: UInt32 in [19, 21] {
          for algorithm: UInt32 in [0x20, 0x28, 0x30] {
            for skip: UInt32 in [0, 1, 2] {
              for configured: UInt32 in [0, 1] {
                for size: UInt16 in [0, 1, 3, 4, 7, 16, 20, 32] {
                  p.reset()
                  p.word(.state, 2)
                  p.word(.lock, 1)
                  p.configuration(.algorithm, algorithm)
                  p.configuration(.keyIVConfigurationSkip, skip)
                  p.word(.keyIVConfiguration, configured)
                  p.half(.size, size)
                  p.register(.sr, instance == 0 ? 0x86 : 0x81)
                  p.register(.dout, 0xFEDC_BA98)
                  p.run(op, 5)
                }
              }
            }
          }
        }
      }
    }
  }
  func testAESSetupTimeoutsAndSourceErrorCompletion() {
    for cb: UInt32 in 0...1 {
      for instance: UInt32 in 0...1 {
        let p = CRYPPair(cb, 0, 0, instance)
        for op: UInt32 in [19, 21] {
          for timeout: UInt32 in [0, 2, 5] {
            p.reset()
            p.word(.state, 2)
            p.word(.lock, 1)
            p.half(.size, 16)
            p.register(.sr, instance == 0 ? 0x10 : 0)
            p.control(4, UInt32.max - 1)
            p.run(op, timeout)
          }
        }
        // The private data routine reports a timeout through the handle/callback,
        // then continues; AES polling can still return HAL_OK after input is fed.
        p.reset()
        p.word(.state, 2)
        p.word(.lock, 1)
        p.half(.size, 16)
        p.register(.sr, instance == 0 ? 0x82 : 0x80)
        p.register(.dout, 0xAABB_CCDD)
        p.callback(3, 2)
        XCTAssertEqual(p.run(19, 1), 0)
        XCTAssertEqual(p.swift.read(.errorCode), 0x10)
      }
    }
  }
  func testAESProcessDataPartialBlockAndTimeoutCallbackMutation() {
    for cb: UInt32 in 0...1 {
      for instance: UInt32 in 0...1 {
        let p = CRYPPair(cb, 0, 0, instance)
        for size: UInt16 in [0, 1, 3, 4, 7, 15, 16, 19] {
          for flags: UInt32 in [0, 1, 2, 4, 6] {
            p.reset()
            p.half(.size, size)
            p.register(.sr, flags)
            p.register(.dout, 0x0102_0304)
            p.word(.state, 2)
            p.word(.lock, 1)
            p.callback(3, 2)
            p.control(9, 1)
            p.control(10, 3)
            p.control(11, 3)
            p.run(28, 1)
          }
        }
      }
    }
  }

  func testAESInterruptSetupAndZeroLengthOrdering() {
    for cb: UInt32 in 0...1 {
      for instance: UInt32 in 0...1 {
        let p = CRYPPair(cb, 1, 0, instance)
        for op: UInt32 in [20, 22] {
          for algorithm: UInt32 in [0x20, 0x28, 0x30] {
            for mode: UInt32 in [
              0, CRYPConstants.CRYP_KEYMODE_WRAPPED, CRYPConstants.CRYP_KEYMODE_SHARED,
            ] {
              for skip: UInt32 in [0, 1, 2] {
                for size: UInt16 in [0, 1, 16, 32] {
                  p.reset()
                  p.configuration(.algorithm, algorithm)
                  p.configuration(.keyMode, mode)
                  p.configuration(.keyIVConfigurationSkip, skip)
                  p.word(.state, 2)
                  p.word(.lock, 1)
                  p.half(.size, size)
                  p.register(.cr, mode)
                  p.register(.sr, 0x81)
                  p.run(op)
                }
              }
            }
          }
        }
        for op: UInt32 in [20, 22] {
          p.reset()
          p.register(.sr, instance == 0 ? 0x10 : 0)
          p.control(4, UInt32.max - 100)
          p.control(5, 100)
          p.run(op)
        }
      }
    }
  }
  func testAESInterruptCallbacksTailsAndSuspension() {
    for cb: UInt32 in 0...1 {
      for suspend: UInt32 in 0...1 {
        for instance: UInt32 in 0...1 {
          let p = CRYPPair(cb, suspend, 0, instance)
          for state: UInt32 in [0, 1, 2, 3] {
            for size: UInt16 in [0, 1, 3, 4, 7, 16, 20, 32] {
              for flags: UInt32 in [0, 2, 4, 6] {
                p.reset()
                p.word(.state, state)
                p.word(.lock, 1)
                p.half(.size, size)
                p.register(.sr, flags)
                p.register(.dout, 0x5566_7788)
                p.register(.imscr, 3)
                p.register(.ier, 15)
                for id: UInt32 in 1...3 { p.callback(id, 2) }
                p.control(9, 1)
                p.control(10, 1)
                p.control(11, 3)
                p.run(29)
              }
            }
          }
          p.reset()
          p.word(.state, 2)
          p.word(.suspendRequest, 1)
          p.half(.size, 32)
          p.register(.sr, 1)
          p.register(.cr, 0xFFFF)
          p.register(.imscr, 3)
          p.register(.ier, 15)
          p.run(29)
        }
      }
    }
  }

  func testAuthenticationHeaderWordByteUnitsAndPadding() {
    for instance: UInt32 in 0...1 {
      let p = CRYPPair(0, 0, 0, instance)
      for width: UInt32 in [0, 1] {
        for size: UInt32 in [0, 1, 2, 3, 4, 5, 7, 15, 16, 17, 31, 32, 33] {
          for dataType: UInt32 in [0, 0x40, 0x80, 0xC0] {
            p.reset()
            p.configuration(.headerWidthUnit, width)
            p.configuration(.headerSize, size)
            p.configuration(.dataType, dataType)
            p.word(.state, 2)
            p.word(.lock, 1)
            p.register(.sr, 1)
            p.run(38, 5)
          }
        }
      }
      p.reset()
      p.configuration(.headerSize, 4)
      p.word(.state, 2)
      p.word(.lock, 1)
      p.register(.sr, 0)
      p.run(38, 1)
      p.reset()
      p.configuration(.headerSize, 0)
      p.register(.sr, 0x18)
      p.run(38, 1)
    }
  }
  func testGCMAndCCMPollingInitializationTailsAndAccumulation() {
    for cb: UInt32 in 0...1 {
      for instance: UInt32 in 0...1 {
        let p = CRYPPair(cb, 0, 0, instance)
        for (op, algorithm): (UInt32, UInt32) in [
          (31, CRYPConstants.CRYP_AES_GCM), (34, CRYPConstants.CRYP_AES_CCM),
        ] {
          for decrypt: UInt32 in [0, 1] {
            for configured: UInt32 in [0, 1] {
              for size: UInt16 in [0, 1, 3, 4, 7, 15, 16, 17, 20, 31, 32, 33] {
                p.reset()
                p.configuration(.algorithm, algorithm)
                p.configuration(.headerSize, 5)
                p.configuration(.keyIVConfigurationSkip, 1)
                p.word(.keyIVConfiguration, configured)
                p.word(.sizesSum, UInt32.max - 8)
                p.half(.size, size)
                p.word(.state, 2)
                p.word(.lock, 1)
                let control: UInt32 =
                  instance == 0
                  ? algorithm | (decrypt << 2)
                  : (algorithm == CRYPConstants.CRYP_AES_GCM
                    ? CRYPConstants.SAES_CR_CHMOD_AES_GCM : CRYPConstants.SAES_CR_CHMOD_AES_CCM)
                    | (decrypt << 4)
                p.register(.cr, control)
                p.register(.sr, instance == 0 ? 0x87 : 0x81)
                p.register(.dout, 0xAABB_CCDD)
                if instance == 0 && configured == 0 { p.event(0, 2, .cr, control) }
                p.run(op, 100)
              }
            }
          }
        }
      }
    }
  }
  func testAuthenticationTailTimeoutDifferences() {
    for cb: UInt32 in 0...1 {
      for instance: UInt32 in 0...1 {
        for op: UInt32 in [31, 34] {
          let p = CRYPPair(cb, 0, 0, instance)
          p.configuration(.keyIVConfigurationSkip, 1)
          p.word(.keyIVConfiguration, 1)
          p.half(.size, 3)
          p.word(.state, 2)
          p.word(.lock, 1)
          p.callback(3, 2)
          p.register(.dout, 0xAABB_CCDD)
          p.run(op, 1)
          p.reset()
          p.half(.size, 16)
          p.configuration(.headerSize, 4)
          p.control(4, UInt32.max - 1)
          p.run(op, 1)
        }
      }
    }
  }

  func testPublicPollingDispatchNarrowedSizeAndBusyState() {
    for cb: UInt32 in 0...1 {
      for instance: UInt32 in 0...1 {
        let p = CRYPPair(cb, 0, 0, instance)
        for operation: UInt32 in [10, 11] {
          for algorithm: UInt32 in [
            CRYPConstants.CRYP_AES_ECB, CRYPConstants.CRYP_AES_CBC, CRYPConstants.CRYP_AES_CTR,
            CRYPConstants.CRYP_AES_GCM, CRYPConstants.CRYP_AES_CCM,
          ] {
            for width: UInt32 in [0, 1] {
              for size: UInt32 in [0, 1, 4, 7, 16, 17, 16384] {
                if size == 16384 && width == 1 { continue }
                p.reset()
                p.configuration(.algorithm, algorithm)
                p.configuration(.dataWidthUnit, width)
                p.configuration(.keyIVConfigurationSkip, 1)
                p.word(.keyIVConfiguration, 1)
                p.word(.state, 1)
                p.register(.sr, 0x87)
                p.register(.dout, 0x1234_5678)
                p.register(.cr, instance == 0 ? algorithm : p.swift.driver.saesAlgorithm(algorithm))
                p.run(operation, size, 100)
              }
            }
            for state: UInt32 in [0, 1, 2, 3] {
              for lock: UInt32 in [0, 1] {
                p.reset()
                p.word(.state, state)
                p.word(.lock, lock)
                p.word(.errorCode, 0x100)
                p.register(.cr, instance == 0 ? 0 : 0x10060)
                p.run(operation, 0, 1)
              }
            }
          }
        }
      }
    }
  }

  func testExtendedKeyOperationsAndTimeoutLockRetention() {
    for cb: UInt32 in 0...1 {
      let p = CRYPPair(cb, 0, 0, 1)
      for op: UInt32 in 53...58 {
        for size: UInt32 in [0, 0x100, 0x200, 0x300] {
          for algorithm: UInt32 in [0x20, 0x28, 0x30] {
            for selection: UInt32 in [0, CRYPConstants.CRYP_KEYSEL_TEST_KEY] {
              p.reset()
              p.word(.state, 1)
              p.configuration(.keySize, size)
              p.configuration(.algorithm, algorithm)
              p.configuration(.keySelection, selection)
              p.register(.sr, 0x81)
              p.register(.doutr, 0xABCD_EF01)
              p.run(op, 0x2000, 5)
            }
          }
        }
      }
      for op: UInt32 in 53...56 {
        for flags: UInt32 in [0, 1, 0x80] {
          for state: UInt32 in [0, 1, 2, 3] {
            for lock: UInt32 in [0, 1] {
              p.reset()
              p.word(.state, state)
              p.word(.lock, lock)
              p.word(.errorCode, 0x100)
              p.register(.sr, flags)
              p.control(4, UInt32.max - 1)
              p.run(op, 0, 1)
            }
          }
        }
      }
      p.reset()
      p.word(.state, 1)
      p.run(53, 0, 1)
      XCTAssertEqual(p.swift.read(.state), 1)
      XCTAssertEqual(p.swift.read(.lock), 1)
      for size: UInt32 in [0, 0x100, 0x200, 0x300] {
        p.reset()
        p.run(59, size)
        for model in [p.c, p.swift] { model.writePointer(.key, value: nil) }
        p.run(59, size)
      }
    }
  }
  func testAuthenticationTagHostSafeStateAndTimeoutPaths() {
    for instance: UInt32 in 0...1 {
      let p = CRYPPair(1, 0, 0, instance)
      for op: UInt32 in [51, 52] {
        for state: UInt32 in [0, 1, 2, 3] {
          for lock: UInt32 in [0, 1] {
            for phase: UInt32 in [0, 1, 2, 3] {
              // The unchanged C success paths narrow native pointers to UInt32.
              // Exercise those paths in the 32-bit board fixture instead.
              if state == 1 && lock == 0 && phase == 2 { continue }
              p.reset()
              p.word(.state, state)
              p.word(.lock, lock)
              p.word(.phase, phase)
              p.word(.errorCode, 0x100)
              p.register(.cr, 0xAABB_CCDD)
              p.register(.ier, 15)
              p.run(op, 0, 1)
            }
          }
        }
      }
      p.reset()
      p.word(.state, 1)
      p.word(.phase, 2)
      p.word(.sizesSum, UInt32.max)
      p.configuration(.headerSize, UInt32.max)
      p.control(4, UInt32.max - 1)
      p.run(51, 0, 1)
    }
  }

  func testDMASetupFailuresLinkedNodesAndCallbackSelection() {
    for cb: UInt32 in 0...1 {
      for instance: UInt32 in 0...1 {
        let p = CRYPPair(cb, 0, 0, instance)
        for mode: UInt32 in [0, 0x80] {
          for queue: UInt32 in [0, 1] {
            for head: UInt32 in [0, 1] {
              for status: UInt32 in [0, 1, 2, 3] {
                p.reset()
                p.word(.state, 2)
                p.word(.lock, 1)
                p.callback(3, 2)
                p.control(9, 1)
                p.control(10, 3)
                p.control(11, 3)
                for model in [p.c, p.swift] {
                  for ch: UInt32 in 0..<2 {
                    CCRYP_SetDMA(model.state, ch, 0, mode)
                    CCRYP_SetDMA(model.state, ch, 4, queue)
                    CCRYP_SetDMA(model.state, ch, 5, head)
                    CCRYP_SetDMACallback(model.state, ch, 1, 3)
                    CCRYP_SetDMACallback(model.state, ch, 3, 1)
                    model.control[Int(32 + ch * 4)] = status
                    model.control[Int(33 + ch * 4)] = status
                  }
                }
                p.run(27, 0x2000_0000, 64, 0x2000_1000)
                p.run(24, 0)
                p.run(26, 1)
              }
            }
          }
        }
        for keySize: UInt32 in [0, 0x100, 0x200] {
          for algorithm: UInt32 in [0x20, 0x28, 0x30] {
            for size: UInt16 in [0, 16, 32] {
              p.reset()
              p.configuration(.keySize, keySize)
              p.configuration(.algorithm, algorithm)
              p.half(.size, size)
              p.word(.state, 2)
              p.word(.lock, 1)
              p.register(.sr, 0x81)
              p.run(23)
            }
          }
        }
      }
    }
  }

  func testDMAOutputTailCopiesPaddingModeAndCounterTimeout() {
    for cb: UInt32 in 0...1 {
      for instance: UInt32 in 0...1 {
        let p = CRYPPair(cb, 0, 0, instance)
        for size: UInt16 in [0, 1, 3, 4, 7, 15, 16, 17, 31, 32] {
          for algorithm: UInt32 in [
            0x20, 0x28, 0x30, CRYPConstants.CRYP_AES_GCM, CRYPConstants.CRYP_AES_CCM,
          ] {
            for direction: UInt32 in [0, 4, 16] {
              p.reset()
              p.half(.size, size)
              p.configuration(.algorithm, algorithm)
              p.word(.state, 2)
              p.word(.lock, 1)
              p.register(.cr, algorithm | direction)
              p.register(.dmacr, 3)
              p.register(.sr, 4)
              p.register(.dout, 0xC0FF_EE00)
              p.callback(2, 2)
              p.run(25, 1)
            }
          }
        }
        if instance == 0 {
          p.reset()
          p.half(.size, 1)
          p.word(.state, 2)
          p.word(.lock, 1)
          p.callback(3, 2)
          p.control(12, 1)
          p.control(13, 4)
          p.control(14, 4)
          p.control(15, 3)
          p.run(25, 1)
          XCTAssertEqual(p.swift.read(.errorCode), 0x10)
          XCTAssertEqual(p.swift.read(.outputCount), 4)
        }
      }
    }
  }

  func testDMAHeaderUnitsOmittedFlagClearAndZeroHeader() {
    for instance: UInt32 in 0...1 {
      let p = CRYPPair(0, 0, 0, instance)
      for unit: UInt32 in [0, 1] {
        for size: UInt32 in [0, 1, 3, 4, 5, 7, 15, 16, 17, 32] {
          for dataType: UInt32 in [0, 0x40, 0x80, 0xC0] {
            p.reset()
            p.configuration(.headerSize, size)
            p.configuration(.headerWidthUnit, unit)
            p.configuration(.dataType, dataType)
            p.register(.sr, 1)
            p.run(39)
          }
        }
      }
      p.reset()
      p.configuration(.headerSize, 4)
      p.control(5, 100)
      p.run(39)
      p.reset()
      p.configuration(.headerSize, 0)
      p.register(.sr, 0x18)
      p.run(39)
    }
  }
  func testInterruptHeaderPaddingPayloadTransitionAndSuspend() {
    for cb: UInt32 in 0...1 {
      for su: UInt32 in 0...1 {
        for instance: UInt32 in 0...1 {
          let p = CRYPPair(cb, su, 0, instance)
          for unit: UInt32 in [0, 1] {
            for headerSize: UInt32 in [0, 1, 3, 4, 5, 7, 16, 17] {
              for processed: UInt16 in [0, 1, 4, 8] {
                for size: UInt16 in [0, 1, 3, 4, 15, 16, 32] {
                  p.reset()
                  p.configuration(.headerWidthUnit, unit)
                  p.configuration(.headerSize, headerSize)
                  p.half(.headerCount, processed)
                  p.configuration(.algorithm, CRYPConstants.CRYP_AES_CCM)
                  p.half(.size, size)
                  p.word(.state, 2)
                  p.word(.lock, 1)
                  p.register(.cr, 16)
                  p.register(.ier, 15)
                  p.register(.imscr, 3)
                  p.callback(1, 2)
                  p.run(40)
                }
              }
            }
          }
          p.reset()
          p.configuration(.headerSize, 16)
          p.word(.suspendRequest, 1)
          p.word(.state, 2)
          p.word(.lock, 1)
          p.run(40)
        }
      }
    }
  }
  func testInterruptPayloadTailCountersCallbacksAndSuspend() {
    for cb: UInt32 in 0...1 {
      for su: UInt32 in 0...1 {
        for instance: UInt32 in 0...1 {
          let p = CRYPPair(cb, su, 0, instance)
          for size: UInt16 in [0, 1, 2, 3, 4, 7, 15, 16, 17, 31, 32, 48] {
            for input: UInt16 in [0, 4, 8] {
              for output: UInt16 in [0, 4, 8] {
                for algorithm: UInt32 in [0x80000, 0x80008] {
                  p.reset()
                  p.half(.size, size)
                  p.half(.inputCount, input)
                  p.half(.outputCount, output)
                  p.configuration(.algorithm, algorithm)
                  p.word(.state, 2)
                  p.word(.lock, 1)
                  p.register(.sr, 4)
                  p.register(.dout, 0x1234_5678)
                  p.register(.doutr, 0xABCD_0001)
                  p.register(.imscr, 3)
                  p.register(.ier, 15)
                  p.callback(1, 2)
                  p.callback(2, 3)
                  p.run(37)
                }
              }
            }
          }
          p.reset()
          p.half(.size, 32)
          p.word(.suspendRequest, 1)
          p.word(.state, 2)
          p.word(.lock, 1)
          p.register(.sr, 1)
          p.register(.imscr, 3)
          p.register(.ier, 15)
          p.run(37)
        }
      }
    }
  }
  func testIRQDispatchFlagsAndDirectDefaultErrorCallback() {
    for cb: UInt32 in 0...1 {
      for instance: UInt32 in 0...1 {
        for engine: UInt32 in 0...2 {
          let p = CRYPPair(cb, 1, engine, instance)
          for algorithm: UInt32 in [0x20, 0x28, 0x30, 0x80000, 0x80008, 0x999] {
            for phase: UInt32 in [0, 0x10000, 0x2000, 0x30000, 0x6000] {
              for flags: UInt32 in [0, 1, 2, 3, 4, 7, 8, 15] {
                p.reset()
                p.configuration(.algorithm, algorithm)
                p.configuration(.headerSize, 4)
                p.word(.state, 2)
                p.word(.lock, 1)
                p.half(.size, 16)
                p.register(.cr, phase)
                p.register(.sr, flags)
                p.register(.isr, flags)
                p.register(.misr, flags)
                p.register(.imscr, 3)
                p.register(.ier, flags)
                p.callback(3, 3)
                p.callback(1, 2)
                p.callback(2, 2)
                p.run(16)
              }
            }
          }
        }
      }
    }
  }

  func testAuthenticationDMAInitHeaderPayloadAndTail() {
    for cb: UInt32 in 0...1 {
      for instance: UInt32 in 0...1 {
        let p = CRYPPair(cb, 0, 0, instance)
        for op: UInt32 in [33, 36] {
          for size: UInt16 in [0, 1, 3, 4, 7, 15, 16, 17, 32] {
            for skip: UInt32 in [0, 1, 2] {
              for configured: UInt32 in [0, 1] {
                for mode: UInt32 in [0, 4, 16] {
                  for header: UInt32 in [0, 3, 4, 5] {
                    p.reset()
                    p.configuration(.algorithm, op == 33 ? 0x80000 : 0x80008)
                    p.configuration(.keyIVConfigurationSkip, skip)
                    p.configuration(.headerSize, header)
                    p.word(.keyIVConfiguration, configured)
                    p.word(.sizesSum, UInt32.max - 3)
                    p.half(.size, size)
                    p.word(.state, 2)
                    p.word(.lock, 1)
                    p.register(.cr, mode)
                    p.register(.sr, instance == 0 ? 5 : 0x81)
                    p.register(.dout, 0xAABB_1234)
                    if instance == 0 { p.event(0, 1, .cr, mode) }
                    p.run(op)
                  }
                }
              }
            }
          }
        }
        for op: UInt32 in [33, 36] {
          p.reset()
          p.half(.size, 16)
          p.control(5, 100)
          p.run(op)
        }
      }
    }
  }
  func testSuspendDMAAbortOrderRemainingCountAndTimeoutContinuation() {
    for cb: UInt32 in 0...1 {
      for instance: UInt32 in 0...1 {
        let p = CRYPPair(cb, 1, 0, instance)
        for inputStatus: UInt32 in 0...3 {
          for outputStatus: UInt32 in 0...3 {
            for remaining: UInt32 in [0, 4, 16] {
              p.reset()
              p.half(.size, 64)
              p.word(.state, 2)
              p.word(.lock, 1)
              p.register(.sr, 1)
              p.register(.dmacr, 3)
              p.register(.cr, 0x1801)
              p.control(34, inputStatus)
              p.control(38, outputStatus)
              for m in [p.c, p.swift] {
                CCRYP_SetDMA(m.state, 0, 6, remaining)
                CCRYP_SetDMA(m.state, 0, 7, 3 << 16)
              }
              p.run(7)
            }
          }
        }
        p.reset()
        p.word(.state, 1)
        p.run(8)
        p.run(6)
        if instance == 1 {
          p.reset()
          p.word(.state, 2)
          p.word(.lock, 1)
          p.control(5, 100)
          p.run(7)
        }
        for phase: UInt32 in [0, 1, 2, 3, 4, 5, 6] {
          p.reset()
          p.word(.phase, phase)
          p.run(49)
        }
      }
    }
  }

  func testAuthenticationInterruptSetupHeaderPaddingAndSkippedConfiguration() {
    for cb: UInt32 in 0...1 {
      for su: UInt32 in 0...1 {
        for instance: UInt32 in 0...1 {
          let p = CRYPPair(cb, su, 0, instance)
          for op: UInt32 in [32, 35] {
            for size: UInt16 in [0, 1, 3, 4, 15, 16, 17, 32] {
              for skip: UInt32 in [0, 1, 2] {
                for configured: UInt32 in [0, 1] {
                  for header: UInt32 in [0, 1, 3, 4, 5, 16, 17] {
                    for unit: UInt32 in [0, 1] {
                      p.reset()
                      p.configuration(.algorithm, op == 32 ? 0x80000 : 0x80008)
                      p.configuration(.keyIVConfigurationSkip, skip)
                      p.configuration(.headerSize, header)
                      p.configuration(.headerWidthUnit, unit)
                      p.word(.keyIVConfiguration, configured)
                      p.word(.sizesSum, UInt32.max - 3)
                      p.half(.size, size)
                      p.word(.state, 2)
                      p.word(.lock, 1)
                      p.register(.sr, 0x81)
                      p.register(.ier, 8)
                      p.callback(1, 2)
                      if instance == 0 { p.event(0, 1, .cr, 0) }
                      p.run(op)
                    }
                  }
                }
              }
            }
          }
          for op: UInt32 in [32, 35] {
            for phase: UInt32 in [4, 5] {
              p.reset()
              p.word(.phase, phase)
              p.half(.size, 16)
              p.control(5, 100)
              p.run(op)
            }
          }
        }
      }
    }
  }
  func testPublicInterruptAndDMAStateDirectionSizeAndResumingCounts() {
    for cb: UInt32 in 0...1 {
      for su: UInt32 in 0...1 {
        for instance: UInt32 in 0...1 {
          let p = CRYPPair(cb, su, 0, instance)
          for op: UInt32 in 12...15 {
            for algorithm: UInt32 in [0x20, 0x28, 0x30, 0x80000, 0x80008] {
              for size: UInt32 in [0, 1, 4, 16, 17, 16384] {
                for unit: UInt32 in [0, 1] {
                  p.reset()
                  p.configuration(.algorithm, algorithm)
                  p.configuration(.dataWidthUnit, unit)
                  p.word(.state, 1)
                  p.word(.resumingFlag, 1)
                  p.word(.savedInputCount, 4)
                  p.word(.savedOutputCount, 4)
                  p.configuration(.keyIVConfigurationSkip, 1)
                  p.word(.keyIVConfiguration, 1)
                  let saesAlgorithm: UInt32 =
                    algorithm == 0x20
                    ? 0
                    : algorithm == 0x28
                      ? 0x20 : algorithm == 0x30 ? 0x40 : algorithm == 0x80000 ? 0x60 : 0x10000
                  p.register(.cr, instance == 0 ? algorithm : saesAlgorithm)
                  p.register(.sr, 0x85)
                  p.run(op, size)
                }
              }
            }
          }
          for op: UInt32 in 12...15 {
            for state: UInt32 in [0, 1, 2, 3] {
              for lock: UInt32 in [0, 1] {
                p.reset()
                p.word(.state, state)
                p.word(.lock, lock)
                p.control(5, 100)
                p.run(op, 16)
              }
            }
          }
        }
      }
    }
  }
  func testSuspendECBSaveAndResumeHostSafePaths() {
    for cb: UInt32 in 0...1 {
      for instance: UInt32 in 0...1 {
        let p = CRYPPair(cb, 1, 0, instance)
        for unit: UInt32 in [0, 1] {
          p.reset()
          p.word(.state, 3)
          p.half(.size, 64)
          p.half(.inputCount, 4)
          p.half(.outputCount, 4)
          p.configuration(.dataWidthUnit, unit)
          p.word(.phase, 2)
          p.word(.sizesSum, 32)
          p.run(8)
          p.register(.sr, 0x81)
          p.control(5, 100)
          p.run(9)
        }
        for state: UInt32 in [0, 1, 2] {
          p.reset()
          p.word(.savedState, state)
          p.run(9)
        }
      }
    }
  }

}
