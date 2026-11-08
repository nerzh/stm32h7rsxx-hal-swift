// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func dmaBurstWriteStart(
    _ BurstBaseAddress: UInt32, _ BurstRequestSrc: UInt32, _ BurstBuffer: UnsafePointer<UInt32>?,
    _ BurstLength: UInt32
  ) -> HALStatus {

    var status: HALStatus = .ok
    var BlockDataLength: UInt32 = 0
    var data_width: UInt32
    var dmaChannel: TIMDMAChannel? = nil

    switch BurstRequestSrc
    {
    case 0x100:
      do {
        dmaChannel = dma.isPresent(.update) ? .update : nil
        break
      }
    case 0x200:
      do {
        dmaChannel = dma.isPresent(.captureCompare1) ? .captureCompare1 : nil
        break
      }
    case 0x400:
      do {
        dmaChannel = dma.isPresent(.captureCompare2) ? .captureCompare2 : nil
        break
      }
    case 0x800:
      do {
        dmaChannel = dma.isPresent(.captureCompare3) ? .captureCompare3 : nil
        break
      }
    case 0x1000:
      do {
        dmaChannel = dma.isPresent(.captureCompare4) ? .captureCompare4 : nil
        break
      }
    case 0x2000:
      do {
        dmaChannel = dma.isPresent(.commutation) ? .commutation : nil
        break
      }
    case 0x4000:
      do {
        dmaChannel = dma.isPresent(.trigger) ? .trigger : nil
        break
      }
    default:
      status = .error
      break
    }
    if dmaChannel != nil {
      if ((dma.read(dmaChannel!, word: .mode) & 0x80) == 0x80)
        && (dma.read(dmaChannel!, word: .queueAddress) != 0)
        && (dmaHead(dmaChannel!) != 0)
      {
        data_width = dma.readMemory32(dmaChannel!, at: dmaHead(dmaChannel!) &+ (0 &* 4)) & 0x3
      } else {
        data_width = dma.readSourceDataWidth(dmaChannel!)
      }
      switch data_width
      {
      case 0x0:
        do {
          BlockDataLength = (BurstLength >> 0x8) &+ 1
          break
        }
      case 0x1:
        do {
          BlockDataLength = ((BurstLength >> 0x8) &+ 1) &* 2
          break
        }
      case 0x2:
        do {
          BlockDataLength = ((BurstLength >> 0x8) &+ 1) &* 4
          break
        }
      default:
        status = .error
        break
      }
      if status == .ok {
        status = dmaBurstMultiWriteStart(
          BurstBaseAddress, BurstRequestSrc, BurstBuffer, BurstLength, BlockDataLength)
      }
    }
    return status

  }
  public func dmaBurstMultiWriteStart(
    _ BurstBaseAddress: UInt32, _ BurstRequestSrc: UInt32, _ BurstBuffer: UnsafePointer<UInt32>?,
    _ BurstLength: UInt32, _ DataLength: UInt32
  ) -> HALStatus {

    var status: HALStatus = .ok
    var tmpDBSS: UInt32 = 0

    if handle.read(.dmaBurstState) == 0x2 {
      return .busy
    } else if handle.read(.dmaBurstState) == 0x1 {
      if (BurstBuffer == nil) && (BurstLength > 0) {
        return .error
      } else {
        handle.write(.dmaBurstState, value: 0x2)
      }
    } else {
    }
    switch BurstRequestSrc
    {
    case 0x100:
      do {
        dma.writeCallback(
          .update, id: .transferComplete, value: dma.callback(.periodElapsedComplete))
        dma.writeCallback(
          .update, id: .halfTransfer, value: dma.callback(.periodElapsedHalfComplete))

        dma.writeCallback(.update, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .update, UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)),
          registers.address(of: .dmar), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = 0x10000
        break
      }
    case 0x200:
      do {
        dma.writeCallback(
          .captureCompare1, id: .transferComplete, value: dma.callback(.delayPulseComplete))
        dma.writeCallback(
          .captureCompare1, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare1, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare1, UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)),
          registers.address(of: .dmar), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = 0x20000
        break
      }
    case 0x400:
      do {
        dma.writeCallback(
          .captureCompare2, id: .transferComplete, value: dma.callback(.delayPulseComplete))
        dma.writeCallback(
          .captureCompare2, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare2, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare2, UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)),
          registers.address(of: .dmar), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = (0x20000 | 0x10000)
        break
      }
    case 0x800:
      do {
        dma.writeCallback(
          .captureCompare3, id: .transferComplete, value: dma.callback(.delayPulseComplete))
        dma.writeCallback(
          .captureCompare3, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare3, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare3, UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)),
          registers.address(of: .dmar), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = 0x40000
        break
      }
    case 0x1000:
      do {
        dma.writeCallback(
          .captureCompare4, id: .transferComplete, value: dma.callback(.delayPulseComplete))
        dma.writeCallback(
          .captureCompare4, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare4, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare4, UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)),
          registers.address(of: .dmar), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = (0x40000 | 0x10000)
        break
      }
    case 0x2000:
      do {
        dma.writeCallback(
          .commutation, id: .transferComplete, value: dma.callback(.commutationComplete))
        dma.writeCallback(
          .commutation, id: .halfTransfer, value: dma.callback(.commutationHalfComplete))

        dma.writeCallback(.commutation, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .commutation, UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)),
          registers.address(of: .dmar), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = (0x40000 | 0x20000)
        break
      }
    case 0x4000:
      do {
        dma.writeCallback(.trigger, id: .transferComplete, value: dma.callback(.triggerComplete))
        dma.writeCallback(.trigger, id: .halfTransfer, value: dma.callback(.triggerHalfComplete))

        dma.writeCallback(.trigger, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .trigger, UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)),
          registers.address(of: .dmar), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = (0x40000 | 0x20000 | 0x10000)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      registers.write(.dcr, value: (BurstBaseAddress | BurstLength | tmpDBSS))
      enableDMARequests(BurstRequestSrc)
    }

    return status

  }
  public func dmaBurstWriteStop(_ BurstRequestSrc: UInt32) -> HALStatus {

    var status: HALStatus = .ok

    switch BurstRequestSrc
    {
    case 0x100:
      do {
        _ = dma.abortInterrupt(.update)
        break
      }
    case 0x200:
      do {
        _ = dma.abortInterrupt(.captureCompare1)
        break
      }
    case 0x400:
      do {
        _ = dma.abortInterrupt(.captureCompare2)
        break
      }
    case 0x800:
      do {
        _ = dma.abortInterrupt(.captureCompare3)
        break
      }
    case 0x1000:
      do {
        _ = dma.abortInterrupt(.captureCompare4)
        break
      }
    case 0x2000:
      do {
        _ = dma.abortInterrupt(.commutation)
        break
      }
    case 0x4000:
      do {
        _ = dma.abortInterrupt(.trigger)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      disableDMARequests(BurstRequestSrc)

      handle.write(.dmaBurstState, value: 0x1)
    }

    return status

  }
  public func dmaBurstReadStart(
    _ BurstBaseAddress: UInt32, _ BurstRequestSrc: UInt32,
    _ BurstBuffer: UnsafeMutablePointer<UInt32>?, _ BurstLength: UInt32
  ) -> HALStatus {

    var status: HALStatus = .ok
    var BlockDataLength: UInt32 = 0
    var data_width: UInt32
    var dmaChannel: TIMDMAChannel? = nil

    switch BurstRequestSrc
    {
    case 0x100:
      do {
        dmaChannel = dma.isPresent(.update) ? .update : nil
        break
      }
    case 0x200:
      do {
        dmaChannel = dma.isPresent(.captureCompare1) ? .captureCompare1 : nil
        break
      }
    case 0x400:
      do {
        dmaChannel = dma.isPresent(.captureCompare2) ? .captureCompare2 : nil
        break
      }
    case 0x800:
      do {
        dmaChannel = dma.isPresent(.captureCompare3) ? .captureCompare3 : nil
        break
      }
    case 0x1000:
      do {
        dmaChannel = dma.isPresent(.captureCompare4) ? .captureCompare4 : nil
        break
      }
    case 0x2000:
      do {
        dmaChannel = dma.isPresent(.commutation) ? .commutation : nil
        break
      }
    case 0x4000:
      do {
        dmaChannel = dma.isPresent(.trigger) ? .trigger : nil
        break
      }
    default:
      status = .error
      break
    }
    if dmaChannel != nil {
      if ((dma.read(dmaChannel!, word: .mode) & 0x80) == 0x80)
        && (dma.read(dmaChannel!, word: .queueAddress) != 0)
        && (dmaHead(dmaChannel!) != 0)
      {
        data_width = dma.readMemory32(dmaChannel!, at: dmaHead(dmaChannel!) &+ (0 &* 4)) & 0x3
      } else {
        data_width = dma.readSourceDataWidth(dmaChannel!)
      }
      switch data_width
      {
      case 0x0:
        do {
          BlockDataLength = ((BurstLength) >> 0x8) &+ 1
          break
        }
      case 0x1:
        do {
          BlockDataLength = ((BurstLength >> 0x8) &+ 1) &* 2
          break
        }
      case 0x2:
        do {
          BlockDataLength = ((BurstLength >> 0x8) &+ 1) &* 4
          break
        }
      default:
        status = .error
        break
      }
      if status == .ok {
        status = dmaBurstMultiReadStart(
          BurstBaseAddress, BurstRequestSrc, BurstBuffer, BurstLength, BlockDataLength)
      }
    }
    return status

  }
  public func dmaBurstMultiReadStart(
    _ BurstBaseAddress: UInt32, _ BurstRequestSrc: UInt32,
    _ BurstBuffer: UnsafeMutablePointer<UInt32>?, _ BurstLength: UInt32, _ DataLength: UInt32
  ) -> HALStatus {

    var status: HALStatus = .ok
    var tmpDBSS: UInt32 = 0

    if handle.read(.dmaBurstState) == 0x2 {
      return .busy
    } else if handle.read(.dmaBurstState) == 0x1 {
      if (BurstBuffer == nil) && (BurstLength > 0) {
        return .error
      } else {
        handle.write(.dmaBurstState, value: 0x2)
      }
    } else {
    }
    switch BurstRequestSrc
    {
    case 0x100:
      do {
        dma.writeCallback(
          .update, id: .transferComplete, value: dma.callback(.periodElapsedComplete))
        dma.writeCallback(
          .update, id: .halfTransfer, value: dma.callback(.periodElapsedHalfComplete))

        dma.writeCallback(.update, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .update, registers.address(of: .dmar),
          UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = 0x10000
        break
      }
    case 0x200:
      do {
        dma.writeCallback(
          .captureCompare1, id: .transferComplete, value: dma.callback(.captureComplete))
        dma.writeCallback(
          .captureCompare1, id: .halfTransfer, value: dma.callback(.captureHalfComplete))

        dma.writeCallback(.captureCompare1, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare1, registers.address(of: .dmar),
          UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = 0x20000
        break
      }
    case 0x400:
      do {
        dma.writeCallback(
          .captureCompare2, id: .transferComplete, value: dma.callback(.captureComplete))
        dma.writeCallback(
          .captureCompare2, id: .halfTransfer, value: dma.callback(.captureHalfComplete))

        dma.writeCallback(.captureCompare2, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare2, registers.address(of: .dmar),
          UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = (0x20000 | 0x10000)
        break
      }
    case 0x800:
      do {
        dma.writeCallback(
          .captureCompare3, id: .transferComplete, value: dma.callback(.captureComplete))
        dma.writeCallback(
          .captureCompare3, id: .halfTransfer, value: dma.callback(.captureHalfComplete))

        dma.writeCallback(.captureCompare3, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare3, registers.address(of: .dmar),
          UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = 0x40000
        break
      }
    case 0x1000:
      do {
        dma.writeCallback(
          .captureCompare4, id: .transferComplete, value: dma.callback(.captureComplete))
        dma.writeCallback(
          .captureCompare4, id: .halfTransfer, value: dma.callback(.captureHalfComplete))

        dma.writeCallback(.captureCompare4, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare4, registers.address(of: .dmar),
          UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = (0x40000 | 0x10000)
        break
      }
    case 0x2000:
      do {
        dma.writeCallback(
          .commutation, id: .transferComplete, value: dma.callback(.commutationComplete))
        dma.writeCallback(
          .commutation, id: .halfTransfer, value: dma.callback(.commutationHalfComplete))

        dma.writeCallback(.commutation, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .commutation, registers.address(of: .dmar),
          UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = (0x40000 | 0x20000)
        break
      }
    case 0x4000:
      do {
        dma.writeCallback(.trigger, id: .transferComplete, value: dma.callback(.triggerComplete))
        dma.writeCallback(.trigger, id: .halfTransfer, value: dma.callback(.triggerHalfComplete))

        dma.writeCallback(.trigger, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .trigger, registers.address(of: .dmar),
          UInt32(truncatingIfNeeded: UInt(bitPattern: BurstBuffer)), DataLength) != .ok
        {
          return .error
        }
        tmpDBSS = (0x40000 | 0x20000 | 0x10000)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      registers.write(.dcr, value: (BurstBaseAddress | BurstLength | tmpDBSS))

      enableDMARequests(BurstRequestSrc)
    }

    return status

  }
  public func dmaBurstReadStop(_ BurstRequestSrc: UInt32) -> HALStatus {

    var status: HALStatus = .ok

    switch BurstRequestSrc
    {
    case 0x100:
      do {
        _ = dma.abortInterrupt(.update)
        break
      }
    case 0x200:
      do {
        _ = dma.abortInterrupt(.captureCompare1)
        break
      }
    case 0x400:
      do {
        _ = dma.abortInterrupt(.captureCompare2)
        break
      }
    case 0x800:
      do {
        _ = dma.abortInterrupt(.captureCompare3)
        break
      }
    case 0x1000:
      do {
        _ = dma.abortInterrupt(.captureCompare4)
        break
      }
    case 0x2000:
      do {
        _ = dma.abortInterrupt(.commutation)
        break
      }
    case 0x4000:
      do {
        _ = dma.abortInterrupt(.trigger)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      disableDMARequests(BurstRequestSrc)

      handle.write(.dmaBurstState, value: 0x1)
    }

    return status

  }
}
