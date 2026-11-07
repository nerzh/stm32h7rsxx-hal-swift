/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Unchanged declarations/functions/macros from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748. Host bindings are in the shim.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#ifndef C_RCC_EXTENDED_TYPES_H
#define C_RCC_EXTENDED_TYPES_H
#include <stdint.h>
typedef struct
{
  uint64_t PeriphClockSelection;   /*!< The Extended Clock to be configured.
                                        This parameter can be a value of @ref RCCEx_Periph_Clock_Selection */

  uint32_t FmcClockSelection;      /*!< Specifies FMC clock source
                                        This parameter can be a value of @ref RCCEx_FMC_Clock_Source    */

  uint32_t Xspi1ClockSelection;    /*!< Specifies XSPI1 clock source
                                        This parameter can be a value of @ref RCCEx_XSPI1_Clock_Source  */

  uint32_t Xspi2ClockSelection;    /*!< Specifies XSPI2 clock source
                                        This parameter can be a value of @ref RCCEx_XSPI2_Clock_Source  */

  uint32_t CkperClockSelection;   /*!< Specifies CKPER clock source
                                        This parameter can be a value of @ref RCCEx_CLKP_Clock_Source   */

  uint32_t AdcClockSelection;      /*!< Specifies ADC interface clock source
                                        This parameter can be a value of @ref RCCEx_ADC_Clock_Source     */

  uint32_t Adf1ClockSelection;     /*!< Specifies ADF1 Clock clock source
                                        This parameter can be a value of @ref RCCEx_ADF1_Clock_Source  */

  uint32_t CecClockSelection;      /*!< Specifies CEC clock source
                                        This parameter can be a value of @ref RCCEx_CEC_Clock_Source     */

  uint32_t Eth1RefClockSelection;     /*!< Specifies ETH1 REF clock source
                                        This parameter can be a value of @ref RCCEx_ETH1REF_Clock_Source   */

  uint32_t Eth1PhyClockSelection;   /*!< Specifies ETH1 PHY clock source
                                        This parameter can be a value of @ref RCCEx_ETH1PHY_Clock_Source   */

  uint32_t FdcanClockSelection;    /*!< Specifies FDCAN kernel clock source
                                        This parameter can be a value of @ref RCCEx_FDCAN_Clock_Source   */

  uint32_t I2c1_I3c1ClockSelection;     /*!< Specifies I2C1/I3C1 clock source
                                        This parameter can be a value of @ref RCCEx_I2C1_I3C1_Clock_Source    */

  uint32_t I2c23ClockSelection;    /*!< Specifies I2C2/I2C3 clock source
                                        This parameter can be a value of @ref RCCEx_I2C23_Clock_Source    */

  uint32_t Lptim1ClockSelection;   /*!< Specifies LPTIM1 clock source
                                        This parameter can be a value of @ref RCCEx_LPTIM1_Clock_Source  */

  uint32_t Lptim23ClockSelection;  /*!< Specifies LPTIM2/LPTIM3 clock source
                                        This parameter can be a value of @ref RCCEx_LPTIM23_Clock_Source  */

  uint32_t Lptim45ClockSelection;  /*!< Specifies LPTIM4/LPTIM5 clock source
                                        This parameter can be a value of @ref RCCEx_LPTIM45_Clock_Source  */

  uint32_t Lpuart1ClockSelection;  /*!< Specifies LPUART1 clock source
                                        This parameter can be a value of @ref RCCEx_LPUART1_Clock_Source */

  uint32_t LtdcClockSelection;     /*!< Specifies LPUART1 clock source
                                        This parameter can be a value of @ref RCCEx_LTDC_Clock_Source */

  uint32_t PssiClockSelection;     /*!< Specifies PSSI clock source
                                        This parameter can be a value of @ref RCCEx_PSSI_Clock_Source   */

  uint32_t Sai1ClockSelection;     /*!< Specifies SAI1 clock source
                                        This parameter can be a value of @ref RCCEx_SAI1_Clock_Source    */

  uint32_t Sai2ClockSelection;     /*!< Specifies SAI2 clock source
                                        This parameter can be a value of @ref RCCEx_SAI2_Clock_Source    */

  uint32_t Sdmmc12ClockSelection;  /*!< Specifies SDMMC clock source
                                        This parameter can be a value of @ref RCCEx_SDMMC12_Clock_Source  */

  uint32_t Spi1ClockSelection;     /*!< Specifies SPI1 clock source
                                        This parameter can be a value of @ref RCCEx_SPI1_Clock_Source    */

  uint32_t Spi23ClockSelection;    /*!< Specifies SPI2/SPI3 clock source
                                        This parameter can be a value of @ref RCCEx_SPI23_Clock_Source    */

  uint32_t Spi45ClockSelection;    /*!< Specifies SPI4/SPI5 clock source
                                        This parameter can be a value of @ref RCCEx_SPI45_Clock_Source    */

  uint32_t Spi6ClockSelection;     /*!< Specifies SPI6 clock source
                                        This parameter can be a value of @ref RCCEx_SPI6_Clock_Source    */

  uint32_t SpdifrxClockSelection;  /*!< Specifies SPDIFRX Clock clock source
                                        This parameter can be a value of @ref RCCEx_SPDIFRX_Clock_Source */

  uint32_t Usart1ClockSelection;   /*!< Specifies USART1 clock source
                                        This parameter can be a value of @ref RCCEx_USART1_Clock_Source  */

  uint32_t Usart234578ClockSelection; /*!< Specifies USART2/USART3/UART4/UART5/UART7/UART8 clock source
                                           This parameter can be a value of @ref RCCEx_USART234578_Clock_Source  */

  uint32_t UsbPhycClockSelection;  /*!< Specifies USB PHYC clock source
                                        This parameter can be a value of @ref RCCEx_USB_PHYC_Clock_Source */

  uint32_t UsbRefClockSelection;  /*!< Specifies USB REF clock frequency.
                                        This parameter can be a value of @ref RCCEx_USB_REF_Clock_Source */

  uint32_t UsbOtgFsClockSelection; /*!< Specifies USB OTG FS clock source
                                        This parameter can be a value of @ref RCCEx_USB_OTGFS_Clock_Source */

  uint32_t RTCClockSelection;      /*!< Specifies RTC Clock clock source
                                        This parameter can be a value of @ref RCC_RTC_Clock_Source       */

  uint32_t TIMPresSelection;       /*!< Specifies TIM Clock Prescalers Selection.
                                        This parameter can be a value of @ref RCCEx_TIM_Prescaler_Selection */
} RCC_PeriphCLKInitTypeDef;

typedef struct
{
  uint32_t Prescaler;              /*!< Specifies the division factor of the SYNC signal.
                                        This parameter can be a value of @ref RCCEx_CRS_SynchroDivider  */

  uint32_t Source;                 /*!< Specifies the SYNC signal source.
                                        This parameter can be a value of @ref RCCEx_CRS_SynchroSource   */

  uint32_t Polarity;               /*!< Specifies the input polarity for the SYNC signal source.
                                        This parameter can be a value of @ref RCCEx_CRS_SynchroPolarity */

  uint32_t ReloadValue;            /*!< Specifies the value to be loaded in the frequency error counter with each SYNC event.
                                        It can be calculated in using macro __HAL_RCC_CRS_RELOADVALUE_CALCULATE(__FTARGET__, __FSYNC__)
                                        This parameter must be a number between 0 and 0xFFFF or a value of @ref RCCEx_CRS_ReloadValueDefault .*/

  uint32_t ErrorLimitValue;        /*!< Specifies the value to be used to evaluate the captured frequency error value.
                                        This parameter must be a number between 0 and 0xFF or a value of @ref RCCEx_CRS_ErrorLimitDefault */

  uint32_t HSI48CalibrationValue;  /*!< Specifies a user-programmable trimming value to the HSI48 oscillator.
                                        This parameter must be a number between 0 and 0x3F or a value of @ref RCCEx_CRS_HSI48CalibrationDefault */

} RCC_CRSInitTypeDef;

typedef struct
{
  uint32_t ReloadValue;            /*!< Specifies the value loaded in the Counter reload value.
                                        This parameter must be a number between 0 and 0xFFFF */

  uint32_t HSI48CalibrationValue;  /*!< Specifies value loaded in HSI48 oscillator smooth trimming.
                                        This parameter must be a number between 0 and 0x3F */

  uint32_t FreqErrorCapture;       /*!< Specifies the value loaded in the .FECAP, the frequency error counter
                                        value latched in the time of the last SYNC event.
                                        This parameter must be a number between 0 and 0xFFFF */

  uint32_t FreqErrorDirection;     /*!< Specifies the value loaded in the .FEDIR, the counting direction of the
                                        frequency error counter latched in the time of the last SYNC event.
                                        It shows whether the actual frequency is below or above the target.
                                        This parameter must be a value of @ref RCCEx_CRS_FreqErrorDirection*/

} RCC_CRSSynchroInfoTypeDef;
#endif
