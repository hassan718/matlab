function [msg_rf] = RF_stage (msg, fs, m, BW)
A_stop1 = 60;		% Attenuation in the first stopband = 60 dB
A_stop2 = 60;		% Attenuation in the second stopband = 60 dB
A_pass = 2;		% Amount of ripple allowed in the passband = 1 dB

wn = 2*pi*100e3+ m*50e3*2*pi;
F_pass1 = wn/(2*pi) - BW;	% Edge of the passband = 10800 Hz
F_pass2 = wn/(2*pi) + BW;	% Closing edge of the passband = 15600 Hz
F_stop1 = wn/(2*pi) - 25e3;		% Edge of the stopband = 8400 Hz
F_stop2 = wn/(2*pi) + 25e3;	% Edge of the second stopband = 18000 Hz

d = fdesign.bandpass;
BandPassSpecObj = ...
   fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2', ...
		F_stop1, F_pass1, F_pass2, F_stop2, A_stop1, A_pass, ...
		A_stop2, fs);
designmethods(BandPassSpecObj);
BandPassFilt = design(BandPassSpecObj, 'ellip')
% fvtool(BandPassFilt); %plot the filter magnitude response
msg_rf = filter(BandPassFilt,msg);
end