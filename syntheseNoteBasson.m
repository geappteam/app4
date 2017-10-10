clc

% Load guitar Note Basson
[y, Fs] = audioread('res/note_basson_plus_sinus_1000_Hz.wav');

% Load Function Bandpass Sinus 1000 Hz
CleanNoteBasson = FctNotchFilterSinus1000Hz(y, Fs);

% Create a wave file
filename = 'res/note_basson.wav';
% audiowrite(filename,CleanNoteBasson,Fs)


N = size(y,1); 
af = @(k) (k / N) * Fs;

cleanWindowed = CleanNoteBasson .* hann(N);
FT_hw_signal = fft(cleanWindowed);

ampSpec = abs(FT_hw_signal(1:N/2)/N);
ampSpec(2:end) = 2*ampSpec(2:end);

%ampSpec = mag2db(ampSpec)+6;
ampSpec = ampSpec * db2mag(6);

figure (13)
subplot(2,1,2)
plot(af(0:N/4-1), mag2db(ampSpec(1:N/4)));
hold on

% Finding the fundamental frequency
[~, ffIndex] = max(ampSpec);

% Finding the main frequency peaks
ampSpec(1:(ffIndex/2)-1) = 0;   % Ingnoring anything below the fundamental
[pkAmp, pkIndices] = findpeaks(ampSpec, ...
    'MinPeakDistance', round(0.9 * ffIndex)/2, ...
    'NPeaks', 32);

spectralLines = zeros(32, 3);

for line = 1:size(pkAmp, 1)
    spectralLines(line,1) = pkAmp(line);
    spectralLines(line,2) = af(pkIndices(line));
    spectralLines(line,3) = angle(FT_hw_signal(pkIndices(line)));
end

stem (spectralLines(:,2), mag2db(spectralLines(:,1)))
title('Spectre filtre')
hold off
spectralLines

% Encoding enveloppe
env = enveloppe( CleanNoteBasson, pi/1000);
decimated_env = decimate(env, 1000);

% Decodage
recSignal = recomposeSignal( spectralLines, decimated_env, 1000, Fs );
recSignal = recSignal*6;

sound (recSignal, Fs);


%% Affichage du spectre original
windowed = y .* hann(N);
FT_signal = fft(windowed);

amp2Spec = abs(FT_signal(1:N/2)/N);
amp2Spec(2:end) = 2*amp2Spec(2:end);

%ampSpec = mag2db(ampSpec)+6;
amp2Spec = amp2Spec * db2mag(6);
subplot(2,1,1)
plot(af(0:N/4-1), mag2db(amp2Spec(1:N/4)));
title('Spectre original')

%% Affichage du spectre synthetique
windowedRes = recSignal .* hann(size(recSignal,1));
FTl_signal = fft(windowedRes);

amp3Spec = abs(FTl_signal(1:size(recSignal,1)/2)/size(recSignal,1));
amp3Spec(2:end) = 2*amp3Spec(2:end);

%ampSpec = mag2db(ampSpec)+6;
amp3Spec = amp3Spec * db2mag(6);
figure()
plot(af(0:N/4-1), mag2db(amp3Spec(1:N/4)));
title('Spectre basson synthetique')
xlabel('Frequence (Hz)')
ylabel('Amplitude (dB)')