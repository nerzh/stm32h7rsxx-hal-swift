#include "include/CLLUtilitiesReference.h"
#include "Upstream/I2C/stm32h7rsxx_ll_i2c.h"
#include "Upstream/I2C/stm32h7rsxx_ll_i3c.h"
uint32_t CL60_I2CTiming(uint32_t prescaler,uint32_t setup,uint32_t hold,uint32_t high,uint32_t low){return __LL_I2C_CONVERT_TIMINGS(prescaler,setup,hold,high,low);}
uint32_t CL60_I3CBCR(uint64_t payload){return LL_I3C_GET_BCR(payload);}
uint32_t CL60_I3CIBI(uint32_t bcr){return LL_I3C_GET_IBI_CAPABLE(bcr);}
uint32_t CL60_I3CPayload(uint32_t bcr){return LL_I3C_GET_IBI_PAYLOAD(bcr);}
uint32_t CL60_I3CController(uint32_t bcr){return LL_I3C_GET_CR_CAPABLE(bcr);}
