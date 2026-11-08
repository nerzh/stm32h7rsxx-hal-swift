#ifndef CFMC_INTERNAL_H
#define CFMC_INTERNAL_H
#include "FMCDefinitions.h"
#include "include/CFMCReference.h"
#include <assert.h>
#include <string.h>
struct CFMCState {
uint32_t registers[88];
FMC_NORSRAM_InitTypeDef norsram;
FMC_NORSRAM_TimingTypeDef norsramTiming;
FMC_NAND_InitTypeDef nand;
FMC_NAND_PCC_TimingTypeDef nandTiming;
FMC_SDRAM_InitTypeDef sdram;
FMC_SDRAM_TimingTypeDef sdramTiming;
FMC_SDRAM_CommandTypeDef command;
uint32_t control[16], output;
};
#endif
