clc
close all
clear all

decimating_factor = 1000;
cutoff = pi/1000;
numberOfLines = 32;

% Load guitar A sharp
[guitarAS, guitarAS_Fs] = audioread('res/note_guitare_LAd.wav');

% guitarAS_Fs = 44100;
% tt = (0:1/guitarAS_Fs:10)';
% guitarAS = sin(2*pi*1000*tt);

N = size(guitarAS,1);

env = enveloppe( guitarAS, cutoff);
decimated_env = decimate(env, decimating_factor);

lines = dftEncode(guitarAS, guitarAS_Fs, numberOfLines);

recSignal = recomposeSignal( lines, decimated_env, decimating_factor, guitarAS_Fs );

recSignal = recSignal*20;

plot((0:N-1)/guitarAS_Fs, guitarAS, (0:(size(recSignal,1)-1))/guitarAS_Fs, recSignal)