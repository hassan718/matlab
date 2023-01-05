function [carrier] = generate_carriers(fs, msg, m)
Ts = 1/(fs);
L = length(msg);
delta_freq = 50e3;
WLO = 2*pi*100e3 + (m)*delta_freq*2*pi;
% make carrier have same length
n = 0:1:L-1;
carrier= cos(WLO * n * Ts);
end