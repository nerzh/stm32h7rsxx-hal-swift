#include "SRAMInternal.h"
#undef USE_HAL_SRAM_REGISTER_CALLBACKS
#define USE_HAL_SRAM_REGISTER_CALLBACKS 1
#define F_VARIANT CSRAM1
#include "SRAMShim.h"
#include "SRAMPrototypes.h"
#include "SRAMMemoryFunctions.inc"
#include "SRAMVariant.inc"
