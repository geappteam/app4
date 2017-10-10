decimating_factor = 1000;
cutoff = pi/1000;
numberOfLines = 32;

% Load guitar A sharp
[guitarAS, guitarAS_Fs] = audioread('res/note_guitare_LAd.wav');

N = size(guitarAS,1);

% Encodage
env = enveloppe( guitarAS, cutoff);
decimated_env = decimate(env, decimating_factor);
cut_env = decimated_env(7:end);

lines = dftEncode(guitarAS, guitarAS_Fs, numberOfLines);
save lines.mat lines
clearvars lines
load('lines.mat', 'lines')

% Decodage
G_lines = fTranspose(lines, 392);
Eb_lines = fTranspose(lines, 311.1);
F_lines = fTranspose(lines, 349.2);
D_lines = fTranspose(lines, 293.7);

shortEnv = cut_env(1:20);
longEnv = cut_env(1:80);

g_s = recomposeSignal( G_lines, shortEnv, decimating_factor, guitarAS_Fs );
eb_s = recomposeSignal( Eb_lines, longEnv, decimating_factor, guitarAS_Fs );
f_s = recomposeSignal( F_lines, shortEnv, decimating_factor, guitarAS_Fs );
d_s = recomposeSignal( D_lines, longEnv, decimating_factor, guitarAS_Fs );

recSignal = [g_s; g_s; g_s; eb_s; zeros(60000,1); ...
             f_s; f_s; f_s; d_s];

recSignal = recSignal*25;
sound (recSignal, guitarAS_Fs);

