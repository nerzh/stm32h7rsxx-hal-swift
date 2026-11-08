#ifndef CADC_LL_ADC_H
#define CADC_LL_ADC_H
#include "Upstream/ADCInlineDefinitions.h"
/* Host pointers are wider than MCU addresses; preserve register-relative word offsets. */
#undef __ADC_PTR_REG_OFFSET
#define __ADC_PTR_REG_OFFSET(r,o) ((__IO uint32_t *)((uintptr_t)&(r)+((uintptr_t)(o)<<2U)))
#include "Upstream/ADCInlineFunctions.inc"
#endif
