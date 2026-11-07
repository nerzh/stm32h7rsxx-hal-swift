// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// FLASH/FLASHEx types from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748
// and CMSIS device 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt and
// LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

public enum FlashEraseType: UInt32, CaseIterable, Sendable { case sectors = 4, mass = 8 }
public struct FlashEraseConfiguration: Equatable, Sendable {
  public var typeErase, sector, sectorCount: UInt32
  public init(typeErase: UInt32 = 4, sector: UInt32 = 0, sectorCount: UInt32 = 1) {
    self.typeErase = typeErase; self.sector = sector; self.sectorCount = sectorCount
  }
}
public struct FlashOptionType: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let writeProtection = Self(rawValue: 1)
  public static let user = Self(rawValue: 2)
  public static let hideProtection = Self(rawValue: 4)
  public static let nonvolatileState = Self(rawValue: 8)
}
public enum FlashWriteProtectionState: UInt32, CaseIterable, Sendable { case disabled = 0, enabled = 1 }
public enum FlashNonvolatileState: UInt32, CaseIterable, Sendable { case open = 0xB4, closed = 0x51 }
public struct FlashUserOptionType: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let brownoutLevel = Self(rawValue: 1)
  public static let watchdogControl = Self(rawValue: 2)
  public static let resetOnStop = Self(rawValue: 4)
  public static let resetOnStandby = Self(rawValue: 8)
  public static let xspi1HighSpeedLowVoltage = Self(rawValue: 0x10)
  public static let xspi2HighSpeedLowVoltage = Self(rawValue: 0x20)
  public static let watchdogStop = Self(rawValue: 0x40)
  public static let watchdogStandby = Self(rawValue: 0x80)
  public static let ioHighSpeedLowVoltage = Self(rawValue: 0x100)
  public static let itcmAXIShare = Self(rawValue: 0x200)
  public static let dtcmAXIShare = Self(rawValue: 0x400)
  public static let sramECC = Self(rawValue: 0x800)
  public static let i2cNotI3c = Self(rawValue: 0x1000)
}
public struct FlashOptionBytesConfiguration: Equatable, Sendable {
  public var optionType, wrpState, wrpSector, userType, userConfiguration1, userConfiguration2: UInt32
  public var hdpStartPage, hdpEndPage, nvState, rotConfiguration, epoch: UInt32
  public init(optionType: UInt32 = 0, wrpState: UInt32 = 0, wrpSector: UInt32 = 0,
              userType: UInt32 = 0, userConfiguration1: UInt32 = 0, userConfiguration2: UInt32 = 0,
              hdpStartPage: UInt32 = 0, hdpEndPage: UInt32 = 0, nvState: UInt32 = 0,
              rotConfiguration: UInt32 = 0, epoch: UInt32 = 0) {
    self.optionType = optionType; self.wrpState = wrpState; self.wrpSector = wrpSector
    self.userType = userType; self.userConfiguration1 = userConfiguration1; self.userConfiguration2 = userConfiguration2
    self.hdpStartPage = hdpStartPage; self.hdpEndPage = hdpEndPage; self.nvState = nvState
    self.rotConfiguration = rotConfiguration; self.epoch = epoch
  }
}
public enum FlashKeySize: UInt32, CaseIterable, Sendable {
  case bits32 = 0, bits64 = 0x400, bits128 = 0x800, bits256 = 0xC00
}
public enum FlashKeyLevel: UInt32, CaseIterable, Sendable { case current = 0, next = 0x100, plusTwo = 0x200 }
public struct FlashKeyConfiguration: Equatable, Sendable {
  public var index, size, hdplLevel: UInt32
  public init(index: UInt32 = 0, size: UInt32 = 0, hdplLevel: UInt32 = 0) {
    self.index = index; self.size = size; self.hdplLevel = hdplLevel
  }
}
public enum FlashCRCType: UInt32, CaseIterable, Sendable { case address = 0, sectors = 0x200, bank = 0x0100_0200 }
public enum FlashCRCBurstSize: UInt32, CaseIterable, Sendable {
  // Each Flash word is 16 bytes, as in FLASH_CRC_BURST_SIZE_*.
  case words4 = 0, words16 = 0x10_0000, words64 = 0x20_0000, words256 = 0x30_0000
}
public struct FlashCRCConfiguration: Equatable, Sendable {
  public var typeCRC, burstSize, sector, sectorCount, startAddress, endAddress: UInt32
  public init(typeCRC: UInt32 = 0, burstSize: UInt32 = 0, sector: UInt32 = 0, sectorCount: UInt32 = 1,
              startAddress: UInt32 = 0x0800_0000, endAddress: UInt32 = 0x0800_FFFF) {
    self.typeCRC = typeCRC; self.burstSize = burstSize; self.sector = sector; self.sectorCount = sectorCount
    self.startAddress = startAddress; self.endAddress = endAddress
  }
}
public enum FlashECCArea: UInt32, CaseIterable, Sendable {
  case userBank1 = 0, system = 1, otp = 2, readOnly = 4
}
public enum FlashECCMaster: UInt32, Sendable { case cpu1 = 0 }
public struct FlashECCInfo: Equatable, Sendable {
  public var area, address, masterID: UInt32
  public init(area: UInt32 = 0, address: UInt32 = 0, masterID: UInt32 = 0) {
    self.area = area; self.address = address; self.masterID = masterID
  }
}
