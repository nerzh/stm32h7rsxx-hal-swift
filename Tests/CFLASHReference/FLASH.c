#include "FLASHShim.h"
#include "Upstream/FLASHPrototypes.inc"
/* The unchanged 32-bit program helpers are compiled on hosts but only their
 * pre-write failure paths execute there. Successful writes are ARM-only. */
#if !defined(CFLASH_REFERENCE_ARM) && defined(__clang__)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wint-to-pointer-cast"
#endif
#include "Upstream/FLASHFunctions.inc"
#if !defined(CFLASH_REFERENCE_ARM) && defined(__clang__)
#pragma clang diagnostic pop
#endif
