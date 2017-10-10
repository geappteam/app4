clc
close all
clear all %#ok<CLSCR>

% Problematique
[y,Fs] = audioread('res/note_basson_plus_sinus_1000_Hz.wav');

% ***
% Bandpass Filter : 2 pole 2 zeros 
% Dc Gain = 0dB
% Cut-off frequency between 980 - 1020 Hz 
%                        -> Must be over -3 dB
% ***

% For information : "Check digitalFilter" class with Tool Help ! 

%% Bandpass Filter (IIR)
r = 0.9985;
N = length(y);
t = (0:N-1)'/Fs;                                    % t : time axis
fn_Low = 980;                                       % 980 Hz
fn_High = 1020;                                     % 1020 Hz
fn = ((fn_Low + fn_High)/2);                        % 1000 Hz

%% Put poles at same angle, inside unit circle
b = [1 -2*cos(2*pi*fn/Fs) 1];                       % Filter Coefficients
a = [1 -2*r*cos(2*pi*fn/Fs) r^2];                   % Filter Coefficients
b = b/sum(b)*sum(a);                                % Make Dc gain to 1

[z,p] = tf2zp(b,a);                                 % Check pole and zero

[H,w] = freqz(b,a);                                 % Freqz returns the frequency response based 
                                                    % on the current filter coefficients                         
y_Out = filter(b, a, y);                            % Apply BandpassFilter

% Check Transfer Function
sys = filt(b,a)                                     % Form (z^-1)
sys_Z = tf(b,a,0.1)                                 % Form (z) Ts = 0.1

% Converting amplitude to dB amplitude
H_dB = 20*log10(H);

%% Display IIR pole-zero diagram
figure('Name','Display IIR pole-zero diagram')
clf
zplane(b,a)
title('IIR notch filter')

%% Display IIR Frequency response
figure('Name','Display IIR Frequency response')
clf
plot(w/(2*pi)*Fs, H_dB)
xlabel('Frequency (Hz)')
title('Frequency response (IIR) filter')
box off

%% Display IIR filter to noisy speech
figure('Name','Display IIR filter to noisy speech')
clf
plot(t,y,t,y_Out)
legend('Noisy signal','Filtered (IIR)')
xlabel('Time (sec)')
       