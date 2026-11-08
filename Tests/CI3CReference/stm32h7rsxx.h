#ifndef CI3C_DEVICE_H
#define CI3C_DEVICE_H
#include "stm32h7rsxx_hal_def.h"
#define __IO volatile
#define __STATIC_INLINE static inline
#define __STATIC_FORCEINLINE static inline
#define I3C1 ((I3C_TypeDef *)0x40005400)
#include "Upstream/I3CRegisterType.h"
#include "Upstream/I3CBits.h"
uint32_t CI3C_ReadVolatile(volatile const uint32_t *);
void CI3C_WriteVolatile(volatile uint32_t *,uint32_t);
uint32_t CI3C_ReadVolatile(volatile const uint32_t *);
void CI3C_WriteVolatile(volatile uint32_t *,uint32_t);
#define READ_REG(r) CI3C_ReadVolatile(&(r))
#define WRITE_REG(r,v) CI3C_WriteVolatile(&(r),(v))
#define READ_BIT(r,b) (READ_REG(r)&(b))
#define SET_BIT(r,b) WRITE_REG(r,READ_REG(r)|(b))
#define CLEAR_BIT(r,b) WRITE_REG(r,READ_REG(r)&~(b))
#define CLEAR_REG(r) WRITE_REG(r,0)
#define MODIFY_REG(r,c,s) WRITE_REG(r,(READ_REG(r)&~(c))|(s))
#endif
