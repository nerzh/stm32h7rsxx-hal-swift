// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAIEx_ConfigPdmMicDelay(const SAI_HandleTypeDef *hsai,
                                              const SAIEx_PdmMicDelayParamTypeDef *pdmMicDelay)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t offset;

  /* Check that SAI sub-block is SAI1 sub-block A */
  if (hsai->Instance != SAI1_Block_A)
  {
    status = HAL_ERROR;
  }
  else
  {
    /* Check microphone delay parameters */
    assert_param(IS_SAI_PDM_MIC_PAIRS_NUMBER(pdmMicDelay->MicPair));
    assert_param(IS_SAI_PDM_MIC_DELAY(pdmMicDelay->LeftDelay));
    assert_param(IS_SAI_PDM_MIC_DELAY(pdmMicDelay->RightDelay));

    /* Compute offset on PDMDLY register according mic pair number */
    offset = SAI_PDM_DELAY_OFFSET * (pdmMicDelay->MicPair - 1U);

    /* Check SAI state and offset */
    if ((hsai->State != HAL_SAI_STATE_RESET) && (offset <= 24U))
    {
      /* Reset current delays for specified microphone */
      SAI1->PDMDLY &= ~(SAI_PDM_DELAY_MASK << offset);

      /* Apply new microphone delays */
      SAI1->PDMDLY |= (((pdmMicDelay->RightDelay << SAI_PDM_RIGHT_DELAY_OFFSET) | pdmMicDelay->LeftDelay) << offset);
    }
    else
    {
      status = HAL_ERROR;
    }
  }
  return status;
}
#endif
