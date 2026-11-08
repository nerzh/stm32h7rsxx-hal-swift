// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDMMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

uint32_t SDMMC_GetResponse(const SDMMC_TypeDef *SDMMCx, uint32_t Response)
{
  uint32_t tmp;

  /* Check the parameters */
  assert_param(IS_SDMMC_RESP(Response));

  /* Get the response */
  tmp = (uint32_t)(&(SDMMCx->RESP1)) + Response;

  return (*(__IO uint32_t *) tmp);
}
