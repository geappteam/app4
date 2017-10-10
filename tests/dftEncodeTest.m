clc
close all
clear all

% Load guitar A sharp
[guitarAS, guitarAS_Fs] = audioread('res/note_guitare_LAd.wav');

tt = (0:1/44100:10)';
res = sin(2*pi*1000*tt);

%lines = dftEncode(guitarAS, guitarAS_Fs, 32)
lines = dftEncode(res, 44100, 32);
lines(1,1)