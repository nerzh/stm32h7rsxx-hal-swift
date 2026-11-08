// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// CMSIS definitions from 7e6e213ddc397c76622a0aca2f623ccc3b34c010.

typedef struct
{
  __IO uint32_t TR;          /*!< RTC time register,                              Address offset: 0x00 */
  __IO uint32_t DR;          /*!< RTC date register,                              Address offset: 0x04 */
  __IO uint32_t SSR;         /*!< RTC sub second register,                        Address offset: 0x08 */
  __IO uint32_t ICSR;        /*!< RTC initialization control and status register, Address offset: 0x0C */
  __IO uint32_t PRER;        /*!< RTC prescaler register,                         Address offset: 0x10 */
  __IO uint32_t WUTR;        /*!< RTC wakeup timer register,                      Address offset: 0x14 */
  __IO uint32_t CR;          /*!< RTC control register,                           Address offset: 0x18 */
  __IO uint32_t PRIVCFGR;    /*!< RTC privilege mode control register,            Address offset: 0x1C */
  __IO uint32_t RESERVED0;   /*!< Reserved,                                       Address offset: 0x20 */
  __IO uint32_t WPR;         /*!< RTC write protection register,                  Address offset: 0x24 */
  __IO uint32_t CALR;        /*!< RTC calibration register,                       Address offset: 0x28 */
  __IO uint32_t SHIFTR;      /*!< RTC shift control register,                     Address offset: 0x2C */
  __IO uint32_t TSTR;        /*!< RTC time stamp time register,                   Address offset: 0x30 */
  __IO uint32_t TSDR;        /*!< RTC time stamp date register,                   Address offset: 0x34 */
  __IO uint32_t TSSSR;       /*!< RTC time-stamp sub second register,             Address offset: 0x38 */
       uint32_t RESERVED1;   /*!< Reserved,                                       Address offset: 0x3C */
  __IO uint32_t ALRMAR;      /*!< RTC alarm A register,                           Address offset: 0x40 */
  __IO uint32_t ALRMASSR;    /*!< RTC alarm A sub second register,                Address offset: 0x44 */
  __IO uint32_t ALRMBR;      /*!< RTC alarm B register,                           Address offset: 0x48 */
  __IO uint32_t ALRMBSSR;    /*!< RTC alarm B sub second register,                Address offset: 0x4C */
  __IO uint32_t SR;          /*!< RTC Status register,                            Address offset: 0x50 */
  __IO uint32_t MISR;        /*!< RTC masked interrupt status register,           Address offset: 0x54 */
  __IO uint32_t RESERVED2;   /*!< Reserved,                                       Address offset: 0x58 */
  __IO uint32_t SCR;         /*!< RTC status Clear register,                      Address offset: 0x5C */
       uint32_t RESERVED3[4];/*!< Reserved,                                       Address offset: 0x58 */
  __IO uint32_t ALRABINR;    /*!< RTC alarm A binary mode register,               Address offset: 0x70 */
  __IO uint32_t ALRBBINR;    /*!< RTC alarm B binary mode register,               Address offset: 0x74 */
} RTC_TypeDef;
typedef struct
{
  __IO uint32_t CR1;           /*!< TAMP configuration register 1,                    Address offset: 0x00 */
  __IO uint32_t CR2;           /*!< TAMP configuration register 2,                    Address offset: 0x04 */
  __IO uint32_t CR3;           /*!< TAMP configuration register 3,                    Address offset: 0x08 */
  __IO uint32_t FLTCR;         /*!< TAMP filter control register,                     Address offset: 0x0C */
  __IO uint32_t ATCR1;         /*!< TAMP filter control register 1                    Address offset: 0x10 */
  __IO uint32_t ATSEEDR;       /*!< TAMP active tamper seed register,                 Address offset: 0x14 */
  __IO uint32_t ATOR;          /*!< TAMP active tamper output register,               Address offset: 0x18 */
  __IO uint32_t ATCR2;         /*!< TAMP filter control register 2,                   Address offset: 0x1C */
  __IO uint32_t CFGR;          /*!< TAMP configuration control register,              Address offset: 0x20 */
  __IO uint32_t PRIVCFGR;      /*!< TAMP privilege mode control register,             Address offset: 0x24 */
       uint32_t RESERVED2;     /*!< Reserved,                                         Address offset: 0x28 */
  __IO uint32_t IER;           /*!< TAMP interrupt enable register,                   Address offset: 0x2C */
  __IO uint32_t SR;            /*!< TAMP status register,                             Address offset: 0x30 */
  __IO uint32_t MISR;          /*!< TAMP masked interrupt status register,            Address offset: 0x34 */
  __IO uint32_t RESERVED3;     /*!< Reserved,                                         Address offset: 0x38 */
  __IO uint32_t SCR;           /*!< TAMP status clear register,                       Address offset: 0x3C */
  __IO uint32_t COUNT1R;       /*!< TAMP monotonic counter 1 register,                Address offset: 0x40 */
       uint32_t RESERVED4[4];  /*!< Reserved,                                         Address offset: 0x43 -- 0x50 */
  __IO uint32_t RPCFGR;        /*!< TAMP resources protection configuration register, Address offset: 0x54 */
       uint32_t RESERVED5[42]; /*!< Reserved,                                         Address offset: 0x58 -- 0xFC */
  __IO uint32_t BKP0R;         /*!< TAMP backup register 0,                           Address offset: 0x100 */
  __IO uint32_t BKP1R;         /*!< TAMP backup register 1,                           Address offset: 0x104 */
  __IO uint32_t BKP2R;         /*!< TAMP backup register 2,                           Address offset: 0x108 */
  __IO uint32_t BKP3R;         /*!< TAMP backup register 3,                           Address offset: 0x10C */
  __IO uint32_t BKP4R;         /*!< TAMP backup register 4,                           Address offset: 0x110 */
  __IO uint32_t BKP5R;         /*!< TAMP backup register 5,                           Address offset: 0x114 */
  __IO uint32_t BKP6R;         /*!< TAMP backup register 6,                           Address offset: 0x118 */
  __IO uint32_t BKP7R;         /*!< TAMP backup register 7,                           Address offset: 0x11C */
  __IO uint32_t BKP8R;         /*!< TAMP backup register 8,                           Address offset: 0x120 */
  __IO uint32_t BKP9R;         /*!< TAMP backup register 9,                           Address offset: 0x124 */
  __IO uint32_t BKP10R;        /*!< TAMP backup register 10,                          Address offset: 0x128 */
  __IO uint32_t BKP11R;        /*!< TAMP backup register 11,                          Address offset: 0x12C */
  __IO uint32_t BKP12R;        /*!< TAMP backup register 12,                          Address offset: 0x130 */
  __IO uint32_t BKP13R;        /*!< TAMP backup register 13,                          Address offset: 0x134 */
  __IO uint32_t BKP14R;        /*!< TAMP backup register 14,                          Address offset: 0x138 */
  __IO uint32_t BKP15R;        /*!< TAMP backup register 15,                          Address offset: 0x13C */
  __IO uint32_t BKP16R;        /*!< TAMP backup register 16,                          Address offset: 0x140 */
  __IO uint32_t BKP17R;        /*!< TAMP backup register 17,                          Address offset: 0x144 */
  __IO uint32_t BKP18R;        /*!< TAMP backup register 18,                          Address offset: 0x148 */
  __IO uint32_t BKP19R;        /*!< TAMP backup register 19,                          Address offset: 0x14C */
  __IO uint32_t BKP20R;        /*!< TAMP backup register 20,                          Address offset: 0x150 */
  __IO uint32_t BKP21R;        /*!< TAMP backup register 21,                          Address offset: 0x154 */
  __IO uint32_t BKP22R;        /*!< TAMP backup register 22,                          Address offset: 0x158 */
  __IO uint32_t BKP23R;        /*!< TAMP backup register 23,                          Address offset: 0x15C */
  __IO uint32_t BKP24R;        /*!< TAMP backup register 24,                          Address offset: 0x160 */
  __IO uint32_t BKP25R;        /*!< TAMP backup register 25,                          Address offset: 0x164 */
  __IO uint32_t BKP26R;        /*!< TAMP backup register 26,                          Address offset: 0x168 */
  __IO uint32_t BKP27R;        /*!< TAMP backup register 27,                          Address offset: 0x16C */
  __IO uint32_t BKP28R;        /*!< TAMP backup register 28,                          Address offset: 0x170 */
  __IO uint32_t BKP29R;        /*!< TAMP backup register 29,                          Address offset: 0x174 */
  __IO uint32_t BKP30R;        /*!< TAMP backup register 30,                          Address offset: 0x178 */
  __IO uint32_t BKP31R;        /*!< TAMP backup register 31,                          Address offset: 0x17C */
} TAMP_TypeDef;
#define RTC_BKP_NB         32U
#define RTC_TAMP_NB        8U
#define RTC_BASE                        (APB4PERIPH_BASE + 0x4000UL)
#define TAMP_BASE                       (APB4PERIPH_BASE + 0x4400UL)
#define RTC_TR_SU_Pos                       (0U)
#define RTC_TR_SU_Msk                       (0xFUL << RTC_TR_SU_Pos)                /*!< 0x0000000F */
#define RTC_TR_SU                           RTC_TR_SU_Msk
#define RTC_TR_SU_0                         (0x1UL << RTC_TR_SU_Pos)                /*!< 0x00000001 */
#define RTC_TR_SU_1                         (0x2UL << RTC_TR_SU_Pos)                /*!< 0x00000002 */
#define RTC_TR_SU_2                         (0x4UL << RTC_TR_SU_Pos)                /*!< 0x00000004 */
#define RTC_TR_SU_3                         (0x8UL << RTC_TR_SU_Pos)                /*!< 0x00000008 */
#define RTC_TR_ST_Pos                       (4U)
#define RTC_TR_ST_Msk                       (0x7UL << RTC_TR_ST_Pos)                /*!< 0x00000070 */
#define RTC_TR_ST                           RTC_TR_ST_Msk
#define RTC_TR_ST_0                         (0x1UL << RTC_TR_ST_Pos)                /*!< 0x00000010 */
#define RTC_TR_ST_1                         (0x2UL << RTC_TR_ST_Pos)                /*!< 0x00000020 */
#define RTC_TR_ST_2                         (0x4UL << RTC_TR_ST_Pos)                /*!< 0x00000040 */
#define RTC_TR_MNU_Pos                      (8U)
#define RTC_TR_MNU_Msk                      (0xFUL << RTC_TR_MNU_Pos)               /*!< 0x00000F00 */
#define RTC_TR_MNU                          RTC_TR_MNU_Msk
#define RTC_TR_MNU_0                        (0x1UL << RTC_TR_MNU_Pos)               /*!< 0x00000100 */
#define RTC_TR_MNU_1                        (0x2UL << RTC_TR_MNU_Pos)               /*!< 0x00000200 */
#define RTC_TR_MNU_2                        (0x4UL << RTC_TR_MNU_Pos)               /*!< 0x00000400 */
#define RTC_TR_MNU_3                        (0x8UL << RTC_TR_MNU_Pos)               /*!< 0x00000800 */
#define RTC_TR_MNT_Pos                      (12U)
#define RTC_TR_MNT_Msk                      (0x7UL << RTC_TR_MNT_Pos)               /*!< 0x00007000 */
#define RTC_TR_MNT                          RTC_TR_MNT_Msk
#define RTC_TR_MNT_0                        (0x1UL << RTC_TR_MNT_Pos)               /*!< 0x00001000 */
#define RTC_TR_MNT_1                        (0x2UL << RTC_TR_MNT_Pos)               /*!< 0x00002000 */
#define RTC_TR_MNT_2                        (0x4UL << RTC_TR_MNT_Pos)               /*!< 0x00004000 */
#define RTC_TR_HU_Pos                       (16U)
#define RTC_TR_HU_Msk                       (0xFUL << RTC_TR_HU_Pos)                /*!< 0x000F0000 */
#define RTC_TR_HU                           RTC_TR_HU_Msk
#define RTC_TR_HU_0                         (0x1UL << RTC_TR_HU_Pos)                /*!< 0x00010000 */
#define RTC_TR_HU_1                         (0x2UL << RTC_TR_HU_Pos)                /*!< 0x00020000 */
#define RTC_TR_HU_2                         (0x4UL << RTC_TR_HU_Pos)                /*!< 0x00040000 */
#define RTC_TR_HU_3                         (0x8UL << RTC_TR_HU_Pos)                /*!< 0x00080000 */
#define RTC_TR_HT_Pos                       (20U)
#define RTC_TR_HT_Msk                       (0x3UL << RTC_TR_HT_Pos)                /*!< 0x00300000 */
#define RTC_TR_HT                           RTC_TR_HT_Msk
#define RTC_TR_HT_0                         (0x1UL << RTC_TR_HT_Pos)                /*!< 0x00100000 */
#define RTC_TR_HT_1                         (0x2UL << RTC_TR_HT_Pos)                /*!< 0x00200000 */
#define RTC_TR_PM_Pos                       (22U)
#define RTC_TR_PM_Msk                       (0x1UL << RTC_TR_PM_Pos)                /*!< 0x00400000 */
#define RTC_TR_PM                           RTC_TR_PM_Msk
#define RTC_DR_DU_Pos                       (0U)
#define RTC_DR_DU_Msk                       (0xFUL << RTC_DR_DU_Pos)                /*!< 0x0000000F */
#define RTC_DR_DU                           RTC_DR_DU_Msk
#define RTC_DR_DU_0                         (0x1UL << RTC_DR_DU_Pos)                /*!< 0x00000001 */
#define RTC_DR_DU_1                         (0x2UL << RTC_DR_DU_Pos)                /*!< 0x00000002 */
#define RTC_DR_DU_2                         (0x4UL << RTC_DR_DU_Pos)                /*!< 0x00000004 */
#define RTC_DR_DU_3                         (0x8UL << RTC_DR_DU_Pos)                /*!< 0x00000008 */
#define RTC_DR_DT_Pos                       (4U)
#define RTC_DR_DT_Msk                       (0x3UL << RTC_DR_DT_Pos)                /*!< 0x00000030 */
#define RTC_DR_DT                           RTC_DR_DT_Msk
#define RTC_DR_DT_0                         (0x1UL << RTC_DR_DT_Pos)                /*!< 0x00000010 */
#define RTC_DR_DT_1                         (0x2UL << RTC_DR_DT_Pos)                /*!< 0x00000020 */
#define RTC_DR_MU_Pos                       (8U)
#define RTC_DR_MU_Msk                       (0xFUL << RTC_DR_MU_Pos)                /*!< 0x00000F00 */
#define RTC_DR_MU                           RTC_DR_MU_Msk
#define RTC_DR_MU_0                         (0x1UL << RTC_DR_MU_Pos)                /*!< 0x00000100 */
#define RTC_DR_MU_1                         (0x2UL << RTC_DR_MU_Pos)                /*!< 0x00000200 */
#define RTC_DR_MU_2                         (0x4UL << RTC_DR_MU_Pos)                /*!< 0x00000400 */
#define RTC_DR_MU_3                         (0x8UL << RTC_DR_MU_Pos)                /*!< 0x00000800 */
#define RTC_DR_MT_Pos                       (12U)
#define RTC_DR_MT_Msk                       (0x1UL << RTC_DR_MT_Pos)                /*!< 0x00001000 */
#define RTC_DR_MT                           RTC_DR_MT_Msk
#define RTC_DR_WDU_Pos                      (13U)
#define RTC_DR_WDU_Msk                      (0x7UL << RTC_DR_WDU_Pos)               /*!< 0x0000E000 */
#define RTC_DR_WDU                          RTC_DR_WDU_Msk
#define RTC_DR_WDU_0                        (0x1UL << RTC_DR_WDU_Pos)               /*!< 0x00002000 */
#define RTC_DR_WDU_1                        (0x2UL << RTC_DR_WDU_Pos)               /*!< 0x00004000 */
#define RTC_DR_WDU_2                        (0x4UL << RTC_DR_WDU_Pos)               /*!< 0x00008000 */
#define RTC_DR_YU_Pos                       (16U)
#define RTC_DR_YU_Msk                       (0xFUL << RTC_DR_YU_Pos)                /*!< 0x000F0000 */
#define RTC_DR_YU                           RTC_DR_YU_Msk
#define RTC_DR_YU_0                         (0x1UL << RTC_DR_YU_Pos)                /*!< 0x00010000 */
#define RTC_DR_YU_1                         (0x2UL << RTC_DR_YU_Pos)                /*!< 0x00020000 */
#define RTC_DR_YU_2                         (0x4UL << RTC_DR_YU_Pos)                /*!< 0x00040000 */
#define RTC_DR_YU_3                         (0x8UL << RTC_DR_YU_Pos)                /*!< 0x00080000 */
#define RTC_DR_YT_Pos                       (20U)
#define RTC_DR_YT_Msk                       (0xFUL << RTC_DR_YT_Pos)                /*!< 0x00F00000 */
#define RTC_DR_YT                           RTC_DR_YT_Msk
#define RTC_DR_YT_0                         (0x1UL << RTC_DR_YT_Pos)                /*!< 0x00100000 */
#define RTC_DR_YT_1                         (0x2UL << RTC_DR_YT_Pos)                /*!< 0x00200000 */
#define RTC_DR_YT_2                         (0x4UL << RTC_DR_YT_Pos)                /*!< 0x00400000 */
#define RTC_DR_YT_3                         (0x8UL << RTC_DR_YT_Pos)                /*!< 0x00800000 */
#define RTC_SSR_SS_Pos                      (0U)
#define RTC_SSR_SS_Msk                      (0xFFFFFFFFUL << RTC_SSR_SS_Pos)        /*!< 0xFFFFFFFF */
#define RTC_SSR_SS                          RTC_SSR_SS_Msk
#define RTC_ICSR_WUTWF_Pos                  (2U)
#define RTC_ICSR_WUTWF_Msk                  (0x1UL << RTC_ICSR_WUTWF_Pos)           /*!< 0x00000004 */
#define RTC_ICSR_WUTWF                      RTC_ICSR_WUTWF_Msk
#define RTC_ICSR_SHPF_Pos                   (3U)
#define RTC_ICSR_SHPF_Msk                   (0x1UL << RTC_ICSR_SHPF_Pos)            /*!< 0x00000008 */
#define RTC_ICSR_SHPF                       RTC_ICSR_SHPF_Msk
#define RTC_ICSR_INITS_Pos                  (4U)
#define RTC_ICSR_INITS_Msk                  (0x1UL << RTC_ICSR_INITS_Pos)           /*!< 0x00000010 */
#define RTC_ICSR_INITS                      RTC_ICSR_INITS_Msk
#define RTC_ICSR_RSF_Pos                    (5U)
#define RTC_ICSR_RSF_Msk                    (0x1UL << RTC_ICSR_RSF_Pos)             /*!< 0x00000020 */
#define RTC_ICSR_RSF                        RTC_ICSR_RSF_Msk
#define RTC_ICSR_INITF_Pos                  (6U)
#define RTC_ICSR_INITF_Msk                  (0x1UL << RTC_ICSR_INITF_Pos)           /*!< 0x00000040 */
#define RTC_ICSR_INITF                      RTC_ICSR_INITF_Msk
#define RTC_ICSR_INIT_Pos                   (7U)
#define RTC_ICSR_INIT_Msk                   (0x1UL << RTC_ICSR_INIT_Pos)            /*!< 0x00000080 */
#define RTC_ICSR_INIT                       RTC_ICSR_INIT_Msk
#define RTC_ICSR_BIN_Pos                    (8U)
#define RTC_ICSR_BIN_Msk                    (0x3UL << RTC_ICSR_BIN_Pos)             /*!< 0x00000300 */
#define RTC_ICSR_BIN                        RTC_ICSR_BIN_Msk
#define RTC_ICSR_BIN_0                      (0x1UL << RTC_ICSR_BIN_Pos)             /*!< 0x00000100 */
#define RTC_ICSR_BIN_1                      (0x2UL << RTC_ICSR_BIN_Pos)             /*!< 0x00000200 */
#define RTC_ICSR_BCDU_Pos                   (10U)
#define RTC_ICSR_BCDU_Msk                   (0x7UL << RTC_ICSR_BCDU_Pos)            /*!< 0x00001C00 */
#define RTC_ICSR_BCDU                       RTC_ICSR_BCDU_Msk
#define RTC_ICSR_BCDU_0                     (0x1UL << RTC_ICSR_BCDU_Pos)            /*!< 0x00000400 */
#define RTC_ICSR_BCDU_1                     (0x2UL << RTC_ICSR_BCDU_Pos)            /*!< 0x00000800 */
#define RTC_ICSR_BCDU_2                     (0x4UL << RTC_ICSR_BCDU_Pos)            /*!< 0x00001000 */
#define RTC_ICSR_RECALPF_Pos                (16U)
#define RTC_ICSR_RECALPF_Msk                (0x1UL << RTC_ICSR_RECALPF_Pos)         /*!< 0x00010000 */
#define RTC_ICSR_RECALPF                    RTC_ICSR_RECALPF_Msk
#define RTC_PRER_PREDIV_S_Pos               (0U)
#define RTC_PRER_PREDIV_S_Msk               (0x7FFFUL << RTC_PRER_PREDIV_S_Pos)     /*!< 0x00007FFF */
#define RTC_PRER_PREDIV_S                   RTC_PRER_PREDIV_S_Msk
#define RTC_PRER_PREDIV_A_Pos               (16U)
#define RTC_PRER_PREDIV_A_Msk               (0x7FUL << RTC_PRER_PREDIV_A_Pos)       /*!< 0x007F0000 */
#define RTC_PRER_PREDIV_A                   RTC_PRER_PREDIV_A_Msk
#define RTC_WUTR_WUT_Pos                    (0U)
#define RTC_WUTR_WUT_Msk                    (0xFFFFUL << RTC_WUTR_WUT_Pos)          /*!< 0x0000FFFF */
#define RTC_WUTR_WUT                        RTC_WUTR_WUT_Msk
#define RTC_WUTR_WUTOCLR_Pos                (16U)
#define RTC_WUTR_WUTOCLR_Msk                (0xFFFFUL << RTC_WUTR_WUTOCLR_Pos)      /*!< 0x0000FFFF */
#define RTC_WUTR_WUTOCLR                    RTC_WUTR_WUTOCLR_Msk
#define RTC_CR_WUCKSEL_Pos                  (0U)
#define RTC_CR_WUCKSEL_Msk                  (0x7UL << RTC_CR_WUCKSEL_Pos)           /*!< 0x00000007 */
#define RTC_CR_WUCKSEL                      RTC_CR_WUCKSEL_Msk
#define RTC_CR_WUCKSEL_0                    (0x1UL << RTC_CR_WUCKSEL_Pos)           /*!< 0x00000001 */
#define RTC_CR_WUCKSEL_1                    (0x2UL << RTC_CR_WUCKSEL_Pos)           /*!< 0x00000002 */
#define RTC_CR_WUCKSEL_2                    (0x4UL << RTC_CR_WUCKSEL_Pos)           /*!< 0x00000004 */
#define RTC_CR_TSEDGE_Pos                   (3U)
#define RTC_CR_TSEDGE_Msk                   (0x1UL << RTC_CR_TSEDGE_Pos)            /*!< 0x00000008 */
#define RTC_CR_TSEDGE                       RTC_CR_TSEDGE_Msk
#define RTC_CR_REFCKON_Pos                  (4U)
#define RTC_CR_REFCKON_Msk                  (0x1UL << RTC_CR_REFCKON_Pos)           /*!< 0x00000010 */
#define RTC_CR_REFCKON                      RTC_CR_REFCKON_Msk
#define RTC_CR_BYPSHAD_Pos                  (5U)
#define RTC_CR_BYPSHAD_Msk                  (0x1UL << RTC_CR_BYPSHAD_Pos)           /*!< 0x00000020 */
#define RTC_CR_BYPSHAD                      RTC_CR_BYPSHAD_Msk
#define RTC_CR_FMT_Pos                      (6U)
#define RTC_CR_FMT_Msk                      (0x1UL << RTC_CR_FMT_Pos)               /*!< 0x00000040 */
#define RTC_CR_FMT                          RTC_CR_FMT_Msk
#define RTC_CR_SSRUIE_Pos                   (7U)
#define RTC_CR_SSRUIE_Msk                   (0x1UL << RTC_CR_SSRUIE_Pos)            /*!< 0x00000080 */
#define RTC_CR_SSRUIE                       RTC_CR_SSRUIE_Msk
#define RTC_CR_ALRAE_Pos                    (8U)
#define RTC_CR_ALRAE_Msk                    (0x1UL << RTC_CR_ALRAE_Pos)             /*!< 0x00000100 */
#define RTC_CR_ALRAE                        RTC_CR_ALRAE_Msk
#define RTC_CR_ALRBE_Pos                    (9U)
#define RTC_CR_ALRBE_Msk                    (0x1UL << RTC_CR_ALRBE_Pos)             /*!< 0x00000200 */
#define RTC_CR_ALRBE                        RTC_CR_ALRBE_Msk
#define RTC_CR_WUTE_Pos                     (10U)
#define RTC_CR_WUTE_Msk                     (0x1UL << RTC_CR_WUTE_Pos)              /*!< 0x00000400 */
#define RTC_CR_WUTE                         RTC_CR_WUTE_Msk
#define RTC_CR_TSE_Pos                      (11U)
#define RTC_CR_TSE_Msk                      (0x1UL << RTC_CR_TSE_Pos)               /*!< 0x00000800 */
#define RTC_CR_TSE                          RTC_CR_TSE_Msk
#define RTC_CR_ALRAIE_Pos                   (12U)
#define RTC_CR_ALRAIE_Msk                   (0x1UL << RTC_CR_ALRAIE_Pos)            /*!< 0x00001000 */
#define RTC_CR_ALRAIE                       RTC_CR_ALRAIE_Msk
#define RTC_CR_ALRBIE_Pos                   (13U)
#define RTC_CR_ALRBIE_Msk                   (0x1UL << RTC_CR_ALRBIE_Pos)            /*!< 0x00002000 */
#define RTC_CR_ALRBIE                       RTC_CR_ALRBIE_Msk
#define RTC_CR_WUTIE_Pos                    (14U)
#define RTC_CR_WUTIE_Msk                    (0x1UL << RTC_CR_WUTIE_Pos)             /*!< 0x00004000 */
#define RTC_CR_WUTIE                        RTC_CR_WUTIE_Msk
#define RTC_CR_TSIE_Pos                     (15U)
#define RTC_CR_TSIE_Msk                     (0x1UL << RTC_CR_TSIE_Pos)              /*!< 0x00008000 */
#define RTC_CR_TSIE                         RTC_CR_TSIE_Msk
#define RTC_CR_ADD1H_Pos                    (16U)
#define RTC_CR_ADD1H_Msk                    (0x1UL << RTC_CR_ADD1H_Pos)             /*!< 0x00010000 */
#define RTC_CR_ADD1H                        RTC_CR_ADD1H_Msk
#define RTC_CR_SUB1H_Pos                    (17U)
#define RTC_CR_SUB1H_Msk                    (0x1UL << RTC_CR_SUB1H_Pos)             /*!< 0x00020000 */
#define RTC_CR_SUB1H                        RTC_CR_SUB1H_Msk
#define RTC_CR_BKP_Pos                      (18U)
#define RTC_CR_BKP_Msk                      (0x1UL << RTC_CR_BKP_Pos)               /*!< 0x00040000 */
#define RTC_CR_BKP                          RTC_CR_BKP_Msk
#define RTC_CR_COSEL_Pos                    (19U)
#define RTC_CR_COSEL_Msk                    (0x1UL << RTC_CR_COSEL_Pos)             /*!< 0x00080000 */
#define RTC_CR_COSEL                        RTC_CR_COSEL_Msk
#define RTC_CR_POL_Pos                      (20U)
#define RTC_CR_POL_Msk                      (0x1UL << RTC_CR_POL_Pos)               /*!< 0x00100000 */
#define RTC_CR_POL                          RTC_CR_POL_Msk
#define RTC_CR_OSEL_Pos                     (21U)
#define RTC_CR_OSEL_Msk                     (0x3UL << RTC_CR_OSEL_Pos)              /*!< 0x00600000 */
#define RTC_CR_OSEL                         RTC_CR_OSEL_Msk
#define RTC_CR_OSEL_0                       (0x1UL << RTC_CR_OSEL_Pos)              /*!< 0x00200000 */
#define RTC_CR_OSEL_1                       (0x2UL << RTC_CR_OSEL_Pos)              /*!< 0x00400000 */
#define RTC_CR_COE_Pos                      (23U)
#define RTC_CR_COE_Msk                      (0x1UL << RTC_CR_COE_Pos)               /*!< 0x00800000 */
#define RTC_CR_COE                          RTC_CR_COE_Msk
#define RTC_CR_ITSE_Pos                     (24U)
#define RTC_CR_ITSE_Msk                     (0x1UL << RTC_CR_ITSE_Pos)              /*!< 0x01000000 */
#define RTC_CR_ITSE                         RTC_CR_ITSE_Msk                         /*!<Timestamp on internal event enable  */
#define RTC_CR_TAMPTS_Pos                   (25U)
#define RTC_CR_TAMPTS_Msk                   (0x1UL << RTC_CR_TAMPTS_Pos)            /*!< 0x02000000 */
#define RTC_CR_TAMPTS                       RTC_CR_TAMPTS_Msk                       /*!<Activate timestamp on tamper detection event  */
#define RTC_CR_TAMPOE_Pos                   (26U)
#define RTC_CR_TAMPOE_Msk                   (0x1UL << RTC_CR_TAMPOE_Pos)            /*!< 0x04000000 */
#define RTC_CR_TAMPOE                       RTC_CR_TAMPOE_Msk                       /*!<Tamper detection output enable on TAMPALARM  */
#define RTC_CR_ALRAFCLR_Pos                 (27U)
#define RTC_CR_ALRAFCLR_Msk                 (0x1UL << RTC_CR_ALRAFCLR_Pos)          /*!< 0x8000000 */
#define RTC_CR_ALRAFCLR                     RTC_CR_ALRAFCLR_Msk                     /*!<Alarm A mask */
#define RTC_CR_ALRBFCLR_Pos                 (28U)
#define RTC_CR_ALRBFCLR_Msk                 (0x1UL << RTC_CR_ALRBFCLR_Pos)          /*!< 0x10000000 */
#define RTC_CR_ALRBFCLR                     RTC_CR_ALRBFCLR_Msk                     /*!<Alarm B mask */
#define RTC_CR_TAMPALRM_PU_Pos              (29U)
#define RTC_CR_TAMPALRM_PU_Msk              (0x1UL << RTC_CR_TAMPALRM_PU_Pos)       /*!< 0x20000000 */
#define RTC_CR_TAMPALRM_PU                  RTC_CR_TAMPALRM_PU_Msk                  /*!<TAMPALARM output pull-up config */
#define RTC_CR_TAMPALRM_TYPE_Pos            (30U)
#define RTC_CR_TAMPALRM_TYPE_Msk            (0x1UL << RTC_CR_TAMPALRM_TYPE_Pos)     /*!< 0x40000000 */
#define RTC_CR_TAMPALRM_TYPE                RTC_CR_TAMPALRM_TYPE_Msk                /*!<TAMPALARM output type  */
#define RTC_CR_OUT2EN_Pos                   (31U)
#define RTC_CR_OUT2EN_Msk                   (0x1UL << RTC_CR_OUT2EN_Pos)            /*!< 0x80000000 */
#define RTC_CR_OUT2EN                       RTC_CR_OUT2EN_Msk                       /*!<RTC_OUT2 output enable */
#define RTC_PRIVCFGR_ALRAPRIV_Pos           (0U)
#define RTC_PRIVCFGR_ALRAPRIV_Msk           (0x1UL << RTC_PRIVCFGR_ALRAPRIV_Pos)    /*!< 0x00000001 */
#define RTC_PRIVCFGR_ALRAPRIV               RTC_PRIVCFGR_ALRAPRIV_Msk
#define RTC_PRIVCFGR_ALRBPRIV_Pos           (1U)
#define RTC_PRIVCFGR_ALRBPRIV_Msk           (0x1UL << RTC_PRIVCFGR_ALRBPRIV_Pos)    /*!< 0x00000002 */
#define RTC_PRIVCFGR_ALRBPRIV               RTC_PRIVCFGR_ALRBPRIV_Msk
#define RTC_PRIVCFGR_WUTPRIV_Pos            (2U)
#define RTC_PRIVCFGR_WUTPRIV_Msk            (0x1UL << RTC_PRIVCFGR_WUTPRIV_Pos)     /*!< 0x00000004 */
#define RTC_PRIVCFGR_WUTPRIV                RTC_PRIVCFGR_WUTPRIV_Msk
#define RTC_PRIVCFGR_TSPRIV_Pos             (3U)
#define RTC_PRIVCFGR_TSPRIV_Msk             (0x1UL << RTC_PRIVCFGR_TSPRIV_Pos)      /*!< 0x00000008 */
#define RTC_PRIVCFGR_TSPRIV                 RTC_PRIVCFGR_TSPRIV_Msk
#define RTC_PRIVCFGR_CALPRIV_Pos            (13U)
#define RTC_PRIVCFGR_CALPRIV_Msk            (0x1UL << RTC_PRIVCFGR_CALPRIV_Pos)     /*!< 0x00002000 */
#define RTC_PRIVCFGR_CALPRIV                RTC_PRIVCFGR_CALPRIV_Msk
#define RTC_PRIVCFGR_INITPRIV_Pos           (14U)
#define RTC_PRIVCFGR_INITPRIV_Msk           (0x1UL << RTC_PRIVCFGR_INITPRIV_Pos)    /*!< 0x00004000 */
#define RTC_PRIVCFGR_INITPRIV               RTC_PRIVCFGR_INITPRIV_Msk
#define RTC_PRIVCFGR_PRIV_Pos               (15U)
#define RTC_PRIVCFGR_PRIV_Msk               (0x1UL << RTC_PRIVCFGR_PRIV_Pos)        /*!< 0x00008000 */
#define RTC_PRIVCFGR_PRIV                   RTC_PRIVCFGR_PRIV_Msk
#define RTC_WPR_KEY_Pos                     (0U)
#define RTC_WPR_KEY_Msk                     (0xFFUL << RTC_WPR_KEY_Pos)             /*!< 0x000000FF */
#define RTC_WPR_KEY                         RTC_WPR_KEY_Msk
#define RTC_CALR_CALM_Pos                   (0U)
#define RTC_CALR_CALM_Msk                   (0x1FFUL << RTC_CALR_CALM_Pos)          /*!< 0x000001FF */
#define RTC_CALR_CALM                       RTC_CALR_CALM_Msk
#define RTC_CALR_CALM_0                     (0x001UL << RTC_CALR_CALM_Pos)          /*!< 0x00000001 */
#define RTC_CALR_CALM_1                     (0x002UL << RTC_CALR_CALM_Pos)          /*!< 0x00000002 */
#define RTC_CALR_CALM_2                     (0x004UL << RTC_CALR_CALM_Pos)          /*!< 0x00000004 */
#define RTC_CALR_CALM_3                     (0x008UL << RTC_CALR_CALM_Pos)          /*!< 0x00000008 */
#define RTC_CALR_CALM_4                     (0x010UL << RTC_CALR_CALM_Pos)          /*!< 0x00000010 */
#define RTC_CALR_CALM_5                     (0x020UL << RTC_CALR_CALM_Pos)          /*!< 0x00000020 */
#define RTC_CALR_CALM_6                     (0x040UL << RTC_CALR_CALM_Pos)          /*!< 0x00000040 */
#define RTC_CALR_CALM_7                     (0x080UL << RTC_CALR_CALM_Pos)          /*!< 0x00000080 */
#define RTC_CALR_CALM_8                     (0x100UL << RTC_CALR_CALM_Pos)          /*!< 0x00000100 */
#define RTC_CALR_LPCAL_Pos                  (12U)
#define RTC_CALR_LPCAL_Msk                  (0x1UL << RTC_CALR_LPCAL_Pos)           /*!< 0x00001000 */
#define RTC_CALR_CALW16                     RTC_CALR_CALW16_Msk
#define RTC_CALR_CALW16_Pos                 (13U)
#define RTC_CALR_CALW16_Msk                 (0x1UL << RTC_CALR_CALW16_Pos)          /*!< 0x00002000 */
#define RTC_CALR_LPCAL                      RTC_CALR_LPCAL_Msk
#define RTC_CALR_CALW8_Pos                  (14U)
#define RTC_CALR_CALW8_Msk                  (0x1UL << RTC_CALR_CALW8_Pos)           /*!< 0x00004000 */
#define RTC_CALR_CALW8                      RTC_CALR_CALW8_Msk
#define RTC_CALR_CALP_Pos                   (15U)
#define RTC_CALR_CALP_Msk                   (0x1UL << RTC_CALR_CALP_Pos)            /*!< 0x00008000 */
#define RTC_CALR_CALP                       RTC_CALR_CALP_Msk
#define RTC_SHIFTR_SUBFS_Pos                (0U)
#define RTC_SHIFTR_SUBFS_Msk                (0x7FFFUL << RTC_SHIFTR_SUBFS_Pos)      /*!< 0x00007FFF */
#define RTC_SHIFTR_SUBFS                    RTC_SHIFTR_SUBFS_Msk
#define RTC_SHIFTR_ADD1S_Pos                (31U)
#define RTC_SHIFTR_ADD1S_Msk                (0x1UL << RTC_SHIFTR_ADD1S_Pos)         /*!< 0x80000000 */
#define RTC_SHIFTR_ADD1S                    RTC_SHIFTR_ADD1S_Msk
#define RTC_TSTR_SU_Pos                     (0U)
#define RTC_TSTR_SU_Msk                     (0xFUL << RTC_TSTR_SU_Pos)              /*!< 0x0000000F */
#define RTC_TSTR_SU                         RTC_TSTR_SU_Msk
#define RTC_TSTR_SU_0                       (0x1UL << RTC_TSTR_SU_Pos)              /*!< 0x00000001 */
#define RTC_TSTR_SU_1                       (0x2UL << RTC_TSTR_SU_Pos)              /*!< 0x00000002 */
#define RTC_TSTR_SU_2                       (0x4UL << RTC_TSTR_SU_Pos)              /*!< 0x00000004 */
#define RTC_TSTR_SU_3                       (0x8UL << RTC_TSTR_SU_Pos)              /*!< 0x00000008 */
#define RTC_TSTR_ST_Pos                     (4U)
#define RTC_TSTR_ST_Msk                     (0x7UL << RTC_TSTR_ST_Pos)              /*!< 0x00000070 */
#define RTC_TSTR_ST                         RTC_TSTR_ST_Msk
#define RTC_TSTR_ST_0                       (0x1UL << RTC_TSTR_ST_Pos)              /*!< 0x00000010 */
#define RTC_TSTR_ST_1                       (0x2UL << RTC_TSTR_ST_Pos)              /*!< 0x00000020 */
#define RTC_TSTR_ST_2                       (0x4UL << RTC_TSTR_ST_Pos)              /*!< 0x00000040 */
#define RTC_TSTR_MNU_Pos                    (8U)
#define RTC_TSTR_MNU_Msk                    (0xFUL << RTC_TSTR_MNU_Pos)             /*!< 0x00000F00 */
#define RTC_TSTR_MNU                        RTC_TSTR_MNU_Msk
#define RTC_TSTR_MNU_0                      (0x1UL << RTC_TSTR_MNU_Pos)             /*!< 0x00000100 */
#define RTC_TSTR_MNU_1                      (0x2UL << RTC_TSTR_MNU_Pos)             /*!< 0x00000200 */
#define RTC_TSTR_MNU_2                      (0x4UL << RTC_TSTR_MNU_Pos)             /*!< 0x00000400 */
#define RTC_TSTR_MNU_3                      (0x8UL << RTC_TSTR_MNU_Pos)             /*!< 0x00000800 */
#define RTC_TSTR_MNT_Pos                    (12U)
#define RTC_TSTR_MNT_Msk                    (0x7UL << RTC_TSTR_MNT_Pos)             /*!< 0x00007000 */
#define RTC_TSTR_MNT                        RTC_TSTR_MNT_Msk
#define RTC_TSTR_MNT_0                      (0x1UL << RTC_TSTR_MNT_Pos)             /*!< 0x00001000 */
#define RTC_TSTR_MNT_1                      (0x2UL << RTC_TSTR_MNT_Pos)             /*!< 0x00002000 */
#define RTC_TSTR_MNT_2                      (0x4UL << RTC_TSTR_MNT_Pos)             /*!< 0x00004000 */
#define RTC_TSTR_HU_Pos                     (16U)
#define RTC_TSTR_HU_Msk                     (0xFUL << RTC_TSTR_HU_Pos)              /*!< 0x000F0000 */
#define RTC_TSTR_HU                         RTC_TSTR_HU_Msk
#define RTC_TSTR_HU_0                       (0x1UL << RTC_TSTR_HU_Pos)              /*!< 0x00010000 */
#define RTC_TSTR_HU_1                       (0x2UL << RTC_TSTR_HU_Pos)              /*!< 0x00020000 */
#define RTC_TSTR_HU_2                       (0x4UL << RTC_TSTR_HU_Pos)              /*!< 0x00040000 */
#define RTC_TSTR_HU_3                       (0x8UL << RTC_TSTR_HU_Pos)              /*!< 0x00080000 */
#define RTC_TSTR_HT_Pos                     (20U)
#define RTC_TSTR_HT_Msk                     (0x3UL << RTC_TSTR_HT_Pos)              /*!< 0x00300000 */
#define RTC_TSTR_HT                         RTC_TSTR_HT_Msk
#define RTC_TSTR_HT_0                       (0x1UL << RTC_TSTR_HT_Pos)              /*!< 0x00100000 */
#define RTC_TSTR_HT_1                       (0x2UL << RTC_TSTR_HT_Pos)              /*!< 0x00200000 */
#define RTC_TSTR_PM_Pos                     (22U)
#define RTC_TSTR_PM_Msk                     (0x1UL << RTC_TSTR_PM_Pos)              /*!< 0x00400000 */
#define RTC_TSTR_PM                         RTC_TSTR_PM_Msk
#define RTC_TSDR_DU_Pos                     (0U)
#define RTC_TSDR_DU_Msk                     (0xFUL << RTC_TSDR_DU_Pos)              /*!< 0x0000000F */
#define RTC_TSDR_DU                         RTC_TSDR_DU_Msk
#define RTC_TSDR_DU_0                       (0x1UL << RTC_TSDR_DU_Pos)              /*!< 0x00000001 */
#define RTC_TSDR_DU_1                       (0x2UL << RTC_TSDR_DU_Pos)              /*!< 0x00000002 */
#define RTC_TSDR_DU_2                       (0x4UL << RTC_TSDR_DU_Pos)              /*!< 0x00000004 */
#define RTC_TSDR_DU_3                       (0x8UL << RTC_TSDR_DU_Pos)              /*!< 0x00000008 */
#define RTC_TSDR_DT_Pos                     (4U)
#define RTC_TSDR_DT_Msk                     (0x3UL << RTC_TSDR_DT_Pos)              /*!< 0x00000030 */
#define RTC_TSDR_DT                         RTC_TSDR_DT_Msk
#define RTC_TSDR_DT_0                       (0x1UL << RTC_TSDR_DT_Pos)              /*!< 0x00000010 */
#define RTC_TSDR_DT_1                       (0x2UL << RTC_TSDR_DT_Pos)              /*!< 0x00000020 */
#define RTC_TSDR_MU_Pos                     (8U)
#define RTC_TSDR_MU_Msk                     (0xFUL << RTC_TSDR_MU_Pos)              /*!< 0x00000F00 */
#define RTC_TSDR_MU                         RTC_TSDR_MU_Msk
#define RTC_TSDR_MU_0                       (0x1UL << RTC_TSDR_MU_Pos)              /*!< 0x00000100 */
#define RTC_TSDR_MU_1                       (0x2UL << RTC_TSDR_MU_Pos)              /*!< 0x00000200 */
#define RTC_TSDR_MU_2                       (0x4UL << RTC_TSDR_MU_Pos)              /*!< 0x00000400 */
#define RTC_TSDR_MU_3                       (0x8UL << RTC_TSDR_MU_Pos)              /*!< 0x00000800 */
#define RTC_TSDR_MT_Pos                     (12U)
#define RTC_TSDR_MT_Msk                     (0x1UL << RTC_TSDR_MT_Pos)              /*!< 0x00001000 */
#define RTC_TSDR_MT                         RTC_TSDR_MT_Msk
#define RTC_TSDR_WDU_Pos                    (13U)
#define RTC_TSDR_WDU_Msk                    (0x7UL << RTC_TSDR_WDU_Pos)             /*!< 0x0000E000 */
#define RTC_TSDR_WDU                        RTC_TSDR_WDU_Msk
#define RTC_TSDR_WDU_0                      (0x1UL << RTC_TSDR_WDU_Pos)             /*!< 0x00002000 */
#define RTC_TSDR_WDU_1                      (0x2UL << RTC_TSDR_WDU_Pos)             /*!< 0x00004000 */
#define RTC_TSDR_WDU_2                      (0x4UL << RTC_TSDR_WDU_Pos)             /*!< 0x00008000 */
#define RTC_TSSSR_SS_Pos                    (0U)
#define RTC_TSSSR_SS_Msk                    (0xFFFFFFFFUL << RTC_TSSSR_SS_Pos)      /*!< 0xFFFFFFFF */
#define RTC_TSSSR_SS                        RTC_TSSSR_SS_Msk                        /*!< rtc timestamp sub second > */
#define RTC_ALRMAR_SU_Pos                   (0U)
#define RTC_ALRMAR_SU_Msk                   (0xFUL << RTC_ALRMAR_SU_Pos)            /*!< 0x0000000F */
#define RTC_ALRMAR_SU                       RTC_ALRMAR_SU_Msk
#define RTC_ALRMAR_SU_0                     (0x1UL << RTC_ALRMAR_SU_Pos)            /*!< 0x00000001 */
#define RTC_ALRMAR_SU_1                     (0x2UL << RTC_ALRMAR_SU_Pos)            /*!< 0x00000002 */
#define RTC_ALRMAR_SU_2                     (0x4UL << RTC_ALRMAR_SU_Pos)            /*!< 0x00000004 */
#define RTC_ALRMAR_SU_3                     (0x8UL << RTC_ALRMAR_SU_Pos)            /*!< 0x00000008 */
#define RTC_ALRMAR_ST_Pos                   (4U)
#define RTC_ALRMAR_ST_Msk                   (0x7UL << RTC_ALRMAR_ST_Pos)            /*!< 0x00000070 */
#define RTC_ALRMAR_ST                       RTC_ALRMAR_ST_Msk
#define RTC_ALRMAR_ST_0                     (0x1UL << RTC_ALRMAR_ST_Pos)            /*!< 0x00000010 */
#define RTC_ALRMAR_ST_1                     (0x2UL << RTC_ALRMAR_ST_Pos)            /*!< 0x00000020 */
#define RTC_ALRMAR_ST_2                     (0x4UL << RTC_ALRMAR_ST_Pos)            /*!< 0x00000040 */
#define RTC_ALRMAR_MSK1_Pos                 (7U)
#define RTC_ALRMAR_MSK1_Msk                 (0x1UL << RTC_ALRMAR_MSK1_Pos)          /*!< 0x00000080 */
#define RTC_ALRMAR_MSK1                     RTC_ALRMAR_MSK1_Msk
#define RTC_ALRMAR_MNU_Pos                  (8U)
#define RTC_ALRMAR_MNU_Msk                  (0xFUL << RTC_ALRMAR_MNU_Pos)           /*!< 0x00000F00 */
#define RTC_ALRMAR_MNU                      RTC_ALRMAR_MNU_Msk
#define RTC_ALRMAR_MNU_0                    (0x1UL << RTC_ALRMAR_MNU_Pos)           /*!< 0x00000100 */
#define RTC_ALRMAR_MNU_1                    (0x2UL << RTC_ALRMAR_MNU_Pos)           /*!< 0x00000200 */
#define RTC_ALRMAR_MNU_2                    (0x4UL << RTC_ALRMAR_MNU_Pos)           /*!< 0x00000400 */
#define RTC_ALRMAR_MNU_3                    (0x8UL << RTC_ALRMAR_MNU_Pos)           /*!< 0x00000800 */
#define RTC_ALRMAR_MNT_Pos                  (12U)
#define RTC_ALRMAR_MNT_Msk                  (0x7UL << RTC_ALRMAR_MNT_Pos)           /*!< 0x00007000 */
#define RTC_ALRMAR_MNT                      RTC_ALRMAR_MNT_Msk
#define RTC_ALRMAR_MNT_0                    (0x1UL << RTC_ALRMAR_MNT_Pos)           /*!< 0x00001000 */
#define RTC_ALRMAR_MNT_1                    (0x2UL << RTC_ALRMAR_MNT_Pos)           /*!< 0x00002000 */
#define RTC_ALRMAR_MNT_2                    (0x4UL << RTC_ALRMAR_MNT_Pos)           /*!< 0x00004000 */
#define RTC_ALRMAR_MSK2_Pos                 (15U)
#define RTC_ALRMAR_MSK2_Msk                 (0x1UL << RTC_ALRMAR_MSK2_Pos)          /*!< 0x00008000 */
#define RTC_ALRMAR_MSK2                     RTC_ALRMAR_MSK2_Msk
#define RTC_ALRMAR_HU_Pos                   (16U)
#define RTC_ALRMAR_HU_Msk                   (0xFUL << RTC_ALRMAR_HU_Pos)            /*!< 0x000F0000 */
#define RTC_ALRMAR_HU                       RTC_ALRMAR_HU_Msk
#define RTC_ALRMAR_HU_0                     (0x1UL << RTC_ALRMAR_HU_Pos)            /*!< 0x00010000 */
#define RTC_ALRMAR_HU_1                     (0x2UL << RTC_ALRMAR_HU_Pos)            /*!< 0x00020000 */
#define RTC_ALRMAR_HU_2                     (0x4UL << RTC_ALRMAR_HU_Pos)            /*!< 0x00040000 */
#define RTC_ALRMAR_HU_3                     (0x8UL << RTC_ALRMAR_HU_Pos)            /*!< 0x00080000 */
#define RTC_ALRMAR_HT_Pos                   (20U)
#define RTC_ALRMAR_HT_Msk                   (0x3UL << RTC_ALRMAR_HT_Pos)            /*!< 0x00300000 */
#define RTC_ALRMAR_HT                       RTC_ALRMAR_HT_Msk
#define RTC_ALRMAR_HT_0                     (0x1UL << RTC_ALRMAR_HT_Pos)            /*!< 0x00100000 */
#define RTC_ALRMAR_HT_1                     (0x2UL << RTC_ALRMAR_HT_Pos)            /*!< 0x00200000 */
#define RTC_ALRMAR_PM_Pos                   (22U)
#define RTC_ALRMAR_PM_Msk                   (0x1UL << RTC_ALRMAR_PM_Pos)            /*!< 0x00400000 */
#define RTC_ALRMAR_PM                       RTC_ALRMAR_PM_Msk
#define RTC_ALRMAR_MSK3_Pos                 (23U)
#define RTC_ALRMAR_MSK3_Msk                 (0x1UL << RTC_ALRMAR_MSK3_Pos)          /*!< 0x00800000 */
#define RTC_ALRMAR_MSK3                     RTC_ALRMAR_MSK3_Msk
#define RTC_ALRMAR_DU_Pos                   (24U)
#define RTC_ALRMAR_DU_Msk                   (0xFUL << RTC_ALRMAR_DU_Pos)            /*!< 0x0F000000 */
#define RTC_ALRMAR_DU                       RTC_ALRMAR_DU_Msk
#define RTC_ALRMAR_DU_0                     (0x1UL << RTC_ALRMAR_DU_Pos)            /*!< 0x01000000 */
#define RTC_ALRMAR_DU_1                     (0x2UL << RTC_ALRMAR_DU_Pos)            /*!< 0x02000000 */
#define RTC_ALRMAR_DU_2                     (0x4UL << RTC_ALRMAR_DU_Pos)            /*!< 0x04000000 */
#define RTC_ALRMAR_DU_3                     (0x8UL << RTC_ALRMAR_DU_Pos)            /*!< 0x08000000 */
#define RTC_ALRMAR_DT_Pos                   (28U)
#define RTC_ALRMAR_DT_Msk                   (0x3UL << RTC_ALRMAR_DT_Pos)            /*!< 0x30000000 */
#define RTC_ALRMAR_DT                       RTC_ALRMAR_DT_Msk
#define RTC_ALRMAR_DT_0                     (0x1UL << RTC_ALRMAR_DT_Pos)            /*!< 0x10000000 */
#define RTC_ALRMAR_DT_1                     (0x2UL << RTC_ALRMAR_DT_Pos)            /*!< 0x20000000 */
#define RTC_ALRMAR_WDSEL_Pos                (30U)
#define RTC_ALRMAR_WDSEL_Msk                (0x1UL << RTC_ALRMAR_WDSEL_Pos)         /*!< 0x40000000 */
#define RTC_ALRMAR_WDSEL                    RTC_ALRMAR_WDSEL_Msk
#define RTC_ALRMAR_MSK4_Pos                 (31U)
#define RTC_ALRMAR_MSK4_Msk                 (0x1UL << RTC_ALRMAR_MSK4_Pos)          /*!< 0x80000000 */
#define RTC_ALRMAR_MSK4                     RTC_ALRMAR_MSK4_Msk
#define RTC_ALRMASSR_SS_Pos                 (0U)
#define RTC_ALRMASSR_SS_Msk                 (0x7FFFUL << RTC_ALRMASSR_SS_Pos)       /*!< 0x00007FFF */
#define RTC_ALRMASSR_SS                     RTC_ALRMASSR_SS_Msk
#define RTC_ALRMASSR_MASKSS_Pos             (24U)
#define RTC_ALRMASSR_MASKSS_Msk             (0x3FUL << RTC_ALRMASSR_MASKSS_Pos)     /*!< 0x3F000000 */
#define RTC_ALRMASSR_MASKSS                 RTC_ALRMASSR_MASKSS_Msk
#define RTC_ALRMASSR_MASKSS_0               (0x1UL << RTC_ALRMASSR_MASKSS_Pos)      /*!< 0x01000000 */
#define RTC_ALRMASSR_MASKSS_1               (0x2UL << RTC_ALRMASSR_MASKSS_Pos)      /*!< 0x02000000 */
#define RTC_ALRMASSR_MASKSS_2               (0x4UL << RTC_ALRMASSR_MASKSS_Pos)      /*!< 0x04000000 */
#define RTC_ALRMASSR_MASKSS_3               (0x8UL << RTC_ALRMASSR_MASKSS_Pos)      /*!< 0x08000000 */
#define RTC_ALRMASSR_MASKSS_4               (0x10UL << RTC_ALRMASSR_MASKSS_Pos)     /*!< 0x10000000 */
#define RTC_ALRMASSR_MASKSS_5               (0x20UL << RTC_ALRMASSR_MASKSS_Pos)     /*!< 0x20000000 */
#define RTC_ALRMASSR_SSCLR_Pos              (31U)
#define RTC_ALRMASSR_SSCLR_Msk              (0x1UL << RTC_ALRMASSR_SSCLR_Pos)       /*!< 0x80000000 */
#define RTC_ALRMASSR_SSCLR                  RTC_ALRMASSR_SSCLR_Msk
#define RTC_ALRMBR_SU_Pos                   (0U)
#define RTC_ALRMBR_SU_Msk                   (0xFUL << RTC_ALRMBR_SU_Pos)            /*!< 0x0000000F */
#define RTC_ALRMBR_SU                       RTC_ALRMBR_SU_Msk
#define RTC_ALRMBR_SU_0                     (0x1UL << RTC_ALRMBR_SU_Pos)            /*!< 0x00000001 */
#define RTC_ALRMBR_SU_1                     (0x2UL << RTC_ALRMBR_SU_Pos)            /*!< 0x00000002 */
#define RTC_ALRMBR_SU_2                     (0x4UL << RTC_ALRMBR_SU_Pos)            /*!< 0x00000004 */
#define RTC_ALRMBR_SU_3                     (0x8UL << RTC_ALRMBR_SU_Pos)            /*!< 0x00000008 */
#define RTC_ALRMBR_ST_Pos                   (4U)
#define RTC_ALRMBR_ST_Msk                   (0x7UL << RTC_ALRMBR_ST_Pos)            /*!< 0x00000070 */
#define RTC_ALRMBR_ST                       RTC_ALRMBR_ST_Msk
#define RTC_ALRMBR_ST_0                     (0x1UL << RTC_ALRMBR_ST_Pos)            /*!< 0x00000010 */
#define RTC_ALRMBR_ST_1                     (0x2UL << RTC_ALRMBR_ST_Pos)            /*!< 0x00000020 */
#define RTC_ALRMBR_ST_2                     (0x4UL << RTC_ALRMBR_ST_Pos)            /*!< 0x00000040 */
#define RTC_ALRMBR_MSK1_Pos                 (7U)
#define RTC_ALRMBR_MSK1_Msk                 (0x1UL << RTC_ALRMBR_MSK1_Pos)          /*!< 0x00000080 */
#define RTC_ALRMBR_MSK1                     RTC_ALRMBR_MSK1_Msk
#define RTC_ALRMBR_MNU_Pos                  (8U)
#define RTC_ALRMBR_MNU_Msk                  (0xFUL << RTC_ALRMBR_MNU_Pos)           /*!< 0x00000F00 */
#define RTC_ALRMBR_MNU                      RTC_ALRMBR_MNU_Msk
#define RTC_ALRMBR_MNU_0                    (0x1UL << RTC_ALRMBR_MNU_Pos)           /*!< 0x00000100 */
#define RTC_ALRMBR_MNU_1                    (0x2UL << RTC_ALRMBR_MNU_Pos)           /*!< 0x00000200 */
#define RTC_ALRMBR_MNU_2                    (0x4UL << RTC_ALRMBR_MNU_Pos)           /*!< 0x00000400 */
#define RTC_ALRMBR_MNU_3                    (0x8UL << RTC_ALRMBR_MNU_Pos)           /*!< 0x00000800 */
#define RTC_ALRMBR_MNT_Pos                  (12U)
#define RTC_ALRMBR_MNT_Msk                  (0x7UL << RTC_ALRMBR_MNT_Pos)           /*!< 0x00007000 */
#define RTC_ALRMBR_MNT                      RTC_ALRMBR_MNT_Msk
#define RTC_ALRMBR_MNT_0                    (0x1UL << RTC_ALRMBR_MNT_Pos)           /*!< 0x00001000 */
#define RTC_ALRMBR_MNT_1                    (0x2UL << RTC_ALRMBR_MNT_Pos)           /*!< 0x00002000 */
#define RTC_ALRMBR_MNT_2                    (0x4UL << RTC_ALRMBR_MNT_Pos)           /*!< 0x00004000 */
#define RTC_ALRMBR_MSK2_Pos                 (15U)
#define RTC_ALRMBR_MSK2_Msk                 (0x1UL << RTC_ALRMBR_MSK2_Pos)          /*!< 0x00008000 */
#define RTC_ALRMBR_MSK2                     RTC_ALRMBR_MSK2_Msk
#define RTC_ALRMBR_HU_Pos                   (16U)
#define RTC_ALRMBR_HU_Msk                   (0xFUL << RTC_ALRMBR_HU_Pos)            /*!< 0x000F0000 */
#define RTC_ALRMBR_HU                       RTC_ALRMBR_HU_Msk
#define RTC_ALRMBR_HU_0                     (0x1UL << RTC_ALRMBR_HU_Pos)            /*!< 0x00010000 */
#define RTC_ALRMBR_HU_1                     (0x2UL << RTC_ALRMBR_HU_Pos)            /*!< 0x00020000 */
#define RTC_ALRMBR_HU_2                     (0x4UL << RTC_ALRMBR_HU_Pos)            /*!< 0x00040000 */
#define RTC_ALRMBR_HU_3                     (0x8UL << RTC_ALRMBR_HU_Pos)            /*!< 0x00080000 */
#define RTC_ALRMBR_HT_Pos                   (20U)
#define RTC_ALRMBR_HT_Msk                   (0x3UL << RTC_ALRMBR_HT_Pos)            /*!< 0x00300000 */
#define RTC_ALRMBR_HT                       RTC_ALRMBR_HT_Msk
#define RTC_ALRMBR_HT_0                     (0x1UL << RTC_ALRMBR_HT_Pos)            /*!< 0x00100000 */
#define RTC_ALRMBR_HT_1                     (0x2UL << RTC_ALRMBR_HT_Pos)            /*!< 0x00200000 */
#define RTC_ALRMBR_PM_Pos                   (22U)
#define RTC_ALRMBR_PM_Msk                   (0x1UL << RTC_ALRMBR_PM_Pos)            /*!< 0x00400000 */
#define RTC_ALRMBR_PM                       RTC_ALRMBR_PM_Msk
#define RTC_ALRMBR_MSK3_Pos                 (23U)
#define RTC_ALRMBR_MSK3_Msk                 (0x1UL << RTC_ALRMBR_MSK3_Pos)          /*!< 0x00800000 */
#define RTC_ALRMBR_MSK3                     RTC_ALRMBR_MSK3_Msk
#define RTC_ALRMBR_DU_Pos                   (24U)
#define RTC_ALRMBR_DU_Msk                   (0xFUL << RTC_ALRMBR_DU_Pos)            /*!< 0x0F000000 */
#define RTC_ALRMBR_DU                       RTC_ALRMBR_DU_Msk
#define RTC_ALRMBR_DU_0                     (0x1UL << RTC_ALRMBR_DU_Pos)            /*!< 0x01000000 */
#define RTC_ALRMBR_DU_1                     (0x2UL << RTC_ALRMBR_DU_Pos)            /*!< 0x02000000 */
#define RTC_ALRMBR_DU_2                     (0x4UL << RTC_ALRMBR_DU_Pos)            /*!< 0x04000000 */
#define RTC_ALRMBR_DU_3                     (0x8UL << RTC_ALRMBR_DU_Pos)            /*!< 0x08000000 */
#define RTC_ALRMBR_DT_Pos                   (28U)
#define RTC_ALRMBR_DT_Msk                   (0x3UL << RTC_ALRMBR_DT_Pos)            /*!< 0x30000000 */
#define RTC_ALRMBR_DT                       RTC_ALRMBR_DT_Msk
#define RTC_ALRMBR_DT_0                     (0x1UL << RTC_ALRMBR_DT_Pos)            /*!< 0x10000000 */
#define RTC_ALRMBR_DT_1                     (0x2UL << RTC_ALRMBR_DT_Pos)            /*!< 0x20000000 */
#define RTC_ALRMBR_WDSEL_Pos                (30U)
#define RTC_ALRMBR_WDSEL_Msk                (0x1UL << RTC_ALRMBR_WDSEL_Pos)         /*!< 0x40000000 */
#define RTC_ALRMBR_WDSEL                    RTC_ALRMBR_WDSEL_Msk
#define RTC_ALRMBR_MSK4_Pos                 (31U)
#define RTC_ALRMBR_MSK4_Msk                 (0x1UL << RTC_ALRMBR_MSK4_Pos)          /*!< 0x80000000 */
#define RTC_ALRMBR_MSK4                     RTC_ALRMBR_MSK4_Msk
#define RTC_ALRMBSSR_SS_Pos                 (0U)
#define RTC_ALRMBSSR_SS_Msk                 (0x7FFFUL << RTC_ALRMBSSR_SS_Pos)       /*!< 0x00007FFF */
#define RTC_ALRMBSSR_SS                     RTC_ALRMBSSR_SS_Msk
#define RTC_ALRMBSSR_MASKSS_Pos             (24U)
#define RTC_ALRMBSSR_MASKSS_Msk             (0x3FUL << RTC_ALRMBSSR_MASKSS_Pos)     /*!< 0x3F000000 */
#define RTC_ALRMBSSR_MASKSS                 RTC_ALRMBSSR_MASKSS_Msk
#define RTC_ALRMBSSR_MASKSS_0               (0x1UL << RTC_ALRMBSSR_MASKSS_Pos)      /*!< 0x01000000 */
#define RTC_ALRMBSSR_MASKSS_1               (0x2UL << RTC_ALRMBSSR_MASKSS_Pos)      /*!< 0x02000000 */
#define RTC_ALRMBSSR_MASKSS_2               (0x4UL << RTC_ALRMBSSR_MASKSS_Pos)      /*!< 0x04000000 */
#define RTC_ALRMBSSR_MASKSS_3               (0x8UL << RTC_ALRMBSSR_MASKSS_Pos)      /*!< 0x08000000 */
#define RTC_ALRMBSSR_MASKSS_4               (0x10UL << RTC_ALRMBSSR_MASKSS_Pos)     /*!< 0x10000000 */
#define RTC_ALRMBSSR_MASKSS_5               (0x20UL << RTC_ALRMBSSR_MASKSS_Pos)     /*!< 0x20000000 */
#define RTC_ALRMBSSR_SSCLR_Pos              (31U)
#define RTC_ALRMBSSR_SSCLR_Msk              (0x1UL << RTC_ALRMBSSR_SSCLR_Pos)       /*!< 0x80000000 */
#define RTC_ALRMBSSR_SSCLR                  RTC_ALRMBSSR_SSCLR_Msk
#define RTC_SR_ALRAF_Pos                    (0U)
#define RTC_SR_ALRAF_Msk                    (0x1UL << RTC_SR_ALRAF_Pos)             /*!< 0x00000001 */
#define RTC_SR_ALRAF                        RTC_SR_ALRAF_Msk
#define RTC_SR_ALRBF_Pos                    (1U)
#define RTC_SR_ALRBF_Msk                    (0x1UL << RTC_SR_ALRBF_Pos)             /*!< 0x00000002 */
#define RTC_SR_ALRBF                        RTC_SR_ALRBF_Msk
#define RTC_SR_WUTF_Pos                     (2U)
#define RTC_SR_WUTF_Msk                     (0x1UL << RTC_SR_WUTF_Pos)              /*!< 0x00000004 */
#define RTC_SR_WUTF                         RTC_SR_WUTF_Msk
#define RTC_SR_TSF_Pos                      (3U)
#define RTC_SR_TSF_Msk                      (0x1UL << RTC_SR_TSF_Pos)               /*!< 0x00000008 */
#define RTC_SR_TSF                          RTC_SR_TSF_Msk
#define RTC_SR_TSOVF_Pos                    (4U)
#define RTC_SR_TSOVF_Msk                    (0x1UL << RTC_SR_TSOVF_Pos)             /*!< 0x00000010 */
#define RTC_SR_TSOVF                        RTC_SR_TSOVF_Msk
#define RTC_SR_ITSF_Pos                     (5U)
#define RTC_SR_ITSF_Msk                     (0x1UL << RTC_SR_ITSF_Pos)              /*!< 0x00000020 */
#define RTC_SR_ITSF                         RTC_SR_ITSF_Msk
#define RTC_SR_SSRUF_Pos                    (6U)
#define RTC_SR_SSRUF_Msk                    (0x1UL << RTC_SR_SSRUF_Pos)             /*!< 0x00000040 */
#define RTC_SR_SSRUF                        RTC_SR_SSRUF_Msk
#define RTC_MISR_ALRAMF_Pos                 (0U)
#define RTC_MISR_ALRAMF_Msk                 (0x1UL << RTC_MISR_ALRAMF_Pos)          /*!< 0x00000001 */
#define RTC_MISR_ALRAMF                     RTC_MISR_ALRAMF_Msk
#define RTC_MISR_ALRBMF_Pos                 (1U)
#define RTC_MISR_ALRBMF_Msk                 (0x1UL << RTC_MISR_ALRBMF_Pos)          /*!< 0x00000002 */
#define RTC_MISR_ALRBMF                     RTC_MISR_ALRBMF_Msk
#define RTC_MISR_WUTMF_Pos                  (2U)
#define RTC_MISR_WUTMF_Msk                  (0x1UL << RTC_MISR_WUTMF_Pos)           /*!< 0x00000004 */
#define RTC_MISR_WUTMF                      RTC_MISR_WUTMF_Msk
#define RTC_MISR_TSMF_Pos                   (3U)
#define RTC_MISR_TSMF_Msk                   (0x1UL << RTC_MISR_TSMF_Pos)            /*!< 0x00000008 */
#define RTC_MISR_TSMF                       RTC_MISR_TSMF_Msk
#define RTC_MISR_TSOVMF_Pos                 (4U)
#define RTC_MISR_TSOVMF_Msk                 (0x1UL << RTC_MISR_TSOVMF_Pos)          /*!< 0x00000010 */
#define RTC_MISR_TSOVMF                     RTC_MISR_TSOVMF_Msk
#define RTC_MISR_ITSMF_Pos                  (5U)
#define RTC_MISR_ITSMF_Msk                  (0x1UL << RTC_MISR_ITSMF_Pos)           /*!< 0x00000020 */
#define RTC_MISR_ITSMF                      RTC_MISR_ITSMF_Msk
#define RTC_MISR_SSRUMF_Pos                 (6U)
#define RTC_MISR_SSRUMF_Msk                 (0x1UL << RTC_MISR_SSRUMF_Pos)          /*!< 0x00000040 */
#define RTC_MISR_SSRUMF                     RTC_MISR_SSRUMF_Msk
#define RTC_SCR_CALRAF_Pos                  (0U)
#define RTC_SCR_CALRAF_Msk                  (0x1UL << RTC_SCR_CALRAF_Pos)           /*!< 0x00000001 */
#define RTC_SCR_CALRAF                      RTC_SCR_CALRAF_Msk
#define RTC_SCR_CALRBF_Pos                  (1U)
#define RTC_SCR_CALRBF_Msk                  (0x1UL << RTC_SCR_CALRBF_Pos)           /*!< 0x00000002 */
#define RTC_SCR_CALRBF                      RTC_SCR_CALRBF_Msk
#define RTC_SCR_CWUTF_Pos                   (2U)
#define RTC_SCR_CWUTF_Msk                   (0x1UL << RTC_SCR_CWUTF_Pos)            /*!< 0x00000004 */
#define RTC_SCR_CWUTF                       RTC_SCR_CWUTF_Msk
#define RTC_SCR_CTSF_Pos                    (3U)
#define RTC_SCR_CTSF_Msk                    (0x1UL << RTC_SCR_CTSF_Pos)             /*!< 0x00000008 */
#define RTC_SCR_CTSF                        RTC_SCR_CTSF_Msk
#define RTC_SCR_CTSOVF_Pos                  (4U)
#define RTC_SCR_CTSOVF_Msk                  (0x1UL << RTC_SCR_CTSOVF_Pos)           /*!< 0x00000010 */
#define RTC_SCR_CTSOVF                      RTC_SCR_CTSOVF_Msk
#define RTC_SCR_CITSF_Pos                   (5U)
#define RTC_SCR_CITSF_Msk                   (0x1UL << RTC_SCR_CITSF_Pos)            /*!< 0x00000020 */
#define RTC_SCR_CITSF                       RTC_SCR_CITSF_Msk
#define RTC_SCR_CSSRUF_Pos                  (6U)
#define RTC_SCR_CSSRUF_Msk                  (0x1UL << RTC_SCR_CSSRUF_Pos)           /*!< 0x00000040 */
#define RTC_SCR_CSSRUF                      RTC_SCR_CSSRUF_Msk
#define RTC_ALRABINR_SS_Pos                 (0U)
#define RTC_ALRABINR_SS_Msk                 (0xFFFFFFFFUL << RTC_ALRABINR_SS_Pos)   /*!< 0xFFFFFFFF */
#define RTC_ALRABINR_SS                     RTC_ALRABINR_SS_Msk
#define RTC_ALRBBINR_SS_Pos                 (0U)
#define RTC_ALRBBINR_SS_Msk                 (0xFFFFFFFFUL << RTC_ALRBBINR_SS_Pos)   /*!< 0xFFFFFFFF */
#define RTC_ALRBBINR_SS                     RTC_ALRBBINR_SS_Msk
#define TAMP_CR1_TAMP1E_Pos                 (0U)
#define TAMP_CR1_TAMP1E_Msk                 (0x1UL << TAMP_CR1_TAMP1E_Pos)          /*!< 0x00000001 */
#define TAMP_CR1_TAMP1E                     TAMP_CR1_TAMP1E_Msk
#define TAMP_CR1_TAMP2E_Pos                 (1U)
#define TAMP_CR1_TAMP2E_Msk                 (0x1UL << TAMP_CR1_TAMP2E_Pos)          /*!< 0x00000002 */
#define TAMP_CR1_TAMP2E                     TAMP_CR1_TAMP2E_Msk
#define TAMP_CR1_TAMP3E_Pos                 (2U)
#define TAMP_CR1_TAMP3E_Msk                 (0x1UL << TAMP_CR1_TAMP3E_Pos)          /*!< 0x00000004 */
#define TAMP_CR1_TAMP3E                     TAMP_CR1_TAMP3E_Msk
#define TAMP_CR1_TAMP4E_Pos                 (3U)
#define TAMP_CR1_TAMP4E_Msk                 (0x1UL << TAMP_CR1_TAMP4E_Pos)          /*!< 0x00000008 */
#define TAMP_CR1_TAMP4E                     TAMP_CR1_TAMP4E_Msk
#define TAMP_CR1_TAMP5E_Pos                 (4U)
#define TAMP_CR1_TAMP5E_Msk                 (0x1UL << TAMP_CR1_TAMP5E_Pos)          /*!< 0x00000010 */
#define TAMP_CR1_TAMP5E                     TAMP_CR1_TAMP5E_Msk
#define TAMP_CR1_TAMP6E_Pos                 (5U)
#define TAMP_CR1_TAMP6E_Msk                 (0x1UL << TAMP_CR1_TAMP6E_Pos)          /*!< 0x00000020 */
#define TAMP_CR1_TAMP6E                     TAMP_CR1_TAMP6E_Msk
#define TAMP_CR1_TAMP7E_Pos                 (6U)
#define TAMP_CR1_TAMP7E_Msk                 (0x1UL << TAMP_CR1_TAMP7E_Pos)          /*!< 0x00000040 */
#define TAMP_CR1_TAMP7E                     TAMP_CR1_TAMP7E_Msk
#define TAMP_CR1_TAMP8E_Pos                 (7U)
#define TAMP_CR1_TAMP8E_Msk                 (0x1UL << TAMP_CR1_TAMP8E_Pos)          /*!< 0x00000080 */
#define TAMP_CR1_TAMP8E                     TAMP_CR1_TAMP8E_Msk
#define TAMP_CR1_ITAMP1E_Pos                (16U)
#define TAMP_CR1_ITAMP1E_Msk                (0x1UL << TAMP_CR1_ITAMP1E_Pos)         /*!< 0x00010000 */
#define TAMP_CR1_ITAMP1E                    TAMP_CR1_ITAMP1E_Msk
#define TAMP_CR1_ITAMP2E_Pos                (17U)
#define TAMP_CR1_ITAMP2E_Msk                (0x1UL << TAMP_CR1_ITAMP2E_Pos)         /*!< 0x00020000 */
#define TAMP_CR1_ITAMP2E                    TAMP_CR1_ITAMP2E_Msk
#define TAMP_CR1_ITAMP3E_Pos                (18U)
#define TAMP_CR1_ITAMP3E_Msk                (0x1UL << TAMP_CR1_ITAMP3E_Pos)         /*!< 0x00040000 */
#define TAMP_CR1_ITAMP3E                    TAMP_CR1_ITAMP3E_Msk
#define TAMP_CR1_ITAMP4E_Pos                (19U)
#define TAMP_CR1_ITAMP4E_Msk                (0x1UL << TAMP_CR1_ITAMP4E_Pos)         /*!< 0x00080000 */
#define TAMP_CR1_ITAMP4E                    TAMP_CR1_ITAMP4E_Msk
#define TAMP_CR1_ITAMP5E_Pos                (20U)
#define TAMP_CR1_ITAMP5E_Msk                (0x1UL << TAMP_CR1_ITAMP5E_Pos)         /*!< 0x00100000 */
#define TAMP_CR1_ITAMP5E                    TAMP_CR1_ITAMP5E_Msk
#define TAMP_CR1_ITAMP6E_Pos                (21U)
#define TAMP_CR1_ITAMP6E_Msk                (0x1UL << TAMP_CR1_ITAMP6E_Pos)         /*!< 0x00200000 */
#define TAMP_CR1_ITAMP6E                    TAMP_CR1_ITAMP6E_Msk
#define TAMP_CR1_ITAMP7E_Pos                (22U)
#define TAMP_CR1_ITAMP7E_Msk                (0x1UL << TAMP_CR1_ITAMP7E_Pos)         /*!< 0x00400000 */
#define TAMP_CR1_ITAMP7E                    TAMP_CR1_ITAMP7E_Msk
#define TAMP_CR1_ITAMP8E_Pos                (23U)
#define TAMP_CR1_ITAMP8E_Msk                (0x1UL << TAMP_CR1_ITAMP8E_Pos)         /*!< 0x00800000 */
#define TAMP_CR1_ITAMP8E                    TAMP_CR1_ITAMP8E_Msk
#define TAMP_CR1_ITAMP9E_Pos                (24U)
#define TAMP_CR1_ITAMP9E_Msk                (0x1UL << TAMP_CR1_ITAMP9E_Pos)         /*!< 0x01000000 */
#define TAMP_CR1_ITAMP9E                    TAMP_CR1_ITAMP9E_Msk
#define TAMP_CR1_ITAMP11E_Pos               (26U)
#define TAMP_CR1_ITAMP11E_Msk               (0x1UL << TAMP_CR1_ITAMP11E_Pos)        /*!< 0x04000000 */
#define TAMP_CR1_ITAMP11E                   TAMP_CR1_ITAMP11E_Msk
#define TAMP_CR1_ITAMP15E_Pos               (30U)
#define TAMP_CR1_ITAMP15E_Msk               (0x1UL << TAMP_CR1_ITAMP15E_Pos)        /*!< 0x40000000 */
#define TAMP_CR1_ITAMP15E                   TAMP_CR1_ITAMP15E_Msk
#define TAMP_CR2_TAMP1POM_Pos               (0U)
#define TAMP_CR2_TAMP1POM_Msk               (0x1UL << TAMP_CR2_TAMP1POM_Pos)        /*!< 0x00000001 */
#define TAMP_CR2_TAMP1POM                   TAMP_CR2_TAMP1POM_Msk
#define TAMP_CR2_TAMP2POM_Pos               (1U)
#define TAMP_CR2_TAMP2POM_Msk               (0x1UL << TAMP_CR2_TAMP2POM_Pos)        /*!< 0x00000002 */
#define TAMP_CR2_TAMP2POM                   TAMP_CR2_TAMP2POM_Msk
#define TAMP_CR2_TAMP3POM_Pos               (2U)
#define TAMP_CR2_TAMP3POM_Msk               (0x1UL << TAMP_CR2_TAMP3POM_Pos)        /*!< 0x00000004 */
#define TAMP_CR2_TAMP3POM                   TAMP_CR2_TAMP3POM_Msk
#define TAMP_CR2_TAMP4POM_Pos               (3U)
#define TAMP_CR2_TAMP4POM_Msk               (0x1UL << TAMP_CR2_TAMP4POM_Pos)        /*!< 0x00000008 */
#define TAMP_CR2_TAMP4POM                   TAMP_CR2_TAMP4POM_Msk
#define TAMP_CR2_TAMP5POM_Pos               (4U)
#define TAMP_CR2_TAMP5POM_Msk               (0x1UL << TAMP_CR2_TAMP5POM_Pos)        /*!< 0x00000010 */
#define TAMP_CR2_TAMP5POM                   TAMP_CR2_TAMP5POM_Msk
#define TAMP_CR2_TAMP6POM_Pos               (5U)
#define TAMP_CR2_TAMP6POM_Msk               (0x1UL << TAMP_CR2_TAMP6POM_Pos)        /*!< 0x00000020 */
#define TAMP_CR2_TAMP6POM                   TAMP_CR2_TAMP6POM_Msk
#define TAMP_CR2_TAMP7POM_Pos               (6U)
#define TAMP_CR2_TAMP7POM_Msk               (0x1UL << TAMP_CR2_TAMP7POM_Pos)        /*!< 0x00000040 */
#define TAMP_CR2_TAMP7POM                   TAMP_CR2_TAMP7POM_Msk
#define TAMP_CR2_TAMP8POM_Pos               (7U)
#define TAMP_CR2_TAMP8POM_Msk               (0x1UL << TAMP_CR2_TAMP8POM_Pos)        /*!< 0x00000080 */
#define TAMP_CR2_TAMP8POM                   TAMP_CR2_TAMP8POM_Msk
#define TAMP_CR2_TAMP1MSK_Pos               (16U)
#define TAMP_CR2_TAMP1MSK_Msk               (0x1UL << TAMP_CR2_TAMP1MSK_Pos)        /*!< 0x00010000 */
#define TAMP_CR2_TAMP1MSK                   TAMP_CR2_TAMP1MSK_Msk
#define TAMP_CR2_TAMP2MSK_Pos               (17U)
#define TAMP_CR2_TAMP2MSK_Msk               (0x1UL << TAMP_CR2_TAMP2MSK_Pos)        /*!< 0x00020000 */
#define TAMP_CR2_TAMP2MSK                   TAMP_CR2_TAMP2MSK_Msk
#define TAMP_CR2_TAMP3MSK_Pos               (18U)
#define TAMP_CR2_TAMP3MSK_Msk               (0x1UL << TAMP_CR2_TAMP3MSK_Pos)        /*!< 0x00040000 */
#define TAMP_CR2_TAMP3MSK                   TAMP_CR2_TAMP3MSK_Msk
#define TAMP_CR2_BKBLOCK_Pos                (22U)
#define TAMP_CR2_BKBLOCK_Msk                (0x1UL << TAMP_CR2_BKBLOCK_Pos)         /*!< 0x00400000 */
#define TAMP_CR2_BKBLOCK                    TAMP_CR2_BKBLOCK_Msk
#define TAMP_CR2_BKERASE_Pos                (23U)
#define TAMP_CR2_BKERASE_Msk                (0x1UL << TAMP_CR2_BKERASE_Pos)         /*!< 0x00800000 */
#define TAMP_CR2_BKERASE                    TAMP_CR2_BKERASE_Msk
#define TAMP_CR2_TAMP1TRG_Pos               (24U)
#define TAMP_CR2_TAMP1TRG_Msk               (0x1UL << TAMP_CR2_TAMP1TRG_Pos)        /*!< 0x01000000 */
#define TAMP_CR2_TAMP1TRG                   TAMP_CR2_TAMP1TRG_Msk
#define TAMP_CR2_TAMP2TRG_Pos               (25U)
#define TAMP_CR2_TAMP2TRG_Msk               (0x1UL << TAMP_CR2_TAMP2TRG_Pos)        /*!< 0x02000000 */
#define TAMP_CR2_TAMP2TRG                   TAMP_CR2_TAMP2TRG_Msk
#define TAMP_CR2_TAMP3TRG_Pos               (26U)
#define TAMP_CR2_TAMP3TRG_Msk               (0x1UL << TAMP_CR2_TAMP3TRG_Pos)        /*!< 0x02000000 */
#define TAMP_CR2_TAMP3TRG                   TAMP_CR2_TAMP3TRG_Msk
#define TAMP_CR2_TAMP4TRG_Pos               (27U)
#define TAMP_CR2_TAMP4TRG_Msk               (0x1UL << TAMP_CR2_TAMP4TRG_Pos)        /*!< 0x02000000 */
#define TAMP_CR2_TAMP4TRG                   TAMP_CR2_TAMP4TRG_Msk
#define TAMP_CR2_TAMP5TRG_Pos               (28U)
#define TAMP_CR2_TAMP5TRG_Msk               (0x1UL << TAMP_CR2_TAMP5TRG_Pos)        /*!< 0x02000000 */
#define TAMP_CR2_TAMP5TRG                   TAMP_CR2_TAMP5TRG_Msk
#define TAMP_CR2_TAMP6TRG_Pos               (29U)
#define TAMP_CR2_TAMP6TRG_Msk               (0x1UL << TAMP_CR2_TAMP6TRG_Pos)        /*!< 0x02000000 */
#define TAMP_CR2_TAMP6TRG                   TAMP_CR2_TAMP6TRG_Msk
#define TAMP_CR2_TAMP7TRG_Pos               (30U)
#define TAMP_CR2_TAMP7TRG_Msk               (0x1UL << TAMP_CR2_TAMP7TRG_Pos)        /*!< 0x02000000 */
#define TAMP_CR2_TAMP7TRG                   TAMP_CR2_TAMP7TRG_Msk
#define TAMP_CR2_TAMP8TRG_Pos               (31U)
#define TAMP_CR2_TAMP8TRG_Msk               (0x1UL << TAMP_CR2_TAMP8TRG_Pos)        /*!< 0x02000000 */
#define TAMP_CR2_TAMP8TRG                   TAMP_CR2_TAMP8TRG_Msk
#define TAMP_CR3_ITAMP1POM_Pos             (0U)
#define TAMP_CR3_ITAMP1POM_Msk             (0x1UL << TAMP_CR3_ITAMP1POM_Pos)        /*!< 0x00000001 */
#define TAMP_CR3_ITAMP1POM                 TAMP_CR3_ITAMP1POM_Msk
#define TAMP_CR3_ITAMP2POM_Pos             (1U)
#define TAMP_CR3_ITAMP2POM_Msk             (0x1UL << TAMP_CR3_ITAMP2POM_Pos)        /*!< 0x00000002 */
#define TAMP_CR3_ITAMP2POM                 TAMP_CR3_ITAMP2POM_Msk
#define TAMP_CR3_ITAMP3POM_Pos             (2U)
#define TAMP_CR3_ITAMP3POM_Msk             (0x1UL << TAMP_CR3_ITAMP3POM_Pos)        /*!< 0x00000004 */
#define TAMP_CR3_ITAMP3POM                 TAMP_CR3_ITAMP3POM_Msk
#define TAMP_CR3_ITAMP4POM_Pos             (3U)
#define TAMP_CR3_ITAMP4POM_Msk             (0x1UL << TAMP_CR3_ITAMP4POM_Pos)        /*!< 0x00000008 */
#define TAMP_CR3_ITAMP4POM                 TAMP_CR3_ITAMP4POM_Msk
#define TAMP_CR3_ITAMP5POM_Pos             (4U)
#define TAMP_CR3_ITAMP5POM_Msk             (0x1UL << TAMP_CR3_ITAMP5POM_Pos)        /*!< 0x00000010 */
#define TAMP_CR3_ITAMP5POM                 TAMP_CR3_ITAMP5POM_Msk
#define TAMP_CR3_ITAMP6POM_Pos             (5U)
#define TAMP_CR3_ITAMP6POM_Msk             (0x1UL << TAMP_CR3_ITAMP6POM_Pos)        /*!< 0x00000020 */
#define TAMP_CR3_ITAMP6POM                 TAMP_CR3_ITAMP6POM_Msk
#define TAMP_CR3_ITAMP7POM_Pos             (6U)
#define TAMP_CR3_ITAMP7POM_Msk             (0x1UL << TAMP_CR3_ITAMP7POM_Pos)        /*!< 0x00000040 */
#define TAMP_CR3_ITAMP7POM                 TAMP_CR3_ITAMP7POM_Msk
#define TAMP_CR3_ITAMP8POM_Pos             (7U)
#define TAMP_CR3_ITAMP8POM_Msk             (0x1UL << TAMP_CR3_ITAMP8POM_Pos)        /*!< 0x00000080 */
#define TAMP_CR3_ITAMP8POM                 TAMP_CR3_ITAMP8POM_Msk
#define TAMP_CR3_ITAMP9POM_Pos             (8U)
#define TAMP_CR3_ITAMP9POM_Msk             (0x1UL << TAMP_CR3_ITAMP9POM_Pos)        /*!< 0x00000100 */
#define TAMP_CR3_ITAMP9POM                 TAMP_CR3_ITAMP9POM_Msk
#define TAMP_CR3_ITAMP11POM_Pos            (10U)
#define TAMP_CR3_ITAMP11POM_Msk            (0x1UL << TAMP_CR3_ITAMP11POM_Pos)       /*!< 0x00000400 */
#define TAMP_CR3_ITAMP11POM                TAMP_CR3_ITAMP11POM_Msk
#define TAMP_CR3_ITAMP15POM_Pos            (14U)
#define TAMP_CR3_ITAMP15POM_Msk            (0x1UL << TAMP_CR3_ITAMP15POM_Pos)       /*!< 0x00004000 */
#define TAMP_CR3_ITAMP15POM                TAMP_CR3_ITAMP15POM_Msk
#define TAMP_FLTCR_TAMPFREQ_Pos             (0U)
#define TAMP_FLTCR_TAMPFREQ_Msk             (0x7UL << TAMP_FLTCR_TAMPFREQ_Pos)      /*!< 0x00000007 */
#define TAMP_FLTCR_TAMPFREQ                 TAMP_FLTCR_TAMPFREQ_Msk
#define TAMP_FLTCR_TAMPFREQ_0               (0x1UL << TAMP_FLTCR_TAMPFREQ_Pos)      /*!< 0x00000001 */
#define TAMP_FLTCR_TAMPFREQ_1               (0x2UL << TAMP_FLTCR_TAMPFREQ_Pos)      /*!< 0x00000002 */
#define TAMP_FLTCR_TAMPFREQ_2               (0x4UL << TAMP_FLTCR_TAMPFREQ_Pos)      /*!< 0x00000004 */
#define TAMP_FLTCR_TAMPFLT_Pos              (3U)
#define TAMP_FLTCR_TAMPFLT_Msk              (0x3UL << TAMP_FLTCR_TAMPFLT_Pos)       /*!< 0x00000018 */
#define TAMP_FLTCR_TAMPFLT                  TAMP_FLTCR_TAMPFLT_Msk
#define TAMP_FLTCR_TAMPFLT_0                (0x1UL << TAMP_FLTCR_TAMPFLT_Pos)       /*!< 0x00000008 */
#define TAMP_FLTCR_TAMPFLT_1                (0x2UL << TAMP_FLTCR_TAMPFLT_Pos)       /*!< 0x00000010 */
#define TAMP_FLTCR_TAMPPRCH_Pos             (5U)
#define TAMP_FLTCR_TAMPPRCH_Msk             (0x3UL << TAMP_FLTCR_TAMPPRCH_Pos)      /*!< 0x00000060 */
#define TAMP_FLTCR_TAMPPRCH                 TAMP_FLTCR_TAMPPRCH_Msk
#define TAMP_FLTCR_TAMPPRCH_0               (0x1UL << TAMP_FLTCR_TAMPPRCH_Pos)      /*!< 0x00000020 */
#define TAMP_FLTCR_TAMPPRCH_1               (0x2UL << TAMP_FLTCR_TAMPPRCH_Pos)      /*!< 0x00000040 */
#define TAMP_FLTCR_TAMPPUDIS_Pos            (7U)
#define TAMP_FLTCR_TAMPPUDIS_Msk            (0x1UL << TAMP_FLTCR_TAMPPUDIS_Pos)     /*!< 0x00000080 */
#define TAMP_FLTCR_TAMPPUDIS                TAMP_FLTCR_TAMPPUDIS_Msk
#define TAMP_ATCR1_TAMP1AM_Pos              (0U)
#define TAMP_ATCR1_TAMP1AM_Msk              (0x1UL << TAMP_ATCR1_TAMP1AM_Pos)       /*!< 0x00000001 */
#define TAMP_ATCR1_TAMP1AM                  TAMP_ATCR1_TAMP1AM_Msk
#define TAMP_ATCR1_TAMP2AM_Pos              (1U)
#define TAMP_ATCR1_TAMP2AM_Msk              (0x1UL << TAMP_ATCR1_TAMP2AM_Pos)       /*!< 0x00000002 */
#define TAMP_ATCR1_TAMP2AM                  TAMP_ATCR1_TAMP2AM_Msk
#define TAMP_ATCR1_TAMP3AM_Pos              (2U)
#define TAMP_ATCR1_TAMP3AM_Msk              (0x1UL << TAMP_ATCR1_TAMP3AM_Pos)       /*!< 0x00000004 */
#define TAMP_ATCR1_TAMP3AM                  TAMP_ATCR1_TAMP3AM_Msk
#define TAMP_ATCR1_TAMP4AM_Pos              (3U)
#define TAMP_ATCR1_TAMP4AM_Msk              (0x1UL << TAMP_ATCR1_TAMP4AM_Pos)       /*!< 0x00000008 */
#define TAMP_ATCR1_TAMP4AM                  TAMP_ATCR1_TAMP4AM_Msk
#define TAMP_ATCR1_TAMP5AM_Pos              (4U)
#define TAMP_ATCR1_TAMP5AM_Msk              (0x1UL << TAMP_ATCR1_TAMP5AM_Pos)       /*!< 0x00000010 */
#define TAMP_ATCR1_TAMP5AM                  TAMP_ATCR1_TAMP5AM_Msk
#define TAMP_ATCR1_TAMP6AM_Pos              (5U)
#define TAMP_ATCR1_TAMP6AM_Msk              (0x1UL << TAMP_ATCR1_TAMP6AM_Pos)       /*!< 0x00000010 */
#define TAMP_ATCR1_TAMP6AM                  TAMP_ATCR1_TAMP6AM_Msk
#define TAMP_ATCR1_TAMP7AM_Pos              (6U)
#define TAMP_ATCR1_TAMP7AM_Msk              (0x1UL << TAMP_ATCR1_TAMP7AM_Pos)       /*!< 0x00000040 */
#define TAMP_ATCR1_TAMP7AM                  TAMP_ATCR1_TAMP7AM_Msk
#define TAMP_ATCR1_TAMP8AM_Pos              (7U)
#define TAMP_ATCR1_TAMP8AM_Msk              (0x1UL << TAMP_ATCR1_TAMP8AM_Pos)       /*!< 0x00000080 */
#define TAMP_ATCR1_TAMP8AM                  TAMP_ATCR1_TAMP8AM_Msk
#define TAMP_ATCR1_ATOSEL1_Pos              (8U)
#define TAMP_ATCR1_ATOSEL1_Msk              (0x3UL << TAMP_ATCR1_ATOSEL1_Pos)       /*!< 0x00000300 */
#define TAMP_ATCR1_ATOSEL1                  TAMP_ATCR1_ATOSEL1_Msk
#define TAMP_ATCR1_ATOSEL1_0                (0x1UL << TAMP_ATCR1_ATOSEL1_Pos)       /*!< 0x00000100 */
#define TAMP_ATCR1_ATOSEL1_1                (0x2UL << TAMP_ATCR1_ATOSEL1_Pos)       /*!< 0x00000200 */
#define TAMP_ATCR1_ATOSEL2_Pos              (10U)
#define TAMP_ATCR1_ATOSEL2_Msk              (0x3UL << TAMP_ATCR1_ATOSEL2_Pos)       /*!< 0x00000C00 */
#define TAMP_ATCR1_ATOSEL2                  TAMP_ATCR1_ATOSEL2_Msk
#define TAMP_ATCR1_ATOSEL2_0                (0x1UL << TAMP_ATCR1_ATOSEL2_Pos)       /*!< 0x00000400 */
#define TAMP_ATCR1_ATOSEL2_1                (0x2UL << TAMP_ATCR1_ATOSEL2_Pos)       /*!< 0x00000800 */
#define TAMP_ATCR1_ATOSEL3_Pos              (12U)
#define TAMP_ATCR1_ATOSEL3_Msk              (0x3UL << TAMP_ATCR1_ATOSEL3_Pos)       /*!< 0x00003000 */
#define TAMP_ATCR1_ATOSEL3                  TAMP_ATCR1_ATOSEL3_Msk
#define TAMP_ATCR1_ATOSEL3_0                (0x1UL << TAMP_ATCR1_ATOSEL3_Pos)       /*!< 0x00001000 */
#define TAMP_ATCR1_ATOSEL3_1                (0x2UL << TAMP_ATCR1_ATOSEL3_Pos)       /*!< 0x00002000 */
#define TAMP_ATCR1_ATOSEL4_Pos              (14U)
#define TAMP_ATCR1_ATOSEL4_Msk              (0x3UL << TAMP_ATCR1_ATOSEL4_Pos)       /*!< 0x0000C000 */
#define TAMP_ATCR1_ATOSEL4                  TAMP_ATCR1_ATOSEL4_Msk
#define TAMP_ATCR1_ATOSEL4_0                (0x1UL << TAMP_ATCR1_ATOSEL4_Pos)       /*!< 0x00004000 */
#define TAMP_ATCR1_ATOSEL4_1                (0x2UL << TAMP_ATCR1_ATOSEL4_Pos)       /*!< 0x00008000 */
#define TAMP_ATCR1_ATCKSEL_Pos              (16U)
#define TAMP_ATCR1_ATCKSEL_Msk              (0xFUL << TAMP_ATCR1_ATCKSEL_Pos)       /*!< 0x000F0000 */
#define TAMP_ATCR1_ATCKSEL                  TAMP_ATCR1_ATCKSEL_Msk
#define TAMP_ATCR1_ATCKSEL_0                (0x1UL << TAMP_ATCR1_ATCKSEL_Pos)       /*!< 0x00010000 */
#define TAMP_ATCR1_ATCKSEL_1                (0x2UL << TAMP_ATCR1_ATCKSEL_Pos)       /*!< 0x00020000 */
#define TAMP_ATCR1_ATCKSEL_2                (0x4UL << TAMP_ATCR1_ATCKSEL_Pos)       /*!< 0x00040000 */
#define TAMP_ATCR1_ATCKSEL_3                (0x8UL << TAMP_ATCR1_ATCKSEL_Pos)       /*!< 0x00080000 */
#define TAMP_ATCR1_ATPER_Pos                (24U)
#define TAMP_ATCR1_ATPER_Msk                (0x7UL << TAMP_ATCR1_ATPER_Pos)         /*!< 0x07000000 */
#define TAMP_ATCR1_ATPER                    TAMP_ATCR1_ATPER_Msk
#define TAMP_ATCR1_ATPER_0                  (0x1UL << TAMP_ATCR1_ATPER_Pos)         /*!< 0x01000000 */
#define TAMP_ATCR1_ATPER_1                  (0x2UL << TAMP_ATCR1_ATPER_Pos)         /*!< 0x02000000 */
#define TAMP_ATCR1_ATPER_2                  (0x4UL << TAMP_ATCR1_ATPER_Pos)         /*!< 0x04000000 */
#define TAMP_ATCR1_ATOSHARE_Pos             (30U)
#define TAMP_ATCR1_ATOSHARE_Msk             (0x1UL << TAMP_ATCR1_ATOSHARE_Pos)      /*!< 0x40000000 */
#define TAMP_ATCR1_ATOSHARE                 TAMP_ATCR1_ATOSHARE_Msk
#define TAMP_ATCR1_FLTEN_Pos                (31U)
#define TAMP_ATCR1_FLTEN_Msk                (0x1UL << TAMP_ATCR1_FLTEN_Pos)         /*!< 0x80000000 */
#define TAMP_ATCR1_FLTEN                    TAMP_ATCR1_FLTEN_Msk
#define TAMP_ATSEEDR_SEED_Pos               (0U)
#define TAMP_ATSEEDR_SEED_Msk               (0xFFFFFFFFUL << TAMP_ATSEEDR_SEED_Pos) /*!< 0xFFFFFFFF */
#define TAMP_ATSEEDR_SEED                   TAMP_ATSEEDR_SEED_Msk
#define TAMP_ATOR_PRNG_Pos                  (0U)
#define TAMP_ATOR_PRNG_Msk                  (0xFFUL << TAMP_ATOR_PRNG_Pos)          /*!< 0x000000FF */
#define TAMP_ATOR_PRNG                      TAMP_ATOR_PRNG_Msk
#define TAMP_ATOR_PRNG_0                    (0x1UL << TAMP_ATOR_PRNG_Pos)           /*!< 0x00000001 */
#define TAMP_ATOR_PRNG_1                    (0x2UL << TAMP_ATOR_PRNG_Pos)           /*!< 0x00000002 */
#define TAMP_ATOR_PRNG_2                    (0x4UL << TAMP_ATOR_PRNG_Pos)           /*!< 0x00000004 */
#define TAMP_ATOR_PRNG_3                    (0x8UL << TAMP_ATOR_PRNG_Pos)           /*!< 0x00000008 */
#define TAMP_ATOR_PRNG_4                    (0x10UL << TAMP_ATOR_PRNG_Pos)          /*!< 0x00000010 */
#define TAMP_ATOR_PRNG_5                    (0x20UL << TAMP_ATOR_PRNG_Pos)          /*!< 0x00000020 */
#define TAMP_ATOR_PRNG_6                    (0x40UL << TAMP_ATOR_PRNG_Pos)          /*!< 0x00000040 */
#define TAMP_ATOR_PRNG_7                    (0x80UL << TAMP_ATOR_PRNG_Pos)          /*!< 0x00000080 */
#define TAMP_ATOR_SEEDF_Pos                 (14U)
#define TAMP_ATOR_SEEDF_Msk                 (1UL << TAMP_ATOR_SEEDF_Pos)            /*!< 0x00004000 */
#define TAMP_ATOR_SEEDF                     TAMP_ATOR_SEEDF_Msk
#define TAMP_ATOR_INITS_Pos                 (15U)
#define TAMP_ATOR_INITS_Msk                 (1UL << TAMP_ATOR_INITS_Pos)            /*!< 0x00008000 */
#define TAMP_ATOR_INITS                     TAMP_ATOR_INITS_Msk
#define TAMP_ATCR2_ATOSEL1_Pos              (8U)
#define TAMP_ATCR2_ATOSEL1_Msk              (0x7UL << TAMP_ATCR2_ATOSEL1_Pos)       /*!< 0x00000700 */
#define TAMP_ATCR2_ATOSEL1                  TAMP_ATCR2_ATOSEL1_Msk
#define TAMP_ATCR2_ATOSEL1_0                (0x1UL << TAMP_ATCR2_ATOSEL1_Pos)       /*!< 0x00000100 */
#define TAMP_ATCR2_ATOSEL1_1                (0x2UL << TAMP_ATCR2_ATOSEL1_Pos)       /*!< 0x00000200 */
#define TAMP_ATCR2_ATOSEL1_2                (0x4UL << TAMP_ATCR2_ATOSEL1_Pos)       /*!< 0x00000400 */
#define TAMP_ATCR2_ATOSEL2_Pos              (11U)
#define TAMP_ATCR2_ATOSEL2_Msk              (0x7UL << TAMP_ATCR2_ATOSEL2_Pos)       /*!< 0x00003800 */
#define TAMP_ATCR2_ATOSEL2                  TAMP_ATCR2_ATOSEL2_Msk
#define TAMP_ATCR2_ATOSEL2_0                (0x1UL << TAMP_ATCR2_ATOSEL2_Pos)       /*!< 0x00000800 */
#define TAMP_ATCR2_ATOSEL2_1                (0x2UL << TAMP_ATCR2_ATOSEL2_Pos)       /*!< 0x00001000 */
#define TAMP_ATCR2_ATOSEL2_2                (0x4UL << TAMP_ATCR2_ATOSEL2_Pos)       /*!< 0x00002000 */
#define TAMP_ATCR2_ATOSEL3_Pos              (14U)
#define TAMP_ATCR2_ATOSEL3_Msk              (0x7UL << TAMP_ATCR2_ATOSEL3_Pos)       /*!< 0x0001C000 */
#define TAMP_ATCR2_ATOSEL3                  TAMP_ATCR2_ATOSEL3_Msk
#define TAMP_ATCR2_ATOSEL3_0                (0x1UL << TAMP_ATCR2_ATOSEL3_Pos)       /*!< 0x00004000 */
#define TAMP_ATCR2_ATOSEL3_1                (0x2UL << TAMP_ATCR2_ATOSEL3_Pos)       /*!< 0x00008000 */
#define TAMP_ATCR2_ATOSEL3_2                (0x4UL << TAMP_ATCR2_ATOSEL3_Pos)       /*!< 0x00010000 */
#define TAMP_ATCR2_ATOSEL4_Pos              (17U)
#define TAMP_ATCR2_ATOSEL4_Msk              (0x7UL << TAMP_ATCR2_ATOSEL4_Pos)       /*!< 0x000E0000 */
#define TAMP_ATCR2_ATOSEL4                  TAMP_ATCR2_ATOSEL4_Msk
#define TAMP_ATCR2_ATOSEL4_0                (0x1UL << TAMP_ATCR2_ATOSEL4_Pos)       /*!< 0x00020000 */
#define TAMP_ATCR2_ATOSEL4_1                (0x2UL << TAMP_ATCR2_ATOSEL4_Pos)       /*!< 0x00040000 */
#define TAMP_ATCR2_ATOSEL4_2                (0x4UL << TAMP_ATCR2_ATOSEL4_Pos)       /*!< 0x00080000 */
#define TAMP_ATCR2_ATOSEL5_Pos              (20U)
#define TAMP_ATCR2_ATOSEL5_Msk              (0x7UL << TAMP_ATCR2_ATOSEL5_Pos)       /*!< 0x00700000 */
#define TAMP_ATCR2_ATOSEL5                  TAMP_ATCR2_ATOSEL5_Msk
#define TAMP_ATCR2_ATOSEL5_0                (0x1UL << TAMP_ATCR2_ATOSEL5_Pos)       /*!< 0x00100000 */
#define TAMP_ATCR2_ATOSEL5_1                (0x2UL << TAMP_ATCR2_ATOSEL5_Pos)       /*!< 0x00200000 */
#define TAMP_ATCR2_ATOSEL5_2                (0x4UL << TAMP_ATCR2_ATOSEL5_Pos)       /*!< 0x00400000 */
#define TAMP_ATCR2_ATOSEL6_Pos              (23U)
#define TAMP_ATCR2_ATOSEL6_Msk              (0x7UL << TAMP_ATCR2_ATOSEL6_Pos)       /*!< 0x03800000 */
#define TAMP_ATCR2_ATOSEL6                  TAMP_ATCR2_ATOSEL6_Msk
#define TAMP_ATCR2_ATOSEL6_0                (0x1UL << TAMP_ATCR2_ATOSEL6_Pos)       /*!< 0x00800000 */
#define TAMP_ATCR2_ATOSEL6_1                (0x2UL << TAMP_ATCR2_ATOSEL6_Pos)       /*!< 0x01000000 */
#define TAMP_ATCR2_ATOSEL6_2                (0x4UL << TAMP_ATCR2_ATOSEL6_Pos)       /*!< 0x02000000 */
#define TAMP_ATCR2_ATOSEL7_Pos              (26U)
#define TAMP_ATCR2_ATOSEL7_Msk              (0x7UL << TAMP_ATCR2_ATOSEL7_Pos)       /*!< 0x1C000000 */
#define TAMP_ATCR2_ATOSEL7                  TAMP_ATCR2_ATOSEL7_Msk
#define TAMP_ATCR2_ATOSEL7_0                (0x1UL << TAMP_ATCR2_ATOSEL7_Pos)       /*!< 0x04000000 */
#define TAMP_ATCR2_ATOSEL7_1                (0x2UL << TAMP_ATCR2_ATOSEL7_Pos)       /*!< 0x08000000 */
#define TAMP_ATCR2_ATOSEL7_2                (0x4UL << TAMP_ATCR2_ATOSEL7_Pos)       /*!< 0x10000000 */
#define TAMP_ATCR2_ATOSEL8_Pos              (29U)
#define TAMP_ATCR2_ATOSEL8_Msk              (0x7UL << TAMP_ATCR2_ATOSEL8_Pos)       /*!< 0xE0000000 */
#define TAMP_ATCR2_ATOSEL8                  TAMP_ATCR2_ATOSEL8_Msk
#define TAMP_ATCR2_ATOSEL8_0                (0x1UL << TAMP_ATCR2_ATOSEL8_Pos)       /*!< 0x20000000 */
#define TAMP_ATCR2_ATOSEL8_1                (0x2UL << TAMP_ATCR2_ATOSEL8_Pos)       /*!< 0x40000000 */
#define TAMP_ATCR2_ATOSEL8_2                (0x4UL << TAMP_ATCR2_ATOSEL8_Pos)       /*!< 0x80000000 */
#define TAMP_CFGR_BKPRW_Pos                 (0U)
#define TAMP_CFGR_BKPRW_Msk                 (0xFFUL << TAMP_CFGR_BKPRW_Pos)         /*!< 0x000000FF */
#define TAMP_CFGR_BKPRW                     TAMP_CFGR_BKPRW_Msk
#define TAMP_CFGR_BKPRW_0                   (0x1UL << TAMP_CFGR_BKPRW_Pos)          /*!< 0x00000001 */
#define TAMP_CFGR_BKPRW_1                   (0x2UL << TAMP_CFGR_BKPRW_Pos)          /*!< 0x00000002 */
#define TAMP_CFGR_BKPRW_2                   (0x4UL << TAMP_CFGR_BKPRW_Pos)          /*!< 0x00000004 */
#define TAMP_CFGR_BKPRW_3                   (0x8UL << TAMP_CFGR_BKPRW_Pos)          /*!< 0x00000008 */
#define TAMP_CFGR_BKPRW_4                   (0x10UL << TAMP_CFGR_BKPRW_Pos)         /*!< 0x00000010 */
#define TAMP_CFGR_BKPRW_5                   (0x20UL << TAMP_CFGR_BKPRW_Pos)         /*!< 0x00000020 */
#define TAMP_CFGR_BKPRW_6                   (0x40UL << TAMP_CFGR_BKPRW_Pos)         /*!< 0x00000040 */
#define TAMP_CFGR_BKPRW_7                   (0x80UL << TAMP_CFGR_BKPRW_Pos)         /*!< 0x00000080 */
#define TAMP_CFGR_BKPW_Pos                  (16U)
#define TAMP_CFGR_BKPW_Msk                  (0xFFUL << TAMP_CFGR_BKPW_Pos)          /*!< 0x00FF0000 */
#define TAMP_CFGR_BKPW                      TAMP_CFGR_BKPW_Msk
#define TAMP_CFGR_BKPW_0                    (0x1UL << TAMP_CFGR_BKPW_Pos)           /*!< 0x00010000 */
#define TAMP_CFGR_BKPW_1                    (0x2UL << TAMP_CFGR_BKPW_Pos)           /*!< 0x00020000 */
#define TAMP_CFGR_BKPW_2                    (0x4UL << TAMP_CFGR_BKPW_Pos)           /*!< 0x00040000 */
#define TAMP_CFGR_BKPW_3                    (0x8UL << TAMP_CFGR_BKPW_Pos)           /*!< 0x00080000 */
#define TAMP_CFGR_BKPW_4                    (0x10UL << TAMP_CFGR_BKPW_Pos)          /*!< 0x00100000 */
#define TAMP_CFGR_BKPW_5                    (0x20UL << TAMP_CFGR_BKPW_Pos)          /*!< 0x00200000 */
#define TAMP_CFGR_BKPW_6                    (0x40UL << TAMP_CFGR_BKPW_Pos)          /*!< 0x00400000 */
#define TAMP_CFGR_BKPW_7                    (0x80UL << TAMP_CFGR_BKPW_Pos)          /*!< 0x00800000 */
#define TAMP_CFGR_BHKLOCK_Pos               (30U)
#define TAMP_CFGR_BHKLOCK_Msk               (0x1UL << TAMP_CFGR_BHKLOCK_Pos)        /*!< 0x40000000 */
#define TAMP_CFGR_BHKLOCK                   TAMP_CFGR_BHKLOCK_Msk
#define TAMP_PRIVCFGR_CNT1PRIV_Pos          (15U)
#define TAMP_PRIVCFGR_CNT1PRIV_Msk          (0x1UL << TAMP_PRIVCFGR_CNT1PRIV_Pos)   /*!< 0x00008000 */
#define TAMP_PRIVCFGR_CNT1PRIV              TAMP_PRIVCFGR_CNT1PRIV_Msk
#define TAMP_PRIVCFGR_BKPRWPRIV_Pos         (29U)
#define TAMP_PRIVCFGR_BKPRWPRIV_Msk         (0x1UL << TAMP_PRIVCFGR_BKPRWPRIV_Pos)  /*!< 0x20000000 */
#define TAMP_PRIVCFGR_BKPRWPRIV             TAMP_PRIVCFGR_BKPRWPRIV_Msk
#define TAMP_PRIVCFGR_BKPWPRIV_Pos          (30U)
#define TAMP_PRIVCFGR_BKPWPRIV_Msk          (0x1UL << TAMP_PRIVCFGR_BKPWPRIV_Pos)   /*!< 0x40000000 */
#define TAMP_PRIVCFGR_BKPWPRIV              TAMP_PRIVCFGR_BKPWPRIV_Msk
#define TAMP_PRIVCFGR_TAMPPRIV_Pos          (31U)
#define TAMP_PRIVCFGR_TAMPPRIV_Msk          (0x1UL << TAMP_PRIVCFGR_TAMPPRIV_Pos)   /*!< 0x80000000 */
#define TAMP_PRIVCFGR_TAMPPRIV              TAMP_PRIVCFGR_TAMPPRIV_Msk
#define TAMP_IER_TAMP1IE_Pos                (0U)
#define TAMP_IER_TAMP1IE_Msk                (0x1UL << TAMP_IER_TAMP1IE_Pos)         /*!< 0x00000001 */
#define TAMP_IER_TAMP1IE                    TAMP_IER_TAMP1IE_Msk
#define TAMP_IER_TAMP2IE_Pos                (1U)
#define TAMP_IER_TAMP2IE_Msk                (0x1UL << TAMP_IER_TAMP2IE_Pos)         /*!< 0x00000002 */
#define TAMP_IER_TAMP2IE                    TAMP_IER_TAMP2IE_Msk
#define TAMP_IER_TAMP3IE_Pos                (2U)
#define TAMP_IER_TAMP3IE_Msk                (0x1UL << TAMP_IER_TAMP3IE_Pos)         /*!< 0x00000004 */
#define TAMP_IER_TAMP3IE                    TAMP_IER_TAMP3IE_Msk
#define TAMP_IER_TAMP4IE_Pos                (3U)
#define TAMP_IER_TAMP4IE_Msk                (0x1UL << TAMP_IER_TAMP4IE_Pos)         /*!< 0x00000008 */
#define TAMP_IER_TAMP4IE                    TAMP_IER_TAMP4IE_Msk
#define TAMP_IER_TAMP5IE_Pos                (4U)
#define TAMP_IER_TAMP5IE_Msk                (0x1UL << TAMP_IER_TAMP5IE_Pos)         /*!< 0x00000010 */
#define TAMP_IER_TAMP5IE                    TAMP_IER_TAMP5IE_Msk
#define TAMP_IER_TAMP6IE_Pos                (5U)
#define TAMP_IER_TAMP6IE_Msk                (0x1UL << TAMP_IER_TAMP6IE_Pos)         /*!< 0x00000020 */
#define TAMP_IER_TAMP6IE                    TAMP_IER_TAMP6IE_Msk
#define TAMP_IER_TAMP7IE_Pos                (6U)
#define TAMP_IER_TAMP7IE_Msk                (0x1UL << TAMP_IER_TAMP7IE_Pos)         /*!< 0x00000040 */
#define TAMP_IER_TAMP7IE                    TAMP_IER_TAMP7IE_Msk
#define TAMP_IER_TAMP8IE_Pos                (7U)
#define TAMP_IER_TAMP8IE_Msk                (0x1UL << TAMP_IER_TAMP8IE_Pos)         /*!< 0x00000080 */
#define TAMP_IER_TAMP8IE                    TAMP_IER_TAMP8IE_Msk
#define TAMP_IER_ITAMP1IE_Pos               (16U)
#define TAMP_IER_ITAMP1IE_Msk               (0x1UL << TAMP_IER_ITAMP1IE_Pos)        /*!< 0x00010000 */
#define TAMP_IER_ITAMP1IE                   TAMP_IER_ITAMP1IE_Msk
#define TAMP_IER_ITAMP2IE_Pos               (17U)
#define TAMP_IER_ITAMP2IE_Msk               (0x1UL << TAMP_IER_ITAMP2IE_Pos)        /*!< 0x00020000 */
#define TAMP_IER_ITAMP2IE                   TAMP_IER_ITAMP2IE_Msk
#define TAMP_IER_ITAMP3IE_Pos               (18U)
#define TAMP_IER_ITAMP3IE_Msk               (0x1UL << TAMP_IER_ITAMP3IE_Pos)        /*!< 0x00040000 */
#define TAMP_IER_ITAMP3IE                   TAMP_IER_ITAMP3IE_Msk
#define TAMP_IER_ITAMP4IE_Pos               (19U)
#define TAMP_IER_ITAMP4IE_Msk               (0x1UL << TAMP_IER_ITAMP4IE_Pos)        /*!< 0x00080000 */
#define TAMP_IER_ITAMP4IE                   TAMP_IER_ITAMP4IE_Msk
#define TAMP_IER_ITAMP5IE_Pos               (20U)
#define TAMP_IER_ITAMP5IE_Msk               (0x1UL << TAMP_IER_ITAMP5IE_Pos)        /*!< 0x00100000 */
#define TAMP_IER_ITAMP5IE                   TAMP_IER_ITAMP5IE_Msk
#define TAMP_IER_ITAMP6IE_Pos               (21U)
#define TAMP_IER_ITAMP6IE_Msk               (0x1UL << TAMP_IER_ITAMP6IE_Pos)        /*!< 0x00200000 */
#define TAMP_IER_ITAMP6IE                   TAMP_IER_ITAMP6IE_Msk
#define TAMP_IER_ITAMP7IE_Pos               (22U)
#define TAMP_IER_ITAMP7IE_Msk               (0x1UL << TAMP_IER_ITAMP7IE_Pos)        /*!< 0x00400000 */
#define TAMP_IER_ITAMP7IE                   TAMP_IER_ITAMP7IE_Msk
#define TAMP_IER_ITAMP8IE_Pos               (23U)
#define TAMP_IER_ITAMP8IE_Msk               (0x1UL << TAMP_IER_ITAMP8IE_Pos)        /*!< 0x00800000 */
#define TAMP_IER_ITAMP8IE                   TAMP_IER_ITAMP8IE_Msk
#define TAMP_IER_ITAMP9IE_Pos               (24U)
#define TAMP_IER_ITAMP9IE_Msk               (0x1UL << TAMP_IER_ITAMP9IE_Pos)        /*!< 0x01000000 */
#define TAMP_IER_ITAMP9IE                   TAMP_IER_ITAMP9IE_Msk
#define TAMP_IER_ITAMP11IE_Pos              (26U)
#define TAMP_IER_ITAMP11IE_Msk              (0x1UL << TAMP_IER_ITAMP11IE_Pos)       /*!< 0x04000000 */
#define TAMP_IER_ITAMP11IE                  TAMP_IER_ITAMP11IE_Msk
#define TAMP_IER_ITAMP15IE_Pos              (30U)
#define TAMP_IER_ITAMP15IE_Msk              (0x1UL << TAMP_IER_ITAMP15IE_Pos)       /*!< 0x40000000 */
#define TAMP_IER_ITAMP15IE                  TAMP_IER_ITAMP15IE_Msk
#define TAMP_SR_TAMP1F_Pos                  (0U)
#define TAMP_SR_TAMP1F_Msk                  (0x1UL << TAMP_SR_TAMP1F_Pos)           /*!< 0x00000001 */
#define TAMP_SR_TAMP1F                      TAMP_SR_TAMP1F_Msk
#define TAMP_SR_TAMP2F_Pos                  (1U)
#define TAMP_SR_TAMP2F_Msk                  (0x1UL << TAMP_SR_TAMP2F_Pos)           /*!< 0x00000002 */
#define TAMP_SR_TAMP2F                      TAMP_SR_TAMP2F_Msk
#define TAMP_SR_TAMP3F_Pos                  (2U)
#define TAMP_SR_TAMP3F_Msk                  (0x1UL << TAMP_SR_TAMP3F_Pos)           /*!< 0x00000004 */
#define TAMP_SR_TAMP3F                      TAMP_SR_TAMP3F_Msk
#define TAMP_SR_TAMP4F_Pos                  (3U)
#define TAMP_SR_TAMP4F_Msk                  (0x1UL << TAMP_SR_TAMP4F_Pos)           /*!< 0x00000008 */
#define TAMP_SR_TAMP4F                      TAMP_SR_TAMP4F_Msk
#define TAMP_SR_TAMP5F_Pos                  (4U)
#define TAMP_SR_TAMP5F_Msk                  (0x1UL << TAMP_SR_TAMP5F_Pos)           /*!< 0x00000010 */
#define TAMP_SR_TAMP5F                      TAMP_SR_TAMP5F_Msk
#define TAMP_SR_TAMP6F_Pos                  (5U)
#define TAMP_SR_TAMP6F_Msk                  (0x1UL << TAMP_SR_TAMP6F_Pos)           /*!< 0x00000020 */
#define TAMP_SR_TAMP6F                      TAMP_SR_TAMP6F_Msk
#define TAMP_SR_TAMP7F_Pos                  (6U)
#define TAMP_SR_TAMP7F_Msk                  (0x1UL << TAMP_SR_TAMP7F_Pos)           /*!< 0x00000040 */
#define TAMP_SR_TAMP7F                      TAMP_SR_TAMP7F_Msk
#define TAMP_SR_TAMP8F_Pos                  (7U)
#define TAMP_SR_TAMP8F_Msk                  (0x1UL << TAMP_SR_TAMP8F_Pos)           /*!< 0x00000080 */
#define TAMP_SR_TAMP8F                      TAMP_SR_TAMP8F_Msk
#define TAMP_SR_ITAMP1F_Pos                 (16U)
#define TAMP_SR_ITAMP1F_Msk                 (0x1UL << TAMP_SR_ITAMP1F_Pos)          /*!< 0x00010000 */
#define TAMP_SR_ITAMP1F                     TAMP_SR_ITAMP1F_Msk
#define TAMP_SR_ITAMP2F_Pos                 (17U)
#define TAMP_SR_ITAMP2F_Msk                 (0x1UL << TAMP_SR_ITAMP2F_Pos)          /*!< 0x00020000 */
#define TAMP_SR_ITAMP2F                     TAMP_SR_ITAMP2F_Msk
#define TAMP_SR_ITAMP3F_Pos                 (18U)
#define TAMP_SR_ITAMP3F_Msk                 (0x1UL << TAMP_SR_ITAMP3F_Pos)          /*!< 0x00040000 */
#define TAMP_SR_ITAMP3F                     TAMP_SR_ITAMP3F_Msk
#define TAMP_SR_ITAMP4F_Pos                 (19U)
#define TAMP_SR_ITAMP4F_Msk                 (0x1UL << TAMP_SR_ITAMP4F_Pos)          /*!< 0x00080000 */
#define TAMP_SR_ITAMP4F                     TAMP_SR_ITAMP4F_Msk
#define TAMP_SR_ITAMP5F_Pos                 (20U)
#define TAMP_SR_ITAMP5F_Msk                 (0x1UL << TAMP_SR_ITAMP5F_Pos)          /*!< 0x00100000 */
#define TAMP_SR_ITAMP5F                     TAMP_SR_ITAMP5F_Msk
#define TAMP_SR_ITAMP6F_Pos                 (21U)
#define TAMP_SR_ITAMP6F_Msk                 (0x1UL << TAMP_SR_ITAMP6F_Pos)          /*!< 0x00200000 */
#define TAMP_SR_ITAMP6F                     TAMP_SR_ITAMP6F_Msk
#define TAMP_SR_ITAMP7F_Pos                 (22U)
#define TAMP_SR_ITAMP7F_Msk                 (0x1UL << TAMP_SR_ITAMP7F_Pos)          /*!< 0x00400000 */
#define TAMP_SR_ITAMP7F                     TAMP_SR_ITAMP7F_Msk
#define TAMP_SR_ITAMP8F_Pos                 (23U)
#define TAMP_SR_ITAMP8F_Msk                 (0x1UL << TAMP_SR_ITAMP8F_Pos)          /*!< 0x00800000 */
#define TAMP_SR_ITAMP8F                     TAMP_SR_ITAMP8F_Msk
#define TAMP_SR_ITAMP9F_Pos                 (24U)
#define TAMP_SR_ITAMP9F_Msk                 (0x1UL << TAMP_SR_ITAMP9F_Pos)          /*!< 0x01000000 */
#define TAMP_SR_ITAMP9F                     TAMP_SR_ITAMP9F_Msk
#define TAMP_SR_ITAMP11F_Pos                (26U)
#define TAMP_SR_ITAMP11F_Msk                (0x1UL << TAMP_SR_ITAMP11F_Pos)         /*!< 0x04000000 */
#define TAMP_SR_ITAMP11F                    TAMP_SR_ITAMP11F_Msk
#define TAMP_SR_ITAMP15F_Pos                (30U)
#define TAMP_SR_ITAMP15F_Msk                (0x1UL << TAMP_SR_ITAMP15F_Pos)         /*!< 0x40000000 */
#define TAMP_SR_ITAMP15F                    TAMP_SR_ITAMP15F_Msk
#define TAMP_MISR_TAMP1MF_Pos               (0U)
#define TAMP_MISR_TAMP1MF_Msk               (0x1UL << TAMP_MISR_TAMP1MF_Pos)        /*!< 0x00000001 */
#define TAMP_MISR_TAMP1MF                   TAMP_MISR_TAMP1MF_Msk
#define TAMP_MISR_TAMP2MF_Pos               (1U)
#define TAMP_MISR_TAMP2MF_Msk               (0x1UL << TAMP_MISR_TAMP2MF_Pos)        /*!< 0x00000002 */
#define TAMP_MISR_TAMP2MF                   TAMP_MISR_TAMP2MF_Msk
#define TAMP_MISR_TAMP3MF_Pos               (2U)
#define TAMP_MISR_TAMP3MF_Msk               (0x1UL << TAMP_MISR_TAMP3MF_Pos)        /*!< 0x00000004 */
#define TAMP_MISR_TAMP3MF                   TAMP_MISR_TAMP3MF_Msk
#define TAMP_MISR_TAMP4MF_Pos               (3U)
#define TAMP_MISR_TAMP4MF_Msk               (0x1UL << TAMP_MISR_TAMP4MF_Pos)        /*!< 0x00000008 */
#define TAMP_MISR_TAMP4MF                   TAMP_MISR_TAMP4MF_Msk
#define TAMP_MISR_TAMP5MF_Pos               (4U)
#define TAMP_MISR_TAMP5MF_Msk               (0x1UL << TAMP_MISR_TAMP5MF_Pos)        /*!< 0x00000010 */
#define TAMP_MISR_TAMP5MF                   TAMP_MISR_TAMP5MF_Msk
#define TAMP_MISR_TAMP6MF_Pos               (5U)
#define TAMP_MISR_TAMP6MF_Msk               (0x1UL << TAMP_MISR_TAMP6MF_Pos)        /*!< 0x00000020 */
#define TAMP_MISR_TAMP6MF                   TAMP_MISR_TAMP6MF_Msk
#define TAMP_MISR_TAMP7MF_Pos               (6U)
#define TAMP_MISR_TAMP7MF_Msk               (0x1UL << TAMP_MISR_TAMP7MF_Pos)        /*!< 0x00000040 */
#define TAMP_MISR_TAMP7MF                   TAMP_MISR_TAMP7MF_Msk
#define TAMP_MISR_TAMP8MF_Pos               (7U)
#define TAMP_MISR_TAMP8MF_Msk               (0x1UL << TAMP_MISR_TAMP8MF_Pos)        /*!< 0x00000080 */
#define TAMP_MISR_TAMP8MF                   TAMP_MISR_TAMP8MF_Msk
#define TAMP_MISR_ITAMP1MF_Pos              (16U)
#define TAMP_MISR_ITAMP1MF_Msk              (0x1UL << TAMP_MISR_ITAMP1MF_Pos)       /*!< 0x00010000 */
#define TAMP_MISR_ITAMP1MF                  TAMP_MISR_ITAMP1MF_Msk
#define TAMP_MISR_ITAMP2MF_Pos              (17U)
#define TAMP_MISR_ITAMP2MF_Msk              (0x1UL << TAMP_MISR_ITAMP2MF_Pos)       /*!< 0x00020000 */
#define TAMP_MISR_ITAMP2MF                  TAMP_MISR_ITAMP2MF_Msk
#define TAMP_MISR_ITAMP3MF_Pos              (18U)
#define TAMP_MISR_ITAMP3MF_Msk              (0x1UL << TAMP_MISR_ITAMP3MF_Pos)       /*!< 0x00040000 */
#define TAMP_MISR_ITAMP3MF                  TAMP_MISR_ITAMP3MF_Msk
#define TAMP_MISR_ITAMP4MF_Pos              (19U)
#define TAMP_MISR_ITAMP4MF_Msk              (0x1UL << TAMP_MISR_ITAMP4MF_Pos)       /*!< 0x00080000 */
#define TAMP_MISR_ITAMP4MF                  TAMP_MISR_ITAMP4MF_Msk
#define TAMP_MISR_ITAMP5MF_Pos              (20U)
#define TAMP_MISR_ITAMP5MF_Msk              (0x1UL << TAMP_MISR_ITAMP5MF_Pos)       /*!< 0x00100000 */
#define TAMP_MISR_ITAMP5MF                  TAMP_MISR_ITAMP5MF_Msk
#define TAMP_MISR_ITAMP6MF_Pos              (21U)
#define TAMP_MISR_ITAMP6MF_Msk              (0x1UL << TAMP_MISR_ITAMP6MF_Pos)       /*!< 0x00200000 */
#define TAMP_MISR_ITAMP6MF                  TAMP_MISR_ITAMP6MF_Msk
#define TAMP_MISR_ITAMP7MF_Pos              (22U)
#define TAMP_MISR_ITAMP7MF_Msk              (0x1UL << TAMP_MISR_ITAMP7MF_Pos)       /*!< 0x00400000 */
#define TAMP_MISR_ITAMP7MF                  TAMP_MISR_ITAMP7MF_Msk
#define TAMP_MISR_ITAMP8MF_Pos              (23U)
#define TAMP_MISR_ITAMP8MF_Msk              (0x1UL << TAMP_MISR_ITAMP8MF_Pos)       /*!< 0x00800000 */
#define TAMP_MISR_ITAMP8MF                  TAMP_MISR_ITAMP8MF_Msk
#define TAMP_MISR_ITAMP9MF_Pos              (24U)
#define TAMP_MISR_ITAMP9MF_Msk              (0x1UL << TAMP_MISR_ITAMP9MF_Pos)       /*!< 0x01000000 */
#define TAMP_MISR_ITAMP9MF                  TAMP_MISR_ITAMP9MF_Msk
#define TAMP_MISR_ITAMP11MF_Pos             (26U)
#define TAMP_MISR_ITAMP11MF_Msk             (0x1UL << TAMP_MISR_ITAMP11MF_Pos)      /*!< 0x04000000 */
#define TAMP_MISR_ITAMP11MF                 TAMP_MISR_ITAMP11MF_Msk
#define TAMP_MISR_ITAMP15MF_Pos             (30U)
#define TAMP_MISR_ITAMP15MF_Msk             (0x1UL << TAMP_MISR_ITAMP15MF_Pos)      /*!< 0x40000000 */
#define TAMP_MISR_ITAMP15MF                 TAMP_MISR_ITAMP15MF_Msk
#define TAMP_SCR_CTAMP1F_Pos                (0U)
#define TAMP_SCR_CTAMP1F_Msk                (0x1UL << TAMP_SCR_CTAMP1F_Pos)         /*!< 0x00000001 */
#define TAMP_SCR_CTAMP1F                    TAMP_SCR_CTAMP1F_Msk
#define TAMP_SCR_CTAMP2F_Pos                (1U)
#define TAMP_SCR_CTAMP2F_Msk                (0x1UL << TAMP_SCR_CTAMP2F_Pos)         /*!< 0x00000002 */
#define TAMP_SCR_CTAMP2F                    TAMP_SCR_CTAMP2F_Msk
#define TAMP_SCR_CTAMP3F_Pos                (2U)
#define TAMP_SCR_CTAMP3F_Msk                (0x1UL << TAMP_SCR_CTAMP3F_Pos)         /*!< 0x00000004 */
#define TAMP_SCR_CTAMP3F                    TAMP_SCR_CTAMP3F_Msk
#define TAMP_SCR_CTAMP4F_Pos                (3U)
#define TAMP_SCR_CTAMP4F_Msk                (0x1UL << TAMP_SCR_CTAMP4F_Pos)         /*!< 0x00000008 */
#define TAMP_SCR_CTAMP4F                    TAMP_SCR_CTAMP4F_Msk
#define TAMP_SCR_CTAMP5F_Pos                (4U)
#define TAMP_SCR_CTAMP5F_Msk                (0x1UL << TAMP_SCR_CTAMP5F_Pos)         /*!< 0x00000010 */
#define TAMP_SCR_CTAMP5F                    TAMP_SCR_CTAMP5F_Msk
#define TAMP_SCR_CTAMP6F_Pos                (5U)
#define TAMP_SCR_CTAMP6F_Msk                (0x1UL << TAMP_SCR_CTAMP6F_Pos)         /*!< 0x00000020 */
#define TAMP_SCR_CTAMP6F                    TAMP_SCR_CTAMP6F_Msk
#define TAMP_SCR_CTAMP7F_Pos                (6U)
#define TAMP_SCR_CTAMP7F_Msk                (0x1UL << TAMP_SCR_CTAMP7F_Pos)         /*!< 0x00000040 */
#define TAMP_SCR_CTAMP7F                    TAMP_SCR_CTAMP7F_Msk
#define TAMP_SCR_CTAMP8F_Pos                (7U)
#define TAMP_SCR_CTAMP8F_Msk                (0x1UL << TAMP_SCR_CTAMP8F_Pos)         /*!< 0x00000080 */
#define TAMP_SCR_CTAMP8F                    TAMP_SCR_CTAMP8F_Msk
#define TAMP_SCR_CITAMP1F_Pos               (16U)
#define TAMP_SCR_CITAMP1F_Msk               (0x1UL << TAMP_SCR_CITAMP1F_Pos)        /*!< 0x00010000 */
#define TAMP_SCR_CITAMP1F                   TAMP_SCR_CITAMP1F_Msk
#define TAMP_SCR_CITAMP2F_Pos               (17U)
#define TAMP_SCR_CITAMP2F_Msk               (0x1UL << TAMP_SCR_CITAMP2F_Pos)        /*!< 0x00020000 */
#define TAMP_SCR_CITAMP2F                   TAMP_SCR_CITAMP2F_Msk
#define TAMP_SCR_CITAMP3F_Pos               (18U)
#define TAMP_SCR_CITAMP3F_Msk               (0x1UL << TAMP_SCR_CITAMP3F_Pos)        /*!< 0x00040000 */
#define TAMP_SCR_CITAMP3F                   TAMP_SCR_CITAMP3F_Msk
#define TAMP_SCR_CITAMP4F_Pos               (19U)
#define TAMP_SCR_CITAMP4F_Msk               (0x1UL << TAMP_SCR_CITAMP4F_Pos)        /*!< 0x00080000 */
#define TAMP_SCR_CITAMP4F                   TAMP_SCR_CITAMP4F_Msk
#define TAMP_SCR_CITAMP5F_Pos               (20U)
#define TAMP_SCR_CITAMP5F_Msk               (0x1UL << TAMP_SCR_CITAMP5F_Pos)        /*!< 0x00100000 */
#define TAMP_SCR_CITAMP5F                   TAMP_SCR_CITAMP5F_Msk
#define TAMP_SCR_CITAMP6F_Pos               (21U)
#define TAMP_SCR_CITAMP6F_Msk               (0x1UL << TAMP_SCR_CITAMP6F_Pos)        /*!< 0x00200000 */
#define TAMP_SCR_CITAMP6F                   TAMP_SCR_CITAMP6F_Msk
#define TAMP_SCR_CITAMP7F_Pos               (22U)
#define TAMP_SCR_CITAMP7F_Msk               (0x1UL << TAMP_SCR_CITAMP7F_Pos)        /*!< 0x00400000 */
#define TAMP_SCR_CITAMP7F                   TAMP_SCR_CITAMP7F_Msk
#define TAMP_SCR_CITAMP8F_Pos               (23U)
#define TAMP_SCR_CITAMP8F_Msk               (0x1UL << TAMP_SCR_CITAMP8F_Pos)        /*!< 0x00800000 */
#define TAMP_SCR_CITAMP8F                   TAMP_SCR_CITAMP8F_Msk
#define TAMP_SCR_CITAMP9F_Pos               (24U)
#define TAMP_SCR_CITAMP9F_Msk               (0x1UL << TAMP_SCR_CITAMP9F_Pos)        /*!< 0x01000000 */
#define TAMP_SCR_CITAMP9F                   TAMP_SCR_CITAMP9F_Msk
#define TAMP_SCR_CITAMP11F_Pos              (26U)
#define TAMP_SCR_CITAMP11F_Msk              (0x1UL << TAMP_SCR_CITAMP11F_Pos)       /*!< 0x04000000 */
#define TAMP_SCR_CITAMP11F                  TAMP_SCR_CITAMP11F_Msk
#define TAMP_SCR_CITAMP15F_Pos              (30U)
#define TAMP_SCR_CITAMP15F_Msk              (0x1UL << TAMP_SCR_CITAMP15F_Pos)       /*!< 0x40000000 */
#define TAMP_SCR_CITAMP15F                  TAMP_SCR_CITAMP15F_Msk
#define TAMP_COUNT1R_COUNT_Pos              (0U)
#define TAMP_COUNT1R_COUNT_Msk              (0xFFFFFFFFUL << TAMP_COUNT1R_COUNT_Pos)/*!< 0xFFFFFFFF */
#define TAMP_COUNT1R_COUNT                  TAMP_COUNT1R_COUNT_Msk
#define TAMP_RPCFGR_RPCFG0_Pos              (0U)
#define TAMP_RPCFGR_RPCFG0_Msk              (0x1UL << TAMP_RPCFGR_RPCFG0_Pos)       /*!< 0x00000001 */
#define TAMP_RPCFGR_RPCFG0                  TAMP_RPCFGR_RPCFG0_Msk
#define TAMP_BKP0R_Pos                      (0U)
#define TAMP_BKP0R_Msk                      (0xFFFFFFFFUL << TAMP_BKP0R_Pos)        /*!< 0xFFFFFFFF */
#define TAMP_BKP0R                          TAMP_BKP0R_Msk
#define TAMP_BKP1R_Pos                      (0U)
#define TAMP_BKP1R_Msk                      (0xFFFFFFFFUL << TAMP_BKP1R_Pos)        /*!< 0xFFFFFFFF */
#define TAMP_BKP1R                          TAMP_BKP1R_Msk
#define TAMP_BKP2R_Pos                      (0U)
#define TAMP_BKP2R_Msk                      (0xFFFFFFFFUL << TAMP_BKP2R_Pos)        /*!< 0xFFFFFFFF */
#define TAMP_BKP2R                          TAMP_BKP2R_Msk
#define TAMP_BKP3R_Pos                      (0U)
#define TAMP_BKP3R_Msk                      (0xFFFFFFFFUL << TAMP_BKP3R_Pos)        /*!< 0xFFFFFFFF */
#define TAMP_BKP3R                          TAMP_BKP3R_Msk
#define TAMP_BKP4R_Pos                      (0U)
#define TAMP_BKP4R_Msk                      (0xFFFFFFFFUL << TAMP_BKP4R_Pos)        /*!< 0xFFFFFFFF */
#define TAMP_BKP4R                          TAMP_BKP4R_Msk
#define TAMP_BKP5R_Pos                      (0U)
#define TAMP_BKP5R_Msk                      (0xFFFFFFFFUL << TAMP_BKP5R_Pos)        /*!< 0xFFFFFFFF */
#define TAMP_BKP5R                          TAMP_BKP5R_Msk
#define TAMP_BKP6R_Pos                      (0U)
#define TAMP_BKP6R_Msk                      (0xFFFFFFFFUL << TAMP_BKP6R_Pos)        /*!< 0xFFFFFFFF */
#define TAMP_BKP6R                          TAMP_BKP6R_Msk
#define TAMP_BKP7R_Pos                      (0U)
#define TAMP_BKP7R_Msk                      (0xFFFFFFFFUL << TAMP_BKP7R_Pos)        /*!< 0xFFFFFFFF */
#define TAMP_BKP7R                          TAMP_BKP7R_Msk
#define TAMP_BKP8R_Pos                      (0U)
#define TAMP_BKP8R_Msk                      (0xFFFFFFFFUL << TAMP_BKP8R_Pos)        /*!< 0xFFFFFFFF */
#define TAMP_BKP8R                          TAMP_BKP8R_Msk
#define TAMP_BKP9R_Pos                      (0U)
#define TAMP_BKP9R_Msk                      (0xFFFFFFFFUL << TAMP_BKP9R_Pos)        /*!< 0xFFFFFFFF */
#define TAMP_BKP9R                          TAMP_BKP9R_Msk
#define TAMP_BKP10R_Pos                     (0U)
#define TAMP_BKP10R_Msk                     (0xFFFFFFFFUL << TAMP_BKP10R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP10R                         TAMP_BKP10R_Msk
#define TAMP_BKP11R_Pos                     (0U)
#define TAMP_BKP11R_Msk                     (0xFFFFFFFFUL << TAMP_BKP11R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP11R                         TAMP_BKP11R_Msk
#define TAMP_BKP12R_Pos                     (0U)
#define TAMP_BKP12R_Msk                     (0xFFFFFFFFUL << TAMP_BKP12R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP12R                         TAMP_BKP12R_Msk
#define TAMP_BKP13R_Pos                     (0U)
#define TAMP_BKP13R_Msk                     (0xFFFFFFFFUL << TAMP_BKP13R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP13R                         TAMP_BKP13R_Msk
#define TAMP_BKP14R_Pos                     (0U)
#define TAMP_BKP14R_Msk                     (0xFFFFFFFFUL << TAMP_BKP14R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP14R                         TAMP_BKP14R_Msk
#define TAMP_BKP15R_Pos                     (0U)
#define TAMP_BKP15R_Msk                     (0xFFFFFFFFUL << TAMP_BKP15R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP15R                         TAMP_BKP15R_Msk
#define TAMP_BKP16R_Pos                     (0U)
#define TAMP_BKP16R_Msk                     (0xFFFFFFFFUL << TAMP_BKP16R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP16R                         TAMP_BKP16R_Msk
#define TAMP_BKP17R_Pos                     (0U)
#define TAMP_BKP17R_Msk                     (0xFFFFFFFFUL << TAMP_BKP17R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP17R                         TAMP_BKP17R_Msk
#define TAMP_BKP18R_Pos                     (0U)
#define TAMP_BKP18R_Msk                     (0xFFFFFFFFUL << TAMP_BKP18R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP18R                         TAMP_BKP18R_Msk
#define TAMP_BKP19R_Pos                     (0U)
#define TAMP_BKP19R_Msk                     (0xFFFFFFFFUL << TAMP_BKP19R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP19R                         TAMP_BKP19R_Msk
#define TAMP_BKP20R_Pos                     (0U)
#define TAMP_BKP20R_Msk                     (0xFFFFFFFFUL << TAMP_BKP20R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP20R                         TAMP_BKP20R_Msk
#define TAMP_BKP21R_Pos                     (0U)
#define TAMP_BKP21R_Msk                     (0xFFFFFFFFUL << TAMP_BKP21R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP21R                         TAMP_BKP21R_Msk
#define TAMP_BKP22R_Pos                     (0U)
#define TAMP_BKP22R_Msk                     (0xFFFFFFFFUL << TAMP_BKP22R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP22R                         TAMP_BKP22R_Msk
#define TAMP_BKP23R_Pos                     (0U)
#define TAMP_BKP23R_Msk                     (0xFFFFFFFFUL << TAMP_BKP23R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP23R                         TAMP_BKP23R_Msk
#define TAMP_BKP24R_Pos                     (0U)
#define TAMP_BKP24R_Msk                     (0xFFFFFFFFUL << TAMP_BKP24R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP24R                         TAMP_BKP24R_Msk
#define TAMP_BKP25R_Pos                     (0U)
#define TAMP_BKP25R_Msk                     (0xFFFFFFFFUL << TAMP_BKP25R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP25R                         TAMP_BKP25R_Msk
#define TAMP_BKP26R_Pos                     (0U)
#define TAMP_BKP26R_Msk                     (0xFFFFFFFFUL << TAMP_BKP26R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP26R                         TAMP_BKP26R_Msk
#define TAMP_BKP27R_Pos                     (0U)
#define TAMP_BKP27R_Msk                     (0xFFFFFFFFUL << TAMP_BKP27R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP27R                         TAMP_BKP27R_Msk
#define TAMP_BKP28R_Pos                     (0U)
#define TAMP_BKP28R_Msk                     (0xFFFFFFFFUL << TAMP_BKP28R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP28R                         TAMP_BKP28R_Msk
#define TAMP_BKP29R_Pos                     (0U)
#define TAMP_BKP29R_Msk                     (0xFFFFFFFFUL << TAMP_BKP29R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP29R                         TAMP_BKP29R_Msk
#define TAMP_BKP30R_Pos                     (0U)
#define TAMP_BKP30R_Msk                     (0xFFFFFFFFUL << TAMP_BKP30R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP30R                         TAMP_BKP30R_Msk
#define TAMP_BKP31R_Pos                     (0U)
#define TAMP_BKP31R_Msk                     (0xFFFFFFFFUL << TAMP_BKP31R_Pos)       /*!< 0xFFFFFFFF */
#define TAMP_BKP31R                         TAMP_BKP31R_Msk
