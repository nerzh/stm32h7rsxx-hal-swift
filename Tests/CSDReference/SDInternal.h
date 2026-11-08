#ifndef CSD_INTERNAL_H
#define CSD_INTERNAL_H
#include "SDDefinitions.h"
#include "../CSDMMCReference/SDMMCInternal.h"
#include "include/CSDReference.h"
struct CSDState {
 SD_HandleTypeDef h;
 CSDMMCState ll;
 SDMMC_TypeDef unusedRegs;
 DLYB_TypeDef delay[2];
 uint32_t control[64], buffers[2][1024], callbackTrace[1024], output[16];
 HAL_SD_CardInfoTypeDef cardInfo;
 HAL_SD_CardCSDTypeDef cardCSD;
 HAL_SD_CardCIDTypeDef cardCID;
 HAL_SD_CardStatusTypeDef cardStatus;
};
#if defined(__arm__) || defined(__thumb__)
#define CSD_THREAD_LOCAL
#else
#define CSD_THREAD_LOCAL _Thread_local
#endif
extern CSD_THREAD_LOCAL CSDState *CSD_Active;
void CSD_Record(CSDState *,uint32_t,uint32_t,uint32_t);
void CSD_Default0(SD_HandleTypeDef *);
void CSD_Default1(SD_HandleTypeDef *);
void CSD_Default2(SD_HandleTypeDef *);
void CSD_Default3(SD_HandleTypeDef *);
void CSD_Default4(SD_HandleTypeDef *);
void CSD_Default5(SD_HandleTypeDef *);
void CSD_Default16(SD_HandleTypeDef *);
void CSD_Default17(SD_HandleTypeDef *);
void CSD_Default18(FlagStatus);
#endif
