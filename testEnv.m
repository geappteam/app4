clc
clear all
close all

[y,Fs] = audioread('res/note_guitare_LAd.wav');
out = enveloppe(y, pi/1000);

tfreq = 69;
tt = 0:size(y)-1;
tsin = sin(tt * 2 * pi * tfreq / Fs);


plot (tt, abs(y), tt,out);