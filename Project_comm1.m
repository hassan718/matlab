close all;
clf;
clc;
clear;
%%  @ TX:
% Reading BW of signals
[msg1,fs1] = audioread('Short_BBCArabic2.wav');
[msg2,fs2] = audioread('Short_QuranPalestine.wav');

%reading BW of signals at Base Band

gettingBWandFs(msg1,fs1)  %draw it in F.D and read the highest frequency
ylabel ('Msg1 at transmiter')
figure()   %to split the figures, and plot 2 signals
gettingBWandFs(msg2,fs2)
ylabel('Msg2 at transmiter')
% ********interp to increase the samples of signals************ %
msg1_mono = sum(msg1,2);
msg2_mono = sum(msg2,2);
%pad the short msg array
msg2_sameL_msg1 = padarray(msg2_mono,numel(msg1_mono)-numel(msg2_mono),0,'post');

%interpolation to increase the Number of samples
msg1_interp = interp(msg1_mono,10);% increase the samples by multiply by 10
msg2_interp = interp(msg2_sameL_msg1,10);
fs = 10 * fs1;

%   --------AM Modulator Block---------- %
% generating carrier:
carrier1= generate_carriers(fs,msg1_interp,0);
carrier2= generate_carriers(fs,msg2_interp,1);

% modulated signals:
modulatedsig1 = carrier1' .* msg1_interp;
modulatedsig2 = carrier2' .* msg2_interp;

tx = modulatedsig1+ modulatedsig2;
drawfft(tx,fs);
ylabel(' Transmitted signal ');
%% RX :
%   ---------RF-stage Block ------------- %
% passing signals throw a BPF center at frequency of carrier wn
RFstage = 1 ;   % change it to 0 if need to see RF stage 
BW = 22.05e3;
if RFstage == 1
    %for first msg: BW is in kHz
    m=0; 
    msg1_rf =2* RF_stage (tx, fs, m, BW);
    % draw the signals after RF filter (before mixer)
    drawfft(msg1_rf, fs)
    ylabel(' Output1 of RF stage');
    % ___________________________________________________________ %
    %for 2nd msg:
    m2=1;
    msg2_rf = 2 * RF_stage (tx, fs, m2, BW);
    % draw the signals after RF filter (before mixer)
    drawfft(msg2_rf, fs)
    ylabel(' Output2 of RF stage');
else
    msg1_rf = tx;   % in case of no RF stage
    
end
%   ---------Oscillators Block (Wc + Wif)------------- %
if_Freq = 25e3;
%IFcarrier for msg 1 : m = 0
IFcarrier_1 = oscillators(msg1_rf, 0,if_Freq, fs);

% % IFcarrier for msg 2 : m = 1
IFcarrier_2 = oscillators(msg2_rf, 1,if_Freq, fs);

%   ---------Mixer Block ------------- %
% NOTE: u should inverting the IFcarrier to make the multiply valid
% msg1:
msg1_if = msg1_rf .* IFcarrier_1';
%The output of the mixer
drawfft(msg1_if,fs)
ylabel('Output1 of mixer')
% ___________________________________________________________ %

% msg2:
%The output of the mixer
msg2_if = msg2_rf .* IFcarrier_2';
drawfft(msg2_if,fs)
ylabel('Output2 of mixer')
% ___________________________________________________________ %

% ---------If Stage Block (Wif) ------------ %
%  this stage is simply modeled as a band-pass filter only, centered at the center frequency 𝜔𝐼𝐹.
% msg1:
msg1_if_Bpf = 2*IF_stage (msg1_if, if_Freq, BW,fs);
%The output of the IF filter
drawfft(msg1_if_Bpf,fs)
ylabel('Output1 of IF stage');
% ___________________________________________________________ %

% msg2:
msg2_if_Bpf = 2*IF_stage (msg2_if, if_Freq, BW,fs);
% The output of the IF filter
drawfft(msg2_if_Bpf,fs)
ylabel('Output2 of IF stage');
% ___________________________________________________________ %

% -----------BaseBand Block (mixer + LPF)------------------- %

% msg1:
% ___________________________________________________________ %
[msg_baseband_1,msg1_mixer] = BaseBandfilter( fs, msg1_if_Bpf);

% Output of mixer before LPF
drawfft(msg1_mixer,fs)
ylabel('msg1 before LPF');

% output of LPF
Output_msg1 = downsample(msg_baseband_1,10);
drawfft(Output_msg1,fs1)
ylabel('Demodulated signal 1 ');
% ylabel(' tx at base band  ');
sound (Output_msg1, 44100)
% ___________________________________________________________ %

%msg2:
% ___________________________________________________________ %
[msg_baseband_2,y] = BaseBandfilter( fs, msg2_if_Bpf);

% Output of mixer before LPF
drawfft(y,fs) % signal at origin before pass through LPF
ylabel('msg2 before LPF');

Output_msg2 = downsample(msg_baseband_2,10);
drawfft(Output_msg2,fs1)
ylabel('Demodulated signal 2 ');
sound (Output_msg2, 44100)
% ___________________________________________________________ %