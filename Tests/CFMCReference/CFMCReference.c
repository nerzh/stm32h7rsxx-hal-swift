#include "FMCInternal.h"
#if defined(__arm__) || defined(__thumb__)
#define CFMC_THREAD_LOCAL
#else
#define CFMC_THREAD_LOCAL _Thread_local
#endif
static CFMC_THREAD_LOCAL CFMCState *active;
size_t CFMC_Size(void) { return sizeof(CFMCState); }
void CFMC_Activate(CFMCState *s){active=s;}
FMC_Bank1_TypeDef *CFMC_Bank1(void){return (void *)active->registers;}
FMC_Bank1E_TypeDef *CFMC_Bank1E(void){return (void *)((uint8_t *)active->registers+0x104);}
FMC_Bank3_TypeDef *CFMC_Bank3(void){return (void *)((uint8_t *)active->registers+0x80);}
FMC_Bank5_6_TypeDef *CFMC_Bank56(void){return (void *)((uint8_t *)active->registers+0x140);}
uint32_t CFMC_TickFor(CFMCState *s){
uint32_t result=s->control[0];s->control[0]+=s->control[1];s->control[2]++;
if(s->control[3] && s->control[2]==s->control[3])s->registers[0x84/4]=s->control[4];
return result;
}
uint32_t CFMC_Tick(void){return CFMC_TickFor(active);}
uint32_t CFMC_Read(CFMCState *s,uint32_t offset){assert(offset<352 && !(offset&3));return s->registers[offset/4];}
void CFMC_Write(CFMCState *s,uint32_t offset,uint32_t value){assert(offset<352 && !(offset&3));s->registers[offset/4]=value;}
uint32_t *CFMC_Output(CFMCState *s){return &s->output;}
void CFMC_Reset(CFMCState *s){memset(s,0,sizeof(*s));s->control[1]=1;s->output=0xC001C0DE;CFMC_Activate(s);}
uint32_t CFMC_Get(CFMCState *s,uint32_t group,uint32_t index){switch(group){
case 0:assert(index<88);return ((uint32_t *)&s->registers)[index];
case 1:assert(index<15);return ((uint32_t *)&s->norsram)[index];
case 2:assert(index<7);return ((uint32_t *)&s->norsramTiming)[index];
case 3:assert(index<7);return ((uint32_t *)&s->nand)[index];
case 4:assert(index<4);return ((uint32_t *)&s->nandTiming)[index];
case 5:assert(index<10);return ((uint32_t *)&s->sdram)[index];
case 6:assert(index<7);return ((uint32_t *)&s->sdramTiming)[index];
case 7:assert(index<4);return ((uint32_t *)&s->command)[index];
case 8:assert(index<16);return ((uint32_t *)&s->control)[index];
case 9:assert(index<1);return ((uint32_t *)&s->output)[index];
}assert(0);return 0;}
void CFMC_Set(CFMCState *s,uint32_t group,uint32_t index,uint32_t value){switch(group){
case 0:assert(index<88);((uint32_t *)&s->registers)[index]=value;return;
case 1:assert(index<15);((uint32_t *)&s->norsram)[index]=value;return;
case 2:assert(index<7);((uint32_t *)&s->norsramTiming)[index]=value;return;
case 3:assert(index<7);((uint32_t *)&s->nand)[index]=value;return;
case 4:assert(index<4);((uint32_t *)&s->nandTiming)[index]=value;return;
case 5:assert(index<10);((uint32_t *)&s->sdram)[index]=value;return;
case 6:assert(index<7);((uint32_t *)&s->sdramTiming)[index]=value;return;
case 7:assert(index<4);((uint32_t *)&s->command)[index]=value;return;
case 8:assert(index<16);((uint32_t *)&s->control)[index]=value;return;
case 9:assert(index<1);((uint32_t *)&s->output)[index]=value;return;
}assert(0);}
uint32_t CFMC_Run(CFMCState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CFMC_Activate(s);switch(op){
case 0:return FMC_NORSRAM_Init(FMC_Bank1_R,s->control[9]?NULL:&s->norsram);
case 1:return FMC_NORSRAM_DeInit(FMC_Bank1_R,FMC_Bank1E_R,a);
case 2:return FMC_NORSRAM_Timing_Init(FMC_Bank1_R,s->control[9]?NULL:&s->norsramTiming,a);
case 3:return FMC_NORSRAM_Extended_Timing_Init(FMC_Bank1E_R,s->control[9]?NULL:&s->norsramTiming,a,b);
case 4:return FMC_NORSRAM_WriteOperation_Enable(FMC_Bank1_R,a);
case 5:return FMC_NORSRAM_WriteOperation_Disable(FMC_Bank1_R,a);
case 6:return FMC_NAND_Init(FMC_Bank3_R,s->control[9]?NULL:&s->nand);
case 7:return FMC_NAND_CommonSpace_Timing_Init(FMC_Bank3_R,s->control[9]?NULL:&s->nandTiming,a);
case 8:return FMC_NAND_AttributeSpace_Timing_Init(FMC_Bank3_R,s->control[9]?NULL:&s->nandTiming,a);
case 9:return FMC_NAND_DeInit(FMC_Bank3_R,a);
case 10:return FMC_NAND_ECC_Enable(FMC_Bank3_R,a);
case 11:return FMC_NAND_ECC_Disable(FMC_Bank3_R,a);
case 12:return FMC_NAND_GetECC(FMC_Bank3_R,&s->output,a,b);
case 13:return FMC_SDRAM_Init(FMC_Bank5_6_R,s->control[9]?NULL:&s->sdram);
case 14:return FMC_SDRAM_Timing_Init(FMC_Bank5_6_R,s->control[9]?NULL:&s->sdramTiming,a);
case 15:return FMC_SDRAM_DeInit(FMC_Bank5_6_R,a);
case 16:return FMC_SDRAM_WriteProtection_Enable(FMC_Bank5_6_R,a);
case 17:return FMC_SDRAM_WriteProtection_Disable(FMC_Bank5_6_R,a);
case 18:return FMC_SDRAM_SendCommand(FMC_Bank5_6_R,s->control[9]?NULL:&s->command,a);
case 19:return FMC_SDRAM_ProgramRefreshRate(FMC_Bank5_6_R,a);
case 20:return FMC_SDRAM_SetAutoRefreshNumber(FMC_Bank5_6_R,a);
case 21:return FMC_SDRAM_GetModeStatus(FMC_Bank5_6_R,a);
case 22:__FMC_ENABLE();return 0;
case 23:__FMC_DISABLE();return 0;
case 24:__FMC_NORSRAM_ENABLE(FMC_Bank1_R,a);return 0;
case 25:__FMC_NORSRAM_DISABLE(FMC_Bank1_R,a);return 0;
case 26:__FMC_NAND_ENABLE(FMC_Bank3_R);return 0;
case 27:__FMC_NAND_DISABLE(FMC_Bank3_R,0);return 0;
case 28:__FMC_NAND_ENABLE_IT(FMC_Bank3_R,a);return 0;
case 29:__FMC_NAND_DISABLE_IT(FMC_Bank3_R,a);return 0;
case 30:return __FMC_NAND_GET_FLAG(FMC_Bank3_R,0,a);
case 31:__FMC_NAND_CLEAR_FLAG(FMC_Bank3_R,a);return 0;
case 32:__FMC_SDRAM_ENABLE_IT(FMC_Bank5_6_R,a);return 0;
case 33:__FMC_SDRAM_DISABLE_IT(FMC_Bank5_6_R,a);return 0;
case 34:return __FMC_SDRAM_GET_FLAG(FMC_Bank5_6_R,a);
case 35:__FMC_SDRAM_CLEAR_FLAG(FMC_Bank5_6_R,a);return 0;

}assert(0);return 0;}
uint32_t CFMC_Compare(CFMCState *a,CFMCState *b){const uint32_t counts[]={88,15,7,7,4,10,7,4,16,1};for(uint32_t g=0;g<10;g++)for(uint32_t i=0;i<counts[g];i++)if(CFMC_Get(a,g,i)!=CFMC_Get(b,g,i))return ((g+1)<<16)|i;return 0;}
uint32_t CFMC_Constant(uint32_t index){switch(index){case 0:return FMC_ACCESS_MODE_A;case 1:return FMC_ACCESS_MODE_B;case 2:return FMC_ACCESS_MODE_C;case 3:return FMC_ACCESS_MODE_D;case 4:return FMC_ASYNCHRONOUS_WAIT_DISABLE;case 5:return FMC_ASYNCHRONOUS_WAIT_ENABLE;case 6:return FMC_BURST_ACCESS_MODE_DISABLE;case 7:return FMC_BURST_ACCESS_MODE_ENABLE;case 8:return FMC_CONTINUOUS_CLOCK_SYNC_ASYNC;case 9:return FMC_CONTINUOUS_CLOCK_SYNC_ONLY;case 10:return FMC_DATA_ADDRESS_MUX_DISABLE;case 11:return FMC_DATA_ADDRESS_MUX_ENABLE;case 12:return FMC_EXTENDED_MODE_DISABLE;case 13:return FMC_EXTENDED_MODE_ENABLE;case 14:return FMC_FLAG_FALLING_EDGE;case 15:return FMC_FLAG_FEMPT;case 16:return FMC_FLAG_LEVEL;case 17:return FMC_FLAG_RISING_EDGE;case 18:return FMC_IT_FALLING_EDGE;case 19:return FMC_IT_LEVEL;case 20:return FMC_IT_REFRESH_ERROR;case 21:return FMC_IT_RISING_EDGE;case 22:return FMC_MEMORY_TYPE_NOR;case 23:return FMC_MEMORY_TYPE_PSRAM;case 24:return FMC_MEMORY_TYPE_SRAM;case 25:return FMC_NAND_BANK3;case 26:return FMC_NAND_ECC_DISABLE;case 27:return FMC_NAND_ECC_ENABLE;case 28:return FMC_NAND_ECC_PAGE_SIZE_1024BYTE;case 29:return FMC_NAND_ECC_PAGE_SIZE_2048BYTE;case 30:return FMC_NAND_ECC_PAGE_SIZE_256BYTE;case 31:return FMC_NAND_ECC_PAGE_SIZE_4096BYTE;case 32:return FMC_NAND_ECC_PAGE_SIZE_512BYTE;case 33:return FMC_NAND_ECC_PAGE_SIZE_8192BYTE;case 34:return FMC_NAND_MEM_BUS_WIDTH_16;case 35:return FMC_NAND_MEM_BUS_WIDTH_8;case 36:return FMC_NAND_WAIT_FEATURE_DISABLE;case 37:return FMC_NAND_WAIT_FEATURE_ENABLE;case 38:return FMC_NORSRAM_BANK1;case 39:return FMC_NORSRAM_BANK2;case 40:return FMC_NORSRAM_BANK3;case 41:return FMC_NORSRAM_BANK4;case 42:return FMC_NORSRAM_FLASH_ACCESS_DISABLE;case 43:return FMC_NORSRAM_FLASH_ACCESS_ENABLE;case 44:return FMC_NORSRAM_MEM_BUS_WIDTH_16;case 45:return FMC_NORSRAM_MEM_BUS_WIDTH_32;case 46:return FMC_NORSRAM_MEM_BUS_WIDTH_8;case 47:return FMC_PAGE_SIZE_1024;case 48:return FMC_PAGE_SIZE_128;case 49:return FMC_PAGE_SIZE_256;case 50:return FMC_PAGE_SIZE_512;case 51:return FMC_PAGE_SIZE_NONE;case 52:return FMC_PCR_MEMORY_TYPE_NAND;case 53:return FMC_SDRAM_BANK1;case 54:return FMC_SDRAM_BANK2;case 55:return FMC_SDRAM_CAS_LATENCY_1;case 56:return FMC_SDRAM_CAS_LATENCY_2;case 57:return FMC_SDRAM_CAS_LATENCY_3;case 58:return FMC_SDRAM_CLOCK_DISABLE;case 59:return FMC_SDRAM_CLOCK_PERIOD_2;case 60:return FMC_SDRAM_CLOCK_PERIOD_3;case 61:return FMC_SDRAM_CMD_AUTOREFRESH_MODE;case 62:return FMC_SDRAM_CMD_CLK_ENABLE;case 63:return FMC_SDRAM_CMD_LOAD_MODE;case 64:return FMC_SDRAM_CMD_NORMAL_MODE;case 65:return FMC_SDRAM_CMD_PALL;case 66:return FMC_SDRAM_CMD_POWERDOWN_MODE;case 67:return FMC_SDRAM_CMD_SELFREFRESH_MODE;case 68:return FMC_SDRAM_CMD_TARGET_BANK1;case 69:return FMC_SDRAM_CMD_TARGET_BANK1_2;case 70:return FMC_SDRAM_CMD_TARGET_BANK2;case 71:return FMC_SDRAM_COLUMN_BITS_NUM_10;case 72:return FMC_SDRAM_COLUMN_BITS_NUM_11;case 73:return FMC_SDRAM_COLUMN_BITS_NUM_8;case 74:return FMC_SDRAM_COLUMN_BITS_NUM_9;case 75:return FMC_SDRAM_FLAG_REFRESH_ERROR;case 76:return FMC_SDRAM_FLAG_REFRESH_IT;case 77:return FMC_SDRAM_INTERN_BANKS_NUM_2;case 78:return FMC_SDRAM_INTERN_BANKS_NUM_4;case 79:return FMC_SDRAM_MEM_BUS_WIDTH_16;case 80:return FMC_SDRAM_MEM_BUS_WIDTH_32;case 81:return FMC_SDRAM_MEM_BUS_WIDTH_8;case 82:return FMC_SDRAM_NORMAL_MODE;case 83:return FMC_SDRAM_POWER_DOWN_MODE;case 84:return FMC_SDRAM_RBURST_DISABLE;case 85:return FMC_SDRAM_RBURST_ENABLE;case 86:return FMC_SDRAM_ROW_BITS_NUM_11;case 87:return FMC_SDRAM_ROW_BITS_NUM_12;case 88:return FMC_SDRAM_ROW_BITS_NUM_13;case 89:return FMC_SDRAM_RPIPE_DELAY_0;case 90:return FMC_SDRAM_RPIPE_DELAY_1;case 91:return FMC_SDRAM_RPIPE_DELAY_2;case 92:return FMC_SDRAM_SELF_REFRESH_MODE;case 93:return FMC_SDRAM_WRITE_PROTECTION_DISABLE;case 94:return FMC_SDRAM_WRITE_PROTECTION_ENABLE;case 95:return FMC_WAIT_SIGNAL_DISABLE;case 96:return FMC_WAIT_SIGNAL_ENABLE;case 97:return FMC_WAIT_SIGNAL_POLARITY_HIGH;case 98:return FMC_WAIT_SIGNAL_POLARITY_LOW;case 99:return FMC_WAIT_TIMING_BEFORE_WS;case 100:return FMC_WAIT_TIMING_DURING_WS;case 101:return FMC_WRITE_BURST_DISABLE;case 102:return FMC_WRITE_BURST_ENABLE;case 103:return FMC_WRITE_FIFO_DISABLE;case 104:return FMC_WRITE_FIFO_ENABLE;case 105:return FMC_WRITE_OPERATION_DISABLE;case 106:return FMC_WRITE_OPERATION_ENABLE;}assert(0);return 0;}
