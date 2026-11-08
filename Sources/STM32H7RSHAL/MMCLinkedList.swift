// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MMC/MMCEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MMC {
  public func buildDMANode(_ node: UInt32, configuration: SDMMCDMANodeConfiguration?) -> HALStatus {
    if linkedList.buildNode(node, configuration: configuration) != 0 {
      return .error
    } else {
      return .ok
    }
  }
  public func insertDMANode(_ list: UInt32, previousNode: UInt32, node: UInt32) -> HALStatus {
    if linkedList.insertNode(list, previousNode: previousNode, node: node) != 0 {
      return .error
    } else {
      return .ok
    }
  }
  public func removeDMANode(_ list: UInt32, node: UInt32) -> HALStatus {
    if linkedList.removeNode(list, node: node) != 0 { return .error } else { return .ok }
  }
  public func lockDMANode(_ node: UInt32) -> HALStatus {
    if linkedList.lockNode(node) != 0 { return .error } else { return .ok }
  }
  public func unlockDMANode(_ node: UInt32) -> HALStatus {
    if linkedList.unlockNode(node) != 0 { return .error } else { return .ok }
  }
  public func enableDMACircularMode(_ list: UInt32) -> HALStatus {
    if linkedList.enableCircularMode(list) != 0 { return .error } else { return .ok }
  }
  public func disableDMACircularMode(_ list: UInt32) -> HALStatus {
    if linkedList.disableCircularMode(list) != 0 { return .error } else { return .ok }
  }
  public func getFlag(_ mask: UInt32) -> Bool { sdmmc.getFlag(mask) }
  public func getInterrupt(_ mask: UInt32) -> Bool { sdmmc.getInterrupt(mask) }
  public func clearFlag(_ mask: UInt32) { sdmmc.clearFlag(mask) }
  public func clearInterrupt(_ mask: UInt32) { sdmmc.clearInterrupt(mask) }
  public func enableInterrupts(_ mask: UInt32) { sdmmc.enableInterrupts(mask) }
  public func disableInterrupts(_ mask: UInt32) { sdmmc.disableInterrupts(mask) }
  public func resetHandleState() {
    handle.write(.state, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }
}
