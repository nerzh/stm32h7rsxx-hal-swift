// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  public func dmaControlTransmitComplete() {

    llDisableDMAReqControl()

  }
  public func dmaDataTransmitComplete() {

    llDisableDMAReqTX()

  }
  public func dmaDataReceiveComplete() {

    llDisableDMAReqRX()

  }
  public func dmaError() {

    handle.write(.errorCode, value: handle.read(.errorCode) | (0x10000))

  }
  public func dmaAbort() {

    if dma.isPresent(.transmit) {
      dma.writeCallback(.transmit, id: .abort, value: nil)
    }

    if dma.isPresent(.receive) {
      dma.writeCallback(.receive, id: .abort, value: nil)
    }

    if dma.isPresent(.control) {
      dma.writeCallback(.control, id: .abort, value: nil)
    }
    invokeErrorCallback()

  }
}

extension I3C {
  public func dmaCallback(_ kind: I3CDMACallbackKind) {
    switch kind {
    case .controlTransmitComplete: dmaControlTransmitComplete()
    case .dataTransmitComplete: dmaDataTransmitComplete()
    case .dataReceiveComplete: dmaDataReceiveComplete()
    case .error: dmaError()
    case .abort: dmaAbort()
    }
  }
}
