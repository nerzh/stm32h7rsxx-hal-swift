/* Original driver compiled for one option combination. */
#define CHASH_VARIANT CHASH10
#define CHASH_CALLBACK_MODE 1
#define CHASH_SUSPEND_MODE 0
#include "HASHShim.h"
/* Host control tests intentionally never execute the narrowed dereferences.
 * The same unchanged functions execute complete data paths on 32-bit ARM. */
#if UINTPTR_MAX > UINT32_MAX
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#pragma clang diagnostic ignored "-Wint-to-pointer-cast"
#endif
#include "Upstream/HASHFunctions.inc"
#if UINTPTR_MAX > UINT32_MAX
#pragma clang diagnostic pop
#endif
#include "HASHVariantWrappers.inc"
