// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// CMSIS device definitions from 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
typedef struct
{
  __IO uint32_t CR;          /*!< Control register,                   Address offset: 0x00 */
  __IO uint32_t IMR;         /*!< Interrupt mask register,            Address offset: 0x04 */
  __IO uint32_t SR;          /*!< Status register,                    Address offset: 0x08 */
  __IO uint32_t IFCR;        /*!< Interrupt Flag Clear register,      Address offset: 0x0C */
  __IO uint32_t DR;          /*!< Data input register,                Address offset: 0x10 */
  __IO uint32_t CSR;         /*!< Channel Status register,            Address offset: 0x14 */
  __IO uint32_t DIR;         /*!< Debug Information register,         Address offset: 0x18 */
} SPDIFRX_TypeDef;
#define SPDIFRX_BASE                    (APB1PERIPH_BASE + 0x4000UL)
#define SPDIFRX_CR_SPDIFRXEN_Pos    (0U)
#define SPDIFRX_CR_SPDIFRXEN_Msk    (0x3UL << SPDIFRX_CR_SPDIFRXEN_Pos)        /*!< 0x00000003 */
#define SPDIFRX_CR_SPDIFRXEN        SPDIFRX_CR_SPDIFRXEN_Msk                   /*!<Peripheral Block Enable                      */
#define SPDIFRX_CR_SPDIFRXEN_0      (0x1UL << SPDIFRX_CR_SPDIFRXEN_Pos)        /*!< 0x00000001 */
#define SPDIFRX_CR_SPDIFRXEN_1      (0x2UL << SPDIFRX_CR_SPDIFRXEN_Pos)        /*!< 0x00000002 */
#define SPDIFRX_CR_RXDMAEN_Pos      (2U)
#define SPDIFRX_CR_RXDMAEN_Msk      (0x1UL << SPDIFRX_CR_RXDMAEN_Pos)          /*!< 0x00000004 */
#define SPDIFRX_CR_RXDMAEN          SPDIFRX_CR_RXDMAEN_Msk                     /*!<Receiver DMA Enable for data flow            */
#define SPDIFRX_CR_RXSTEO_Pos       (3U)
#define SPDIFRX_CR_RXSTEO_Msk       (0x1UL << SPDIFRX_CR_RXSTEO_Pos)           /*!< 0x00000008 */
#define SPDIFRX_CR_RXSTEO           SPDIFRX_CR_RXSTEO_Msk                      /*!<Stereo Mode                                  */
#define SPDIFRX_CR_DRFMT_Pos        (4U)
#define SPDIFRX_CR_DRFMT_Msk        (0x3UL << SPDIFRX_CR_DRFMT_Pos)            /*!< 0x00000030 */
#define SPDIFRX_CR_DRFMT            SPDIFRX_CR_DRFMT_Msk                       /*!<RX Data format                               */
#define SPDIFRX_CR_DRFMT_0          (0x1UL << SPDIFRX_CR_DRFMT_Pos)            /*!< 0x00000010 */
#define SPDIFRX_CR_DRFMT_1          (0x2UL << SPDIFRX_CR_DRFMT_Pos)            /*!< 0x00000020 */
#define SPDIFRX_CR_PMSK_Pos         (6U)
#define SPDIFRX_CR_PMSK_Msk         (0x1UL << SPDIFRX_CR_PMSK_Pos)             /*!< 0x00000040 */
#define SPDIFRX_CR_PMSK             SPDIFRX_CR_PMSK_Msk                        /*!<Mask Parity error bit                        */
#define SPDIFRX_CR_VMSK_Pos         (7U)
#define SPDIFRX_CR_VMSK_Msk         (0x1UL << SPDIFRX_CR_VMSK_Pos)             /*!< 0x00000080 */
#define SPDIFRX_CR_VMSK             SPDIFRX_CR_VMSK_Msk                        /*!<Mask of Validity bit                         */
#define SPDIFRX_CR_CUMSK_Pos        (8U)
#define SPDIFRX_CR_CUMSK_Msk        (0x1UL << SPDIFRX_CR_CUMSK_Pos)            /*!< 0x00000100 */
#define SPDIFRX_CR_CUMSK            SPDIFRX_CR_CUMSK_Msk                       /*!<Mask of channel status and user bits         */
#define SPDIFRX_CR_PTMSK_Pos        (9U)
#define SPDIFRX_CR_PTMSK_Msk        (0x1UL << SPDIFRX_CR_PTMSK_Pos)            /*!< 0x00000200 */
#define SPDIFRX_CR_PTMSK            SPDIFRX_CR_PTMSK_Msk                       /*!<Mask of Preamble Type bits                   */
#define SPDIFRX_CR_CBDMAEN_Pos      (10U)
#define SPDIFRX_CR_CBDMAEN_Msk      (0x1UL << SPDIFRX_CR_CBDMAEN_Pos)          /*!< 0x00000400 */
#define SPDIFRX_CR_CBDMAEN          SPDIFRX_CR_CBDMAEN_Msk                     /*!<Control Buffer DMA ENable for control flow   */
#define SPDIFRX_CR_CHSEL_Pos        (11U)
#define SPDIFRX_CR_CHSEL_Msk        (0x1UL << SPDIFRX_CR_CHSEL_Pos)            /*!< 0x00000800 */
#define SPDIFRX_CR_CHSEL            SPDIFRX_CR_CHSEL_Msk                       /*!<Channel Selection                            */
#define SPDIFRX_CR_NBTR_Pos         (12U)
#define SPDIFRX_CR_NBTR_Msk         (0x3UL << SPDIFRX_CR_NBTR_Pos)             /*!< 0x00003000 */
#define SPDIFRX_CR_NBTR             SPDIFRX_CR_NBTR_Msk                        /*!<Maximum allowed re-tries during synchronization phase */
#define SPDIFRX_CR_NBTR_0           (0x1UL << SPDIFRX_CR_NBTR_Pos)             /*!< 0x00001000 */
#define SPDIFRX_CR_NBTR_1           (0x2UL << SPDIFRX_CR_NBTR_Pos)             /*!< 0x00002000 */
#define SPDIFRX_CR_WFA_Pos          (14U)
#define SPDIFRX_CR_WFA_Msk          (0x1UL << SPDIFRX_CR_WFA_Pos)              /*!< 0x00004000 */
#define SPDIFRX_CR_WFA              SPDIFRX_CR_WFA_Msk                         /*!<Wait For Activity     */
#define SPDIFRX_CR_INSEL_Pos        (16U)
#define SPDIFRX_CR_INSEL_Msk        (0x7UL << SPDIFRX_CR_INSEL_Pos)            /*!< 0x00070000 */
#define SPDIFRX_CR_INSEL            SPDIFRX_CR_INSEL_Msk                       /*!<SPDIF input selection */
#define SPDIFRX_CR_INSEL_0          (0x1UL << SPDIFRX_CR_INSEL_Pos)            /*!< 0x00010000 */
#define SPDIFRX_CR_INSEL_1          (0x2UL << SPDIFRX_CR_INSEL_Pos)            /*!< 0x00020000 */
#define SPDIFRX_CR_INSEL_2          (0x4UL << SPDIFRX_CR_INSEL_Pos)            /*!< 0x00040000 */
#define SPDIFRX_CR_CKSEN_Pos        (20U)
#define SPDIFRX_CR_CKSEN_Msk        (0x1UL << SPDIFRX_CR_CKSEN_Pos)            /*!< 0x00100000 */
#define SPDIFRX_CR_CKSEN            SPDIFRX_CR_CKSEN_Msk                       /*!<Symbol Clock Enable */
#define SPDIFRX_CR_CKSBKPEN_Pos     (21U)
#define SPDIFRX_CR_CKSBKPEN_Msk     (0x1UL << SPDIFRX_CR_CKSBKPEN_Pos)         /*!< 0x00200000 */
#define SPDIFRX_CR_CKSBKPEN         SPDIFRX_CR_CKSBKPEN_Msk                    /*!<Backup Symbol Clock Enable */
#define SPDIFRX_IMR_RXNEIE_Pos      (0U)
#define SPDIFRX_IMR_RXNEIE_Msk      (0x1UL << SPDIFRX_IMR_RXNEIE_Pos)          /*!< 0x00000001 */
#define SPDIFRX_IMR_RXNEIE          SPDIFRX_IMR_RXNEIE_Msk                     /*!<RXNE interrupt enable                              */
#define SPDIFRX_IMR_CSRNEIE_Pos     (1U)
#define SPDIFRX_IMR_CSRNEIE_Msk     (0x1UL << SPDIFRX_IMR_CSRNEIE_Pos)         /*!< 0x00000002 */
#define SPDIFRX_IMR_CSRNEIE         SPDIFRX_IMR_CSRNEIE_Msk                    /*!<Control Buffer Ready Interrupt Enable              */
#define SPDIFRX_IMR_PERRIE_Pos      (2U)
#define SPDIFRX_IMR_PERRIE_Msk      (0x1UL << SPDIFRX_IMR_PERRIE_Pos)          /*!< 0x00000004 */
#define SPDIFRX_IMR_PERRIE          SPDIFRX_IMR_PERRIE_Msk                     /*!<Parity error interrupt enable                      */
#define SPDIFRX_IMR_OVRIE_Pos       (3U)
#define SPDIFRX_IMR_OVRIE_Msk       (0x1UL << SPDIFRX_IMR_OVRIE_Pos)           /*!< 0x00000008 */
#define SPDIFRX_IMR_OVRIE           SPDIFRX_IMR_OVRIE_Msk                      /*!<Overrun error Interrupt Enable                     */
#define SPDIFRX_IMR_SBLKIE_Pos      (4U)
#define SPDIFRX_IMR_SBLKIE_Msk      (0x1UL << SPDIFRX_IMR_SBLKIE_Pos)          /*!< 0x00000010 */
#define SPDIFRX_IMR_SBLKIE          SPDIFRX_IMR_SBLKIE_Msk                     /*!<Synchronization Block Detected Interrupt Enable    */
#define SPDIFRX_IMR_SYNCDIE_Pos     (5U)
#define SPDIFRX_IMR_SYNCDIE_Msk     (0x1UL << SPDIFRX_IMR_SYNCDIE_Pos)         /*!< 0x00000020 */
#define SPDIFRX_IMR_SYNCDIE         SPDIFRX_IMR_SYNCDIE_Msk                    /*!<Synchronization Done                               */
#define SPDIFRX_IMR_IFEIE_Pos       (6U)
#define SPDIFRX_IMR_IFEIE_Msk       (0x1UL << SPDIFRX_IMR_IFEIE_Pos)           /*!< 0x00000040 */
#define SPDIFRX_IMR_IFEIE           SPDIFRX_IMR_IFEIE_Msk                      /*!<Serial Interface Error Interrupt Enable            */
#define SPDIFRX_SR_RXNE_Pos         (0U)
#define SPDIFRX_SR_RXNE_Msk         (0x1UL << SPDIFRX_SR_RXNE_Pos)             /*!< 0x00000001 */
#define SPDIFRX_SR_RXNE             SPDIFRX_SR_RXNE_Msk                        /*!<Read data register not empty                          */
#define SPDIFRX_SR_CSRNE_Pos        (1U)
#define SPDIFRX_SR_CSRNE_Msk        (0x1UL << SPDIFRX_SR_CSRNE_Pos)            /*!< 0x00000002 */
#define SPDIFRX_SR_CSRNE            SPDIFRX_SR_CSRNE_Msk                       /*!<The Control Buffer register is not empty              */
#define SPDIFRX_SR_PERR_Pos         (2U)
#define SPDIFRX_SR_PERR_Msk         (0x1UL << SPDIFRX_SR_PERR_Pos)             /*!< 0x00000004 */
#define SPDIFRX_SR_PERR             SPDIFRX_SR_PERR_Msk                        /*!<Parity error                                          */
#define SPDIFRX_SR_OVR_Pos          (3U)
#define SPDIFRX_SR_OVR_Msk          (0x1UL << SPDIFRX_SR_OVR_Pos)              /*!< 0x00000008 */
#define SPDIFRX_SR_OVR              SPDIFRX_SR_OVR_Msk                         /*!<Overrun error                                         */
#define SPDIFRX_SR_SBD_Pos          (4U)
#define SPDIFRX_SR_SBD_Msk          (0x1UL << SPDIFRX_SR_SBD_Pos)              /*!< 0x00000010 */
#define SPDIFRX_SR_SBD              SPDIFRX_SR_SBD_Msk                         /*!<Synchronization Block Detected                        */
#define SPDIFRX_SR_SYNCD_Pos        (5U)
#define SPDIFRX_SR_SYNCD_Msk        (0x1UL << SPDIFRX_SR_SYNCD_Pos)            /*!< 0x00000020 */
#define SPDIFRX_SR_SYNCD            SPDIFRX_SR_SYNCD_Msk                       /*!<Synchronization Done                                  */
#define SPDIFRX_SR_FERR_Pos         (6U)
#define SPDIFRX_SR_FERR_Msk         (0x1UL << SPDIFRX_SR_FERR_Pos)             /*!< 0x00000040 */
#define SPDIFRX_SR_FERR             SPDIFRX_SR_FERR_Msk                        /*!<Framing error                                         */
#define SPDIFRX_SR_SERR_Pos         (7U)
#define SPDIFRX_SR_SERR_Msk         (0x1UL << SPDIFRX_SR_SERR_Pos)             /*!< 0x00000080 */
#define SPDIFRX_SR_SERR             SPDIFRX_SR_SERR_Msk                        /*!<Synchronization error                                 */
#define SPDIFRX_SR_TERR_Pos         (8U)
#define SPDIFRX_SR_TERR_Msk         (0x1UL << SPDIFRX_SR_TERR_Pos)             /*!< 0x00000100 */
#define SPDIFRX_SR_TERR             SPDIFRX_SR_TERR_Msk                        /*!<Time-out error                                        */
#define SPDIFRX_SR_WIDTH5_Pos       (16U)
#define SPDIFRX_SR_WIDTH5_Msk       (0x7FFFUL << SPDIFRX_SR_WIDTH5_Pos)        /*!< 0x7FFF0000 */
#define SPDIFRX_SR_WIDTH5           SPDIFRX_SR_WIDTH5_Msk                      /*!<Duration of 5 symbols counted with spdif_clk          */
#define SPDIFRX_IFCR_PERRCF_Pos     (2U)
#define SPDIFRX_IFCR_PERRCF_Msk     (0x1UL << SPDIFRX_IFCR_PERRCF_Pos)         /*!< 0x00000004 */
#define SPDIFRX_IFCR_PERRCF         SPDIFRX_IFCR_PERRCF_Msk                    /*!<Clears the Parity error flag                         */
#define SPDIFRX_IFCR_OVRCF_Pos      (3U)
#define SPDIFRX_IFCR_OVRCF_Msk      (0x1UL << SPDIFRX_IFCR_OVRCF_Pos)          /*!< 0x00000008 */
#define SPDIFRX_IFCR_OVRCF          SPDIFRX_IFCR_OVRCF_Msk                     /*!<Clears the Overrun error flag                        */
#define SPDIFRX_IFCR_SBDCF_Pos      (4U)
#define SPDIFRX_IFCR_SBDCF_Msk      (0x1UL << SPDIFRX_IFCR_SBDCF_Pos)          /*!< 0x00000010 */
#define SPDIFRX_IFCR_SBDCF          SPDIFRX_IFCR_SBDCF_Msk                     /*!<Clears the Synchronization Block Detected flag       */
#define SPDIFRX_IFCR_SYNCDCF_Pos    (5U)
#define SPDIFRX_IFCR_SYNCDCF_Msk    (0x1UL << SPDIFRX_IFCR_SYNCDCF_Pos)        /*!< 0x00000020 */
#define SPDIFRX_IFCR_SYNCDCF        SPDIFRX_IFCR_SYNCDCF_Msk                   /*!<Clears the Synchronization Done flag                 */
#define SPDIFRX_DR0_DR_Pos          (0U)
#define SPDIFRX_DR0_DR_Msk          (0xFFFFFFUL << SPDIFRX_DR0_DR_Pos)         /*!< 0x00FFFFFF */
#define SPDIFRX_DR0_DR              SPDIFRX_DR0_DR_Msk                         /*!<Data value            */
#define SPDIFRX_DR0_PE_Pos          (24U)
#define SPDIFRX_DR0_PE_Msk          (0x1UL << SPDIFRX_DR0_PE_Pos)              /*!< 0x01000000 */
#define SPDIFRX_DR0_PE              SPDIFRX_DR0_PE_Msk                         /*!<Parity Error bit      */
#define SPDIFRX_DR0_V_Pos           (25U)
#define SPDIFRX_DR0_V_Msk           (0x1UL << SPDIFRX_DR0_V_Pos)               /*!< 0x02000000 */
#define SPDIFRX_DR0_V               SPDIFRX_DR0_V_Msk                          /*!<Validity bit          */
#define SPDIFRX_DR0_U_Pos           (26U)
#define SPDIFRX_DR0_U_Msk           (0x1UL << SPDIFRX_DR0_U_Pos)               /*!< 0x04000000 */
#define SPDIFRX_DR0_U               SPDIFRX_DR0_U_Msk                          /*!<User bit              */
#define SPDIFRX_DR0_C_Pos           (27U)
#define SPDIFRX_DR0_C_Msk           (0x1UL << SPDIFRX_DR0_C_Pos)               /*!< 0x08000000 */
#define SPDIFRX_DR0_C               SPDIFRX_DR0_C_Msk                          /*!<Channel Status bit    */
#define SPDIFRX_DR0_PT_Pos          (28U)
#define SPDIFRX_DR0_PT_Msk          (0x3UL << SPDIFRX_DR0_PT_Pos)              /*!< 0x30000000 */
#define SPDIFRX_DR0_PT              SPDIFRX_DR0_PT_Msk                         /*!<Preamble Type         */
#define SPDIFRX_DR1_DR_Pos          (8U)
#define SPDIFRX_DR1_DR_Msk          (0xFFFFFFUL << SPDIFRX_DR1_DR_Pos)         /*!< 0xFFFFFF00 */
#define SPDIFRX_DR1_DR              SPDIFRX_DR1_DR_Msk                         /*!<Data value            */
#define SPDIFRX_DR1_PT_Pos          (4U)
#define SPDIFRX_DR1_PT_Msk          (0x3UL << SPDIFRX_DR1_PT_Pos)              /*!< 0x00000030 */
#define SPDIFRX_DR1_PT              SPDIFRX_DR1_PT_Msk                         /*!<Preamble Type         */
#define SPDIFRX_DR1_C_Pos           (3U)
#define SPDIFRX_DR1_C_Msk           (0x1UL << SPDIFRX_DR1_C_Pos)               /*!< 0x00000008 */
#define SPDIFRX_DR1_C               SPDIFRX_DR1_C_Msk                          /*!<Channel Status bit    */
#define SPDIFRX_DR1_U_Pos           (2U)
#define SPDIFRX_DR1_U_Msk           (0x1UL << SPDIFRX_DR1_U_Pos)               /*!< 0x00000004 */
#define SPDIFRX_DR1_U               SPDIFRX_DR1_U_Msk                          /*!<User bit              */
#define SPDIFRX_DR1_V_Pos           (1U)
#define SPDIFRX_DR1_V_Msk           (0x1UL << SPDIFRX_DR1_V_Pos)               /*!< 0x00000002 */
#define SPDIFRX_DR1_V               SPDIFRX_DR1_V_Msk                          /*!<Validity bit          */
#define SPDIFRX_DR1_PE_Pos          (0U)
#define SPDIFRX_DR1_PE_Msk          (0x1UL << SPDIFRX_DR1_PE_Pos)              /*!< 0x00000001 */
#define SPDIFRX_DR1_PE              SPDIFRX_DR1_PE_Msk                         /*!<Parity Error bit      */
#define SPDIFRX_DR1_DRNL1_Pos       (16U)
#define SPDIFRX_DR1_DRNL1_Msk       (0xFFFFUL << SPDIFRX_DR1_DRNL1_Pos)        /*!< 0xFFFF0000 */
#define SPDIFRX_DR1_DRNL1           SPDIFRX_DR1_DRNL1_Msk                      /*!<Data value Channel B      */
#define SPDIFRX_DR1_DRNL2_Pos       (0U)
#define SPDIFRX_DR1_DRNL2_Msk       (0xFFFFUL << SPDIFRX_DR1_DRNL2_Pos)        /*!< 0x0000FFFF */
#define SPDIFRX_DR1_DRNL2           SPDIFRX_DR1_DRNL2_Msk                      /*!<Data value Channel A      */
#define SPDIFRX_CSR_USR_Pos         (0U)
#define SPDIFRX_CSR_USR_Msk         (0xFFFFUL << SPDIFRX_CSR_USR_Pos)          /*!< 0x0000FFFF */
#define SPDIFRX_CSR_USR             SPDIFRX_CSR_USR_Msk                        /*!<User data information           */
#define SPDIFRX_CSR_CS_Pos          (16U)
#define SPDIFRX_CSR_CS_Msk          (0xFFUL << SPDIFRX_CSR_CS_Pos)             /*!< 0x00FF0000 */
#define SPDIFRX_CSR_CS              SPDIFRX_CSR_CS_Msk                         /*!<Channel A status information    */
#define SPDIFRX_CSR_SOB_Pos         (24U)
#define SPDIFRX_CSR_SOB_Msk         (0x1UL << SPDIFRX_CSR_SOB_Pos)             /*!< 0x01000000 */
#define SPDIFRX_CSR_SOB             SPDIFRX_CSR_SOB_Msk                        /*!<Start Of Block                  */
#define SPDIFRX_DIR_THI_Pos         (0U)
#define SPDIFRX_DIR_THI_Msk         (0x1FFFUL << SPDIFRX_DIR_THI_Pos)          /*!< 0x00001FFF */
#define SPDIFRX_DIR_THI             SPDIFRX_DIR_THI_Msk                        /*!<Threshold LOW      */
#define SPDIFRX_DIR_TLO_Pos         (16U)
#define SPDIFRX_DIR_TLO_Msk         (0x1FFFUL << SPDIFRX_DIR_TLO_Pos)          /*!< 0x1FFF0000 */
#define SPDIFRX_DIR_TLO             SPDIFRX_DIR_TLO_Msk                        /*!<Threshold HIGH     */
