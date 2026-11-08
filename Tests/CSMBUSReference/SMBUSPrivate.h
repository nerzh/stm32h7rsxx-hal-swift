// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMBUS/SMBUSEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#define TIMING_CLEAR_MASK   (0xF0FFFFFFUL)
#define HAL_TIMEOUT_ADDR    (10000U)
#define HAL_TIMEOUT_BUSY    (25U)
#define HAL_TIMEOUT_DIR     (25U)
#define HAL_TIMEOUT_RXNE    (25U)
#define HAL_TIMEOUT_STOPF   (25U)
#define HAL_TIMEOUT_TC      (25U)
#define HAL_TIMEOUT_TCR     (25U)
#define HAL_TIMEOUT_TXIS    (25U)
#define MAX_NBYTE_SIZE      255U
