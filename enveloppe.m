% fNcutoff is the normalized cutoff
function [ env ] = enveloppe( samples, fNcutoff)
    samples = abs(samples);
    
    fc = fNcutoff;                              % Cut-off standardized frequency 
    N = 290;                                        % Estimated at 290 -> To be determined
    n = -((N-1)/2):((N-1)/2);       
    n = n+(n==0)*eps;                               % Only to prevent devision by 0

    [h] = sin(n*2*pi*fc)./(n*pi);                   % Generation of the sequence of ideal coefficients
    [w] = 0.54 + 0.46*cos(2*pi*n/N);                % Generation of the Hamming Window
    d = h .* w;                                     % Modified Filter

    env = filter(d,1, samples);    
end

