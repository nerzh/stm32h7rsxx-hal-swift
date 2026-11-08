#ifndef CMMC_INTERNAL_H
#define CMMC_INTERNAL_H
#include "MMCDefinitions.h"
#include "../CSDMMCReference/SDMMCInternal.h"
#include "include/CMMCReference.h"
struct CMMCState {
 MMC_HandleTypeDef h;
 CSDMMCState ll;
 SDMMC_TypeDef unusedRegs;
 uint32_t control[64], buffers[4][1024], callbackTrace[1024], output[16];
 HAL_MMC_CardInfoTypeDef cardInfo;
 HAL_MMC_CardCSDTypeDef cardCSD;
 HAL_MMC_CardCIDTypeDef cardCID;
 uint32_t extendedOutput[128], fifoInput[1024], fifoOutput[1024];
};
#if defined(__arm__) || defined(__thumb__)
#define CMMC_THREAD_LOCAL
#else
#define CMMC_THREAD_LOCAL _Thread_local
#endif
extern CMMC_THREAD_LOCAL CMMCState *CMMC_Active;
uint32_t CMMC_ReadFIFO(const SDMMC_TypeDef *);
HAL_StatusTypeDef CMMC_WriteFIFO(SDMMC_TypeDef *,uint32_t *);
void CMMC_Record(CMMCState *,uint32_t,uint32_t,uint32_t);
void CMMC_Default0(MMC_HandleTypeDef *);
void CMMC_Default1(MMC_HandleTypeDef *);
void CMMC_Default2(MMC_HandleTypeDef *);
void CMMC_Default3(MMC_HandleTypeDef *);
void CMMC_Default4(MMC_HandleTypeDef *);
void CMMC_Default5(MMC_HandleTypeDef *);
void CMMC_Default16(MMC_HandleTypeDef *);
void CMMC_Default17(MMC_HandleTypeDef *);
HAL_StatusTypeDef CMMC_RPMB_WriteBlocksCorrected(MMC_HandleTypeDef *,const uint8_t *,uint16_t,uint16_t,const uint8_t *,uint32_t);
HAL_StatusTypeDef CMMC_RPMB_ReadBlocksCorrected(MMC_HandleTypeDef *,uint8_t *,uint16_t,uint16_t,const uint8_t *,uint8_t *,uint32_t);
#endif
