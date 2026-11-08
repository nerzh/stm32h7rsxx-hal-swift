// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func configCommutEvent(_ InputTrigger: UInt32, _ CommutationSource: UInt32) -> HALStatus {

    guard lock() else { return .busy }
    if CommutationSource == 0x4 {
      registers.write(.smcr, value: registers.read(.smcr) & (~0x300070))
      registers.write(.smcr, value: registers.read(.smcr) | (InputTrigger))
    }

    registers.write(.cr2, value: registers.read(.cr2) | (0x1))
    registers.write(.cr2, value: registers.read(.cr2) & (~0x4))
    registers.write(.cr2, value: registers.read(.cr2) | (CommutationSource))

    disableInterrupts(0x20)

    disableDMARequests(0x2000)
    unlock()
    return .ok

  }
  public func configCommutEventInterrupt(_ InputTrigger: UInt32, _ CommutationSource: UInt32)
    -> HALStatus
  {

    guard lock() else { return .busy }
    if CommutationSource == 0x4 {
      registers.write(.smcr, value: registers.read(.smcr) & (~0x300070))
      registers.write(.smcr, value: registers.read(.smcr) | (InputTrigger))
    }

    registers.write(.cr2, value: registers.read(.cr2) | (0x1))
    registers.write(.cr2, value: registers.read(.cr2) & (~0x4))
    registers.write(.cr2, value: registers.read(.cr2) | (CommutationSource))

    disableDMARequests(0x2000)

    enableInterrupts(0x20)
    unlock()
    return .ok

  }
  public func configCommutEventDMA(_ InputTrigger: UInt32, _ CommutationSource: UInt32) -> HALStatus
  {

    guard lock() else { return .busy }
    if CommutationSource == 0x4 {
      registers.write(.smcr, value: registers.read(.smcr) & (~0x300070))
      registers.write(.smcr, value: registers.read(.smcr) | (InputTrigger))
    }

    registers.write(.cr2, value: registers.read(.cr2) | (0x1))
    registers.write(.cr2, value: registers.read(.cr2) & (~0x4))
    registers.write(.cr2, value: registers.read(.cr2) | (CommutationSource))

    dma.writeCallback(
      .commutation, id: .transferComplete, value: dma.callback(.commutationComplete))
    dma.writeCallback(
      .commutation, id: .halfTransfer, value: dma.callback(.commutationHalfComplete))
    dma.writeCallback(.commutation, id: .error, value: dma.callback(.error))

    disableInterrupts(0x20)

    enableDMARequests(0x2000)
    unlock()
    return .ok

  }
  public func masterConfigSynchronization(_ sMasterConfig: TIMMasterConfiguration) -> HALStatus {

    var tmpcr2: UInt32
    var tmpsmcr: UInt32

    guard lock() else { return .busy }

    handle.write(.state, value: 0x2)

    tmpcr2 = registers.read(.cr2)

    tmpsmcr = registers.read(.smcr)

    if (((registers.instance)) == TIMInstance.tim1) {

      tmpcr2 &= ~0xf00000
      tmpcr2 |= sMasterConfig.masterOutputTrigger2
    }

    tmpcr2 &= ~0x2000070
    tmpcr2 |= sMasterConfig.masterOutputTrigger

    registers.write(.cr2, value: tmpcr2)
    if ((((registers.instance)) == TIMInstance.tim1) || (((registers.instance)) == TIMInstance.tim2)
      || (((registers.instance)) == TIMInstance.tim3)
      || (((registers.instance)) == TIMInstance.tim4)
      || (((registers.instance)) == TIMInstance.tim5)
      || (((registers.instance)) == TIMInstance.tim9)
      || (((registers.instance)) == TIMInstance.tim12)
      || (((registers.instance)) == TIMInstance.tim15))
    {
      tmpsmcr &= ~0x80
      tmpsmcr |= sMasterConfig.masterSlaveMode

      registers.write(.smcr, value: tmpsmcr)
    }

    handle.write(.state, value: 0x1)
    unlock()
    return .ok

  }
  public func configBreakDeadTime(_ sBreakDeadTimeConfig: TIMBreakDeadTimeConfiguration)
    -> HALStatus
  {

    var tmpbdtr: UInt32 = 0

    guard lock() else { return .busy }

    tmpbdtr = (tmpbdtr & ~(0xff)) | (sBreakDeadTimeConfig.deadTime)
    tmpbdtr = (tmpbdtr & ~(0x300)) | (sBreakDeadTimeConfig.lockLevel)
    tmpbdtr = (tmpbdtr & ~(0x400)) | (sBreakDeadTimeConfig.offStateIdleMode)
    tmpbdtr = (tmpbdtr & ~(0x800)) | (sBreakDeadTimeConfig.offStateRunMode)
    tmpbdtr = (tmpbdtr & ~(0x1000)) | (sBreakDeadTimeConfig.breakState)
    tmpbdtr = (tmpbdtr & ~(0x2000)) | (sBreakDeadTimeConfig.breakPolarity)
    tmpbdtr = (tmpbdtr & ~(0x4000)) | (sBreakDeadTimeConfig.automaticOutput)
    tmpbdtr = (tmpbdtr & ~(0xf0000)) | ((sBreakDeadTimeConfig.breakFilter << 0x10))
    tmpbdtr = (tmpbdtr & ~(0x1000_0000)) | (sBreakDeadTimeConfig.breakAFMode)
    if (((registers.instance)) == TIMInstance.tim1) {

      tmpbdtr = (tmpbdtr & ~(0xf00000)) | ((sBreakDeadTimeConfig.break2Filter << 0x14))
      tmpbdtr = (tmpbdtr & ~(0x1000000)) | (sBreakDeadTimeConfig.break2State)
      tmpbdtr = (tmpbdtr & ~(0x2000000)) | (sBreakDeadTimeConfig.break2Polarity)
      tmpbdtr = (tmpbdtr & ~(0x2000_0000)) | (sBreakDeadTimeConfig.break2AFMode)
    }

    registers.write(.bdtr, value: tmpbdtr)
    unlock()
    return .ok

  }
  public func configBreakInput(
    _ BreakInput: UInt32, _ sBreakInputConfig: TIMBreakInputConfiguration
  ) -> HALStatus {

    var status: HALStatus = .ok
    var tmporx: UInt32
    var bkin_enable_mask: UInt32
    var bkin_polarity_mask: UInt32
    var bkin_enable_bitpos: UInt32
    var bkin_polarity_bitpos: UInt32

    guard lock() else { return .busy }
    switch sBreakInputConfig.source
    {
    case 0x1:
      do {
        bkin_enable_mask = 0x1
        bkin_enable_bitpos = 0x0
        bkin_polarity_mask = 0x200
        bkin_polarity_bitpos = 0x9
        break
      }
    default:
      do {
        bkin_enable_mask = 0
        bkin_polarity_mask = 0
        bkin_enable_bitpos = 0
        bkin_polarity_bitpos = 0
        break
      }
    }
    switch BreakInput
    {
    case 0x1:
      do {
        tmporx = registers.read(.af1)

        tmporx &= ~bkin_enable_mask
        tmporx |= (sBreakInputConfig.enable << bkin_enable_bitpos) & bkin_enable_mask

        tmporx &= ~bkin_polarity_mask
        tmporx |= (sBreakInputConfig.polarity << bkin_polarity_bitpos) & bkin_polarity_mask

        registers.write(.af1, value: tmporx)
        break
      }
    case 0x2:
      do {
        tmporx = registers.read(.af2)

        tmporx &= ~bkin_enable_mask
        tmporx |= (sBreakInputConfig.enable << bkin_enable_bitpos) & bkin_enable_mask

        tmporx &= ~bkin_polarity_mask
        tmporx |= (sBreakInputConfig.polarity << bkin_polarity_bitpos) & bkin_polarity_mask

        registers.write(.af2, value: tmporx)
        break
      }
    default:
      status = .error
      break
    }
    unlock()
    return status

  }
  public func remapConfig(_ Remap: UInt32) -> HALStatus {

    guard lock() else { return .busy }
    registers.write(.af1, value: (registers.read(.af1) & ~(0x3c000)) | (Remap))
    unlock()
    return .ok

  }
  public func tiSelection(_ TISelection: UInt32, _ Channel: UInt32) -> HALStatus {

    var status: HALStatus = .ok

    guard lock() else { return .busy }
    switch Channel
    {
    case 0x0:
      registers.write(.tisel, value: (registers.read(.tisel) & ~(0xf)) | (TISelection))
      break
    case 0x4:
      registers.write(.tisel, value: (registers.read(.tisel) & ~(0xf00)) | (TISelection))
      break
    default:
      status = .error
      break
    }
    unlock()
    return status

  }
  public func groupChannel5(_ Channels: UInt32) -> HALStatus {

    guard lock() else { return .busy }
    handle.write(.state, value: 0x2)

    registers.write(
      .ccr5, value: registers.read(.ccr5) & (~(0x8000_0000 | 0x4000_0000 | 0x2000_0000)))

    registers.write(.ccr5, value: registers.read(.ccr5) | (Channels))

    handle.write(.state, value: 0x1)
    unlock()
    return .ok

  }
  public func disarmBreakInput(_ BreakInput: UInt32) -> HALStatus {

    var status: HALStatus = .ok
    var tmpbdtr: UInt32

    switch BreakInput
    {
    case 0x1:
      do {
        tmpbdtr = registers.read(.bdtr)
        if ((tmpbdtr & (0x1000_0000)) == 0x1000_0000) && ((tmpbdtr & (0x8000)) == 0) {
          registers.write(.bdtr, value: registers.read(.bdtr) | (0x4000000))
        }
        break
      }
    case 0x2:
      do {
        tmpbdtr = registers.read(.bdtr)
        if ((tmpbdtr & (0x2000_0000)) == 0x2000_0000) && ((tmpbdtr & (0x8000)) == 0) {
          registers.write(.bdtr, value: registers.read(.bdtr) | (0x8000000))
        }
        break
      }
    default:
      status = .error
      break
    }
    return status

  }
  public func reArmBreakInput(_ BreakInput: UInt32, getTick: () -> UInt32) -> HALStatus {

    var status: HALStatus = .ok
    var tickstart: UInt32

    switch BreakInput
    {
    case 0x1:
      do {
        if (registers.read(.bdtr) & (0x1000_0000)) == 0x1000_0000 {

          tickstart = getTick()
          while (registers.read(.bdtr) & (0x4000000)) != 0 {
            if (getTick() &- tickstart) > 0x5 {
              if (registers.read(.bdtr) & (0x4000000)) != 0 {
                return .timeout
              }
            }
          }
        }
        break
      }
    case 0x2:
      do {
        if (registers.read(.bdtr) & (0x2000_0000)) == 0x2000_0000 {

          tickstart = getTick()
          while (registers.read(.bdtr) & (0x8000000)) != 0 {
            if (getTick() &- tickstart) > 0x5 {
              if (registers.read(.bdtr) & (0x8000000)) != 0 {
                return .timeout
              }
            }
          }
        }
        break
      }
    default:
      status = .error
      break
    }
    return status

  }
  public func ditheringEnable() -> HALStatus {

    registers.write(.cr1, value: registers.read(.cr1) | (0x1000))
    return .ok

  }
  public func ditheringDisable() -> HALStatus {

    registers.write(.cr1, value: registers.read(.cr1) & (~(0x1000)))
    return .ok

  }
  public func outputCompareConfigPulseOnCompare(_ PulseWidthPrescaler: UInt32, _ PulseWidth: UInt32)
    -> HALStatus
  {

    var tmpecr: UInt32

    guard lock() else { return .busy }

    handle.write(.state, value: 0x2)

    tmpecr = registers.read(.ecr)
    tmpecr &= ~(0x7000000 | 0xff0000)
    tmpecr |= PulseWidthPrescaler << 0x18
    tmpecr |= PulseWidth << 0x10
    registers.write(.ecr, value: tmpecr)

    handle.write(.state, value: 0x1)

    unlock()
    return .ok

  }
  public func configSlaveModePreload(_ Source: UInt32) -> HALStatus {

    registers.write(.smcr, value: (registers.read(.smcr) & ~(0x2000000)) | (Source))
    return .ok

  }
  public func enableSlaveModePreload() -> HALStatus {

    registers.write(.smcr, value: registers.read(.smcr) | (0x1000000))
    return .ok

  }
  public func disableSlaveModePreload() -> HALStatus {

    registers.write(.smcr, value: registers.read(.smcr) & (~(0x1000000)))
    return .ok

  }
  public func enableDeadTimePreload() -> HALStatus {

    registers.write(.dtr2, value: registers.read(.dtr2) | (0x20000))
    return .ok

  }
  public func disableDeadTimePreload() -> HALStatus {

    registers.write(.dtr2, value: registers.read(.dtr2) & (~(0x20000)))
    return .ok

  }
  public func configDeadTime(_ Deadtime: UInt32) -> HALStatus {

    registers.write(.bdtr, value: (registers.read(.bdtr) & ~(0xff)) | (Deadtime))
    return .ok

  }
  public func configAsymmetricalDeadTime(_ FallingDeadtime: UInt32) -> HALStatus {

    registers.write(.dtr2, value: (registers.read(.dtr2) & ~(0xff)) | (FallingDeadtime))
    return .ok

  }
  public func enableAsymmetricalDeadTime() -> HALStatus {

    registers.write(.dtr2, value: registers.read(.dtr2) | (0x10000))
    return .ok

  }
  public func disableAsymmetricalDeadTime() -> HALStatus {

    registers.write(.dtr2, value: registers.read(.dtr2) & (~(0x10000)))
    return .ok

  }
  public func configEncoderIndex(_ sEncoderIndexConfig: TIMEncoderIndexConfiguration) -> HALStatus {

    guard lock() else { return .busy }

    etrSetConfig(
      sEncoderIndexConfig.prescaler, sEncoderIndexConfig.polarity, sEncoderIndexConfig.filter)

    registers.write(
      .ecr,
      value: (registers.read(.ecr) & ~(0x6 | 0x18 | 0x20 | 0xc0))
        | ((sEncoderIndexConfig.direction | (sEncoderIndexConfig.blanking)
          | ((sEncoderIndexConfig.firstIndexEnable == 1) ? (0x1 << 0x5) : 0)
          | sEncoderIndexConfig.position | 0x1)))
    unlock()
    return .ok

  }
  public func enableEncoderIndex() -> HALStatus {

    registers.write(.ecr, value: registers.read(.ecr) | (0x1))
    return .ok

  }
  public func disableEncoderIndex() -> HALStatus {

    registers.write(.ecr, value: registers.read(.ecr) & (~(0x1)))
    return .ok

  }
  public func enableEncoderFirstIndex() -> HALStatus {

    registers.write(.ecr, value: registers.read(.ecr) | (0x20))
    return .ok

  }
  public func disableEncoderFirstIndex() -> HALStatus {

    registers.write(.ecr, value: registers.read(.ecr) & (~(0x20)))
    return .ok

  }
}
