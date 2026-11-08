// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// CMSIS definitions from 7e6e213ddc397c76622a0aca2f623ccc3b34c010.

typedef struct
{
  __IO uint32_t CREL;          /*!< FDCAN Core Release register,                      Address offset: 0x000 */
  __IO uint32_t ENDN;          /*!< FDCAN Endian register,                            Address offset: 0x004 */
       uint32_t RESERVED1;     /*!< Reserved,                                                         0x008 */
  __IO uint32_t DBTP;          /*!< FDCAN Data Bit Timing & Prescaler register,       Address offset: 0x00C */
  __IO uint32_t TEST;          /*!< FDCAN Test register,                              Address offset: 0x010 */
  __IO uint32_t RWD;           /*!< FDCAN RAM Watchdog register,                      Address offset: 0x014 */
  __IO uint32_t CCCR;          /*!< FDCAN CC Control register,                        Address offset: 0x018 */
  __IO uint32_t NBTP;          /*!< FDCAN Nominal Bit Timing & Prescaler register,    Address offset: 0x01C */
  __IO uint32_t TSCC;          /*!< FDCAN Timestamp Counter Configuration register,   Address offset: 0x020 */
  __IO uint32_t TSCV;          /*!< FDCAN Timestamp Counter Value register,           Address offset: 0x024 */
  __IO uint32_t TOCC;          /*!< FDCAN Timeout Counter Configuration register,     Address offset: 0x028 */
  __IO uint32_t TOCV;          /*!< FDCAN Timeout Counter Value register,             Address offset: 0x02C */
       uint32_t RESERVED2[4];  /*!< Reserved,                                                 0x030 - 0x03C */
  __IO uint32_t ECR;           /*!< FDCAN Error Counter register,                     Address offset: 0x040 */
  __IO uint32_t PSR;           /*!< FDCAN Protocol Status register,                   Address offset: 0x044 */
  __IO uint32_t TDCR;          /*!< FDCAN Transmitter Delay Compensation register,    Address offset: 0x048 */
       uint32_t RESERVED3;     /*!< Reserved,                                                         0x04C */
  __IO uint32_t IR;            /*!< FDCAN Interrupt register,                         Address offset: 0x050 */
  __IO uint32_t IE;            /*!< FDCAN Interrupt Enable register,                  Address offset: 0x054 */
  __IO uint32_t ILS;           /*!< FDCAN Interrupt Line Select register,             Address offset: 0x058 */
  __IO uint32_t ILE;           /*!< FDCAN Interrupt Line Enable register,             Address offset: 0x05C */
       uint32_t RESERVED4[8];  /*!< Reserved,                                                 0x060 - 0x07C */
  __IO uint32_t RXGFC;         /*!< FDCAN Global Filter Configuration register,       Address offset: 0x080 */
  __IO uint32_t XIDAM;         /*!< FDCAN Extended ID AND Mask register,              Address offset: 0x084 */
  __IO uint32_t HPMS;          /*!< FDCAN High Priority Message Status register,      Address offset: 0x088 */
       uint32_t RESERVED5;     /*!< Reserved,                                                         0x08C */
  __IO uint32_t RXF0S;         /*!< FDCAN Rx FIFO 0 Status register,                  Address offset: 0x090 */
  __IO uint32_t RXF0A;         /*!< FDCAN Rx FIFO 0 Acknowledge register,             Address offset: 0x094 */
  __IO uint32_t RXF1S;         /*!< FDCAN Rx FIFO 1 Status register,                  Address offset: 0x098 */
  __IO uint32_t RXF1A;         /*!< FDCAN Rx FIFO 1 Acknowledge register,             Address offset: 0x09C */
       uint32_t RESERVED6[8];  /*!< Reserved,                                                 0x0A0 - 0x0BC */
  __IO uint32_t TXBC;          /*!< FDCAN Tx Buffer Configuration register,           Address offset: 0x0C0 */
  __IO uint32_t TXFQS;         /*!< FDCAN Tx FIFO/Queue Status register,              Address offset: 0x0C4 */
  __IO uint32_t TXBRP;         /*!< FDCAN Tx Buffer Request Pending register,         Address offset: 0x0C8 */
  __IO uint32_t TXBAR;         /*!< FDCAN Tx Buffer Add Request register,             Address offset: 0x0CC */
  __IO uint32_t TXBCR;         /*!< FDCAN Tx Buffer Cancellation Request register,    Address offset: 0x0D0 */
  __IO uint32_t TXBTO;         /*!< FDCAN Tx Buffer Transmission Occurred register,   Address offset: 0x0D4 */
  __IO uint32_t TXBCF;         /*!< FDCAN Tx Buffer Cancellation Finished register,   Address offset: 0x0D8 */
  __IO uint32_t TXBTIE;        /*!< FDCAN Tx Buffer Transmission Interrupt Enable register,          Address offset: 0x0DC */
  __IO uint32_t TXBCIE;        /*!< FDCAN Tx Buffer Cancellation Finished Interrupt Enable register, Address offset: 0x0E0 */
  __IO uint32_t TXEFS;         /*!< FDCAN Tx Event FIFO Status register,              Address offset: 0x0E4 */
  __IO uint32_t TXEFA;         /*!< FDCAN Tx Event FIFO Acknowledge register,         Address offset: 0x0E8 */
} FDCAN_GlobalTypeDef;

typedef struct
{
  __IO uint32_t CKDIV;         /*!< FDCAN clock divider register,                    Address offset: 0x100 + 0x000 */
       uint32_t RESERVED1[128];/*!< Reserved,                                        0x100 + 0x004 - 0x100 + 0x200 */
  __IO uint32_t OPTR;          /*!< FDCAN option register,                           Address offset: 0x100 + 0x204 */
       uint32_t RESERVED2[58]; /*!< Reserved,                                        0x100 + 0x208 - 0x100 + 0x2EC */
  __IO uint32_t HWCFG;         /*!< FDCAN hardware configuration register,           Address offset: 0x100 + 0x2F0 */
  __IO uint32_t VERR;          /*!< FDCAN IP version register,                       Address offset: 0x100 + 0x2F4 */
  __IO uint32_t IPIDR;         /*!< FDCAN IP ID register,                            Address offset: 0x100 + 0x2F8 */
  __IO uint32_t SIDR;          /*!< FDCAN size ID register,                          Address offset: 0x100 + 0x2FC */
} FDCAN_Config_TypeDef;
#define FDCAN_CREL_DAY_Pos           (0U)
#define FDCAN_CREL_DAY_Msk           (0xFFUL << FDCAN_CREL_DAY_Pos)            
#define FDCAN_CREL_DAY               FDCAN_CREL_DAY_Msk                        
#define FDCAN_CREL_MON_Pos           (8U)
#define FDCAN_CREL_MON_Msk           (0xFFUL << FDCAN_CREL_MON_Pos)            
#define FDCAN_CREL_MON               FDCAN_CREL_MON_Msk                        
#define FDCAN_CREL_YEAR_Pos          (16U)
#define FDCAN_CREL_YEAR_Msk          (0xFUL << FDCAN_CREL_YEAR_Pos)            
#define FDCAN_CREL_YEAR              FDCAN_CREL_YEAR_Msk                       
#define FDCAN_CREL_SUBSTEP_Pos       (20U)
#define FDCAN_CREL_SUBSTEP_Msk       (0xFUL << FDCAN_CREL_SUBSTEP_Pos)         
#define FDCAN_CREL_SUBSTEP           FDCAN_CREL_SUBSTEP_Msk                    
#define FDCAN_CREL_STEP_Pos          (24U)
#define FDCAN_CREL_STEP_Msk          (0xFUL << FDCAN_CREL_STEP_Pos)            
#define FDCAN_CREL_STEP              FDCAN_CREL_STEP_Msk                       
#define FDCAN_CREL_REL_Pos           (28U)
#define FDCAN_CREL_REL_Msk           (0xFUL << FDCAN_CREL_REL_Pos)             
#define FDCAN_CREL_REL               FDCAN_CREL_REL_Msk                        
#define FDCAN_ENDN_ETV_Pos           (0U)
#define FDCAN_ENDN_ETV_Msk           (0xFFFFFFFFUL << FDCAN_ENDN_ETV_Pos)      
#define FDCAN_ENDN_ETV               FDCAN_ENDN_ETV_Msk                        
#define FDCAN_DBTP_DSJW_Pos          (0U)
#define FDCAN_DBTP_DSJW_Msk          (0xFUL << FDCAN_DBTP_DSJW_Pos)            
#define FDCAN_DBTP_DSJW              FDCAN_DBTP_DSJW_Msk                       
#define FDCAN_DBTP_DTSEG2_Pos        (4U)
#define FDCAN_DBTP_DTSEG2_Msk        (0xFUL << FDCAN_DBTP_DTSEG2_Pos)          
#define FDCAN_DBTP_DTSEG2            FDCAN_DBTP_DTSEG2_Msk                     
#define FDCAN_DBTP_DTSEG1_Pos        (8U)
#define FDCAN_DBTP_DTSEG1_Msk        (0x1FUL << FDCAN_DBTP_DTSEG1_Pos)         
#define FDCAN_DBTP_DTSEG1            FDCAN_DBTP_DTSEG1_Msk                     
#define FDCAN_DBTP_DBRP_Pos          (16U)
#define FDCAN_DBTP_DBRP_Msk          (0x1FUL << FDCAN_DBTP_DBRP_Pos)           
#define FDCAN_DBTP_DBRP              FDCAN_DBTP_DBRP_Msk                       
#define FDCAN_DBTP_TDC_Pos           (23U)
#define FDCAN_DBTP_TDC_Msk           (0x1UL << FDCAN_DBTP_TDC_Pos)             
#define FDCAN_DBTP_TDC               FDCAN_DBTP_TDC_Msk                        
#define FDCAN_TEST_LBCK_Pos          (4U)
#define FDCAN_TEST_LBCK_Msk          (0x1UL << FDCAN_TEST_LBCK_Pos)            
#define FDCAN_TEST_LBCK              FDCAN_TEST_LBCK_Msk                       
#define FDCAN_TEST_TX_Pos            (5U)
#define FDCAN_TEST_TX_Msk            (0x3UL << FDCAN_TEST_TX_Pos)              
#define FDCAN_TEST_TX                FDCAN_TEST_TX_Msk                         
#define FDCAN_TEST_RX_Pos            (7U)
#define FDCAN_TEST_RX_Msk            (0x1UL << FDCAN_TEST_RX_Pos)              
#define FDCAN_TEST_RX                FDCAN_TEST_RX_Msk                         
#define FDCAN_RWD_WDC_Pos            (0U)
#define FDCAN_RWD_WDC_Msk            (0xFFUL << FDCAN_RWD_WDC_Pos)             
#define FDCAN_RWD_WDC                FDCAN_RWD_WDC_Msk                         
#define FDCAN_RWD_WDV_Pos            (8U)
#define FDCAN_RWD_WDV_Msk            (0xFFUL << FDCAN_RWD_WDV_Pos)             
#define FDCAN_RWD_WDV                FDCAN_RWD_WDV_Msk                         
#define FDCAN_CCCR_INIT_Pos          (0U)
#define FDCAN_CCCR_INIT_Msk          (0x1UL << FDCAN_CCCR_INIT_Pos)            
#define FDCAN_CCCR_INIT              FDCAN_CCCR_INIT_Msk                       
#define FDCAN_CCCR_CCE_Pos           (1U)
#define FDCAN_CCCR_CCE_Msk           (0x1UL << FDCAN_CCCR_CCE_Pos)             
#define FDCAN_CCCR_CCE               FDCAN_CCCR_CCE_Msk                        
#define FDCAN_CCCR_ASM_Pos           (2U)
#define FDCAN_CCCR_ASM_Msk           (0x1UL << FDCAN_CCCR_ASM_Pos)             
#define FDCAN_CCCR_ASM               FDCAN_CCCR_ASM_Msk                        
#define FDCAN_CCCR_CSA_Pos           (3U)
#define FDCAN_CCCR_CSA_Msk           (0x1UL << FDCAN_CCCR_CSA_Pos)             
#define FDCAN_CCCR_CSA               FDCAN_CCCR_CSA_Msk                        
#define FDCAN_CCCR_CSR_Pos           (4U)
#define FDCAN_CCCR_CSR_Msk           (0x1UL << FDCAN_CCCR_CSR_Pos)             
#define FDCAN_CCCR_CSR               FDCAN_CCCR_CSR_Msk                        
#define FDCAN_CCCR_MON_Pos           (5U)
#define FDCAN_CCCR_MON_Msk           (0x1UL << FDCAN_CCCR_MON_Pos)             
#define FDCAN_CCCR_MON               FDCAN_CCCR_MON_Msk                        
#define FDCAN_CCCR_DAR_Pos           (6U)
#define FDCAN_CCCR_DAR_Msk           (0x1UL << FDCAN_CCCR_DAR_Pos)             
#define FDCAN_CCCR_DAR               FDCAN_CCCR_DAR_Msk                        
#define FDCAN_CCCR_TEST_Pos          (7U)
#define FDCAN_CCCR_TEST_Msk          (0x1UL << FDCAN_CCCR_TEST_Pos)            
#define FDCAN_CCCR_TEST              FDCAN_CCCR_TEST_Msk                       
#define FDCAN_CCCR_FDOE_Pos          (8U)
#define FDCAN_CCCR_FDOE_Msk          (0x1UL << FDCAN_CCCR_FDOE_Pos)            
#define FDCAN_CCCR_FDOE              FDCAN_CCCR_FDOE_Msk                       
#define FDCAN_CCCR_BRSE_Pos          (9U)
#define FDCAN_CCCR_BRSE_Msk          (0x1UL << FDCAN_CCCR_BRSE_Pos)            
#define FDCAN_CCCR_BRSE              FDCAN_CCCR_BRSE_Msk                       
#define FDCAN_CCCR_PXHD_Pos          (12U)
#define FDCAN_CCCR_PXHD_Msk          (0x1UL << FDCAN_CCCR_PXHD_Pos)            
#define FDCAN_CCCR_PXHD              FDCAN_CCCR_PXHD_Msk                       
#define FDCAN_CCCR_EFBI_Pos          (13U)
#define FDCAN_CCCR_EFBI_Msk          (0x1UL << FDCAN_CCCR_EFBI_Pos)            
#define FDCAN_CCCR_EFBI              FDCAN_CCCR_EFBI_Msk                       
#define FDCAN_CCCR_TXP_Pos           (14U)
#define FDCAN_CCCR_TXP_Msk           (0x1UL << FDCAN_CCCR_TXP_Pos)             
#define FDCAN_CCCR_TXP               FDCAN_CCCR_TXP_Msk                        
#define FDCAN_CCCR_NISO_Pos          (15U)
#define FDCAN_CCCR_NISO_Msk          (0x1UL << FDCAN_CCCR_NISO_Pos)            
#define FDCAN_CCCR_NISO              FDCAN_CCCR_NISO_Msk                       
#define FDCAN_NBTP_NTSEG2_Pos        (0U)
#define FDCAN_NBTP_NTSEG2_Msk        (0x7FUL << FDCAN_NBTP_NTSEG2_Pos)         
#define FDCAN_NBTP_NTSEG2            FDCAN_NBTP_NTSEG2_Msk                     
#define FDCAN_NBTP_NTSEG1_Pos        (8U)
#define FDCAN_NBTP_NTSEG1_Msk        (0xFFUL << FDCAN_NBTP_NTSEG1_Pos)         
#define FDCAN_NBTP_NTSEG1            FDCAN_NBTP_NTSEG1_Msk                     
#define FDCAN_NBTP_NBRP_Pos          (16U)
#define FDCAN_NBTP_NBRP_Msk          (0x1FFUL << FDCAN_NBTP_NBRP_Pos)          
#define FDCAN_NBTP_NBRP              FDCAN_NBTP_NBRP_Msk                       
#define FDCAN_NBTP_NSJW_Pos          (25U)
#define FDCAN_NBTP_NSJW_Msk          (0x7FUL << FDCAN_NBTP_NSJW_Pos)           
#define FDCAN_NBTP_NSJW              FDCAN_NBTP_NSJW_Msk                       
#define FDCAN_TSCC_TSS_Pos           (0U)
#define FDCAN_TSCC_TSS_Msk           (0x3UL << FDCAN_TSCC_TSS_Pos)             
#define FDCAN_TSCC_TSS               FDCAN_TSCC_TSS_Msk                        
#define FDCAN_TSCC_TCP_Pos           (16U)
#define FDCAN_TSCC_TCP_Msk           (0xFUL << FDCAN_TSCC_TCP_Pos)             
#define FDCAN_TSCC_TCP               FDCAN_TSCC_TCP_Msk                        
#define FDCAN_TSCV_TSC_Pos           (0U)
#define FDCAN_TSCV_TSC_Msk           (0xFFFFUL << FDCAN_TSCV_TSC_Pos)          
#define FDCAN_TSCV_TSC               FDCAN_TSCV_TSC_Msk                        
#define FDCAN_TOCC_ETOC_Pos          (0U)
#define FDCAN_TOCC_ETOC_Msk          (0x1UL << FDCAN_TOCC_ETOC_Pos)            
#define FDCAN_TOCC_ETOC              FDCAN_TOCC_ETOC_Msk                       
#define FDCAN_TOCC_TOS_Pos           (1U)
#define FDCAN_TOCC_TOS_Msk           (0x3UL << FDCAN_TOCC_TOS_Pos)             
#define FDCAN_TOCC_TOS               FDCAN_TOCC_TOS_Msk                        
#define FDCAN_TOCC_TOP_Pos           (16U)
#define FDCAN_TOCC_TOP_Msk           (0xFFFFUL << FDCAN_TOCC_TOP_Pos)          
#define FDCAN_TOCC_TOP               FDCAN_TOCC_TOP_Msk                        
#define FDCAN_TOCV_TOC_Pos           (0U)
#define FDCAN_TOCV_TOC_Msk           (0xFFFFUL << FDCAN_TOCV_TOC_Pos)          
#define FDCAN_TOCV_TOC               FDCAN_TOCV_TOC_Msk                        
#define FDCAN_ECR_TEC_Pos            (0U)
#define FDCAN_ECR_TEC_Msk            (0xFFUL << FDCAN_ECR_TEC_Pos)             
#define FDCAN_ECR_TEC                FDCAN_ECR_TEC_Msk                         
#define FDCAN_ECR_REC_Pos            (8U)
#define FDCAN_ECR_REC_Msk            (0x7FUL << FDCAN_ECR_REC_Pos)             
#define FDCAN_ECR_REC                FDCAN_ECR_REC_Msk                         
#define FDCAN_ECR_RP_Pos             (15U)
#define FDCAN_ECR_RP_Msk             (0x1UL << FDCAN_ECR_RP_Pos)               
#define FDCAN_ECR_RP                 FDCAN_ECR_RP_Msk                          
#define FDCAN_ECR_CEL_Pos            (16U)
#define FDCAN_ECR_CEL_Msk            (0xFFUL << FDCAN_ECR_CEL_Pos)             
#define FDCAN_ECR_CEL                FDCAN_ECR_CEL_Msk                         
#define FDCAN_PSR_LEC_Pos            (0U)
#define FDCAN_PSR_LEC_Msk            (0x7UL << FDCAN_PSR_LEC_Pos)              
#define FDCAN_PSR_LEC                FDCAN_PSR_LEC_Msk                         
#define FDCAN_PSR_ACT_Pos            (3U)
#define FDCAN_PSR_ACT_Msk            (0x3UL << FDCAN_PSR_ACT_Pos)              
#define FDCAN_PSR_ACT                FDCAN_PSR_ACT_Msk                         
#define FDCAN_PSR_EP_Pos             (5U)
#define FDCAN_PSR_EP_Msk             (0x1UL << FDCAN_PSR_EP_Pos)               
#define FDCAN_PSR_EP                 FDCAN_PSR_EP_Msk                          
#define FDCAN_PSR_EW_Pos             (6U)
#define FDCAN_PSR_EW_Msk             (0x1UL << FDCAN_PSR_EW_Pos)               
#define FDCAN_PSR_EW                 FDCAN_PSR_EW_Msk                          
#define FDCAN_PSR_BO_Pos             (7U)
#define FDCAN_PSR_BO_Msk             (0x1UL << FDCAN_PSR_BO_Pos)               
#define FDCAN_PSR_BO                 FDCAN_PSR_BO_Msk                          
#define FDCAN_PSR_DLEC_Pos           (8U)
#define FDCAN_PSR_DLEC_Msk           (0x7UL << FDCAN_PSR_DLEC_Pos)             
#define FDCAN_PSR_DLEC               FDCAN_PSR_DLEC_Msk                        
#define FDCAN_PSR_RESI_Pos           (11U)
#define FDCAN_PSR_RESI_Msk           (0x1UL << FDCAN_PSR_RESI_Pos)             
#define FDCAN_PSR_RESI               FDCAN_PSR_RESI_Msk                        
#define FDCAN_PSR_RBRS_Pos           (12U)
#define FDCAN_PSR_RBRS_Msk           (0x1UL << FDCAN_PSR_RBRS_Pos)             
#define FDCAN_PSR_RBRS               FDCAN_PSR_RBRS_Msk                        
#define FDCAN_PSR_REDL_Pos           (13U)
#define FDCAN_PSR_REDL_Msk           (0x1UL << FDCAN_PSR_REDL_Pos)             
#define FDCAN_PSR_REDL               FDCAN_PSR_REDL_Msk                        
#define FDCAN_PSR_PXE_Pos            (14U)
#define FDCAN_PSR_PXE_Msk            (0x1UL << FDCAN_PSR_PXE_Pos)              
#define FDCAN_PSR_PXE                FDCAN_PSR_PXE_Msk                         
#define FDCAN_PSR_TDCV_Pos           (16U)
#define FDCAN_PSR_TDCV_Msk           (0x7FUL << FDCAN_PSR_TDCV_Pos)            
#define FDCAN_PSR_TDCV               FDCAN_PSR_TDCV_Msk                        
#define FDCAN_TDCR_TDCF_Pos          (0U)
#define FDCAN_TDCR_TDCF_Msk          (0x7FUL << FDCAN_TDCR_TDCF_Pos)           
#define FDCAN_TDCR_TDCF              FDCAN_TDCR_TDCF_Msk                       
#define FDCAN_TDCR_TDCO_Pos          (8U)
#define FDCAN_TDCR_TDCO_Msk          (0x7FUL << FDCAN_TDCR_TDCO_Pos)           
#define FDCAN_TDCR_TDCO              FDCAN_TDCR_TDCO_Msk                       
#define FDCAN_IR_RF0N_Pos            (0U)
#define FDCAN_IR_RF0N_Msk            (0x1UL << FDCAN_IR_RF0N_Pos)              
#define FDCAN_IR_RF0N                FDCAN_IR_RF0N_Msk                         
#define FDCAN_IR_RF0F_Pos            (1U)
#define FDCAN_IR_RF0F_Msk            (0x1UL << FDCAN_IR_RF0F_Pos)              
#define FDCAN_IR_RF0F                FDCAN_IR_RF0F_Msk                         
#define FDCAN_IR_RF0L_Pos            (2U)
#define FDCAN_IR_RF0L_Msk            (0x1UL << FDCAN_IR_RF0L_Pos)              
#define FDCAN_IR_RF0L                FDCAN_IR_RF0L_Msk                         
#define FDCAN_IR_RF1N_Pos            (3U)
#define FDCAN_IR_RF1N_Msk            (0x1UL << FDCAN_IR_RF1N_Pos)              
#define FDCAN_IR_RF1N                FDCAN_IR_RF1N_Msk                         
#define FDCAN_IR_RF1F_Pos            (4U)
#define FDCAN_IR_RF1F_Msk            (0x1UL << FDCAN_IR_RF1F_Pos)              
#define FDCAN_IR_RF1F                FDCAN_IR_RF1F_Msk                         
#define FDCAN_IR_RF1L_Pos            (5U)
#define FDCAN_IR_RF1L_Msk            (0x1UL << FDCAN_IR_RF1L_Pos)              
#define FDCAN_IR_RF1L                FDCAN_IR_RF1L_Msk                         
#define FDCAN_IR_HPM_Pos             (6U)
#define FDCAN_IR_HPM_Msk             (0x1UL << FDCAN_IR_HPM_Pos)               
#define FDCAN_IR_HPM                 FDCAN_IR_HPM_Msk                          
#define FDCAN_IR_TC_Pos              (7U)
#define FDCAN_IR_TC_Msk              (0x1UL << FDCAN_IR_TC_Pos)                
#define FDCAN_IR_TC                  FDCAN_IR_TC_Msk                           
#define FDCAN_IR_TCF_Pos             (8U)
#define FDCAN_IR_TCF_Msk             (0x1UL << FDCAN_IR_TCF_Pos)               
#define FDCAN_IR_TCF                 FDCAN_IR_TCF_Msk                          
#define FDCAN_IR_TFE_Pos             (9U)
#define FDCAN_IR_TFE_Msk             (0x1UL << FDCAN_IR_TFE_Pos)               
#define FDCAN_IR_TFE                 FDCAN_IR_TFE_Msk                          
#define FDCAN_IR_TEFN_Pos            (10U)
#define FDCAN_IR_TEFN_Msk            (0x1UL << FDCAN_IR_TEFN_Pos)              
#define FDCAN_IR_TEFN                FDCAN_IR_TEFN_Msk                         
#define FDCAN_IR_TEFF_Pos            (11U)
#define FDCAN_IR_TEFF_Msk            (0x1UL << FDCAN_IR_TEFF_Pos)              
#define FDCAN_IR_TEFF                FDCAN_IR_TEFF_Msk                         
#define FDCAN_IR_TEFL_Pos            (12U)
#define FDCAN_IR_TEFL_Msk            (0x1UL << FDCAN_IR_TEFL_Pos)              
#define FDCAN_IR_TEFL                FDCAN_IR_TEFL_Msk                         
#define FDCAN_IR_TSW_Pos             (13U)
#define FDCAN_IR_TSW_Msk             (0x1UL << FDCAN_IR_TSW_Pos)               
#define FDCAN_IR_TSW                 FDCAN_IR_TSW_Msk                          
#define FDCAN_IR_MRAF_Pos            (14U)
#define FDCAN_IR_MRAF_Msk            (0x1UL << FDCAN_IR_MRAF_Pos)              
#define FDCAN_IR_MRAF                FDCAN_IR_MRAF_Msk                         
#define FDCAN_IR_TOO_Pos             (15U)
#define FDCAN_IR_TOO_Msk             (0x1UL << FDCAN_IR_TOO_Pos)               
#define FDCAN_IR_TOO                 FDCAN_IR_TOO_Msk                          
#define FDCAN_IR_ELO_Pos             (16U)
#define FDCAN_IR_ELO_Msk             (0x1UL << FDCAN_IR_ELO_Pos)               
#define FDCAN_IR_ELO                 FDCAN_IR_ELO_Msk                          
#define FDCAN_IR_EP_Pos              (17U)
#define FDCAN_IR_EP_Msk              (0x1UL << FDCAN_IR_EP_Pos)                
#define FDCAN_IR_EP                  FDCAN_IR_EP_Msk                           
#define FDCAN_IR_EW_Pos              (18U)
#define FDCAN_IR_EW_Msk              (0x1UL << FDCAN_IR_EW_Pos)                
#define FDCAN_IR_EW                  FDCAN_IR_EW_Msk                           
#define FDCAN_IR_BO_Pos              (19U)
#define FDCAN_IR_BO_Msk              (0x1UL << FDCAN_IR_BO_Pos)                
#define FDCAN_IR_BO                  FDCAN_IR_BO_Msk                           
#define FDCAN_IR_WDI_Pos             (20U)
#define FDCAN_IR_WDI_Msk             (0x1UL << FDCAN_IR_WDI_Pos)               
#define FDCAN_IR_WDI                 FDCAN_IR_WDI_Msk                          
#define FDCAN_IR_PEA_Pos             (21U)
#define FDCAN_IR_PEA_Msk             (0x1UL << FDCAN_IR_PEA_Pos)               
#define FDCAN_IR_PEA                 FDCAN_IR_PEA_Msk                          
#define FDCAN_IR_PED_Pos             (22U)
#define FDCAN_IR_PED_Msk             (0x1UL << FDCAN_IR_PED_Pos)               
#define FDCAN_IR_PED                 FDCAN_IR_PED_Msk                          
#define FDCAN_IR_ARA_Pos             (23U)
#define FDCAN_IR_ARA_Msk             (0x1UL << FDCAN_IR_ARA_Pos)               
#define FDCAN_IR_ARA                 FDCAN_IR_ARA_Msk                          
#define FDCAN_IE_RF0NE_Pos           (0U)
#define FDCAN_IE_RF0NE_Msk           (0x1UL << FDCAN_IE_RF0NE_Pos)             
#define FDCAN_IE_RF0NE               FDCAN_IE_RF0NE_Msk                        
#define FDCAN_IE_RF0FE_Pos           (1U)
#define FDCAN_IE_RF0FE_Msk           (0x1UL << FDCAN_IE_RF0FE_Pos)             
#define FDCAN_IE_RF0FE               FDCAN_IE_RF0FE_Msk                        
#define FDCAN_IE_RF0LE_Pos           (2U)
#define FDCAN_IE_RF0LE_Msk           (0x1UL << FDCAN_IE_RF0LE_Pos)             
#define FDCAN_IE_RF0LE               FDCAN_IE_RF0LE_Msk                        
#define FDCAN_IE_RF1NE_Pos           (3U)
#define FDCAN_IE_RF1NE_Msk           (0x1UL << FDCAN_IE_RF1NE_Pos)             
#define FDCAN_IE_RF1NE               FDCAN_IE_RF1NE_Msk                        
#define FDCAN_IE_RF1FE_Pos           (4U)
#define FDCAN_IE_RF1FE_Msk           (0x1UL << FDCAN_IE_RF1FE_Pos)             
#define FDCAN_IE_RF1FE               FDCAN_IE_RF1FE_Msk                        
#define FDCAN_IE_RF1LE_Pos           (5U)
#define FDCAN_IE_RF1LE_Msk           (0x1UL << FDCAN_IE_RF1LE_Pos)             
#define FDCAN_IE_RF1LE               FDCAN_IE_RF1LE_Msk                        
#define FDCAN_IE_HPME_Pos            (6U)
#define FDCAN_IE_HPME_Msk            (0x1UL << FDCAN_IE_HPME_Pos)              
#define FDCAN_IE_HPME                FDCAN_IE_HPME_Msk                         
#define FDCAN_IE_TCE_Pos             (7U)
#define FDCAN_IE_TCE_Msk             (0x1UL << FDCAN_IE_TCE_Pos)               
#define FDCAN_IE_TCE                 FDCAN_IE_TCE_Msk                          
#define FDCAN_IE_TCFE_Pos            (8U)
#define FDCAN_IE_TCFE_Msk            (0x1UL << FDCAN_IE_TCFE_Pos)              
#define FDCAN_IE_TCFE                FDCAN_IE_TCFE_Msk                         
#define FDCAN_IE_TFEE_Pos            (9U)
#define FDCAN_IE_TFEE_Msk            (0x1UL << FDCAN_IE_TFEE_Pos)              
#define FDCAN_IE_TFEE                FDCAN_IE_TFEE_Msk                         
#define FDCAN_IE_TEFNE_Pos           (10U)
#define FDCAN_IE_TEFNE_Msk           (0x1UL << FDCAN_IE_TEFNE_Pos)             
#define FDCAN_IE_TEFNE               FDCAN_IE_TEFNE_Msk                        
#define FDCAN_IE_TEFFE_Pos           (11U)
#define FDCAN_IE_TEFFE_Msk           (0x1UL << FDCAN_IE_TEFFE_Pos)             
#define FDCAN_IE_TEFFE               FDCAN_IE_TEFFE_Msk                        
#define FDCAN_IE_TEFLE_Pos           (12U)
#define FDCAN_IE_TEFLE_Msk           (0x1UL << FDCAN_IE_TEFLE_Pos)             
#define FDCAN_IE_TEFLE               FDCAN_IE_TEFLE_Msk                        
#define FDCAN_IE_TSWE_Pos            (13U)
#define FDCAN_IE_TSWE_Msk            (0x1UL << FDCAN_IE_TSWE_Pos)              
#define FDCAN_IE_TSWE                FDCAN_IE_TSWE_Msk                         
#define FDCAN_IE_MRAFE_Pos           (14U)
#define FDCAN_IE_MRAFE_Msk           (0x1UL << FDCAN_IE_MRAFE_Pos)             
#define FDCAN_IE_MRAFE               FDCAN_IE_MRAFE_Msk                        
#define FDCAN_IE_TOOE_Pos            (15U)
#define FDCAN_IE_TOOE_Msk            (0x1UL << FDCAN_IE_TOOE_Pos)              
#define FDCAN_IE_TOOE                FDCAN_IE_TOOE_Msk                         
#define FDCAN_IE_ELOE_Pos            (16U)
#define FDCAN_IE_ELOE_Msk            (0x1UL << FDCAN_IE_ELOE_Pos)              
#define FDCAN_IE_ELOE                FDCAN_IE_ELOE_Msk                         
#define FDCAN_IE_EPE_Pos             (17U)
#define FDCAN_IE_EPE_Msk             (0x1UL << FDCAN_IE_EPE_Pos)               
#define FDCAN_IE_EPE                 FDCAN_IE_EPE_Msk                          
#define FDCAN_IE_EWE_Pos             (18U)
#define FDCAN_IE_EWE_Msk             (0x1UL << FDCAN_IE_EWE_Pos)               
#define FDCAN_IE_EWE                 FDCAN_IE_EWE_Msk                          
#define FDCAN_IE_BOE_Pos             (19U)
#define FDCAN_IE_BOE_Msk             (0x1UL << FDCAN_IE_BOE_Pos)               
#define FDCAN_IE_BOE                 FDCAN_IE_BOE_Msk                          
#define FDCAN_IE_WDIE_Pos            (20U)
#define FDCAN_IE_WDIE_Msk            (0x1UL << FDCAN_IE_WDIE_Pos)              
#define FDCAN_IE_WDIE                FDCAN_IE_WDIE_Msk                         
#define FDCAN_IE_PEAE_Pos            (21U)
#define FDCAN_IE_PEAE_Msk            (0x1UL << FDCAN_IE_PEAE_Pos)              
#define FDCAN_IE_PEAE                FDCAN_IE_PEAE_Msk                         
#define FDCAN_IE_PEDE_Pos            (22U)
#define FDCAN_IE_PEDE_Msk            (0x1UL << FDCAN_IE_PEDE_Pos)              
#define FDCAN_IE_PEDE                FDCAN_IE_PEDE_Msk                         
#define FDCAN_IE_ARAE_Pos            (23U)
#define FDCAN_IE_ARAE_Msk            (0x1UL << FDCAN_IE_ARAE_Pos)              
#define FDCAN_IE_ARAE                FDCAN_IE_ARAE_Msk                         
#define FDCAN_ILS_RXFIFO0_Pos        (0U)
#define FDCAN_ILS_RXFIFO0_Msk        (0x1UL << FDCAN_ILS_RXFIFO0_Pos)          
#define FDCAN_ILS_RXFIFO0            FDCAN_ILS_RXFIFO0_Msk                     
#define FDCAN_ILS_RXFIFO1_Pos        (1U)
#define FDCAN_ILS_RXFIFO1_Msk        (0x1UL << FDCAN_ILS_RXFIFO1_Pos)          
#define FDCAN_ILS_RXFIFO1            FDCAN_ILS_RXFIFO1_Msk                     
#define FDCAN_ILS_SMSG_Pos           (2U)
#define FDCAN_ILS_SMSG_Msk           (0x1UL << FDCAN_ILS_SMSG_Pos)             
#define FDCAN_ILS_SMSG               FDCAN_ILS_SMSG_Msk                        
#define FDCAN_ILS_TFERR_Pos          (3U)
#define FDCAN_ILS_TFERR_Msk          (0x1UL << FDCAN_ILS_TFERR_Pos)            
#define FDCAN_ILS_TFERR              FDCAN_ILS_TFERR_Msk                       
#define FDCAN_ILS_MISC_Pos           (4U)
#define FDCAN_ILS_MISC_Msk           (0x1UL << FDCAN_ILS_MISC_Pos)             
#define FDCAN_ILS_MISC               FDCAN_ILS_MISC_Msk                        
#define FDCAN_ILS_BERR_Pos           (5U)
#define FDCAN_ILS_BERR_Msk           (0x1UL << FDCAN_ILS_BERR_Pos)             
#define FDCAN_ILS_BERR               FDCAN_ILS_BERR_Msk                        
#define FDCAN_ILS_PERR_Pos           (6U)
#define FDCAN_ILS_PERR_Msk           (0x1UL << FDCAN_ILS_PERR_Pos)             
#define FDCAN_ILS_PERR               FDCAN_ILS_PERR_Msk                        
#define FDCAN_ILE_EINT0_Pos          (0U)
#define FDCAN_ILE_EINT0_Msk          (0x1UL << FDCAN_ILE_EINT0_Pos)            
#define FDCAN_ILE_EINT0              FDCAN_ILE_EINT0_Msk                       
#define FDCAN_ILE_EINT1_Pos          (1U)
#define FDCAN_ILE_EINT1_Msk          (0x1UL << FDCAN_ILE_EINT1_Pos)            
#define FDCAN_ILE_EINT1              FDCAN_ILE_EINT1_Msk                       
#define FDCAN_RXGFC_RRFE_Pos         (0U)
#define FDCAN_RXGFC_RRFE_Msk         (0x1UL << FDCAN_RXGFC_RRFE_Pos)           
#define FDCAN_RXGFC_RRFE             FDCAN_RXGFC_RRFE_Msk                      
#define FDCAN_RXGFC_RRFS_Pos         (1U)
#define FDCAN_RXGFC_RRFS_Msk         (0x1UL << FDCAN_RXGFC_RRFS_Pos)           
#define FDCAN_RXGFC_RRFS             FDCAN_RXGFC_RRFS_Msk                      
#define FDCAN_RXGFC_ANFE_Pos         (2U)
#define FDCAN_RXGFC_ANFE_Msk         (0x3UL << FDCAN_RXGFC_ANFE_Pos)           
#define FDCAN_RXGFC_ANFE             FDCAN_RXGFC_ANFE_Msk                      
#define FDCAN_RXGFC_ANFS_Pos         (4U)
#define FDCAN_RXGFC_ANFS_Msk         (0x3UL << FDCAN_RXGFC_ANFS_Pos)           
#define FDCAN_RXGFC_ANFS             FDCAN_RXGFC_ANFS_Msk                      
#define FDCAN_RXGFC_F1OM_Pos         (8U)
#define FDCAN_RXGFC_F1OM_Msk         (0x1UL << FDCAN_RXGFC_F1OM_Pos)           
#define FDCAN_RXGFC_F1OM             FDCAN_RXGFC_F1OM_Msk                      
#define FDCAN_RXGFC_F0OM_Pos         (9U)
#define FDCAN_RXGFC_F0OM_Msk         (0x1UL << FDCAN_RXGFC_F0OM_Pos)           
#define FDCAN_RXGFC_F0OM             FDCAN_RXGFC_F0OM_Msk                      
#define FDCAN_RXGFC_LSS_Pos          (16U)
#define FDCAN_RXGFC_LSS_Msk          (0x1FUL << FDCAN_RXGFC_LSS_Pos)           
#define FDCAN_RXGFC_LSS              FDCAN_RXGFC_LSS_Msk                       
#define FDCAN_RXGFC_LSE_Pos          (24U)
#define FDCAN_RXGFC_LSE_Msk          (0xFUL << FDCAN_RXGFC_LSE_Pos)            
#define FDCAN_RXGFC_LSE              FDCAN_RXGFC_LSE_Msk                       
#define FDCAN_XIDAM_EIDM_Pos         (0U)
#define FDCAN_XIDAM_EIDM_Msk         (0x1FFFFFFFUL << FDCAN_XIDAM_EIDM_Pos)    
#define FDCAN_XIDAM_EIDM             FDCAN_XIDAM_EIDM_Msk                      
#define FDCAN_HPMS_BIDX_Pos          (0U)
#define FDCAN_HPMS_BIDX_Msk          (0x7UL << FDCAN_HPMS_BIDX_Pos)            
#define FDCAN_HPMS_BIDX              FDCAN_HPMS_BIDX_Msk                       
#define FDCAN_HPMS_MSI_Pos           (6U)
#define FDCAN_HPMS_MSI_Msk           (0x3UL << FDCAN_HPMS_MSI_Pos)             
#define FDCAN_HPMS_MSI               FDCAN_HPMS_MSI_Msk                        
#define FDCAN_HPMS_FIDX_Pos          (8U)
#define FDCAN_HPMS_FIDX_Msk          (0x1FUL << FDCAN_HPMS_FIDX_Pos)           
#define FDCAN_HPMS_FIDX              FDCAN_HPMS_FIDX_Msk                       
#define FDCAN_HPMS_FLST_Pos          (15U)
#define FDCAN_HPMS_FLST_Msk          (0x1UL << FDCAN_HPMS_FLST_Pos)            
#define FDCAN_HPMS_FLST              FDCAN_HPMS_FLST_Msk                       
#define FDCAN_RXF0S_F0FL_Pos         (0U)
#define FDCAN_RXF0S_F0FL_Msk         (0xFUL << FDCAN_RXF0S_F0FL_Pos)           
#define FDCAN_RXF0S_F0FL             FDCAN_RXF0S_F0FL_Msk                      
#define FDCAN_RXF0S_F0GI_Pos         (8U)
#define FDCAN_RXF0S_F0GI_Msk         (0x3UL << FDCAN_RXF0S_F0GI_Pos)           
#define FDCAN_RXF0S_F0GI             FDCAN_RXF0S_F0GI_Msk                      
#define FDCAN_RXF0S_F0PI_Pos         (16U)
#define FDCAN_RXF0S_F0PI_Msk         (0x3UL << FDCAN_RXF0S_F0PI_Pos)           
#define FDCAN_RXF0S_F0PI             FDCAN_RXF0S_F0PI_Msk                      
#define FDCAN_RXF0S_F0F_Pos          (24U)
#define FDCAN_RXF0S_F0F_Msk          (0x1UL << FDCAN_RXF0S_F0F_Pos)            
#define FDCAN_RXF0S_F0F              FDCAN_RXF0S_F0F_Msk                       
#define FDCAN_RXF0S_RF0L_Pos         (25U)
#define FDCAN_RXF0S_RF0L_Msk         (0x1UL << FDCAN_RXF0S_RF0L_Pos)           
#define FDCAN_RXF0S_RF0L             FDCAN_RXF0S_RF0L_Msk                      
#define FDCAN_RXF0A_F0AI_Pos         (0U)
#define FDCAN_RXF0A_F0AI_Msk         (0x7UL << FDCAN_RXF0A_F0AI_Pos)           
#define FDCAN_RXF0A_F0AI             FDCAN_RXF0A_F0AI_Msk                      
#define FDCAN_RXF1S_F1FL_Pos         (0U)
#define FDCAN_RXF1S_F1FL_Msk         (0xFUL << FDCAN_RXF1S_F1FL_Pos)           
#define FDCAN_RXF1S_F1FL             FDCAN_RXF1S_F1FL_Msk                      
#define FDCAN_RXF1S_F1GI_Pos         (8U)
#define FDCAN_RXF1S_F1GI_Msk         (0x3UL << FDCAN_RXF1S_F1GI_Pos)           
#define FDCAN_RXF1S_F1GI             FDCAN_RXF1S_F1GI_Msk                      
#define FDCAN_RXF1S_F1PI_Pos         (16U)
#define FDCAN_RXF1S_F1PI_Msk         (0x3UL << FDCAN_RXF1S_F1PI_Pos)           
#define FDCAN_RXF1S_F1PI             FDCAN_RXF1S_F1PI_Msk                      
#define FDCAN_RXF1S_F1F_Pos          (24U)
#define FDCAN_RXF1S_F1F_Msk          (0x1UL << FDCAN_RXF1S_F1F_Pos)            
#define FDCAN_RXF1S_F1F              FDCAN_RXF1S_F1F_Msk                       
#define FDCAN_RXF1S_RF1L_Pos         (25U)
#define FDCAN_RXF1S_RF1L_Msk         (0x1UL << FDCAN_RXF1S_RF1L_Pos)           
#define FDCAN_RXF1S_RF1L             FDCAN_RXF1S_RF1L_Msk                      
#define FDCAN_RXF1A_F1AI_Pos         (0U)
#define FDCAN_RXF1A_F1AI_Msk         (0x7UL << FDCAN_RXF1A_F1AI_Pos)           
#define FDCAN_RXF1A_F1AI             FDCAN_RXF1A_F1AI_Msk                      
#define FDCAN_TXBC_TFQM_Pos          (24U)
#define FDCAN_TXBC_TFQM_Msk          (0x1UL << FDCAN_TXBC_TFQM_Pos)            
#define FDCAN_TXBC_TFQM              FDCAN_TXBC_TFQM_Msk                       
#define FDCAN_TXFQS_TFFL_Pos         (0U)
#define FDCAN_TXFQS_TFFL_Msk         (0x7UL << FDCAN_TXFQS_TFFL_Pos)           
#define FDCAN_TXFQS_TFFL             FDCAN_TXFQS_TFFL_Msk                      
#define FDCAN_TXFQS_TFGI_Pos         (8U)
#define FDCAN_TXFQS_TFGI_Msk         (0x3UL << FDCAN_TXFQS_TFGI_Pos)           
#define FDCAN_TXFQS_TFGI             FDCAN_TXFQS_TFGI_Msk                      
#define FDCAN_TXFQS_TFQPI_Pos        (16U)
#define FDCAN_TXFQS_TFQPI_Msk        (0x3UL << FDCAN_TXFQS_TFQPI_Pos)          
#define FDCAN_TXFQS_TFQPI            FDCAN_TXFQS_TFQPI_Msk                     
#define FDCAN_TXFQS_TFQF_Pos         (21U)
#define FDCAN_TXFQS_TFQF_Msk         (0x1UL << FDCAN_TXFQS_TFQF_Pos)           
#define FDCAN_TXFQS_TFQF             FDCAN_TXFQS_TFQF_Msk                      
#define FDCAN_TXBRP_TRP_Pos          (0U)
#define FDCAN_TXBRP_TRP_Msk          (0x7UL << FDCAN_TXBRP_TRP_Pos)            
#define FDCAN_TXBRP_TRP              FDCAN_TXBRP_TRP_Msk                       
#define FDCAN_TXBAR_AR_Pos           (0U)
#define FDCAN_TXBAR_AR_Msk           (0x7UL << FDCAN_TXBAR_AR_Pos)             
#define FDCAN_TXBAR_AR               FDCAN_TXBAR_AR_Msk                        
#define FDCAN_TXBCR_CR_Pos           (0U)
#define FDCAN_TXBCR_CR_Msk           (0x7UL << FDCAN_TXBCR_CR_Pos)             
#define FDCAN_TXBCR_CR               FDCAN_TXBCR_CR_Msk                        
#define FDCAN_TXBTO_TO_Pos           (0U)
#define FDCAN_TXBTO_TO_Msk           (0x7UL << FDCAN_TXBTO_TO_Pos)             
#define FDCAN_TXBTO_TO               FDCAN_TXBTO_TO_Msk                        
#define FDCAN_TXBCF_CF_Pos           (0U)
#define FDCAN_TXBCF_CF_Msk           (0x7UL << FDCAN_TXBCF_CF_Pos)             
#define FDCAN_TXBCF_CF               FDCAN_TXBCF_CF_Msk                        
#define FDCAN_TXBTIE_TIE_Pos         (0U)
#define FDCAN_TXBTIE_TIE_Msk         (0x7UL << FDCAN_TXBTIE_TIE_Pos)           
#define FDCAN_TXBTIE_TIE             FDCAN_TXBTIE_TIE_Msk                      
#define FDCAN_TXBCIE_CFIE_Pos        (0U)
#define FDCAN_TXBCIE_CFIE_Msk        (0x7UL << FDCAN_TXBCIE_CFIE_Pos)          
#define FDCAN_TXBCIE_CFIE            FDCAN_TXBCIE_CFIE_Msk                     
#define FDCAN_TXEFS_EFFL_Pos         (0U)
#define FDCAN_TXEFS_EFFL_Msk         (0x7UL << FDCAN_TXEFS_EFFL_Pos)           
#define FDCAN_TXEFS_EFFL             FDCAN_TXEFS_EFFL_Msk                      
#define FDCAN_TXEFS_EFGI_Pos         (8U)
#define FDCAN_TXEFS_EFGI_Msk         (0x3UL << FDCAN_TXEFS_EFGI_Pos)           
#define FDCAN_TXEFS_EFGI             FDCAN_TXEFS_EFGI_Msk                      
#define FDCAN_TXEFS_EFPI_Pos         (16U)
#define FDCAN_TXEFS_EFPI_Msk         (0x3UL << FDCAN_TXEFS_EFPI_Pos)           
#define FDCAN_TXEFS_EFPI             FDCAN_TXEFS_EFPI_Msk                      
#define FDCAN_TXEFS_EFF_Pos          (24U)
#define FDCAN_TXEFS_EFF_Msk          (0x1UL << FDCAN_TXEFS_EFF_Pos)            
#define FDCAN_TXEFS_EFF              FDCAN_TXEFS_EFF_Msk                       
#define FDCAN_TXEFS_TEFL_Pos         (25U)
#define FDCAN_TXEFS_TEFL_Msk         (0x1UL << FDCAN_TXEFS_TEFL_Pos)           
#define FDCAN_TXEFS_TEFL             FDCAN_TXEFS_TEFL_Msk                      
#define FDCAN_TXEFA_EFAI_Pos         (0U)
#define FDCAN_TXEFA_EFAI_Msk         (0x3UL << FDCAN_TXEFA_EFAI_Pos)           
#define FDCAN_TXEFA_EFAI             FDCAN_TXEFA_EFAI_Msk                      
#define FDCAN_CKDIV_PDIV_Pos         (0U)
#define FDCAN_CKDIV_PDIV_Msk         (0xFUL << FDCAN_CKDIV_PDIV_Pos)           
#define FDCAN_CKDIV_PDIV             FDCAN_CKDIV_PDIV_Msk                      
