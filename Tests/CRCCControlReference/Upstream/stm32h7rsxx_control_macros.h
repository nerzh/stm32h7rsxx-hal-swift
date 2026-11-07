/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Unchanged declarations/bodies/macros extracted from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748. Host substitutions are in the shim.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#pragma once
#define RCC_OSCILLATORTYPE_NONE        0x00000000U  /*!< Oscillator configuration unchanged */
#define RCC_OSCILLATORTYPE_HSE         0x00000001U  /*!< HSE selected */
#define RCC_OSCILLATORTYPE_HSI         0x00000002U  /*!< HSI selected */
#define RCC_OSCILLATORTYPE_LSE         0x00000004U  /*!< LSE selected */
#define RCC_OSCILLATORTYPE_LSI         0x00000008U  /*!< LSI selected */
#define RCC_OSCILLATORTYPE_CSI         0x00000010U  /*!< CSI selected */
#define RCC_OSCILLATORTYPE_HSI48       0x00000020U  /*!< HSI48 selected */
#define RCC_HSE_OFF                    0U                                                 /*!< HSE clock deactivation */
#define RCC_HSE_ON                     RCC_CR_HSEON                                       /*!< HSE clock activation */
#define RCC_HSE_BYPASS                 (RCC_CR_HSEBYP | RCC_CR_HSEON)                     /*!< HSE bypass analog clock activation */
#define RCC_HSE_BYPASS_DIGITAL         (RCC_CR_HSEEXT | RCC_CR_HSEBYP | RCC_CR_HSEON)     /*!< HSE bypass digital clock activation */
#define RCC_LSE_OFF                    0U                                                   /*!< LSE clock deactivation */
#define RCC_LSE_ON                     RCC_BDCR_LSEON                                       /*!< LSE clock activation */
#define RCC_LSE_BYPASS                 (RCC_BDCR_LSEBYP | RCC_BDCR_LSEON)                   /*!< LSE bypass analog clock activation */
#define RCC_LSE_BYPASS_DIGITAL         (RCC_BDCR_LSEEXT | RCC_BDCR_LSEBYP | RCC_BDCR_LSEON) /*!< LSE bypass digital clock activation */
#define RCC_HSI_OFF                    0U                                    /*!< HSI clock deactivation */
#define RCC_HSI_ON                     RCC_CR_HSION                          /*!< HSI clock activation with divider 1 = 64MHz */
#define RCC_HSI_DIV1                   0U                  /*!< HSI clock activation with divider 1 = 64MHz */
#define RCC_HSI_DIV2                   RCC_CR_HSIDIV_0     /*!< HSI clock activation with divider 2 = 32MHz */
#define RCC_HSI_DIV4                   RCC_CR_HSIDIV_1     /*!< HSI clock activation with divider 4 = 16MHz */
#define RCC_HSI_DIV8                   RCC_CR_HSIDIV       /*!< HSI clock activation with divider 8 = 8MHz */
#define RCC_HSI48_OFF                  0U                  /*!< HSI48 clock deactivation */
#define RCC_HSI48_ON                   RCC_CR_HSI48ON      /*!< HSI48 clock activation */
#define RCC_LSI_OFF                    0U                  /*!< LSI clock deactivation */
#define RCC_LSI_ON                     RCC_CSR_LSION       /*!< LSI clock activation */
#define RCC_CSI_OFF                    0U                  /*!< CSI clock deactivation */
#define RCC_CSI_ON                     RCC_CR_CSION        /*!< CSI clock activation */
#define RCC_PLL_NONE                   0U                  /*!< PLL configuration unchanged */
#define RCC_PLL_OFF                    1U                  /*!< PLL deactivation */
#define RCC_PLL_ON                     2U                  /*!< PLL activation */
#define RCC_PLLSOURCE_HSI              0U                     /*!< HSI clock selected as PLL entry clock source */
#define RCC_PLLSOURCE_CSI              RCC_PLLCKSELR_PLLSRC_0 /*!< CSI clock selected as PLL entry clock source */
#define RCC_PLLSOURCE_HSE              RCC_PLLCKSELR_PLLSRC_1 /*!< HSE clock selected as PLL entry clock source */
#define RCC_PLLSOURCE_NONE             RCC_PLLCKSELR_PLLSRC   /*!< No clock selected as PLL entry clock source  */
#define RCC_PLL_VCOINPUT_RANGE0             0U                    /*!< Clock range frequency for PLL between 1 and 2 MHz (reset) */
#define RCC_PLL_VCOINPUT_RANGE1             RCC_PLLCFGR_PLL1RGE_0 /*!< Clock range frequency for PLL between 2 and 4 MHz  */
#define RCC_PLL_VCOINPUT_RANGE2             RCC_PLLCFGR_PLL1RGE_1 /*!< Clock range frequency for PLL between 4 and 8 MHz  */
#define RCC_PLL_VCOINPUT_RANGE3             RCC_PLLCFGR_PLL1RGE   /*!< Clock range frequency for PLL between 8 and 16 MHz */
#define RCC_PLL_VCO_HIGH                    0U                       /*!< Wide PLL VCO output range between 400 and 1600 MHz (reset) */
#define RCC_PLL_VCO_LOW                     RCC_PLLCFGR_PLL1VCOSEL   /*!< Low PLL VCO output range between 150 and 420 MHz        */
#define RCC_CLOCKTYPE_SYSCLK           0x00000001U         /*!< SYSCLK to configure */
#define RCC_CLOCKTYPE_HCLK             0x00000002U         /*!< HCLK to configure */
#define RCC_CLOCKTYPE_PCLK1            0x00000004U         /*!< PCLK1 to configure */
#define RCC_CLOCKTYPE_PCLK2            0x00000008U         /*!< PCLK2 to configure */
#define RCC_CLOCKTYPE_PCLK4            0x00000010U         /*!< PCLK4 to configure */
#define RCC_CLOCKTYPE_PCLK5            0x00000020U         /*!< PCLK5 to configure */
#define RCC_SYSCLKSOURCE_HSI           0U                  /*!< HSI selection as system clock */
#define RCC_SYSCLKSOURCE_CSI           RCC_CFGR_SW_0       /*!< CSI selection as system clock */
#define RCC_SYSCLKSOURCE_HSE           RCC_CFGR_SW_1       /*!< HSE selection as system clock */
#define RCC_SYSCLKSOURCE_PLLCLK        (RCC_CFGR_SW_1 | RCC_CFGR_SW_0) /*!< PLL1 selection as system clock */
#define RCC_SYSCLKSOURCE_STATUS_HSI    0U                  /*!< HSI used as system clock */
#define RCC_SYSCLKSOURCE_STATUS_CSI    RCC_CFGR_SWS_0      /*!< CSI used as system clock */
#define RCC_SYSCLKSOURCE_STATUS_HSE    RCC_CFGR_SWS_1      /*!< HSE used as system clock */
#define RCC_SYSCLKSOURCE_STATUS_PLLCLK (RCC_CFGR_SWS_1 | RCC_CFGR_SWS_0) /*!< PLL1 used as system clock */
#define RCC_SYSCLK_DIV1      0U                                                          /*!< SYSCLK not divided */
#define RCC_SYSCLK_DIV2      RCC_CDCFGR_CPRE_3                                           /*!< SYSCLK divided by 2 */
#define RCC_SYSCLK_DIV4      (RCC_CDCFGR_CPRE_3 | RCC_CDCFGR_CPRE_0)                     /*!< SYSCLK divided by 4 */
#define RCC_SYSCLK_DIV8      (RCC_CDCFGR_CPRE_3 | RCC_CDCFGR_CPRE_1)                     /*!< SYSCLK divided by 8 */
#define RCC_SYSCLK_DIV16     (RCC_CDCFGR_CPRE_3 | RCC_CDCFGR_CPRE_1 | RCC_CDCFGR_CPRE_0) /*!< SYSCLK divided by 16 */
#define RCC_SYSCLK_DIV64     (RCC_CDCFGR_CPRE_3 | RCC_CDCFGR_CPRE_2)                     /*!< SYSCLK divided by 64 */
#define RCC_SYSCLK_DIV128    (RCC_CDCFGR_CPRE_3 | RCC_CDCFGR_CPRE_2 | RCC_CDCFGR_CPRE_0) /*!< SYSCLK divided by 128 */
#define RCC_SYSCLK_DIV256    (RCC_CDCFGR_CPRE_3 | RCC_CDCFGR_CPRE_2 | RCC_CDCFGR_CPRE_1) /*!< SYSCLK divided by 256 */
#define RCC_SYSCLK_DIV512    (RCC_CDCFGR_CPRE_3 | RCC_CDCFGR_CPRE_2 | RCC_CDCFGR_CPRE_1 | RCC_CDCFGR_CPRE_0) /*!< SYSCLK divided by 512 */
#define RCC_HCLK_DIV1        0U                                                             /*!< HCLK not divided */
#define RCC_HCLK_DIV2        RCC_BMCFGR_BMPRE_3                                             /*!< HCLK divided by 2 */
#define RCC_HCLK_DIV4        (RCC_BMCFGR_BMPRE_3 | RCC_BMCFGR_BMPRE_0)                      /*!< HCLK divided by 4 */
#define RCC_HCLK_DIV8        (RCC_BMCFGR_BMPRE_3 | RCC_BMCFGR_BMPRE_1)                      /*!< HCLK divided by 8 */
#define RCC_HCLK_DIV16       (RCC_BMCFGR_BMPRE_3 | RCC_BMCFGR_BMPRE_1 | RCC_BMCFGR_BMPRE_0) /*!< HCLK divided by 16 */
#define RCC_HCLK_DIV64       (RCC_BMCFGR_BMPRE_3 | RCC_BMCFGR_BMPRE_2)                      /*!< HCLK divided by 64 */
#define RCC_HCLK_DIV128      (RCC_BMCFGR_BMPRE_3 | RCC_BMCFGR_BMPRE_2 | RCC_BMCFGR_BMPRE_0) /*!< HCLK divided by 128 */
#define RCC_HCLK_DIV256      (RCC_BMCFGR_BMPRE_3 | RCC_BMCFGR_BMPRE_2 | RCC_BMCFGR_BMPRE_1) /*!< HCLK divided by 256 */
#define RCC_HCLK_DIV512      (RCC_BMCFGR_BMPRE_3 | RCC_BMCFGR_BMPRE_2 | RCC_BMCFGR_BMPRE_1 | RCC_BMCFGR_BMPRE_0) /*!< HCLK divided by 512 */
#define RCC_APB1_DIV1        0U                                                    /*!< APB1 not divided */
#define RCC_APB1_DIV2        RCC_APBCFGR_PPRE1_2                                   /*!< APB1 divided by 2 */
#define RCC_APB1_DIV4        (RCC_APBCFGR_PPRE1_2 | RCC_APBCFGR_PPRE1_0)           /*!< APB1 divided by 4 */
#define RCC_APB1_DIV8        (RCC_APBCFGR_PPRE1_2 | RCC_APBCFGR_PPRE1_1)           /*!< APB1 divided by 8 */
#define RCC_APB1_DIV16       RCC_APBCFGR_PPRE1                                     /*!< APB1 divided by 16 */
#define RCC_APB2_DIV1        0U                                                    /*!< APB2 not divided */
#define RCC_APB2_DIV2        RCC_APBCFGR_PPRE2_2                                   /*!< APB2 divided by 2 */
#define RCC_APB2_DIV4        (RCC_APBCFGR_PPRE2_2 | RCC_APBCFGR_PPRE2_0)           /*!< APB2 divided by 4 */
#define RCC_APB2_DIV8        (RCC_APBCFGR_PPRE2_2 | RCC_APBCFGR_PPRE2_1)           /*!< APB2 divided by 8 */
#define RCC_APB2_DIV16       RCC_APBCFGR_PPRE2                                     /*!< APB2 divided by 16 */
#define RCC_APB4_DIV1        0U                                                    /*!< APB4 not divided */
#define RCC_APB4_DIV2        RCC_APBCFGR_PPRE4_2                                   /*!< APB4 divided by 2 */
#define RCC_APB4_DIV4        (RCC_APBCFGR_PPRE4_2 | RCC_APBCFGR_PPRE4_0)           /*!< APB4 divided by 4 */
#define RCC_APB4_DIV8        (RCC_APBCFGR_PPRE4_2 | RCC_APBCFGR_PPRE4_1)           /*!< APB4 divided by 8 */
#define RCC_APB4_DIV16       RCC_APBCFGR_PPRE4                                     /*!< APB4 divided by 16 */
#define RCC_APB5_DIV1        0U                                                    /*!< APB5 not divided */
#define RCC_APB5_DIV2        RCC_APBCFGR_PPRE5_2                                   /*!< APB5 divided by 2 */
#define RCC_APB5_DIV4        (RCC_APBCFGR_PPRE5_2 | RCC_APBCFGR_PPRE5_0)           /*!< APB5 divided by 4 */
#define RCC_APB5_DIV8        (RCC_APBCFGR_PPRE5_2 | RCC_APBCFGR_PPRE5_1)           /*!< APB5 divided by 8 */
#define RCC_APB5_DIV16       RCC_APBCFGR_PPRE5                                     /*!< APB5 divided by 16 */
#define RCC_MCO_GPIOPORT_POS   16U
#define RCC_MCO_GPIOPORT_MASK  (0xFUL << RCC_MCO_GPIOPORT_POS)
#define RCC_MCO_GPIOAF_POS     20U
#define RCC_MCO_GPIOAF_MASK    (0xFFUL << RCC_MCO_GPIOAF_POS)
#define RCC_MCO_INDEX_POS      28U
#define RCC_MCO_INDEX_MASK     (0x1UL << RCC_MCO_INDEX_POS)
#define RCC_MCO1_INDEX         (0x0UL << RCC_MCO_INDEX_POS)             /*!< MCO1 index */
#define RCC_MCO2_INDEX         (0x1UL << RCC_MCO_INDEX_POS)             /*!< MCO2 index */
#define RCC_MCO1_PA8           (RCC_MCO1_INDEX |\
                                (GPIO_AF0_MCO << RCC_MCO_GPIOAF_POS) | (GPIO_GET_INDEX(GPIOA) << RCC_MCO_GPIOPORT_POS) | GPIO_PIN_8)
#define RCC_MCO2_PC9           (RCC_MCO2_INDEX |\
                                (GPIO_AF0_MCO << RCC_MCO_GPIOAF_POS) | (GPIO_GET_INDEX(GPIOC) << RCC_MCO_GPIOPORT_POS) | GPIO_PIN_9)
#define RCC_MCO1SOURCE_HSI             0U                                        /*!< HSI clock selected as MCO1 source (reset) */
#define RCC_MCO1SOURCE_LSE             RCC_CFGR_MCO1SEL_0                        /*!< LSE clock selected as MCO1 source */
#define RCC_MCO1SOURCE_HSE             RCC_CFGR_MCO1SEL_1                        /*!< HSE clock selected as MCO1 source */
#define RCC_MCO1SOURCE_PLL1Q           (RCC_CFGR_MCO1SEL_1 | RCC_CFGR_MCO1SEL_0) /*!< PLL1Q clock selected as MCO1 source */
#define RCC_MCO1SOURCE_HSI48           RCC_CFGR_MCO1SEL_2                        /*!< HSI48 clock selected as MCO1 source */
#define RCC_MCO2SOURCE_SYSCLK          0U                                        /*!< System clock selected as MCO2 source (reset) */
#define RCC_MCO2SOURCE_PLL2P           RCC_CFGR_MCO2SEL_0                        /*!< PLL2P clock selected as MCO2 source */
#define RCC_MCO2SOURCE_HSE             RCC_CFGR_MCO2SEL_1                        /*!< HSE clock selected as MCO2 source */
#define RCC_MCO2SOURCE_PLL1P           (RCC_CFGR_MCO2SEL_1 | RCC_CFGR_MCO2SEL_0) /*!< PLL1P clock selected as MCO2 source */
#define RCC_MCO2SOURCE_CSI             RCC_CFGR_MCO2SEL_2                        /*!< CSI clock selected as MCO2 source */
#define RCC_MCO2SOURCE_LSI             (RCC_CFGR_MCO2SEL_2 | RCC_CFGR_MCO2SEL_0) /*!< LSI clock selected as MCO2 source */
#define RCC_MCODIV_NONE                0U                                                             /*!< No MCO prescaler (reset) */
#define RCC_MCODIV_1                   RCC_CFGR_MCO1PRE_0                                             /*!< MCO divided by 1 */
#define RCC_MCODIV_2                   RCC_CFGR_MCO1PRE_1                                             /*!< MCO divided by 2 */
#define RCC_MCODIV_3                   (RCC_CFGR_MCO1PRE_1 | RCC_CFGR_MCO1PRE_0)                      /*!< MCO divided by 3 */
#define RCC_MCODIV_4                   RCC_CFGR_MCO1PRE_2                                             /*!< MCO divided by 4 */
#define RCC_MCODIV_5                   (RCC_CFGR_MCO1PRE_2 | RCC_CFGR_MCO1PRE_0)                      /*!< MCO divided by 5 */
#define RCC_MCODIV_6                   (RCC_CFGR_MCO1PRE_2 | RCC_CFGR_MCO1PRE_1)                      /*!< MCO divided by 6 */
#define RCC_MCODIV_7                   (RCC_CFGR_MCO1PRE_2 | RCC_CFGR_MCO1PRE_1 | RCC_CFGR_MCO1PRE_0) /*!< MCO divided by 7 */
#define RCC_MCODIV_8                   RCC_CFGR_MCO1PRE_3                                             /*!< MCO divided by 8 */
#define RCC_MCODIV_9                   (RCC_CFGR_MCO1PRE_3 | RCC_CFGR_MCO1PRE_0)                      /*!< MCO divided by 9 */
#define RCC_MCODIV_10                  (RCC_CFGR_MCO1PRE_3 | RCC_CFGR_MCO1PRE_1)                      /*!< MCO divided by 10 */
#define RCC_MCODIV_11                  (RCC_CFGR_MCO1PRE_3 | RCC_CFGR_MCO1PRE_1 | RCC_CFGR_MCO1PRE_0) /*!< MCO divided by 11 */
#define RCC_MCODIV_12                  (RCC_CFGR_MCO1PRE_3 | RCC_CFGR_MCO1PRE_2)                      /*!< MCO divided by 12 */
#define RCC_MCODIV_13                  (RCC_CFGR_MCO1PRE_3 | RCC_CFGR_MCO1PRE_2 | RCC_CFGR_MCO1PRE_0) /*!< MCO divided by 13 */
#define RCC_MCODIV_14                  (RCC_CFGR_MCO1PRE_3 | RCC_CFGR_MCO1PRE_2 | RCC_CFGR_MCO1PRE_1) /*!< MCO divided by 14 */
#define RCC_MCODIV_15                  RCC_CFGR_MCO1PRE                                               /*!< MCO divided by 15 */
#define RCC_IT_HSECSS                  RCC_CIFR_HSECSSF    /*!< HSE Clock Security System Interrupt (flag only) */
#define RCC_RESET_FLAG_OBL              RCC_RSR_OBLRSTF    /*!< Option Byte Loader reset flag */
#define RCC_RESET_FLAG_PIN              RCC_RSR_PINRSTF    /*!< PIN reset flag */
#define RCC_RESET_FLAG_PWR              RCC_RSR_BORRSTF    /*!< BOR or POR/PDR reset flag */
#define RCC_RESET_FLAG_SW               RCC_RSR_SFTRSTF    /*!< Software Reset flag */
#define RCC_RESET_FLAG_IWDG             RCC_RSR_IWDGRSTF   /*!< Independent Watchdog reset flag */
#define RCC_RESET_FLAG_WWDG             RCC_RSR_WWDGRSTF   /*!< Window watchdog reset flag */
#define RCC_RESET_FLAG_LPWR             RCC_RSR_LPWRRSTF   /*!< Low power reset flag */
#define RCC_RESET_FLAG_ALL              (RCC_RESET_FLAG_OBL | RCC_RESET_FLAG_PIN | RCC_RESET_FLAG_PWR | \
                                         RCC_RESET_FLAG_SW | RCC_RESET_FLAG_IWDG | RCC_RESET_FLAG_WWDG | \
                                         RCC_RESET_FLAG_LPWR)
#define __HAL_RCC_HSI_CONFIG(__STATE__) \
  MODIFY_REG(RCC->CR, RCC_CR_HSION | RCC_CR_HSIDIV , (uint32_t)(__STATE__))
#define __HAL_RCC_GET_HSI_DIVIDER() ((uint32_t)(READ_BIT(RCC->CR, RCC_CR_HSIDIV)))
#define __HAL_RCC_HSI_DISABLE() CLEAR_BIT(RCC->CR, RCC_CR_HSION)
#define __HAL_RCC_HSI_CALIBRATIONVALUE_ADJUST(__HSICALIBRATIONVALUE__) \
  MODIFY_REG(RCC->HSICFGR, RCC_HSICFGR_HSITRIM, (uint32_t)(__HSICALIBRATIONVALUE__) << RCC_HSICFGR_HSITRIM_Pos);
#define __HAL_RCC_CSI_ENABLE()  SET_BIT(RCC->CR, RCC_CR_CSION)
#define __HAL_RCC_CSI_DISABLE() CLEAR_BIT(RCC->CR, RCC_CR_CSION)
#define __HAL_RCC_HSI48_ENABLE()    SET_BIT(RCC->CR, RCC_CR_HSI48ON);
#define __HAL_RCC_HSI48_DISABLE()   CLEAR_BIT(RCC->CR, RCC_CR_HSI48ON);
#define __HAL_RCC_LSI_ENABLE()         SET_BIT(RCC->CSR, RCC_CSR_LSION)
#define __HAL_RCC_LSI_DISABLE()        CLEAR_BIT(RCC->CSR, RCC_CSR_LSION)
#define __HAL_RCC_HSE_CONFIG(__STATE__)                                \
  do {                                               \
    if ((__STATE__) == RCC_HSE_ON)                   \
    {                                                \
      SET_BIT(RCC->CR, RCC_CR_HSEON);                \
    }                                                \
    else if ((__STATE__) == RCC_HSE_OFF)             \
    {                                                \
      CLEAR_BIT(RCC->CR, RCC_CR_HSEON);              \
      CLEAR_BIT(RCC->CR, RCC_CR_HSEEXT);             \
      CLEAR_BIT(RCC->CR, RCC_CR_HSEBYP);             \
    }                                                \
    else if ((__STATE__) == RCC_HSE_BYPASS)          \
    {                                                \
      SET_BIT(RCC->CR, RCC_CR_HSEBYP);               \
      CLEAR_BIT(RCC->CR, RCC_CR_HSEEXT);             \
      SET_BIT(RCC->CR, RCC_CR_HSEON);                \
    }                                                \
    else if((__STATE__) == RCC_HSE_BYPASS_DIGITAL)   \
    {                                                \
      SET_BIT(RCC->CR, RCC_CR_HSEBYP);               \
      SET_BIT(RCC->CR, RCC_CR_HSEEXT);               \
      SET_BIT(RCC->CR, RCC_CR_HSEON);                \
    }                                                \
    else                                             \
    {                                                \
      CLEAR_BIT(RCC->CR, RCC_CR_HSEON);              \
      CLEAR_BIT(RCC->CR, RCC_CR_HSEBYP);             \
      CLEAR_BIT(RCC->CR, RCC_CR_HSEEXT);             \
    }                                                \
  } while(0)
#define __HAL_RCC_LSE_CONFIG(__STATE__) \
  do {                                               \
    if((__STATE__) == RCC_LSE_ON)                    \
    {                                                \
      SET_BIT(RCC->BDCR, RCC_BDCR_LSEON);            \
    }                                                \
    else if((__STATE__) == RCC_LSE_OFF)              \
    {                                                \
      CLEAR_BIT(RCC->BDCR, RCC_BDCR_LSEON);          \
      CLEAR_BIT(RCC->BDCR, RCC_BDCR_LSEEXT);         \
      CLEAR_BIT(RCC->BDCR, RCC_BDCR_LSEBYP);         \
    }                                                \
    else if((__STATE__) == RCC_LSE_BYPASS)           \
    {                                                \
      SET_BIT(RCC->BDCR, RCC_BDCR_LSEBYP);           \
      CLEAR_BIT(RCC->BDCR, RCC_BDCR_LSEEXT);         \
      SET_BIT(RCC->BDCR, RCC_BDCR_LSEON);            \
    }                                                \
    else if((__STATE__) == RCC_LSE_BYPASS_DIGITAL)   \
    {                                                \
      SET_BIT(RCC->BDCR, RCC_BDCR_LSEBYP);           \
      SET_BIT(RCC->BDCR, RCC_BDCR_LSEEXT);           \
      SET_BIT(RCC->BDCR, RCC_BDCR_LSEON);            \
    }                                                \
    else                                             \
    {                                                \
      CLEAR_BIT(RCC->BDCR, RCC_BDCR_LSEON);          \
      CLEAR_BIT(RCC->BDCR, RCC_BDCR_LSEBYP);         \
      CLEAR_BIT(RCC->BDCR, RCC_BDCR_LSEEXT);         \
    }                                                \
  } while(0)
#define __HAL_RCC_GET_PLL_OSCSOURCE() \
  READ_BIT(RCC->PLLCKSELR, RCC_PLLCKSELR_PLLSRC)
#define __HAL_RCC_PLL1_FRACN_ENABLE()   SET_BIT(RCC->PLLCFGR, RCC_PLLCFGR_PLL1FRACEN)
#define __HAL_RCC_PLL1_FRACN_DISABLE()  CLEAR_BIT(RCC->PLLCFGR, RCC_PLLCFGR_PLL1FRACEN)
#define  __HAL_RCC_PLL1_FRACN_CONFIG(__PLL1FRACN__) \
  MODIFY_REG(RCC->PLL1FRACR, RCC_PLL1FRACR_FRACN, (uint32_t)(__PLL1FRACN__) << RCC_PLL1FRACR_FRACN_Pos)
#define __HAL_RCC_GET_SYSCLK_SOURCE() \
  READ_BIT(RCC->CFGR, RCC_CFGR_SWS)
#define __HAL_RCC_CLEAR_IT(__INTERRUPT__) WRITE_REG(RCC->CICR, (__INTERRUPT__))
#define __HAL_RCC_GET_IT(__INTERRUPT__) (READ_BIT(RCC->CIFR, (__INTERRUPT__)) == (__INTERRUPT__))
#define RCC_PLL_VCOINPUTFREQ_MAX            16000000U /* Maximum VCO input frequency is 16 MHz */
#define RCC_PLL_VCOINPUTFREQ_MIN             1000000U /* Minimum VCO input frequency is 1 MHz */
#define RCC_PLL_TIMEOUT_VALUE         (50U)    /* 50 ms */
#define RCC_LSE_TIMEOUT_VALUE         LSE_STARTUP_TIMEOUT
#define IS_RCC_OSCILLATORTYPE(__OSCILLATOR__) (((__OSCILLATOR__) == RCC_OSCILLATORTYPE_NONE)                           || \
                                               (((__OSCILLATOR__) & RCC_OSCILLATORTYPE_HSE) == RCC_OSCILLATORTYPE_HSE) || \
                                               (((__OSCILLATOR__) & RCC_OSCILLATORTYPE_HSI) == RCC_OSCILLATORTYPE_HSI) || \
                                               (((__OSCILLATOR__) & RCC_OSCILLATORTYPE_CSI) == RCC_OSCILLATORTYPE_CSI) || \
                                               (((__OSCILLATOR__) & RCC_OSCILLATORTYPE_LSI) == RCC_OSCILLATORTYPE_LSI) || \
                                               (((__OSCILLATOR__) & RCC_OSCILLATORTYPE_LSE) == RCC_OSCILLATORTYPE_LSE) || \
                                               (((__OSCILLATOR__) & RCC_OSCILLATORTYPE_HSI48) == RCC_OSCILLATORTYPE_HSI48))
#define IS_RCC_HSE(__HSE__) (((__HSE__) == RCC_HSE_OFF)    || ((__HSE__) == RCC_HSE_ON) || \
                             ((__HSE__) == RCC_HSE_BYPASS) || ((__HSE__) == RCC_HSE_BYPASS_DIGITAL))
#define IS_RCC_LSE(__LSE__) (((__LSE__) == RCC_LSE_OFF)    || ((__LSE__) == RCC_LSE_ON) || \
                             ((__LSE__) == RCC_LSE_BYPASS) || ((__LSE__) == RCC_LSE_BYPASS_DIGITAL))
#define IS_RCC_HSI(__HSI__) (((__HSI__) == RCC_HSI_OFF)    || ((__HSI__) == RCC_HSI_ON))
#define IS_RCC_HSIDIV(__HSIDIV__) (((__HSIDIV__) == RCC_HSI_DIV1) || ((__HSIDIV__) == RCC_HSI_DIV2) || \
                                   ((__HSIDIV__) == RCC_HSI_DIV4) || ((__HSIDIV__) == RCC_HSI_DIV8))
#define IS_RCC_HSI48(__HSI48__) (((__HSI48__) == RCC_HSI48_OFF) || ((__HSI48__) == RCC_HSI48_ON))
#define IS_RCC_LSI(__LSI__) (((__LSI__) == RCC_LSI_OFF) || ((__LSI__) == RCC_LSI_ON))
#define IS_RCC_CSI(__CSI__) (((__CSI__) == RCC_CSI_OFF) || ((__CSI__) == RCC_CSI_ON))
#define IS_RCC_PLL(__PLL__) (((__PLL__) == RCC_PLL_NONE) || ((__PLL__) == RCC_PLL_OFF) || \
                             ((__PLL__) == RCC_PLL_ON))
#define IS_RCC_PLLSOURCE(__SOURCE__) (((__SOURCE__) == RCC_PLLSOURCE_HSI) || \
                                      ((__SOURCE__) == RCC_PLLSOURCE_CSI) || \
                                      ((__SOURCE__) == RCC_PLLSOURCE_HSE))
#define IS_RCC_PLLM_VALUE(__VALUE__) ((1U <= (__VALUE__)) && ((__VALUE__) <= 63U))
#define IS_RCC_PLLN_VALUE(__VALUE__) ((8U <= (__VALUE__)) && ((__VALUE__) <= 420U))
#define IS_RCC_PLLP_VALUE(__VALUE__) ((1U <= (__VALUE__)) && ((__VALUE__) <= 128U))
#define IS_RCC_PLLQ_VALUE(__VALUE__) ((1U <= (__VALUE__)) && ((__VALUE__) <= 128U))
#define IS_RCC_PLLR_VALUE(__VALUE__) ((1U <= (__VALUE__)) && ((__VALUE__) <= 128U))
#define IS_RCC_PLLS_VALUE(__VALUE__) ((1U <= (__VALUE__)) && ((__VALUE__) <= 8U))
#define IS_RCC_PLLT_VALUE(__VALUE__) ((1U <= (__VALUE__)) && ((__VALUE__) <= 8U))
#define IS_RCC_PLL_VCOINPUTFREQ(__VALUE__)  ((RCC_PLL_VCOINPUTFREQ_MIN <= (__VALUE__)) &&\
                                             ((__VALUE__) <= RCC_PLL_VCOINPUTFREQ_MAX))
#define IS_RCC_PLLFRACN_VALUE(__VALUE__) ((__VALUE__) <= 8191U)
#define IS_RCC_CLOCKTYPE(__CLK__) ((1U <= (__CLK__)) && ((__CLK__) <= 63U))
#define IS_RCC_SYSCLKSOURCE(__SOURCE__) (((__SOURCE__) == RCC_SYSCLKSOURCE_HSI) || \
                                         ((__SOURCE__) == RCC_SYSCLKSOURCE_CSI) || \
                                         ((__SOURCE__) == RCC_SYSCLKSOURCE_HSE) || \
                                         ((__SOURCE__) == RCC_SYSCLKSOURCE_PLLCLK))
#define IS_RCC_SYSCLK(__SYSCLK__) (((__SYSCLK__) == RCC_SYSCLK_DIV1)   || ((__SYSCLK__) == RCC_SYSCLK_DIV2)   || \
                                   ((__SYSCLK__) == RCC_SYSCLK_DIV4)   || ((__SYSCLK__) == RCC_SYSCLK_DIV8)   || \
                                   ((__SYSCLK__) == RCC_SYSCLK_DIV16)  || ((__SYSCLK__) == RCC_SYSCLK_DIV64)  || \
                                   ((__SYSCLK__) == RCC_SYSCLK_DIV128) || ((__SYSCLK__) == RCC_SYSCLK_DIV256) || \
                                   ((__SYSCLK__) == RCC_SYSCLK_DIV512))
#define IS_RCC_HCLK(__HCLK__) (((__HCLK__) == RCC_HCLK_DIV1)   || ((__HCLK__) == RCC_HCLK_DIV2)   || \
                               ((__HCLK__) == RCC_HCLK_DIV4)   || ((__HCLK__) == RCC_HCLK_DIV8)   || \
                               ((__HCLK__) == RCC_HCLK_DIV16)  || ((__HCLK__) == RCC_HCLK_DIV64)  || \
                               ((__HCLK__) == RCC_HCLK_DIV128) || ((__HCLK__) == RCC_HCLK_DIV256) || \
                               ((__HCLK__) == RCC_HCLK_DIV512))
#define IS_RCC_PCLK1(__PCLK1__) (((__PCLK1__) == RCC_APB1_DIV1) || ((__PCLK1__) == RCC_APB1_DIV2) || \
                                 ((__PCLK1__) == RCC_APB1_DIV4) || ((__PCLK1__) == RCC_APB1_DIV8) || \
                                 ((__PCLK1__) == RCC_APB1_DIV16))
#define IS_RCC_PCLK2(__PCLK2__) (((__PCLK2__) == RCC_APB2_DIV1) || ((__PCLK2__) == RCC_APB2_DIV2) || \
                                 ((__PCLK2__) == RCC_APB2_DIV4) || ((__PCLK2__) == RCC_APB2_DIV8) || \
                                 ((__PCLK2__) == RCC_APB2_DIV16))
#define IS_RCC_PCLK4(__PCLK4__) (((__PCLK4__) == RCC_APB4_DIV1) || ((__PCLK4__) == RCC_APB4_DIV2) || \
                                 ((__PCLK4__) == RCC_APB4_DIV4) || ((__PCLK4__) == RCC_APB4_DIV8) || \
                                 ((__PCLK4__) == RCC_APB4_DIV16))
#define IS_RCC_PCLK5(__PCLK5__) (((__PCLK5__) == RCC_APB5_DIV1) || ((__PCLK5__) == RCC_APB5_DIV2) || \
                                 ((__PCLK5__) == RCC_APB5_DIV4) || ((__PCLK5__) == RCC_APB5_DIV8) || \
                                 ((__PCLK5__) == RCC_APB5_DIV16))
#define IS_RCC_MCO(__MCOX__) (((__MCOX__) == RCC_MCO1_PA8) || \
                              ((__MCOX__) == RCC_MCO2_PC9))
#define IS_RCC_MCO1SOURCE(__SOURCE__) (((__SOURCE__) == RCC_MCO1SOURCE_HSI) || ((__SOURCE__) == RCC_MCO1SOURCE_LSE)   || \
                                       ((__SOURCE__) == RCC_MCO1SOURCE_HSE) || ((__SOURCE__) == RCC_MCO1SOURCE_PLL1Q) || \
                                       ((__SOURCE__) == RCC_MCO1SOURCE_HSI48))
#define IS_RCC_MCO2SOURCE(__SOURCE__) (((__SOURCE__) == RCC_MCO2SOURCE_SYSCLK) || ((__SOURCE__) == RCC_MCO2SOURCE_PLL2P) || \
                                       ((__SOURCE__) == RCC_MCO2SOURCE_HSE)    || ((__SOURCE__) == RCC_MCO2SOURCE_PLL1P) || \
                                       ((__SOURCE__) == RCC_MCO2SOURCE_CSI)    || ((__SOURCE__) == RCC_MCO2SOURCE_LSI))
#define IS_RCC_MCODIV(__DIV__) (((__DIV__) == RCC_MCODIV_NONE) || ((__DIV__) == RCC_MCODIV_1)  || \
                                ((__DIV__) == RCC_MCODIV_2)    || ((__DIV__) == RCC_MCODIV_3)  || \
                                ((__DIV__) == RCC_MCODIV_4)    || ((__DIV__) == RCC_MCODIV_5)  || \
                                ((__DIV__) == RCC_MCODIV_6)    || ((__DIV__) == RCC_MCODIV_7)  || \
                                ((__DIV__) == RCC_MCODIV_8)    || ((__DIV__) == RCC_MCODIV_9)  || \
                                ((__DIV__) == RCC_MCODIV_10)   || ((__DIV__) == RCC_MCODIV_11) || \
                                ((__DIV__) == RCC_MCODIV_12)   || ((__DIV__) == RCC_MCODIV_13) || \
                                ((__DIV__) == RCC_MCODIV_14)   || ((__DIV__) == RCC_MCODIV_15))
#define IS_RCC_HSICALIBRATION_VALUE(__VALUE__) ((__VALUE__) <= 0x7FU)
#define GPIO_PIN_8                      ((uint16_t)0x0100)  /* Pin 8 selected    */
#define GPIO_PIN_9                      ((uint16_t)0x0200)  /* Pin 9 selected    */
#define GPIO_PIN_MASK                   (0x0000FFFFu) /* PIN mask for assert test */
#define GPIO_MODE_AF_PP                 (MODE_AF | OUTPUT_PP)                                       /*!< Alternate Function Push Pull Mode                                  */
#define GPIO_SPEED_FREQ_VERY_HIGH       0x00000003U  /*!< Very high speed */
#define GPIO_NOPULL                     0x00000000U   /*!< No Pull-up or Pull-down activation  */
#define GPIO_MODE_Pos                           0U
#define MODE_AF                                 (0x2UL << GPIO_MODE_Pos)
#define OUTPUT_TYPE_Pos                         4U
#define OUTPUT_PP                               (0x0UL << OUTPUT_TYPE_Pos)
#define FLASH_LATENCY_0        0U                                                                                       /*!< FLASH Zero wait state      */
#define FLASH_LATENCY_1        FLASH_ACR_LATENCY_0                                                                      /*!< FLASH One wait state       */
#define FLASH_LATENCY_2        (FLASH_ACR_LATENCY_1 | FLASH_ACR_WRHIGHFREQ_0)                                           /*!< FLASH Two wait states      */
#define FLASH_LATENCY_3        (FLASH_ACR_LATENCY_1 | FLASH_ACR_LATENCY_0 | FLASH_ACR_WRHIGHFREQ_0)                     /*!< FLASH Three wait states    */
#define FLASH_LATENCY_4        (FLASH_ACR_LATENCY_2 | FLASH_ACR_WRHIGHFREQ_1)                                           /*!< FLASH Four wait states     */
#define FLASH_LATENCY_5        (FLASH_ACR_LATENCY_2 | FLASH_ACR_LATENCY_0 | FLASH_ACR_WRHIGHFREQ_1)                     /*!< FLASH Five wait states     */
#define FLASH_LATENCY_6        (FLASH_ACR_LATENCY_2 | FLASH_ACR_LATENCY_1 | FLASH_ACR_WRHIGHFREQ)                       /*!< FLASH Six wait state       */
#define FLASH_LATENCY_7        (FLASH_ACR_LATENCY_2 | FLASH_ACR_LATENCY_1 | FLASH_ACR_LATENCY_0 | FLASH_ACR_WRHIGHFREQ) /*!< FLASH Seven wait states    */
#define __HAL_FLASH_SET_LATENCY(__LATENCY__) MODIFY_REG(FLASH->ACR, (FLASH_ACR_LATENCY |\
                                                                     FLASH_ACR_WRHIGHFREQ), (__LATENCY__))
#define __HAL_FLASH_GET_LATENCY() READ_BIT(FLASH->ACR, (FLASH_ACR_LATENCY | FLASH_ACR_WRHIGHFREQ))
#define IS_FLASH_LATENCY(LATENCY)          (((LATENCY) == FLASH_LATENCY_0)  || ((LATENCY) == FLASH_LATENCY_1) || \
                                            ((LATENCY) == FLASH_LATENCY_2)  || ((LATENCY) == FLASH_LATENCY_3) || \
                                            ((LATENCY) == FLASH_LATENCY_4)  || ((LATENCY) == FLASH_LATENCY_5) || \
                                            ((LATENCY) == FLASH_LATENCY_6)  || ((LATENCY) == FLASH_LATENCY_7))
#define HAL_GPIO_MODULE_ENABLED
#define HSE_STARTUP_TIMEOUT 100UL   /*!< Time out for HSE start up (in ms) */
#define LSE_STARTUP_TIMEOUT 5000UL    /*!< Time out for LSE start up (in ms) */
#define assert_param(expr) ((void)0U)
#define RCC_CSI_TIMEOUT_VALUE         1U        /* 1 ms */
#define RCC_HSI_TIMEOUT_VALUE         1U        /* 1 ms */
#define RCC_HSI48_TIMEOUT_VALUE       1U        /* 1 ms */
#define RCC_HSE_TIMEOUT_VALUE         HSE_STARTUP_TIMEOUT
#define RCC_LSI_TIMEOUT_VALUE         1U        /* 1 ms */
#define RCC_CLOCKSWITCH_TIMEOUT_VALUE 5000U     /* 5 s  */
#define RCC_PLL_FRAC_WAIT_VALUE       1U        /* PLL Fractional part waiting time before new latch enable : 1 ms */
#define RCC_PLL_INPUTRANGE0_FREQMAX   2000000U  /* 2 MHz is maximum frequency for VCO input range 0 */
#define RCC_PLL_INPUTRANGE1_FREQMAX   4000000U  /* 4 MHz is maximum frequency for VCO input range 1 */
#define RCC_PLL_INPUTRANGE2_FREQMAX   8000000U  /* 8 MHz is maximum frequency for VCO input range 2 */
#define RCC_PLL1_CONFIG               0U
#define RCC_PLL2_CONFIG               1U
#define RCC_PLL3_CONFIG               2U
#define RCC_GET_MCO_GPIO_PIN(__RCC_MCOx__)   ((__RCC_MCOx__) & GPIO_PIN_MASK)
#define RCC_GET_MCO_GPIO_AF(__RCC_MCOx__)    (((__RCC_MCOx__) & RCC_MCO_GPIOAF_MASK) >> RCC_MCO_GPIOAF_POS)
#define RCC_GET_MCO_GPIO_INDEX(__RCC_MCOx__) (((__RCC_MCOx__) & RCC_MCO_GPIOPORT_MASK) >> RCC_MCO_GPIOPORT_POS)
#define RCC_GET_MCO_GPIO_PORT(__RCC_MCOx__)  (GPIOA_BASE + ((0x00000400UL) * RCC_GET_MCO_GPIO_INDEX((__RCC_MCOx__))))
#define GPIO_AF0_MCO                        ((uint8_t)0x00)  /*!< MCO (MCO1 and MCO2) Alternate Function mapping */
#define GPIO_GET_INDEX(__GPIOx__)           (((uint32_t )(__GPIOx__) & (~GPIOA_BASE)) >> 10)
