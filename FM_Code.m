% This code simulate Experiment 3 about Narrow Band Frequency Modulation

% Clear is used to clear variables in workspace so that each time we run 
% the program it will process as it was the first time also to prevent
% the confusion of variables from the previous experiments

% clc is used to clear commands in Command Window

% close all is used to close all previous figures
clear             
clc
close all

% Step One : reading audio file attached
% m_t will store message sample vector and fs will store sampling rate of
% messege
[m_t, fs] = audioread("eric.wav");

% Since Messege is column vector, we have to convert it into row vector to
% be able to process it with other variables
%(we can transpose the other variables instead of this one but it will be 
% tedious task)
m_t = m_t';

% Evaluating Message Specturm
M_F = fftshift(fft(m_t));

% Ploting Message in Time domain and Frequency domain

% endTime will store period of audio without knowing it in advance
endTime = length(m_t) / fs ;

% time vector will be used to plot signal in time domain
time = linspace(0,endTime,length(m_t));

% while freq will be used to plot signal in frequency domain
% according to Nyquist: Sampling frequency is greater than maximum
% frequency in messege that is why we divide sampling frequency and plot
% from negative half of sampling frequency to half of sampling frequency
freq = linspace(-fs/2,fs/2,length(m_t));

% Ploting signal in time domain
figure
plot(time,m_t);
title("Signal In Time Domain");

% Ploting signal in frequency domain
figure
plot(freq,abs(M_F));
title("Signal In Frequency Domain");

% Step Two : use ideal filter to remove frequencies above 4kHz
% Factor is calculated which will be used in filtering the signal
factor = (length(M_F)/fs);

% the filter will allow signal of frequency ranging from
% -4khz to 4khz while prevent the other frequencies from passing so
% samples from start to -4 khz and samples from 4 khz to end become zeros
% round is used to eliminate the probability of existing fraction index as
% that will result in error.

f_F = M_F;
f_F (1:round(factor*(fs/2 - 4*10^3))) = 0;
f_F (round(factor*(fs/2 + 4*10^3))+ 1:end)=0;

% Returning Filtered signal to time domain
f_t = real(ifft(ifftshift(f_F)));

% Ploting filtered signal in time domain
figure
plot(time,f_t);
title("Filtered Signal In Time Domain");

% Step Three :
% Ploting signal in frequency domain
figure
plot(freq,abs(f_F));
title("Filtered Signal In Frequency Domain");

% Sounding the filtered signal
sound(f_t,fs);

% Step Four : Generating DSB - SC Modulated Signal
% Carrier Properties
fc = 100 * 10^3;
fm = 5*fc;

% e_t is upsampled version of f_t
e_t = resample(f_t, fm, fs);
e_F = fftshift(fft(e_t));

% due to upsampling, old time vector can't be used as well as old freq
% vector. so we create new vector that will be used to plot the signal
% later in the program
time_new = linspace(0,endTime,length(e_t));
freq_new = linspace(-fm/2,fm/2,length(e_t));

% Ploting resampled filtered signal in time domain
figure
plot(time_new,e_t);
title("Resampled Filtered Signal In Time Domain");

% Ploting resampled filtered signal in frequency domain
figure
plot(freq_new,abs(e_F));
title("Resampled Filtered Signal In Frequency Domain");

% DSB-SC modulated Signal
x_SC =  e_t.*cos(2*pi*fc*time_new);
X_SC = fftshift(fft(x_SC));

% Ploting DSB-SC modulated Signal in time domain
figure
plot(time_new,x_SC);
title("DSB-SC modulated Signal In Time Domain");

% Ploting resampled filtered signal in frequency domain
figure
plot(freq_new,abs(X_SC));
title("DSB-SC modulated Signal In Frequency Domain");

% Modulated Signal

% Modulation Properties
kf = 0.8;
f_maxdev = kf*max(e_t)/(2*pi);
A = 1;

% Phi is angle deviation in modulated signal
% cumsum is summation of signal which is equivalent to integration for
% continous signal. since MATLAB store values as samples we use summation
% instead of intgration.
Phi = kf.* cumsum(e_t);

% Applying signal to FM formula
s_t =  A.*cos(2*pi*fc*time_new + Phi);
s_F = fftshift(fft(s_t));

% Ploting Modulated Signal in time domain
figure
plot(time_new,s_t);
title("Modulated Signal In Time Domain");

% Ploting Modulated Signal in frequency domain
figure
plot(freq_new,abs(s_F));
title("Modulated Signal In Frequency Domain");

% Step 2 Question Answer
% The Modulated signal is nearly cosine signal with various frequencies
% that increase with increase of message amplitude and decreases with
% decrease of message amplitude. 
% maximum frequency deviation = (max(m_t)*kf)/(2*pi) = 0.0253

% Step 3 Question Answer
% it is required that phase deviation to be less than 30 degree (pi/6 rad)
% and modulation index or frequency deviation constant very small compared
% to one. so that bandwidth of transmitted signal become nearly 2*fm in
% this case 8 kHZ (Similar to DSB-TC)


% Demodulation

% r is received signal
% demodulation require differentiator then result pass through envolope
% detector to detect envolope of output signal
% diff is used to calculate difference of vector which is equivalent to
% differentiation for continous signal but again as MATLAB store signal as
% samples. differencing samples is equivalent to differentiating the signal
diff_t = diff(s_t);
diff_F = fftshift(fft(diff_t));

% abs(hilbert()) is equivlent to envolope of signal
r_t = abs(hilbert(diff_t));
r_t = r_t - mean(r_t);
r_t = r_t/kf;
r_F = fftshift(fft(r_t));

% since the output signal is of length less than original by 1 so the
% time_new vector and freq_new vector must be reduced by one sample too
time_new = time_new(1:end-1);
freq_new = freq_new(1:end-1);

% Ploting Demodulated Signal in time domain
figure
plot(time_new,r_t);
title("Demodulated Signal In Time Domain");

% Ploting Demodulated Signal in frequency domain
figure
plot(freq_new,abs(r_F));
title("Demodulated Signal In Frequency Domain");

% to playback the sound, we need to return it to original rate
r_t = resample(r_t,fs,fm);
sound(r_t,fs);