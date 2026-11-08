// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDMMC linked-list operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum SDMMCDMAListWord: UInt32, CaseIterable, Sendable {
  case head = 0
  case tail = 4
  case nodeCount = 8
  public static let byteCount: UInt32 = 12
}

public enum SDMMCDMANodeWord: UInt32, CaseIterable, Sendable {
  case link = 0
  case bufferAddress = 4
  case bufferSize = 8
  public static let byteCount: UInt32 = 12
}

// List metadata and nodes use the explicit ARM word layout in caller-owned memory.
// All addresses are target bus addresses; zero represents a C null pointer.
public struct SDMMCDMALinkedList<Memory: DMAMemoryIO> {
  public let memory: Memory
  public init(memory: Memory) { self.memory = memory }

  private func modifyLink(_ node: UInt32, clear: UInt32, set: UInt32) {
    memory.write32(at: node, value: (memory.read32(at: node) & ~clear) | set)
  }

  public func buildNode(_ node: UInt32, configuration: SDMMCDMANodeConfiguration?) -> UInt32 {
    guard node != 0, let configuration else { return 0x0800_0000 }
    memory.write32(at: node &+ 4, value: configuration.bufferAddress)
    memory.write32(at: node &+ 8, value: configuration.bufferSize)
    memory.write32(at: node, value: 0x4000_0000 | 0x2000_0000)
    return 0
  }

  public func insertNode(_ list: UInt32, previousNode: UInt32, node: UInt32) -> UInt32 {
    if memory.read32(at: list &+ 8) == 0 {
      memory.write32(at: list, value: node)
      memory.write32(at: list &+ 4, value: node)
      memory.write32(at: list &+ 8, value: 1)
    } else if previousNode == memory.read32(at: list &+ 4) {
      if node <= memory.read32(at: list) { return 0x0800_0000 }
      modifyLink(previousNode, clear: 0x8000_0000, set: 0)
      modifyLink(previousNode, clear: 0x8000_0000, set: 0x8000_0000)
      modifyLink(previousNode, clear: 0xFFFC, set: node &- memory.read32(at: list))
      memory.write32(at: list &+ 8, value: memory.read32(at: list &+ 8) &+ 1)
      memory.write32(at: list &+ 4, value: node)
    } else {
      if node <= memory.read32(at: list) { return 0x0800_0000 }
      let linkListOffset = memory.read32(at: node)
      modifyLink(previousNode, clear: 0xFFFC, set: linkListOffset)
      modifyLink(previousNode, clear: 0x8000_0000, set: 0x8000_0000)
      modifyLink(previousNode, clear: 0xFFFC, set: node &- memory.read32(at: list))
      memory.write32(at: list &+ 8, value: memory.read32(at: list &+ 8) &+ 1)
    }
    return 0
  }

  public func removeNode(_ list: UInt32, node: UInt32) -> UInt32 {
    var count: UInt32 = 0
    var previousNode: UInt32 = 0
    if memory.read32(at: list &+ 8) == 0 {
      return 0x0800_0000
    } else {
      var currentNode = memory.read32(at: list)
      while currentNode != node && count <= memory.read32(at: list &+ 8) {
        previousNode = currentNode
        currentNode = (memory.read32(at: previousNode) & 0xFFFC) &+ memory.read32(at: list)
        count &+= 1
      }
      if count == 0 || count > memory.read32(at: list &+ 8) { return 0x0800_0000 }
      memory.write32(at: list &+ 8, value: memory.read32(at: list &+ 8) &- 1)
      if memory.read32(at: list &+ 8) == 0 {
        memory.write32(at: list, value: 0)
        memory.write32(at: list &+ 4, value: 0)
      } else {
        let linkedListOffset = memory.read32(at: currentNode)
        modifyLink(previousNode, clear: 0xFFFC, set: linkedListOffset)
        memory.write32(at: node, value: memory.read32(at: node) | linkedListOffset)
        memory.write32(at: list &+ 4, value: previousNode)
      }
    }
    return 0
  }

  public func lockNode(_ node: UInt32) -> UInt32 {
    if node == 0 { return 0x0800_0000 }
    modifyLink(node, clear: 0x2000_0000, set: 0)
    return 0
  }

  public func unlockNode(_ node: UInt32) -> UInt32 {
    if node == 0 { return 0x0800_0000 }
    modifyLink(node, clear: 0x2000_0000, set: 0x2000_0000)
    return 0
  }

  public func enableCircularMode(_ list: UInt32) -> UInt32 {
    if list == 0 { return 0x0800_0000 }
    modifyLink(memory.read32(at: list &+ 4), clear: 0x8000_FFFC, set: 0x8000_0000)
    return 0
  }

  public func disableCircularMode(_ list: UInt32) -> UInt32 {
    if list == 0 { return 0x0800_0000 }
    modifyLink(memory.read32(at: list &+ 4), clear: 0x8000_0000, set: 0)
    return 0
  }
}
