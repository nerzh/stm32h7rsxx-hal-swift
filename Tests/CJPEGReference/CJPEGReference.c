#include "JPEGInternal.h"
CJPEGState *CJPEG_Active;
size_t CJPEG_Size(void) {return sizeof(CJPEGState);}
static uint32_t handleGet(CJPEGState *s,uint32_t i) {switch(i){case 0:return s->h.Conf.ColorSpace;case 1:return s->h.Conf.ChromaSubsampling;case 2:return s->h.Conf.ImageHeight;case 3:return s->h.Conf.ImageWidth;case 4:return s->h.Conf.ImageQuality;case 5:return s->h.JpegInCount;case 6:return s->h.JpegOutCount;case 7:return s->h.InDataLength;case 8:return s->h.OutDataLength;case 9:return s->h.CustomQuanTable;case 10:return s->h.Lock;case 11:return s->h.State;case 12:return s->h.ErrorCode;case 13:return s->h.Context;default:assert(0);return 0;}}
static void handleSet(CJPEGState *s,uint32_t i,uint32_t v) {switch(i){case 0:s->h.Conf.ColorSpace=v;break;case 1:s->h.Conf.ChromaSubsampling=v;break;case 2:s->h.Conf.ImageHeight=v;break;case 3:s->h.Conf.ImageWidth=v;break;case 4:s->h.Conf.ImageQuality=v;break;case 5:s->h.JpegInCount=v;break;case 6:s->h.JpegOutCount=v;break;case 7:s->h.InDataLength=v;break;case 8:s->h.OutDataLength=v;break;case 9:s->h.CustomQuanTable=v;break;case 10:s->h.Lock=v;break;case 11:s->h.State=v;break;case 12:s->h.ErrorCode=v;break;case 13:s->h.Context=v;break;default:assert(0);}}
static uint32_t configGet(CJPEGState *s,uint32_t i) {switch(i){case 0:return s->config.ColorSpace;case 1:return s->config.ChromaSubsampling;case 2:return s->config.ImageHeight;case 3:return s->config.ImageWidth;case 4:return s->config.ImageQuality;default:assert(0);return 0;}}
static void configSet(CJPEGState *s,uint32_t i,uint32_t v) {switch(i){case 0:s->config.ColorSpace=v;break;case 1:s->config.ChromaSubsampling=v;break;case 2:s->config.ImageHeight=v;break;case 3:s->config.ImageWidth=v;break;case 4:s->config.ImageQuality=v;break;default:assert(0);}}
static uint32_t outputGet(CJPEGState *s,uint32_t i) {switch(i){case 0:return s->output.ColorSpace;case 1:return s->output.ChromaSubsampling;case 2:return s->output.ImageHeight;case 3:return s->output.ImageWidth;case 4:return s->output.ImageQuality;default:assert(0);return 0;}}
static void outputSet(CJPEGState *s,uint32_t i,uint32_t v) {switch(i){case 0:s->output.ColorSpace=v;break;case 1:s->output.ChromaSubsampling=v;break;case 2:s->output.ImageHeight=v;break;case 3:s->output.ImageWidth=v;break;case 4:s->output.ImageQuality=v;break;default:assert(0);}}
uint32_t CJPEG_NormalizeAddress(uint32_t address,uint32_t dataBase,uint32_t registerBase) {
 // Zero DMA fields stay zero even when a host pointer's low 32 bits are zero.
 if(address==0)return 0;
 if(address-dataBase<256)return 0x24001000U+(address-dataBase);
 if(address-registerBase<sizeof(JPEG_TypeDef))return 0x52003000U+(address-registerBase);
 return address;
}
static uint32_t normalize(CJPEGState *s,uint32_t address) {
 return CJPEG_NormalizeAddress(address,(uint32_t)(uintptr_t)s->data,(uint32_t)(uintptr_t)&s->regs);
}
uint8_t *CJPEG_Buffer(CJPEGState *s,uint32_t i) {assert(i<256);return s->data+i;}
uint8_t *CJPEG_GetBuffer(CJPEGState *s,uint32_t d) {return d?s->h.pJpegOutBuffPtr:s->h.pJpegInBuffPtr;}
void CJPEG_SetBuffer(CJPEGState *s,uint32_t d,uint8_t *p) {if(d)s->h.pJpegOutBuffPtr=p;else s->h.pJpegInBuffPtr=p;}
const uint8_t *CJPEG_GetQuantization(CJPEGState *s,uint32_t i) {switch(i){case 0:return s->h.QuantTable0;case 1:return s->h.QuantTable1;case 2:return s->h.QuantTable2;case 3:return s->h.QuantTable3;default:assert(0);return NULL;}}
void CJPEG_SetQuantization(CJPEGState *s,uint32_t i,const uint8_t *p) {switch(i){case 0:s->h.QuantTable0=(uint8_t*)p;break;case 1:s->h.QuantTable1=(uint8_t*)p;break;case 2:s->h.QuantTable2=(uint8_t*)p;break;case 3:s->h.QuantTable3=(uint8_t*)p;break;default:assert(0);}}
uint8_t *CJPEG_CustomQuantization(CJPEGState *s,uint32_t i) {assert(i<4);return s->quant[i];}
uint32_t *CJPEG_Configuration(CJPEGState *s) {return &s->h.Conf.ColorSpace;}
static uint32_t quantToken(CJPEGState *s,uint32_t i) {
 const uint8_t *p=CJPEG_GetQuantization(s,i);if(!p)return 0;
 for(uint32_t j=0;j<4;j++)if(p==s->quant[j])return j+3;
 return p[0]==16?1:p[0]==17?2:99;
}
void CJPEG_Reset(CJPEGState *s,uint32_t mode) {
 memset(s,0,sizeof(*s));s->mode=mode;s->h.Instance=&s->regs;s->h.pJpegInBuffPtr=s->data;s->h.pJpegOutBuffPtr=s->data+128;
 s->h.hdmain=&s->dma[0];s->h.hdmaout=&s->dma[1];s->control[0]=s->control[1]=s->control[2]=s->control[3]=1;
 s->config.ImageHeight=8;s->config.ImageWidth=8;s->config.ImageQuality=75;
 for(uint32_t i=0;i<256;i++)s->data[i]=(uint8_t)(i+1);
 for(uint32_t i=0;i<4;i++){for(uint32_t j=0;j<64;j++)s->quant[i][j]=(uint8_t)(1+i+j);CJPEG_SetQuantization(s,i,s->quant[i]);}
 for(uint32_t d=0;d<2;d++){s->dma[d].Parent=&s->h;s->dma[d].State=1;s->dma[d].LinkedListQueue=&s->queue[d];s->queue[d].Head=&s->node[d];}
 for(uint32_t i=1;i<=8;i++)CJPEG_SetCallback(s,i,1);
}
uint32_t CJPEG_Get(CJPEGState *s,uint32_t area,uint32_t i) {
 switch(area){
 case 0:assert(i<512);return ((uint32_t*)&s->regs)[i];case 1:return handleGet(s,i);case 2:return configGet(s,i);case 3:return outputGet(s,i);
 case 4:{uint32_t d=i/16,n=i%16;switch(n){case 0:return s->dma[d].Mode;case 1:return s->dma[d].LinkedListQueue!=NULL;case 2:return s->queue[d].Head!=NULL;
 case 3:return s->node[d].LinkRegisters[2];case 4:return normalize(s,s->node[d].LinkRegisters[3]);case 5:return normalize(s,s->node[d].LinkRegisters[4]);
 case 6:case 7:case 8:return s->mode?CJPEG1_GetDMA(s,d,n-6):CJPEG0_GetDMA(s,d,n-6);
 case 14:return s->dma[d].State;case 15:return s->dma[d].ErrorCode;default:return s->meta[d][n];}}
 case 5:assert(i<16);return s->control[i];case 6:assert(i<256);return s->data[i];
 case 7:{assert(i<256);const uint8_t *p=CJPEG_GetQuantization(s,i/64);return p?p[i%64]:0;}
 case 8:return quantToken(s,i);case 9:{uint8_t *p=CJPEG_GetBuffer(s,i);return p?(uint32_t)(p-s->data)+1:0;}
 case 10:assert(i<12);return s->calls[i];case 11:return i?s->tickCalls:s->tick;case 12:return s->traceCount;case 13:return s->mode;
 case 14:assert(i<256);return s->quant[i/64][i%64];default:assert(0);return 0;
 }
}
void CJPEG_Set(CJPEGState *s,uint32_t area,uint32_t i,uint32_t v) {
 switch(area){
 case 0:assert(i<512);((uint32_t*)&s->regs)[i]=v;break;case 1:handleSet(s,i,v);break;case 2:configSet(s,i,v);break;case 3:outputSet(s,i,v);break;
 case 4:{uint32_t d=i/16,n=i%16;switch(n){case 0:s->dma[d].Mode=v;break;case 1:s->dma[d].LinkedListQueue=v?&s->queue[d]:NULL;break;case 2:s->queue[d].Head=v?&s->node[d]:NULL;break;
 case 3:s->node[d].LinkRegisters[2]=v;break;case 4:s->node[d].LinkRegisters[3]=v;break;case 5:s->node[d].LinkRegisters[4]=v;break;
 case 6:case 7:case 8:if(s->mode)CJPEG1_SetDMA(s,d,n-6,v);else CJPEG0_SetDMA(s,d,n-6,v);break;
 case 14:s->dma[d].State=v;break;case 15:s->dma[d].ErrorCode=v;break;default:s->meta[d][n]=v;break;}break;}
 case 5:assert(i<16);s->control[i]=v;break;case 6:assert(i<256);s->data[i]=(uint8_t)v;break;
 case 8:assert(i<4 && (v==0 || (v>=3 && v<=6)));CJPEG_SetQuantization(s,i,v?s->quant[v-3]:NULL);break;
 case 9:CJPEG_SetBuffer(s,i,v?s->data+v-1:NULL);break;case 10:assert(i<12);s->calls[i]=v;break;
 case 11:if(i)s->tickCalls=v;else s->tick=v;break;case 12:s->traceCount=v;break;
 case 14:assert(i<256);s->quant[i/64][i%64]=(uint8_t)v;break;default:assert(0);
 }
}
static void trace(CJPEGState *s,uint32_t id,uint32_t token,uint32_t a,uint32_t b) {
 assert(s->traceCount<32);uint32_t *out=s->trace[s->traceCount++],n=0;out[n++]=id;out[n++]=token;out[n++]=a;out[n++]=b;
 const uint32_t counts[]={512,14,5,5,32,16,256,256,4,2,12,2};
 for(uint32_t area=0;area<12;area++)for(uint32_t i=0;i<counts[area];i++)out[n++]=CJPEG_Get(s,area,i);
 for(uint32_t i=1;i<=8;i++)out[n++]=CJPEG_GetCallback(s,i);
 assert(n<=1536);while(n<1536)out[n++]=0;
}
void CJPEG_Callback(CJPEGState *s,uint32_t id,uint32_t token,uint32_t a,uint32_t b) {
 trace(s,id,token,a,b);
 if(s->control[6]){s->h.State=6;s->h.ErrorCode=0x8000;s->h.Lock=0;s->regs.CR=0;}
 if(id==7){switch(s->control[7]){
 case 1:s->h.InDataLength=0;s->h.Context|=0x1000;break;
 case 2:s->h.pJpegInBuffPtr=s->data+16;s->h.InDataLength=5;break;
 case 3:s->h.pJpegInBuffPtr=s->data+32;s->h.InDataLength=3;break;
 case 4:s->h.InDataLength=24;s->h.Context|=0x1000;break;
 }}
 if(id==8){switch(s->control[8]){
 case 1:s->h.Context|=0x2000;break;
 case 2:s->h.pJpegOutBuffPtr=s->data+144;s->h.OutDataLength=7;break;
 case 3:s->h.pJpegOutBuffPtr=s->data+160;s->h.OutDataLength=4;break;
 }}
 if(id==6 && s->control[9]){s->h.Conf.ColorSpace=0x30;s->h.Conf.ImageQuality=73;s->h.Context|=0x3000;}
 if(id==4 && s->control[10]){s->h.Context=0xFFFF;s->h.Conf.ImageQuality=99;}
}
uint32_t CJPEG_Tick(CJPEGState *s) {uint32_t result=s->tick;s->tick+=s->control[3];s->tickCalls++;
 if(s->control[4] && s->tickCalls>=s->control[4])s->regs.SR=s->control[5];return result;}
uint32_t CJPEG_Start(CJPEGState *s,uint32_t d,uint32_t linked,uint32_t src,uint32_t dst,uint32_t size) {
 s->calls[d]++;s->calls[6]=normalize(s,src);s->calls[7]=normalize(s,dst);s->calls[8]=size;s->calls[9]=d;s->calls[10]=linked;
 trace(s,20+d,linked,0,0);if(s->meta[d][11]==0)s->dma[d].State=2;return s->meta[d][11];
}
uint32_t CJPEG_Abort(CJPEGState *s,uint32_t d,uint32_t interrupt) {
 s->calls[2+d+2*interrupt]++;trace(s,30+d,interrupt,0,0);uint32_t result=s->meta[d][interrupt?13:12];
 if(result==0)s->dma[d].State=interrupt?4:1;return result;
}
uint32_t CJPEG_Run(CJPEGState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {return s->mode?CJPEG1_Run(s,op,a,b,c):CJPEG0_Run(s,op,a,b,c);}
uint32_t CJPEG_TraceWord(CJPEGState *s,uint32_t e,uint32_t w) {assert(e<32 && w<1536);return s->trace[e][w];}
