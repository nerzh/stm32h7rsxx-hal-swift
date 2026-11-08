// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct FMCNORSRAMConfiguration: Equatable, Sendable {
  public var bank: UInt32
  public var dataAddressMux: UInt32
  public var memoryType: UInt32
  public var memoryDataWidth: UInt32
  public var burstAccessMode: UInt32
  public var waitSignalPolarity: UInt32
  public var waitSignalActive: UInt32
  public var writeOperation: UInt32
  public var waitSignal: UInt32
  public var extendedMode: UInt32
  public var asynchronousWait: UInt32
  public var writeBurst: UInt32
  public var continuousClock: UInt32
  public var writeFIFO: UInt32
  public var pageSize: UInt32
  public init(
    bank: UInt32 = 0, dataAddressMux: UInt32 = 0, memoryType: UInt32 = 0,
    memoryDataWidth: UInt32 = 0, burstAccessMode: UInt32 = 0, waitSignalPolarity: UInt32 = 0,
    waitSignalActive: UInt32 = 0, writeOperation: UInt32 = 0, waitSignal: UInt32 = 0,
    extendedMode: UInt32 = 0, asynchronousWait: UInt32 = 0, writeBurst: UInt32 = 0,
    continuousClock: UInt32 = 0, writeFIFO: UInt32 = 0, pageSize: UInt32 = 0
  ) {
    self.bank = bank
    self.dataAddressMux = dataAddressMux
    self.memoryType = memoryType
    self.memoryDataWidth = memoryDataWidth
    self.burstAccessMode = burstAccessMode
    self.waitSignalPolarity = waitSignalPolarity
    self.waitSignalActive = waitSignalActive
    self.writeOperation = writeOperation
    self.waitSignal = waitSignal
    self.extendedMode = extendedMode
    self.asynchronousWait = asynchronousWait
    self.writeBurst = writeBurst
    self.continuousClock = continuousClock
    self.writeFIFO = writeFIFO
    self.pageSize = pageSize
  }
}
public struct FMCNORSRAMTiming: Equatable, Sendable {
  public var addressSetupTime: UInt32
  public var addressHoldTime: UInt32
  public var dataSetupTime: UInt32
  public var busTurnAroundDuration: UInt32
  public var clockDivision: UInt32
  public var dataLatency: UInt32
  public var accessMode: UInt32
  public init(
    addressSetupTime: UInt32 = 0, addressHoldTime: UInt32 = 0, dataSetupTime: UInt32 = 0,
    busTurnAroundDuration: UInt32 = 0, clockDivision: UInt32 = 0, dataLatency: UInt32 = 0,
    accessMode: UInt32 = 0
  ) {
    self.addressSetupTime = addressSetupTime
    self.addressHoldTime = addressHoldTime
    self.dataSetupTime = dataSetupTime
    self.busTurnAroundDuration = busTurnAroundDuration
    self.clockDivision = clockDivision
    self.dataLatency = dataLatency
    self.accessMode = accessMode
  }
}
public struct FMCNANDConfiguration: Equatable, Sendable {
  public var bank: UInt32
  public var waitFeature: UInt32
  public var memoryDataWidth: UInt32
  public var eccComputation: UInt32
  public var eccPageSize: UInt32
  public var tclrSetupTime: UInt32
  public var tarSetupTime: UInt32
  public init(
    bank: UInt32 = 0, waitFeature: UInt32 = 0, memoryDataWidth: UInt32 = 0,
    eccComputation: UInt32 = 0, eccPageSize: UInt32 = 0, tclrSetupTime: UInt32 = 0,
    tarSetupTime: UInt32 = 0
  ) {
    self.bank = bank
    self.waitFeature = waitFeature
    self.memoryDataWidth = memoryDataWidth
    self.eccComputation = eccComputation
    self.eccPageSize = eccPageSize
    self.tclrSetupTime = tclrSetupTime
    self.tarSetupTime = tarSetupTime
  }
}
public struct FMCNANDTiming: Equatable, Sendable {
  public var setupTime: UInt32
  public var waitSetupTime: UInt32
  public var holdSetupTime: UInt32
  public var hiZSetupTime: UInt32
  public init(
    setupTime: UInt32 = 0, waitSetupTime: UInt32 = 0, holdSetupTime: UInt32 = 0,
    hiZSetupTime: UInt32 = 0
  ) {
    self.setupTime = setupTime
    self.waitSetupTime = waitSetupTime
    self.holdSetupTime = holdSetupTime
    self.hiZSetupTime = hiZSetupTime
  }
}
public struct FMCSDRAMConfiguration: Equatable, Sendable {
  public var bank: UInt32
  public var columnBitsNumber: UInt32
  public var rowBitsNumber: UInt32
  public var memoryDataWidth: UInt32
  public var internalBankNumber: UInt32
  public var casLatency: UInt32
  public var writeProtection: UInt32
  public var sdClockPeriod: UInt32
  public var readBurst: UInt32
  public var readPipeDelay: UInt32
  public init(
    bank: UInt32 = 0, columnBitsNumber: UInt32 = 0, rowBitsNumber: UInt32 = 0,
    memoryDataWidth: UInt32 = 0, internalBankNumber: UInt32 = 0, casLatency: UInt32 = 0,
    writeProtection: UInt32 = 0, sdClockPeriod: UInt32 = 0, readBurst: UInt32 = 0,
    readPipeDelay: UInt32 = 0
  ) {
    self.bank = bank
    self.columnBitsNumber = columnBitsNumber
    self.rowBitsNumber = rowBitsNumber
    self.memoryDataWidth = memoryDataWidth
    self.internalBankNumber = internalBankNumber
    self.casLatency = casLatency
    self.writeProtection = writeProtection
    self.sdClockPeriod = sdClockPeriod
    self.readBurst = readBurst
    self.readPipeDelay = readPipeDelay
  }
}
public struct FMCSDRAMTiming: Equatable, Sendable {
  public var loadToActiveDelay: UInt32
  public var exitSelfRefreshDelay: UInt32
  public var selfRefreshTime: UInt32
  public var rowCycleDelay: UInt32
  public var writeRecoveryTime: UInt32
  public var rpDelay: UInt32
  public var rcdDelay: UInt32
  public init(
    loadToActiveDelay: UInt32 = 0, exitSelfRefreshDelay: UInt32 = 0, selfRefreshTime: UInt32 = 0,
    rowCycleDelay: UInt32 = 0, writeRecoveryTime: UInt32 = 0, rpDelay: UInt32 = 0,
    rcdDelay: UInt32 = 0
  ) {
    self.loadToActiveDelay = loadToActiveDelay
    self.exitSelfRefreshDelay = exitSelfRefreshDelay
    self.selfRefreshTime = selfRefreshTime
    self.rowCycleDelay = rowCycleDelay
    self.writeRecoveryTime = writeRecoveryTime
    self.rpDelay = rpDelay
    self.rcdDelay = rcdDelay
  }
}
public struct FMCSDRAMCommand: Equatable, Sendable {
  public var commandMode: UInt32
  public var commandTarget: UInt32
  public var autoRefreshNumber: UInt32
  public var modeRegisterDefinition: UInt32
  public init(
    commandMode: UInt32 = 0, commandTarget: UInt32 = 0, autoRefreshNumber: UInt32 = 0,
    modeRegisterDefinition: UInt32 = 0
  ) {
    self.commandMode = commandMode
    self.commandTarget = commandTarget
    self.autoRefreshNumber = autoRefreshNumber
    self.modeRegisterDefinition = modeRegisterDefinition
  }
}
