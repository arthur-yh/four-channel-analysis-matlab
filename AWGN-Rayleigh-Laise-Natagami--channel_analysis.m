%%
% copyright   yh 
% wechat: yhll0014
% If you have any question, you could contact me by wechat.

% 现代通信技术project1仿真    2018年10月30号
% 这个程序仿真了QPSK在大尺度和小尺度衰落情况下的不同SNR下的BER
% 程序运行matlab版本：R2014b 运行前请检查安装目录下toolbox是否存在comm通信工具箱

%%
%--------------------------系统初始化参数设置
% clc;
clear all;
snr = -25:2:15;     %信噪比
KFactor = 3; % Rician K-factor
Ts=1e-4;   % sampling time in second
Fd=100; % doppler frequency in Hz
Tau=[0 1.5e-4 2.5e-4]; % delay for the three paths
PdB=[-3, -9, -10]; % power in each of the three paths
chan = ricianchan(Ts, Fd, KFactor, Tau, PdB); %瑞利信道参数
chanraylei = rayleighchan(Ts, Fd, Tau, PdB);
chan.ResetBeforeFiltering = 0;
%-----------------------------------
its = 1;          %蒙特卡洛试验次数
ser1=[];ser2=[];ser3=[];ser4=[];
errors1=zeros(length(snr),1);
errors2=zeros(length(snr),1);
errors3=zeros(length(snr),1);
errors4=zeros(length(snr),1);
Z_in_constell=[];Z_in_constell1=[];Z_in_constell2=[];Z_in_constell3=[];
Z_qd_constell=[];Z_qd_constell1=[];Z_qd_constell2=[];Z_qd_constell3=[];

%星座图初始化
hScope1 = comm.ConstellationDiagram('ReferenceConstellation', [1+1i  -1+1i  -1-1i 1-1i],...
    'XLimits', [-2 2], 'YLimits', [-2 2],...
    'Position', figposition([1.5 72 17 20]), ...
    'Name','发送信号星座图',...
    'ShowTrajectory','true',...
    'ColorFading','true');%'SamplesPerSymbol',length(yrician),... 'SymbolsToDisplaySource','Property',...
hScope2 = comm.ConstellationDiagram('ReferenceConstellation', [1+1i  -1+1i  -1-1i 1-1i],...%[0.5+0.5i  -0.5+0.5i  -0.5-0.5i 0.5-0.5i],...
    'XLimits', [-1.5 1.5], 'YLimits', [-1.5 1.5],...
    'Position', figposition([1.5 50 17 20]), ...
    'Name','高斯信道',...
    'ShowTrajectory',false,...
    'ColorFading',false);%'SamplesPerSymbol',length(yrician),... 'SymbolsToDisplaySource','Property',...
hScope3 = comm.ConstellationDiagram('ReferenceConstellation', [1+1i  -1+1i  -1-1i 1-1i],...%[0.5+0.5i  -0.5+0.5i  -0.5-0.5i 0.5-0.5i],...
    'XLimits', [-1.5 1.5], 'YLimits', [-1.5 1.5],...
    'Position', figposition([1.5 28 17 20]), ...
    'Name','莱斯信道',...
    'ShowTrajectory',false,...
    'ColorFading',false);
hScope4 = comm.ConstellationDiagram('ReferenceConstellation', [1+1i  -1+1i  -1-1i 1-1i],...%[0.5+0.5i  -0.5+0.5i  -0.5-0.5i 0.5-0.5i],...
    'XLimits', [-1.5 1.5], 'YLimits', [-1.5 1.5],...
    'Position', figposition([1.5 6 17 20]), ...
    'Name','瑞利信道',...
    'ShowTrajectory',false,...
    'ColorFading',false);
hScope5 = comm.ConstellationDiagram('ReferenceConstellation', [1+1i  -1+1i  -1-1i 1-1i],...%[0.5+0.5i  -0.5+0.5i  -0.5-0.5i 0.5-0.5i],...
    'XLimits', [-1.5 1.5], 'YLimits', [-1.5 1.5],...
    'Position', figposition([19 72 17 20]), ...
    'Name','nakagami-m信道',...
    'ShowTrajectory',false,...
    'ColorFading',false);

for si=1:length(snr)
    for j=1:its
%         data=[0  1 0 1 1 1 0 0 1 1]; % information

        Number_of_bit=750;
        data=randi([0 1],Number_of_bit,1);

        figure(1)
        stem(data, 'linewidth',3), grid on;
        title('未调制原始数据流');
        axis([ 0 100 0 1.5]);

        data_NZR=2*data-1; % Data Represented at NZR form for QPSK modulation
        s_p_data=reshape(data_NZR,2,length(data)/2);  % S/P convertion of data


        br=10^9; %Let us transmission bit rate  1GHz
        fc=br; % minimum carrier frequency
        T=1/br; % bit duration
        t=T/99:T/99:T; % Time vector for one bit information
%----------------------------------------
%QPSK调制
%生成随机数据符号流
        y=[];
        y_in=[];
        y_qd=[];
        for j=1:length(data)/2
            y1=s_p_data(1,j)*cos(2*pi*fc*t); % inphase component
            y2=s_p_data(2,j)*sin(2*pi*fc*t) ;% Quadrature component
            y_in=[y_in y1]; % inphase signal vector
            y_qd=[y_qd y2]; %quadrature signal vector
            y=[y y1+y2]; % modulated signal vector
        end
        Tx_sig=y; % transmitting signal after modulation
        tt=T/99:T/99:(T*length(data))/2;
        
%----------------------------------------
        %画发送信号星座图               

        for k = 1:1:length(data)/2 
            y_constell(k) = complex(s_p_data(1,k),s_p_data(2,k));
        end
        y_constell = y_constell.';
        step(hScope1, y_constell)                   % Step scope
        y_constell = y_constell.';
        y_constell = [];
%----------------------------------------
        figure(2)

        subplot(3,1,1);
        plot(tt,y_in,'linewidth',3), grid on;
        title('QPSK同相调制分量');
        xlabel('time(sec)');
        ylabel(' amplitude(volt)');

        subplot(3,1,2);
        plot(tt,y_qd,'linewidth',3), grid on;
        title('QPSK正交调制分量');
        xlabel('time(sec)');
        ylabel(' amplitude(volt)');

        subplot(3,1,3);
        plot(tt,Tx_sig,'r','linewidth',3), grid on;
        title('QPSK调制信号 （同相和正交分量的和）');
        xlabel('time(sec)');
        ylabel(' amplitude(volt)');
%% 
        
%-------------------------------------------------------
%通过自由空间以及阴影衰落信道
        d0=100; sigma=3; distance=1000;
        Gt=[1 1 0.5]; Gr=[1 0.5 0.5]; Exp=[2 3 6]; %其余的为备选参数
        lamda=3e8/fc; PL= -20*log10(lamda/(4*pi*d0))+10*Exp(1)*log10(distance/d0); 
        ydb = PL + sigma*randn(size(distance));
        Tx_sig_dBm = 10*log10(abs(1000*Tx_sig)) - ydb;
        tx_sig_real = Tx_sig.*10.^(-ydb/10);
%         tx_sig_real = Tx_sig;
        figure(3)
        plot(tt,tx_sig_real,'r','linewidth',3), grid on;
        title('QPSK信号经过对数正态阴影衰落');
        xlabel('time(sec)');
        ylabel(' amplitude(volt)');
        
%-------------------------------------------------------
%瑞利信道&莱斯信道&natagami-m信道
        if (si==1)
            chan.AvgPathGaindB = chan.AvgPathGaindB + snr(si);
            chanraylei.AvgPathGaindB = chanraylei.AvgPathGaindB + snr(si);
        else
            chan.AvgPathGaindB = chan.AvgPathGaindB + snr(si) - snr(si-1);
            chanraylei.AvgPathGaindB = chanraylei.AvgPathGaindB + snr(si) - snr(si-1);
        end   
        % 调整这里的信噪比的单位关系
        yrician = awgn(filter(chan,tx_sig_real),snr(si),'measured');
        yraylei = awgn(filter(chanraylei,tx_sig_real),snr(si),'measured');
        ynakagami = (yrician + yraylei)/2;

%         yrician = filter(chan,Tx_sig_dBm);
%         yraylei = filter(chanraylei,Tx_sig_dBm);
%         yrician = filter(chan,tx_sig_real);
%         yraylei = filter(chanraylei,tx_sig_real);
%         ynakagami = (yrician + yraylei)/2;
        yawgn = awgn(tx_sig_real,snr(si),'measured');   %AWGN信道
  
        figure(4)
        subplot(4,1,1);
        plot(tt,yrician,'r','linewidth',3), grid on;
        title('QPSK信号经过对数正态阴影衰落 + 莱斯信道');
        xlabel('time(sec)');
        ylabel('amplitude(volt)');
        subplot(4,1,2);
        plot(tt,yraylei,'b','linewidth',3), grid on;
        title('QPSK信号经过对数正态阴影衰落 + 瑞利信道');
        xlabel('time(sec)');
        ylabel(' amplitude(volt)');
        subplot(4,1,3);
        plot(tt,ynakagami,'g','linewidth',3), grid on;
        title('QPSK信号经过对数正态阴影衰落 + nakagami-m信道');
        xlabel('time(sec)');
        ylabel(' amplitude(volt)');
        subplot(4,1,4);
        plot(tt,yawgn,'b','linewidth',1), grid on; hold on; 
        title('QPSK信号经过对数正态阴影衰落 + AWGN信道');
        xlabel('time(sec)');
%         axis([0 0.5*10^-7 -6 6]);
        ylabel(' amplitude(volt)');
%--------------------------------------------------------
%接收端增益放大
        yrician = yrician .* 10^(+ydb/10);
        yraylei = yraylei .* 10^(+ydb/10);
        ynakagami = ynakagami .* 10^(+ydb/10);
        yawgn = yawgn .* 10^(+ydb/10);     

%--------------------------------------------------------
%QPSK解调
        Rx_data1=[];
        Rx_data2=[];
        Rx_data3=[];
        Rx_data4=[];
        Rx_sig_rician=yrician; % Received signal
        Rx_sig_raylei=yraylei; % Received signal
        Rx_sig_nakagami=ynakagami; % Received signal
        Rx_sig_awgn=yawgn; % Received signal
        for(j=1:1:length(data)/2)

            %%XXXXXX inphase coherent dector XXXXXXX
            Z_in1=Rx_sig_rician((j-1)*length(t)+1:j*length(t)).*cos(2*pi*fc*t); 
            Z_in2=Rx_sig_raylei((j-1)*length(t)+1:j*length(t)).*cos(2*pi*fc*t); 
            Z_in3=Rx_sig_nakagami((j-1)*length(t)+1:j*length(t)).*cos(2*pi*fc*t); 
            Z_in4=Rx_sig_awgn((j-1)*length(t)+1:j*length(t)).*cos(2*pi*fc*t); 
            % above line indicat multiplication of received & inphase carred signal

            Z_in_intg1=(trapz(t,Z_in1))*(2/T);% integration using trapizodial rull
            Z_in_constell1 = [Z_in_constell1 Z_in_intg1];
            if(Z_in_intg1>0) % Decession Maker
                Rx_in_data1=1;
            else
               Rx_in_data1=0; 
            end
            
            Z_in_intg2=(trapz(t,Z_in2))*(2/T);% integration using trapizodial rull
            Z_in_constell2 = [Z_in_constell2 Z_in_intg2];
            if(Z_in_intg2>0) % Decession Maker
                Rx_in_data2=1;
            else
               Rx_in_data2=0; 
            end
            
            Z_in_intg3=(trapz(t,Z_in3))*(2/T);% integration using trapizodial rull
            Z_in_constell3 = [Z_in_constell3 Z_in_intg3];
            if(Z_in_intg3>0) % Decession Maker
                Rx_in_data3=1;
            else
               Rx_in_data3=0; 
            end
            
            Z_in_intg4=(trapz(t,Z_in4))*(2/T);% integration using trapizodial rull
            Z_in_constell = [Z_in_constell Z_in_intg4];
%             Z_in_constell = [Z_in_constell Z_in_intg4-fix(Z_in_intg4)];
            if(Z_in_intg4>0) % Decession Maker
                Rx_in_data4=1;
            else
               Rx_in_data4=0; 
            end
            %%XXXXXX Quadrature coherent dector XXXXXX
            Z_qd1=Rx_sig_rician((j-1)*length(t)+1:j*length(t)).*sin(2*pi*fc*t);
            Z_qd2=Rx_sig_raylei((j-1)*length(t)+1:j*length(t)).*sin(2*pi*fc*t);
            Z_qd3=Rx_sig_nakagami((j-1)*length(t)+1:j*length(t)).*sin(2*pi*fc*t);
            Z_qd4=Rx_sig_awgn((j-1)*length(t)+1:j*length(t)).*sin(2*pi*fc*t);
            %above line indicat multiplication ofreceived & Quadphase carred signal

            Z_qd_intg1=(trapz(t,Z_qd1))*(2/T);%integration using trapizodial rull
            Z_qd_intg2=(trapz(t,Z_qd2))*(2/T);%integration using trapizodial rull
            Z_qd_intg3=(trapz(t,Z_qd3))*(2/T);%integration using trapizodial rull
            Z_qd_intg4=(trapz(t,Z_qd4))*(2/T);%integration using trapizodial rull
%             Z_qd_constell = [Z_qd_constell Z_qd_intg4-fix(Z_qd_intg4)];
            Z_qd_constell = [Z_qd_constell Z_qd_intg4];
            Z_qd_constell1 = [Z_qd_constell1 Z_qd_intg1];
            Z_qd_constell2 = [Z_qd_constell2 Z_qd_intg2];
            Z_qd_constell3 = [Z_qd_constell3 Z_qd_intg3];
                if (Z_qd_intg1>0)% Decession Maker
                Rx_qd_data1=1;
                else
               Rx_qd_data1=0; 
                end
                if (Z_qd_intg2>0)% Decession Maker
                Rx_qd_data2=1;
                else
               Rx_qd_data2=0; 
                end
                if (Z_qd_intg3>0)% Decession Maker
                Rx_qd_data3=1;
                else
               Rx_qd_data3=0; 
                end
                if (Z_qd_intg4>0)% Decession Maker
                Rx_qd_data4=1;
                else
               Rx_qd_data4=0; 
                end

                Rx_data1 = [Rx_data1  Rx_in_data1  Rx_qd_data1]; % Received Data vector
                Rx_data2 = [Rx_data2  Rx_in_data2  Rx_qd_data2]; % Received Data vector
                Rx_data3 = [Rx_data3  Rx_in_data3  Rx_qd_data3]; % Received Data vector
                Rx_data4 = [Rx_data4  Rx_in_data4  Rx_qd_data4]; % Received Data vector
        end
        data_compare = data';
        errors1(si) = errors1(si) + sum(Rx_data1 ~= data_compare);
        errors2(si) = errors2(si) + sum(Rx_data2 ~= data_compare);
        errors3(si) = errors3(si) + sum(Rx_data3 ~= data_compare);
        errors4(si) = errors4(si) + sum(Rx_data4 ~= data_compare);
        
        %----------------------------------------
        %画接受信号星座图               

        for k = 1:1:length(data)/2 
            y_constell_receive(k) = complex(Z_in_constell(k),Z_qd_constell(k));
            y_constell_receive1(k) = complex(real(Z_in_constell1(k)),real(Z_qd_constell1(k)));
            y_constell_receive2(k) = complex(real(Z_in_constell2(k)),real(Z_qd_constell2(k)));
            y_constell_receive3(k) = complex(real(Z_in_constell3(k)),real(Z_qd_constell3(k)));
%             y_constell_receive(k) = y_constell_receive(k)/abs(y_constell_receive(k));
        end
        y_constell_receive = y_constell_receive.';y_constell_receive1 = y_constell_receive1.';
        y_constell_receive2 = y_constell_receive2.';y_constell_receive3 = y_constell_receive3.';
        step(hScope2, y_constell_receive)                   % Step scope
        step(hScope3, y_constell_receive1)
        step(hScope4, y_constell_receive2)
        step(hScope5, y_constell_receive3)
        y_constell_receive = y_constell_receive.';y_constell_receive1 = y_constell_receive1.';
        y_constell_receive2 = y_constell_receive2.';y_constell_receive3 = y_constell_receive3.';
        y_constell_receive = [];y_constell_receive1 = [];y_constell_receive2 = [];y_constell_receive3 = [];
        Z_in_constell = [];Z_in_constell1 = [];Z_in_constell2 = [];Z_in_constell3 = [];
        Z_qd_constell = [];Z_qd_constell1 = [];Z_qd_constell2 = [];Z_qd_constell3 = [];
%----------------------------------------
        
    end
    ser1   = [ser1 errors1(si)];
    ser2   = [ser2 errors2(si)];
    ser3   = [ser3 errors3(si)];
    ser4   = [ser4 errors4(si)];
end
%------------------------------------------------------
%画结果图
hold off;
figure (5)
semilogy(snr, ser1/((length(data)*its)),'g-o','linewidth',2.5);
hold on;
semilogy(snr, ser2/((length(data)*its)),'r-o','linewidth',2.5);
semilogy(snr, ser3/((length(data)*its)),'b-o','linewidth',2.5);
semilogy(snr, ser4/((length(data)*its)),'m-o','linewidth',2.5);
grid on;
legend({'莱斯信道-K=3','瑞利信道','nakagami-m信道-m=2.29','AWGN信道'});
axis([-25 5 10^(-3) 1]);
title('不同信噪比情况下的信噪比与误码率曲线')
xlabel('SNR');
ylabel('BER');
