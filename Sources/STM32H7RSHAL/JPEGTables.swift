// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// JPEG operations and definitions from stm32h7rsxx_hal_jpeg.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension JPEG {
    func makeHuffmanCodes(isAC: Bool, bits: (Int) -> UInt8, symbols: (Int) -> UInt8,
                          store: (Int, UInt32, UInt8) -> Void) -> HALStatus {
        var sizes = InlineArray<257, UInt8>(repeating: 0)
        var codes = InlineArray<257, UInt32>(repeating: 0)
        var j = 0
        for k in 0..<16 {
            var i = Int(bits(k))
            if j + i > 256 { return .error }
            while i != 0 { sizes[j] = UInt8(k) + 1; j += 1; i -= 1 }
        }
        sizes[j] = 0
        let last = j
        var code: UInt32 = 0, size = UInt32(sizes[0])
        j = 0
        while sizes[j] != 0 {
            while UInt32(sizes[j]) == size { codes[j] = code; j += 1; code &+= 1 }
            if size > 31 { return .error }
            if code >= UInt32(1) << size { return .error }
            code <<= 1; size &+= 1
        }
        var k = 0
        while k < last {
            var i = UInt32(symbols(k))
            if isAC {
                if i == 0 { i = 160 }
                else if i == 0xF0 { i = 161 }
                else { let msb = (i & 0xF0) >> 4, lsb = i & 0x0F; i = (msb * 10) &+ lsb &- 1 }
            }
            if i >= (isAC ? 162 : 12) { return .error }
            store(Int(i), codes[k], sizes[k] &- 1); k += 1
        }
        return .ok
    }
    func setDCHuffmanMemory(_ table: JPEGTable, chrominance: Bool) -> HALStatus {
        guard table == .dc0 || table == .dc1 else { return .error }
        var lengths = InlineArray<12, UInt8>(repeating: 0), codes = InlineArray<12, UInt32>(repeating: 0)
        let source = chrominance ? JPEGDefaultTables.dcChrominance : JPEGDefaultTables.dcLuminance
        let status = makeHuffmanCodes(isAC: false, bits: { source[$0] }, symbols: { source[$0 + 16] },
                                     store: { codes[$0] = $1; lengths[$0] = $2 })
        guard status == .ok else { return status }
        registers.writeTable(table, index: 6, value: 0x0FFF0FFF); registers.writeTable(table, index: 7, value: 0x0FFF0FFF)
        var i = 12, address = 6
        while i > 1 {
            i -= 1; address -= 1
            let msb = ((UInt32(lengths[i]) & 0xF) << 8) | (codes[i] & 0xFF)
            i -= 1
            let lsb = ((UInt32(lengths[i]) & 0xF) << 8) | (codes[i] & 0xFF)
            registers.writeTable(table, index: address, value: lsb | (msb << 16))
        }
        return .ok
    }
    func setACHuffmanMemory(_ table: JPEGTable, chrominance: Bool) -> HALStatus {
        guard table == .ac0 || table == .ac1 else { return .error }
        var lengths = InlineArray<162, UInt8>(repeating: 0), codes = InlineArray<162, UInt32>(repeating: 0)
        let source = chrominance ? JPEGDefaultTables.acChrominance : JPEGDefaultTables.acLuminance
        let status = makeHuffmanCodes(isAC: true, bits: { source[$0] }, symbols: { source[$0 + 16] },
                                     store: { codes[$0] = $1; lengths[$0] = $2 })
        guard status == .ok else { return status }
        for i in 0..<3 { registers.writeTable(table, index: 81 + i, value: 0x0FFF0FFF) }
        registers.writeTable(table, index: 84, value: 0x0FD10FD0); registers.writeTable(table, index: 85, value: 0x0FD30FD2)
        registers.writeTable(table, index: 86, value: 0x0FD50FD4); registers.writeTable(table, index: 87, value: 0x0FD70FD6)
        var i = 162, address = 81
        while i > 1 {
            i -= 1; address -= 1
            let msb = ((UInt32(lengths[i]) & 0xF) << 8) | (codes[i] & 0xFF)
            i -= 1
            let lsb = ((UInt32(lengths[i]) & 0xF) << 8) | (codes[i] & 0xFF)
            registers.writeTable(table, index: address, value: lsb | (msb << 16))
        }
        return .ok
    }
    func setHuffmanEncodingMemory() -> HALStatus {
        setDHTMemory()
        var status = setACHuffmanMemory(.ac0, chrominance: false)
        if status != .ok { return status }
        status = setACHuffmanMemory(.ac1, chrominance: true)
        if status != .ok { return status }
        status = setDCHuffmanMemory(.dc0, chrominance: false)
        if status != .ok { return status }
        status = setDCHuffmanMemory(.dc1, chrominance: true)
        return status
    }
    func setQuantizationMemory(_ source: UnsafePointer<UInt8>, table: JPEGTable) -> UInt32 {
        let scale: UInt32
        if handle.read(.imageQuality) >= 50 && handle.read(.imageQuality) <= 100 { scale = 200 &- (handle.read(.imageQuality) &* 2) }
        else if handle.read(.imageQuality) > 0 { scale = 5000 / handle.read(.imageQuality) }
        else { return 1 }
        var i = 0, address = 0
        while i < 61 {
            var row: UInt32 = 0
            for j in 0..<4 {
                var value = ((UInt32(source[JPEGDefaultTables.zigzag[i + j]]) &* scale) &+ 50) / 100
                if value == 0 { value = 1 }
                else if value > 255 { value = 255 }
                row |= (value & 0xFF) << (8 * j)
            }
            i += 4; registers.writeTable(table, index: address, value: row); address += 1
        }
        return 0
    }
    func getQuality() -> UInt32 {
        var quality: UInt32 = 0, i = 0, address = 0
        while i < 61 {
            let row = registers.readTable(.quantization0, index: address)
            for j in 0..<4 {
                let value = (row >> (8 * j)) & 0xFF
                if value == 1 { quality &+= 100 }
                else {
                    let scale = (value * 100) / UInt32(handle.readQuantizationTable(0)![JPEGDefaultTables.zigzag[i + j]])
                    if scale <= 100 { quality &+= (200 - scale) / 2 }
                    else { quality &+= 5000 / scale }
                }
            }
            i += 4; address += 1
        }
        return quality / 64
    }
}
