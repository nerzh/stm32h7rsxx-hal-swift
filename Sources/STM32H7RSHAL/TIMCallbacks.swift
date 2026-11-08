// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func registerCallback(_ CallbackID: UInt32, _ pCallback: TIMCallback?) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok
    if pCallback == nil {
      return .error
    }
    if handle.read(.state) == 0x1 {
      switch CallbackID
      {
      case 0x0:
        callbacks.write(.baseMspInitialize, value: pCallback)
        break
      case 0x1:
        callbacks.write(.baseMspDeinitialize, value: pCallback)
        break
      case 0x2:
        callbacks.write(.inputCaptureMspInitialize, value: pCallback)
        break
      case 0x3:
        callbacks.write(.inputCaptureMspDeinitialize, value: pCallback)
        break
      case 0x4:
        callbacks.write(.outputCompareMspInitialize, value: pCallback)
        break
      case 0x5:
        callbacks.write(.outputCompareMspDeinitialize, value: pCallback)
        break
      case 0x6:
        callbacks.write(.pWMMspInitialize, value: pCallback)
        break
      case 0x7:
        callbacks.write(.pWMMspDeinitialize, value: pCallback)
        break
      case 0x8:
        callbacks.write(.onePulseMspInitialize, value: pCallback)
        break
      case 0x9:
        callbacks.write(.onePulseMspDeinitialize, value: pCallback)
        break
      case 0xa:
        callbacks.write(.encoderMspInitialize, value: pCallback)
        break
      case 0xb:
        callbacks.write(.encoderMspDeinitialize, value: pCallback)
        break
      case 0xc:
        callbacks.write(.hallSensorMspInitialize, value: pCallback)
        break
      case 0xd:
        callbacks.write(.hallSensorMspDeinitialize, value: pCallback)
        break
      case 0xe:
        callbacks.write(.periodElapsed, value: pCallback)
        break
      case 0xf:
        callbacks.write(.periodElapsedHalfComplete, value: pCallback)
        break
      case 0x10:
        callbacks.write(.trigger, value: pCallback)
        break
      case 0x11:
        callbacks.write(.triggerHalfComplete, value: pCallback)
        break
      case 0x12:
        callbacks.write(.inputCaptureCapture, value: pCallback)
        break
      case 0x13:
        callbacks.write(.inputCaptureCaptureHalfComplete, value: pCallback)
        break
      case 0x14:
        callbacks.write(.outputCompareDelayElapsed, value: pCallback)
        break
      case 0x15:
        callbacks.write(.pWMPulseFinished, value: pCallback)
        break
      case 0x16:
        callbacks.write(.pWMPulseFinishedHalfComplete, value: pCallback)
        break
      case 0x17:
        callbacks.write(.error, value: pCallback)
        break
      case 0x18:
        callbacks.write(.commutation, value: pCallback)
        break
      case 0x19:
        callbacks.write(.commutationHalfComplete, value: pCallback)
        break
      case 0x1a:
        callbacks.write(.breakEvent, value: pCallback)
        break
      case 0x1b:
        callbacks.write(.break2, value: pCallback)
        break
      case 0x1c:
        callbacks.write(.encoderIndex, value: pCallback)
        break
      case 0x1d:
        callbacks.write(.directionChange, value: pCallback)
        break
      case 0x1e:
        callbacks.write(.indexError, value: pCallback)
        break
      case 0x1f:
        callbacks.write(.transitionError, value: pCallback)
        break
      default:
        status = .error
        break
      }
    } else if handle.read(.state) == 0x0 {
      switch CallbackID
      {
      case 0x0:
        callbacks.write(.baseMspInitialize, value: pCallback)
        break
      case 0x1:
        callbacks.write(.baseMspDeinitialize, value: pCallback)
        break
      case 0x2:
        callbacks.write(.inputCaptureMspInitialize, value: pCallback)
        break
      case 0x3:
        callbacks.write(.inputCaptureMspDeinitialize, value: pCallback)
        break
      case 0x4:
        callbacks.write(.outputCompareMspInitialize, value: pCallback)
        break
      case 0x5:
        callbacks.write(.outputCompareMspDeinitialize, value: pCallback)
        break
      case 0x6:
        callbacks.write(.pWMMspInitialize, value: pCallback)
        break
      case 0x7:
        callbacks.write(.pWMMspDeinitialize, value: pCallback)
        break
      case 0x8:
        callbacks.write(.onePulseMspInitialize, value: pCallback)
        break
      case 0x9:
        callbacks.write(.onePulseMspDeinitialize, value: pCallback)
        break
      case 0xa:
        callbacks.write(.encoderMspInitialize, value: pCallback)
        break
      case 0xb:
        callbacks.write(.encoderMspDeinitialize, value: pCallback)
        break
      case 0xc:
        callbacks.write(.hallSensorMspInitialize, value: pCallback)
        break
      case 0xd:
        callbacks.write(.hallSensorMspDeinitialize, value: pCallback)
        break
      default:
        status = .error
        break
      }
    } else {
      status = .error
    }
    return status

  }
  public func unregisterCallback(_ CallbackID: UInt32) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok
    if handle.read(.state) == 0x1 {
      switch CallbackID
      {
      case 0x0:
        callbacks.write(.baseMspInitialize, value: defaults.baseMspInitialize)
        break
      case 0x1:
        callbacks.write(.baseMspDeinitialize, value: defaults.baseMspDeinitialize)
        break
      case 0x2:
        callbacks.write(.inputCaptureMspInitialize, value: defaults.inputCaptureMspInitialize)
        break
      case 0x3:
        callbacks.write(.inputCaptureMspDeinitialize, value: defaults.inputCaptureMspDeinitialize)
        break
      case 0x4:
        callbacks.write(.outputCompareMspInitialize, value: defaults.outputCompareMspInitialize)
        break
      case 0x5:
        callbacks.write(.outputCompareMspDeinitialize, value: defaults.outputCompareMspDeinitialize)
        break
      case 0x6:
        callbacks.write(.pWMMspInitialize, value: defaults.pWMMspInitialize)
        break
      case 0x7:
        callbacks.write(.pWMMspDeinitialize, value: defaults.pWMMspDeinitialize)
        break
      case 0x8:
        callbacks.write(.onePulseMspInitialize, value: defaults.onePulseMspInitialize)
        break
      case 0x9:
        callbacks.write(.onePulseMspDeinitialize, value: defaults.onePulseMspDeinitialize)
        break
      case 0xa:
        callbacks.write(.encoderMspInitialize, value: defaults.encoderMspInitialize)
        break
      case 0xb:
        callbacks.write(.encoderMspDeinitialize, value: defaults.encoderMspDeinitialize)
        break
      case 0xc:
        callbacks.write(.hallSensorMspInitialize, value: defaults.hallSensorMspInitialize)
        break
      case 0xd:
        callbacks.write(.hallSensorMspDeinitialize, value: defaults.hallSensorMspDeinitialize)
        break
      case 0xe:
        callbacks.write(.periodElapsed, value: defaults.periodElapsed)
        break
      case 0xf:
        callbacks.write(.periodElapsedHalfComplete, value: defaults.periodElapsedHalfComplete)
        break
      case 0x10:
        callbacks.write(.trigger, value: defaults.trigger)
        break
      case 0x11:
        callbacks.write(.triggerHalfComplete, value: defaults.triggerHalfComplete)
        break
      case 0x12:
        callbacks.write(.inputCaptureCapture, value: defaults.inputCaptureCapture)
        break
      case 0x13:
        callbacks.write(
          .inputCaptureCaptureHalfComplete, value: defaults.inputCaptureCaptureHalfComplete)
        break
      case 0x14:
        callbacks.write(.outputCompareDelayElapsed, value: defaults.outputCompareDelayElapsed)
        break
      case 0x15:
        callbacks.write(.pWMPulseFinished, value: defaults.pWMPulseFinished)
        break
      case 0x16:
        callbacks.write(.pWMPulseFinishedHalfComplete, value: defaults.pWMPulseFinishedHalfComplete)
        break
      case 0x17:
        callbacks.write(.error, value: defaults.error)
        break
      case 0x18:
        callbacks.write(.commutation, value: defaults.commutation)
        break
      case 0x19:
        callbacks.write(.commutationHalfComplete, value: defaults.commutationHalfComplete)
        break
      case 0x1a:
        callbacks.write(.breakEvent, value: defaults.breakEvent)
        break
      case 0x1b:
        callbacks.write(.break2, value: defaults.break2)
        break
      case 0x1c:
        callbacks.write(.encoderIndex, value: defaults.encoderIndex)
        break
      case 0x1d:
        callbacks.write(.directionChange, value: defaults.directionChange)
        break
      case 0x1e:
        callbacks.write(.indexError, value: defaults.indexError)
        break
      case 0x1f:
        callbacks.write(.transitionError, value: defaults.transitionError)
        break
      default:
        status = .error
        break
      }
    } else if handle.read(.state) == 0x0 {
      switch CallbackID
      {
      case 0x0:
        callbacks.write(.baseMspInitialize, value: defaults.baseMspInitialize)
        break
      case 0x1:
        callbacks.write(.baseMspDeinitialize, value: defaults.baseMspDeinitialize)
        break
      case 0x2:
        callbacks.write(.inputCaptureMspInitialize, value: defaults.inputCaptureMspInitialize)
        break
      case 0x3:
        callbacks.write(.inputCaptureMspDeinitialize, value: defaults.inputCaptureMspDeinitialize)
        break
      case 0x4:
        callbacks.write(.outputCompareMspInitialize, value: defaults.outputCompareMspInitialize)
        break
      case 0x5:
        callbacks.write(.outputCompareMspDeinitialize, value: defaults.outputCompareMspDeinitialize)
        break
      case 0x6:
        callbacks.write(.pWMMspInitialize, value: defaults.pWMMspInitialize)
        break
      case 0x7:
        callbacks.write(.pWMMspDeinitialize, value: defaults.pWMMspDeinitialize)
        break
      case 0x8:
        callbacks.write(.onePulseMspInitialize, value: defaults.onePulseMspInitialize)
        break
      case 0x9:
        callbacks.write(.onePulseMspDeinitialize, value: defaults.onePulseMspDeinitialize)
        break
      case 0xa:
        callbacks.write(.encoderMspInitialize, value: defaults.encoderMspInitialize)
        break
      case 0xb:
        callbacks.write(.encoderMspDeinitialize, value: defaults.encoderMspDeinitialize)
        break
      case 0xc:
        callbacks.write(.hallSensorMspInitialize, value: defaults.hallSensorMspInitialize)
        break
      case 0xd:
        callbacks.write(.hallSensorMspDeinitialize, value: defaults.hallSensorMspDeinitialize)
        break
      default:
        status = .error
        break
      }
    } else {
      status = .error
    }
    return status

  }
  func resetCallback() {

    callbacks.write(.periodElapsed, value: defaults.periodElapsed)
    callbacks.write(.periodElapsedHalfComplete, value: defaults.periodElapsedHalfComplete)
    callbacks.write(.trigger, value: defaults.trigger)
    callbacks.write(.triggerHalfComplete, value: defaults.triggerHalfComplete)
    callbacks.write(.inputCaptureCapture, value: defaults.inputCaptureCapture)
    callbacks.write(
      .inputCaptureCaptureHalfComplete, value: defaults.inputCaptureCaptureHalfComplete)
    callbacks.write(.outputCompareDelayElapsed, value: defaults.outputCompareDelayElapsed)
    callbacks.write(.pWMPulseFinished, value: defaults.pWMPulseFinished)
    callbacks.write(.pWMPulseFinishedHalfComplete, value: defaults.pWMPulseFinishedHalfComplete)
    callbacks.write(.error, value: defaults.error)
    callbacks.write(.commutation, value: defaults.commutation)
    callbacks.write(.commutationHalfComplete, value: defaults.commutationHalfComplete)
    callbacks.write(.breakEvent, value: defaults.breakEvent)
    callbacks.write(.break2, value: defaults.break2)
    callbacks.write(.encoderIndex, value: defaults.encoderIndex)
    callbacks.write(.directionChange, value: defaults.directionChange)
    callbacks.write(.indexError, value: defaults.indexError)
    callbacks.write(.transitionError, value: defaults.transitionError)

  }
}
