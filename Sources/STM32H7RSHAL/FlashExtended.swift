// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Port of stm32h7rsxx_hal_flash_ex.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// Register masks from CMSIS device 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt and
// LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

extension Flash {
  public func erase(_ configuration: FlashEraseConfiguration, sectorError: inout UInt32,
                    getTick: () -> UInt32) -> HALStatus {
    assert(configuration.typeErase == 4 || configuration.typeErase == 8)
    guard tryLock() else { return .busy }
    process.write(.errorCode, value: 0)
    var status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
    if status == .ok {
      if configuration.typeErase == 8 {
        massErase()
        status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
      } else {
        sectorError = .max
        var sectorIndex = configuration.sector
        while sectorIndex < configuration.sector &+ configuration.sectorCount {
          sectorErase(sectorIndex)
          status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
          if status != .ok { sectorError = sectorIndex; break }
          sectorIndex &+= 1
        }
      }
      modify(.cr, clear: configuration.typeErase | 0x1C0, set: 0)
    }
    unlockProcess()
    return status
  }

  public func eraseInterrupt(_ configuration: FlashEraseConfiguration,
                             getTick: () -> UInt32) -> HALStatus {
    assert(configuration.typeErase == 4 || configuration.typeErase == 8)
    guard tryLock() else { return .busy }
    process.write(.errorCode, value: 0)
    let status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
    if status != .ok {
      unlockProcess()
    } else {
      process.write(.procedure, value: configuration.typeErase)
      enableInterrupts([.endOfOperation, .writeProtectionError, .programmingSequenceError,
                        .strobeError, .inconsistencyError])
      if configuration.typeErase == 8 {
        massErase()
      } else {
        process.write(.sectorsRemaining, value: configuration.sectorCount)
        process.write(.sector, value: configuration.sector)
        sectorErase(configuration.sector)
      }
    }
    return status
  }

  public func programOptionBytes(_ configuration: FlashOptionBytesConfiguration,
                                 getTick: () -> UInt32) -> HALStatus {
    assert(configuration.optionType <= 0xF)
    guard tryLock() else { return .busy }
    process.write(.errorCode, value: 0)
    var status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
    if status == .ok && configuration.optionType != 0 {
      modify(.optcr, clear: 0, set: 2)
      if configuration.optionType & 1 != 0 {
        configureWriteProtection(state: configuration.wrpState, sectors: configuration.wrpSector)
      }
      if configuration.optionType & 2 != 0 {
        configureUserOptions(type: configuration.userType, configuration1: configuration.userConfiguration1,
                             configuration2: configuration.userConfiguration2)
      }
      if configuration.optionType & 4 != 0 {
        assert(configuration.hdpStartPage < 0x100 && configuration.hdpEndPage < 0x100)
        modify(.hdpsrp, clear: 0x00FF_00FF,
               set: configuration.hdpStartPage | (configuration.hdpEndPage << 16))
      }
      if configuration.optionType & 8 != 0 {
        assert(configuration.nvState == 0xB4 || configuration.nvState == 0x51)
        modify(.nvsrp, clear: 0xFF, set: configuration.nvState)
      }
      status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
      modify(.optcr, clear: 2, set: 0)
    }
    unlockProcess()
    return status
  }

  public func getOptionBytesConfiguration(_ configuration: inout FlashOptionBytesConfiguration) {
    if registers.read(.wrpsr) & 0xFF == 0xFF {
      configuration.wrpState = 0
      // FLASH_OB_GetWRP leaves WRPSector unchanged when protection is disabled.
    } else {
      configuration.wrpState = 1
      configuration.wrpSector = ~registers.read(.wrpsr) & 0xFF
    }
    configuration.userConfiguration1 = registers.read(.obw1sr)
    configuration.userConfiguration2 = registers.read(.obw2sr)
    configuration.hdpStartPage = registers.read(.hdpsr) & 0xFF
    configuration.hdpEndPage = (registers.read(.hdpsr) & 0x00FF_0000) >> 16
    configuration.nvState = registers.read(.nvsr) & 0xFF
    configuration.rotConfiguration = registers.read(.rotsr) & 0xFF00_FFFF
    configuration.epoch = registers.read(.epochsr) & 0x00FF_FFFF
  }

  public func configureOTPLock(_ blocks: UInt32, getTick: () -> UInt32) -> HALStatus {
    assert(blocks <= 0xFFFF)
    guard tryLock() else { return .busy }
    process.write(.errorCode, value: 0)
    var status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
    if status == .ok {
      modify(.cr, clear: 0, set: 0x0001_0000)
      modify(.optcr, clear: 0, set: 2)
      modify(.otplsrp, clear: 0xFFFF, set: blocks & 0xFFFF)
      status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
      modify(.optcr, clear: 2, set: 0)
      modify(.cr, clear: 0x0001_0000, set: 0)
    }
    unlockProcess()
    return status
  }

  public func getOTPLock() -> UInt32 { registers.read(.otplsr) & 0xFFFF }

  // The caller supplies readable 32-bit source words at the target bus address.
  public func configureKey(_ configuration: FlashKeyConfiguration, keyAddress: UInt32,
                           getTick: () -> UInt32) -> HALStatus {
    assert(configuration.index < 0x20)
    assert(FlashKeySize(rawValue: configuration.size) != nil)
    assert(FlashKeyLevel(rawValue: configuration.hdplLevel) != nil)
    guard tryLock() else { return .busy }
    process.write(.errorCode, value: 0)
    var status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
    if status == .ok {
      modify(.optcr, clear: 0, set: 2)
      let count = keyWordCount(configuration.size)
      for index in 0..<count {
        registers.write(.obkdr(index: index), value: memory.read32(at: keyAddress &+ UInt32(index) &* 4))
      }
      modify(.obkcr, clear: 0xF1F, set: configuration.index | configuration.hdplLevel | configuration.size)
      modify(.obkcr, clear: 0, set: 0xC000)
      status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
      modify(.obkcr, clear: 0x4000, set: 0)
      modify(.optcr, clear: 2, set: 0)
    }
    unlockProcess()
    return status
  }

  // A nil output still loads the key, matching the optional C pKey argument.
  public func getKey(_ configuration: FlashKeyConfiguration, outputAddress: UInt32?,
                     getTick: () -> UInt32) -> HALStatus {
    assert(configuration.index < 0x20)
    assert(FlashKeySize(rawValue: configuration.size) != nil)
    assert(FlashKeyLevel(rawValue: configuration.hdplLevel) != nil)
    guard tryLock() else { return .busy }
    process.write(.errorCode, value: 0)
    var status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
    if status == .ok {
      modify(.optcr, clear: 0, set: 2)
      modify(.obkcr, clear: 0x4F1F, set: configuration.index | configuration.hdplLevel | configuration.size)
      modify(.obkcr, clear: 0, set: 0x8000)
      status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
      if status == .ok, let outputAddress, outputAddress != 0 {
        let count = keyWordCount(configuration.size)
        for index in 0..<count {
          memory.write32(at: outputAddress &+ UInt32(index) &* 4, value: registers.read(.obkdr(index: index)))
        }
      }
      modify(.optcr, clear: 2, set: 0)
    }
    unlockProcess()
    return status
  }

  public func computeCRC(_ configuration: FlashCRCConfiguration, result: inout UInt32,
                         getTick: () -> UInt32) -> HALStatus {
    assert(FlashCRCType(rawValue: configuration.typeCRC) != nil)
    assert(FlashCRCBurstSize(rawValue: configuration.burstSize) != nil)
    // Unlike the other extended operations, C waits before taking pFlash.Lock.
    var status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
    if status == .ok {
      guard tryLock() else { return .busy }
      process.write(.errorCode, value: 0)
      modify(.cr, clear: 0, set: 0x0002_0000)
      registers.write(.icr, value: 0x1800_0000)
      modify(.crccr, clear: 0x0032_0000, set: 0x0002_0000 | configuration.burstSize)
      if configuration.typeCRC == 0x200 {
        modify(.crccr, clear: 0, set: 0xA00)
        var sectorIndex = configuration.sector
        while sectorIndex < configuration.sectorCount &+ configuration.sector {
          addCRCSector(sectorIndex)
          sectorIndex &+= 1
        }
      } else if configuration.typeCRC == 0x0100_0200 {
        modify(.crccr, clear: 0, set: 0x0100_0200)
      } else {
        modify(.crccr, clear: 0x200, set: 0)
        assert(configuration.startAddress >= 0x0800_0000 && configuration.startAddress < 0x0801_0000)
        assert(configuration.endAddress >= 0x0800_0000 && configuration.endAddress < 0x0801_0000)
        registers.write(.crcsaddr, value: configuration.startAddress &- 0x0800_0000)
        registers.write(.crceaddr, value: configuration.endAddress &- 0x0800_0000)
      }
      modify(.crccr, clear: 0, set: 0x0001_0000)
      status = waitForCRCOperation(timeout: flashOperationTimeout, getTick: getTick)
      // C returns CRCDATAR even when CRC waiting fails or times out.
      result = registers.read(.crcdatar)
      modify(.cr, clear: 0x0002_0000, set: 0)
      registers.write(.icr, value: 0x1800_0000)
      unlockProcess()
    }
    return status
  }

  public func enableECCCorrectionInterrupt() { enableInterrupts(.eccSingleError) }
  public func disableECCCorrectionInterrupt() { disableInterrupts(.eccSingleError) }
  public func enableECCDetectionInterrupt() { enableInterrupts(.eccDoubleError) }
  public func disableECCDetectionInterrupt() { disableInterrupts(.eccDoubleError) }

  public func getECCInfo(_ info: inout FlashECCInfo) {
    if registers.read(.isr) & 0x0200_0000 != 0 {
      info.address = registers.read(.eccsfaddr)
    } else {
      info.address = registers.read(.eccdfaddr)
    }
    if info.address >= 0x0800_0000 && info.address < 0x0801_0000 {
      info.area = 0
    } else if info.address >= 0x08FF_F000 && info.address < 0x08FF_F400 {
      info.area = 2
    } else if info.address >= 0x1FF0_0000 && info.address < 0x1FF2_0000 {
      info.area = 1
    } else {
      info.area = 4
    }
    info.masterID = 0
  }

  public func handleECCDetectionInterrupt() {
    if registers.read(.isr) & 0x0400_0000 != 0 {
      callbacks.eccDetection(callbacks.context)
      registers.write(.icr, value: 0x0400_0000)
    }
  }

  internal func sectorErase(_ sector: UInt32) {
    assert(sector < 8)
    modify(.cr, clear: 0x1E4, set: (sector << 6) | 4 | 0x20)
  }
  private func massErase() { modify(.cr, clear: 0, set: 0x28) }

  private func configureWriteProtection(state: UInt32, sectors: UInt32) {
    assert(state == 0 || state == 1)
    if state == 0 { modify(.wrpsrp, clear: 0, set: sectors & 0xFF) }
    else if state == 1 { modify(.wrpsrp, clear: sectors & 0xFF, set: 0) }
  }

  private func configureUserOptions(type: UInt32, configuration1: UInt32, configuration2: UInt32) {
    assert(type <= 0x1FFF && type != 0)
    var value: UInt32 = 0
    var mask: UInt32 = 0
    // The C assertions on each masked field permit every encoding in its mask.
    if type & 1 != 0 { value |= configuration1 & 0xC; mask |= 0xC }
    if type & 2 != 0 { value |= configuration1 & 0x10; mask |= 0x10 }
    if type & 4 != 0 { value |= configuration1 & 0x40; mask |= 0x40 }
    if type & 8 != 0 { value |= configuration1 & 0x80; mask |= 0x80 }
    if type & 0x10 != 0 { value |= configuration1 & 0x100; mask |= 0x100 }
    if type & 0x20 != 0 { value |= configuration1 & 0x200; mask |= 0x200 }
    if type & 0x40 != 0 { value |= configuration1 & 0x0002_0000; mask |= 0x0002_0000 }
    if type & 0x80 != 0 { value |= configuration1 & 0x0004_0000; mask |= 0x0004_0000 }
    if type & 0x100 != 0 { value |= configuration1 & 0x2000_0000; mask |= 0x2000_0000 }
    if mask != 0 { modify(.obw1srp, clear: mask, set: value) }
    value = 0; mask = 0
    if type & 0x200 != 0 { value |= configuration2 & 7; mask |= 7 }
    if type & 0x400 != 0 { value |= configuration2 & 0x70; mask |= 0x70 }
    if type & 0x800 != 0 { value |= configuration2 & 0x100; mask |= 0x100 }
    if type & 0x1000 != 0 { value |= configuration2 & 0x200; mask |= 0x200 }
    if mask != 0 { modify(.obw2srp, clear: mask, set: value) }
  }

  private func keyWordCount(_ size: UInt32) -> Int {
    switch size { case 0: return 1; case 0x400: return 2; case 0x800: return 4; case 0xC00: return 8; default: return 0 }
  }
  private func addCRCSector(_ sector: UInt32) {
    assert(sector < 8)
    modify(.crccr, clear: 7, set: sector)
    modify(.crccr, clear: 0, set: 0x400)
  }
  internal func waitForCRCOperation(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    let tickStart = getTick()
    while registers.read(.sr) & 8 != 0 {
      if getTick() &- tickStart > timeout || timeout == 0 { return .timeout }
    }
    if registers.read(.isr) & 0x1000_0000 != 0 {
      process.write(.errorCode, value: process.read(.errorCode) | 0x1000_0000)
      registers.write(.icr, value: 0x1000_0000)
      return .error
    }
    if registers.read(.isr) & 0x0800_0000 != 0 { registers.write(.icr, value: 0x0800_0000) }
    return .ok
  }
}
