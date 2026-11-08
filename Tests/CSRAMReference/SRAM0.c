#include "SRAMInternal.h"
#undef USE_HAL_SRAM_REGISTER_CALLBACKS
#define USE_HAL_SRAM_REGISTER_CALLBACKS 0
#define F_VARIANT CSRAM0
#include "SRAMShim.h"
#include "SRAMPrototypes.h"
#include "SRAMMemoryFunctions.inc"
#include "SRAMVariant.inc"
