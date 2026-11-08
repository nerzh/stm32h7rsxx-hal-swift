#ifndef CFMC_DEFINITIONS_H
#define CFMC_DEFINITIONS_H
#include "stm32h7rsxx_hal_def.h"
#include "Upstream/FMCRegisterTypes.h"
#include "Upstream/FMCBits.h"
FMC_Bank1_TypeDef *CFMC_Bank1(void);
FMC_Bank1E_TypeDef *CFMC_Bank1E(void);
FMC_Bank3_TypeDef *CFMC_Bank3(void);
FMC_Bank5_6_TypeDef *CFMC_Bank56(void);
#define FMC_Bank1_R CFMC_Bank1()
#define FMC_Bank1E_R CFMC_Bank1E()
#define FMC_Bank3_R CFMC_Bank3()
#define FMC_Bank5_6_R CFMC_Bank56()
#include "Upstream/stm32h7rsxx_ll_fmc.h"
#include "FMCPrivate.h"
uint32_t CFMC_Tick(void);
#define HAL_GetTick CFMC_Tick
#define READ_REG(r) (r)
#define WRITE_REG(r,v) ((r)=(v))
#define READ_BIT(r,b) (READ_REG(r)&(b))
#define SET_BIT(r,b) WRITE_REG(r,READ_REG(r)|(b))
#define CLEAR_BIT(r,b) WRITE_REG(r,READ_REG(r)&~(b))
#define CLEAR_REG(r) WRITE_REG(r,0)
#define MODIFY_REG(r,c,s) WRITE_REG(r,(READ_REG(r)&~(c))|(s))
#define HAL_IS_BIT_SET(r,b) (((r)&(b))==(b))
#endif
