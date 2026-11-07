/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted without body changes from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_ICACHE_Enable(void);
HAL_StatusTypeDef HAL_ICACHE_Disable(void);
uint32_t HAL_ICACHE_IsEnabled(void);
HAL_StatusTypeDef HAL_ICACHE_ConfigAssociativityMode(uint32_t AssociativityMode);
HAL_StatusTypeDef HAL_ICACHE_DeInit(void);
HAL_StatusTypeDef HAL_ICACHE_Invalidate(void);
HAL_StatusTypeDef HAL_ICACHE_Invalidate_IT(void);
HAL_StatusTypeDef HAL_ICACHE_WaitForInvalidateComplete(void);
HAL_StatusTypeDef HAL_ICACHE_Monitor_Start(uint32_t MonitorType);
HAL_StatusTypeDef HAL_ICACHE_Monitor_Stop(uint32_t MonitorType);
HAL_StatusTypeDef HAL_ICACHE_Monitor_Reset(uint32_t MonitorType);
uint32_t HAL_ICACHE_Monitor_GetHitValue(void);
uint32_t HAL_ICACHE_Monitor_GetMissValue(void);
void HAL_ICACHE_IRQHandler(void);
void HAL_ICACHE_InvalidateCompleteCallback(void);
void HAL_ICACHE_ErrorCallback(void);
