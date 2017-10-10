function [newSpecLines] = fTranspose(spectralLines , targetFrequency)
%FTRANSPOSE Scales the spectral lines of a signal for the base frequency to match the target

newSpecLines = spectralLines;

fRation = targetFrequency / spectralLines(1,2);

for line = 1:size(newSpecLines,1)
    newSpecLines(line, 2) = newSpecLines(line, 2) * fRation;
end
end

