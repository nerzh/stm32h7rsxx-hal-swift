/* Derived from STMicroelectronics STM32H7RSxx HAL Driver, commit
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * Licensed under BSD-3-Clause; see LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.
 * Function bodies below are unchanged; test-only register/OS substitutions and
 * symbol namespaces are supplied by RNGReferenceShim.h.
 */

#define RNG_TIMEOUT_VALUE 2U

HAL_StatusTypeDef HAL_RNGEx_SetConfig(RNG_HandleTypeDef *hrng, const RNG_ConfigTypeDef *pConf)
{
  uint32_t tickstart;
  uint32_t cr_value;
  HAL_StatusTypeDef status ;

  /* Check the RNG handle allocation */
  if ((hrng == NULL) || (pConf == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_RNG_ALL_INSTANCE(hrng->Instance));
  assert_param(IS_RNG_CLOCK_DIVIDER(pConf->ClockDivider));
  assert_param(IS_RNG_NIST_COMPLIANCE(pConf->NistCompliance));
  assert_param(IS_RNG_CONFIG1(pConf->Config1));
  assert_param(IS_RNG_CONFIG2(pConf->Config2));
  assert_param(IS_RNG_CONFIG3(pConf->Config3));
  assert_param(IS_RNG_ARDIS(pConf->AutoReset));

  /* Check RNG peripheral state */
  if (hrng->State == HAL_RNG_STATE_READY)
  {
    /* Change RNG peripheral state */
    hrng->State = HAL_RNG_STATE_BUSY;

    /* Disable RNG */
    __HAL_RNG_DISABLE(hrng);

    /* RNG CR register configuration. Set value in CR register for :
        - NIST Compliance setting
        - Clock divider value
        - Automatic reset to clear SECS bit
        - CONFIG 1, CONFIG 2 and CONFIG 3 values */
    cr_value = (uint32_t)(pConf->ClockDivider | pConf->NistCompliance | pConf->AutoReset
                          | (pConf->Config1 << RNG_CR_RNG_CONFIG1_Pos)
                          | (pConf->Config2 << RNG_CR_RNG_CONFIG2_Pos)
                          | (pConf->Config3 << RNG_CR_RNG_CONFIG3_Pos));

    MODIFY_REG(hrng->Instance->CR, RNG_CR_NISTC | RNG_CR_CLKDIV | RNG_CR_RNG_CONFIG1
               | RNG_CR_RNG_CONFIG2 | RNG_CR_RNG_CONFIG3 | RNG_CR_ARDIS,
               (uint32_t)(RNG_CR_CONDRST | cr_value));

    /* RNG health test control in accordance with NIST */
    WRITE_REG(hrng->Instance->HTCR, pConf->HealthTest);

    /* Writing bit CONDRST=0*/
    CLEAR_BIT(hrng->Instance->CR, RNG_CR_CONDRST);
    /* Get tick */
    tickstart = HAL_GetTick();

    /* Wait for conditioning reset process to be completed */
    while (HAL_IS_BIT_SET(hrng->Instance->CR, RNG_CR_CONDRST))
    {
      if ((HAL_GetTick() - tickstart) > RNG_TIMEOUT_VALUE)
      {
        /* New check to avoid false timeout detection in case of prememption */
        if (HAL_IS_BIT_SET(hrng->Instance->CR, RNG_CR_CONDRST))
        {
          hrng->State = HAL_RNG_STATE_READY;
          hrng->ErrorCode = HAL_RNG_ERROR_TIMEOUT;
          return HAL_ERROR;
        }
      }
    }

    /* Enable RNG */
    __HAL_RNG_ENABLE(hrng);

    /* Initialize the RNG state */
    hrng->State = HAL_RNG_STATE_READY;

    /* function status */
    status = HAL_OK;
  }
  else
  {
    hrng->ErrorCode = HAL_RNG_ERROR_BUSY;
    status = HAL_ERROR;
  }

  /* Return the function status */
  return status;
}

HAL_StatusTypeDef HAL_RNGEx_GetConfig(RNG_HandleTypeDef *hrng, RNG_ConfigTypeDef *pConf)
{

  HAL_StatusTypeDef status ;

  /* Check the RNG handle allocation */
  if ((hrng == NULL) || (pConf == NULL))
  {
    return HAL_ERROR;
  }

  /* Check RNG peripheral state */
  if (hrng->State == HAL_RNG_STATE_READY)
  {
    /* Change RNG peripheral state */
    hrng->State = HAL_RNG_STATE_BUSY;

    /* Get  RNG parameters  */
    pConf->Config1        = (uint32_t)((hrng->Instance->CR & RNG_CR_RNG_CONFIG1) >> RNG_CR_RNG_CONFIG1_Pos) ;
    pConf->Config2        = (uint32_t)((hrng->Instance->CR & RNG_CR_RNG_CONFIG2) >> RNG_CR_RNG_CONFIG2_Pos);
    pConf->Config3        = (uint32_t)((hrng->Instance->CR & RNG_CR_RNG_CONFIG3) >> RNG_CR_RNG_CONFIG3_Pos);
    pConf->ClockDivider   = (hrng->Instance->CR & RNG_CR_CLKDIV);
    pConf->NistCompliance = (hrng->Instance->CR & RNG_CR_NISTC);
    pConf->AutoReset      = (hrng->Instance->CR & RNG_CR_ARDIS);
    pConf->HealthTest     = (hrng->Instance->HTCR);

    /* Initialize the RNG state */
    hrng->State = HAL_RNG_STATE_READY;

    /* function status */
    status = HAL_OK;
  }
  else
  {
    hrng->ErrorCode |= HAL_RNG_ERROR_BUSY;
    status = HAL_ERROR;
  }

  /* Return the function status */
  return status;
}

HAL_StatusTypeDef HAL_RNGEx_LockConfig(RNG_HandleTypeDef *hrng)
{
  HAL_StatusTypeDef status;

  /* Check the RNG handle allocation */
  if (hrng == NULL)
  {
    return HAL_ERROR;
  }

  /* Check RNG peripheral state */
  if (hrng->State == HAL_RNG_STATE_READY)
  {
    /* Change RNG peripheral state */
    hrng->State = HAL_RNG_STATE_BUSY;

    /* Perform RNG configuration Lock */
    MODIFY_REG(hrng->Instance->CR, RNG_CR_CONFIGLOCK, RNG_CR_CONFIGLOCK);

    /* Change RNG peripheral state */
    hrng->State = HAL_RNG_STATE_READY;

    /* function status */
    status = HAL_OK;
  }
  else
  {
    hrng->ErrorCode = HAL_RNG_ERROR_BUSY;
    status = HAL_ERROR;
  }

  /* Return the function status */
  return status;
}

HAL_StatusTypeDef HAL_RNGEx_RecoverSeedError(RNG_HandleTypeDef *hrng)
{
  HAL_StatusTypeDef status;

  /* Check the RNG handle allocation */
  if (hrng == NULL)
  {
    return HAL_ERROR;
  }

  /* Check RNG peripheral state */
  if (hrng->State == HAL_RNG_STATE_READY)
  {
    /* Change RNG peripheral state */
    hrng->State = HAL_RNG_STATE_BUSY;

    /* sequence to fully recover from a seed error */
    status = RNG_RecoverSeedError(hrng);
    if (status == HAL_ERROR)
    {
      /* Update the error code */
      hrng->ErrorCode = HAL_RNG_ERROR_RECOVERSEED;
    }
  }
  else
  {
    hrng->ErrorCode = HAL_RNG_ERROR_BUSY;
    status = HAL_ERROR;
  }

  /* Return the function status */
  return status;
}
