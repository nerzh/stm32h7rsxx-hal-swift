// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  func invokeTransferISR(_ flags: UInt32) -> HALStatus {
    switch handle.read(.transferISR) {
    case I3CTransferISR.targetEvent.rawValue: return handleTargetEvent(flags)
    case I3CTransferISR.controllerEvent.rawValue: return handleControllerEvent(flags)
    case I3CTransferISR.targetHotJoin.rawValue: return handleTargetHotJoin(flags)
    case I3CTransferISR.targetControlRole.rawValue: return handleTargetControlRole(flags)
    case I3CTransferISR.targetIBI.rawValue: return handleTargetIBI(flags)
    case I3CTransferISR.targetTransmit.rawValue: return handleTargetTransmit(flags)
    case I3CTransferISR.targetReceive.rawValue: return handleTargetReceive(flags)
    case I3CTransferISR.targetTransmitDMA.rawValue: return handleTargetTransmitDMA(flags)
    case I3CTransferISR.targetReceiveDMA.rawValue: return handleTargetReceiveDMA(flags)
    case I3CTransferISR.controllerTransmit.rawValue: return handleControllerTransmit(flags)
    case I3CTransferISR.controllerReceive.rawValue: return handleControllerReceive(flags)
    case I3CTransferISR.controllerMultipleTransfer.rawValue:
      return handleControllerMultipleTransfer(flags)
    case I3CTransferISR.controllerTransmitListen.rawValue:
      return handleControllerTransmitListen(flags)
    case I3CTransferISR.controllerReceiveListen.rawValue:
      return handleControllerReceiveListen(flags)
    case I3CTransferISR.controllerMultipleTransferListen.rawValue:
      return handleControllerMultipleTransferListen(flags)
    case I3CTransferISR.controllerDynamicAddress.rawValue:
      return handleControllerDynamicAddress(flags)
    case I3CTransferISR.controllerTransmitDMA.rawValue: return handleControllerTransmitDMA(flags)
    case I3CTransferISR.controllerReceiveDMA.rawValue: return handleControllerReceiveDMA(flags)
    case I3CTransferISR.controllerMultipleTransferDMA.rawValue:
      return handleControllerMultipleTransferDMA(flags)
    case I3CTransferISR.abort.rawValue: return handleAbort(flags)
    default: preconditionFailure("Invalid I3C ISR selector")
    }
  }
  func invokeTransmitTreatment() {
    switch handle.read(.transmitTreatment) {
    case 1: transmitBytes()
    case 2: transmitWords()
    default: preconditionFailure("Invalid I3C treatment selector")
    }
  }
  func invokeReceiveTreatment() {
    switch handle.read(.receiveTreatment) {
    case 1: receiveBytes()
    case 2: receiveWords()
    default: preconditionFailure("Invalid I3C treatment selector")
    }
  }
  public func getFlag(_ flag: UInt32) -> UInt32 { (registers.read(.evr) & flag) == flag ? 1 : 0 }
  public func resetHandleState() {
    handle.write(.state, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }
}
