#include "USBInternal.h"
CUSB_THREAD_LOCAL CUSBState *CUSB_Active;
size_t CUSB_Size(void){return sizeof(CUSBState);}
uint32_t *CUSB_Registers(CUSBState *s){return s->registers;}
uint32_t *CUSB_Control(CUSBState *s){return s->control;}
uint32_t *CUSB_Trace(CUSBState *s){return s->trace;}
uint8_t *CUSB_Buffer(CUSBState *s){return s->buffer;}
void CUSB_DelayFor(CUSBState *s,uint32_t ms){assert(s->control[1]<256);s->delays[s->control[1]++]=ms;s->control[2]+=ms;if(s->control[3]&&s->control[1]==s->control[3])s->registers[0x14/4]=s->control[4];}
void CUSB_Delay(uint32_t ms){CUSB_DelayFor(CUSB_Active,ms);}
void CUSB_Reset(CUSBState *s,uint32_t hs){memset(s,0,sizeof(*s));s->control[0]=hs;s->configuration.dev_endpoints=8;s->configuration.Host_channels=16;s->endpoint.maxpacket=64;s->channel.max_packet=64;s->endpoint.xfer_buff=s->buffer;s->channel.xfer_buff=s->buffer;}
uint32_t CUSB_GetConfiguration(CUSBState *s,uint32_t i){switch(i){
case 0:return s->configuration.dev_endpoints;
case 1:return s->configuration.Host_channels;
case 2:return s->configuration.dma_enable;
case 3:return s->configuration.speed;
case 4:return s->configuration.ep0_mps;
case 5:return s->configuration.phy_itface;
case 6:return s->configuration.Sof_enable;
case 7:return s->configuration.low_power_enable;
case 8:return s->configuration.lpm_enable;
case 9:return s->configuration.battery_charging_enable;
case 10:return s->configuration.vbus_sensing_enable;
case 11:return s->configuration.use_dedicated_ep1;
case 12:return s->configuration.use_external_vbus;
default:assert(0);return 0;}}
void CUSB_SetConfiguration(CUSBState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->configuration.dev_endpoints=v;return;
case 1:s->configuration.Host_channels=v;return;
case 2:s->configuration.dma_enable=v;return;
case 3:s->configuration.speed=v;return;
case 4:s->configuration.ep0_mps=v;return;
case 5:s->configuration.phy_itface=v;return;
case 6:s->configuration.Sof_enable=v;return;
case 7:s->configuration.low_power_enable=v;return;
case 8:s->configuration.lpm_enable=v;return;
case 9:s->configuration.battery_charging_enable=v;return;
case 10:s->configuration.vbus_sensing_enable=v;return;
case 11:s->configuration.use_dedicated_ep1=v;return;
case 12:s->configuration.use_external_vbus=v;return;
default:assert(0);}}
uint32_t CUSB_GetEndpoint(CUSBState *s,uint32_t i){switch(i){
case 0:return s->endpoint.num;
case 1:return s->endpoint.is_in;
case 2:return s->endpoint.is_stall;
case 3:return s->endpoint.is_iso_incomplete;
case 4:return s->endpoint.type;
case 5:return s->endpoint.data_pid_start;
case 6:return s->endpoint.maxpacket;
case 7:return s->endpoint.xfer_len;
case 8:return s->endpoint.xfer_count;
case 9:return s->endpoint.even_odd_frame;
case 10:return s->endpoint.tx_fifo_num;
case 11:return s->endpoint.dma_addr;
case 12:return s->endpoint.xfer_size;
default:assert(0);return 0;}}
void CUSB_SetEndpoint(CUSBState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->endpoint.num=v;return;
case 1:s->endpoint.is_in=v;return;
case 2:s->endpoint.is_stall=v;return;
case 3:s->endpoint.is_iso_incomplete=v;return;
case 4:s->endpoint.type=v;return;
case 5:s->endpoint.data_pid_start=v;return;
case 6:s->endpoint.maxpacket=v;return;
case 7:s->endpoint.xfer_len=v;return;
case 8:s->endpoint.xfer_count=v;return;
case 9:s->endpoint.even_odd_frame=v;return;
case 10:s->endpoint.tx_fifo_num=v;return;
case 11:s->endpoint.dma_addr=v;return;
case 12:s->endpoint.xfer_size=v;return;
default:assert(0);}}
uint32_t CUSB_GetChannel(CUSBState *s,uint32_t i){switch(i){
case 0:return s->channel.dev_addr;
case 1:return s->channel.ch_num;
case 2:return s->channel.ep_num;
case 3:return s->channel.ep_is_in;
case 4:return s->channel.ch_dir;
case 5:return s->channel.speed;
case 6:return s->channel.do_ping;
case 7:return s->channel.do_ssplit;
case 8:return s->channel.do_csplit;
case 9:return s->channel.ep_ss_schedule;
case 10:return s->channel.iso_splt_xactPos;
case 11:return s->channel.hub_port_nbr;
case 12:return s->channel.hub_addr;
case 13:return s->channel.ep_type;
case 14:return s->channel.max_packet;
case 15:return s->channel.data_pid;
case 16:return s->channel.XferSize;
case 17:return s->channel.xfer_len;
case 18:return s->channel.xfer_count;
case 19:return s->channel.toggle_in;
case 20:return s->channel.toggle_out;
case 21:return s->channel.dma_addr;
case 22:return s->channel.NakCnt;
case 23:return s->channel.ErrCnt;
case 24:return s->channel.NyetErrCnt;
case 25:return s->channel.urb_state;
case 26:return s->channel.state;
default:assert(0);return 0;}}
void CUSB_SetChannel(CUSBState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->channel.dev_addr=v;return;
case 1:s->channel.ch_num=v;return;
case 2:s->channel.ep_num=v;return;
case 3:s->channel.ep_is_in=v;return;
case 4:s->channel.ch_dir=v;return;
case 5:s->channel.speed=v;return;
case 6:s->channel.do_ping=v;return;
case 7:s->channel.do_ssplit=v;return;
case 8:s->channel.do_csplit=v;return;
case 9:s->channel.ep_ss_schedule=v;return;
case 10:s->channel.iso_splt_xactPos=v;return;
case 11:s->channel.hub_port_nbr=v;return;
case 12:s->channel.hub_addr=v;return;
case 13:s->channel.ep_type=v;return;
case 14:s->channel.max_packet=v;return;
case 15:s->channel.data_pid=v;return;
case 16:s->channel.XferSize=v;return;
case 17:s->channel.xfer_len=v;return;
case 18:s->channel.xfer_count=v;return;
case 19:s->channel.toggle_in=v;return;
case 20:s->channel.toggle_out=v;return;
case 21:s->channel.dma_addr=v;return;
case 22:s->channel.NakCnt=v;return;
case 23:s->channel.ErrCnt=v;return;
case 24:s->channel.NyetErrCnt=v;return;
case 25:s->channel.urb_state=v;return;
case 26:s->channel.state=v;return;
default:assert(0);}}
uint8_t *CUSB_GetEndpointBuffer(CUSBState *s){return s->endpoint.xfer_buff;}
void CUSB_SetEndpointBuffer(CUSBState *s,uint8_t *p){s->endpoint.xfer_buff=p;}
uint8_t *CUSB_GetChannelBuffer(CUSBState *s){return s->channel.xfer_buff;}
void CUSB_SetChannelBuffer(CUSBState *s,uint8_t *p){s->channel.xfer_buff=p;}
uint32_t CUSB_Constant(uint32_t i){switch(i){
case 0:return CLEAR_INTERRUPT_MASK;
case 1:return DCFG_FRAME_INTERVAL_80;
case 2:return DCFG_FRAME_INTERVAL_85;
case 3:return DCFG_FRAME_INTERVAL_90;
case 4:return DCFG_FRAME_INTERVAL_95;
case 5:return DSTS_ENUMSPD_FS_PHY_30MHZ_OR_60MHZ;
case 6:return DSTS_ENUMSPD_FS_PHY_48MHZ;
case 7:return DSTS_ENUMSPD_HS_PHY_30MHZ_OR_60MHZ;
case 8:return EP_ADDR_MSK;
case 9:return EP_MPS_16;
case 10:return EP_MPS_32;
case 11:return EP_MPS_64;
case 12:return EP_MPS_8;
case 13:return EP_SPEED_FULL;
case 14:return EP_SPEED_HIGH;
case 15:return EP_SPEED_LOW;
case 16:return EP_TYPE_BULK;
case 17:return EP_TYPE_CTRL;
case 18:return EP_TYPE_INTR;
case 19:return EP_TYPE_ISOC;
case 20:return EP_TYPE_MSK;
case 21:return GRXSTS_PKTSTS_CH_HALTED;
case 22:return GRXSTS_PKTSTS_DATA_TOGGLE_ERR;
case 23:return GRXSTS_PKTSTS_IN;
case 24:return GRXSTS_PKTSTS_IN_XFER_COMP;
case 25:return HAL_HCD_CHANNEL_NAK_COUNT;
case 26:return HAL_HCD_CONNECT_CB_ID;
case 27:return HAL_HCD_DISCONNECT_CB_ID;
case 28:return HAL_HCD_ERROR_INVALID_CALLBACK;
case 29:return HAL_HCD_MSPDEINIT_CB_ID;
case 30:return HAL_HCD_MSPINIT_CB_ID;
case 31:return HAL_HCD_PORT_DISABLED_CB_ID;
case 32:return HAL_HCD_PORT_ENABLED_CB_ID;
case 33:return HAL_HCD_SOF_CB_ID;
case 34:return HAL_HCD_STATE_BUSY;
case 35:return HAL_HCD_STATE_ERROR;
case 36:return HAL_HCD_STATE_READY;
case 37:return HAL_HCD_STATE_RESET;
case 38:return HAL_HCD_STATE_TIMEOUT;
case 39:return HAL_PCD_CONNECT_CB_ID;
case 40:return HAL_PCD_DISCONNECT_CB_ID;
case 41:return HAL_PCD_ERROR_INVALID_CALLBACK;
case 42:return HAL_PCD_MSPDEINIT_CB_ID;
case 43:return HAL_PCD_MSPINIT_CB_ID;
case 44:return HAL_PCD_RESET_CB_ID;
case 45:return HAL_PCD_RESUME_CB_ID;
case 46:return HAL_PCD_SETUPSTAGE_CB_ID;
case 47:return HAL_PCD_SOF_CB_ID;
case 48:return HAL_PCD_STATE_BUSY;
case 49:return HAL_PCD_STATE_ERROR;
case 50:return HAL_PCD_STATE_READY;
case 51:return HAL_PCD_STATE_RESET;
case 52:return HAL_PCD_STATE_TIMEOUT;
case 53:return HAL_PCD_SUSPEND_CB_ID;
case 54:return HAL_USB_CURRENT_MODE_MAX_DELAY_MS;
case 55:return HAL_USB_TIMEOUT;
case 56:return HCCHAR_BULK;
case 57:return HCCHAR_CTRL;
case 58:return HCCHAR_INTR;
case 59:return HCCHAR_ISOC;
case 60:return HCD_DEVICE_SPEED_FULL;
case 61:return HCD_DEVICE_SPEED_HIGH;
case 62:return HCD_DEVICE_SPEED_LOW;
case 63:return HCD_PHY_EMBEDDED;
case 64:return HCD_PHY_ULPI;
case 65:return HCD_SPEED_FULL;
case 66:return HCD_SPEED_HIGH;
case 67:return HCD_SPEED_LOW;
case 68:return HCFG_30_60_MHZ;
case 69:return HCFG_48_MHZ;
case 70:return HCFG_6_MHZ;
case 71:return HCSPLT_BEGIN;
case 72:return HCSPLT_END;
case 73:return HCSPLT_FULL;
case 74:return HCSPLT_MIDDLE;
case 75:return HC_ACK;
case 76:return HC_BBLERR;
case 77:return HC_DATATGLERR;
case 78:return HC_HALTED;
case 79:return HC_IDLE;
case 80:return HC_MAX_PKT_CNT;
case 81:return HC_NAK;
case 82:return HC_NYET;
case 83:return HC_PID_DATA0;
case 84:return HC_PID_DATA1;
case 85:return HC_PID_DATA2;
case 86:return HC_PID_SETUP;
case 87:return HC_STALL;
case 88:return HC_XACTERR;
case 89:return HC_XFRC;
case 90:return HFIR_48_MHZ;
case 91:return HFIR_60_MHZ;
case 92:return HFIR_6_MHZ;
case 93:return HPRT0_PRTSPD_FULL_SPEED;
case 94:return HPRT0_PRTSPD_HIGH_SPEED;
case 95:return HPRT0_PRTSPD_LOW_SPEED;
case 96:return ISO_SPLT_MPS;
case 97:return LPM_L0;
case 98:return LPM_L1;
case 99:return LPM_L2;
case 100:return LPM_L3;
case 101:return PCD_BCD_CHARGING_DOWNSTREAM_PORT;
case 102:return PCD_BCD_CONTACT_DETECTION;
case 103:return PCD_BCD_DEDICATED_CHARGING_PORT;
case 104:return PCD_BCD_DISCOVERY_COMPLETED;
case 105:return PCD_BCD_ERROR;
case 106:return PCD_BCD_STD_DOWNSTREAM_PORT;
case 107:return PCD_LPM_L0_ACTIVE;
case 108:return PCD_LPM_L1_ACTIVE;
case 109:return PCD_PHY_EMBEDDED;
case 110:return PCD_PHY_ULPI;
case 111:return PCD_PHY_UTMI;
case 112:return PCD_SPEED_FULL;
case 113:return PCD_SPEED_HIGH;
case 114:return PCD_SPEED_HIGH_IN_FULL;
case 115:return STS_DATA_UPDT;
case 116:return STS_GOUT_NAK;
case 117:return STS_SETUP_COMP;
case 118:return STS_SETUP_UPDT;
case 119:return STS_XFER_COMP;
case 120:return TEST_FORCE_EN;
case 121:return TEST_J;
case 122:return TEST_K;
case 123:return TEST_PACKET;
case 124:return TEST_SE0_NAK;
case 125:return URB_DONE;
case 126:return URB_ERROR;
case 127:return URB_IDLE;
case 128:return URB_NAK_WAIT;
case 129:return URB_NOTREADY;
case 130:return URB_NYET;
case 131:return URB_STALL;
case 132:return USBD_DEFAULT_TRDT_VALUE;
case 133:return USBD_FS_SPEED;
case 134:return USBD_FS_TRDT_VALUE;
case 135:return USBD_HSINFS_SPEED;
case 136:return USBD_HS_SPEED;
case 137:return USBD_HS_TRDT_VALUE;
case 138:return USBH_FSLS_SPEED;
case 139:return USBH_HS_SPEED;
case 140:return USB_DEVICE_MODE;
case 141:return USB_DRD_MODE;
case 142:return USB_HOST_MODE;
case 143:return USB_OTG_CORE_ID_300A;
case 144:return USB_OTG_CORE_ID_310A;
case 145:return USB_OTG_DOEPINT_NAK;
case 146:return USB_OTG_DOEPINT_OTEPSPR;
case 147:return USB_OTG_DOEPINT_STPKTRX;
case 148:return USB_OTG_DOEPMSK_NAKM;
case 149:return USB_OTG_DOEPMSK_NYETM;
case 150:return USB_OTG_DOEPMSK_OTEPSPRM;
case 151:return USB_OTG_EMBEDDED_PHY;
case 152:return USB_OTG_FS_MAX_PACKET_SIZE;
case 153:return USB_OTG_GAHBCFG_HBSTLEN_INCR;
case 154:return USB_OTG_GAHBCFG_HBSTLEN_INCR16;
case 155:return USB_OTG_GAHBCFG_HBSTLEN_INCR4;
case 156:return USB_OTG_GAHBCFG_HBSTLEN_INCR8;
case 157:return USB_OTG_GAHBCFG_HBSTLEN_SINGLE;
case 158:return USB_OTG_HS_EMBEDDED_PHY;
case 159:return USB_OTG_HS_MAX_PACKET_SIZE;
case 160:return USB_OTG_MAX_EP0_SIZE;
case 161:return USB_OTG_MODE_DEVICE;
case 162:return USB_OTG_MODE_DRD;
case 163:return USB_OTG_MODE_HOST;
case 164:return USB_OTG_SPEED_FULL;
case 165:return USB_OTG_SPEED_HIGH;
case 166:return USB_OTG_SPEED_HIGH_IN_FULL;
default:assert(0);return 0;}}

static uint32_t normalizeAddress(CUSBState *s,uint32_t v){uint32_t base=(uint32_t)(uintptr_t)s->buffer;return (uint32_t)(v-base)<sizeof(s->buffer)?(0xABC00000U+(v-base)):v;}
uint32_t CUSB_Compare(CUSBState *a,CUSBState *b){
 for(uint32_t i=0;i<0x4400;i++){
 uint32_t av=a->registers[i],bv=b->registers[i],off=i*4;
 if((off>=0x500&&off<0x700&&(off&31)==20)||(off>=0x900&&off<0xD00&&(off&31)==20)){av=normalizeAddress(a,av);bv=normalizeAddress(b,bv);}
 if(av!=bv)return 0x100000U+off;
 }
 for(uint32_t i=0;i<13;i++)if(CUSB_GetConfiguration(a,i)!=CUSB_GetConfiguration(b,i))return 0x200000+i;
 for(uint32_t i=0;i<13;i++)if(CUSB_GetEndpoint(a,i)!=CUSB_GetEndpoint(b,i))return 0x300000+i;
 for(uint32_t i=0;i<27;i++)if(CUSB_GetChannel(a,i)!=CUSB_GetChannel(b,i))return 0x400000+i;
 for(uint32_t i=0;i<sizeof(a->buffer);i++)if(a->buffer[i]!=b->buffer[i])return 0x500000U+i;
 for(uint32_t i=0;i<64;i++)if(a->control[i]!=b->control[i])return 0x600000U+i;
 for(uint32_t i=0;i<256;i++)if(a->trace[i]!=b->trace[i])return 0x700000U+i;
 for(uint32_t i=0;i<256;i++)if(a->delays[i]!=b->delays[i])return 0x710000U+i;
 return 0;
}
