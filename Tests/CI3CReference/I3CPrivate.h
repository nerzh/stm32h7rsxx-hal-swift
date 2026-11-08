// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#define I3C_XFER_LISTEN_IT            (0x00000001U)
#define I3C_XFER_TARGET_TX_IT         (0x00000002U)
#define I3C_XFER_TARGET_RX_IT         (0x00000004U)
#define I3C_XFER_DMA                  (0x00000008U)
#define I3C_XFER_TARGET_CTRLROLE      (0x00000010U)
#define I3C_XFER_TARGET_HOTJOIN       (0x00000020U)
#define I3C_XFER_TARGET_IBI           (0x00000040U)
#define I3C_XFER_CONTROLLER_TX_IT     (0x00000080U)
#define I3C_XFER_CONTROLLER_RX_IT     (0x00000100U)
#define I3C_XFER_CONTROLLER_RX_CCC_IT (0x00000400U)
#define I3C_XFER_CONTROLLER_DAA_IT    (0x00001000U)
#define I3C_OPERATION_TYPE_MASK       (0x78000000U)
#define I3C_RESTART_STOP_MASK         (0x80000000U)
#define I3C_ARBITRATION_HEADER_MASK   (0x00000004U)
#define I3C_DEFINE_BYTE_MASK          (0x00000001U)
#define I3C_BROADCAST_RSTDAA          (0x00000006U)
#define I3C_BROADCAST_ENTDAA          (0x00000007U)
#define I3C_DCR_IN_PAYLOAD_SHIFT       56
#define I3C_PID_IN_PAYLOAD_MASK        0xFFFFFFFFFFFFU
#define I3C_MIPIMID_PID_SHIFT          33
#define I3C_MIPIMID_PID_MASK           0x7FFFU
#define I3C_IDTSEL_PID_SHIFT           32
#define I3C_IDTSEL_PID_MASK            0x01U
#define I3C_PART_ID_PID_SHIFT          16
#define I3C_PART_ID_PID_MASK           0xFFFFU
#define I3C_MIPIID_PID_SHIFT           12
#define I3C_MIPIID_PID_MASK            0xFU
#define I3C_GET_PID(__PAYLOAD__) ((uint64_t)(__PAYLOAD__) & I3C_PID_IN_PAYLOAD_MASK)
#define I3C_GET_MIPIMID(__PID__) ((uint16_t)((uint64_t)(__PID__) >> I3C_MIPIMID_PID_SHIFT) & \
                                  I3C_MIPIMID_PID_MASK)
#define I3C_GET_IDTSEL(__PID__) ((uint8_t)((uint64_t)(__PID__) >> I3C_IDTSEL_PID_SHIFT) & \
                                 I3C_IDTSEL_PID_MASK)
#define I3C_GET_PART_ID(__PID__) ((uint16_t)((uint64_t)(__PID__) >> I3C_PART_ID_PID_SHIFT) & \
                                  I3C_PART_ID_PID_MASK)
#define I3C_GET_MIPIID(__PID__) ((uint8_t)((uint64_t)(__PID__) >> I3C_MIPIID_PID_SHIFT) & \
                                 I3C_MIPIID_PID_MASK)
#define I3C_GET_DCR(__PAYLOAD__) (((uint32_t)((uint64_t)(__PAYLOAD__) >> I3C_DCR_IN_PAYLOAD_SHIFT)) & \
                                  I3C_DCR_DCR)
#define I3C_GET_ADVANCED_CAPABLE(__BCR__) (((((__BCR__) & I3C_BCR_BCR5_Msk) >> \
                                             I3C_BCR_BCR5_Pos) == 1U) ? ENABLE : DISABLE)
#define I3C_GET_VIRTUAL_TGT(__BCR__) (((((__BCR__) & I3C_BCR_BCR4_Msk) >> \
                                        I3C_BCR_BCR4_Pos) == 1U) ? ENABLE : DISABLE)
#define I3C_GET_OFFLINE_CAPABLE(__BCR__) (((((__BCR__) & I3C_BCR_BCR3_Msk) >> \
                                            I3C_BCR_BCR3_Pos) == 1U) ? ENABLE : DISABLE)
#define I3C_GET_MAX_DATA_SPEED_LIMIT(__BCR__) (((((__BCR__) & I3C_BCR_BCR0_Msk) >> \
                                                 I3C_BCR_BCR0_Pos) == 1U) ? ENABLE : DISABLE)
#define I3C_BIG_TO_LITTLE_ENDIAN(__DATA__) ((uint32_t)((((__DATA__) & 0xff000000U) >> 24) | \
                                                       (((__DATA__) & 0x00ff0000U) >> 8)  | \
                                                       (((__DATA__) & 0x0000ff00U) << 8)  | \
                                                       (((__DATA__) & 0x000000ffU) << 24)))

typedef struct
{
  uint8_t   Address;            /* Dynamic or Static target Address */
  uint32_t  MessageType;        /* Message Type */

} I3C_DeviceTypeDef;
