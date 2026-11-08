#ifndef CSDIO_INTERNAL_H
#define CSDIO_INTERNAL_H
#include "SDIODefinitions.h"
#include "../CSDMMCReference/SDMMCInternal.h"
#include "include/CSDIOReference.h"
struct CSDIOState {
 SDIO_HandleTypeDef h;
 CSDMMCState ll;
 SDMMC_TypeDef unusedRegs;
 uint32_t control[64], buffers[4][1024], callbackTrace[1024], output[16];
 HAL_SDIO_CCCR_TypeDef commonControl;
 HAL_SDIO_FBR_t functions[7];
 HAL_SDIO_DirectCmd_TypeDef directCommand;
 HAL_SDIO_ExtendedCmd_TypeDef extendedCommand;
 uint8_t cardMemory[2048];
 uint32_t fifoOutput[1024];
};
#if defined(__arm__) || defined(__thumb__)
#define CSDIO_THREAD_LOCAL
#else
#define CSDIO_THREAD_LOCAL _Thread_local
#endif
extern CSDIO_THREAD_LOCAL CSDIOState *CSDIO_Active;
void CSDIO_Record(CSDIOState *,uint32_t,uint32_t,uint32_t);
void CSDIO_Default18(SDIO_HandleTypeDef *,FlagStatus);
HAL_StatusTypeDef CSDIO_IdentifyCustom(SDIO_HandleTypeDef *);
void CSDIO_FunctionCustom(SDIO_HandleTypeDef *,uint32_t);
void CSDIO_WriteVolatile(volatile uint32_t *,uint32_t);
uintptr_t CSDIO_DefaultIdentify(uint32_t);
void CSDIO_Default0(SDIO_HandleTypeDef *);
void CSDIO_Default1(SDIO_HandleTypeDef *);
void CSDIO_Default2(SDIO_HandleTypeDef *);
void CSDIO_Default16(SDIO_HandleTypeDef *);
void CSDIO_Default17(SDIO_HandleTypeDef *);
#endif
