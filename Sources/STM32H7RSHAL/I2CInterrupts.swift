// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2C {
  public func eventInterruptHandler() {

    let itflags: UInt32 = registers.read(.isr)
    let itsources: UInt32 = registers.read(.cr1)

    if handle.read(.transferISR) != 0 {
      dispatchTransferInterrupt(itflags, itsources)
    }

  }
  public func errorInterruptHandler() {

    let itflags: UInt32 = registers.read(.isr)
    let itsources: UInt32 = registers.read(.cr1)
    var tmperror: UInt32

    if (checkFlag(itflags, 0x100) != 0) && (checkInterruptSource(itsources, 0x80) != 0) {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x1))

      clearFlag(0x100)
    }

    if (checkFlag(itflags, 0x400) != 0) && (checkInterruptSource(itsources, 0x80) != 0) {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))

      clearFlag(0x400)
    }

    if (checkFlag(itflags, 0x200) != 0) && (checkInterruptSource(itsources, 0x80) != 0) {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))

      clearFlag(0x200)
    }

    tmperror = handle.read(.errorCode)

    if (tmperror & (0x1 | 0x8 | 0x2)) != 0x0 {
      interruptError(tmperror)
    }

  }
  func masterInterrupt(_ ITFlags: UInt32, _ ITSources: UInt32) -> HALStatus {

    var devaddress: UInt32
    var tmpITFlags: UInt32 = ITFlags

    guard lock() else { return .busy }
    if (checkFlag(tmpITFlags, 0x10) != 0) && (checkInterruptSource(ITSources, 0x10) != 0) {
      clearFlag(0x10)

      handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))

      flushTransmitData()
    } else if (checkFlag(tmpITFlags, 0x4) != 0) && (checkInterruptSource(ITSources, 0x4) != 0) {
      tmpITFlags &= ~0x4

      handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((registers.read(.rxdr)) & 0xFF))

      advanceBuffer(1)
      handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
      handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
    } else if (checkFlag(tmpITFlags, 0x2) != 0) && (checkInterruptSource(ITSources, 0x2) != 0) {
      registers.write(.txdr, value: UInt32(handle.readBuffer()!.pointee))

      advanceBuffer(1)
      handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
      handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
    } else if (checkFlag(tmpITFlags, 0x80) != 0) && (checkInterruptSource(ITSources, 0x40) != 0) {
      if (UInt32(handle.read(.transferCount)) != 0) && (UInt32(handle.read(.transferSize)) == 0) {
        devaddress = (((registers.read(.cr2) & 0x3FF)) & 0xFFFF)
        if UInt32(handle.read(.transferCount)) > 0xFF {
          handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
          transferConfiguration(
            UInt16(truncatingIfNeeded: devaddress),
            UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x1000000, 0x0
          )
        } else {
          handle.write(
            .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
          if handle.read(.transferOptions) != 0xFFFF_0000 {
            transferConfiguration(
              UInt16(truncatingIfNeeded: devaddress),
              UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)),
              handle.read(.transferOptions), 0x0)
          } else {
            transferConfiguration(
              UInt16(truncatingIfNeeded: devaddress),
              UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
              0x0)
          }
        }
      } else {
        if stopMode() != 0x2000000 {
          masterSequenceComplete()
        } else {

          interruptError(0x40)
        }
      }
    } else if (checkFlag(tmpITFlags, 0x40) != 0) && (checkInterruptSource(ITSources, 0x40) != 0) {
      if UInt32(handle.read(.transferCount)) == 0 {
        if stopMode() != 0x2000000 {
          if handle.read(.transferOptions) == 0xFFFF_0000 {
            registers.write(.cr2, value: registers.read(.cr2) | (0x4000))
          } else {
            masterSequenceComplete()
          }
        }
      } else {

        interruptError(0x40)
      }
    } else {
    }
    if (checkFlag(tmpITFlags, 0x20) != 0) && (checkInterruptSource(ITSources, 0x20) != 0) {
      masterComplete(tmpITFlags)
    }

    unlock()
    return .ok

  }
  func memoryInterrupt(_ ITFlags: UInt32, _ ITSources: UInt32) -> HALStatus {

    var direction: UInt32 = 0x8000_2000
    var tmpITFlags: UInt32 = ITFlags

    guard lock() else { return .busy }
    if (checkFlag(tmpITFlags, 0x10) != 0) && (checkInterruptSource(ITSources, 0x10) != 0) {
      clearFlag(0x10)

      handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))

      flushTransmitData()
    } else if (checkFlag(tmpITFlags, 0x4) != 0) && (checkInterruptSource(ITSources, 0x4) != 0) {
      tmpITFlags &= ~0x4

      handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((registers.read(.rxdr)) & 0xFF))

      advanceBuffer(1)
      handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
      handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
    } else if (checkFlag(tmpITFlags, 0x2) != 0) && (checkInterruptSource(ITSources, 0x2) != 0) {
      if handle.read(.memoryAddress) == 0xFFFF_FFFF {
        registers.write(.txdr, value: UInt32(handle.readBuffer()!.pointee))

        advanceBuffer(1)
        handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
      } else {
        registers.write(.txdr, value: handle.read(.memoryAddress))

        handle.write(.memoryAddress, value: 0xFFFF_FFFF)
      }
    } else if (checkFlag(tmpITFlags, 0x80) != 0) && (checkInterruptSource(ITSources, 0x40) != 0) {
      if (UInt32(handle.read(.transferCount)) != 0) && (UInt32(handle.read(.transferSize)) == 0) {
        if UInt32(handle.read(.transferCount)) > 0xFF {
          handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
          transferConfiguration(
            UInt16(truncatingIfNeeded: ((handle.read(.deviceAddress)) & 0xFFFF)),
            UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x1000000, 0x0
          )
        } else {
          handle.write(
            .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
          transferConfiguration(
            UInt16(truncatingIfNeeded: ((handle.read(.deviceAddress)) & 0xFFFF)),
            UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000, 0x0
          )
        }
      } else {

        interruptError(0x40)
      }
    } else if (checkFlag(tmpITFlags, 0x40) != 0) && (checkInterruptSource(ITSources, 0x40) != 0) {
      disableIRQ(0x1)

      enableIRQ(0x2)
      if handle.read(.state) == 0x22 {
        direction = 0x8000_2400
      }
      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))

        transferConfiguration(
          UInt16(truncatingIfNeeded: ((handle.read(.deviceAddress)) & 0xFFFF)),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x1000000,
          direction)
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))

        transferConfiguration(
          UInt16(truncatingIfNeeded: ((handle.read(.deviceAddress)) & 0xFFFF)),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
          direction)
      }
    } else {
    }
    if (checkFlag(tmpITFlags, 0x20) != 0) && (checkInterruptSource(ITSources, 0x20) != 0) {
      masterComplete(tmpITFlags)
    }

    unlock()
    return .ok

  }
  func slaveInterrupt(_ ITFlags: UInt32, _ ITSources: UInt32) -> HALStatus {

    let tmpoptions: UInt32 = handle.read(.transferOptions)
    let tmpITFlags: UInt32 = ITFlags

    guard lock() else { return .busy }

    if (checkFlag(tmpITFlags, 0x20) != 0) && (checkInterruptSource(ITSources, 0x20) != 0) {
      slaveComplete(tmpITFlags)
    } else if (checkFlag(tmpITFlags, 0x10) != 0) && (checkInterruptSource(ITSources, 0x10) != 0) {

      if UInt32(handle.read(.transferCount)) == 0 {
        if (handle.read(.state) == 0x28) && (tmpoptions == 0x2000000) {
          listenComplete(tmpITFlags)
        } else if (handle.read(.state) == 0x29) && (tmpoptions != 0xFFFF_0000) {
          clearFlag(0x10)

          flushTransmitData()

          slaveSequenceComplete()
        } else {
          clearFlag(0x10)
        }
      } else {

        clearFlag(0x10)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))
        if (tmpoptions == 0x0) || (tmpoptions == 0x1000000) {
          interruptError(handle.read(.errorCode))
        }
      }
    } else if (checkFlag(tmpITFlags, 0x4) != 0) && (checkInterruptSource(ITSources, 0x4) != 0) {
      if UInt32(handle.read(.transferCount)) > 0 {
        handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((registers.read(.rxdr)) & 0xFF))

        advanceBuffer(1)
        handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
      }
      if (UInt32(handle.read(.transferCount)) == 0) && (tmpoptions != 0xFFFF_0000) {
        slaveSequenceComplete()
      }
    } else if (checkFlag(tmpITFlags, 0x8) != 0) && (checkInterruptSource(ITSources, 0x8) != 0) {
      addressComplete(tmpITFlags)
    } else if (checkFlag(tmpITFlags, 0x2) != 0) && (checkInterruptSource(ITSources, 0x2) != 0) {

      if UInt32(handle.read(.transferCount)) > 0 {
        registers.write(.txdr, value: UInt32(handle.readBuffer()!.pointee))

        advanceBuffer(1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
        handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
      } else {
        if (tmpoptions == 0x1000000) || (tmpoptions == 0x0) {

          slaveSequenceComplete()
        }
      }
    } else {
    }

    unlock()
    return .ok

  }
  func masterDMAInterrupt(_ ITFlags: UInt32, _ ITSources: UInt32) -> HALStatus {

    var devaddress: UInt32
    var xfermode: UInt32

    guard lock() else { return .busy }
    if (checkFlag(ITFlags, 0x10) != 0) && (checkInterruptSource(ITSources, 0x10) != 0) {
      clearFlag(0x10)

      handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))

      enableIRQ(0x20)

      flushTransmitData()
    } else if (checkFlag(ITFlags, 0x80) != 0) && (checkInterruptSource(ITSources, 0x40) != 0) {
      disableInterrupts(0x40)
      if UInt32(handle.read(.transferCount)) != 0 {
        devaddress = (((registers.read(.cr2) & 0x3FF)) & 0xFFFF)

        if UInt32(handle.read(.transferCount)) > 0xFF {
          handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
          xfermode = 0x1000000
        } else {
          handle.write(
            .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
          if handle.read(.transferOptions) != 0xFFFF_0000 {
            xfermode = handle.read(.transferOptions)
          } else {
            xfermode = 0x2000000
          }
        }

        transferConfiguration(
          UInt16(truncatingIfNeeded: devaddress),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), xfermode, 0x0)

        handle.write(
          .transferCount,
          value: UInt16(
            truncatingIfNeeded: UInt32(handle.read(.transferCount))
              &- (UInt32(handle.read(.transferSize)))))

        if handle.read(.state) == 0x22 {
          registers.write(.cr1, value: registers.read(.cr1) | (0x8000))
        } else {
          registers.write(.cr1, value: registers.read(.cr1) | (0x4000))
        }
      } else {
        if stopMode() != 0x2000000 {
          masterSequenceComplete()
        } else {

          interruptError(0x40)
        }
      }
    } else if (checkFlag(ITFlags, 0x40) != 0) && (checkInterruptSource(ITSources, 0x40) != 0) {
      if UInt32(handle.read(.transferCount)) == 0 {
        if stopMode() != 0x2000000 {
          if handle.read(.transferOptions) == 0xFFFF_0000 {
            registers.write(.cr2, value: registers.read(.cr2) | (0x4000))
          } else {
            masterSequenceComplete()
          }
        }
      } else {

        interruptError(0x40)
      }
    } else if (checkFlag(ITFlags, 0x20) != 0) && (checkInterruptSource(ITSources, 0x20) != 0) {
      masterComplete(ITFlags)
    } else {
    }

    unlock()
    return .ok

  }
  func memoryDMAInterrupt(_ ITFlags: UInt32, _ ITSources: UInt32) -> HALStatus {

    var direction: UInt32 = 0x8000_2000

    guard lock() else { return .busy }
    if (checkFlag(ITFlags, 0x10) != 0) && (checkInterruptSource(ITSources, 0x10) != 0) {
      clearFlag(0x10)

      handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))

      enableIRQ(0x20)

      flushTransmitData()
    } else if (checkFlag(ITFlags, 0x2) != 0) && (checkInterruptSource(ITSources, 0x2) != 0) {
      registers.write(.txdr, value: handle.read(.memoryAddress))

      handle.write(.memoryAddress, value: 0xFFFF_FFFF)
    } else if (checkFlag(ITFlags, 0x80) != 0) && (checkInterruptSource(ITSources, 0x40) != 0) {
      disableIRQ(0x1)

      enableIRQ(0x10)
      if UInt32(handle.read(.transferCount)) != 0 {
        if UInt32(handle.read(.transferCount)) > 0xFF {
          handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
          transferConfiguration(
            UInt16(truncatingIfNeeded: ((handle.read(.deviceAddress)) & 0xFFFF)),
            UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x1000000, 0x0
          )
        } else {
          handle.write(
            .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
          transferConfiguration(
            UInt16(truncatingIfNeeded: ((handle.read(.deviceAddress)) & 0xFFFF)),
            UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000, 0x0
          )
        }

        handle.write(
          .transferCount,
          value: UInt16(
            truncatingIfNeeded: UInt32(handle.read(.transferCount))
              &- (UInt32(handle.read(.transferSize)))))

        if handle.read(.state) == 0x22 {
          registers.write(.cr1, value: registers.read(.cr1) | (0x8000))
        } else {
          registers.write(.cr1, value: registers.read(.cr1) | (0x4000))
        }
      } else {

        interruptError(0x40)
      }
    } else if (checkFlag(ITFlags, 0x40) != 0) && (checkInterruptSource(ITSources, 0x40) != 0) {
      disableIRQ(0x1)

      enableIRQ(0x10)
      if handle.read(.state) == 0x22 {
        direction = 0x8000_2400
      }
      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))

        transferConfiguration(
          UInt16(truncatingIfNeeded: ((handle.read(.deviceAddress)) & 0xFFFF)),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x1000000,
          direction)
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))

        transferConfiguration(
          UInt16(truncatingIfNeeded: ((handle.read(.deviceAddress)) & 0xFFFF)),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
          direction)
      }

      handle.write(
        .transferCount,
        value: UInt16(
          truncatingIfNeeded: UInt32(handle.read(.transferCount))
            &- (UInt32(handle.read(.transferSize)))))

      if handle.read(.state) == 0x22 {
        registers.write(.cr1, value: registers.read(.cr1) | (0x8000))
      } else {
        registers.write(.cr1, value: registers.read(.cr1) | (0x4000))
      }
    } else if (checkFlag(ITFlags, 0x20) != 0) && (checkInterruptSource(ITSources, 0x20) != 0) {
      masterComplete(ITFlags)
    } else {
    }

    unlock()
    return .ok

  }
  func slaveDMAInterrupt(_ ITFlags: UInt32, _ ITSources: UInt32) -> HALStatus {

    let tmpoptions: UInt32 = handle.read(.transferOptions)
    var treatdmanack: UInt32 = 0
    var tmpstate: UInt32

    guard lock() else { return .busy }

    if (checkFlag(ITFlags, 0x20) != 0) && (checkInterruptSource(ITSources, 0x20) != 0) {
      slaveComplete(ITFlags)
    } else if (checkFlag(ITFlags, 0x10) != 0) && (checkInterruptSource(ITSources, 0x10) != 0) {

      if (checkInterruptSource(ITSources, 0x4000) != 0)
        || (checkInterruptSource(ITSources, 0x8000) != 0)
      {
        if dma.isPresent(.receive) {
          if checkInterruptSource(ITSources, 0x8000) != 0 {
            if (dma.getCounter(.receive) &+ dma.getFIFOLevel(.receive)) == 0 {
              treatdmanack = 1
            }
          }
        }

        if dma.isPresent(.transmit) {
          if checkInterruptSource(ITSources, 0x4000) != 0 {
            if (dma.getCounter(.transmit) &+ dma.getFIFOLevel(.transmit)) == 0 {
              treatdmanack = 1
            }
          }
        }
        if treatdmanack == 1 {
          if (handle.read(.state) == 0x28) && (tmpoptions == 0x2000000) {
            listenComplete(ITFlags)
          } else if (handle.read(.state) == 0x29) && (tmpoptions != 0xFFFF_0000) {
            clearFlag(0x10)

            flushTransmitData()

            slaveSequenceComplete()
          } else {
            clearFlag(0x10)
          }
        } else {

          clearFlag(0x10)

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))

          tmpstate = handle.read(.state)
          if (tmpoptions == 0x0) || (tmpoptions == 0x1000000) {
            if (tmpstate == 0x21) || (tmpstate == 0x29) {
              handle.write(.previousState, value: 0x21)
            } else if (tmpstate == 0x22) || (tmpstate == 0x2A) {
              handle.write(.previousState, value: 0x22)
            } else {
            }

            interruptError(handle.read(.errorCode))
          }
        }
      } else {
        clearFlag(0x10)
      }
    } else if (checkFlag(ITFlags, 0x8) != 0) && (checkInterruptSource(ITSources, 0x8) != 0) {
      addressComplete(ITFlags)
    } else {
    }

    unlock()
    return .ok

  }
  func dispatchTransferInterrupt(_ flags: UInt32, _ sources: UInt32) {
    switch I2CTransferISR(rawValue: handle.read(.transferISR))! {
    case .none: break
    case .masterInterrupt: _ = masterInterrupt(flags, sources)
    case .memoryInterrupt: _ = memoryInterrupt(flags, sources)
    case .slaveInterrupt: _ = slaveInterrupt(flags, sources)
    case .masterDMA: _ = masterDMAInterrupt(flags, sources)
    case .memoryDMA: _ = memoryDMAInterrupt(flags, sources)
    case .slaveDMA: _ = slaveDMAInterrupt(flags, sources)
    }
  }
}
