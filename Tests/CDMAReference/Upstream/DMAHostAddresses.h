/* Host-only pointer constants preserve the exact CMSIS IS_* predicates. */
extern _Thread_local CDMAState *CDMA_Current;
DMA_TypeDef *CDMA_ControllerFor(const DMA_Channel_TypeDef *channel);
uint32_t CDMA_ChannelFor(const DMA_Channel_TypeDef *channel);
#undef GPDMA1
#define GPDMA1 (&CDMA_Current->controllers[0])
#undef GPDMA1_Channel0
#define GPDMA1_Channel0 (&CDMA_Current->channels[0][0])
#undef GPDMA1_Channel1
#define GPDMA1_Channel1 (&CDMA_Current->channels[0][1])
#undef GPDMA1_Channel2
#define GPDMA1_Channel2 (&CDMA_Current->channels[0][2])
#undef GPDMA1_Channel3
#define GPDMA1_Channel3 (&CDMA_Current->channels[0][3])
#undef GPDMA1_Channel4
#define GPDMA1_Channel4 (&CDMA_Current->channels[0][4])
#undef GPDMA1_Channel5
#define GPDMA1_Channel5 (&CDMA_Current->channels[0][5])
#undef GPDMA1_Channel6
#define GPDMA1_Channel6 (&CDMA_Current->channels[0][6])
#undef GPDMA1_Channel7
#define GPDMA1_Channel7 (&CDMA_Current->channels[0][7])
#undef GPDMA1_Channel8
#define GPDMA1_Channel8 (&CDMA_Current->channels[0][8])
#undef GPDMA1_Channel9
#define GPDMA1_Channel9 (&CDMA_Current->channels[0][9])
#undef GPDMA1_Channel10
#define GPDMA1_Channel10 (&CDMA_Current->channels[0][10])
#undef GPDMA1_Channel11
#define GPDMA1_Channel11 (&CDMA_Current->channels[0][11])
#undef GPDMA1_Channel12
#define GPDMA1_Channel12 (&CDMA_Current->channels[0][12])
#undef GPDMA1_Channel13
#define GPDMA1_Channel13 (&CDMA_Current->channels[0][13])
#undef GPDMA1_Channel14
#define GPDMA1_Channel14 (&CDMA_Current->channels[0][14])
#undef GPDMA1_Channel15
#define GPDMA1_Channel15 (&CDMA_Current->channels[0][15])
#undef HPDMA1
#define HPDMA1 (&CDMA_Current->controllers[1])
#undef HPDMA1_Channel0
#define HPDMA1_Channel0 (&CDMA_Current->channels[1][0])
#undef HPDMA1_Channel1
#define HPDMA1_Channel1 (&CDMA_Current->channels[1][1])
#undef HPDMA1_Channel2
#define HPDMA1_Channel2 (&CDMA_Current->channels[1][2])
#undef HPDMA1_Channel3
#define HPDMA1_Channel3 (&CDMA_Current->channels[1][3])
#undef HPDMA1_Channel4
#define HPDMA1_Channel4 (&CDMA_Current->channels[1][4])
#undef HPDMA1_Channel5
#define HPDMA1_Channel5 (&CDMA_Current->channels[1][5])
#undef HPDMA1_Channel6
#define HPDMA1_Channel6 (&CDMA_Current->channels[1][6])
#undef HPDMA1_Channel7
#define HPDMA1_Channel7 (&CDMA_Current->channels[1][7])
#undef HPDMA1_Channel8
#define HPDMA1_Channel8 (&CDMA_Current->channels[1][8])
#undef HPDMA1_Channel9
#define HPDMA1_Channel9 (&CDMA_Current->channels[1][9])
#undef HPDMA1_Channel10
#define HPDMA1_Channel10 (&CDMA_Current->channels[1][10])
#undef HPDMA1_Channel11
#define HPDMA1_Channel11 (&CDMA_Current->channels[1][11])
#undef HPDMA1_Channel12
#define HPDMA1_Channel12 (&CDMA_Current->channels[1][12])
#undef HPDMA1_Channel13
#define HPDMA1_Channel13 (&CDMA_Current->channels[1][13])
#undef HPDMA1_Channel14
#define HPDMA1_Channel14 (&CDMA_Current->channels[1][14])
#undef HPDMA1_Channel15
#define HPDMA1_Channel15 (&CDMA_Current->channels[1][15])
