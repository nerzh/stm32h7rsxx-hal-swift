// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ETH {
  public func transmit(
    _ configuration: UnsafePointer<ETHTransmitPacketConfiguration>?, timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {
    guard let configuration else {
      addError(0x1)
      return .error
    }
    guard handle.read(.state) == 0x40 else { return .error }
    if prepareTransmitDescriptors(configuration, interruptMode: 0) != 0x0 {
      addError(0x2)
      return .error
    }
    platform.dataSynchronizationBarrier()
    let descriptor = handle.descriptorAddress(
      .transmit, index: handle.read(.currentTransmitDescriptor))
    handle.write(
      .currentTransmitDescriptor,
      value: incrementTransmitDescriptor(handle.read(.currentTransmitDescriptor), by: 1))
    registers.write(
      .dmactdtpr,
      value: handle.descriptorAddress(.transmit, index: handle.read(.currentTransmitDescriptor)))
    let start = getTick()
    while descriptorRead(descriptor, 3) & 0x8000_0000 != 0 {
      if registers.read(.dmacsr) & 0x1000 != 0 {
        addError(0x8)
        handle.write(.dmaErrorCode, value: registers.read(.dmacsr))
        return .error
      }
      if timeout != UInt32.max {
        if getTick() &- start > timeout || timeout == 0 {
          addError(0x4)
          descriptorWrite(descriptor, 3, 0x2000_0000 | 0x1000_0000)
          return .error
        }
      }
    }
    return .ok
  }
  public func transmitInterrupt(_ configuration: UnsafePointer<ETHTransmitPacketConfiguration>?)
    -> HALStatus
  {
    guard let configuration else {
      addError(0x1)
      return .error
    }
    guard handle.read(.state) == 0x40 else { return .error }
    handle.writePointer(.currentTransmitPacket, value: configuration.pointee.applicationData)
    if prepareTransmitDescriptors(configuration, interruptMode: 1) != 0x0 {
      addError(0x2)
      return .error
    }
    platform.dataSynchronizationBarrier()
    handle.write(
      .currentTransmitDescriptor,
      value: incrementTransmitDescriptor(handle.read(.currentTransmitDescriptor), by: 1))
    registers.write(
      .dmactdtpr,
      value: handle.descriptorAddress(.transmit, index: handle.read(.currentTransmitDescriptor)))
    return .ok
  }
  func prepareTransmitDescriptors(
    _ configuration: UnsafePointer<ETHTransmitPacketConfiguration>, interruptMode: UInt32
  ) -> UInt32 {
    var index = handle.read(.currentTransmitDescriptor)
    let first = handle.read(.currentTransmitDescriptor)
    var descriptorCount: UInt32 = 0
    var descriptor = handle.descriptorAddress(.transmit, index: index)
    var buffer = configuration.pointee.buffer
    var bufferDescriptorCount: UInt32 = 0
    if descriptorRead(descriptor, 3) & 0x8000_0000 == 0x8000_0000
      || handle.transmitPacket(index: index) != nil
    {
      return 0x2
    }
    if configuration.pointee.attributes & 0x4 != 0 {
      descriptorModify(descriptor, 3, clear: 0xffff, set: configuration.pointee.vlanTag)
      descriptorModify(descriptor, 3, set: 0x10000)
      modify(.macvir, set: 0x100000)
      if configuration.pointee.attributes & 0x8 != 0 {
        descriptorModify(
          descriptor, 2, clear: 0xffff_0000, set: configuration.pointee.innerVLANTag << 16)
        descriptorModify(descriptor, 3, set: 0x20000)
        descriptorModify(descriptor, 3, clear: 0xc0000, set: configuration.pointee.innerVLANControl)
        modify(.macivir, set: 0x100000)
        modify(.macvtr, set: 0x4000000)
      }
    }
    if configuration.pointee.attributes & 0x10 != 0 {
      descriptorModify(descriptor, 2, clear: 0x3fff, set: configuration.pointee.maximumSegmentSize)
      descriptorModify(descriptor, 3, set: 0x4000000)
    }
    if configuration.pointee.attributes & 0x4 != 0 || configuration.pointee.attributes & 0x10 != 0 {
      descriptorModify(descriptor, 3, set: 0x4000_0000)
      platform.dataMemoryBarrier()
      descriptorModify(descriptor, 3, set: 0x8000_0000)
      index = incrementTransmitDescriptor(index, by: 1)
      descriptor = handle.descriptorAddress(.transmit, index: index)
      descriptorCount &+= 1
      if descriptorRead(descriptor, 3) & 0x8000_0000 == 0x8000_0000 {
        descriptor = handle.descriptorAddress(.transmit, index: first)
        platform.dataMemoryBarrier()
        descriptorModify(descriptor, 3, clear: 0x8000_0000)
        return 0x2
      }
    }
    descriptorCount &+= 1
    descriptorWrite(
      descriptor, 0, UInt32(truncatingIfNeeded: UInt(bitPattern: buffer!.pointee.buffer)))
    descriptorModify(descriptor, 2, clear: 0x3fff, set: buffer!.pointee.length)
    if buffer!.pointee.next != nil {
      buffer = buffer!.pointee.next
      descriptorWrite(
        descriptor, 1, UInt32(truncatingIfNeeded: UInt(bitPattern: buffer!.pointee.buffer)))
      descriptorModify(descriptor, 2, clear: 0x3fff_0000, set: buffer!.pointee.length << 16)
    } else {
      descriptorWrite(descriptor, 1, 0)
      descriptorModify(descriptor, 2, clear: 0x3fff_0000)
    }
    if configuration.pointee.attributes & 0x10 != 0 {
      descriptorModify(
        descriptor, 3, clear: 0x780000, set: configuration.pointee.tcpHeaderLength << 19)
      descriptorModify(descriptor, 3, clear: 0x3ffff, set: configuration.pointee.payloadLength)
      descriptorModify(descriptor, 3, set: 0x40000)
    } else {
      descriptorModify(descriptor, 3, clear: 0x7fff, set: configuration.pointee.length)
      if configuration.pointee.attributes & 0x1 != 0 {
        descriptorModify(descriptor, 3, clear: 0x30000, set: configuration.pointee.checksumControl)
      }
      if configuration.pointee.attributes & 0x20 != 0 {
        descriptorModify(descriptor, 3, clear: 0xc000000, set: configuration.pointee.crcPadControl)
      }
    }
    if configuration.pointee.attributes & 0x4 != 0 {
      descriptorModify(descriptor, 2, clear: 0xc000, set: configuration.pointee.vlanControl)
    }
    descriptorModify(descriptor, 3, set: 0x2000_0000)
    descriptorModify(descriptor, 3, clear: 0x4000_0000)
    platform.dataMemoryBarrier()
    descriptorModify(descriptor, 3, set: 0x8000_0000)
    if configuration.pointee.attributes & 0x2 != 0 {
      descriptorModify(
        descriptor, 3, clear: 0x3800000, set: configuration.pointee.sourceAddressControl)
    }
    while buffer!.pointee.next != nil {
      descriptorModify(descriptor, 3, clear: 0x1000_0000)
      index = incrementTransmitDescriptor(index, by: 1)
      descriptor = handle.descriptorAddress(.transmit, index: index)
      descriptorModify(descriptor, 3, clear: 0x2000_0000)
      if descriptorRead(descriptor, 3) & 0x8000_0000 == 0x8000_0000
        || handle.transmitPacket(index: index) != nil
      {
        index = first
        descriptor = handle.descriptorAddress(.transmit, index: index)
        var i: UInt32 = 0
        while i < descriptorCount {
          platform.dataMemoryBarrier()
          descriptorModify(descriptor, 3, clear: 0x8000_0000)
          index = incrementTransmitDescriptor(index, by: 1)
          descriptor = handle.descriptorAddress(.transmit, index: index)
          i &+= 1
        }
        return 0x2
      }
      descriptorCount &+= 1
      buffer = buffer!.pointee.next
      descriptorWrite(
        descriptor, 0, UInt32(truncatingIfNeeded: UInt(bitPattern: buffer!.pointee.buffer)))
      descriptorModify(descriptor, 2, clear: 0x3fff, set: buffer!.pointee.length)
      if buffer!.pointee.next != nil {
        buffer = buffer!.pointee.next
        descriptorWrite(
          descriptor, 1, UInt32(truncatingIfNeeded: UInt(bitPattern: buffer!.pointee.buffer)))
        descriptorModify(descriptor, 2, clear: 0x3fff_0000, set: buffer!.pointee.length << 16)
      } else {
        descriptorWrite(descriptor, 1, 0)
        descriptorModify(descriptor, 2, clear: 0x3fff_0000)
      }
      if configuration.pointee.attributes & 0x10 != 0 {
        descriptorModify(descriptor, 3, clear: 0x3ffff, set: configuration.pointee.payloadLength)
        descriptorModify(descriptor, 3, set: 0x40000)
      } else {
        descriptorModify(descriptor, 3, clear: 0x7fff, set: configuration.pointee.length)
        if configuration.pointee.attributes & 0x1 != 0 {
          descriptorModify(
            descriptor, 3, clear: 0x30000, set: configuration.pointee.checksumControl)
        }
      }
      bufferDescriptorCount &+= 1
      platform.dataMemoryBarrier()
      descriptorModify(descriptor, 3, set: 0x8000_0000)
      descriptorModify(descriptor, 3, clear: 0x4000_0000)
    }
    if interruptMode != 0 {
      descriptorModify(descriptor, 2, set: 0x8000_0000)
    } else {
      descriptorModify(descriptor, 2, clear: 0x8000_0000)
    }
    descriptorModify(descriptor, 3, set: 0x1000_0000)
    handle.writeTransmitPacket(
      index: index,
      value: handle.readPointer(.currentTransmitPacket)?.assumingMemoryBound(to: UInt32.self))
    handle.write(.currentTransmitDescriptor, value: index)
    let mask = platform.readInterruptMask()
    platform.writeInterruptMask(1)
    handle.write(
      .transmitBuffersInUse, value: handle.read(.transmitBuffersInUse) &+ bufferDescriptorCount &+ 1
    )
    platform.writeInterruptMask(mask)
    return 0x0
  }
}
