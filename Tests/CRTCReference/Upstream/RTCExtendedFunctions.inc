/**
  ******************************************************************************
  * @file    stm32h7rsxx_hal_rtc_ex.c
  * @author  GPM Application Team
  * @brief   Extended RTC HAL module driver.
  *          This file provides firmware functions to manage the following
  *          functionalities of the Real Time Clock (RTC) Extended peripheral:
  *           + RTC Time Stamp functions
  *           + RTC Tamper functions
  *           + RTC Wake-up functions
  *           + Extended Control functions
  *           + Extended RTC features functions
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
    (+) Enable the RTC domain access.
    (+) Configure the RTC Prescaler (Asynchronous and Synchronous) and RTC hour
        format using the HAL_RTC_Init() function.

  *** RTC Wakeup configuration ***
  ================================
  [..]
    (+) To configure the RTC Wakeup Clock source and Counter use the HAL_RTCEx_SetWakeUpTimer()
        function. You can also configure the RTC Wakeup timer with interrupt mode
        using the HAL_RTCEx_SetWakeUpTimer_IT() function.
    (+) To read the RTC WakeUp Counter register, use the HAL_RTCEx_GetWakeUpTimer()
        function.

  *** Outputs configuration ***
  =============================
  [..]  The RTC has 2 outputs pins (RTC_OUT1 & RTC_OUT2).
        To configure the outputs, use the HAL_RTC_Init() function.
    (+) RTC_OUT1 and RTC_OUT2 which select one of the following two outputs:
    (+) CALIB: 512Hz or 1Hz clock output (with an LSE frequency of 32.768kHz).
        To enable the CALIB, use the HAL_RTCEx_SetCalibrationOutPut() function.
    (+) TAMPALRM: This output is the OR between rtc_tamp_evt and ALARM signals.
        ALARM is enabled by configuring the OSEL[1:0] bits in the RTC_CR register
        which select the alarm A, alarm B or wakeup outputs.
        rtc_tamp_evt is enabled by setting the TAMPOE bit
        in the RTC_CR register which selects the tamper event outputs.

  *** Smooth digital Calibration configuration ***
  ================================================
  [..]
    (+) Configure the RTC Original Digital Calibration Value and the corresponding
        calibration cycle period (32s,16s and 8s) using the HAL_RTCEx_SetSmoothCalib()
        function.

  *** RTC synchronization ***
  ================================================
  [..]
    (+) The RTC can be finely adjusted using HAL_RTCEx_SetSynchroShift() function.
        Writing to RTC_SHIFTR can shift (either delay or advance) the clock with
        a resolution of 1 ck_apre period.
        The shift operation consists in adding the SUBFS[14:0] value to the synchronous
        prescaler counter SS[15:0]: this delays the clock.

  *** Bypass shadow registers ***
  ================================================
  [..]
    (+) Enable bypass shadow registers using the HAL_RTCEx_EnableBypassShadow().
        When the Bypass Shadow is enabled the calendar value are taken directly
        from the Calendar counter.
        Thus eliminating the need to wait for the RSF bit to be set.
        This is especially useful after exiting from low-power modes (Stop or Standby),
        since the shadow registers are not updated during these modes.

  *** RTC ultra-low-power mode ***
  ================================================
  [..]
    (+) Configure the RTC ultra-low-power mode using HAL_RTCEx_SetLowPowerCalib() function.
        In this case, the calibration mechanism is applied on ck_apre instead of RTCCLK.
        The resulting accuracy is the same, but the calibration is performed during a
        calibration cycle of about 220 x PREDIV_A x RTCCLK pulses instead of 220 RTCCLK pulses.

  *** RTC subsecond register underflow interruption ***
  ================================================
  [..]
    (+) Enable the RTC SSRU interruption mode using HAL_RTCEx_SetSSRU_IT() function.
        In this case, when the SSR rolls under 0, an SSRU interruption is triggered.
        Disable the RTC SSRU interruption mode using HAL_RTCEx_DeactivateSSRU() function.

  *** TimeStamp configuration ***
  ===============================
  [..]
    (+) Enable the RTC TimeStamp using the HAL_RTCEx_SetTimeStamp() function.
        You can also configure the RTC TimeStamp with interrupt mode using the
        HAL_RTCEx_SetTimeStamp_IT() function.
    (+) To read the RTC TimeStamp Time and Date register, use the HAL_RTCEx_GetTimeStamp()
        function.

  *** Internal TimeStamp configuration ***
  ===============================
  [..]
    (+) Enable the RTC internal TimeStamp using the HAL_RTCEx_SetInternalTimeStamp() function.
        User has to check internal timestamp occurrence using __HAL_RTC_INTERNAL_TIMESTAMP_GET_FLAG.
    (+) To read the RTC TimeStamp Time and Date register, use the HAL_RTCEx_GetTimeStamp()
        function.

   *** Tamper configuration ***
   ============================
   [..]
     (+) Enable the RTC Tamper and configure the Tamper filter count, trigger Edge
         or Level according to the Tamper filter (if equal to 0 Edge else Level)
         value, sampling frequency, NoErase, MaskFlag,  precharge or discharge and
         Pull-UP using the HAL_RTCEx_SetTamper() function. You can configure RTC Tamper
         with interrupt mode using HAL_RTCEx_SetTamper_IT() function.
     (+) The default configuration of the Tamper erases the backup registers. To avoid
         erase, enable the TAMPxPOM field on the TAMP_CR2 register.
     (+) With new RTC tamper configuration, you have to call HAL_RTC_Init() in order to
         perform TAMP base address offset calculation.
     (+) Enable Internal tamper using HAL_RTCEx_SetInternalTamper. IT mode can be chosen using
         setting Interrupt field.

   *** Backup Data Registers and Device Secrets configuration ***
   ===========================================
   [..]
     (+) To write to the RTC Backup Data registers, use the HAL_RTCEx_BKUPWrite()
         function.
     (+) To read the RTC Backup registers, use the HAL_RTCEx_BKUPRead()
         function.
     (+) To reset the RTC Backup registers and erase the device secrets,
         use HAL_RTCEx_BKUPErase() function.
     (+) Enable the lock of the Boot hardware Key using the HAL_RTCEx_LockBootHardwareKey()
         function.
         The backup registers from TAMP_BKP0R to TAMP_BKP7R cannot be accessed neither in
         read nor in write (they are read as 0 and write ignore).
     (+) Configure the erase of the Device Secrets using HAL_RTCEx_ConfigEraseDeviceSecrets()
         function.
     (+) Block the access to the RTC Backup registers and all the device secrets
         using HAL_RTCEx_BKUPBlock() function.

  *** Monotonic counter ***
  ================================================
  [..]
     (+) To increment the Monotonic counter, use the HAL_RTCEx_MonotonicCounterIncrement()
         function.
     (+) To get the current value of the Monotonic counter, use the HAL_RTCEx_MonotonicCounterGet()
         function.

  *** RTC & TAMP privilege protection modes ***
  ================================================
  [..]
     (+) Set the privilege level of the RTC/TAMP/Backup registers using HAL_RTCEx_PrivilegeModeSet()
         function.
      +) Get the privilege level of the RTC/TAMP/Backup registers using HAL_RTCEx_PrivilegeModeGet()
         function.

  @endverbatim
  */


HAL_StatusTypeDef HAL_RTCEx_SetTimeStamp(RTC_HandleTypeDef *hrtc, uint32_t TimeStampEdge, uint32_t RTC_TimeStampPin)
{
  /* Check the parameters */
#if defined(RTC_CR_TSEDGE)
  assert_param(IS_TIMESTAMP_EDGE(TimeStampEdge));
#endif /* RTC_CR_TSEDGE */
  assert_param(IS_RTC_TIMESTAMP_PIN(RTC_TimeStampPin));
  UNUSED(RTC_TimeStampPin);

  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Get the RTC_CR register and clear the bits to be configured */
#if defined(RTC_CR_TSEDGE)
  CLEAR_BIT(RTC->CR, (RTC_CR_TSEDGE | RTC_CR_TSE));
#else
  CLEAR_BIT(RTC->CR, RTC_CR_TSE);
#endif /* RTC_CR_TSEDGE */

  /* Configure the Time Stamp TSEDGE and Enable bits */
  SET_BIT(RTC->CR, (uint32_t)TimeStampEdge | RTC_CR_TSE);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetTimeStamp_IT(RTC_HandleTypeDef *hrtc, uint32_t TimeStampEdge, uint32_t RTC_TimeStampPin)
{
  /* Check the parameters */
#if defined(RTC_CR_TSEDGE)
  assert_param(IS_TIMESTAMP_EDGE(TimeStampEdge));
#endif /* RTC_CR_TSEDGE */
  assert_param(IS_RTC_TIMESTAMP_PIN(RTC_TimeStampPin));
  UNUSED(RTC_TimeStampPin);

  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Get the RTC_CR register and clear the bits to be configured */
#if defined(RTC_CR_TSEDGE)
  CLEAR_BIT(RTC->CR, (RTC_CR_TSEDGE | RTC_CR_TSE | RTC_CR_TSIE));
#else
  CLEAR_BIT(RTC->CR, (RTC_CR_TSE | RTC_CR_TSIE));
#endif /* RTC_CR_TSEDGE */

  /* Configure the Time Stamp TSEDGE before Enable bit to avoid unwanted TSF setting. */
  SET_BIT(RTC->CR, (uint32_t)TimeStampEdge);

  /* Enable timestamp and IT */
  SET_BIT(RTC->CR, RTC_CR_TSE | RTC_CR_TSIE);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_DeactivateTimeStamp(RTC_HandleTypeDef *hrtc)
{
  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* In case of interrupt mode is used, the interrupt source must disabled */
#if defined(RTC_CR_TSEDGE)
  CLEAR_BIT(RTC->CR, (RTC_CR_TSEDGE | RTC_CR_TSE | RTC_CR_TSIE));
#else
  CLEAR_BIT(RTC->CR, (RTC_CR_TSE | RTC_CR_TSIE));
#endif /* RTC_CR_TSEDGE */

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetInternalTimeStamp(RTC_HandleTypeDef *hrtc)
{
  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Configure the internal Time Stamp Enable bits */
  SET_BIT(RTC->CR, RTC_CR_ITSE);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_DeactivateInternalTimeStamp(RTC_HandleTypeDef *hrtc)
{
  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Configure the internal Time Stamp Enable bits */
  CLEAR_BIT(RTC->CR, RTC_CR_ITSE);

  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_GetTimeStamp(const RTC_HandleTypeDef *hrtc, RTC_TimeTypeDef *sTimeStamp,
                                         RTC_DateTypeDef *sTimeStampDate, uint32_t Format)
{
  uint32_t tmptime;
  uint32_t tmpdate;

  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  /* Check the parameters */
  assert_param(IS_RTC_FORMAT(Format));

  /* Get the TimeStamp time and date registers values */
  tmptime = READ_BIT(RTC->TSTR, RTC_TR_RESERVED_MASK);
  tmpdate = READ_BIT(RTC->TSDR, RTC_DR_RESERVED_MASK);

  /* Fill the Time structure fields with the read parameters */
  sTimeStamp->Hours = (uint8_t)((tmptime & (RTC_TSTR_HT | RTC_TSTR_HU)) >> RTC_TSTR_HU_Pos);
  sTimeStamp->Minutes = (uint8_t)((tmptime & (RTC_TSTR_MNT | RTC_TSTR_MNU)) >> RTC_TSTR_MNU_Pos);
  sTimeStamp->Seconds = (uint8_t)((tmptime & (RTC_TSTR_ST | RTC_TSTR_SU)) >> RTC_TSTR_SU_Pos);
  sTimeStamp->TimeFormat = (uint8_t)((tmptime & (RTC_TSTR_PM)) >> RTC_TSTR_PM_Pos);
  sTimeStamp->SubSeconds = READ_BIT(RTC->TSSSR, RTC_TSSSR_SS);

  /* Fill the Date structure fields with the read parameters */
  sTimeStampDate->Year = 0U;
  sTimeStampDate->Month = (uint8_t)((tmpdate & (RTC_TSDR_MT | RTC_TSDR_MU)) >> RTC_TSDR_MU_Pos);
  sTimeStampDate->Date = (uint8_t)(tmpdate & (RTC_TSDR_DT | RTC_TSDR_DU));
  sTimeStampDate->WeekDay = (uint8_t)((tmpdate & (RTC_TSDR_WDU)) >> RTC_TSDR_WDU_Pos);

  /* Check the input parameters format */
  if (Format == RTC_FORMAT_BIN)
  {
    /* Convert the TimeStamp structure parameters to Binary format */
    sTimeStamp->Hours = (uint8_t)RTC_Bcd2ToByte(sTimeStamp->Hours);
    sTimeStamp->Minutes = (uint8_t)RTC_Bcd2ToByte(sTimeStamp->Minutes);
    sTimeStamp->Seconds = (uint8_t)RTC_Bcd2ToByte(sTimeStamp->Seconds);

    /* Convert the DateTimeStamp structure parameters to Binary format */
    sTimeStampDate->Month = (uint8_t)RTC_Bcd2ToByte(sTimeStampDate->Month);
    sTimeStampDate->Date = (uint8_t)RTC_Bcd2ToByte(sTimeStampDate->Date);
    sTimeStampDate->WeekDay = (uint8_t)RTC_Bcd2ToByte(sTimeStampDate->WeekDay);
  }

  /* Check if TIMESTAMP flag is set */
  if (READ_BIT(RTC->SR, RTC_SR_TSF) != 0U)
  {
    /* Clear the TIMESTAMP Flags */
    WRITE_REG(RTC->SCR, (RTC_SCR_CITSF | RTC_SCR_CTSF));

    /* Check if TIMESTAMP OverRun flag is set */
    if (READ_BIT(RTC->SR, RTC_SR_TSOVF) != 0U)
    {
      /* Clear the TIMESTAMP OverRun Flag */
      WRITE_REG(RTC->SCR, RTC_SCR_CTSOVF);

      return HAL_ERROR;
    }
  }

  return HAL_OK;
}

void HAL_RTCEx_TimeStampIRQHandler(RTC_HandleTypeDef *hrtc)
{
  /* Get the pending status of the TimeStamp Interrupt */
  if (READ_BIT(RTC->MISR, RTC_MISR_TSMF) != 0U)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call TimeStampEvent registered Callback */
    hrtc->TimeStampEventCallback(hrtc);
#else
    HAL_RTCEx_TimeStampEventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */

    /* Clearing flags after the Callback because the content of RTC_TSTR and RTC_TSDR are cleared when
       TSF bit is reset.*/
    WRITE_REG(RTC->SCR, RTC_SCR_CITSF | RTC_SCR_CTSF);
  }

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;
}

HAL_StatusTypeDef HAL_RTCEx_PollForTimeStampEvent(const RTC_HandleTypeDef *hrtc, uint32_t Timeout)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  uint32_t tickstart = HAL_GetTick();

  while (READ_BIT(RTC->SR, RTC_SR_TSF) == 0U)
  {
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        /* New check to avoid false timeout detection in case of preemption */
        if (READ_BIT(RTC->SR, RTC_SR_TSF) == 0U)
        {
          return HAL_TIMEOUT;
        }
        else
        {
          break;
        }
      }
    }
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetWakeUpTimer(RTC_HandleTypeDef *hrtc, uint32_t WakeUpCounter, uint32_t WakeUpClock)
{
  uint32_t tickstart;

  /* Check the parameters */
  assert_param(IS_RTC_WAKEUP_CLOCK(WakeUpClock));
  assert_param(IS_RTC_WAKEUP_COUNTER(WakeUpCounter));

  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Clear WUTE in RTC_CR to disable the wakeup timer */
  CLEAR_BIT(RTC->CR, RTC_CR_WUTE);

  /* Poll WUTWF until it is set in RTC_ICSR to make sure the access to wakeup autoreload
     counter and to WUCKSEL[2:0] bits is allowed. This step must be skipped in
     calendar initialization mode. */
  if (READ_BIT(RTC->ICSR, RTC_ICSR_INITF) == 0U)
  {
    tickstart = HAL_GetTick();

    while (READ_BIT(RTC->ICSR, RTC_ICSR_WUTWF) == 0U)
    {
      if ((HAL_GetTick() - tickstart) > RTC_TIMEOUT_VALUE)
      {
        /* New check to avoid false timeout detection in case of preemption */
        if (READ_BIT(RTC->ICSR, RTC_ICSR_WUTWF) == 0U)
        {
          /* Change RTC state */
          hrtc->State = HAL_RTC_STATE_TIMEOUT;

          /* Process Unlocked */
          __HAL_UNLOCK(hrtc);

          return HAL_TIMEOUT;
        }
        else
        {
          break;
        }
      }
    }
  }

  /* Configure the clock source */
  MODIFY_REG(RTC->CR, RTC_CR_WUCKSEL, (uint32_t)WakeUpClock);

  /* Configure the Wakeup Timer counter */
  WRITE_REG(RTC->WUTR, (uint32_t)WakeUpCounter);

  /* Enable the Wakeup Timer */
  SET_BIT(RTC->CR, RTC_CR_WUTE);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetWakeUpTimer_IT(RTC_HandleTypeDef *hrtc, uint32_t WakeUpCounter, uint32_t WakeUpClock,
                                              uint32_t WakeUpAutoClr)
{
  uint32_t tickstart;

  /* Check the parameters */
  assert_param(IS_RTC_WAKEUP_CLOCK(WakeUpClock));
  assert_param(IS_RTC_WAKEUP_COUNTER(WakeUpCounter));
  /* (0x0000<=WUTOCLR<=WUT) */
  assert_param(WakeUpAutoClr <= WakeUpCounter);

  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Clear WUTE in RTC_CR to disable the wakeup timer */
  CLEAR_BIT(RTC->CR, RTC_CR_WUTE);

  /* Clear flag Wake-Up */
  WRITE_REG(RTC->SCR, RTC_SCR_CWUTF);

  /* Poll WUTWF until it is set in RTC_ICSR to make sure the access to wakeup autoreload
     counter and to WUCKSEL[2:0] bits is allowed. This step must be skipped in
     calendar initialization mode. */
  if (READ_BIT(RTC->ICSR, RTC_ICSR_INITF) == 0U)
  {
    tickstart = HAL_GetTick();
    while (READ_BIT(RTC->ICSR, RTC_ICSR_WUTWF) == 0U)
    {
      if ((HAL_GetTick() - tickstart) > RTC_TIMEOUT_VALUE)
      {
        /* New check to avoid false timeout detection in case of preemption */
        if (READ_BIT(RTC->ICSR, RTC_ICSR_WUTWF) == 0U)
        {
          /* Change RTC state */
          hrtc->State = HAL_RTC_STATE_TIMEOUT;

          /* Process Unlocked */
          __HAL_UNLOCK(hrtc);

          return HAL_TIMEOUT;
        }
        else
        {
          break;
        }
      }
    }
  }

  /* Configure the Wakeup Timer counter and auto clear value */
  WRITE_REG(RTC->WUTR, (uint32_t)(WakeUpCounter | (WakeUpAutoClr << RTC_WUTR_WUTOCLR_Pos)));

  /* Configure the clock source */
  MODIFY_REG(RTC->CR, RTC_CR_WUCKSEL, (uint32_t)WakeUpClock);

  /* Configure the Interrupt in the RTC_CR register and Enable the Wakeup Timer*/
  SET_BIT(RTC->CR, (RTC_CR_WUTIE | RTC_CR_WUTE));

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_DeactivateWakeUpTimer(RTC_HandleTypeDef *hrtc)
{
  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Disable the Wakeup Timer */
  /* In case of interrupt mode is used, the interrupt source must disabled */
  CLEAR_BIT(RTC->CR, (RTC_CR_WUTE | RTC_CR_WUTIE));

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

uint32_t HAL_RTCEx_GetWakeUpTimer(const RTC_HandleTypeDef *hrtc)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  /* Get the counter value */
  return (uint32_t)(READ_BIT(RTC->WUTR, RTC_WUTR_WUT));
}

void HAL_RTCEx_WakeUpTimerIRQHandler(RTC_HandleTypeDef *hrtc)
{
  /* Get the pending status of the Wake-Up Timer Interrupt */
  if (READ_BIT(RTC->MISR, RTC_MISR_WUTMF) != 0U)
  {
    /* Immediately clear flags */
    WRITE_REG(RTC->SCR, RTC_SCR_CWUTF);
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call wake up timer registered Callback */
    hrtc->WakeUpTimerEventCallback(hrtc);
#else
    HAL_RTCEx_WakeUpTimerEventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;
}

HAL_StatusTypeDef HAL_RTCEx_PollForWakeUpTimerEvent(const RTC_HandleTypeDef *hrtc, uint32_t Timeout)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  uint32_t tickstart = HAL_GetTick();

  while (READ_BIT(RTC->SR, RTC_SR_WUTF) == 0U)
  {
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        /* New check to avoid false timeout detection in case of preemption */
        if (READ_BIT(RTC->SR, RTC_SR_WUTF) == 0U)
        {
          return HAL_TIMEOUT;
        }
        else
        {
          break;
        }
      }
    }
  }

  /* Clear the WAKEUPTIMER Flag */
  WRITE_REG(RTC->SCR, RTC_SCR_CWUTF);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetSmoothCalib(RTC_HandleTypeDef *hrtc, uint32_t SmoothCalibPeriod,
                                           uint32_t SmoothCalibPlusPulses, uint32_t SmoothCalibMinusPulsesValue)
{
  uint32_t tickstart;

  /* Check the parameters */
  assert_param(IS_RTC_SMOOTH_CALIB_PERIOD(SmoothCalibPeriod));
  assert_param(IS_RTC_SMOOTH_CALIB_PLUS(SmoothCalibPlusPulses));
  assert_param(IS_RTC_SMOOTH_CALIB_MINUS(SmoothCalibMinusPulsesValue));

  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  tickstart = HAL_GetTick();

  /* check if a calibration is pending */
  while (READ_BIT(RTC->ICSR, RTC_ICSR_RECALPF) != 0U)
  {
    if ((HAL_GetTick() - tickstart) > RTC_TIMEOUT_VALUE)
    {
      /* New check to avoid false timeout detection in case of preemption */
      if (READ_BIT(RTC->ICSR, RTC_ICSR_RECALPF) != 0U)
      {

        /* Change RTC state */
        hrtc->State = HAL_RTC_STATE_TIMEOUT;

        /* Process Unlocked */
        __HAL_UNLOCK(hrtc);

        return HAL_TIMEOUT;
      }
      else
      {
        break;
      }
    }
  }

  /* Disable the write protection for RTC registers */
  __HAL_RTC_WRITEPROTECTION_DISABLE(hrtc);

  /* Configure the Smooth calibration settings */
  MODIFY_REG(RTC->CALR, (RTC_CALR_CALP | RTC_CALR_CALW8 | RTC_CALR_CALW16 | RTC_CALR_CALM),
             (uint32_t)(SmoothCalibPeriod | SmoothCalibPlusPulses | SmoothCalibMinusPulsesValue));

  /* Enable the write protection for RTC registers */
  __HAL_RTC_WRITEPROTECTION_ENABLE(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetLowPowerCalib(RTC_HandleTypeDef *hrtc, uint32_t LowPowerCalib)
{
  /* Check the parameters */
  assert_param(IS_RTC_LOW_POWER_CALIB(LowPowerCalib));

  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Disable the write protection for RTC registers */
  __HAL_RTC_WRITEPROTECTION_DISABLE(hrtc);

  /* Configure the Smooth calibration settings */
  MODIFY_REG(RTC->CALR, RTC_CALR_LPCAL, LowPowerCalib);

  /* Enable the write protection for RTC registers */
  __HAL_RTC_WRITEPROTECTION_ENABLE(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetSynchroShift(RTC_HandleTypeDef *hrtc, uint32_t ShiftAdd1S, uint32_t ShiftSubFS)
{
  uint32_t tickstart;

  /* Check the parameters */
  assert_param(IS_RTC_SHIFT_ADD1S(ShiftAdd1S));
  assert_param(IS_RTC_SHIFT_SUBFS(ShiftSubFS));

  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  tickstart = HAL_GetTick();

  /* Wait until the shift is completed */
  while (READ_BIT(RTC->ICSR, RTC_ICSR_SHPF) != 0U)
  {
    if ((HAL_GetTick() - tickstart) > RTC_TIMEOUT_VALUE)
    {
      /* New check to avoid false timeout detection in case of preemption */
      if (READ_BIT(RTC->ICSR, RTC_ICSR_SHPF) != 0U)
      {
        /* Change RTC state */
        hrtc->State = HAL_RTC_STATE_TIMEOUT;

        /* Process Unlocked */
        __HAL_UNLOCK(hrtc);

        return HAL_TIMEOUT;
      }
      else
      {
        break;
      }
    }
  }

  /* Disable the write protection for RTC registers */
  __HAL_RTC_WRITEPROTECTION_DISABLE(hrtc);

#if defined(RTC_CR_REFCKON)
  /* Check if the reference clock detection is disabled */
  if (READ_BIT(RTC->CR, RTC_CR_REFCKON) == 0U)
  {
#endif /* RTC_CR_REFCKON */
    /* Configure the Shift settings */
    MODIFY_REG(RTC->SHIFTR, RTC_SHIFTR_SUBFS, (uint32_t)(ShiftSubFS) | (uint32_t)(ShiftAdd1S));

    /* If  RTC_CR_BYPSHAD bit = 0, wait for synchro else this check is not needed */
    if (READ_BIT(RTC->CR, RTC_CR_BYPSHAD) == 0U)
    {
      if (HAL_RTC_WaitForSynchro(hrtc) != HAL_OK)
      {
        /* Enable the write protection for RTC registers */
        __HAL_RTC_WRITEPROTECTION_ENABLE(hrtc);

        /* Change RTC state */
        hrtc->State = HAL_RTC_STATE_ERROR;

        /* Process Unlocked */
        __HAL_UNLOCK(hrtc);

        return HAL_ERROR;
      }
    }
#if defined(RTC_CR_REFCKON)
  }
  else
  {
    /* Enable the write protection for RTC registers */
    __HAL_RTC_WRITEPROTECTION_ENABLE(hrtc);

    /* Change RTC state */
    hrtc->State = HAL_RTC_STATE_ERROR;

    /* Process Unlocked */
    __HAL_UNLOCK(hrtc);

    return HAL_ERROR;
  }
#endif /* RTC_CR_REFCKON */

  /* Enable the write protection for RTC registers */
  __HAL_RTC_WRITEPROTECTION_ENABLE(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetCalibrationOutPut(RTC_HandleTypeDef *hrtc, uint32_t CalibOutput)
{
  /* Check the parameters */
  assert_param(IS_RTC_CALIB_OUTPUT(CalibOutput));

  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Configure the RTC_CR register */
  MODIFY_REG(RTC->CR, RTC_CR_COSEL, CalibOutput);

  /* Enable calibration output */
  SET_BIT(RTC->CR, RTC_CR_COE);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_DeactivateCalibrationOutPut(RTC_HandleTypeDef *hrtc)
{
  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Disable calibration output */
  CLEAR_BIT(RTC->CR, RTC_CR_COE);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetRefClock(RTC_HandleTypeDef *hrtc)
{
  HAL_StatusTypeDef status;

  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Disable the write protection for RTC registers */
  __HAL_RTC_WRITEPROTECTION_DISABLE(hrtc);

  /* Enter Initialization mode */
  status = RTC_EnterInitMode(hrtc);
  if (status == HAL_OK)
  {
    /* Enable clockref detection */
    SET_BIT(RTC->CR, RTC_CR_REFCKON);

    /* Exit Initialization mode */
    status = RTC_ExitInitMode(hrtc);
  }

  /* Enable the write protection for RTC registers */
  __HAL_RTC_WRITEPROTECTION_ENABLE(hrtc);

  if (status == HAL_OK)
  {
    /* Change RTC state */
    hrtc->State = HAL_RTC_STATE_READY;
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return status;
}

HAL_StatusTypeDef HAL_RTCEx_DeactivateRefClock(RTC_HandleTypeDef *hrtc)
{
  HAL_StatusTypeDef status;

  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Disable the write protection for RTC registers */
  __HAL_RTC_WRITEPROTECTION_DISABLE(hrtc);

  /* Enter Initialization mode */
  status = RTC_EnterInitMode(hrtc);
  if (status == HAL_OK)
  {
    /* Disable clockref detection */
    CLEAR_BIT(RTC->CR, RTC_CR_REFCKON);

    /* Exit Initialization mode */
    status = RTC_ExitInitMode(hrtc);
  }

  /* Enable the write protection for RTC registers */
  __HAL_RTC_WRITEPROTECTION_ENABLE(hrtc);

  if (status == HAL_OK)
  {
    /* Change RTC state */
    hrtc->State = HAL_RTC_STATE_READY;
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return status;
}

HAL_StatusTypeDef HAL_RTCEx_EnableBypassShadow(RTC_HandleTypeDef *hrtc)
{
  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Set the BYPSHAD bit */
  SET_BIT(RTC->CR, RTC_CR_BYPSHAD);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_DisableBypassShadow(RTC_HandleTypeDef *hrtc)
{
  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Reset the BYPSHAD bit */
  CLEAR_BIT(RTC->CR, RTC_CR_BYPSHAD);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_MonotonicCounterIncrement(const RTC_HandleTypeDef *hrtc, uint32_t Instance)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);
  UNUSED(Instance);

  /* This register is read-only only and is incremented by one when a write access is done to this
     register. This register cannot roll-over and is frozen when reaching the maximum value. */
  CLEAR_REG(TAMP->COUNT1R);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_MonotonicCounterGet(const RTC_HandleTypeDef *hrtc, uint32_t Instance, uint32_t *pValue)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);
  UNUSED(Instance);

  /* This register is read-only only and is incremented by one when a write access is done to this
     register. This register cannot roll-over and is frozen when reaching the maximum value. */
  *pValue = READ_REG(TAMP->COUNT1R);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetSSRU_IT(RTC_HandleTypeDef *hrtc)
{
  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* Enable IT SSRU */
  __HAL_RTC_SSRU_ENABLE_IT(hrtc, RTC_IT_SSRU);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_DeactivateSSRU(RTC_HandleTypeDef *hrtc)
{
  /* Process Locked */
  __HAL_LOCK(hrtc);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_BUSY;

  /* In case of interrupt mode is used, the interrupt source must disabled */
  __HAL_RTC_SSRU_DISABLE_IT(hrtc, RTC_IT_SSRU);

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hrtc);

  return HAL_OK;
}

void HAL_RTCEx_SSRUIRQHandler(RTC_HandleTypeDef *hrtc)
{
  /* Get the pending status of the SSR Underflow Interrupt */
  if (READ_BIT(RTC->MISR, RTC_MISR_SSRUMF) != 0U)
  {
    /* Immediately clear SSR underflow flag */
    WRITE_REG(RTC->SCR, RTC_SCR_CSSRUF);

    /* SSRU callback */
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call SSRUEvent registered Callback */
    hrtc->SSRUEventCallback(hrtc);
#else
    HAL_RTCEx_SSRUEventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */

  }

  /* Change RTC state */
  hrtc->State = HAL_RTC_STATE_READY;
}

HAL_StatusTypeDef HAL_RTCEx_PollForAlarmBEvent(const RTC_HandleTypeDef *hrtc, uint32_t Timeout)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  uint32_t tickstart = HAL_GetTick();

  while (READ_BIT(RTC->SR, RTC_SR_ALRBF) == 0U)
  {
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        /* New check to avoid false timeout detection in case of preemption */
        if (READ_BIT(RTC->SR, RTC_SR_ALRBF) == 0U)
        {
          return HAL_TIMEOUT;
        }
        else
        {
          break;
        }
      }
    }
  }

  /* Clear the Alarm Flag */
  WRITE_REG(RTC->SCR, RTC_SCR_CALRBF);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetTamper(const RTC_HandleTypeDef *hrtc, const RTC_TamperTypeDef *sTamper)
{
  uint32_t tmpreg;

  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  /* Check the parameters */
  assert_param(IS_RTC_TAMPER(sTamper->Tamper));
  assert_param(IS_RTC_TAMPER_TRIGGER(sTamper->Trigger));
  assert_param(IS_RTC_TAMPER_ERASE_MODE(sTamper->NoErase));
  assert_param(IS_RTC_TAMPER_MASKFLAG_STATE(sTamper->MaskFlag));
  assert_param(IS_RTC_TAMPER_TIMESTAMPONTAMPER_DETECTION(sTamper->TimeStampOnTamperDetection));
#if (RTC_TAMP_NB > 2U)
  /* Mask flag only supported by TAMPER 1, 2 and 3 */
  assert_param(!((sTamper->MaskFlag != RTC_TAMPERMASK_FLAG_DISABLE) && (sTamper->Tamper > RTC_TAMPER_3)));
#else
  assert_param(!((sTamper->MaskFlag != RTC_TAMPERMASK_FLAG_DISABLE) && (sTamper->Tamper > RTC_TAMPER_2)));
#endif /* (RTC_TAMP_NB > 2U) */
  assert_param(IS_RTC_TAMPER_FILTER(sTamper->Filter));
  assert_param(IS_RTC_TAMPER_SAMPLING_FREQ(sTamper->SamplingFrequency));
  assert_param(IS_RTC_TAMPER_PRECHARGE_DURATION(sTamper->PrechargeDuration));
  assert_param(IS_RTC_TAMPER_PULLUP_STATE(sTamper->TamperPullUp));
  /* Trigger and Filter have exclusive configurations */
  assert_param(((sTamper->Filter != RTC_TAMPERFILTER_DISABLE) &&
                ((sTamper->Trigger == RTC_TAMPERTRIGGER_LOWLEVEL) ||
                 (sTamper->Trigger == RTC_TAMPERTRIGGER_HIGHLEVEL))) ||
               ((sTamper->Filter == RTC_TAMPERFILTER_DISABLE) &&
                ((sTamper->Trigger == RTC_TAMPERTRIGGER_RISINGEDGE) ||
                 (sTamper->Trigger == RTC_TAMPERTRIGGER_FALLINGEDGE))));

  /* Configuration register 2 */
  tmpreg = READ_REG(TAMP->CR2);
  tmpreg &= ~((sTamper->Tamper << TAMP_CR2_TAMP1TRG_Pos) | (sTamper->Tamper << TAMP_CR2_TAMP1MSK_Pos) |
              (sTamper->Tamper << TAMP_CR2_TAMP1POM_Pos));

  if ((sTamper->Trigger == RTC_TAMPERTRIGGER_HIGHLEVEL) || (sTamper->Trigger == RTC_TAMPERTRIGGER_FALLINGEDGE))
  {
    tmpreg |= (sTamper->Tamper << TAMP_CR2_TAMP1TRG_Pos);
  }

  if (sTamper->MaskFlag != RTC_TAMPERMASK_FLAG_DISABLE)
  {
    tmpreg |= (sTamper->Tamper << TAMP_CR2_TAMP1MSK_Pos);
  }

  if (sTamper->NoErase != RTC_TAMPER_ERASE_BACKUP_ENABLE)
  {
    tmpreg |= (sTamper->Tamper << TAMP_CR2_TAMP1POM_Pos);
  }
  WRITE_REG(TAMP->CR2, tmpreg);

  /* Filter control register */
  WRITE_REG(TAMP->FLTCR, sTamper->Filter | sTamper->SamplingFrequency | sTamper->PrechargeDuration |
            sTamper->TamperPullUp);

  /* Timestamp on tamper */
  if (READ_BIT(RTC->CR, RTC_CR_TAMPTS) != sTamper->TimeStampOnTamperDetection)
  {
    MODIFY_REG(RTC->CR, RTC_CR_TAMPTS, sTamper->TimeStampOnTamperDetection);
  }

  /* Control register 1 */
  SET_BIT(TAMP->CR1, sTamper->Tamper);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetTamper_IT(const RTC_HandleTypeDef *hrtc, const RTC_TamperTypeDef *sTamper)
{
  uint32_t tmpreg;

  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  /* Check the parameters */
  assert_param(IS_RTC_TAMPER(sTamper->Tamper));
  assert_param(IS_RTC_TAMPER_TRIGGER(sTamper->Trigger));
  assert_param(IS_RTC_TAMPER_ERASE_MODE(sTamper->NoErase));
  assert_param(IS_RTC_TAMPER_TIMESTAMPONTAMPER_DETECTION(sTamper->TimeStampOnTamperDetection));
  /* The interrupt must not be enabled when TAMPxMSK is set. */
  assert_param(sTamper->MaskFlag == RTC_TAMPERMASK_FLAG_DISABLE);
  assert_param(IS_RTC_TAMPER_FILTER(sTamper->Filter));
  assert_param(IS_RTC_TAMPER_SAMPLING_FREQ(sTamper->SamplingFrequency));
  assert_param(IS_RTC_TAMPER_PRECHARGE_DURATION(sTamper->PrechargeDuration));
  assert_param(IS_RTC_TAMPER_PULLUP_STATE(sTamper->TamperPullUp));
  /* Trigger and Filter have exclusive configurations */
  assert_param(((sTamper->Filter != RTC_TAMPERFILTER_DISABLE) &&
                ((sTamper->Trigger == RTC_TAMPERTRIGGER_LOWLEVEL) ||
                 (sTamper->Trigger == RTC_TAMPERTRIGGER_HIGHLEVEL))) ||
               ((sTamper->Filter == RTC_TAMPERFILTER_DISABLE) &&
                ((sTamper->Trigger == RTC_TAMPERTRIGGER_RISINGEDGE) ||
                 (sTamper->Trigger == RTC_TAMPERTRIGGER_FALLINGEDGE))));

  /* Configuration register 2 */
  tmpreg = READ_REG(TAMP->CR2);
  tmpreg &= ~((sTamper->Tamper << TAMP_CR2_TAMP1TRG_Pos) | (sTamper->Tamper << TAMP_CR2_TAMP1MSK_Pos) |
              (sTamper->Tamper << TAMP_CR2_TAMP1POM_Pos));

  if ((sTamper->Trigger == RTC_TAMPERTRIGGER_HIGHLEVEL) || (sTamper->Trigger == RTC_TAMPERTRIGGER_FALLINGEDGE))
  {
    tmpreg |= (sTamper->Tamper << TAMP_CR2_TAMP1TRG_Pos);
  }

  if (sTamper->NoErase != RTC_TAMPER_ERASE_BACKUP_ENABLE)
  {
    tmpreg |= (sTamper->Tamper << TAMP_CR2_TAMP1POM_Pos);
  }
  WRITE_REG(TAMP->CR2, tmpreg);

  /* Filter control register */
  WRITE_REG(TAMP->FLTCR, sTamper->Filter | sTamper->SamplingFrequency | sTamper->PrechargeDuration |
            sTamper->TamperPullUp);

  /* Timestamp on tamper */
  if (READ_BIT(RTC->CR, RTC_CR_TAMPTS) != sTamper->TimeStampOnTamperDetection)
  {
    MODIFY_REG(RTC->CR, RTC_CR_TAMPTS, sTamper->TimeStampOnTamperDetection);
  }

  /* Interrupt enable register */
  SET_BIT(TAMP->IER, sTamper->Tamper);

  /* Control register 1 */
  SET_BIT(TAMP->CR1, sTamper->Tamper);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_DeactivateTamper(const RTC_HandleTypeDef *hrtc, uint32_t Tamper)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  assert_param(IS_RTC_TAMPER(Tamper));

  /* Disable the selected Tamper pin */
  CLEAR_BIT(TAMP->CR1, Tamper);

  /* Clear tamper interrupt and event flags (WO register) */
  WRITE_REG(TAMP->SCR, Tamper);

  /* Clear tamper mask/noerase/trigger configuration */
  CLEAR_BIT(TAMP->CR2, (Tamper << TAMP_CR2_TAMP1TRG_Pos) | (Tamper << TAMP_CR2_TAMP1MSK_Pos) | \
            (Tamper << TAMP_CR2_TAMP1POM_Pos));

  /* Clear tamper interrupt mode configuration */
  CLEAR_BIT(TAMP->IER, Tamper);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetActiveTampers(RTC_HandleTypeDef *hrtc, const RTC_ActiveTampersTypeDef *sAllTamper)
{
  uint32_t tmp_ier;
  uint32_t tmp_cr1;
  uint32_t tmp_cr2;
  uint32_t tmp_atcr1;
  uint32_t tmp_atcr2;
  uint32_t tmp_cr;
  uint32_t i;
  uint32_t tickstart;

#ifdef  USE_FULL_ASSERT
  for (i = 0; i < RTC_TAMP_NB; i++)
  {
    assert_param(IS_RTC_TAMPER_ERASE_MODE(sAllTamper->TampInput[i].NoErase));
    assert_param(IS_RTC_TAMPER_MASKFLAG_STATE(sAllTamper->TampInput[i].MaskFlag));
    /* Mask flag only supported by TAMPER 1, 2 and 3 */
    assert_param(!((sAllTamper->TampInput[i].MaskFlag == RTC_TAMPERMASK_FLAG_ENABLE) &&
                   (i >= RTC_TAMPER_MASKABLE_NB)));
  }
  assert_param(IS_RTC_TAMPER_TIMESTAMPONTAMPER_DETECTION(sAllTamper->TimeStampOnTamperDetection));
  assert_param(IS_RTC_ATAMPER_FILTER(sAllTamper->ActiveFilter));
  assert_param(IS_RTC_ATAMPER_OUTPUT_CHANGE_PERIOD(sAllTamper->ActiveOutputChangePeriod));
  assert_param(IS_RTC_ATAMPER_ASYNCPRES_RTCCLK(sAllTamper->ActiveAsyncPrescaler));
#endif /* USE_FULL_ASSERT */

  /* Active Tampers must not be already enabled */
  if (READ_BIT(TAMP->ATOR, TAMP_ATOR_INITS) != 0U)
  {
    /* Disable all actives tampers with HAL_RTCEx_DeactivateActiveTampers.
       No need to check return value because it returns always HAL_OK */
    (void) HAL_RTCEx_DeactivateActiveTampers(hrtc);
  }

  /* Set TimeStamp on tamper detection */
  tmp_cr = READ_REG(RTC->CR);
  if ((tmp_cr & RTC_CR_TAMPTS) != (sAllTamper->TimeStampOnTamperDetection))
  {
    MODIFY_REG(RTC->CR, RTC_CR_TAMPTS, sAllTamper->TimeStampOnTamperDetection);
  }

  tmp_cr1 = READ_REG(TAMP->CR1);
  tmp_cr2 = READ_REG(TAMP->CR2);
  tmp_atcr2 = 0U;
  tmp_ier = READ_REG(TAMP->IER);

  /* Set common parameters */
  tmp_atcr1 = (sAllTamper->ActiveFilter | (sAllTamper->ActiveOutputChangePeriod << TAMP_ATCR1_ATPER_Pos) |
               sAllTamper->ActiveAsyncPrescaler);

  /* Set specific parameters for each active tamper inputs if enable */
  for (i = 0; i < RTC_TAMP_NB; i++)
  {
    if (sAllTamper->TampInput[i].Enable != RTC_ATAMP_DISABLE)
    {
      tmp_cr1 |= (TAMP_CR1_TAMP1E << i);
      tmp_atcr1 |= (TAMP_ATCR1_TAMP1AM << i);

      if (sAllTamper->TampInput[i].Interrupt != RTC_ATAMP_INTERRUPT_DISABLE)
      {
        /* Interrupt enable register */
        tmp_ier |= (TAMP_IER_TAMP1IE << i);
      }

      if (sAllTamper->TampInput[i].MaskFlag != RTC_TAMPERMASK_FLAG_DISABLE)
      {
        tmp_cr2 |= (TAMP_CR2_TAMP1MSK << i);
      }

      if (sAllTamper->TampInput[i].NoErase != RTC_TAMPER_ERASE_BACKUP_ENABLE)
      {
        tmp_cr2 |= (TAMP_CR2_TAMP1POM << i);
      }

      /* Configure ATOSELx[] in case of output sharing */
      tmp_atcr2 |= sAllTamper->TampInput[i].Output << ((3U * i) + TAMP_ATCR2_ATOSEL1_Pos);

      if (i != sAllTamper->TampInput[i].Output)
      {
        tmp_atcr1 |= TAMP_ATCR1_ATOSHARE;
      }
    }
  }

  WRITE_REG(TAMP->IER, tmp_ier);
  WRITE_REG(TAMP->ATCR1, tmp_atcr1);
  WRITE_REG(TAMP->ATCR2, tmp_atcr2);
  WRITE_REG(TAMP->CR2, tmp_cr2);
  WRITE_REG(TAMP->CR1, tmp_cr1);

  /* Write seed */
  for (i = 0; i < RTC_ATAMP_SEED_NB_UINT32; i++)
  {
    WRITE_REG(TAMP->ATSEEDR, sAllTamper->Seed[i]);
  }

  /* Wait till RTC SEEDF flag is cleared and if Time out is reached exit */
  tickstart = HAL_GetTick();
  while (READ_BIT(TAMP->ATOR,  TAMP_ATOR_SEEDF) != 0U)
  {
    if ((HAL_GetTick() - tickstart) > RTC_TIMEOUT_VALUE)
    {
      /* New check to avoid false timeout detection in case of preemption */
      if (READ_BIT(TAMP->ATOR, TAMP_ATOR_SEEDF) != 0U)
      {
        /* Change RTC state */
        hrtc->State = HAL_RTC_STATE_TIMEOUT;

        return HAL_TIMEOUT;
      }
      else
      {
        break;
      }
    }
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetActiveSeed(RTC_HandleTypeDef *hrtc, const uint32_t *pSeed)
{
  uint32_t i;
  uint32_t tickstart;

  /* Active Tampers must be enabled */
  if (READ_BIT(TAMP->ATOR,  TAMP_ATOR_INITS) == 0U)
  {
    return HAL_ERROR;
  }

  for (i = 0; i < RTC_ATAMP_SEED_NB_UINT32; i++)
  {
    WRITE_REG(TAMP->ATSEEDR, pSeed[i]);
  }

  /* Wait till RTC SEEDF flag is cleared and if Time out is reached exit */
  tickstart = HAL_GetTick();
  while (READ_BIT(TAMP->ATOR,  TAMP_ATOR_SEEDF) != 0U)
  {
    if ((HAL_GetTick() - tickstart) > RTC_TIMEOUT_VALUE)
    {
      /* New check to avoid false timeout detection in case of preemption */
      if (READ_BIT(TAMP->ATOR, TAMP_ATOR_SEEDF) != 0U)
      {
        /* Change RTC state */
        hrtc->State = HAL_RTC_STATE_TIMEOUT;

        return HAL_TIMEOUT;
      }
      else
      {
        break;
      }
    }
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_LockBootHardwareKey(const RTC_HandleTypeDef *hrtc)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  SET_BIT(TAMP->CFGR, TAMP_CFGR_BHKLOCK);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_DeactivateActiveTampers(const RTC_HandleTypeDef *hrtc)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  /* Get Active tampers */
  uint32_t atamp_mask = READ_BIT(TAMP->ATCR1, TAMP_ALL);

  /* Disable all actives tampers but not passives tampers */
  CLEAR_BIT(TAMP->CR1, atamp_mask);

  /* Clear tamper interrupt and event flags (WO register) of all actives tampers but not passives tampers */
  WRITE_REG(TAMP->SCR, atamp_mask);

  /* Disable no erase and mask */
  CLEAR_BIT(TAMP->CR2, (atamp_mask | ((atamp_mask & (TAMP_ATCR1_TAMP1AM | TAMP_ATCR1_TAMP2AM | TAMP_ATCR1_TAMP3AM)) <<
                                      TAMP_CR2_TAMP1MSK_Pos)));

  /* Clear all active tampers interrupt mode configuration but not passives tampers */
  CLEAR_BIT(TAMP->IER, atamp_mask);

  /* Set reset value for active tamper control register 1 */
  WRITE_REG(TAMP->ATCR1, TAMP_ATCR1_ATCKSEL_0 | TAMP_ATCR1_ATCKSEL_1 | TAMP_ATCR1_ATCKSEL_2);

  /* Set reset value for active tamper control register 2 */
  CLEAR_REG(TAMP->ATCR2);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_PollForTamperEvent(const RTC_HandleTypeDef *hrtc, uint32_t Tamper, uint32_t Timeout)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  assert_param(IS_RTC_TAMPER(Tamper));

  uint32_t tickstart = HAL_GetTick();

  /* Get the status of the Interrupt */
  while (READ_BIT(TAMP->SR, Tamper) != Tamper)
  {
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        /* New check to avoid false timeout detection in case of preemption */
        if (READ_BIT(TAMP->SR, Tamper) != Tamper)
        {
          return HAL_TIMEOUT;
        }
        else
        {
          break;
        }
      }
    }
  }

  /* Clear the Tamper Flag */
  WRITE_REG(TAMP->SCR, Tamper);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetInternalTamper(const RTC_HandleTypeDef *hrtc,
                                              const RTC_InternalTamperTypeDef *sIntTamper)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  /* Check the parameters */
  assert_param(IS_RTC_INTERNAL_TAMPER(sIntTamper->IntTamper));
  assert_param(IS_RTC_TAMPER_TIMESTAMPONTAMPER_DETECTION(sIntTamper->TimeStampOnTamperDetection));
  assert_param(IS_RTC_TAMPER_ERASE_MODE(sIntTamper->NoErase));

  /* Timestamp enable on internal tamper */
  if (READ_BIT(RTC->CR, RTC_CR_TAMPTS) != sIntTamper->TimeStampOnTamperDetection)
  {
    MODIFY_REG(RTC->CR, RTC_CR_TAMPTS, sIntTamper->TimeStampOnTamperDetection);
  }

  /* No Erase Backup register enable for Internal Tamper */
  if (sIntTamper->NoErase != RTC_TAMPER_ERASE_BACKUP_ENABLE)
  {
    SET_BIT(TAMP->CR3, (sIntTamper->IntTamper >> (TAMP_CR1_ITAMP1E_Pos - TAMP_CR3_ITAMP1POM_Pos)));
  }
  else
  {
    CLEAR_BIT(TAMP->CR3, (sIntTamper->IntTamper >> (TAMP_CR1_ITAMP1E_Pos - TAMP_CR3_ITAMP1POM_Pos)));
  }

  /* Enable Internal Tamper */
  SET_BIT(TAMP->CR1, sIntTamper->IntTamper);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_SetInternalTamper_IT(const RTC_HandleTypeDef *hrtc,
                                                 const RTC_InternalTamperTypeDef *sIntTamper)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  /* Check the parameters */
  assert_param(IS_RTC_INTERNAL_TAMPER(sIntTamper->IntTamper));
  assert_param(IS_RTC_TAMPER_TIMESTAMPONTAMPER_DETECTION(sIntTamper->TimeStampOnTamperDetection));
  assert_param(IS_RTC_TAMPER_ERASE_MODE(sIntTamper->NoErase));

  /* Timestamp enable on internal tamper */
  if (READ_BIT(RTC->CR, RTC_CR_TAMPTS) != sIntTamper->TimeStampOnTamperDetection)
  {
    MODIFY_REG(RTC->CR, RTC_CR_TAMPTS, sIntTamper->TimeStampOnTamperDetection);
  }

  /* Interrupt enable register */
  SET_BIT(TAMP->IER, sIntTamper->IntTamper);

  /* No Erase Backup register enable for Internal Tamper */
  if (sIntTamper->NoErase != RTC_TAMPER_ERASE_BACKUP_ENABLE)
  {
    SET_BIT(TAMP->CR3, (sIntTamper->IntTamper >> (TAMP_CR1_ITAMP1E_Pos - TAMP_CR3_ITAMP1POM_Pos)));
  }
  else
  {
    CLEAR_BIT(TAMP->CR3, (sIntTamper->IntTamper >> (TAMP_CR1_ITAMP1E_Pos - TAMP_CR3_ITAMP1POM_Pos)));
  }

  /* Enable Internal Tamper */
  SET_BIT(TAMP->CR1, sIntTamper->IntTamper);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_DeactivateInternalTamper(const RTC_HandleTypeDef *hrtc, uint32_t IntTamper)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  assert_param(IS_RTC_INTERNAL_TAMPER(IntTamper));

  /* Disable the selected Tamper pin */
  CLEAR_BIT(TAMP->CR1, IntTamper);

  /* Clear internal tamper interrupt mode configuration */
  CLEAR_BIT(TAMP->IER, IntTamper);

  /* Clear internal tamper interrupt */
  WRITE_REG(TAMP->SCR, IntTamper);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_PollForInternalTamperEvent(const RTC_HandleTypeDef *hrtc, uint32_t IntTamper,
                                                       uint32_t Timeout)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  assert_param(IS_RTC_INTERNAL_TAMPER(IntTamper));

  uint32_t tickstart = HAL_GetTick();

  /* Get the status of the Interrupt */
  while (READ_BIT(TAMP->SR, IntTamper) != IntTamper)
  {
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        /* New check to avoid false timeout detection in case of preemption */
        if (READ_BIT(TAMP->SR, IntTamper) != IntTamper)
        {
          return HAL_TIMEOUT;
        }
        else
        {
          break;
        }
      }
    }
  }

  /* Clear the Tamper Flag */
  WRITE_REG(TAMP->SCR, IntTamper);

  return HAL_OK;
}

void HAL_RTCEx_TamperIRQHandler(RTC_HandleTypeDef *hrtc)
{
  /* Get the pending status of the Tampers Interrupt */
  uint32_t tmp = READ_REG(TAMP->MISR);

  /* Check Tamper1 status */
  if ((tmp & RTC_TAMPER_1) == RTC_TAMPER_1)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Tamper 1 Event registered Callback */
    hrtc->Tamper1EventCallback(hrtc);
#else
    /* Tamper1 callback */
    HAL_RTCEx_Tamper1EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Tamper2 status */
  if ((tmp & RTC_TAMPER_2) == RTC_TAMPER_2)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Tamper 2 Event registered Callback */
    hrtc->Tamper2EventCallback(hrtc);
#else
    /* Tamper2 callback */
    HAL_RTCEx_Tamper2EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

#if (RTC_TAMP_NB > 2U)

  /* Check Tamper3 status */
  if ((tmp & RTC_TAMPER_3) == RTC_TAMPER_3)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Tamper 3 Event registered Callback */
    hrtc->Tamper3EventCallback(hrtc);
#else
    /* Tamper3 callback */
    HAL_RTCEx_Tamper3EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Tamper4 status */
  if ((tmp & RTC_TAMPER_4) == RTC_TAMPER_4)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Tamper 4 Event registered Callback */
    hrtc->Tamper4EventCallback(hrtc);
#else
    /* Tamper4 callback */
    HAL_RTCEx_Tamper4EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Tamper5 status */
  if ((tmp & RTC_TAMPER_5) == RTC_TAMPER_5)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Tamper 5 Event registered Callback */
    hrtc->Tamper5EventCallback(hrtc);
#else
    /* Tamper5 callback */
    HAL_RTCEx_Tamper5EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Tamper6 status */
  if ((tmp & RTC_TAMPER_6) == RTC_TAMPER_6)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Tamper 6 Event registered Callback */
    hrtc->Tamper6EventCallback(hrtc);
#else
    /* Tamper6 callback */
    HAL_RTCEx_Tamper6EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

#endif /* (RTC_TAMP_NB > 2U) */
#if (RTC_TAMP_NB > 6U)

  /* Check Tamper7 status */
  if ((tmp & RTC_TAMPER_7) == RTC_TAMPER_7)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Tamper 7 Event registered Callback */
    hrtc->Tamper7EventCallback(hrtc);
#else
    /* Tamper7 callback */
    HAL_RTCEx_Tamper7EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Tamper8 status */
  if ((tmp & RTC_TAMPER_8) == RTC_TAMPER_8)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Tamper 8 Event registered Callback */
    hrtc->Tamper8EventCallback(hrtc);
#else
    /* Tamper8 callback */
    HAL_RTCEx_Tamper8EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

#endif /* (RTC_TAMP_NB > 6U) */

  /* Check Internal Tamper1 status */
  if ((tmp & RTC_INT_TAMPER_1) == RTC_INT_TAMPER_1)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Internal Tamper 1 Event registered Callback */
    hrtc->InternalTamper1EventCallback(hrtc);
#else
    /* Internal Tamper1 callback */
    HAL_RTCEx_InternalTamper1EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Internal Tamper2 status */
  if ((tmp & RTC_INT_TAMPER_2) == RTC_INT_TAMPER_2)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Internal Tamper 2 Event registered Callback */
    hrtc->InternalTamper2EventCallback(hrtc);
#else
    /* Internal Tamper2 callback */
    HAL_RTCEx_InternalTamper2EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Internal Tamper3 status */
  if ((tmp & RTC_INT_TAMPER_3) == RTC_INT_TAMPER_3)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Internal Tamper 3 Event registered Callback */
    hrtc->InternalTamper3EventCallback(hrtc);
#else
    /* Internal Tamper3 callback */
    HAL_RTCEx_InternalTamper3EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Internal Tamper4 status */
  if ((tmp & RTC_INT_TAMPER_4) == RTC_INT_TAMPER_4)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Internal Tamper 4 Event registered Callback */
    hrtc->InternalTamper4EventCallback(hrtc);
#else
    /* Internal Tamper4 callback */
    HAL_RTCEx_InternalTamper4EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Internal Tamper5 status */
  if ((tmp & RTC_INT_TAMPER_5) == RTC_INT_TAMPER_5)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Internal Tamper 5 Event registered Callback */
    hrtc->InternalTamper5EventCallback(hrtc);
#else
    /* Internal Tamper5 callback */
    HAL_RTCEx_InternalTamper5EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Internal Tamper6 status */
  if ((tmp & RTC_INT_TAMPER_6) == RTC_INT_TAMPER_6)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Internal Tamper 6 Event registered Callback */
    hrtc->InternalTamper6EventCallback(hrtc);
#else
    /* Internal Tamper6 callback */
    HAL_RTCEx_InternalTamper6EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Internal Tamper7 status */
  if ((tmp & RTC_INT_TAMPER_7) == RTC_INT_TAMPER_7)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Internal Tamper 7 Event registered Callback */
    hrtc->InternalTamper7EventCallback(hrtc);
#else
    /* Internal Tamper7 callback */
    HAL_RTCEx_InternalTamper7EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Internal Tamper8 status */
  if ((tmp & RTC_INT_TAMPER_8) == RTC_INT_TAMPER_8)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Internal Tamper 8 Event registered Callback */
    hrtc->InternalTamper8EventCallback(hrtc);
#else
    /* Internal Tamper8 callback */
    HAL_RTCEx_InternalTamper8EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Internal Tamper9 status */
  if ((tmp & RTC_INT_TAMPER_9) == RTC_INT_TAMPER_9)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Internal Tamper 9 Event registered Callback */
    hrtc->InternalTamper9EventCallback(hrtc);
#else
    /* Internal Tamper9 callback */
    HAL_RTCEx_InternalTamper9EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Internal Tamper11 status */
  if ((tmp & RTC_INT_TAMPER_11) == RTC_INT_TAMPER_11)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Internal Tamper 11 Event registered Callback */
    hrtc->InternalTamper11EventCallback(hrtc);
#else
    /* Internal Tamper11 callback */
    HAL_RTCEx_InternalTamper11EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Check Internal Tamper15 status */
  if ((tmp & RTC_INT_TAMPER_15) == RTC_INT_TAMPER_15)
  {
#if (USE_HAL_RTC_REGISTER_CALLBACKS == 1)
    /* Call Internal Tamper 15 Event registered Callback */
    hrtc->InternalTamper15EventCallback(hrtc);
#else
    /* Internal Tamper15 callback */
    HAL_RTCEx_InternalTamper15EventCallback(hrtc);
#endif /* USE_HAL_RTC_REGISTER_CALLBACKS */
  }

  /* Clear flags after treatment to allow the potential tamper feature */
  WRITE_REG(TAMP->SCR, tmp);
}

void HAL_RTCEx_BKUPWrite(const RTC_HandleTypeDef *hrtc, uint32_t BackupRegister, uint32_t Data)
{
  uintptr_t tmp;

  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  /* Check the parameters */
  assert_param(IS_RTC_BKP(BackupRegister));

  /* Determine address of the specified Backup register */
  tmp = (uintptr_t)(&(TAMP->BKP0R));
  tmp += (BackupRegister * 4U);

  /* Write data in the specified register Backup register */
  *(__IO uint32_t *)tmp = (uint32_t)Data;
}

uint32_t HAL_RTCEx_BKUPRead(const RTC_HandleTypeDef *hrtc, uint32_t BackupRegister)
{
  uintptr_t tmp;

  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  /* Check the parameters */
  assert_param(IS_RTC_BKP(BackupRegister));

  /* Determine address of the specified Backup register */
  tmp = (uintptr_t)(&(TAMP->BKP0R));
  tmp += (BackupRegister * 4U);

  /* Read the data from the specified register */
  return (*(__IO uint32_t *)tmp);
}

void  HAL_RTCEx_BKUPErase(const RTC_HandleTypeDef *hrtc)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  SET_BIT(TAMP->CR2, TAMP_CR2_BKERASE);
}

void  HAL_RTCEx_BKUPBlock(const RTC_HandleTypeDef *hrtc)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  SET_BIT(TAMP->CR2, TAMP_CR2_BKBLOCK);
}

void  HAL_RTCEx_BKUPUnblock(const RTC_HandleTypeDef *hrtc)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  CLEAR_BIT(TAMP->CR2, TAMP_CR2_BKBLOCK);
}

void  HAL_RTCEx_ConfigEraseDeviceSecrets(const RTC_HandleTypeDef *hrtc, uint32_t DeviceSecretConf)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  MODIFY_REG(TAMP->RPCFGR, TAMP_RPCFGR_RPCFG0, DeviceSecretConf);
}

HAL_StatusTypeDef HAL_RTCEx_PrivilegeModeSet(const RTC_HandleTypeDef *hrtc,
                                             const RTC_PrivilegeStateTypeDef *privilegeState)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  assert_param(IS_RTC_PRIVILEGE_FULL(privilegeState->rtcPrivilegeFull));
  assert_param(IS_RTC_PRIVILEGE_FEATURES(privilegeState->rtcPrivilegeFeatures));
  assert_param(IS_TAMP_PRIVILEGE_FULL(privilegeState->tampPrivilegeFull));
  assert_param(IS_TAMP_MONOTONIC_CNT_PRIVILEGE(privilegeState->MonotonicCounterPrivilege));
  assert_param(IS_RTC_PRIVILEGE_BKUP_ZONE(privilegeState->backupRegisterPrivZone));
  assert_param(IS_RTC_BKP(privilegeState->backupRegisterStartZone2));
  assert_param(IS_RTC_BKP(privilegeState->backupRegisterStartZone3));

  /* RTC privilege configuration */
  WRITE_REG(RTC->PRIVCFGR, privilegeState->rtcPrivilegeFull | privilegeState->rtcPrivilegeFeatures);

  /* TAMP, Monotonic counter and Backup registers privilege configuration */
  WRITE_REG(TAMP->PRIVCFGR, privilegeState->tampPrivilegeFull | privilegeState->backupRegisterPrivZone | \
            privilegeState->MonotonicCounterPrivilege);

  /* Backup register start zone */
  MODIFY_REG(TAMP->CFGR,
             (TAMP_CFGR_BKPRW | TAMP_CFGR_BKPW),
             ((privilegeState->backupRegisterStartZone2 << TAMP_CFGR_BKPRW_Pos) | (privilegeState->backupRegisterStartZone3 << TAMP_CFGR_BKPW_Pos)));

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RTCEx_PrivilegeModeGet(const RTC_HandleTypeDef *hrtc, RTC_PrivilegeStateTypeDef *privilegeState)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrtc);

  /* Read registers */
  uint32_t rtc_privcfgr = READ_REG(RTC->PRIVCFGR);
  uint32_t tamp_privcfgr = READ_REG(TAMP->PRIVCFGR);
  uint32_t tamp_cfgr = READ_REG(TAMP->CFGR);

  /* RTC privilege configuration */
  privilegeState->rtcPrivilegeFull = READ_BIT(rtc_privcfgr, RTC_PRIVCFGR_PRIV);

  /* Warning, rtcPrivilegeFeatures is only relevant if privilegeState->rtcPrivilegeFull == RTC_PRIVILEGE_FULL_NO */
  privilegeState->rtcPrivilegeFeatures = READ_BIT(rtc_privcfgr, RTC_PRIVILEGE_FEATURE_ALL);

  /* TAMP and Backup registers privilege configuration */
  privilegeState->tampPrivilegeFull = READ_BIT(tamp_privcfgr, TAMP_PRIVCFGR_TAMPPRIV);

  /* Monotonic registers privilege configuration */
  privilegeState->MonotonicCounterPrivilege = READ_BIT(tamp_privcfgr, TAMP_PRIVCFGR_CNT1PRIV);

  /* Backup registers Zones */
  privilegeState->backupRegisterPrivZone = READ_BIT(tamp_privcfgr, (TAMP_PRIVCFGR_BKPWPRIV | TAMP_PRIVCFGR_BKPRWPRIV));

  /* Backup registers start zones */
  privilegeState->backupRegisterStartZone2 = READ_BIT(tamp_cfgr, TAMP_CFGR_BKPRW) >> TAMP_CFGR_BKPRW_Pos;
  privilegeState->backupRegisterStartZone3 = READ_BIT(tamp_cfgr, TAMP_CFGR_BKPW) >> TAMP_CFGR_BKPW_Pos;

  return HAL_OK;
}
