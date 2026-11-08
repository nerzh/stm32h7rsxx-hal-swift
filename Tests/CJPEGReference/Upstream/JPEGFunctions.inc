/**
  ******************************************************************************
  * @file    stm32h7rsxx_hal_jpeg.c
  * @author  MCD Application Team
  * @brief   JPEG HAL module driver.
  *          This file provides firmware functions to manage the following
  *          functionalities of the JPEG encoder/decoder peripheral:
  *           + Initialization and de-initialization functions
  *           + JPEG processing functions encoding and decoding
  *           + JPEG decoding Getting Info and encoding configuration setting
  *           + JPEG enable/disable header parsing functions (for decoding)
  *           + JPEG Input/Output Buffer configuration.
  *           + JPEG callback functions
  *           + JPEG Abort/Pause/Resume functions
  *           + JPEG custom quantization tables setting functions
  *           + IRQ handler management
  *           + Peripheral State and Error functions
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
     (#) Initialize the JPEG peripheral using HAL_JPEG_Init : No initialization parameters are required.
         Only the call to HAL_JPEG_Init is necessary to initialize the JPEG peripheral.

     (#) If operation is JPEG encoding use function HAL_JPEG_ConfigEncoding to set
         the encoding parameters (mandatory before calling the encoding function).
         the application can change the encoding parameter ImageQuality from
         1 to 100 to obtain a more or less quality (visual quality vs the original row image),
         and inversely more or less jpg file size.

     (#) Note that for decoding operation the JPEG peripheral output data are organized in
         YCbCr blocks called MCU (Minimum Coded Unit) as defioned in the JPEG specification
         ISO/IEC 10918-1 standard.
         It is up to the application to transform these YCbCr blocks to RGB data that can be display.

         Respectively, for Encoding operation the JPEG peripheral input should be organized
         in YCbCr MCU blocks. It is up to the application to perform the necessary RGB to YCbCr
         MCU blocks transformation before feeding the JPEG peripheral with data.

     (#) Use functions HAL_JPEG_Encode and HAL_JPEG_Decode to start respectively
         a JPEG encoding/decoding operation in polling method (blocking).

     (#) Use functions HAL_JPEG_Encode_IT and HAL_JPEG_Decode_IT to start respectively
         a JPEG encoding/decoding operation with Interrupt method (not blocking).

     (#) Use functions HAL_JPEG_Encode_DMA and HAL_JPEG_Decode_DMA to start respectively
         a JPEG encoding/decoding operation with DMA method (not blocking).

     (#) Callback HAL_JPEG_InfoReadyCallback is asserted if the current operation
         is a JPEG decoding to provide the application with JPEG image  parameters.
         This callback is asserted when the JPEG peripheral successfully parse the
         JPEG header.

     (#) Callback HAL_JPEG_GetDataCallback is asserted for both encoding and decoding
         operations to inform the application that the input buffer has been
         consumed by the peripheral and to ask for a new data chunk if the operation
         (encoding/decoding) has not been complete yet.

        (++) This CallBack should be implemented in the application side. It should
             call the function HAL_JPEG_ConfigInputBuffer if new input data are available,
             or call HAL_JPEG_Pause with parameter XferSelection set to JPEG_PAUSE_RESUME_INPUT
             to inform the JPEG HAL driver that the ongoing operation shall pause waiting for the
             application to provide a new input data chunk.
             Once the application succeed getting new data and if the input has been paused,
             the application can call the function HAL_JPEG_ConfigInputBuffer to set the new
             input buffer and size, then resume the JPEG HAL input by calling new function HAL_JPEG_Resume.
             If the application has ended feeding the HAL JPEG with input data (no more input data), the application
             Should call the function HAL_JPEG_ConfigInputBuffer (within the callback HAL_JPEG_GetDataCallback)
             with the parameter InDataLength set to zero.

         (++) The mechanism of HAL_JPEG_ConfigInputBuffer/HAL_JPEG_Pause/HAL_JPEG_Resume allows
              to the application to provide the input data (for encoding or decoding) by chunks.
              If the new input data chunk is not available (because data should be read from an input file
              for example) the application can pause the JPEG input (using function HAL_JPEG_Pause)
              Once the new input data chunk is available ( read from a file for example), the application
              can call the function HAL_JPEG_ConfigInputBuffer to provide the HAL with the new chunk
              then resume the JPEG HAL input by calling function HAL_JPEG_Resume.

         (++) The application can call functions HAL_JPEG_ConfigInputBuffer then HAL_JPEG_Resume.
              any time (outside the HAL_JPEG_GetDataCallback)  Once the new input chunk data available.
              However, to keep data coherency, the function HAL_JPEG_Pause must be imperatively called
              (if necessary) within the callback HAL_JPEG_GetDataCallback, i.e when the HAL JPEG has ended
              Transferring the previous chunk buffer to the JPEG peripheral.

     (#) Callback HAL_JPEG_DataReadyCallback is asserted when the HAL JPEG driver
         has filled the given output buffer with the given size.

         (++) This CallBack should be implemented in the application side. It should
              call the function HAL_JPEG_ConfigOutputBuffer to provide the HAL JPEG driver
              with the new output buffer location and size to be used  to store next data chunk.
              if the application is not ready to provide the output chunk location then it can
              call the function HAL_JPEG_Pause with parameter XferSelection set to JPEG_PAUSE_RESUME_OUTPUT
              to inform the JPEG HAL driver that it shall pause output data. Once the application
              is ready to receive the new data chunk (output buffer location free or available) it should call
              the function HAL_JPEG_ConfigOutputBuffer to provide the HAL JPEG driver
              with the new output chunk buffer location and size, then call HAL_JPEG_Resume
              to inform the HAL that it shall resume outputting data in the given output buffer.

         (++) The mechanism of HAL_JPEG_ConfigOutputBuffer/HAL_JPEG_Pause/HAL_JPEG_Resume allows
              the application to receive data from the JPEG peripheral by chunks. when a chunk
              is received, the application can pause the HAL JPEG output data to be able to process
              these received data (YCbCr to RGB conversion in case of decoding or data storage in case
              of encoding).

         (++) The application can call  functions HAL_JPEG_ ConfigOutputBuffer then HAL_JPEG_Resume.
              any time (outside the HAL_JPEG_DataReadyCallback) Once the output data buffer is free to use.
              However, to keep data coherency, the function HAL_JPEG_Pause must be imperatively called
              (if necessary) within the callback HAL_JPEG_ DataReadyCallback, i.e when the HAL JPEG has ended
              Transferring the previous chunk buffer from the JPEG peripheral to the application.

     (#) Callback HAL_JPEG_EncodeCpltCallback is asserted when the HAL JPEG driver has
         ended the current JPEG encoding operation, and all output data has been transmitted
         to the application.

     (#) Callback HAL_JPEG_DecodeCpltCallback is asserted when the HAL JPEG driver has
         ended the current JPEG decoding operation. and all output data has been transmitted
         to the application.

     (#) Callback HAL_JPEG_ErrorCallback is asserted when an error occurred during
         the current operation. the application can call the function HAL_JPEG_GetError()
         to retrieve the error codes.

     (#) By default the HAL JPEG driver uses the default quantization tables
         as provide in the JPEG specification (ISO/IEC 10918-1 standard) for encoding.
         User can change these default tables if necessary using the function HAL_JPEG_SetUserQuantTables
         Note that for decoding the quantization tables are automatically extracted from
         the JPEG header.

      (#) To control JPEG state you can use the following function: HAL_JPEG_GetState()

     *** JPEG HAL driver macros list ***
     =============================================
     [..]
       Below the list of most used macros in JPEG HAL driver.

      (+) __HAL_JPEG_RESET_HANDLE_STATE : Reset JPEG handle state.
      (+) __HAL_JPEG_ENABLE             : Enable the JPEG peripheral.
      (+) __HAL_JPEG_DISABLE            : Disable the JPEG peripheral.
      (+) __HAL_JPEG_GET_FLAG           : Check the specified JPEG status flag.
      (+) __HAL_JPEG_CLEAR_FLAG         : Clear the specified JPEG status flag.
      (+) __HAL_JPEG_ENABLE_IT          : Enable the specified JPEG Interrupt.
      (+) __HAL_JPEG_DISABLE_IT         : Disable the specified JPEG Interrupt.
      (+) __HAL_JPEG_GET_IT_SOURCE      : returns the state of the specified JPEG Interrupt (Enabled or disabled).

  *** Callback registration ***
  =============================================

  The compilation define  USE_HAL_JPEG_REGISTER_CALLBACKS when set to 1
  allows the user to configure dynamically the driver callbacks.
  Use Functions HAL_JPEG_RegisterCallback() or HAL_JPEG_RegisterXXXCallback()
  to register an interrupt callback.

  Function HAL_JPEG_RegisterCallback() allows to register following callbacks:
    (+) EncodeCpltCallback : callback for end of encoding operation.
    (+) DecodeCpltCallback : callback for end of decoding operation.
    (+) ErrorCallback      : callback for error detection.
    (+) MspInitCallback    : JPEG MspInit.
    (+) MspDeInitCallback  : JPEG MspDeInit.
  This function takes as parameters the HAL peripheral handle, the Callback ID
  and a pointer to the user callback function.

  For specific callbacks InfoReadyCallback, GetDataCallback and DataReadyCallback use dedicated
  register callbacks : respectively HAL_JPEG_RegisterInfoReadyCallback(),
  HAL_JPEG_RegisterGetDataCallback() and HAL_JPEG_RegisterDataReadyCallback().

  Use function HAL_JPEG_UnRegisterCallback() to reset a callback to the default
  weak function.
  HAL_JPEG_UnRegisterCallback() takes as parameters the HAL peripheral handle,
  and the Callback ID.
  This function allows to reset following callbacks:
    (+) EncodeCpltCallback : callback for end of encoding operation.
    (+) DecodeCpltCallback : callback for end of decoding operation.
    (+) ErrorCallback      : callback for error detection.
    (+) MspInitCallback    : JPEG MspInit.
    (+) MspDeInitCallback  : JPEG MspDeInit.

  For callbacks InfoReadyCallback, GetDataCallback and DataReadyCallback use dedicated
  unregister callbacks : respectively HAL_JPEG_UnRegisterInfoReadyCallback(),
  HAL_JPEG_UnRegisterGetDataCallback() and HAL_JPEG_UnRegisterDataReadyCallback().

  By default, after the HAL_JPEG_Init() and when the state is HAL_JPEG_STATE_RESET
  all callbacks are set to the corresponding weak functions :
  examples HAL_JPEG_DecodeCpltCallback() , HAL_JPEG_GetDataCallback().
  Exception done for MspInit and MspDeInit functions that are
  reset to the legacy weak function in the HAL_JPEG_Init()/ HAL_JPEG_DeInit() only when
  these callbacks are null (not registered beforehand).
  if not, MspInit or MspDeInit are not null, the HAL_JPEG_Init() / HAL_JPEG_DeInit()
  keep and use the user MspInit/MspDeInit functions (registered beforehand)

  Callbacks can be registered/unregistered in HAL_JPEG_STATE_READY state only.
  Exception done MspInit/MspDeInit callbacks that can be registered/unregistered
  in HAL_JPEG_STATE_READY or HAL_JPEG_STATE_RESET state,
  thus registered (user) MspInit/DeInit callbacks can be used during the Init/DeInit.
  In that case first register the MspInit/MspDeInit user callbacks
  using HAL_JPEG_RegisterCallback() before calling HAL_JPEG_DeInit()
  or HAL_JPEG_Init() function.

  When The compilation define USE_HAL_JPEG_REGISTER_CALLBACKS is set to 0 or
  not defined, the callback registration feature is not available and all callbacks
  are set to the corresponding weak functions.

  @endverbatim
  ******************************************************************************
  */


HAL_StatusTypeDef HAL_JPEG_Init(JPEG_HandleTypeDef *hjpeg)
{
  /* These are the sample quantization tables given in JPEG spec ISO/IEC 10918-1 standard , section K.1. */
  static const uint8_t JPEG_LUM_QuantTable[JPEG_QUANT_TABLE_SIZE] =
  {
    16,  11,  10,  16,  24,  40,  51,  61,
    12,  12,  14,  19,  26,  58,  60,  55,
    14,  13,  16,  24,  40,  57,  69,  56,
    14,  17,  22,  29,  51,  87,  80,  62,
    18,  22,  37,  56,  68, 109, 103,  77,
    24,  35,  55,  64,  81, 104, 113,  92,
    49,  64,  78,  87, 103, 121, 120, 101,
    72,  92,  95,  98, 112, 100, 103,  99
  };
  static const uint8_t JPEG_CHROM_QuantTable[JPEG_QUANT_TABLE_SIZE] =
  {
    17,  18,  24,  47,  99,  99,  99,  99,
    18,  21,  26,  66,  99,  99,  99,  99,
    24,  26,  56,  99,  99,  99,  99,  99,
    47,  66,  99,  99,  99,  99,  99,  99,
    99,  99,  99,  99,  99,  99,  99,  99,
    99,  99,  99,  99,  99,  99,  99,  99,
    99,  99,  99,  99,  99,  99,  99,  99,
    99,  99,  99,  99,  99,  99,  99,  99
  };

  /* Check the JPEG handle allocation */
  if (hjpeg == NULL)
  {
    return HAL_ERROR;
  }

#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
  if (hjpeg->State == HAL_JPEG_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hjpeg->Lock = HAL_UNLOCKED;

    hjpeg->InfoReadyCallback  = HAL_JPEG_InfoReadyCallback;  /* Legacy weak InfoReadyCallback  */
    hjpeg->EncodeCpltCallback = HAL_JPEG_EncodeCpltCallback; /* Legacy weak EncodeCpltCallback */
    hjpeg->DecodeCpltCallback = HAL_JPEG_DecodeCpltCallback; /* Legacy weak DecodeCpltCallback */
    hjpeg->ErrorCallback      = HAL_JPEG_ErrorCallback;      /* Legacy weak ErrorCallback      */
    hjpeg->GetDataCallback    = HAL_JPEG_GetDataCallback;    /* Legacy weak GetDataCallback    */
    hjpeg->DataReadyCallback  = HAL_JPEG_DataReadyCallback;  /* Legacy weak DataReadyCallback  */

    if (hjpeg->MspInitCallback == NULL)
    {
      hjpeg->MspInitCallback = HAL_JPEG_MspInit; /* Legacy weak MspInit  */
    }

    /* Init the low level hardware */
    hjpeg->MspInitCallback(hjpeg);
  }
#else
  if (hjpeg->State == HAL_JPEG_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hjpeg->Lock = HAL_UNLOCKED;

    /* Init the low level hardware : GPIO, CLOCK */
    HAL_JPEG_MspInit(hjpeg);
  }
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */

  /* Change the JPEG state */
  hjpeg->State = HAL_JPEG_STATE_BUSY;

  /* Start the JPEG Core*/
  __HAL_JPEG_ENABLE(hjpeg);

  /* Stop the JPEG encoding/decoding process*/
  hjpeg->Instance->CONFR0 &=  ~JPEG_CONFR0_START;

  /* Disable All Interrupts */
  __HAL_JPEG_DISABLE_IT(hjpeg, JPEG_INTERRUPT_MASK);

  /* Disable All DMA requests */
  JPEG_DISABLE_DMA(hjpeg, JPEG_DMA_MASK);

  /* Flush input and output FIFOs*/
  hjpeg->Instance->CR |= JPEG_CR_IFF;
  hjpeg->Instance->CR |= JPEG_CR_OFF;

  /* Clear all flags */
  __HAL_JPEG_CLEAR_FLAG(hjpeg, JPEG_FLAG_ALL);

  /* init default quantization tables*/
  hjpeg->QuantTable0 = (uint8_t *)((uintptr_t)JPEG_LUM_QuantTable);
  hjpeg->QuantTable1 = (uint8_t *)((uintptr_t)JPEG_CHROM_QuantTable);
  hjpeg->QuantTable2 = NULL;
  hjpeg->QuantTable3 = NULL;

  /* init the default Huffman tables*/
  if (JPEG_Set_HuffEnc_Mem(hjpeg) != HAL_OK)
  {
    hjpeg->ErrorCode = HAL_JPEG_ERROR_HUFF_TABLE;

    return HAL_ERROR;
  }

  /* Enable header processing*/
  hjpeg->Instance->CONFR1 |= JPEG_CONFR1_HDR;

  /* Reset JpegInCount and JpegOutCount */
  hjpeg->JpegInCount = 0;
  hjpeg->JpegOutCount = 0;

  /* Change the JPEG state */
  hjpeg->State = HAL_JPEG_STATE_READY;

  /* Reset the JPEG ErrorCode */
  hjpeg->ErrorCode = HAL_JPEG_ERROR_NONE;

  /* Clear the context fields */
  hjpeg->Context = 0;

  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_JPEG_DeInit(JPEG_HandleTypeDef *hjpeg)
{
  /* Check the JPEG handle allocation */
  if (hjpeg == NULL)
  {
    return HAL_ERROR;
  }

#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
  if (hjpeg->MspDeInitCallback == NULL)
  {
    hjpeg->MspDeInitCallback = HAL_JPEG_MspDeInit; /* Legacy weak MspDeInit  */
  }

  /* DeInit the low level hardware */
  hjpeg->MspDeInitCallback(hjpeg);

#else
  /* DeInit the low level hardware: CLOCK, NVIC.*/
  HAL_JPEG_MspDeInit(hjpeg);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */

  /* Change the JPEG state */
  hjpeg->State = HAL_JPEG_STATE_BUSY;

  /* Reset the JPEG ErrorCode */
  hjpeg->ErrorCode = HAL_JPEG_ERROR_NONE;

  /* Reset JpegInCount and JpegOutCount */
  hjpeg->JpegInCount = 0;
  hjpeg->JpegOutCount = 0;

  /* Change the JPEG state */
  hjpeg->State = HAL_JPEG_STATE_RESET;

  /*Clear the context fields*/
  hjpeg->Context = 0;

  /* Release Lock */
  __HAL_UNLOCK(hjpeg);

  /* Return function status */
  return HAL_OK;
}

#if F_MODE
HAL_StatusTypeDef HAL_JPEG_RegisterCallback(JPEG_HandleTypeDef *hjpeg, HAL_JPEG_CallbackIDTypeDef CallbackID,
                                            pJPEG_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }
  /* Process locked */
  __HAL_LOCK(hjpeg);

  if (HAL_JPEG_STATE_READY == hjpeg->State)
  {
    switch (CallbackID)
    {
      case HAL_JPEG_ENCODE_CPLT_CB_ID :
        hjpeg->EncodeCpltCallback = pCallback;
        break;

      case HAL_JPEG_DECODE_CPLT_CB_ID :
        hjpeg->DecodeCpltCallback = pCallback;
        break;

      case HAL_JPEG_ERROR_CB_ID :
        hjpeg->ErrorCallback = pCallback;
        break;

      case HAL_JPEG_MSPINIT_CB_ID :
        hjpeg->MspInitCallback = pCallback;
        break;

      case HAL_JPEG_MSPDEINIT_CB_ID :
        hjpeg->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_JPEG_STATE_RESET == hjpeg->State)
  {
    switch (CallbackID)
    {
      case HAL_JPEG_MSPINIT_CB_ID :
        hjpeg->MspInitCallback = pCallback;
        break;

      case HAL_JPEG_MSPDEINIT_CB_ID :
        hjpeg->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hjpeg);
  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_JPEG_UnRegisterCallback(JPEG_HandleTypeDef *hjpeg, HAL_JPEG_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Process locked */
  __HAL_LOCK(hjpeg);

  if (HAL_JPEG_STATE_READY == hjpeg->State)
  {
    switch (CallbackID)
    {
      case HAL_JPEG_ENCODE_CPLT_CB_ID :
        hjpeg->EncodeCpltCallback = HAL_JPEG_EncodeCpltCallback; /* Legacy weak EncodeCpltCallback  */
        break;

      case HAL_JPEG_DECODE_CPLT_CB_ID :
        hjpeg->DecodeCpltCallback = HAL_JPEG_DecodeCpltCallback; /* Legacy weak DecodeCpltCallback  */
        break;

      case HAL_JPEG_ERROR_CB_ID :
        hjpeg->ErrorCallback = HAL_JPEG_ErrorCallback;           /* Legacy weak ErrorCallback  */
        break;

      case HAL_JPEG_MSPINIT_CB_ID :
        hjpeg->MspInitCallback = HAL_JPEG_MspInit;              /* Legacy weak MspInit  */
        break;

      case HAL_JPEG_MSPDEINIT_CB_ID :
        hjpeg->MspDeInitCallback = HAL_JPEG_MspDeInit;          /* Legacy weak MspDeInit  */
        break;

      default :
        /* Update the error code */
        hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_JPEG_STATE_RESET == hjpeg->State)
  {
    switch (CallbackID)
    {
      case HAL_JPEG_MSPINIT_CB_ID :
        hjpeg->MspInitCallback = HAL_JPEG_MspInit;           /* Legacy weak MspInit  */
        break;

      case HAL_JPEG_MSPDEINIT_CB_ID :
        hjpeg->MspDeInitCallback = HAL_JPEG_MspDeInit;       /* Legacy weak MspInit  */
        break;

      default :
        /* Update the error code */
        hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hjpeg);
  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_JPEG_RegisterInfoReadyCallback(JPEG_HandleTypeDef *hjpeg,
                                                     pJPEG_InfoReadyCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }
  /* Process locked */
  __HAL_LOCK(hjpeg);

  if (HAL_JPEG_STATE_READY == hjpeg->State)
  {
    hjpeg->InfoReadyCallback = pCallback;
  }
  else
  {
    /* Update the error code */
    hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hjpeg);
  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_JPEG_UnRegisterInfoReadyCallback(JPEG_HandleTypeDef *hjpeg)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Process locked */
  __HAL_LOCK(hjpeg);

  if (HAL_JPEG_STATE_READY == hjpeg->State)
  {
    hjpeg->InfoReadyCallback = HAL_JPEG_InfoReadyCallback; /* Legacy weak InfoReadyCallback  */
  }
  else
  {
    /* Update the error code */
    hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hjpeg);
  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_JPEG_RegisterGetDataCallback(JPEG_HandleTypeDef *hjpeg, pJPEG_GetDataCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }
  /* Process locked */
  __HAL_LOCK(hjpeg);

  if (HAL_JPEG_STATE_READY == hjpeg->State)
  {
    hjpeg->GetDataCallback = pCallback;
  }
  else
  {
    /* Update the error code */
    hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hjpeg);
  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_JPEG_UnRegisterGetDataCallback(JPEG_HandleTypeDef *hjpeg)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Process locked */
  __HAL_LOCK(hjpeg);

  if (HAL_JPEG_STATE_READY == hjpeg->State)
  {
    hjpeg->GetDataCallback = HAL_JPEG_GetDataCallback;  /* Legacy weak GetDataCallback  */
  }
  else
  {
    /* Update the error code */
    hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hjpeg);
  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_JPEG_RegisterDataReadyCallback(JPEG_HandleTypeDef *hjpeg,
                                                     pJPEG_DataReadyCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }
  /* Process locked */
  __HAL_LOCK(hjpeg);

  if (HAL_JPEG_STATE_READY == hjpeg->State)
  {
    hjpeg->DataReadyCallback = pCallback;
  }
  else
  {
    /* Update the error code */
    hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hjpeg);
  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_JPEG_UnRegisterDataReadyCallback(JPEG_HandleTypeDef *hjpeg)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Process locked */
  __HAL_LOCK(hjpeg);

  if (HAL_JPEG_STATE_READY == hjpeg->State)
  {
    hjpeg->DataReadyCallback = HAL_JPEG_DataReadyCallback;  /* Legacy weak DataReadyCallback  */
  }
  else
  {
    /* Update the error code */
    hjpeg->ErrorCode |= HAL_JPEG_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hjpeg);
  return status;
}
#endif

HAL_StatusTypeDef HAL_JPEG_ConfigEncoding(JPEG_HandleTypeDef *hjpeg, const JPEG_ConfTypeDef *pConf)
{
  uint32_t error;
  uint32_t numberMCU;
  uint32_t hfactor;
  uint32_t vfactor;
  uint32_t hMCU;
  uint32_t vMCU;

  /* Check the JPEG handle allocation */
  if ((hjpeg == NULL) || (pConf == NULL))
  {
    return HAL_ERROR;
  }
  else
  {
    /* Check the parameters */
    assert_param(IS_JPEG_COLORSPACE(pConf->ColorSpace));
    assert_param(IS_JPEG_CHROMASUBSAMPLING(pConf->ChromaSubsampling));
    assert_param(IS_JPEG_IMAGE_QUALITY(pConf->ImageQuality));

    /* Process Locked */
    __HAL_LOCK(hjpeg);

    if (hjpeg->State == HAL_JPEG_STATE_READY)
    {
      hjpeg->State = HAL_JPEG_STATE_BUSY;

      hjpeg->Conf.ColorSpace          =  pConf->ColorSpace;
      hjpeg->Conf.ChromaSubsampling   =  pConf->ChromaSubsampling;
      hjpeg->Conf.ImageHeight         =  pConf->ImageHeight;
      hjpeg->Conf.ImageWidth          =  pConf->ImageWidth;
      hjpeg->Conf.ImageQuality        =  pConf->ImageQuality;

      /* Reset the Color Space : by default only one quantization table is used*/
      hjpeg->Instance->CONFR1 &= ~JPEG_CONFR1_COLORSPACE;

      /* Set Number of color components*/
      if (hjpeg->Conf.ColorSpace == JPEG_GRAYSCALE_COLORSPACE)
      {
        /*Gray Scale is only one component 8x8 blocks i.e 4:4:4*/
        hjpeg->Conf.ChromaSubsampling = JPEG_444_SUBSAMPLING;

        JPEG_SetColorGrayScale(hjpeg);
        /* Set quantization table 0*/
        error = JPEG_Set_Quantization_Mem(hjpeg, hjpeg->QuantTable0, (hjpeg->Instance->QMEM0));
      }
      else if (hjpeg->Conf.ColorSpace == JPEG_YCBCR_COLORSPACE)
      {
        /*
           Set the Color Space for YCbCr : 2 quantization tables are used
           one for Luminance(Y) and one for both Chrominances (Cb & Cr)
          */
        hjpeg->Instance->CONFR1 |= JPEG_CONFR1_COLORSPACE_0;

        JPEG_SetColorYCBCR(hjpeg);

        /* Set quantization table 0*/
        error  = JPEG_Set_Quantization_Mem(hjpeg, hjpeg->QuantTable0, (hjpeg->Instance->QMEM0));
        /*By default quantization table 0 for component 0 and quantization table 1 for both components 1 and 2*/
        (void) JPEG_Set_Quantization_Mem(hjpeg, hjpeg->QuantTable1, (hjpeg->Instance->QMEM1));

        if ((hjpeg->Context & JPEG_CONTEXT_CUSTOM_TABLES) != 0UL)
        {
          /*Use user customized quantization tables , 1 table per component*/
          /* use 3 quantization tables , one for each component*/
          hjpeg->Instance->CONFR1 &= (~JPEG_CONFR1_COLORSPACE);
          hjpeg->Instance->CONFR1 |= JPEG_CONFR1_COLORSPACE_1;

          (void) JPEG_Set_Quantization_Mem(hjpeg, hjpeg->QuantTable2, (hjpeg->Instance->QMEM2));

          /*Use Quantization 1 table for component 1*/
          hjpeg->Instance->CONFR5 &= (~JPEG_CONFR5_QT);
          hjpeg->Instance->CONFR5 |=  JPEG_CONFR5_QT_0;

          /*Use Quantization 2 table for component 2*/
          hjpeg->Instance->CONFR6 &= (~JPEG_CONFR6_QT);
          hjpeg->Instance->CONFR6 |=  JPEG_CONFR6_QT_1;
        }
      }
      else /* ColorSpace == JPEG_CMYK_COLORSPACE */
      {
        JPEG_SetColorCMYK(hjpeg);

        /* Set quantization table 0*/
        error  = JPEG_Set_Quantization_Mem(hjpeg, hjpeg->QuantTable0, (hjpeg->Instance->QMEM0));
        /*By default quantization table 0 for All components*/

        if ((hjpeg->Context & JPEG_CONTEXT_CUSTOM_TABLES) != 0UL)
        {
          /*Use user customized quantization tables , 1 table per component*/
          /* use 4 quantization tables , one for each component*/
          hjpeg->Instance->CONFR1 |= JPEG_CONFR1_COLORSPACE;

          (void) JPEG_Set_Quantization_Mem(hjpeg, hjpeg->QuantTable1, (hjpeg->Instance->QMEM1));
          (void) JPEG_Set_Quantization_Mem(hjpeg, hjpeg->QuantTable2, (hjpeg->Instance->QMEM2));
          (void) JPEG_Set_Quantization_Mem(hjpeg, hjpeg->QuantTable3, (hjpeg->Instance->QMEM3));

          /*Use Quantization 1 table for component 1*/
          hjpeg->Instance->CONFR5 |=  JPEG_CONFR5_QT_0;

          /*Use Quantization 2 table for component 2*/
          hjpeg->Instance->CONFR6 |=  JPEG_CONFR6_QT_1;

          /*Use Quantization 3 table for component 3*/
          hjpeg->Instance->CONFR7 |=  JPEG_CONFR7_QT;
        }
      }

      if (error != 0UL)
      {
        hjpeg->ErrorCode = HAL_JPEG_ERROR_QUANT_TABLE;

        /* Process Unlocked */
        __HAL_UNLOCK(hjpeg);

        /* Set the JPEG State to ready */
        hjpeg->State = HAL_JPEG_STATE_READY;

        return  HAL_ERROR;
      }
      /* Set the image size*/
      /* set the number of lines*/
      MODIFY_REG(hjpeg->Instance->CONFR1, JPEG_CONFR1_YSIZE, ((hjpeg->Conf.ImageHeight & 0x0000FFFFUL) << 16));
      /* set the number of pixels per line*/
      MODIFY_REG(hjpeg->Instance->CONFR3, JPEG_CONFR3_XSIZE, ((hjpeg->Conf.ImageWidth & 0x0000FFFFUL) << 16));


      if (hjpeg->Conf.ChromaSubsampling == JPEG_420_SUBSAMPLING) /* 4:2:0*/
      {
        hfactor = 16;
        vfactor = 16;
      }
      else if (hjpeg->Conf.ChromaSubsampling == JPEG_422_SUBSAMPLING) /* 4:2:2*/
      {
        hfactor = 16;
        vfactor = 8;
      }
      else /* Default is 8x8 MCU,  4:4:4*/
      {
        hfactor = 8;
        vfactor = 8;
      }

      hMCU = (hjpeg->Conf.ImageWidth / hfactor);
      if ((hjpeg->Conf.ImageWidth % hfactor) != 0UL)
      {
        hMCU++; /*+1 for horizontal incomplete MCU */
      }

      vMCU = (hjpeg->Conf.ImageHeight / vfactor);
      if ((hjpeg->Conf.ImageHeight % vfactor) != 0UL)
      {
        vMCU++; /*+1 for vertical incomplete MCU */
      }

      numberMCU = (hMCU * vMCU) - 1UL; /* Bit Field JPEG_CONFR2_NMCU shall be set to NB_MCU - 1*/
      /* Set the number of MCU*/
      hjpeg->Instance->CONFR2 = (numberMCU & JPEG_CONFR2_NMCU);

      hjpeg->Context |= JPEG_CONTEXT_CONF_ENCODING;

      /* Process Unlocked */
      __HAL_UNLOCK(hjpeg);

      /* Set the JPEG State to ready */
      hjpeg->State = HAL_JPEG_STATE_READY;

      /* Return function status */
      return HAL_OK;
    }
    else
    {
      /* Process Unlocked */
      __HAL_UNLOCK(hjpeg);

      /* Return function status */
      return HAL_BUSY;
    }
  }
}

HAL_StatusTypeDef HAL_JPEG_GetInfo(JPEG_HandleTypeDef *hjpeg, JPEG_ConfTypeDef *pInfo)
{
  uint32_t yblockNb;
  uint32_t cBblockNb;
  uint32_t cRblockNb;

  /* Check the JPEG handle allocation */
  if ((hjpeg == NULL) || (pInfo == NULL))
  {
    return HAL_ERROR;
  }

  /*Read the conf parameters */
  if ((hjpeg->Instance->CONFR1 & JPEG_CONFR1_NF) == JPEG_CONFR1_NF_1)
  {
    pInfo->ColorSpace = JPEG_YCBCR_COLORSPACE;
  }
  else if ((hjpeg->Instance->CONFR1 & JPEG_CONFR1_NF) == 0UL)
  {
    pInfo->ColorSpace = JPEG_GRAYSCALE_COLORSPACE;
  }
  else if ((hjpeg->Instance->CONFR1 & JPEG_CONFR1_NF) == JPEG_CONFR1_NF)
  {
    pInfo->ColorSpace = JPEG_CMYK_COLORSPACE;
  }
  else
  {
    return HAL_ERROR;
  }

  pInfo->ImageHeight = (hjpeg->Instance->CONFR1 & 0xFFFF0000UL) >> 16;
  pInfo->ImageWidth  = (hjpeg->Instance->CONFR3 & 0xFFFF0000UL) >> 16;

  if ((pInfo->ColorSpace == JPEG_YCBCR_COLORSPACE) || (pInfo->ColorSpace == JPEG_CMYK_COLORSPACE))
  {
    yblockNb  = (hjpeg->Instance->CONFR4 & JPEG_CONFR4_NB) >> 4;
    cBblockNb = (hjpeg->Instance->CONFR5 & JPEG_CONFR5_NB) >> 4;
    cRblockNb = (hjpeg->Instance->CONFR6 & JPEG_CONFR6_NB) >> 4;

    if ((yblockNb == 1UL) && (cBblockNb == 0UL) && (cRblockNb == 0UL))
    {
      pInfo->ChromaSubsampling = JPEG_422_SUBSAMPLING; /*16x8 block*/
    }
    else if ((yblockNb == 0UL) && (cBblockNb == 0UL) && (cRblockNb == 0UL))
    {
      pInfo->ChromaSubsampling = JPEG_444_SUBSAMPLING;
    }
    else if ((yblockNb == 3UL) && (cBblockNb == 0UL) && (cRblockNb == 0UL))
    {
      pInfo->ChromaSubsampling = JPEG_420_SUBSAMPLING;
    }
    else /*Default is 4:4:4*/
    {
      pInfo->ChromaSubsampling = JPEG_444_SUBSAMPLING;
    }
  }
  else
  {
    pInfo->ChromaSubsampling = JPEG_444_SUBSAMPLING;
  }

  pInfo->ImageQuality = JPEG_GetQuality(hjpeg);

  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_JPEG_EnableHeaderParsing(JPEG_HandleTypeDef *hjpeg)
{
  /* Process locked */
  __HAL_LOCK(hjpeg);

  if (hjpeg->State == HAL_JPEG_STATE_READY)
  {
    /* Change the JPEG state */
    hjpeg->State = HAL_JPEG_STATE_BUSY;

    /* Enable header processing*/
    hjpeg->Instance->CONFR1 |= JPEG_CONFR1_HDR;

    /* Process unlocked */
    __HAL_UNLOCK(hjpeg);

    /* Change the JPEG state */
    hjpeg->State = HAL_JPEG_STATE_READY;

    return HAL_OK;
  }
  else
  {
    /* Process unlocked */
    __HAL_UNLOCK(hjpeg);

    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_JPEG_DisableHeaderParsing(JPEG_HandleTypeDef *hjpeg)
{
  /* Process locked */
  __HAL_LOCK(hjpeg);

  if (hjpeg->State == HAL_JPEG_STATE_READY)
  {
    /* Change the JPEG state */
    hjpeg->State = HAL_JPEG_STATE_BUSY;

    /* Disable header processing*/
    hjpeg->Instance->CONFR1 &= ~JPEG_CONFR1_HDR;

    /* Process unlocked */
    __HAL_UNLOCK(hjpeg);

    /* Change the JPEG state */
    hjpeg->State = HAL_JPEG_STATE_READY;

    return HAL_OK;
  }
  else
  {
    /* Process unlocked */
    __HAL_UNLOCK(hjpeg);

    return HAL_BUSY;
  }
}

HAL_StatusTypeDef  HAL_JPEG_SetUserQuantTables(JPEG_HandleTypeDef *hjpeg, uint8_t *QTable0, uint8_t *QTable1,
                                               uint8_t *QTable2, uint8_t *QTable3)
{
  /* Process Locked */
  __HAL_LOCK(hjpeg);

  if (hjpeg->State == HAL_JPEG_STATE_READY)
  {
    /* Change the DMA state */
    hjpeg->State = HAL_JPEG_STATE_BUSY;

    hjpeg->Context |= JPEG_CONTEXT_CUSTOM_TABLES;

    hjpeg->QuantTable0 = QTable0;
    hjpeg->QuantTable1 = QTable1;
    hjpeg->QuantTable2 = QTable2;
    hjpeg->QuantTable3 = QTable3;

    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);

    /* Change the DMA state */
    hjpeg->State = HAL_JPEG_STATE_READY;

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);

    return HAL_BUSY;
  }
}

HAL_StatusTypeDef  HAL_JPEG_Encode(JPEG_HandleTypeDef *hjpeg, uint8_t *pDataInMCU, uint32_t InDataLength,
                                   uint8_t *pDataOut, uint32_t OutDataLength, uint32_t Timeout)
{
  uint32_t tickstart;

  /* Check the parameters */
  assert_param((InDataLength >= 4UL));
  assert_param((OutDataLength >= 4UL));

  /* Check In/out buffer allocation and size */
  if ((hjpeg == NULL) || (pDataInMCU == NULL) || (pDataOut == NULL))
  {
    return HAL_ERROR;
  }
  /* Process locked */
  __HAL_LOCK(hjpeg);

  if (hjpeg->State != HAL_JPEG_STATE_READY)
  {
    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);

    return HAL_BUSY;
  }

  if (hjpeg->State == HAL_JPEG_STATE_READY)
  {
    if ((hjpeg->Context & JPEG_CONTEXT_CONF_ENCODING) == JPEG_CONTEXT_CONF_ENCODING)
    {
      /*Change JPEG state*/
      hjpeg->State = HAL_JPEG_STATE_BUSY_ENCODING;

      /*Set the Context to Encode with Polling*/
      hjpeg->Context &= ~(JPEG_CONTEXT_OPERATION_MASK | JPEG_CONTEXT_METHOD_MASK);
      hjpeg->Context |= (JPEG_CONTEXT_ENCODE | JPEG_CONTEXT_POLLING);

      /* Get tick */
      tickstart = HAL_GetTick();

      /*Store In/out buffers pointers and size*/
      hjpeg->pJpegInBuffPtr = pDataInMCU;
      hjpeg->pJpegOutBuffPtr = pDataOut;
      hjpeg->InDataLength = InDataLength - (InDataLength % 4UL);    /* In Data length must be multiple
                                                                       of 4 Bytes (1 word)*/
      hjpeg->OutDataLength = OutDataLength - (OutDataLength % 4UL); /* Out Data length must be multiple
                                                                       of 4 Bytes (1 word)*/

      /*Reset In/out data counter */
      hjpeg->JpegInCount = 0;
      hjpeg->JpegOutCount = 0;

      /*Init decoding process*/
      JPEG_Init_Process(hjpeg);

      /*JPEG data processing : In/Out FIFO transfer*/
      while ((JPEG_Process(hjpeg) == JPEG_PROCESS_ONGOING))
      {
        if (Timeout != HAL_MAX_DELAY)
        {
          if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0UL))
          {

            /* Update error code */
            hjpeg->ErrorCode |= HAL_JPEG_ERROR_TIMEOUT;

            /* Process Unlocked */
            __HAL_UNLOCK(hjpeg);

            /*Change JPEG state*/
            hjpeg->State = HAL_JPEG_STATE_READY;

            return HAL_TIMEOUT;
          }
        }
      }

      /* Process Unlocked */
      __HAL_UNLOCK(hjpeg);

      /*Change JPEG state*/
      hjpeg->State = HAL_JPEG_STATE_READY;

    }
    else
    {
      /* Process Unlocked */
      __HAL_UNLOCK(hjpeg);

      return HAL_ERROR;
    }
  }
  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef  HAL_JPEG_Decode(JPEG_HandleTypeDef *hjpeg, uint8_t *pDataIn, uint32_t InDataLength,
                                   uint8_t *pDataOutMCU, uint32_t OutDataLength, uint32_t Timeout)
{
  uint32_t tickstart;

  /* Check the parameters */
  assert_param((InDataLength >= 4UL));
  assert_param((OutDataLength >= 4UL));

  /* Check In/out buffer allocation and size */
  if ((hjpeg == NULL) || (pDataIn == NULL) || (pDataOutMCU == NULL))
  {
    return HAL_ERROR;
  }

  /* Process Locked */
  __HAL_LOCK(hjpeg);

  /* Get tick */
  tickstart = HAL_GetTick();

  if (hjpeg->State == HAL_JPEG_STATE_READY)
  {
    /*Change JPEG state*/
    hjpeg->State = HAL_JPEG_STATE_BUSY_DECODING;

    /*Set the Context to Decode with Polling*/
    /*Set the Context to Encode with Polling*/
    hjpeg->Context &= ~(JPEG_CONTEXT_OPERATION_MASK | JPEG_CONTEXT_METHOD_MASK);
    hjpeg->Context |= (JPEG_CONTEXT_DECODE | JPEG_CONTEXT_POLLING);

    /*Store In/out buffers pointers and size*/
    hjpeg->pJpegInBuffPtr = pDataIn;
    hjpeg->pJpegOutBuffPtr = pDataOutMCU;
    hjpeg->InDataLength = InDataLength - (InDataLength % 4UL);    /*In Data length must be multiple
                                                                    of 4 Bytes (1 word)*/
    hjpeg->OutDataLength = OutDataLength - (OutDataLength % 4UL); /*Out Data length must be multiple
                                                                    of 4 Bytes (1 word)*/

    /*Reset In/out data counter */
    hjpeg->JpegInCount = 0;
    hjpeg->JpegOutCount = 0;

    /*Init decoding process*/
    JPEG_Init_Process(hjpeg);

    /*JPEG data processing : In/Out FIFO transfer*/
    while ((JPEG_Process(hjpeg) == JPEG_PROCESS_ONGOING))
    {
      if (Timeout != HAL_MAX_DELAY)
      {
        if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0UL))
        {

          /* Update error code */
          hjpeg->ErrorCode |= HAL_JPEG_ERROR_TIMEOUT;

          /* Process Unlocked */
          __HAL_UNLOCK(hjpeg);

          /*Change JPEG state*/
          hjpeg->State = HAL_JPEG_STATE_READY;

          return HAL_TIMEOUT;
        }
      }
    }

    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);

    /*Change JPEG state*/
    hjpeg->State = HAL_JPEG_STATE_READY;

  }
  else
  {
    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);

    return HAL_BUSY;
  }
  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef  HAL_JPEG_Encode_IT(JPEG_HandleTypeDef *hjpeg, uint8_t *pDataInMCU, uint32_t InDataLength,
                                      uint8_t *pDataOut, uint32_t OutDataLength)
{
  /* Check the parameters */
  assert_param((InDataLength >= 4UL));
  assert_param((OutDataLength >= 4UL));

  /* Check In/out buffer allocation and size */
  if ((hjpeg == NULL) || (pDataInMCU == NULL) || (pDataOut == NULL))
  {
    return HAL_ERROR;
  }

  /* Process Locked */
  __HAL_LOCK(hjpeg);

  if (hjpeg->State != HAL_JPEG_STATE_READY)
  {
    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);

    return HAL_BUSY;
  }
  else
  {
    if ((hjpeg->Context & JPEG_CONTEXT_CONF_ENCODING) == JPEG_CONTEXT_CONF_ENCODING)
    {
      /*Change JPEG state*/
      hjpeg->State = HAL_JPEG_STATE_BUSY_ENCODING;

      /*Set the Context to Encode with IT*/
      hjpeg->Context &= ~(JPEG_CONTEXT_OPERATION_MASK | JPEG_CONTEXT_METHOD_MASK);
      hjpeg->Context |= (JPEG_CONTEXT_ENCODE | JPEG_CONTEXT_IT);

      /*Store In/out buffers pointers and size*/
      hjpeg->pJpegInBuffPtr = pDataInMCU;
      hjpeg->pJpegOutBuffPtr = pDataOut;
      hjpeg->InDataLength = InDataLength - (InDataLength % 4UL);    /*In Data length must be multiple
                                                                      of 4 Bytes (1 word)*/
      hjpeg->OutDataLength = OutDataLength - (OutDataLength % 4UL); /*Out Data length must be multiple
                                                                      of 4 Bytes (1 word)*/

      /*Reset In/out data counter */
      hjpeg->JpegInCount = 0;
      hjpeg->JpegOutCount = 0;

      /*Init decoding process*/
      JPEG_Init_Process(hjpeg);

    }
    else
    {
      /* Process Unlocked */
      __HAL_UNLOCK(hjpeg);

      return HAL_ERROR;
    }
  }
  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef  HAL_JPEG_Decode_IT(JPEG_HandleTypeDef *hjpeg, uint8_t *pDataIn, uint32_t InDataLength,
                                      uint8_t *pDataOutMCU, uint32_t OutDataLength)
{
  /* Check the parameters */
  assert_param((InDataLength >= 4UL));
  assert_param((OutDataLength >= 4UL));

  /* Check In/out buffer allocation and size */
  if ((hjpeg == NULL) || (pDataIn == NULL) || (pDataOutMCU == NULL))
  {
    return HAL_ERROR;
  }

  /* Process Locked */
  __HAL_LOCK(hjpeg);

  if (hjpeg->State == HAL_JPEG_STATE_READY)
  {
    /*Change JPEG state*/
    hjpeg->State = HAL_JPEG_STATE_BUSY_DECODING;

    /*Set the Context to Decode with IT*/
    hjpeg->Context &= ~(JPEG_CONTEXT_OPERATION_MASK | JPEG_CONTEXT_METHOD_MASK);
    hjpeg->Context |= (JPEG_CONTEXT_DECODE | JPEG_CONTEXT_IT);

    /*Store In/out buffers pointers and size*/
    hjpeg->pJpegInBuffPtr = pDataIn;
    hjpeg->pJpegOutBuffPtr = pDataOutMCU;
    hjpeg->InDataLength = InDataLength - (InDataLength % 4UL);    /*In Data length must be multiple
                                                                    of 4 Bytes (1 word)*/
    hjpeg->OutDataLength = OutDataLength - (OutDataLength % 4UL); /*Out Data length must be multiple
                                                                    of 4 Bytes (1 word)*/

    /*Reset In/out data counter */
    hjpeg->JpegInCount = 0;
    hjpeg->JpegOutCount = 0;

    /*Init decoding process*/
    JPEG_Init_Process(hjpeg);

  }
  else
  {
    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);

    return HAL_BUSY;
  }
  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef  HAL_JPEG_Encode_DMA(JPEG_HandleTypeDef *hjpeg, uint8_t *pDataInMCU, uint32_t InDataLength,
                                       uint8_t *pDataOut, uint32_t OutDataLength)
{
  /* Check the parameters */
  assert_param((InDataLength >= 4UL));
  assert_param((OutDataLength >= 4UL));

  /* Check In/out buffer allocation and size */
  if ((hjpeg == NULL) || (pDataInMCU == NULL) || (pDataOut == NULL))
  {
    return HAL_ERROR;
  }

  /* Process Locked */
  __HAL_LOCK(hjpeg);

  if (hjpeg->State != HAL_JPEG_STATE_READY)
  {
    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);

    return HAL_BUSY;
  }
  else
  {
    if ((hjpeg->Context & JPEG_CONTEXT_CONF_ENCODING) == JPEG_CONTEXT_CONF_ENCODING)
    {
      /*Change JPEG state*/
      hjpeg->State = HAL_JPEG_STATE_BUSY_ENCODING;

      /*Set the Context to Encode with DMA*/
      hjpeg->Context &= ~(JPEG_CONTEXT_OPERATION_MASK | JPEG_CONTEXT_METHOD_MASK);
      hjpeg->Context |= (JPEG_CONTEXT_ENCODE | JPEG_CONTEXT_DMA);

      /*Store In/out buffers pointers and size*/
      hjpeg->pJpegInBuffPtr = pDataInMCU;
      hjpeg->pJpegOutBuffPtr = pDataOut;
      hjpeg->InDataLength = InDataLength;
      hjpeg->OutDataLength = OutDataLength;

      /*Reset In/out data counter */
      hjpeg->JpegInCount = 0;
      hjpeg->JpegOutCount = 0;

      /*Init decoding process*/
      JPEG_Init_Process(hjpeg);

      /* JPEG encoding process using DMA */
      if (JPEG_DMA_StartProcess(hjpeg) != HAL_OK)
      {
        /* Update State */
        hjpeg->State = HAL_JPEG_STATE_ERROR;
        /* Process Unlocked */
        __HAL_UNLOCK(hjpeg);

        return HAL_ERROR;
      }

    }
    else
    {
      /* Process Unlocked */
      __HAL_UNLOCK(hjpeg);

      return HAL_ERROR;
    }
  }
  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef  HAL_JPEG_Decode_DMA(JPEG_HandleTypeDef *hjpeg, uint8_t *pDataIn, uint32_t InDataLength,
                                       uint8_t *pDataOutMCU, uint32_t OutDataLength)
{
  /* Check the parameters */
  assert_param((InDataLength >= 4UL));
  assert_param((OutDataLength >= 4UL));

  /* Check In/out buffer allocation and size */
  if ((hjpeg == NULL) || (pDataIn == NULL) || (pDataOutMCU == NULL))
  {
    return HAL_ERROR;
  }

  /* Process Locked */
  __HAL_LOCK(hjpeg);

  if (hjpeg->State == HAL_JPEG_STATE_READY)
  {
    /*Change JPEG state*/
    hjpeg->State = HAL_JPEG_STATE_BUSY_DECODING;

    /*Set the Context to Decode with DMA*/
    hjpeg->Context &= ~(JPEG_CONTEXT_OPERATION_MASK | JPEG_CONTEXT_METHOD_MASK);
    hjpeg->Context |= (JPEG_CONTEXT_DECODE | JPEG_CONTEXT_DMA);

    /*Store In/out buffers pointers and size*/
    hjpeg->pJpegInBuffPtr = pDataIn;
    hjpeg->pJpegOutBuffPtr = pDataOutMCU;
    hjpeg->InDataLength = InDataLength;
    hjpeg->OutDataLength = OutDataLength;

    /*Reset In/out data counter */
    hjpeg->JpegInCount = 0;
    hjpeg->JpegOutCount = 0;

    /*Init decoding process*/
    JPEG_Init_Process(hjpeg);

    /* JPEG decoding process using DMA */
    if (JPEG_DMA_StartProcess(hjpeg) != HAL_OK)
    {
      /* Update State */
      hjpeg->State = HAL_JPEG_STATE_ERROR;
      /* Process Unlocked */
      __HAL_UNLOCK(hjpeg);

      return HAL_ERROR;
    }
  }
  else
  {
    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);

    return HAL_BUSY;
  }
  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef  HAL_JPEG_Pause(JPEG_HandleTypeDef *hjpeg, uint32_t XferSelection)
{
  uint32_t mask = 0;

  assert_param(IS_JPEG_PAUSE_RESUME_STATE(XferSelection));

  if ((hjpeg->Context & JPEG_CONTEXT_METHOD_MASK) == JPEG_CONTEXT_DMA)
  {
    if ((XferSelection & JPEG_PAUSE_RESUME_INPUT) == JPEG_PAUSE_RESUME_INPUT)
    {
      hjpeg->Context |= JPEG_CONTEXT_PAUSE_INPUT;
      mask |= JPEG_DMA_IDMA;
    }
    if ((XferSelection & JPEG_PAUSE_RESUME_OUTPUT) == JPEG_PAUSE_RESUME_OUTPUT)
    {
      hjpeg->Context |= JPEG_CONTEXT_PAUSE_OUTPUT;
      mask |= JPEG_DMA_ODMA;
    }
    JPEG_DISABLE_DMA(hjpeg, mask);

  }
  else if ((hjpeg->Context & JPEG_CONTEXT_METHOD_MASK) == JPEG_CONTEXT_IT)
  {

    if ((XferSelection & JPEG_PAUSE_RESUME_INPUT) == JPEG_PAUSE_RESUME_INPUT)
    {
      hjpeg->Context |= JPEG_CONTEXT_PAUSE_INPUT;
      mask |= (JPEG_IT_IFT | JPEG_IT_IFNF);
    }
    if ((XferSelection & JPEG_PAUSE_RESUME_OUTPUT) == JPEG_PAUSE_RESUME_OUTPUT)
    {
      hjpeg->Context |= JPEG_CONTEXT_PAUSE_OUTPUT;
      mask |= (JPEG_IT_OFT | JPEG_IT_OFNE | JPEG_IT_EOC);
    }
    __HAL_JPEG_DISABLE_IT(hjpeg, mask);

  }
  else
  {
    /* Nothing to do */
  }

  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef  HAL_JPEG_Resume(JPEG_HandleTypeDef *hjpeg, uint32_t XferSelection)
{
  uint32_t mask = 0;

  assert_param(IS_JPEG_PAUSE_RESUME_STATE(XferSelection));

  if ((hjpeg->Context & (JPEG_CONTEXT_PAUSE_INPUT | JPEG_CONTEXT_PAUSE_OUTPUT)) == 0UL)
  {
    /* if nothing paused to resume return error*/
    return HAL_ERROR;
  }

  if ((hjpeg->Context & JPEG_CONTEXT_METHOD_MASK) == JPEG_CONTEXT_DMA)
  {

    if ((XferSelection & JPEG_PAUSE_RESUME_INPUT) == JPEG_PAUSE_RESUME_INPUT)
    {
      hjpeg->Context &= (~JPEG_CONTEXT_PAUSE_INPUT);
      mask |= JPEG_DMA_IDMA;

      /*JPEG Input DMA transfer data number must be multiple of DMA buffer size
        as the destination is a 32 bits register */
      hjpeg->InDataLength = hjpeg->InDataLength - (hjpeg->InDataLength % 4UL);

      if (hjpeg->InDataLength > 0UL)
      {
        /* Start DMA FIFO In transfer */
        if (HAL_DMA_Start_IT(hjpeg->hdmain, (uint32_t)hjpeg->pJpegInBuffPtr, (uint32_t)&hjpeg->Instance->DIR,
                             hjpeg->InDataLength) != HAL_OK)
        {
          hjpeg->ErrorCode |= HAL_JPEG_ERROR_DMA;
          hjpeg->State = HAL_JPEG_STATE_ERROR;
          return HAL_ERROR;
        }
      }
    }
    if ((XferSelection & JPEG_PAUSE_RESUME_OUTPUT) == JPEG_PAUSE_RESUME_OUTPUT)
    {
      hjpeg->Context &= (~JPEG_CONTEXT_PAUSE_OUTPUT);

      if ((hjpeg->Context & JPEG_CONTEXT_ENDING_DMA) != 0UL)
      {
        JPEG_DMA_PollResidualData(hjpeg);
      }
      else
      {
        mask |= JPEG_DMA_ODMA;

        /* Start DMA FIFO Out transfer */
        if (HAL_DMA_Start_IT(hjpeg->hdmaout, (uint32_t)&hjpeg->Instance->DOR, (uint32_t)hjpeg->pJpegOutBuffPtr,
                             hjpeg->OutDataLength) != HAL_OK)
        {
          hjpeg->ErrorCode |= HAL_JPEG_ERROR_DMA;
          hjpeg->State = HAL_JPEG_STATE_ERROR;
          return HAL_ERROR;
        }
      }

    }
    JPEG_ENABLE_DMA(hjpeg, mask);

  }
  else if ((hjpeg->Context & JPEG_CONTEXT_METHOD_MASK) == JPEG_CONTEXT_IT)
  {
    if ((XferSelection & JPEG_PAUSE_RESUME_INPUT) == JPEG_PAUSE_RESUME_INPUT)
    {
      hjpeg->Context &= (~JPEG_CONTEXT_PAUSE_INPUT);
      mask |= (JPEG_IT_IFT | JPEG_IT_IFNF);
    }
    if ((XferSelection & JPEG_PAUSE_RESUME_OUTPUT) == JPEG_PAUSE_RESUME_OUTPUT)
    {
      hjpeg->Context &= (~JPEG_CONTEXT_PAUSE_OUTPUT);
      mask |= (JPEG_IT_OFT | JPEG_IT_OFNE | JPEG_IT_EOC);
    }
    __HAL_JPEG_ENABLE_IT(hjpeg, mask);

  }
  else
  {
    /* Nothing to do */
  }

  /* Return function status */
  return HAL_OK;
}

void HAL_JPEG_ConfigInputBuffer(JPEG_HandleTypeDef *hjpeg, uint8_t *pNewInputBuffer, uint32_t InDataLength)
{
  hjpeg->pJpegInBuffPtr =  pNewInputBuffer;
  hjpeg->InDataLength = InDataLength;
}

void HAL_JPEG_ConfigOutputBuffer(JPEG_HandleTypeDef *hjpeg, uint8_t *pNewOutputBuffer, uint32_t OutDataLength)
{
  hjpeg->pJpegOutBuffPtr = pNewOutputBuffer;
  hjpeg->OutDataLength = OutDataLength;
}

HAL_StatusTypeDef HAL_JPEG_Abort(JPEG_HandleTypeDef *hjpeg)
{
  uint32_t tickstart;
  uint32_t tmpContext;
  tmpContext = hjpeg->Context;

  /*Reset the Context operation and method*/
  hjpeg->Context &= ~(JPEG_CONTEXT_OPERATION_MASK | JPEG_CONTEXT_METHOD_MASK | JPEG_CONTEXT_ENDING_DMA);

  if ((tmpContext & JPEG_CONTEXT_METHOD_MASK) == JPEG_CONTEXT_DMA)
  {
    /* Stop the DMA In/out Xfer*/
    if (HAL_DMA_Abort(hjpeg->hdmaout) != HAL_OK)
    {
      if (hjpeg->hdmaout->ErrorCode == HAL_DMA_ERROR_TIMEOUT)
      {
        hjpeg->ErrorCode |= HAL_JPEG_ERROR_DMA;
      }
    }
    if (HAL_DMA_Abort(hjpeg->hdmain) != HAL_OK)
    {
      if (hjpeg->hdmain->ErrorCode == HAL_DMA_ERROR_TIMEOUT)
      {
        hjpeg->ErrorCode |= HAL_JPEG_ERROR_DMA;
      }
    }

  }

  /* Stop the JPEG encoding/decoding process*/
  hjpeg->Instance->CONFR0 &=  ~JPEG_CONFR0_START;

  /* Get tick */
  tickstart = HAL_GetTick();

  /* Check if the JPEG Codec is effectively disabled */
  while (__HAL_JPEG_GET_FLAG(hjpeg, JPEG_FLAG_COF) != 0UL)
  {
    /* Check for the Timeout */
    if ((HAL_GetTick() - tickstart) > JPEG_TIMEOUT_VALUE)
    {
      /* Update error code */
      hjpeg->ErrorCode |= HAL_JPEG_ERROR_TIMEOUT;

      /* Change the DMA state */
      hjpeg->State = HAL_JPEG_STATE_ERROR;
      break;
    }
  }

  /* Disable All Interrupts */
  __HAL_JPEG_DISABLE_IT(hjpeg, JPEG_INTERRUPT_MASK);

  /* Disable All DMA requests */
  JPEG_DISABLE_DMA(hjpeg, JPEG_DMA_MASK);

  /* Flush input and output FIFOs*/
  hjpeg->Instance->CR |= JPEG_CR_IFF;
  hjpeg->Instance->CR |= JPEG_CR_OFF;

  /* Clear all flags */
  __HAL_JPEG_CLEAR_FLAG(hjpeg, JPEG_FLAG_ALL);

  /* Reset JpegInCount and JpegOutCount */
  hjpeg->JpegInCount = 0;
  hjpeg->JpegOutCount = 0;

  /*Reset the Context Pause*/
  hjpeg->Context &= ~(JPEG_CONTEXT_PAUSE_INPUT | JPEG_CONTEXT_PAUSE_OUTPUT);

  /* Change the DMA state*/
  if (hjpeg->ErrorCode != HAL_JPEG_ERROR_NONE)
  {
    hjpeg->State = HAL_JPEG_STATE_ERROR;
    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);
    /* Return function status */
    return HAL_ERROR;
  }
  else
  {
    hjpeg->State = HAL_JPEG_STATE_READY;
    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);
    /* Return function status */
    return HAL_OK;
  }

}

void HAL_JPEG_IRQHandler(JPEG_HandleTypeDef *hjpeg)
{
  switch (hjpeg->State)
  {
    case HAL_JPEG_STATE_BUSY_ENCODING:
    case HAL_JPEG_STATE_BUSY_DECODING:
      /* continue JPEG data encoding/Decoding*/
      /* JPEG data processing : In/Out FIFO transfer*/
      if ((hjpeg->Context & JPEG_CONTEXT_METHOD_MASK) == JPEG_CONTEXT_IT)
      {
        (void) JPEG_Process(hjpeg);
      }
      else if ((hjpeg->Context & JPEG_CONTEXT_METHOD_MASK) == JPEG_CONTEXT_DMA)
      {
        JPEG_DMA_ContinueProcess(hjpeg);
      }
      else
      {
        /* Nothing to do */
      }
      break;

    default:
      break;
  }
}

HAL_JPEG_STATETypeDef HAL_JPEG_GetState(const JPEG_HandleTypeDef *hjpeg)
{
  return hjpeg->State;
}

uint32_t HAL_JPEG_GetError(const JPEG_HandleTypeDef *hjpeg)
{
  return hjpeg->ErrorCode;
}

static HAL_StatusTypeDef JPEG_Bits_To_SizeCodes(const uint8_t *Bits, uint8_t *Huffsize, uint32_t *Huffcode,
                                                uint32_t *LastK)
{
  uint32_t i;
  uint32_t j;
  uint32_t k;
  uint32_t code;
  uint32_t si;

  /* Figure C.1: Generation of table of Huffman code sizes */
  j = 0;
  for (k = 0; k < 16UL; k++)
  {
    i = (uint32_t)Bits[k];
    if ((j + i) > 256UL)
    {
      /* check for table overflow */
      return HAL_ERROR;
    }
    while (i != 0UL)
    {
      Huffsize[j] = (uint8_t) k + 1U;
      j++;
      i--;
    }
  }
  Huffsize[j] = 0;
  *LastK = j;

  /* Figure C.2: Generation of table of Huffman codes */
  code = 0;
  si = Huffsize[0];
  j = 0;
  while (Huffsize[j] != 0U)
  {
    while (((uint32_t) Huffsize[j]) == si)
    {
      Huffcode[j] = code;
      j++;
      code++;
    }
    /* code must fit in "size" bits (si), no code is allowed to be all ones*/
    if (si > 31UL)
    {
      return HAL_ERROR;
    }
    if (((uint32_t) code) >= (((uint32_t) 1) << si))
    {
      return HAL_ERROR;
    }
    code <<= 1;
    si++;
  }
  /* Return function status */
  return HAL_OK;
}

static HAL_StatusTypeDef JPEG_ACHuff_BitsVals_To_SizeCodes(JPEG_ACHuffTableTypeDef *AC_BitsValsTable,
                                                           JPEG_AC_HuffCodeTableTypeDef *AC_SizeCodesTable)
{
  HAL_StatusTypeDef error;
  uint8_t huffsize[257];
  uint32_t huffcode[257];
  uint32_t k;
  uint32_t i;
  uint32_t lsb;
  uint32_t msb;
  uint32_t lastK;

  error = JPEG_Bits_To_SizeCodes(AC_BitsValsTable->Bits, huffsize, huffcode, &lastK);
  if (error != HAL_OK)
  {
    return  error;
  }

  /* Figure C.3: Ordering procedure for encoding procedure code tables */
  k = 0;

  while (k < lastK)
  {
    i = AC_BitsValsTable->HuffVal[k];
    if (i == 0UL)
    {
      i = JPEG_AC_HUFF_TABLE_SIZE - 2UL; /*i = 0x00 EOB code*/
    }
    else if (i == 0xF0UL) /* i = 0xF0 ZRL code*/
    {
      i = JPEG_AC_HUFF_TABLE_SIZE - 1UL;
    }
    else
    {
      msb = (i & 0xF0UL) >> 4;
      lsb = (i & 0x0FUL);
      i = (msb * 10UL) + lsb - 1UL;
    }
    if (i >= JPEG_AC_HUFF_TABLE_SIZE)
    {
      return HAL_ERROR; /* Huffman Table overflow error*/
    }
    else
    {
      AC_SizeCodesTable->HuffmanCode[i] = huffcode[k];
      AC_SizeCodesTable->CodeLength[i] = huffsize[k] - 1U;
      k++;
    }
  }

  /* Return function status */
  return HAL_OK;
}

static HAL_StatusTypeDef JPEG_DCHuff_BitsVals_To_SizeCodes(JPEG_DCHuffTableTypeDef *DC_BitsValsTable,
                                                           JPEG_DC_HuffCodeTableTypeDef *DC_SizeCodesTable)
{
  HAL_StatusTypeDef error;

  uint32_t k;
  uint32_t i;
  uint32_t lastK;
  uint8_t huffsize[257];
  uint32_t huffcode[257];
  error = JPEG_Bits_To_SizeCodes(DC_BitsValsTable->Bits, huffsize, huffcode, &lastK);
  if (error != HAL_OK)
  {
    return  error;
  }
  /* Figure C.3: ordering procedure for encoding procedure code tables */
  k = 0;

  while (k < lastK)
  {
    i = DC_BitsValsTable->HuffVal[k];
    if (i >= JPEG_DC_HUFF_TABLE_SIZE)
    {
      return HAL_ERROR; /* Huffman Table overflow error*/
    }
    else
    {
      DC_SizeCodesTable->HuffmanCode[i] = huffcode[k];
      DC_SizeCodesTable->CodeLength[i] = huffsize[k] - 1U;
      k++;
    }
  }

  /* Return function status */
  return HAL_OK;
}

static HAL_StatusTypeDef JPEG_Set_HuffDC_Mem(const JPEG_HandleTypeDef *hjpeg, JPEG_DCHuffTableTypeDef *HuffTableDC,
                                             const __IO uint32_t *DCTableAddress)
{
  HAL_StatusTypeDef error;
  JPEG_DC_HuffCodeTableTypeDef dcSizeCodesTable;
  uint32_t i;
  uint32_t lsb;
  uint32_t msb;
  __IO uint32_t *address;
  __IO uint32_t *addressDef;

  if (DCTableAddress == (hjpeg->Instance->HUFFENC_DC0))
  {
    address = (hjpeg->Instance->HUFFENC_DC0 + (JPEG_DC_HUFF_TABLE_SIZE / 2UL));
  }
  else if (DCTableAddress == (hjpeg->Instance->HUFFENC_DC1))
  {
    address = (hjpeg->Instance->HUFFENC_DC1 + (JPEG_DC_HUFF_TABLE_SIZE / 2UL));
  }
  else
  {
    return HAL_ERROR;
  }

  if (HuffTableDC != NULL)
  {
    error = JPEG_DCHuff_BitsVals_To_SizeCodes(HuffTableDC, &dcSizeCodesTable);
    if (error != HAL_OK)
    {
      return  error;
    }
    addressDef = address;
    *addressDef = 0x0FFF0FFF;
    addressDef++;
    *addressDef = 0x0FFF0FFF;

    i = JPEG_DC_HUFF_TABLE_SIZE;
    while (i > 1UL)
    {
      i--;
      address --;
      msb = ((uint32_t)(((uint32_t)dcSizeCodesTable.CodeLength[i] & 0xFU) << 8)) |
            ((uint32_t)dcSizeCodesTable.HuffmanCode[i] & 0xFFUL);
      i--;
      lsb = ((uint32_t)(((uint32_t)dcSizeCodesTable.CodeLength[i] & 0xFU) << 8)) |
            ((uint32_t)dcSizeCodesTable.HuffmanCode[i] & 0xFFUL);

      *address = lsb | (msb << 16);
    }
  }

  /* Return function status */
  return HAL_OK;
}

static HAL_StatusTypeDef JPEG_Set_HuffAC_Mem(const JPEG_HandleTypeDef *hjpeg, JPEG_ACHuffTableTypeDef *HuffTableAC,
                                             const __IO uint32_t *ACTableAddress)
{
  HAL_StatusTypeDef error;
  JPEG_AC_HuffCodeTableTypeDef acSizeCodesTable;
  uint32_t i;
  uint32_t lsb;
  uint32_t msb;
  __IO uint32_t *address;
  __IO uint32_t *addressDef;

  if (ACTableAddress == (hjpeg->Instance->HUFFENC_AC0))
  {
    address = (hjpeg->Instance->HUFFENC_AC0 + (JPEG_AC_HUFF_TABLE_SIZE / 2UL));
  }
  else if (ACTableAddress == (hjpeg->Instance->HUFFENC_AC1))
  {
    address = (hjpeg->Instance->HUFFENC_AC1 + (JPEG_AC_HUFF_TABLE_SIZE / 2UL));
  }
  else
  {
    return HAL_ERROR;
  }

  if (HuffTableAC != NULL)
  {
    error = JPEG_ACHuff_BitsVals_To_SizeCodes(HuffTableAC, &acSizeCodesTable);
    if (error != HAL_OK)
    {
      return  error;
    }
    /* Default values settings: 162:167 FFFh , 168:175 FD0h_FD7h */
    /* Locations 162:175 of each AC table contain information used internally by the core */

    addressDef = address;
    for (i = 0; i < 3UL; i++)
    {
      *addressDef = 0x0FFF0FFF;
      addressDef++;
    }
    *addressDef = 0x0FD10FD0;
    addressDef++;
    *addressDef = 0x0FD30FD2;
    addressDef++;
    *addressDef = 0x0FD50FD4;
    addressDef++;
    *addressDef = 0x0FD70FD6;
    /* end of Locations 162:175  */


    i = JPEG_AC_HUFF_TABLE_SIZE;
    while (i > 1UL)
    {
      i--;
      address--;
      msb = ((uint32_t)(((uint32_t)acSizeCodesTable.CodeLength[i] & 0xFU) << 8)) |
            ((uint32_t)acSizeCodesTable.HuffmanCode[i] & 0xFFUL);
      i--;
      lsb = ((uint32_t)(((uint32_t)acSizeCodesTable.CodeLength[i] & 0xFU) << 8)) |
            ((uint32_t)acSizeCodesTable.HuffmanCode[i] & 0xFFUL);

      *address = lsb | (msb << 16);
    }
  }

  /* Return function status */
  return HAL_OK;
}

static HAL_StatusTypeDef JPEG_Set_HuffEnc_Mem(JPEG_HandleTypeDef *hjpeg)
{
  HAL_StatusTypeDef error;

  JPEG_Set_Huff_DHTMem(hjpeg);
  error = JPEG_Set_HuffAC_Mem(hjpeg, (JPEG_ACHuffTableTypeDef *)(uintptr_t)&JPEG_ACLUM_HuffTable,
                              (hjpeg->Instance->HUFFENC_AC0));
  if (error != HAL_OK)
  {
    return  error;
  }

  error = JPEG_Set_HuffAC_Mem(hjpeg, (JPEG_ACHuffTableTypeDef *)(uintptr_t)&JPEG_ACCHROM_HuffTable,
                              (hjpeg->Instance->HUFFENC_AC1));
  if (error != HAL_OK)
  {
    return  error;
  }

  error = JPEG_Set_HuffDC_Mem(hjpeg, (JPEG_DCHuffTableTypeDef *)(uintptr_t)&JPEG_DCLUM_HuffTable,
                              hjpeg->Instance->HUFFENC_DC0);
  if (error != HAL_OK)
  {
    return  error;
  }

  error = JPEG_Set_HuffDC_Mem(hjpeg, (JPEG_DCHuffTableTypeDef *)(uintptr_t)&JPEG_DCCHROM_HuffTable,
                              hjpeg->Instance->HUFFENC_DC1);
  if (error != HAL_OK)
  {
    return  error;
  }
  /* Return function status */
  return HAL_OK;
}

static void JPEG_Set_Huff_DHTMem(const JPEG_HandleTypeDef *hjpeg)
{
  const JPEG_ACHuffTableTypeDef *HuffTableAC0 = (JPEG_ACHuffTableTypeDef *)(uintptr_t)&JPEG_ACLUM_HuffTable;
  const JPEG_ACHuffTableTypeDef *HuffTableAC1 = (JPEG_ACHuffTableTypeDef *)(uintptr_t)&JPEG_ACCHROM_HuffTable;
  const JPEG_DCHuffTableTypeDef *HuffTableDC0 = (JPEG_DCHuffTableTypeDef *)(uintptr_t)&JPEG_DCLUM_HuffTable;
  const JPEG_DCHuffTableTypeDef *HuffTableDC1 = (JPEG_DCHuffTableTypeDef *)(uintptr_t)&JPEG_DCCHROM_HuffTable;
  uint32_t value;
  uint32_t index;
  __IO uint32_t *address;

  /* DC0 Huffman Table : BITS*/
  /* DC0 BITS is a 16 Bytes table i.e 4x32bits words from DHTMEM base address to DHTMEM + 3*/
  address = (hjpeg->Instance->DHTMEM + 3);
  index = 16;
  while (index > 3UL)
  {

    *address = (((uint32_t)HuffTableDC0->Bits[index - 1UL] & 0xFFUL) << 24) |
               (((uint32_t)HuffTableDC0->Bits[index - 2UL] & 0xFFUL) << 16) |
               (((uint32_t)HuffTableDC0->Bits[index - 3UL] & 0xFFUL) << 8) |
               ((uint32_t)HuffTableDC0->Bits[index - 4UL] & 0xFFUL);
    address--;
    index -= 4UL;

  }
  /* DC0 Huffman Table : Val*/
  /* DC0 VALS is a 12 Bytes table i.e 3x32bits words from DHTMEM base address +4 to DHTMEM + 6 */
  address = (hjpeg->Instance->DHTMEM + 6);
  index = 12;
  while (index > 3UL)
  {
    *address = (((uint32_t)HuffTableDC0->HuffVal[index - 1UL] & 0xFFUL) << 24) |
               (((uint32_t)HuffTableDC0->HuffVal[index - 2UL] & 0xFFUL) << 16) |
               (((uint32_t)HuffTableDC0->HuffVal[index - 3UL] & 0xFFUL) << 8) |
               ((uint32_t)HuffTableDC0->HuffVal[index - 4UL] & 0xFFUL);
    address--;
    index -= 4UL;
  }

  /* AC0 Huffman Table : BITS*/
  /* AC0 BITS is a 16 Bytes table i.e 4x32bits words from DHTMEM base address + 7 to DHTMEM + 10*/
  address = (hjpeg->Instance->DHTMEM + 10UL);
  index = 16;
  while (index > 3UL)
  {

    *address = (((uint32_t)HuffTableAC0->Bits[index - 1UL] & 0xFFUL) << 24) |
               (((uint32_t)HuffTableAC0->Bits[index - 2UL] & 0xFFUL) << 16) |
               (((uint32_t)HuffTableAC0->Bits[index - 3UL] & 0xFFUL) << 8) |
               ((uint32_t)HuffTableAC0->Bits[index - 4UL] & 0xFFUL);
    address--;
    index -= 4UL;

  }
  /* AC0 Huffman Table : Val*/
  /* AC0 VALS is a 162 Bytes table i.e 41x32bits words from DHTMEM base address + 11 to DHTMEM + 51 */
  /* only Byte 0 and Byte 1 of the last word (@ DHTMEM + 51) belong to AC0 VALS table */
  address = (hjpeg->Instance->DHTMEM + 51);
  value = *address & 0xFFFF0000U;
  value = value | (((uint32_t)HuffTableAC0->HuffVal[161] & 0xFFUL) << 8) |
          ((uint32_t)HuffTableAC0->HuffVal[160] & 0xFFUL);
  *address = value;

  /*continue setting 160 AC0 huffman values */
  address--; /* address = hjpeg->Instance->DHTMEM + 50*/
  index = JPEG_AC_HUFF_TABLE_SIZE - 2UL;
  while (index > 3UL)
  {
    *address = (((uint32_t)HuffTableAC0->HuffVal[index - 1UL] & 0xFFUL) << 24) |
               (((uint32_t)HuffTableAC0->HuffVal[index - 2UL] & 0xFFUL) << 16) |
               (((uint32_t)HuffTableAC0->HuffVal[index - 3UL] & 0xFFUL) << 8) |
               ((uint32_t)HuffTableAC0->HuffVal[index - 4UL] & 0xFFUL);
    address--;
    index -= 4UL;
  }

  /* DC1 Huffman Table : BITS*/
  /* DC1 BITS is a 16 Bytes table i.e 4x32bits words from DHTMEM + 51 base address to DHTMEM + 55*/
  /* only Byte 2 and Byte 3 of the first word (@ DHTMEM + 51) belong to DC1 Bits table */
  address = (hjpeg->Instance->DHTMEM + 51);
  value = *address & 0x0000FFFFU;
  value = value | (((uint32_t)HuffTableDC1->Bits[1] & 0xFFUL) << 24) |
          (((uint32_t)HuffTableDC1->Bits[0] & 0xFFUL) << 16);
  *address = value;

  /* only Byte 0 and Byte 1 of the last word (@ DHTMEM + 55) belong to DC1 Bits table */
  address = (hjpeg->Instance->DHTMEM + 55);
  value = *address & 0xFFFF0000U;
  value = value | (((uint32_t)HuffTableDC1->Bits[15] & 0xFFUL) << 8) |
          ((uint32_t)HuffTableDC1->Bits[14] & 0xFFUL);
  *address = value;

  /*continue setting 12 DC1 huffman Bits from DHTMEM + 54 down to DHTMEM + 52*/
  address--;
  index = 12;
  while (index > 3UL)
  {

    *address = (((uint32_t)HuffTableDC1->Bits[index + 1UL] & 0xFFUL) << 24) |
               (((uint32_t)HuffTableDC1->Bits[index] & 0xFFUL) << 16) |
               (((uint32_t)HuffTableDC1->Bits[index - 1UL] & 0xFFUL) << 8) |
               ((uint32_t)HuffTableDC1->Bits[index - 2UL] & 0xFFUL);
    address--;
    index -= 4UL;

  }
  /* DC1 Huffman Table : Val*/
  /* DC1 VALS is a 12 Bytes table i.e 3x32bits words from DHTMEM base address +55 to DHTMEM + 58 */
  /* only Byte 2 and Byte 3 of the first word (@ DHTMEM + 55) belong to DC1 Val table */
  address = (hjpeg->Instance->DHTMEM + 55);
  value = *address & 0x0000FFFFUL;
  value = value | (((uint32_t)HuffTableDC1->HuffVal[1] & 0xFFUL) << 24) |
          (((uint32_t)HuffTableDC1->HuffVal[0] & 0xFFUL) << 16);
  *address = value;

  /* only Byte 0 and Byte 1 of the last word (@ DHTMEM + 58) belong to DC1 Val table */
  address = (hjpeg->Instance->DHTMEM + 58);
  value = *address & 0xFFFF0000UL;
  value = value | (((uint32_t)HuffTableDC1->HuffVal[11] & 0xFFUL) << 8) |
          ((uint32_t)HuffTableDC1->HuffVal[10] & 0xFFUL);
  *address = value;

  /*continue setting 8 DC1 huffman val from DHTMEM + 57 down to DHTMEM + 56*/
  address--;
  index = 8;
  while (index > 3UL)
  {
    *address = (((uint32_t)HuffTableDC1->HuffVal[index + 1UL] & 0xFFUL) << 24) |
               (((uint32_t)HuffTableDC1->HuffVal[index] & 0xFFUL) << 16) |
               (((uint32_t)HuffTableDC1->HuffVal[index - 1UL] & 0xFFUL) << 8) |
               ((uint32_t)HuffTableDC1->HuffVal[index - 2UL] & 0xFFUL);
    address--;
    index -= 4UL;
  }

  /* AC1 Huffman Table : BITS*/
  /* AC1 BITS is a 16 Bytes table i.e 4x32bits words from DHTMEM base address + 58 to DHTMEM + 62*/
  /* only Byte 2 and Byte 3 of the first word (@ DHTMEM + 58) belong to AC1 Bits table */
  address = (hjpeg->Instance->DHTMEM + 58);
  value = *address & 0x0000FFFFU;
  value = value | (((uint32_t)HuffTableAC1->Bits[1] & 0xFFUL) << 24) |
          (((uint32_t)HuffTableAC1->Bits[0] & 0xFFUL) << 16);
  *address = value;

  /* only Byte 0 and Byte 1 of the last word (@ DHTMEM + 62) belong to Bits Val table */
  address = (hjpeg->Instance->DHTMEM + 62);
  value = *address & 0xFFFF0000U;
  value = value | (((uint32_t)HuffTableAC1->Bits[15] & 0xFFUL) << 8) | ((uint32_t)HuffTableAC1->Bits[14] & 0xFFUL);
  *address = value;

  /*continue setting 12 AC1 huffman Bits from DHTMEM + 61 down to DHTMEM + 59*/
  address--;
  index = 12;
  while (index > 3UL)
  {

    *address = (((uint32_t)HuffTableAC1->Bits[index + 1UL] & 0xFFUL) << 24) |
               (((uint32_t)HuffTableAC1->Bits[index] & 0xFFUL) << 16) |
               (((uint32_t)HuffTableAC1->Bits[index - 1UL] & 0xFFUL) << 8) |
               ((uint32_t)HuffTableAC1->Bits[index - 2UL] & 0xFFUL);
    address--;
    index -= 4UL;

  }
  /* AC1 Huffman Table : Val*/
  /* AC1 VALS is a 162 Bytes table i.e 41x32bits words from DHTMEM base address + 62 to DHTMEM + 102 */
  /* only Byte 2 and Byte 3 of the first word (@ DHTMEM + 62) belong to AC1 VALS table */
  address = (hjpeg->Instance->DHTMEM + 62);
  value = *address & 0x0000FFFFUL;
  value = value | (((uint32_t)HuffTableAC1->HuffVal[1] & 0xFFUL) << 24) |
          (((uint32_t)HuffTableAC1->HuffVal[0] & 0xFFUL) << 16);
  *address = value;

  /*continue setting 160 AC1 huffman values from DHTMEM + 63 to DHTMEM+102 */
  address = (hjpeg->Instance->DHTMEM + 102);
  index = JPEG_AC_HUFF_TABLE_SIZE - 2UL;
  while (index > 3UL)
  {
    *address = (((uint32_t)HuffTableAC1->HuffVal[index + 1UL] & 0xFFUL) << 24) |
               (((uint32_t)HuffTableAC1->HuffVal[index] & 0xFFUL) << 16) |
               (((uint32_t)HuffTableAC1->HuffVal[index - 1UL] & 0xFFUL) << 8) |
               ((uint32_t)HuffTableAC1->HuffVal[index - 2UL] & 0xFFUL);
    address--;
    index -= 4UL;
  }

}

static uint32_t JPEG_Set_Quantization_Mem(const JPEG_HandleTypeDef *hjpeg, const uint8_t *QTable,
                                          __IO uint32_t *QTableAddress)
{
  uint32_t i;
  uint32_t j;
  uint32_t quantRow;
  uint32_t quantVal;
  uint32_t ScaleFactor;
  __IO uint32_t *tableAddress;

  tableAddress = QTableAddress;

  if ((hjpeg->Conf.ImageQuality >= 50UL) && (hjpeg->Conf.ImageQuality <= 100UL))
  {
    ScaleFactor = JPEG_HIGH_QUALITY_REFERENCE - (hjpeg->Conf.ImageQuality * 2UL);
  }
  else if (hjpeg->Conf.ImageQuality > 0UL)
  {
    ScaleFactor = JPEG_LOW_QUALITY_REFERENCE / ((uint32_t) hjpeg->Conf.ImageQuality);
  }
  else
  {
    return 1UL;
  }

  /*Quantization_table = (Standard_quanization_table * ScaleFactor + 50) / 100*/
  i = 0;
  while (i < (JPEG_QUANT_TABLE_SIZE - 3UL))
  {
    quantRow = 0;
    for (j = 0; j < 4UL; j++)
    {
      /* Note that the quantization coefficients must be specified in the table in zigzag order */
      quantVal = ((((uint32_t) QTable[JPEG_ZIGZAG_ORDER[i + j]]) * ScaleFactor) + 50UL) / 100UL;

      if (quantVal == 0UL)
      {
        quantVal = 1UL;
      }
      else if (quantVal > 255UL)
      {
        quantVal = JPEG_QUANTVAL_MAX;
      }
      else
      {
        /* Nothing to do, keep same value of quantVal */
      }

      quantRow |= ((quantVal & 0xFFUL) << (8UL * j));
    }

    i += 4UL;
    *tableAddress = quantRow;
    tableAddress ++;
  }

  /* Return function status */
  return 0UL;
}

static void JPEG_SetColorYCBCR(JPEG_HandleTypeDef *hjpeg)
{
  uint32_t ySamplingH;
  uint32_t ySamplingV;
  uint32_t yblockNb;

  /*Set Number of color components to 3*/
  hjpeg->Instance->CONFR1 &=  ~JPEG_CONFR1_NF;
  hjpeg->Instance->CONFR1 |=  JPEG_CONFR1_NF_1;

  /* compute MCU block size and Y, Cb ,Cr sampling factors*/
  if (hjpeg->Conf.ChromaSubsampling == JPEG_420_SUBSAMPLING)
  {
    ySamplingH  = JPEG_CONFR4_HSF_1;   /* Hs = 2*/
    ySamplingV  = JPEG_CONFR4_VSF_1;   /* Vs = 2*/

    yblockNb  = 0x30; /* 4 blocks of 8x8*/
  }
  else if (hjpeg->Conf.ChromaSubsampling == JPEG_422_SUBSAMPLING)
  {
    ySamplingH  = JPEG_CONFR4_HSF_1;   /* Hs = 2*/
    ySamplingV  = JPEG_CONFR4_VSF_0;   /* Vs = 1*/

    yblockNb  = 0x10; /* 2 blocks of 8x8*/
  }
  else /*JPEG_444_SUBSAMPLING and default*/
  {
    ySamplingH  = JPEG_CONFR4_HSF_0;   /* Hs = 1*/
    ySamplingV  = JPEG_CONFR4_VSF_0;   /* Vs = 1*/

    yblockNb  = 0; /* 1 block of 8x8*/
  }

  hjpeg->Instance->CONFR1 &= ~(JPEG_CONFR1_NF | JPEG_CONFR1_NS);
  hjpeg->Instance->CONFR1 |= (JPEG_CONFR1_NF_1 | JPEG_CONFR1_NS_1);

  /*Reset CONFR4 register*/
  hjpeg->Instance->CONFR4 =  0;
  /*Set Horizental and Vertical  sampling factor , number of blocks,
   Quantization table and Huffman AC/DC tables for component 0*/
  hjpeg->Instance->CONFR4 |= (ySamplingH | ySamplingV | (yblockNb & JPEG_CONFR4_NB));

  /*Reset CONFR5 register*/
  hjpeg->Instance->CONFR5 =  0;
  /*Set Horizental and Vertical  sampling factor , number of blocks,
    Quantization table and Huffman AC/DC tables for component 1*/
  hjpeg->Instance->CONFR5 |= (JPEG_CONFR5_HSF_0 | JPEG_CONFR5_VSF_0 | JPEG_CONFR5_QT_0 | JPEG_CONFR5_HA |
                              JPEG_CONFR5_HD);

  /*Reset CONFR6 register*/
  hjpeg->Instance->CONFR6 =  0;
  /*Set Horizental and Vertical  sampling factor and number of blocks for component 2*/
  /* In YCBCR , by default, both chrominance components (component 1 and component 2)
     use the same Quantization table (table 1) */
  /* In YCBCR , both chrominance components (component 1 and component 2) use the same Huffman tables (table 1) */
  hjpeg->Instance->CONFR6 |= (JPEG_CONFR6_HSF_0 | JPEG_CONFR6_VSF_0 | JPEG_CONFR6_QT_0 | JPEG_CONFR6_HA |
                              JPEG_CONFR6_HD);

}

static void JPEG_SetColorGrayScale(JPEG_HandleTypeDef *hjpeg)
{
  /*Set Number of color components to 1*/
  hjpeg->Instance->CONFR1 &= ~(JPEG_CONFR1_NF | JPEG_CONFR1_NS);

  /*in GrayScale use 1 single Quantization table (Table 0)*/
  /*in GrayScale use only one couple of AC/DC huffman table (table 0)*/

  /*Reset CONFR4 register*/
  hjpeg->Instance->CONFR4 =  0;
  /*Set Horizental and Vertical  sampling factor , number of blocks,
    Quantization table and Huffman AC/DC tables for component 0*/
  hjpeg->Instance->CONFR4 |=  JPEG_CONFR4_HSF_0 | JPEG_CONFR4_VSF_0 ;
}

static void JPEG_SetColorCMYK(JPEG_HandleTypeDef *hjpeg)
{
  uint32_t ySamplingH;
  uint32_t ySamplingV;
  uint32_t yblockNb;

  /*Set Number of color components to 4*/
  hjpeg->Instance->CONFR1 |= (JPEG_CONFR1_NF | JPEG_CONFR1_NS);

  /* compute MCU block size and Y, Cb ,Cr sampling factors*/
  if (hjpeg->Conf.ChromaSubsampling == JPEG_420_SUBSAMPLING)
  {
    ySamplingH  = JPEG_CONFR4_HSF_1;   /* Hs = 2*/
    ySamplingV  = JPEG_CONFR4_VSF_1;   /* Vs = 2*/

    yblockNb  = 0x30; /* 4 blocks of 8x8*/
  }
  else if (hjpeg->Conf.ChromaSubsampling == JPEG_422_SUBSAMPLING)
  {
    ySamplingH  = JPEG_CONFR4_HSF_1;   /* Hs = 2*/
    ySamplingV  = JPEG_CONFR4_VSF_0;   /* Vs = 1*/

    yblockNb  = 0x10; /* 2 blocks of 8x8*/
  }
  else /*JPEG_444_SUBSAMPLING and default*/
  {
    ySamplingH  = JPEG_CONFR4_HSF_0;   /* Hs = 1*/
    ySamplingV  = JPEG_CONFR4_VSF_0;   /* Vs = 1*/

    yblockNb  = 0; /* 1 block of 8x8*/
  }

  /*Reset CONFR4 register*/
  hjpeg->Instance->CONFR4 =  0;
  /*Set Horizental and Vertical  sampling factor , number of blocks,
    Quantization table and Huffman AC/DC tables for component 0*/
  hjpeg->Instance->CONFR4 |= (ySamplingH | ySamplingV | (yblockNb & JPEG_CONFR4_NB));

  /*Reset CONFR5 register*/
  hjpeg->Instance->CONFR5 =  0;
  /*Set Horizental and Vertical  sampling factor , number of blocks,
    Quantization table and Huffman AC/DC tables for component 1*/
  hjpeg->Instance->CONFR5 |= (JPEG_CONFR5_HSF_0 | JPEG_CONFR5_VSF_0);

  /*Reset CONFR6 register*/
  hjpeg->Instance->CONFR6 =  0;
  /*Set Horizental and Vertical  sampling factor , number of blocks,
    Quantization table and Huffman AC/DC tables for component 2*/
  hjpeg->Instance->CONFR6 |= (JPEG_CONFR6_HSF_0 | JPEG_CONFR6_VSF_0);

  /*Reset CONFR7 register*/
  hjpeg->Instance->CONFR7 =  0;
  /*Set Horizental and Vertical  sampling factor , number of blocks,
    Quantization table and Huffman AC/DC tables for component 3*/
  hjpeg->Instance->CONFR7 |= (JPEG_CONFR7_HSF_0 | JPEG_CONFR7_VSF_0);
}

static void JPEG_Init_Process(JPEG_HandleTypeDef *hjpeg)
{
  /*Reset pause*/
  hjpeg->Context &= (~(JPEG_CONTEXT_PAUSE_INPUT | JPEG_CONTEXT_PAUSE_OUTPUT));

  if ((hjpeg->Context & JPEG_CONTEXT_OPERATION_MASK) == JPEG_CONTEXT_DECODE)
  {
    /*Set JPEG Codec to Decoding mode */
    hjpeg->Instance->CONFR1 |= JPEG_CONFR1_DE;
  }
  else /* JPEG_CONTEXT_ENCODE */
  {
    /*Set JPEG Codec to Encoding mode */
    hjpeg->Instance->CONFR1 &= ~JPEG_CONFR1_DE;
  }

  /*Stop JPEG processing */
  hjpeg->Instance->CONFR0 &=  ~JPEG_CONFR0_START;

  /* Disable All Interrupts */
  __HAL_JPEG_DISABLE_IT(hjpeg, JPEG_INTERRUPT_MASK);

  /* Disable All DMA requests */
  JPEG_DISABLE_DMA(hjpeg, JPEG_DMA_MASK);
  /* Flush input and output FIFOs*/
  hjpeg->Instance->CR |= JPEG_CR_IFF;
  hjpeg->Instance->CR |= JPEG_CR_OFF;

  /* Clear all flags */
  __HAL_JPEG_CLEAR_FLAG(hjpeg, JPEG_FLAG_ALL);

  /*Start Encoding/Decoding*/
  hjpeg->Instance->CONFR0 |=  JPEG_CONFR0_START;

  if ((hjpeg->Context & JPEG_CONTEXT_METHOD_MASK) == JPEG_CONTEXT_IT)
  {
    /*Enable IN/OUT, end of Conversation, and end of header parsing interruptions*/
    __HAL_JPEG_ENABLE_IT(hjpeg, JPEG_IT_IFT | JPEG_IT_IFNF | JPEG_IT_OFT | JPEG_IT_OFNE | JPEG_IT_EOC | JPEG_IT_HPD);
  }
  else if ((hjpeg->Context & JPEG_CONTEXT_METHOD_MASK) == JPEG_CONTEXT_DMA)
  {
    /*Enable End Of Conversation, and End Of Header parsing interruptions*/
    __HAL_JPEG_ENABLE_IT(hjpeg, JPEG_IT_EOC | JPEG_IT_HPD);

  }
  else
  {
    /* Nothing to do */
  }
}

static uint32_t JPEG_Process(JPEG_HandleTypeDef *hjpeg)
{
  uint32_t tmpContext;
  uint32_t itflag = hjpeg->Instance->SR;

  /*End of header processing flag */
  if ((hjpeg->Context & JPEG_CONTEXT_OPERATION_MASK) == JPEG_CONTEXT_DECODE)
  {
    if ((itflag & JPEG_FLAG_HPDF) != 0UL)
    {
      /*Call Header parsing complete callback */
      (void) HAL_JPEG_GetInfo(hjpeg, &hjpeg->Conf);
      /* Reset the ImageQuality */
      hjpeg->Conf.ImageQuality = 0;
      /* Note : the image quality is only available at the end of the decoding operation */
      /* at the current stage the calculated image quality is not correct so reset it */

      /*Call Info Ready callback */
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->InfoReadyCallback(hjpeg, &hjpeg->Conf);
#else
      HAL_JPEG_InfoReadyCallback(hjpeg, &hjpeg->Conf);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */

      __HAL_JPEG_DISABLE_IT(hjpeg, JPEG_IT_HPD);

      /* Clear header processing done flag */
      __HAL_JPEG_CLEAR_FLAG(hjpeg, JPEG_FLAG_HPDF);
    }
  }

  /*Input FIFO status handling*/
  if ((hjpeg->Context &  JPEG_CONTEXT_PAUSE_INPUT) == 0UL)
  {
    if ((itflag & JPEG_FLAG_IFTF) != 0UL)
    {
      /*Input FIFO threshold flag */
      /*JPEG_FIFO_TH_SIZE words can be written in */
      JPEG_ReadInputData(hjpeg, JPEG_FIFO_TH_SIZE);
    }
    else if ((itflag & JPEG_FLAG_IFNFF) != 0UL)
    {
      /*Input FIFO Not Full flag */
      /*32-bit value can be written in */
      JPEG_ReadInputData(hjpeg, 1);
    }
    else
    {
      /* Nothing to do */
    }
  }

  /*Output FIFO flag handling*/
  if ((hjpeg->Context &  JPEG_CONTEXT_PAUSE_OUTPUT) == 0UL)
  {
    if ((itflag & JPEG_FLAG_OFTF) != 0UL)
    {
      /*Output FIFO threshold flag */
      /*JPEG_FIFO_TH_SIZE words can be read out */
      JPEG_StoreOutputData(hjpeg, JPEG_FIFO_TH_SIZE);
    }
    else if ((itflag & JPEG_FLAG_OFNEF) != 0UL)
    {
      /*Output FIFO Not Empty flag */
      /*32-bit value can be read out */
      JPEG_StoreOutputData(hjpeg, 1);
    }
    else
    {
      /* Nothing to do */
    }
  }

  /*End of Conversion handling :i.e EOC flag is high and OFTF low and OFNEF low*/
  if ((itflag & (JPEG_FLAG_EOCF | JPEG_FLAG_OFTF | JPEG_FLAG_OFNEF)) == JPEG_FLAG_EOCF)
  {
    /*Stop Encoding/Decoding*/
    hjpeg->Instance->CONFR0 &=  ~JPEG_CONFR0_START;

    if ((hjpeg->Context & JPEG_CONTEXT_METHOD_MASK) == JPEG_CONTEXT_IT)
    {
      /* Disable All Interrupts */
      __HAL_JPEG_DISABLE_IT(hjpeg, JPEG_INTERRUPT_MASK);
    }

    /* Clear all flags */
    __HAL_JPEG_CLEAR_FLAG(hjpeg, JPEG_FLAG_ALL);

    /*Call End of conversion callback */
    if (hjpeg->JpegOutCount > 0UL)
    {
      /*Output Buffer is not empty, call DecodedDataReadyCallback*/
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#else
      HAL_JPEG_DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */

      hjpeg->JpegOutCount = 0;
    }

    /*Reset Context Operation*/
    tmpContext = hjpeg->Context;
    /*Clear all context fields execpt JPEG_CONTEXT_CONF_ENCODING and JPEG_CONTEXT_CUSTOM_TABLES*/
    hjpeg->Context &= (JPEG_CONTEXT_CONF_ENCODING | JPEG_CONTEXT_CUSTOM_TABLES);

    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);

    /* Change the JPEG state */
    hjpeg->State = HAL_JPEG_STATE_READY;

    /*Call End of Encoding/Decoding callback */
    if ((tmpContext & JPEG_CONTEXT_OPERATION_MASK) == JPEG_CONTEXT_DECODE)
    {
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->DecodeCpltCallback(hjpeg);
#else
      HAL_JPEG_DecodeCpltCallback(hjpeg);
#endif /*USE_HAL_JPEG_REGISTER_CALLBACKS*/
    }
    else /* JPEG_CONTEXT_ENCODE */
    {
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->EncodeCpltCallback(hjpeg);
#else
      HAL_JPEG_EncodeCpltCallback(hjpeg);
#endif /*USE_HAL_JPEG_REGISTER_CALLBACKS*/
    }

    return JPEG_PROCESS_DONE;
  }

  return JPEG_PROCESS_ONGOING;
}

static void JPEG_StoreOutputData(JPEG_HandleTypeDef *hjpeg, uint32_t nbOutputWords)
{
  uint32_t index;
  uint32_t nb_words;
  uint32_t nb_bytes;
  uint32_t dataword;

  if (hjpeg->OutDataLength >= (hjpeg->JpegOutCount + (nbOutputWords * 4UL)))
  {
    for (index = 0; index < nbOutputWords; index++)
    {
      /*Transfer 32 bits from the JPEG output FIFO*/
      dataword = hjpeg->Instance->DOR;
      hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount] = (uint8_t)(dataword & 0x000000FFUL);
      hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount + 1UL] = (uint8_t)((dataword & 0x0000FF00UL) >> 8);
      hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount + 2UL] = (uint8_t)((dataword & 0x00FF0000UL) >> 16);
      hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount + 3UL] = (uint8_t)((dataword & 0xFF000000UL) >> 24);
      hjpeg->JpegOutCount += 4UL;
    }
    if (hjpeg->OutDataLength == hjpeg->JpegOutCount)
    {
      /*Output Buffer is full, call DecodedDataReadyCallback*/
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#else
      HAL_JPEG_DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#endif /*USE_HAL_JPEG_REGISTER_CALLBACKS*/
      hjpeg->JpegOutCount = 0;
    }
  }
  else if (hjpeg->OutDataLength > hjpeg->JpegOutCount)
  {
    nb_words = (hjpeg->OutDataLength - hjpeg->JpegOutCount) / 4UL;
    for (index = 0; index < nb_words; index++)
    {
      /*Transfer 32 bits from the JPEG output FIFO*/
      dataword = hjpeg->Instance->DOR;
      hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount] = (uint8_t)(dataword & 0x000000FFUL);
      hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount + 1UL] = (uint8_t)((dataword & 0x0000FF00UL) >> 8);
      hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount + 2UL] = (uint8_t)((dataword & 0x00FF0000UL) >> 16);
      hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount + 3UL] = (uint8_t)((dataword & 0xFF000000UL) >> 24);
      hjpeg->JpegOutCount += 4UL;
    }
    if (hjpeg->OutDataLength == hjpeg->JpegOutCount)
    {
      /*Output Buffer is full, call DecodedDataReadyCallback*/
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#else
      HAL_JPEG_DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */
      hjpeg->JpegOutCount = 0;
    }
    else
    {
      nb_bytes = hjpeg->OutDataLength - hjpeg->JpegOutCount;
      dataword = hjpeg->Instance->DOR;
      for (index = 0; index < nb_bytes; index++)
      {
        hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount] = (uint8_t)((dataword >> (8UL * (index & 0x3UL))) & 0xFFUL);
        hjpeg->JpegOutCount++;
      }
      /*Output Buffer is full, call DecodedDataReadyCallback*/
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#else
      HAL_JPEG_DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */

      hjpeg->JpegOutCount = 0;

      nb_bytes = 4UL - nb_bytes;
      for (index = nb_bytes; index < 4UL; index++)
      {
        hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount] = (uint8_t)((dataword >> (8UL * index)) & 0xFFUL);
        hjpeg->JpegOutCount++;
      }
    }
  }
  else
  {
    /* Nothing to do */
  }
}

static void JPEG_ReadInputData(JPEG_HandleTypeDef *hjpeg, uint32_t nbRequestWords)
{
  uint32_t nb_bytes = 0;
  uint32_t nb_words;
  uint32_t index;
  uint32_t dataword;
  uint32_t input_count;

  if ((hjpeg->InDataLength == 0UL) || (nbRequestWords == 0UL))
  {
    /* No more Input data : nothing to do*/
    (void) HAL_JPEG_Pause(hjpeg, JPEG_PAUSE_RESUME_INPUT);
  }
  else if (hjpeg->InDataLength > hjpeg->JpegInCount)
  {
    nb_bytes = hjpeg->InDataLength - hjpeg->JpegInCount;
  }
  else if (hjpeg->InDataLength == hjpeg->JpegInCount)
  {
    /*Call HAL_JPEG_GetDataCallback to get new data */
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
    hjpeg->GetDataCallback(hjpeg, hjpeg->JpegInCount);
#else
    HAL_JPEG_GetDataCallback(hjpeg, hjpeg->JpegInCount);
#endif /*USE_HAL_JPEG_REGISTER_CALLBACKS*/

    if (hjpeg->InDataLength > 4UL)
    {
      hjpeg->InDataLength = ((hjpeg->InDataLength + 3UL) / 4UL) * 4UL;
    }
    hjpeg->JpegInCount = 0;
    nb_bytes = hjpeg->InDataLength;
  }
  else
  {
    /* Nothing to do */
  }
  if (((hjpeg->Context &  JPEG_CONTEXT_PAUSE_INPUT) == 0UL) && (nb_bytes > 0UL))
  {
    nb_words = nb_bytes / 4UL;
    if (nb_words >= nbRequestWords)
    {
      for (index = 0; index < nbRequestWords; index++)
      {
        input_count = hjpeg->JpegInCount;
        hjpeg->Instance->DIR = (((uint32_t)(hjpeg->pJpegInBuffPtr[input_count])) | \
                                (((uint32_t)(hjpeg->pJpegInBuffPtr[input_count + 1UL])) << 8) | \
                                (((uint32_t)(hjpeg->pJpegInBuffPtr[input_count + 2UL])) << 16) | \
                                (((uint32_t)(hjpeg->pJpegInBuffPtr[input_count + 3UL])) << 24));

        hjpeg->JpegInCount += 4UL;
      }
    }
    else /*nb_words < nbRequestWords*/
    {
      if (nb_words > 0UL)
      {
        for (index = 0; index < nb_words; index++)
        {
          input_count = hjpeg->JpegInCount;
          hjpeg->Instance->DIR = (((uint32_t)(hjpeg->pJpegInBuffPtr[input_count])) | \
                                  (((uint32_t)(hjpeg->pJpegInBuffPtr[input_count + 1UL])) << 8) | \
                                  (((uint32_t)(hjpeg->pJpegInBuffPtr[input_count + 2UL])) << 16) | \
                                  (((uint32_t)(hjpeg->pJpegInBuffPtr[input_count + 3UL])) << 24));

          hjpeg->JpegInCount += 4UL;
        }
      }
      else
      {
        /* end of file*/
        dataword = 0;
        for (index = 0; index < nb_bytes; index++)
        {
          dataword |= (uint32_t)hjpeg->pJpegInBuffPtr[hjpeg->JpegInCount] << (8UL * (index & 0x03UL));
          hjpeg->JpegInCount++;
        }
        hjpeg->Instance->DIR = dataword;
      }
    }
  }
}

static HAL_StatusTypeDef JPEG_DMA_StartProcess(JPEG_HandleTypeDef *hjpeg)
{
  if ((hjpeg->InDataLength < 4UL) || (hjpeg->OutDataLength < 4UL))
  {
    return HAL_ERROR;
  }
  /* Reset Ending DMA internal context flag*/
  hjpeg->Context &= ~JPEG_CONTEXT_ENDING_DMA;

  /* Disable DMA In/Out Request*/
  JPEG_DISABLE_DMA(hjpeg, JPEG_DMA_ODMA | JPEG_DMA_IDMA);

  /* Set the JPEG DMA In transfer complete callback */
  hjpeg->hdmain->XferCpltCallback = JPEG_DMAInCpltCallback;
  /* Set the DMA In error callback */
  hjpeg->hdmain->XferErrorCallback = JPEG_DMAErrorCallback;

  /* Set the JPEG DMA Out transfer complete callback */
  hjpeg->hdmaout->XferCpltCallback = JPEG_DMAOutCpltCallback;
  /* Set the DMA Out error callback */
  hjpeg->hdmaout->XferErrorCallback = JPEG_DMAErrorCallback;
  /* Set the DMA Out Abort callback */
  hjpeg->hdmaout->XferAbortCallback = JPEG_DMAOutAbortCallback;

  /*DMA transfer size must be a multiple of 4 bytes i.e multiple of 32bits words*/
  hjpeg->InDataLength = hjpeg->InDataLength - (hjpeg->InDataLength % 4UL);

  /*DMA transfer size must be a multiple of 4 bytes i.e multiple of 32bits words*/
  hjpeg->OutDataLength = hjpeg->OutDataLength - (hjpeg->OutDataLength % 4UL);

  if ((hjpeg->hdmain->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
  {
    if (hjpeg->hdmain->LinkedListQueue != NULL)
    {
      /* Set DMA data size */
      hjpeg->hdmain->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hjpeg->InDataLength;

      /* Set DMA source address */
      hjpeg->hdmain->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)hjpeg->pJpegInBuffPtr;

      /* Set DMA destination address */
      hjpeg->hdmain->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)&hjpeg->Instance->DIR;

      if (HAL_DMAEx_List_Start_IT(hjpeg->hdmain) != HAL_OK)
      {
        return HAL_ERROR;
      }
    }
    else
    {
      /* Set the JPEG State to ready */
      hjpeg->State = HAL_JPEG_STATE_READY;

      /* Update JPEG error code */
      hjpeg->ErrorCode |= HAL_JPEG_ERROR_DMA;

      /* Process Unlocked */
      __HAL_UNLOCK(hjpeg);

      return HAL_ERROR;
    }
  }
  else
  {
    /* Start DMA FIFO In transfer */
    if (HAL_DMA_Start_IT(hjpeg->hdmain, (uint32_t)hjpeg->pJpegInBuffPtr, (uint32_t)&hjpeg->Instance->DIR,
                         hjpeg->InDataLength)  != HAL_OK)
    {
      hjpeg->ErrorCode |= HAL_JPEG_ERROR_DMA;
      return HAL_ERROR;
    }
  }

  if ((hjpeg->hdmaout->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
  {
    if (hjpeg->hdmaout->LinkedListQueue != NULL)
    {
      /* Set DMA data size */
      hjpeg->hdmaout->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hjpeg->OutDataLength;

      /* Set DMA source address */
      hjpeg->hdmaout->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)&hjpeg->Instance->DOR;

      /* Set DMA destination address */
      hjpeg->hdmaout->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)hjpeg->pJpegOutBuffPtr;

      if (HAL_DMAEx_List_Start_IT(hjpeg->hdmaout) != HAL_OK)
      {
        return HAL_ERROR;
      }
    }
    else
    {
      /* Set the JPEG State to ready */
      hjpeg->State = HAL_JPEG_STATE_READY;

      /* Update JPEG error code */
      hjpeg->ErrorCode |= HAL_JPEG_ERROR_DMA;

      /* Process Unlocked */
      __HAL_UNLOCK(hjpeg);

      return HAL_ERROR;
    }
  }
  else
  {
    /* Start DMA FIFO Out transfer */
    if (HAL_DMA_Start_IT(hjpeg->hdmaout, (uint32_t)&hjpeg->Instance->DOR, (uint32_t)hjpeg->pJpegOutBuffPtr,
                         hjpeg->OutDataLength)  != HAL_OK)
    {
      hjpeg->ErrorCode |= HAL_JPEG_ERROR_DMA;
      return HAL_ERROR;
    }
  }

  /* Enable JPEG In/Out DMA requests*/
  JPEG_ENABLE_DMA(hjpeg, JPEG_DMA_IDMA | JPEG_DMA_ODMA);

  return HAL_OK;
}

static void JPEG_DMA_ContinueProcess(JPEG_HandleTypeDef *hjpeg)
{
  uint32_t itflag = hjpeg->Instance->SR;

  /*End of header processing flag rises*/
  if ((hjpeg->Context & JPEG_CONTEXT_OPERATION_MASK) == JPEG_CONTEXT_DECODE)
  {
    if ((itflag & JPEG_FLAG_HPDF) != 0UL)
    {
      /*Call Header parsing complete callback */
      (void) HAL_JPEG_GetInfo(hjpeg, &hjpeg->Conf);

      /* Reset the ImageQuality */
      hjpeg->Conf.ImageQuality = 0;
      /* Note : the image quality is only available at the end of the decoding operation */
      /* at the current stage the calculated image quality is not correct so reset it */

      /*Call Info Ready callback */
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->InfoReadyCallback(hjpeg, &hjpeg->Conf);
#else
      HAL_JPEG_InfoReadyCallback(hjpeg, &hjpeg->Conf);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */

      __HAL_JPEG_DISABLE_IT(hjpeg, JPEG_IT_HPD);

      /* Clear header processing done flag */
      __HAL_JPEG_CLEAR_FLAG(hjpeg, JPEG_FLAG_HPDF);
    }
  }

  /*End of Conversion handling*/
  if ((itflag & JPEG_FLAG_EOCF) != 0UL)
  {
    /*Disable JPEG In/Out DMA Requests*/
    JPEG_DISABLE_DMA(hjpeg, JPEG_DMA_ODMA | JPEG_DMA_IDMA);

    hjpeg->Context |= JPEG_CONTEXT_ENDING_DMA;

    /*Stop Encoding/Decoding*/
    hjpeg->Instance->CONFR0 &=  ~JPEG_CONFR0_START;

    __HAL_JPEG_DISABLE_IT(hjpeg, JPEG_INTERRUPT_MASK);

    /* Clear all flags */
    __HAL_JPEG_CLEAR_FLAG(hjpeg, JPEG_FLAG_ALL);

    if (hjpeg->hdmain->State == HAL_DMA_STATE_BUSY)
    {
      /* Stop the DMA In Xfer*/
      (void) HAL_DMA_Abort_IT(hjpeg->hdmain);
    }

    if (hjpeg->hdmaout->State == HAL_DMA_STATE_BUSY)
    {
      /* Stop the DMA out Xfer*/
      (void) HAL_DMA_Abort_IT(hjpeg->hdmaout);
    }
    else
    {
      JPEG_DMA_EndProcess(hjpeg);
    }
  }
}

static void JPEG_DMA_EndProcess(JPEG_HandleTypeDef *hjpeg)
{
  uint32_t tmpContext;
  hjpeg->JpegOutCount = hjpeg->OutDataLength - JPEG_GET_DMA_REMAIN_DATA(hjpeg->hdmaout);

  /*if Output Buffer is full, call HAL_JPEG_DataReadyCallback*/
  if (hjpeg->JpegOutCount == hjpeg->OutDataLength)
  {
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
    hjpeg->DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#else
    HAL_JPEG_DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */

    hjpeg->JpegOutCount = 0;
  }

  /*Check if remaining data in the output FIFO*/
  if (__HAL_JPEG_GET_FLAG(hjpeg, JPEG_FLAG_OFNEF) == 0UL)
  {
    if (hjpeg->JpegOutCount > 0UL)
    {
      /*Output Buffer is not empty, call DecodedDataReadyCallback*/
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#else
      HAL_JPEG_DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */

      hjpeg->JpegOutCount = 0;
    }

    /*Stop Encoding/Decoding*/
    hjpeg->Instance->CONFR0 &=  ~JPEG_CONFR0_START;

    tmpContext = hjpeg->Context;
    /*Clear all context fields execpt JPEG_CONTEXT_CONF_ENCODING and JPEG_CONTEXT_CUSTOM_TABLES*/
    hjpeg->Context &= (JPEG_CONTEXT_CONF_ENCODING | JPEG_CONTEXT_CUSTOM_TABLES);

    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);

    /* Change the JPEG state */
    hjpeg->State = HAL_JPEG_STATE_READY;

    /*Call End of Encoding/Decoding callback */
    if ((tmpContext & JPEG_CONTEXT_OPERATION_MASK) == JPEG_CONTEXT_DECODE)
    {
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->DecodeCpltCallback(hjpeg);
#else
      HAL_JPEG_DecodeCpltCallback(hjpeg);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */
    }
    else /* JPEG_CONTEXT_ENCODE */
    {
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->EncodeCpltCallback(hjpeg);
#else
      HAL_JPEG_EncodeCpltCallback(hjpeg);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */
    }
  }
  else if ((hjpeg->Context &  JPEG_CONTEXT_PAUSE_OUTPUT) == 0UL)
  {
    JPEG_DMA_PollResidualData(hjpeg);
  }
  else
  {
    /* Nothing to do */
  }

}

static void JPEG_DMA_PollResidualData(JPEG_HandleTypeDef *hjpeg)
{
  uint32_t tmpContext;
  uint32_t count;
  uint32_t dataOut;

  for (count = JPEG_FIFO_SIZE; count > 0UL; count--)
  {
    if ((hjpeg->Context &  JPEG_CONTEXT_PAUSE_OUTPUT) == 0UL)
    {
      if (__HAL_JPEG_GET_FLAG(hjpeg, JPEG_FLAG_OFNEF) != 0UL)
      {
        dataOut = hjpeg->Instance->DOR;
        hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount] = (uint8_t)(dataOut & 0x000000FFUL);
        hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount + 1UL] = (uint8_t)((dataOut & 0x0000FF00UL) >> 8);
        hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount + 2UL] = (uint8_t)((dataOut & 0x00FF0000UL) >> 16);
        hjpeg->pJpegOutBuffPtr[hjpeg->JpegOutCount + 3UL] = (uint8_t)((dataOut & 0xFF000000UL) >> 24);
        hjpeg->JpegOutCount += 4UL;

        if (hjpeg->JpegOutCount == hjpeg->OutDataLength)
        {
          /*Output Buffer is full, call HAL_JPEG_DataReadyCallback*/
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
          hjpeg->DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#else
          HAL_JPEG_DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */

          hjpeg->JpegOutCount = 0;
        }

      }
    }
  }

  tmpContext = hjpeg->Context;

  if ((__HAL_JPEG_GET_FLAG(hjpeg, JPEG_FLAG_OFNEF) == 0UL) || ((tmpContext & JPEG_CONTEXT_PAUSE_OUTPUT) == 0UL))
  {
    /*Stop Encoding/Decoding*/
    hjpeg->Instance->CONFR0 &=  ~JPEG_CONFR0_START;

    if (hjpeg->JpegOutCount > 0UL)
    {
      /*Output Buffer is not empty, call DecodedDataReadyCallback*/
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#else
      HAL_JPEG_DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */

      hjpeg->JpegOutCount = 0;
    }

    tmpContext = hjpeg->Context;
    /*Clear all context fields execpt JPEG_CONTEXT_CONF_ENCODING and JPEG_CONTEXT_CUSTOM_TABLES*/
    hjpeg->Context &= (JPEG_CONTEXT_CONF_ENCODING | JPEG_CONTEXT_CUSTOM_TABLES);

    /* Process Unlocked */
    __HAL_UNLOCK(hjpeg);

    /* Change the JPEG state */
    hjpeg->State = HAL_JPEG_STATE_READY;

    /*Call End of Encoding/Decoding callback */
    if ((tmpContext & JPEG_CONTEXT_OPERATION_MASK) == JPEG_CONTEXT_DECODE)
    {
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->DecodeCpltCallback(hjpeg);
#else
      HAL_JPEG_DecodeCpltCallback(hjpeg);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */
    }
    else /* JPEG_CONTEXT_ENCODE */
    {
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->EncodeCpltCallback(hjpeg);
#else
      HAL_JPEG_EncodeCpltCallback(hjpeg);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */
    }
  }
}

static void JPEG_DMAInCpltCallback(DMA_HandleTypeDef *hdma)
{
  JPEG_HandleTypeDef *hjpeg = (JPEG_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* Disable The JPEG IT so the DMA Input Callback can not be interrupted by the JPEG EOC IT or JPEG HPD IT */
  __HAL_JPEG_DISABLE_IT(hjpeg, JPEG_INTERRUPT_MASK);

  if ((hjpeg->Context & (JPEG_CONTEXT_METHOD_MASK | JPEG_CONTEXT_ENDING_DMA)) ==
      JPEG_CONTEXT_DMA) /* Check if context method is DMA and we are not in ending DMA stage */
  {
    JPEG_DISABLE_DMA(hjpeg, JPEG_DMA_IDMA);

    hjpeg->JpegInCount = hjpeg->InDataLength - JPEG_GET_DMA_REMAIN_DATA(hdma);

    /*Call HAL_JPEG_GetDataCallback to get new data */
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
    hjpeg->GetDataCallback(hjpeg, hjpeg->JpegInCount);
#else
    HAL_JPEG_GetDataCallback(hjpeg, hjpeg->JpegInCount);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */

    if (hjpeg->InDataLength >= 4UL)
    {
      /*JPEG Input DMA transfer data number must be multiple of 32 bits word
        as the destination is a 32 bits (4 bytes) register */
      hjpeg->InDataLength = ((hjpeg->InDataLength + 3UL) / 4UL) * 4UL;
    }
    else
    {
      /* Nothing to do */
    }

    if (((hjpeg->Context &  JPEG_CONTEXT_PAUSE_INPUT) == 0UL) && (hjpeg->InDataLength > 0UL))
    {
      /* Start DMA FIFO In transfer */
      if (HAL_DMA_Start_IT(hjpeg->hdmain, (uint32_t)hjpeg->pJpegInBuffPtr, (uint32_t)&hjpeg->Instance->DIR,
                           hjpeg->InDataLength) != HAL_OK)
      {
        hjpeg->ErrorCode |= HAL_JPEG_ERROR_DMA;
        hjpeg->State = HAL_JPEG_STATE_ERROR;
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
        hjpeg->ErrorCallback(hjpeg);
#else
        HAL_JPEG_ErrorCallback(hjpeg);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */
        return;
      }
      JPEG_ENABLE_DMA(hjpeg, JPEG_DMA_IDMA);
    }

    /* JPEG Conversion still on going : Enable the JPEG IT */
    __HAL_JPEG_ENABLE_IT(hjpeg, JPEG_IT_EOC | JPEG_IT_HPD);
  }
}

static void JPEG_DMAOutCpltCallback(DMA_HandleTypeDef *hdma)
{
  JPEG_HandleTypeDef *hjpeg = (JPEG_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* Disable The JPEG IT so the DMA Output Callback can not be interrupted by the JPEG EOC IT or JPEG HPD IT */
  __HAL_JPEG_DISABLE_IT(hjpeg, JPEG_INTERRUPT_MASK);

  if ((hjpeg->Context & (JPEG_CONTEXT_METHOD_MASK | JPEG_CONTEXT_ENDING_DMA)) ==
      JPEG_CONTEXT_DMA) /* Check if context method is DMA and we are not in ending DMA stage */
  {
    if (__HAL_JPEG_GET_FLAG(hjpeg, JPEG_FLAG_EOCF) == 0UL)
    {
      JPEG_DISABLE_DMA(hjpeg, JPEG_DMA_ODMA);
      hjpeg->JpegOutCount = hjpeg->OutDataLength - JPEG_GET_DMA_REMAIN_DATA(hdma);

      /*Output Buffer is full, call HAL_JPEG_DataReadyCallback*/
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
      hjpeg->DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#else
      HAL_JPEG_DataReadyCallback(hjpeg, hjpeg->pJpegOutBuffPtr, hjpeg->JpegOutCount);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */

      if ((hjpeg->Context &  JPEG_CONTEXT_PAUSE_OUTPUT) == 0UL)
      {
        /* Start DMA FIFO Out transfer */
        if (HAL_DMA_Start_IT(hjpeg->hdmaout, (uint32_t)&hjpeg->Instance->DOR, (uint32_t)hjpeg->pJpegOutBuffPtr,
                             hjpeg->OutDataLength) != HAL_OK)
        {
          hjpeg->ErrorCode |= HAL_JPEG_ERROR_DMA;
          hjpeg->State = HAL_JPEG_STATE_ERROR;
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
          hjpeg->ErrorCallback(hjpeg);
#else
          HAL_JPEG_ErrorCallback(hjpeg);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */
          return;
        }
        JPEG_ENABLE_DMA(hjpeg, JPEG_DMA_ODMA);
      }
    }

    /* JPEG Conversion still on going : Enable the JPEG IT */
    __HAL_JPEG_ENABLE_IT(hjpeg, JPEG_IT_EOC | JPEG_IT_HPD);
  }
}

static void JPEG_DMAErrorCallback(DMA_HandleTypeDef *hdma)
{
  JPEG_HandleTypeDef *hjpeg = (JPEG_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  if (HAL_DMA_GetError(hdma) != HAL_DMA_ERROR_NONE)
  {
    /*Stop Encoding/Decoding*/
    hjpeg->Instance->CONFR0 &=  ~JPEG_CONFR0_START;

    /* Disable All Interrupts */
    __HAL_JPEG_DISABLE_IT(hjpeg, JPEG_INTERRUPT_MASK);

    /* Disable All DMA requests */
    JPEG_DISABLE_DMA(hjpeg, JPEG_DMA_MASK);

    hjpeg->State = HAL_JPEG_STATE_READY;
    hjpeg->ErrorCode |= HAL_JPEG_ERROR_DMA;
#if (USE_HAL_JPEG_REGISTER_CALLBACKS == 1)
    hjpeg->ErrorCallback(hjpeg);
#else
    HAL_JPEG_ErrorCallback(hjpeg);
#endif /* USE_HAL_JPEG_REGISTER_CALLBACKS */
  }
}

static void JPEG_DMAOutAbortCallback(DMA_HandleTypeDef *hdma)
{
  JPEG_HandleTypeDef *hjpeg = (JPEG_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  if ((hjpeg->Context & JPEG_CONTEXT_ENDING_DMA) != 0UL)
  {
    JPEG_DMA_EndProcess(hjpeg);
  }
}

static uint32_t JPEG_GetQuality(const JPEG_HandleTypeDef *hjpeg)
{
  uint32_t quality = 0;
  uint32_t quantRow;
  uint32_t quantVal;
  uint32_t scale;
  uint32_t i;
  uint32_t j;
  const __IO uint32_t *tableAddress = hjpeg->Instance->QMEM0;

  i = 0;
  while (i < (JPEG_QUANT_TABLE_SIZE - 3UL))
  {
    quantRow = *tableAddress;
    for (j = 0; j < 4UL; j++)
    {
      quantVal = (quantRow >> (8UL * j)) & 0xFFUL;
      if (quantVal == 1UL)
      {
        /* if Quantization value = 1 then quality is 100%*/
        quality += 100UL;
      }
      else
      {
        /* Note that the quantization coefficients must be specified in the table in zigzag order */
        scale = (quantVal * 100UL) / ((uint32_t) hjpeg->QuantTable0[JPEG_ZIGZAG_ORDER[i + j]]);

        if (scale <= 100UL)
        {
          quality += (200UL - scale) / 2UL;
        }
        else
        {
          quality += 5000UL / scale;
        }
      }
    }

    i += 4UL;
    tableAddress ++;
  }

  return (quality / 64UL);
}
