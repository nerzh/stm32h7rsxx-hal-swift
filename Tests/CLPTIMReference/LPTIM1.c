#define CP_VARIANT CLPTIM1
#define CP_MODE 1
#include "LPTIMShim.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#include "Upstream/LPTIMFunctions.inc"
#pragma clang diagnostic pop
#include "LPTIMVariant.inc"
