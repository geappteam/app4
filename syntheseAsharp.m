clc
close all
clear all

% Load guitar A sharp
[guitarAS, guitarAS_Fs] = audioread('res/note_guitare_LAd.wav');

% Constants
N = size(guitarAS,1);
fe = guitarAS_Fs;

% Analog frequency
f = @(k) (k / N) * fe;

fourrierTransform = fft (guitarAS);
shiftedFT = fftshift(fourrierTransform);

figure(1)
subplot(2,1,1)
stem(f((0:N-1)-80000), abs(shiftedFT)); % Minus 80000 on the x-axis for aligntment purpose on 0
subplot(2,1,2)
stem(f((0:N-1)-80000), angle(shiftedFT));