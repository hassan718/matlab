function[IFcarrier] = oscillators(msg, m, if_Freq, fs)
%this is the generator for a carrier frequency ππ + ππΌπΉ, 
%where ππ = ππ + πΞπΉ. 
%The IF frequency ππ°π­ = ππ KHz. The mixer is a simple multiplier in 
%this simulation.
Ts = 1/(fs);
delta_freq = 50e3;

WN = 2*pi*100e3+ m*delta_freq*2*pi;
WLO = WN + if_Freq*2*pi + 10000*2*pi;
length_msg = length(msg);
n=0:1:length_msg-1;
IFcarrier= cos(WLO * n * Ts);
end

