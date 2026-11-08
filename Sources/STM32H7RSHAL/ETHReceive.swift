// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ETH {
  func updateReceiveDescriptors() {
    var index = handle.read(.receiveBuildDescriptorIndex)
    var descriptor = handle.descriptorAddress(.receive, index: index)
    var count = handle.read(.receiveBuildDescriptorCount)
    var buffer: UnsafeMutablePointer<UInt8>?
    var allocated: UInt8 = 1
    while count > 0 && allocated != 0 {
      if descriptorRead(descriptor, 4) == 0 {
        (useRegisteredCallbacks ? callbacks.readReceiveAllocate()! : defaults.receiveAllocate)(
          &buffer)
        if buffer == nil {
          allocated = 0
        } else {
          descriptorWrite(descriptor, 4, UInt32(truncatingIfNeeded: UInt(bitPattern: buffer)))
          descriptorWrite(descriptor, 0, UInt32(truncatingIfNeeded: UInt(bitPattern: buffer)))
        }
      } else {
        descriptorWrite(descriptor, 0, descriptorRead(descriptor, 4))
      }
      if allocated != 0 {
        if handle.read(.receiveInterruptMode) != 0 {
          descriptorWrite(descriptor, 3, 0x8000_0000 | 0x1000000 | 0x4000_0000)
        } else {
          descriptorWrite(descriptor, 3, 0x8000_0000 | 0x1000000)
        }
        index = incrementReceiveDescriptor(index, by: 1)
        descriptor = handle.descriptorAddress(.receive, index: index)
        count &-= 1
      }
    }
    if handle.read(.receiveBuildDescriptorCount) != count {
      let tail = (receiveDescriptorCount &+ index &- 1) % receiveDescriptorCount
      platform.dataMemoryBarrier()
      registers.write(.dmacrdtpr, value: descriptorBase(.receive) &+ tail &* 24)
      handle.write(.receiveBuildDescriptorIndex, value: index)
      handle.write(.receiveBuildDescriptorCount, value: count)
    }
  }
  public func readData(_ applicationBuffer: UnsafeMutablePointer<UnsafeMutableRawPointer?>?)
    -> HALStatus
  {
    guard let applicationBuffer else {
      addError(0x1)
      return .error
    }
    guard handle.read(.state) == 0x40 else { return .error }
    var index = handle.read(.receiveDescriptorIndex)
    var descriptor = handle.descriptorAddress(.receive, index: index)
    let maximum = receiveDescriptorCount &- handle.read(.receiveBuildDescriptorCount)
    var count: UInt32 = 0
    var ready: UInt8 = 0
    handle.write(.receiveTimestampHigh, value: UInt32.max)
    handle.write(.receiveTimestampLow, value: UInt32.max)
    while descriptorRead(descriptor, 3) & 0x8000_0000 == 0 && count < maximum && ready == 0 {
      if descriptorRead(descriptor, 3) & 0x2000_0000 != 0
        || handle.readPointer(.receiveStart) != nil
      {
        if descriptorRead(descriptor, 3) & 0x2000_0000 != 0 {
          handle.write(.receiveDescriptorCount, value: 0)
          handle.write(.receiveDataLength, value: 0)
        }
        let length = (descriptorRead(descriptor, 3) & 0x7fff) &- handle.read(.receiveDataLength)
        if descriptorRead(descriptor, 3) & 0x1000_0000 != 0 {
          handle.write(.lastReceiveDescriptor, value: descriptorRead(descriptor, 3))
          if descriptorRead(descriptor, 1) & 0x4000 != 0 {
            let nextIndex = incrementReceiveDescriptor(index, by: 1)
            let nextDescriptor = handle.descriptorAddress(.receive, index: nextIndex)
            if descriptorRead(nextDescriptor, 3) & 0x8000_0000 == 0 {
              if descriptorRead(nextDescriptor, 3) & 0x4000_0000 != 0 {
                handle.write(.receiveTimestampHigh, value: descriptorRead(nextDescriptor, 1))
                handle.write(.receiveTimestampLow, value: descriptorRead(nextDescriptor, 0))
                index = incrementReceiveDescriptor(index, by: 1)
                count &+= 1
              }
            } else {
              break
            }
          }
          ready = 1
        }
        (useRegisteredCallbacks ? callbacks.readReceiveLink()! : defaults.receiveLink)(
          handle.pointerStorage(.receiveStart), handle.pointerStorage(.receiveEnd),
          UnsafeMutablePointer<UInt8>(bitPattern: UInt(descriptorRead(descriptor, 4))),
          UInt16(truncatingIfNeeded: length))
        handle.write(.receiveDescriptorCount, value: handle.read(.receiveDescriptorCount) &+ 1)
        handle.write(.receiveDataLength, value: handle.read(.receiveDataLength) &+ length)
        descriptorWrite(descriptor, 4, 0)
      }
      index = incrementReceiveDescriptor(index, by: 1)
      descriptor = handle.descriptorAddress(.receive, index: index)
      count &+= 1
    }
    handle.write(
      .receiveBuildDescriptorCount, value: handle.read(.receiveBuildDescriptorCount) &+ count)
    if handle.read(.receiveBuildDescriptorCount) != 0 { updateReceiveDescriptors() }
    handle.write(.receiveDescriptorIndex, value: index)
    if ready == 1 {
      applicationBuffer.pointee = handle.readPointer(.receiveStart)
      handle.writePointer(.receiveStart, value: nil)
      return .ok
    }
    return .error
  }
  public func getReceiveDataErrorCode(_ error: UnsafeMutablePointer<UInt32>) -> HALStatus {
    error.pointee = handle.read(.lastReceiveDescriptor) & 0x1f80000
    return .ok
  }
  public func releaseTransmitPacket() -> HALStatus {
    var count = handle.read(.transmitBuffersInUse)
    var index = handle.read(.transmitReleaseIndex)
    var status: UInt8 = 1
    while count != 0 && status != 0 {
      var inUse: UInt8 = 1
      count &-= 1
      if handle.transmitPacket(index: index) == nil {
        index = incrementTransmitDescriptor(index, by: 1)
        inUse = 0
      }
      if inUse != 0 {
        let descriptor = descriptorBase(.transmit) &+ index &* 24
        if descriptorRead(descriptor, 3) & 0x8000_0000 == 0 {
          if usePTP {
            descriptorModify(descriptor, 2, clear: 0x4000_0000)
            if descriptorRead(descriptor, 3) & 0x1000_0000 != 0
              && descriptorRead(descriptor, 3) & 0x20000 != 0
            {
              handle.write(.transmitTimestampLow, value: descriptorRead(descriptor, 0))
              handle.write(.transmitTimestampHigh, value: descriptorRead(descriptor, 1))
            } else {
              handle.write(.transmitTimestampLow, value: UInt32.max)
              handle.write(.transmitTimestampHigh, value: UInt32.max)
            }
          }
          if usePTP && handle.read(.transmitTimestampHigh) != UInt32.max
            && handle.read(.transmitTimestampLow) != UInt32.max
          {
            (useRegisteredCallbacks ? callbacks.readTransmitPTP()! : defaults.transmitPTP)(
              handle.transmitPacket(index: index), handle.transmitTimestampWords())
          }
          (useRegisteredCallbacks ? callbacks.readTransmitFree()! : defaults.transmitFree)(
            handle.transmitPacket(index: index))
          handle.writeTransmitPacket(index: index, value: nil)
          index = incrementTransmitDescriptor(index, by: 1)
          handle.write(.transmitBuffersInUse, value: count)
          handle.write(.transmitReleaseIndex, value: index)
        } else {
          status = 0
        }
      }
    }
    return .ok
  }
}
