#include "NANDInternal.h"
#undef USE_HAL_NAND_REGISTER_CALLBACKS
#define USE_HAL_NAND_REGISTER_CALLBACKS 1
#define F_VARIANT CNAND1
#include "NANDShim.h"
#include "NANDPrototypes.h"
#include "NANDMemoryFunctions.inc"
#include "NANDVariant.inc"
