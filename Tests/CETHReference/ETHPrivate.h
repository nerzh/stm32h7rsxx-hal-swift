// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#define ETH_MACCR_MASK                0xFFFB7F7CU
#define ETH_MACECR_MASK               0x3F077FFFU
#define ETH_MACPFR_MASK               0x800007FFU
#define ETH_MACWTR_MASK               0x0000010FU
#define ETH_MACTFCR_MASK              0xFFFF00F2U
#define ETH_MACRFCR_MASK              0x00000003U
#define ETH_MTLTQOMR_MASK             0x00000072U
#define ETH_MTLRQOMR_MASK             0x0000007BU
#define ETH_DMAMR_MASK                0x00007802U
#define ETH_DMASBMR_MASK              0x0000D001U
#define ETH_DMACCR_MASK               0x00013FFFU
#define ETH_DMACTCR_MASK              0x003F1010U
#define ETH_DMACRCR_MASK              0x803F0000U
#define ETH_MACPCSR_MASK              (ETH_MACPCSR_PWRDWN | ETH_MACPCSR_RWKPKTEN | \
                                       ETH_MACPCSR_MGKPKTEN | ETH_MACPCSR_GLBLUCAST | \
                                       ETH_MACPCSR_RWKPFE)
#define ETH_DMARXNDESCWBF_ERRORS_MASK ((uint32_t)(ETH_DMARXNDESCWBF_DE | ETH_DMARXNDESCWBF_RE | \
                                                  ETH_DMARXNDESCWBF_OE | ETH_DMARXNDESCWBF_RWT |\
                                                  ETH_DMARXNDESCWBF_GP | ETH_DMARXNDESCWBF_CE))
#define ETH_MACTSCR_MASK              0x0087FF2FU
#define ETH_MACSTSUR_VALUE            0xFFFFFFFFU
#define ETH_MACSTNUR_VALUE            0xBB9ACA00U
#define ETH_SEGMENT_SIZE_DEFAULT      0x218U
#define INCR_TX_DESC_INDEX(inx, offset) do {\
                                             (inx) += (offset);\
                                             if ((inx) >= (uint32_t)ETH_TX_DESC_CNT){\
                                             (inx) = ((inx) - (uint32_t)ETH_TX_DESC_CNT);}\
                                           } while (0)
#define INCR_RX_DESC_INDEX(inx, offset) do {\
                                             (inx) += (offset);\
                                             if ((inx) >= (uint32_t)ETH_RX_DESC_CNT){\
                                             (inx) = ((inx) - (uint32_t)ETH_RX_DESC_CNT);}\
                                           } while (0)
#define ETH_MACL4CR_MASK     (ETH_MACL3L4CR_L4PEN | ETH_MACL3L4CR_L4SPM | \
                              ETH_MACL3L4CR_L4SPIM | ETH_MACL3L4CR_L4DPM | \
                              ETH_MACL3L4CR_L4DPIM)
#define ETH_MACL3CR_MASK     (ETH_MACL3L4CR_L3PEN | ETH_MACL3L4CR_L3SAM | \
                              ETH_MACL3L4CR_L3SAIM | ETH_MACL3L4CR_L3DAM | \
                              ETH_MACL3L4CR_L3DAIM | ETH_MACL3L4CR_L3HSBM | \
                              ETH_MACL3L4CR_L3HDBM)
#define ETH_MACRXVLAN_MASK (ETH_MACVTR_EIVLRXS | ETH_MACVTR_EIVLS | \
                            ETH_MACVTR_ERIVLT | ETH_MACVTR_EDVLP | \
                            ETH_MACVTR_VTHM | ETH_MACVTR_EVLRXS | \
                            ETH_MACVTR_EVLS | ETH_MACVTR_DOVLTC | \
                            ETH_MACVTR_ERSVLM | ETH_MACVTR_ESVL | \
                            ETH_MACVTR_VTIM | ETH_MACVTR_ETV)
#define ETH_MACTXVLAN_MASK (ETH_MACVIR_VLTI | ETH_MACVIR_CSVL | \
                            ETH_MACVIR_VLP | ETH_MACVIR_VLC)
#define ETH_MAC_L4_SRSP_MASK          0x0000FFFFU
#define ETH_MAC_L4_DSTP_MASK          0xFFFF0000U
