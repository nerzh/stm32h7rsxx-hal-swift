/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define  HAL_HASH_ERROR_NONE             0x00000000U   /*!< No error                */

#define  HAL_HASH_ERROR_BUSY             0x00000001U   /*!< Busy flag error  */

#define  HAL_HASH_ERROR_DMA              0x00000002U   /*!< DMA-based process error */

#define  HAL_HASH_ERROR_TIMEOUT          0x00000004U   /*!< Timeout error */

#if (USE_HAL_HASH_REGISTER_CALLBACKS == 1U)
#define  HAL_HASH_ERROR_INVALID_CALLBACK 0x00000010U   /*!< Invalid Callback error  */
#endif

#define HASH_ALGOSELECTION_SHA1         0x00000000U                         /*!< HASH function is SHA1   */

#define HASH_ALGOSELECTION_SHA224       HASH_CR_ALGO_1                      /*!< HASH function is SHA224 */

#define HASH_ALGOSELECTION_SHA256       (HASH_CR_ALGO_0 | HASH_CR_ALGO_1)   /*!< HASH function is SHA256 */

#define HASH_ALGOSELECTION_SHA384       (HASH_CR_ALGO_2 |  HASH_CR_ALGO_3)  /*!< HASH function is SHA384 */

#define HASH_ALGOSELECTION_SHA512_224   (HASH_CR_ALGO_0 | HASH_CR_ALGO_2 |  HASH_CR_ALGO_3)

#define HASH_ALGOSELECTION_SHA512_256   (HASH_CR_ALGO_1 | HASH_CR_ALGO_2 |  HASH_CR_ALGO_3)

#define HASH_ALGOSELECTION_SHA512        HASH_CR_ALGO                       /*!< HASH function is SHA512 */

#define HASH_ALGOMODE_HASH         0x00000000U     /*!< HASH mode */

#define HASH_ALGOMODE_HMAC         HASH_CR_MODE    /*!< HMAC mode */

#define HASH_NO_SWAP          0x00000000U        /*!< 32-bit data. No swapping                     */

#define HASH_HALFWORD_SWAP    HASH_CR_DATATYPE_0 /*!< 16-bit data. Each half word is swapped       */

#define HASH_BYTE_SWAP        HASH_CR_DATATYPE_1 /*!< 8-bit data. All bytes are swapped            */

#define HASH_BIT_SWAP         HASH_CR_DATATYPE   /*!< 1-bit data. In the word all bits are swapped */

#define HASH_SHORTKEY      0x00000000U   /*!< HMAC Key size is <= block size (64 or 128 bytes) */

#define HASH_LONGKEY       HASH_CR_LKEY  /*!< HMAC Key size is > block size (64 or 128 bytes) */

#define HASH_FLAG_DINIS            HASH_SR_DINIS  /*!< 16 locations are free in the DIN : new block can be entered 
                                                       in the Peripheral */

#define HASH_FLAG_DCIS             HASH_SR_DCIS   /*!< Digest calculation complete                                    */

#define HASH_FLAG_DMAS             HASH_SR_DMAS   /*!< DMA interface is enabled (DMAE=1) or a transfer is ongoing     */

#define HASH_FLAG_BUSY             HASH_SR_BUSY   /*!< The hash core is Busy, processing a block of data              */

#define HASH_FLAG_DINNE            HASH_CR_DINNE  /*!< DIN not empty : input buffer contains at least one word of data*/

#define HASH_IT_DINI               HASH_IMR_DINIE  /*!< A new block can be entered into the input buffer (DIN) */

#define HASH_IT_DCI                HASH_IMR_DCIE   /*!< Digest calculation complete                            */

#define __HAL_HASH_GET_FLAG(__HANDLE__, __FLAG__)  (((__FLAG__) > 8U)  ?                           \
                                                    ((((__HANDLE__)->Instance->CR & (__FLAG__)) == \
                                                      (__FLAG__)) ? SET : RESET) :                     \
                                                    ((((__HANDLE__)->Instance->SR & (__FLAG__)) == \
                                                      (__FLAG__)) ? SET : RESET) )

#define __HAL_HASH_CLEAR_FLAG(__HANDLE__, __FLAG__) CLEAR_BIT((__HANDLE__)->Instance->SR, (__FLAG__))

#define __HAL_HASH_GET_IT_SOURCE(__HANDLE__, __INTERRUPT__) (((__HANDLE__)->Instance->IMR\
                                                              & (__INTERRUPT__)) == (__INTERRUPT__))

#define __HAL_HASH_ENABLE_IT(__HANDLE__, __INTERRUPT__)   SET_BIT((__HANDLE__)->Instance->IMR, (__INTERRUPT__))

#define __HAL_HASH_DISABLE_IT(__HANDLE__, __INTERRUPT__)   CLEAR_BIT((__HANDLE__)->Instance->IMR, (__INTERRUPT__))

#if (USE_HAL_HASH_REGISTER_CALLBACKS == 1)
#define __HAL_HASH_RESET_HANDLE_STATE(__HANDLE__) do{\
                                                      (__HANDLE__)->State = HAL_HASH_STATE_RESET;\
                                                      (__HANDLE__)->MspInitCallback = NULL;      \
                                                      (__HANDLE__)->MspDeInitCallback = NULL;    \
                                                     }while(0)
#else
#define __HAL_HASH_RESET_HANDLE_STATE(__HANDLE__) ((__HANDLE__)->State = HAL_HASH_STATE_RESET)
#endif /* USE_HAL_HASH_REGISTER_CALLBACKS */

#define __HAL_HASH_SET_MDMAT()          SET_BIT(HASH->CR, HASH_CR_MDMAT)

#define __HAL_HASH_RESET_MDMAT()        CLEAR_BIT(HASH->CR, HASH_CR_MDMAT)

#define HAL_HASH_VERSION       200  /*!< HAL HASH driver version 2.0.0*/

#define HASH_DIGEST_LENGTH(__HANDLE__) (((READ_BIT((__HANDLE__)->Instance->CR, HASH_CR_ALGO) \
                                          == HASH_ALGOSELECTION_SHA1) ?  20U : \
                                         ((READ_BIT((__HANDLE__)->Instance->CR, HASH_CR_ALGO) \
                                           == HASH_ALGOSELECTION_SHA224) ?  28U : \
                                          ((READ_BIT((__HANDLE__)->Instance->CR, HASH_CR_ALGO) \
                                            == HASH_ALGOSELECTION_SHA256) ?  32U : \
                                           ((READ_BIT((__HANDLE__)->Instance->CR, HASH_CR_ALGO) \
                                             == HASH_ALGOSELECTION_SHA384) ?  48U : \
                                            ((READ_BIT((__HANDLE__)->Instance->CR, HASH_CR_ALGO) \
                                              == HASH_ALGOSELECTION_SHA512_224) ?  28U : \
                                             ((READ_BIT((__HANDLE__)->Instance->CR, HASH_CR_ALGO) \
                                               == HASH_ALGOSELECTION_SHA512_256) ?  32U : \
                                              ((READ_BIT((__HANDLE__)->Instance->CR, HASH_CR_ALGO) \
                                                == HASH_ALGOSELECTION_SHA512) ?  64U : 20U ) ) ))))))

#define IS_HASH_DATATYPE(__DATATYPE__) (((__DATATYPE__) == HASH_NO_SWAP)|| \
                                        ((__DATATYPE__) == HASH_HALFWORD_SWAP)|| \
                                        ((__DATATYPE__) == HASH_BYTE_SWAP) || \
                                        ((__DATATYPE__) == HASH_BIT_SWAP))

#define IS_HASH_ALGORITHM(__ALGORITHM__) (((__ALGORITHM__) == HASH_ALGOSELECTION_SHA1)|| \
                                          ((__ALGORITHM__) == HASH_ALGOSELECTION_SHA224)|| \
                                          ((__ALGORITHM__) == HASH_ALGOSELECTION_SHA256)|| \
                                          ((__ALGORITHM__) == HASH_ALGOSELECTION_SHA384)|| \
                                          ((__ALGORITHM__) == HASH_ALGOSELECTION_SHA512_224)|| \
                                          ((__ALGORITHM__) == HASH_ALGOSELECTION_SHA512_256)|| \
                                          ((__ALGORITHM__) == HASH_ALGOSELECTION_SHA512))

#define HASH_TIMEOUTVALUE                         1000U  /*!< Time-out value  */

#define BLOCK_64B                                 64U    /*!< block Size equal to 64 bytes */

#define BLOCK_128B                                128U   /*!< block Size equal to 128 bytes */

#define HASH_NUMBER_OF_CSR_REGISTERS              103U /*!< Number of Context Swap Registers */

#define UNUSED(X) (void)X      /* To avoid gcc/g++ warnings */

#define HAL_MAX_DELAY      0xFFFFFFFFU

#define HAL_IS_BIT_SET(REG, BIT)         (((REG) & (BIT)) == (BIT))

#define HAL_IS_BIT_CLR(REG, BIT)         (((REG) & (BIT)) == 0U)

#define __HAL_LOCK(__HANDLE__)            \
  do{                                     \
    if((__HANDLE__)->Lock == HAL_LOCKED)  \
    {                                     \
      return HAL_BUSY;                    \
    }                                     \
    else                                  \
    {                                     \
      (__HANDLE__)->Lock = HAL_LOCKED;    \
    }                                     \
  }while (0)

#define __HAL_UNLOCK(__HANDLE__)          \
  do{                                     \
    (__HANDLE__)->Lock = HAL_UNLOCKED;    \
  }while (0)

#define __weak  __attribute__((weak))

#define DMA_LINKEDLIST                  (0x0080UL) /* DMA channel linked-list mode          */

#define NODE_CBR1_DEFAULT_OFFSET        (0x0002UL) /* CBR1 default offset                   */

#define NODE_CSAR_DEFAULT_OFFSET        (0x0003UL) /* CSAR default offset                   */

#define NODE_CDAR_DEFAULT_OFFSET        (0x0004UL) /* CDAR default offset                   */
