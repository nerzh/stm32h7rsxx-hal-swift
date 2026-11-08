#ifndef CADC_DEVICE_H
#define CADC_DEVICE_H
#include <stdint.h>
#include <stddef.h>
#include "stm32h7rsxx_hal_def.h"
#include "Upstream/ADCBits.h"
extern ADC_TypeDef *CADC_ADC1,*CADC_ADC2;
extern ADC_Common_TypeDef *CADC_Common;
#define ADC1 CADC_ADC1
#define ADC2 CADC_ADC2
#define ADC12_COMMON CADC_Common
#define __STATIC_INLINE static inline
#define READ_REG(r) (r)
#define WRITE_REG(r,v) ((r)=(v))
uint32_t CADC_ReadBits(const volatile uint32_t *,uint32_t);
#define READ_BIT(r,b) CADC_ReadBits(&(r),(b))
#define SET_BIT(r,m) ((r)|=(m))
#define CLEAR_BIT(r,m) ((r)&=~(m))
#define MODIFY_REG(r,c,s) ((r)=(((r)&~(c))|(s)))
#define HAL_IS_BIT_SET(r,m) (((r)&(m))!=0U)
#define HAL_IS_BIT_CLR(r,m) (((r)&(m))==0U)
#define UNUSED(x) ((void)(x))
#define POSITION_VAL(x) ((uint32_t)(x)==0U?32U:(uint32_t)__builtin_ctz((uint32_t)(x)))
#define ADC_MULTIMODE_SUPPORT
#define __CLZ(x) ((uint32_t)(x)==0U?32U:(uint32_t)__builtin_clz((uint32_t)(x)))
#endif
