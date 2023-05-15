function DSB_Mod(m, fs, DC_coeff, type)
%-------------------------TX DSC-------------------------
fc = 100000;
fs_new = 5*fc;
f_m_resampled = resample(m, fs_new, fs);
t = linspace(0, length(f_m_resampled)/fs_new, length(f_m_resampled));
carrier = cos(2*pi*fc*t);
A = DC_coeff * max(f_m_resampled);
s_tx = (A + f_m_resampled) .* (carrier');

%Freq domain representation of transmitted signal
S_tx = fftshift(fft(s_tx));
Fvec = linspace(-fs_new/2, fs_new/2, length(s_tx));
figure
plot(Fvec, abs(S_tx));
title('DSB-'+type+' transmitted signal in freq domain');

%-------------------------RX DSC-------------------------
envelop = abs(hilbert(s_tx));
% Time domain representation of received signal
figure
plot(t, envelop);
title('DSB-'+type+' received (envelop) signal in time domain');
m_original = resample(envelop, fs, fs_new);
%sound(m_original, fs);
