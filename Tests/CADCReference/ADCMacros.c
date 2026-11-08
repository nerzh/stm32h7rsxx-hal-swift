#include "ADCInternal.h"
static uint16_t factory[3];
#undef VREFINT_CAL_ADDR
#undef TEMPSENSOR_CAL1_ADDR
#undef TEMPSENSOR_CAL2_ADDR
#define VREFINT_CAL_ADDR (&factory[0])
#define TEMPSENSOR_CAL1_ADDR (&factory[1])
#define TEMPSENSOR_CAL2_ADDR (&factory[2])
void CADC_SetFactory(uint32_t i,uint16_t v) { assert(i<3);factory[i]=v; }
uint32_t CADC_Macro(uint32_t op,uint32_t a,uint32_t b,uint32_t c,uint32_t d,uint32_t e,uint32_t f) {
 switch(op) {
 case 0:return __HAL_ADC_CHANNEL_TO_DECIMAL_NB(a);
 case 1:return __HAL_ADC_DECIMAL_NB_TO_CHANNEL(a);
 case 2:return __HAL_ADC_IS_CHANNEL_INTERNAL(a);
 case 3:return __HAL_ADC_CHANNEL_INTERNAL_TO_EXTERNAL(a);
 case 4:return __HAL_ADC_IS_CHANNEL_INTERNAL_AVAILABLE(b?ADC2:ADC1,a);
 case 5:return __HAL_ADC_MULTI_CONV_DATA_MASTER_SLAVE(a,b);
 case 6:return __HAL_ADC_DIGITAL_SCALE(a);
 case 7:return __HAL_ADC_CONVERT_DATA_RESOLUTION(a,b,c);
 case 8:return __HAL_ADC_CALC_DATA_TO_VOLTAGE(a,b,c);
 case 9:return (uint32_t)__HAL_ADC_CALC_DIFF_DATA_TO_VOLTAGE(a,b,c);
 case 10:return __HAL_ADC_CALC_VREFANALOG_VOLTAGE(a,b);
 case 11:return (uint32_t)__HAL_ADC_CALC_TEMPERATURE(a,b,c);
 case 12:return (uint32_t)__HAL_ADC_CALC_TEMPERATURE_TYP_PARAMS(a,b,(int32_t)c,d,e,f);
 default:assert(0);return 0;
 }
}
