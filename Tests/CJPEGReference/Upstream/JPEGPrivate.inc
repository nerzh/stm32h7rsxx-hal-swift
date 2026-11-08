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


#define JPEG_TIMEOUT_VALUE  ((uint32_t)1000)     /* 1s */
#define JPEG_AC_HUFF_TABLE_SIZE  ((uint32_t)162) /* Huffman AC table size : 162 codes*/
#define JPEG_DC_HUFF_TABLE_SIZE  ((uint32_t)12)  /* Huffman DC table size : 12 codes*/

#define JPEG_QUANTVAL_MAX ((uint32_t)255)           /* Quantization values are 8-bit numbers*/
#define JPEG_LOW_QUALITY_REFERENCE ((uint32_t)5000) /*Reference value to generate scaling factor
                                                      for low quality factors (<50) */
#define JPEG_HIGH_QUALITY_REFERENCE ((uint32_t)200) /*Reference value to generate scaling factor
                                                      for high quality factors (>=50)*/

#define JPEG_FIFO_SIZE ((uint32_t)16U)              /* JPEG Input/Output HW FIFO size in words*/

#define JPEG_FIFO_TH_SIZE ((uint32_t)4U)            /* JPEG Input/Output HW FIFO Threshold in words*/

#define JPEG_DMA_MASK     ((uint32_t)0x00001800)     /* JPEG DMA request Mask*/
#define JPEG_DMA_IDMA     ((uint32_t)JPEG_CR_IDMAEN)  /* DMA request for the input FIFO */
#define JPEG_DMA_ODMA     ((uint32_t)JPEG_CR_ODMAEN)  /* DMA request for the output FIFO */

#define JPEG_INTERRUPT_MASK  ((uint32_t)0x0000007EU) /* JPEG Interrupt Mask*/

#define JPEG_CONTEXT_ENCODE          ((uint32_t)0x00000001) /* JPEG context : operation is encoding*/
#define JPEG_CONTEXT_DECODE          ((uint32_t)0x00000002) /* JPEG context : operation is decoding*/
#define JPEG_CONTEXT_OPERATION_MASK  ((uint32_t)0x00000003) /* JPEG context : operation Mask */

#define JPEG_CONTEXT_POLLING        ((uint32_t)0x00000004)  /* JPEG context : Transfer use Polling */
#define JPEG_CONTEXT_IT             ((uint32_t)0x00000008)  /* JPEG context : Transfer use Interrupt */
#define JPEG_CONTEXT_DMA            ((uint32_t)0x0000000C)  /* JPEG context : Transfer use DMA */
#define JPEG_CONTEXT_METHOD_MASK    ((uint32_t)0x0000000C)  /* JPEG context : Transfer Mask */


#define JPEG_CONTEXT_CONF_ENCODING  ((uint32_t)0x00000100)  /* JPEG context : encoding config done */

#define JPEG_CONTEXT_PAUSE_INPUT    ((uint32_t)0x00001000)  /* JPEG context : Pause Input */
#define JPEG_CONTEXT_PAUSE_OUTPUT   ((uint32_t)0x00002000)  /* JPEG context : Pause Output */

#define JPEG_CONTEXT_CUSTOM_TABLES  ((uint32_t)0x00004000)  /* JPEG context : Use custom quantization tables */

#define JPEG_CONTEXT_ENDING_DMA     ((uint32_t)0x00008000)  /* JPEG context : ending with DMA in progress */

#define JPEG_PROCESS_ONGOING        ((uint32_t)0x00000000)  /* Process is on going */
#define JPEG_PROCESS_DONE           ((uint32_t)0x00000001)  /* Process is done (ends) */
#define JPEG_GET_DMA_REMAIN_DATA(__HANDLE__)     (__HAL_DMA_GET_COUNTER(__HANDLE__)\
                                                  + HAL_DMAEx_GetFifoLevel(__HANDLE__))
/**
  * @}
  */

/* Private typedef -----------------------------------------------------------*/
/** @addtogroup JPEG_Private_Types
  * @{
  */

/*
 JPEG Huffman Table Structure definition :
 This implementation of Huffman table structure is compliant with ISO/IEC 10918-1 standard,
 Annex C Huffman Table specification
 */
typedef struct
{
  /* These two fields directly represent the contents of a JPEG DHT marker */
  uint8_t Bits[16];        /*!< bits[k] = # of symbols with codes of length k bits,
                             this parameter corresponds to BITS list in the Annex C */

  uint8_t HuffVal[162];    /*!< The symbols, in order of incremented code length,
                             this parameter corresponds to HUFFVAL list in the Annex C */


} JPEG_ACHuffTableTypeDef;

typedef struct
{
  /* These two fields directly represent the contents of a JPEG DHT marker */
  uint8_t Bits[16];        /*!< bits[k] = # of symbols with codes of length k bits,
                             this parameter corresponds to BITS list in the Annex C */

  uint8_t HuffVal[12];    /*!< The symbols, in order of incremented code length,
                            this parameter corresponds to HUFFVAL list in the Annex C */


} JPEG_DCHuffTableTypeDef;

typedef struct
{
  uint8_t CodeLength[JPEG_AC_HUFF_TABLE_SIZE];      /*!< Code length  */

  uint32_t HuffmanCode[JPEG_AC_HUFF_TABLE_SIZE];    /*!< HuffmanCode */

} JPEG_AC_HuffCodeTableTypeDef;

typedef struct
{
  uint8_t CodeLength[JPEG_DC_HUFF_TABLE_SIZE];        /*!< Code length  */

  uint32_t HuffmanCode[JPEG_DC_HUFF_TABLE_SIZE];    /*!< HuffmanCode */

} JPEG_DC_HuffCodeTableTypeDef;
/**
  * @}
  */

/* Private macro -------------------------------------------------------------*/
/** @addtogroup JPEG_Private_Macros
  * @{
  */
#define JPEG_ENABLE_DMA(__HANDLE__,__DMA__)  ((__HANDLE__)->Instance->CR |= ((__DMA__) & JPEG_DMA_MASK))
/*note  : To disable a DMA request we must use MODIFY_REG macro to avoid writing "1" to the FIFO flush bits
         located in the same DMA request enable register (CR register). */
#define JPEG_DISABLE_DMA(__HANDLE__,__DMA__) MODIFY_REG((__HANDLE__)->Instance->CR, ((__DMA__) & JPEG_DMA_MASK), 0UL)
/**
  * @}
  */

/* Private variables ---------------------------------------------------------*/
/** @addtogroup JPEG_Private_Variables
  * @{
  */

/* The following Huffman tables, are based on the JPEG standard as defined by the ITU-T Recommendation T.81. */
static const JPEG_DCHuffTableTypeDef JPEG_DCLUM_HuffTable =
{
  { 0, 1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0 },   /*Bits*/

  { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0xa, 0xb }           /*HUFFVAL */

};

static const JPEG_DCHuffTableTypeDef JPEG_DCCHROM_HuffTable =
{
  { 0, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0 },  /*Bits*/

  { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0xa, 0xb }          /*HUFFVAL */
};

static const JPEG_ACHuffTableTypeDef JPEG_ACLUM_HuffTable =
{
  { 0, 2, 1, 3, 3, 2, 4, 3, 5, 5, 4, 4, 0, 0, 1, 0x7d },  /*Bits*/

  {
    0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12,     /*HUFFVAL */
    0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07,
    0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
    0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0,
    0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16,
    0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
    0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
    0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
    0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
    0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
    0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
    0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
    0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
    0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
    0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
    0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5,
    0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4,
    0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
    0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
    0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
    0xf9, 0xfa
  }
};

static const JPEG_ACHuffTableTypeDef JPEG_ACCHROM_HuffTable =
{
  { 0, 2, 1, 2, 4, 4, 3, 4, 7, 5, 4, 4, 0, 1, 2, 0x77 },   /*Bits*/

  {
    0x00, 0x01, 0x02, 0x03, 0x11, 0x04, 0x05, 0x21,      /*HUFFVAL */
    0x31, 0x06, 0x12, 0x41, 0x51, 0x07, 0x61, 0x71,
    0x13, 0x22, 0x32, 0x81, 0x08, 0x14, 0x42, 0x91,
    0xa1, 0xb1, 0xc1, 0x09, 0x23, 0x33, 0x52, 0xf0,
    0x15, 0x62, 0x72, 0xd1, 0x0a, 0x16, 0x24, 0x34,
    0xe1, 0x25, 0xf1, 0x17, 0x18, 0x19, 0x1a, 0x26,
    0x27, 0x28, 0x29, 0x2a, 0x35, 0x36, 0x37, 0x38,
    0x39, 0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48,
    0x49, 0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
    0x59, 0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68,
    0x69, 0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,
    0x79, 0x7a, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
    0x88, 0x89, 0x8a, 0x92, 0x93, 0x94, 0x95, 0x96,
    0x97, 0x98, 0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5,
    0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4,
    0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3,
    0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2,
    0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda,
    0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9,
    0xea, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
    0xf9, 0xfa
  }
};

static const uint8_t JPEG_ZIGZAG_ORDER[JPEG_QUANT_TABLE_SIZE] =
{
  0,   1,   8,  16,   9,   2,   3,  10,
  17,  24,  32,  25,  18,  11,   4,   5,
  12,  19,  26,  33,  40,  48,  41,  34,
  27,  20,  13,   6,   7,  14,  21,  28,
  35,  42,  49,  56,  57,  50,  43,  36,
  29,  22,  15,  23,  30,  37,  44,  51,
  58,  59,  52,  45,  38,  31,  39,  46,
  53,  60,  61,  54,  47,  55,  62,  63
};
/**
  * @}
  */

