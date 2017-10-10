decimating_factor = 1000;
cutoff = pi/1000;
numberOfLines = 32;

% Load guitar A sharp
[guitarAS, guitarAS_Fs] = audioread('res/note_guitare_LAd.wav');

N = size(guitarAS,1);

% Encodage
env = enveloppe( guitarAS, cutoff);
decimated_env = decimate(env, decimating_factor);
lines = dftEncode(guitarAS, guitarAS_Fs, numberOfLines);

save lines.mat lines
clearvars lines
load('lines.mat', 'lines')

% Decodage
recSignal = recomposeSignal( lines, decimated_env, decimating_factor, guitarAS_Fs );
recSignal = recSignal*25;

sound (recSignal, guitarAS_Fs);