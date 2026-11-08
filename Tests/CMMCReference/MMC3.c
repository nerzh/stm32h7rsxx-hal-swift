#define VDD_VALUE 1800
#include "MMCInternal.h"
#undef USE_HAL_MMC_REGISTER_CALLBACKS
#define USE_HAL_MMC_REGISTER_CALLBACKS 1
#undef USE_SD_TRANSCEIVER
#define USE_SD_TRANSCEIVER 0
#define F_VARIANT CMMC3
#include "MMCShim.h"
#include "MMCPrototypes.h"
#if defined(__clang__) && !defined(__arm__) && !defined(__thumb__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#pragma clang diagnostic ignored "-Wint-to-pointer-cast"
#endif
#include "Upstream/MMCFunctions.inc"
#include "MMCVariant.inc"
