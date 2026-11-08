// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func interruptHandler() {

    var itsource: UInt32 = registers.read(.dier)
    var itflag: UInt32 = registers.read(.sr)

    if (itflag & (0x2)) == (0x2) {
      if (itsource & (0x2)) == (0x2) {
        do {
          clearFlag(0x2)
          handle.write(.channel, value: 0x1)

          if (registers.read(.ccmr1) & 0x3) != 0x00 {
            if useRegisteredCallbacks {
              callbacks.read(.inputCaptureCapture)!(callbacks.context)
            } else {
              defaults.inputCaptureCapture(callbacks.context)
            }
          } else {
            if useRegisteredCallbacks {
              callbacks.read(.outputCompareDelayElapsed)!(callbacks.context)
              callbacks.read(.pWMPulseFinished)!(callbacks.context)
            } else {
              defaults.outputCompareDelayElapsed(callbacks.context)
              defaults.pWMPulseFinished(callbacks.context)
            }
          }
          handle.write(.channel, value: 0x0)
        }
      }
    }
    if (itflag & (0x4)) == (0x4) {
      if (itsource & (0x4)) == (0x4) {
        clearFlag(0x4)
        handle.write(.channel, value: 0x2)
        if (registers.read(.ccmr1) & 0x300) != 0x00 {
          if useRegisteredCallbacks {
            callbacks.read(.inputCaptureCapture)!(callbacks.context)
          } else {
            defaults.inputCaptureCapture(callbacks.context)
          }
        } else {
          if useRegisteredCallbacks {
            callbacks.read(.outputCompareDelayElapsed)!(callbacks.context)
            callbacks.read(.pWMPulseFinished)!(callbacks.context)
          } else {
            defaults.outputCompareDelayElapsed(callbacks.context)
            defaults.pWMPulseFinished(callbacks.context)
          }
        }
        handle.write(.channel, value: 0x0)
      }
    }
    if (itflag & (0x8)) == (0x8) {
      if (itsource & (0x8)) == (0x8) {
        clearFlag(0x8)
        handle.write(.channel, value: 0x4)
        if (registers.read(.ccmr2) & 0x3) != 0x00 {
          if useRegisteredCallbacks {
            callbacks.read(.inputCaptureCapture)!(callbacks.context)
          } else {
            defaults.inputCaptureCapture(callbacks.context)
          }
        } else {
          if useRegisteredCallbacks {
            callbacks.read(.outputCompareDelayElapsed)!(callbacks.context)
            callbacks.read(.pWMPulseFinished)!(callbacks.context)
          } else {
            defaults.outputCompareDelayElapsed(callbacks.context)
            defaults.pWMPulseFinished(callbacks.context)
          }
        }
        handle.write(.channel, value: 0x0)
      }
    }
    if (itflag & (0x10)) == (0x10) {
      if (itsource & (0x10)) == (0x10) {
        clearFlag(0x10)
        handle.write(.channel, value: 0x8)
        if (registers.read(.ccmr2) & 0x300) != 0x00 {
          if useRegisteredCallbacks {
            callbacks.read(.inputCaptureCapture)!(callbacks.context)
          } else {
            defaults.inputCaptureCapture(callbacks.context)
          }
        } else {
          if useRegisteredCallbacks {
            callbacks.read(.outputCompareDelayElapsed)!(callbacks.context)
            callbacks.read(.pWMPulseFinished)!(callbacks.context)
          } else {
            defaults.outputCompareDelayElapsed(callbacks.context)
            defaults.pWMPulseFinished(callbacks.context)
          }
        }
        handle.write(.channel, value: 0x0)
      }
    }
    if (itflag & (0x1)) == (0x1) {
      if (itsource & (0x1)) == (0x1) {
        clearFlag(0x1)
        if useRegisteredCallbacks {
          callbacks.read(.periodElapsed)!(callbacks.context)
        } else {
          defaults.periodElapsed(callbacks.context)
        }
      }
    }
    if ((itflag & (0x80)) == (0x80)) || ((itflag & (0x2000)) == (0x2000)) {
      if (itsource & (0x80)) == (0x80) {
        clearFlag(0x80 | 0x2000)
        if useRegisteredCallbacks {
          callbacks.read(.breakEvent)!(callbacks.context)
        } else {
          defaults.breakEvent(callbacks.context)
        }
      }
    }
    if (itflag & (0x100)) == (0x100) {
      if (itsource & (0x80)) == (0x80) {
        clearFlag(0x100)
        if useRegisteredCallbacks {
          callbacks.read(.break2)!(callbacks.context)
        } else {
          defaults.break2(callbacks.context)
        }
      }
    }
    if (itflag & (0x40)) == (0x40) {
      if (itsource & (0x40)) == (0x40) {
        clearFlag(0x40)
        if useRegisteredCallbacks {
          callbacks.read(.trigger)!(callbacks.context)
        } else {
          defaults.trigger(callbacks.context)
        }
      }
    }
    if (itflag & (0x20)) == (0x20) {
      if (itsource & (0x20)) == (0x20) {
        clearFlag(0x20)
        if useRegisteredCallbacks {
          callbacks.read(.commutation)!(callbacks.context)
        } else {
          defaults.commutation(callbacks.context)
        }
      }
    }
    if (itflag & (0x100000)) == (0x100000) {
      if (itsource & (0x100000)) == (0x100000) {
        clearFlag(0x100000)
        if useRegisteredCallbacks {
          callbacks.read(.encoderIndex)!(callbacks.context)
        } else {
          defaults.encoderIndex(callbacks.context)
        }
      }
    }
    if (itflag & (0x200000)) == (0x200000) {
      if (itsource & (0x200000)) == (0x200000) {
        clearFlag(0x200000)
        if useRegisteredCallbacks {
          callbacks.read(.directionChange)!(callbacks.context)
        } else {
          defaults.directionChange(callbacks.context)
        }
      }
    }
    if (itflag & (0x400000)) == (0x400000) {
      if (itsource & (0x400000)) == (0x400000) {
        clearFlag(0x400000)
        if useRegisteredCallbacks {
          callbacks.read(.indexError)!(callbacks.context)
        } else {
          defaults.indexError(callbacks.context)
        }
      }
    }
    if (itflag & (0x800000)) == (0x800000) {
      if (itsource & (0x800000)) == (0x800000) {
        clearFlag(0x800000)
        if useRegisteredCallbacks {
          callbacks.read(.transitionError)!(callbacks.context)
        } else {
          defaults.transitionError(callbacks.context)
        }
      }
    }

  }
}
