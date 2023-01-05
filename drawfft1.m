function[] = drawfft(y,fs)
N  = length(y);
Y=fft(y,N);
k=-N/2:N/2-1;
figure()
plot(k*fs/N,fftshift(abs(Y)));
grid on;
hold on;
end

