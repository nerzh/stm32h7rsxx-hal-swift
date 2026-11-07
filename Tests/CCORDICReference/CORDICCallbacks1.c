/* Application overrides of the unchanged weak callbacks. */
#define CCORDIC_VARIANT CCORDIC1
#define CCORDIC_CALLBACK_MODE 1
#include "CORDICShim.h"
void HAL_CORDIC_ErrorCallback(CORDIC_HandleTypeDef *h){CCORDIC_DispatchCallback(h,0,1);}
void HAL_CORDIC_CalculateCpltCallback(CORDIC_HandleTypeDef *h){CCORDIC_DispatchCallback(h,1,1);}
void HAL_CORDIC_MspInit(CORDIC_HandleTypeDef *h){CCORDIC_DispatchCallback(h,2,1);}
void HAL_CORDIC_MspDeInit(CORDIC_HandleTypeDef *h){CCORDIC_DispatchCallback(h,3,1);}
