#ifndef C_GPIO_REFERENCE_H
#define C_GPIO_REFERENCE_H

#include <stdint.h>

/* Host-only register storage. It deliberately does not emulate device side effects. */
typedef struct {
  volatile uint32_t MODER, OTYPER, OSPEEDR, PUPDR, IDR, ODR, BSRR, BRR, LCKR;
  volatile uint32_t AFR[2];
} CGPIOReferenceGPIO;

typedef struct {
  volatile uint32_t RTSR1, FTSR1, EMR1, IMR1, PR1;
} CGPIOReferenceEXTI;

typedef struct {
  volatile uint32_t EXTICR[4];
} CGPIOReferenceSBS;

typedef struct {
  CGPIOReferenceGPIO gpio;
  CGPIOReferenceEXTI exti;
  CGPIOReferenceSBS sbs;
  uint32_t portIndex;
  uint32_t callbackCount;
  uint32_t callbackPins;
} CGPIOReferenceState;

typedef enum {
  CGPIOReference_MODER,
  CGPIOReference_OTYPER,
  CGPIOReference_OSPEEDR,
  CGPIOReference_PUPDR,
  CGPIOReference_IDR,
  CGPIOReference_ODR,
  CGPIOReference_BSRR,
  CGPIOReference_BRR,
  CGPIOReference_LCKR,
  CGPIOReference_AFRL,
  CGPIOReference_AFRH,
  CGPIOReference_EXTICR0,
  CGPIOReference_EXTICR1,
  CGPIOReference_EXTICR2,
  CGPIOReference_EXTICR3,
  CGPIOReference_RTSR1,
  CGPIOReference_FTSR1,
  CGPIOReference_EMR1,
  CGPIOReference_IMR1,
  CGPIOReference_PR1,
  CGPIOReference_RegisterCount
} CGPIOReferenceRegister;

void CGPIOReference_Reset(CGPIOReferenceState *state, uint32_t portIndex);
uint32_t CGPIOReference_Get(const CGPIOReferenceState *state, CGPIOReferenceRegister reg);
void CGPIOReference_Set(CGPIOReferenceState *state, CGPIOReferenceRegister reg, uint32_t value);
void CGPIOReference_Init(CGPIOReferenceState *state, uint32_t pins, uint32_t mode,
                         uint32_t pull, uint32_t speed, uint32_t alternate);
void CGPIOReference_DeInit(CGPIOReferenceState *state, uint32_t pins);
uint32_t CGPIOReference_ReadPin(CGPIOReferenceState *state, uint16_t pins);
void CGPIOReference_WritePin(CGPIOReferenceState *state, uint16_t pins, uint32_t pinState);
void CGPIOReference_WriteMultipleStatePin(CGPIOReferenceState *state, uint16_t reset, uint16_t set);
void CGPIOReference_TogglePin(CGPIOReferenceState *state, uint16_t pins);
uint32_t CGPIOReference_LockPin(CGPIOReferenceState *state, uint16_t pins);
void CGPIOReference_IRQHandler(CGPIOReferenceState *state, uint16_t pins);
uint32_t CGPIOReference_CallbackCount(const CGPIOReferenceState *state);
uint32_t CGPIOReference_CallbackPins(const CGPIOReferenceState *state);

#endif
