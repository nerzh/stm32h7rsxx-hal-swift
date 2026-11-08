#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#include "Upstream/FDCANNamespace.h"
#include "FDCANDefinitions.h"
#undef USE_HAL_FDCAN_REGISTER_CALLBACKS
#define USE_HAL_FDCAN_REGISTER_CALLBACKS F_MODE
#define assert_param(x) ((void)0)
#define SET_BIT(r,b) ((r)|=(b))
#define CLEAR_BIT(r,b) ((r)&=~(b))
#define READ_BIT(r,b) ((r)&(b))
#define WRITE_REG(r,v) ((r)=(v))
#define READ_REG(r) (r)
#define CLEAR_REG(r) ((r)=0)
#define MODIFY_REG(r,c,s) WRITE_REG(r,((READ_REG(r)&~(c))|(s)))
uint32_t CFDCAN_Tick(void);
#define HAL_GetTick() CFDCAN_Tick()
#include "FDCANPrivate.h"
#include "FDCANPrototypes.h"
static const uint8_t DLCtoBytes[]={0,1,2,3,4,5,6,7,8,12,16,20,24,32,48,64};
