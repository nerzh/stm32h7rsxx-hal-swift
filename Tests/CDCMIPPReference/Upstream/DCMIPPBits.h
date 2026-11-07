// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010, stm32h7s3xx.h.
typedef struct
{
  __IO uint32_t IPGR1;         /*!< IP-Plug global register 1                         Address offset: 0x00 */
  __IO uint32_t IPGR2;         /*!< IP-Plug global register 2                         Address offset: 0x04 */
  __IO uint32_t IPGR3;         /*!< IP-Plug global register 3                         Address offset: 0x08 */
  uint32_t RESERVED1[4];       /*!< Reserved,                                    Address offset: 0x0C-0x18 */
  __IO uint32_t IPGR8;         /*!< IP-Plug global register 8                         Address offset: 0x1C */
  __IO uint32_t IPC1R1;        /*!< IP-Plug client 1 register 1                       Address offset: 0x20 */
  __IO uint32_t IPC1R2;        /*!< IP-Plug client 1 register 2                       Address offset: 0x24 */
  __IO uint32_t IPC1R3;        /*!< IP-Plug client 1 register 3                       Address offset: 0x28 */
  __IO uint32_t RESERVED2[54]; /*!< Reserved,                                   Address offset: 0x2C-0x100 */
  __IO uint32_t PRCR;          /*!< Parallel interface control register              Address offset: 0x104 */
  __IO uint32_t PRESCR;        /*!< Parallel interface embedded sync code register   Address offset: 0x108 */
  __IO uint32_t PRESUR;        /*!< Parallel interface embedded sync unmask register Address offset: 0x10C */
  __IO uint32_t RESERVED3[57]; /*!< Reserved,                                  Address offset: 0x110-0x1F0 */
  __IO uint32_t PRIER;         /*!< Parallel interface interrupt enable register     Address offset: 0x1F4 */
  __IO uint32_t PRSR;          /*!< Parallel interface status register               Address offset: 0x1F8 */
  __IO uint32_t PRFCR;         /*!< Parallel interface interrupt clear register      Address offset: 0x1FC */
  uint32_t RESERVED4;          /*!< Reserved,                                        Address offset: 0x200 */
  __IO uint32_t CMCR;          /*!< Common configuration register                    Address offset: 0x204 */
  __IO uint32_t CMFRCR;        /*!< Common frame counter register                    Address offset: 0x208 */
  __IO uint32_t RESERVED5[121]; /*!< Reserved,                                 Address offset: 0x20C-0x3EC */
  __IO uint32_t CMIER;         /*!< Common interrupt enable register                 Address offset: 0x3F0 */
  __IO uint32_t CMSR1;         /*!< Common status register 1                         Address offset: 0x3F4 */
  __IO uint32_t CMSR2;         /*!< Common status register 2                         Address offset: 0x3F8 */
  __IO uint32_t CMFCR;         /*!< Common interrupt clear register                  Address offset: 0x3FC */
  uint32_t RESERVED6;          /*!< Reserved,                                        Address offset: 0x400 */
  __IO uint32_t P0FSCR;        /*!< Pipe0 flow selection configuration register      Address offset: 0x404 */
  __IO uint32_t RESERVED7[62]; /*!< Reserved,                                  Address offset: 0x408-0x4FC */
  __IO uint32_t P0FCTCR;       /*!< Pipe0 flow control configuration register        Address offset: 0x500 */
  __IO uint32_t P0SCSTR;       /*!< Pipe0 stat/crop start register                   Address offset: 0x504 */
  __IO uint32_t P0SCSZR;       /*!< Pipe0 stat/crop size register                    Address offset: 0x508 */
  __IO uint32_t RESERVED8[41]; /*!< Reserved,                                  Address offset: 0x50C-0x5AC */
  __IO uint32_t P0DCCNTR;      /*!< Pipe0 dump counter register                      Address offset: 0x5B0 */
  __IO uint32_t P0DCLMTR;      /*!< Pipe0 dump limit register                        Address offset: 0x5B4 */
  __IO uint32_t RESERVED9[2];  /*!< Reserved,                                  Address offset: 0x5B8-0x5BC */
  __IO uint32_t P0PPCR;        /*!< Pipe0 pixel packer configuration register        Address offset: 0x5C0 */
  __IO uint32_t P0PPM0AR1;     /*!< Pipe0 pixel packer memory0 address register 1    Address offset: 0x5C4 */
  __IO uint32_t P0PPM0AR2;     /*!< Pipe0 pixel packer memory0 address register 2    Address offset: 0x5C8 */
  __IO uint32_t RESERVED10[10]; /*!< Reserved,                                 Address offset: 0x5CC-0x5F0 */
  __IO uint32_t P0IER;         /*!< Pipe0 interrupt enable register                  Address offset: 0x5F4 */
  __IO uint32_t P0SR;          /*!< Pipe0 status register                            Address offset: 0x5F8 */
  __IO uint32_t P0FCR;         /*!< Pipe0 interrupt clear register                   Address offset: 0x5FC */
  __IO uint32_t RESERVED11[64]; /*!< Reserved,                                 Address offset: 0x600-0x6FC */
  __IO uint32_t P0CFCTCR;      /*!< Pipe0 current flow control configuration register Address offset: 0x700 */
  __IO uint32_t P0CSCSTR;      /*!< Pipe0 current stat/crop start register           Address offset: 0x704 */
  __IO uint32_t P0CSCSZR;      /*!< Pipe0 current stat/crop size register            Address offset: 0x708 */
  __IO uint32_t RESERVED12[45]; /*!< Reserved,                                 Address offset: 0x70C-0x7BC */
  __IO uint32_t P0CPPCR;       /*!< Pipe0 current pixel packer configuration register      Address offset: 0x700 */
  __IO uint32_t P0CPPM0AR1;    /*!< Pipe0 current pixel packer memory0 address register 1  Address offset: 0x7C4 */
  __IO uint32_t P0CPPM0AR2;    /*!< Pipe0 current pixel packer memory0 address register 2  Address offset: 0x7C8 */
} DCMIPP_TypeDef;
#define DCMIPP_NUM_OF_PIPES 0x1U
#define DCMIPP_IPGR1_MEMORYPAGE_Pos    (0U)
#define DCMIPP_IPGR1_MEMORYPAGE_Msk    (0x7UL << DCMIPP_IPGR1_MEMORYPAGE_Pos)  /*!< 0x00000007 */
#define DCMIPP_IPGR1_MEMORYPAGE        DCMIPP_IPGR1_MEMORYPAGE_Msk             /*!< MEMORYPAGE[2:0] */
#define DCMIPP_IPGR1_QOS_MODE_Pos      (24U)
#define DCMIPP_IPGR1_QOS_MODE_Msk      (0x1UL << DCMIPP_IPGR1_QOS_MODE_Pos)    /*!< 0x01000000 */
#define DCMIPP_IPGR1_QOS_MODE          DCMIPP_IPGR1_QOS_MODE_Msk               /*!< Quality Of Service */
#define DCMIPP_IPGR2_PSTART_Pos        (0U)
#define DCMIPP_IPGR2_PSTART_Msk        (0x1UL << DCMIPP_IPGR2_PSTART_Pos)      /*!< 0x00000001 */
#define DCMIPP_IPGR2_PSTART            DCMIPP_IPGR2_PSTART_Msk                 /*!< request to lock the IP-Plug */
#define DCMIPP_IPGR3_IDLE_Pos          (0U)
#define DCMIPP_IPGR3_IDLE_Msk          (0x1UL << DCMIPP_IPGR3_IDLE_Pos)        /*!< 0x00000001 */
#define DCMIPP_IPGR3_IDLE              DCMIPP_IPGR3_IDLE_Msk                   /*!< request to lock the IP-Plug */
#define DCMIPP_IPGR8_DID_Pos           (0U)
#define DCMIPP_IPGR8_DID_Msk           (0x3FUL << DCMIPP_IPGR8_DID_Pos)        /*!< 0x0000003F */
#define DCMIPP_IPGR8_DID               DCMIPP_IPGR8_DID_Msk                    /*!< DID[5:0]: division identifier */
#define DCMIPP_IPGR8_REVID_Pos         (8U)
#define DCMIPP_IPGR8_REVID_Msk         (0x1FUL << DCMIPP_IPGR8_REVID_Pos)      /*!< 0x00001F00 */
#define DCMIPP_IPGR8_REVID             DCMIPP_IPGR8_REVID_Msk                  /*!< REVID[4:0]: revision identifier */
#define DCMIPP_IPGR8_ARCHIID_Pos       (16U)
#define DCMIPP_IPGR8_ARCHIID_Msk       (0x1FUL << DCMIPP_IPGR8_ARCHIID_Pos)    /*!< 0x001F0000 */
#define DCMIPP_IPGR8_ARCHIID           DCMIPP_IPGR8_ARCHIID_Msk                /*!< ARCHIID[4:0]: architecture identifier */
#define DCMIPP_IPGR8_IPID_Pos          (24U)
#define DCMIPP_IPGR8_IPID_Msk          (0xFFUL << DCMIPP_IPGR8_IPID_Pos)       /*!< 0xFF000000 */
#define DCMIPP_IPGR8_IPID              DCMIPP_IPGR8_IPID_Msk                   /*!< IPPID[7:0]: IP identifier */
#define DCMIPP_IPC1R1_TRAFFIC_Pos      (0U)
#define DCMIPP_IPC1R1_TRAFFIC_Msk      (0x7UL << DCMIPP_IPC1R1_TRAFFIC_Pos)    /*!< 0x00000007 */
#define DCMIPP_IPC1R1_TRAFFIC          DCMIPP_IPC1R1_TRAFFIC_Msk               /*!< TRAFFIC[2:0] */
#define DCMIPP_IPC1R1_OTR_Pos          (8U)
#define DCMIPP_IPC1R1_OTR_Msk          (0x3UL << DCMIPP_IPC1R1_OTR_Pos)        /*!< 0x00000300 */
#define DCMIPP_IPC1R1_OTR              DCMIPP_IPC1R1_OTR_Msk                   /*!< OTR[1:0]: max outstanding transactions */
#define DCMIPP_IPC1R2_WLRU_Pos         (16U)
#define DCMIPP_IPC1R2_WLRU_Msk         (0xFUL << DCMIPP_IPC1R2_WLRU_Pos)       /*!< 0x000F0000 */
#define DCMIPP_IPC1R2_WLRU             DCMIPP_IPC1R2_WLRU_Msk                  /*!< WLRU[3:0]: ratio for WLRU[3:0] arbitration */
#define DCMIPP_IPC1R3_DPREGSTART_Pos   (0U)
#define DCMIPP_IPC1R3_DPREGSTART_Msk   (0x1FUL << DCMIPP_IPC1R3_DPREGSTART_Pos) /*!< 0x0000001F */
#define DCMIPP_IPC1R3_DPREGSTART       DCMIPP_IPC1R3_DPREGSTART_Msk            /*!< DPREGSTART[4:0]: start word */
#define DCMIPP_IPC1R3_DPREGEND_Pos     (16U)
#define DCMIPP_IPC1R3_DPREGEND_Msk     (0x1FUL << DCMIPP_IPC1R3_DPREGEND_Pos)  /*!< 0x001F0000 */
#define DCMIPP_IPC1R3_DPREGEND         DCMIPP_IPC1R3_DPREGEND_Msk              /*!< DPREGEND[4:0]: end word */
#define DCMIPP_PRCR_ESS_Pos            (4U)
#define DCMIPP_PRCR_ESS_Msk            (0x1UL << DCMIPP_PRCR_ESS_Pos)          /*!< 0x00000010 */
#define DCMIPP_PRCR_ESS                DCMIPP_PRCR_ESS_Msk                     /*!< Embedded synchronization select */
#define DCMIPP_PRCR_PCKPOL_Pos         (5U)
#define DCMIPP_PRCR_PCKPOL_Msk         (0x1UL << DCMIPP_PRCR_PCKPOL_Pos)       /*!< 0x00000020 */
#define DCMIPP_PRCR_PCKPOL             DCMIPP_PRCR_PCKPOL_Msk                  /*!< Pixel clock polarity */
#define DCMIPP_PRCR_HSPOL_Pos          (6U)
#define DCMIPP_PRCR_HSPOL_Msk          (0x1UL << DCMIPP_PRCR_HSPOL_Pos)        /*!< 0x00000040 */
#define DCMIPP_PRCR_HSPOL              DCMIPP_PRCR_HSPOL_Msk                   /*!< Horizontal synchronization polarity */
#define DCMIPP_PRCR_VSPOL_Pos          (7U)
#define DCMIPP_PRCR_VSPOL_Msk          (0x1UL << DCMIPP_PRCR_VSPOL_Pos)        /*!< 0x00000080 */
#define DCMIPP_PRCR_VSPOL              DCMIPP_PRCR_VSPOL_Msk                   /*!< Vertical synchronization polarity */
#define DCMIPP_PRCR_EDM_Pos            (10U)
#define DCMIPP_PRCR_EDM_Msk            (0x7UL << DCMIPP_PRCR_EDM_Pos)          /*!< 0x00001C00 */
#define DCMIPP_PRCR_EDM                DCMIPP_PRCR_EDM_Msk                     /*!< EDM[2:0]: Extended data mode */
#define DCMIPP_PRCR_ENABLE_Pos         (14U)
#define DCMIPP_PRCR_ENABLE_Msk         (0x1UL << DCMIPP_PRCR_ENABLE_Pos)       /*!< 0x00004000 */
#define DCMIPP_PRCR_ENABLE             DCMIPP_PRCR_ENABLE_Msk                  /*!< Parallel Interface enable */
#define DCMIPP_PRCR_FORMAT_Pos         (16U)
#define DCMIPP_PRCR_FORMAT_Msk         (0xFFUL << DCMIPP_PRCR_FORMAT_Pos)      /*!< 0x00FF0000 */
#define DCMIPP_PRCR_FORMAT             DCMIPP_PRCR_FORMAT_Msk                  /*!< FORMAT[7:0] */
#define DCMIPP_PRCR_SWAPCYCLES_Pos     (25U)
#define DCMIPP_PRCR_SWAPCYCLES_Msk     (0x1UL << DCMIPP_PRCR_SWAPCYCLES_Pos)   /*!< 0x02000000 */
#define DCMIPP_PRCR_SWAPCYCLES         DCMIPP_PRCR_SWAPCYCLES_Msk              /*!< swap data */
#define DCMIPP_PRCR_SWAPBITS_Pos       (26U)
#define DCMIPP_PRCR_SWAPBITS_Msk       (0x1UL << DCMIPP_PRCR_SWAPBITS_Pos)     /*!< 0x04000000 */
#define DCMIPP_PRCR_SWAPBITS           DCMIPP_PRCR_SWAPBITS_Msk                /*!< swap lsb vs msb */
#define DCMIPP_PRESCR_FSC_Pos          (0U)
#define DCMIPP_PRESCR_FSC_Msk          (0xFFUL << DCMIPP_PRESCR_FSC_Pos)       /*!< 0x000000FF */
#define DCMIPP_PRESCR_FSC              DCMIPP_PRESCR_FSC_Msk                   /*!< Frame start delimiter code */
#define DCMIPP_PRESCR_LSC_Pos          (8U)
#define DCMIPP_PRESCR_LSC_Msk          (0xFFUL << DCMIPP_PRESCR_LSC_Pos)       /*!< 0x0000FF00 */
#define DCMIPP_PRESCR_LSC              DCMIPP_PRESCR_LSC_Msk                   /*!< Line start delimiter code */
#define DCMIPP_PRESCR_LEC_Pos          (16U)
#define DCMIPP_PRESCR_LEC_Msk          (0xFFUL << DCMIPP_PRESCR_LEC_Pos)       /*!< 0x00FF0000 */
#define DCMIPP_PRESCR_LEC              DCMIPP_PRESCR_LEC_Msk                   /*!< Line end delimiter code */
#define DCMIPP_PRESCR_FEC_Pos          (24U)
#define DCMIPP_PRESCR_FEC_Msk          (0xFFUL << DCMIPP_PRESCR_FEC_Pos)       /*!< 0xFF000000 */
#define DCMIPP_PRESCR_FEC              DCMIPP_PRESCR_FEC_Msk                   /*!< Frame end delimiter code */
#define DCMIPP_PRESUR_FSU_Pos          (0U)
#define DCMIPP_PRESUR_FSU_Msk          (0xFFUL << DCMIPP_PRESUR_FSU_Pos)       /*!< 0x000000FF */
#define DCMIPP_PRESUR_FSU              DCMIPP_PRESUR_FSU_Msk                   /*!< Frame start delimiter unmask */
#define DCMIPP_PRESUR_LSU_Pos          (8U)
#define DCMIPP_PRESUR_LSU_Msk          (0xFFUL << DCMIPP_PRESUR_LSU_Pos)       /*!< 0x0000FF00 */
#define DCMIPP_PRESUR_LSU              DCMIPP_PRESUR_LSU_Msk                   /*!< Line start delimiter unmask */
#define DCMIPP_PRESUR_LEU_Pos          (16U)
#define DCMIPP_PRESUR_LEU_Msk          (0xFFUL << DCMIPP_PRESUR_LEU_Pos)       /*!< 0x00FF0000 */
#define DCMIPP_PRESUR_LEU              DCMIPP_PRESUR_LEU_Msk                   /*!< Line end delimiter unmask */
#define DCMIPP_PRESUR_FEU_Pos          (24U)
#define DCMIPP_PRESUR_FEU_Msk          (0xFFUL << DCMIPP_PRESUR_FEU_Pos)       /*!< 0xFF000000 */
#define DCMIPP_PRESUR_FEU              DCMIPP_PRESUR_FEU_Msk                   /*!< Frame end delimiter unmask */
#define DCMIPP_PRIER_ERRIE_Pos         (6U)
#define DCMIPP_PRIER_ERRIE_Msk         (0x1UL << DCMIPP_PRIER_ERRIE_Pos)       /*!< 0x00000040 */
#define DCMIPP_PRIER_ERRIE             DCMIPP_PRIER_ERRIE_Msk                  /*!< Synchronization error interrupt enable */
#define DCMIPP_PRSR_ERRF_Pos           (6U)
#define DCMIPP_PRSR_ERRF_Msk           (0x1UL << DCMIPP_PRSR_ERRF_Pos)         /*!< 0x00000040 */
#define DCMIPP_PRSR_ERRF               DCMIPP_PRSR_ERRF_Msk                    /*!< Synchronization error raw interrupt status */
#define DCMIPP_PRSR_HSYNC_Pos          (16U)
#define DCMIPP_PRSR_HSYNC_Msk          (0x1UL << DCMIPP_PRSR_HSYNC_Pos)        /*!< 0x00010000 */
#define DCMIPP_PRSR_HSYNC              DCMIPP_PRSR_HSYNC_Msk                   /*!< HSYNC */
#define DCMIPP_PRSR_VSYNC_Pos          (17U)
#define DCMIPP_PRSR_VSYNC_Msk          (0x1UL << DCMIPP_PRSR_VSYNC_Pos)        /*!< 0x00020000 */
#define DCMIPP_PRSR_VSYNC              DCMIPP_PRSR_VSYNC_Msk                   /*!< VSYNC */
#define DCMIPP_PRFCR_CERRF_Pos         (6U)
#define DCMIPP_PRFCR_CERRF_Msk         (0x1UL << DCMIPP_PRFCR_CERRF_Pos)       /*!< 0x00000040 */
#define DCMIPP_PRFCR_CERRF             DCMIPP_PRFCR_CERRF_Msk                  /*!< Synchronization error interrupt status clear */
#define DCMIPP_CMCR_CFC_Pos            (4U)
#define DCMIPP_CMCR_CFC_Msk            (0x1UL << DCMIPP_CMCR_CFC_Pos)          /*!< 0x00000010 */
#define DCMIPP_CMCR_CFC                DCMIPP_CMCR_CFC_Msk                     /*!< Clear frame counter */
#define DCMIPP_CMFRCR_FRMCNT_Pos       (0U)
#define DCMIPP_CMFRCR_FRMCNT_Msk       (0xFFFFFFFFUL << DCMIPP_CMFRCR_FRMCNT_Pos) /*!< 0xFFFFFFFF */
#define DCMIPP_CMFRCR_FRMCNT           DCMIPP_CMFRCR_FRMCNT_Msk                   /*!< FRMCNT[31:0]: frame counter */
#define DCMIPP_CMIER_ATXERRIE_Pos      (5U)
#define DCMIPP_CMIER_ATXERRIE_Msk      (0x1UL << DCMIPP_CMIER_ATXERRIE_Pos)    /*!< 0x00000020 */
#define DCMIPP_CMIER_ATXERRIE          DCMIPP_CMIER_ATXERRIE_Msk               /*!< AXI Transfer error interrupt enable for IP_Plug */
#define DCMIPP_CMIER_PRERRIE_Pos       (6U)
#define DCMIPP_CMIER_PRERRIE_Msk       (0x1UL << DCMIPP_CMIER_PRERRIE_Pos)     /*!< 0x00000040 */
#define DCMIPP_CMIER_PRERRIE           DCMIPP_CMIER_PRERRIE_Msk                /*!< limit interrupt enable for the Parallel Interface */
#define DCMIPP_CMIER_P0LINEIE_Pos      (8U)
#define DCMIPP_CMIER_P0LINEIE_Msk      (0x1UL << DCMIPP_CMIER_P0LINEIE_Pos)    /*!< 0x0000100 */
#define DCMIPP_CMIER_P0LINEIE          DCMIPP_CMIER_P0LINEIE_Msk               /*!< multi-Line Capture complete interrupt enable for the Pipe0 */
#define DCMIPP_CMIER_P0FRAMEIE_Pos     (9U)
#define DCMIPP_CMIER_P0FRAMEIE_Msk     (0x1UL << DCMIPP_CMIER_P0FRAMEIE_Pos)   /*!< 0x0000200 */
#define DCMIPP_CMIER_P0FRAMEIE         DCMIPP_CMIER_P0FRAMEIE_Msk              /*!< Frame Capture complete interrupt enable for the Pipe0 */
#define DCMIPP_CMIER_P0VSYNCIE_Pos     (10U)
#define DCMIPP_CMIER_P0VSYNCIE_Msk     (0x1UL << DCMIPP_CMIER_P0VSYNCIE_Pos)   /*!< 0x0000400 */
#define DCMIPP_CMIER_P0VSYNCIE         DCMIPP_CMIER_P0VSYNCIE_Msk              /*!< Vertical sync interrupt enable for the Pipe0 */
#define DCMIPP_CMIER_P0LIMITIE_Pos     (14U)
#define DCMIPP_CMIER_P0LIMITIE_Msk     (0x1UL << DCMIPP_CMIER_P0LIMITIE_Pos)   /*!< 0x0004000 */
#define DCMIPP_CMIER_P0LIMITIE         DCMIPP_CMIER_P0LIMITIE_Msk              /*!< limit interrupt enable for the Pipe0 */
#define DCMIPP_CMIER_P0OVRIE_Pos       (15U)
#define DCMIPP_CMIER_P0OVRIE_Msk       (0x1UL << DCMIPP_CMIER_P0OVRIE_Pos)     /*!< 0x0008000 */
#define DCMIPP_CMIER_P0OVRIE           DCMIPP_CMIER_P0OVRIE_Msk                /*!< Overrun interrupt enable for the Pipe0 */
#define DCMIPP_CMSR1_PRHSYNC_Pos       (0U)
#define DCMIPP_CMSR1_PRHSYNC_Msk       (0x1UL << DCMIPP_CMSR1_PRHSYNC_Pos)     /*!< 0x00000001 */
#define DCMIPP_CMSR1_PRHSYNC           DCMIPP_CMSR1_PRHSYNC_Msk                /*!< state of the HSYNC pin */
#define DCMIPP_CMSR1_PRVSYNC_Pos       (1U)
#define DCMIPP_CMSR1_PRVSYNC_Msk       (0x1UL << DCMIPP_CMSR1_PRVSYNC_Pos)     /*!< 0x00000002 */
#define DCMIPP_CMSR1_PRVSYNC           DCMIPP_CMSR1_PRVSYNC_Msk                /*!< state of the VSYNC pin */
#define DCMIPP_CMSR1_P0CPTACT_Pos      (15U)
#define DCMIPP_CMSR1_P0CPTACT_Msk      (0x1UL << DCMIPP_CMSR1_P0CPTACT_Pos)    /*!< 0x00008000 */
#define DCMIPP_CMSR1_P0CPTACT          DCMIPP_CMSR1_P0CPTACT_Msk               /*!< active frame capture for the Pipe0 */
#define DCMIPP_CMSR2_ATXERRF_Pos       (5U)
#define DCMIPP_CMSR2_ATXERRF_Msk       (0x1UL << DCMIPP_CMSR2_ATXERRF_Pos)     /*!< 0x00000020 */
#define DCMIPP_CMSR2_ATXERRF           DCMIPP_CMSR2_ATXERRF_Msk                /*!< AXI transfer error interrupt status flag for the IPPLUG */
#define DCMIPP_CMSR2_PRERRF_Pos        (6U)
#define DCMIPP_CMSR2_PRERRF_Msk        (0x1UL << DCMIPP_CMSR2_PRERRF_Pos)      /*!< 0x00000040 */
#define DCMIPP_CMSR2_PRERRF            DCMIPP_CMSR2_PRERRF_Msk                 /*!< Synchronization error raw interrupt status flag for the Parallel Interface */
#define DCMIPP_CMSR2_P0LINEF_Pos       (8U)
#define DCMIPP_CMSR2_P0LINEF_Msk       (0x1UL << DCMIPP_CMSR2_P0LINEF_Pos)      /*!< 0x00000100 */
#define DCMIPP_CMSR2_P0LINEF           DCMIPP_CMSR2_P0LINEF_Msk                /*!< multi-Line Capture completed raw interrupt status flag for the Pipe0 */
#define DCMIPP_CMSR2_P0FRAMEF_Pos      (9U)
#define DCMIPP_CMSR2_P0FRAMEF_Msk      (0x1UL << DCMIPP_CMSR2_P0FRAMEF_Pos)    /*!< 0x00000200 */
#define DCMIPP_CMSR2_P0FRAMEF          DCMIPP_CMSR2_P0FRAMEF_Msk               /*!< Frame Capture completed raw interrupt status flag for the Pipe0 */
#define DCMIPP_CMSR2_P0VSYNCF_Pos      (10U)
#define DCMIPP_CMSR2_P0VSYNCF_Msk      (0x1UL << DCMIPP_CMSR2_P0VSYNCF_Pos)    /*!< 0x00000400 */
#define DCMIPP_CMSR2_P0VSYNCF          DCMIPP_CMSR2_P0VSYNCF_Msk               /*!< VSYNC raw interrupt status flag for the Pipe0 */
#define DCMIPP_CMSR2_P0LIMITF_Pos      (14U)
#define DCMIPP_CMSR2_P0LIMITF_Msk      (0x1UL << DCMIPP_CMSR2_P0LIMITF_Pos)    /*!< 0x00004000 */
#define DCMIPP_CMSR2_P0LIMITF          DCMIPP_CMSR2_P0LIMITF_Msk               /*!< Limit raw interrupt status flag for the Pipe0 */
#define DCMIPP_CMSR2_P0OVRF_Pos        (15U)
#define DCMIPP_CMSR2_P0OVRF_Msk        (0x1UL << DCMIPP_CMSR2_P0OVRF_Pos)      /*!< 0x00008000 */
#define DCMIPP_CMSR2_P0OVRF            DCMIPP_CMSR2_P0OVRF_Msk                 /*!< Overrun raw interrupt status flag for the Pipe0 */
#define DCMIPP_CMFCR_CATXERRF_Pos      (5U)
#define DCMIPP_CMFCR_CATXERRF_Msk      (0x1UL << DCMIPP_CMFCR_CATXERRF_Pos)    /*!< 0x00000020 */
#define DCMIPP_CMFCR_CATXERRF          DCMIPP_CMFCR_CATXERRF_Msk               /*!< AXI transfer error interrupt status clear for the IPPLUG */
#define DCMIPP_CMFCR_CPRERRF_Pos       (6U)
#define DCMIPP_CMFCR_CPRERRF_Msk       (0x1UL << DCMIPP_CMFCR_CPRERRF_Pos)     /*!< 0x00000040 */
#define DCMIPP_CMFCR_CPRERRF           DCMIPP_CMFCR_CPRERRF_Msk                /*!< Synchronization error raw interrupt status clear for the Parallel Interface */
#define DCMIPP_CMFCR_CP0LINEF_Pos      (8U)
#define DCMIPP_CMFCR_CP0LINEF_Msk      (0x1UL << DCMIPP_CMFCR_CP0LINEF_Pos)    /*!< 0x00000100 */
#define DCMIPP_CMFCR_CP0LINEF          DCMIPP_CMFCR_CP0LINEF_Msk               /*!< multi-Line Capture completed raw interrupt status clear for the Pipe0 */
#define DCMIPP_CMFCR_CP0FRAMEF_Pos     (9U)
#define DCMIPP_CMFCR_CP0FRAMEF_Msk     (0x1UL << DCMIPP_CMFCR_CP0FRAMEF_Pos)   /*!< 0x00000200 */
#define DCMIPP_CMFCR_CP0FRAMEF         DCMIPP_CMFCR_CP0FRAMEF_Msk              /*!< Frame Capture completed raw interrupt status clear for the Pipe0 */
#define DCMIPP_CMFCR_CP0VSYNCF_Pos     (10U)
#define DCMIPP_CMFCR_CP0VSYNCF_Msk     (0x1UL << DCMIPP_CMFCR_CP0VSYNCF_Pos)   /*!< 0x00000400 */
#define DCMIPP_CMFCR_CP0VSYNCF         DCMIPP_CMFCR_CP0VSYNCF_Msk              /*!< VSYNC raw interrupt status clear for the Pipe0 */
#define DCMIPP_CMFCR_CP0LIMITF_Pos     (14U)
#define DCMIPP_CMFCR_CP0LIMITF_Msk     (0x1UL << DCMIPP_CMFCR_CP0LIMITF_Pos)   /*!< 0x00004000 */
#define DCMIPP_CMFCR_CP0LIMITF         DCMIPP_CMFCR_CP0LIMITF_Msk              /*!< Limit raw interrupt status clear for the Pipe0 */
#define DCMIPP_CMFCR_CP0OVRF_Pos       (15U)
#define DCMIPP_CMFCR_CP0OVRF_Msk       (0x1UL << DCMIPP_CMFCR_CP0OVRF_Pos)     /*!< 0x00008000 */
#define DCMIPP_CMFCR_CP0OVRF           DCMIPP_CMFCR_CP0OVRF_Msk                /*!< Overrun raw interrupt status clear for the Pipe0 */
#define DCMIPP_P0FSCR_PIPEN_Pos        (31U)
#define DCMIPP_P0FSCR_PIPEN_Msk        (0x1UL << DCMIPP_P0FSCR_PIPEN_Pos)      /*!< 0x80000000 */
#define DCMIPP_P0FSCR_PIPEN            DCMIPP_P0FSCR_PIPEN_Msk                 /*!< activation of this Pipe */
#define DCMIPP_P0FCTCR_FRATE_Pos       (0U)
#define DCMIPP_P0FCTCR_FRATE_Msk       (0x3UL << DCMIPP_P0FCTCR_FRATE_Pos)     /*!< 0x00000003 */
#define DCMIPP_P0FCTCR_FRATE           DCMIPP_P0FCTCR_FRATE_Msk                /*!< FRATE[1:0]: Frame capture rate control */
#define DCMIPP_P0FCTCR_CPTMODE_Pos     (2U)
#define DCMIPP_P0FCTCR_CPTMODE_Msk     (0x1UL << DCMIPP_P0FCTCR_CPTMODE_Pos)   /*!< 0x00000004 */
#define DCMIPP_P0FCTCR_CPTMODE         DCMIPP_P0FCTCR_CPTMODE_Msk              /*!< Capture mode */
#define DCMIPP_P0FCTCR_CPTREQ_Pos      (3U)
#define DCMIPP_P0FCTCR_CPTREQ_Msk      (0x1UL << DCMIPP_P0FCTCR_CPTREQ_Pos)    /*!< 0x00000008 */
#define DCMIPP_P0FCTCR_CPTREQ          DCMIPP_P0FCTCR_CPTREQ_Msk               /*!< Capture requested */
#define DCMIPP_P0SCSTR_HSTART_Pos      (0U)
#define DCMIPP_P0SCSTR_HSTART_Msk      (0xFFFUL << DCMIPP_P0SCSTR_HSTART_Pos)  /*!< 0x00000FFF */
#define DCMIPP_P0SCSTR_HSTART          DCMIPP_P0SCSTR_HSTART_Msk               /*!< HSTART[11:0]: horizontal start */
#define DCMIPP_P0SCSTR_VSTART_Pos      (16U)
#define DCMIPP_P0SCSTR_VSTART_Msk      (0xFFFUL << DCMIPP_P0SCSTR_VSTART_Pos)  /*!< 0x0FFF0000 */
#define DCMIPP_P0SCSTR_VSTART          DCMIPP_P0SCSTR_VSTART_Msk               /*!< VSTART[11:0]: vertical start */
#define DCMIPP_P0SCSZR_HSIZE_Pos       (0U)
#define DCMIPP_P0SCSZR_HSIZE_Msk       (0xFFFUL << DCMIPP_P0SCSZR_HSIZE_Pos)   /*!< 0x00000FFF */
#define DCMIPP_P0SCSZR_HSIZE           DCMIPP_P0SCSZR_HSIZE_Msk                /*!< HSTART[11:0]: horizontal size */
#define DCMIPP_P0SCSZR_VSIZE_Pos       (16U)
#define DCMIPP_P0SCSZR_VSIZE_Msk       (0xFFFUL << DCMIPP_P0SCSZR_VSIZE_Pos)   /*!< 0x0FFF0000 */
#define DCMIPP_P0SCSZR_VSIZE           DCMIPP_P0SCSZR_VSIZE_Msk                /*!< VSTART[11:0]: vertical size */
#define DCMIPP_P0SCSZR_POSNEG_Pos      (30U)
#define DCMIPP_P0SCSZR_POSNEG_Msk      (0x1UL << DCMIPP_P0SCSZR_POSNEG_Pos)    /*!< 0x40000000 */
#define DCMIPP_P0SCSZR_POSNEG          DCMIPP_P0SCSZR_POSNEG_Msk               /*!< Negative area */
#define DCMIPP_P0SCSZR_ENABLE_Pos      (31U)
#define DCMIPP_P0SCSZR_ENABLE_Msk      (0x1UL << DCMIPP_P0SCSZR_ENABLE_Pos)    /*!< 0x80000000 */
#define DCMIPP_P0SCSZR_ENABLE          DCMIPP_P0SCSZR_ENABLE_Msk               /*!< Enable */
#define DCMIPP_P0DCCNTR_CNT_Pos        (0U)
#define DCMIPP_P0DCCNTR_CNT_Msk        (0x3FFFFFFUL << DCMIPP_P0DCCNTR_CNT_Pos) /*!< 0x03FFFFFF */
#define DCMIPP_P0DCCNTR_CNT            DCMIPP_P0DCCNTR_CNT_Msk                  /*!< CNT[25:0]: number of data dumped during the frame */
#define DCMIPP_P0DCLMTR_LIMIT_Pos      (0U)
#define DCMIPP_P0DCLMTR_LIMIT_Msk      (0xFFFFFFUL << DCMIPP_P0DCLMTR_LIMIT_Pos) /*!< 0x00FFFFFF */
#define DCMIPP_P0DCLMTR_LIMIT          DCMIPP_P0DCLMTR_LIMIT_Msk                 /*!< LIMIT[23:0]: maximum number of data dumped during the frame */
#define DCMIPP_P0DCLMTR_ENABLE_Pos     (31U)
#define DCMIPP_P0DCLMTR_ENABLE_Msk     (0x1UL << DCMIPP_P0DCLMTR_ENABLE_Pos)   /*!< 0x80000000 */
#define DCMIPP_P0DCLMTR_ENABLE         DCMIPP_P0DCLMTR_ENABLE_Msk              /*!< Enable */
#define DCMIPP_P0PPCR_PAD_Pos          (5U)
#define DCMIPP_P0PPCR_PAD_Msk          (0x1UL << DCMIPP_P0PPCR_PAD_Pos)        /*!< 0x00000020 */
#define DCMIPP_P0PPCR_PAD              DCMIPP_P0PPCR_PAD_Msk                   /*!< PAD mode */
#define DCMIPP_P0PPCR_BSM_Pos          (7U)
#define DCMIPP_P0PPCR_BSM_Msk          (0x3UL << DCMIPP_P0PPCR_BSM_Pos)        /*!< 0x00000180 */
#define DCMIPP_P0PPCR_BSM              DCMIPP_P0PPCR_BSM_Msk                   /*!< Byte Select mode */
#define DCMIPP_P0PPCR_OEBS_Pos         (9U)
#define DCMIPP_P0PPCR_OEBS_Msk         (0x1UL << DCMIPP_P0PPCR_OEBS_Pos)       /*!< 0x00000200 */
#define DCMIPP_P0PPCR_OEBS             DCMIPP_P0PPCR_OEBS_Msk                  /*!< Odd/Even Byte Select */
#define DCMIPP_P0PPCR_LSM_Pos          (10U)
#define DCMIPP_P0PPCR_LSM_Msk          (0x1UL << DCMIPP_P0PPCR_LSM_Pos)        /*!< 0x00000400 */
#define DCMIPP_P0PPCR_LSM              DCMIPP_P0PPCR_LSM_Msk                   /*!< Line Select mode */
#define DCMIPP_P0PPCR_OELS_Pos         (11U)
#define DCMIPP_P0PPCR_OELS_Msk         (0x1UL << DCMIPP_P0PPCR_OELS_Pos)       /*!< 0x00000800 */
#define DCMIPP_P0PPCR_OELS             DCMIPP_P0PPCR_OELS_Msk                  /*!< Odd/Even Line Select */
#define DCMIPP_P0PPCR_LINEMULT_Pos     (13U)
#define DCMIPP_P0PPCR_LINEMULT_Msk     (0x7UL << DCMIPP_P0PPCR_LINEMULT_Pos)   /*!< 0x0000E000 */
#define DCMIPP_P0PPCR_LINEMULT         DCMIPP_P0PPCR_LINEMULT_Msk              /*!< LINEMULT[2:0] */
#define DCMIPP_P0PPCR_DBM_Pos          (16U)
#define DCMIPP_P0PPCR_DBM_Msk          (0x1UL << DCMIPP_P0PPCR_DBM_Pos)        /*!< 0x00010000 */
#define DCMIPP_P0PPCR_DBM              DCMIPP_P0PPCR_DBM_Msk                   /*!< Double buffer mode */
#define DCMIPP_P0PPM0AR1_MOA_Pos       (0U)
#define DCMIPP_P0PPM0AR1_MOA_Msk       (0xFFFFFFFFUL << DCMIPP_P0PPM0AR1_MOA_Pos) /*!< 0xFFFFFFFF */
#define DCMIPP_P0PPM0AR1_MOA           DCMIPP_P0PPM0AR1_MOA_Msk                   /*!< Memory 0 address register 1 */
#define DCMIPP_P0PPM0AR2_MOA_Pos       (0U)
#define DCMIPP_P0PPM0AR2_MOA_Msk       (0xFFFFFFFFUL << DCMIPP_P0PPM0AR2_MOA_Pos) /*!< 0xFFFFFFFF */
#define DCMIPP_P0PPM0AR2_MOA           DCMIPP_P0PPM0AR2_MOA_Msk                   /*!< Memory 0 address register 2 */
#define DCMIPP_P0IER_LINEIE_Pos        (0U)
#define DCMIPP_P0IER_LINEIE_Msk        (0x1UL << DCMIPP_P0IER_LINEIE_Pos)      /*!< 0x00000001 */
#define DCMIPP_P0IER_LINEIE            DCMIPP_P0IER_LINEIE_Msk                 /*!< multi-Line Capture completed interrupt enable */
#define DCMIPP_P0IER_FRAMEIE_Pos       (1U)
#define DCMIPP_P0IER_FRAMEIE_Msk       (0x1UL << DCMIPP_P0IER_FRAMEIE_Pos)     /*!< 0x00000002 */
#define DCMIPP_P0IER_FRAMEIE           DCMIPP_P0IER_FRAMEIE_Msk                /*!< Frame Capture completed interrupt enable */
#define DCMIPP_P0IER_VSYNCIE_Pos       (2U)
#define DCMIPP_P0IER_VSYNCIE_Msk       (0x1UL << DCMIPP_P0IER_VSYNCIE_Pos)     /*!< 0x00000004 */
#define DCMIPP_P0IER_VSYNCIE           DCMIPP_P0IER_VSYNCIE_Msk                /*!< VSYNC interrupt enable */
#define DCMIPP_P0IER_LIMITIE_Pos       (6U)
#define DCMIPP_P0IER_LIMITIE_Msk       (0x1UL << DCMIPP_P0IER_LIMITIE_Pos)     /*!< 0x00000040 */
#define DCMIPP_P0IER_LIMITIE           DCMIPP_P0IER_LIMITIE_Msk                /*!< Limit interrupt enable */
#define DCMIPP_P0IER_OVRIE_Pos         (7U)
#define DCMIPP_P0IER_OVRIE_Msk         (0x1UL << DCMIPP_P0IER_OVRIE_Pos)       /*!< 0x00000080 */
#define DCMIPP_P0IER_OVRIE             DCMIPP_P0IER_OVRIE_Msk                  /*!< Overrun interrupt enable */
#define DCMIPP_P0SR_LINEF_Pos          (0U)
#define DCMIPP_P0SR_LINEF_Msk          (0x1UL << DCMIPP_P0SR_LINEF_Pos)        /*!< 0x00000001 */
#define DCMIPP_P0SR_LINEF              DCMIPP_P0SR_LINEF_Msk                   /*!< multi-Line Capture completed interrupt status */
#define DCMIPP_P0SR_FRAMEF_Pos         (1U)
#define DCMIPP_P0SR_FRAMEF_Msk         (0x1UL << DCMIPP_P0SR_FRAMEF_Pos)       /*!< 0x00000002 */
#define DCMIPP_P0SR_FRAMEF             DCMIPP_P0SR_FRAMEF_Msk                  /*!< Frame Capture completed interrupt status */
#define DCMIPP_P0SR_VSYNCF_Pos         (2U)
#define DCMIPP_P0SR_VSYNCF_Msk         (0x1UL << DCMIPP_P0SR_VSYNCF_Pos)       /*!< 0x00000004 */
#define DCMIPP_P0SR_VSYNCF             DCMIPP_P0SR_VSYNCF_Msk                  /*!< VSYNC interrupt status */
#define DCMIPP_P0SR_LIMITF_Pos         (6U)
#define DCMIPP_P0SR_LIMITF_Msk         (0x1UL << DCMIPP_P0SR_LIMITF_Pos)       /*!< 0x00000040 */
#define DCMIPP_P0SR_LIMITF             DCMIPP_P0SR_LIMITF_Msk                  /*!< Limit interrupt status */
#define DCMIPP_P0SR_OVRF_Pos           (7U)
#define DCMIPP_P0SR_OVRF_Msk           (0x1UL << DCMIPP_P0SR_OVRF_Pos)         /*!< 0x00000080 */
#define DCMIPP_P0SR_OVRF               DCMIPP_P0SR_OVRF_Msk                    /*!< Overrun interrupt status */
#define DCMIPP_P0SR_LSTLINE_Pos        (16U)
#define DCMIPP_P0SR_LSTLINE_Msk        (0x1UL << DCMIPP_P0SR_LSTLINE_Pos)      /*!< 0x00010000 */
#define DCMIPP_P0SR_LSTLINE            DCMIPP_P0SR_LSTLINE_Msk                 /*!< Last Line Lsb bit */
#define DCMIPP_P0SR_CPTACT_Pos         (23U)
#define DCMIPP_P0SR_CPTACT_Msk         (0x1UL << DCMIPP_P0SR_CPTACT_Pos)       /*!< 0x00800000 */
#define DCMIPP_P0SR_CPTACT             DCMIPP_P0SR_CPTACT_Msk                  /*!< Capture immediate status */
#define DCMIPP_P0FCR_CLINEF_Pos        (0U)
#define DCMIPP_P0FCR_CLINEF_Msk        (0x1UL << DCMIPP_P0FCR_CLINEF_Pos)      /*!< 0x00000001 */
#define DCMIPP_P0FCR_CLINEF            DCMIPP_P0FCR_CLINEF_Msk                 /*!< multi-Line Capture completed interrupt status clear */
#define DCMIPP_P0FCR_CFRAMEF_Pos       (1U)
#define DCMIPP_P0FCR_CFRAMEF_Msk       (0x1UL << DCMIPP_P0FCR_CFRAMEF_Pos)     /*!< 0x00000002 */
#define DCMIPP_P0FCR_CFRAMEF           DCMIPP_P0FCR_CFRAMEF_Msk                /*!< Frame Capture completed interrupt status clear */
#define DCMIPP_P0FCR_CVSYNCF_Pos       (2U)
#define DCMIPP_P0FCR_CVSYNCF_Msk       (0x1UL << DCMIPP_P0FCR_CVSYNCF_Pos)     /*!< 0x00000004 */
#define DCMIPP_P0FCR_CVSYNCF           DCMIPP_P0FCR_CVSYNCF_Msk                /*!< VSYNC interrupt status clear */
#define DCMIPP_P0FCR_CLIMITF_Pos       (6U)
#define DCMIPP_P0FCR_CLIMITF_Msk       (0x1UL << DCMIPP_P0FCR_CLIMITF_Pos)     /*!< 0x00000040 */
#define DCMIPP_P0FCR_CLIMITF           DCMIPP_P0FCR_CLIMITF_Msk                /*!< Limit interrupt status clear */
#define DCMIPP_P0FCR_COVRF_Pos         (7U)
#define DCMIPP_P0FCR_COVRF_Msk         (0x1UL << DCMIPP_P0FCR_COVRF_Pos)       /*!< 0x00000080 */
#define DCMIPP_P0FCR_COVRF             DCMIPP_P0FCR_COVRF_Msk                  /*!< Overrun interrupt status clear */
#define DCMIPP_P0CFCTCR_FRATE_Pos      (0U)
#define DCMIPP_P0CFCTCR_FRATE_Msk      (0x3UL << DCMIPP_P0CFCTCR_FRATE_Pos)    /*!< 0x00000003 */
#define DCMIPP_P0CFCTCR_FRATE          DCMIPP_P0CFCTCR_FRATE_Msk               /*!< FRATE[1:0]: Frame capture rate control */
#define DCMIPP_P0CFCTCR_CPTMODE_Pos    (2U)
#define DCMIPP_P0CFCTCR_CPTMODE_Msk    (0x1UL << DCMIPP_P0CFCTCR_CPTMODE_Pos)  /*!< 0x00000004 */
#define DCMIPP_P0CFCTCR_CPTMODE        DCMIPP_P0CFCTCR_CPTMODE_Msk             /*!< Capture mode */
#define DCMIPP_P0CFCTCR_CPTREQ_Pos     (3U)
#define DCMIPP_P0CFCTCR_CPTREQ_Msk     (0x1UL << DCMIPP_P0CFCTCR_CPTREQ_Pos)   /*!< 0x00000008 */
#define DCMIPP_P0CFCTCR_CPTREQ         DCMIPP_P0CFCTCR_CPTREQ_Msk              /*!< Capture requested */
#define DCMIPP_P0CSCSTR_HSTART_Pos     (0U)
#define DCMIPP_P0CSCSTR_HSTART_Msk     (0xFFFUL << DCMIPP_P0CSCSTR_HSTART_Pos) /*!< 0x00000FFF */
#define DCMIPP_P0CSCSTR_HSTART         DCMIPP_P0CSCSTR_HSTART_Msk              /*!< HSTART[11:0]: horizontal start */
#define DCMIPP_P0CSCSTR_VSTART_Pos     (16U)
#define DCMIPP_P0CSCSTR_VSTART_Msk     (0xFFFUL << DCMIPP_P0CSCSTR_VSTART_Pos) /*!< 0x0FFF0000 */
#define DCMIPP_P0CSCSTR_VSTART         DCMIPP_P0CSCSTR_VSTART_Msk              /*!< VSTART[11:0]: vertical start */
#define DCMIPP_P0CSCSZR_HSIZE_Pos      (0U)
#define DCMIPP_P0CSCSZR_HSIZE_Msk      (0xFFFUL << DCMIPP_P0CSCSZR_HSIZE_Pos)  /*!< 0x00000FFF */
#define DCMIPP_P0CSCSZR_HSIZE          DCMIPP_P0CSCSZR_HSIZE_Msk               /*!< HSTART[11:0]: horizontal size */
#define DCMIPP_P0CSCSZR_VSIZE_Pos      (16U)
#define DCMIPP_P0CSCSZR_VSIZE_Msk      (0xFFFUL << DCMIPP_P0CSCSZR_VSIZE_Pos)  /*!< 0x0FFF0000 */
#define DCMIPP_P0CSCSZR_VSIZE          DCMIPP_P0CSCSZR_VSIZE_Msk               /*!< VSTART[11:0]: vertical size */
#define DCMIPP_P0CSCSZR_POSNEG_Pos     (30U)
#define DCMIPP_P0CSCSZR_POSNEG_Msk     (0x1UL << DCMIPP_P0CSCSZR_POSNEG_Pos)   /*!< 0x40000000 */
#define DCMIPP_P0CSCSZR_POSNEG         DCMIPP_P0CSCSZR_POSNEG_Msk              /*!< Negative area */
#define DCMIPP_P0CSCSZR_ENABLE_Pos     (31U)
#define DCMIPP_P0CSCSZR_ENABLE_Msk     (0x1UL << DCMIPP_P0CSCSZR_ENABLE_Pos)   /*!< 0x80000000 */
#define DCMIPP_P0CSCSZR_ENABLE         DCMIPP_P0CSCSZR_ENABLE_Msk              /*!< Enable */
#define DCMIPP_P0CPPCR_PAD_Pos         (5U)
#define DCMIPP_P0CPPCR_PAD_Msk         (0x1UL << DCMIPP_P0CPPCR_PAD_Pos)       /*!< 0x00000020 */
#define DCMIPP_P0CPPCR_PAD             DCMIPP_P0CPPCR_PAD_Msk                  /*!< PAD mode */
#define DCMIPP_P0CPPCR_BSM_Pos         (7U)
#define DCMIPP_P0CPPCR_BSM_Msk         (0x3UL << DCMIPP_P0CPPCR_BSM_Pos)       /*!< 0x00000180 */
#define DCMIPP_P0CPPCR_BSM             DCMIPP_P0CPPCR_BSM_Msk                  /*!< Byte Select mode */
#define DCMIPP_P0CPPCR_OEBS_Pos        (9U)
#define DCMIPP_P0CPPCR_OEBS_Msk        (0x1UL << DCMIPP_P0CPPCR_OEBS_Pos)      /*!< 0x00000200 */
#define DCMIPP_P0CPPCR_OEBS            DCMIPP_P0CPPCR_OEBS_Msk                 /*!< Odd/Even Byte Select */
#define DCMIPP_P0CPPCR_LSM_Pos         (10U)
#define DCMIPP_P0CPPCR_LSM_Msk         (0x1UL << DCMIPP_P0CPPCR_LSM_Pos)       /*!< 0x00000400 */
#define DCMIPP_P0CPPCR_LSM             DCMIPP_P0CPPCR_LSM_Msk                  /*!< Line Select mode */
#define DCMIPP_P0CPPCR_OELS_Pos        (11U)
#define DCMIPP_P0CPPCR_OELS_Msk        (0x1UL << DCMIPP_P0CPPCR_OELS_Pos)      /*!< 0x00000800 */
#define DCMIPP_P0CPPCR_OELS            DCMIPP_P0CPPCR_OELS_Msk                 /*!< Odd/Even Line Select */
#define DCMIPP_P0CPPCR_LINEMULT_Pos    (13U)
#define DCMIPP_P0CPPCR_LINEMULT_Msk    (0x7UL << DCMIPP_P0CPPCR_LINEMULT_Pos)  /*!< 0x0000E000 */
#define DCMIPP_P0CPPCR_LINEMULT        DCMIPP_P0CPPCR_LINEMULT_Msk             /*!< LINEMULT[2:0] */
#define DCMIPP_P0CPPCR_DBM_Pos         (16U)
#define DCMIPP_P0CPPCR_DBM_Msk         (0x1UL << DCMIPP_P0CPPCR_DBM_Pos)       /*!< 0x00010000 */
#define DCMIPP_P0CPPCR_DBM             DCMIPP_P0CPPCR_DBM_Msk                  /*!< Double buffer mode */
#define DCMIPP_P0CPPM0AR1_MOA_Pos     (0U)
#define DCMIPP_P0CPPM0AR1_MOA_Msk     (0xFFFFFFFFUL << DCMIPP_P0CPPM0AR1_MOA_Pos) /*!< 0xFFFFFFFF */
#define DCMIPP_P0CPPM0AR1_MOA         DCMIPP_P0CPPM0AR1_MOA_Msk                   /*!< Memory 0 address register 1 */
#define DCMIPP_P0CPPM0AR2_MOA_Pos     (0U)
#define DCMIPP_P0CPPM0AR2_MOA_Msk     (0xFFFFFFFFUL << DCMIPP_P0CPPM0AR2_MOA_Pos) /*!< 0xFFFFFFFF */
#define DCMIPP_P0CPPM0AR2_MOA         DCMIPP_P0CPPM0AR2_MOA_Msk                   /*!< Memory 0 address register 2 */
