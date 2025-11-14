%Gen code By AI.....................
clc;
clear;

f  = 100000;
fs = 10e6;
B  = 2*pi*f/fs;

alpha = 2*cos(B);
beta  = -1;

N  = 250;
y  = zeros(N,1);

y(1) = 0;
y(2) = sin(B);

for i = 3:N
    y(i) = alpha*y(i-1) + beta*y(i-2);
end

n = (0:N-1).';

figure(1);
stem(n, y, 'LineWidth', 0.5, 'MarkerSize', 3);
xlabel('n');
ylabel('y[n]');
title('Sine Wave Generator (Discrete-Time)');
grid on;

t = n / fs;

figure(2);
plot(t*1e6, y, 'LineWidth', 1.2);
xlabel('Time (\mus)');
ylabel('x_c(t)');
title('Sine Wave in Continuous-Time View');
grid on;

x_ct = y;
w    = hann(N);
Nfft = 8192;

X    = fft(x_ct .* w, Nfft);
Xmag = abs(X(1:Nfft/2));
f_axis = (0:Nfft/2-1)*(fs/Nfft);

f0 = f;
k1 = round(f0*Nfft/fs) + 1;
V1 = Xmag(k1);

maxHarmOrder = 10;
maxOrderByNyq = floor((fs/2)/f0);
H = min(maxHarmOrder, maxOrderByNyq);

harm_mag = zeros(H,1);
harm_mag(1) = V1;

for h = 2:H
    idx = round(h*f0*Nfft/fs) + 1;
    harm_mag(h) = Xmag(idx);
end

num = sqrt(sum(harm_mag(2:end).^2));
den = harm_mag(1);
THD = num / den;
THD_percent = THD * 100;

figure(3);
plot(f_axis, Xmag, 'r', 'LineWidth', 1.2);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title(sprintf('Continuous-Time Spectrum (THD = %.4f %%)', THD_percent));
grid on;
xlim([0, 10*f0]);
