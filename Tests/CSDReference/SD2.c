#include "SDInternal.h"
#undef USE_HAL_SD_REGISTER_CALLBACKS
#define USE_HAL_SD_REGISTER_CALLBACKS 0
#undef USE_SD_TRANSCEIVER
#define USE_SD_TRANSCEIVER 1
#define F_VARIANT CSD2
#include "SDShim.h"
#include "SDPrototypes.h"
#if defined(__clang__) && !defined(__arm__) && !defined(__thumb__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#pragma clang diagnostic ignored "-Wint-to-pointer-cast"
#endif
#include "Upstream/SDFunctions.inc"
#include "SDVariant.inc"
