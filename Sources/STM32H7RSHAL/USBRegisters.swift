// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// USB register offsets from CMSIS stm32h7s3xx.h at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

public struct USBRegister: RawRepresentable, Equatable, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let gotgctl = Self(rawValue: 0x0)
  public static let gotgint = Self(rawValue: 0x4)
  public static let gahbcfg = Self(rawValue: 0x8)
  public static let gusbcfg = Self(rawValue: 0xC)
  public static let grstctl = Self(rawValue: 0x10)
  public static let gintsts = Self(rawValue: 0x14)
  public static let gintmsk = Self(rawValue: 0x18)
  public static let grxstsr = Self(rawValue: 0x1C)
  public static let grxstsp = Self(rawValue: 0x20)
  public static let grxfsiz = Self(rawValue: 0x24)
  public static let dieptxf0_hnptxfsiz = Self(rawValue: 0x28)
  public static let hnptxsts = Self(rawValue: 0x2C)
  public static let gccfg = Self(rawValue: 0x38)
  public static let cid = Self(rawValue: 0x3C)
  public static let gsnpsid = Self(rawValue: 0x40)
  public static let ghwcfg1 = Self(rawValue: 0x44)
  public static let ghwcfg2 = Self(rawValue: 0x48)
  public static let ghwcfg3 = Self(rawValue: 0x4C)
  public static let glpmcfg = Self(rawValue: 0x54)
  public static let gpwrdn = Self(rawValue: 0x58)
  public static let gdfifocfg = Self(rawValue: 0x5C)
  public static let gadpctl = Self(rawValue: 0x60)
  public static let hptxfsiz = Self(rawValue: 0x100)
  public static func dieptxf(_ index: UInt32) -> Self { Self(rawValue: 0x104 &+ index &* 4) }
  public static let dcfg = Self(rawValue: 0x800)
  public static let dctl = Self(rawValue: 0x804)
  public static let dsts = Self(rawValue: 0x808)
  public static let diepmsk = Self(rawValue: 0x810)
  public static let doepmsk = Self(rawValue: 0x814)
  public static let daint = Self(rawValue: 0x818)
  public static let daintmsk = Self(rawValue: 0x81C)
  public static let dvbusdis = Self(rawValue: 0x828)
  public static let dvbuspulse = Self(rawValue: 0x82C)
  public static let dthrctl = Self(rawValue: 0x830)
  public static let diepempmsk = Self(rawValue: 0x834)
  public static let deachint = Self(rawValue: 0x838)
  public static let deachmsk = Self(rawValue: 0x83C)
  public static let dinep1msk = Self(rawValue: 0x844)
  public static let doutep1msk = Self(rawValue: 0x884)
  public static func diepctl(_ index: UInt32) -> Self { Self(rawValue: 0x900 &+ index &* 0x20) }
  public static func diepint(_ index: UInt32) -> Self { Self(rawValue: 0x908 &+ index &* 0x20) }
  public static func dieptsiz(_ index: UInt32) -> Self { Self(rawValue: 0x910 &+ index &* 0x20) }
  public static func diepdma(_ index: UInt32) -> Self { Self(rawValue: 0x914 &+ index &* 0x20) }
  public static func dtxfsts(_ index: UInt32) -> Self { Self(rawValue: 0x918 &+ index &* 0x20) }
  public static func doepctl(_ index: UInt32) -> Self { Self(rawValue: 0xB00 &+ index &* 0x20) }
  public static func doepint(_ index: UInt32) -> Self { Self(rawValue: 0xB08 &+ index &* 0x20) }
  public static func doeptsiz(_ index: UInt32) -> Self { Self(rawValue: 0xB10 &+ index &* 0x20) }
  public static func doepdma(_ index: UInt32) -> Self { Self(rawValue: 0xB14 &+ index &* 0x20) }
  public static let hcfg = Self(rawValue: 0x400)
  public static let hfir = Self(rawValue: 0x404)
  public static let hfnum = Self(rawValue: 0x408)
  public static let hptxsts = Self(rawValue: 0x410)
  public static let haint = Self(rawValue: 0x414)
  public static let haintmsk = Self(rawValue: 0x418)
  public static func hcchar(_ index: UInt32) -> Self { Self(rawValue: 0x500 &+ index &* 0x20) }
  public static func hcsplt(_ index: UInt32) -> Self { Self(rawValue: 0x504 &+ index &* 0x20) }
  public static func hcint(_ index: UInt32) -> Self { Self(rawValue: 0x508 &+ index &* 0x20) }
  public static func hcintmsk(_ index: UInt32) -> Self { Self(rawValue: 0x50C &+ index &* 0x20) }
  public static func hctsiz(_ index: UInt32) -> Self { Self(rawValue: 0x510 &+ index &* 0x20) }
  public static func hcdma(_ index: UInt32) -> Self { Self(rawValue: 0x514 &+ index &* 0x20) }
  public static let pcgcctl = Self(rawValue: 0xE00)
  public static let hprt0 = Self(rawValue: 0x440)
  public static func dfifo(_ index: UInt32) -> Self { Self(rawValue: 0x1000 &+ index &* 0x1000) }
}
public protocol USBRegisterIO {
  func delayAfterAHBIdle()
  var isHighSpeedInstance: Bool { get }
  func read(_ register: USBRegister) -> UInt32
  func write(_ register: USBRegister, value: UInt32)
}
