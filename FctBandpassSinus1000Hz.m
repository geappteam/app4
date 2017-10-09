function [ out ] = FctBandpassSinus1000Hz( y, Fs )

% ***
% Bandpass Filter : 2 pole 2 zeros 
% Dc Gain = 0dB
% Cut-off frequency between 980 - 1020 Hz 
%                        -> Must be over -3 dB
% ***

    % Bandpass Filter (IIR)
    r = 0.9969;
    N = length(y);
    fn_Low = 980;                                   % 980 Hz
    fn_High = 1020;                                 % 1020 Hz
    fn = ((fn_Low + fn_High)/2);                    % 1010 Hz

    % Put poles at same angle, inside unit circle
    b = [1 -2*cos(2*pi*fn/Fs) 1];                   % Filter Coefficients (Numerator)
    a = [1 -2*r*cos(2*pi*fn/Fs) r^2];               % Filter Coefficients (Denominator)
    b = b/sum(b)*sum(a);                            % Make Dc gain to 1

    out = filter(b, a, y);                          % Apply BandpassFilter
end

