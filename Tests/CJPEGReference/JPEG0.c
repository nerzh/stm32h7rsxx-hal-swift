#define F_MODE 0
#define F_VARIANT CJPEG0
#include "JPEGShim.h"
#include "Upstream/JPEGFunctions.inc"
#include "JPEGVariant.inc"

uint32_t CJPEG_Huffman(uint32_t ac,const uint8_t *bits,const uint8_t *symbols,uint32_t *codes,uint8_t *lengths) {
 if(ac) {
  JPEG_ACHuffTableTypeDef input;JPEG_AC_HuffCodeTableTypeDef output;
  memcpy(input.Bits,bits,16);memcpy(input.HuffVal,symbols,162);
  memcpy(output.HuffmanCode,codes,162*4);memcpy(output.CodeLength,lengths,162);
  uint32_t status=JPEG_ACHuff_BitsVals_To_SizeCodes(&input,&output);
  memcpy(codes,output.HuffmanCode,162*4);memcpy(lengths,output.CodeLength,162);return status;
 }
 JPEG_DCHuffTableTypeDef input;JPEG_DC_HuffCodeTableTypeDef output;
 memcpy(input.Bits,bits,16);memcpy(input.HuffVal,symbols,12);
 memcpy(output.HuffmanCode,codes,12*4);memcpy(output.CodeLength,lengths,12);
 uint32_t status=JPEG_DCHuff_BitsVals_To_SizeCodes(&input,&output);
 memcpy(codes,output.HuffmanCode,12*4);memcpy(lengths,output.CodeLength,12);return status;
}
