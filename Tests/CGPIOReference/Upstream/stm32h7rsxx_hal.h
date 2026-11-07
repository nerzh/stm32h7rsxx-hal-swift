#ifndef C_GPIO_REFERENCE_HAL_H
#define C_GPIO_REFERENCE_HAL_H

/* Host-only CMSIS shim for the unmodified ST GPIO source and public GPIO header.
 * Register masks are from ST cmsis-device-h7rs Include/stm32h7s3xx.h.
 * Upstream GPIO sources: 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * CMSIS revision: 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * Modified for host-only test storage.
 * SPDX-License-Identifier: Apache-2.0
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.
 */
#include "stm32h7rsxx_hal_gpio.h"

#define HAL_GPIO_MODULE_ENABLED

extern _Thread_local CGPIOReferenceState *CGPIOReference_Current;
#define EXTI (&CGPIOReference_Current->exti)
#define SBS (&CGPIOReference_Current->sbs)

/* Host pointers have no device address encoding. Tests supply the port index. */
#undef GPIO_GET_INDEX
#define GPIO_GET_INDEX(gpio) (CGPIOReference_Current->portIndex)

#define GPIO_OSPEEDR_OSPEED0 (0x3UL)
#define GPIO_OSPEEDR_OSPEED1_Pos (2U)
#define GPIO_OTYPER_OT0 (0x1UL)
#define GPIO_PUPDR_PUPD0 (0x3UL)
#define GPIO_PUPDR_PUPD1_Pos (2U)
#define GPIO_AFRL_AFSEL1_Pos (4U)
#define GPIO_MODER_MODE0 (0x3UL)
#define GPIO_MODER_MODE1_Pos (2U)
#define GPIO_LCKR_LCKK (0x1UL << 16U)
#define SBS_EXTICR1_PC_EXTI1_Pos (4U)

#endif
