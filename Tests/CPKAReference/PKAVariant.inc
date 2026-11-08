#include "PKAInternal.h"
static PKA_ECCMulInTypeDef input0(CPKAState *s) { PKA_ECCMulInTypeDef v={0};
v.scalarMulSize=s->params[0][0];
v.modulusSize=s->params[0][1];
v.coefSign=s->params[0][2];
v.coefA=(s->control[6]&(1U<<3))?NULL:(const uint8_t*)s->buffers[3];
v.coefB=(s->control[6]&(1U<<4))?NULL:(const uint8_t*)s->buffers[4];
v.modulus=(s->control[6]&(1U<<5))?NULL:(const uint8_t*)s->buffers[5];
v.pointX=(s->control[6]&(1U<<6))?NULL:(const uint8_t*)s->buffers[6];
v.pointY=(s->control[6]&(1U<<7))?NULL:(const uint8_t*)s->buffers[7];
v.scalarMul=(s->control[6]&(1U<<8))?NULL:(const uint8_t*)s->buffers[8];
v.primeOrder=(s->control[6]&(1U<<9))?NULL:(const uint8_t*)s->buffers[9];
return v;}
static PKA_ECCMulExInTypeDef input1(CPKAState *s) { PKA_ECCMulExInTypeDef v={0};
v.primeOrderSize=s->params[1][0];
v.scalarMulSize=s->params[1][1];
v.modulusSize=s->params[1][2];
v.coefSign=s->params[1][3];
v.coefA=(s->control[6]&(1U<<4))?NULL:(const uint8_t*)s->buffers[4];
v.coefB=(s->control[6]&(1U<<5))?NULL:(const uint8_t*)s->buffers[5];
v.modulus=(s->control[6]&(1U<<6))?NULL:(const uint8_t*)s->buffers[6];
v.pointX=(s->control[6]&(1U<<7))?NULL:(const uint8_t*)s->buffers[7];
v.pointY=(s->control[6]&(1U<<8))?NULL:(const uint8_t*)s->buffers[8];
v.scalarMul=(s->control[6]&(1U<<9))?NULL:(const uint8_t*)s->buffers[9];
v.primeOrder=(s->control[6]&(1U<<10))?NULL:(const uint8_t*)s->buffers[10];
return v;}
static PKA_PointCheckInTypeDef input2(CPKAState *s) { PKA_PointCheckInTypeDef v={0};
v.modulusSize=s->params[2][0];
v.coefSign=s->params[2][1];
v.coefA=(s->control[6]&(1U<<2))?NULL:(const uint8_t*)s->buffers[2];
v.coefB=(s->control[6]&(1U<<3))?NULL:(const uint8_t*)s->buffers[3];
v.modulus=(s->control[6]&(1U<<4))?NULL:(const uint8_t*)s->buffers[4];
v.pointX=(s->control[6]&(1U<<5))?NULL:(const uint8_t*)s->buffers[5];
v.pointY=(s->control[6]&(1U<<6))?NULL:(const uint8_t*)s->buffers[6];
v.pMontgomeryParam=(s->control[6]&(1U<<7))?NULL:(const uint32_t*)s->buffers[7];
return v;}
static PKA_RSACRTExpInTypeDef input3(CPKAState *s) { PKA_RSACRTExpInTypeDef v={0};
v.size=s->params[3][0];
v.pOpDp=(s->control[6]&(1U<<1))?NULL:(const uint8_t*)s->buffers[1];
v.pOpDq=(s->control[6]&(1U<<2))?NULL:(const uint8_t*)s->buffers[2];
v.pOpQinv=(s->control[6]&(1U<<3))?NULL:(const uint8_t*)s->buffers[3];
v.pPrimeP=(s->control[6]&(1U<<4))?NULL:(const uint8_t*)s->buffers[4];
v.pPrimeQ=(s->control[6]&(1U<<5))?NULL:(const uint8_t*)s->buffers[5];
v.popA=(s->control[6]&(1U<<6))?NULL:(const uint8_t*)s->buffers[6];
return v;}
static PKA_ECDSAVerifInTypeDef input4(CPKAState *s) { PKA_ECDSAVerifInTypeDef v={0};
v.primeOrderSize=s->params[4][0];
v.modulusSize=s->params[4][1];
v.coefSign=s->params[4][2];
v.coef=(s->control[6]&(1U<<3))?NULL:(const uint8_t*)s->buffers[3];
v.modulus=(s->control[6]&(1U<<4))?NULL:(const uint8_t*)s->buffers[4];
v.basePointX=(s->control[6]&(1U<<5))?NULL:(const uint8_t*)s->buffers[5];
v.basePointY=(s->control[6]&(1U<<6))?NULL:(const uint8_t*)s->buffers[6];
v.pPubKeyCurvePtX=(s->control[6]&(1U<<7))?NULL:(const uint8_t*)s->buffers[7];
v.pPubKeyCurvePtY=(s->control[6]&(1U<<8))?NULL:(const uint8_t*)s->buffers[8];
v.RSign=(s->control[6]&(1U<<9))?NULL:(const uint8_t*)s->buffers[9];
v.SSign=(s->control[6]&(1U<<10))?NULL:(const uint8_t*)s->buffers[10];
v.hash=(s->control[6]&(1U<<11))?NULL:(const uint8_t*)s->buffers[11];
v.primeOrder=(s->control[6]&(1U<<12))?NULL:(const uint8_t*)s->buffers[12];
return v;}
static PKA_ECDSASignInTypeDef input5(CPKAState *s) { PKA_ECDSASignInTypeDef v={0};
v.primeOrderSize=s->params[5][0];
v.modulusSize=s->params[5][1];
v.coefSign=s->params[5][2];
v.coef=(s->control[6]&(1U<<3))?NULL:(const uint8_t*)s->buffers[3];
v.coefB=(s->control[6]&(1U<<4))?NULL:(const uint8_t*)s->buffers[4];
v.modulus=(s->control[6]&(1U<<5))?NULL:(const uint8_t*)s->buffers[5];
v.integer=(s->control[6]&(1U<<6))?NULL:(const uint8_t*)s->buffers[6];
v.basePointX=(s->control[6]&(1U<<7))?NULL:(const uint8_t*)s->buffers[7];
v.basePointY=(s->control[6]&(1U<<8))?NULL:(const uint8_t*)s->buffers[8];
v.hash=(s->control[6]&(1U<<9))?NULL:(const uint8_t*)s->buffers[9];
v.privateKey=(s->control[6]&(1U<<10))?NULL:(const uint8_t*)s->buffers[10];
v.primeOrder=(s->control[6]&(1U<<11))?NULL:(const uint8_t*)s->buffers[11];
return v;}
static PKA_ECDSASignOutTypeDef input6(CPKAState *s) { PKA_ECDSASignOutTypeDef v={0};
v.RSign=(s->control[6]&(1U<<0))?NULL:(uint8_t*)s->buffers[0];
v.SSign=(s->control[6]&(1U<<1))?NULL:(uint8_t*)s->buffers[1];
return v;}
static PKA_ECDSASignOutExtParamTypeDef input7(CPKAState *s) { PKA_ECDSASignOutExtParamTypeDef v={0};
v.ptX=(s->control[6]&(1U<<0))?NULL:(uint8_t*)s->buffers[0];
v.ptY=(s->control[6]&(1U<<1))?NULL:(uint8_t*)s->buffers[1];
return v;}
static PKA_ECCCompleteAdditionOutTypeDef input8(CPKAState *s) { PKA_ECCCompleteAdditionOutTypeDef v={0};
v.ptX=(s->control[6]&(1U<<0))?NULL:(uint8_t*)s->buffers[0];
v.ptY=(s->control[6]&(1U<<1))?NULL:(uint8_t*)s->buffers[1];
v.ptZ=(s->control[6]&(1U<<2))?NULL:(uint8_t*)s->buffers[2];
return v;}
static PKA_ModExpInTypeDef input9(CPKAState *s) { PKA_ModExpInTypeDef v={0};
v.expSize=s->params[9][0];
v.OpSize=s->params[9][1];
v.pExp=(s->control[6]&(1U<<2))?NULL:(const uint8_t*)s->buffers[2];
v.pOp1=(s->control[6]&(1U<<3))?NULL:(const uint8_t*)s->buffers[3];
v.pMod=(s->control[6]&(1U<<4))?NULL:(const uint8_t*)s->buffers[4];
return v;}
static PKA_ModExpProtectModeInTypeDef input10(CPKAState *s) { PKA_ModExpProtectModeInTypeDef v={0};
v.expSize=s->params[10][0];
v.OpSize=s->params[10][1];
v.pOp1=(s->control[6]&(1U<<2))?NULL:(const uint8_t*)s->buffers[2];
v.pExp=(s->control[6]&(1U<<3))?NULL:(const uint8_t*)s->buffers[3];
v.pMod=(s->control[6]&(1U<<4))?NULL:(const uint8_t*)s->buffers[4];
v.pPhi=(s->control[6]&(1U<<5))?NULL:(const uint8_t*)s->buffers[5];
return v;}
static PKA_ModExpFastModeInTypeDef input11(CPKAState *s) { PKA_ModExpFastModeInTypeDef v={0};
v.expSize=s->params[11][0];
v.OpSize=s->params[11][1];
v.pExp=(s->control[6]&(1U<<2))?NULL:(const uint8_t*)s->buffers[2];
v.pOp1=(s->control[6]&(1U<<3))?NULL:(const uint8_t*)s->buffers[3];
v.pMod=(s->control[6]&(1U<<4))?NULL:(const uint8_t*)s->buffers[4];
v.pMontgomeryParam=(s->control[6]&(1U<<5))?NULL:(const uint32_t*)s->buffers[5];
return v;}
static PKA_MontgomeryParamInTypeDef input12(CPKAState *s) { PKA_MontgomeryParamInTypeDef v={0};
v.size=s->params[12][0];
v.pOp1=(s->control[6]&(1U<<1))?NULL:(const uint8_t*)s->buffers[1];
return v;}
static PKA_AddInTypeDef input13(CPKAState *s) { PKA_AddInTypeDef v={0};
v.size=s->params[13][0];
v.pOp1=(s->control[6]&(1U<<1))?NULL:(const uint32_t*)s->buffers[1];
v.pOp2=(s->control[6]&(1U<<2))?NULL:(const uint32_t*)s->buffers[2];
return v;}
static PKA_ModInvInTypeDef input14(CPKAState *s) { PKA_ModInvInTypeDef v={0};
v.size=s->params[14][0];
v.pOp1=(s->control[6]&(1U<<1))?NULL:(const uint32_t*)s->buffers[1];
v.pMod=(s->control[6]&(1U<<2))?NULL:(const uint8_t*)s->buffers[2];
return v;}
static PKA_ModRedInTypeDef input15(CPKAState *s) { PKA_ModRedInTypeDef v={0};
v.OpSize=s->params[15][0];
v.modSize=s->params[15][1];
v.pOp1=(s->control[6]&(1U<<2))?NULL:(const uint32_t*)s->buffers[2];
v.pMod=(s->control[6]&(1U<<3))?NULL:(const uint8_t*)s->buffers[3];
return v;}
static PKA_ModAddInTypeDef input16(CPKAState *s) { PKA_ModAddInTypeDef v={0};
v.size=s->params[16][0];
v.pOp1=(s->control[6]&(1U<<1))?NULL:(const uint32_t*)s->buffers[1];
v.pOp2=(s->control[6]&(1U<<2))?NULL:(const uint32_t*)s->buffers[2];
v.pOp3=(s->control[6]&(1U<<3))?NULL:(const uint8_t*)s->buffers[3];
return v;}
static PKA_ECCDoubleBaseLadderInTypeDef input17(CPKAState *s) { PKA_ECCDoubleBaseLadderInTypeDef v={0};
v.primeOrderSize=s->params[17][0];
v.modulusSize=s->params[17][1];
v.coefSign=s->params[17][2];
v.coefA=(s->control[6]&(1U<<3))?NULL:(const uint8_t*)s->buffers[3];
v.modulus=(s->control[6]&(1U<<4))?NULL:(const uint8_t*)s->buffers[4];
v.integerK=(s->control[6]&(1U<<5))?NULL:(const uint8_t*)s->buffers[5];
v.integerM=(s->control[6]&(1U<<6))?NULL:(const uint8_t*)s->buffers[6];
v.basePointX1=(s->control[6]&(1U<<7))?NULL:(const uint8_t*)s->buffers[7];
v.basePointY1=(s->control[6]&(1U<<8))?NULL:(const uint8_t*)s->buffers[8];
v.basePointZ1=(s->control[6]&(1U<<9))?NULL:(const uint8_t*)s->buffers[9];
v.basePointX2=(s->control[6]&(1U<<10))?NULL:(const uint8_t*)s->buffers[10];
v.basePointY2=(s->control[6]&(1U<<11))?NULL:(const uint8_t*)s->buffers[11];
v.basePointZ2=(s->control[6]&(1U<<12))?NULL:(const uint8_t*)s->buffers[12];
return v;}
static PKA_ECCProjective2AffineInTypeDef input18(CPKAState *s) { PKA_ECCProjective2AffineInTypeDef v={0};
v.modulusSize=s->params[18][0];
v.modulus=(s->control[6]&(1U<<1))?NULL:(const uint8_t*)s->buffers[1];
v.basePointX=(s->control[6]&(1U<<2))?NULL:(const uint8_t*)s->buffers[2];
v.basePointY=(s->control[6]&(1U<<3))?NULL:(const uint8_t*)s->buffers[3];
v.basePointZ=(s->control[6]&(1U<<4))?NULL:(const uint8_t*)s->buffers[4];
v.pMontgomeryParam=(s->control[6]&(1U<<5))?NULL:(const uint32_t*)s->buffers[5];
return v;}
static PKA_ECCCompleteAdditionInTypeDef input19(CPKAState *s) { PKA_ECCCompleteAdditionInTypeDef v={0};
v.modulusSize=s->params[19][0];
v.coefSign=s->params[19][1];
v.modulus=(s->control[6]&(1U<<2))?NULL:(const uint8_t*)s->buffers[2];
v.coefA=(s->control[6]&(1U<<3))?NULL:(const uint8_t*)s->buffers[3];
v.basePointX1=(s->control[6]&(1U<<4))?NULL:(const uint8_t*)s->buffers[4];
v.basePointY1=(s->control[6]&(1U<<5))?NULL:(const uint8_t*)s->buffers[5];
v.basePointZ1=(s->control[6]&(1U<<6))?NULL:(const uint8_t*)s->buffers[6];
v.basePointX2=(s->control[6]&(1U<<7))?NULL:(const uint8_t*)s->buffers[7];
v.basePointY2=(s->control[6]&(1U<<8))?NULL:(const uint8_t*)s->buffers[8];
v.basePointZ2=(s->control[6]&(1U<<9))?NULL:(const uint8_t*)s->buffers[9];
return v;}
uint32_t F_JOIN(F_VARIANT,_Run)(CPKAState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 PKA_HandleTypeDef *h=&s->h;switch(op) {
case 0:{
return HAL_PKA_Init(h);
}
case 1:{
return HAL_PKA_DeInit(h);
}
case 2:{
#if F_MODE
return HAL_PKA_RegisterCallback(h,a,CPKA_CallbackPointer(a<4?a:0,b));
#else
return 0;
#endif
}
case 3:{
#if F_MODE
return HAL_PKA_UnRegisterCallback(h,a);
#else
return 0;
#endif
}
case 4:{ PKA_ModExpInTypeDef v=input9(s);return HAL_PKA_ModExp(h,&v,b);}
case 5:{ PKA_ModExpInTypeDef v=input9(s);return HAL_PKA_ModExp_IT(h,&v);}
case 6:{ PKA_ModExpFastModeInTypeDef v=input11(s);return HAL_PKA_ModExpFastMode(h,&v,b);}
case 7:{ PKA_ModExpFastModeInTypeDef v=input11(s);return HAL_PKA_ModExpFastMode_IT(h,&v);}
case 8:{ PKA_ModExpProtectModeInTypeDef v=input10(s);return HAL_PKA_ModExpProtectMode(h,&v,b);}
case 9:{ PKA_ModExpProtectModeInTypeDef v=input10(s);return HAL_PKA_ModExpProtectMode_IT(h,&v);}
case 10:{
HAL_PKA_ModExp_GetResult(h,b?NULL:(uint8_t*)s->buffers[16]);return 0;
}
case 11:{ PKA_ECDSASignInTypeDef v=input5(s);return HAL_PKA_ECDSASign(h,&v,b);}
case 12:{ PKA_ECDSASignInTypeDef v=input5(s);return HAL_PKA_ECDSASign_IT(h,&v);}
case 13:{
PKA_ECDSASignOutTypeDef o={.RSign=(uint8_t*)s->buffers[16],.SSign=(uint8_t*)s->buffers[17]};PKA_ECDSASignOutExtParamTypeDef e={.ptX=(uint8_t*)s->buffers[18],.ptY=(uint8_t*)s->buffers[19]};HAL_PKA_ECDSASign_GetResult(h,(b&1)?NULL:&o,(b&2)?NULL:&e);return 0;
}
case 14:{ PKA_ECDSAVerifInTypeDef v=input4(s);return HAL_PKA_ECDSAVerif(h,&v,b);}
case 15:{ PKA_ECDSAVerifInTypeDef v=input4(s);return HAL_PKA_ECDSAVerif_IT(h,&v);}
case 16:{
return HAL_PKA_ECDSAVerif_IsValidSignature(h);
}
case 17:{ PKA_RSACRTExpInTypeDef v=input3(s);return HAL_PKA_RSACRTExp(h,&v,b);}
case 18:{ PKA_RSACRTExpInTypeDef v=input3(s);return HAL_PKA_RSACRTExp_IT(h,&v);}
case 19:{
HAL_PKA_RSACRTExp_GetResult(h,b?NULL:(uint8_t*)s->buffers[16]);return 0;
}
case 20:{ PKA_PointCheckInTypeDef v=input2(s);return HAL_PKA_PointCheck(h,&v,b);}
case 21:{ PKA_PointCheckInTypeDef v=input2(s);return HAL_PKA_PointCheck_IT(h,&v);}
case 22:{
return HAL_PKA_PointCheck_IsOnCurve(h);
}
case 23:{ PKA_ECCMulInTypeDef v=input0(s);return HAL_PKA_ECCMul(h,&v,b);}
case 24:{ PKA_ECCMulInTypeDef v=input0(s);return HAL_PKA_ECCMul_IT(h,&v);}
case 25:{ PKA_ECCMulExInTypeDef v=input1(s);return HAL_PKA_ECCMulEx(h,&v,b);}
case 26:{ PKA_ECCMulExInTypeDef v=input1(s);return HAL_PKA_ECCMulEx_IT(h,&v);}
case 27:{
PKA_ECCMulOutTypeDef o={.ptX=(uint8_t*)s->buffers[16],.ptY=(uint8_t*)s->buffers[17]};HAL_PKA_ECCMul_GetResult(h,b?NULL:&o);return 0;
}
case 28:{ PKA_AddInTypeDef v=input13(s);return HAL_PKA_Add(h,&v,b);}
case 29:{ PKA_AddInTypeDef v=input13(s);return HAL_PKA_Add_IT(h,&v);}
case 30:{ PKA_SubInTypeDef v=input13(s);return HAL_PKA_Sub(h,&v,b);}
case 31:{ PKA_SubInTypeDef v=input13(s);return HAL_PKA_Sub_IT(h,&v);}
case 32:{ PKA_MulInTypeDef v=input13(s);return HAL_PKA_Mul(h,&v,b);}
case 33:{ PKA_MulInTypeDef v=input13(s);return HAL_PKA_Mul_IT(h,&v);}
case 34:{ PKA_CmpInTypeDef v=input13(s);return HAL_PKA_Cmp(h,&v,b);}
case 35:{ PKA_CmpInTypeDef v=input13(s);return HAL_PKA_Cmp_IT(h,&v);}
case 36:{ PKA_ModAddInTypeDef v=input16(s);return HAL_PKA_ModAdd(h,&v,b);}
case 37:{ PKA_ModAddInTypeDef v=input16(s);return HAL_PKA_ModAdd_IT(h,&v);}
case 38:{ PKA_ModInvInTypeDef v=input14(s);return HAL_PKA_ModInv(h,&v,b);}
case 39:{ PKA_ModInvInTypeDef v=input14(s);return HAL_PKA_ModInv_IT(h,&v);}
case 40:{ PKA_ModSubInTypeDef v=input16(s);return HAL_PKA_ModSub(h,&v,b);}
case 41:{ PKA_ModSubInTypeDef v=input16(s);return HAL_PKA_ModSub_IT(h,&v);}
case 42:{ PKA_ModRedInTypeDef v=input15(s);return HAL_PKA_ModRed(h,&v,b);}
case 43:{ PKA_ModRedInTypeDef v=input15(s);return HAL_PKA_ModRed_IT(h,&v);}
case 44:{ PKA_MontgomeryMulInTypeDef v=input16(s);return HAL_PKA_MontgomeryMul(h,&v,b);}
case 45:{ PKA_MontgomeryMulInTypeDef v=input16(s);return HAL_PKA_MontgomeryMul_IT(h,&v);}
case 46:{
HAL_PKA_Arithmetic_GetResult(h,b?NULL:s->buffers[16]);return 0;
}
case 47:{ PKA_MontgomeryParamInTypeDef v=input12(s);return HAL_PKA_MontgomeryParam(h,&v,b);}
case 48:{ PKA_MontgomeryParamInTypeDef v=input12(s);return HAL_PKA_MontgomeryParam_IT(h,&v);}
case 49:{ PKA_ECCDoubleBaseLadderInTypeDef v=input17(s);return HAL_PKA_ECCDoubleBaseLadder(h,&v,b);}
case 50:{ PKA_ECCDoubleBaseLadderInTypeDef v=input17(s);return HAL_PKA_ECCDoubleBaseLadder_IT(h,&v);}
case 51:{ PKA_ECCProjective2AffineInTypeDef v=input18(s);return HAL_PKA_ECCProjective2Affine(h,&v,b);}
case 52:{ PKA_ECCProjective2AffineInTypeDef v=input18(s);return HAL_PKA_ECCProjective2Affine_IT(h,&v);}
case 53:{ PKA_ECCCompleteAdditionInTypeDef v=input19(s);return HAL_PKA_ECCCompleteAddition(h,&v,b);}
case 54:{ PKA_ECCCompleteAdditionInTypeDef v=input19(s);return HAL_PKA_ECCCompleteAddition_IT(h,&v);}
case 55:{
HAL_PKA_MontgomeryParam_GetResult(h,b?NULL:s->buffers[16]);return 0;
}
case 56:{
return HAL_PKA_Abort(h);
}
case 57:{
HAL_PKA_RAMReset(h);return 0;
}
case 58:{
HAL_PKA_IRQHandler(h);return 0;
}
case 59:{
return HAL_PKA_GetState(h);
}
case 60:{
return HAL_PKA_GetError(h);
}
case 61:{
return PKA_GetMode(h);
}
case 62:{
return PKA_PollEndOfOperation(h,b,a);
}
case 63:{
return PKA_CheckError(h,a);
}
case 64:{
return PKA_GetBitSize_u8(a);
}
case 65:{
return PKA_GetOptBitSize_u8(a,b);
}
case 66:{
return PKA_GetBitSize_u32(a);
}
case 67:{
return PKA_GetArraySize_u8(a);
}
case 68:{
PKA_Memcpy_u32_to_u8(b?NULL:(uint8_t*)s->buffers[16],&s->regs.RAM[c],a);return 0;
}
case 69:{
PKA_Memcpy_u8_to_u32(&s->regs.RAM[c],b?NULL:(uint8_t*)s->buffers[0],a);return 0;
}
case 70:{
if(b&2)PKA_Memcpy_u32_to_u32((b&1)?NULL:s->buffers[16],&s->regs.RAM[c],a);else PKA_Memcpy_u32_to_u32(&s->regs.RAM[c],(b&1)?NULL:s->buffers[0],a);return 0;
}
case 71:{
return PKA_Process(h,a,b);
}
case 72:{
return PKA_Process_IT(h,a);
}
case 73:{ PKA_ModExpInTypeDef v=input9(s);PKA_ModExp_Set(h,&v);return 0;}
case 74:{ PKA_ModExpFastModeInTypeDef v=input11(s);PKA_ModExpFastMode_Set(h,&v);return 0;}
case 75:{ PKA_ModExpProtectModeInTypeDef v=input10(s);PKA_ModExpProtectMode_Set(h,&v);return 0;}
case 76:{ PKA_ECDSASignInTypeDef v=input5(s);PKA_ECDSASign_Set(h,&v);return 0;}
case 77:{ PKA_ECDSAVerifInTypeDef v=input4(s);PKA_ECDSAVerif_Set(h,&v);return 0;}
case 78:{ PKA_RSACRTExpInTypeDef v=input3(s);PKA_RSACRTExp_Set(h,&v);return 0;}
case 79:{ PKA_PointCheckInTypeDef v=input2(s);PKA_PointCheck_Set(h,&v);return 0;}
case 80:{ PKA_ECCMulInTypeDef v=input0(s);PKA_ECCMul_Set(h,&v);return 0;}
case 81:{ PKA_ECCMulExInTypeDef v=input1(s);PKA_ECCMulEx_Set(h,&v);return 0;}
case 82:{ PKA_ModInvInTypeDef v=input14(s);PKA_ModInv_Set(h,&v);return 0;}
case 83:{ PKA_ModRedInTypeDef v=input15(s);PKA_ModRed_Set(h,&v);return 0;}
case 84:{
PKA_MontgomeryParam_Set(h,a,b?NULL:(uint8_t*)s->buffers[0]);return 0;
}
case 85:{ PKA_ECCDoubleBaseLadderInTypeDef v=input17(s);PKA_ECCDoubleBaseLadder_Set(h,&v);return 0;}
case 86:{
PKA_ECCDoubleBaseLadderOutTypeDef o={.ptX=(uint8_t*)s->buffers[16],.ptY=(uint8_t*)s->buffers[17]};HAL_PKA_ECCDoubleBaseLadder_GetResult(h,b?NULL:&o);return 0;
}
case 87:{ PKA_ECCProjective2AffineInTypeDef v=input18(s);PKA_ECCProjective2Affine_Set(h,&v);return 0;}
case 88:{
PKA_ECCProjective2AffineOutTypeDef o={.ptX=(uint8_t*)s->buffers[16],.ptY=(uint8_t*)s->buffers[17]};HAL_PKA_ECCProjective2Affine_GetResult(h,b?NULL:&o);return 0;
}
case 89:{ PKA_ECCCompleteAdditionInTypeDef v=input19(s);PKA_ECCCompleteAddition_Set(h,&v);return 0;}
case 90:{
PKA_ECCCompleteAdditionOutTypeDef o={.ptX=(uint8_t*)s->buffers[16],.ptY=(uint8_t*)s->buffers[17],.ptZ=(uint8_t*)s->buffers[18]};HAL_PKA_ECCCompleteAddition_GetResult(h,b?NULL:&o);return 0;
}
case 91:{
PKA_ARI_Set(h,a,(b&1)?NULL:s->buffers[0],(b&2)?NULL:s->buffers[1],(b&4)?NULL:(uint8_t*)s->buffers[2]);return 0;
}
case 92:{
return PKA_WaitOnFlagUntilTimeout(h,a,(FlagStatus)b,s->tick,c);
}
case 93:{
return PKA_Result_GetSize(h,a,b);
}
case 94:CPKA_DefaultMSP(s);return 0;
case 100:__HAL_PKA_RESET_HANDLE_STATE(h);return 0;
case 101:__HAL_PKA_ENABLE(h);return 0;
case 102:__HAL_PKA_DISABLE(h);return 0;
case 103:__HAL_PKA_START(h);return 0;
case 104:__HAL_PKA_ENABLE_IT(h,a);return 0;
case 105:__HAL_PKA_DISABLE_IT(h,a);return 0;
case 106:return __HAL_PKA_GET_IT_SOURCE(h,a);
case 107:return __HAL_PKA_GET_FLAG(h,a);
case 108:__HAL_PKA_CLEAR_FLAG(h,a);return 0;
default:assert(0);return 0;}}
