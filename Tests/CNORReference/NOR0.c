#include "NORInternal.h"
#undef USE_HAL_NOR_REGISTER_CALLBACKS
#define USE_HAL_NOR_REGISTER_CALLBACKS 0
#define F_VARIANT CNOR0
#include "NORShim.h"
#include "NORPrototypes.h"
#include "NORMemoryFunctions.inc"
#include "NORVariant.inc"
