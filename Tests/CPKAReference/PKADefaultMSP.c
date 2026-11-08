#include "PKAInternal.h"
#define F_MODE 1
#define F_VARIANT CPKA1
#include "PKAShim.h"
#define HAL_PKA_MspDeInit CPKA_OriginalMSP
#define __HAL_RCC_PKA_FORCE_RESET() CPKA_System(CPKA_Active,0)
#define __HAL_RCC_PKA_RELEASE_RESET() CPKA_System(CPKA_Active,1)
#define __HAL_RCC_PKA_CLK_DISABLE() CPKA_System(CPKA_Active,2)
#define HAL_NVIC_DisableIRQ(x) CPKA_System(CPKA_Active,3)
#include "Upstream/PKADefaultMSP.inc"
void CPKA_DefaultMSP(CPKAState *s) { CPKA_Active=s;CPKA_OriginalMSP(&s->h); }
