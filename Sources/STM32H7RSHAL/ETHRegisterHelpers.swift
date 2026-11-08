// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ETH {
  func modify(_ register: ETHRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
  func addError(_ bits: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | bits) }
  func invoke(_ id: ETHCallbackID) {
    (useRegisteredCallbacks ? callbacks.read(id)! : defaults.callback(id))(callbacks.context)
  }
  public func getState() -> UInt32 { handle.read(.state) }
  public func getError() -> UInt32 { handle.read(.errorCode) }
  public func getDMAError() -> UInt32 { handle.read(.dmaErrorCode) }
  public func getMACError() -> UInt32 { handle.read(.macErrorCode) }
  public func getMACWakeUpSource() -> UInt32 { handle.read(.macWakeUpEvent) }
  public func getMACLPIEvent() -> UInt32 { handle.read(.macLPIEvent) }
  public func getTransmitBuffersNumber() -> UInt32 { handle.read(.transmitBuffersInUse) }
  public func resetHandleState() {
    handle.write(.state, value: 0x0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }
  public func enableDMAInterrupts(_ mask: UInt32) { modify(.dmacier, set: mask) }
  public func disableDMAInterrupts(_ mask: UInt32) { modify(.dmacier, clear: mask) }
  public func getDMAInterruptSource(_ mask: UInt32) -> Bool {
    registers.read(.dmacier) & mask == mask
  }
  public func getDMAInterrupt(_ mask: UInt32) -> Bool { registers.read(.dmacsr) & mask == mask }
  public func clearDMAInterrupt(_ mask: UInt32) { registers.write(.dmacsr, value: mask) }
  public func getDMAFlag(_ mask: UInt32) -> Bool { registers.read(.dmacsr) & mask == mask }
  public func clearDMAFlag(_ mask: UInt32) { registers.write(.dmacsr, value: mask) }
  public func enableMACInterrupts(_ mask: UInt32) { modify(.macier, set: mask) }
  public func disableMACInterrupts(_ mask: UInt32) { modify(.macier, clear: mask) }
  public func getMACInterrupt(_ mask: UInt32) -> Bool { registers.read(.macisr) & mask == mask }
  public func getPTPControl(_ mask: UInt32) -> Bool { registers.read(.mactscr) & mask == mask }
  public func setPTPControl(_ mask: UInt32) { modify(.mactscr, set: mask) }
  func incrementTransmitDescriptor(_ index: UInt32, by offset: UInt32) -> UInt32 {
    var result = index &+ offset
    if result >= transmitDescriptorCount { result &-= transmitDescriptorCount }
    return result
  }
  func incrementReceiveDescriptor(_ index: UInt32, by offset: UInt32) -> UInt32 {
    var result = index &+ offset
    if result >= receiveDescriptorCount { result &-= receiveDescriptorCount }
    return result
  }
}
