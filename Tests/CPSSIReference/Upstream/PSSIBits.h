/* Copyright (c) 2022 STMicroelectronics. SPDX-License-Identifier: Apache-2.0
 * CMSIS extracts at 7e6e213ddc397c76622a0aca2f623ccc3b34c010. */
typedef struct
{
  __IO uint32_t CR;            /*!< PSSI control register,                 Address offset: 0x000 */
  __IO uint32_t SR;            /*!< PSSI status register,                  Address offset: 0x004 */
  __IO uint32_t RIS;           /*!< PSSI raw interrupt status register,    Address offset: 0x008 */
  __IO uint32_t IER;           /*!< PSSI interrupt enable register,        Address offset: 0x00C */
  __IO uint32_t MIS;           /*!< PSSI masked interrupt status register, Address offset: 0x010 */
  __IO uint32_t ICR;           /*!< PSSI interrupt clear register,         Address offset: 0x014 */
  __IO uint32_t RESERVED1[4];  /*!< Reserved,                      Address offset: 0x018 - 0x024 */
  __IO uint32_t DR;            /*!< PSSI data register,                    Address offset: 0x028 */
} PSSI_TypeDef;
#define PSSI_BASE                       (AHB2PERIPH_BASE + 0x0400UL)
#define PSSI_CR_CKPOL_Pos              (5U)
#define PSSI_CR_CKPOL_Msk              (0x1UL << PSSI_CR_CKPOL_Pos)            /*!< 0x00000020 */
#define PSSI_CR_CKPOL                  PSSI_CR_CKPOL_Msk                       /*!< Parallel data clock polarity */
#define PSSI_CR_DEPOL_Pos              (6U)
#define PSSI_CR_DEPOL_Msk              (0x1UL << PSSI_CR_DEPOL_Pos)            /*!< 0x00000040 */
#define PSSI_CR_DEPOL                  PSSI_CR_DEPOL_Msk                       /*!<  Data enable polarity */
#define PSSI_CR_RDYPOL_Pos             (8U)
#define PSSI_CR_RDYPOL_Msk             (0x1UL << PSSI_CR_RDYPOL_Pos)           /*!< 0x00000100 */
#define PSSI_CR_RDYPOL                 PSSI_CR_RDYPOL_Msk                      /*!< Ready polarity */
#define PSSI_CR_EDM_Pos                (10U)
#define PSSI_CR_EDM_Msk                (0x3UL << PSSI_CR_EDM_Pos)              /*!< 0x00000C00 */
#define PSSI_CR_EDM                    PSSI_CR_EDM_Msk                         /*!< Extended data mode */
#define PSSI_CR_ENABLE_Pos             (14U)
#define PSSI_CR_ENABLE_Msk             (0x1UL << PSSI_CR_ENABLE_Pos)           /*!< 0x00004000 */
#define PSSI_CR_ENABLE                 PSSI_CR_ENABLE_Msk                      /*!< PSSI enable */
#define PSSI_CR_DERDYCFG_Pos           (18U)
#define PSSI_CR_DERDYCFG_Msk           (0x7UL << PSSI_CR_DERDYCFG_Pos)         /*!< 0x001C0000 */
#define PSSI_CR_DERDYCFG               PSSI_CR_DERDYCFG_Msk                    /*!< Data enable and ready configuration */
#define PSSI_CR_CKSRC_Pos              (29U)
#define PSSI_CR_CKSRC_Msk              (0x1UL << PSSI_CR_CKSRC_Pos)            /*!< 0x20000000 */
#define PSSI_CR_CKSRC                  PSSI_CR_CKSRC_Msk                       /*!< Clock source */
#define PSSI_CR_DMAEN_Pos              (30U)
#define PSSI_CR_DMAEN_Msk              (0x1UL << PSSI_CR_DMAEN_Pos)            /*!< 0x40000000 */
#define PSSI_CR_DMAEN                  PSSI_CR_DMAEN_Msk                       /*!< DMA enable */
#define PSSI_CR_OUTEN_Pos              (31U)
#define PSSI_CR_OUTEN_Msk              (0x1UL << PSSI_CR_OUTEN_Pos)            /*!< 0x80000000 */
#define PSSI_CR_OUTEN                  PSSI_CR_OUTEN_Msk                       /*!< Data direction selection */
#define PSSI_SR_RTT4B_Pos              (2U)
#define PSSI_SR_RTT4B_Msk              (0x1UL << PSSI_SR_RTT4B_Pos)            /*!< 0x00000004 */
#define PSSI_SR_RTT4B                  PSSI_SR_RTT4B_Msk                       /*!< Ready to transfer four bytes */
#define PSSI_SR_RTT1B_Pos              (3U)
#define PSSI_SR_RTT1B_Msk              (0x1UL << PSSI_SR_RTT1B_Pos)            /*!< 0x00000008 */
#define PSSI_SR_RTT1B                  PSSI_SR_RTT1B_Msk                       /*!< Ready to transfer one byte */
#define PSSI_RIS_OVR_RIS_Pos           (1U)
#define PSSI_RIS_OVR_RIS_Msk           (0x1UL << PSSI_RIS_OVR_RIS_Pos)         /*!< 0x00000002 */
#define PSSI_RIS_OVR_RIS               PSSI_RIS_OVR_RIS_Msk                    /*!< Data buffer overrun/underrun raw interrupt status */
#define PSSI_IER_OVR_IE_Pos            (1U)
#define PSSI_IER_OVR_IE_Msk            (0x1UL << PSSI_IER_OVR_IE_Pos)          /*!< 0x00000002 */
#define PSSI_IER_OVR_IE                PSSI_IER_OVR_IE_Msk                     /*!< Data buffer overrun/underrun interrupt enable */
#define PSSI_MIS_OVR_MIS_Pos           (1U)
#define PSSI_MIS_OVR_MIS_Msk           (0x1UL << PSSI_MIS_OVR_MIS_Pos)         /*!< 0x00000002 */
#define PSSI_MIS_OVR_MIS               PSSI_MIS_OVR_MIS_Msk                    /*!< Data buffer overrun/underrun masked interrupt status */
#define PSSI_ICR_OVR_ISC_Pos           (1U)
#define PSSI_ICR_OVR_ISC_Msk           (0x1UL << PSSI_ICR_OVR_ISC_Pos)         /*!< 0x00000002 */
#define PSSI_ICR_OVR_ISC               PSSI_ICR_OVR_ISC_Msk                    /*!< Data buffer overrun/underrun interrupt status clear */
#define PSSI_DR_DR_Pos                 (0U)
#define PSSI_DR_DR_Msk                 (0xFFFFFFFFUL << PSSI_DR_DR_Pos)        /*!< 0xFFFFFFF */
#define PSSI_DR_DR                     PSSI_DR_DR_Msk                          /*!< Data register  */
