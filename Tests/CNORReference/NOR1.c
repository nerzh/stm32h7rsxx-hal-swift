#include "NORInternal.h"
#undef USE_HAL_NOR_REGISTER_CALLBACKS
#define USE_HAL_NOR_REGISTER_CALLBACKS 1
#define F_VARIANT CNOR1
#include "NORShim.h"
#include "NORPrototypes.h"
#include "NORMemoryFunctions.inc"
#include "NORVariant.inc"
