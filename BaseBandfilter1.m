function [msgBaseBand, y] = BaseBandfilter(fs, msg_if)
%% generate Baseband Carrier
Ts = 1/(fs);
N = length(msg_if);    % we get the length of msg to make the carrier with same length
n1 = 0:1:N-1;
if_Freq = 25e3*2*pi;
W = if_Freq;
BaseBandcarrier = cos(W * n1 * Ts);
%draw the carriers here not using the defined function: ' drawfft ' 
Carrier_freq=fft(BaseBandcarrier,N);
k = -N/2 : N/2-1;
% plot(k*fs/N,fftshift(abs(Carrier_freq)));
grid on;
% ylabel('Carrier1OfBaseBand for 1st msg')
%  return the if msg to Base Band
y =  BaseBandcarrier' .* msg_if;

%% the LPF
    Fpass = 22.05e3;
    Fstop = 23e3;
    Apass = 0.01;
    Astop = 80;


d = designfilt('lowpassfir', 'PassbandFrequency', Fpass, ...
    'StopbandFrequency', Fstop, 'PassbandRipple', 1, ...
    'StopbandAttenuation', 60, 'SampleRate', 441000, ...
    'DesignMethod', 'equiripple');
%      fvtool(lpFilt)
msgBaseBand = filter(d,y);
end


