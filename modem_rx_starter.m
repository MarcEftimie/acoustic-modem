
load long_modem_rx.mat

    % The received signal includes a bunch of samples from before the
    %transmission started so we need discard these samples that occurred before
    %the transmission started.

    start_idx = find_start_of_signal(y_r, x_sync);
    % start_idx now contains the location in y_r where x_sync begins
    % we need to offset by the length of x_sync to only include the signal
    % we are interested in y_t = y_r(start_idx + length(x_sync) : end);
    % y_t is the signal which starts at the beginning of the transmission
    y_t = y_r(start_idx + length(x_sync) : end);
    clf
    figure(7)
    hold on
    title("Initial Received Signal Time Domain")
xlabel('Time (s)')
ylabel('Magnitude')
grid on
    plot((0:length(y_t)-1)/Fs, y_t)
    hold off
figure(1)
y = fft(y_t);
n = length(y_t);
fshift = (-n / 2 : n / 2 - 1) * (Fs / n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
title('Initial Received Signal Frequency Domain')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
grid on
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
grid on
y1 =lowpass(y_c,1,Fs);
figure(3)
y=fft(y1);
n = length(y);
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
title('Filtered Signal Frequency Domain')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
grid on
figure(4)
clf
plot((0:length(y1)-1)/Fs, y1)
title("Filtered Signal Time Domain")
xlabel('Time (s)')
ylabel('Magnitude')
ylim([-0.1,0.1])
grid on


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
figure(8)
clf
hold on
title("Binary Output Signal")
ylabel('Binary Magnitude')
xlabel('Time (s)')
ylim([0,1])
plot((0:length(x_d)-1)/100, x_d)
hold off
x_d = x_d(1:end-1)

% convert to a string assuming that x_d is a vector of 1s and 0s
% representing the decoded bits
BitsToString(x_d)
