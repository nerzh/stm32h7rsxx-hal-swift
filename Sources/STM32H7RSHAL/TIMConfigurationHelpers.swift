// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  func baseSetConfig(_ Structure: TIMBaseConfiguration) {

    var tmpcr1: UInt32
    tmpcr1 = registers.read(.cr1)

    if ((((registers.instance)) == TIMInstance.tim1) || (((registers.instance)) == TIMInstance.tim2)
      || (((registers.instance)) == TIMInstance.tim3)
      || (((registers.instance)) == TIMInstance.tim4)
      || (((registers.instance)) == TIMInstance.tim5))
    {
      tmpcr1 &= ~(0x10 | 0x60)
      tmpcr1 |= Structure.counterMode
    }
    if ((((registers.instance)) == TIMInstance.tim1) || (((registers.instance)) == TIMInstance.tim2)
      || (((registers.instance)) == TIMInstance.tim3)
      || (((registers.instance)) == TIMInstance.tim4)
      || (((registers.instance)) == TIMInstance.tim5)
      || (((registers.instance)) == TIMInstance.tim9)
      || (((registers.instance)) == TIMInstance.tim12)
      || (((registers.instance)) == TIMInstance.tim13)
      || (((registers.instance)) == TIMInstance.tim14)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {
      tmpcr1 &= ~0x300
      tmpcr1 |= (Structure.clockDivision)
    }

    tmpcr1 = (tmpcr1 & ~(0x80)) | (Structure.autoReloadPreload)

    registers.write(.arr, value: (Structure.period))

    registers.write(.psc, value: Structure.prescaler)
    if ((((registers.instance)) == TIMInstance.tim1)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {
      registers.write(.rcr, value: Structure.repetitionCounter)
    }

    registers.write(.cr1, value: registers.read(.cr1) | (0x4))

    registers.write(.egr, value: 0x1)
    registers.write(.cr1, value: tmpcr1)

  }
  func oc1SetConfig(_ OC_Config: TIMOutputCompareConfiguration) {

    var tmpccmrx: UInt32
    var tmpccer: UInt32
    var tmpcr2: UInt32

    tmpccer = registers.read(.ccer)

    registers.write(.ccer, value: registers.read(.ccer) & (~0x1))

    tmpcr2 = registers.read(.cr2)

    tmpccmrx = registers.read(.ccmr1)

    tmpccmrx &= ~0x10070
    tmpccmrx &= ~0x3
    tmpccmrx |= OC_Config.outputCompareMode

    tmpccer &= ~0x2
    tmpccer |= OC_Config.outputComparePolarity
    if (((((registers.instance)) == TIMInstance.tim1)
      && ((((0x0)) == 0x0) || (((0x0)) == 0x4) || (((0x0)) == 0x8) || (((0x0)) == 0xc)))
      || ((((registers.instance)) == TIMInstance.tim15) && (((0x0)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim16) && (((0x0)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim17) && (((0x0)) == 0x0)))
    {

      registers.write(.ccer, value: registers.read(.ccer) & (~0x4))

      tmpccer &= ~0x8
      tmpccer |= OC_Config.outputCompareNPolarity
    }
    if ((((registers.instance)) == TIMInstance.tim1)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {

      tmpcr2 &= ~0x100
      tmpcr2 &= ~0x200
      tmpcr2 |= OC_Config.outputCompareIdleState
      tmpcr2 |= OC_Config.outputCompareNIdleState
    }

    registers.write(.cr2, value: tmpcr2)

    registers.write(.ccmr1, value: tmpccmrx)

    registers.write(.ccr1, value: OC_Config.pulse)

    registers.write(.ccer, value: tmpccer)

  }
  func oc2SetConfig(_ OC_Config: TIMOutputCompareConfiguration) {

    var tmpccmrx: UInt32
    var tmpccer: UInt32
    var tmpcr2: UInt32

    tmpccer = registers.read(.ccer)

    registers.write(.ccer, value: registers.read(.ccer) & (~0x10))

    tmpcr2 = registers.read(.cr2)

    tmpccmrx = registers.read(.ccmr1)

    tmpccmrx &= ~0x1007000
    tmpccmrx &= ~0x300

    tmpccmrx |= (OC_Config.outputCompareMode << 8)

    tmpccer &= ~0x20
    tmpccer |= (OC_Config.outputComparePolarity << 4)
    if (((((registers.instance)) == TIMInstance.tim1)
      && ((((0x4)) == 0x0) || (((0x4)) == 0x4) || (((0x4)) == 0x8) || (((0x4)) == 0xc)))
      || ((((registers.instance)) == TIMInstance.tim15) && (((0x4)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim16) && (((0x4)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim17) && (((0x4)) == 0x0)))
    {

      registers.write(.ccer, value: registers.read(.ccer) & (~0x40))

      tmpccer &= ~0x80
      tmpccer |= (OC_Config.outputCompareNPolarity << 4)
    }
    if ((((registers.instance)) == TIMInstance.tim1)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {

      tmpcr2 &= ~0x400
      tmpcr2 &= ~0x800
      tmpcr2 |= (OC_Config.outputCompareIdleState << 2)
      tmpcr2 |= (OC_Config.outputCompareNIdleState << 2)
    }

    registers.write(.cr2, value: tmpcr2)

    registers.write(.ccmr1, value: tmpccmrx)

    registers.write(.ccr2, value: OC_Config.pulse)

    registers.write(.ccer, value: tmpccer)

  }
  func oc3SetConfig(_ OC_Config: TIMOutputCompareConfiguration) {

    var tmpccmrx: UInt32
    var tmpccer: UInt32
    var tmpcr2: UInt32

    tmpccer = registers.read(.ccer)

    registers.write(.ccer, value: registers.read(.ccer) & (~0x100))

    tmpcr2 = registers.read(.cr2)

    tmpccmrx = registers.read(.ccmr2)

    tmpccmrx &= ~0x10070
    tmpccmrx &= ~0x3
    tmpccmrx |= OC_Config.outputCompareMode

    tmpccer &= ~0x200
    tmpccer |= (OC_Config.outputComparePolarity << 8)
    if (((((registers.instance)) == TIMInstance.tim1)
      && ((((0x8)) == 0x0) || (((0x8)) == 0x4) || (((0x8)) == 0x8) || (((0x8)) == 0xc)))
      || ((((registers.instance)) == TIMInstance.tim15) && (((0x8)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim16) && (((0x8)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim17) && (((0x8)) == 0x0)))
    {

      registers.write(.ccer, value: registers.read(.ccer) & (~0x400))

      tmpccer &= ~0x800
      tmpccer |= (OC_Config.outputCompareNPolarity << 8)
    }
    if ((((registers.instance)) == TIMInstance.tim1)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {

      tmpcr2 &= ~0x1000
      tmpcr2 &= ~0x2000
      tmpcr2 |= (OC_Config.outputCompareIdleState << 4)
      tmpcr2 |= (OC_Config.outputCompareNIdleState << 4)
    }

    registers.write(.cr2, value: tmpcr2)

    registers.write(.ccmr2, value: tmpccmrx)

    registers.write(.ccr3, value: OC_Config.pulse)

    registers.write(.ccer, value: tmpccer)

  }
  func oc4SetConfig(_ OC_Config: TIMOutputCompareConfiguration) {

    var tmpccmrx: UInt32
    var tmpccer: UInt32
    var tmpcr2: UInt32

    tmpccer = registers.read(.ccer)

    registers.write(.ccer, value: registers.read(.ccer) & (~0x1000))

    tmpcr2 = registers.read(.cr2)

    tmpccmrx = registers.read(.ccmr2)

    tmpccmrx &= ~0x1007000
    tmpccmrx &= ~0x300

    tmpccmrx |= (OC_Config.outputCompareMode << 8)

    tmpccer &= ~0x2000
    tmpccer |= (OC_Config.outputComparePolarity << 12)
    if (((((registers.instance)) == TIMInstance.tim1)
      && ((((0xc)) == 0x0) || (((0xc)) == 0x4) || (((0xc)) == 0x8) || (((0xc)) == 0xc)))
      || ((((registers.instance)) == TIMInstance.tim15) && (((0xc)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim16) && (((0xc)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim17) && (((0xc)) == 0x0)))
    {

      registers.write(.ccer, value: registers.read(.ccer) & (~0x4000))

      tmpccer &= ~0x8000
      tmpccer |= (OC_Config.outputCompareNPolarity << 12)
    }
    if ((((registers.instance)) == TIMInstance.tim1)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {

      tmpcr2 &= ~0x4000
      tmpcr2 &= ~0x8000

      tmpcr2 |= (OC_Config.outputCompareIdleState << 6)
      tmpcr2 |= (OC_Config.outputCompareNIdleState << 6)
    }

    registers.write(.cr2, value: tmpcr2)

    registers.write(.ccmr2, value: tmpccmrx)

    registers.write(.ccr4, value: OC_Config.pulse)

    registers.write(.ccer, value: tmpccer)

  }
  func oc5SetConfig(_ OC_Config: TIMOutputCompareConfiguration) {

    var tmpccmrx: UInt32
    var tmpccer: UInt32
    var tmpcr2: UInt32

    tmpccer = registers.read(.ccer)

    registers.write(.ccer, value: registers.read(.ccer) & (~0x10000))

    tmpcr2 = registers.read(.cr2)
    tmpccmrx = registers.read(.ccmr3)

    tmpccmrx &= ~(0x10070)
    tmpccmrx |= OC_Config.outputCompareMode

    tmpccer &= ~0x20000
    tmpccer |= (OC_Config.outputComparePolarity << 16)
    if ((((registers.instance)) == TIMInstance.tim1)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {
      tmpcr2 &= ~0x10000
      tmpcr2 |= (OC_Config.outputCompareIdleState << 8)
    }
    registers.write(.cr2, value: tmpcr2)

    registers.write(.ccmr3, value: tmpccmrx)

    registers.write(.ccr5, value: OC_Config.pulse)

    registers.write(.ccer, value: tmpccer)

  }
  func oc6SetConfig(_ OC_Config: TIMOutputCompareConfiguration) {

    var tmpccmrx: UInt32
    var tmpccer: UInt32
    var tmpcr2: UInt32

    tmpccer = registers.read(.ccer)

    registers.write(.ccer, value: registers.read(.ccer) & (~0x100000))

    tmpcr2 = registers.read(.cr2)
    tmpccmrx = registers.read(.ccmr3)

    tmpccmrx &= ~(0x1007000)
    tmpccmrx |= (OC_Config.outputCompareMode << 8)

    tmpccer &= ~0x200000
    tmpccer |= (OC_Config.outputComparePolarity << 20)
    if ((((registers.instance)) == TIMInstance.tim1)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {
      tmpcr2 &= ~0x40000
      tmpcr2 |= (OC_Config.outputCompareIdleState << 10)
    }

    registers.write(.cr2, value: tmpcr2)

    registers.write(.ccmr3, value: tmpccmrx)

    registers.write(.ccr6, value: OC_Config.pulse)

    registers.write(.ccer, value: tmpccer)

  }
  func slaveTimerSetConfig(_ sSlaveConfig: TIMSlaveConfiguration) -> HALStatus {

    var status: HALStatus = .ok
    var tmpsmcr: UInt32
    var tmpccmr1: UInt32
    var tmpccer: UInt32

    tmpsmcr = registers.read(.smcr)

    tmpsmcr &= ~0x300070
    tmpsmcr |= sSlaveConfig.inputTrigger

    tmpsmcr &= ~0x10007
    tmpsmcr |= sSlaveConfig.slaveMode

    registers.write(.smcr, value: tmpsmcr)

    switch sSlaveConfig.inputTrigger
    {
    case 0x70:
      do {

        etrSetConfig(
          sSlaveConfig.triggerPrescaler, sSlaveConfig.triggerPolarity, sSlaveConfig.triggerFilter)
        break
      }
    case 0x40:
      do {

        if (sSlaveConfig.slaveMode == 0x5) || (sSlaveConfig.slaveMode == 0x10001) {
          return .error
        }

        tmpccer = registers.read(.ccer)
        registers.write(.ccer, value: registers.read(.ccer) & (~0x1))
        tmpccmr1 = registers.read(.ccmr1)

        tmpccmr1 &= ~0xf0
        tmpccmr1 |= ((sSlaveConfig.triggerFilter) << 4)

        registers.write(.ccmr1, value: tmpccmr1)
        registers.write(.ccer, value: tmpccer)
        break
      }
    case 0x50:
      do {

        ti1ConfigInputStage(sSlaveConfig.triggerPolarity, sSlaveConfig.triggerFilter)
        break
      }
    case 0x60:
      do {

        ti2ConfigInputStage(sSlaveConfig.triggerPolarity, sSlaveConfig.triggerFilter)
        break
      }
    case 0x0, 0x10, 0x20, 0x30, 0x100000, 0x100010, 0x100020, 0x100030, 0x100040, 0x100050,
      0x100060, 0x100070, 0x200010, 0x200020:
      do {

        break
      }
    default:
      status = .error
      break
    }
    return status

  }
  func ti1SetConfig(_ TIM_ICPolarity: UInt32, _ TIM_ICSelection: UInt32, _ TIM_ICFilter: UInt32) {

    var tmpccmr1: UInt32
    var tmpccer: UInt32

    tmpccer = registers.read(.ccer)

    registers.write(.ccer, value: registers.read(.ccer) & (~0x1))
    if (((((registers.instance)) == TIMInstance.tim1)
      && ((((0x0)) == 0x0) || (((0x0)) == 0x4) || (((0x0)) == 0x8) || (((0x0)) == 0xc)))
      || ((((registers.instance)) == TIMInstance.tim15) && (((0x0)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim16) && (((0x0)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim17) && (((0x0)) == 0x0)))
    {
      registers.write(.ccer, value: registers.read(.ccer) & (~0x4))
    }

    tmpccmr1 = registers.read(.ccmr1)

    if ((((registers.instance)) == TIMInstance.tim1) || (((registers.instance)) == TIMInstance.tim2)
      || (((registers.instance)) == TIMInstance.tim3)
      || (((registers.instance)) == TIMInstance.tim4)
      || (((registers.instance)) == TIMInstance.tim5)
      || (((registers.instance)) == TIMInstance.tim9)
      || (((registers.instance)) == TIMInstance.tim12)
      || (((registers.instance)) == TIMInstance.tim15))
    {
      tmpccmr1 &= ~0x3
      tmpccmr1 |= TIM_ICSelection
    } else {
      tmpccmr1 |= 0x1
    }

    tmpccmr1 &= ~0xf0
    tmpccmr1 |= ((TIM_ICFilter << 4) & 0xf0)

    tmpccer &= ~(0x2 | 0x8)
    tmpccer |= (TIM_ICPolarity & (0x2 | 0x8))

    registers.write(.ccmr1, value: tmpccmr1)
    registers.write(.ccer, value: tmpccer)

  }
  func ti1ConfigInputStage(_ TIM_ICPolarity: UInt32, _ TIM_ICFilter: UInt32) {

    var tmpccmr1: UInt32
    var tmpccer: UInt32

    tmpccer = registers.read(.ccer)

    registers.write(.ccer, value: registers.read(.ccer) & (~0x1))
    if (((((registers.instance)) == TIMInstance.tim1)
      && ((((0x0)) == 0x0) || (((0x0)) == 0x4) || (((0x0)) == 0x8) || (((0x0)) == 0xc)))
      || ((((registers.instance)) == TIMInstance.tim15) && (((0x0)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim16) && (((0x0)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim17) && (((0x0)) == 0x0)))
    {
      registers.write(.ccer, value: registers.read(.ccer) & (~0x4))
    }

    tmpccmr1 = registers.read(.ccmr1)

    tmpccmr1 &= ~0xf0
    tmpccmr1 |= (TIM_ICFilter << 4)

    tmpccer &= ~(0x2 | 0x8)
    tmpccer |= TIM_ICPolarity

    registers.write(.ccmr1, value: tmpccmr1)
    registers.write(.ccer, value: tmpccer)

  }
  func ti2SetConfig(_ TIM_ICPolarity: UInt32, _ TIM_ICSelection: UInt32, _ TIM_ICFilter: UInt32) {

    var tmpccmr1: UInt32
    var tmpccer: UInt32

    tmpccer = registers.read(.ccer)

    registers.write(.ccer, value: registers.read(.ccer) & (~0x10))
    if (((((registers.instance)) == TIMInstance.tim1)
      && ((((0x4)) == 0x0) || (((0x4)) == 0x4) || (((0x4)) == 0x8) || (((0x4)) == 0xc)))
      || ((((registers.instance)) == TIMInstance.tim15) && (((0x4)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim16) && (((0x4)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim17) && (((0x4)) == 0x0)))
    {
      registers.write(.ccer, value: registers.read(.ccer) & (~0x40))
    }

    tmpccmr1 = registers.read(.ccmr1)

    tmpccmr1 &= ~0x300
    tmpccmr1 |= (TIM_ICSelection << 8)

    tmpccmr1 &= ~0xf000
    tmpccmr1 |= ((TIM_ICFilter << 12) & 0xf000)

    tmpccer &= ~(0x20 | 0x80)
    tmpccer |= ((TIM_ICPolarity << 4) & (0x20 | 0x80))

    registers.write(.ccmr1, value: tmpccmr1)
    registers.write(.ccer, value: tmpccer)

  }
  func ti2ConfigInputStage(_ TIM_ICPolarity: UInt32, _ TIM_ICFilter: UInt32) {

    var tmpccmr1: UInt32
    var tmpccer: UInt32

    tmpccer = registers.read(.ccer)

    registers.write(.ccer, value: registers.read(.ccer) & (~0x10))
    if (((((registers.instance)) == TIMInstance.tim1)
      && ((((0x4)) == 0x0) || (((0x4)) == 0x4) || (((0x4)) == 0x8) || (((0x4)) == 0xc)))
      || ((((registers.instance)) == TIMInstance.tim15) && (((0x4)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim16) && (((0x4)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim17) && (((0x4)) == 0x0)))
    {
      registers.write(.ccer, value: registers.read(.ccer) & (~0x40))
    }

    tmpccmr1 = registers.read(.ccmr1)

    tmpccmr1 &= ~0xf000
    tmpccmr1 |= (TIM_ICFilter << 12)

    tmpccer &= ~(0x20 | 0x80)
    tmpccer |= (TIM_ICPolarity << 4)

    registers.write(.ccmr1, value: tmpccmr1)
    registers.write(.ccer, value: tmpccer)

  }
  func ti3SetConfig(_ TIM_ICPolarity: UInt32, _ TIM_ICSelection: UInt32, _ TIM_ICFilter: UInt32) {

    var tmpccmr2: UInt32
    var tmpccer: UInt32

    tmpccer = registers.read(.ccer)

    registers.write(.ccer, value: registers.read(.ccer) & (~0x100))
    if (((((registers.instance)) == TIMInstance.tim1)
      && ((((0x8)) == 0x0) || (((0x8)) == 0x4) || (((0x8)) == 0x8) || (((0x8)) == 0xc)))
      || ((((registers.instance)) == TIMInstance.tim15) && (((0x8)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim16) && (((0x8)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim17) && (((0x8)) == 0x0)))
    {
      registers.write(.ccer, value: registers.read(.ccer) & (~0x400))
    }

    tmpccmr2 = registers.read(.ccmr2)

    tmpccmr2 &= ~0x3
    tmpccmr2 |= TIM_ICSelection

    tmpccmr2 &= ~0xf0
    tmpccmr2 |= ((TIM_ICFilter << 4) & 0xf0)

    tmpccer &= ~(0x200 | 0x800)
    tmpccer |= ((TIM_ICPolarity << 8) & (0x200 | 0x800))

    registers.write(.ccmr2, value: tmpccmr2)
    registers.write(.ccer, value: tmpccer)

  }
  func ti4SetConfig(_ TIM_ICPolarity: UInt32, _ TIM_ICSelection: UInt32, _ TIM_ICFilter: UInt32) {

    var tmpccmr2: UInt32
    var tmpccer: UInt32

    tmpccer = registers.read(.ccer)

    registers.write(.ccer, value: registers.read(.ccer) & (~0x1000))
    if (((((registers.instance)) == TIMInstance.tim1)
      && ((((0xc)) == 0x0) || (((0xc)) == 0x4) || (((0xc)) == 0x8) || (((0xc)) == 0xc)))
      || ((((registers.instance)) == TIMInstance.tim15) && (((0xc)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim16) && (((0xc)) == 0x0))
      || ((((registers.instance)) == TIMInstance.tim17) && (((0xc)) == 0x0)))
    {
      registers.write(.ccer, value: registers.read(.ccer) & (~0x4000))
    }

    tmpccmr2 = registers.read(.ccmr2)

    tmpccmr2 &= ~0x300
    tmpccmr2 |= (TIM_ICSelection << 8)

    tmpccmr2 &= ~0xf000
    tmpccmr2 |= ((TIM_ICFilter << 12) & 0xf000)

    tmpccer &= ~(0x2000 | 0x8000)
    tmpccer |= ((TIM_ICPolarity << 12) & (0x2000 | 0x8000))

    registers.write(.ccmr2, value: tmpccmr2)
    registers.write(.ccer, value: tmpccer)

  }
  func iTRxSetConfig(_ InputTriggerSource: UInt32) {

    var tmpsmcr: UInt32

    tmpsmcr = registers.read(.smcr)
    tmpsmcr &= ~0x300070
    tmpsmcr |= (InputTriggerSource | 0x7)
    registers.write(.smcr, value: tmpsmcr)

  }
  func etrSetConfig(
    _ TIM_ExtTRGPrescaler: UInt32, _ TIM_ExtTRGPolarity: UInt32, _ ExtTRGFilter: UInt32
  ) {

    var tmpsmcr: UInt32
    tmpsmcr = registers.read(.smcr)

    tmpsmcr &= ~(0xf00 | 0x3000 | 0x4000 | 0x8000)

    tmpsmcr |= ((TIM_ExtTRGPrescaler | (TIM_ExtTRGPolarity | (ExtTRGFilter << 8))))

    registers.write(.smcr, value: tmpsmcr)

  }
  func ccxChannelCmd(_ Channel: UInt32, _ ChannelState: UInt32) {

    var tmp: UInt32

    tmp = 0x1 << (Channel & 0x1F)

    registers.write(.ccer, value: registers.read(.ccer) & (~tmp))

    registers.write(.ccer, value: registers.read(.ccer) | (((ChannelState << (Channel & 0x1F)))))

  }
  func ccxNChannelCmd(_ Channel: UInt32, _ ChannelNState: UInt32) {

    var tmp: UInt32
    tmp = 0x4 << (Channel & 0xF)

    registers.write(.ccer, value: registers.read(.ccer) & (~tmp))

    registers.write(.ccer, value: registers.read(.ccer) | (((ChannelNState << (Channel & 0xF)))))

  }
}
