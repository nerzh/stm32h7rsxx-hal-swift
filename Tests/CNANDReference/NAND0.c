#include "NANDInternal.h"
#undef USE_HAL_NAND_REGISTER_CALLBACKS
#define USE_HAL_NAND_REGISTER_CALLBACKS 0
#define F_VARIANT CNAND0
#include "NANDShim.h"
#include "NANDPrototypes.h"
#include "NANDMemoryFunctions.inc"
#include "NANDVariant.inc"
