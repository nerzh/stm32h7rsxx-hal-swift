// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// Extracted from cmsis-device-h7rs 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
typedef struct
{
  __IO uint32_t REGCR;            /*!< MCE region configuration register,             Address offset: 0x040 + 0x10 * (x-1) (x = 1 to 4) */
  __IO uint32_t SADDR;            /*!< MCE region start address register,             Address offset: 0x044 + 0x10 * (x-1) (x = 1 to 4) */
  __IO uint32_t EADDR;            /*!< MCE region end address register,               Address offset: 0x048 + 0x10 * (x-1) (x = 1 to 4) */
  __IO uint32_t ATTR;             /*!< MCE region attribute register,                 Address offset: 0x04C + 0x10 * (x-1) (x = 1 to 4) */
} MCE_Region_TypeDef;

typedef struct
{
  __IO uint32_t CCCFGR;           /*!< MCE cipher context configuration register,     Address offset: 0x240 + 0x30 * (x-1) (x = 1 to 2) */
  __IO uint32_t CCNR0;            /*!< MCE cipher context nonce register 0,           Address offset: 0x244 + 0x30 * (x-1) (x = 1 to 2) */
  __IO uint32_t CCNR1;            /*!< MCE cipher context nonce register 1,           Address offset: 0x248 + 0x30 * (x-1) (x = 1 to 2) */
  __IO uint32_t CCKEYR0;          /*!< MCE cipher context key register 0,             Address offset: 0x24C + 0x30 * (x-1) (x = 1 to 2) */
  __IO uint32_t CCKEYR1;          /*!< MCE cipher context key register 1,             Address offset: 0x250 + 0x30 * (x-1) (x = 1 to 2) */
  __IO uint32_t CCKEYR2;          /*!< MCE cipher context key register 2,             Address offset: 0x254 + 0x30 * (x-1) (x = 1 to 2) */
  __IO uint32_t CCKEYR3;          /*!< MCE cipher context key register 3,             Address offset: 0x258 + 0x30 * (x-1) (x = 1 to 2) */
} MCE_Context_TypeDef;

typedef struct
{
  __IO uint32_t CR;               /*!< MCE configuration register,                           Address offset: 0x000       */
  __IO uint32_t SR;               /*!< MCE status register,                                  Address offset: 0x004       */
  __IO uint32_t IASR;             /*!< MCE illegal access status register,                   Address offset: 0x008       */
  __IO uint32_t IACR;             /*!< MCE illegal access clear register,                    Address offset: 0x00C       */
  __IO uint32_t IAIER;            /*!< MCE illegal access interrupt enable register,         Address offset: 0x010       */
  uint32_t RESERVED1[2];          /*!< Reserved,                                             Address offset: 0x014-0x018 */
  __IO uint32_t PRIVCFGR;         /*!< MCE privileged configuration register,                Address offset: 0x01C       */
  __IO uint32_t IAESR;            /*!< MCE illegal access error status register,             Address offset: 0x020       */
  __IO uint32_t IADDR;            /*!< MCE illegal address register,                         Address offset: 0x024       */
  uint32_t RESERVED2[118];        /*!< Reserved,                                             Address offset: 0x028-0x1FC */
  __IO uint32_t MKEYR0;           /*!< MCE master key register 0,                            Address offset: 0x200       */
  __IO uint32_t MKEYR1;           /*!< MCE master key register 1,                            Address offset: 0x204       */
  __IO uint32_t MKEYR2;           /*!< MCE master key register 2,                            Address offset: 0x208       */
  __IO uint32_t MKEYR3;           /*!< MCE master key register 3,                            Address offset: 0x20C       */
  uint32_t RESERVED3[4];          /*!< Reserved,                                             Address offset: 0x210-0x21C */
  __IO uint32_t FMKEYR0;          /*!< MCE fast master key register 0,                       Address offset: 0x220       */
  __IO uint32_t FMKEYR1;          /*!< MCE fast master key register 1,                       Address offset: 0x224       */
  __IO uint32_t FMKEYR2;          /*!< MCE fast master key register 2,                       Address offset: 0x228       */
  __IO uint32_t FMKEYR3;          /*!< MCE fast master key register 3,                       Address offset: 0x22C       */
} MCE_TypeDef;
#define MCE_CR_GLOCK_Pos               (0U)
#define MCE_CR_GLOCK_Msk               (0x1UL << MCE_CR_GLOCK_Pos)             /*!< 0x00000001 */
#define MCE_CR_GLOCK                   MCE_CR_GLOCK_Msk                        /*!< MCE global lock */
#define MCE_CR_MKLOCK_Pos              (1U)
#define MCE_CR_MKLOCK_Msk              (0x1UL << MCE_CR_MKLOCK_Pos)            /*!< 0x00000002 */
#define MCE_CR_MKLOCK                  MCE_CR_MKLOCK_Msk                       /*!< MCE master and fast master keys lock */
#define MCE_SR_MKVALID_Pos             (0U)
#define MCE_SR_MKVALID_Msk             (0x1UL << MCE_SR_MKVALID_Pos)           /*!< 0x00000001 */
#define MCE_SR_MKVALID                 MCE_SR_MKVALID_Msk                      /*!< MCE master key valid flag */
#define MCE_SR_FMKVALID_Pos            (2U)
#define MCE_SR_FMKVALID_Msk            (0x1UL << MCE_SR_FMKVALID_Pos)          /*!< 0x00000004 */
#define MCE_SR_FMKVALID                 MCE_SR_FMKVALID_Msk                    /*!< MCE fast master key valid flag */
#define MCE_SR_ENCDIS_Pos              (4U)
#define MCE_SR_ENCDIS_Msk              (0x1UL << MCE_SR_ENCDIS_Pos)            /*!< 0x00000010 */
#define MCE_SR_ENCDIS                  MCE_SR_ENCDIS_Msk                       /*!< MCE encryption disabled flag */
#define MCE_IASR_CAEF_Pos              (0U)
#define MCE_IASR_CAEF_Msk              (0x1UL << MCE_IASR_CAEF_Pos)             /*!< 0x00000001 */
#define MCE_IASR_CAEF                  MCE_IASR_CAEF_Msk                        /*!< MCE configuration access error flag */
#define MCE_IASR_IAEF_Pos              (1U)
#define MCE_IASR_IAEF_Msk              (0x1UL << MCE_IASR_IAEF_Pos)             /*!< 0x00000002 */
#define MCE_IASR_IAEF                  MCE_IASR_IAEF_Msk                        /*!< MCE illegal access error flag */
#define MCE_IACR_CAEF_Pos              (0U)
#define MCE_IACR_CAEF_Msk              (0x1UL << MCE_IACR_CAEF_Pos)             /*!< 0x00000001 */
#define MCE_IACR_CAEF                  MCE_IACR_CAEF_Msk                        /*!< MCE configuration access error clear bit */
#define MCE_IACR_IAEF_Pos              (1U)
#define MCE_IACR_IAEF_Msk              (0x1UL << MCE_IACR_IAEF_Pos)             /*!< 0x00000002 */
#define MCE_IACR_IAEF                  MCE_IACR_IAEF_Msk                        /*!< MCE illegal access error clear bit */
#define MCE_IAIER_CAEIE_Pos            (0U)
#define MCE_IAIER_CAEIE_Msk            (0x1UL << MCE_IAIER_CAEIE_Pos)           /*!< 0x00000001 */
#define MCE_IAIER_CAEIE                MCE_IAIER_CAEIE_Msk                      /*!< MCE configuration access error interrupt enable */
#define MCE_IAIER_IAEIE_Pos            (1U)
#define MCE_IAIER_IAEIE_Msk            (0x1UL << MCE_IAIER_IAEIE_Pos)           /*!< 0x00000002 */
#define MCE_IAIER_IAEIE                MCE_IAIER_IAEIE_Msk                      /*!< MCE illegal access error interrupt enable */
#define MCE_PRIVCFGR_PRIV_Pos          (0U)
#define MCE_PRIVCFGR_PRIV_Msk          (0x1UL << MCE_PRIVCFGR_PRIV_Pos)         /*!< 0x00000001 */
#define MCE_PRIVCFGR_PRIV              MCE_PRIVCFGR_PRIV_Msk                    /*!< MCE privileged configuration */
#define MCE_IAESR_IAPRIV_Pos           (4U)
#define MCE_IAESR_IAPRIV_Msk           (0x1UL << MCE_IAESR_IAPRIV_Pos)          /*!< 0x00000010 */
#define MCE_IAESR_IAPRIV               MCE_IAESR_IAPRIV_Msk                     /*!< MCE illegal access privilege */
#define MCE_IAESR_IANRW_Pos            (7U)
#define MCE_IAESR_IANRW_Msk            (0x1UL << MCE_IAESR_IANRW_Pos)           /*!< 0x00000080 */
#define MCE_IAESR_IANRW                MCE_IAESR_IANRW_Msk                      /*!< MCE illegal access read/write */
#define MCE_IADDR_IADD_Pos             (0U)
#define MCE_IADDR_IADD_Msk             (0xFFFFFFFFUL << MCE_IADDR_IADD_Pos)     /*!< 0xFFFFFFFF */
#define MCE_IADDR_IADD                 MCE_IADDR_IADD_Msk                       /*!< MCE illegal address */
#define MCE_REGCR_BREN_Pos             (0U)
#define MCE_REGCR_BREN_Msk             (0x1UL << MCE_REGCR_BREN_Pos)            /*!< 0x00000001 */
#define MCE_REGCR_BREN                 MCE_REGCR_BREN_Msk                       /*!< MCE base region enable */
#define MCE_REGCR_CTXID_Pos            (9U)
#define MCE_REGCR_CTXID_Msk            (0x3UL << MCE_REGCR_CTXID_Pos)           /*!< 0x00000600 */
#define MCE_REGCR_CTXID                MCE_REGCR_CTXID_Msk                      /*!< MCE context ID */
#define MCE_REGCR_CTXID_0              (0x1UL << MCE_REGCR_CTXID_Pos)           /*!< 0x00000200 */
#define MCE_REGCR_CTXID_1              (0x2UL << MCE_REGCR_CTXID_Pos)           /*!< 0x00000400 */
#define MCE_REGCR_ENC_Pos              (14U)
#define MCE_REGCR_ENC_Msk              (0x3UL << MCE_REGCR_ENC_Pos)             /*!< 0x0000C000 */
#define MCE_REGCR_ENC                  MCE_REGCR_ENC_Msk                        /*!< MCE encrypted region */
#define MCE_REGCR_ENC_0                (0x1UL << MCE_REGCR_ENC_Pos)             /*!< 0x00004000 */
#define MCE_REGCR_ENC_1                (0x2UL << MCE_REGCR_ENC_Pos)             /*!< 0x00008000 */
#define MCE_REGCR_PRIV_Pos             (16U)
#define MCE_REGCR_PRIV_Msk             (0x1UL << MCE_REGCR_PRIV_Pos)            /*!< 0x00010000 */
#define MCE_REGCR_PRIV                 MCE_REGCR_PRIV_Msk                       /*!< MCE privileged region */
#define MCE_SADDR_BADDSTART_Pos        (12U)
#define MCE_SADDR_BADDSTART_Msk        (0xFFFFFUL << MCE_SADDR_BADDSTART_Pos)   /*!< 0xFFFFF000 */
#define MCE_SADDR_BADDSTART            MCE_SADDR_BADDSTART_Msk                  /*!< MCE region address start */
#define MCE_EADDR_BADDEND_Pos          (12U)
#define MCE_EADDR_BADDEND_Msk          (0xFFFFFUL << MCE_EADDR_BADDEND_Pos)     /*!< 0xFFFFF000 */
#define MCE_EADDR_BADDEND              MCE_EADDR_BADDEND_Msk                    /*!< MCE region address end */
#define MCE_ATTR_WREN_Pos              (16U)
#define MCE_ATTR_WREN_Msk              (0x1UL << MCE_ATTR_WREN_Pos)             /*!< 0x00010000 */
#define MCE_ATTR_WREN                  MCE_ATTR_WREN_Msk                        /*!< MCE region write enable */
#define MCE_MKEYR0_MKEY_Pos            (0U)
#define MCE_MKEYR0_MKEY_Msk            (0xFFFFFFFFUL << MCE_MKEYR0_MKEY_Pos)    /*!< 0xFFFFFFFF */
#define MCE_MKEYR0_MKEY                MCE_MKEYR0_MKEY_Msk                      /*!< MCE master key, bits [31:0] */
#define MCE_MKEYR1_MKEY_Pos            (0U)
#define MCE_MKEYR1_MKEY_Msk            (0xFFFFFFFFUL << MCE_MKEYR1_MKEY_Pos)    /*!< 0xFFFFFFFF */
#define MCE_MKEYR1_MKEY                MCE_MKEYR1_MKEY_Msk                      /*!< MCE master key, bits [63:32] */
#define MCE_MKEYR2_MKEY_Pos            (0U)
#define MCE_MKEYR2_MKEY_Msk            (0xFFFFFFFFUL << MCE_MKEYR2_MKEY_Pos)    /*!< 0xFFFFFFFF */
#define MCE_MKEYR2_MKEY                MCE_MKEYR2_MKEY_Msk                      /*!< MCE master key, bits [95:64] */
#define MCE_MKEYR3_MKEY_Pos            (0U)
#define MCE_MKEYR3_MKEY_Msk            (0xFFFFFFFFUL << MCE_MKEYR3_MKEY_Pos)    /*!< 0xFFFFFFFF */
#define MCE_MKEYR3_MKEY                MCE_MKEYR3_MKEY_Msk                      /*!< MCE master key, bits [127:96] */
#define MCE_FMKEYR0_FMKEY_Pos          (0U)
#define MCE_FMKEYR0_FMKEY_Msk          (0xFFFFFFFFUL << MCE_FMKEYR0_FMKEY_Pos)  /*!< 0xFFFFFFFF */
#define MCE_FMKEYR0_FMKEY              MCE_FMKEYR0_FMKEY_Msk                    /*!< MCE fast master key, bits [31:0] */
#define MCE_FMKEYR1_FMKEY_Pos          (0U)
#define MCE_FMKEYR1_FMKEY_Msk          (0xFFFFFFFFUL << MCE_FMKEYR1_FMKEY_Pos)  /*!< 0xFFFFFFFF */
#define MCE_FMKEYR1_FMKEY              MCE_FMKEYR1_FMKEY_Msk                    /*!< MCE fast master key, bits [63:32] */
#define MCE_FMKEYR2_FMKEY_Pos          (0U)
#define MCE_FMKEYR2_FMKEY_Msk          (0xFFFFFFFFUL << MCE_FMKEYR2_FMKEY_Pos)  /*!< 0xFFFFFFFF */
#define MCE_FMKEYR2_FMKEY              MCE_FMKEYR2_FMKEY_Msk                    /*!< MCE fast master key, bits [95:64] */
#define MCE_FMKEYR3_FMKEY_Pos          (0U)
#define MCE_FMKEYR3_FMKEY_Msk          (0xFFFFFFFFUL << MCE_FMKEYR3_FMKEY_Pos)  /*!< 0xFFFFFFFF */
#define MCE_FMKEYR3_FMKEY              MCE_FMKEYR3_FMKEY_Msk                    /*!< MCE fast master key, bits [127:96] */
#define MCE_CCCFGR_CCEN_Pos             (0U)
#define MCE_CCCFGR_CCEN_Msk             (0x1UL << MCE_CCCFGR_CCEN_Pos)          /*!< 0x00000001 */
#define MCE_CCCFGR_CCEN                 MCE_CCCFGR_CCEN_Msk                     /*!< MCE cipher context enable */
#define MCE_CCCFGR_CCLOCK_Pos           (1U)
#define MCE_CCCFGR_CCLOCK_Msk           (0x1UL << MCE_CCCFGR_CCLOCK_Pos)        /*!< 0x00000002 */
#define MCE_CCCFGR_CCLOCK               MCE_CCCFGR_CCLOCK_Msk                   /*!< MCE cipher context lock */
#define MCE_CCCFGR_KEYLOCK_Pos          (2U)
#define MCE_CCCFGR_KEYLOCK_Msk          (0x1UL << MCE_CCCFGR_KEYLOCK_Pos)       /*!< 0x00000004 */
#define MCE_CCCFGR_KEYLOCK              MCE_CCCFGR_KEYLOCK_Msk                  /*!< MCE cipher context key lock */
#define MCE_CCCFGR_KEYCRC_Pos           (8U)
#define MCE_CCCFGR_KEYCRC_Msk           (0xFFUL << MCE_CCCFGR_KEYCRC_Pos)       /*!< 0x0000FF00 */
#define MCE_CCCFGR_KEYCRC               MCE_CCCFGR_KEYCRC_Msk                   /*!< MCE cipher context key CRC */
#define MCE_CCCFGR_VERSION_Pos          (16U)
#define MCE_CCCFGR_VERSION_Msk          (0xFFFFUL << MCE_CCCFGR_VERSION_Pos)    /*!< 0xFFFF0000 */
#define MCE_CCCFGR_VERSION              MCE_CCCFGR_VERSION_Msk                  /*!< MCE cipher context version */
#define MCE_CCNR0_SCNONCE_Pos          (0U)
#define MCE_CCNR0_SCNONCE_Msk          (0xFFFFFFFFUL << MCE_CCNR0_SCNONCE_Pos)  /*!< 0xFFFFFFFF */
#define MCE_CCNR0_SCNONCE              MCE_CCNR0_SCNONCE_Msk                    /*!< MCE cipher context stream cipher nonce, bits [31:0] */
#define MCE_CCNR1_SCNONCE_Pos          (0U)
#define MCE_CCNR1_SCNONCE_Msk          (0xFFFFFFFFUL << MCE_CCNR1_SCNONCE_Pos)  /*!< 0xFFFFFFFF */
#define MCE_CCNR1_SCNONCE              MCE_CCNR1_SCNONCE_Msk                    /*!< MCE cipher context stream cipher nonce, bits [63:32] */
#define MCE_CCKEYR0_KEY_Pos            (0U)
#define MCE_CCKEYR0_KEY_Msk            (0xFFFFFFFFUL << MCE_CCKEYR0_KEY_Pos)    /*!< 0xFFFFFFFF */
#define MCE_CCKEYR0_KEY                MCE_CCKEYR0_KEY_Msk                      /*!< MCE cipher context key, bits [31:0] */
#define MCE_CCKEYR1_KEY_Pos            (0U)
#define MCE_CCKEYR1_KEY_Msk            (0xFFFFFFFFUL << MCE_CCKEYR1_KEY_Pos)    /*!< 0xFFFFFFFF */
#define MCE_CCKEYR1_KEY                MCE_CCKEYR1_KEY_Msk                      /*!< MCE fast master key, bits [63:32] */
#define MCE_CCKEYR2_KEY_Pos            (0U)
#define MCE_CCKEYR2_KEY_Msk            (0xFFFFFFFFUL << MCE_CCKEYR2_KEY_Pos)    /*!< 0xFFFFFFFF */
#define MCE_CCKEYR2_KEY                MCE_CCKEYR2_KEY_Msk                      /*!< MCE fast master key, bits [95:64] */
#define MCE_CCKEYR3_KEY_Pos            (0U)
#define MCE_CCKEYR3_KEY_Msk            (0xFFFFFFFFUL << MCE_CCKEYR3_KEY_Pos)    /*!< 0xFFFFFFFF */
#define MCE_CCKEYR3_KEY                MCE_CCKEYR3_KEY_Msk                      /*!< MCE fast master key, bits [127:96] */
