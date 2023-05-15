function DSB_Mod_coh(m, fs, DC_coeff, freq_error, SNR, phase_error, type)
%-------------------------TX DSC-SC-------------------------
fc = 100000;
fs_new = 5*fc;
f_m_resampled = resample(m, fs_new, fs);
t = linspace(0, length(f_m_resampled)/fs_new, length(f_m_resampled));
carrier = cos(2*pi*fc*t);
A = DC_coeff * max(f_m_resampled);
s_tx = (A + f_m_resampled) .* (carrier');
%--------------------TX DSC-SC with noise--------------------
if (type == "SC")
    carrier = cos(2*pi*fc*t + phase_error*(pi/180));
    DSB_SC_coherent(s_tx, fs, fs_new, carrier, SNR, fc + freq_error, phase_error);
end