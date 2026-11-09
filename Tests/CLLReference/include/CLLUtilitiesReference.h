#pragma once
#include <stdint.h>
uint32_t CL60_I2CTiming(uint32_t prescaler,uint32_t setup,uint32_t hold,uint32_t high,uint32_t low);
uint32_t CL60_I3CBCR(uint64_t payload);
uint32_t CL60_I3CIBI(uint32_t bcr);
uint32_t CL60_I3CPayload(uint32_t bcr);
uint32_t CL60_I3CController(uint32_t bcr);
