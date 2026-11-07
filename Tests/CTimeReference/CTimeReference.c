/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Unmodified function bodies extracted from stm32h7rsxx_hal.c, revision
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748. Surrounding hardware/state shim is new.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.
 */
#include "CTimeReference.h"
#include <string.h>
typedef uint32_t HAL_StatusTypeDef;
typedef uint32_t HAL_TickFreqTypeDef;
#define HAL_OK 0U
#define HAL_ERROR 1U
#define HAL_MAX_DELAY 0xFFFFFFFFU
#define __NVIC_PRIO_BITS 4U
#ifdef __weak
#undef __weak
#endif
#define __weak
#define SysTick_IRQn (-1)
#define SysTick_CTRL_TICKINT_Msk 2U
static _Thread_local CTimeReferenceState *current;
#define uwTick (current->tick)
#define uwTickPrio (current->priority)
#define uwTickFreq (current->frequency)
#define SystemCoreClock (current->coreClock)
#define SysTick (&current->sysTick)
static uint32_t HAL_SYSTICK_Config(uint32_t ticks) {
    current->configCalls++;
    current->configTicks = ticks;
    return current->configResult;
}
static void HAL_NVIC_SetPriority(int irq, uint32_t priority, uint32_t subpriority) {
    (void)irq; (void)subpriority;
    current->priorityCalls++;
    current->lastPriority = priority;
}
/* Override the weak time source to simulate asynchronous ISR progress. */
static uint32_t HAL_GetTick(void) {
    uint32_t value = current->tick;
    current->tick += current->tickStep;
    current->tickReads++;
    return value;
}
__weak HAL_StatusTypeDef HAL_InitTick(uint32_t TickPriority)
{
  HAL_StatusTypeDef  status = HAL_OK;

  /* Check uwTickFreq for MisraC 2012 (even if uwTickFreq is a enum type that doesn't take the value zero)*/
  if ((uint32_t)uwTickFreq != 0U)
  {
    /*Configure the SysTick to have interrupt in 1ms time basis*/
    if (HAL_SYSTICK_Config(SystemCoreClock / (1000U / (uint32_t)uwTickFreq)) == 0U)
    {
      /* Configure the SysTick IRQ priority */
      if (TickPriority < (1UL << __NVIC_PRIO_BITS))
      {
        HAL_NVIC_SetPriority(SysTick_IRQn, TickPriority, 0U);
        uwTickPrio = TickPriority;
      }
      else
      {
        status = HAL_ERROR;
      }
    }
    else
    {
      status = HAL_ERROR;
    }
  }
  else
  {
    status = HAL_ERROR;
  }

  /* Return function status */
  return status;
}

__weak void HAL_IncTick(void)
{
  uwTick += (uint32_t)uwTickFreq;
}

uint32_t HAL_GetTickPrio(void)
{
  return uwTickPrio;
}

HAL_StatusTypeDef HAL_SetTickFreq(HAL_TickFreqTypeDef Freq)
{
  HAL_StatusTypeDef status  = HAL_OK;
  HAL_TickFreqTypeDef prevTickFreq;

  if (uwTickFreq != Freq)
  {
    /* Back up uwTickFreq frequency */
    prevTickFreq = uwTickFreq;

    /* Update uwTickFreq global variable used by HAL_InitTick() */
    uwTickFreq = Freq;

    /* Apply the new tick Freq  */
    status = HAL_InitTick(uwTickPrio);
    if (status != HAL_OK)
    {
      /* Restore previous tick frequency */
      uwTickFreq = prevTickFreq;
    }
  }

  return status;
}

HAL_TickFreqTypeDef HAL_GetTickFreq(void)
{
  return uwTickFreq;
}

__weak void HAL_Delay(uint32_t Delay)
{
  uint32_t tickstart = HAL_GetTick();
  uint32_t wait = Delay;

  /* Add a period to ensure minimum wait */
  if (wait < HAL_MAX_DELAY)
  {
    wait += (uint32_t)uwTickFreq;
  }

  while ((HAL_GetTick() - tickstart) < wait)
  {
  }
}

__weak void HAL_SuspendTick(void)
{
  /* Disable SysTick Interrupt */
  SysTick->CTRL &= ~SysTick_CTRL_TICKINT_Msk;
}

__weak void HAL_ResumeTick(void)
{
  /* Enable SysTick Interrupt */
  SysTick->CTRL  |= SysTick_CTRL_TICKINT_Msk;
}
void CTime_Reset(CTimeReferenceState *state) {
    memset(state, 0, sizeof(*state));
    state->priority = 16;
    state->frequency = 1;
    state->coreClock = 64000000;
}
uint32_t CTime_InitTick(CTimeReferenceState *state, uint32_t priority) {
    current = state; return HAL_InitTick(priority);
}
void CTime_IncTick(CTimeReferenceState *state) { current=state; HAL_IncTick(); }
uint32_t CTime_SetFrequency(CTimeReferenceState *state, uint32_t frequency) {
    current=state; return HAL_SetTickFreq(frequency);
}
void CTime_Delay(CTimeReferenceState *state, uint32_t delay) { current=state; HAL_Delay(delay); }
void CTime_Suspend(CTimeReferenceState *state) { current=state; HAL_SuspendTick(); }
void CTime_Resume(CTimeReferenceState *state) { current=state; HAL_ResumeTick(); }
