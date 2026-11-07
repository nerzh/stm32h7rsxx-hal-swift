/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Unchanged declarations/bodies/macros extracted from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748. Host substitutions are in the shim.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#ifndef C_RCC_CONTROL_TYPES_H
#define C_RCC_CONTROL_TYPES_H
#include <stdint.h>
typedef struct
{
  uint32_t PLLState;   /*!< The new state of the PLL.
                            This parameter can be a value of @ref RCC_PLL_Config                      */

  uint32_t PLLSource;  /*!< PLL entry clock source.
                            This parameter must be a value of @ref RCC_PLL_Clock_Source               */

  uint32_t PLLM;       /*!< Division factor for PLL VCO input clock.
                            This parameter must be a number between Min_Data = 1 and Max_Data = 63    */

  uint32_t PLLN;       /*!< Multiplication factor for PLL VCO output clock.
                            This parameter must be a number between Min_Data = 8 and Max_Data = 420   */

  uint32_t PLLP;       /*!< Division factor for system clock.
                            This parameter must be a number between Min_Data = 1 and Max_Data = 128
                            Odd division factors (except for 1) are not allowed                                      */

  uint32_t PLLQ;       /*!< Division factor for peripheral clocks.
                            This parameter must be a number between Min_Data = 1 and Max_Data = 128   */

  uint32_t PLLR;       /*!< Division factor for peripheral clocks.
                            This parameter must be a number between Min_Data = 1 and Max_Data = 128   */

  uint32_t PLLS;       /*!< Division factor for peripheral clocks.
                            This parameter must be a number between Min_Data = 1 and Max_Data = 8     */

  uint32_t PLLT;       /*!< Division factor for peripheral clocks.
                            This parameter must be a number between Min_Data = 1 and Max_Data = 8     */

  uint32_t PLLFractional;   /*!< Fractional Part of the Multiplication Factor for PLL VCO.
                            This parameter must be a number  between 0 and 8191                       */

} RCC_PLLInitTypeDef;

typedef struct
{
  uint32_t OscillatorType;       /*!< The oscillators to be configured.
                                      This parameter can be a value of @ref RCC_Oscillator_Type                   */

  uint32_t HSEState;             /*!< The new state of the HSE.
                                      This parameter can be a value of @ref RCC_HSE_Config                        */

  uint32_t LSEState;             /*!< The new state of the LSE.
                                      This parameter can be a value of @ref RCC_LSE_Config                        */

  uint32_t HSIState;             /*!< The new state of the HSI.
                                      This parameter can be a value of @ref RCC_HSI_Config                        */

  uint32_t HSIDiv;               /*!< The division factor of the HSI.
                                      This parameter can be a value of @ref RCC_HSI_Divider                       */

  uint32_t HSICalibrationValue;  /*!< The calibration trimming value.
                                      This parameter must be a number between Min_Data = 0x00 and Max_Data = 0x7F */

  uint32_t LSIState;             /*!< The new state of the LSI.
                                      This parameter can be a value of @ref RCC_LSI_Config                        */

  uint32_t HSI48State;           /*!< The new state of the HSI48.
                                      This parameter can be a value of @ref RCC_HSI48_Config                      */

  uint32_t CSIState;             /*!< The new state of the CSI.
                                      This parameter can be a value of @ref RCC_CSI_Config                        */

  RCC_PLLInitTypeDef PLL1;       /*!< Main PLL1 structure parameters                                              */

  RCC_PLLInitTypeDef PLL2;       /*!< PLL2 structure parameters                                                   */

  RCC_PLLInitTypeDef PLL3;       /*!< PLL3 structure parameters                                                   */

} RCC_OscInitTypeDef;

typedef struct
{
  uint32_t ClockType;             /*!< The clock to be configured.
                                       This parameter can be a value of @ref RCC_System_Clock_Type                        */

  uint32_t SYSCLKSource;          /*!< The clock source used as system clock (SYSCLK).
                                       This parameter can be a value of @ref RCC_System_Clock_Source                      */

  uint32_t SYSCLKDivider;         /*!< The system clock divider for CPU clock and all bus matrix clocks.
                                       This parameter can be a value of @ref RCC_System_Clock_Divider                     */

  uint32_t AHBCLKDivider;         /*!< The AHB/AXI clock divider for HCLK.
                                       This clock is derived from the system clock divided by the system clock divider.
                                       This parameter can be a value of @ref RCC_HCLK_Clock_Source                        */

  uint32_t APB1CLKDivider;        /*!< The APB1 clock divider for PCLK1.
                                       This clock is derived from the AHB clock (HCLK).
                                       This parameter can be a value of @ref RCC_APB1_Clock_Source                        */

  uint32_t APB2CLKDivider;        /*!< The APB2 clock divider for PCLK2.
                                       This clock is derived from the AHB clock (HCLK).
                                       This parameter can be a value of @ref RCC_APB2_Clock_Source                        */

  uint32_t APB4CLKDivider;        /*!< The APB4 clock divider for PCLK4.
                                       This clock is derived from the AHB clock (HCLK).
                                       This parameter can be a value of @ref RCC_APB4_Clock_Source                        */

  uint32_t APB5CLKDivider;        /*!< The APB5 clock divider for PCLK5.
                                       This clock is derived from the AHB clock (HCLK).
                                       This parameter can be a value of @ref RCC_APB5_Clock_Source                        */

} RCC_ClkInitTypeDef;
#endif
