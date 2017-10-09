function [ signal ] = preriodicSignComposition( spectralLines, len, Fs )
    
    amplitudes = 1;
    frequencies = 2;
    phases = 3;

    ts = 0:len-1;
    
    signal = zeros(1,len);
    % Assuming 32 spectralLines
    for curSLine = 1:32
        phase = spectralLines(curSLine, phases);
        frequency = spectralLines(curSLine, frequencies);
        amplitude = db2mag(spectralLines(curSLine, amplitudes));
        
        signal = signal + ...
            amplitude * sin ( ((frequency * 2*pi)+(phase)) * ts/ Fs);
                
    end
end

