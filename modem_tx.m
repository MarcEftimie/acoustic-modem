clear
Fs = 8192;
f_c = 1000;
bits_to_send = StringToBits('Hello');
msg_length = length(bits_to_send)/8;
SymbolPeriod = 100;

% convert the vector of 1s and 0s to 1s and -1s
m = 2*bits_to_send-1;
% create a waveform that has a positive box to represent a 1
% and a negative box to represent a zero
m_us = upsample(m, SymbolPeriod);
m_boxy = conv(m_us, ones(SymbolPeriod, 1));
clf
plot(m_boxy); % visualize the boxy signal
clf
y=fft(m_boxy);
% f = (0:length(y)-1)*Fs/length(y);
% plot(f,abs(y))
% xlabel('Frequency (Hz)')
% ylabel('Magnitude')
% title('Magnitude')
n = length(m_boxy);
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
% create a cosine with analog frequency f_c
c = cos(2*pi*f_c/Fs*[0:length(m_boxy)-1]');
clf
y=fft(c);
n = length(m_boxy);
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
% create the transmitted signal
x_tx = m_boxy.*c;
%plot(x_tx)  % visualize the transmitted signal
clf
figure(1)
y=fft(x_tx);
n = length(m_boxy);
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
y_c=x_tx.*cos(2*pi*f_c/Fs*[0:length(x_tx)-1]');
figure(4)
y=fft(y_c);
n = length(y_c);
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
y_t=(2*pi*f_c/Fs/pi*sinc(2*pi*f_c/Fs*[0:length(y_c)-1]'));
figure(7)
y=fft(y_t);
n = length(y_t);
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
y_t=lowpass(y_c,1,Fs);

figure(8)
y=fft(y_t);
n = length(y_t);
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')

figure(9)
clf
hold on
plot(2.*y_t)
plot(m_boxy);

nVar = 0.1;
recsymb = awgn(2.*y_t,1/nVar,1,'linear');
out = nrSymbolDemodulate(recsymb,'BPSK',0.1)
% create  noise-like signal 
% to synchronize the transmission
% this same noise sequence will be used at
% the receiver to line up the received signal
% This approach is standard practice in real communications
% systems.
randn('seed', 1234);
x_sync = randn(Fs/4,1);
x_sync = x_sync/max(abs(x_sync))*0.5;
% stick it at the beginning of the transmission
x_tx = [x_sync;x_tx];
save sync_noise.mat x_sync Fs msg_length
% write the data to a file
audiowrite('acoustic_modem_short_tx.wav', x_tx, Fs);


