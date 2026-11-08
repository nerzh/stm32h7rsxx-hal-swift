#include "SDRAMInternal.h"
#undef USE_HAL_SDRAM_REGISTER_CALLBACKS
#define USE_HAL_SDRAM_REGISTER_CALLBACKS 0
#define F_VARIANT CSDRAM0
#include "SDRAMShim.h"
#include "SDRAMPrototypes.h"
#include "SDRAMMemoryFunctions.inc"
#include "SDRAMVariant.inc"
