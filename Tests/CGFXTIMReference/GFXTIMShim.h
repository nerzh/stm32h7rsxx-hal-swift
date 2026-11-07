#define CGFX_JOIN_INNER(a,b) a##b
#define CGFX_JOIN(a,b) CGFX_JOIN_INNER(a,b)
#include "Upstream/GFXTIMNamespace.h"
#include "GFXTIMInternal.h"
#undef USE_HAL_GFXTIM_REGISTER_CALLBACKS
#define USE_HAL_GFXTIM_REGISTER_CALLBACKS CGFX_MODE
#define assert_param(expression) ((void)0)
#define READ_REG(reg) CGFXTIM_ReadAddress(&(reg))
#define WRITE_REG(reg,value) CGFXTIM_WriteAddress(&(reg),(value))
#define SET_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg)|(mask))
#define CLEAR_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg)&~(mask))
#define MODIFY_REG(reg,clear,set) WRITE_REG(reg,(READ_REG(reg)&~(clear))|(set))
