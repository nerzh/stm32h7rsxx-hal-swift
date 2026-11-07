/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define HAL_CORDIC_ERROR_NONE              ((uint32_t)0x00000000U)   /*!< No error                */

#define HAL_CORDIC_ERROR_PARAM             ((uint32_t)0x00000001U)   /*!< Wrong parameter error   */

#define HAL_CORDIC_ERROR_NOT_READY         ((uint32_t)0x00000002U)   /*!< Peripheral not ready    */

#define HAL_CORDIC_ERROR_TIMEOUT           ((uint32_t)0x00000004U)   /*!< Timeout error           */

#define HAL_CORDIC_ERROR_DMA               ((uint32_t)0x00000008U)   /*!< DMA error               */

#define HAL_CORDIC_ERROR_INVALID_CALLBACK  ((uint32_t)0x00000010U)   /*!< Invalid Callback error  */

#define CORDIC_FUNCTION_COSINE      (0x00000000U)                                                          /*!< Cosine */

#define CORDIC_FUNCTION_SINE        ((uint32_t)(CORDIC_CSR_FUNC_0))                                        /*!< Sine */

#define CORDIC_FUNCTION_PHASE       ((uint32_t)(CORDIC_CSR_FUNC_1))                                        /*!< Phase */

#define CORDIC_FUNCTION_MODULUS     ((uint32_t)(CORDIC_CSR_FUNC_1 | CORDIC_CSR_FUNC_0))                    /*!< Modulus */

#define CORDIC_FUNCTION_ARCTANGENT  ((uint32_t)(CORDIC_CSR_FUNC_2))                                        /*!< Arctangent */

#define CORDIC_FUNCTION_HCOSINE     ((uint32_t)(CORDIC_CSR_FUNC_2 | CORDIC_CSR_FUNC_0))                    /*!< Hyperbolic Cosine */

#define CORDIC_FUNCTION_HSINE       ((uint32_t)(CORDIC_CSR_FUNC_2 | CORDIC_CSR_FUNC_1))                    /*!< Hyperbolic Sine */

#define CORDIC_FUNCTION_HARCTANGENT ((uint32_t)(CORDIC_CSR_FUNC_2 | CORDIC_CSR_FUNC_1 | CORDIC_CSR_FUNC_0))/*!< Hyperbolic Arctangent */

#define CORDIC_FUNCTION_NATURALLOG  ((uint32_t)(CORDIC_CSR_FUNC_3))                                        /*!< Natural Logarithm */

#define CORDIC_FUNCTION_SQUAREROOT  ((uint32_t)(CORDIC_CSR_FUNC_3 | CORDIC_CSR_FUNC_0))                    /*!< Square Root */

#define CORDIC_PRECISION_1CYCLE     ((uint32_t)(CORDIC_CSR_PRECISION_0))

#define CORDIC_PRECISION_2CYCLES    ((uint32_t)(CORDIC_CSR_PRECISION_1))

#define CORDIC_PRECISION_3CYCLES    ((uint32_t)(CORDIC_CSR_PRECISION_1 | CORDIC_CSR_PRECISION_0))

#define CORDIC_PRECISION_4CYCLES    ((uint32_t)(CORDIC_CSR_PRECISION_2))

#define CORDIC_PRECISION_5CYCLES    ((uint32_t)(CORDIC_CSR_PRECISION_2 | CORDIC_CSR_PRECISION_0))

#define CORDIC_PRECISION_6CYCLES    ((uint32_t)(CORDIC_CSR_PRECISION_2 | CORDIC_CSR_PRECISION_1))

#define CORDIC_PRECISION_7CYCLES    ((uint32_t)(CORDIC_CSR_PRECISION_2\
                                                | CORDIC_CSR_PRECISION_1 | CORDIC_CSR_PRECISION_0))

#define CORDIC_PRECISION_8CYCLES    ((uint32_t)(CORDIC_CSR_PRECISION_3))

#define CORDIC_PRECISION_9CYCLES    ((uint32_t)(CORDIC_CSR_PRECISION_3 | CORDIC_CSR_PRECISION_0))

#define CORDIC_PRECISION_10CYCLES   ((uint32_t)(CORDIC_CSR_PRECISION_3 | CORDIC_CSR_PRECISION_1))

#define CORDIC_PRECISION_11CYCLES   ((uint32_t)(CORDIC_CSR_PRECISION_3\
                                                | CORDIC_CSR_PRECISION_1 | CORDIC_CSR_PRECISION_0))

#define CORDIC_PRECISION_12CYCLES   ((uint32_t)(CORDIC_CSR_PRECISION_3 | CORDIC_CSR_PRECISION_2))

#define CORDIC_PRECISION_13CYCLES   ((uint32_t)(CORDIC_CSR_PRECISION_3\
                                                | CORDIC_CSR_PRECISION_2 | CORDIC_CSR_PRECISION_0))

#define CORDIC_PRECISION_14CYCLES   ((uint32_t)(CORDIC_CSR_PRECISION_3\
                                                | CORDIC_CSR_PRECISION_2 | CORDIC_CSR_PRECISION_1))

#define CORDIC_PRECISION_15CYCLES   ((uint32_t)(CORDIC_CSR_PRECISION_3\
                                                | CORDIC_CSR_PRECISION_2 | CORDIC_CSR_PRECISION_1\
                                                |CORDIC_CSR_PRECISION_0))

#define CORDIC_SCALE_0              (0x00000000U)

#define CORDIC_SCALE_1              ((uint32_t)(CORDIC_CSR_SCALE_0))

#define CORDIC_SCALE_2              ((uint32_t)(CORDIC_CSR_SCALE_1))

#define CORDIC_SCALE_3              ((uint32_t)(CORDIC_CSR_SCALE_1 | CORDIC_CSR_SCALE_0))

#define CORDIC_SCALE_4              ((uint32_t)(CORDIC_CSR_SCALE_2))

#define CORDIC_SCALE_5              ((uint32_t)(CORDIC_CSR_SCALE_2 | CORDIC_CSR_SCALE_0))

#define CORDIC_SCALE_6              ((uint32_t)(CORDIC_CSR_SCALE_2 | CORDIC_CSR_SCALE_1))

#define CORDIC_SCALE_7              ((uint32_t)(CORDIC_CSR_SCALE_2 | CORDIC_CSR_SCALE_1 | CORDIC_CSR_SCALE_0))

#define CORDIC_IT_IEN              CORDIC_CSR_IEN            /*!< Result ready interrupt enable */

#define CORDIC_DMA_REN             CORDIC_CSR_DMAREN         /*!< DMA Read requests enable */

#define CORDIC_DMA_WEN             CORDIC_CSR_DMAWEN         /*!< DMA Write channel enable */

#define CORDIC_NBWRITE_1           (0x00000000U)             /*!< One 32-bits write containing either only one
                                                                  32-bit data input (Q1.31 format), or two 16-bit
                                                                  data input (Q1.15 format) packed in one 32 bits
                                                                  Data */

#define CORDIC_NBWRITE_2           CORDIC_CSR_NARGS          /*!< Two 32-bit write containing two 32-bits data input
                                                                  (Q1.31 format) */

#define CORDIC_NBREAD_1            (0x00000000U)             /*!< One 32-bits read containing either only one
                                                                  32-bit data output (Q1.31 format), or two 16-bit
                                                                  data output (Q1.15 format) packed in one 32 bits
                                                                  Data */

#define CORDIC_NBREAD_2            CORDIC_CSR_NRES           /*!< Two 32-bit Data containing two 32-bits data output
                                                                  (Q1.31 format) */

#define CORDIC_INSIZE_32BITS       (0x00000000U)             /*!< 32 bits input data size (Q1.31 format) */

#define CORDIC_INSIZE_16BITS       CORDIC_CSR_ARGSIZE        /*!< 16 bits input data size (Q1.15 format) */

#define CORDIC_OUTSIZE_32BITS      (0x00000000U)             /*!< 32 bits output data size (Q1.31 format) */

#define CORDIC_OUTSIZE_16BITS      CORDIC_CSR_RESSIZE        /*!< 16 bits output data size (Q1.15 format) */

#define CORDIC_FLAG_RRDY           CORDIC_CSR_RRDY           /*!< Result Ready Flag */

#define CORDIC_DMA_DIR_NONE        ((uint32_t)0x00000000U)   /*!< DMA direction : none */

#define CORDIC_DMA_DIR_IN          ((uint32_t)0x00000001U)   /*!< DMA direction : Input of CORDIC */

#define CORDIC_DMA_DIR_OUT         ((uint32_t)0x00000002U)   /*!< DMA direction : Output of CORDIC */

#define CORDIC_DMA_DIR_IN_OUT      ((uint32_t)0x00000003U)   /*!< DMA direction : Input and Output of CORDIC */

#if USE_HAL_CORDIC_REGISTER_CALLBACKS == 1
#define __HAL_CORDIC_RESET_HANDLE_STATE(__HANDLE__) do{                                                \
                                                        (__HANDLE__)->State = HAL_CORDIC_STATE_RESET;  \
                                                        (__HANDLE__)->MspInitCallback = NULL;          \
                                                        (__HANDLE__)->MspDeInitCallback = NULL;        \
                                                      } while(0)

#else
#define __HAL_CORDIC_RESET_HANDLE_STATE(__HANDLE__) ((__HANDLE__)->State = HAL_CORDIC_STATE_RESET)

#endif

#define __HAL_CORDIC_ENABLE_IT(__HANDLE__, __INTERRUPT__)                     \
  (((__HANDLE__)->Instance->CSR) |= (__INTERRUPT__))

#define __HAL_CORDIC_DISABLE_IT(__HANDLE__, __INTERRUPT__)                    \
  (((__HANDLE__)->Instance->CSR) &= ~(__INTERRUPT__))

#define __HAL_CORDIC_GET_IT(__HANDLE__, __INTERRUPT__)     /* Dummy macro */

#define __HAL_CORDIC_CLEAR_IT(__HANDLE__, __INTERRUPT__)   /* Dummy macro */

#define __HAL_CORDIC_GET_FLAG(__HANDLE__, __FLAG__)                           \
  ((((__HANDLE__)->Instance->CSR) & (__FLAG__)) == (__FLAG__))

#define __HAL_CORDIC_CLEAR_FLAG(__HANDLE__, __FLAG__)     /* Dummy macro */

#define __HAL_CORDIC_GET_IT_SOURCE(__HANDLE__, __INTERRUPT__)                 \
  (((__HANDLE__)->Instance->CSR) & (__INTERRUPT__))

#define IS_CORDIC_FUNCTION(__FUNCTION__) (((__FUNCTION__) == CORDIC_FUNCTION_COSINE)       || \
                                          ((__FUNCTION__) == CORDIC_FUNCTION_SINE)         || \
                                          ((__FUNCTION__) == CORDIC_FUNCTION_PHASE)        || \
                                          ((__FUNCTION__) == CORDIC_FUNCTION_MODULUS)      || \
                                          ((__FUNCTION__) == CORDIC_FUNCTION_ARCTANGENT)   || \
                                          ((__FUNCTION__) == CORDIC_FUNCTION_HCOSINE)      || \
                                          ((__FUNCTION__) == CORDIC_FUNCTION_HSINE)        || \
                                          ((__FUNCTION__) == CORDIC_FUNCTION_HARCTANGENT)  || \
                                          ((__FUNCTION__) == CORDIC_FUNCTION_NATURALLOG)   || \
                                          ((__FUNCTION__) == CORDIC_FUNCTION_SQUAREROOT))

#define IS_CORDIC_PRECISION(__PRECISION__) (((__PRECISION__) == CORDIC_PRECISION_1CYCLE)   || \
                                            ((__PRECISION__) == CORDIC_PRECISION_2CYCLES)  || \
                                            ((__PRECISION__) == CORDIC_PRECISION_3CYCLES)  || \
                                            ((__PRECISION__) == CORDIC_PRECISION_4CYCLES)  || \
                                            ((__PRECISION__) == CORDIC_PRECISION_5CYCLES)  || \
                                            ((__PRECISION__) == CORDIC_PRECISION_6CYCLES)  || \
                                            ((__PRECISION__) == CORDIC_PRECISION_7CYCLES)  || \
                                            ((__PRECISION__) == CORDIC_PRECISION_8CYCLES)  || \
                                            ((__PRECISION__) == CORDIC_PRECISION_9CYCLES)  || \
                                            ((__PRECISION__) == CORDIC_PRECISION_10CYCLES) || \
                                            ((__PRECISION__) == CORDIC_PRECISION_11CYCLES) || \
                                            ((__PRECISION__) == CORDIC_PRECISION_12CYCLES) || \
                                            ((__PRECISION__) == CORDIC_PRECISION_13CYCLES) || \
                                            ((__PRECISION__) == CORDIC_PRECISION_14CYCLES) || \
                                            ((__PRECISION__) == CORDIC_PRECISION_15CYCLES))

#define IS_CORDIC_SCALE(__SCALE__) (((__SCALE__) == CORDIC_SCALE_0)  || \
                                    ((__SCALE__) == CORDIC_SCALE_1)  || \
                                    ((__SCALE__) == CORDIC_SCALE_2)  || \
                                    ((__SCALE__) == CORDIC_SCALE_3)  || \
                                    ((__SCALE__) == CORDIC_SCALE_4)  || \
                                    ((__SCALE__) == CORDIC_SCALE_5)  || \
                                    ((__SCALE__) == CORDIC_SCALE_6)  || \
                                    ((__SCALE__) == CORDIC_SCALE_7))

#define IS_CORDIC_NBWRITE(__NBWRITE__) (((__NBWRITE__) == CORDIC_NBWRITE_1)  || \
                                        ((__NBWRITE__) == CORDIC_NBWRITE_2))

#define IS_CORDIC_NBREAD(__NBREAD__) (((__NBREAD__) == CORDIC_NBREAD_1)  || \
                                      ((__NBREAD__) == CORDIC_NBREAD_2))

#define IS_CORDIC_INSIZE(__INSIZE__) (((__INSIZE__) == CORDIC_INSIZE_32BITS)  || \
                                      ((__INSIZE__) == CORDIC_INSIZE_16BITS))

#define IS_CORDIC_OUTSIZE(__OUTSIZE__) (((__OUTSIZE__) == CORDIC_OUTSIZE_32BITS)  || \
                                        ((__OUTSIZE__) == CORDIC_OUTSIZE_16BITS))

#define IS_CORDIC_DMA_DIRECTION(__DMADIR__) (((__DMADIR__) == CORDIC_DMA_DIR_IN)  || \
                                             ((__DMADIR__) == CORDIC_DMA_DIR_OUT) || \
                                             ((__DMADIR__) == CORDIC_DMA_DIR_IN_OUT))
