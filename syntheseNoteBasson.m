clc
close all
clear all %#ok<CLSCR>

% Load guitar Note Basson
[y, Fs] = audioread('res/note_basson_plus_sinus_1000_Hz.wav');

% Load Function Bandpass Sinus 1000 Hz
CleanNoteBasson = FctBandpassSinus1000Hz(y, Fs);

% Create a wave file
filename = 'res/note_basson.wav';
audiowrite(filename,CleanNoteBasson,Fs)

