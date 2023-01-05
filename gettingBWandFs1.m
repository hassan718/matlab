function [] = gettingBWandFs(y,fs)
y_mono = sum(y,2);
N  = length(y_mono);
Y=fft(y_mono,N);
k=-N/2:N/2-1;
 plot(k*fs/N,fftshift(abs(Y)));
grid on;

end