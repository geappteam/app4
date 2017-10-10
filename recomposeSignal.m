function [ signal ] = recomposeSignal( spectralLines, enveloppe, decimFact, Fs )
%RECOMPOSESIGNAL This function rebuilds a signal from spectral lines and
%enveloppe.

N = (size(enveloppe,1)-1) * decimFact + 1;

recompEnv = interp1(0:decimFact:N-1, enveloppe, 0:1:N-1);

wave = preriodicSignComposition( spectralLines, N, Fs );

signal = recompEnv' .* wave';

end

