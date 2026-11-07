/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Extracted unchanged from CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
#define PERIPH_BASE                     0x40000000UL  /*!< AHB and APB Peripherals base address */

#define AHB5PERIPH_BASE                 (PERIPH_BASE + 0x12000000UL)

#define APB4PERIPH_BASE                 (PERIPH_BASE + 0x18000000UL)

#define XSPI1_R_BASE                    (AHB5PERIPH_BASE + 0x5000UL)

#define XSPI2_R_BASE                    (AHB5PERIPH_BASE + 0xA000UL)

#define EXTI_BASE                       APB4PERIPH_BASE

#define EXTI                   ((EXTI_TypeDef *) EXTI_BASE)

#define XSPI1                  ((XSPI_TypeDef *) XSPI1_R_BASE)

#define XSPI2                  ((XSPI_TypeDef *) XSPI2_R_BASE)

#define AXIM_ASIB_FNMOD2_BYPASS_MERGE_Pos   (0U)

#define AXIM_ASIB_FNMOD2_BYPASS_MERGE_Msk   (0x1UL << AXIM_ASIB_FNMOD2_BYPASS_MERGE_Pos)    /*!< 0x00000001 */

#define AXIM_ASIB_FNMOD2_BYPASS_MERGE       AXIM_ASIB_FNMOD2_BYPASS_MERGE_Msk               /*!< Bypass Merge enable */

#define AXIM_ASIB_READQOS_AR_QOS_Pos       (0U)

#define AXIM_ASIB_READQOS_AR_QOS_Msk       (0xFUL << AXIM_ASIB_READQOS_AR_QOS_Pos)          /*!< 0x0000000F */

#define AXIM_ASIB_READQOS_AR_QOS           AXIM_ASIB_READQOS_AR_QOS_Msk                     /*!< Read channel QoS setting */

#define AXIM_ASIB_FNMOD_READ_ISS_Pos        (0U)

#define AXIM_ASIB_FNMOD_READ_ISS_Msk        (0x1UL << AXIM_ASIB_FNMOD_READ_ISS_Pos)         /*!< 0x00000001 */

#define AXIM_ASIB_FNMOD_READ_ISS            AXIM_ASIB_FNMOD_READ_ISS_Msk                    /*!< Force read issuing capability to 1 */

#define AXIM_ASIB_FNMOD_WRITE_ISS_Pos       (1U)

#define AXIM_ASIB_FNMOD_WRITE_ISS_Msk       (0x1UL << AXIM_ASIB_FNMOD_WRITE_ISS_Pos)        /*!< 0x00000002 */

#define AXIM_ASIB_FNMOD_WRITE_ISS           AXIM_ASIB_FNMOD_WRITE_ISS_Msk                   /*!< Force write issuing capability to 1 */

#define AXIM_AMIB_FNMOD2_BYPASS_MERGE_Pos   (0U)

#define AXIM_AMIB_FNMOD2_BYPASS_MERGE_Msk   (0x1UL << AXIM_AMIB_FNMOD2_BYPASS_MERGE_Pos)    /*!< 0x00000001 */

#define AXIM_AMIB_FNMOD2_BYPASS_MERGE       AXIM_AMIB_FNMOD2_BYPASS_MERGE_Msk               /*!< Bypass Merge enable */

#define AXIM_AMIB_FNMODLB_LONG_BURST_Pos    (0U)

#define AXIM_AMIB_FNMODLB_LONG_BURST_Msk    (0x1UL << AXIM_AMIB_FNMODLB_LONG_BURST_Pos)     /*!< 0x00000001 */

#define AXIM_AMIB_FNMODLB_LONG_BURST        AXIM_AMIB_FNMODLB_LONG_BURST_Msk                /*!< Long bursts can be generated */

#define AXIM_AMIB_FNMOD_READ_ISS_Pos        (0U)

#define AXIM_AMIB_FNMOD_READ_ISS_Msk        (0x1UL << AXIM_AMIB_FNMOD_READ_ISS_Pos)         /*!< 0x00000001 */

#define AXIM_AMIB_FNMOD_READ_ISS            AXIM_AMIB_FNMOD_READ_ISS_Msk                    /*!< Force read issuing capability to 1 */

#define AXIM_AMIB_FNMOD_WRITE_ISS_Pos       (1U)

#define AXIM_AMIB_FNMOD_WRITE_ISS_Msk       (0x1UL << AXIM_AMIB_FNMOD_WRITE_ISS_Pos)        /*!< 0x00000002 */

#define AXIM_AMIB_FNMOD_WRITE_ISS           AXIM_AMIB_FNMOD_WRITE_ISS_Msk                   /*!< Force write issuing capability to 1 */

#define VREFBUF_CSR_ENVR_Pos        (0U)

#define VREFBUF_CSR_ENVR_Msk        (0x1UL << VREFBUF_CSR_ENVR_Pos)            /*!< 0x00000001 */

#define VREFBUF_CSR_ENVR            VREFBUF_CSR_ENVR_Msk                       /*!<Voltage reference buffer enable */

#define VREFBUF_CSR_HIZ_Pos         (1U)

#define VREFBUF_CSR_HIZ_Msk         (0x1UL << VREFBUF_CSR_HIZ_Pos)             /*!< 0x00000002 */

#define VREFBUF_CSR_HIZ             VREFBUF_CSR_HIZ_Msk                        /*!<High impedance mode             */

#define VREFBUF_CSR_VRR_Pos         (3U)

#define VREFBUF_CSR_VRR_Msk         (0x1UL << VREFBUF_CSR_VRR_Pos)             /*!< 0x00000008 */

#define VREFBUF_CSR_VRR             VREFBUF_CSR_VRR_Msk                        /*!<Voltage reference buffer ready  */

#define VREFBUF_CSR_VRS_Pos         (4U)

#define VREFBUF_CSR_VRS_Msk         (0x7UL << VREFBUF_CSR_VRS_Pos)             /*!< 0x00000070 */

#define VREFBUF_CSR_VRS             VREFBUF_CSR_VRS_Msk                        /*!<Voltage reference scale         */

#define VREFBUF_CSR_VRS_OUT1        ((uint32_t)0x00000000)                     /*!<Voltage reference VREF_OUT1     */

#define VREFBUF_CSR_VRS_OUT2_Pos    (4U)

#define VREFBUF_CSR_VRS_OUT2_Msk    (0x1UL << VREFBUF_CSR_VRS_OUT2_Pos)        /*!< 0x00000010 */

#define VREFBUF_CSR_VRS_OUT2        VREFBUF_CSR_VRS_OUT2_Msk                   /*!<Voltage reference VREF_OUT2     */

#define VREFBUF_CSR_VRS_OUT3_Pos    (5U)

#define VREFBUF_CSR_VRS_OUT3_Msk    (0x1UL << VREFBUF_CSR_VRS_OUT3_Pos)        /*!< 0x00000020 */

#define VREFBUF_CSR_VRS_OUT3        VREFBUF_CSR_VRS_OUT3_Msk                   /*!<Voltage reference VREF_OUT3     */

#define VREFBUF_CSR_VRS_OUT4_Pos    (4U)

#define VREFBUF_CSR_VRS_OUT4_Msk    (0x3UL << VREFBUF_CSR_VRS_OUT4_Pos)        /*!< 0x00000030 */

#define VREFBUF_CSR_VRS_OUT4        VREFBUF_CSR_VRS_OUT4_Msk                   /*!<Voltage reference VREF_OUT4     */

#define VREFBUF_CCR_TRIM_Pos        (0U)

#define VREFBUF_CCR_TRIM_Msk        (0x3FUL << VREFBUF_CCR_TRIM_Pos)           /*!< 0x0000003F */

#define VREFBUF_CCR_TRIM            VREFBUF_CCR_TRIM_Msk                       /*!<TRIM[5:0] bits (Trimming code)  */

#define FMC_BCR1_BMAP_Pos          (24U)

#define FMC_BCR1_BMAP_Msk          (0x3UL << FMC_BCR1_BMAP_Pos)                /*!< 0x03000000 */

#define FMC_BCR1_BMAP              FMC_BCR1_BMAP_Msk                           /*!< FMC bank mapping */

#define FMC_BCR1_BMAP_0            (0x1UL << FMC_BCR1_BMAP_Pos)                /*!< 0x01000000 */

#define SBS_HDPLCR_INCR_HDPL_Pos         (0U)

#define SBS_HDPLCR_INCR_HDPL_Msk         (0xFFUL << SBS_HDPLCR_INCR_HDPL_Pos)        /*!< 0x000000FF */

#define SBS_HDPLCR_INCR_HDPL             SBS_HDPLCR_INCR_HDPL_Msk                    /*!< Increment HDPL */

#define SBS_HDPLSR_HDPL_Pos              (0U)

#define SBS_HDPLSR_HDPL_Msk              (0xFFUL << SBS_HDPLSR_HDPL_Pos)             /*!< 0x000000FF */

#define SBS_HDPLSR_HDPL                  SBS_HDPLSR_HDPL_Msk                         /*!< Hide protection level */

#define SBS_DBGCR_AP_UNLOCK_Pos          (0U)

#define SBS_DBGCR_AP_UNLOCK_Msk          (0xFFUL << SBS_DBGCR_AP_UNLOCK_Pos)         /*!< 0x000000FF */

#define SBS_DBGCR_AP_UNLOCK              SBS_DBGCR_AP_UNLOCK_Msk                     /*!< Access port unlock */

#define SBS_DBGCR_DBG_UNLOCK_Pos         (8U)

#define SBS_DBGCR_DBG_UNLOCK_Msk         (0xFFUL << SBS_DBGCR_DBG_UNLOCK_Pos)        /*!< 0x0000FF00 */

#define SBS_DBGCR_DBG_UNLOCK             SBS_DBGCR_DBG_UNLOCK_Msk                    /*!< Debug unlock */

#define SBS_DBGCR_DBG_AUTH_HDPL_Pos      (16U)

#define SBS_DBGCR_DBG_AUTH_HDPL_Msk      (0xFFUL << SBS_DBGCR_DBG_AUTH_HDPL_Pos)     /*!< 0x00FF0000 */

#define SBS_DBGCR_DBG_AUTH_HDPL          SBS_DBGCR_DBG_AUTH_HDPL_Msk                 /*!< Authenticated debug hide protection level */

#define SBS_DBGLOCKR_DBGCFG_LOCK_Pos     (0U)

#define SBS_DBGLOCKR_DBGCFG_LOCK_Msk     (0xFFUL << SBS_DBGLOCKR_DBGCFG_LOCK_Pos)    /*!< 0x000000FF */

#define SBS_DBGLOCKR_DBGCFG_LOCK         SBS_DBGLOCKR_DBGCFG_LOCK_Msk                /*!< Debug configuration lock */

#define SBS_RSSCMDR_RSSCMD_Pos           (0U)

#define SBS_RSSCMDR_RSSCMD_Msk           (0xFFFFUL << SBS_RSSCMDR_RSSCMD_Pos)        /*!< 0x0000FFFF */

#define SBS_RSSCMDR_RSSCMD               SBS_RSSCMDR_RSSCMD_Msk                      /*!< RSS command */

#define SBS_PMCR_BOOSTEN_Pos             (8U)

#define SBS_PMCR_BOOSTEN_Msk             (0x1UL << SBS_PMCR_BOOSTEN_Pos)             /*!< 0x00000100 */

#define SBS_PMCR_BOOSTEN                 SBS_PMCR_BOOSTEN_Msk                        /*!< Booster enable */

#define SBS_PMCR_BOOSTVDDSEL_Pos         (9U)

#define SBS_PMCR_BOOSTVDDSEL_Msk         (0x1UL << SBS_PMCR_BOOSTVDDSEL_Pos)         /*!< 0x00000200 */

#define SBS_PMCR_BOOSTVDDSEL             SBS_PMCR_BOOSTVDDSEL_Msk                    /*!< Booster Vdd selection */

#define SBS_PMCR_ETH_PHYSEL_Pos          (21U)

#define SBS_PMCR_ETH_PHYSEL_Msk          (0x7UL << SBS_PMCR_ETH_PHYSEL_Pos)          /*!< 0x00E00000 */

#define SBS_PMCR_ETH_PHYSEL              SBS_PMCR_ETH_PHYSEL_Msk                     /*!< Ethernet PHY interface selection */

#define SBS_PMCR_ETH_PHYSEL_2            (0x4UL << SBS_PMCR_ETH_PHYSEL_Pos)          /*!< 0x00800000 */

#define SBS_PMCR_AXISRAM_WS_Pos          (28U)

#define SBS_PMCR_AXISRAM_WS_Msk          (0x1UL << SBS_PMCR_AXISRAM_WS_Pos)          /*!< 0x10000000 */

#define SBS_PMCR_AXISRAM_WS              SBS_PMCR_AXISRAM_WS_Msk                     /*!< AXISRAM wait state */

#define SBS_FPUIMR_FPU_IE_0_Pos          (0U)

#define SBS_FPUIMR_FPU_IE_0_Msk          (0x1UL << SBS_FPUIMR_FPU_IE_0_Pos)          /*!< 0x00000001 */

#define SBS_FPUIMR_FPU_IE_0              SBS_FPUIMR_FPU_IE_0_Msk                     /*!< Invalid operation Interrupt enable */

#define SBS_FPUIMR_FPU_IE_1_Pos          (1U)

#define SBS_FPUIMR_FPU_IE_1_Msk          (0x1UL << SBS_FPUIMR_FPU_IE_1_Pos)          /*!< 0x00000002 */

#define SBS_FPUIMR_FPU_IE_1              SBS_FPUIMR_FPU_IE_1_Msk                     /*!< Divide-by-zero Interrupt enable */

#define SBS_FPUIMR_FPU_IE_2_Pos          (2U)

#define SBS_FPUIMR_FPU_IE_2_Msk          (0x1UL << SBS_FPUIMR_FPU_IE_2_Pos)          /*!< 0x00000004 */

#define SBS_FPUIMR_FPU_IE_2              SBS_FPUIMR_FPU_IE_2_Msk                     /*!< Underflow Interrupt enable */

#define SBS_FPUIMR_FPU_IE_3_Pos          (3U)

#define SBS_FPUIMR_FPU_IE_3_Msk          (0x1UL << SBS_FPUIMR_FPU_IE_3_Pos)          /*!< 0x00000008 */

#define SBS_FPUIMR_FPU_IE_3              SBS_FPUIMR_FPU_IE_3_Msk                     /*!< Overflow Interrupt enable */

#define SBS_FPUIMR_FPU_IE_4_Pos          (4U)

#define SBS_FPUIMR_FPU_IE_4_Msk          (0x1UL << SBS_FPUIMR_FPU_IE_4_Pos)          /*!< 0x00000010 */

#define SBS_FPUIMR_FPU_IE_4              SBS_FPUIMR_FPU_IE_4_Msk                     /*!< Input denormal Interrupt enable */

#define SBS_FPUIMR_FPU_IE_5_Pos          (5U)

#define SBS_FPUIMR_FPU_IE_5_Msk          (0x1UL << SBS_FPUIMR_FPU_IE_5_Pos)          /*!< 0x00000020 */

#define SBS_FPUIMR_FPU_IE_5              SBS_FPUIMR_FPU_IE_5_Msk                     /*!< Inexact Interrupt enable */

#define SBS_MESR_MEF_Pos                 (0U)

#define SBS_MESR_MEF_Msk                 (0x1UL << SBS_MESR_MEF_Pos)                 /*!< 0x00000001 */

#define SBS_MESR_MEF                     SBS_MESR_MEF_Msk                            /*!< Memory erase flag */

#define SBS_CCCSR_COMP_EN_Pos            (0U)

#define SBS_CCCSR_COMP_EN_Msk            (0x1UL << SBS_CCCSR_COMP_EN_Pos)            /*!< 0x00000001 */

#define SBS_CCCSR_COMP_EN                SBS_CCCSR_COMP_EN_Msk                       /*!< Compensation cell enable */

#define SBS_CCCSR_XSPI1_COMP_EN_Pos      (2U)

#define SBS_CCCSR_XSPI1_COMP_EN_Msk      (0x1UL << SBS_CCCSR_XSPI1_COMP_EN_Pos)      /*!< 0x00000004 */

#define SBS_CCCSR_XSPI1_COMP_EN          SBS_CCCSR_XSPI1_COMP_EN_Msk                 /*!< XSPIM_P1 compensation cell enable */

#define SBS_CCCSR_XSPI2_COMP_EN_Pos      (4U)

#define SBS_CCCSR_XSPI2_COMP_EN_Msk      (0x1UL << SBS_CCCSR_XSPI2_COMP_EN_Pos)      /*!< 0x00000010 */

#define SBS_CCCSR_XSPI2_COMP_EN          SBS_CCCSR_XSPI2_COMP_EN_Msk                 /*!< XSPIM_P2 compensation cell enable */

#define SBS_CCCSR_COMP_RDY_Pos           (8U)

#define SBS_CCCSR_COMP_RDY_Msk           (0x1UL << SBS_CCCSR_COMP_RDY_Pos)           /*!< 0x00000100 */

#define SBS_CCCSR_COMP_RDY               SBS_CCCSR_COMP_RDY_Msk                      /*!< Compensation cell ready */

#define SBS_CCCSR_XSPI1_COMP_RDY_Pos     (9U)

#define SBS_CCCSR_XSPI1_COMP_RDY_Msk     (0x1UL << SBS_CCCSR_XSPI1_COMP_RDY_Pos)     /*!< 0x00000200 */

#define SBS_CCCSR_XSPI1_COMP_RDY         SBS_CCCSR_XSPI1_COMP_RDY_Msk                /*!< XSPIM_P1 compensation cell ready */

#define SBS_CCCSR_XSPI2_COMP_RDY_Pos     (10U)

#define SBS_CCCSR_XSPI2_COMP_RDY_Msk     (0x1UL << SBS_CCCSR_XSPI2_COMP_RDY_Pos)     /*!< 0x00000400 */

#define SBS_CCCSR_XSPI2_COMP_RDY         SBS_CCCSR_XSPI2_COMP_RDY_Msk                /*!< XSPIM_P2 compensation cell ready */

#define SBS_CCCSR_IOHSLV_Pos             (16U)

#define SBS_CCCSR_IOHSLV_Msk             (0x1UL << SBS_CCCSR_IOHSLV_Pos)             /*!< 0x00010000 */

#define SBS_CCCSR_IOHSLV                 SBS_CCCSR_IOHSLV_Msk                        /*!< I/O high speed at low voltage */

#define SBS_CCCSR_XSPI1_IOHSLV_Pos       (17U)

#define SBS_CCCSR_XSPI1_IOHSLV_Msk       (0x1UL << SBS_CCCSR_XSPI1_IOHSLV_Pos)       /*!< 0x00020000 */

#define SBS_CCCSR_XSPI1_IOHSLV           SBS_CCCSR_XSPI1_IOHSLV_Msk                  /*!< XSPIM_P1 I/O high speed at low voltage */

#define SBS_CCCSR_XSPI2_IOHSLV_Pos       (18U)

#define SBS_CCCSR_XSPI2_IOHSLV_Msk       (0x1UL << SBS_CCCSR_XSPI2_IOHSLV_Pos)       /*!< 0x00040000 */

#define SBS_CCCSR_XSPI2_IOHSLV           SBS_CCCSR_XSPI2_IOHSLV_Msk                  /*!< XSPIM_P2 I/O high speed at low voltage */

#define SBS_BKLOCKR_PVD_BL_Pos           (2U)

#define SBS_BKLOCKR_PVD_BL_Msk           (0x1UL << SBS_BKLOCKR_PVD_BL_Pos)           /*!< 0x00000004 */

#define SBS_BKLOCKR_PVD_BL               SBS_BKLOCKR_PVD_BL_Msk                      /*!< PVD break lock */

#define SBS_BKLOCKR_FLASHECC_BL_Pos      (3U)

#define SBS_BKLOCKR_FLASHECC_BL_Msk      (0x1UL << SBS_BKLOCKR_FLASHECC_BL_Pos)      /*!< 0x00000008 */

#define SBS_BKLOCKR_FLASHECC_BL          SBS_BKLOCKR_FLASHECC_BL_Msk                 /*!< Flash ECC error break lock */

#define SBS_BKLOCKR_CM7LCKUP_BL_Pos      (6U)

#define SBS_BKLOCKR_CM7LCKUP_BL_Msk      (0x1UL << SBS_BKLOCKR_CM7LCKUP_BL_Pos)      /*!< 0x00000040 */

#define SBS_BKLOCKR_CM7LCKUP_BL          SBS_BKLOCKR_CM7LCKUP_BL_Msk                 /*!< Cortex-M7 lockup break lock */

#define SBS_BKLOCKR_BKRAMECC_BL_Pos      (7U)

#define SBS_BKLOCKR_BKRAMECC_BL_Msk      (0x1UL << SBS_BKLOCKR_BKRAMECC_BL_Pos)      /*!< 0x00000080 */

#define SBS_BKLOCKR_BKRAMECC_BL          SBS_BKLOCKR_BKRAMECC_BL_Msk                 /*!< Backup RAM ECC error break lock */

#define SBS_BKLOCKR_DTCMECC_BL_Pos       (13U)

#define SBS_BKLOCKR_DTCMECC_BL_Msk       (0x1UL << SBS_BKLOCKR_DTCMECC_BL_Pos)       /*!< 0x00002000 */

#define SBS_BKLOCKR_DTCMECC_BL           SBS_BKLOCKR_DTCMECC_BL_Msk                  /*!< DTCM ECC error break lock */

#define SBS_BKLOCKR_ITCMECC_BL_Pos       (14U)

#define SBS_BKLOCKR_ITCMECC_BL_Msk       (0x1UL << SBS_BKLOCKR_ITCMECC_BL_Pos)       /*!< 0x00004000 */

#define SBS_BKLOCKR_ITCMECC_BL           SBS_BKLOCKR_ITCMECC_BL_Msk                  /*!< ITCM ECC error break lock */

#define SBS_BKLOCKR_ARAM3ECC_BL_Pos      (21U)

#define SBS_BKLOCKR_ARAM3ECC_BL_Msk      (0x1UL << SBS_BKLOCKR_ARAM3ECC_BL_Pos)      /*!< 0x00200000 */

#define SBS_BKLOCKR_ARAM3ECC_BL          SBS_BKLOCKR_ARAM3ECC_BL_Msk                 /*!< AXIRAM3 ECC error break lock */

#define SBS_BKLOCKR_ARAM1ECC_BL_Pos      (23U)

#define SBS_BKLOCKR_ARAM1ECC_BL_Msk      (0x1UL << SBS_BKLOCKR_ARAM1ECC_BL_Pos)      /*!< 0x00800000 */

#define SBS_BKLOCKR_ARAM1ECC_BL          SBS_BKLOCKR_ARAM1ECC_BL_Msk                 /*!< AXIRAM1 ECC error break lock */

#define IS_AXIM_ASIB_ALL_INSTANCE(INSTANCE)      (((INSTANCE) == AXIM_ASIB_1)  || \
                                                  ((INSTANCE) == AXIM_ASIB_2)  || \
                                                  ((INSTANCE) == AXIM_ASIB_3)  || \
                                                  ((INSTANCE) == AXIM_ASIB_4)  || \
                                                  ((INSTANCE) == AXIM_ASIB_5)  || \
                                                  ((INSTANCE) == AXIM_ASIB_6)  || \
                                                  ((INSTANCE) == AXIM_ASIB_7)  || \
                                                  ((INSTANCE) == AXIM_ASIB_8)  || \
                                                  ((INSTANCE) == AXIM_ASIB_9)  || \
                                                  ((INSTANCE) == AXIM_ASIB_10) || \
                                                  ((INSTANCE) == AXIM_ASIB_11))

#define IS_AXIM_AMIB_ALL_INSTANCE(INSTANCE)      (((INSTANCE) == AXIM_AMIB_1)  || \
                                                  ((INSTANCE) == AXIM_AMIB_2)  || \
                                                  ((INSTANCE) == AXIM_AMIB_3)  || \
                                                  ((INSTANCE) == AXIM_AMIB_4)  || \
                                                  ((INSTANCE) == AXIM_AMIB_5)  || \
                                                  ((INSTANCE) == AXIM_AMIB_6)  || \
                                                  ((INSTANCE) == AXIM_AMIB_7)  || \
                                                  ((INSTANCE) == AXIM_AMIB_8)  || \
                                                  ((INSTANCE) == AXIM_AMIB_9)  || \
                                                  ((INSTANCE) == AXIM_AMIB_10))

#define SET_BIT(REG, BIT)     ((REG) |= (BIT))

#define CLEAR_BIT(REG, BIT)   ((REG) &= ~(BIT))

#define READ_BIT(REG, BIT)    ((REG) & (BIT))

#define WRITE_REG(REG, VAL)   ((REG) = (VAL))

#define READ_REG(REG)         ((REG))

#define MODIFY_REG(REG, CLEARMASK, SETMASK)  WRITE_REG((REG), (((READ_REG(REG)) & (~(CLEARMASK))) | (SETMASK)))

#define POSITION_VAL(VAL)     (__CLZ(__RBIT(VAL)))
