% In this script, we test windows
% Hamming vs Hann

% Load guitar A sharp
[guitarAS, guitarAS_Fs] = audioread('res/note_guitare_LAd.wav');

% Constants
N = size(guitarAS,1);
fe = guitarAS_Fs;

w = hamming(N);
ww = hann(N);


wHammingSignal = guitarAS .* w;
wHannSignal = guitarAS .* ww;

fourrierTransform = fft (guitarAS);
shiftedFT = fftshift(fourrierTransform);

hamFourrierTransform = fft (wHammingSignal);
hamShiftedFT = fftshift(hamFourrierTransform);

hanFourrierTransform = fft (wHannSignal);
hanShiftedFT = fftshift(hanFourrierTransform);

figure(1)
subplot(3,1,1)
stem(f((0:N-1)-80000), abs(shiftedFT)); % Minus 80000 on the x-axis for aligntment purpose on 0
subplot(3,1,2)
stem(f((0:N-1)-80000), abs(hamShiftedFT));
subplot(3,1,3)
stem(f((0:N-1)-80000), abs(hanShiftedFT));