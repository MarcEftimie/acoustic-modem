
load long_modem_rx.mat

    % The received signal includes a bunch of samples from before the
    %transmission started so we need discard these samples that occurred before
    %the transmission started.

    start_idx = find_start_of_signal(y_r, x_sync);
    % start_idx now contains the location in y_r where x_sync begins
    % we need to offset by the length of x_sync to only include the signal
    % we are interested in y_t = y_r(start_idx + length(x_sync) : end);
    % y_t is the signal which starts at the beginning of the transmission

figure(1)
y = fft(y_t);
n = length(y_t);
fshift = (-n / 2 : n / 2 - 1) * (Fs / n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
title('Orignal Signal')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
y_c=y_t.*cos(2*pi*f_c/Fs*[0:length(y_t)-1]');
figure(2)
y=fft(y_c);
n = length(y_c);
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
title('Cosine Multiplication in Time Domain')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
y1 =lowpass(y_c,0.0001,Fs);
figure(3)
y=fft(y1);
n = length(y);
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
title('Lowpass Filter Applied')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
figure(4)
clf
plot((0:length(y1)-1)/Fs, y1)
title("Filtered Signal Time Domain")
xlabel('Time (s)')
ylabel('Magnitude')


x_d = [];
sample = 50;
i = 1;
while true
    if (y1(sample) < 0.005) && (y1(sample) > -0.005)
        break;
    elseif (y1(sample) > 0)
        x_d(i) = 1;
    else
        x_d(i) = 0;
    end
    sample = sample + 100;
    i = i + 1;
end
x_d = x_d(1:end-1)

% convert to a string assuming that x_d is a vector of 1s and 0s
% representing the decoded bits
BitsToString(x_d)
