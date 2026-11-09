// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public struct LL_UCPD_InitTypeDef: Equatable, Sendable {
    public var psc_ucpdclk: UInt32
    public var transwin: UInt32
    public var IfrGap: UInt32
    public var HbitClockDiv: UInt32
    public init(psc_ucpdclk: UInt32 = 0, transwin: UInt32 = 0, IfrGap: UInt32 = 0, HbitClockDiv: UInt32 = 0) {
        self.psc_ucpdclk = psc_ucpdclk
        self.transwin = transwin
        self.IfrGap = IfrGap
        self.HbitClockDiv = HbitClockDiv
    }
}
