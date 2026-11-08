// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// JPEG operations and definitions from stm32h7rsxx_hal_jpeg.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension JPEG {
    func setDHTMemory() {

        var value: UInt32 = 0
        var index = 0
        var address = 0
        address = 3
        index = 16
        while index > 3 {
            registers.writeTable(.dht, index: address, value: ((UInt32(JPEGDefaultTables.dcLuminance[index - 1]) & 0xFF) << 24) |
                ((UInt32(JPEGDefaultTables.dcLuminance[index - 2]) & 0xFF) << 16) |
                ((UInt32(JPEGDefaultTables.dcLuminance[index - 3]) & 0xFF) << 8) |
                (UInt32(JPEGDefaultTables.dcLuminance[index - 4]) & 0xFF))
            address -= 1
            index -= 4
        }
        address = 6
        index = 12
        while index > 3 {
            registers.writeTable(.dht, index: address, value: ((UInt32(JPEGDefaultTables.dcLuminance[index - 1 + 16]) & 0xFF) << 24) |
                ((UInt32(JPEGDefaultTables.dcLuminance[index - 2 + 16]) & 0xFF) << 16) |
                ((UInt32(JPEGDefaultTables.dcLuminance[index - 3 + 16]) & 0xFF) << 8) |
                (UInt32(JPEGDefaultTables.dcLuminance[index - 4 + 16]) & 0xFF))
            address -= 1
            index -= 4
        }
        address = 10
        index = 16
        while index > 3 {
            registers.writeTable(.dht, index: address, value: ((UInt32(JPEGDefaultTables.acLuminance[index - 1]) & 0xFF) << 24) |
                ((UInt32(JPEGDefaultTables.acLuminance[index - 2]) & 0xFF) << 16) |
                ((UInt32(JPEGDefaultTables.acLuminance[index - 3]) & 0xFF) << 8) |
                (UInt32(JPEGDefaultTables.acLuminance[index - 4]) & 0xFF))
            address -= 1
            index -= 4
        }
        address = 51
        value = registers.readTable(.dht, index: address) & 0xFFFF0000
        value = value | ((UInt32(JPEGDefaultTables.acLuminance[161 + 16]) & 0xFF) << 8) |
            (UInt32(JPEGDefaultTables.acLuminance[160 + 16]) & 0xFF)
        registers.writeTable(.dht, index: address, value: value)
        address -= 1
        index = 162 - 2
        while index > 3 {
            registers.writeTable(.dht, index: address, value: ((UInt32(JPEGDefaultTables.acLuminance[index - 1 + 16]) & 0xFF) << 24) |
                ((UInt32(JPEGDefaultTables.acLuminance[index - 2 + 16]) & 0xFF) << 16) |
                ((UInt32(JPEGDefaultTables.acLuminance[index - 3 + 16]) & 0xFF) << 8) |
                (UInt32(JPEGDefaultTables.acLuminance[index - 4 + 16]) & 0xFF))
            address -= 1
            index -= 4
        }
        address = 51
        value = registers.readTable(.dht, index: address) & 0x0000FFFF
        value = value | ((UInt32(JPEGDefaultTables.dcChrominance[1]) & 0xFF) << 24) |
            ((UInt32(JPEGDefaultTables.dcChrominance[0]) & 0xFF) << 16)
        registers.writeTable(.dht, index: address, value: value)
        address = 55
        value = registers.readTable(.dht, index: address) & 0xFFFF0000
        value = value | ((UInt32(JPEGDefaultTables.dcChrominance[15]) & 0xFF) << 8) |
            (UInt32(JPEGDefaultTables.dcChrominance[14]) & 0xFF)
        registers.writeTable(.dht, index: address, value: value)
        address -= 1
        index = 12
        while index > 3 {
            registers.writeTable(.dht, index: address, value: ((UInt32(JPEGDefaultTables.dcChrominance[index + 1]) & 0xFF) << 24) |
                ((UInt32(JPEGDefaultTables.dcChrominance[index]) & 0xFF) << 16) |
                ((UInt32(JPEGDefaultTables.dcChrominance[index - 1]) & 0xFF) << 8) |
                (UInt32(JPEGDefaultTables.dcChrominance[index - 2]) & 0xFF))
            address -= 1
            index -= 4
        }
        address = 55
        value = registers.readTable(.dht, index: address) & 0x0000FFFF
        value = value | ((UInt32(JPEGDefaultTables.dcChrominance[1 + 16]) & 0xFF) << 24) |
            ((UInt32(JPEGDefaultTables.dcChrominance[0 + 16]) & 0xFF) << 16)
        registers.writeTable(.dht, index: address, value: value)
        address = 58
        value = registers.readTable(.dht, index: address) & 0xFFFF0000
        value = value | ((UInt32(JPEGDefaultTables.dcChrominance[11 + 16]) & 0xFF) << 8) |
            (UInt32(JPEGDefaultTables.dcChrominance[10 + 16]) & 0xFF)
        registers.writeTable(.dht, index: address, value: value)
        address -= 1
        index = 8
        while index > 3 {
            registers.writeTable(.dht, index: address, value: ((UInt32(JPEGDefaultTables.dcChrominance[index + 1 + 16]) & 0xFF) << 24) |
                ((UInt32(JPEGDefaultTables.dcChrominance[index + 16]) & 0xFF) << 16) |
                ((UInt32(JPEGDefaultTables.dcChrominance[index - 1 + 16]) & 0xFF) << 8) |
                (UInt32(JPEGDefaultTables.dcChrominance[index - 2 + 16]) & 0xFF))
            address -= 1
            index -= 4
        }
        address = 58
        value = registers.readTable(.dht, index: address) & 0x0000FFFF
        value = value | ((UInt32(JPEGDefaultTables.acChrominance[1]) & 0xFF) << 24) |
            ((UInt32(JPEGDefaultTables.acChrominance[0]) & 0xFF) << 16)
        registers.writeTable(.dht, index: address, value: value)
        address = 62
        value = registers.readTable(.dht, index: address) & 0xFFFF0000
        value = value | ((UInt32(JPEGDefaultTables.acChrominance[15]) & 0xFF) << 8) | (UInt32(JPEGDefaultTables.acChrominance[14]) & 0xFF)
        registers.writeTable(.dht, index: address, value: value)
        address -= 1
        index = 12
        while index > 3 {
            registers.writeTable(.dht, index: address, value: ((UInt32(JPEGDefaultTables.acChrominance[index + 1]) & 0xFF) << 24) |
                ((UInt32(JPEGDefaultTables.acChrominance[index]) & 0xFF) << 16) |
                ((UInt32(JPEGDefaultTables.acChrominance[index - 1]) & 0xFF) << 8) |
                (UInt32(JPEGDefaultTables.acChrominance[index - 2]) & 0xFF))
            address -= 1
            index -= 4
        }
        address = 62
        value = registers.readTable(.dht, index: address) & 0x0000FFFF
        value = value | ((UInt32(JPEGDefaultTables.acChrominance[1 + 16]) & 0xFF) << 24) |
            ((UInt32(JPEGDefaultTables.acChrominance[0 + 16]) & 0xFF) << 16)
        registers.writeTable(.dht, index: address, value: value)
        address = 102
        index = 162 - 2
        while index > 3 {
            registers.writeTable(.dht, index: address, value: ((UInt32(JPEGDefaultTables.acChrominance[index + 1 + 16]) & 0xFF) << 24) |
                ((UInt32(JPEGDefaultTables.acChrominance[index + 16]) & 0xFF) << 16) |
                ((UInt32(JPEGDefaultTables.acChrominance[index - 1 + 16]) & 0xFF) << 8) |
                (UInt32(JPEGDefaultTables.acChrominance[index - 2 + 16]) & 0xFF))
            address -= 1
            index -= 4
        }
    }
}
