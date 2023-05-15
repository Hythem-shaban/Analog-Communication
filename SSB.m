clear
clc
close all
% 1
[y,fs] = audioread('eric.wav');
%sound(y,fs);
%pause(length(y)/fs); % wait until finishing sound file 
t1= linspace(0,length(y)/fs,length(y)); % Duration=number of samles[length(y)]/sampling frequency[fs]
yf = fftshift(fft(y));
yfmag = abs(yf);
fvac = linspace(-fs/2,fs/2,length(yf));
figure;
subplot(2,1,1)
plot(t1,y);
title(' SOUND FILE IN TIME DOMAIN');
grid on
subplot(2,1,2)
plot(fvac,yfmag);
title(' SOUND FILE  IN FREQ. DOMAIN [MAGNITUDE SPECTRUM]');
grid on


%2
Filter=ones(length(yf),1);
f1=round((-4*1000+fs/2).*(length(yf)/fs));
f2=round((4*1000+fs/2).*(length(yf)/fs));
Filter([1:f1  f2:end])=0;
yfiltered = yf.* Filter;
yfmagfiltered = abs(yfiltered);
fvacfiltered = linspace(-fs/2,fs/2,length(yfiltered));






%3
yt = real(ifft(ifftshift(yfiltered)));
t2= linspace(0,length(yt)/fs,length(yt));
figure;
subplot(2,1,1)
plot(fvacfiltered,yfmagfiltered);
title(' FILTERED SOUND FILE  IN FREQ. DOMAIN [MAGNITUDE SPECTRUM]');
grid on
subplot(2,1,2)
plot(t2,yt);
title(' FILTERED SOUND FILE IN TIME DOMAIN');
grid on

yt2 = yt;
ytmag=abs(yt);
%sound(ytmag,fs);
%pause(length(ytmag)/fs); % wait until finishing sound file 



%4
yf2 = fftshift(fft(yt2));
yfmag2 = abs(yf2);
fvac2 = linspace(-fs/2,fs/2,length(yf2));

% DSB-SC :
cs=5*100000;
yt3 = resample(yt2,cs,fs); %resampled message
t3 =  linspace(0,length(yt3)/cs,length(yt3));
carrier = cos(2*pi*100000*t3);
carrier = carrier';

stsc = yt3 .* carrier;

yf3 = fftshift(fft(stsc));
yfmag3 = abs(yf3);
fvac3 = linspace(-cs/2,cs/2,length(yt3));

%figure;
%plot(fvac3,yf3);
figure;
subplot(2,1,1)
plot(t3,stsc);
title(' MODULATED SOUND FILE IN TIME DOMAIN -SC');
grid on
subplot(2,1,2)
plot(fvac3,yfmag3);
title(' MODULATED SOUND FILE IN FREQ DOMAIN -SC');
grid on





%5
%SSB-SC

lsb_sc_f=yf3;
B  = 100000; %filtering the usb
SSBFdem = length(lsb_sc_f)./(cs);
lim = ceil(((cs/2)-B)*SSBFdem);
lsb_sc_f([1:lim  length(lsb_sc_f)-lim+1:length(lsb_sc_f)]) = 0;
lsb_sc_fmag  = abs(lsb_sc_f) ;

flsbfiltered = linspace(-cs/2,cs/2,length(lsb_sc_f));
figure;
plot(flsbfiltered,lsb_sc_fmag);
title(' LSSB  IN FREQ. DOMAIN [MAGNITUDE SPECTRUM]');

%lsb in time domain
lsb_sc_t = real(ifft(ifftshift(lsb_sc_f)));
 

%6
coh_dem=2.*carrier;
lsb_sc_t_dem=lsb_sc_t.*coh_dem; %coherent detection
mfenvtc = fftshift(fft(lsb_sc_t_dem));
B  = 4000; %bandwidth of the filter
SSBFdem = length(mfenvtc)./(cs);
lim = ceil(((cs/2)-B)*SSBFdem);
mfenvtc([1:lim  length(mfenvtc)-lim+1:length(mfenvtc)]) = 0;
lsb_sc_t_dem = real(ifft(ifftshift(mfenvtc)));
lsb_sc_t_res = resample(lsb_sc_t_dem,fs,cs); %resample to fs
lsb_sc_f_res = fftshift(fft(lsb_sc_t_res));

flsbdem=linspace(-fs/2,fs/2,length(lsb_sc_f_res));
lsb_sc_f_resmag=abs(lsb_sc_f_res);
lsb_sc_t_resmag = abs(lsb_sc_t_res);
tlsbdem= linspace(0,length(lsb_sc_t_res)/fs,length(lsb_sc_t_res));
figure;
subplot(2,1,1)
plot(tlsbdem,lsb_sc_t_res);
title(' LSSB  IN TIME DOMAIN after demodulation');
grid on
subplot(2,1,2)
plot(flsbdem,lsb_sc_f_resmag);
title(' LSSB  IN FREQ. DOMAIN [MAGNITUDE SPECTRUM] after demodulation');
grid on
%sound(lsb_sc_t_resmag,fs);
%pause(length(lsb_sc_t_resmag)/fs); % wait until finishing sound file



%%7 repeat 5
lsb_sc_f_btr=yf3;
lsb_sc_t_btr = real(ifft(ifftshift(lsb_sc_f_btr)));
lsb_sc_f_btrmag  = abs(lsb_sc_f_btr) ;
[C,B2] = butter(4,100000/(cs/2),'low');
lsb_sc_t_btr_fl=filter(C,B2,lsb_sc_t_btr);
lsb_sc_f_btr_fl= fftshift(fft(lsb_sc_t_btr_fl));
lsb_sc_f_btr_flmag  = abs(lsb_sc_f_btr_fl) ;
flsbfilteredbtr = linspace(-cs/2,cs/2,length(lsb_sc_f_btr_fl));
figure;
plot(flsbfilteredbtr,lsb_sc_f_btr_flmag);
title(' LSSB  IN FREQ. DOMAIN [MAGNITUDE SPECTRUM] butter');


%7 repeat 6
coh_dem=2.*carrier;
lsb_sc_t_dem_btr=lsb_sc_t.*coh_dem;
%lsb_sc_f_dem_btr = fftshift(fft(lsb_sc_t_dem_btr));
[z,f] = butter(4,4000/(cs/2),'low');
lsb_sc_t_dem_btr=filter(z,f,lsb_sc_t_dem_btr);
%lsb_sc_t_dem_btr = real(ifft(ifftshift(lsb_sc_f_dem_btr)));
lsb_sc_t_btr_res = resample(lsb_sc_t_dem_btr,fs,cs);
lsb_sc_f_btr_res = fftshift(fft(lsb_sc_t_btr_res));
flsbdembtr=linspace(-fs/2,fs/2,length(lsb_sc_f_btr_res));
lsb_sc_f_btr_resmag=abs(lsb_sc_f_btr_res);
lsb_sc_t_btr_resmag = abs(lsb_sc_t_btr_res);
tlsbdembtr= linspace(0,length(lsb_sc_t_btr_res)/fs,length(lsb_sc_t_btr_res));

figure;
subplot(2,1,1)
plot(tlsbdembtr,lsb_sc_t_btr_res);
title(' LSSB  IN TIME DOMAIN after demodulation butter');
grid on
subplot(2,1,2)
plot(flsbdembtr,lsb_sc_f_btr_resmag);
title(' LSSB  IN FREQ. DOMAIN [MAGNITUDE SPECTRUM] after demodulation butter');
grid on
%sound(lsb_sc_t_btr_resmag,fs);
%pause(length(lsb_sc_t_btr_resmag)/fs); % wait until finishing sound file

%8
%0 dB
snr0=awgn(lsb_sc_t_res,0);
snr0f=fftshift(fft(snr0));
snr0fmag=abs(snr0f);
snr0mag=abs(snr0);
figure;
subplot(2,1,1)
plot(tlsbdem,snr0);
title(' LSSB  IN TIME DOMAIN 0dB');
grid on
subplot(2,1,2)
plot(flsbdem,snr0fmag);
title(' LSSB  IN FREQ. DOMAIN [MAGNITUDE SPECTRUM] 0dB');
grid on
%sound(snr0mag,fs);
%pause(length(snr0)/fs);

%10 dB
snr10=awgn(lsb_sc_t_res,10);
snr10f=fftshift(fft(snr10));
snr10fmag=abs(snr10f);
snr10mag=abs(snr10);
figure;
subplot(2,1,1)
plot(tlsbdem,snr10);
title(' LSSB  IN TIME DOMAIN 10dB');
grid on
subplot(2,1,2)
plot(flsbdem,snr10fmag);
title(' LSSB  IN FREQ. DOMAIN [MAGNITUDE SPECTRUM] 10dB');
grid on
%sound(snr10mag,fs);
%pause(length(snr10)/fs);

%30 dB
snr30=awgn(lsb_sc_t_res,30);
snr30f=fftshift(fft(snr30));
snr30fmag=abs(snr30f);
snr30mag=abs(snr30);
figure;
subplot(2,1,1)
plot(tlsbdem,snr30);
title(' LSSB  IN TIME DOMAIN 30dB');
grid on
subplot(2,1,2)
plot(flsbdem,snr30fmag);
title(' LSSB  IN FREQ. DOMAIN [MAGNITUDE SPECTRUM] 30dB');
grid on
%sound(snr30mag,fs);
%pause(length(snr30)/fs);


%9
am=max(abs(y));
Ac=am/0.5;
mtlssbtc=lsb_sc_t+Ac.*carrier;
mflssbtc=fftshift(fft(mtlssbtc));
mflssbtcmag=abs(mflssbtc);
figure;
subplot(2,1,1)
plot(t3,mtlssbtc);
title(' LSSB TC  IN TIME DOMAIN');
grid on
subplot(2,1,2)
plot(flsbfiltered,mflssbtcmag);
title(' LSSB TC  IN FREQ. DOMAIN [MAGNITUDE SPECTRUM]');
grid on

%Envelope Detector
mtenvtc = abs(hilbert(mtlssbtc)) - Ac;

mfenvtc = fftshift(fft(mtenvtc));

B  = 4000; %bandwidth of the filter
SSBF_low = length(mfenvtc)./(cs);
lim = ceil(((cs/2)-B)*SSBF_low);
mfenvtc([1:lim  length(mfenvtc)-lim+1:length(mfenvtc)]) = 0;
mtenvtcfl =ifft(ifftshift(mfenvtc));
tenv = linspace(0, length(mtenvtc)/cs, length(mtenvtc));



figure;
plot(tenv,mtenvtcfl);
title(' LSSB TC ENV IN TIME DOMAIN');


envtcres = resample(mtenvtcfl,fs,cs);
%sound(envtcres,fs);
%pause(length(envtcres)/fs);

