// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#define SAI_DEFAULT_TIMEOUT      4U
#define SAI_LONG_TIMEOUT         1000U
#define SAI_SPDIF_FRAME_LENGTH   64U
#define SAI_AC97_FRAME_LENGTH    256U
typedef enum
{
  SAI_MODE_DMA,
  SAI_MODE_IT
} SAI_ModeTypedef;
#define SAI_PDM_DELAY_MASK          0x77UL
#define SAI_PDM_DELAY_OFFSET        8UL
#define SAI_PDM_RIGHT_DELAY_OFFSET  4UL
