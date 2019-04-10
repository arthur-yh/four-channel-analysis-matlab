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

