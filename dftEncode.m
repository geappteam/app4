function [ spectralLines ] = encode( signal, Fs, nbOfLines )
%ENCODE This function will convert a signal into the main spectral lines
%   returns a matrix :
%
%   SIGNAL is the list of points
%   FS is the sampling frequency
%   NBOFLINES is the number of significant spectral lines

window = true;
windowGainCorrection = 6;

if nargin < 2
    nbOfLines = 32;             % Default value
end

N = size(signal,1);             % Size of the input       
af = @(k) (k / N) * Fs;         % Analog frequency function


% Hamming Window applied on signal
if window
    signal = signal.* hann(N);
end
    
% DFT of the input signal
FT_hw_signal = fft(signal);

% Single sided FFT
ampSpec = abs(FT_hw_signal(1:N/2)/N);
ampSpec(2:end) = 2*ampSpec(2:end);

% gain correcttion for the window.
if window
    ampSpec = ampSpec * db2mag(windowGainCorrection);
end

% Finding the fundamental frequency
[~, ffIndex] = max(ampSpec);

% Finding the main frequency peaks
ampSpec(1:ffIndex-1) = 0;   % Ingnoring anything below the fundamental
[pkAmp, pkIndices] = findpeaks(ampSpec, ...
    'MinPeakDistance', round(0.9 * ffIndex), ...
    'NPeaks', nbOfLines);

spectralLines = zeros(nbOfLines, 3);

for line = 1:size(pkAmp, 1)
    spectralLines(line,1) = pkAmp(line);
    spectralLines(line,2) = af(pkIndices(line));
    spectralLines(line,3) = angle(FT_hw_signal(pkIndices(line)));
end
end

