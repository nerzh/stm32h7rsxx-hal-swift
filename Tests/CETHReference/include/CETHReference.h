#ifndef CETH_REFERENCE_H
#define CETH_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CETHState CETHState;
size_t CETH_Size(void);
void CETH_Reset(CETHState *,uint32_t callbacks,uint32_t ptp,uint32_t rings);
uint32_t CETH_Run(CETHState *,uint32_t op,uint32_t a,uint32_t b,uint32_t c);
uint32_t CETH_GetRegister(CETHState *,uint32_t offset);
void CETH_SetRegister(CETHState *,uint32_t offset,uint32_t value);
uint32_t CETH_GetWord(CETHState *,uint32_t word);
void CETH_SetWord(CETHState *,uint32_t word,uint32_t value);
void *CETH_GetPointer(CETHState *,uint32_t pointer);
void CETH_SetPointer(CETHState *,uint32_t pointer,void *value);
void **CETH_PointerStorage(CETHState *,uint32_t pointer);
uint32_t CETH_GetDescriptorAddress(CETHState *,uint32_t ring,uint32_t index);
void CETH_SetDescriptorAddress(CETHState *,uint32_t ring,uint32_t index,uint32_t address);
uint32_t *CETH_GetTransmitPacket(CETHState *,uint32_t index);
void CETH_SetTransmitPacket(CETHState *,uint32_t index,uint32_t *value);
uint32_t *CETH_TransmitTimestamp(CETHState *);
uint32_t CETH_GetConfiguration(CETHState *,uint32_t kind,uint32_t field);
void CETH_SetConfiguration(CETHState *,uint32_t kind,uint32_t field,uint32_t value);
uint32_t *CETH_Control(CETHState *);
uint32_t *CETH_Trace(CETHState *);
uint32_t CETH_TickFor(CETHState *);
uint32_t CETH_Constant(uint32_t);
uint32_t CETH_RegisterSize(void);
uint32_t *CETH_Buffer(CETHState *,uint32_t index);
uint32_t CETH_HCLKFor(CETHState *);
void CETH_WriteGlobal(CETHState *,uint32_t offset,uint32_t value);
uint32_t CETH_ReadGlobal(CETHState *,uint32_t offset);
void CETH_Event(CETHState *,uint32_t index,uint32_t due,uint32_t offset,uint32_t value);
void *CETH_Callback(uint32_t id,uint32_t token);
void *CETH_GetCallback(CETHState *,uint32_t id);
void CETH_SetCallback(CETHState *,uint32_t id,void *value);
void CETH_Activate(CETHState *);
uint32_t CETH_GetEXTI(CETHState *,uint32_t index);
void CETH_SetEXTI(CETHState *,uint32_t index,uint32_t value);
uint32_t CETH_Platform(CETHState *,uint32_t op,uint32_t value);
uint32_t CETH_GetPacketWord(CETHState *,uint32_t index);
void CETH_SetPacketWord(CETHState *,uint32_t index,uint32_t value);
void *CETH_PacketBuffer(CETHState *);
void *CETH_PacketData(CETHState *);
uint32_t CETH_Normalize(CETHState *,uintptr_t value);
uint32_t CETH_Layout(uint32_t);
void CETH_SetPacketData(CETHState *,void *);
#endif
