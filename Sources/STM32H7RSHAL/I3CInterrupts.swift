// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  public func activateNotification(
    _ pXferData: UnsafeMutablePointer<I3CTransfer>?, _ interruptMask: UInt32
  ) -> HALStatus {

    var status: HALStatus = .ok

    do {

      if (handle.read(.state) == 0x0)
        || ((handle.read(.mode) != 0x1) && (handle.read(.mode) != 0x2))
      {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle.read(.mode) == 0x2) && ((interruptMask & (0x4000_0020 | 0x8000_0020)) != 0)
        && (pXferData == nil)
      {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else {
        if handle.read(.mode) == 0x2 {
          if (interruptMask & (0x4000_0020 | 0x8000_0020)) != 0 {
            handle.writeTransfer(pXferData)
            handle.write(
              .receiveTransferCount, value: handle.readTransfer()!.pointee.receiveBuffer.size)

            if llGetRxFIFOThreshold() == 0x0 {
              handle.write(.receiveTreatment, value: 1)
            } else {
              handle.write(.receiveTreatment, value: 2)
            }
          }
          handle.write(.transferISR, value: I3CTransferISR.targetEvent.rawValue)
        } else {
          handle.write(.transferISR, value: I3CTransferISR.controllerEvent.rawValue)
        }

        handle.write(.errorCode, value: 0x0)
        handle.write(.state, value: 0x30)
        handle.write(.previousState, value: 0x30)

        enableTransferInterrupts((interruptMask | 0x1))
      }
    }
    return status

  }
  public func deactivateNotification(_ interruptMask: UInt32) -> HALStatus {

    var status: HALStatus = .ok

    do {

      if handle.read(.state) == 0x0 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        disableTransferInterrupts((interruptMask | 0x1))
        if registers.read(.ier) == 0 {
          handle.write(.transferISR, value: 0)

          handle.write(.state, value: 0x10)
          handle.write(.previousState, value: 0x10)
        }
      }
    }
    return status

  }
  public func errorInterruptHandler() {

    let it_flag: UInt32 = registers.read(.evr)
    let it_source: UInt32 = registers.read(.ier)

    if ((((((it_flag) & (0x800)) == (0x800)) ? 1 : 0)) != 0)
      && ((((((it_source) & (0x800)) == (0x800)) ? 1 : 0)) != 0)
    {
      llClearFlagERR()
      if handle.read(.state) != 0x60 {
        getErrorSources()
      }

      treatError()
    }

  }
  public func eventInterruptHandler() {

    let it_flags: UInt32 = registers.read(.evr)
    let it_sources: UInt32 = registers.read(.ier)
    let it_masks: UInt32 = UInt32(truncatingIfNeeded: (it_flags & it_sources))

    if handle.read(.transferISR) != 0 {
      _ = invokeTransferISR(it_masks)
    }

  }
  func handleTargetEvent(_ itMasks: UInt32) -> HALStatus {

    var tmpevent: UInt32 = 0

    if (((((itMasks) & (0x20)) == (0x20)) ? 1 : 0)) != 0 {
      invokeReceiveTreatment()
    }

    if (((((itMasks) & (0x40000)) == (0x40000)) ? 1 : 0)) != 0 {
      llClearFlagCRUPD()

      tmpevent |= 0x1
    }

    if (((((itMasks) & (0x400000)) == (0x400000)) ? 1 : 0)) != 0 {
      llClearFlagGET()

      tmpevent |= 0x8
    }

    if (((((itMasks) & (0x800000)) == (0x800000)) ? 1 : 0)) != 0 {
      llClearFlagSTA()

      tmpevent |= 0x10
    }

    if (((((itMasks) & (0x1000000)) == (0x1000000)) ? 1 : 0)) != 0 {
      llClearFlagDAUPD()

      tmpevent |= 0x4
    }

    if (((((itMasks) & (0x2000000)) == (0x2000000)) ? 1 : 0)) != 0 {
      llClearFlagMWLUPD()

      tmpevent |= 0x20
    }

    if (((((itMasks) & (0x4000000)) == (0x4000000)) ? 1 : 0)) != 0 {
      llClearFlagMRLUPD()

      tmpevent |= 0x40
    }

    if (((((itMasks) & (0x8000000)) == (0x8000000)) ? 1 : 0)) != 0 {
      llClearFlagRST()

      tmpevent |= 0x80
    }

    if (((((itMasks) & (0x1000_0000)) == (0x1000_0000)) ? 1 : 0)) != 0 {
      llClearFlagASUPD()

      tmpevent |= 0x100
    }

    if (((((itMasks) & (0x2000_0000)) == (0x2000_0000)) ? 1 : 0)) != 0 {
      llClearFlagINTUPD()

      tmpevent |= 0x200
    }

    if (((((itMasks) & (0x4000_0000)) == (0x4000_0000)) ? 1 : 0)) != 0 {
      llClearFlagDEF()

      tmpevent |= 0x400
    }

    if (((((itMasks) & (0x8000_0000)) == (0x8000_0000)) ? 1 : 0)) != 0 {
      llClearFlagGRP()

      tmpevent |= 0x800
    }

    if (((((itMasks) & (0x200000)) == (0x200000)) ? 1 : 0)) != 0 {
      llClearFlagWKP()

      tmpevent |= 0x1000
    }
    if tmpevent != 0 {
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, tmpevent)
      } else {
        defaults.notify(callbacks.context, tmpevent)
      }
    }

    updateState()
    return .ok

  }
  func handleControllerEvent(_ itMasks: UInt32) -> HALStatus {

    if (((((itMasks) & (0x8000)) == (0x8000)) ? 1 : 0)) != 0 {
      llClearFlagIBI()
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x2000)
      } else {
        defaults.notify(callbacks.context, 0x2000)
      }
    }

    if (((((itMasks) & (0x20000)) == (0x20000)) ? 1 : 0)) != 0 {
      llClearFlagCR()
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x4000)
      } else {
        defaults.notify(callbacks.context, 0x4000)
      }
    }

    if (((((itMasks) & (0x80000)) == (0x80000)) ? 1 : 0)) != 0 {
      llClearFlagHJ()
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x8000)
      } else {
        defaults.notify(callbacks.context, 0x8000)
      }
    }

    updateState()
    return .ok

  }
  func handleTargetHotJoin(_ itMasks: UInt32) -> HALStatus {

    if (((((itMasks) & (0x1000000)) == (0x1000000)) ? 1 : 0)) != 0 {
      llClearFlagDAUPD()

      disableTransferInterrupts(0x20)

      if llIsEnabledOwnDynAddress() == 1 {
        updateState()
        handle.write(.errorCode, value: 0x0)
        if useRegisteredCallbacks {
          callbacks.readTargetHotJoin()!(
            callbacks.context,
            UInt8(truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: llGetOwnDynamicAddress()))))
        } else {
          defaults.targetHotJoin(
            callbacks.context,
            UInt8(truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: llGetOwnDynamicAddress()))))
        }
      } else {
        handle.write(.errorCode, value: 0x400000)

        treatError()
      }
    }
    return .ok

  }
  func handleTargetControlRole(_ itMasks: UInt32) -> HALStatus {

    if (((((itMasks) & (0x40000)) == (0x40000)) ? 1 : 0)) != 0 {
      llClearFlagCRUPD()

      disableTransferInterrupts(0x10)

      updateState()
      handle.write(.errorCode, value: 0x0)
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x1)
      } else {
        defaults.notify(callbacks.context, 0x1)
      }
    }
    return .ok

  }
  func handleTargetIBI(_ itMasks: UInt32) -> HALStatus {

    if (((((itMasks) & (0x10000)) == (0x10000)) ? 1 : 0)) != 0 {
      llClearFlagIBIEND()

      disableTransferInterrupts(0x40)

      updateState()
      handle.write(.errorCode, value: 0x0)
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x2)
      } else {
        defaults.notify(callbacks.context, 0x2)
      }
    }
    return .ok

  }
  func handleTargetTransmit(_ itMasks: UInt32) -> HALStatus {

    if handle.read(.state) == 0x21 {
      if (((((itMasks) & (0x10)) == (0x10)) ? 1 : 0)) != 0 {
        if handle.read(.transmitTransferCount) > 0 {
          invokeTransmitTreatment()
        }
      }

      if (((((itMasks) & (0x200)) == (0x200)) ? 1 : 0)) != 0 {
        llClearFlagFC()

        if llGetXferDataCount() == handle.readTransfer()!.pointee.transmitBuffer.size {
          disableTransferInterrupts(0x2)

          updateState()
          handle.write(.errorCode, value: 0x0)

          if useRegisteredCallbacks {
            callbacks.read(.targetTransmitComplete)!(callbacks.context)
          } else {
            defaults.targetTransmitComplete(callbacks.context)
          }
        } else {
          handle.write(.errorCode, value: 0x100000)

          treatError()
        }
      }

      if (((((itMasks) & (0x200000)) == (0x200000)) ? 1 : 0)) != 0 {
        llClearFlagWKP()
        if useRegisteredCallbacks {
          callbacks.readNotify()!(callbacks.context, 0x1000)
        } else {
          defaults.notify(callbacks.context, 0x1000)
        }
      }
    }
    return .ok

  }
  func handleTargetReceive(_ itMasks: UInt32) -> HALStatus {

    if handle.read(.state) == 0x22 {
      if (((((itMasks) & (0x20)) == (0x20)) ? 1 : 0)) != 0 {
        if handle.read(.receiveTransferCount) > 0 {
          invokeReceiveTreatment()
        }
      }

      if (((((itMasks) & (0x200)) == (0x200)) ? 1 : 0)) != 0 {
        llClearFlagFC()

        if llGetXferDataCount() == handle.readTransfer()!.pointee.receiveBuffer.size {
          disableTransferInterrupts(0x4)

          updateState()
          handle.write(.errorCode, value: 0x0)

          if useRegisteredCallbacks {
            callbacks.read(.targetReceiveComplete)!(callbacks.context)
          } else {
            defaults.targetReceiveComplete(callbacks.context)
          }
        } else {
          handle.write(.errorCode, value: 0x100000)

          treatError()
        }
      }

      if (((((itMasks) & (0x200000)) == (0x200000)) ? 1 : 0)) != 0 {
        llClearFlagWKP()
        if useRegisteredCallbacks {
          callbacks.readNotify()!(callbacks.context, 0x1000)
        } else {
          defaults.notify(callbacks.context, 0x1000)
        }
      }
    }
    return .ok

  }
  func handleTargetTransmitDMA(_ itMasks: UInt32) -> HALStatus {

    if handle.read(.state) == 0x21 {
      if (((((itMasks) & (0x200)) == (0x200)) ? 1 : 0)) != 0 {
        llClearFlagFC()

        if ((dma.getCounter(.transmit) &+ dma.getFIFOLevel(.transmit))) == 0 {
          disableTransferInterrupts(0x8)

          updateState()
          handle.write(.errorCode, value: 0x0)

          handle.write(.transmitTransferCount, value: 0)

          if useRegisteredCallbacks {
            callbacks.read(.targetTransmitComplete)!(callbacks.context)
          } else {
            defaults.targetTransmitComplete(callbacks.context)
          }
        } else {
          handle.write(.errorCode, value: 0x100000)

          treatError()
        }
      }

      if (((((itMasks) & (0x200000)) == (0x200000)) ? 1 : 0)) != 0 {
        llClearFlagWKP()
        if useRegisteredCallbacks {
          callbacks.readNotify()!(callbacks.context, 0x1000)
        } else {
          defaults.notify(callbacks.context, 0x1000)
        }
      }
    }
    return .ok

  }
  func handleTargetReceiveDMA(_ itMasks: UInt32) -> HALStatus {

    if handle.read(.state) == 0x22 {
      if (((((itMasks) & (0x200)) == (0x200)) ? 1 : 0)) != 0 {
        llClearFlagFC()

        if ((dma.getCounter(.receive) &+ dma.getFIFOLevel(.receive))) == 0 {
          disableTransferInterrupts(0x8)

          updateState()
          handle.write(.errorCode, value: 0x0)

          handle.write(.receiveTransferCount, value: 0)

          if useRegisteredCallbacks {
            callbacks.read(.targetReceiveComplete)!(callbacks.context)
          } else {
            defaults.targetReceiveComplete(callbacks.context)
          }
        } else {
          handle.write(.errorCode, value: 0x100000)

          treatError()
        }
      }

      if (((((itMasks) & (0x200000)) == (0x200000)) ? 1 : 0)) != 0 {
        llClearFlagWKP()
        if useRegisteredCallbacks {
          callbacks.readNotify()!(callbacks.context, 0x1000)
        } else {
          defaults.notify(callbacks.context, 0x1000)
        }
      }
    }
    return .ok

  }
  func handleControllerTransmit(_ itMasks: UInt32) -> HALStatus {

    if handle.read(.state) == 0x21 {
      if (((((itMasks) & (0x4)) == (0x4)) ? 1 : 0)) != 0 {
        if handle.read(.controlTransferCount) > 0 {
          controlData()
        }
      }

      if (((((itMasks) & (0x10)) == (0x10)) ? 1 : 0)) != 0 {
        if handle.read(.transmitTransferCount) > 0 {
          invokeTransmitTreatment()
        }
      }

      if (((((itMasks) & (0x8)) == (0x8)) ? 1 : 0)) != 0 {
        _ = registers.read(.sr)
      }

      if (((((itMasks) & (0x200)) == (0x200)) ? 1 : 0)) != 0 {
        llClearFlagFC()
        if handle.read(.controlTransferCount) == 0 {
          disableTransferInterrupts(0x80)

          updateState()
          handle.write(.errorCode, value: 0x0)

          if useRegisteredCallbacks {
            callbacks.read(.controllerTransmitComplete)!(callbacks.context)
          } else {
            defaults.controllerTransmitComplete(callbacks.context)
          }
        } else {
          handle.write(.errorCode, value: 0x0)

          if useRegisteredCallbacks {
            callbacks.read(.controllerTransmitComplete)!(callbacks.context)
          } else {
            defaults.controllerTransmitComplete(callbacks.context)
          }

          llRequestTransfer()
        }
      }
    }
    return .ok

  }
  func handleControllerReceive(_ itMasks: UInt32) -> HALStatus {

    if handle.read(.state) == 0x22 {
      if (((((itMasks) & (0x4)) == (0x4)) ? 1 : 0)) != 0 {
        if handle.read(.controlTransferCount) > 0 {
          controlData()
        }
      }

      if (((((itMasks) & (0x20)) == (0x20)) ? 1 : 0)) != 0 {
        if handle.read(.receiveTransferCount) > 0 {
          invokeReceiveTreatment()
        }
      }

      if (((((itMasks) & (0x10)) == (0x10)) ? 1 : 0)) != 0 {
        if handle.read(.transmitTransferCount) > 0 {
          invokeTransmitTreatment()
        }
      }

      if (((((itMasks) & (0x8)) == (0x8)) ? 1 : 0)) != 0 {
        _ = registers.read(.sr)
      }

      if (((((itMasks) & (0x200)) == (0x200)) ? 1 : 0)) != 0 {
        llClearFlagFC()
        if handle.read(.controlTransferCount) == 0 {
          disableTransferInterrupts(0x400)

          updateState()
          handle.write(.errorCode, value: 0x0)

          if useRegisteredCallbacks {
            callbacks.read(.controllerReceiveComplete)!(callbacks.context)
          } else {
            defaults.controllerReceiveComplete(callbacks.context)
          }
        } else {
          handle.write(.errorCode, value: 0x0)

          if useRegisteredCallbacks {
            callbacks.read(.controllerReceiveComplete)!(callbacks.context)
          } else {
            defaults.controllerReceiveComplete(callbacks.context)
          }

          llRequestTransfer()
        }
      }
    }
    return .ok

  }
  func handleControllerMultipleTransfer(_ itMasks: UInt32) -> HALStatus {

    if handle.read(.state) == 0x23 {
      if (((((itMasks) & (0x4)) == (0x4)) ? 1 : 0)) != 0 {
        if handle.read(.controlTransferCount) > 0 {
          controlData()
        }
      }

      if (((((itMasks) & (0x10)) == (0x10)) ? 1 : 0)) != 0 {
        if handle.read(.transmitTransferCount) > 0 {
          invokeTransmitTreatment()
        }
      }

      if (((((itMasks) & (0x20)) == (0x20)) ? 1 : 0)) != 0 {
        if handle.read(.receiveTransferCount) > 0 {
          invokeReceiveTreatment()
        }
      }

      if (((((itMasks) & (0x8)) == (0x8)) ? 1 : 0)) != 0 {
        _ = registers.read(.sr)
      }

      if (((((itMasks) & (0x200)) == (0x200)) ? 1 : 0)) != 0 {
        llClearFlagFC()
        if handle.read(.controlTransferCount) == 0 {
          disableTransferInterrupts(0x80)

          disableTransferInterrupts(0x400)

          updateState()
          handle.write(.errorCode, value: 0x0)

          if useRegisteredCallbacks {
            callbacks.read(.controllerMultipleTransferComplete)!(callbacks.context)
          } else {
            defaults.controllerMultipleTransferComplete(callbacks.context)
          }
        } else {
          handle.write(.errorCode, value: 0x0)

          llRequestTransfer()
        }
      }
    }
    return .ok

  }
  func handleControllerTransmitListen(_ itMasks: UInt32) -> HALStatus {

    if (((((itMasks) & (0x8000)) == (0x8000)) ? 1 : 0)) != 0 {
      llClearFlagIBI()
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x2000)
      } else {
        defaults.notify(callbacks.context, 0x2000)
      }
    }

    if (((((itMasks) & (0x20000)) == (0x20000)) ? 1 : 0)) != 0 {
      llClearFlagCR()
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x4000)
      } else {
        defaults.notify(callbacks.context, 0x4000)
      }
    }

    if (((((itMasks) & (0x80000)) == (0x80000)) ? 1 : 0)) != 0 {
      llClearFlagHJ()
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x8000)
      } else {
        defaults.notify(callbacks.context, 0x8000)
      }
    }

    return (handleControllerTransmit(itMasks))

  }
  func handleControllerReceiveListen(_ itMasks: UInt32) -> HALStatus {

    if (((((itMasks) & (0x8000)) == (0x8000)) ? 1 : 0)) != 0 {
      llClearFlagIBI()
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x2000)
      } else {
        defaults.notify(callbacks.context, 0x2000)
      }
    }

    if (((((itMasks) & (0x20000)) == (0x20000)) ? 1 : 0)) != 0 {
      llClearFlagCR()
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x4000)
      } else {
        defaults.notify(callbacks.context, 0x4000)
      }
    }

    if (((((itMasks) & (0x80000)) == (0x80000)) ? 1 : 0)) != 0 {
      llClearFlagHJ()
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x8000)
      } else {
        defaults.notify(callbacks.context, 0x8000)
      }
    }

    return (handleControllerReceive(itMasks))

  }
  func handleControllerMultipleTransferListen(_ itMasks: UInt32) -> HALStatus {

    if (((((itMasks) & (0x8000)) == (0x8000)) ? 1 : 0)) != 0 {
      llClearFlagIBI()
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x2000)
      } else {
        defaults.notify(callbacks.context, 0x2000)
      }
    }

    if (((((itMasks) & (0x20000)) == (0x20000)) ? 1 : 0)) != 0 {
      llClearFlagCR()
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x4000)
      } else {
        defaults.notify(callbacks.context, 0x4000)
      }
    }

    if (((((itMasks) & (0x80000)) == (0x80000)) ? 1 : 0)) != 0 {
      llClearFlagHJ()
      if useRegisteredCallbacks {
        callbacks.readNotify()!(callbacks.context, 0x8000)
      } else {
        defaults.notify(callbacks.context, 0x8000)
      }
    }

    return (handleControllerMultipleTransfer(itMasks))

  }
  func handleControllerDynamicAddress(_ itMasks: UInt32) -> HALStatus {

    var target_payload: UInt64 = 0

    if handle.read(.state) == 0x24 {
      if (((((itMasks) & (0x4)) == (0x4)) ? 1 : 0)) != 0 {
        llControllerHandleCCC(0x7, 0, 0x8000_0000)
      }

      if (((((itMasks) & (0x10)) == (0x10)) ? 1 : 0)) != 0 {
        if llGetRxFIFOThreshold() == 0x0 {
          do {
            var index: UInt32 = 0
            while index < 8 {

              target_payload |= UInt64((UInt64(llReceiveData8()) << (index &* 8)))
              index &+= 1
            }
          }
        } else {
          target_payload = UInt64(llReceiveData32())

          target_payload |= UInt64((UInt64(llReceiveData32()) << 32))
        }

        if useRegisteredCallbacks {
          callbacks.readTargetRequestDynamicAddress()!(callbacks.context, target_payload)
        } else {
          defaults.targetRequestDynamicAddress(callbacks.context, target_payload)
        }
      }

      if (((((itMasks) & (0x8)) == (0x8)) ? 1 : 0)) != 0 {
        _ = registers.read(.sr)
      }

      if (((((itMasks) & (0x200)) == (0x200)) ? 1 : 0)) != 0 {
        llClearFlagFC()

        disableTransferInterrupts(0x1000)

        updateState()
        handle.write(.errorCode, value: 0x0)

        if useRegisteredCallbacks {
          callbacks.read(.controllerDynamicAddressComplete)!(callbacks.context)
        } else {
          defaults.controllerDynamicAddressComplete(callbacks.context)
        }
      }
    }
    return .ok

  }
  func handleControllerTransmitDMA(_ itMasks: UInt32) -> HALStatus {

    if handle.read(.state) == 0x21 {
      if (((((itMasks) & (0x8)) == (0x8)) ? 1 : 0)) != 0 {
        _ = registers.read(.sr)
      }

      if (((((itMasks) & (0x200)) == (0x200)) ? 1 : 0)) != 0 {
        llClearFlagFC()
        if ((dma.getCounter(.control) &+ dma.getFIFOLevel(.control))) == 0 {
          if ((dma.getCounter(.transmit) &+ dma.getFIFOLevel(.transmit))) == 0 {
            disableTransferInterrupts(0x8)

            updateState()
            handle.write(.errorCode, value: 0x0)

            handle.write(.transmitTransferCount, value: 0)

            if useRegisteredCallbacks {
              callbacks.read(.controllerTransmitComplete)!(callbacks.context)
            } else {
              defaults.controllerTransmitComplete(callbacks.context)
            }
          } else {
            handle.write(.errorCode, value: 0x100000)

            treatError()
          }
        } else {
          handle.write(.errorCode, value: 0x0)

          if useRegisteredCallbacks {
            callbacks.read(.controllerTransmitComplete)!(callbacks.context)
          } else {
            defaults.controllerTransmitComplete(callbacks.context)
          }

          llRequestTransfer()
        }
      }
    }
    return .ok

  }
  func handleControllerReceiveDMA(_ itMasks: UInt32) -> HALStatus {

    if handle.read(.state) == 0x22 {
      if (((((itMasks) & (0x8)) == (0x8)) ? 1 : 0)) != 0 {
        _ = registers.read(.sr)
      }

      if (((((itMasks) & (0x200)) == (0x200)) ? 1 : 0)) != 0 {
        llClearFlagFC()
        if ((dma.getCounter(.control) &+ dma.getFIFOLevel(.control))) == 0 {
          if ((dma.getCounter(.receive) &+ dma.getFIFOLevel(.receive))) == 0 {
            disableTransferInterrupts(0x8)

            updateState()
            handle.write(.errorCode, value: 0x0)

            handle.write(.receiveTransferCount, value: 0)

            if useRegisteredCallbacks {
              callbacks.read(.controllerReceiveComplete)!(callbacks.context)
            } else {
              defaults.controllerReceiveComplete(callbacks.context)
            }
          } else {
            handle.write(.errorCode, value: 0x100000)

            treatError()
          }
        } else {
          handle.write(.errorCode, value: 0x0)

          if useRegisteredCallbacks {
            callbacks.read(.controllerReceiveComplete)!(callbacks.context)
          } else {
            defaults.controllerReceiveComplete(callbacks.context)
          }

          llRequestTransfer()
        }
      }
    }
    return .ok

  }
  func handleControllerMultipleTransferDMA(_ itMasks: UInt32) -> HALStatus {

    if handle.read(.state) == 0x23 {
      if (((((itMasks) & (0x8)) == (0x8)) ? 1 : 0)) != 0 {
        _ = registers.read(.sr)
      }

      if (((((itMasks) & (0x200)) == (0x200)) ? 1 : 0)) != 0 {
        llClearFlagFC()
        if ((dma.getCounter(.control) &+ dma.getFIFOLevel(.control))) == 0 {
          if ((dma.getCounter(.receive) &+ dma.getFIFOLevel(.receive))) == 0 {
            if ((dma.getCounter(.transmit) &+ dma.getFIFOLevel(.transmit))) == 0 {
              disableTransferInterrupts(0x8)

              updateState()
              handle.write(.errorCode, value: 0x0)

              handle.write(.receiveTransferCount, value: 0)

              handle.write(.transmitTransferCount, value: 0)

              if useRegisteredCallbacks {
                callbacks.read(.controllerMultipleTransferComplete)!(callbacks.context)
              } else {
                defaults.controllerMultipleTransferComplete(callbacks.context)
              }
            } else {
              handle.write(.errorCode, value: 0x100000)

              treatError()
            }
          } else {
            handle.write(.errorCode, value: 0x100000)

            treatError()
          }
        } else {
          handle.write(.errorCode, value: 0x0)

          llRequestTransfer()
        }
      }
    }
    return .ok

  }
  func handleAbort(_ itMasks: UInt32) -> HALStatus {

    if handle.read(.state) == 0x60 {
      if (((((itMasks) & (0x20)) == (0x20)) ? 1 : 0)) != 0 {
        if llIsActiveFlagDOVR() == 1 {
          llRequestRxFIFOFlush()
        }
      }

      if (((((itMasks) & (0x8)) == (0x8)) ? 1 : 0)) != 0 {
        _ = registers.read(.sr)
      }

      if (((((itMasks) & (0x200)) == (0x200)) ? 1 : 0)) != 0 {
        llClearFlagFC()

        treatError()
      }
    }
    return .ok

  }
}
