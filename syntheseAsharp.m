clc
close all
clear all

% To change for tweaking
freq_separation_harmonics_tweak = 450;
almost_next_harmonic_multiplier = 1.8;
nb_main_sinus_needed = 32;
portion_maximum_spectral_ray_threshold = 0.10;

% Load guitar A sharp
[guitarAS, guitarAS_Fs] = audioread('res/note_guitare_LAd.wav');

% Constants
N = size(guitarAS,1);
fe = guitarAS_Fs;

x_axis_spectral_freq_data_alignment = -N/2;
spectral_freq_data_mid_index = N/2;

amplitudes = 1;
frequencies = 2;
phases = 3;

normalized_freq_des = pi/1000;
decimating_factor = 1000;

% Analog frequency
f = @(k) (k / N) * fe;

% Window (Hamming) created and applied on signal
hammingWindow = hamming(N);
hw_guitarAS = guitarAS.*hammingWindow;

% Fourrier Transform on hamming-windowed signal
FT_hw_guitarAS = fft(hw_guitarAS);
FT_hw_guitarAS = fftshift(FT_hw_guitarAS);

ampl_FT_hw_guitarAS = abs(FT_hw_guitarAS); 
phase_FT_hw_guitarAS = angle(FT_hw_guitarAS);

% Converting amplitude to dB amplitude
dB_ampl_FT_hw_guitarAS = 20*log10(ampl_FT_hw_guitarAS);

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
        maximum_spectral_ray_index = index;
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

% Isolating main sinus algorithm
[main_peaks, main_peaks_freq] = findpeaks(dB_ampl_FT_hw_guitarAS(spectral_freq_data_mid_index:N-1), f((spectral_freq_data_mid_index:N-1)+x_axis_spectral_freq_data_alignment),'MinPeakDistance',freq_separation_harmonics_tweak);
main_peaks_freq = main_peaks_freq';
%main_peaks_informations = [main_peaks (round((main_peaks_freq*N)/fe)+x_axis_spectral_freq_data_alignment)];
main_peaks_informations = [main_peaks main_peaks_freq];
main_peaks_informations = sortrows(main_peaks_informations,2);
main_peaks_informations = main_peaks_informations(2:nb_main_sinus_needed+1,:);

% Inserting other parameters, in one array, associated to the main sinus peaks
for main_sinus = 1:nb_main_sinus_needed
    main_sinus_parameters(main_sinus, amplitudes) = main_peaks_informations(main_sinus,1);
    main_sinus_parameters(main_sinus, frequencies) = main_peaks_informations(main_sinus,2);
    main_sinus_parameters(main_sinus, phases) = phase_FT_hw_guitarAS(round(main_peaks_informations(main_sinus,2)*N/fe));
end

figure(3)
subplot(2,1,1)
stem(main_sinus_parameters(:,frequencies),main_sinus_parameters(:,amplitudes));
xlabel('Frequency (Hz)')
ylabel('Amplitude (dB)')
subplot(2,1,2)
stem(main_sinus_parameters(:,frequencies),main_sinus_parameters(:,phases));
xlabel('Frequency (Hz)')
ylabel('Phase (rads/s)')


%% Recreating signal
main_sinus_sum = preriodicSignComposition(main_sinus_parameters, N, fe);
decimated_env = decimate(enveloppe( guitarAS, normalized_freq_des),decimating_factor); 

n_dec_env_samples = N/decimating_factor;
synth_signal = zeros(size(N));

for index_dec_env = 1:n_dec_env_samples
    begin_index = index_dec_env * decimating_factor - (decimating_factor - 1);
    ending_index = index_dec_env * decimating_factor;
    for index = begin_index:ending_index
        synth_signal(index) = main_sinus_sum(index).*decimated_env(index_dec_env);
    end
end

synth_signal = synth_signal';

figure(4)
plot(1:N, guitarAS);

figure(5)
plot(1:N, synth_signal);