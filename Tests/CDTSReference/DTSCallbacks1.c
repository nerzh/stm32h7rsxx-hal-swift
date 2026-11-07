/* Application overrides of the unchanged weak callbacks. */
#define CDTS_VARIANT CDTS1
#define CDTS_CALLBACK_MODE 1
#include "DTSShim.h"
void HAL_DTS_EndCallback(DTS_HandleTypeDef *h) {(void)h;CDTS_DispatchCallback(0,1);}
void HAL_DTS_AsyncEndCallback(DTS_HandleTypeDef *h) {(void)h;CDTS_DispatchCallback(1,1);}
void HAL_DTS_LowCallback(DTS_HandleTypeDef *h) {(void)h;CDTS_DispatchCallback(2,1);}
void HAL_DTS_AsyncLowCallback(DTS_HandleTypeDef *h) {(void)h;CDTS_DispatchCallback(3,1);}
void HAL_DTS_HighCallback(DTS_HandleTypeDef *h) {(void)h;CDTS_DispatchCallback(4,1);}
void HAL_DTS_AsyncHighCallback(DTS_HandleTypeDef *h) {(void)h;CDTS_DispatchCallback(5,1);}
void HAL_DTS_MspInit(DTS_HandleTypeDef *h) {(void)h;CDTS_DispatchCallback(6,1);}
void HAL_DTS_MspDeInit(DTS_HandleTypeDef *h) {(void)h;CDTS_DispatchCallback(7,1);}
