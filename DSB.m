clear;
clc;
close all
% read audio message
[m, fs] = audioread('eric.wav');
sound(m, fs);

M = fftshift(fft(m));
Fvec = linspace(-fs/2,fs/2,length(M));

% Freq domain representation
figure
plot(Fvec, abs(M));
title('Freq domain representation of message');

% Time domain representation
t=linspace(0, length(m)/fs, length(m));
figure
plot(t, m);
title('Time domain representation of message');

% filterring frequencies above 4KHz
sample_per_hertz = (length(m)/fs);
M (1 : round(sample_per_hertz*(fs/2 - 4*10^3))) = 0;
M (round(sample_per_hertz*(fs/2 + 4*10^3))+ 1 : end) = 0;

% Freq domain representation after filtering
figure
plot(Fvec, abs(M));
title('Filtered message in freq domain')

% Time domain representation after filtering
m = real(ifft(ifftshift(M)));
t = linspace(0, length(m)/fs, length(m));
figure
plot(t, m);
title('Filtered message in time domain');
%sound(m, fs);
%-------------------------DSC-SC-------------------------
%---DSB-SC moduation---

%envelop detector
DC_coeff = 0;
DSB_Mod(m, fs, DC_coeff, "SC");

%coherent detector
%changing SNR with freq error = 0 and phase error = 0
freq_error = 0;
phase_error = 0;
DC_coeff = 0;
DSB_Mod_coh(m, fs, DC_coeff, freq_error, 0, phase_error, "SC");
DSB_Mod_coh(m, fs, DC_coeff, freq_error, 10, phase_error, "SC");
DSB_Mod_coh(m, fs, DC_coeff, freq_error, 30, phase_error, "SC");

%changing SNR with freq error = 100 and phase error = 0 
freq_error = 100;
phase_error = 0;
DC_coeff = 0;
DSB_Mod_coh(m, fs, DC_coeff, freq_error, 0, phase_error, "SC");
DSB_Mod_coh(m, fs, DC_coeff, freq_error, 10, phase_error, "SC");
DSB_Mod_coh(m, fs, DC_coeff, freq_error, 30, phase_error, "SC");

%changing SNR with freq error = 0 and phase error = 20
freq_error = 0;
phase_error = 20;
DC_coeff = 0;
DSB_Mod_coh(m, fs, DC_coeff, freq_error, 0, phase_error, "SC");
DSB_Mod_coh(m, fs, DC_coeff, freq_error, 10, phase_error, "SC");
DSB_Mod_coh(m, fs, DC_coeff, freq_error, 30, phase_error, "SC");

%-------------------------DSC-TC-------------------------
%---DSB-TC moduation---

%envelop detector
mod_index = 0.5;
DC_coeff = 1 / mod_index;
DSB_Mod(m, fs, DC_coeff, "TC");

