// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// DMA control and callback bodies from stm32h7rsxx_hal_cordic.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CORDIC {
  @discardableResult
  public func calculateDMA(_ input: UnsafePointer<Int32>?, output: UnsafeMutablePointer<Int32>?,
                           count: UInt32, direction: UInt32) -> HALStatus {
    precondition(direction == 1 || direction == 2 || direction == 3)
    guard count != 0 else { addError(1); return .error }
    if direction == 2 || direction == 3 {
      guard output != nil else { addError(1); return .error }
    }
    if direction == 1 || direction == 3 {
      guard input != nil else { addError(1); return .error }
    }
    guard handle.read(.state) == 1 else { addError(2); return .error }
    handle.write(.errorCode, value: 0)
    handle.write(.state, value: 2)
    handle.write(.dmaDirection, value: direction)

    if direction == 2 || direction == 3 {
      dma.writeCallback(.output, id: .transferComplete, value: dma.callback(.outputComplete))
      dma.writeCallback(.output, id: .error, value: dma.callback(.error))
      var size: UInt32
      if registers.read(.csr) & 0x0008_0000 != 0 { size = 2 &* count }
      else { size = count }
      size = 4 &* size
      if dma.startInterrupt(.output, sourceAddress: registers.address(of: .rdata),
        destinationAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: output!)),
        sourceDataSize: size) != .ok {
        addError(8)
        return .error
      }
      modifyCSR(set: 0x0002_0000)
    }
    if direction == 1 || direction == 3 {
      dma.writeCallback(.input, id: .transferComplete, value: dma.callback(.inputComplete))
      dma.writeCallback(.input, id: .error, value: dma.callback(.error))
      var size: UInt32
      if registers.read(.csr) & 0x0010_0000 != 0 { size = 2 &* count }
      else { size = count }
      size = 4 &* size
      if dma.startInterrupt(.input, sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: input!)),
        destinationAddress: registers.address(of: .wdata), sourceDataSize: size) != .ok {
        addError(8)
        return .error
      }
      modifyCSR(set: 0x0004_0000)
    }
    return .ok
  }
  @discardableResult
  public func calculateDMA(_ input: UnsafePointer<Int32>?, output: UnsafeMutablePointer<Int32>?,
                           count: UInt32, direction: CORDICDMATransferDirection) -> HALStatus {
    calculateDMA(input, output: output, count: count, direction: direction.rawValue)
  }

  // The DMA thunk reconstructs this wrapper from the original DMA handle's
  // current Parent. These three C callbacks do not read DMA mode or counters.
  public func handleDMAEvent(_ kind: CORDICDMACallbackKind) {
    switch kind {
    case .inputComplete:
      modifyCSR(clear: 0x0004_0000)
      if handle.read(.dmaDirection) == 1 {
        handle.write(.dmaDirection, value: 0)
        handle.write(.state, value: 1)
        invokeCallback(.calculateComplete)
      }
    case .outputComplete:
      modifyCSR(clear: 0x0002_0000)
      handle.write(.dmaDirection, value: 0)
      handle.write(.state, value: 1)
      invokeCallback(.calculateComplete)
    case .error:
      handle.write(.state, value: 1)
      addError(8)
      invokeCallback(.error)
    }
  }
}
