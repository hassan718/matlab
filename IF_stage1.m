function [msg_if] = IF_stage (msg, if_Freq, BW,fs)
A_stop1 = 60;		% Attenuation in the first stopband = 60 dB
A_stop2 = 60;		% Attenuation in the second stopband = 60 dB
A_pass = 0.5;		% Amount of ripple allowed in the passband = 1 dB % as we center the BPF at W_if we need gain = 2 

F_pass1 = if_Freq - BW;	% Edge of the passband = 10800 Hz
F_pass2 = if_Freq + BW;	% Closing edge of the passband = 15600 Hz
F_stop1 = if_Freq - 24e3;		% Edge of the stopband = 8400 Hz
F_stop2 = if_Freq + 24e3;	% Edge of the second stopband = 18000 Hz

d = fdesign.bandpass;
BandPassSpecObj = ...
   fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2', ...
		F_stop1, F_pass1, F_pass2, F_stop2, A_stop1, A_pass, ...
		A_stop2, fs);
designmethods(BandPassSpecObj);
BandPassFilt = design(BandPassSpecObj, 'ellip');
%fvtool(BandPassFilt); %plot the filter magnitude response
msg_if = filter(BandPassFilt,msg);
end