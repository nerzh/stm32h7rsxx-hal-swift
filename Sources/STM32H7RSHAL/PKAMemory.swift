// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PKA operations and definitions from stm32h7rsxx_hal_pka.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum PKAEncoding {
    public static func bitSize(bytes: UInt32) -> UInt32 { bytes &* 8 }
    public static func optimizedBitSize(bytes: UInt32, mostSignificantByte: UInt8) -> UInt32 {
        let position = 32 &- UInt32(UInt32(mostSignificantByte).leadingZeroBitCount)
        return ((bytes &- 1) &* 8) &+ position
    }
    public static func bitSize(words: UInt32) -> UInt32 { words &* 32 }
    public static func byteCount(bits: UInt32) -> UInt32 { (bits &+ 7) / 8 }
}
extension PKA {
    public func readBytes(fromRAM index: UInt32, to destination: UnsafeMutablePointer<UInt8>?, count: UInt32) {
        guard let destination else { return }
        var word: UInt32 = 0
        while word < count / 4 {
            let byte = count &- 4 &- (word &* 4)
            // Four volatile reads are intentional and match the original C.
            destination[Int(byte &+ 3)] = UInt8(truncatingIfNeeded: registers.readRAM(index &+ word) & 0xFF)
            destination[Int(byte &+ 2)] = UInt8(truncatingIfNeeded: (registers.readRAM(index &+ word) & 0xFF00) >> 8)
            destination[Int(byte &+ 1)] = UInt8(truncatingIfNeeded: (registers.readRAM(index &+ word) & 0xFF0000) >> 16)
            destination[Int(byte)] = UInt8(truncatingIfNeeded: (registers.readRAM(index &+ word) & 0xFF000000) >> 24)
            word &+= 1
        }
        if count % 4 == 1 {
            destination[0] = UInt8(truncatingIfNeeded: registers.readRAM(index &+ word) & 0xFF)
        } else if count % 4 == 2 {
            destination[1] = UInt8(truncatingIfNeeded: registers.readRAM(index &+ word) & 0xFF)
            destination[0] = UInt8(truncatingIfNeeded: (registers.readRAM(index &+ word) & 0xFF00) >> 8)
        } else if count % 4 == 3 {
            destination[2] = UInt8(truncatingIfNeeded: registers.readRAM(index &+ word) & 0xFF)
            destination[1] = UInt8(truncatingIfNeeded: (registers.readRAM(index &+ word) & 0xFF00) >> 8)
            destination[0] = UInt8(truncatingIfNeeded: (registers.readRAM(index &+ word) & 0xFF0000) >> 16)
        }
    }
    public func writeBytes(toRAM index: UInt32, from source: UnsafePointer<UInt8>?, count: UInt32) {
        guard let source else { return }
        var word: UInt32 = 0
        while word < count / 4 {
            let byte = count &- (word &* 4)
            registers.writeRAM(index &+ word, value: UInt32(source[Int(byte &- 1)])
                | UInt32(source[Int(byte &- 2)]) << 8 | UInt32(source[Int(byte &- 3)]) << 16
                | UInt32(source[Int(byte &- 4)]) << 24)
            word &+= 1
        }
        let byte = count &- (word &* 4)
        if count % 4 == 1 {
            registers.writeRAM(index &+ word, value: UInt32(source[Int(byte &- 1)]))
        } else if count % 4 == 2 {
            registers.writeRAM(index &+ word, value: UInt32(source[Int(byte &- 1)]) | UInt32(source[Int(byte &- 2)]) << 8)
        } else if count % 4 == 3 {
            registers.writeRAM(index &+ word, value: UInt32(source[Int(byte &- 1)]) | UInt32(source[Int(byte &- 2)]) << 8
                | UInt32(source[Int(byte &- 3)]) << 16)
        }
    }
    public func writeWords(toRAM index: UInt32, from source: UnsafePointer<UInt32>?, count: UInt32) {
        guard let source else { return }
        for word in 0..<count { registers.writeRAM(index &+ word, value: registers.readOperandWord(source.advanced(by: Int(word)))) }
    }
    public func readWords(fromRAM index: UInt32, to destination: UnsafeMutablePointer<UInt32>?, count: UInt32) {
        guard let destination else { return }
        for word in 0..<count { registers.writeResultWord(destination.advanced(by: Int(word)), value: registers.readRAM(index &+ word)) }
    }
    func writeParameterEnd(at index: UInt32) {
        registers.writeRAM(index, value: 0); registers.writeRAM(index &+ 1, value: 0)
    }
    public func resultSize(startIndex: UInt32, maximumWords: UInt32) -> UInt32 {
        precondition(maximumWords != 0)
        var index = maximumWords &- 1
        while registers.readRAM(startIndex &+ index) == 0 && index != 0 { index &-= 1 }
        return (index &+ 1) &* 4
    }
}
