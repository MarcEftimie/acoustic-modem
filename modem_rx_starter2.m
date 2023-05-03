
load long_modem_rx.mat

% The received signal includes a bunch of samples from before the
% transmission started so we need discard these samples that occurred before
% the transmission started. 

start_idx = find_start_of_signal(y_r,x_sync);
% start_idx now contains the location in y_r where x_sync begins
% we need to offset by the length of x_sync to only include the signal
% we are interested in
y_t = y_r(start_idx+length(x_sync):end); % y_t is the signal which starts at the beginning of the transmission

figure(2)
y=fft(y_t);
n = length(y_t);
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
y_c=y_t.*cos(2*pi*f_c/Fs*[0:length(y_t)-1]');
figure(3)
y=fft(y_c);
n = length(y_c);
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
y1 =lowpass(y_c,0.0001,Fs);
figure(5)
y=fft(y1);
n = length(y);
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
figure(6)
clf
plot(y1)
title("y1")

samples = [50:100:98350];
x_d = zeros(1, length(samples));
x_d_count = 1;
for i = 1:length(samples)
    if (y1(samples(1, i)) > 0)
        x_d(i) = 1;
    else
        x_d(i) = 0;
    end
end

% convert to a string assuming that x_d is a vector of 1s and 0s
% representing the decoded bits
BitsToString(x_d)