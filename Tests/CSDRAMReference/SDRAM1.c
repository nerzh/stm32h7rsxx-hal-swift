#include "SDRAMInternal.h"
#undef USE_HAL_SDRAM_REGISTER_CALLBACKS
#define USE_HAL_SDRAM_REGISTER_CALLBACKS 1
#define F_VARIANT CSDRAM1
#include "SDRAMShim.h"
#include "SDRAMPrototypes.h"
#include "SDRAMMemoryFunctions.inc"
#include "SDRAMVariant.inc"
