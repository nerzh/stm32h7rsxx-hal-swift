/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_FLASH_Program(uint32_t TypeProgram, uint32_t Address, uint32_t DataAddress);
HAL_StatusTypeDef HAL_FLASH_Program_IT(uint32_t TypeProgram, uint32_t Address, uint32_t DataAddress);
void HAL_FLASH_IRQHandler(void);
void HAL_FLASH_EndOfOperationCallback(uint32_t ReturnValue);
void HAL_FLASH_OperationErrorCallback(uint32_t ReturnValue);
HAL_StatusTypeDef HAL_FLASH_Unlock(void);
HAL_StatusTypeDef HAL_FLASH_Lock(void);
HAL_StatusTypeDef HAL_FLASH_OB_Unlock(void);
HAL_StatusTypeDef HAL_FLASH_OB_Lock(void);
uint32_t HAL_FLASH_GetError(void);
HAL_StatusTypeDef FLASH_WaitForLastOperation(uint32_t Timeout);
static void FLASH_Program_Byte(uint32_t Address, uint32_t DataAddress);
static void FLASH_Program_HalfWord(uint32_t Address, uint32_t DataAddress);
static void FLASH_Program_Word(uint32_t Address, uint32_t DataAddress);
static void FLASH_Program_DoubleWord(uint32_t Address, uint32_t DataAddress);
static void FLASH_Program_QuadWord(uint32_t Address, uint32_t DataAddress);
static void FLASH_Program_OTPHalfWord(uint32_t Address, uint32_t DataAddress);
static void FLASH_Program_OTPWord(uint32_t Address, uint32_t DataAddress);
