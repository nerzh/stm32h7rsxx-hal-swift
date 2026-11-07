#include "include/CGPIOReference.h"
#include "Upstream/stm32h7rsxx_hal.h"
#include <assert.h>
#include <stddef.h>
#include <string.h>

_Thread_local CGPIOReferenceState *CGPIOReference_Current;

void CGPIOReference_Reset(CGPIOReferenceState *state, uint32_t portIndex) {
  memset(state, 0, sizeof(*state));
  state->portIndex = portIndex;
}

static const volatile uint32_t *registerPointer(const CGPIOReferenceState *state,
                                               CGPIOReferenceRegister reg) {
  switch (reg) {
    case CGPIOReference_MODER: return &state->gpio.MODER;
    case CGPIOReference_OTYPER: return &state->gpio.OTYPER;
    case CGPIOReference_OSPEEDR: return &state->gpio.OSPEEDR;
    case CGPIOReference_PUPDR: return &state->gpio.PUPDR;
    case CGPIOReference_IDR: return &state->gpio.IDR;
    case CGPIOReference_ODR: return &state->gpio.ODR;
    case CGPIOReference_BSRR: return &state->gpio.BSRR;
    case CGPIOReference_BRR: return &state->gpio.BRR;
    case CGPIOReference_LCKR: return &state->gpio.LCKR;
    case CGPIOReference_AFRL: return &state->gpio.AFR[0];
    case CGPIOReference_AFRH: return &state->gpio.AFR[1];
    case CGPIOReference_EXTICR0: return &state->sbs.EXTICR[0];
    case CGPIOReference_EXTICR1: return &state->sbs.EXTICR[1];
    case CGPIOReference_EXTICR2: return &state->sbs.EXTICR[2];
    case CGPIOReference_EXTICR3: return &state->sbs.EXTICR[3];
    case CGPIOReference_RTSR1: return &state->exti.RTSR1;
    case CGPIOReference_FTSR1: return &state->exti.FTSR1;
    case CGPIOReference_EMR1: return &state->exti.EMR1;
    case CGPIOReference_IMR1: return &state->exti.IMR1;
    case CGPIOReference_PR1: return &state->exti.PR1;
    case CGPIOReference_RegisterCount: break;
  }
  assert(!"Invalid reference register");
  return NULL;
}

uint32_t CGPIOReference_Get(const CGPIOReferenceState *state, CGPIOReferenceRegister reg) {
  return *registerPointer(state, reg);
}

void CGPIOReference_Set(CGPIOReferenceState *state, CGPIOReferenceRegister reg, uint32_t value) {
  *(volatile uint32_t *)registerPointer(state, reg) = value;
}

void CGPIOReference_Init(CGPIOReferenceState *state, uint32_t pins, uint32_t mode,
                         uint32_t pull, uint32_t speed, uint32_t alternate) {
  CGPIOReference_Current = state;
  GPIO_InitTypeDef config = { pins, mode, pull, speed, alternate };
  HAL_GPIO_Init(&state->gpio, &config);
}

void CGPIOReference_DeInit(CGPIOReferenceState *state, uint32_t pins) {
  CGPIOReference_Current = state;
  HAL_GPIO_DeInit(&state->gpio, pins);
}

uint32_t CGPIOReference_ReadPin(CGPIOReferenceState *state, uint16_t pins) {
  CGPIOReference_Current = state;
  return (uint32_t)HAL_GPIO_ReadPin(&state->gpio, pins);
}

void CGPIOReference_WritePin(CGPIOReferenceState *state, uint16_t pins, uint32_t pinState) {
  CGPIOReference_Current = state;
  HAL_GPIO_WritePin(&state->gpio, pins, (GPIO_PinState)pinState);
}

void CGPIOReference_WriteMultipleStatePin(CGPIOReferenceState *state, uint16_t reset, uint16_t set) {
  CGPIOReference_Current = state;
  HAL_GPIO_WriteMultipleStatePin(&state->gpio, reset, set);
}

void CGPIOReference_TogglePin(CGPIOReferenceState *state, uint16_t pins) {
  CGPIOReference_Current = state;
  HAL_GPIO_TogglePin(&state->gpio, pins);
}

uint32_t CGPIOReference_LockPin(CGPIOReferenceState *state, uint16_t pins) {
  CGPIOReference_Current = state;
  return (uint32_t)HAL_GPIO_LockPin(&state->gpio, pins);
}

void CGPIOReference_IRQHandler(CGPIOReferenceState *state, uint16_t pins) {
  CGPIOReference_Current = state;
  HAL_GPIO_EXTI_IRQHandler(pins);
}

void HAL_GPIO_EXTI_Callback(uint16_t pins) {
  CGPIOReference_Current->callbackPins = pins;
  CGPIOReference_Current->callbackCount += 1;
}

uint32_t CGPIOReference_CallbackCount(const CGPIOReferenceState *state) {
  return state->callbackCount;
}

uint32_t CGPIOReference_CallbackPins(const CGPIOReferenceState *state) {
  return state->callbackPins;
}
