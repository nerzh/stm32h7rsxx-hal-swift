/* Application overrides of the unchanged weak reference callbacks. */
#include "FLASHShim.h"
void HAL_FLASH_EndOfOperationCallback(uint32_t argument) { CFLASH_DispatchCallback(0,argument); }
void HAL_FLASH_OperationErrorCallback(uint32_t argument) { CFLASH_DispatchCallback(1,argument); }
void HAL_FLASHEx_EccCorrectionCallback(void) { CFLASH_DispatchCallback(2,0); }
void HAL_FLASHEx_EccDetectionCallback(void) { CFLASH_DispatchCallback(3,0); }
