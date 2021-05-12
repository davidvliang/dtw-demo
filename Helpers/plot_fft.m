function plot_fft(time, signal)
% time is a vector of timestamps of each sample.
% samples should be roughly evenly spaced for best results
% signal is a vector of real numbers representing signal to be analysed
% does not (yet) support analysis of complex signals

% Compute fft
numSamples = size(time, 1);
T = mean(diff(time));
sampleRate = 1/T;
Y = fft(normalize(signal)); % compute FFT of normalized magnitude
f = sampleRate*(0:numSamples-1)/numSamples; % compute frequency axis
P = abs(Y).^2; % Magnitude squared

% Plot FFT results
figure();
plot(f, P);
xlim([0 sampleRate/2]);
xlabel('f (Hz)');
