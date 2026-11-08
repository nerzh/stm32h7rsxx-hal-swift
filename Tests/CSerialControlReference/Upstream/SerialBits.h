/* Copyright (c) 2022 STMicroelectronics. SPDX-License-Identifier: Apache-2.0
 * CMSIS extracts at 7e6e213ddc397c76622a0aca2f623ccc3b34c010. */
typedef struct
{
  __IO uint32_t CR;
  __IO uint32_t WRFR;
  __IO uint32_t CWRFR;
  __IO uint32_t RDFR;
  __IO uint32_t CRDFR;
  __IO uint32_t SR;
  __IO uint32_t CLRFR;
  uint32_t RESERVED[57];
  __IO uint32_t DINR0;
  __IO uint32_t DINR1;
  __IO uint32_t DINR2;
  __IO uint32_t DINR3;
  __IO uint32_t DINR4;
  __IO uint32_t DINR5;
  __IO uint32_t DINR6;
  __IO uint32_t DINR7;
  __IO uint32_t DINR8;
  __IO uint32_t DINR9;
  __IO uint32_t DINR10;
  __IO uint32_t DINR11;
  __IO uint32_t DINR12;
  __IO uint32_t DINR13;
  __IO uint32_t DINR14;
  __IO uint32_t DINR15;
  __IO uint32_t DINR16;
  __IO uint32_t DINR17;
  __IO uint32_t DINR18;
  __IO uint32_t DINR19;
  __IO uint32_t DINR20;
  __IO uint32_t DINR21;
  __IO uint32_t DINR22;
  __IO uint32_t DINR23;
  __IO uint32_t DINR24;
  __IO uint32_t DINR25;
  __IO uint32_t DINR26;
  __IO uint32_t DINR27;
  __IO uint32_t DINR28;
  __IO uint32_t DINR29;
  __IO uint32_t DINR30;
  __IO uint32_t DINR31;
  __IO uint32_t DOUTR0;
  __IO uint32_t DOUTR1;
  __IO uint32_t DOUTR2;
  __IO uint32_t DOUTR3;
  __IO uint32_t DOUTR4;
  __IO uint32_t DOUTR5;
  __IO uint32_t DOUTR6;
  __IO uint32_t DOUTR7;
  __IO uint32_t DOUTR8;
  __IO uint32_t DOUTR9;
  __IO uint32_t DOUTR10;
  __IO uint32_t DOUTR11;
  __IO uint32_t DOUTR12;
  __IO uint32_t DOUTR13;
  __IO uint32_t DOUTR14;
  __IO uint32_t DOUTR15;
  __IO uint32_t DOUTR16;
  __IO uint32_t DOUTR17;
  __IO uint32_t DOUTR18;
  __IO uint32_t DOUTR19;
  __IO uint32_t DOUTR20;
  __IO uint32_t DOUTR21;
  __IO uint32_t DOUTR22;
  __IO uint32_t DOUTR23;
  __IO uint32_t DOUTR24;
  __IO uint32_t DOUTR25;
  __IO uint32_t DOUTR26;
  __IO uint32_t DOUTR27;
  __IO uint32_t DOUTR28;
  __IO uint32_t DOUTR29;
  __IO uint32_t DOUTR30;
  __IO uint32_t DOUTR31;
} MDIOS_TypeDef;
typedef struct
{
  __IO uint32_t CR;            /*!< CEC control register,                           Address offset:0x00 */
  __IO uint32_t CFGR;          /*!< CEC configuration register,                     Address offset:0x04 */
  __IO uint32_t TXDR;          /*!< CEC Tx data register ,                          Address offset:0x08 */
  __IO uint32_t RXDR;          /*!< CEC Rx Data Register,                           Address offset:0x0C */
  __IO uint32_t ISR;           /*!< CEC Interrupt and Status Register,              Address offset:0x10 */
  __IO uint32_t IER;           /*!< CEC interrupt enable register,                  Address offset:0x14 */
} CEC_TypeDef;
#define CEC_BASE                        (APB1PERIPH_BASE + 0x6C00UL)
#define MDIOS_BASE                      (APB1PERIPH_BASE + 0x9400UL)
#define CEC_CR_CECEN_Pos         (0U)
#define CEC_CR_CECEN_Msk         (0x1UL << CEC_CR_CECEN_Pos)                   /*!< 0x00000001 */
#define CEC_CR_CECEN             CEC_CR_CECEN_Msk                              /*!< CEC Enable                                */
#define CEC_CR_TXSOM_Pos         (1U)
#define CEC_CR_TXSOM_Msk         (0x1UL << CEC_CR_TXSOM_Pos)                   /*!< 0x00000002 */
#define CEC_CR_TXSOM             CEC_CR_TXSOM_Msk                              /*!< CEC Tx Start Of Message                   */
#define CEC_CR_TXEOM_Pos         (2U)
#define CEC_CR_TXEOM_Msk         (0x1UL << CEC_CR_TXEOM_Pos)                   /*!< 0x00000004 */
#define CEC_CR_TXEOM             CEC_CR_TXEOM_Msk                              /*!< CEC Tx End Of Message                     */
#define CEC_CFGR_SFT_Pos         (0U)
#define CEC_CFGR_SFT_Msk         (0x7UL << CEC_CFGR_SFT_Pos)                   /*!< 0x00000007 */
#define CEC_CFGR_SFT             CEC_CFGR_SFT_Msk                              /*!< CEC Signal Free Time                      */
#define CEC_CFGR_RXTOL_Pos       (3U)
#define CEC_CFGR_RXTOL_Msk       (0x1UL << CEC_CFGR_RXTOL_Pos)                 /*!< 0x00000008 */
#define CEC_CFGR_RXTOL           CEC_CFGR_RXTOL_Msk                            /*!< CEC Tolerance                             */
#define CEC_CFGR_BRESTP_Pos      (4U)
#define CEC_CFGR_BRESTP_Msk      (0x1UL << CEC_CFGR_BRESTP_Pos)                /*!< 0x00000010 */
#define CEC_CFGR_BRESTP          CEC_CFGR_BRESTP_Msk                           /*!< CEC Rx Stop                               */
#define CEC_CFGR_BREGEN_Pos      (5U)
#define CEC_CFGR_BREGEN_Msk      (0x1UL << CEC_CFGR_BREGEN_Pos)                /*!< 0x00000020 */
#define CEC_CFGR_BREGEN          CEC_CFGR_BREGEN_Msk                           /*!< CEC Bit Rising Error generation           */
#define CEC_CFGR_LBPEGEN_Pos     (6U)
#define CEC_CFGR_LBPEGEN_Msk     (0x1UL << CEC_CFGR_LBPEGEN_Pos)               /*!< 0x00000040 */
#define CEC_CFGR_LBPEGEN         CEC_CFGR_LBPEGEN_Msk                          /*!< CEC Long Bit Period Error generation      */
#define CEC_CFGR_SFTOPT_Pos      (8U)
#define CEC_CFGR_SFTOPT_Msk      (0x1UL << CEC_CFGR_SFTOPT_Pos)                /*!< 0x00000100 */
#define CEC_CFGR_SFTOPT          CEC_CFGR_SFTOPT_Msk                           /*!< CEC Signal Free Time optional             */
#define CEC_CFGR_BRDNOGEN_Pos    (7U)
#define CEC_CFGR_BRDNOGEN_Msk    (0x1UL << CEC_CFGR_BRDNOGEN_Pos)              /*!< 0x00000080 */
#define CEC_CFGR_BRDNOGEN        CEC_CFGR_BRDNOGEN_Msk                         /*!< CEC Broadcast No error generation         */
#define CEC_CFGR_OAR_Pos         (16U)
#define CEC_CFGR_OAR_Msk         (0x7FFFUL << CEC_CFGR_OAR_Pos)                /*!< 0x7FFF0000 */
#define CEC_CFGR_OAR             CEC_CFGR_OAR_Msk                              /*!< CEC Own Address                           */
#define CEC_CFGR_LSTN_Pos        (31U)
#define CEC_CFGR_LSTN_Msk        (0x1UL << CEC_CFGR_LSTN_Pos)                  /*!< 0x80000000 */
#define CEC_CFGR_LSTN            CEC_CFGR_LSTN_Msk                             /*!< CEC Listen mode                           */
#define CEC_TXDR_TXD_Pos         (0U)
#define CEC_TXDR_TXD_Msk         (0xFFUL << CEC_TXDR_TXD_Pos)                  /*!< 0x000000FF */
#define CEC_TXDR_TXD             CEC_TXDR_TXD_Msk                              /*!< CEC Tx Data                               */
#define CEC_RXDR_RXD_Pos         (0U)
#define CEC_RXDR_RXD_Msk         (0xFFUL << CEC_RXDR_RXD_Pos)                  /*!< 0x000000FF */
#define CEC_RXDR_RXD             CEC_RXDR_RXD_Msk                              /*!< CEC Rx Data                               */
#define CEC_ISR_RXBR_Pos         (0U)
#define CEC_ISR_RXBR_Msk         (0x1UL << CEC_ISR_RXBR_Pos)                   /*!< 0x00000001 */
#define CEC_ISR_RXBR             CEC_ISR_RXBR_Msk                              /*!< CEC Rx-Byte Received                      */
#define CEC_ISR_RXEND_Pos        (1U)
#define CEC_ISR_RXEND_Msk        (0x1UL << CEC_ISR_RXEND_Pos)                  /*!< 0x00000002 */
#define CEC_ISR_RXEND            CEC_ISR_RXEND_Msk                             /*!< CEC End Of Reception                      */
#define CEC_ISR_RXOVR_Pos        (2U)
#define CEC_ISR_RXOVR_Msk        (0x1UL << CEC_ISR_RXOVR_Pos)                  /*!< 0x00000004 */
#define CEC_ISR_RXOVR            CEC_ISR_RXOVR_Msk                             /*!< CEC Rx-Overrun                            */
#define CEC_ISR_BRE_Pos          (3U)
#define CEC_ISR_BRE_Msk          (0x1UL << CEC_ISR_BRE_Pos)                    /*!< 0x00000008 */
#define CEC_ISR_BRE              CEC_ISR_BRE_Msk                               /*!< CEC Rx Bit Rising Error                   */
#define CEC_ISR_SBPE_Pos         (4U)
#define CEC_ISR_SBPE_Msk         (0x1UL << CEC_ISR_SBPE_Pos)                   /*!< 0x00000010 */
#define CEC_ISR_SBPE             CEC_ISR_SBPE_Msk                              /*!< CEC Rx Short Bit period Error             */
#define CEC_ISR_LBPE_Pos         (5U)
#define CEC_ISR_LBPE_Msk         (0x1UL << CEC_ISR_LBPE_Pos)                   /*!< 0x00000020 */
#define CEC_ISR_LBPE             CEC_ISR_LBPE_Msk                              /*!< CEC Rx Long Bit period Error              */
#define CEC_ISR_RXACKE_Pos       (6U)
#define CEC_ISR_RXACKE_Msk       (0x1UL << CEC_ISR_RXACKE_Pos)                 /*!< 0x00000040 */
#define CEC_ISR_RXACKE           CEC_ISR_RXACKE_Msk                            /*!< CEC Rx Missing Acknowledge                */
#define CEC_ISR_ARBLST_Pos       (7U)
#define CEC_ISR_ARBLST_Msk       (0x1UL << CEC_ISR_ARBLST_Pos)                 /*!< 0x00000080 */
#define CEC_ISR_ARBLST           CEC_ISR_ARBLST_Msk                            /*!< CEC Arbitration Lost                      */
#define CEC_ISR_TXBR_Pos         (8U)
#define CEC_ISR_TXBR_Msk         (0x1UL << CEC_ISR_TXBR_Pos)                   /*!< 0x00000100 */
#define CEC_ISR_TXBR             CEC_ISR_TXBR_Msk                              /*!< CEC Tx Byte Request                       */
#define CEC_ISR_TXEND_Pos        (9U)
#define CEC_ISR_TXEND_Msk        (0x1UL << CEC_ISR_TXEND_Pos)                  /*!< 0x00000200 */
#define CEC_ISR_TXEND            CEC_ISR_TXEND_Msk                             /*!< CEC End of Transmission                   */
#define CEC_ISR_TXUDR_Pos        (10U)
#define CEC_ISR_TXUDR_Msk        (0x1UL << CEC_ISR_TXUDR_Pos)                  /*!< 0x00000400 */
#define CEC_ISR_TXUDR            CEC_ISR_TXUDR_Msk                             /*!< CEC Tx-Buffer Underrun                    */
#define CEC_ISR_TXERR_Pos        (11U)
#define CEC_ISR_TXERR_Msk        (0x1UL << CEC_ISR_TXERR_Pos)                  /*!< 0x00000800 */
#define CEC_ISR_TXERR            CEC_ISR_TXERR_Msk                             /*!< CEC Tx-Error                              */
#define CEC_ISR_TXACKE_Pos       (12U)
#define CEC_ISR_TXACKE_Msk       (0x1UL << CEC_ISR_TXACKE_Pos)                 /*!< 0x00001000 */
#define CEC_ISR_TXACKE           CEC_ISR_TXACKE_Msk                            /*!< CEC Tx Missing Acknowledge                */
#define CEC_IER_RXBRIE_Pos       (0U)
#define CEC_IER_RXBRIE_Msk       (0x1UL << CEC_IER_RXBRIE_Pos)                 /*!< 0x00000001 */
#define CEC_IER_RXBRIE           CEC_IER_RXBRIE_Msk                            /*!< CEC Rx-Byte Received IT Enable            */
#define CEC_IER_RXENDIE_Pos      (1U)
#define CEC_IER_RXENDIE_Msk      (0x1UL << CEC_IER_RXENDIE_Pos)                /*!< 0x00000002 */
#define CEC_IER_RXENDIE          CEC_IER_RXENDIE_Msk                           /*!< CEC End Of Reception IT Enable            */
#define CEC_IER_RXOVRIE_Pos      (2U)
#define CEC_IER_RXOVRIE_Msk      (0x1UL << CEC_IER_RXOVRIE_Pos)                /*!< 0x00000004 */
#define CEC_IER_RXOVRIE          CEC_IER_RXOVRIE_Msk                           /*!< CEC Rx-Overrun IT Enable                  */
#define CEC_IER_BREIE_Pos        (3U)
#define CEC_IER_BREIE_Msk        (0x1UL << CEC_IER_BREIE_Pos)                  /*!< 0x00000008 */
#define CEC_IER_BREIE            CEC_IER_BREIE_Msk                             /*!< CEC Rx Bit Rising Error IT Enable         */
#define CEC_IER_SBPEIE_Pos       (4U)
#define CEC_IER_SBPEIE_Msk       (0x1UL << CEC_IER_SBPEIE_Pos)                 /*!< 0x00000010 */
#define CEC_IER_SBPEIE           CEC_IER_SBPEIE_Msk                            /*!< CEC Rx Short Bit period Error IT Enable   */
#define CEC_IER_LBPEIE_Pos       (5U)
#define CEC_IER_LBPEIE_Msk       (0x1UL << CEC_IER_LBPEIE_Pos)                 /*!< 0x00000020 */
#define CEC_IER_LBPEIE           CEC_IER_LBPEIE_Msk                            /*!< CEC Rx Long Bit period Error IT Enable    */
#define CEC_IER_RXACKEIE_Pos     (6U)
#define CEC_IER_RXACKEIE_Msk     (0x1UL << CEC_IER_RXACKEIE_Pos)               /*!< 0x00000040 */
#define CEC_IER_RXACKEIE         CEC_IER_RXACKEIE_Msk                          /*!< CEC Rx Missing Acknowledge IT Enable      */
#define CEC_IER_ARBLSTIE_Pos     (7U)
#define CEC_IER_ARBLSTIE_Msk     (0x1UL << CEC_IER_ARBLSTIE_Pos)               /*!< 0x00000080 */
#define CEC_IER_ARBLSTIE         CEC_IER_ARBLSTIE_Msk                          /*!< CEC Arbitration Lost IT Enable            */
#define CEC_IER_TXBRIE_Pos       (8U)
#define CEC_IER_TXBRIE_Msk       (0x1UL << CEC_IER_TXBRIE_Pos)                 /*!< 0x00000100 */
#define CEC_IER_TXBRIE           CEC_IER_TXBRIE_Msk                            /*!< CEC Tx Byte Request  IT Enable            */
#define CEC_IER_TXENDIE_Pos      (9U)
#define CEC_IER_TXENDIE_Msk      (0x1UL << CEC_IER_TXENDIE_Pos)                /*!< 0x00000200 */
#define CEC_IER_TXENDIE          CEC_IER_TXENDIE_Msk                           /*!< CEC End of Transmission IT Enable         */
#define CEC_IER_TXUDRIE_Pos      (10U)
#define CEC_IER_TXUDRIE_Msk      (0x1UL << CEC_IER_TXUDRIE_Pos)                /*!< 0x00000400 */
#define CEC_IER_TXUDRIE          CEC_IER_TXUDRIE_Msk                           /*!< CEC Tx-Buffer Underrun IT Enable          */
#define CEC_IER_TXERRIE_Pos      (11U)
#define CEC_IER_TXERRIE_Msk      (0x1UL << CEC_IER_TXERRIE_Pos)                /*!< 0x00000800 */
#define CEC_IER_TXERRIE          CEC_IER_TXERRIE_Msk                           /*!< CEC Tx-Error IT Enable                    */
#define CEC_IER_TXACKEIE_Pos     (12U)
#define CEC_IER_TXACKEIE_Msk     (0x1UL << CEC_IER_TXACKEIE_Pos)               /*!< 0x00001000 */
#define CEC_IER_TXACKEIE         CEC_IER_TXACKEIE_Msk                          /*!< CEC Tx Missing Acknowledge IT Enable      */
#define MDIOS_CR_EN_Pos                (0U)
#define MDIOS_CR_EN_Msk                (0x1UL << MDIOS_CR_EN_Pos)              /*!< 0x00000001 */
#define MDIOS_CR_EN                    MDIOS_CR_EN_Msk                         /*!<  MDIOS slave peripheral enable */
#define MDIOS_CR_WRIE_Pos              (1U)
#define MDIOS_CR_WRIE_Msk              (0x1UL << MDIOS_CR_WRIE_Pos)            /*!< 0x00000002 */
#define MDIOS_CR_WRIE                  MDIOS_CR_WRIE_Msk                       /*!<  MDIOS slave register write interrupt enable. */
#define MDIOS_CR_RDIE_Pos              (2U)
#define MDIOS_CR_RDIE_Msk              (0x1UL << MDIOS_CR_RDIE_Pos)            /*!< 0x00000004 */
#define MDIOS_CR_RDIE                  MDIOS_CR_RDIE_Msk                       /*!<  MDIOS slave register read interrupt enable. */
#define MDIOS_CR_EIE_Pos               (3U)
#define MDIOS_CR_EIE_Msk               (0x1UL << MDIOS_CR_EIE_Pos)             /*!< 0x00000008 */
#define MDIOS_CR_EIE                   MDIOS_CR_EIE_Msk                        /*!<  MDIOS slave register error interrupt enable. */
#define MDIOS_CR_DPC_Pos               (7U)
#define MDIOS_CR_DPC_Msk               (0x1UL << MDIOS_CR_DPC_Pos)             /*!< 0x00000080 */
#define MDIOS_CR_DPC                   MDIOS_CR_DPC_Msk                        /*!<  MDIOS slave disable preamble check. */
#define MDIOS_CR_PORT_ADDRESS_Pos      (8U)
#define MDIOS_CR_PORT_ADDRESS_Msk      (0x1FUL << MDIOS_CR_PORT_ADDRESS_Pos)   /*!< 0x00001F00 */
#define MDIOS_CR_PORT_ADDRESS          MDIOS_CR_PORT_ADDRESS_Msk               /*!<  MDIOS slave port address mask. */
#define MDIOS_CR_PORT_ADDRESS_0        (0x01UL << MDIOS_CR_PORT_ADDRESS_Pos)    /*!< 0x00000100 */
#define MDIOS_CR_PORT_ADDRESS_1        (0x02UL << MDIOS_CR_PORT_ADDRESS_Pos)    /*!< 0x00000200 */
#define MDIOS_CR_PORT_ADDRESS_2        (0x04UL << MDIOS_CR_PORT_ADDRESS_Pos)    /*!< 0x00000400 */
#define MDIOS_CR_PORT_ADDRESS_3        (0x08UL << MDIOS_CR_PORT_ADDRESS_Pos)    /*!< 0x00000800 */
#define MDIOS_CR_PORT_ADDRESS_4        (0x10UL << MDIOS_CR_PORT_ADDRESS_Pos)    /*!< 0x00001000 */
#define MDIOS_SR_PERF_Pos              (0U)
#define MDIOS_SR_PERF_Msk              (0x1UL << MDIOS_SR_PERF_Pos)            /*!< 0x00000001 */
#define MDIOS_SR_PERF                  MDIOS_SR_PERF_Msk                       /*!<  MDIOS slave turnaround error flag*/
#define MDIOS_SR_SERF_Pos              (1U)
#define MDIOS_SR_SERF_Msk              (0x1UL << MDIOS_SR_SERF_Pos)            /*!< 0x00000002 */
#define MDIOS_SR_SERF                  MDIOS_SR_SERF_Msk                       /*!<  MDIOS slave start error flag */
#define MDIOS_SR_TERF_Pos              (2U)
#define MDIOS_SR_TERF_Msk              (0x1UL << MDIOS_SR_TERF_Pos)            /*!< 0x00000004 */
#define MDIOS_SR_TERF                  MDIOS_SR_TERF_Msk                       /*!<  MDIOS slave preamble error flag */
#define MDIOS_CLRFR_CPERF_Pos          (0U)
#define MDIOS_CLRFR_CPERF_Msk          (0x1UL << MDIOS_SR_CPERF_Pos)           /*!< 0x00000001 */
#define MDIOS_CLRFR_CPERF              MDIOS_CLRFR_CPERF_Msk                   /*!<  MDIOS slave Clear the turnaround error flag */
#define MDIOS_CLRFR_CSERF_Pos          (1U)
#define MDIOS_CLRFR_CSERF_Msk          (0x1UL << MDIOS_SR_CSERF_Pos)           /*!< 0x00000002 */
#define MDIOS_CLRFR_CSERF              MDIOS_CLRFR_CSERF_Msk                   /*!<  MDIOS slave Clear the start error flag */
#define MDIOS_CLRFR_CTERF_Pos          (2U)
#define MDIOS_CLRFR_CTERF_Msk          (0x1UL << MDIOS_SR_CTERF_Pos)           /*!< 0x00000004 */
#define MDIOS_CLRFR_CTERF              MDIOS_CLRFR_CTERF_Msk                   /*!<  MDIOS slave Clear the preamble error flag */
