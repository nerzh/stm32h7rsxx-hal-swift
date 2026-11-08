// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  func dmaStartInterrupt(
    _ dmaChannel: TIMDMAChannel, _ src: UInt32, _ dst: UInt32, _ length: UInt32
  ) -> HALStatus {

    var status: HALStatus

    if (dma.read(dmaChannel, word: .mode) & 0x80) == 0x80 {
      if (dma.read(dmaChannel, word: .queueAddress) != 0) && (dmaHead(dmaChannel) != 0) {
        dma.writeMemory32(dmaChannel, at: dmaHead(dmaChannel) &+ (0x2 &* 4), value: length)
        dma.writeMemory32(dmaChannel, at: dmaHead(dmaChannel) &+ (0x3 &* 4), value: src)
        dma.writeMemory32(dmaChannel, at: dmaHead(dmaChannel) &+ (0x4 &* 4), value: dst)
        status = dma.startLinkedListInterrupt(dmaChannel)
      } else {
        status = .error
      }
    } else {
      status = dma.startInterrupt(
        dmaChannel, sourceAddress: src, destinationAddress: dst, sourceDataSize: length)
    }
    return status

  }
  func dmaError(sourceContext: UnsafeMutableRawPointer?) {

    if dma.matches(.captureCompare1, context: sourceContext) {
      handle.write(.channel, value: 0x1)
      channelSetState(0x0, 0x1)
    } else if dma.matches(.captureCompare2, context: sourceContext) {
      handle.write(.channel, value: 0x2)
      channelSetState(0x4, 0x1)
    } else if dma.matches(.captureCompare3, context: sourceContext) {
      handle.write(.channel, value: 0x4)
      channelSetState(0x8, 0x1)
    } else if dma.matches(.captureCompare4, context: sourceContext) {
      handle.write(.channel, value: 0x8)
      channelSetState(0xc, 0x1)
    } else {
      handle.write(.state, value: 0x1)
    }
    if useRegisteredCallbacks {
      callbacks.read(.error)!(callbacks.context)
    } else {
      defaults.error(callbacks.context)
    }
    handle.write(.channel, value: 0x0)

  }
  func dmaDelayPulseCplt(sourceContext: UnsafeMutableRawPointer?) {

    if dma.matches(.captureCompare1, context: sourceContext) {
      handle.write(.channel, value: 0x1)
    } else if dma.matches(.captureCompare2, context: sourceContext) {
      handle.write(.channel, value: 0x2)
    } else if dma.matches(.captureCompare3, context: sourceContext) {
      handle.write(.channel, value: 0x4)
    } else if dma.matches(.captureCompare4, context: sourceContext) {
      handle.write(.channel, value: 0x8)
    } else {
    }
    if useRegisteredCallbacks {
      callbacks.read(.pWMPulseFinished)!(callbacks.context)
    } else {
      defaults.pWMPulseFinished(callbacks.context)
    }
    handle.write(.channel, value: 0x0)

  }
  func dmaDelayPulseHalfCplt(sourceContext: UnsafeMutableRawPointer?) {

    if dma.matches(.captureCompare1, context: sourceContext) {
      handle.write(.channel, value: 0x1)
    } else if dma.matches(.captureCompare2, context: sourceContext) {
      handle.write(.channel, value: 0x2)
    } else if dma.matches(.captureCompare3, context: sourceContext) {
      handle.write(.channel, value: 0x4)
    } else if dma.matches(.captureCompare4, context: sourceContext) {
      handle.write(.channel, value: 0x8)
    } else {
    }
    if useRegisteredCallbacks {
      callbacks.read(.pWMPulseFinishedHalfComplete)!(callbacks.context)
    } else {
      defaults.pWMPulseFinishedHalfComplete(callbacks.context)
    }
    handle.write(.channel, value: 0x0)

  }
  func dmaCaptureCplt(sourceContext: UnsafeMutableRawPointer?) {

    if dma.matches(.captureCompare1, context: sourceContext) {
      handle.write(.channel, value: 0x1)
    } else if dma.matches(.captureCompare2, context: sourceContext) {
      handle.write(.channel, value: 0x2)
    } else if dma.matches(.captureCompare3, context: sourceContext) {
      handle.write(.channel, value: 0x4)
    } else if dma.matches(.captureCompare4, context: sourceContext) {
      handle.write(.channel, value: 0x8)
    } else {
    }
    if useRegisteredCallbacks {
      callbacks.read(.inputCaptureCapture)!(callbacks.context)
    } else {
      defaults.inputCaptureCapture(callbacks.context)
    }
    handle.write(.channel, value: 0x0)

  }
  func dmaCaptureHalfCplt(sourceContext: UnsafeMutableRawPointer?) {

    if dma.matches(.captureCompare1, context: sourceContext) {
      handle.write(.channel, value: 0x1)
    } else if dma.matches(.captureCompare2, context: sourceContext) {
      handle.write(.channel, value: 0x2)
    } else if dma.matches(.captureCompare3, context: sourceContext) {
      handle.write(.channel, value: 0x4)
    } else if dma.matches(.captureCompare4, context: sourceContext) {
      handle.write(.channel, value: 0x8)
    } else {
    }
    if useRegisteredCallbacks {
      callbacks.read(.inputCaptureCaptureHalfComplete)!(callbacks.context)
    } else {
      defaults.inputCaptureCaptureHalfComplete(callbacks.context)
    }
    handle.write(.channel, value: 0x0)

  }
  func dmaPeriodElapsedCplt(sourceContext: UnsafeMutableRawPointer?) {

    if useRegisteredCallbacks {
      callbacks.read(.periodElapsed)!(callbacks.context)
    } else {
      defaults.periodElapsed(callbacks.context)
    }

  }
  func dmaPeriodElapsedHalfCplt(sourceContext: UnsafeMutableRawPointer?) {

    if useRegisteredCallbacks {
      callbacks.read(.periodElapsedHalfComplete)!(callbacks.context)
    } else {
      defaults.periodElapsedHalfComplete(callbacks.context)
    }

  }
  func dmaTriggerCplt(sourceContext: UnsafeMutableRawPointer?) {

    if useRegisteredCallbacks {
      callbacks.read(.trigger)!(callbacks.context)
    } else {
      defaults.trigger(callbacks.context)
    }

  }
  func dmaTriggerHalfCplt(sourceContext: UnsafeMutableRawPointer?) {

    if useRegisteredCallbacks {
      callbacks.read(.triggerHalfComplete)!(callbacks.context)
    } else {
      defaults.triggerHalfComplete(callbacks.context)
    }

  }
  func dmaCommutationCplt(sourceContext: UnsafeMutableRawPointer?) {

    handle.write(.state, value: 0x1)
    if useRegisteredCallbacks {
      callbacks.read(.commutation)!(callbacks.context)
    } else {
      defaults.commutation(callbacks.context)
    }

  }
  func dmaCommutationHalfCplt(sourceContext: UnsafeMutableRawPointer?) {

    handle.write(.state, value: 0x1)
    if useRegisteredCallbacks {
      callbacks.read(.commutationHalfComplete)!(callbacks.context)
    } else {
      defaults.commutationHalfComplete(callbacks.context)
    }

  }
  func dmaDelayPulseNCplt(sourceContext: UnsafeMutableRawPointer?) {

    if dma.matches(.captureCompare1, context: sourceContext) {
      handle.write(.channel, value: 0x1)
    } else if dma.matches(.captureCompare2, context: sourceContext) {
      handle.write(.channel, value: 0x2)
    } else if dma.matches(.captureCompare3, context: sourceContext) {
      handle.write(.channel, value: 0x4)
    } else if dma.matches(.captureCompare4, context: sourceContext) {
      handle.write(.channel, value: 0x8)
    } else {
    }
    if useRegisteredCallbacks {
      callbacks.read(.pWMPulseFinished)!(callbacks.context)
    } else {
      defaults.pWMPulseFinished(callbacks.context)
    }
    handle.write(.channel, value: 0x0)

  }
  func dmaErrorCCxN(sourceContext: UnsafeMutableRawPointer?) {

    if dma.matches(.captureCompare1, context: sourceContext) {
      handle.write(.channel, value: 0x1)
      channelNSetState(0x0, 0x1)
    } else if dma.matches(.captureCompare2, context: sourceContext) {
      handle.write(.channel, value: 0x2)
      channelNSetState(0x4, 0x1)
    } else if dma.matches(.captureCompare3, context: sourceContext) {
      handle.write(.channel, value: 0x4)
      channelNSetState(0x8, 0x1)
    } else if dma.matches(.captureCompare4, context: sourceContext) {
      handle.write(.channel, value: 0x8)
      channelNSetState(0xc, 0x1)
    } else {
    }
    if useRegisteredCallbacks {
      callbacks.read(.error)!(callbacks.context)
    } else {
      defaults.error(callbacks.context)
    }
    handle.write(.channel, value: 0x0)

  }
  func dmaHead(_ channel: TIMDMAChannel) -> UInt32 {
    dma.readMemory32(channel, at: dma.read(channel, word: .queueAddress))
  }
  public func dmaCallback(_ kind: TIMDMACallbackKind, sourceContext: UnsafeMutableRawPointer?) {
    switch kind {
    case .error: dmaError(sourceContext: sourceContext)
    case .delayPulseComplete: dmaDelayPulseCplt(sourceContext: sourceContext)
    case .delayPulseHalfComplete: dmaDelayPulseHalfCplt(sourceContext: sourceContext)
    case .captureComplete: dmaCaptureCplt(sourceContext: sourceContext)
    case .captureHalfComplete: dmaCaptureHalfCplt(sourceContext: sourceContext)
    case .periodElapsedComplete: dmaPeriodElapsedCplt(sourceContext: sourceContext)
    case .periodElapsedHalfComplete: dmaPeriodElapsedHalfCplt(sourceContext: sourceContext)
    case .triggerComplete: dmaTriggerCplt(sourceContext: sourceContext)
    case .triggerHalfComplete: dmaTriggerHalfCplt(sourceContext: sourceContext)
    case .commutationComplete: dmaCommutationCplt(sourceContext: sourceContext)
    case .commutationHalfComplete: dmaCommutationHalfCplt(sourceContext: sourceContext)
    case .delayPulseNComplete: dmaDelayPulseNCplt(sourceContext: sourceContext)
    case .errorCCxN: dmaErrorCCxN(sourceContext: sourceContext)
    }
  }
}
