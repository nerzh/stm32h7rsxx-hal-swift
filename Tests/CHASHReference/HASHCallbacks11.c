/* Application overrides for the original weak callback symbols. */
#define CHASH_VARIANT CHASH11
#define CHASH_CALLBACK_MODE 1
#define CHASH_SUSPEND_MODE 1
#include "HASHShim.h"
void HAL_HASH_MspInit(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,0,1);}
void HAL_HASH_MspDeInit(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,1,1);}
void HAL_HASH_InCpltCallback(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,2,1);}
void HAL_HASH_DgstCpltCallback(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,3,1);}
void HAL_HASH_ErrorCallback(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,4,1);}
