close all
clear all
clc

% Load Tolkien signal to decode
[Tolkien_data, Tolkien_Fs] = audioread('res/a11_Tolkien_tatoue.wav');

% Number of characters in the message
nb_char_mess = 160;

% Maximum n-point location possible for N1
N1_maximum_point_loc = 4000;

% Number of points
n_Tolkien_data = length(Tolkien_data);

% Maximal value of a byte
LBIT    =   256;

% Number of bits in a byte
byte = 8;

w       =   hanning(LBIT)';     %  Hanning window of 256 points.
gain_bit    =   0.003;          %  signal's amplitude (code) for 1 bit.

% Defines how the bit 0 and bit 1 signals look/are. 
% Must find those signals by correlation.
bit_0   =   gain_bit * ((-1).^(0:LBIT-1) ) .* w;  
bit_1   =   - bit_0;

% Reference signal to find first in the whole signal (Tolkien)
%to show where the message start.
s_ref = bit_0;

% Find the start of the message (N1). Must correlate with "s_ref".
C = xcorr(Tolkien_data, s_ref); 

L = length(Tolkien_data); 
k = - (L-1) : (L-1); 
figure(1) 
plot(k,C) 
title('Fonction de correlation croisee entre Tolkien_d_a_t_a et s_r_e_f') 
xlabel('Decalage k') 

% Finds all the peaks , because the first local maxima is the location of
% "s_ref"
C_length = length(C);
if mod(C_length,2) == 1
    begin_C = (C_length-1)/2+2;
else
    begin_C = C_length/2+1;
end
end_C = C_length;

C = C(begin_C:end_C);
C = C(1:N1_maximum_point_loc);

[pks,pks_index] = findpeaks(C);
pks_infos = [pks pks_index];
pks_infos = sortrows(pks_infos, -1);


% N1 is the n_point to skip to find "s_ref" (the indicator of a starting message)
N1 = pks_infos(1,2);

% Defines the number of points to skip to go to the next bit in the whole
% signal (Tolkien). N1 is the n-point of the whole signal where the message
% start (in other words it's "s_ref" define just above)
N2 = N1 + 750;

% Correlation in each sample of 256 bits next to ech other. Find if it's a
% 0 or a 1
message_bytes = zeros(nb_char_mess, byte);
begin_it = N1+LBIT+N2; 
end_it = begin_it+LBIT-1;
n_bit = 1; 
for index_char = 1:nb_char_mess
    for n_bit = 1:byte    
        Tolkien_sample = Tolkien_data(begin_it:end_it);

        Corr_bit0 = sum(Tolkien_sample .* bit_0');
        Corr_bit1 = sum(Tolkien_sample .* bit_1');

        if Corr_bit0 > 0
           message_bytes(index_char, n_bit) = 0;
        elseif Corr_bit1 > 0
           message_bytes(index_char, n_bit) = 1;     
        end
        begin_it = end_it+1;
        end_it = begin_it+LBIT-1;
    end
end

% Transform array of 160 bytes into message with real string/characters
message = '0';
for index = 1:nb_char_mess
    message(index) = char(bin2dec(num2str(message_bytes(index,:))));
end

% Answer
message