/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Unchanged declarations/functions/macros from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748. Host bindings are in the shim.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */

#define IS_RCC_ADCCLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_ADCCLKSOURCE_PLL2P) || \
   ((__SOURCE__) == RCC_ADCCLKSOURCE_PLL3R) || \
   ((__SOURCE__) == RCC_ADCCLKSOURCE_CLKP))
#define IS_RCC_ADF1CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_ADF1CLKSOURCE_HCLK)  || \
   ((__SOURCE__) == RCC_ADF1CLKSOURCE_PLL2P) || \
   ((__SOURCE__) == RCC_ADF1CLKSOURCE_PLL3P) || \
   ((__SOURCE__) == RCC_ADF1CLKSOURCE_PIN)   || \
   ((__SOURCE__) == RCC_ADF1CLKSOURCE_CSI)   || \
   ((__SOURCE__) == RCC_ADF1CLKSOURCE_HSI))
#define IS_RCC_CECCLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_CECCLKSOURCE_LSE) || \
   ((__SOURCE__) == RCC_CECCLKSOURCE_LSI) || \
   ((__SOURCE__) == RCC_CECCLKSOURCE_CSI))
#define IS_RCC_CKPERCLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_CLKPSOURCE_HSI) || \
   ((__SOURCE__) == RCC_CLKPSOURCE_CSI) || \
   ((__SOURCE__) == RCC_CLKPSOURCE_HSE))
#define IS_RCC_CLOCKPROTECTION(__CLOCK__) \
  ((((__CLOCK__) & RCC_CLOCKPROTECT_FMC) == RCC_CLOCKPROTECT_FMC) || \
   (((__CLOCK__) & RCC_CLOCKPROTECT_XSPI) == RCC_CLOCKPROTECT_XSPI) || \
   (((__CLOCK__) & ~(RCC_CLOCKPROTECT_FMC | RCC_CLOCKPROTECT_XSPI)) == 0U))
#define IS_RCC_CRS_ERRORLIMIT(__VALUE__)   ((__VALUE__) <= (CRS_CFGR_FELIM >> CRS_CFGR_FELIM_Pos))
#define IS_RCC_CRS_HSI48CALIBRATION(__VALUE__) ((__VALUE__) <= (CRS_CR_TRIM >> CRS_CR_TRIM_Pos))
#define IS_RCC_CRS_RELOADVALUE(__VALUE__)  ((__VALUE__) <= CRS_CFGR_RELOAD)
#define IS_RCC_CRS_SYNC_DIV(__DIV__)       (((__DIV__) == RCC_CRS_SYNC_DIV1)  || ((__DIV__) == RCC_CRS_SYNC_DIV2)  || \
                                            ((__DIV__) == RCC_CRS_SYNC_DIV4)  || ((__DIV__) == RCC_CRS_SYNC_DIV8)  || \
                                            ((__DIV__) == RCC_CRS_SYNC_DIV16) || ((__DIV__) == RCC_CRS_SYNC_DIV32) || \
                                            ((__DIV__) == RCC_CRS_SYNC_DIV64) || ((__DIV__) == RCC_CRS_SYNC_DIV128))
#define IS_RCC_CRS_SYNC_POLARITY(__POLARITY__) (((__POLARITY__) == RCC_CRS_SYNC_POLARITY_RISING) || \
                                                ((__POLARITY__) == RCC_CRS_SYNC_POLARITY_FALLING))
#define IS_RCC_CRS_SYNC_SOURCE(__SOURCE__) (((__SOURCE__) == RCC_CRS_SYNC_SOURCE_LSE)  || \
                                            ((__SOURCE__) == RCC_CRS_SYNC_SOURCE_USB_OTG_FS) || \
                                            ((__SOURCE__) == RCC_CRS_SYNC_SOURCE_USB_OTG_HS) || \
                                            ((__SOURCE__) == RCC_CRS_SYNC_SOURCE_GPIO))
#define IS_RCC_ETH1PHYCLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_ETH1PHYCLKSOURCE_HSE) || \
   ((__SOURCE__) == RCC_ETH1PHYCLKSOURCE_PLL3S))
#define IS_RCC_ETH1REFCLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_ETH1REFCLKSOURCE_PHY) || \
   ((__SOURCE__) == RCC_ETH1REFCLKSOURCE_HSE) || \
   ((__SOURCE__) == RCC_ETH1REFCLKSOURCE_ETH))
#define IS_RCC_FDCANCLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_FDCANCLKSOURCE_HSE)   || \
   ((__SOURCE__) == RCC_FDCANCLKSOURCE_PLL1Q) || \
   ((__SOURCE__) == RCC_FDCANCLKSOURCE_PLL2P))
#define IS_RCC_FMCCLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_FMCCLKSOURCE_HCLK)  || \
   ((__SOURCE__) == RCC_FMCCLKSOURCE_PLL1Q) || \
   ((__SOURCE__) == RCC_FMCCLKSOURCE_PLL2R) || \
   ((__SOURCE__) == RCC_FMCCLKSOURCE_HSI))
#define IS_RCC_I2C1_I3C1CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_I2C1_I3C1CLKSOURCE_PCLK1) || \
   ((__SOURCE__) == RCC_I2C1_I3C1CLKSOURCE_PLL3R) || \
   ((__SOURCE__) == RCC_I2C1_I3C1CLKSOURCE_HSI)   || \
   ((__SOURCE__) == RCC_I2C1_I3C1CLKSOURCE_CSI))
#define IS_RCC_I2C23CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_I2C23CLKSOURCE_PCLK1) || \
   ((__SOURCE__) == RCC_I2C23CLKSOURCE_PLL3R) || \
   ((__SOURCE__) == RCC_I2C23CLKSOURCE_HSI)   || \
   ((__SOURCE__) == RCC_I2C23CLKSOURCE_CSI))
#define IS_RCC_LPTIM1CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_LPTIM1CLKSOURCE_PCLK1) || \
   ((__SOURCE__) == RCC_LPTIM1CLKSOURCE_PLL2P) || \
   ((__SOURCE__) == RCC_LPTIM1CLKSOURCE_PLL3R) || \
   ((__SOURCE__) == RCC_LPTIM1CLKSOURCE_LSE)   || \
   ((__SOURCE__) == RCC_LPTIM1CLKSOURCE_LSI)   || \
   ((__SOURCE__) == RCC_LPTIM1CLKSOURCE_CLKP))
#define IS_RCC_LPUART1CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_LPUART1CLKSOURCE_PCLK4) || \
   ((__SOURCE__) == RCC_LPUART1CLKSOURCE_PLL2Q) || \
   ((__SOURCE__) == RCC_LPUART1CLKSOURCE_PLL3Q) || \
   ((__SOURCE__) == RCC_LPUART1CLKSOURCE_HSI)   || \
   ((__SOURCE__) == RCC_LPUART1CLKSOURCE_CSI)   || \
   ((__SOURCE__) == RCC_LPUART1CLKSOURCE_LSE))
#define IS_RCC_PERIPHCLOCK(__SELECTION__)  \
  ((((__SELECTION__) & RCC_PERIPHCLK_FMC)         == RCC_PERIPHCLK_FMC)         || \
   (((__SELECTION__) & RCC_PERIPHCLK_XSPI1)       == RCC_PERIPHCLK_XSPI1)       || \
   (((__SELECTION__) & RCC_PERIPHCLK_XSPI2)       == RCC_PERIPHCLK_XSPI2)       || \
   (((__SELECTION__) & RCC_PERIPHCLK_CKPER)       == RCC_PERIPHCLK_CKPER)       || \
   (((__SELECTION__) & RCC_PERIPHCLK_ADC)         == RCC_PERIPHCLK_ADC)         || \
   (((__SELECTION__) & RCC_PERIPHCLK_ADF1)        == RCC_PERIPHCLK_ADF1)        || \
   (((__SELECTION__) & RCC_PERIPHCLK_CEC)         == RCC_PERIPHCLK_CEC)         || \
   (((__SELECTION__) & RCC_PERIPHCLK_ETH1REF)     == RCC_PERIPHCLK_ETH1REF)     || \
   (((__SELECTION__) & RCC_PERIPHCLK_ETH1PHY)     == RCC_PERIPHCLK_ETH1PHY)     || \
   (((__SELECTION__) & RCC_PERIPHCLK_FDCAN)       == RCC_PERIPHCLK_FDCAN)       || \
   (((__SELECTION__) & RCC_PERIPHCLK_I2C1_I3C1)   == RCC_PERIPHCLK_I2C1_I3C1)   || \
   (((__SELECTION__) & RCC_PERIPHCLK_I2C23)       == RCC_PERIPHCLK_I2C23)       || \
   (((__SELECTION__) & RCC_PERIPHCLK_LPTIM1)      == RCC_PERIPHCLK_LPTIM1)      || \
   (((__SELECTION__) & RCC_PERIPHCLK_LPTIM23)     == RCC_PERIPHCLK_LPTIM23)     || \
   (((__SELECTION__) & RCC_PERIPHCLK_LPTIM45)     == RCC_PERIPHCLK_LPTIM45)     || \
   (((__SELECTION__) & RCC_PERIPHCLK_LPUART1)     == RCC_PERIPHCLK_LPUART1)     || \
   (((__SELECTION__) & RCC_PERIPHCLK_LTDC)        == RCC_PERIPHCLK_LTDC)        || \
   (((__SELECTION__) & RCC_PERIPHCLK_PSSI)        == RCC_PERIPHCLK_PSSI)        || \
   (((__SELECTION__) & RCC_PERIPHCLK_RTC)         == RCC_PERIPHCLK_RTC)         || \
   (((__SELECTION__) & RCC_PERIPHCLK_SAI1)        == RCC_PERIPHCLK_SAI1)        || \
   (((__SELECTION__) & RCC_PERIPHCLK_SAI2)        == RCC_PERIPHCLK_SAI2)        || \
   (((__SELECTION__) & RCC_PERIPHCLK_SDMMC12)     == RCC_PERIPHCLK_SDMMC12)     || \
   (((__SELECTION__) & RCC_PERIPHCLK_SPDIFRX)     == RCC_PERIPHCLK_SPDIFRX)     || \
   (((__SELECTION__) & RCC_PERIPHCLK_SPI1)        == RCC_PERIPHCLK_SPI1)        || \
   (((__SELECTION__) & RCC_PERIPHCLK_SPI23)       == RCC_PERIPHCLK_SPI23)       || \
   (((__SELECTION__) & RCC_PERIPHCLK_SPI45)       == RCC_PERIPHCLK_SPI45)       || \
   (((__SELECTION__) & RCC_PERIPHCLK_SPI6)        == RCC_PERIPHCLK_SPI6)        || \
   (((__SELECTION__) & RCC_PERIPHCLK_TIM)         == RCC_PERIPHCLK_TIM)         || \
   (((__SELECTION__) & RCC_PERIPHCLK_USART1)      == RCC_PERIPHCLK_USART1)      || \
   (((__SELECTION__) & RCC_PERIPHCLK_USART234578) == RCC_PERIPHCLK_USART234578) || \
   (((__SELECTION__) & RCC_PERIPHCLK_USBPHYC)     == RCC_PERIPHCLK_USBPHYC)     || \
   (((__SELECTION__) & RCC_PERIPHCLK_USBOTGFS)    == RCC_PERIPHCLK_USBOTGFS)    || \
   (((__SELECTION__) & RCC_PERIPHCLK_USBREF)      == RCC_PERIPHCLK_USBREF))
#define IS_RCC_PSSICLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_PSSICLKSOURCE_PLL3R) || \
   ((__SOURCE__) == RCC_PSSICLKSOURCE_CLKP))
#define IS_RCC_RTCCLKSOURCE(__SOURCE__) (((__SOURCE__) == RCC_RTCCLKSOURCE_LSE)       || ((__SOURCE__) == RCC_RTCCLKSOURCE_LSI)       || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV2)  || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV3)  || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV4)  || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV5)  || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV6)  || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV7)  || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV8)  || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV9)  || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV10) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV11) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV12) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV13) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV14) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV15) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV16) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV17) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV18) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV19) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV20) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV21) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV22) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV23) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV24) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV25) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV26) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV27) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV28) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV29) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV30) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV31) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV32) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV33) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV34) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV35) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV36) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV37) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV38) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV39) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV40) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV41) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV42) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV43) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV44) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV45) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV46) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV47) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV48) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV49) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV50) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV51) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV52) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV53) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV54) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV55) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV56) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV57) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV58) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV59) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV60) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV61) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV62) || ((__SOURCE__) == RCC_RTCCLKSOURCE_HSE_DIV63) || \
                                         ((__SOURCE__) == RCC_RTCCLKSOURCE_DISABLE))
#define IS_RCC_SAI1CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_SAI1CLKSOURCE_PLL1Q) || \
   ((__SOURCE__) == RCC_SAI1CLKSOURCE_PLL2P) || \
   ((__SOURCE__) == RCC_SAI1CLKSOURCE_PLL3P) || \
   ((__SOURCE__) == RCC_SAI1CLKSOURCE_CLKP)  || \
   ((__SOURCE__) == RCC_SAI1CLKSOURCE_PIN))
#define IS_RCC_SAI2CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_SAI2CLKSOURCE_PLL1Q) || \
   ((__SOURCE__) == RCC_SAI2CLKSOURCE_PLL2P) || \
   ((__SOURCE__) == RCC_SAI2CLKSOURCE_PLL3P) || \
   ((__SOURCE__) == RCC_SAI2CLKSOURCE_CLKP)  || \
   ((__SOURCE__) == RCC_SAI2CLKSOURCE_PIN)   || \
   ((__SOURCE__) == RCC_SAI2CLKSOURCE_SPDIF))
#define IS_RCC_SDMMC12CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_SDMMC12CLKSOURCE_PLL2S)  || \
   ((__SOURCE__) == RCC_SDMMC12CLKSOURCE_PLL2T))
#define IS_RCC_SPDIFRXCLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_SPDIFRXCLKSOURCE_PLL1Q) || \
   ((__SOURCE__) == RCC_SPDIFRXCLKSOURCE_PLL2R) || \
   ((__SOURCE__) == RCC_SPDIFRXCLKSOURCE_PLL3R) || \
   ((__SOURCE__) == RCC_SPDIFRXCLKSOURCE_HSI))
#define IS_RCC_SPI1CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_SPI1CLKSOURCE_PLL1Q) || \
   ((__SOURCE__) == RCC_SPI1CLKSOURCE_PLL2P) || \
   ((__SOURCE__) == RCC_SPI1CLKSOURCE_PLL3P) || \
   ((__SOURCE__) == RCC_SPI1CLKSOURCE_PIN)   || \
   ((__SOURCE__) == RCC_SPI1CLKSOURCE_CLKP))
#define IS_RCC_SPI23CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_SPI23CLKSOURCE_PLL1Q) || \
   ((__SOURCE__) == RCC_SPI23CLKSOURCE_PLL2P) || \
   ((__SOURCE__) == RCC_SPI23CLKSOURCE_PLL3P) || \
   ((__SOURCE__) == RCC_SPI23CLKSOURCE_PIN)   || \
   ((__SOURCE__) == RCC_SPI23CLKSOURCE_CLKP))
#define IS_RCC_SPI45CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_SPI45CLKSOURCE_PCLK2) || \
   ((__SOURCE__) == RCC_SPI45CLKSOURCE_PLL2Q) || \
   ((__SOURCE__) == RCC_SPI45CLKSOURCE_PLL3Q) || \
   ((__SOURCE__) == RCC_SPI45CLKSOURCE_HSI)   || \
   ((__SOURCE__) == RCC_SPI45CLKSOURCE_CSI)   || \
   ((__SOURCE__) == RCC_SPI45CLKSOURCE_HSE))
#define IS_RCC_SPI6CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_SPI6CLKSOURCE_PCLK4) || \
   ((__SOURCE__) == RCC_SPI6CLKSOURCE_PLL2Q) || \
   ((__SOURCE__) == RCC_SPI6CLKSOURCE_PLL3Q) || \
   ((__SOURCE__) == RCC_SPI6CLKSOURCE_HSI)   || \
   ((__SOURCE__) == RCC_SPI6CLKSOURCE_CSI)   || \
   ((__SOURCE__) == RCC_SPI6CLKSOURCE_HSE))
#define IS_RCC_STOP_KERWAKEUPCLOCK(__SOURCE__) (((__SOURCE__) == RCC_STOP_KERWAKEUPCLOCK_CSI) || \
                                                ((__SOURCE__) == RCC_STOP_KERWAKEUPCLOCK_HSI))
#define IS_RCC_STOP_WAKEUPCLOCK(__SOURCE__) (((__SOURCE__) == RCC_STOP_WAKEUPCLOCK_CSI) || \
                                             ((__SOURCE__) == RCC_STOP_WAKEUPCLOCK_HSI))
#define IS_RCC_TIMCLKPRESCALER(__VALUE__)  \
  (((__VALUE__) == RCC_TIMPRES_DISABLE) || \
   ((__VALUE__) == RCC_TIMPRES_ENABLE))
#define IS_RCC_USART1CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_USART1CLKSOURCE_PCLK2) || \
   ((__SOURCE__) == RCC_USART1CLKSOURCE_PLL2Q) || \
   ((__SOURCE__) == RCC_USART1CLKSOURCE_PLL3Q) || \
   ((__SOURCE__) == RCC_USART1CLKSOURCE_HSI)   || \
   ((__SOURCE__) == RCC_USART1CLKSOURCE_CSI)   || \
   ((__SOURCE__) == RCC_USART1CLKSOURCE_LSE))
#define IS_RCC_USART234578CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_USART234578CLKSOURCE_PCLK1) || \
   ((__SOURCE__) == RCC_USART234578CLKSOURCE_PLL2Q) || \
   ((__SOURCE__) == RCC_USART234578CLKSOURCE_PLL3Q) || \
   ((__SOURCE__) == RCC_USART234578CLKSOURCE_HSI)   || \
   ((__SOURCE__) == RCC_USART234578CLKSOURCE_LSE)   || \
   ((__SOURCE__) == RCC_USART234578CLKSOURCE_CSI))
#define IS_RCC_USBOTGFSCLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_USBOTGFSCLKSOURCE_HSI48) || \
   ((__SOURCE__) == RCC_USBOTGFSCLKSOURCE_PLL3Q) || \
   ((__SOURCE__) == RCC_USBOTGFSCLKSOURCE_HSE)   || \
   ((__SOURCE__) == RCC_USBOTGFSCLKSOURCE_CLK48))
#define IS_RCC_USBPHYCCLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_USBPHYCCLKSOURCE_HSE)      || \
   ((__SOURCE__) == RCC_USBPHYCCLKSOURCE_HSE_DIV2) || \
   ((__SOURCE__) == RCC_USBPHYCCLKSOURCE_PLL3Q))
#define IS_RCC_USBREFCLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_USBREFCLKSOURCE_16M)     || \
   ((__SOURCE__) == RCC_USBREFCLKSOURCE_19_2M)   || \
   ((__SOURCE__) == RCC_USBREFCLKSOURCE_20M)     || \
   ((__SOURCE__) == RCC_USBREFCLKSOURCE_24M)     || \
   ((__SOURCE__) == RCC_USBREFCLKSOURCE_26M)     || \
   ((__SOURCE__) == RCC_USBREFCLKSOURCE_32M))
#define IS_RCC_XSPI1CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_XSPI1CLKSOURCE_HCLK)  || \
   ((__SOURCE__) == RCC_XSPI1CLKSOURCE_PLL2S) || \
   ((__SOURCE__) == RCC_XSPI1CLKSOURCE_PLL2T))
#define IS_RCC_XSPI2CLKSOURCE(__SOURCE__) \
  (((__SOURCE__) == RCC_XSPI2CLKSOURCE_HCLK)  || \
   ((__SOURCE__) == RCC_XSPI2CLKSOURCE_PLL2S) || \
   ((__SOURCE__) == RCC_XSPI2CLKSOURCE_PLL2T))
#define RCC_ADCCLKSOURCE_CLKP      RCC_CCIPR1_ADCSEL_1   /*!< Clock peripheral output selection */
#define RCC_ADCCLKSOURCE_PLL2P     0U                      /*!< PLL2 'P' output selection (default) */
#define RCC_ADCCLKSOURCE_PLL3R     RCC_CCIPR1_ADCSEL_0   /*!< PLL3 'R' output selection */
#define RCC_ADF1CLKSOURCE_CSI      RCC_CCIPR1_ADF1SEL_2    /*!< CSI selection */
#define RCC_ADF1CLKSOURCE_HCLK     0U                        /*!< HCLK selection (default) */
#define RCC_ADF1CLKSOURCE_HSI      (RCC_CCIPR1_ADF1SEL_2 |  RCC_CCIPR1_ADF1SEL_0) /*!< HSI selection */
#define RCC_ADF1CLKSOURCE_PIN      (RCC_CCIPR1_ADF1SEL_1 |  RCC_CCIPR1_ADF1SEL_0) /*!< External I2S_PIN selection */
#define RCC_ADF1CLKSOURCE_PLL2P    RCC_CCIPR1_ADF1SEL_0    /*!< PLL2 'P' output selection */
#define RCC_ADF1CLKSOURCE_PLL3P    RCC_CCIPR1_ADF1SEL_1    /*!< PLL3 'P' output selection */
#define RCC_CECCLKSOURCE_CSI       RCC_CCIPR2_CECSEL_1      /*!< CSI divided by 122 selection */
#define RCC_CECCLKSOURCE_LSE       0U                          /*!< LSE selection (default) */
#define RCC_CECCLKSOURCE_LSI       RCC_CCIPR2_CECSEL_0      /*!< LSI selection */
#define RCC_CLKPSOURCE_CSI         RCC_CCIPR1_CKPERSEL_0     /*!< CSI selection */
#define RCC_CLKPSOURCE_HSE         RCC_CCIPR1_CKPERSEL_1     /*!< HSE selection */
#define RCC_CLKPSOURCE_HSI         0U                          /*!< HSI selection (default) */
#define RCC_CLOCKPROTECT_FMC           RCC_CKPROTR_FMCCKP      /*!< FMC clock protection */
#define RCC_CLOCKPROTECT_XSPI          RCC_CKPROTR_XSPICKP        /*!< XSPIs clock protection */
#define RCC_CRS_FLAG_ERR               CRS_ISR_ERRF          /*!< Error flag        */
#define RCC_CRS_FLAG_ERROR_MASK                ((uint32_t)(RCC_CRS_FLAG_TRIMOVF |\
                                                           RCC_CRS_FLAG_SYNCERR | RCC_CRS_FLAG_SYNCMISS))
#define RCC_CRS_FLAG_ESYNC             CRS_ISR_ESYNCF        /*!< Expected SYNC flag     */
#define RCC_CRS_FLAG_SYNCERR           CRS_ISR_SYNCERR       /*!< SYNC error */
#define RCC_CRS_FLAG_SYNCMISS          CRS_ISR_SYNCMISS      /*!< SYNC missed*/
#define RCC_CRS_FLAG_SYNCOK            CRS_ISR_SYNCOKF       /*!< SYNC event OK flag     */
#define RCC_CRS_FLAG_SYNCWARN          CRS_ISR_SYNCWARNF     /*!< SYNC warning flag      */
#define RCC_CRS_FLAG_TRIMOVF           CRS_ISR_TRIMOVF       /*!< Trimming overflow or underflow */
#define RCC_CRS_IT_ERR                 CRS_CR_ERRIE          /*!< Error */
#define RCC_CRS_IT_ESYNC               CRS_CR_ESYNCIE        /*!< Expected SYNC */
#define RCC_CRS_IT_SYNCOK              CRS_CR_SYNCOKIE       /*!< SYNC event OK */
#define RCC_CRS_IT_SYNCWARN            CRS_CR_SYNCWARNIE     /*!< SYNC warning */
#define RCC_CRS_NONE                   0x00000000U
#define RCC_CRS_SYNCERR                0x00000008U
#define RCC_CRS_SYNCMISS               0x00000010U
#define RCC_CRS_SYNCOK                 0x00000002U
#define RCC_CRS_SYNCWARN               0x00000004U
#define RCC_CRS_SYNC_DIV1              0U                                        /*!< Synchro Signal not divided (default) */
#define RCC_CRS_SYNC_DIV128            CRS_CFGR_SYNCDIV                          /*!< Synchro Signal divided by 128 */
#define RCC_CRS_SYNC_DIV16             CRS_CFGR_SYNCDIV_2                        /*!< Synchro Signal divided by 16 */
#define RCC_CRS_SYNC_DIV2              CRS_CFGR_SYNCDIV_0                        /*!< Synchro Signal divided by 2 */
#define RCC_CRS_SYNC_DIV32             (CRS_CFGR_SYNCDIV_2 | CRS_CFGR_SYNCDIV_0) /*!< Synchro Signal divided by 32 */
#define RCC_CRS_SYNC_DIV4              CRS_CFGR_SYNCDIV_1                        /*!< Synchro Signal divided by 4 */
#define RCC_CRS_SYNC_DIV64             (CRS_CFGR_SYNCDIV_2 | CRS_CFGR_SYNCDIV_1) /*!< Synchro Signal divided by 64 */
#define RCC_CRS_SYNC_DIV8              (CRS_CFGR_SYNCDIV_1 | CRS_CFGR_SYNCDIV_0) /*!< Synchro Signal divided by 8 */
#define RCC_CRS_SYNC_POLARITY_FALLING  CRS_CFGR_SYNCPOL        /*!< Synchro Active on falling edge */
#define RCC_CRS_SYNC_POLARITY_RISING   0U                      /*!< Synchro Active on rising edge (default) */
#define RCC_CRS_SYNC_SOURCE_GPIO          0U                                      /*!< Synchro Signal source GPIO */
#define RCC_CRS_SYNC_SOURCE_LSE          CRS_CFGR_SYNCSRC_0                      /*!< Synchro Signal source LSE */
#define RCC_CRS_SYNC_SOURCE_USB_OTG_FS   CRS_CFGR_SYNCSRC_1                      /*!< Synchro Signal source USB OTG FS SOF (default) */
#define RCC_CRS_SYNC_SOURCE_USB_OTG_HS   (CRS_CFGR_SYNCSRC_1|CRS_CFGR_SYNCSRC_0) /*!< Synchro Signal source USB OTG HS SOF */
#define RCC_CRS_TIMEOUT                0x00000001U
#define RCC_CRS_TRIMOVF                0x00000020U
#define RCC_ETH1PHYCLKSOURCE_HSE    0U                         /*!< HSE selection (default) */
#define RCC_ETH1PHYCLKSOURCE_PLL3S  RCC_CCIPR1_ETH1PHYCKSEL      /*!< PLL3 'S' output selection */
#define RCC_ETH1REFCLKSOURCE_ETH      RCC_CCIPR1_ETH1REFCKSEL_1   /*!< ETH Feedback output selection */
#define RCC_ETH1REFCLKSOURCE_HSE      RCC_CCIPR1_ETH1REFCKSEL_0   /*!< HSE selection */
#define RCC_ETH1REFCLKSOURCE_PHY      0U                          /*!< ETH PHY selection (default) */
#define RCC_EXTI_LINE_LSECSS           EXTI_IMR1_IM18        /*!< External interrupt line 18 connected to the LSE CSS EXTI Line */
#define RCC_FDCANCLKSOURCE_HSE     0U                          /*!< HSE selection (default) */
#define RCC_FDCANCLKSOURCE_PLL1Q   RCC_CCIPR2_FDCANSEL_0    /*!< PLL1 'Q' output selection */
#define RCC_FDCANCLKSOURCE_PLL2P   RCC_CCIPR2_FDCANSEL_1    /*!< PLL2 'P' output selection */
#define RCC_FMCCLKSOURCE_HCLK          0U                        /*!< HCLK selection (default) */
#define RCC_FMCCLKSOURCE_HCLK_DIV4     (RCC_CKPROTR_FMCSWP_2 | RCC_CKPROTR_FMCSWP_0) /*!< HCLK/4 selection (recovery position) */
#define RCC_FMCCLKSOURCE_HSI           RCC_CCIPR1_FMCSEL         /*!< HSI selection */
#define RCC_FMCCLKSOURCE_PLL1Q         RCC_CCIPR1_FMCSEL_0       /*!< PLL 'Q' output selection */
#define RCC_FMCCLKSOURCE_PLL2R         RCC_CCIPR1_FMCSEL_1       /*!< PLL2 'R' output selection */
#define RCC_I2C1_I3C1CLKSOURCE_CSI      (RCC_CCIPR2_I2C1_I3C1SEL_1 | RCC_CCIPR2_I2C1_I3C1SEL_0) /*!< CSI selection */
#define RCC_I2C1_I3C1CLKSOURCE_HSI      RCC_CCIPR2_I2C1_I3C1SEL_1  /*!< HSI selection */
#define RCC_I2C1_I3C1CLKSOURCE_PCLK1    0U                            /*!< PCLK1 selection (default) */
#define RCC_I2C1_I3C1CLKSOURCE_PLL3R    RCC_CCIPR2_I2C1_I3C1SEL_0  /*!< PLL3 'R' output selection */
#define RCC_I2C23CLKSOURCE_CSI     (RCC_CCIPR2_I2C23SEL_1 | RCC_CCIPR2_I2C23SEL_0) /*!< CSI selection */
#define RCC_I2C23CLKSOURCE_HSI     RCC_CCIPR2_I2C23SEL_1    /*!< HSI selection */
#define RCC_I2C23CLKSOURCE_PCLK1   0U                          /*!< PCLK1 selection (default) */
#define RCC_I2C23CLKSOURCE_PLL3R   RCC_CCIPR2_I2C23SEL_0    /*!< PLL3 'R' output selection */
#define RCC_IT_LSECSS                  RCC_CIFR_LSECSSF    /*!< LSE Clock Security System Interrupt */
#define RCC_LPTIM1CLKSOURCE_CLKP   (RCC_CCIPR2_LPTIM1SEL_2 | RCC_CCIPR2_LPTIM1SEL_0) /*!< Clock peripheral output selection */
#define RCC_LPTIM1CLKSOURCE_LSE    (RCC_CCIPR2_LPTIM1SEL_1 | RCC_CCIPR2_LPTIM1SEL_0) /*!< LSE selection */
#define RCC_LPTIM1CLKSOURCE_LSI    RCC_CCIPR2_LPTIM1SEL_2   /*!< LSI selection */
#define RCC_LPTIM1CLKSOURCE_PCLK1  0U                          /*!< PCLK1 selection (default) */
#define RCC_LPTIM1CLKSOURCE_PLL2P  RCC_CCIPR2_LPTIM1SEL_0   /*!< PLL2 'P' output selection */
#define RCC_LPTIM1CLKSOURCE_PLL3R  RCC_CCIPR2_LPTIM1SEL_1   /*!< PLL3 'R' output selection */
#define RCC_LPTIM23CLKSOURCE_CLKP   (RCC_CCIPR4_LPTIM23SEL_2 | RCC_CCIPR4_LPTIM23SEL_0) /*!< Clock peripheral output selection */
#define RCC_LPTIM23CLKSOURCE_LSE    (RCC_CCIPR4_LPTIM23SEL_1 | RCC_CCIPR4_LPTIM23SEL_0) /*!< LSE selection */
#define RCC_LPTIM23CLKSOURCE_LSI    RCC_CCIPR4_LPTIM23SEL_2 /*!< LSI selection */
#define RCC_LPTIM23CLKSOURCE_PCLK4  0U                          /*!< PCLK4 selection (default) */
#define RCC_LPTIM23CLKSOURCE_PLL2P  RCC_CCIPR4_LPTIM23SEL_0 /*!< PLL2 'P' output selection */
#define RCC_LPTIM23CLKSOURCE_PLL3R  RCC_CCIPR4_LPTIM23SEL_1 /*!< PLL3 'R' output selection */
#define RCC_LPTIM45CLKSOURCE_CLKP   (RCC_CCIPR4_LPTIM45SEL_2 | RCC_CCIPR4_LPTIM45SEL_0) /*!< Clock peripheral output selection */
#define RCC_LPTIM45CLKSOURCE_LSE    (RCC_CCIPR4_LPTIM45SEL_1 | RCC_CCIPR4_LPTIM45SEL_0) /*!< LSE selection */
#define RCC_LPTIM45CLKSOURCE_LSI    RCC_CCIPR4_LPTIM45SEL_2 /*!< LSI selection */
#define RCC_LPTIM45CLKSOURCE_PCLK4  0U                          /*!< PCLK4 selection (default) */
#define RCC_LPTIM45CLKSOURCE_PLL2P  RCC_CCIPR4_LPTIM45SEL_0 /*!< PLL2 'P' output selection */
#define RCC_LPTIM45CLKSOURCE_PLL3R  RCC_CCIPR4_LPTIM45SEL_1 /*!< PLL3 'R' output selection */
#define RCC_LPUART1CLKSOURCE_CSI    RCC_CCIPR4_LPUART1SEL_2   /*!< CSI selection */
#define RCC_LPUART1CLKSOURCE_HSI    (RCC_CCIPR4_LPUART1SEL_1 | RCC_CCIPR4_LPUART1SEL_0)  /*!< HSI selection */
#define RCC_LPUART1CLKSOURCE_LSE    (RCC_CCIPR4_LPUART1SEL_2 | RCC_CCIPR4_LPUART1SEL_0)  /*!< LSE selection */
#define RCC_LPUART1CLKSOURCE_PCLK4  0U                            /*!< PCLK4 selection (default) */
#define RCC_LPUART1CLKSOURCE_PLL2Q  RCC_CCIPR4_LPUART1SEL_0   /*!< PLL2 'Q' output selection */
#define RCC_LPUART1CLKSOURCE_PLL3Q  RCC_CCIPR4_LPUART1SEL_1   /*!< PLL2 'Q' output selection */
#define RCC_LSE_TIMEOUT_VALUE         LSE_STARTUP_TIMEOUT
#define RCC_LTDCCLKSOURCE_PLL3R     0U                            /*!< PLL3 'R' output selection (unique) */
#define RCC_PERIPHCLK_ADC          ((uint64_t)(0x00000010U))
#define RCC_PERIPHCLK_ADF1         ((uint64_t)(0x00000020U))
#define RCC_PERIPHCLK_CEC          ((uint64_t)(0x00000040U))
#define RCC_PERIPHCLK_CKPER        ((uint64_t)(0x00000008U))
#define RCC_PERIPHCLK_ETH1PHY      ((uint64_t)(0x00000100U))
#define RCC_PERIPHCLK_ETH1REF      ((uint64_t)(0x00000080U))
#define RCC_PERIPHCLK_FDCAN        ((uint64_t)(0x00000200U))
#define RCC_PERIPHCLK_FMC          ((uint64_t)(0x00000001U))
#define RCC_PERIPHCLK_I2C1_I3C1    ((uint64_t)(0x00000800U))
#define RCC_PERIPHCLK_I2C23        ((uint64_t)(0x00000400U))
#define RCC_PERIPHCLK_LPTIM1       ((uint64_t)(0x00001000U))
#define RCC_PERIPHCLK_LPTIM23      ((uint64_t)(0x00002000U))
#define RCC_PERIPHCLK_LPTIM45      ((uint64_t)(0x00004000U))
#define RCC_PERIPHCLK_LPUART1      ((uint64_t)(0x00008000U))
#define RCC_PERIPHCLK_LTDC         ((uint64_t)(0x00010000U))
#define RCC_PERIPHCLK_PSSI         ((uint64_t)(0x00020000U))
#define RCC_PERIPHCLK_RTC          ((uint64_t)(0x00040000U))
#define RCC_PERIPHCLK_SAI1         ((uint64_t)(0x00080000U))
#define RCC_PERIPHCLK_SAI2         ((uint64_t)(0x00100000U))
#define RCC_PERIPHCLK_SDMMC12      ((uint64_t)(0x00200000U))
#define RCC_PERIPHCLK_SPDIFRX      ((uint64_t)(0x00400000U))
#define RCC_PERIPHCLK_SPI1         ((uint64_t)(0x00800000U))
#define RCC_PERIPHCLK_SPI23        ((uint64_t)(0x01000000U))
#define RCC_PERIPHCLK_SPI45        ((uint64_t)(0x02000000U))
#define RCC_PERIPHCLK_SPI6         ((uint64_t)(0x04000000U))
#define RCC_PERIPHCLK_TIM          ((uint64_t)(0x08000000U))
#define RCC_PERIPHCLK_USART1       ((uint64_t)(0x10000000U))
#define RCC_PERIPHCLK_USART234578  ((uint64_t)(0x20000000U))
#define RCC_PERIPHCLK_USBOTGFS     ((uint64_t)(0x80000000U))
#define RCC_PERIPHCLK_USBPHYC      ((uint64_t)(0x40000000U))
#define RCC_PERIPHCLK_USBREF       ((uint64_t)(0x0000000100000000U))
#define RCC_PERIPHCLK_XSPI1        ((uint64_t)(0x00000002U))
#define RCC_PERIPHCLK_XSPI2        ((uint64_t)(0x00000004U))
#define RCC_PLLSOURCE_CSI              RCC_PLLCKSELR_PLLSRC_0 /*!< CSI clock selected as PLL entry clock source */
#define RCC_PLLSOURCE_HSE              RCC_PLLCKSELR_PLLSRC_1 /*!< HSE clock selected as PLL entry clock source */
#define RCC_PLLSOURCE_HSI              0U                     /*!< HSI clock selected as PLL entry clock source */
#define RCC_PLL_PCLK                  RCC_PLLCFGR_PLL1PEN   /*!< PLL DIVP divider output enable */
#define RCC_PLL_QCLK                  RCC_PLLCFGR_PLL1QEN   /*!< PLL DIVQ divider output enable */
#define RCC_PLL_RCLK                  RCC_PLLCFGR_PLL1REN   /*!< PLL DIVR divider output enable */
#define RCC_PLL_SCLK                  RCC_PLLCFGR_PLL1SEN   /*!< PLL DIVS divider output enable */
#define RCC_PLL_TCLK                  0x00000200U           /*!< PLL DIVT divider output enable, hardcoded because no definition in CMSIS */
#define RCC_PSSICLKSOURCE_CLKP    RCC_CCIPR1_PSSISEL         /*!< Clock peripheral output selection */
#define RCC_PSSICLKSOURCE_PLL3R   0U                           /*!< PLL3 'R' output selection (default) */
#define RCC_RTCCLKSOURCE_DISABLE       0U                                  /*!< RTC clock is disabled */
#define RCC_RTCCLKSOURCE_HSE_DIV10     ((0x0AUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 10 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV11     ((0x0BUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 11 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV12     ((0x0CUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 12 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV13     ((0x0DUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 13 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV14     ((0x0EUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 14 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV15     ((0x0FUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 15 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV16     ((0x10UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 16 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV17     ((0x11UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 17 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV18     ((0x12UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 18 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV19     ((0x13UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 19 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV2      ((0x02UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 2 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV20     ((0x14UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 20 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV21     ((0x15UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 21 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV22     ((0x16UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 22 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV23     ((0x17UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 23 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV24     ((0x18UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 24 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV25     ((0x19UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 25 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV26     ((0x1AUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 26 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV27     ((0x1BUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 27 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV28     ((0x1CUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 28 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV29     ((0x1DUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 29 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV3      ((0x03UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 3 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV30     ((0x1EUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 30 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV31     ((0x1FUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 31 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV32     ((0x20UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 32 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV33     ((0x21UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 33 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV34     ((0x22UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 34 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV35     ((0x23UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 35 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV36     ((0x24UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 36 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV37     ((0x25UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 37 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV38     ((0x26UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 38 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV39     ((0x27UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 39 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV4      ((0x04UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 4 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV40     ((0x28UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 40 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV41     ((0x29UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 41 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV42     ((0x2AUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 42 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV43     ((0x2BUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 43 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV44     ((0x2CUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 44 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV45     ((0x2DUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 45 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV46     ((0x2EUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 46 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV47     ((0x2FUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 47 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV48     ((0x30UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 48 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV49     ((0x31UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 49 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV5      ((0x05UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 5 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV50     ((0x32UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 50 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV51     ((0x33UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 51 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV52     ((0x34UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 52 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV53     ((0x35UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 53 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV54     ((0x36UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 54 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV55     ((0x37UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 55 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV56     ((0x38UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 56 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV57     ((0x39UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 57 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV58     ((0x3AUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 58 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV59     ((0x3BUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 59 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV6      ((0x06UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 6 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV60     ((0x3CUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 60 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV61     ((0x3DUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 61 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV62     ((0x3EUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 62 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV63     ((0x3FUL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 63 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV7      ((0x07UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 7 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV8      ((0x08UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 8 used as RTC clock */
#define RCC_RTCCLKSOURCE_HSE_DIV9      ((0x09UL << 12U) | RCC_BDCR_RTCSEL)  /*!< HSE oscillator clock divided by 9 used as RTC clock */
#define RCC_RTCCLKSOURCE_LSE           RCC_BDCR_RTCSEL_0                   /*!< LSE oscillator clock used as RTC clock */
#define RCC_RTCCLKSOURCE_LSI           RCC_BDCR_RTCSEL_1                   /*!< LSI oscillator clock used as RTC clock */
#define RCC_SAI1CLKSOURCE_CLKP     RCC_CCIPR3_SAI1SEL_2     /*!< Clock peripheral output selection */
#define RCC_SAI1CLKSOURCE_PIN      (RCC_CCIPR3_SAI1SEL_1 | RCC_CCIPR3_SAI1SEL_0)  /*!< I2S_PIN selection */
#define RCC_SAI1CLKSOURCE_PLL1Q    0U                          /*!< PLL1 'Q' output selection (default) */
#define RCC_SAI1CLKSOURCE_PLL2P    RCC_CCIPR3_SAI1SEL_0     /*!< PLL2 'P' output selection */
#define RCC_SAI1CLKSOURCE_PLL3P    RCC_CCIPR3_SAI1SEL_1     /*!< PLL3 'P' output selection */
#define RCC_SAI2CLKSOURCE_CLKP     RCC_CCIPR3_SAI2SEL_2     /*!< Clock peripheral output selection */
#define RCC_SAI2CLKSOURCE_PIN      (RCC_CCIPR3_SAI2SEL_1 | RCC_CCIPR3_SAI2SEL_0)  /*!< I2S_PIN selection */
#define RCC_SAI2CLKSOURCE_PLL1Q    0U                          /*!< PLL1 'Q' output selection (default) */
#define RCC_SAI2CLKSOURCE_PLL2P    RCC_CCIPR3_SAI2SEL_0     /*!< PLL2 'P' output selection */
#define RCC_SAI2CLKSOURCE_PLL3P    RCC_CCIPR3_SAI2SEL_1     /*!< PLL3 'P' output selection */
#define RCC_SAI2CLKSOURCE_SPDIF    (RCC_CCIPR3_SAI2SEL_2 | RCC_CCIPR3_SAI2SEL_0)  /*!< SPDIF output selection */
#define RCC_SDMMC12CLKSOURCE_PLL2S   0U                          /*!< PLL2 'S' output selection (default) */
#define RCC_SDMMC12CLKSOURCE_PLL2T   RCC_CCIPR1_SDMMC12SEL       /*!< PLL2 'T' output selection */
#define RCC_SPDIFRXCLKSOURCE_HSI   RCC_CCIPR2_SPDIFRXSEL    /*!< HSI selection */
#define RCC_SPDIFRXCLKSOURCE_PLL1Q 0U                          /*!< PLL1 'Q' output selection (default) */
#define RCC_SPDIFRXCLKSOURCE_PLL2R RCC_CCIPR2_SPDIFRXSEL_0  /*!< PLL2 'R' output selection */
#define RCC_SPDIFRXCLKSOURCE_PLL3R RCC_CCIPR2_SPDIFRXSEL_1  /*!< PLL3 'R' output selection */
#define RCC_SPI1CLKSOURCE_CLKP     RCC_CCIPR3_SPI1SEL_2     /*!< Clock peripheral output selection */
#define RCC_SPI1CLKSOURCE_PIN      (RCC_CCIPR3_SPI1SEL_1 | RCC_CCIPR3_SPI1SEL_0)  /*!< I2S_PIN selection */
#define RCC_SPI1CLKSOURCE_PLL1Q    0U                          /*!< PLL1 'Q' output selection (default) */
#define RCC_SPI1CLKSOURCE_PLL2P    RCC_CCIPR3_SPI1SEL_0     /*!< PLL2 'P' output selection */
#define RCC_SPI1CLKSOURCE_PLL3P    RCC_CCIPR3_SPI1SEL_1     /*!< PLL3 'P' output selection */
#define RCC_SPI23CLKSOURCE_CLKP    RCC_CCIPR2_SPI23SEL_2    /*!< Clock peripheral output selection */
#define RCC_SPI23CLKSOURCE_PIN     (RCC_CCIPR2_SPI23SEL_1 | RCC_CCIPR2_SPI23SEL_0)  /*!< I2S_PIN selection */
#define RCC_SPI23CLKSOURCE_PLL1Q   0U                          /*!< PLL1 'Q' output selection (default) */
#define RCC_SPI23CLKSOURCE_PLL2P   RCC_CCIPR2_SPI23SEL_0    /*!< PLL2 'P' output selection */
#define RCC_SPI23CLKSOURCE_PLL3P   RCC_CCIPR2_SPI23SEL_1    /*!< PLL3 'P' output selection */
#define RCC_SPI45CLKSOURCE_CSI     RCC_CCIPR3_SPI45SEL_2    /*!< CSI selection */
#define RCC_SPI45CLKSOURCE_HSE     (RCC_CCIPR3_SPI45SEL_2 | RCC_CCIPR3_SPI45SEL_0)  /*!< HSE selection */
#define RCC_SPI45CLKSOURCE_HSI     (RCC_CCIPR3_SPI45SEL_1 | RCC_CCIPR3_SPI45SEL_0)  /*!< HSI selection */
#define RCC_SPI45CLKSOURCE_PCLK2   0U                          /*!< PCLK2 selection (default) */
#define RCC_SPI45CLKSOURCE_PLL2Q   RCC_CCIPR3_SPI45SEL_0    /*!< PLL2 'Q' output selection */
#define RCC_SPI45CLKSOURCE_PLL3Q   RCC_CCIPR3_SPI45SEL_1    /*!< PLL3 'Q' output selection */
#define RCC_SPI6CLKSOURCE_CSI      RCC_CCIPR4_SPI6SEL_2    /*!< CSI selection */
#define RCC_SPI6CLKSOURCE_HSE      (RCC_CCIPR4_SPI6SEL_2 | RCC_CCIPR4_SPI6SEL_0)  /*!< HSE selection */
#define RCC_SPI6CLKSOURCE_HSI      (RCC_CCIPR4_SPI6SEL_1 | RCC_CCIPR4_SPI6SEL_0)  /*!< HSI selection */
#define RCC_SPI6CLKSOURCE_PCLK4    0U                          /*!< PCLK4 selection (default) */
#define RCC_SPI6CLKSOURCE_PLL2Q    RCC_CCIPR4_SPI6SEL_0    /*!< PLL2 'Q' output selection */
#define RCC_SPI6CLKSOURCE_PLL3Q    RCC_CCIPR4_SPI6SEL_1    /*!< PLL3 'Q' output selection */
#define RCC_STOP_KERWAKEUPCLOCK_CSI    RCC_CFGR_STOPKERWUCK /*!< CSI selected as wake up kernel clock from system Stop */
#define RCC_STOP_KERWAKEUPCLOCK_HSI    0U                   /*!< HSI selected as wake up kernel clock from system Stop (default after reset) */
#define RCC_STOP_WAKEUPCLOCK_CSI       RCC_CFGR_STOPWUCK   /*!< CSI selected as wake up system clock from system Stop */
#define RCC_STOP_WAKEUPCLOCK_HSI       0U                  /*!< HSI selected as wake up system clock from system Stop (default after reset) */
#define RCC_SYSCLKSOURCE_STATUS_CSI    RCC_CFGR_SWS_0      /*!< CSI used as system clock */
#define RCC_SYSCLKSOURCE_STATUS_HSE    RCC_CFGR_SWS_1      /*!< HSE used as system clock */
#define RCC_SYSCLKSOURCE_STATUS_HSI    0U                  /*!< HSI used as system clock */
#define RCC_SYSCLKSOURCE_STATUS_PLLCLK (RCC_CFGR_SWS_1 | RCC_CFGR_SWS_0) /*!< PLL1 used as system clock */
#define RCC_TIMPRES_DISABLE   0U                         /*!< Timers clocks prescaler not set (default) */
#define RCC_TIMPRES_ENABLE    RCC_CFGR_TIMPRE            /*!< Timers clocks prescaler set */
#define RCC_USART1CLKSOURCE_CSI    RCC_CCIPR3_USART1SEL_2   /*!< CSI selection */
#define RCC_USART1CLKSOURCE_HSI    (RCC_CCIPR3_USART1SEL_1 | RCC_CCIPR3_USART1SEL_0)  /*!< HSI selection */
#define RCC_USART1CLKSOURCE_LSE    (RCC_CCIPR3_USART1SEL_2 | RCC_CCIPR3_USART1SEL_0)  /*!< LSE selection */
#define RCC_USART1CLKSOURCE_PCLK2  0U                          /*!< PCLK2 selection (default) */
#define RCC_USART1CLKSOURCE_PLL2Q  RCC_CCIPR3_USART1SEL_0   /*!< PLL2 'Q' output selection */
#define RCC_USART1CLKSOURCE_PLL3Q  RCC_CCIPR3_USART1SEL_1   /*!< PLL2 'Q' output selection */
#define RCC_USART234578CLKSOURCE_CSI    RCC_CCIPR2_UART234578SEL_2   /*!< CSI selection */
#define RCC_USART234578CLKSOURCE_HSI    (RCC_CCIPR2_UART234578SEL_1 | RCC_CCIPR2_UART234578SEL_0)  /*!< HSI selection */
#define RCC_USART234578CLKSOURCE_LSE    (RCC_CCIPR2_UART234578SEL_2 | RCC_CCIPR2_UART234578SEL_0)  /*!< LSE selection */
#define RCC_USART234578CLKSOURCE_PCLK1  0U                            /*!< PCLK1 selection (default) */
#define RCC_USART234578CLKSOURCE_PLL2Q  RCC_CCIPR2_UART234578SEL_0 /*!< PLL2 'Q' output selection */
#define RCC_USART234578CLKSOURCE_PLL3Q  RCC_CCIPR2_UART234578SEL_1 /*!< PLL3 'Q' output selection */
#define RCC_USBOTGFSCLKSOURCE_CLK48    RCC_CCIPR1_OTGFSSEL   /*!< USBPHYC CLK48 output selection */
#define RCC_USBOTGFSCLKSOURCE_HSE      RCC_CCIPR1_OTGFSSEL_1 /*!< HSE selection */
#define RCC_USBOTGFSCLKSOURCE_HSI48    0U                      /*!< HSI48 selection (default) */
#define RCC_USBOTGFSCLKSOURCE_PLL3Q    RCC_CCIPR1_OTGFSSEL_0 /*!< PLL3 'Q' output selection */
#define RCC_USBPHYCCLKSOURCE_HSE       0U                        /*!< HSE selection (default) */
#define RCC_USBPHYCCLKSOURCE_HSE_DIV2  RCC_CCIPR1_USBPHYCSEL_0 /*!< HSE div 2 selection */
#define RCC_USBPHYCCLKSOURCE_PLL3Q     RCC_CCIPR1_USBPHYCSEL_1 /*!< PLL3 'Q' output selection */
#define RCC_USBREFCLKSOURCE_16M         (RCC_CCIPR1_USBREFCKSEL_1 | RCC_CCIPR1_USBREFCKSEL_0)
#define RCC_USBREFCLKSOURCE_19_2M       RCC_CCIPR1_USBREFCKSEL_3
#define RCC_USBREFCLKSOURCE_20M         (RCC_CCIPR1_USBREFCKSEL_3 | RCC_CCIPR1_USBREFCKSEL_0)
#define RCC_USBREFCLKSOURCE_24M         (RCC_CCIPR1_USBREFCKSEL_3 | RCC_CCIPR1_USBREFCKSEL_1)
#define RCC_USBREFCLKSOURCE_26M         (RCC_CCIPR1_USBREFCKSEL_3 |\
                                         RCC_CCIPR1_USBREFCKSEL_2 | RCC_CCIPR1_USBREFCKSEL_1)
#define RCC_USBREFCLKSOURCE_32M         (RCC_CCIPR1_USBREFCKSEL_3 |\
                                         RCC_CCIPR1_USBREFCKSEL_1 | RCC_CCIPR1_USBREFCKSEL_0)
#define RCC_XSPI1CLKSOURCE_HCLK        0U                     /*!< HCLK selection (default) */
#define RCC_XSPI1CLKSOURCE_HCLK_DIV4   RCC_CKPROTR_XSPI1SWP_2 /*!< HCLK/4 selection (recovery position) */
#define RCC_XSPI1CLKSOURCE_PLL2S       RCC_CCIPR1_XSPI1SEL_0  /*!< PLL2 'S' output selection */
#define RCC_XSPI1CLKSOURCE_PLL2T       RCC_CCIPR1_XSPI1SEL_1  /*!< PLL2 'T' output selection */
#define RCC_XSPI2CLKSOURCE_HCLK        0U                     /*!< HCLK selection (default) */
#define RCC_XSPI2CLKSOURCE_HCLK_DIV4   RCC_CKPROTR_XSPI2SWP_2 /*!< HCLK/4 selection (recovery position) */
#define RCC_XSPI2CLKSOURCE_PLL2S       RCC_CCIPR1_XSPI2SEL_0  /*!< PLL2 'S' output selection */
#define RCC_XSPI2CLKSOURCE_PLL2T       RCC_CCIPR1_XSPI2SEL_1  /*!< PLL2 'T' output selection */
#define __HAL_RCC_ADC_CONFIG(__ADC_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR1, RCC_CCIPR1_ADCSEL, (uint32_t)(__ADC_CLKSOURCE__))
#define __HAL_RCC_ADF1_CONFIG(__ADF1_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR1, RCC_CCIPR1_ADF1SEL, (uint32_t)(__ADF1_CLKSOURCE__))
#define __HAL_RCC_BACKUPRESET_FORCE()   SET_BIT(RCC->BDCR, RCC_BDCR_VSWRST)
#define __HAL_RCC_BACKUPRESET_RELEASE() CLEAR_BIT(RCC->BDCR, RCC_BDCR_VSWRST)
#define __HAL_RCC_CEC_CONFIG(__CEC_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR2, RCC_CCIPR2_CECSEL, (uint32_t)(__CEC_CLKSOURCE__))
#define __HAL_RCC_CLEAR_IT(__INTERRUPT__) WRITE_REG(RCC->CICR, (__INTERRUPT__))
#define __HAL_RCC_CLKP_CONFIG(__CLKP_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR1, RCC_CCIPR1_CKPERSEL, (uint32_t)(__CLKP_CLKSOURCE__))
#define __HAL_RCC_CRS_CLEAR_FLAG(__FLAG__)     do { \
                                                    if(((__FLAG__) & RCC_CRS_FLAG_ERROR_MASK) != 0U) \
                                                    { \
                                                      WRITE_REG(CRS->ICR, CRS_ICR_ERRC | ((__FLAG__) & ~RCC_CRS_FLAG_ERROR_MASK)); \
                                                    } \
                                                    else \
                                                    { \
                                                      WRITE_REG(CRS->ICR, (__FLAG__)); \
                                                    } \
                                                  } while(0)
#define __HAL_RCC_CRS_FORCE_RESET()        SET_BIT(RCC->APB1RSTR2, RCC_APB1RSTR2_CRSRST)
#define __HAL_RCC_CRS_GET_FLAG(__FLAG__)  (READ_BIT(CRS->ISR, (__FLAG__)) == (__FLAG__))
#define __HAL_RCC_CRS_RELEASE_RESET()      CLEAR_BIT(RCC->APB1RSTR2, RCC_APB1RSTR2_CRSRST)
#define __HAL_RCC_DISABLE_IT(__INTERRUPT__) CLEAR_BIT(RCC->CIER, (__INTERRUPT__))
#define __HAL_RCC_ENABLE_IT(__INTERRUPT__) SET_BIT(RCC->CIER, (__INTERRUPT__))
#define __HAL_RCC_ETH1PHY_CONFIG(__ETH1PHY_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR1, RCC_CCIPR1_ETH1PHYCKSEL, (uint32_t)(__ETH1PHY_CLKSOURCE__))
#define __HAL_RCC_ETH1REF_CONFIG(__ETH1REF_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR1, RCC_CCIPR1_ETH1REFCKSEL, (uint32_t)(__ETH1REF_CLKSOURCE__))
#define __HAL_RCC_FDCAN_CONFIG(__FDCAN_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR2, RCC_CCIPR2_FDCANSEL, (uint32_t)(__FDCAN_CLKSOURCE__))
#define __HAL_RCC_FMC_CONFIG(__FMC_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR1, RCC_CCIPR1_FMCSEL, (uint32_t)(__FMC_CLKSOURCE__))
#define __HAL_RCC_GET_ADC_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR1, RCC_CCIPR1_ADCSEL)))
#define __HAL_RCC_GET_ADF1_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR1, RCC_CCIPR1_ADF1SEL)))
#define __HAL_RCC_GET_CEC_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR2, RCC_CCIPR2_CECSEL)))
#define __HAL_RCC_GET_CLKP_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR1, RCC_CCIPR1_CKPERSEL)))
#define __HAL_RCC_GET_ETH1PHY_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR1, RCC_CCIPR1_ETH1PHYCKSEL)))
#define __HAL_RCC_GET_ETH1REF_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR1, RCC_CCIPR1_ETH1REFCKSEL)))
#define __HAL_RCC_GET_FDCAN_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR2, RCC_CCIPR2_FDCANSEL)))
#define __HAL_RCC_GET_FMC_SOURCE() ((READ_BIT(RCC->CKPROTR, RCC_CKPROTR_FMCSWP) == RCC_FMCCLKSOURCE_HCLK_DIV4) ? \
                                    RCC_FMCCLKSOURCE_HCLK_DIV4 : ((uint32_t)(READ_BIT(RCC->CCIPR1, RCC_CCIPR1_FMCSEL))))
#define __HAL_RCC_GET_HSI_DIVIDER() ((uint32_t)(READ_BIT(RCC->CR, RCC_CR_HSIDIV)))
#define __HAL_RCC_GET_I2C1_I3C1_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR2, RCC_CCIPR2_I2C1_I3C1SEL)))
#define __HAL_RCC_GET_I2C23_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR2, RCC_CCIPR2_I2C23SEL)))
#define __HAL_RCC_GET_IT(__INTERRUPT__) (READ_BIT(RCC->CIFR, (__INTERRUPT__)) == (__INTERRUPT__))
#define __HAL_RCC_GET_LPTIM1_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR2, RCC_CCIPR2_LPTIM1SEL)))
#define __HAL_RCC_GET_LPTIM23_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR4, RCC_CCIPR4_LPTIM23SEL)))
#define __HAL_RCC_GET_LPTIM45_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR4, RCC_CCIPR4_LPTIM45SEL)))
#define __HAL_RCC_GET_LPUART1_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR4, RCC_CCIPR4_LPUART1SEL)))
#define __HAL_RCC_GET_LTDC_SOURCE() RCC_LTDCCLKSOURCE_PLL3R
#define __HAL_RCC_GET_PLL1CLKOUT_CONFIG(__PLL_CLOCKOUT__)   READ_BIT(RCC->PLLCFGR, (__PLL_CLOCKOUT__))
#define __HAL_RCC_GET_PLL2CLKOUT_CONFIG(__PLL_CLOCKOUT__)   (READ_BIT(RCC->PLLCFGR, ((__PLL_CLOCKOUT__) << (RCC_PLLCFGR_PLL2PEN_Pos - RCC_PLLCFGR_PLL1PEN_Pos))) \
                                                             >> (RCC_PLLCFGR_PLL2PEN_Pos - RCC_PLLCFGR_PLL1PEN_Pos))
#define __HAL_RCC_GET_PLL3CLKOUT_CONFIG(__PLL_CLOCKOUT__)   (READ_BIT(RCC->PLLCFGR, ((__PLL_CLOCKOUT__) << (RCC_PLLCFGR_PLL3PEN_Pos - RCC_PLLCFGR_PLL1PEN_Pos))) \
                                                             >> (RCC_PLLCFGR_PLL3PEN_Pos - RCC_PLLCFGR_PLL1PEN_Pos))
#define __HAL_RCC_GET_PSSI_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR1, RCC_CCIPR1_PSSISEL)))
#define __HAL_RCC_GET_RTC_SOURCE() \
  ((READ_BIT(RCC->BDCR, RCC_BDCR_RTCSEL) == RCC_BDCR_RTCSEL) ? \
   ((READ_BIT(RCC->CFGR, RCC_CFGR_RTCPRE) << 4U) | RCC_BDCR_RTCSEL) : READ_BIT(RCC->BDCR, RCC_BDCR_RTCSEL))
#define __HAL_RCC_GET_SAI1_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR3, RCC_CCIPR3_SAI1SEL)))
#define __HAL_RCC_GET_SAI2_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR3, RCC_CCIPR3_SAI2SEL)))
#define __HAL_RCC_GET_SDMMC12_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR1, RCC_CCIPR1_SDMMC12SEL)))
#define __HAL_RCC_GET_SPDIFRX_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR2, RCC_CCIPR2_SPDIFRXSEL)))
#define __HAL_RCC_GET_SPI1_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR3, RCC_CCIPR3_SPI1SEL)))
#define __HAL_RCC_GET_SPI23_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR2, RCC_CCIPR2_SPI23SEL)))
#define __HAL_RCC_GET_SPI45_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR3, RCC_CCIPR3_SPI45SEL)))
#define __HAL_RCC_GET_SPI6_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR4, RCC_CCIPR4_SPI6SEL)))
#define __HAL_RCC_GET_USART1_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR3, RCC_CCIPR3_USART1SEL)))
#define __HAL_RCC_GET_USART234578_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR2, RCC_CCIPR2_UART234578SEL)))
#define __HAL_RCC_GET_USBOTGFS_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR1, RCC_CCIPR1_OTGFSSEL)))
#define __HAL_RCC_GET_USBPHYC_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR1, RCC_CCIPR1_USBPHYCSEL)))
#define __HAL_RCC_GET_USBREF_SOURCE() ((uint32_t)(READ_BIT(RCC->CCIPR1, RCC_CCIPR1_USBREFCKSEL)))
#define __HAL_RCC_GET_XSPI1_SOURCE() ((READ_BIT(RCC->CKPROTR, RCC_CKPROTR_XSPI1SWP) == RCC_XSPI1CLKSOURCE_HCLK_DIV4) ? \
                                      RCC_XSPI1CLKSOURCE_HCLK_DIV4 : ((uint32_t)(READ_BIT(RCC->CCIPR1, RCC_CCIPR1_XSPI1SEL))))
#define __HAL_RCC_GET_XSPI2_SOURCE() ((READ_BIT(RCC->CKPROTR, RCC_CKPROTR_XSPI2SWP) == RCC_XSPI2CLKSOURCE_HCLK_DIV4) ? \
                                      RCC_XSPI2CLKSOURCE_HCLK_DIV4 : ((uint32_t)(READ_BIT(RCC->CCIPR1, RCC_CCIPR1_XSPI2SEL))))
#define __HAL_RCC_I2C1_I3C1_CONFIG(__I2C1_I3C1_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR2, RCC_CCIPR2_I2C1_I3C1SEL, (uint32_t)(__I2C1_I3C1_CLKSOURCE__))
#define __HAL_RCC_I2C23_CONFIG(__I2C23_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR2, RCC_CCIPR2_I2C23SEL, (uint32_t)(__I2C23_CLKSOURCE__))
#define __HAL_RCC_KERWAKEUPSTOP_CLK_CONFIG(__STOPKERWUCLK__) \
  MODIFY_REG(RCC->CFGR, RCC_CFGR_STOPKERWUCK, (__STOPKERWUCLK__))
#define __HAL_RCC_LPTIM1_CONFIG(__LPTIM1_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR2, RCC_CCIPR2_LPTIM1SEL, (uint32_t)(__LPTIM1_CLKSOURCE__))
#define __HAL_RCC_LPTIM23_CONFIG(__LPTIM23_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR4, RCC_CCIPR4_LPTIM23SEL, (uint32_t)(__LPTIM23_CLKSOURCE__))
#define __HAL_RCC_LPTIM45_CONFIG(__LPTIM45_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR4, RCC_CCIPR4_LPTIM45SEL, (uint32_t)(__LPTIM45_CLKSOURCE__))
#define __HAL_RCC_LPUART1_CONFIG(__LPUART1_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR4, RCC_CCIPR4_LPUART1SEL, (uint32_t)(__LPUART1_CLKSOURCE__))
#define __HAL_RCC_LSECSS_EXTI_ENABLE_IT()      SET_BIT(EXTI->IMR1, RCC_EXTI_LINE_LSECSS)
#define __HAL_RCC_LSECSS_EXTI_ENABLE_RISING_EDGE()   SET_BIT(EXTI->RTSR1, RCC_EXTI_LINE_LSECSS)
#define __HAL_RCC_PLL1CLKOUT_ENABLE(__PLL_CLOCKOUT__)   SET_BIT(RCC->PLLCFGR, (__PLL_CLOCKOUT__))
#define __HAL_RCC_PLL2CLKOUT_ENABLE(__PLL_CLOCKOUT__)   SET_BIT(RCC->PLLCFGR, ((__PLL_CLOCKOUT__) << (RCC_PLLCFGR_PLL2PEN_Pos - RCC_PLLCFGR_PLL1PEN_Pos)))
#define __HAL_RCC_PLL3CLKOUT_ENABLE(__PLL_CLOCKOUT__)   SET_BIT(RCC->PLLCFGR, ((__PLL_CLOCKOUT__) << (RCC_PLLCFGR_PLL3PEN_Pos - RCC_PLLCFGR_PLL1PEN_Pos)))
#define __HAL_RCC_PSSI_CONFIG(__PSSI_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR1, RCC_CCIPR1_PSSISEL, (__PSSI_CLKSOURCE__))
#define __HAL_RCC_RTC_CLKPRESCALER(__RTC_CLKSOURCE__) \
  ((((__RTC_CLKSOURCE__) & (0x3FUL << 12U)) != 0U) ? \
   MODIFY_REG(RCC->CFGR, RCC_CFGR_RTCPRE, (((__RTC_CLKSOURCE__) & (~RCC_BDCR_RTCSEL)) >> 4U)) : \
   CLEAR_BIT(RCC->CFGR, RCC_CFGR_RTCPRE))
#define __HAL_RCC_RTC_CONFIG(__RTC_CLKSOURCE__) \
  do { \
    __HAL_RCC_RTC_CLKPRESCALER(__RTC_CLKSOURCE__); \
    SET_BIT(RCC->BDCR, ((__RTC_CLKSOURCE__) & RCC_BDCR_RTCSEL)); \
  } while(0)
#define __HAL_RCC_RTC_ENABLE()         SET_BIT(RCC->BDCR, RCC_BDCR_RTCEN)
#define __HAL_RCC_SAI1_CONFIG(__SAI1_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR3, RCC_CCIPR3_SAI1SEL, (__SAI1_CLKSOURCE__))
#define __HAL_RCC_SAI2_CONFIG(__SAI2_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR3, RCC_CCIPR3_SAI2SEL, (__SAI2_CLKSOURCE__))
#define __HAL_RCC_SDMMC12_CONFIG(__SDMMC12_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR1, RCC_CCIPR1_SDMMC12SEL, (uint32_t)(__SDMMC12_CLKSOURCE__))
#define __HAL_RCC_SPDIFRX_CONFIG(__SPDIFRX_CLKSOURCE__ ) \
  MODIFY_REG(RCC->CCIPR2, RCC_CCIPR2_SPDIFRXSEL, (__SPDIFRX_CLKSOURCE__))
#define __HAL_RCC_SPI1_CONFIG(__SPI1_CLKSOURCE__ ) \
  MODIFY_REG(RCC->CCIPR3, RCC_CCIPR3_SPI1SEL, (__SPI1_CLKSOURCE__))
#define __HAL_RCC_SPI23_CONFIG(__SPI23_CLKSOURCE__ ) \
  MODIFY_REG(RCC->CCIPR2, RCC_CCIPR2_SPI23SEL, (__SPI23_CLKSOURCE__))
#define __HAL_RCC_SPI45_CONFIG(__SPI45_CLKSOURCE__ ) \
  MODIFY_REG(RCC->CCIPR3, RCC_CCIPR3_SPI45SEL, (__SPI45_CLKSOURCE__))
#define __HAL_RCC_SPI6_CONFIG(__SPI6_CLKSOURCE__ ) \
  MODIFY_REG(RCC->CCIPR4, RCC_CCIPR4_SPI6SEL, (__SPI6_CLKSOURCE__))
#define __HAL_RCC_TIMCLKPRESCALER_CONFIG(__PRESC__) \
  MODIFY_REG(RCC->CFGR, RCC_CFGR_TIMPRE, (uint32_t)(__PRESC__))
#define __HAL_RCC_USART1_CONFIG(__USART1_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR3, RCC_CCIPR3_USART1SEL, (uint32_t)(__USART1_CLKSOURCE__))
#define __HAL_RCC_USART234578_CONFIG(__USART234578_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR2, RCC_CCIPR2_UART234578SEL, (uint32_t)(__USART234578_CLKSOURCE__))
#define __HAL_RCC_USBOTGFS_CONFIG(__USBOTGFS_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR1, RCC_CCIPR1_OTGFSSEL, (uint32_t)(__USBOTGFS_CLKSOURCE__))
#define __HAL_RCC_USBPHYC_CONFIG(__USBPHYC_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR1, RCC_CCIPR1_USBPHYCSEL, (uint32_t)(__USBPHYC_CLKSOURCE__))
#define __HAL_RCC_USBREF_CONFIG(__USBREF_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR1, RCC_CCIPR1_USBREFCKSEL, (uint32_t)(__USBREF_CLKSOURCE__))
#define __HAL_RCC_WAKEUPSTOP_CLK_CONFIG(__STOPWUCLK__) \
  MODIFY_REG(RCC->CFGR, RCC_CFGR_STOPWUCK, (__STOPWUCLK__))
#define __HAL_RCC_XSPI1_CONFIG(__XSPI1_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR1, RCC_CCIPR1_XSPI1SEL, (uint32_t)(__XSPI1_CLKSOURCE__))
#define __HAL_RCC_XSPI2_CONFIG(__XSPI2_CLKSOURCE__) \
  MODIFY_REG(RCC->CCIPR1, RCC_CCIPR1_XSPI2SEL, (uint32_t)(__XSPI2_CLKSOURCE__))
