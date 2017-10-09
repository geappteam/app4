
% Problematique
[y,Fs] = audioread('res/note_guitare_LAd.wav');

% ***
% Cut-off frequency to be determined
% ***

% Low Pass Filter : Fc = 8000 H, fs = 44100 Hz, N = 2000(|M| = ?) Hamming Window

clc;
close all;
clear all;

fc = pi/1000;                                   % Cut-off standardized frequency 
N = 290;                                        % Estimated at 2000 -> To be determined
n = -((N-1)/2):((N-1)/2);       
n = n+(n==0)*eps;                               % Only to prevent devision by 0

[h] = sin(n*2*pi*fc)./(n*pi);                   % Generation of the sequence of ideal coefficients
[w] = 0.54 + 0.46*cos(2*pi*n/N);                % Generation of the Hamming Window
d = h .* w;                                     % Modified Filter

figure('Name','Truncated Impulse Response');
stem(d);                                        % Drawing Coefficient values obtained
xlabel('Coefficient Number');
ylabel('Value');
title('Truncated Impulse Response');

figure('Name','Freqz')
freqz(d);                           % Frequency response of digital filter
title('Frequency response of digital filter')