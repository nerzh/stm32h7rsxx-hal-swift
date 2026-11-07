// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Control, polling and IRQ behavior from stm32h7rsxx_hal_cordic.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CORDIC {
  @discardableResult
  public func initialize() -> HALStatus {
    if handle.read(.state) == 0 {
      handle.write(.lock, value: 0)
      if useRegisteredCallbacks {
        callbacks.write(.error, value: defaults.error)
        callbacks.write(.calculateComplete, value: defaults.calculateComplete)
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }
      }
      invokeCallback(.mspInitialize)
    }
    handle.write(.errorCode, value: 0)
    handle.writePointer(.input, value: nil)
    handle.writePointer(.output, value: nil)
    handle.write(.calculationsToOrder, value: 0)
    handle.write(.calculationsToGet, value: 0)
    handle.write(.dmaDirection, value: 0)
    handle.write(.state, value: 1)
    return .ok
  }

  @discardableResult
  public func deinitialize() -> HALStatus {
    handle.write(.state, value: 2)
    if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
      callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
    }
    invokeCallback(.mspDeinitialize)
    handle.write(.errorCode, value: 0)
    handle.writePointer(.input, value: nil)
    handle.writePointer(.output, value: nil)
    handle.write(.calculationsToOrder, value: 0)
    handle.write(.calculationsToGet, value: 0)
    handle.write(.dmaDirection, value: 0)
    handle.write(.state, value: 0)
    handle.write(.lock, value: 0)
    return .ok
  }

  @discardableResult
  public func configure(_ configuration: CORDICConfiguration) -> HALStatus {
    precondition(CORDICFunction(rawValue: configuration.function) != nil)
    precondition(CORDICPrecision(rawValue: configuration.precision) != nil)
    precondition(CORDICScale(rawValue: configuration.scale) != nil)
    precondition(CORDICWriteCount(rawValue: configuration.writeCount) != nil)
    precondition(CORDICReadCount(rawValue: configuration.readCount) != nil)
    precondition(CORDICInputSize(rawValue: configuration.inputSize) != nil)
    precondition(CORDICOutputSize(rawValue: configuration.outputSize) != nil)
    if handle.read(.state) == 1 {
      modifyCSR(clear: 0x0078_07FF,
        set: configuration.function | configuration.precision | configuration.scale
          | configuration.writeCount | configuration.readCount | configuration.inputSize | configuration.outputSize)
      return .ok
    }
    addError(2)
    return .error
  }

  // Buffers contain raw 32-bit words even for Q1.15: two 16-bit values are
  // packed into each word. The caller supplies enough words for count and the
  // configured NARGS/NRES values; no allocation or numeric conversion occurs.
  @discardableResult
  public func calculate(_ input: UnsafePointer<Int32>?, output: UnsafeMutablePointer<Int32>?,
                        count: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    calculatePolling(input, output: output, count: count, timeout: timeout,
                     zeroOverhead: false, getTick: getTick)
  }
  @discardableResult
  public func calculateZeroOverhead(_ input: UnsafePointer<Int32>?, output: UnsafeMutablePointer<Int32>?,
                                    count: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    calculatePolling(input, output: output, count: count, timeout: timeout,
                     zeroOverhead: true, getTick: getTick)
  }

  private func calculatePolling(_ input: UnsafePointer<Int32>?, output: UnsafeMutablePointer<Int32>?,
                                count: UInt32, timeout: UInt32, zeroOverhead: Bool,
                                getTick: () -> UInt32) -> HALStatus {
    guard var input, var output, count != 0 else { addError(1); return .error }
    guard handle.read(.state) == 1 else { addError(2); return .error }
    handle.write(.errorCode, value: 0)
    handle.write(.state, value: 2)
    let tickStart = getTick()
    writeInputData(&input)
    var index = count &- 1
    while index > 0 {
      writeInputData(&input)
      if zeroOverhead {
        readOutputData(&output)
        if timeout != UInt32.max && (getTick() &- tickStart) > timeout {
          handle.write(.errorCode, value: 4)
          handle.write(.state, value: 1)
          return .error
        }
      } else {
        // The C do/while checks the deadline before its first RRDY read.
        repeat {
          if timeout != UInt32.max && (getTick() &- tickStart) > timeout {
            handle.write(.errorCode, value: 4)
            handle.write(.state, value: 1)
            return .error
          }
        } while registers.read(.csr) & 0x8000_0000 == 0
        readOutputData(&output)
      }
      index &-= 1
    }
    // The last result uses the peripheral's stalled-read behavior in both modes.
    readOutputData(&output)
    handle.write(.state, value: 1)
    return .ok
  }

  @discardableResult
  public func calculateInterrupt(_ input: UnsafePointer<Int32>?, output: UnsafeMutablePointer<Int32>?,
                                 count: UInt32) -> HALStatus {
    guard let input, let output, count != 0 else { addError(1); return .error }
    guard handle.read(.state) == 1 else { addError(2); return .error }
    handle.write(.errorCode, value: 0)
    handle.write(.state, value: 2)
    let nextInput: UnsafePointer<Int32>
    if registers.read(.csr) & 0x0010_0000 != 0 { nextInput = input.advanced(by: 2) }
    else { nextInput = input.advanced(by: 1) }
    handle.writePointer(.input, value: UnsafeMutableRawPointer(mutating: nextInput))
    handle.writePointer(.output, value: UnsafeMutableRawPointer(output))
    handle.write(.calculationsToOrder, value: count &- 1)
    handle.write(.calculationsToGet, value: count)
    enableInterrupts(0x0001_0000)
    registers.write(.wdata, value: UInt32(bitPattern: input.pointee))
    if registers.read(.csr) & 0x0010_0000 != 0 {
      registers.write(.wdata, value: UInt32(bitPattern: input.advanced(by: 1).pointee))
    }
    return .ok
  }

  public func handleInterrupt() {
    if getInterruptSource(0x0001_0000) != 0 {
      if getFlag(0x8000_0000) != 0 {
        handle.write(.calculationsToGet, value: handle.read(.calculationsToGet) &- 1)
        readOutputData()
        if handle.read(.calculationsToOrder) > 0 {
          handle.write(.calculationsToOrder, value: handle.read(.calculationsToOrder) &- 1)
          writeInputData()
        }
        if handle.read(.calculationsToGet) == 0 {
          disableInterrupts(0x0001_0000)
          handle.write(.state, value: 1)
          invokeCallback(.calculateComplete)
        }
      }
    }
  }

  public func getState() -> UInt32 { handle.read(.state) }
  public func getError() -> UInt32 { handle.read(.errorCode) }
  public func enableInterrupts(_ interrupts: UInt32) { modifyCSR(set: interrupts) }
  public func disableInterrupts(_ interrupts: UInt32) { modifyCSR(clear: interrupts) }
  public func getInterruptSource(_ interrupts: UInt32) -> UInt32 { registers.read(.csr) & interrupts }
  public func getFlag(_ flags: UInt32) -> UInt32 { registers.read(.csr) & flags == flags ? 1 : 0 }
  public func enableInterrupts(_ interrupts: CORDICInterrupts) { enableInterrupts(interrupts.rawValue) }
  public func disableInterrupts(_ interrupts: CORDICInterrupts) { disableInterrupts(interrupts.rawValue) }
  public func getInterruptSource(_ interrupts: CORDICInterrupts) -> UInt32 { getInterruptSource(interrupts.rawValue) }
  public func getFlag(_ flags: CORDICFlags) -> UInt32 { getFlag(flags.rawValue) }
  // These three original macros are empty; they neither read nor clear CSR.
  public func getInterrupt(_ interrupts: UInt32) {}
  public func clearInterrupt(_ interrupts: UInt32) {}
  public func clearFlag(_ flags: UInt32) {}

  func modifyCSR(clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(.csr, value: (registers.read(.csr) & ~clear) | set)
  }
  private func writeInputData(_ pointer: inout UnsafePointer<Int32>) {
    registers.write(.wdata, value: UInt32(bitPattern: pointer.pointee))
    pointer = pointer.advanced(by: 1)
    if registers.read(.csr) & 0x0010_0000 != 0 {
      registers.write(.wdata, value: UInt32(bitPattern: pointer.pointee))
      pointer = pointer.advanced(by: 1)
    }
  }
  private func readOutputData(_ pointer: inout UnsafeMutablePointer<Int32>) {
    pointer.pointee = Int32(bitPattern: registers.read(.rdata))
    pointer = pointer.advanced(by: 1)
    if registers.read(.csr) & 0x0008_0000 != 0 {
      pointer.pointee = Int32(bitPattern: registers.read(.rdata))
      pointer = pointer.advanced(by: 1)
    }
  }
  // IRQ helpers update the shared pointer after each word. Keeping a local copy
  // across the whole helper would hide the intermediate C handle state.
  private func writeInputData() {
    registers.write(.wdata, value: UInt32(bitPattern: handle.readPointer(.input)!.load(as: Int32.self)))
    handle.writePointer(.input, value: handle.readPointer(.input)!.advanced(by: 4))
    if registers.read(.csr) & 0x0010_0000 != 0 {
      registers.write(.wdata, value: UInt32(bitPattern: handle.readPointer(.input)!.load(as: Int32.self)))
      handle.writePointer(.input, value: handle.readPointer(.input)!.advanced(by: 4))
    }
  }
  private func readOutputData() {
    let first = Int32(bitPattern: registers.read(.rdata))
    handle.readPointer(.output)!.storeBytes(of: first, as: Int32.self)
    handle.writePointer(.output, value: handle.readPointer(.output)!.advanced(by: 4))
    if registers.read(.csr) & 0x0008_0000 != 0 {
      let second = Int32(bitPattern: registers.read(.rdata))
      handle.readPointer(.output)!.storeBytes(of: second, as: Int32.self)
      handle.writePointer(.output, value: handle.readPointer(.output)!.advanced(by: 4))
    }
  }
}
