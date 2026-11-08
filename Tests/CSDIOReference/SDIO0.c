#include "SDIOInternal.h"
#undef USE_HAL_SDIO_REGISTER_CALLBACKS
#define USE_HAL_SDIO_REGISTER_CALLBACKS 0
#undef USE_SDIO_TRANSCEIVER
#define USE_SDIO_TRANSCEIVER 0
#define F_VARIANT CSDIO0
#include "SDIOShim.h"
#include "SDIOPrototypes.h"
#if defined(__clang__) && !defined(__arm__) && !defined(__thumb__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#pragma clang diagnostic ignored "-Wint-to-pointer-cast"
#endif
#include "Upstream/SDIOFunctions.inc"
#include "SDIOVariant.inc"

uintptr_t CSDIO0_DefaultIdentify(void){return (uintptr_t)SDIO_InitCard;}
