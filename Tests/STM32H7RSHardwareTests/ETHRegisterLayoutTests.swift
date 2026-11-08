import STM32H7RSHAL
import XCTest

@testable import STM32H7RSHardware

#if STM32H7R
  import STM32H7R
#else
  import STM32H7S
#endif
final class ETHRegisterLayoutTests: XCTestCase {
  func testCMSISAndSVDAddresses() {
    let io = STM32ETHRegisters()
    XCTAssertEqual(io.address(of: .maccr), 0x4002_8000)
    XCTAssertEqual(io.address(of: .dmaccr), 0x4002_9100)
    XCTAssertEqual(UInt(io.address(of: .dmaccr)), eth.dmaccr.unsafeAddress)
    XCTAssertEqual(io.address(of: .dmacier), 0x4002_9134)
    XCTAssertEqual(UInt(io.address(of: .dmacier)), eth.dmacier.unsafeAddress)
    XCTAssertEqual(io.address(of: .dmacrcr), 0x4002_9108)
    XCTAssertEqual(UInt(io.address(of: .dmacrcr)), eth.dmacrxcr.unsafeAddress)
    XCTAssertEqual(io.address(of: .dmacrdlar), 0x4002_911c)
    XCTAssertEqual(UInt(io.address(of: .dmacrdlar)), eth.dmacrxdlar.unsafeAddress)
    XCTAssertEqual(io.address(of: .dmacrdrlr), 0x4002_9130)
    XCTAssertEqual(UInt(io.address(of: .dmacrdrlr)), eth.dmacrxrlr.unsafeAddress)
    XCTAssertEqual(io.address(of: .dmacrdtpr), 0x4002_9128)
    XCTAssertEqual(UInt(io.address(of: .dmacrdtpr)), eth.dmacrxdtpr.unsafeAddress)
    XCTAssertEqual(io.address(of: .dmacsr), 0x4002_9160)
    XCTAssertEqual(UInt(io.address(of: .dmacsr)), eth.dmacsr.unsafeAddress)
    XCTAssertEqual(io.address(of: .dmactcr), 0x4002_9104)
    XCTAssertEqual(UInt(io.address(of: .dmactcr)), eth.dmactxcr.unsafeAddress)
    XCTAssertEqual(io.address(of: .dmactdlar), 0x4002_9114)
    XCTAssertEqual(UInt(io.address(of: .dmactdlar)), eth.dmactxdlar.unsafeAddress)
    XCTAssertEqual(io.address(of: .dmactdrlr), 0x4002_912c)
    XCTAssertEqual(UInt(io.address(of: .dmactdrlr)), eth.dmactxrlr.unsafeAddress)
    XCTAssertEqual(io.address(of: .dmactdtpr), 0x4002_9120)
    XCTAssertEqual(UInt(io.address(of: .dmactdtpr)), eth.dmactxdtpr.unsafeAddress)
    XCTAssertEqual(io.address(of: .dmamr), 0x4002_9000)
    XCTAssertEqual(UInt(io.address(of: .dmamr)), eth.dmamr.unsafeAddress)
    XCTAssertEqual(io.address(of: .dmasbmr), 0x4002_9004)
    XCTAssertEqual(UInt(io.address(of: .dmasbmr)), eth.dmasbmr.unsafeAddress)
    XCTAssertEqual(io.address(of: .mac1ustcr), 0x4002_80dc)
    XCTAssertEqual(UInt(io.address(of: .mac1ustcr)), eth.mac1ustcr.unsafeAddress)
    XCTAssertEqual(io.address(of: .maca0hr), 0x4002_8300)
    XCTAssertEqual(UInt(io.address(of: .maca0hr)), eth.maca0hr.unsafeAddress)
    XCTAssertEqual(io.address(of: .maca0lr), 0x4002_8304)
    XCTAssertEqual(UInt(io.address(of: .maca0lr)), eth.maca0lr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macarpar), 0x4002_8210)
    XCTAssertEqual(UInt(io.address(of: .macarpar)), eth.macarpar.unsafeAddress)
    XCTAssertEqual(io.address(of: .maccr), 0x4002_8000)
    XCTAssertEqual(UInt(io.address(of: .maccr)), eth.maccr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macecr), 0x4002_8004)
    XCTAssertEqual(UInt(io.address(of: .macecr)), eth.macecr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macht0r), 0x4002_8010)
    XCTAssertEqual(UInt(io.address(of: .macht0r)), eth.macht0r.unsafeAddress)
    XCTAssertEqual(io.address(of: .macht1r), 0x4002_8014)
    XCTAssertEqual(UInt(io.address(of: .macht1r)), eth.macht1r.unsafeAddress)
    XCTAssertEqual(io.address(of: .macier), 0x4002_80b4)
    XCTAssertEqual(UInt(io.address(of: .macier)), eth.macier.unsafeAddress)
    XCTAssertEqual(io.address(of: .macisr), 0x4002_80b0)
    XCTAssertEqual(UInt(io.address(of: .macisr)), eth.macisr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macivir), 0x4002_8064)
    XCTAssertEqual(UInt(io.address(of: .macivir)), eth.macivir.unsafeAddress)
    XCTAssertEqual(io.address(of: .macl3a0r0r), 0x4002_8910)
    XCTAssertEqual(UInt(io.address(of: .macl3a0r0r)), eth.macl3a00r.unsafeAddress)
    XCTAssertEqual(io.address(of: .macl3a0r1r), 0x4002_8940)
    XCTAssertEqual(UInt(io.address(of: .macl3a0r1r)), eth.macl3a01r.unsafeAddress)
    XCTAssertEqual(io.address(of: .macl3a1r0r), 0x4002_8914)
    XCTAssertEqual(UInt(io.address(of: .macl3a1r0r)), eth.macl3a10r.unsafeAddress)
    XCTAssertEqual(io.address(of: .macl3a1r1r), 0x4002_8944)
    XCTAssertEqual(UInt(io.address(of: .macl3a1r1r)), eth.macl3a11r.unsafeAddress)
    XCTAssertEqual(io.address(of: .macl3a2r0r), 0x4002_8918)
    XCTAssertEqual(UInt(io.address(of: .macl3a2r0r)), eth.macl3a20r.unsafeAddress)
    XCTAssertEqual(io.address(of: .macl3a2r1r), 0x4002_8948)
    XCTAssertEqual(UInt(io.address(of: .macl3a2r1r)), eth.macl3a21r.unsafeAddress)
    XCTAssertEqual(io.address(of: .macl3a3r0r), 0x4002_891c)
    XCTAssertEqual(UInt(io.address(of: .macl3a3r0r)), eth.macl3a30r.unsafeAddress)
    XCTAssertEqual(io.address(of: .macl3a3r1r), 0x4002_894c)
    XCTAssertEqual(UInt(io.address(of: .macl3a3r1r)), eth.macl3a31r.unsafeAddress)
    XCTAssertEqual(io.address(of: .macl3l4c0r), 0x4002_8900)
    XCTAssertEqual(UInt(io.address(of: .macl3l4c0r)), eth.macl3l4c0r.unsafeAddress)
    XCTAssertEqual(io.address(of: .macl3l4c1r), 0x4002_8930)
    XCTAssertEqual(UInt(io.address(of: .macl3l4c1r)), eth.macl3l4c1r.unsafeAddress)
    XCTAssertEqual(io.address(of: .macl4a0r), 0x4002_8904)
    XCTAssertEqual(UInt(io.address(of: .macl4a0r)), eth.macl4a0r.unsafeAddress)
    XCTAssertEqual(io.address(of: .macl4a1r), 0x4002_8934)
    XCTAssertEqual(UInt(io.address(of: .macl4a1r)), eth.macl4a1r.unsafeAddress)
    XCTAssertEqual(io.address(of: .maclcsr), 0x4002_80d0)
    XCTAssertEqual(UInt(io.address(of: .maclcsr)), eth.maclcsr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macmdioar), 0x4002_8200)
    XCTAssertEqual(UInt(io.address(of: .macmdioar)), eth.macmdioar.unsafeAddress)
    XCTAssertEqual(io.address(of: .macmdiodr), 0x4002_8204)
    XCTAssertEqual(UInt(io.address(of: .macmdiodr)), eth.macmdiodr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macpcsr), 0x4002_80c0)
    XCTAssertEqual(UInt(io.address(of: .macpcsr)), eth.macpcsr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macpfr), 0x4002_8008)
    XCTAssertEqual(UInt(io.address(of: .macpfr)), eth.macpfr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macrfcr), 0x4002_8090)
    XCTAssertEqual(UInt(io.address(of: .macrfcr)), eth.macrxfcr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macrwkpfr), 0x4002_80c4)
    XCTAssertEqual(UInt(io.address(of: .macrwkpfr)), eth.macrwkpfr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macrxtxsr), 0x4002_80b8)
    XCTAssertEqual(UInt(io.address(of: .macrxtxsr)), eth.macrxtxsr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macssir), 0x4002_8b04)
    XCTAssertEqual(UInt(io.address(of: .macssir)), eth.macssir.unsafeAddress)
    XCTAssertEqual(io.address(of: .macstnr), 0x4002_8b0c)
    XCTAssertEqual(UInt(io.address(of: .macstnr)), eth.macstnr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macstnur), 0x4002_8b14)
    XCTAssertEqual(UInt(io.address(of: .macstnur)), eth.macstnur.unsafeAddress)
    XCTAssertEqual(io.address(of: .macstsr), 0x4002_8b08)
    XCTAssertEqual(UInt(io.address(of: .macstsr)), eth.macstsr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macstsur), 0x4002_8b10)
    XCTAssertEqual(UInt(io.address(of: .macstsur)), eth.macstsur.unsafeAddress)
    XCTAssertEqual(io.address(of: .mactfcr), 0x4002_8070)
    XCTAssertEqual(UInt(io.address(of: .mactfcr)), eth.macqtxfcr.unsafeAddress)
    XCTAssertEqual(io.address(of: .mactsar), 0x4002_8b18)
    XCTAssertEqual(UInt(io.address(of: .mactsar)), eth.mactsar.unsafeAddress)
    XCTAssertEqual(io.address(of: .mactscr), 0x4002_8b00)
    XCTAssertEqual(UInt(io.address(of: .mactscr)), eth.mactscr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macvhtr), 0x4002_8058)
    XCTAssertEqual(UInt(io.address(of: .macvhtr)), eth.macvhtr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macvir), 0x4002_8060)
    XCTAssertEqual(UInt(io.address(of: .macvir)), eth.macvir.unsafeAddress)
    XCTAssertEqual(io.address(of: .macvtr), 0x4002_8050)
    XCTAssertEqual(UInt(io.address(of: .macvtr)), eth.macvtr.unsafeAddress)
    XCTAssertEqual(io.address(of: .macwtr), 0x4002_800c)
    XCTAssertEqual(UInt(io.address(of: .macwtr)), eth.macwtr.unsafeAddress)
    XCTAssertEqual(io.address(of: .mmcrimr), 0x4002_870c)
    XCTAssertEqual(UInt(io.address(of: .mmcrimr)), eth.mmc_rx_interrupt_mask.unsafeAddress)
    XCTAssertEqual(io.address(of: .mmctimr), 0x4002_8710)
    XCTAssertEqual(UInt(io.address(of: .mmctimr)), eth.mmc_tx_interrupt_mask.unsafeAddress)
    XCTAssertEqual(io.address(of: .mtlrqomr), 0x4002_8d30)
    XCTAssertEqual(UInt(io.address(of: .mtlrqomr)), eth.mtlrxqomr.unsafeAddress)
    XCTAssertEqual(io.address(of: .mtltqomr), 0x4002_8d00)
    XCTAssertEqual(UInt(io.address(of: .mtltqomr)), eth.mtltxqomr.unsafeAddress)
  }
  func testHandleStorageAndTimestampAliases() {
    let w = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 25)
    w.initialize(repeating: 0xA55A_A55A)
    let p = UnsafeMutableBufferPointer<UnsafeMutableRawPointer?>.allocate(capacity: 8)
    p.initialize(repeating: nil)
    let tx = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 4)
    tx.initialize(repeating: 0)
    let rx = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 4)
    rx.initialize(repeating: 0)
    let packets = UnsafeMutableBufferPointer<UnsafeMutablePointer<UInt32>?>.allocate(capacity: 4)
    packets.initialize(repeating: nil)
    defer {
      w.deallocate()
      p.deallocate()
      tx.deallocate()
      rx.deallocate()
      packets.deallocate()
    }
    let io = STM32ETHHandleRegisters(
      words: .init(rebasing: w[1..<24]), pointers: .init(rebasing: p[1..<7]),
      transmitDescriptors: tx, receiveDescriptors: rx, transmitPackets: packets)
    for field in ETHHandleWord.allCases {
      io.write(field, value: UInt32(field.rawValue))
      XCTAssertEqual(io.read(field), UInt32(field.rawValue))
    }
    for field in ETHHandlePointer.allCases {
      let ptr = UnsafeMutableRawPointer(w.baseAddress! + field.rawValue)
      io.writePointer(field, value: ptr)
      XCTAssertEqual(io.readPointer(field), ptr)
      io.pointerStorage(field).pointee = nil
      XCTAssertNil(io.readPointer(field))
    }
    for ring in ETHDescriptorRing.allCases {
      for index: UInt32 in 0..<4 {
        io.writeDescriptorAddress(ring, index: index, value: 0x2400_0000 + index * 24)
        XCTAssertEqual(io.descriptorAddress(ring, index: index), 0x2400_0000 + index * 24)
      }
    }
    for index: UInt32 in 0..<4 {
      io.writeTransmitPacket(index: index, value: w.baseAddress! + Int(index))
      XCTAssertEqual(io.transmitPacket(index: index), w.baseAddress! + Int(index))
    }
    io.transmitTimestampWords()[0] = 0x1234
    io.transmitTimestampWords()[1] = 0x5678
    XCTAssertEqual(io.read(.transmitTimestampLow), 0x1234)
    XCTAssertEqual(io.read(.transmitTimestampHigh), 0x5678)
    XCTAssertEqual(w[0], 0xA55A_A55A)
    XCTAssertEqual(w[24], 0xA55A_A55A)
    XCTAssertNil(p[0])
    XCTAssertNil(p[7])
  }
  func testCallbackStorageUsesReservedSlotAndNativeWidth() {
    let p = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 15)
    p.initialize(repeating: 0)
    p[0] = 1
    p[14] = 2
    p[6] = 3
    defer { p.deallocate() }
    let io = STM32ETHCallbackRegisters(storage: .init(rebasing: p[1..<14]))
    let cb: ETHCallback = { _ in }
    for id in ETHCallbackID.allCases {
      io.write(id, value: cb)
      XCTAssertEqual(unsafeBitCast(io.read(id)!, to: UInt.self), unsafeBitCast(cb, to: UInt.self))
      io.write(id, value: nil)
      XCTAssertNil(io.read(id))
    }
    let allocate: ETHReceiveAllocateCallback = { _ in }
    let link: ETHReceiveLinkCallback = { _, _, _, _ in }
    let free: ETHTransmitFreeCallback = { _ in }
    let ptp: ETHTransmitPTPCallback = { _, _ in }
    io.writeReceiveAllocate(allocate)
    io.writeReceiveLink(link)
    io.writeTransmitFree(free)
    io.writeTransmitPTP(ptp)
    XCTAssertEqual(
      unsafeBitCast(io.readReceiveAllocate()!, to: UInt.self),
      unsafeBitCast(allocate, to: UInt.self))
    XCTAssertEqual(
      unsafeBitCast(io.readReceiveLink()!, to: UInt.self), unsafeBitCast(link, to: UInt.self))
    XCTAssertEqual(
      unsafeBitCast(io.readTransmitFree()!, to: UInt.self), unsafeBitCast(free, to: UInt.self))
    XCTAssertEqual(
      unsafeBitCast(io.readTransmitPTP()!, to: UInt.self), unsafeBitCast(ptp, to: UInt.self))
    io.writeReceiveAllocate(nil)
    io.writeReceiveLink(nil)
    io.writeTransmitFree(nil)
    io.writeTransmitPTP(nil)
    XCTAssertNil(io.readReceiveAllocate())
    XCTAssertNil(io.readReceiveLink())
    XCTAssertNil(io.readTransmitFree())
    XCTAssertNil(io.readTransmitPTP())
    XCTAssertEqual(p[0], 1)
    XCTAssertEqual(p[6], 3)
    XCTAssertEqual(p[14], 2)
  }
}
