#ifndef CSDMMC_INTERNAL_H
#define CSDMMC_INTERNAL_H
#include "SDMMCDefinitions.h"
#include "include/CSDMMCReference.h"
#include <assert.h>
#include <string.h>
struct CSDMMCState {
 SDMMC_TypeDef regs;
 uint32_t control[16], responses[64][6], commandTrace[1024];
 SDMMC_InitTypeDef configuration;
 SDMMC_CmdInitTypeDef command;
 SDMMC_DataInitTypeDef data;
 SDMMC_DMALinkNodeConfTypeDef nodeConfiguration;
 SDMMC_DMALinkedListTypeDef list;
 SDMMC_DMALinkNodeTypeDef nodes[8];
 uint32_t output;
};
void CSDMMC_Bind(SDMMC_TypeDef *,uint32_t *,uint32_t *,uint32_t *);
uint32_t CSDMMC_GetCmdError(SDMMC_TypeDef *);
#endif
