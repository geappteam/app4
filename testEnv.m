clc
clear all
close all

[y,Fs] = audioread('res/note_guitare_LAd.wav');

out = enveloppe(y, Fs, 0.0005);

plot (1:size(y), abs(y), 1:size(out),out*2);