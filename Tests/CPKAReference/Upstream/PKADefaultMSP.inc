/**
  ******************************************************************************
  * @file    stm32h7rsxx_hal_pka.c
  * @author  MCD Application Team
  * @brief   PKA HAL module driver.
  *          This file provides firmware functions to manage the following
  *          functionalities of public key accelerator(PKA):
  *           + Initialization and de-initialization functions
  *           + Start an operation
  *           + Retrieve the operation result
  *
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2022 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  @verbatim
  ==============================================================================
                        ##### How to use this driver #####
  ==============================================================================
    [..]
    The PKA HAL driver can be used as follows:

    (#) Declare a PKA_HandleTypeDef handle structure, for example: PKA_HandleTypeDef  hpka;

    (#) Initialize the PKA low level resources by implementing the HAL_PKA_MspInit() API:
        (##) Enable the PKA interface clock
        (##) NVIC configuration if you need to use interrupt process
            (+++) Configure the PKA interrupt priority
            (+++) Enable the NVIC PKA IRQ Channel

    (#) Initialize the PKA registers by calling the HAL_PKA_Init() API which trig
        HAL_PKA_MspInit().

    (#) Fill entirely the input structure corresponding to your operation:
        For instance: PKA_ModExpInTypeDef for HAL_PKA_ModExp().

    (#) Execute the operation (in polling or interrupt) and check the returned value.

    (#) Retrieve the result of the operation (For instance, HAL_PKA_ModExp_GetResult for
        HAL_PKA_ModExp operation). The function to gather the result is different for each
        kind of operation. The correspondence can be found in the following section.

    (#) Call the function HAL_PKA_DeInit() to restore the default configuration which trig
        HAL_PKA_MspDeInit().

    *** High level operation ***
    =================================
    [..]
      (+) Input structure requires buffers as uint8_t array.

      (+) Output structure requires buffers as uint8_t array.

      (+) Modular exponentiation using:
      (++) HAL_PKA_ModExp().
      (++) HAL_PKA_ModExp_IT().
      (++) HAL_PKA_ModExpFastMode().
      (++) HAL_PKA_ModExpFastMode_IT().
      (++) HAL_PKA_ModExpProtectMode().
      (++) HAL_PKA_ModExpProtectMode_IT().
      (++) HAL_PKA_ModExp_GetResult() to retrieve the result of the operation.

      (+) RSA Chinese Remainder Theorem (CRT) using:
      (++) HAL_PKA_RSACRTExp().
      (++) HAL_PKA_RSACRTExp_IT().
      (++) HAL_PKA_RSACRTExp_GetResult() to retrieve the result of the operation.

      (+) ECC Point Check using:
      (++) HAL_PKA_PointCheck().
      (++) HAL_PKA_PointCheck_IT().
      (++) HAL_PKA_PointCheck_IsOnCurve() to retrieve the result of the operation.

      (+) ECDSA Sign
      (++) HAL_PKA_ECDSASign().
      (++) HAL_PKA_ECDSASign_IT().
      (++) HAL_PKA_ECDSASign_GetResult() to retrieve the result of the operation.

      (+) ECDSA Verify
      (++) HAL_PKA_ECDSAVerif().
      (++) HAL_PKA_ECDSAVerif_IT().
      (++) HAL_PKA_ECDSAVerif_IsValidSignature() to retrieve the result of the operation.

      (+) ECC Scalar Multiplication using:
      (++) HAL_PKA_ECCMul().
      (++) HAL_PKA_ECCMul_IT().
      (++) HAL_PKA_ECCMul_GetResult() to retrieve the result of the operation.

      (+) ECC  double base  ladder using:
      (++) HAL_PKA_ECCDoubleBaseLadder().
      (++) HAL_PKA_ECCDoubleBaseLadder_IT().
      (++) HAL_PKA_ECCDoubleBaseLadder_GetResult() to retrieve the result of the operation.

      (+) ECC  projective to affine using:
      (++) HAL_PKA_ECCProjective2Affine().
      (++) HAL_PKA_ECCProjective2Affine_IT().
      (++) HAL_PKA_ECCProjective2Affine_GetResult() to retrieve the result of the operation.

      (+) ECC  complete addition using:
      (++) HAL_PKA_ECCCompleteAddition().
      (++) HAL_PKA_ECCCompleteAddition_IT().
      (++) HAL_PKA_ECCCompleteAddition_GetResult() to retrieve the result of the operation.

    *** Low level operation ***
    =================================
    [..]
      (+) Input structure requires buffers as uint32_t array.

      (+) Output structure requires buffers as uint32_t array.

      (+) Arithmetic addition using:
      (++) HAL_PKA_Add().
      (++) HAL_PKA_Add_IT().
      (++) HAL_PKA_Arithmetic_GetResult() to retrieve the result of the operation.
            The resulting size can be the input parameter or the input parameter size + 1 (overflow).

      (+) Arithmetic subtraction using:
      (++) HAL_PKA_Sub().
      (++) HAL_PKA_Sub_IT().
      (++) HAL_PKA_Arithmetic_GetResult() to retrieve the result of the operation.

      (+) Arithmetic multiplication using:
      (++) HAL_PKA_Mul().
      (++) HAL_PKA_Mul_IT().
      (++) HAL_PKA_Arithmetic_GetResult() to retrieve the result of the operation.

      (+) Comparison using:
      (++) HAL_PKA_Cmp().
      (++) HAL_PKA_Cmp_IT().
      (++) HAL_PKA_Arithmetic_GetResult() to retrieve the result of the operation.

      (+) Modular addition using:
      (++) HAL_PKA_ModAdd().
      (++) HAL_PKA_ModAdd_IT().
      (++) HAL_PKA_Arithmetic_GetResult() to retrieve the result of the operation.

      (+) Modular subtraction using:
      (++) HAL_PKA_ModSub().
      (++) HAL_PKA_ModSub_IT().
      (++) HAL_PKA_Arithmetic_GetResult() to retrieve the result of the operation.

      (+) Modular inversion using:
      (++) HAL_PKA_ModInv().
      (++) HAL_PKA_ModInv_IT().
      (++) HAL_PKA_Arithmetic_GetResult() to retrieve the result of the operation.

      (+) Modular reduction using:
      (++) HAL_PKA_ModRed().
      (++) HAL_PKA_ModRed_IT().
      (++) HAL_PKA_Arithmetic_GetResult() to retrieve the result of the operation.

      (+) Montgomery multiplication using:
      (++) HAL_PKA_MontgomeryMul().
      (++) HAL_PKA_MontgomeryMul_IT().
      (++) HAL_PKA_Arithmetic_GetResult() to retrieve the result of the operation.

    *** Montgomery parameter ***
    =================================
      (+) For some operation, the computation of the Montgomery parameter is a prerequisite.
      (+) Input structure requires buffers as uint8_t array.
      (+) Output structure requires buffers as uint32_t array.(Only used inside PKA).
      (+) You can compute the Montgomery parameter using:
      (++) HAL_PKA_MontgomeryParam().
      (++) HAL_PKA_MontgomeryParam_IT().
      (++) HAL_PKA_MontgomeryParam_GetResult() to retrieve the result of the operation.

    *** Polling mode operation ***
    ===================================
    [..]
      (+) When an operation is started in polling mode, the function returns when:
      (++) A timeout is encounter.
      (++) The operation is completed.

    *** Interrupt mode operation ***
    ===================================
    [..]
      (+) Add HAL_PKA_IRQHandler to the IRQHandler of PKA.
      (+) Enable the IRQ using HAL_NVIC_EnableIRQ().
      (+) When an operation is started in interrupt mode, the function returns immediately.
      (+) When the operation is completed, the callback HAL_PKA_OperationCpltCallback is called.
      (+) When an error is encountered, the callback HAL_PKA_ErrorCallback is called.
      (+) To stop any operation in interrupt mode, use HAL_PKA_Abort().

    *** Utilities ***
    ===================================
    [..]
      (+) To clear the PKA RAM, use HAL_PKA_RAMReset().
      (+) To get current state, use HAL_PKA_GetState().
      (+) To get current error, use HAL_PKA_GetError().

    *** Callback registration ***
    =============================================
    [..]

     The compilation flag USE_HAL_PKA_REGISTER_CALLBACKS, when set to 1,
     allows the user to configure dynamically the driver callbacks.
     Use Functions HAL_PKA_RegisterCallback()
     to register an interrupt callback.
    [..]

     Function HAL_PKA_RegisterCallback() allows to register following callbacks:
       (+) OperationCpltCallback : callback for End of operation.
       (+) ErrorCallback         : callback for error detection.
       (+) MspInitCallback       : callback for Msp Init.
       (+) MspDeInitCallback     : callback for Msp DeInit.
     This function takes as parameters the HAL peripheral handle, the Callback ID
     and a pointer to the user callback function.
    [..]

     Use function HAL_PKA_UnRegisterCallback to reset a callback to the default
     weak function.
    [..]

     HAL_PKA_UnRegisterCallback takes as parameters the HAL peripheral handle,
     and the Callback ID.
     This function allows to reset following callbacks:
       (+) OperationCpltCallback : callback for End of operation.
       (+) ErrorCallback         : callback for error detection.
       (+) MspInitCallback       : callback for Msp Init.
       (+) MspDeInitCallback     : callback for Msp DeInit.
     [..]

     By default, after the HAL_PKA_Init() and when the state is HAL_PKA_STATE_RESET
     all callbacks are set to the corresponding weak functions:
     examples HAL_PKA_OperationCpltCallback(), HAL_PKA_ErrorCallback().
     Exception done for MspInit and MspDeInit functions that are
     reset to the legacy weak functions in the HAL_PKA_Init()/ HAL_PKA_DeInit() only when
     these callbacks are null (not registered beforehand).
    [..]

     If MspInit or MspDeInit are not null, the HAL_PKA_Init()/ HAL_PKA_DeInit()
     keep and use the user MspInit/MspDeInit callbacks (registered beforehand) whatever the state.
     [..]

     Callbacks can be registered/unregistered in HAL_PKA_STATE_READY state only.
     Exception done MspInit/MspDeInit functions that can be registered/unregistered
     in HAL_PKA_STATE_READY or HAL_PKA_STATE_RESET state,
     thus registered (user) MspInit/DeInit callbacks can be used during the Init/DeInit.
    [..]

     Then, the user first registers the MspInit/MspDeInit user callbacks
     using HAL_PKA_RegisterCallback() before calling HAL_PKA_DeInit()
     or HAL_PKA_Init() function.
     [..]

     When the compilation flag USE_HAL_PKA_REGISTER_CALLBACKS is set to 0 or
     not defined, the callback registration feature is not available and all callbacks
     are set to the corresponding weak functions.

  @endverbatim
  ******************************************************************************
  */


void HAL_PKA_MspDeInit(PKA_HandleTypeDef *hpka)
{
  /* NOTE : This function should not be modified,
            the HAL_PKA_MspDeInit can be implemented in the user file
            user should take into consideration PKA RAM erase when resetting PKA
   */
  uint32_t tickstart = HAL_GetTick();

  /* Enable PKA reset state */
  __HAL_RCC_PKA_FORCE_RESET();

  /* Release PKA from reset state */
  __HAL_RCC_PKA_RELEASE_RESET();

  /* Wait the INITOK flag Setting */
  while (hpka->Instance->CR != PKA_CR_EN)
  {
    hpka->Instance->CR = PKA_CR_EN;

    /* Check for the Timeout */
    if ((HAL_GetTick() - tickstart) > PKA_RAM_ERASE_TIMEOUT)
    {
      /* update the state */
      hpka->State = HAL_PKA_STATE_ERROR;
    }
  }

  /* Get current tick */
  tickstart = HAL_GetTick();

  /* Wait the INITOK flag Setting */
  if (PKA_WaitOnFlagUntilTimeout(hpka, PKA_SR_INITOK, RESET, tickstart, PKA_RAM_ERASE_TIMEOUT) != HAL_OK)
  {
    /* update the state */
    hpka->State = HAL_PKA_STATE_ERROR;
  }

  /* Reset any pending flag */
  SET_BIT(hpka->Instance->CLRFR, PKA_CLRFR_PROCENDFC | PKA_CLRFR_RAMERRFC | PKA_CLRFR_ADDRERRFC | PKA_CLRFR_OPERRFC);

  /* PKA Periph clock disable */
  hpka->Instance->CR = 0;
  __HAL_RCC_PKA_CLK_DISABLE();

  /* PKA Periph IRQ disable */
  HAL_NVIC_DisableIRQ(PKA_IRQn);
}
