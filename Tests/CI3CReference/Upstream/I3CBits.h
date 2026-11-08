// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// From stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

#define I3C_CR_DCNT_Pos                     (0U)
#define I3C_CR_DCNT_Msk                     (0xFFFFUL << I3C_CR_DCNT_Pos)           /*!< 0x0000FFFF */
#define I3C_CR_DCNT                         I3C_CR_DCNT_Msk                         /*!< Data Byte Count */
#define I3C_CR_RNW_Pos                      (16U)
#define I3C_CR_RNW_Msk                      (0x1UL << I3C_CR_RNW_Pos)               /*!< 0x00010000 */
#define I3C_CR_RNW                          I3C_CR_RNW_Msk                          /*!< Read Not Write */
#define I3C_CR_CCC_Pos                      (16U)
#define I3C_CR_CCC_Msk                      (0xFFUL << I3C_CR_CCC_Pos)              /*!< 0x00FF0000 */
#define I3C_CR_CCC                          I3C_CR_CCC_Msk                          /*!< 8-Bit CCC code */
#define I3C_CR_ADD_Pos                      (17U)
#define I3C_CR_ADD_Msk                      (0x7FUL << I3C_CR_ADD_Pos)              /*!< 0x00FE0000 */
#define I3C_CR_ADD                          I3C_CR_ADD_Msk                          /*!< Target Address */
#define I3C_CR_MTYPE_Pos                    (27U)
#define I3C_CR_MTYPE_Msk                    (0xFUL << I3C_CR_MTYPE_Pos)             /*!< 0xF8000000 */
#define I3C_CR_MTYPE                        I3C_CR_MTYPE_Msk                        /*!< Message Type */
#define I3C_CR_MTYPE_0                      (0x1UL << I3C_CR_MTYPE_Pos)             /*!< 0x08000000 */
#define I3C_CR_MTYPE_1                      (0x2UL << I3C_CR_MTYPE_Pos)             /*!< 0x10000000 */
#define I3C_CR_MTYPE_2                      (0x4UL << I3C_CR_MTYPE_Pos)             /*!< 0x20000000 */
#define I3C_CR_MTYPE_3                      (0x8UL << I3C_CR_MTYPE_Pos)             /*!< 0x40000000 */
#define I3C_CR_MEND_Pos                     (31U)
#define I3C_CR_MEND_Msk                     (0x1UL << I3C_CR_MEND_Pos)              /*!< 0x80000000 */
#define I3C_CR_MEND                         I3C_CR_MEND_Msk                         /*!< Message End */
#define I3C_CFGR_EN_Pos                     (0U)
#define I3C_CFGR_EN_Msk                     (0x1UL << I3C_CFGR_EN_Pos)              /*!< 0x00000001 */
#define I3C_CFGR_EN                         I3C_CFGR_EN_Msk                         /*!< Peripheral Enable */
#define I3C_CFGR_CRINIT_Pos                 (1U)
#define I3C_CFGR_CRINIT_Msk                 (0x1UL << I3C_CFGR_CRINIT_Pos)          /*!< 0x00000002 */
#define I3C_CFGR_CRINIT                     I3C_CFGR_CRINIT_Msk                     /*!< Peripheral Init mode (Target/Controller) */
#define I3C_CFGR_NOARBH_Pos                 (2U)
#define I3C_CFGR_NOARBH_Msk                 (0x1UL << I3C_CFGR_NOARBH_Pos)          /*!< 0x00000004 */
#define I3C_CFGR_NOARBH                     I3C_CFGR_NOARBH_Msk                     /*!< No Arbitration Header (7'h7E)*/
#define I3C_CFGR_RSTPTRN_Pos                (3U)
#define I3C_CFGR_RSTPTRN_Msk                (0x1UL << I3C_CFGR_RSTPTRN_Pos)         /*!< 0x00000008 */
#define I3C_CFGR_RSTPTRN                    I3C_CFGR_RSTPTRN_Msk                    /*!< Reset Pattern enable */
#define I3C_CFGR_EXITPTRN_Pos               (4U)
#define I3C_CFGR_EXITPTRN_Msk               (0x1UL << I3C_CFGR_EXITPTRN_Pos)        /*!< 0x00000010 */
#define I3C_CFGR_EXITPTRN                   I3C_CFGR_EXITPTRN_Msk                   /*!< Exit Pattern enable */
#define I3C_CFGR_HKSDAEN_Pos                (5U)
#define I3C_CFGR_HKSDAEN_Msk                (0x1UL << I3C_CFGR_HKSDAEN_Pos)         /*!< 0x00000020 */
#define I3C_CFGR_HKSDAEN                    I3C_CFGR_HKSDAEN_Msk                    /*!< High-Keeper on SDA Enable */
#define I3C_CFGR_HJACK_Pos                  (7U)
#define I3C_CFGR_HJACK_Msk                  (0x1UL << I3C_CFGR_HJACK_Pos)           /*!< 0x00000080 */
#define I3C_CFGR_HJACK                      I3C_CFGR_HJACK_Msk                      /*!< Hot Join Acknowledgment */
#define I3C_CFGR_RXDMAEN_Pos                (8U)
#define I3C_CFGR_RXDMAEN_Msk                (0x1UL << I3C_CFGR_RXDMAEN_Pos)         /*!< 0x00000100 */
#define I3C_CFGR_RXDMAEN                    I3C_CFGR_RXDMAEN_Msk                    /*!< RX FIFO DMA mode Enable */
#define I3C_CFGR_RXFLUSH_Pos                (9U)
#define I3C_CFGR_RXFLUSH_Msk                (0x1UL << I3C_CFGR_RXFLUSH_Pos)         /*!< 0x00000200 */
#define I3C_CFGR_RXFLUSH                    I3C_CFGR_RXFLUSH_Msk                    /*!< RX FIFO Flush */
#define I3C_CFGR_RXTHRES_Pos                (10U)
#define I3C_CFGR_RXTHRES_Msk                (0x1UL << I3C_CFGR_RXTHRES_Pos)         /*!< 0x00000400 */
#define I3C_CFGR_RXTHRES                    I3C_CFGR_RXTHRES_Msk                    /*!< RX FIFO Threshold */
#define I3C_CFGR_TXDMAEN_Pos                (12U)
#define I3C_CFGR_TXDMAEN_Msk                (0x1UL << I3C_CFGR_TXDMAEN_Pos)         /*!< 0x00001000 */
#define I3C_CFGR_TXDMAEN                    I3C_CFGR_TXDMAEN_Msk                    /*!< TX FIFO DMA mode Enable */
#define I3C_CFGR_TXFLUSH_Pos                (13U)
#define I3C_CFGR_TXFLUSH_Msk                (0x1UL << I3C_CFGR_TXFLUSH_Pos)         /*!< 0x00002000 */
#define I3C_CFGR_TXFLUSH                    I3C_CFGR_TXFLUSH_Msk                    /*!< TX FIFO Flush */
#define I3C_CFGR_TXTHRES_Pos                (14U)
#define I3C_CFGR_TXTHRES_Msk                (0x1UL << I3C_CFGR_TXTHRES_Pos)         /*!< 0x00004000 */
#define I3C_CFGR_TXTHRES                    I3C_CFGR_TXTHRES_Msk                    /*!< TX FIFO Threshold */
#define I3C_CFGR_SDMAEN_Pos                 (16U)
#define I3C_CFGR_SDMAEN_Msk                 (0x1UL << I3C_CFGR_SDMAEN_Pos)          /*!< 0x00010000 */
#define I3C_CFGR_SDMAEN                     I3C_CFGR_SDMAEN_Msk                     /*!< Status FIFO DMA mode Enable */
#define I3C_CFGR_SFLUSH_Pos                 (17U)
#define I3C_CFGR_SFLUSH_Msk                 (0x1UL << I3C_CFGR_SFLUSH_Pos)          /*!< 0x00020000 */
#define I3C_CFGR_SFLUSH                     I3C_CFGR_SFLUSH_Msk                     /*!< Status FIFO Flush */
#define I3C_CFGR_SMODE_Pos                  (18U)
#define I3C_CFGR_SMODE_Msk                  (0x1UL << I3C_CFGR_SMODE_Pos)           /*!< 0x00040000 */
#define I3C_CFGR_SMODE                      I3C_CFGR_SMODE_Msk                      /*!< Status FIFO mode Enable */
#define I3C_CFGR_TMODE_Pos                  (19U)
#define I3C_CFGR_TMODE_Msk                  (0x1UL << I3C_CFGR_TMODE_Pos)           /*!< 0x00080000 */
#define I3C_CFGR_TMODE                      I3C_CFGR_TMODE_Msk                      /*!< Control FIFO mode Enable */
#define I3C_CFGR_CDMAEN_Pos                 (20U)
#define I3C_CFGR_CDMAEN_Msk                 (0x1UL << I3C_CFGR_CDMAEN_Pos)          /*!< 0x00100000 */
#define I3C_CFGR_CDMAEN                     I3C_CFGR_CDMAEN_Msk                     /*!< Control FIFO DMA mode Enable */
#define I3C_CFGR_CFLUSH_Pos                 (21U)
#define I3C_CFGR_CFLUSH_Msk                 (0x1UL << I3C_CFGR_CFLUSH_Pos)          /*!< 0x00200000 */
#define I3C_CFGR_CFLUSH                     I3C_CFGR_CFLUSH_Msk                     /*!< Control FIFO Flush */
#define I3C_CFGR_TSFSET_Pos                 (30U)
#define I3C_CFGR_TSFSET_Msk                 (0x1UL << I3C_CFGR_TSFSET_Pos)          /*!< 0x40000000 */
#define I3C_CFGR_TSFSET                     I3C_CFGR_TSFSET_Msk                     /*!< Transfer Set */
#define I3C_RDR_RDB0_Pos                    (0U)
#define I3C_RDR_RDB0_Msk                    (0xFFUL << I3C_RDR_RDB0_Pos)            /*!< 0x000000FF */
#define I3C_RDR_RDB0                        I3C_RDR_RDB0_Msk                        /*!< Receive Data Byte */
#define I3C_RDWR_RDBx_Pos                   (0U)
#define I3C_RDWR_RDBx_Msk                   (0xFFFFFFFFUL << I3C_RDWR_RDBx_Pos)     /*!< 0xFFFFFFFF */
#define I3C_RDWR_RDBx                       I3C_RDWR_RDBx_Msk                       /*!< Receive Data Byte, full double word */
#define I3C_RDWR_RDB0_Pos                   (0U)
#define I3C_RDWR_RDB0_Msk                   (0xFFUL << I3C_RDWR_RDB0_Pos)           /*!< 0x000000FF */
#define I3C_RDWR_RDB0                       I3C_RDWR_RDB0_Msk                       /*!< Receive Data Byte 0 */
#define I3C_RDWR_RDB1_Pos                   (8U)
#define I3C_RDWR_RDB1_Msk                   (0xFFUL << I3C_RDWR_RDB1_Pos)           /*!< 0x0000FF00 */
#define I3C_RDWR_RDB1                       I3C_RDWR_RDB1_Msk                       /*!< Receive Data Byte 1 */
#define I3C_RDWR_RDB2_Pos                   (16U)
#define I3C_RDWR_RDB2_Msk                   (0xFFUL << I3C_RDWR_RDB2_Pos)           /*!< 0x00FF0000 */
#define I3C_RDWR_RDB2                       I3C_RDWR_RDB2_Msk                       /*!< Receive Data Byte 2 */
#define I3C_RDWR_RDB3_Pos                   (24U)
#define I3C_RDWR_RDB3_Msk                   (0xFFUL << I3C_RDWR_RDB3_Pos)           /*!< 0xFF000000 */
#define I3C_RDWR_RDB3                       I3C_RDWR_RDB3_Msk                       /*!< Receive Data Byte 3 */
#define I3C_TDR_TDB0_Pos                    (0U)
#define I3C_TDR_TDB0_Msk                    (0xFFUL << I3C_TDR_TDB0_Pos)            /*!< 0x000000FF */
#define I3C_TDR_TDB0                        I3C_TDR_TDB0_Msk                        /*!< Transmit Data Byte */
#define I3C_TDWR_TDBx_Pos                   (0U)
#define I3C_TDWR_TDBx_Msk                   (0xFFFFFFFFUL << I3C_TDWR_TDBx_Pos)     /*!< 0xFFFFFFFF */
#define I3C_TDWR_TDBx                       I3C_TDWR_TDBx_Msk                       /*!< Transmit Data Byte, full double word */
#define I3C_TDWR_TDB0_Pos                   (0U)
#define I3C_TDWR_TDB0_Msk                   (0xFFUL << I3C_TDWR_TDB0_Pos)           /*!< 0x000000FF */
#define I3C_TDWR_TDB0                       I3C_TDWR_TDB0_Msk                       /*!< Transmit Data Byte 0 */
#define I3C_TDWR_TDB1_Pos                   (8U)
#define I3C_TDWR_TDB1_Msk                   (0xFFUL << I3C_TDWR_TDB1_Pos)           /*!< 0x0000FF00 */
#define I3C_TDWR_TDB1                       I3C_TDWR_TDB1_Msk                       /*!< Transmit Data Byte 1 */
#define I3C_TDWR_TDB2_Pos                   (16U)
#define I3C_TDWR_TDB2_Msk                   (0xFFUL << I3C_TDWR_TDB2_Pos)           /*!< 0x00FF0000 */
#define I3C_TDWR_TDB2                       I3C_TDWR_TDB2_Msk                       /*!< Transmit Data Byte 2 */
#define I3C_TDWR_TDB3_Pos                   (24U)
#define I3C_TDWR_TDB3_Msk                   (0xFFUL << I3C_TDWR_TDB3_Pos)           /*!< 0xFF000000 */
#define I3C_TDWR_TDB3                       I3C_TDWR_TDB3_Msk                       /*!< Transmit Data Byte 3 */
#define I3C_IBIDR_IBIDBx_Pos                (0U)
#define I3C_IBIDR_IBIDBx_Msk                (0xFFFFFFFFUL << I3C_IBIDR_IBIDBx_Pos)  /*!< 0xFFFFFFFF */
#define I3C_IBIDR_IBIDBx                    I3C_IBIDR_IBIDBx_Msk                    /*!< IBI Data Byte, full double word */
#define I3C_IBIDR_IBIDB0_Pos                (0U)
#define I3C_IBIDR_IBIDB0_Msk                (0xFFUL << I3C_IBIDR_IBIDB0_Pos)        /*!< 0x000000FF */
#define I3C_IBIDR_IBIDB0                    I3C_IBIDR_IBIDB0_Msk                    /*!< IBI Data Byte 0 */
#define I3C_IBIDR_IBIDB1_Pos                (8U)
#define I3C_IBIDR_IBIDB1_Msk                (0xFFUL << I3C_IBIDR_IBIDB1_Pos)        /*!< 0x0000FF00 */
#define I3C_IBIDR_IBIDB1                    I3C_IBIDR_IBIDB1_Msk                    /*!< IBI Data Byte 1 */
#define I3C_IBIDR_IBIDB2_Pos                (16U)
#define I3C_IBIDR_IBIDB2_Msk                (0xFFUL << I3C_IBIDR_IBIDB2_Pos)        /*!< 0x00FF0000 */
#define I3C_IBIDR_IBIDB2                    I3C_IBIDR_IBIDB2_Msk                    /*!< IBI Data Byte 2 */
#define I3C_IBIDR_IBIDB3_Pos                (24U)
#define I3C_IBIDR_IBIDB3_Msk                (0xFFUL << I3C_IBIDR_IBIDB3_Pos)        /*!< 0xFF000000 */
#define I3C_IBIDR_IBIDB3                    I3C_IBIDR_IBIDB3_Msk                    /*!< IBI Data Byte 3 */
#define I3C_TGTTDR_TGTTDCNT_Pos             (0U)
#define I3C_TGTTDR_TGTTDCNT_Msk             (0xFFFFUL << I3C_TGTTDR_TGTTDCNT_Pos)   /*!< 0x0000FFFF */
#define I3C_TGTTDR_TGTTDCNT                 I3C_TGTTDR_TGTTDCNT_Msk                 /*!< Target Transmit Data Counter */
#define I3C_TGTTDR_PRELOAD_Pos              (16U)
#define I3C_TGTTDR_PRELOAD_Msk              (0x1UL << I3C_TGTTDR_PRELOAD_Pos)       /*!< 0x00010000 */
#define I3C_TGTTDR_PRELOAD                  I3C_TGTTDR_PRELOAD_Msk                  /*!< Transmit FIFO Preload Enable/Status */
#define I3C_SR_XDCNT_Pos                    (0U)
#define I3C_SR_XDCNT_Msk                    (0xFFFFUL << I3C_SR_XDCNT_Pos)          /*!< 0x0000FFFF */
#define I3C_SR_XDCNT                        I3C_SR_XDCNT_Msk                        /*!< Transfer Data Byte Count status */
#define I3C_SR_ABT_Pos                      (17U)
#define I3C_SR_ABT_Msk                      (0x1UL << I3C_SR_ABT_Pos)               /*!< 0x00020000 */
#define I3C_SR_ABT                          I3C_SR_ABT_Msk                          /*!< Target Abort Indication */
#define I3C_SR_DIR_Pos                      (18U)
#define I3C_SR_DIR_Msk                      (0x1UL << I3C_SR_DIR_Pos)               /*!< 0x00040000 */
#define I3C_SR_DIR                          I3C_SR_DIR_Msk                          /*!< Message Direction */
#define I3C_SR_MID_Pos                      (24U)
#define I3C_SR_MID_Msk                      (0xFFUL << I3C_SR_MID_Pos)              /*!< 0xFF000000 */
#define I3C_SR_MID                          I3C_SR_MID_Msk                          /*!< Message Identifier */
#define I3C_SER_CODERR_Pos                  (0U)
#define I3C_SER_CODERR_Msk                  (0xFUL << I3C_SER_CODERR_Pos)           /*!< 0x0000000F */
#define I3C_SER_CODERR                      I3C_SER_CODERR_Msk                      /*!< Protocol Error Code */
#define I3C_SER_CODERR_0                    (0x1UL << I3C_SER_CODERR_Pos)           /*!< 0x00000001 */
#define I3C_SER_CODERR_1                    (0x2UL << I3C_SER_CODERR_Pos)           /*!< 0x00000002 */
#define I3C_SER_CODERR_2                    (0x4UL << I3C_SER_CODERR_Pos)           /*!< 0x00000004 */
#define I3C_SER_CODERR_3                    (0x8UL << I3C_SER_CODERR_Pos)           /*!< 0x00000008 */
#define I3C_SER_PERR_Pos                    (4U)
#define I3C_SER_PERR_Msk                    (0x1UL << I3C_SER_PERR_Pos)             /*!< 0x00000010 */
#define I3C_SER_PERR                        I3C_SER_PERR_Msk                        /*!< Protocol Error */
#define I3C_SER_STALL_Pos                   (5U)
#define I3C_SER_STALL_Msk                   (0x1UL << I3C_SER_STALL_Pos)            /*!< 0x00000020 */
#define I3C_SER_STALL                       I3C_SER_STALL_Msk                       /*!< SCL Stall Error */
#define I3C_SER_DOVR_Pos                    (6U)
#define I3C_SER_DOVR_Msk                    (0x1UL << I3C_SER_DOVR_Pos)             /*!< 0x00000040 */
#define I3C_SER_DOVR                        I3C_SER_DOVR_Msk                        /*!< RX/TX FIFO Overrun */
#define I3C_SER_COVR_Pos                    (7U)
#define I3C_SER_COVR_Msk                    (0x1UL << I3C_SER_COVR_Pos)             /*!< 0x00000080 */
#define I3C_SER_COVR                        I3C_SER_COVR_Msk                        /*!< Status/Control FIFO Overrun */
#define I3C_SER_ANACK_Pos                   (8U)
#define I3C_SER_ANACK_Msk                   (0x1UL << I3C_SER_ANACK_Pos)            /*!< 0x00000100 */
#define I3C_SER_ANACK                       I3C_SER_ANACK_Msk                       /*!< Address Not Acknowledged */
#define I3C_SER_DNACK_Pos                   (9U)
#define I3C_SER_DNACK_Msk                   (0x1UL << I3C_SER_DNACK_Pos)            /*!< 0x00000200 */
#define I3C_SER_DNACK                       I3C_SER_DNACK_Msk                       /*!< Data Not Acknowledged */
#define I3C_SER_DERR_Pos                    (10U)
#define I3C_SER_DERR_Msk                    (0x1UL << I3C_SER_DERR_Pos)             /*!< 0x00000400 */
#define I3C_SER_DERR                        I3C_SER_DERR_Msk                        /*!< Data Error during the controller-role hand-off procedure */
#define I3C_RMR_IBIRDCNT_Pos                (0U)
#define I3C_RMR_IBIRDCNT_Msk                (0x7UL << I3C_RMR_IBIRDCNT_Pos)         /*!< 0x00000007 */
#define I3C_RMR_IBIRDCNT                    I3C_RMR_IBIRDCNT_Msk                    /*!< Data Count when reading IBI data */
#define I3C_RMR_RCODE_Pos                   (8U)
#define I3C_RMR_RCODE_Msk                   (0xFFUL << I3C_RMR_RCODE_Pos)           /*!< 0x0000FF00 */
#define I3C_RMR_RCODE                       I3C_RMR_RCODE_Msk                       /*!< CCC code of received command */
#define I3C_RMR_RADD_Pos                    (17U)
#define I3C_RMR_RADD_Msk                    (0x7FUL << I3C_RMR_RADD_Pos)            /*!< 0x00FE0000 */
#define I3C_RMR_RADD                        I3C_RMR_RADD_Msk                        /*!< Target Address Received during accepted IBI or Controller-role request */
#define I3C_EVR_CFEF_Pos                    (0U)
#define I3C_EVR_CFEF_Msk                    (0x1UL << I3C_EVR_CFEF_Pos)             /*!< 0x00000001 */
#define I3C_EVR_CFEF                        I3C_EVR_CFEF_Msk                        /*!< Control FIFO Empty Flag */
#define I3C_EVR_TXFEF_Pos                   (1U)
#define I3C_EVR_TXFEF_Msk                   (0x1UL << I3C_EVR_TXFEF_Pos)            /*!< 0x00000002 */
#define I3C_EVR_TXFEF                       I3C_EVR_TXFEF_Msk                       /*!< TX FIFO Empty Flag */
#define I3C_EVR_CFNFF_Pos                   (2U)
#define I3C_EVR_CFNFF_Msk                   (0x1UL << I3C_EVR_CFNFF_Pos)            /*!< 0x00000004 */
#define I3C_EVR_CFNFF                       I3C_EVR_CFNFF_Msk                       /*!< Control FIFO Not Full Flag */
#define I3C_EVR_SFNEF_Pos                   (3U)
#define I3C_EVR_SFNEF_Msk                   (0x1UL << I3C_EVR_SFNEF_Pos)            /*!< 0x00000008 */
#define I3C_EVR_SFNEF                       I3C_EVR_SFNEF_Msk                       /*!< Status FIFO Not Empty Flag */
#define I3C_EVR_TXFNFF_Pos                  (4U)
#define I3C_EVR_TXFNFF_Msk                  (0x1UL << I3C_EVR_TXFNFF_Pos)           /*!< 0x00000010 */
#define I3C_EVR_TXFNFF                      I3C_EVR_TXFNFF_Msk                      /*!< TX FIFO Not Full Flag */
#define I3C_EVR_RXFNEF_Pos                  (5U)
#define I3C_EVR_RXFNEF_Msk                  (0x1UL << I3C_EVR_RXFNEF_Pos)           /*!< 0x00000020 */
#define I3C_EVR_RXFNEF                      I3C_EVR_RXFNEF_Msk                      /*!< RX FIFO Not Empty Flag */
#define I3C_EVR_TXLASTF_Pos                 (6U)
#define I3C_EVR_TXLASTF_Msk                 (0x1UL << I3C_EVR_TXLASTF_Pos)          /*!< 0x00000040 */
#define I3C_EVR_TXLASTF                     I3C_EVR_TXLASTF_Msk                     /*!< Last TX byte available in FIFO */
#define I3C_EVR_RXLASTF_Pos                 (7U)
#define I3C_EVR_RXLASTF_Msk                 (0x1UL << I3C_EVR_RXLASTF_Pos)          /*!< 0x00000080 */
#define I3C_EVR_RXLASTF                     I3C_EVR_RXLASTF_Msk                     /*!< Last RX byte read from FIFO */
#define I3C_EVR_FCF_Pos                     (9U)
#define I3C_EVR_FCF_Msk                     (0x1UL << I3C_EVR_FCF_Pos)              /*!< 0x00000200 */
#define I3C_EVR_FCF                         I3C_EVR_FCF_Msk                         /*!< Frame Complete Flag */
#define I3C_EVR_RXTGTENDF_Pos               (10U)
#define I3C_EVR_RXTGTENDF_Msk               (0x1UL << I3C_EVR_RXTGTENDF_Pos)        /*!< 0x00000400 */
#define I3C_EVR_RXTGTENDF                   I3C_EVR_RXTGTENDF_Msk                   /*!< Reception Target End Flag */
#define I3C_EVR_ERRF_Pos                    (11U)
#define I3C_EVR_ERRF_Msk                    (0x1UL << I3C_EVR_ERRF_Pos)             /*!< 0x00000800 */
#define I3C_EVR_ERRF                        I3C_EVR_ERRF_Msk                        /*!< Error Flag */
#define I3C_EVR_IBIF_Pos                    (15U)
#define I3C_EVR_IBIF_Msk                    (0x1UL << I3C_EVR_IBIF_Pos)             /*!< 0x00008000 */
#define I3C_EVR_IBIF                        I3C_EVR_IBIF_Msk                        /*!< IBI Flag */
#define I3C_EVR_IBIENDF_Pos                 (16U)
#define I3C_EVR_IBIENDF_Msk                 (0x1UL << I3C_EVR_IBIENDF_Pos)          /*!< 0x00010000 */
#define I3C_EVR_IBIENDF                     I3C_EVR_IBIENDF_Msk                     /*!< IBI End Flag */
#define I3C_EVR_CRF_Pos                     (17U)
#define I3C_EVR_CRF_Msk                     (0x1UL << I3C_EVR_CRF_Pos)              /*!< 0x00020000 */
#define I3C_EVR_CRF                         I3C_EVR_CRF_Msk                         /*!< Controller-role Request Flag */
#define I3C_EVR_CRUPDF_Pos                  (18U)
#define I3C_EVR_CRUPDF_Msk                  (0x1UL << I3C_EVR_CRUPDF_Pos)           /*!< 0x00040000 */
#define I3C_EVR_CRUPDF                      I3C_EVR_CRUPDF_Msk                      /*!< Controller-role Update Flag */
#define I3C_EVR_HJF_Pos                     (19U)
#define I3C_EVR_HJF_Msk                     (0x1UL << I3C_EVR_HJF_Pos)              /*!< 0x00080000 */
#define I3C_EVR_HJF                         I3C_EVR_HJF_Msk                         /*!< Hot Join Flag */
#define I3C_EVR_WKPF_Pos                    (21U)
#define I3C_EVR_WKPF_Msk                    (0x1UL << I3C_EVR_WKPF_Pos)             /*!< 0x00200000 */
#define I3C_EVR_WKPF                        I3C_EVR_WKPF_Msk                        /*!< Wake Up Flag */
#define I3C_EVR_GETF_Pos                    (22U)
#define I3C_EVR_GETF_Msk                    (0x1UL << I3C_EVR_GETF_Pos)             /*!< 0x00400000 */
#define I3C_EVR_GETF                        I3C_EVR_GETF_Msk                        /*!< Get type CCC received Flag */
#define I3C_EVR_STAF_Pos                    (23U)
#define I3C_EVR_STAF_Msk                    (0x1UL << I3C_EVR_STAF_Pos)             /*!< 0x00800000 */
#define I3C_EVR_STAF                        I3C_EVR_STAF_Msk                        /*!< Get Status Flag */
#define I3C_EVR_DAUPDF_Pos                  (24U)
#define I3C_EVR_DAUPDF_Msk                  (0x1UL << I3C_EVR_DAUPDF_Pos)           /*!< 0x01000000 */
#define I3C_EVR_DAUPDF                      I3C_EVR_DAUPDF_Msk                      /*!< Dynamic Address Update Flag */
#define I3C_EVR_MWLUPDF_Pos                 (25U)
#define I3C_EVR_MWLUPDF_Msk                 (0x1UL << I3C_EVR_MWLUPDF_Pos)          /*!< 0x02000000 */
#define I3C_EVR_MWLUPDF                     I3C_EVR_MWLUPDF_Msk                     /*!< Max Write Length Update Flag */
#define I3C_EVR_MRLUPDF_Pos                 (26U)
#define I3C_EVR_MRLUPDF_Msk                 (0x1UL << I3C_EVR_MRLUPDF_Pos)          /*!< 0x04000000 */
#define I3C_EVR_MRLUPDF                     I3C_EVR_MRLUPDF_Msk                     /*!< Max Read Length Update Flag */
#define I3C_EVR_RSTF_Pos                    (27U)
#define I3C_EVR_RSTF_Msk                    (0x1UL << I3C_EVR_RSTF_Pos)             /*!< 0x08000000 */
#define I3C_EVR_RSTF                        I3C_EVR_RSTF_Msk                        /*!< Reset Flag, due to Reset pattern received */
#define I3C_EVR_ASUPDF_Pos                  (28U)
#define I3C_EVR_ASUPDF_Msk                  (0x1UL << I3C_EVR_ASUPDF_Pos)           /*!< 0x10000000 */
#define I3C_EVR_ASUPDF                      I3C_EVR_ASUPDF_Msk                      /*!< Activity State Flag */
#define I3C_EVR_INTUPDF_Pos                 (29U)
#define I3C_EVR_INTUPDF_Msk                 (0x1UL << I3C_EVR_INTUPDF_Pos)          /*!< 0x20000000 */
#define I3C_EVR_INTUPDF                     I3C_EVR_INTUPDF_Msk                     /*!< Interrupt Update Flag */
#define I3C_EVR_DEFF_Pos                    (30U)
#define I3C_EVR_DEFF_Msk                    (0x1UL << I3C_EVR_DEFF_Pos)             /*!< 0x40000000 */
#define I3C_EVR_DEFF                        I3C_EVR_DEFF_Msk                        /*!< List of Targets Command Received Flag */
#define I3C_EVR_GRPF_Pos                    (31U)
#define I3C_EVR_GRPF_Msk                    (0x1UL << I3C_EVR_GRPF_Pos)             /*!< 0x80000000 */
#define I3C_EVR_GRPF                        I3C_EVR_GRPF_Msk                        /*!< List of Group Addresses Command Received Flag */
#define I3C_IER_CFNFIE_Pos                  (2U)
#define I3C_IER_CFNFIE_Msk                  (0x1UL << I3C_IER_CFNFIE_Pos)           /*!< 0x00000004 */
#define I3C_IER_CFNFIE                      I3C_IER_CFNFIE_Msk                      /*!< Control FIFO Not Full Interrupt Enable */
#define I3C_IER_SFNEIE_Pos                  (3U)
#define I3C_IER_SFNEIE_Msk                  (0x1UL << I3C_IER_SFNEIE_Pos)           /*!< 0x00000008 */
#define I3C_IER_SFNEIE                      I3C_IER_SFNEIE_Msk                      /*!< Status FIFO Not Empty Interrupt Enable */
#define I3C_IER_TXFNFIE_Pos                 (4U)
#define I3C_IER_TXFNFIE_Msk                 (0x1UL << I3C_IER_TXFNFIE_Pos)          /*!< 0x00000010 */
#define I3C_IER_TXFNFIE                     I3C_IER_TXFNFIE_Msk                     /*!< TX FIFO Not Full Interrupt Enable */
#define I3C_IER_RXFNEIE_Pos                 (5U)
#define I3C_IER_RXFNEIE_Msk                 (0x1UL << I3C_IER_RXFNEIE_Pos)          /*!< 0x00000020 */
#define I3C_IER_RXFNEIE                     I3C_IER_RXFNEIE_Msk                     /*!< RX FIFO Not Empty Interrupt Enable */
#define I3C_IER_FCIE_Pos                    (9U)
#define I3C_IER_FCIE_Msk                    (0x1UL << I3C_IER_FCIE_Pos)             /*!< 0x00000200 */
#define I3C_IER_FCIE                        I3C_IER_FCIE_Msk                        /*!< Frame Complete Interrupt Enable */
#define I3C_IER_RXTGTENDIE_Pos              (10U)
#define I3C_IER_RXTGTENDIE_Msk              (0x1UL << I3C_IER_RXTGTENDIE_Pos)       /*!< 0x00000400 */
#define I3C_IER_RXTGTENDIE                  I3C_IER_RXTGTENDIE_Msk                  /*!< Reception Target End Interrupt Enable */
#define I3C_IER_ERRIE_Pos                   (11U)
#define I3C_IER_ERRIE_Msk                   (0x1UL << I3C_IER_ERRIE_Pos)            /*!< 0x00000800 */
#define I3C_IER_ERRIE                       I3C_IER_ERRIE_Msk                       /*!< Error Interrupt Enable */
#define I3C_IER_IBIIE_Pos                   (15U)
#define I3C_IER_IBIIE_Msk                   (0x1UL << I3C_IER_IBIIE_Pos)            /*!< 0x00008000 */
#define I3C_IER_IBIIE                       I3C_IER_IBIIE_Msk                       /*!< IBI Interrupt Enable */
#define I3C_IER_IBIENDIE_Pos                (16U)
#define I3C_IER_IBIENDIE_Msk                (0x1UL << I3C_IER_IBIENDIE_Pos)         /*!< 0x00010000 */
#define I3C_IER_IBIENDIE                    I3C_IER_IBIENDIE_Msk                    /*!< IBI End Interrupt Enable */
#define I3C_IER_CRIE_Pos                    (17U)
#define I3C_IER_CRIE_Msk                    (0x1UL << I3C_IER_CRIE_Pos)             /*!< 0x00020000 */
#define I3C_IER_CRIE                        I3C_IER_CRIE_Msk                        /*!< Controller-role Interrupt Enable */
#define I3C_IER_CRUPDIE_Pos                 (18U)
#define I3C_IER_CRUPDIE_Msk                 (0x1UL << I3C_IER_CRUPDIE_Pos)          /*!< 0x00040000 */
#define I3C_IER_CRUPDIE                     I3C_IER_CRUPDIE_Msk                     /*!< Controller-role Update Interrupt Enable */
#define I3C_IER_HJIE_Pos                    (19U)
#define I3C_IER_HJIE_Msk                    (0x1UL << I3C_IER_HJIE_Pos)             /*!< 0x00080000 */
#define I3C_IER_HJIE                        I3C_IER_HJIE_Msk                        /*!< Hot Join Interrupt Enable */
#define I3C_IER_WKPIE_Pos                   (21U)
#define I3C_IER_WKPIE_Msk                   (0x1UL << I3C_IER_WKPIE_Pos)            /*!< 0x00200000 */
#define I3C_IER_WKPIE                       I3C_IER_WKPIE_Msk                       /*!< Wake Up Interrupt Enable */
#define I3C_IER_GETIE_Pos                   (22U)
#define I3C_IER_GETIE_Msk                   (0x1UL << I3C_IER_GETIE_Pos)            /*!< 0x00400000 */
#define I3C_IER_GETIE                       I3C_IER_GETIE_Msk                       /*!< Get type CCC received Interrupt Enable */
#define I3C_IER_STAIE_Pos                   (23U)
#define I3C_IER_STAIE_Msk                   (0x1UL << I3C_IER_STAIE_Pos)            /*!< 0x00800000 */
#define I3C_IER_STAIE                       I3C_IER_STAIE_Msk                       /*!< Get Status Interrupt Enable */
#define I3C_IER_DAUPDIE_Pos                 (24U)
#define I3C_IER_DAUPDIE_Msk                 (0x1UL << I3C_IER_DAUPDIE_Pos)          /*!< 0x01000000 */
#define I3C_IER_DAUPDIE                     I3C_IER_DAUPDIE_Msk                     /*!< Dynamic Address Update Interrupt Enable */
#define I3C_IER_MWLUPDIE_Pos                (25U)
#define I3C_IER_MWLUPDIE_Msk                (0x1UL << I3C_IER_MWLUPDIE_Pos)         /*!< 0x02000000 */
#define I3C_IER_MWLUPDIE                    I3C_IER_MWLUPDIE_Msk                    /*!< Max Write Length Update Interrupt Enable */
#define I3C_IER_MRLUPDIE_Pos                (26U)
#define I3C_IER_MRLUPDIE_Msk                (0x1UL << I3C_IER_MRLUPDIE_Pos)         /*!< 0x04000000 */
#define I3C_IER_MRLUPDIE                    I3C_IER_MRLUPDIE_Msk                    /*!< Max Read Length Update Interrupt Enable */
#define I3C_IER_RSTIE_Pos                   (27U)
#define I3C_IER_RSTIE_Msk                   (0x1UL << I3C_IER_RSTIE_Pos)            /*!< 0x08000000 */
#define I3C_IER_RSTIE                       I3C_IER_RSTIE_Msk                       /*!< Reset Interrupt Enabled, due to Reset pattern received */
#define I3C_IER_ASUPDIE_Pos                 (28U)
#define I3C_IER_ASUPDIE_Msk                 (0x1UL << I3C_IER_ASUPDIE_Pos)          /*!< 0x10000000 */
#define I3C_IER_ASUPDIE                     I3C_IER_ASUPDIE_Msk                     /*!< Activity State Interrupt Enable */
#define I3C_IER_INTUPDIE_Pos                (29U)
#define I3C_IER_INTUPDIE_Msk                (0x1UL << I3C_IER_INTUPDIE_Pos)         /*!< 0x20000000 */
#define I3C_IER_INTUPDIE                    I3C_IER_INTUPDIE_Msk                    /*!< Interrupt Update Interrupt Enable */
#define I3C_IER_DEFIE_Pos                   (30U)
#define I3C_IER_DEFIE_Msk                   (0x1UL << I3C_IER_DEFIE_Pos)            /*!< 0x40000000 */
#define I3C_IER_DEFIE                       I3C_IER_DEFIE_Msk                       /*!< List of Targets Command Received Interrupt Enable */
#define I3C_IER_GRPIE_Pos                   (31U)
#define I3C_IER_GRPIE_Msk                   (0x1UL << I3C_IER_GRPIE_Pos)            /*!< 0x80000000 */
#define I3C_IER_GRPIE                       I3C_IER_GRPIE_Msk                       /*!< List of Group Addresses Command Received Interrupt Enable */
#define I3C_CEVR_CFCF_Pos                   (9U)
#define I3C_CEVR_CFCF_Msk                   (0x1UL << I3C_CEVR_CFCF_Pos)            /*!< 0x00000200 */
#define I3C_CEVR_CFCF                       I3C_CEVR_CFCF_Msk                       /*!< Frame Complete Clear Flag */
#define I3C_CEVR_CRXTGTENDF_Pos             (10U)
#define I3C_CEVR_CRXTGTENDF_Msk             (0x1UL << I3C_CEVR_CRXTGTENDF_Pos)      /*!< 0x00000400 */
#define I3C_CEVR_CRXTGTENDF                 I3C_CEVR_CRXTGTENDF_Msk                 /*!< Reception Target End Clear Flag */
#define I3C_CEVR_CERRF_Pos                  (11U)
#define I3C_CEVR_CERRF_Msk                  (0x1UL << I3C_CEVR_CERRF_Pos)           /*!< 0x00000800 */
#define I3C_CEVR_CERRF                      I3C_CEVR_CERRF_Msk                      /*!< Error Clear Flag */
#define I3C_CEVR_CIBIF_Pos                  (15U)
#define I3C_CEVR_CIBIF_Msk                  (0x1UL << I3C_CEVR_CIBIF_Pos)           /*!< 0x00008000 */
#define I3C_CEVR_CIBIF                      I3C_CEVR_CIBIF_Msk                      /*!< IBI Clear Flag */
#define I3C_CEVR_CIBIENDF_Pos               (16U)
#define I3C_CEVR_CIBIENDF_Msk               (0x1UL << I3C_CEVR_CIBIENDF_Pos)        /*!< 0x00010000 */
#define I3C_CEVR_CIBIENDF                   I3C_CEVR_CIBIENDF_Msk                   /*!< IBI End Clear Flag */
#define I3C_CEVR_CCRF_Pos                   (17U)
#define I3C_CEVR_CCRF_Msk                   (0x1UL << I3C_CEVR_CCRF_Pos)            /*!< 0x00020000 */
#define I3C_CEVR_CCRF                       I3C_CEVR_CCRF_Msk                       /*!< Controller-role Clear Flag */
#define I3C_CEVR_CCRUPDF_Pos                (18U)
#define I3C_CEVR_CCRUPDF_Msk                (0x1UL << I3C_CEVR_CCRUPDF_Pos)         /*!< 0x00040000 */
#define I3C_CEVR_CCRUPDF                    I3C_CEVR_CCRUPDF_Msk                    /*!< Controller-role Update Clear Flag */
#define I3C_CEVR_CHJF_Pos                   (19U)
#define I3C_CEVR_CHJF_Msk                   (0x1UL << I3C_CEVR_CHJF_Pos)            /*!< 0x00080000 */
#define I3C_CEVR_CHJF                       I3C_CEVR_CHJF_Msk                       /*!< Hot Join Clear Flag */
#define I3C_CEVR_CWKPF_Pos                  (21U)
#define I3C_CEVR_CWKPF_Msk                  (0x1UL << I3C_CEVR_CWKPF_Pos)           /*!< 0x00200000 */
#define I3C_CEVR_CWKPF                      I3C_CEVR_CWKPF_Msk                      /*!< Wake Up Clear Flag */
#define I3C_CEVR_CGETF_Pos                  (22U)
#define I3C_CEVR_CGETF_Msk                  (0x1UL << I3C_CEVR_CGETF_Pos)           /*!< 0x00400000 */
#define I3C_CEVR_CGETF                      I3C_CEVR_CGETF_Msk                      /*!< Get type CCC received Clear Flag */
#define I3C_CEVR_CSTAF_Pos                  (23U)
#define I3C_CEVR_CSTAF_Msk                  (0x1UL << I3C_CEVR_CSTAF_Pos)           /*!< 0x00800000 */
#define I3C_CEVR_CSTAF                      I3C_CEVR_CSTAF_Msk                      /*!< Get Status Clear Flag */
#define I3C_CEVR_CDAUPDF_Pos                (24U)
#define I3C_CEVR_CDAUPDF_Msk                (0x1UL << I3C_CEVR_CDAUPDF_Pos)         /*!< 0x01000000 */
#define I3C_CEVR_CDAUPDF                    I3C_CEVR_CDAUPDF_Msk                    /*!< Dynamic Address Update Clear Flag */
#define I3C_CEVR_CMWLUPDF_Pos               (25U)
#define I3C_CEVR_CMWLUPDF_Msk               (0x1UL << I3C_CEVR_CMWLUPDF_Pos)        /*!< 0x02000000 */
#define I3C_CEVR_CMWLUPDF                   I3C_CEVR_CMWLUPDF_Msk                   /*!< Max Write Length Update Clear Flag */
#define I3C_CEVR_CMRLUPDF_Pos               (26U)
#define I3C_CEVR_CMRLUPDF_Msk               (0x1UL << I3C_CEVR_CMRLUPDF_Pos)        /*!< 0x04000000 */
#define I3C_CEVR_CMRLUPDF                   I3C_CEVR_CMRLUPDF_Msk                   /*!< Max Read Length Update Clear Flag */
#define I3C_CEVR_CRSTF_Pos                  (27U)
#define I3C_CEVR_CRSTF_Msk                  (0x1UL << I3C_CEVR_CRSTF_Pos)           /*!< 0x08000000 */
#define I3C_CEVR_CRSTF                      I3C_CEVR_CRSTF_Msk                      /*!< Reset Flag, due to Reset pattern received */
#define I3C_CEVR_CASUPDF_Pos                (28U)
#define I3C_CEVR_CASUPDF_Msk                (0x1UL << I3C_CEVR_CASUPDF_Pos)         /*!< 0x10000000 */
#define I3C_CEVR_CASUPDF                    I3C_CEVR_CASUPDF_Msk                    /*!< Activity State Clear Flag */
#define I3C_CEVR_CINTUPDF_Pos               (29U)
#define I3C_CEVR_CINTUPDF_Msk               (0x1UL << I3C_CEVR_CINTUPDF_Pos)        /*!< 0x20000000 */
#define I3C_CEVR_CINTUPDF                   I3C_CEVR_CINTUPDF_Msk                   /*!< Interrupt Update Clear Flag */
#define I3C_CEVR_CDEFF_Pos                  (30U)
#define I3C_CEVR_CDEFF_Msk                  (0x1UL << I3C_CEVR_CDEFF_Pos)           /*!< 0x40000000 */
#define I3C_CEVR_CDEFF                      I3C_CEVR_CDEFF_Msk                      /*!< List of Targets Command Received Clear Flag */
#define I3C_CEVR_CGRPF_Pos                  (31U)
#define I3C_CEVR_CGRPF_Msk                  (0x1UL << I3C_CEVR_CGRPF_Pos)           /*!< 0x80000000 */
#define I3C_CEVR_CGRPF                      I3C_CEVR_CGRPF_Msk                      /*!< List of Group Addresses Command Received Clear Flag */
#define I3C_DEVR0_DAVAL_Pos                 (0U)
#define I3C_DEVR0_DAVAL_Msk                 (0x1UL << I3C_DEVR0_DAVAL_Pos)          /*!< 0x00000001 */
#define I3C_DEVR0_DAVAL                     I3C_DEVR0_DAVAL_Msk                     /*!< Dynamic Address Validity */
#define I3C_DEVR0_DA_Pos                    (1U)
#define I3C_DEVR0_DA_Msk                    (0x7FUL << I3C_DEVR0_DA_Pos)            /*!< 0x000000FE */
#define I3C_DEVR0_DA                        I3C_DEVR0_DA_Msk                        /*!< Own Target Device Address */
#define I3C_DEVR0_IBIEN_Pos                 (16U)
#define I3C_DEVR0_IBIEN_Msk                 (0x1UL << I3C_DEVR0_IBIEN_Pos)          /*!< 0x00010000 */
#define I3C_DEVR0_IBIEN                     I3C_DEVR0_IBIEN_Msk                     /*!< IBI Enable */
#define I3C_DEVR0_CREN_Pos                  (17U)
#define I3C_DEVR0_CREN_Msk                  (0x1UL << I3C_DEVR0_CREN_Pos)           /*!< 0x00020000 */
#define I3C_DEVR0_CREN                      I3C_DEVR0_CREN_Msk                      /*!< Controller-role Enable */
#define I3C_DEVR0_HJEN_Pos                  (19U)
#define I3C_DEVR0_HJEN_Msk                  (0x1UL << I3C_DEVR0_HJEN_Pos)           /*!< 0x00080000 */
#define I3C_DEVR0_HJEN                      I3C_DEVR0_HJEN_Msk                      /*!< Hot Join Enable */
#define I3C_DEVR0_AS_Pos                    (20U)
#define I3C_DEVR0_AS_Msk                    (0x3UL << I3C_DEVR0_AS_Pos)             /*!< 0x00300000 */
#define I3C_DEVR0_AS                        I3C_DEVR0_AS_Msk                        /*!< Activity State value update after ENTAx received */
#define I3C_DEVR0_AS_0                      (0x1UL << I3C_DEVR0_AS_Pos)             /*!< 0x00100000 */
#define I3C_DEVR0_AS_1                      (0x2UL << I3C_DEVR0_AS_Pos)             /*!< 0x00200000 */
#define I3C_DEVR0_RSTACT_Pos                (22U)
#define I3C_DEVR0_RSTACT_Msk                (0x3UL << I3C_DEVR0_RSTACT_Pos)         /*!< 0x00C000000 */
#define I3C_DEVR0_RSTACT                    I3C_DEVR0_RSTACT_Msk                    /*!< Reset Action value update after RSTACT received */
#define I3C_DEVR0_RSTACT_0                  (0x1UL << I3C_DEVR0_RSTACT_Pos)         /*!< 0x00400000 */
#define I3C_DEVR0_RSTACT_1                  (0x2UL << I3C_DEVR0_RSTACT_Pos)         /*!< 0x00800000 */
#define I3C_DEVR0_RSTVAL_Pos                (24U)
#define I3C_DEVR0_RSTVAL_Msk                (0x1UL << I3C_DEVR0_RSTVAL_Pos)         /*!< 0x01000000 */
#define I3C_DEVR0_RSTVAL                    I3C_DEVR0_RSTVAL_Msk                    /*!< Reset Action Valid */
#define I3C_DEVRX_DA_Pos                    (1U)
#define I3C_DEVRX_DA_Msk                    (0x7FUL << I3C_DEVRX_DA_Pos)            /*!< 0x000000FE */
#define I3C_DEVRX_DA                        I3C_DEVRX_DA_Msk                        /*!< Dynamic Address Target x */
#define I3C_DEVRX_IBIACK_Pos                (16U)
#define I3C_DEVRX_IBIACK_Msk                (0x1UL << I3C_DEVRX_IBIACK_Pos)         /*!< 0x00010000 */
#define I3C_DEVRX_IBIACK                    I3C_DEVRX_IBIACK_Msk                    /*!< IBI Acknowledge from Target x */
#define I3C_DEVRX_CRACK_Pos                 (17U)
#define I3C_DEVRX_CRACK_Msk                 (0x1UL << I3C_DEVRX_CRACK_Pos)          /*!< 0x00020000 */
#define I3C_DEVRX_CRACK                     I3C_DEVRX_CRACK_Msk                     /*!< Controller-role Acknowledge from Target x */
#define I3C_DEVRX_IBIDEN_Pos                (18U)
#define I3C_DEVRX_IBIDEN_Msk                (0x1UL << I3C_DEVRX_IBIDEN_Pos)         /*!< 0x00040000 */
#define I3C_DEVRX_IBIDEN                    I3C_DEVRX_IBIDEN_Msk                    /*!< IBI Additional Data Enable */
#define I3C_DEVRX_SUSP_Pos                  (19U)
#define I3C_DEVRX_SUSP_Msk                  (0x1UL << I3C_DEVRX_SUSP_Pos)           /*!< 0x00080000 */
#define I3C_DEVRX_SUSP                      I3C_DEVRX_SUSP_Msk                      /*!< Suspended Transfer */
#define I3C_DEVRX_DIS_Pos                   (31U)
#define I3C_DEVRX_DIS_Msk                   (0x1UL << I3C_DEVRX_DIS_Pos)            /*!< 0x80000000 */
#define I3C_DEVRX_DIS                       I3C_DEVRX_DIS_Msk                       /*!< Disable Register access */
#define I3C_MAXRLR_MRL_Pos                  (0U)
#define I3C_MAXRLR_MRL_Msk                  (0xFFFFUL << I3C_MAXRLR_MRL_Pos)        /*!< 0x0000FFFF */
#define I3C_MAXRLR_MRL                      I3C_MAXRLR_MRL_Msk                      /*!< Maximum Read Length */
#define I3C_MAXRLR_IBIP_Pos                 (16U)
#define I3C_MAXRLR_IBIP_Msk                 (0x7UL << I3C_MAXRLR_IBIP_Pos)          /*!< 0x00070000 */
#define I3C_MAXRLR_IBIP                     I3C_MAXRLR_IBIP_Msk                     /*!< IBI Payload size */
#define I3C_MAXRLR_IBIP_0                   (0x1UL << I3C_MAXRLR_IBIP_Pos)          /*!< 0x00010000 */
#define I3C_MAXRLR_IBIP_1                   (0x2UL << I3C_MAXRLR_IBIP_Pos)          /*!< 0x00020000 */
#define I3C_MAXRLR_IBIP_2                   (0x4UL << I3C_MAXRLR_IBIP_Pos)          /*!< 0x00040000 */
#define I3C_MAXWLR_MWL_Pos                  (0U)
#define I3C_MAXWLR_MWL_Msk                  (0xFFFFUL << I3C_MAXWLR_MWL_Pos)        /*!< 0x0000FFFF */
#define I3C_MAXWLR_MWL                      I3C_MAXWLR_MWL_Msk                      /*!< Maximum Write Length */
#define I3C_TIMINGR0_SCLL_PP_Pos            (0U)
#define I3C_TIMINGR0_SCLL_PP_Msk            (0xFFUL << I3C_TIMINGR0_SCLL_PP_Pos)    /*!< 0x000000FF */
#define I3C_TIMINGR0_SCLL_PP                I3C_TIMINGR0_SCLL_PP_Msk                /*!< SCL Low duration during I3C Push-Pull phases */
#define I3C_TIMINGR0_SCLH_I3C_Pos           (8U)
#define I3C_TIMINGR0_SCLH_I3C_Msk           (0xFFUL << I3C_TIMINGR0_SCLH_I3C_Pos)   /*!< 0x0000FF00 */
#define I3C_TIMINGR0_SCLH_I3C               I3C_TIMINGR0_SCLH_I3C_Msk               /*!< SCL High duration during I3C Open-drain and Push-Pull phases */
#define I3C_TIMINGR0_SCLL_OD_Pos            (16U)
#define I3C_TIMINGR0_SCLL_OD_Msk            (0xFFUL << I3C_TIMINGR0_SCLL_OD_Pos)    /*!< 0x00FF0000 */
#define I3C_TIMINGR0_SCLL_OD                I3C_TIMINGR0_SCLL_OD_Msk                /*!< SCL Low duration during  I3C Open-drain phases and I2C transfer */
#define I3C_TIMINGR0_SCLH_I2C_Pos           (24U)
#define I3C_TIMINGR0_SCLH_I2C_Msk           (0xFFUL << I3C_TIMINGR0_SCLH_I2C_Pos)   /*!< 0xFF000000 */
#define I3C_TIMINGR0_SCLH_I2C               I3C_TIMINGR0_SCLH_I2C_Msk               /*!< SCL High duration during I2C transfer */
#define I3C_TIMINGR1_AVAL_Pos               (0U)
#define I3C_TIMINGR1_AVAL_Msk               (0xFFUL << I3C_TIMINGR1_AVAL_Pos)       /*!< 0x000000FF */
#define I3C_TIMINGR1_AVAL                   I3C_TIMINGR1_AVAL_Msk                   /*!< Timing for I3C Bus Idle or Available condition */
#define I3C_TIMINGR1_ASNCR_Pos              (8U)
#define I3C_TIMINGR1_ASNCR_Msk              (0x3UL << I3C_TIMINGR1_ASNCR_Pos)       /*!< 0x00000300 */
#define I3C_TIMINGR1_ASNCR                  I3C_TIMINGR1_ASNCR_Msk                  /*!< Activity State of the New Controller */
#define I3C_TIMINGR1_ASNCR_0                (0x1UL << I3C_TIMINGR1_ASNCR_Pos)       /*!< 0x00000100 */
#define I3C_TIMINGR1_ASNCR_1                (0x2UL << I3C_TIMINGR1_ASNCR_Pos)       /*!< 0x00000200 */
#define I3C_TIMINGR1_FREE_Pos               (16U)
#define I3C_TIMINGR1_FREE_Msk               (0x7FUL << I3C_TIMINGR1_FREE_Pos)       /*!< 0x007F0000 */
#define I3C_TIMINGR1_FREE                   I3C_TIMINGR1_FREE_Msk                   /*!< Timing for I3C Bus Free condition */
#define I3C_TIMINGR1_SDA_HD_Pos             (28U)
#define I3C_TIMINGR1_SDA_HD_Msk             (0x1UL << I3C_TIMINGR1_SDA_HD_Pos)      /*!< 0x00010000 */
#define I3C_TIMINGR1_SDA_HD                 I3C_TIMINGR1_SDA_HD_Msk                 /*!< SDA Hold Duration */
#define I3C_TIMINGR2_STALLT_Pos             (0U)
#define I3C_TIMINGR2_STALLT_Msk             (0x1UL << I3C_TIMINGR2_STALLT_Pos)      /*!< 0x00000001 */
#define I3C_TIMINGR2_STALLT                 I3C_TIMINGR2_STALLT_Msk                 /*!< Stall on T bit */
#define I3C_TIMINGR2_STALLD_Pos             (1U)
#define I3C_TIMINGR2_STALLD_Msk             (0x1UL << I3C_TIMINGR2_STALLD_Pos)      /*!< 0x00000002 */
#define I3C_TIMINGR2_STALLD                 I3C_TIMINGR2_STALLD_Msk                 /*!< Stall on PAR bit of data bytes */
#define I3C_TIMINGR2_STALLC_Pos             (2U)
#define I3C_TIMINGR2_STALLC_Msk             (0x1UL << I3C_TIMINGR2_STALLC_Pos)      /*!< 0x00000004 */
#define I3C_TIMINGR2_STALLC                 I3C_TIMINGR2_STALLC_Msk                 /*!< Stall on PAR bit of CCC byte */
#define I3C_TIMINGR2_STALLA_Pos             (3U)
#define I3C_TIMINGR2_STALLA_Msk             (0x1UL << I3C_TIMINGR2_STALLA_Pos)      /*!< 0x00000008 */
#define I3C_TIMINGR2_STALLA                 I3C_TIMINGR2_STALLA_Msk                 /*!< Stall on ACK bit */
#define I3C_TIMINGR2_STALL_Pos              (8U)
#define I3C_TIMINGR2_STALL_Msk              (0xFFUL << I3C_TIMINGR2_STALL_Pos)      /*!< 0x0000FF00 */
#define I3C_TIMINGR2_STALL                  I3C_TIMINGR2_STALL_Msk                  /*!< Controller Stall duration */
#define I3C_BCR_BCR_Pos                     (0U)
#define I3C_BCR_BCR_Msk                     (0xFFUL << I3C_BCR_BCR_Pos)             /*!< 0x000000FF */
#define I3C_BCR_BCR                         I3C_BCR_BCR_Msk                         /*!< Bus Characteristics */
#define I3C_BCR_BCR0_Pos                    (0U)
#define I3C_BCR_BCR0_Msk                    (0x1UL << I3C_BCR_BCR0_Pos)             /*!< 0x00000001 */
#define I3C_BCR_BCR0                        I3C_BCR_BCR0_Msk                        /*!< Max Data Speed Limitation */
#define I3C_BCR_BCR1_Pos                    (1U)
#define I3C_BCR_BCR1_Msk                    (0x1UL << I3C_BCR_BCR1_Pos)             /*!< 0x00000002 */
#define I3C_BCR_BCR1                        I3C_BCR_BCR1_Msk                        /*!< IBI Request capable */
#define I3C_BCR_BCR2_Pos                    (2U)
#define I3C_BCR_BCR2_Msk                    (0x1UL << I3C_BCR_BCR2_Pos)             /*!< 0x00000004 */
#define I3C_BCR_BCR2                        I3C_BCR_BCR2_Msk                        /*!< IBI Payload additional Mandatory Data Byte */
#define I3C_BCR_BCR3_Pos                    (3U)
#define I3C_BCR_BCR3_Msk                    (0x1UL << I3C_BCR_BCR3_Pos)             /*!< 0x00000008 */
#define I3C_BCR_BCR3                        I3C_BCR_BCR3_Msk                        /*!< Offline capable */
#define I3C_BCR_BCR4_Pos                    (4U)
#define I3C_BCR_BCR4_Msk                    (0x1UL << I3C_BCR_BCR4_Pos)             /*!< 0x00000010 */
#define I3C_BCR_BCR4                        I3C_BCR_BCR4_Msk                        /*!< Virtual target support */
#define I3C_BCR_BCR5_Pos                    (5U)
#define I3C_BCR_BCR5_Msk                    (0x1UL << I3C_BCR_BCR5_Pos)             /*!< 0x00000020 */
#define I3C_BCR_BCR5                        I3C_BCR_BCR5_Msk                        /*!< Advanced capabilities */
#define I3C_BCR_BCR6_Pos                    (6U)
#define I3C_BCR_BCR6_Msk                    (0x1UL << I3C_BCR_BCR6_Pos)             /*!< 0x00000040 */
#define I3C_BCR_BCR6                        I3C_BCR_BCR6_Msk                        /*!< Device Role shared during Dynamic Address Assignment */
#define I3C_DCR_DCR_Pos                     (0U)
#define I3C_DCR_DCR_Msk                     (0xFFUL << I3C_DCR_DCR_Pos)             /*!< 0x000000FF */
#define I3C_DCR_DCR                         I3C_DCR_DCR_Msk                         /*!< Devices Characteristics */
#define I3C_GETCAPR_CAPPEND_Pos             (14U)
#define I3C_GETCAPR_CAPPEND_Msk             (0x1UL << I3C_GETCAPR_CAPPEND_Pos)      /*!< 0x00004000 */
#define I3C_GETCAPR_CAPPEND                 I3C_GETCAPR_CAPPEND_Msk                 /*!< IBI Request with Mandatory Data Byte */
#define I3C_CRCAPR_CAPDHOFF_Pos             (3U)
#define I3C_CRCAPR_CAPDHOFF_Msk             (0x1UL << I3C_CRCAPR_CAPDHOFF_Pos)      /*!< 0x00000008 */
#define I3C_CRCAPR_CAPDHOFF                 I3C_CRCAPR_CAPDHOFF_Msk                 /*!< Controller-role handoff needed */
#define I3C_CRCAPR_CAPGRP_Pos               (9U)
#define I3C_CRCAPR_CAPGRP_Msk               (0x1UL << I3C_CRCAPR_CAPGRP_Pos)        /*!< 0x00000200 */
#define I3C_CRCAPR_CAPGRP                   I3C_CRCAPR_CAPGRP_Msk                   /*!< Group Address handoff supported */
#define I3C_GETMXDSR_HOFFAS_Pos             (0U)
#define I3C_GETMXDSR_HOFFAS_Msk             (0x3UL << I3C_GETMXDSR_HOFFAS_Pos)      /*!< 0x00000003 */
#define I3C_GETMXDSR_HOFFAS                 I3C_GETMXDSR_HOFFAS_Msk                 /*!< Handoff Activity State */
#define I3C_GETMXDSR_HOFFAS_0               (0x1UL << I3C_GETMXDSR_HOFFAS_Pos)      /*!< 0x00000001 */
#define I3C_GETMXDSR_HOFFAS_1               (0x2UL << I3C_GETMXDSR_HOFFAS_Pos)      /*!< 0x00000002 */
#define I3C_GETMXDSR_FMT_Pos                (8U)
#define I3C_GETMXDSR_FMT_Msk                (0x3UL << I3C_GETMXDSR_FMT_Pos)         /*!< 0x00000300 */
#define I3C_GETMXDSR_FMT                    I3C_GETMXDSR_FMT_Msk                    /*!< Get Max Data Speed response in format 2 */
#define I3C_GETMXDSR_FMT_0                  (0x1UL << I3C_GETMXDSR_FMT_Pos)         /*!< 0x00000100 */
#define I3C_GETMXDSR_FMT_1                  (0x2UL << I3C_GETMXDSR_FMT_Pos)         /*!< 0x00000200 */
#define I3C_GETMXDSR_RDTURN_Pos             (16U)
#define I3C_GETMXDSR_RDTURN_Msk             (0xFFUL << I3C_GETMXDSR_RDTURN_Pos)     /*!< 0x00FF0000 */
#define I3C_GETMXDSR_RDTURN                 I3C_GETMXDSR_RDTURN_Msk                 /*!< Max Read Turnaround Middle Byte  */
#define I3C_GETMXDSR_TSCO_Pos               (24U)
#define I3C_GETMXDSR_TSCO_Msk               (0x1UL << I3C_GETMXDSR_TSCO_Pos)        /*!< 0x01000000 */
#define I3C_GETMXDSR_TSCO                   I3C_GETMXDSR_TSCO_Msk                   /*!< Clock-to-data Turnaround time */
#define I3C_EPIDR_MIPIID_Pos                (12U)
#define I3C_EPIDR_MIPIID_Msk                (0xFUL << I3C_EPIDR_MIPIID_Pos)         /*!< 0x0000F000 */
#define I3C_EPIDR_MIPIID                    I3C_EPIDR_MIPIID_Msk                    /*!< MIPI Instance ID */
#define I3C_EPIDR_IDTSEL_Pos                (16U)
#define I3C_EPIDR_IDTSEL_Msk                (0x1UL << I3C_EPIDR_IDTSEL_Pos)         /*!< 0x00010000 */
#define I3C_EPIDR_IDTSEL                    I3C_EPIDR_IDTSEL_Msk                    /*!< ID Type Selector */
#define I3C_EPIDR_MIPIMID_Pos               (17U)
#define I3C_EPIDR_MIPIMID_Msk               (0x7FFFUL << I3C_EPIDR_MIPIMID_Pos)     /*!< 0xFFFE0000 */
#define I3C_EPIDR_MIPIMID                   I3C_EPIDR_MIPIMID_Msk                   /*!< MIPI Manufacturer ID */
