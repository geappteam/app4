% fNcutoff is the normalized cutoff
function [ env ] = enveloppe( samples, fNcutoff)
    samples = abs(samples);
    
    fc = fNcutoff;                              % Cut-off standardized frequency 
    N = 885;
    n = -((N-1)/2):((N-1)/2);       
    n = n+(n==0)*eps;
    
    coeff = (1/N)*ones(1,N);
    [w] = 0.54 + 0.46*cos(2*pi*n/N);                % Generation of the Hamming Window
    d = coeff .* w;                                    % Modified Filter

    env = filter(d,1, samples) * 2;          % Correcting according to lim x-> infinity, (sum sin(n/x * pi/2) , n=1 to x)/x
end

