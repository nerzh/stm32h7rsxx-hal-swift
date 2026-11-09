// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_RTC_FORMAT_BIN: UInt32 = 0x0000_0000
public let LL_RTC_FORMAT_BCD: UInt32 = 0x0000_0001
public let LL_RTC_ALMA_DATEWEEKDAYSEL_DATE: UInt32 = 0x0000_0000
public let LL_RTC_ALMA_DATEWEEKDAYSEL_WEEKDAY: UInt32 = 0x4000_0000
public let LL_RTC_ALMB_DATEWEEKDAYSEL_DATE: UInt32 = 0x0000_0000
public let LL_RTC_ALMB_DATEWEEKDAYSEL_WEEKDAY: UInt32 = 0x4000_0000
public let LL_RTC_SCR_SSRUF: UInt32 = 0x0000_0040
public let LL_RTC_SCR_ITSF: UInt32 = 0x0000_0020
public let LL_RTC_SCR_TSOVF: UInt32 = 0x0000_0010
public let LL_RTC_SCR_TSF: UInt32 = 0x0000_0008
public let LL_RTC_SCR_WUTF: UInt32 = 0x0000_0004
public let LL_RTC_SCR_ALRBF: UInt32 = 0x0000_0002
public let LL_RTC_SCR_ALRAF: UInt32 = 0x0000_0001
public let LL_RTC_ICSR_RECALPF: UInt32 = 0x0001_0000
public let LL_RTC_ICSR_BCDU_2: UInt32 = 0x0000_1000
public let LL_RTC_ICSR_BCDU_1: UInt32 = 0x0000_0800
public let LL_RTC_ICSR_BCDU_0: UInt32 = 0x0000_0400
public let LL_RTC_ICSR_BIN_1: UInt32 = 0x0000_0200
public let LL_RTC_ICSR_BIN_0: UInt32 = 0x0000_0100
public let LL_RTC_ICSR_INITF: UInt32 = 0x0000_0040
public let LL_RTC_ICSR_RSF: UInt32 = 0x0000_0020
public let LL_RTC_ICSR_INITS: UInt32 = 0x0000_0010
public let LL_RTC_ICSR_SHPF: UInt32 = 0x0000_0008
public let LL_RTC_ICSR_WUTWF: UInt32 = 0x0000_0004
public let LL_RTC_CR_TSIE: UInt32 = 0x0000_8000
public let LL_RTC_CR_WUTIE: UInt32 = 0x0000_4000
public let LL_RTC_CR_ALRBIE: UInt32 = 0x0000_2000
public let LL_RTC_CR_ALRAIE: UInt32 = 0x0000_1000
public let LL_RTC_WEEKDAY_MONDAY: UInt32 = 0x0000_0001
public let LL_RTC_WEEKDAY_TUESDAY: UInt32 = 0x0000_0002
public let LL_RTC_WEEKDAY_WEDNESDAY: UInt32 = 0x0000_0003
public let LL_RTC_WEEKDAY_THURSDAY: UInt32 = 0x0000_0004
public let LL_RTC_WEEKDAY_FRIDAY: UInt32 = 0x0000_0005
public let LL_RTC_WEEKDAY_SATURDAY: UInt32 = 0x0000_0006
public let LL_RTC_WEEKDAY_SUNDAY: UInt32 = 0x0000_0007
public let LL_RTC_MONTH_JANUARY: UInt32 = 0x0000_0001
public let LL_RTC_MONTH_FEBRUARY: UInt32 = 0x0000_0002
public let LL_RTC_MONTH_MARCH: UInt32 = 0x0000_0003
public let LL_RTC_MONTH_APRIL: UInt32 = 0x0000_0004
public let LL_RTC_MONTH_MAY: UInt32 = 0x0000_0005
public let LL_RTC_MONTH_JUNE: UInt32 = 0x0000_0006
public let LL_RTC_MONTH_JULY: UInt32 = 0x0000_0007
public let LL_RTC_MONTH_AUGUST: UInt32 = 0x0000_0008
public let LL_RTC_MONTH_SEPTEMBER: UInt32 = 0x0000_0009
public let LL_RTC_MONTH_OCTOBER: UInt32 = 0x0000_0010
public let LL_RTC_MONTH_NOVEMBER: UInt32 = 0x0000_0011
public let LL_RTC_MONTH_DECEMBER: UInt32 = 0x0000_0012
public let LL_RTC_HOURFORMAT_24HOUR: UInt32 = 0x0000_0000
public let LL_RTC_HOURFORMAT_AMPM: UInt32 = 0x0000_0040
public let LL_RTC_ALARMOUT_DISABLE: UInt32 = 0x0000_0000
public let LL_RTC_ALARMOUT_ALMA: UInt32 = 0x0020_0000
public let LL_RTC_ALARMOUT_ALMB: UInt32 = 0x0040_0000
public let LL_RTC_ALARMOUT_WAKEUP: UInt32 = 0x0060_0000
public let LL_RTC_ALARM_OUTPUTTYPE_PUSHPULL: UInt32 = 0x0000_0000
public let LL_RTC_ALARM_OUTPUTTYPE_OPENDRAIN: UInt32 = 0x4000_0000
public let LL_RTC_OUTPUTPOLARITY_PIN_HIGH: UInt32 = 0x0000_0000
public let LL_RTC_OUTPUTPOLARITY_PIN_LOW: UInt32 = 0x0010_0000
public let LL_RTC_TIME_FORMAT_AM_OR_24: UInt32 = 0x0000_0000
public let LL_RTC_TIME_FORMAT_PM: UInt32 = 0x0040_0000
public let LL_RTC_SHIFT_SECOND_DELAY: UInt32 = 0x0000_0000
public let LL_RTC_SHIFT_SECOND_ADVANCE: UInt32 = 0x8000_0000
public let LL_RTC_ALMA_MASK_NONE: UInt32 = 0x0000_0000
public let LL_RTC_ALMA_MASK_DATEWEEKDAY: UInt32 = 0x8000_0000
public let LL_RTC_ALMA_MASK_HOURS: UInt32 = 0x0080_0000
public let LL_RTC_ALMA_MASK_MINUTES: UInt32 = 0x0000_8000
public let LL_RTC_ALMA_MASK_SECONDS: UInt32 = 0x0000_0080
public let LL_RTC_ALMA_MASK_ALL: UInt32 = 0x8080_8080
public let LL_RTC_ALMA_TIME_FORMAT_AM: UInt32 = 0x0000_0000
public let LL_RTC_ALMA_TIME_FORMAT_PM: UInt32 = 0x0040_0000
public let LL_RTC_ALMA_SUBSECONDBIN_AUTOCLR_NO: UInt32 = 0x0000_0000
public let LL_RTC_ALMA_SUBSECONDBIN_AUTOCLR_YES: UInt32 = 0x8000_0000
public let LL_RTC_ALMB_MASK_NONE: UInt32 = 0x0000_0000
public let LL_RTC_ALMB_MASK_DATEWEEKDAY: UInt32 = 0x8000_0000
public let LL_RTC_ALMB_MASK_HOURS: UInt32 = 0x0080_0000
public let LL_RTC_ALMB_MASK_MINUTES: UInt32 = 0x0000_8000
public let LL_RTC_ALMB_MASK_SECONDS: UInt32 = 0x0000_0080
public let LL_RTC_ALMB_MASK_ALL: UInt32 = 0x8080_8080
public let LL_RTC_ALMB_TIME_FORMAT_AM: UInt32 = 0x0000_0000
public let LL_RTC_ALMB_TIME_FORMAT_PM: UInt32 = 0x0040_0000
public let LL_RTC_ALMB_SUBSECONDBIN_AUTOCLR_NO: UInt32 = 0x0000_0000
public let LL_RTC_ALMB_SUBSECONDBIN_AUTOCLR_YES: UInt32 = 0x8000_0000
public let LL_RTC_TIMESTAMP_EDGE_RISING: UInt32 = 0x0000_0000
public let LL_RTC_TIMESTAMP_EDGE_FALLING: UInt32 = 0x0000_0008
public let LL_RTC_TS_TIME_FORMAT_AM: UInt32 = 0x0000_0000
public let LL_RTC_TS_TIME_FORMAT_PM: UInt32 = 0x0040_0000
public let LL_RTC_TAMPER_1: UInt32 = 0x0000_0001
public let LL_RTC_TAMPER_2: UInt32 = 0x0000_0002
public let LL_RTC_TAMPER_3: UInt32 = 0x0000_0004
public let LL_RTC_TAMPER_4: UInt32 = 0x0000_0008
public let LL_RTC_TAMPER_5: UInt32 = 0x0000_0010
public let LL_RTC_TAMPER_6: UInt32 = 0x0000_0020
public let LL_RTC_TAMPER_7: UInt32 = 0x0000_0040
public let LL_RTC_TAMPER_8: UInt32 = 0x0000_0080
public let LL_RTC_TAMPER_MASK_TAMPER1: UInt32 = 0x0001_0000
public let LL_RTC_TAMPER_MASK_TAMPER2: UInt32 = 0x0002_0000
public let LL_RTC_TAMPER_MASK_TAMPER3: UInt32 = 0x0004_0000
public let LL_RTC_TAMPER_NOERASE_TAMPER1: UInt32 = 0x0000_0001
public let LL_RTC_TAMPER_NOERASE_TAMPER2: UInt32 = 0x0000_0002
public let LL_RTC_TAMPER_NOERASE_TAMPER3: UInt32 = 0x0000_0004
public let LL_RTC_TAMPER_NOERASE_TAMPER4: UInt32 = 0x0000_0008
public let LL_RTC_TAMPER_NOERASE_TAMPER5: UInt32 = 0x0000_0010
public let LL_RTC_TAMPER_NOERASE_TAMPER6: UInt32 = 0x0000_0020
public let LL_RTC_TAMPER_NOERASE_TAMPER7: UInt32 = 0x0000_0040
public let LL_RTC_TAMPER_NOERASE_TAMPER8: UInt32 = 0x0000_0080
public let LL_RTC_TAMPER_DURATION_1RTCCLK: UInt32 = 0x0000_0000
public let LL_RTC_TAMPER_DURATION_2RTCCLK: UInt32 = 0x0000_0020
public let LL_RTC_TAMPER_DURATION_4RTCCLK: UInt32 = 0x0000_0040
public let LL_RTC_TAMPER_DURATION_8RTCCLK: UInt32 = 0x0000_0060
public let LL_RTC_TAMPER_FILTER_DISABLE: UInt32 = 0x0000_0000
public let LL_RTC_TAMPER_FILTER_2SAMPLE: UInt32 = 0x0000_0008
public let LL_RTC_TAMPER_FILTER_4SAMPLE: UInt32 = 0x0000_0010
public let LL_RTC_TAMPER_FILTER_8SAMPLE: UInt32 = 0x0000_0018
public let LL_RTC_TAMPER_SAMPLFREQDIV_32768: UInt32 = 0x0000_0000
public let LL_RTC_TAMPER_SAMPLFREQDIV_16384: UInt32 = 0x0000_0001
public let LL_RTC_TAMPER_SAMPLFREQDIV_8192: UInt32 = 0x0000_0002
public let LL_RTC_TAMPER_SAMPLFREQDIV_4096: UInt32 = 0x0000_0003
public let LL_RTC_TAMPER_SAMPLFREQDIV_2048: UInt32 = 0x0000_0004
public let LL_RTC_TAMPER_SAMPLFREQDIV_1024: UInt32 = 0x0000_0005
public let LL_RTC_TAMPER_SAMPLFREQDIV_512: UInt32 = 0x0000_0006
public let LL_RTC_TAMPER_SAMPLFREQDIV_256: UInt32 = 0x0000_0007
public let LL_RTC_TAMPER_ACTIVELEVEL_TAMP1: UInt32 = 0x0100_0000
public let LL_RTC_TAMPER_ACTIVELEVEL_TAMP2: UInt32 = 0x0200_0000
public let LL_RTC_TAMPER_ACTIVELEVEL_TAMP3: UInt32 = 0x0400_0000
public let LL_RTC_TAMPER_ACTIVELEVEL_TAMP4: UInt32 = 0x0800_0000
public let LL_RTC_TAMPER_ACTIVELEVEL_TAMP5: UInt32 = 0x1000_0000
public let LL_RTC_TAMPER_ACTIVELEVEL_TAMP6: UInt32 = 0x2000_0000
public let LL_RTC_TAMPER_ACTIVELEVEL_TAMP7: UInt32 = 0x4000_0000
public let LL_RTC_TAMPER_ACTIVELEVEL_TAMP8: UInt32 = 0x8000_0000
public let LL_RTC_TAMPER_ITAMP1: UInt32 = 0x0001_0000
public let LL_RTC_TAMPER_ITAMP2: UInt32 = 0x0002_0000
public let LL_RTC_TAMPER_ITAMP3: UInt32 = 0x0004_0000
public let LL_RTC_TAMPER_ITAMP4: UInt32 = 0x0008_0000
public let LL_RTC_TAMPER_ITAMP5: UInt32 = 0x0010_0000
public let LL_RTC_TAMPER_ITAMP6: UInt32 = 0x0020_0000
public let LL_RTC_TAMPER_ITAMP7: UInt32 = 0x0040_0000
public let LL_RTC_TAMPER_ITAMP8: UInt32 = 0x0080_0000
public let LL_RTC_TAMPER_ITAMP9: UInt32 = 0x0100_0000
public let LL_RTC_TAMPER_ITAMP11: UInt32 = 0x0400_0000
public let LL_RTC_TAMPER_ITAMP15: UInt32 = 0x4000_0000
public let LL_RTC_TAMPER_NOERASE_ITAMPER1: UInt32 = 0x0000_0001
public let LL_RTC_TAMPER_NOERASE_ITAMPER2: UInt32 = 0x0000_0002
public let LL_RTC_TAMPER_NOERASE_ITAMPER3: UInt32 = 0x0000_0004
public let LL_RTC_TAMPER_NOERASE_ITAMPER4: UInt32 = 0x0000_0008
public let LL_RTC_TAMPER_NOERASE_ITAMPER5: UInt32 = 0x0000_0010
public let LL_RTC_TAMPER_NOERASE_ITAMPER6: UInt32 = 0x0000_0020
public let LL_RTC_TAMPER_NOERASE_ITAMPER7: UInt32 = 0x0000_0040
public let LL_RTC_TAMPER_NOERASE_ITAMPER8: UInt32 = 0x0000_0080
public let LL_RTC_TAMPER_NOERASE_ITAMPER9: UInt32 = 0x0000_0100
public let LL_RTC_TAMPER_NOERASE_ITAMPER11: UInt32 = 0x0000_0400
public let LL_RTC_TAMPER_NOERASE_ITAMPER15: UInt32 = 0x0000_4000
public let LL_RTC_TAMPER_ATAMP_TAMP1AM: UInt32 = 0x0000_0001
public let LL_RTC_TAMPER_ATAMP_TAMP2AM: UInt32 = 0x0000_0002
public let LL_RTC_TAMPER_ATAMP_TAMP3AM: UInt32 = 0x0000_0004
public let LL_RTC_TAMPER_ATAMP_TAMP4AM: UInt32 = 0x0000_0008
public let LL_RTC_TAMPER_ATAMP_TAMP5AM: UInt32 = 0x0000_0010
public let LL_RTC_TAMPER_ATAMP_TAMP6AM: UInt32 = 0x0000_0020
public let LL_RTC_TAMPER_ATAMP_TAMP7AM: UInt32 = 0x0000_0040
public let LL_RTC_TAMPER_ATAMP_TAMP8AM: UInt32 = 0x0000_0080
public let LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK: UInt32 = 0x0000_0000
public let LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_2: UInt32 = 0x0001_0000
public let LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_4: UInt32 = 0x0002_0000
public let LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_8: UInt32 = 0x0003_0000
public let LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_16: UInt32 = 0x0004_0000
public let LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_32: UInt32 = 0x0005_0000
public let LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_64: UInt32 = 0x0006_0000
public let LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_128: UInt32 = 0x0007_0000
public let LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_2048: UInt32 = 0x000B_0000
public let LL_RTC_TAMPER_ATAMP1IN_ATAMP1OUT: UInt32 = 0x0000_0000
public let LL_RTC_TAMPER_ATAMP1IN_ATAMP2OUT: UInt32 = 0x0000_0100
public let LL_RTC_TAMPER_ATAMP1IN_ATAMP3OUT: UInt32 = 0x0000_0200
public let LL_RTC_TAMPER_ATAMP1IN_ATAMP4OUT: UInt32 = 0x0000_0300
public let LL_RTC_TAMPER_ATAMP1IN_ATAMP5OUT: UInt32 = 0x0000_0400
public let LL_RTC_TAMPER_ATAMP1IN_ATAMP6OUT: UInt32 = 0x0000_0500
public let LL_RTC_TAMPER_ATAMP1IN_ATAMP7OUT: UInt32 = 0x0000_0600
public let LL_RTC_TAMPER_ATAMP1IN_ATAMP8OUT: UInt32 = 0x0000_0700
public let LL_RTC_TAMPER_ATAMP2IN_ATAMP1OUT: UInt32 = 0x0000_0000
public let LL_RTC_TAMPER_ATAMP2IN_ATAMP2OUT: UInt32 = 0x0000_0800
public let LL_RTC_TAMPER_ATAMP2IN_ATAMP3OUT: UInt32 = 0x0000_1000
public let LL_RTC_TAMPER_ATAMP2IN_ATAMP4OUT: UInt32 = 0x0000_1800
public let LL_RTC_TAMPER_ATAMP2IN_ATAMP5OUT: UInt32 = 0x0000_2000
public let LL_RTC_TAMPER_ATAMP2IN_ATAMP6OUT: UInt32 = 0x0000_2800
public let LL_RTC_TAMPER_ATAMP2IN_ATAMP7OUT: UInt32 = 0x0000_3000
public let LL_RTC_TAMPER_ATAMP2IN_ATAMP8OUT: UInt32 = 0x0000_3800
public let LL_RTC_TAMPER_ATAMP3IN_ATAMP1OUT: UInt32 = 0x0000_0000
public let LL_RTC_TAMPER_ATAMP3IN_ATAMP2OUT: UInt32 = 0x0000_4000
public let LL_RTC_TAMPER_ATAMP3IN_ATAMP3OUT: UInt32 = 0x0000_8000
public let LL_RTC_TAMPER_ATAMP3IN_ATAMP4OUT: UInt32 = 0x0000_C000
public let LL_RTC_TAMPER_ATAMP3IN_ATAMP5OUT: UInt32 = 0x0001_0000
public let LL_RTC_TAMPER_ATAMP3IN_ATAMP6OUT: UInt32 = 0x0001_4000
public let LL_RTC_TAMPER_ATAMP3IN_ATAMP7OUT: UInt32 = 0x0001_8000
public let LL_RTC_TAMPER_ATAMP3IN_ATAMP8OUT: UInt32 = 0x0001_C000
public let LL_RTC_TAMPER_ATAMP4IN_ATAMP1OUT: UInt32 = 0x0000_0000
public let LL_RTC_TAMPER_ATAMP4IN_ATAMP2OUT: UInt32 = 0x0002_0000
public let LL_RTC_TAMPER_ATAMP4IN_ATAMP3OUT: UInt32 = 0x0004_0000
public let LL_RTC_TAMPER_ATAMP4IN_ATAMP4OUT: UInt32 = 0x0006_0000
public let LL_RTC_TAMPER_ATAMP4IN_ATAMP5OUT: UInt32 = 0x0008_0000
public let LL_RTC_TAMPER_ATAMP4IN_ATAMP6OUT: UInt32 = 0x000A_0000
public let LL_RTC_TAMPER_ATAMP4IN_ATAMP7OUT: UInt32 = 0x000C_0000
public let LL_RTC_TAMPER_ATAMP4IN_ATAMP8OUT: UInt32 = 0x000E_0000
public let LL_RTC_TAMPER_ATAMP5IN_ATAMP1OUT: UInt32 = 0x0000_0000
public let LL_RTC_TAMPER_ATAMP5IN_ATAMP2OUT: UInt32 = 0x0010_0000
public let LL_RTC_TAMPER_ATAMP5IN_ATAMP3OUT: UInt32 = 0x0020_0000
public let LL_RTC_TAMPER_ATAMP5IN_ATAMP4OUT: UInt32 = 0x0030_0000
public let LL_RTC_TAMPER_ATAMP5IN_ATAMP5OUT: UInt32 = 0x0040_0000
public let LL_RTC_TAMPER_ATAMP5IN_ATAMP6OUT: UInt32 = 0x0050_0000
public let LL_RTC_TAMPER_ATAMP5IN_ATAMP7OUT: UInt32 = 0x0060_0000
public let LL_RTC_TAMPER_ATAMP5IN_ATAMP8OUT: UInt32 = 0x0070_0000
public let LL_RTC_TAMPER_ATAMP6IN_ATAMP1OUT: UInt32 = 0x0000_0000
public let LL_RTC_TAMPER_ATAMP6IN_ATAMP2OUT: UInt32 = 0x0080_0000
public let LL_RTC_TAMPER_ATAMP6IN_ATAMP3OUT: UInt32 = 0x0100_0000
public let LL_RTC_TAMPER_ATAMP6IN_ATAMP4OUT: UInt32 = 0x0180_0000
public let LL_RTC_TAMPER_ATAMP6IN_ATAMP5OUT: UInt32 = 0x0200_0000
public let LL_RTC_TAMPER_ATAMP6IN_ATAMP6OUT: UInt32 = 0x0280_0000
public let LL_RTC_TAMPER_ATAMP6IN_ATAMP7OUT: UInt32 = 0x0300_0000
public let LL_RTC_TAMPER_ATAMP6IN_ATAMP8OUT: UInt32 = 0x0380_0000
public let LL_RTC_TAMPER_ATAMP7IN_ATAMP1OUT: UInt32 = 0x0000_0000
public let LL_RTC_TAMPER_ATAMP7IN_ATAMP2OUT: UInt32 = 0x0400_0000
public let LL_RTC_TAMPER_ATAMP7IN_ATAMP3OUT: UInt32 = 0x0800_0000
public let LL_RTC_TAMPER_ATAMP7IN_ATAMP4OUT: UInt32 = 0x0C00_0000
public let LL_RTC_TAMPER_ATAMP7IN_ATAMP5OUT: UInt32 = 0x1000_0000
public let LL_RTC_TAMPER_ATAMP7IN_ATAMP6OUT: UInt32 = 0x1400_0000
public let LL_RTC_TAMPER_ATAMP7IN_ATAMP7OUT: UInt32 = 0x1800_0000
public let LL_RTC_TAMPER_ATAMP7IN_ATAMP8OUT: UInt32 = 0x1C00_0000
public let LL_RTC_TAMPER_ATAMP8IN_ATAMP1OUT: UInt32 = 0x0000_0000
public let LL_RTC_TAMPER_ATAMP8IN_ATAMP2OUT: UInt32 = 0x2000_0000
public let LL_RTC_TAMPER_ATAMP8IN_ATAMP3OUT: UInt32 = 0x4000_0000
public let LL_RTC_TAMPER_ATAMP8IN_ATAMP4OUT: UInt32 = 0x6000_0000
public let LL_RTC_TAMPER_ATAMP8IN_ATAMP5OUT: UInt32 = 0x8000_0000
public let LL_RTC_TAMPER_ATAMP8IN_ATAMP6OUT: UInt32 = 0xA000_0000
public let LL_RTC_TAMPER_ATAMP8IN_ATAMP7OUT: UInt32 = 0xC000_0000
public let LL_RTC_TAMPER_ATAMP8IN_ATAMP8OUT: UInt32 = 0xE000_0000
public let LL_RTC_BKP_DR0: UInt32 = 0x0000_0000
public let LL_RTC_BKP_DR1: UInt32 = 0x0000_0001
public let LL_RTC_BKP_DR2: UInt32 = 0x0000_0002
public let LL_RTC_BKP_DR3: UInt32 = 0x0000_0003
public let LL_RTC_BKP_DR4: UInt32 = 0x0000_0004
public let LL_RTC_BKP_DR5: UInt32 = 0x0000_0005
public let LL_RTC_BKP_DR6: UInt32 = 0x0000_0006
public let LL_RTC_BKP_DR7: UInt32 = 0x0000_0007
public let LL_RTC_BKP_DR8: UInt32 = 0x0000_0008
public let LL_RTC_BKP_DR9: UInt32 = 0x0000_0009
public let LL_RTC_BKP_DR10: UInt32 = 0x0000_000A
public let LL_RTC_BKP_DR11: UInt32 = 0x0000_000B
public let LL_RTC_BKP_DR12: UInt32 = 0x0000_000C
public let LL_RTC_BKP_DR13: UInt32 = 0x0000_000D
public let LL_RTC_BKP_DR14: UInt32 = 0x0000_000E
public let LL_RTC_BKP_DR15: UInt32 = 0x0000_000F
public let LL_RTC_BKP_DR16: UInt32 = 0x0000_0010
public let LL_RTC_BKP_DR17: UInt32 = 0x0000_0011
public let LL_RTC_BKP_DR18: UInt32 = 0x0000_0012
public let LL_RTC_BKP_DR19: UInt32 = 0x0000_0013
public let LL_RTC_BKP_DR20: UInt32 = 0x0000_0014
public let LL_RTC_BKP_DR21: UInt32 = 0x0000_0015
public let LL_RTC_BKP_DR22: UInt32 = 0x0000_0016
public let LL_RTC_BKP_DR23: UInt32 = 0x0000_0017
public let LL_RTC_BKP_DR24: UInt32 = 0x0000_0018
public let LL_RTC_BKP_DR25: UInt32 = 0x0000_0019
public let LL_RTC_BKP_DR26: UInt32 = 0x0000_001A
public let LL_RTC_BKP_DR27: UInt32 = 0x0000_001B
public let LL_RTC_BKP_DR28: UInt32 = 0x0000_001C
public let LL_RTC_BKP_DR29: UInt32 = 0x0000_001D
public let LL_RTC_BKP_DR30: UInt32 = 0x0000_001E
public let LL_RTC_BKP_DR31: UInt32 = 0x0000_001F
public let LL_RTC_WAKEUPCLOCK_DIV_16: UInt32 = 0x0000_0000
public let LL_RTC_WAKEUPCLOCK_DIV_8: UInt32 = 0x0000_0001
public let LL_RTC_WAKEUPCLOCK_DIV_4: UInt32 = 0x0000_0002
public let LL_RTC_WAKEUPCLOCK_DIV_2: UInt32 = 0x0000_0003
public let LL_RTC_WAKEUPCLOCK_CKSPRE: UInt32 = 0x0000_0004
public let LL_RTC_WAKEUPCLOCK_CKSPRE_WUT: UInt32 = 0x0000_0006
public let LL_RTC_CALIB_OUTPUT_NONE: UInt32 = 0x0000_0000
public let LL_RTC_CALIB_OUTPUT_1HZ: UInt32 = 0x0088_0000
public let LL_RTC_CALIB_OUTPUT_512HZ: UInt32 = 0x0080_0000
public let LL_RTC_CALIB_INSERTPULSE_NONE: UInt32 = 0x0000_0000
public let LL_RTC_CALIB_INSERTPULSE_SET: UInt32 = 0x0000_8000
public let LL_RTC_CALIB_PERIOD_32SEC: UInt32 = 0x0000_0000
public let LL_RTC_CALIB_PERIOD_16SEC: UInt32 = 0x0000_2000
public let LL_RTC_CALIB_PERIOD_8SEC: UInt32 = 0x0000_4000
public let LL_RTC_CALIB_LOWPOWER_NONE: UInt32 = 0x0000_0000
public let LL_RTC_CALIB_LOWPOWER_SET: UInt32 = 0x0000_1000
public let LL_RTC_BINARY_NONE: UInt32 = 0x0000_0000
public let LL_RTC_BINARY_ONLY: UInt32 = 0x0000_0100
public let LL_RTC_BINARY_MIX: UInt32 = 0x0000_0200
public let LL_RTC_BINARY_MIX_BCDU_0: UInt32 = 0x0000_0000
public let LL_RTC_BINARY_MIX_BCDU_1: UInt32 = 0x0000_0400
public let LL_RTC_BINARY_MIX_BCDU_2: UInt32 = 0x0000_0800
public let LL_RTC_BINARY_MIX_BCDU_3: UInt32 = 0x0000_0C00
public let LL_RTC_BINARY_MIX_BCDU_4: UInt32 = 0x0000_1000
public let LL_RTC_BINARY_MIX_BCDU_5: UInt32 = 0x0000_1400
public let LL_RTC_BINARY_MIX_BCDU_6: UInt32 = 0x0000_1800
public let LL_RTC_BINARY_MIX_BCDU_7: UInt32 = 0x0000_1C00
public let LL_RTC_PRIVILEGE_FULL_YES: UInt32 = 0x0000_8000
public let LL_RTC_PRIVILEGE_FULL_NO: UInt32 = 0x0000_0000
public let LL_RTC_PRIVILEGE_FEATURE_INIT: UInt32 = 0x0000_4000
public let LL_RTC_PRIVILEGE_FEATURE_CAL: UInt32 = 0x0000_2000
public let LL_RTC_PRIVILEGE_FEATURE_TS: UInt32 = 0x0000_0008
public let LL_RTC_PRIVILEGE_FEATURE_WUT: UInt32 = 0x0000_0004
public let LL_RTC_PRIVILEGE_FEATURE_ALRA: UInt32 = 0x0000_0001
public let LL_RTC_PRIVILEGE_FEATURE_ALRB: UInt32 = 0x0000_0002
public let LL_TAMP_PRIVILEGE_FULL_YES: UInt32 = 0x8000_0000
public let LL_TAMP_PRIVILEGE_FULL_NO: UInt32 = 0x0000_0000
public let LL_RTC_PRIVILEGE_BKUP_ZONE_NONE: UInt32 = 0x0000_0000
public let LL_RTC_PRIVILEGE_BKUP_ZONE_1: UInt32 = 0x2000_0000
public let LL_RTC_PRIVILEGE_BKUP_ZONE_2: UInt32 = 0x4000_0000
public let LL_RTC_PRIVILEGE_BKUP_ZONE_ALL: UInt32 = 0x6000_0000

public func LL_RTC_SetHourFormat<IO: RTCRegisterIO>(_ registers: IO, _ HourFormat: UInt32) {
    registers.write(RTCRegister.cr, value: (registers.read(RTCRegister.cr) & ~(0x40)) | (HourFormat))
}

public func LL_RTC_GetHourFormat<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.cr) & (0x40)))
}

public func LL_RTC_SetAlarmOutEvent<IO: RTCRegisterIO>(_ registers: IO, _ AlarmOutput: UInt32) {
    registers.write(RTCRegister.cr, value: (registers.read(RTCRegister.cr) & ~(0x600000)) | (AlarmOutput))
}

public func LL_RTC_GetAlarmOutEvent<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.cr) & (0x600000)))
}

public func LL_RTC_SetAlarmOutputType<IO: RTCRegisterIO>(_ registers: IO, _ Output: UInt32) {
    registers.write(RTCRegister.cr, value: (registers.read(RTCRegister.cr) & ~(0x4000_0000)) | (Output))
}

public func LL_RTC_GetAlarmOutputType<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.cr) & (0x4000_0000)))
}

public func LL_RTC_EnableInitMode<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.icsr, value: registers.read(RTCRegister.icsr) | (0x80))
}

public func LL_RTC_DisableInitMode<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.icsr, value: registers.read(RTCRegister.icsr) & ~(0x80))
}

public func LL_RTC_SetBinaryMode<IO: RTCRegisterIO>(_ registers: IO, _ BinaryMode: UInt32) {
    registers.write(RTCRegister.icsr, value: (registers.read(RTCRegister.icsr) & ~(0x300)) | (BinaryMode))
}

public func LL_RTC_GetBinaryMode<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.icsr) & (0x300)))
}

public func LL_RTC_SetBinMixBCDU<IO: RTCRegisterIO>(_ registers: IO, _ BinMixBcdU: UInt32) {
    registers.write(RTCRegister.icsr, value: (registers.read(RTCRegister.icsr) & ~(0x1c00)) | (BinMixBcdU))
}

public func LL_RTC_GetBinMixBCDU<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.icsr) & (0x1c00)))
}

public func LL_RTC_SetOutputPolarity<IO: RTCRegisterIO>(_ registers: IO, _ Polarity: UInt32) {
    registers.write(RTCRegister.cr, value: (registers.read(RTCRegister.cr) & ~(0x100000)) | (Polarity))
}

public func LL_RTC_GetOutputPolarity<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.cr) & (0x100000)))
}

public func LL_RTC_EnableShadowRegBypass<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x20))
}

public func LL_RTC_DisableShadowRegBypass<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x20))
}

public func LL_RTC_IsShadowRegBypassEnabled<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.cr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_RTC_EnableRefClock<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x10))
}

public func LL_RTC_DisableRefClock<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x10))
}

public func LL_RTC_SetAsynchPrescaler<IO: RTCRegisterIO>(_ registers: IO, _ AsynchPrescaler: UInt32) {
    registers.write(
        RTCRegister.prer, value: (registers.read(RTCRegister.prer) & ~(0x7f0000)) | (AsynchPrescaler << 0x10))
}

public func LL_RTC_SetSynchPrescaler<IO: RTCRegisterIO>(_ registers: IO, _ SynchPrescaler: UInt32) {
    registers.write(RTCRegister.prer, value: (registers.read(RTCRegister.prer) & ~(0x7fff)) | (SynchPrescaler))
}

public func LL_RTC_GetAsynchPrescaler<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.prer) & (0x7f0000)) >> 0x10)
}

public func LL_RTC_GetSynchPrescaler<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.prer) & (0x7fff)))
}

public func LL_RTC_EnableWriteProtection<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.wpr, value: 0xff)
}

public func LL_RTC_DisableWriteProtection<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.wpr, value: 0xca)
    registers.write(RTCRegister.wpr, value: 0x53)
}

public func LL_RTC_EnableTamperOutput<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x4000000))
}

public func LL_RTC_DisableTamperOutput<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x4000000))
}

public func LL_RTC_IsTamperOutputEnabled<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.cr) & (0x4000000)) == (0x4000000)) ? 1 : 0)
}

public func LL_RTC_EnableAlarmPullUp<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x2000_0000))
}

public func LL_RTC_DisableAlarmPullUp<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x2000_0000))
}

public func LL_RTC_IsAlarmPullUpEnabled<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.cr) & (0x2000_0000)) == (0x2000_0000)) ? 1 : 0)
}

public func LL_RTC_EnableOutput2<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x8000_0000))
}

public func LL_RTC_DisableOutput2<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x8000_0000))
}

public func LL_RTC_IsOutput2Enabled<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.cr) & (0x8000_0000)) == (0x8000_0000)) ? 1 : 0)
}

public func LL_RTC_TIME_SetFormat<IO: RTCRegisterIO>(_ registers: IO, _ TimeFormat: UInt32) {
    registers.write(RTCRegister.tr, value: (registers.read(RTCRegister.tr) & ~(0x400000)) | (TimeFormat))
}

public func LL_RTC_TIME_GetFormat<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.tr) & (0x400000)))
}

public func LL_RTC_TIME_SetHour<IO: RTCRegisterIO>(_ registers: IO, _ Hours: UInt32) {
    registers.write(
        RTCRegister.tr,
        value: (registers.read(RTCRegister.tr) & ~((0x300000 | 0xf0000)))
            | ((((Hours & 0xF0) << (0x14 &- 4)) | ((Hours & 0x0F) << 0x10))))
}

public func LL_RTC_TIME_GetHour<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.tr) & ((0x300000 | 0xf0000)))) >> 0x10)
}

public func LL_RTC_TIME_SetMinute<IO: RTCRegisterIO>(_ registers: IO, _ Minutes: UInt32) {
    registers.write(
        RTCRegister.tr,
        value: (registers.read(RTCRegister.tr) & ~((0x7000 | 0xf00)))
            | ((((Minutes & 0xF0) << (0xc &- 4)) | ((Minutes & 0x0F) << 0x8))))
}

public func LL_RTC_TIME_GetMinute<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.tr) & ((0x7000 | 0xf00))) >> 0x8)
}

public func LL_RTC_TIME_SetSecond<IO: RTCRegisterIO>(_ registers: IO, _ Seconds: UInt32) {
    registers.write(
        RTCRegister.tr,
        value: (registers.read(RTCRegister.tr) & ~((0x70 | 0xf)))
            | ((((Seconds & 0xF0) << (0x4 &- 4)) | ((Seconds & 0x0F) << 0x0))))
}

public func LL_RTC_TIME_GetSecond<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.tr) & ((0x70 | 0xf))) >> 0x0)
}

public func LL_RTC_TIME_Config<IO: RTCRegisterIO>(
    _ registers: IO, _ Format12_24: UInt32, _ Hours: UInt32, _ Minutes: UInt32, _ Seconds: UInt32
) {
    var temp: UInt32
    temp =
        Format12_24 | (((Hours & 0xF0) << (0x14 &- 4)) | ((Hours & 0x0F) << 0x10))
        | (((Minutes & 0xF0) << (0xc &- 4)) | ((Minutes & 0x0F) << 0x8))
        | (((Seconds & 0xF0) << (0x4 &- 4)) | ((Seconds & 0x0F) << 0x0))
    registers.write(
        RTCRegister.tr,
        value: (registers.read(RTCRegister.tr) & ~((0x400000 | 0x300000 | 0xf0000 | 0x7000 | 0xf00 | 0x70 | 0xf)))
            | (temp))
}

public func LL_RTC_TIME_Get<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    var temp: UInt32
    temp = (registers.read(RTCRegister.tr) & ((0x300000 | 0xf0000 | 0x7000 | 0xf00 | 0x70 | 0xf)))
    return
        ((((((temp & 0x300000) >> 0x14) << 4) | ((temp & 0xf0000) >> 0x10)) << 0x10)
        | (((((temp & 0x7000) >> 0xc) << 4) | ((temp & 0xf00) >> 0x8)) << 0x8)
        | ((((temp & 0x70) >> 0x4) << 4) | ((temp & 0xf) >> 0x0)))
}

public func LL_RTC_TIME_EnableDayLightStore<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x40000))
}

public func LL_RTC_TIME_DisableDayLightStore<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x40000))
}

public func LL_RTC_TIME_IsDayLightStoreEnabled<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.cr) & (0x40000)) == (0x40000)) ? 1 : 0)
}

public func LL_RTC_TIME_DecHour<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x20000))
}

public func LL_RTC_TIME_IncHour<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x10000))
}

public func LL_RTC_TIME_GetSubSecond<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.ssr) & (0xffff_ffff)))
}

public func LL_RTC_TIME_Synchronize<IO: RTCRegisterIO>(_ registers: IO, _ ShiftSecond: UInt32, _ Fraction: UInt32) {
    registers.write(RTCRegister.shiftr, value: ShiftSecond | Fraction)
}

public func LL_RTC_DATE_SetYear<IO: RTCRegisterIO>(_ registers: IO, _ Year: UInt32) {
    registers.write(
        RTCRegister.dr,
        value: (registers.read(RTCRegister.dr) & ~((0xf00000 | 0xf0000)))
            | ((((Year & 0xF0) << (0x14 &- 4)) | ((Year & 0x0F) << 0x10))))
}

public func LL_RTC_DATE_GetYear<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.dr) & ((0xf00000 | 0xf0000)))) >> 0x10)
}

public func LL_RTC_DATE_SetWeekDay<IO: RTCRegisterIO>(_ registers: IO, _ WeekDay: UInt32) {
    registers.write(RTCRegister.dr, value: (registers.read(RTCRegister.dr) & ~(0xe000)) | (WeekDay << 0xd))
}

public func LL_RTC_DATE_GetWeekDay<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.dr) & (0xe000)) >> 0xd)
}

public func LL_RTC_DATE_SetMonth<IO: RTCRegisterIO>(_ registers: IO, _ Month: UInt32) {
    registers.write(
        RTCRegister.dr,
        value: (registers.read(RTCRegister.dr) & ~((0x1000 | 0xf00)))
            | ((((Month & 0xF0) << (0xc &- 4)) | ((Month & 0x0F) << 0x8))))
}

public func LL_RTC_DATE_GetMonth<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.dr) & ((0x1000 | 0xf00)))) >> 0x8)
}

public func LL_RTC_DATE_SetDay<IO: RTCRegisterIO>(_ registers: IO, _ Day: UInt32) {
    registers.write(
        RTCRegister.dr,
        value: (registers.read(RTCRegister.dr) & ~((0x30 | 0xf)))
            | ((((Day & 0xF0) << (0x4 &- 4)) | ((Day & 0x0F) << 0x0))))
}

public func LL_RTC_DATE_GetDay<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.dr) & ((0x30 | 0xf)))) >> 0x0)
}

public func LL_RTC_DATE_Config<IO: RTCRegisterIO>(
    _ registers: IO, _ WeekDay: UInt32, _ Day: UInt32, _ Month: UInt32, _ Year: UInt32
) {
    var temp: UInt32
    temp =
        (WeekDay << 0xd) | (((Year & 0xF0) << (0x14 &- 4)) | ((Year & 0x0F) << 0x10))
        | (((Month & 0xF0) << (0xc &- 4)) | ((Month & 0x0F) << 0x8))
        | (((Day & 0xF0) << (0x4 &- 4)) | ((Day & 0x0F) << 0x0))
    registers.write(
        RTCRegister.dr,
        value: (registers.read(RTCRegister.dr) & ~((0xe000 | 0x1000 | 0xf00 | 0x30 | 0xf | 0xf00000 | 0xf0000)))
            | (temp))
}

public func LL_RTC_DATE_Get<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    var temp: UInt32
    temp = (registers.read(RTCRegister.dr) & ((0xe000 | 0x1000 | 0xf00 | 0x30 | 0xf | 0xf00000 | 0xf0000)))
    return
        ((((temp & 0xe000) >> 0xd) << 0x18) | (((((temp & 0x30) >> 0x4) << 4) | ((temp & 0xf) >> 0x0)) << 0x10)
        | (((((temp & 0x1000) >> 0xc) << 4) | ((temp & 0xf00) >> 0x8)) << 0x8)
        | ((((temp & 0xf00000) >> 0x14) << 4) | ((temp & 0xf0000) >> 0x10)))
}

public func LL_RTC_ALMA_Enable<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x100))
}

public func LL_RTC_ALMA_Disable<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x100))
}

public func LL_RTC_ALMA_SetMask<IO: RTCRegisterIO>(_ registers: IO, _ Mask: UInt32) {
    registers.write(
        RTCRegister.alrmar,
        value: (registers.read(RTCRegister.alrmar) & ~(0x8000_0000 | 0x800000 | 0x8000 | 0x80)) | (Mask))
}

public func LL_RTC_ALMA_GetMask<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.alrmar) & (0x8000_0000 | 0x800000 | 0x8000 | 0x80)))
}

public func LL_RTC_ALMA_EnableWeekday<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.alrmar, value: registers.read(RTCRegister.alrmar) | (0x4000_0000))
}

public func LL_RTC_ALMA_DisableWeekday<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.alrmar, value: registers.read(RTCRegister.alrmar) & ~(0x4000_0000))
}

public func LL_RTC_ALMA_SetDay<IO: RTCRegisterIO>(_ registers: IO, _ Day: UInt32) {
    registers.write(
        RTCRegister.alrmar,
        value: (registers.read(RTCRegister.alrmar) & ~((0x3000_0000 | 0xf000000)))
            | ((((Day & 0xF0) << (0x1c &- 4)) | ((Day & 0x0F) << 0x18))))
}

public func LL_RTC_ALMA_GetDay<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.alrmar) & ((0x3000_0000 | 0xf000000)))) >> 0x18)
}

public func LL_RTC_ALMA_SetWeekDay<IO: RTCRegisterIO>(_ registers: IO, _ WeekDay: UInt32) {
    registers.write(RTCRegister.alrmar, value: (registers.read(RTCRegister.alrmar) & ~(0xf000000)) | (WeekDay << 0x18))
}

public func LL_RTC_ALMA_GetWeekDay<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.alrmar) & (0xf000000)) >> 0x18)
}

public func LL_RTC_ALMA_SetTimeFormat<IO: RTCRegisterIO>(_ registers: IO, _ TimeFormat: UInt32) {
    registers.write(RTCRegister.alrmar, value: (registers.read(RTCRegister.alrmar) & ~(0x400000)) | (TimeFormat))
}

public func LL_RTC_ALMA_GetTimeFormat<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.alrmar) & (0x400000)))
}

public func LL_RTC_ALMA_SetHour<IO: RTCRegisterIO>(_ registers: IO, _ Hours: UInt32) {
    registers.write(
        RTCRegister.alrmar,
        value: (registers.read(RTCRegister.alrmar) & ~((0x300000 | 0xf0000)))
            | ((((Hours & 0xF0) << (0x14 &- 4)) | ((Hours & 0x0F) << 0x10))))
}

public func LL_RTC_ALMA_GetHour<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.alrmar) & ((0x300000 | 0xf0000)))) >> 0x10)
}

public func LL_RTC_ALMA_SetMinute<IO: RTCRegisterIO>(_ registers: IO, _ Minutes: UInt32) {
    registers.write(
        RTCRegister.alrmar,
        value: (registers.read(RTCRegister.alrmar) & ~((0x7000 | 0xf00)))
            | ((((Minutes & 0xF0) << (0xc &- 4)) | ((Minutes & 0x0F) << 0x8))))
}

public func LL_RTC_ALMA_GetMinute<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.alrmar) & ((0x7000 | 0xf00)))) >> 0x8)
}

public func LL_RTC_ALMA_SetSecond<IO: RTCRegisterIO>(_ registers: IO, _ Seconds: UInt32) {
    registers.write(
        RTCRegister.alrmar,
        value: (registers.read(RTCRegister.alrmar) & ~((0x70 | 0xf)))
            | ((((Seconds & 0xF0) << (0x4 &- 4)) | ((Seconds & 0x0F) << 0x0))))
}

public func LL_RTC_ALMA_GetSecond<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.alrmar) & ((0x70 | 0xf)))) >> 0x0)
}

public func LL_RTC_ALMA_ConfigTime<IO: RTCRegisterIO>(
    _ registers: IO, _ Format12_24: UInt32, _ Hours: UInt32, _ Minutes: UInt32, _ Seconds: UInt32
) {
    var temp: UInt32
    temp =
        Format12_24 | (((Hours & 0xF0) << (0x14 &- 4)) | ((Hours & 0x0F) << 0x10))
        | (((Minutes & 0xF0) << (0xc &- 4)) | ((Minutes & 0x0F) << 0x8))
        | (((Seconds & 0xF0) << (0x4 &- 4)) | ((Seconds & 0x0F) << 0x0))
    registers.write(
        RTCRegister.alrmar,
        value: (registers.read(RTCRegister.alrmar) & ~(0x400000 | 0x300000 | 0xf0000 | 0x7000 | 0xf00 | 0x70 | 0xf))
            | (temp))
}

public func LL_RTC_ALMA_GetTime<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return
        ((LL_RTC_ALMA_GetHour(registers) << 0x10) | (LL_RTC_ALMA_GetMinute(registers) << 0x8)
        | LL_RTC_ALMA_GetSecond(registers))
}

public func LL_RTC_ALMA_SetSubSecondMask<IO: RTCRegisterIO>(_ registers: IO, _ Mask: UInt32) {
    registers.write(
        RTCRegister.alrmassr, value: (registers.read(RTCRegister.alrmassr) & ~(0x3f00_0000)) | (Mask << 0x18))
}

public func LL_RTC_ALMA_GetSubSecondMask<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.alrmassr) & (0x3f00_0000)) >> 0x18)
}

public func LL_RTC_ALMA_SetBinAutoClr<IO: RTCRegisterIO>(_ registers: IO, _ BinaryAutoClr: UInt32) {
    registers.write(
        RTCRegister.alrmassr, value: (registers.read(RTCRegister.alrmassr) & ~(0x8000_0000)) | (BinaryAutoClr))
}

public func LL_RTC_ALMA_GetBinAutoClr<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.alrmassr) & (0x8000_0000)))
}

public func LL_RTC_ALMA_SetSubSecond<IO: RTCRegisterIO>(_ registers: IO, _ Subsecond: UInt32) {
    registers.write(RTCRegister.alrmassr, value: (registers.read(RTCRegister.alrmassr) & ~(0x7fff)) | (Subsecond))
}

public func LL_RTC_ALMA_GetSubSecond<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.alrmassr) & (0x7fff)))
}

public func LL_RTC_ALMB_Enable<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x200))
}

public func LL_RTC_ALMB_Disable<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x200))
}

public func LL_RTC_ALMB_SetMask<IO: RTCRegisterIO>(_ registers: IO, _ Mask: UInt32) {
    registers.write(
        RTCRegister.alrmbr,
        value: (registers.read(RTCRegister.alrmbr) & ~(0x8000_0000 | 0x800000 | 0x8000 | 0x80)) | (Mask))
}

public func LL_RTC_ALMB_GetMask<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.alrmbr) & (0x8000_0000 | 0x800000 | 0x8000 | 0x80)))
}

public func LL_RTC_ALMB_EnableWeekday<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.alrmbr, value: registers.read(RTCRegister.alrmbr) | (0x4000_0000))
}

public func LL_RTC_ALMB_DisableWeekday<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.alrmbr, value: registers.read(RTCRegister.alrmbr) & ~(0x4000_0000))
}

public func LL_RTC_ALMB_SetDay<IO: RTCRegisterIO>(_ registers: IO, _ Day: UInt32) {
    registers.write(
        RTCRegister.alrmbr,
        value: (registers.read(RTCRegister.alrmbr) & ~((0x3000_0000 | 0xf000000)))
            | ((((Day & 0xF0) << (0x1c &- 4)) | ((Day & 0x0F) << 0x18))))
}

public func LL_RTC_ALMB_GetDay<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.alrmbr) & ((0x3000_0000 | 0xf000000)))) >> 0x18)
}

public func LL_RTC_ALMB_SetWeekDay<IO: RTCRegisterIO>(_ registers: IO, _ WeekDay: UInt32) {
    registers.write(RTCRegister.alrmbr, value: (registers.read(RTCRegister.alrmbr) & ~(0xf000000)) | (WeekDay << 0x18))
}

public func LL_RTC_ALMB_GetWeekDay<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.alrmbr) & (0xf000000)) >> 0x18)
}

public func LL_RTC_ALMB_SetTimeFormat<IO: RTCRegisterIO>(_ registers: IO, _ TimeFormat: UInt32) {
    registers.write(RTCRegister.alrmbr, value: (registers.read(RTCRegister.alrmbr) & ~(0x400000)) | (TimeFormat))
}

public func LL_RTC_ALMB_GetTimeFormat<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.alrmbr) & (0x400000)))
}

public func LL_RTC_ALMB_SetHour<IO: RTCRegisterIO>(_ registers: IO, _ Hours: UInt32) {
    registers.write(
        RTCRegister.alrmbr,
        value: (registers.read(RTCRegister.alrmbr) & ~((0x300000 | 0xf0000)))
            | ((((Hours & 0xF0) << (0x14 &- 4)) | ((Hours & 0x0F) << 0x10))))
}

public func LL_RTC_ALMB_GetHour<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.alrmbr) & ((0x300000 | 0xf0000)))) >> 0x10)
}

public func LL_RTC_ALMB_SetMinute<IO: RTCRegisterIO>(_ registers: IO, _ Minutes: UInt32) {
    registers.write(
        RTCRegister.alrmbr,
        value: (registers.read(RTCRegister.alrmbr) & ~((0x7000 | 0xf00)))
            | ((((Minutes & 0xF0) << (0xc &- 4)) | ((Minutes & 0x0F) << 0x8))))
}

public func LL_RTC_ALMB_GetMinute<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.alrmbr) & ((0x7000 | 0xf00)))) >> 0x8)
}

public func LL_RTC_ALMB_SetSecond<IO: RTCRegisterIO>(_ registers: IO, _ Seconds: UInt32) {
    registers.write(
        RTCRegister.alrmbr,
        value: (registers.read(RTCRegister.alrmbr) & ~((0x70 | 0xf)))
            | ((((Seconds & 0xF0) << (0x4 &- 4)) | ((Seconds & 0x0F) << 0x0))))
}

public func LL_RTC_ALMB_GetSecond<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.alrmbr) & ((0x70 | 0xf)))) >> 0x0)
}

public func LL_RTC_ALMB_ConfigTime<IO: RTCRegisterIO>(
    _ registers: IO, _ Format12_24: UInt32, _ Hours: UInt32, _ Minutes: UInt32, _ Seconds: UInt32
) {
    var temp: UInt32
    temp =
        Format12_24 | (((Hours & 0xF0) << (0x14 &- 4)) | ((Hours & 0x0F) << 0x10))
        | (((Minutes & 0xF0) << (0xc &- 4)) | ((Minutes & 0x0F) << 0x8))
        | (((Seconds & 0xF0) << (0x4 &- 4)) | ((Seconds & 0x0F) << 0x0))
    registers.write(
        RTCRegister.alrmbr,
        value: (registers.read(RTCRegister.alrmbr) & ~(0x400000 | 0x300000 | 0xf0000 | 0x7000 | 0xf00 | 0x70 | 0xf))
            | (temp))
}

public func LL_RTC_ALMB_GetTime<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return
        ((LL_RTC_ALMB_GetHour(registers) << 0x10) | (LL_RTC_ALMB_GetMinute(registers) << 0x8)
        | LL_RTC_ALMB_GetSecond(registers))
}

public func LL_RTC_ALMB_SetSubSecondMask<IO: RTCRegisterIO>(_ registers: IO, _ Mask: UInt32) {
    registers.write(
        RTCRegister.alrmbssr, value: (registers.read(RTCRegister.alrmbssr) & ~(0x3f00_0000)) | (Mask << 0x18))
}

public func LL_RTC_ALMB_GetSubSecondMask<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.alrmbssr) & (0x3f00_0000)) >> 0x18)
}

public func LL_RTC_ALMB_SetBinAutoClr<IO: RTCRegisterIO>(_ registers: IO, _ BinaryAutoClr: UInt32) {
    registers.write(
        RTCRegister.alrmbssr, value: (registers.read(RTCRegister.alrmbssr) & ~(0x8000_0000)) | (BinaryAutoClr))
}

public func LL_RTC_ALMB_GetBinAutoClr<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.alrmbssr) & (0x8000_0000)))
}

public func LL_RTC_ALMB_SetSubSecond<IO: RTCRegisterIO>(_ registers: IO, _ Subsecond: UInt32) {
    registers.write(RTCRegister.alrmbssr, value: (registers.read(RTCRegister.alrmbssr) & ~(0x7fff)) | (Subsecond))
}

public func LL_RTC_ALMB_GetSubSecond<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.alrmbssr) & (0x7fff)))
}

public func LL_RTC_TS_EnableInternalEvent<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x1000000))
}

public func LL_RTC_TS_DisableInternalEvent<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x1000000))
}

public func LL_RTC_TS_Enable<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x800))
}

public func LL_RTC_TS_Disable<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x800))
}

public func LL_RTC_TS_SetActiveEdge<IO: RTCRegisterIO>(_ registers: IO, _ Edge: UInt32) {
    registers.write(RTCRegister.cr, value: (registers.read(RTCRegister.cr) & ~(0x8)) | (Edge))
}

public func LL_RTC_TS_GetActiveEdge<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.cr) & (0x8)))
}

public func LL_RTC_TS_GetTimeFormat<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.tstr) & (0x400000)))
}

public func LL_RTC_TS_GetHour<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.tstr) & (0x300000 | 0xf0000)) >> 0x10)
}

public func LL_RTC_TS_GetMinute<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.tstr) & (0x7000 | 0xf00)) >> 0x8)
}

public func LL_RTC_TS_GetSecond<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.tstr) & (0x70 | 0xf)))
}

public func LL_RTC_TS_GetTime<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.tstr) & (0x300000 | 0xf0000 | 0x7000 | 0xf00 | 0x70 | 0xf)))
}

public func LL_RTC_TS_GetWeekDay<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.tsdr) & (0xe000)) >> 0xd)
}

public func LL_RTC_TS_GetMonth<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.tsdr) & (0x1000 | 0xf00)) >> 0x8)
}

public func LL_RTC_TS_GetDay<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.tsdr) & (0x30 | 0xf)))
}

public func LL_RTC_TS_GetDate<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.tsdr) & (0xe000 | 0x1000 | 0xf00 | 0x30 | 0xf)))
}

public func LL_RTC_TS_GetSubSecond<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.tsssr) & (0xffff_ffff)))
}

public func LL_RTC_TS_EnableOnTamper<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x2000000))
}

public func LL_RTC_TS_DisableOnTamper<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x2000000))
}

public func LL_RTC_TAMPER_Enable<IO: RTCRegisterIO>(_ registers: IO, _ Tamper: UInt32) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.cr1, value: registers.readTamper(RTCTamperRegister.cr1) | (Tamper))
}

public func LL_RTC_TAMPER_Disable<IO: RTCRegisterIO>(_ registers: IO, _ Tamper: UInt32) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.cr1, value: registers.readTamper(RTCTamperRegister.cr1) & ~(Tamper))
}

public func LL_RTC_TAMPER_EnableMask<IO: RTCRegisterIO>(_ registers: IO, _ Mask: UInt32) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.cr2, value: registers.readTamper(RTCTamperRegister.cr2) | (Mask))
}

public func LL_RTC_TAMPER_DisableMask<IO: RTCRegisterIO>(_ registers: IO, _ Mask: UInt32) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.cr2, value: registers.readTamper(RTCTamperRegister.cr2) & ~(Mask))
}

public func LL_RTC_TAMPER_EnableEraseBKP<IO: RTCRegisterIO>(_ registers: IO, _ Tamper: UInt32) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.cr2, value: registers.readTamper(RTCTamperRegister.cr2) & ~(Tamper))
}

public func LL_RTC_TAMPER_DisableEraseBKP<IO: RTCRegisterIO>(_ registers: IO, _ Tamper: UInt32) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.cr2, value: registers.readTamper(RTCTamperRegister.cr2) | (Tamper))
}

public func LL_RTC_TAMPER_DisablePullUp<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.fltcr, value: registers.readTamper(RTCTamperRegister.fltcr) | (0x80))
}

public func LL_RTC_TAMPER_EnablePullUp<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.fltcr, value: registers.readTamper(RTCTamperRegister.fltcr) & ~(0x80))
}

public func LL_RTC_TAMPER_SetPrecharge<IO: RTCRegisterIO>(_ registers: IO, _ Duration: UInt32) {
    _ = registers
    registers.writeTamper(
        RTCTamperRegister.fltcr, value: (registers.readTamper(RTCTamperRegister.fltcr) & ~(0x60)) | (Duration))
}

public func LL_RTC_TAMPER_GetPrecharge<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return ((registers.readTamper(RTCTamperRegister.fltcr) & (0x60)))
}

public func LL_RTC_TAMPER_SetFilterCount<IO: RTCRegisterIO>(_ registers: IO, _ FilterCount: UInt32) {
    _ = registers
    registers.writeTamper(
        RTCTamperRegister.fltcr, value: (registers.readTamper(RTCTamperRegister.fltcr) & ~(0x18)) | (FilterCount))
}

public func LL_RTC_TAMPER_GetFilterCount<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return ((registers.readTamper(RTCTamperRegister.fltcr) & (0x18)))
}

public func LL_RTC_TAMPER_SetSamplingFreq<IO: RTCRegisterIO>(_ registers: IO, _ SamplingFreq: UInt32) {
    _ = registers
    registers.writeTamper(
        RTCTamperRegister.fltcr, value: (registers.readTamper(RTCTamperRegister.fltcr) & ~(0x7)) | (SamplingFreq))
}

public func LL_RTC_TAMPER_GetSamplingFreq<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return ((registers.readTamper(RTCTamperRegister.fltcr) & (0x7)))
}

public func LL_RTC_TAMPER_EnableActiveLevel<IO: RTCRegisterIO>(_ registers: IO, _ Tamper: UInt32) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.cr2, value: registers.readTamper(RTCTamperRegister.cr2) | (Tamper))
}

public func LL_RTC_TAMPER_DisableActiveLevel<IO: RTCRegisterIO>(_ registers: IO, _ Tamper: UInt32) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.cr2, value: registers.readTamper(RTCTamperRegister.cr2) & ~(Tamper))
}

public func LL_RTC_TAMPER_ITAMP_Enable<IO: RTCRegisterIO>(_ registers: IO, _ InternalTamper: UInt32) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.cr1, value: registers.readTamper(RTCTamperRegister.cr1) | (InternalTamper))
}

public func LL_RTC_TAMPER_ITAMP_Disable<IO: RTCRegisterIO>(_ registers: IO, _ InternalTamper: UInt32) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.cr1, value: registers.readTamper(RTCTamperRegister.cr1) & ~(InternalTamper))
}

public func LL_RTC_TAMPER_ITAMP_EnableEraseBKP<IO: RTCRegisterIO>(_ registers: IO, _ InternalTamper: UInt32) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.cr3, value: registers.readTamper(RTCTamperRegister.cr3) & ~(InternalTamper))
}

public func LL_RTC_TAMPER_ITAMP_DisableEraseBKP<IO: RTCRegisterIO>(_ registers: IO, _ InternalTamper: UInt32) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.cr3, value: registers.readTamper(RTCTamperRegister.cr3) | (InternalTamper))
}

public func LL_RTC_TAMPER_ATAMP_EnableActiveMode<IO: RTCRegisterIO>(_ registers: IO, _ Tamper: UInt32) {
    registers.writeTamper(RTCTamperRegister.atcr1, value: registers.readTamper(RTCTamperRegister.atcr1) | (Tamper))
}

public func LL_RTC_TAMPER_ATAMP_DisableActiveMode<IO: RTCRegisterIO>(_ registers: IO, _ Tamper: UInt32) {
    registers.writeTamper(RTCTamperRegister.atcr1, value: registers.readTamper(RTCTamperRegister.atcr1) & ~(Tamper))
}

public func LL_RTC_TAMPER_ATAMP_EnableFilter<IO: RTCRegisterIO>(_ registers: IO) {
    registers.writeTamper(RTCTamperRegister.atcr1, value: registers.readTamper(RTCTamperRegister.atcr1) | (0x8000_0000))
}

public func LL_RTC_TAMPER_ATAMP_DisableFilter<IO: RTCRegisterIO>(_ registers: IO) {
    registers.writeTamper(
        RTCTamperRegister.atcr1, value: registers.readTamper(RTCTamperRegister.atcr1) & ~(0x8000_0000))
}

public func LL_RTC_TAMPER_ATAMP_SetOutputChangePeriod<IO: RTCRegisterIO>(
    _ registers: IO, _ ActiveOutputChangePeriod: UInt32
) {
    registers.writeTamper(
        RTCTamperRegister.atcr1,
        value: (registers.readTamper(RTCTamperRegister.atcr1) & ~(0x7000000)) | ((ActiveOutputChangePeriod << 0x18)))
}

public func LL_RTC_TAMPER_ATAMP_GetOutputChangePeriod<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.readTamper(RTCTamperRegister.atcr1) & (0x7000000)) >> 0x18)
}

public func LL_RTC_TAMPER_ATAMP_SetAsyncPrescaler<IO: RTCRegisterIO>(_ registers: IO, _ ActiveAsynvPrescaler: UInt32) {
    registers.writeTamper(
        RTCTamperRegister.atcr1,
        value: (registers.readTamper(RTCTamperRegister.atcr1) & ~(0xf0000)) | (ActiveAsynvPrescaler))
}

public func LL_RTC_TAMPER_ATAMP_GetAsyncPrescaler<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.readTamper(RTCTamperRegister.atcr1) & (0xf0000)))
}

public func LL_RTC_TAMPER_ATAMP_EnableOutputSharing<IO: RTCRegisterIO>(_ registers: IO) {
    registers.writeTamper(RTCTamperRegister.atcr1, value: registers.readTamper(RTCTamperRegister.atcr1) | (0x4000_0000))
}

public func LL_RTC_TAMPER_ATAMP_DisableOutputSharing<IO: RTCRegisterIO>(_ registers: IO) {
    registers.writeTamper(
        RTCTamperRegister.atcr1, value: registers.readTamper(RTCTamperRegister.atcr1) & ~(0x4000_0000))
}

public func LL_RTC_TAMPER_ATAMP_SetSharedOuputSelection<IO: RTCRegisterIO>(_ registers: IO, _ OutputSelection: UInt32) {

    registers.writeTamper(
        RTCTamperRegister.atcr2,
        value: (registers.readTamper(RTCTamperRegister.atcr2)
            & ~((0x700 | 0x3800 | 0x1c000 | 0xe0000 | 0x700000 | 0x3800000 | 0x1c00_0000 | 0xe000_0000)))
            | (OutputSelection))
}

public func LL_RTC_TAMPER_ATAMP_GetSharedOuputSelection<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {

    return
        ((registers.readTamper(RTCTamperRegister.atcr2)
        & ((0x700 | 0x3800 | 0x1c000 | 0xe0000 | 0x700000 | 0x3800000 | 0x1c00_0000 | 0xe000_0000))))
}

public func LL_RTC_TAMPER_ATAMP_WriteSeed<IO: RTCRegisterIO>(_ registers: IO, _ Seed: UInt32) {
    registers.writeTamper(RTCTamperRegister.atseedr, value: Seed)
}

public func LL_RTC_IsActiveFlag_ATAMP_INITS<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readTamper(RTCTamperRegister.ator) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ATAMP_SEEDF<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readTamper(RTCTamperRegister.ator) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_RTC_WAKEUP_Enable<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x400))
}

public func LL_RTC_WAKEUP_Disable<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x400))
}

public func LL_RTC_WAKEUP_IsEnabled<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.cr) & (0x400)) == (0x400)) ? 1 : 0)
}

public func LL_RTC_WAKEUP_SetClock<IO: RTCRegisterIO>(_ registers: IO, _ WakeupClock: UInt32) {
    registers.write(RTCRegister.cr, value: (registers.read(RTCRegister.cr) & ~(0x7)) | (WakeupClock))
}

public func LL_RTC_WAKEUP_GetClock<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.cr) & (0x7)))
}

public func LL_RTC_WAKEUP_SetAutoReload<IO: RTCRegisterIO>(_ registers: IO, _ Value: UInt32) {
    registers.write(RTCRegister.wutr, value: (registers.read(RTCRegister.wutr) & ~(0xffff)) | (Value))
}

public func LL_RTC_WAKEUP_GetAutoReload<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.wutr) & (0xffff)))
}

public func LL_RTC_BKP_SetRegister<IO: RTCRegisterIO>(_ registers: IO, _ BackupRegister: UInt32, _ Data: UInt32) {
    registers.writeBackup(BackupRegister, value: Data)
}

public func LL_RTC_BKP_GetRegister<IO: RTCRegisterIO>(_ registers: IO, _ BackupRegister: UInt32) -> UInt32 {
    return registers.readBackup(BackupRegister)
}

public func LL_RTC_CAL_SetOutputFreq<IO: RTCRegisterIO>(_ registers: IO, _ Frequency: UInt32) {
    registers.write(RTCRegister.cr, value: (registers.read(RTCRegister.cr) & ~(0x800000 | 0x80000)) | (Frequency))
}

public func LL_RTC_CAL_GetOutputFreq<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.cr) & (0x800000 | 0x80000)))
}

public func LL_RTC_CAL_SetPulse<IO: RTCRegisterIO>(_ registers: IO, _ Pulse: UInt32) {
    registers.write(RTCRegister.calr, value: (registers.read(RTCRegister.calr) & ~(0x8000)) | (Pulse))
}

public func LL_RTC_CAL_IsPulseInserted<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.calr) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_RTC_CAL_SetPeriod<IO: RTCRegisterIO>(_ registers: IO, _ Period: UInt32) {
    registers.write(RTCRegister.calr, value: (registers.read(RTCRegister.calr) & ~(0x4000 | 0x2000)) | (Period))
}

public func LL_RTC_CAL_GetPeriod<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.calr) & (0x4000 | 0x2000)))
}

public func LL_RTC_CAL_SetMinus<IO: RTCRegisterIO>(_ registers: IO, _ CalibMinus: UInt32) {
    registers.write(RTCRegister.calr, value: (registers.read(RTCRegister.calr) & ~(0x1ff)) | (CalibMinus))
}

public func LL_RTC_CAL_GetMinus<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RTCRegister.calr) & (0x1ff)))
}

public func LL_RTC_CAL_LowPower_Enable<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.calr, value: registers.read(RTCRegister.calr) | (0x1000))
}

public func LL_RTC_CAL_LowPower_Disable<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.calr, value: registers.read(RTCRegister.calr) & ~(0x1000))
}

public func LL_RTC_CAL_LowPower_IsEnabled<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.calr) & (0x1000)) == (0x1000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITS<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.sr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_RECALP<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.icsr) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TSOV<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.sr) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TS<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.sr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_WUT<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.sr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ALRB<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.sr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ALRA<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.sr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_SSRU<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.sr) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_RTC_ClearFlag_ITS<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.scr, value: 0x20)
}

public func LL_RTC_ClearFlag_TSOV<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.scr, value: 0x10)
}

public func LL_RTC_ClearFlag_TS<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.scr, value: 0x8)
}

public func LL_RTC_ClearFlag_WUT<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.scr, value: 0x4)
}

public func LL_RTC_ClearFlag_ALRB<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.scr, value: 0x2)
}

public func LL_RTC_ClearFlag_ALRA<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.scr, value: 0x1)
}

public func LL_RTC_ClearFlag_SSRU<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.scr, value: 0x40)
}

public func LL_RTC_IsActiveFlag_INIT<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.icsr) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_RS<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.icsr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_RTC_ClearFlag_RS<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(
        RTCRegister.icsr, value: (~((0x20 | 0x80) & 0x0000_00FF) | (registers.read(RTCRegister.icsr) & 0x80)))
}

public func LL_RTC_IsActiveFlag_INITS<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.icsr) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_SHP<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.icsr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_WUTW<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.icsr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ALRAM<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.misr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_SSRUM<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.misr) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ALRBM<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.misr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_WUTM<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.misr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TSM<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.misr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TSOVM<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.misr) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITSM<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.misr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP1<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP2<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP3<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP4<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP5<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP6<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP7<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP8<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP1<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP2<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP3<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x40000)) == (0x40000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP4<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x80000)) == (0x80000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP5<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x100000)) == (0x100000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP6<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x200000)) == (0x200000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP7<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x400000)) == (0x400000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP8<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP9<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP11<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x4000000)) == (0x4000000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP15<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.sr) & (0x4000_0000)) == (0x4000_0000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP1M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP2M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP3M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP4M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP5M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP6M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP7M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_TAMP8M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP1M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP2M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP3M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x40000)) == (0x40000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP4M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x80000)) == (0x80000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP5M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x100000)) == (0x100000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP6M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x200000)) == (0x200000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP7M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x400000)) == (0x400000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP8M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP9M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP11M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x4000000)) == (0x4000000)) ? 1 : 0)
}

public func LL_RTC_IsActiveFlag_ITAMP15M<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.misr) & (0x4000_0000)) == (0x4000_0000)) ? 1 : 0)
}

public func LL_RTC_ClearFlag_TAMP1<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x1)
}

public func LL_RTC_ClearFlag_TAMP2<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x2)
}

public func LL_RTC_ClearFlag_TAMP3<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x4)
}

public func LL_RTC_ClearFlag_TAMP4<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x8)
}

public func LL_RTC_ClearFlag_TAMP5<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x10)
}

public func LL_RTC_ClearFlag_TAMP6<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x20)
}

public func LL_RTC_ClearFlag_TAMP7<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x40)
}

public func LL_RTC_ClearFlag_TAMP8<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x80)
}

public func LL_RTC_ClearFlag_ITAMP1<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x10000)
}

public func LL_RTC_ClearFlag_ITAMP2<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x20000)
}

public func LL_RTC_ClearFlag_ITAMP3<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x40000)
}

public func LL_RTC_ClearFlag_ITAMP4<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x80000)
}

public func LL_RTC_ClearFlag_ITAMP5<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x100000)
}

public func LL_RTC_ClearFlag_ITAMP6<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x200000)
}

public func LL_RTC_ClearFlag_ITAMP7<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x400000)
}

public func LL_RTC_ClearFlag_ITAMP8<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x800000)
}

public func LL_RTC_ClearFlag_ITAMP9<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x1000000)
}

public func LL_RTC_ClearFlag_ITAMP11<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x4000000)
}

public func LL_RTC_ClearFlag_ITAMP15<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.scr, value: 0x4000_0000)
}

public func LL_RTC_SetRtcPrivilege<IO: RTCRegisterIO>(_ registers: IO, _ rtcPrivilege: UInt32) {
    registers.write(
        RTCRegister.privcfgr,
        value: (registers.read(RTCRegister.privcfgr) & ~(0x8000 | 0x4000 | 0x2000 | 0x8 | 0x4 | 0x1 | 0x2))
            | (rtcPrivilege))
}

public func LL_RTC_GetRtcPrivilege<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(RTCRegister.privcfgr) & (0x8000 | 0x4000 | 0x2000 | 0x8 | 0x4 | 0x1 | 0x2))
}

public func LL_RTC_SetTampPrivilege<IO: RTCRegisterIO>(_ registers: IO, _ tampPrivilege: UInt32) {
    _ = registers
    registers.writeTamper(
        RTCTamperRegister.privcfgr,
        value: (registers.readTamper(RTCTamperRegister.privcfgr) & ~(0x8000_0000)) | (tampPrivilege))
}

public func LL_RTC_GetTampPrivilege<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (registers.readTamper(RTCTamperRegister.privcfgr) & (0x8000_0000))
}

public func LL_RTC_SetBackupRegisterPrivilege<IO: RTCRegisterIO>(_ registers: IO, _ bckupRegisterPrivilege: UInt32) {
    _ = registers
    registers.writeTamper(
        RTCTamperRegister.privcfgr,
        value: (registers.readTamper(RTCTamperRegister.privcfgr) & ~((0x4000_0000 | 0x2000_0000)))
            | (bckupRegisterPrivilege))
}

public func LL_RTC_GetBackupRegisterPrivilege<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (registers.readTamper(RTCTamperRegister.privcfgr) & ((0x4000_0000 | 0x2000_0000)))
}

public func LL_RTC_SetBackupRegProtection<IO: RTCRegisterIO>(
    _ registers: IO, _ startZone2: UInt32, _ startZone3: UInt32
) {
    _ = registers
    registers.writeTamper(
        RTCTamperRegister.cfgr,
        value: (registers.readTamper(RTCTamperRegister.cfgr) & ~((0xff | 0xff0000)))
            | ((startZone2 << 0x0) | (startZone3 << 0x10)))
}

public func LL_RTC_GetBackupRegProtectionStartZone2<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (registers.readTamper(RTCTamperRegister.cfgr) & (0xff)) >> 0x0
}

public func LL_RTC_GetBackupRegProtectionStartZone3<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (registers.readTamper(RTCTamperRegister.cfgr) & (0xff0000)) >> 0x10
}

public func LL_RTC_EnableIT_TS<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x8000))
}

public func LL_RTC_DisableIT_TS<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x8000))
}

public func LL_RTC_EnableIT_WUT<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x4000))
}

public func LL_RTC_DisableIT_WUT<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x4000))
}

public func LL_RTC_EnableIT_ALRB<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x2000))
}

public func LL_RTC_DisableIT_ALRB<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x2000))
}

public func LL_RTC_EnableIT_ALRA<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x1000))
}

public func LL_RTC_DisableIT_ALRA<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x1000))
}

public func LL_RTC_EnableIT_SSRU<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) | (0x80))
}

public func LL_RTC_DisableIT_SSRU<IO: RTCRegisterIO>(_ registers: IO) {
    registers.write(RTCRegister.cr, value: registers.read(RTCRegister.cr) & ~(0x80))
}

public func LL_RTC_IsEnabledIT_TS<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.cr) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_WUT<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.cr) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_ALRB<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.cr) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_ALRA<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.cr) & (0x1000)) == (0x1000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_SSRU<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RTCRegister.cr) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_RTC_EnableIT_TAMP1<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x1))
}

public func LL_RTC_DisableIT_TAMP1<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x1))
}

public func LL_RTC_EnableIT_TAMP2<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x2))
}

public func LL_RTC_DisableIT_TAMP2<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x2))
}

public func LL_RTC_EnableIT_TAMP3<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x4))
}

public func LL_RTC_DisableIT_TAMP3<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x4))
}

public func LL_RTC_EnableIT_TAMP4<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x8))
}

public func LL_RTC_DisableIT_TAMP4<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x8))
}

public func LL_RTC_EnableIT_TAMP5<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x10))
}

public func LL_RTC_DisableIT_TAMP5<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x10))
}

public func LL_RTC_EnableIT_TAMP6<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x20))
}

public func LL_RTC_DisableIT_TAMP6<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x20))
}

public func LL_RTC_EnableIT_TAMP7<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x40))
}

public func LL_RTC_DisableIT_TAMP7<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x40))
}

public func LL_RTC_EnableIT_TAMP8<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x80))
}

public func LL_RTC_DisableIT_TAMP8<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x80))
}

public func LL_RTC_EnableIT_ITAMP1<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x10000))
}

public func LL_RTC_DisableIT_ITAMP1<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x10000))
}

public func LL_RTC_EnableIT_ITAMP2<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x20000))
}

public func LL_RTC_DisableIT_ITAMP2<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x20000))
}

public func LL_RTC_EnableIT_ITAMP3<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x40000))
}

public func LL_RTC_DisableIT_ITAMP3<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x40000))
}

public func LL_RTC_EnableIT_ITAMP4<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x80000))
}

public func LL_RTC_DisableIT_ITAMP4<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x80000))
}

public func LL_RTC_EnableIT_ITAMP5<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x100000))
}

public func LL_RTC_DisableIT_ITAMP5<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x100000))
}

public func LL_RTC_EnableIT_ITAMP6<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x200000))
}

public func LL_RTC_DisableIT_ITAMP6<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x200000))
}

public func LL_RTC_EnableIT_ITAMP7<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x400000))
}

public func LL_RTC_DisableIT_ITAMP7<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x400000))
}

public func LL_RTC_EnableIT_ITAMP8<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x800000))
}

public func LL_RTC_DisableIT_ITAMP8<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x800000))
}

public func LL_RTC_EnableIT_ITAMP9<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x1000000))
}

public func LL_RTC_DisableIT_ITAMP9<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x1000000))
}

public func LL_RTC_EnableIT_ITAMP11<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x4000000))
}

public func LL_RTC_DisableIT_ITAMP11<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x4000000))
}

public func LL_RTC_EnableIT_ITAMP15<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) | (0x4000_0000))
}

public func LL_RTC_DisableIT_ITAMP15<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.ier, value: registers.readTamper(RTCTamperRegister.ier) & ~(0x4000_0000))
}

public func LL_RTC_IsEnabledIT_TAMP1<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_TAMP2<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_TAMP3<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_TAMP4<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_TAMP5<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_TAMP6<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_TAMP7<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_TAMP8<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_ITAMP1<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_ITAMP2<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_ITAMP3<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x40000)) == (0x40000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_ITAMP4<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x80000)) == (0x80000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_ITAMP5<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x100000)) == (0x100000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_ITAMP6<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x200000)) == (0x200000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_ITAMP7<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x400000)) == (0x400000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_ITAMP8<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_ITAMP9<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_ITAMP11<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x4000000)) == (0x4000000)) ? 1 : 0)
}

public func LL_RTC_IsEnabledIT_ITAMP15<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return (((registers.readTamper(RTCTamperRegister.ier) & (0x4000_0000)) == (0x4000_0000)) ? 1 : 0)
}

public func LL_RTC_IncrementMonotonicCounter<IO: RTCRegisterIO>(_ registers: IO) {
    _ = registers
    registers.writeTamper(RTCTamperRegister.count1r, value: 0)
}

public func LL_RTC_GetMonotonicCounter<IO: RTCRegisterIO>(_ registers: IO) -> UInt32 {
    _ = registers
    return registers.readTamper(RTCTamperRegister.count1r)
}

public func LL_RTC_DeInit<IO: RTCRegisterIO, Clock: LLCortexRegisterIO>(_ registers: IO, clock: inout Clock)
    -> LLErrorStatus
{
    var status: UInt32 = LLErrorStatus.error.rawValue

    LL_RTC_DisableWriteProtection(registers)

    if LL_RTC_EnterInitMode(registers, clock: &clock).rawValue != LLErrorStatus.error.rawValue {
        registers.write(RTCRegister.tr, value: 0)
        registers.write(RTCRegister.dr, value: (0x2000 | 0x100 | 0x1))
        registers.write(RTCRegister.cr, value: 0)
        registers.write(RTCRegister.wutr, value: 0xffff)
        registers.write(RTCRegister.prer, value: (0x7f0000 | 0xff))
        registers.write(RTCRegister.alrmar, value: 0)
        registers.write(RTCRegister.alrmbr, value: 0)
        registers.write(RTCRegister.shiftr, value: 0)
        registers.write(RTCRegister.calr, value: 0)
        registers.write(RTCRegister.alrmassr, value: 0)
        registers.write(RTCRegister.alrmbssr, value: 0)
        registers.write(RTCRegister.privcfgr, value: 0)

        registers.write(RTCRegister.icsr, value: registers.read(RTCRegister.icsr) & ~(0x1c00 | 0x300 | 0x80))

        status = LL_RTC_WaitForSynchro(registers, clock: &clock).rawValue
    }

    LL_RTC_EnableWriteProtection(registers)

    registers.writeTamper(RTCTamperRegister.cr1, value: 0)
    registers.writeTamper(RTCTamperRegister.cr2, value: 0)
    registers.writeTamper(RTCTamperRegister.cr3, value: 0)
    registers.writeTamper(RTCTamperRegister.cfgr, value: 0)
    registers.writeTamper(RTCTamperRegister.privcfgr, value: 0)
    registers.writeTamper(RTCTamperRegister.fltcr, value: 0)
    registers.writeTamper(RTCTamperRegister.atcr1, value: 0x0007_0000)
    registers.writeTamper(RTCTamperRegister.atcr2, value: 0)
    registers.writeTamper(RTCTamperRegister.ier, value: 0)
    registers.writeTamper(RTCTamperRegister.scr, value: 0xFFFF_FFFF)
    return LLErrorStatus(rawValue: status)!
}

public func LL_RTC_Init<IO: RTCRegisterIO, Clock: LLCortexRegisterIO>(
    _ registers: IO, _ RTC_InitStruct: inout LL_RTC_InitTypeDef, clock: inout Clock
) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.error.rawValue

    LL_RTC_DisableWriteProtection(registers)

    if LL_RTC_EnterInitMode(registers, clock: &clock).rawValue != LLErrorStatus.error.rawValue {
        LL_RTC_SetHourFormat(registers, UInt32(RTC_InitStruct.HourFormat))

        LL_RTC_SetSynchPrescaler(registers, UInt32(RTC_InitStruct.SynchPrescaler))
        LL_RTC_SetAsynchPrescaler(registers, UInt32(RTC_InitStruct.AsynchPrescaler))

        LL_RTC_DisableInitMode(registers)
        status = LLErrorStatus.success.rawValue
    }
    LL_RTC_EnableWriteProtection(registers)
    return LLErrorStatus(rawValue: status)!
}

public func LL_RTC_StructInit(_ RTC_InitStruct: inout LL_RTC_InitTypeDef) {
    RTC_InitStruct.HourFormat = LL_RTC_HOURFORMAT_24HOUR
    RTC_InitStruct.AsynchPrescaler = 0x7f
    RTC_InitStruct.SynchPrescaler = 0xff
}

public func LL_RTC_TIME_Init<IO: RTCRegisterIO, Clock: LLCortexRegisterIO>(
    _ registers: IO, _ RTC_Format: UInt32, _ RTC_TimeStruct: inout LL_RTC_TimeTypeDef, clock: inout Clock
) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.error.rawValue

    if RTC_Format == LL_RTC_FORMAT_BIN {
        if LL_RTC_GetHourFormat(registers) != LL_RTC_HOURFORMAT_24HOUR {

        } else {
            RTC_TimeStruct.TimeFormat = 0x00
        }

    } else {
        if LL_RTC_GetHourFormat(registers) != LL_RTC_HOURFORMAT_24HOUR {

        } else {
            RTC_TimeStruct.TimeFormat = 0
        }

    }

    LL_RTC_DisableWriteProtection(registers)

    if LL_RTC_EnterInitMode(registers, clock: &clock).rawValue != LLErrorStatus.error.rawValue {
        if RTC_Format != LL_RTC_FORMAT_BIN {
            LL_RTC_TIME_Config(
                registers, UInt32(RTC_TimeStruct.TimeFormat), UInt32(RTC_TimeStruct.Hours),
                UInt32(RTC_TimeStruct.Minutes), UInt32(RTC_TimeStruct.Seconds))
        } else {
            LL_RTC_TIME_Config(
                registers, UInt32(RTC_TimeStruct.TimeFormat),
                UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_TimeStruct.Hours))),
                UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_TimeStruct.Minutes))),
                UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_TimeStruct.Seconds))))
        }

        LL_RTC_DisableInitMode(registers)

        if LL_RTC_IsShadowRegBypassEnabled(registers) == 0 {
            status = LL_RTC_WaitForSynchro(registers, clock: &clock).rawValue
        } else {
            status = LLErrorStatus.success.rawValue
        }
    }
    LL_RTC_EnableWriteProtection(registers)
    return LLErrorStatus(rawValue: status)!
}

public func LL_RTC_TIME_StructInit(_ RTC_TimeStruct: inout LL_RTC_TimeTypeDef) {
    RTC_TimeStruct.TimeFormat = LL_RTC_TIME_FORMAT_AM_OR_24
    RTC_TimeStruct.Hours = UInt8(truncatingIfNeeded: 0)
    RTC_TimeStruct.Minutes = UInt8(truncatingIfNeeded: 0)
    RTC_TimeStruct.Seconds = UInt8(truncatingIfNeeded: 0)
}

public func LL_RTC_DATE_Init<IO: RTCRegisterIO, Clock: LLCortexRegisterIO>(
    _ registers: IO, _ RTC_Format: UInt32, _ RTC_DateStruct: inout LL_RTC_DateTypeDef, clock: inout Clock
) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.error.rawValue

    if (RTC_Format == LL_RTC_FORMAT_BIN) && ((RTC_DateStruct.Month & 0x10) == 0x10) {
        RTC_DateStruct.Month = UInt8(truncatingIfNeeded: (RTC_DateStruct.Month & ~(0x10)) &+ 0x0A)
    }
    if RTC_Format == LL_RTC_FORMAT_BIN {

    } else {

    }

    LL_RTC_DisableWriteProtection(registers)

    if LL_RTC_EnterInitMode(registers, clock: &clock).rawValue != LLErrorStatus.error.rawValue {
        if RTC_Format != LL_RTC_FORMAT_BIN {
            LL_RTC_DATE_Config(
                registers, UInt32(RTC_DateStruct.WeekDay), UInt32(RTC_DateStruct.Day), UInt32(RTC_DateStruct.Month),
                UInt32(RTC_DateStruct.Year))
        } else {
            LL_RTC_DATE_Config(
                registers, UInt32(RTC_DateStruct.WeekDay), UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_DateStruct.Day))),
                UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_DateStruct.Month))),
                UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_DateStruct.Year))))
        }

        LL_RTC_DisableInitMode(registers)

        if LL_RTC_IsShadowRegBypassEnabled(registers) == 0 {
            status = LL_RTC_WaitForSynchro(registers, clock: &clock).rawValue
        } else {
            status = LLErrorStatus.success.rawValue
        }
    }
    LL_RTC_EnableWriteProtection(registers)
    return LLErrorStatus(rawValue: status)!
}

public func LL_RTC_DATE_StructInit(_ RTC_DateStruct: inout LL_RTC_DateTypeDef) {
    RTC_DateStruct.WeekDay = UInt8(truncatingIfNeeded: LL_RTC_WEEKDAY_MONDAY)
    RTC_DateStruct.Day = UInt8(truncatingIfNeeded: 1)
    RTC_DateStruct.Month = UInt8(truncatingIfNeeded: LL_RTC_MONTH_JANUARY)
    RTC_DateStruct.Year = UInt8(truncatingIfNeeded: 0)
}

public func LL_RTC_ALMA_Init<IO: RTCRegisterIO>(
    _ registers: IO, _ RTC_Format: UInt32, _ RTC_AlarmStruct: inout LL_RTC_AlarmTypeDef
) -> LLErrorStatus {

    if RTC_Format == LL_RTC_FORMAT_BIN {
        if LL_RTC_GetHourFormat(registers) != LL_RTC_HOURFORMAT_24HOUR {

        } else {
            RTC_AlarmStruct.AlarmTime.TimeFormat = 0x00
        }

        if RTC_AlarmStruct.AlarmDateWeekDaySel == LL_RTC_ALMA_DATEWEEKDAYSEL_DATE {
        } else {
        }
    } else {
        if LL_RTC_GetHourFormat(registers) != LL_RTC_HOURFORMAT_24HOUR {

        } else {
            RTC_AlarmStruct.AlarmTime.TimeFormat = 0x00
        }

        if RTC_AlarmStruct.AlarmDateWeekDaySel == LL_RTC_ALMA_DATEWEEKDAYSEL_DATE {
        } else {
        }
    }

    LL_RTC_DisableWriteProtection(registers)

    if RTC_AlarmStruct.AlarmDateWeekDaySel == LL_RTC_ALMA_DATEWEEKDAYSEL_DATE {
        LL_RTC_ALMA_DisableWeekday(registers)
        if RTC_Format != LL_RTC_FORMAT_BIN {
            LL_RTC_ALMA_SetDay(registers, UInt32(RTC_AlarmStruct.AlarmDateWeekDay))
        } else {
            LL_RTC_ALMA_SetDay(registers, UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_AlarmStruct.AlarmDateWeekDay))))
        }
    } else {
        LL_RTC_ALMA_EnableWeekday(registers)
        LL_RTC_ALMA_SetWeekDay(registers, UInt32(RTC_AlarmStruct.AlarmDateWeekDay))
    }

    if RTC_Format != LL_RTC_FORMAT_BIN {
        LL_RTC_ALMA_ConfigTime(
            registers, UInt32(RTC_AlarmStruct.AlarmTime.TimeFormat), UInt32(RTC_AlarmStruct.AlarmTime.Hours),
            UInt32(RTC_AlarmStruct.AlarmTime.Minutes), UInt32(RTC_AlarmStruct.AlarmTime.Seconds))
    } else {
        LL_RTC_ALMA_ConfigTime(
            registers, UInt32(RTC_AlarmStruct.AlarmTime.TimeFormat),
            UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_AlarmStruct.AlarmTime.Hours))),
            UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_AlarmStruct.AlarmTime.Minutes))),
            UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_AlarmStruct.AlarmTime.Seconds))))
    }
    LL_RTC_ALMA_SetMask(registers, UInt32(RTC_AlarmStruct.AlarmMask))

    LL_RTC_EnableWriteProtection(registers)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

public func LL_RTC_ALMB_Init<IO: RTCRegisterIO>(
    _ registers: IO, _ RTC_Format: UInt32, _ RTC_AlarmStruct: inout LL_RTC_AlarmTypeDef
) -> LLErrorStatus {

    if RTC_Format == LL_RTC_FORMAT_BIN {
        if LL_RTC_GetHourFormat(registers) != LL_RTC_HOURFORMAT_24HOUR {

        } else {
            RTC_AlarmStruct.AlarmTime.TimeFormat = 0x00
        }

        if RTC_AlarmStruct.AlarmDateWeekDaySel == LL_RTC_ALMB_DATEWEEKDAYSEL_DATE {
        } else {
        }
    } else {
        if LL_RTC_GetHourFormat(registers) != LL_RTC_HOURFORMAT_24HOUR {

        } else {
            RTC_AlarmStruct.AlarmTime.TimeFormat = 0x00
        }

        if RTC_AlarmStruct.AlarmDateWeekDaySel == LL_RTC_ALMB_DATEWEEKDAYSEL_DATE {
        } else {
        }
    }

    LL_RTC_DisableWriteProtection(registers)

    if RTC_AlarmStruct.AlarmDateWeekDaySel == LL_RTC_ALMB_DATEWEEKDAYSEL_DATE {
        LL_RTC_ALMB_DisableWeekday(registers)
        if RTC_Format != LL_RTC_FORMAT_BIN {
            LL_RTC_ALMB_SetDay(registers, UInt32(RTC_AlarmStruct.AlarmDateWeekDay))
        } else {
            LL_RTC_ALMB_SetDay(registers, UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_AlarmStruct.AlarmDateWeekDay))))
        }
    } else {
        LL_RTC_ALMB_EnableWeekday(registers)
        LL_RTC_ALMB_SetWeekDay(registers, UInt32(RTC_AlarmStruct.AlarmDateWeekDay))
    }

    if RTC_Format != LL_RTC_FORMAT_BIN {
        LL_RTC_ALMB_ConfigTime(
            registers, UInt32(RTC_AlarmStruct.AlarmTime.TimeFormat), UInt32(RTC_AlarmStruct.AlarmTime.Hours),
            UInt32(RTC_AlarmStruct.AlarmTime.Minutes), UInt32(RTC_AlarmStruct.AlarmTime.Seconds))
    } else {
        LL_RTC_ALMB_ConfigTime(
            registers, UInt32(RTC_AlarmStruct.AlarmTime.TimeFormat),
            UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_AlarmStruct.AlarmTime.Hours))),
            UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_AlarmStruct.AlarmTime.Minutes))),
            UInt32(__LL_RTC_CONVERT_BIN2BCD(UInt32(RTC_AlarmStruct.AlarmTime.Seconds))))
    }
    LL_RTC_ALMB_SetMask(registers, UInt32(RTC_AlarmStruct.AlarmMask))

    LL_RTC_EnableWriteProtection(registers)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

public func LL_RTC_ALMA_StructInit(_ RTC_AlarmStruct: inout LL_RTC_AlarmTypeDef) {
    RTC_AlarmStruct.AlarmTime.TimeFormat = LL_RTC_ALMA_TIME_FORMAT_AM
    RTC_AlarmStruct.AlarmTime.Hours = UInt8(truncatingIfNeeded: 0)
    RTC_AlarmStruct.AlarmTime.Minutes = UInt8(truncatingIfNeeded: 0)
    RTC_AlarmStruct.AlarmTime.Seconds = UInt8(truncatingIfNeeded: 0)

    RTC_AlarmStruct.AlarmDateWeekDaySel = LL_RTC_ALMA_DATEWEEKDAYSEL_DATE
    RTC_AlarmStruct.AlarmDateWeekDay = UInt8(truncatingIfNeeded: 1)

    RTC_AlarmStruct.AlarmMask = LL_RTC_ALMA_MASK_NONE
}

public func LL_RTC_ALMB_StructInit(_ RTC_AlarmStruct: inout LL_RTC_AlarmTypeDef) {
    RTC_AlarmStruct.AlarmTime.TimeFormat = LL_RTC_ALMB_TIME_FORMAT_AM
    RTC_AlarmStruct.AlarmTime.Hours = UInt8(truncatingIfNeeded: 0)
    RTC_AlarmStruct.AlarmTime.Minutes = UInt8(truncatingIfNeeded: 0)
    RTC_AlarmStruct.AlarmTime.Seconds = UInt8(truncatingIfNeeded: 0)

    RTC_AlarmStruct.AlarmDateWeekDaySel = LL_RTC_ALMB_DATEWEEKDAYSEL_DATE
    RTC_AlarmStruct.AlarmDateWeekDay = UInt8(truncatingIfNeeded: 1)

    RTC_AlarmStruct.AlarmMask = LL_RTC_ALMB_MASK_NONE
}

public func LL_RTC_EnterInitMode<IO: RTCRegisterIO, Clock: LLCortexRegisterIO>(_ registers: IO, clock: inout Clock)
    -> LLErrorStatus
{
    var timeout: UInt32 = 0x3e8
    var status: UInt32 = LLErrorStatus.success.rawValue
    var tmp: UInt32

    if LL_RTC_IsActiveFlag_INIT(registers) == 0 {
        LL_RTC_EnableInitMode(registers)

        tmp = LL_RTC_IsActiveFlag_INIT(registers)
        while (timeout != 0) && (tmp != 1) {
            if LL_SYSTICK_IsActiveCounterFlag(&clock) == 1 {
                timeout &-= 1
            }
            tmp = LL_RTC_IsActiveFlag_INIT(registers)
            if timeout == 0 {
                status = LLErrorStatus.error.rawValue
            }
        }
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_RTC_ExitInitMode<IO: RTCRegisterIO>(_ registers: IO) -> LLErrorStatus {

    LL_RTC_DisableInitMode(registers)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

public func LL_RTC_WaitForSynchro<IO: RTCRegisterIO, Clock: LLCortexRegisterIO>(_ registers: IO, clock: inout Clock)
    -> LLErrorStatus
{
    var timeout: UInt32 = 0x3e8
    var tmp: UInt32
    var status: UInt32 = LLErrorStatus.success.rawValue

    LL_RTC_ClearFlag_RS(registers)

    tmp = LL_RTC_IsActiveFlag_RS(registers)
    while (timeout != 0) && (tmp != 1) {
        if LL_SYSTICK_IsActiveCounterFlag(&clock) == 1 {
            timeout &-= 1
        }
        tmp = LL_RTC_IsActiveFlag_RS(registers)
    }
    if timeout == 0 {
        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}
