#ifndef CJPEG_REFERENCE_H
#define CJPEG_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CJPEGState CJPEGState;
uint32_t CJPEG_NormalizeAddress(uint32_t address,uint32_t dataBase,uint32_t registerBase);
size_t CJPEG_Size(void);
void CJPEG_Reset(CJPEGState *,uint32_t);
uint32_t CJPEG_Get(CJPEGState *,uint32_t,uint32_t);
void CJPEG_Set(CJPEGState *,uint32_t,uint32_t,uint32_t);
uint32_t CJPEG_GetCallback(CJPEGState *,uint32_t);
void CJPEG_SetCallback(CJPEGState *,uint32_t,uint32_t);
void CJPEG_Callback(CJPEGState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CJPEG_Tick(CJPEGState *);
uint32_t CJPEG_Start(CJPEGState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CJPEG_Abort(CJPEGState *,uint32_t,uint32_t);
uint32_t CJPEG_Run(CJPEGState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CJPEG_TraceWord(CJPEGState *,uint32_t,uint32_t);
uint8_t *CJPEG_Buffer(CJPEGState *,uint32_t);
uint8_t *CJPEG_GetBuffer(CJPEGState *,uint32_t);
void CJPEG_SetBuffer(CJPEGState *,uint32_t,uint8_t *);
const uint8_t *CJPEG_GetQuantization(CJPEGState *,uint32_t);
void CJPEG_SetQuantization(CJPEGState *,uint32_t,const uint8_t *);
uint8_t *CJPEG_CustomQuantization(CJPEGState *,uint32_t);
uint32_t *CJPEG_Configuration(CJPEGState *);
uint32_t CJPEG_Huffman(uint32_t,const uint8_t *,const uint8_t *,uint32_t *,uint8_t *);
uint32_t CJPEG_Constant(uint32_t);
#endif
