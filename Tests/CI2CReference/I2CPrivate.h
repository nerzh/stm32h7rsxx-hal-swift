// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#define TIMING_CLEAR_MASK   (0xF0FFFFFFU)
#define I2C_TIMEOUT_ADDR    (10000U)
#define I2C_TIMEOUT_BUSY    (25U)
#define I2C_TIMEOUT_DIR     (25U)
#define I2C_TIMEOUT_RXNE    (25U)
#define I2C_TIMEOUT_STOPF   (25U)
#define I2C_TIMEOUT_TC      (25U)
#define I2C_TIMEOUT_TCR     (25U)
#define I2C_TIMEOUT_TXIS    (25U)
#define I2C_TIMEOUT_FLAG    (25U)
#define MAX_NBYTE_SIZE      255U
#define SLAVE_ADDR_SHIFT     7U
#define SLAVE_ADDR_MSK       0x06U
#define I2C_STATE_MSK             ((uint32_t)((uint32_t)((uint32_t)HAL_I2C_STATE_BUSY_TX | \
                                                         (uint32_t)HAL_I2C_STATE_BUSY_RX) & \
                                              (uint32_t)(~((uint32_t)HAL_I2C_STATE_READY))))
#define I2C_STATE_NONE            ((uint32_t)(HAL_I2C_MODE_NONE))
#define I2C_STATE_MASTER_BUSY_TX  ((uint32_t)(((uint32_t)HAL_I2C_STATE_BUSY_TX & I2C_STATE_MSK) | \
                                              (uint32_t)HAL_I2C_MODE_MASTER))
#define I2C_STATE_MASTER_BUSY_RX  ((uint32_t)(((uint32_t)HAL_I2C_STATE_BUSY_RX & I2C_STATE_MSK) | \
                                              (uint32_t)HAL_I2C_MODE_MASTER))
#define I2C_STATE_SLAVE_BUSY_TX   ((uint32_t)(((uint32_t)HAL_I2C_STATE_BUSY_TX & I2C_STATE_MSK) | \
                                              (uint32_t)HAL_I2C_MODE_SLAVE))
#define I2C_STATE_SLAVE_BUSY_RX   ((uint32_t)(((uint32_t)HAL_I2C_STATE_BUSY_RX & I2C_STATE_MSK) | \
                                              (uint32_t)HAL_I2C_MODE_SLAVE))
#define I2C_STATE_MEM_BUSY_TX     ((uint32_t)(((uint32_t)HAL_I2C_STATE_BUSY_TX & I2C_STATE_MSK) | \
                                              (uint32_t)HAL_I2C_MODE_MEM))
#define I2C_STATE_MEM_BUSY_RX     ((uint32_t)(((uint32_t)HAL_I2C_STATE_BUSY_RX & I2C_STATE_MSK) | \
                                              (uint32_t)HAL_I2C_MODE_MEM))
#define I2C_XFER_TX_IT          (uint16_t)(0x0001U)
#define I2C_XFER_RX_IT          (uint16_t)(0x0002U)
#define I2C_XFER_LISTEN_IT      (uint16_t)(0x8000U)
#define I2C_XFER_ERROR_IT       (uint16_t)(0x0010U)
#define I2C_XFER_CPLT_IT        (uint16_t)(0x0020U)
#define I2C_XFER_RELOAD_IT      (uint16_t)(0x0040U)
#define I2C_NO_OPTION_FRAME     (0xFFFF0000U)
#define I2C_GET_DMA_REMAIN_DATA(__HANDLE__)     (__HAL_DMA_GET_COUNTER(__HANDLE__) + HAL_DMAEx_GetFifoLevel(__HANDLE__))
