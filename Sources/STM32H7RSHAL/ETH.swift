// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ETH {
  func descriptorBase(_ ring: ETHDescriptorRing) -> UInt32 {
    UInt32(
      truncatingIfNeeded: UInt(
        bitPattern: handle.readPointer(
          ring == .transmit ? .transmitDescriptors : .receiveDescriptors)))
  }
  func descriptorRead(_ address: UInt32, _ word: UInt32) -> UInt32 {
    memory.read32(at: address &+ word &* 4)
  }
  func descriptorWrite(_ address: UInt32, _ word: UInt32, _ value: UInt32) {
    memory.write32(at: address &+ word &* 4, value: value)
  }
  func descriptorModify(_ address: UInt32, _ word: UInt32, clear: UInt32 = 0, set: UInt32 = 0) {
    descriptorWrite(address, word, (descriptorRead(address, word) & ~clear) | set)
  }
  func initializeTransmitDescriptors() {
    var i: UInt32 = 0
    while i < transmitDescriptorCount {
      let descriptor = descriptorBase(.transmit) &+ i &* 24
      descriptorWrite(descriptor, 0, 0)
      descriptorWrite(descriptor, 1, 0)
      descriptorWrite(descriptor, 2, 0)
      descriptorWrite(descriptor, 3, 0)
      handle.writeDescriptorAddress(.transmit, index: i, value: descriptor)
      i &+= 1
    }
    handle.write(.currentTransmitDescriptor, value: 0)
    registers.write(.dmactdrlr, value: transmitDescriptorCount &- 1)
    registers.write(.dmactdlar, value: descriptorBase(.transmit))
    registers.write(.dmactdtpr, value: descriptorBase(.transmit))
  }
  func initializeReceiveDescriptors() {
    var i: UInt32 = 0
    while i < receiveDescriptorCount {
      let descriptor = descriptorBase(.receive) &+ i &* 24
      descriptorWrite(descriptor, 0, 0)
      descriptorWrite(descriptor, 1, 0)
      descriptorWrite(descriptor, 2, 0)
      descriptorWrite(descriptor, 3, 0)
      descriptorWrite(descriptor, 4, 0)
      descriptorWrite(descriptor, 5, 0)
      handle.writeDescriptorAddress(.receive, index: i, value: descriptor)
      i &+= 1
    }
    handle.write(.receiveDescriptorIndex, value: 0)
    handle.write(.receiveDescriptorCount, value: 0)
    handle.write(.receiveBuildDescriptorIndex, value: 0)
    handle.write(.receiveBuildDescriptorCount, value: 0)
    handle.write(.receiveInterruptMode, value: 0)
    registers.write(.dmacrdrlr, value: receiveDescriptorCount &- 1)
    registers.write(.dmacrdlar, value: descriptorBase(.receive))
    registers.write(
      .dmacrdtpr, value: descriptorBase(.receive) &+ (receiveDescriptorCount &- 1) &* 24)
  }
  public func initialize(getTick: () -> UInt32, getHCLKFrequency: () -> UInt32) -> HALStatus {
    if handle.read(.state) == 0x0 {
      handle.write(.state, value: 0x20)
      if useRegisteredCallbacks {
        initializeCallbacksToDefault()
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }
      }
      invoke(.mspInitialize)
    }
    platform.enableSBSClock()
    if handle.read(.mediaInterface) == 0 {
      platform.configureEthernetPHY(0)
    } else {
      platform.configureEthernetPHY(0x800000)
    }
    _ = platform.readSBSPeripheralMode()
    modify(.dmamr, set: 0x1)
    let start = getTick()
    while registers.read(.dmamr) & 0x1 > 0 {
      if getTick() &- start > softwareResetTimeout {
        handle.write(.errorCode, value: 0x4)
        handle.write(.state, value: 0xe0)
        return .error
      }
    }
    setMDIOClockRange(getHCLKFrequency: getHCLKFrequency)
    registers.write(.mac1ustcr, value: (getHCLKFrequency() / macMicrosecondTick) &- 1)
    applyDefaultMACDMAConfiguration()
    modify(.dmaccr, clear: 0x1c0000, set: 0x80000)
    if handle.read(.receiveBufferLength) % 4 != 0 {
      handle.write(.errorCode, value: 0x1)
      handle.write(.state, value: 0xe0)
      return .error
    } else {
      modify(.dmacrcr, clear: 0x7ffe, set: handle.read(.receiveBufferLength) << 1)
    }
    initializeTransmitDescriptors()
    initializeReceiveDescriptors()
    let mac = handle.readPointer(.macAddress)!.assumingMemoryBound(to: UInt8.self)
    registers.write(.maca0hr, value: (UInt32(mac[5]) << 8) | UInt32(mac[4]))
    registers.write(
      .maca0lr,
      value: (UInt32(mac[3]) << 24) | (UInt32(mac[2]) << 16) | (UInt32(mac[1]) << 8)
        | UInt32(mac[0]))
    modify(.mmcrimr, set: 0x8000000 | 0x4000000 | 0x20000 | 0x40 | 0x20)
    modify(.mmctimr, set: 0x8000000 | 0x4000000 | 0x200000 | 0x8000 | 0x4000)
    handle.write(.errorCode, value: 0x0)
    handle.write(.state, value: 0x10)
    return .ok
  }
  public func start() -> HALStatus {
    guard handle.read(.state) == 0x10 else { return .error }
    handle.write(.state, value: 0x20)
    handle.write(.receiveBuildDescriptorCount, value: receiveDescriptorCount)
    updateReceiveDescriptors()
    modify(.maccr, set: 0x2)
    modify(.maccr, set: 0x1)
    modify(.mtltqomr, set: 0x1)
    modify(.dmactcr, set: 0x1)
    modify(.dmacrcr, set: 0x1)
    modify(.dmacsr, set: 0x2 | 0x100)
    handle.write(.state, value: 0x40)
    return .ok
  }
  public func startInterrupt() -> HALStatus {
    guard handle.read(.state) == 0x10 else { return .error }
    handle.write(.state, value: 0x20)
    handle.write(.receiveInterruptMode, value: 1)
    handle.write(.receiveBuildDescriptorCount, value: receiveDescriptorCount)
    updateReceiveDescriptors()
    modify(.dmactcr, set: 0x1)
    modify(.dmacrcr, set: 0x1)
    modify(.dmacsr, set: 0x2 | 0x100)
    modify(.mtltqomr, set: 0x1)
    modify(.maccr, set: 0x2)
    modify(.maccr, set: 0x1)
    enableDMAInterrupts(0x8000 | 0x40 | 0x1 | 0x1000 | 0x4000 | 0x80)
    handle.write(.state, value: 0x40)
    return .ok
  }
  public func stop() -> HALStatus {
    guard handle.read(.state) == 0x40 else { return .error }
    handle.write(.state, value: 0x20)
    modify(.dmactcr, clear: 0x1)
    modify(.dmacrcr, clear: 0x1)
    modify(.maccr, clear: 0x1)
    modify(.mtltqomr, set: 0x1)
    modify(.maccr, clear: 0x2)
    handle.write(.state, value: 0x10)
    return .ok
  }
  public func stopInterrupt() -> HALStatus {
    guard handle.read(.state) == 0x40 else { return .error }
    handle.write(.state, value: 0x20)
    disableDMAInterrupts(0x8000 | 0x40 | 0x1 | 0x1000 | 0x4000 | 0x80)
    modify(.dmactcr, clear: 0x1)
    modify(.dmacrcr, clear: 0x1)
    modify(.maccr, clear: 0x1)
    modify(.mtltqomr, set: 0x1)
    modify(.maccr, clear: 0x2)
    var i: UInt32 = 0
    while i < receiveDescriptorCount {
      descriptorModify(handle.descriptorAddress(.receive, index: i), 3, clear: 0x4000_0000)
      i &+= 1
    }
    handle.write(.receiveInterruptMode, value: 0)
    handle.write(.state, value: 0x10)
    return .ok
  }
}
