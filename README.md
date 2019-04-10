# four-channel-analysis-matlab
This matlab code analyzes four different channels (1)AWGN (2)Rayleigh (3)Rician (4)Natagami BER under the different SNR by QPSK modulation.
After run this code, dynamic constellation diagram variation under different SNR will show in your screen. Well, I paste some result below.
<div align="center">
<img src="https://github.com/arthur-yh/four-channel-analysis-matlab/blob/master/picture/small.png" height=80% width=80% >
</div>
<div align = "center">Fig1. four channel on small SNR</div>
<div align="center">
<img src="https://github.com/arthur-yh/four-channel-analysis-matlab/blob/master/picture/middle.jpg" height=80% width=80% >
</div>
<div align = "center">Fig2. four channel on middle SNR</div>
<div align="center">
<img src="https://github.com/arthur-yh/four-channel-analysis-matlab/blob/master/picture/large.jpg" height=80% width=80% >
</div>
<div align = "center">Fig3. four channel on large SNR</div>  
  
**Notes that: diagram in top left corner is AWGN channel, top right corner is Natagami channel, left bottom corner is Rician channel, right bottom corner is Rayleigh channel.**  



The result is shown below:
<div align="center">
<img src="https://github.com/arthur-yh/four-channel-analysis-matlab/blob/master/picture/snr.jpg" height=80% width=80% >
</div>
<div align = "center">Fig4. QPSK modulation's BER under different SNR</div>

## Analysis of the results
### Constellation diagram analysis  
As shown in Fig1-3, as the increasing of SNR the points in diagram become more compact and orderly.   
1. For AWGN channel, it only consider one direct channel, so as the SNR increases, the points in the diagram will locate in four points which is (1, i), (1, -i), (-1, i) and (-1, -i). These four points is modulation results of QPSK.  
2. For Rayleigh channel, it contains multi-channels but not the direct channel. So the diagram will be spin for an angle compared to AWGN because of the multipath effect like multi-channel time delay. Also because of no direct channel in the model, so the average signal power will be lower than other channel models, which results that all the points will be center in the origin than others.  
   Notes that: the distance between the point in diagram to the origin points is the power of the signal.
3. For Rician channel, compared to Rayleigh channel, it contains multi-channels and the direct channel. So the spin angle exists and the average signals power is larger than Rayleigh, so it will be away from the origin points. 
4. For Natagami channel, it is the combination of Rayleigh channel and Rician, or to say, it is the updated version of Rician channel, because it contain more channels than Rician. so the results is the diagram become well-proportioned from the origin to the infinty.  
### Fig4 analysis  
***Conclusion***
**1. As the increasing of SNR, the BER of these four channel becomes lower.**  
Analyze: As the increasing of SNR, the noise in those four channel becomes lower, so the BER have better performance.  
**2. If in the same SNR, the BER performance is AWGN > Rician > Natagami > Rayleigh.**  
Analyze: AWGN channel have the best performance because it only have one direct channel，signal will not suffer frequency selective fading (FSF) since no multipath time delay existed. Rayleigh channel have the worst performance because it does not have direct channel, so the signals suffer strong FSF which will bring large fading to signal itself, so the worst performance. Rician channel is better than than Natagami, because Natagami channel have more channel than Rician results in more severe time delay. So the FSF in Natagami is more severe than Rician, so the worse performance than Rician.  
  
  
## Question towards the results and the code (to be updated)  
1. Why the SNR in Fig4 could so low like -25dB and the BER is not too bad?
Answer: This code simulates the Large-scale fading and the Small-scale fading, so the received signal will be extreme low like -160dB than transmitted signals. Well the Large-scale fading code is in the [AWGN-Rayleigh-rician-Natagami--channel_analysis.m](https://github.com/arthur-yh/four-channel-analysis-matlab/blob/master/AWGN-Rayleigh-rician-Natagami--channel_analysis.m) line 135-146. In order to analyze the BER towards the transmitted signals, I provide some power gain in line 193-196 shown below:
`
        yrician = yrician .* 10^(+ydb/10);

        yraylei = yraylei .* 10^(+ydb/10);

        ynakagami = ynakagami .* 10^(+ydb/10);

        yawgn = yawgn .* 10^(+ydb/10); `
