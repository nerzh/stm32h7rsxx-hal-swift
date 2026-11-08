#include "SDMMCDefinitions.h"
#if defined(__clang__) && !defined(__arm__) && !defined(__thumb__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#pragma clang diagnostic ignored "-Wint-to-pointer-cast"
#endif
#define SDMMC_GetResponse CSDMMC_OriginalGetResponse
#include "Upstream/SDMMCResponse.inc"
#undef SDMMC_GetResponse
uint32_t SDMMC_GetResponse(const SDMMC_TypeDef *regs,uint32_t response) {
#if defined(__arm__) || defined(__thumb__)
 return CSDMMC_OriginalGetResponse(regs,response);
#else
 return *(volatile const uint32_t *)((uintptr_t)&regs->RESP1+response);
#endif
}
static uint32_t SDMMC_GetCmdError(SDMMC_TypeDef *SDMMCx);
#define SDMMC_ReadFIFO CSDMMC_OriginalReadFIFO
#define SDMMC_WriteFIFO CSDMMC_OriginalWriteFIFO
#include "Upstream/SDMMCFunctions.inc"
#undef SDMMC_ReadFIFO
#undef SDMMC_WriteFIFO
uint32_t SDMMC_ReadFIFO(const SDMMC_TypeDef *r){uint32_t v=CSDMMC_OriginalReadFIFO(r);CSDMMC_FIFOAfterWord();return v;}
HAL_StatusTypeDef SDMMC_WriteFIFO(SDMMC_TypeDef *r,uint32_t *v){HAL_StatusTypeDef result=CSDMMC_OriginalWriteFIFO(r,v);CSDMMC_FIFOAfterWord();return result;}
uint32_t CSDMMC_GetCmdError(SDMMC_TypeDef *regs){return SDMMC_GetCmdError(regs);}
