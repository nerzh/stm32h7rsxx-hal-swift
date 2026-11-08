// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func generateEvent(_ EventSource: UInt32) -> HALStatus {

    guard lock() else { return .busy }

    handle.write(.state, value: 0x2)

    registers.write(.egr, value: EventSource)

    handle.write(.state, value: 0x1)
    unlock()

    return .ok

  }
  public func configOCrefClear(_ sClearInputConfig: TIMClearInputConfiguration, _ Channel: UInt32)
    -> HALStatus
  {

    var status: HALStatus = .ok

    guard lock() else { return .busy }
    handle.write(.state, value: 0x2)
    switch sClearInputConfig.clearInputSource
    {
    case 0x0:
      do {
        registers.write(
          .smcr, value: registers.read(.smcr) & (~((0xf00 | 0x3000 | 0x4000 | 0x8000))))
        break
      }
    case 0x1:
      do {

        if sClearInputConfig.clearInputPrescaler != 0x0 {
          handle.write(.state, value: 0x1)
          unlock()
          return .error
        }
        etrSetConfig(
          sClearInputConfig.clearInputPrescaler, sClearInputConfig.clearInputPolarity,
          sClearInputConfig.clearInputFilter)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      switch Channel
      {
      case 0x0:
        do {
          if sClearInputConfig.clearInputState != (0) {
            registers.write(.ccmr1, value: registers.read(.ccmr1) | (0x80))
          } else {
            registers.write(.ccmr1, value: registers.read(.ccmr1) & (~(0x80)))
          }
          break
        }
      case 0x4:
        do {
          if sClearInputConfig.clearInputState != (0) {
            registers.write(.ccmr1, value: registers.read(.ccmr1) | (0x8000))
          } else {
            registers.write(.ccmr1, value: registers.read(.ccmr1) & (~(0x8000)))
          }
          break
        }
      case 0x8:
        do {
          if sClearInputConfig.clearInputState != (0) {
            registers.write(.ccmr2, value: registers.read(.ccmr2) | (0x80))
          } else {
            registers.write(.ccmr2, value: registers.read(.ccmr2) & (~(0x80)))
          }
          break
        }
      case 0xc:
        do {
          if sClearInputConfig.clearInputState != (0) {
            registers.write(.ccmr2, value: registers.read(.ccmr2) | (0x8000))
          } else {
            registers.write(.ccmr2, value: registers.read(.ccmr2) & (~(0x8000)))
          }
          break
        }
      case 0x10:
        do {
          if sClearInputConfig.clearInputState != (0) {
            registers.write(.ccmr3, value: registers.read(.ccmr3) | (0x80))
          } else {
            registers.write(.ccmr3, value: registers.read(.ccmr3) & (~(0x80)))
          }
          break
        }
      case 0x14:
        do {
          if sClearInputConfig.clearInputState != (0) {
            registers.write(.ccmr3, value: registers.read(.ccmr3) | (0x8000))
          } else {
            registers.write(.ccmr3, value: registers.read(.ccmr3) & (~(0x8000)))
          }
          break
        }
      default:
        break
      }
    }
    handle.write(.state, value: 0x1)
    unlock()
    return status

  }
  public func configClockSource(_ sClockSourceConfig: TIMClockConfiguration) -> HALStatus {

    var status: HALStatus = .ok
    var tmpsmcr: UInt32

    guard lock() else { return .busy }
    handle.write(.state, value: 0x2)

    tmpsmcr = registers.read(.smcr)
    tmpsmcr &= ~(0x10007 | 0x300070)
    tmpsmcr &= ~(0xf00 | 0x3000 | 0x4000 | 0x8000)
    registers.write(.smcr, value: tmpsmcr)
    switch sClockSourceConfig.clockSource
    {
    case 0x1000:
      do {
        break
      }
    case 0x70:
      do {

        etrSetConfig(
          sClockSourceConfig.clockPrescaler, sClockSourceConfig.clockPolarity,
          sClockSourceConfig.clockFilter)

        tmpsmcr = registers.read(.smcr)
        tmpsmcr |= (0x7 | 0x70)
        registers.write(.smcr, value: tmpsmcr)
        break
      }
    case 0x2000:
      do {

        etrSetConfig(
          sClockSourceConfig.clockPrescaler, sClockSourceConfig.clockPolarity,
          sClockSourceConfig.clockFilter)
        registers.write(.smcr, value: registers.read(.smcr) | (0x4000))
        break
      }
    case 0x50:
      do {

        ti1ConfigInputStage(sClockSourceConfig.clockPolarity, sClockSourceConfig.clockFilter)
        iTRxSetConfig(0x50)
        break
      }
    case 0x60:
      do {

        ti2ConfigInputStage(sClockSourceConfig.clockPolarity, sClockSourceConfig.clockFilter)
        iTRxSetConfig(0x60)
        break
      }
    case 0x40:
      do {

        ti1ConfigInputStage(sClockSourceConfig.clockPolarity, sClockSourceConfig.clockFilter)
        iTRxSetConfig(0x40)
        break
      }
    case 0x0, 0x10, 0x20, 0x30, 0x100000, 0x100010, 0x100020, 0x100030, 0x100040, 0x100050,
      0x100060, 0x100070, 0x200010, 0x200020:
      do {

        iTRxSetConfig(sClockSourceConfig.clockSource)
        break
      }
    default:
      status = .error
      break
    }
    handle.write(.state, value: 0x1)
    unlock()
    return status

  }
  public func configTI1Input(_ TI1_Selection: UInt32) -> HALStatus {

    var tmpcr2: UInt32

    tmpcr2 = registers.read(.cr2)

    tmpcr2 &= ~0x80

    tmpcr2 |= TI1_Selection

    registers.write(.cr2, value: tmpcr2)
    return .ok

  }
  public func slaveConfigSynchro(_ sSlaveConfig: TIMSlaveConfiguration) -> HALStatus {

    guard lock() else { return .busy }
    handle.write(.state, value: 0x2)
    if slaveTimerSetConfig(sSlaveConfig) != .ok {
      handle.write(.state, value: 0x1)
      unlock()
      return .error
    }

    disableInterrupts(0x40)

    disableDMARequests(0x4000)
    handle.write(.state, value: 0x1)
    unlock()
    return .ok

  }
  public func slaveConfigSynchroInterrupt(_ sSlaveConfig: TIMSlaveConfiguration) -> HALStatus {

    guard lock() else { return .busy }
    handle.write(.state, value: 0x2)
    if slaveTimerSetConfig(sSlaveConfig) != .ok {
      handle.write(.state, value: 0x1)
      unlock()
      return .error
    }

    enableInterrupts(0x40)

    disableDMARequests(0x4000)
    handle.write(.state, value: 0x1)
    unlock()
    return .ok

  }
  public func readCapturedValue(_ Channel: UInt32) -> UInt32 {

    var tmpreg: UInt32 = 0
    switch Channel
    {
    case 0x0:
      do {

        tmpreg = registers.read(.ccr1)
        break
      }
    case 0x4:
      do {

        tmpreg = registers.read(.ccr2)
        break
      }
    case 0x8:
      do {

        tmpreg = registers.read(.ccr3)
        break
      }
    case 0xc:
      do {

        tmpreg = registers.read(.ccr4)
        break
      }
    default:
      break
    }
    return tmpreg

  }
}
