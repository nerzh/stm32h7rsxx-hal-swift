/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * ST HAL BSD-3-Clause and CMSIS Apache-2.0 constants, pinned references.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt and
 * LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
#ifndef C_RNG_REFERENCE_BITS_H
#define C_RNG_REFERENCE_BITS_H
#define RNG_CR_RNGEN_Pos               (2U)
#define RNG_CR_RNGEN_Msk               (0x1UL << RNG_CR_RNGEN_Pos)             /*!< 0x00000004 */
#define RNG_CR_RNGEN                   RNG_CR_RNGEN_Msk
#define RNG_CR_IE_Pos                  (3U)
#define RNG_CR_IE_Msk                  (0x1UL << RNG_CR_IE_Pos)                /*!< 0x00000008 */
#define RNG_CR_IE                      RNG_CR_IE_Msk
#define RNG_CR_CED_Pos                 (5U)
#define RNG_CR_CED_Msk                 (0x1UL << RNG_CR_CED_Pos)               /*!< 0x00000020 */
#define RNG_CR_CED                     RNG_CR_CED_Msk
#define RNG_CR_ARDIS_Pos               (7U)
#define RNG_CR_ARDIS_Msk               (0x1UL << RNG_CR_ARDIS_Pos)
#define RNG_CR_ARDIS                   RNG_CR_ARDIS_Msk
#define RNG_CR_RNG_CONFIG3_Pos         (8U)
#define RNG_CR_RNG_CONFIG3_Msk         (0xFUL << RNG_CR_RNG_CONFIG3_Pos)
#define RNG_CR_RNG_CONFIG3             RNG_CR_RNG_CONFIG3_Msk
#define RNG_CR_NISTC_Pos               (12U)
#define RNG_CR_NISTC_Msk               (0x1UL << RNG_CR_NISTC_Pos)
#define RNG_CR_NISTC                   RNG_CR_NISTC_Msk
#define RNG_CR_RNG_CONFIG2_Pos         (13U)
#define RNG_CR_RNG_CONFIG2_Msk         (0x7UL << RNG_CR_RNG_CONFIG2_Pos)
#define RNG_CR_RNG_CONFIG2             RNG_CR_RNG_CONFIG2_Msk
#define RNG_CR_CLKDIV_Pos              (16U)
#define RNG_CR_CLKDIV_Msk              (0xFUL << RNG_CR_CLKDIV_Pos)
#define RNG_CR_CLKDIV                  RNG_CR_CLKDIV_Msk
#define RNG_CR_CLKDIV_0                (0x1UL << RNG_CR_CLKDIV_Pos)            /*!< 0x00010000 */
#define RNG_CR_CLKDIV_1                (0x2UL << RNG_CR_CLKDIV_Pos)            /*!< 0x00020000 */
#define RNG_CR_CLKDIV_2                (0x4UL << RNG_CR_CLKDIV_Pos)            /*!< 0x00040000 */
#define RNG_CR_CLKDIV_3                (0x8UL << RNG_CR_CLKDIV_Pos)            /*!< 0x00080000 */
#define RNG_CR_RNG_CONFIG1_Pos         (20U)
#define RNG_CR_RNG_CONFIG1_Msk         (0x3FUL << RNG_CR_RNG_CONFIG1_Pos)
#define RNG_CR_RNG_CONFIG1             RNG_CR_RNG_CONFIG1_Msk
#define RNG_CR_CONDRST_Pos             (30U)
#define RNG_CR_CONDRST_Msk             (0x1UL << RNG_CR_CONDRST_Pos)
#define RNG_CR_CONDRST                 RNG_CR_CONDRST_Msk
#define RNG_CR_CONFIGLOCK_Pos          (31U)
#define RNG_CR_CONFIGLOCK_Msk          (0x1UL << RNG_CR_CONFIGLOCK_Pos)
#define RNG_CR_CONFIGLOCK              RNG_CR_CONFIGLOCK_Msk
#define RNG_SR_DRDY_Pos                (0U)
#define RNG_SR_DRDY_Msk                (0x1UL << RNG_SR_DRDY_Pos)              /*!< 0x00000001 */
#define RNG_SR_DRDY                    RNG_SR_DRDY_Msk
#define RNG_SR_CECS_Pos                (1U)
#define RNG_SR_CECS_Msk                (0x1UL << RNG_SR_CECS_Pos)              /*!< 0x00000002 */
#define RNG_SR_CECS                    RNG_SR_CECS_Msk
#define RNG_SR_SECS_Pos                (2U)
#define RNG_SR_SECS_Msk                (0x1UL << RNG_SR_SECS_Pos)              /*!< 0x00000004 */
#define RNG_SR_SECS                    RNG_SR_SECS_Msk
#define RNG_SR_CEIS_Pos                (5U)
#define RNG_SR_CEIS_Msk                (0x1UL << RNG_SR_CEIS_Pos)              /*!< 0x00000020 */
#define RNG_SR_CEIS                    RNG_SR_CEIS_Msk
#define RNG_SR_SEIS_Pos                (6U)
#define RNG_SR_SEIS_Msk                (0x1UL << RNG_SR_SEIS_Pos)              /*!< 0x00000040 */
#define RNG_SR_SEIS                    RNG_SR_SEIS_Msk
#define RNG_IT_DRDY  RNG_SR_DRDY  /*!< Data Ready interrupt  */
#define RNG_IT_CEI   RNG_SR_CEIS  /*!< Clock error interrupt */
#define RNG_IT_SEI   RNG_SR_SEIS  /*!< Seed error interrupt  */
#define RNG_FLAG_DRDY   RNG_SR_DRDY  /*!< Data ready                 */
#define RNG_FLAG_CECS   RNG_SR_CECS  /*!< Clock error current status */
#define RNG_FLAG_SECS   RNG_SR_SECS  /*!< Seed error current status  */
#define RNG_CED_ENABLE          0x00000000U /*!< Clock error detection Enabled  */
#define RNG_CED_DISABLE         RNG_CR_CED  /*!< Clock error detection Disabled */
#define  HAL_RNG_ERROR_NONE             0x00000000U    /*!< No error          */
#define  HAL_RNG_ERROR_INVALID_CALLBACK 0x00000001U    /*!< Invalid Callback error  */
#define  HAL_RNG_ERROR_TIMEOUT          0x00000002U    /*!< Timeout error     */
#define  HAL_RNG_ERROR_BUSY             0x00000004U    /*!< Busy error        */
#define  HAL_RNG_ERROR_SEED             0x00000008U    /*!< Seed error        */
#define  HAL_RNG_ERROR_CLOCK            0x00000010U    /*!< Clock error       */
#define  HAL_RNG_ERROR_RECOVERSEED      0x00000020U    /*!< Recover Seed error */
#define IS_RNG_IT(IT) (((IT) == RNG_IT_CEI) || \
                       ((IT) == RNG_IT_SEI))
#define IS_RNG_FLAG(FLAG) (((FLAG) == RNG_FLAG_DRDY) || \
                           ((FLAG) == RNG_FLAG_CECS) || \
                           ((FLAG) == RNG_FLAG_SECS))
#define IS_RNG_CED(__MODE__)   (((__MODE__) == RNG_CED_ENABLE) || \
                                ((__MODE__) == RNG_CED_DISABLE))
#define RNG_CLKDIV_BY_1       (0x00000000UL)      /*!< No clock division  */
#define RNG_CLKDIV_BY_2       (RNG_CR_CLKDIV_0)
#define RNG_CLKDIV_BY_4       (RNG_CR_CLKDIV_1)
#define RNG_CLKDIV_BY_8       (RNG_CR_CLKDIV_1 | RNG_CR_CLKDIV_0)
#define RNG_CLKDIV_BY_16      (RNG_CR_CLKDIV_2)
#define RNG_CLKDIV_BY_32      (RNG_CR_CLKDIV_2 | RNG_CR_CLKDIV_0)
#define RNG_CLKDIV_BY_64      (RNG_CR_CLKDIV_2 | RNG_CR_CLKDIV_1)
#define RNG_CLKDIV_BY_128     (RNG_CR_CLKDIV_2 | RNG_CR_CLKDIV_1 | RNG_CR_CLKDIV_0)
#define RNG_CLKDIV_BY_256     (RNG_CR_CLKDIV_3)
#define RNG_CLKDIV_BY_512     (RNG_CR_CLKDIV_3 | RNG_CR_CLKDIV_0)
#define RNG_CLKDIV_BY_1024    (RNG_CR_CLKDIV_3 | RNG_CR_CLKDIV_1)
#define RNG_CLKDIV_BY_2048    (RNG_CR_CLKDIV_3 | RNG_CR_CLKDIV_1 | RNG_CR_CLKDIV_0)
#define RNG_CLKDIV_BY_4096    (RNG_CR_CLKDIV_3 | RNG_CR_CLKDIV_2)
#define RNG_CLKDIV_BY_8192    (RNG_CR_CLKDIV_3 | RNG_CR_CLKDIV_2 | RNG_CR_CLKDIV_0)
#define RNG_CLKDIV_BY_16384   (RNG_CR_CLKDIV_3 | RNG_CR_CLKDIV_2 | RNG_CR_CLKDIV_1)
#define RNG_CLKDIV_BY_32768   (RNG_CR_CLKDIV_3 | RNG_CR_CLKDIV_2 | RNG_CR_CLKDIV_1 | RNG_CR_CLKDIV_0)
#define RNG_NIST_COMPLIANT     (0x00000000UL) /*!< NIST compliant configuration*/
#define RNG_CUSTOM_NIST        (RNG_CR_NISTC) /*!< Custom NIST configuration */
#define RNG_ARDIS_ENABLE     (0x00000000UL) /*!< automatic reset after seed error*/
#define RNG_ARDIS_DISABLE    (RNG_CR_ARDIS) /*!< Disable automatic reset after seed error */
#define IS_RNG_CLOCK_DIVIDER(__CLOCK_DIV__) (((__CLOCK_DIV__) == RNG_CLKDIV_BY_1)     || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_2)     || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_4)     || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_8)     || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_16)    || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_32)    || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_64)    || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_128)   || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_256)   || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_512)   || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_1024)  || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_2048)  || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_4096)  || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_8192)  || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_16384) || \
                                             ((__CLOCK_DIV__) == RNG_CLKDIV_BY_32768))
#define IS_RNG_NIST_COMPLIANCE(__NIST_COMPLIANCE__) (((__NIST_COMPLIANCE__) == RNG_NIST_COMPLIANT) || \
                                                     ((__NIST_COMPLIANCE__) == RNG_CUSTOM_NIST))
#define IS_RNG_CONFIG1(__CONFIG1__) ((__CONFIG1__) <= 0x3FUL)
#define IS_RNG_CONFIG2(__CONFIG2__) ((__CONFIG2__) <= 0x07UL)
#define IS_RNG_CONFIG3(__CONFIG3__) ((__CONFIG3__) <= 0xFUL)
#define IS_RNG_ARDIS(__ARDIS__) (((__ARDIS__) == RNG_ARDIS_ENABLE) || \
                                 ((__ARDIS__) == RNG_ARDIS_DISABLE))
#endif
