clc
close all
clear all


% Load guitar A sharp
[guitarAS, guitarAS_Fs] = audioread('res/note_guitare_LAd.wav');

% Constants
N = size(guitarAS,1);
fe = guitarAS_Fs;
portion_maximum_spectral_ray_threshold = 0.10;
x_axis_spectral_freq_data_alignment = -N/2;
spectral_freq_data_mid_index = N/2;
nb_main_sinus_needed = 32;

amplitudes = 1;
frequencies = 2;
phases = 3;

almost_next_harmonic_multiplier = 1.8;


% Analog frequency
f = @(k) (k / N) * fe;

% Window (Hamming) created and applied on signal
hammingWindow = hamming(N);
hw_guitarAS = guitarAS.*hammingWindow;

% Fourrier Transform on hamming-windowed signal
FT_hw_guitarAS = fft (hw_guitarAS);
FT_hw_guitarAS = fftshift(FT_hw_guitarAS);

ampl_FT_hw_guitarAS = abs(FT_hw_guitarAS);
phase_FT_hw_guitarAS = angle(FT_hw_guitarAS);

% Converting amplitude to dB amplitude
dB_ampl_FT_hw_guitarAS = 20*log(ampl_FT_hw_guitarAS);

% To align the X-asis for showing only the valuable information
highest_considered_freq = f((N-1)+x_axis_spectral_freq_data_alignment);

figure(1)
subplot(2,1,1)
plot(f((0:N-1)+x_axis_spectral_freq_data_alignment), dB_ampl_FT_hw_guitarAS); % Minus 80000 on the x-axis for aligntment purpose on 0
xlim([0 highest_considered_freq])
title('Amplitude after FFT and Hamming window on A Sharp signal')
xlabel('Frequency (Hz)')
ylabel('Amplitude (dB)')
subplot(2,1,2)
plot(f((0:N-1)+x_axis_spectral_freq_data_alignment), phase_FT_hw_guitarAS);
title('Phase after FFT and Hamming window on A Sharp signal')
xlabel('Frequency (Hz)')
ylabel('Phase (rads/s)')

% Choose the maximum spectral ray
maximum_spectral_ray = 0;
for index = 1:N
    if maximum_spectral_ray < dB_ampl_FT_hw_guitarAS(index)
        maximum_spectral_ray = dB_ampl_FT_hw_guitarAS(index);
    end
end

% Clean the array of useless data (data which amplitude is lower than 10%
% of the maximum spectral ray's amplitude)
spectral_ray_threshold = maximum_spectral_ray*portion_maximum_spectral_ray_threshold;
cleaned_dB_ampl_FT_hw_guitarAS = dB_ampl_FT_hw_guitarAS;
number_non_zero_data = N;
for index = 1:N
    if dB_ampl_FT_hw_guitarAS(index) < spectral_ray_threshold
        cleaned_dB_ampl_FT_hw_guitarAS(index) = 0;
        number_non_zero_data = number_non_zero_data - 1;
    end
end

% Show most important (main) amplitudes left 
figure(2)
plot(f((0:N-1)+x_axis_spectral_freq_data_alignment), cleaned_dB_ampl_FT_hw_guitarAS); % Minus 80000 on the x-axis for aligntment purpose on 0
xlim([0 highest_considered_freq])
title('Main considered amplitudes after FFT and Hamming window on A Sharp signal')
xlabel('Frequency (Hz)')

% Choosing main sinus algorithm
main_sinus_parameters = zeros(nb_main_sinus_needed,3);
for n_main_sinus = 1:nb_main_sinus_needed
    last_main_sinus = 0;
    last_main_sinus_index = 1;
    for index = spectral_freq_data_mid_index:N
        if  cleaned_dB_ampl_FT_hw_guitarAS(index) > last_main_sinus
            actual_frequency = f((index)+x_axis_spectral_freq_data_alignment);
            if (n_main_sinus == 1) || ((main_sinus_parameters((n_main_sinus-1), frequencies)*almost_next_harmonic_multiplier) < actual_frequency) || ((main_sinus_parameters((n_main_sinus-1), amplitudes)) < cleaned_dB_ampl_FT_hw_guitarAS(index)) 
                last_main_sinus_index = index;
                last_main_sinus = cleaned_dB_ampl_FT_hw_guitarAS(index);
            end
        end
    end
    
    main_sinus_parameters(n_main_sinus,amplitudes) = last_main_sinus;
    main_sinus_parameters(n_main_sinus,frequencies) = f((last_main_sinus_index)+x_axis_spectral_freq_data_alignment);
    main_sinus_parameters(n_main_sinus,phases) = phase_FT_hw_guitarAS(last_main_sinus_index);
end