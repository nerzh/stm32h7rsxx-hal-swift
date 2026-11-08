// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Original utility and bus types from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// ErrorStatus from CMSIS stm32h7rsxx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
#include <stdint.h>
#include "include/CI3CReference.h"
#define USE_FULL_LL_DRIVER
// Only the two bus-configuration types are needed; no peripheral is accessed.
#define STM32H7RSxx_LL_I3C_H
typedef enum
{
  SUCCESS = 0,
  ERROR = !SUCCESS
} ErrorStatus;
#define I3C_TIMINGR1_SDA_HD_Pos 28U
typedef struct
{
  uint32_t SDAHoldTime;         /*!< Specifies the I3C SDA hold time.
                                     This parameter must be a value of @ref I3C_LL_EC_SDA_HOLD_TIME                   */

  uint32_t WaitTime;            /*!< Specifies the time that the main and the new controllers should wait before
                                     issuing a start.
                                     This parameter must be a value of @ref I3C_LL_EC_OWN_ACTIVITY_STATE              */

  uint8_t SCLPPLowDuration;     /*!< Specifies the I3C SCL low duration in number of kernel clock cycles
                                     in I3C push-pull phases.
                                     This parameter must be a number between Min_Data=0 and Max_Data=0xFF.            */

  uint8_t SCLI3CHighDuration;   /*!< Specifies the I3C SCL high duration in number of kernel clock cycles,
                                     used for I3C messages for I3C open-drain and push pull phases.
                                     This parameter must be a number between Min_Data=0 and Max_Data=0xFF.            */

  uint8_t SCLODLowDuration;     /*!< Specifies the I3C SCL low duration in number of kernel clock cycles in
                                     open-drain phases, used for legacy I2C commands and for I3C open-drain phases.
                                     This parameter must be a number between Min_Data=0 and Max_Data=0xFF.            */

  uint8_t SCLI2CHighDuration;   /*!< Specifies the I3C SCL high duration in number of kernel clock cycles, used
                                     for legacy I2C commands.
                                     This parameter must be a number between Min_Data=0 and Max_Data=0xFF.            */

  uint8_t BusFreeDuration;      /*!< Specifies the I3C controller duration in number of kernel clock cycles, after
                                     a stop and before a start.
                                     This parameter must be a number between Min_Data=0 and Max_Data=0xFF.            */

  uint8_t BusIdleDuration;      /*!< Specifies the I3C controller duration in number of kernel clock cycles to be
                                     elapsed, after that both SDA and SCL are continuously high and stable
                                     before issuing a hot-join event.
                                     This parameter must be a number between Min_Data=0 and Max_Data=0xFF.            */
} LL_I3C_CtrlBusConfTypeDef;
/**
  * @}
  */

/** @defgroup I3C_LL_ES_TARGET_BUS_CONFIG_STRUCTURE_DEFINITION I3C Target Bus Configuration Structure definition
  * @brief    I3C LL Target Bus Configuration Structure definition
  * @{
  */
typedef struct
{
  uint8_t BusAvailableDuration; /*!< Specifies the I3C target duration in number of kernel clock cycles, when
                                     the SDA and the SCL are high for at least taval.
                                     This parameter must be a number between Min_Data=0 and Max_Data=0xFF.            */
} LL_I3C_TgtBusConfTypeDef;
#include "Upstream/I3CTiming.inc"

uint32_t CI3C_ControllerTiming(const uint32_t *input, uint32_t *output) {
  I3C_CtrlTimingTypeDef timing = {input[0], input[1], input[2], input[3], input[4]};
  LL_I3C_CtrlBusConfTypeDef config = {
    output[0], output[1], (uint8_t)output[2], (uint8_t)output[3],
    (uint8_t)output[4], (uint8_t)output[5], (uint8_t)output[6], (uint8_t)output[7]
  };
  ErrorStatus status = I3C_CtrlTimingComputation(&timing, &config);
  output[0] = config.SDAHoldTime;
  output[1] = config.WaitTime;
  output[2] = config.SCLPPLowDuration;
  output[3] = config.SCLI3CHighDuration;
  output[4] = config.SCLODLowDuration;
  output[5] = config.SCLI2CHighDuration;
  output[6] = config.BusFreeDuration;
  output[7] = config.BusIdleDuration;
  return status;
}

uint32_t CI3C_TargetTiming(uint32_t clock, uint8_t *output) {
  I3C_TgtTimingTypeDef timing = {clock};
  LL_I3C_TgtBusConfTypeDef config = {*output};
  ErrorStatus status = I3C_TgtTimingComputation(&timing, &config);
  *output = config.BusAvailableDuration;
  return status;
}
