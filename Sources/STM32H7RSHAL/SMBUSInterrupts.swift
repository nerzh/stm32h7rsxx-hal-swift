// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMBUS/SMBUSEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SMBUS {
  public func eventInterruptHandler() {

    var tmpisrvalue: UInt32 = registers.read(.isr)
    var tmpcr1value: UInt32 = registers.read(.cr1)

    if (checkInterruptSource(tmpcr1value, (0x40 | 0x20 | 0x10 | 0x2)) != 0)
      && ((checkFlag(tmpisrvalue, 0x2) != 0) || (checkFlag(tmpisrvalue, 0x80) != 0)
        || (checkFlag(tmpisrvalue, 0x40) != 0) || (checkFlag(tmpisrvalue, 0x20) != 0)
        || (checkFlag(tmpisrvalue, 0x10) != 0))
    {
      if (handle.read(.state) & 0x32) == 0x32 {
        _ = slaveInterrupt(tmpisrvalue)
      } else if (handle.read(.state) & 0x12) == 0x12 {
        _ = masterInterrupt(tmpisrvalue)
      } else {
      }
    }

    if (checkInterruptSource(tmpcr1value, (0x40 | 0x20 | 0x10 | 0x4)) != 0)
      && ((checkFlag(tmpisrvalue, 0x4) != 0) || (checkFlag(tmpisrvalue, 0x80) != 0)
        || (checkFlag(tmpisrvalue, 0x40) != 0) || (checkFlag(tmpisrvalue, 0x20) != 0)
        || (checkFlag(tmpisrvalue, 0x10) != 0))
    {
      if (handle.read(.state) & 0x42) == 0x42 {
        _ = slaveInterrupt(tmpisrvalue)
      } else if (handle.read(.state) & 0x22) == 0x22 {
        _ = masterInterrupt(tmpisrvalue)
      } else {
      }
    }

    if ((checkInterruptSource(tmpcr1value, 0x8) != 0)
      || (checkInterruptSource(tmpcr1value, 0x20) != 0)
      || (checkInterruptSource(tmpcr1value, 0x10) != 0))
      && ((checkFlag(tmpisrvalue, 0x8) != 0) || (checkFlag(tmpisrvalue, 0x20) != 0)
        || (checkFlag(tmpisrvalue, 0x10) != 0))
    {
      if (handle.read(.state) & 0x8) == 0x8 {
        _ = slaveInterrupt(tmpisrvalue)
      }
    }

  }
  public func errorInterruptHandler() {

    interruptError()

  }
  func masterInterrupt(_ StatusFlags: UInt32) -> HALStatus {

    var DevAddress: UInt32

    guard lock() else { return .busy }
    if checkFlag(StatusFlags, 0x10) != 0 {
      clearFlag(0x10)

      handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))

      flushTransmitData()

      unlock()

      if useRegisteredCallbacks {
        callbacks.read(.error)!(callbacks.context)
      } else {
        defaults.error(callbacks.context)
      }
    } else if checkFlag(StatusFlags, 0x20) != 0 {
      interruptError()

      if handle.read(.state) == 0x12 {
        disableIRQ(0xf2)

        clearFlag(0x20)

        resetCR2()

        disable()
        handle.write(.previousState, value: 0x1)
        handle.write(.state, value: 0x1)

        unlock()

        enable()

        if useRegisteredCallbacks {
          callbacks.read(.masterTransmitComplete)!(callbacks.context)
        } else {
          defaults.masterTransmitComplete(callbacks.context)
        }
      } else if handle.read(.state) == 0x22 {
        if checkFlag(StatusFlags, 0x4) != 0 {
          handle.readBuffer()!.pointee = UInt8(
            truncatingIfNeeded: (((registers.read(.rxdr))) & 0xFF))

          advanceBuffer(1)
          if UInt32(handle.read(.transferSize)) > 0 {
            handle.write(
              .transferSize,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferSize)) &- (1)))
            handle.write(
              .transferCount,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
          }
        }

        disableIRQ(0xd4)

        clearFlag(0x20)

        resetCR2()
        handle.write(.previousState, value: 0x1)
        handle.write(.state, value: 0x1)

        unlock()

        if useRegisteredCallbacks {
          callbacks.read(.masterReceiveComplete)!(callbacks.context)
        } else {
          defaults.masterReceiveComplete(callbacks.context)
        }
      } else {
      }
    } else if checkFlag(StatusFlags, 0x4) != 0 {
      handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: (((registers.read(.rxdr))) & 0xFF))

      advanceBuffer(1)

      handle.write(
        .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferSize)) &- (1)))
      handle.write(
        .transferCount,
        value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
    } else if checkFlag(StatusFlags, 0x2) != 0 {
      registers.write(.txdr, value: UInt32(handle.readBuffer()!.pointee))

      advanceBuffer(1)

      handle.write(
        .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferSize)) &- (1)))
      handle.write(
        .transferCount,
        value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
    } else if checkFlag(StatusFlags, 0x80) != 0 {
      if (UInt32(handle.read(.transferCount)) != 0) && (UInt32(handle.read(.transferSize)) == 0) {
        DevAddress = (((registers.read(.cr2) & 0x3ff)) & 0xFFFF)
        if UInt32(handle.read(.transferCount)) > 0xff {
          transferConfiguration(
            DevAddress, 0xff, (0x1000000 | (handle.read(.transferOptions) & 0x4000000)), 0x0)
          handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xff))
        } else {
          handle.write(
            .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
          transferConfiguration(
            DevAddress, ((UInt32(handle.read(.transferSize))) & 0xFF),
            handle.read(.transferOptions), 0x0)

          if pecMode() != 0 {
            handle.write(
              .transferSize,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferSize)) &- (1)))
            handle.write(
              .transferCount,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
          }
        }
      } else if (UInt32(handle.read(.transferCount)) == 0)
        && (UInt32(handle.read(.transferSize)) == 0)
      {
        if stopMode() != 0x2000000 {
          if handle.read(.state) == 0x12 {
            disableIRQ(0xf2)
            handle.write(.previousState, value: handle.read(.state))
            handle.write(.state, value: 0x1)

            unlock()

            if useRegisteredCallbacks {
              callbacks.read(.masterTransmitComplete)!(callbacks.context)
            } else {
              defaults.masterTransmitComplete(callbacks.context)
            }
          } else if handle.read(.state) == 0x22 {
            disableIRQ(0xd4)
            handle.write(.previousState, value: handle.read(.state))
            handle.write(.state, value: 0x1)

            unlock()

            if useRegisteredCallbacks {
              callbacks.read(.masterReceiveComplete)!(callbacks.context)
            } else {
              defaults.masterReceiveComplete(callbacks.context)
            }
          } else {
          }
        }
      } else {
      }
    } else if checkFlag(StatusFlags, 0x40) != 0 {
      if UInt32(handle.read(.transferCount)) == 0 {
        if handle.readBuffer() == nil {
          registers.write(.cr2, value: registers.read(.cr2) | (0x4000))
        } else if stopMode() != 0x2000000 {

          if handle.read(.state) == 0x12 {
            disableIRQ(0xf2)
            handle.write(.previousState, value: handle.read(.state))
            handle.write(.state, value: 0x1)

            unlock()

            if useRegisteredCallbacks {
              callbacks.read(.masterTransmitComplete)!(callbacks.context)
            } else {
              defaults.masterTransmitComplete(callbacks.context)
            }
          } else if handle.read(.state) == 0x22 {
            disableIRQ(0xd4)
            handle.write(.previousState, value: handle.read(.state))
            handle.write(.state, value: 0x1)

            unlock()

            if useRegisteredCallbacks {
              callbacks.read(.masterReceiveComplete)!(callbacks.context)
            } else {
              defaults.masterReceiveComplete(callbacks.context)
            }
          } else {
          }
        } else {
        }
      }
    } else {
    }

    unlock()
    return .ok

  }
  func slaveInterrupt(_ StatusFlags: UInt32) -> HALStatus {

    var TransferDirection: UInt32
    var SlaveAddrCode: UInt32

    guard lock() else { return .busy }
    if checkFlag(StatusFlags, 0x10) != 0 {

      if UInt32(handle.read(.transferCount)) == 0 {
        clearFlag(0x10)

        flushTransmitData()

        unlock()
      } else {

        clearFlag(0x10)

        handle.write(.previousState, value: handle.read(.state))
        handle.write(.state, value: handle.read(.state) & (~((0x32))))
        handle.write(.state, value: handle.read(.state) & (~((0x42))))

        disableIRQ(0xd4 | 0xf2)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))

        flushTransmitData()

        unlock()

        if useRegisteredCallbacks {
          callbacks.read(.error)!(callbacks.context)
        } else {
          defaults.error(callbacks.context)
        }
      }
    } else if checkFlag(StatusFlags, 0x8) != 0 {
      TransferDirection = (((direction())) & 0xFF)
      SlaveAddrCode = (((addressMatch())) & 0xFFFF)

      disableInterrupts(0x8)

      unlock()

      if useRegisteredCallbacks {
        callbacks.readAddress()!(
          callbacks.context, UInt8(truncatingIfNeeded: TransferDirection),
          UInt16(truncatingIfNeeded: SlaveAddrCode))
      } else {
        defaults.address(
          callbacks.context, UInt8(truncatingIfNeeded: TransferDirection),
          UInt16(truncatingIfNeeded: SlaveAddrCode))
      }
    } else if (checkFlag(StatusFlags, 0x4) != 0) || (checkFlag(StatusFlags, 0x80) != 0) {
      if (handle.read(.state) & 0x42) == 0x42 {
        handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: (((registers.read(.rxdr))) & 0xFF))

        advanceBuffer(1)
        handle.write(
          .transferSize,
          value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferSize)) &- (1)))
        handle.write(
          .transferCount,
          value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
        if UInt32(handle.read(.transferCount)) == 1 {

          handle.write(.transferOptions, value: handle.read(.transferOptions) & (~0x1000000))
          transferConfiguration(0, 1, handle.read(.transferOptions), 0x0)
        } else if UInt32(handle.read(.transferCount)) == 0 {
          disableIRQ(0xd4)

          handle.write(.previousState, value: handle.read(.state))
          handle.write(.state, value: handle.read(.state) & (~((0x42))))

          unlock()

          if useRegisteredCallbacks {
            callbacks.read(.slaveReceiveComplete)!(callbacks.context)
          } else {
            defaults.slaveReceiveComplete(callbacks.context)
          }
        } else {
          transferConfiguration(0, 1, 0x1000000 | (handle.read(.transferOptions) & 0x4000000), 0x0)

          registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))
        }
      } else if (handle.read(.state) & 0x32) == 0x32 {
        if (UInt32(handle.read(.transferCount)) != 0) && (UInt32(handle.read(.transferSize)) == 0) {
          if UInt32(handle.read(.transferCount)) > 0xff {
            transferConfiguration(
              0, 0xff, (0x1000000 | (handle.read(.transferOptions) & 0x4000000)), 0x0)
            handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xff))
          } else {
            handle.write(
              .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
            transferConfiguration(
              0, ((UInt32(handle.read(.transferSize))) & 0xFF), handle.read(.transferOptions), 0x0)

            if pecMode() != 0 {
              handle.write(
                .transferSize,
                value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferSize)) &- (1)))
              handle.write(
                .transferCount,
                value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
            }
          }
        }
      } else {
      }
    } else if checkFlag(StatusFlags, 0x2) != 0 {

      if UInt32(handle.read(.transferCount)) > 0 {
        registers.write(.txdr, value: UInt32(handle.readBuffer()!.pointee))

        advanceBuffer(1)
        handle.write(
          .transferCount,
          value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
        handle.write(
          .transferSize,
          value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferSize)) &- (1)))
      }
      if UInt32(handle.read(.transferCount)) == 0 {

        disableIRQ(0xf2)
        handle.write(.previousState, value: handle.read(.state))
        handle.write(.state, value: handle.read(.state) & (~((0x32))))

        unlock()

        if useRegisteredCallbacks {
          callbacks.read(.slaveTransmitComplete)!(callbacks.context)
        } else {
          defaults.slaveTransmitComplete(callbacks.context)
        }
      }
    } else {
    }

    if checkFlag(StatusFlags, 0x20) != 0 {
      if (handle.read(.state) & 0x8) == 0x8 {
        if getFlag(0x4) != 0 {
          handle.readBuffer()!.pointee = UInt8(
            truncatingIfNeeded: (((registers.read(.rxdr))) & 0xFF))

          advanceBuffer(1)
          if UInt32(handle.read(.transferSize)) > 0 {
            handle.write(
              .transferSize,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferSize)) &- (1)))
            handle.write(
              .transferCount,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
          }
        }

        disableIRQ(0xd4 | 0xf2)

        disableIRQ(0x38)

        registers.write(.cr2, value: registers.read(.cr2) | (0x8000))

        resetCR2()

        clearFlag(0x20)

        clearFlag(0x8)
        handle.write(.transferOptions, value: 0)
        handle.write(.previousState, value: handle.read(.state))
        handle.write(.state, value: 0x1)

        unlock()

        if useRegisteredCallbacks {
          callbacks.read(.listenComplete)!(callbacks.context)
        } else {
          defaults.listenComplete(callbacks.context)
        }
      }
    }

    unlock()
    return .ok

  }
  func interruptError() {

    var itflags: UInt32 = registers.read(.isr)
    var itsources: UInt32 = registers.read(.cr1)
    var tmpstate: UInt32
    var tmperror: UInt32

    if ((itflags & 0x100) == 0x100) && ((itsources & 0x80) == 0x80) {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x1))

      clearFlag(0x100)
    }

    if ((itflags & 0x400) == 0x400) && ((itsources & 0x80) == 0x80) {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))

      clearFlag(0x400)
    }

    if ((itflags & 0x200) == 0x200) && ((itsources & 0x80) == 0x80) {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))

      clearFlag(0x200)
    }

    if ((itflags & 0x1000) == 0x1000) && ((itsources & 0x80) == 0x80) {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))

      clearFlag(0x1000)
    }

    if ((itflags & 0x2000) == 0x2000) && ((itsources & 0x80) == 0x80) {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))

      clearFlag(0x2000)
    }

    if ((itflags & 0x800) == 0x800) && ((itsources & 0x80) == 0x80) {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

      clearFlag(0x800)
    }
    if handle.read(.errorCode) != 0x0 {
      flushTransmitData()
    }

    tmperror = handle.read(.errorCode)

    if (tmperror != 0x0) && (tmperror != 0x4) {
      if (tmperror & 0x40) != 0x40 {
        tmpstate = handle.read(.state)
        if ((tmpstate & 0x32) == 0x32)
          || ((tmpstate & 0x42) == 0x42)
        {

          handle.write(.previousState, value: 0x1)
          handle.write(.state, value: 0x8)
        }
      }

      if useRegisteredCallbacks {
        callbacks.read(.error)!(callbacks.context)
      } else {
        defaults.error(callbacks.context)
      }
    }

  }
}
