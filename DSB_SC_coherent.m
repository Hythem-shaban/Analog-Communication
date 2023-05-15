function DSB_SC_coherent(s_tx, fs, fs_new, carrier, SNR, fc, phase_error)
t = linspace(0, length(s_tx)/fs_new, length(s_tx));
noisy_s_tx = awgn(s_tx, SNR);
s_rx = (noisy_s_tx) .* (carrier');

S_rx = fftshift(fft(s_rx));
Fvec = linspace(-fs_new/2, fs_new/2, length(s_rx));
figure
plot(Fvec, abs(S_rx));
title("DSB-SC(coherent)signal in freq with: SNR= "+SNR+", Fc= "+fc+", phase error= "+phase_error);

figure
plot(t, s_rx);
title("DSB-SC(coherent)signal in time with: SNR= "+SNR+", Fc= "+fc+", phase error= "+phase_error);

% LPF
sample_per_hertz = (length(s_rx)/fs_new);
S_rx (1 : round(sample_per_hertz*(fs_new/2 - 4*10^3))) = 0;
S_rx (round(sample_per_hertz*(fs_new/2 + 4*10^3))+ 1 : end) = 0;

figure
plot(Fvec, abs(S_rx));
title("DSB-SC(coherent)LPF signal in freq with: SNR= "+SNR+", Fc="+fc+", phase error= "+phase_error);

LPF_s_rx = real(ifft(ifftshift(S_rx)));
figure
plot(t, LPF_s_rx);
title("DSB-SC(coherent)LPF signal in freq with: SNR= "+SNR+", Fc="+fc+", phase error= "+phase_error);

m_original = resample(LPF_s_rx, fs, fs_new);
%sound(m_original, fs);