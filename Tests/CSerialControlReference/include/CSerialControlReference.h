#ifndef CSERIAL_REFERENCE_H
#define CSERIAL_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CSerialState CSerialState;
size_t CSerial_Size(void);
void CSerial_Reset(CSerialState *,uint32_t kind,uint32_t mode);
uint32_t CSerial_Get(CSerialState *,uint32_t area,uint32_t index);
void CSerial_Set(CSerialState *,uint32_t area,uint32_t index,uint32_t value);
void *CSerial_Buffer(CSerialState *,uint32_t offset);
void *CSerial_GetPointer(CSerialState *,uint32_t index);
void CSerial_SetPointer(CSerialState *,uint32_t index,void *);
void CSerial_Callback(CSerialState *,uint32_t id,uint32_t token,uint32_t size);
void CSerial_SetCallback(CSerialState *,uint32_t id,uint32_t token);
uint32_t CSerial_GetCallback(CSerialState *,uint32_t id);
uint32_t CSerial_Run(CSerialState *,uint32_t op,uint32_t a,uint32_t b,uint32_t c);
uint32_t CSerial_TraceCount(CSerialState *);
uint32_t CSerial_TraceWord(CSerialState *,uint32_t event,uint32_t word);
uint32_t CSerial_ConstantCount(void);
uint32_t CSerial_Constant(uint32_t index);
#endif
