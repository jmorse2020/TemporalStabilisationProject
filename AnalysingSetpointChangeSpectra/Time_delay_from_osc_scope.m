Unstabilised_4_sec = "\\dc.clf.rl.ac.uk\Users\Data2\JackMorse\Public\Spectral_Interference_Project\Osc_Scope_Delay_Data\T0002CH1.CSV";
Stabilised_4_sec = "\\dc.clf.rl.ac.uk\Users\Data2\JackMorse\Public\Spectral_Interference_Project\Osc_Scope_Delay_Data\T0003CH1.CSV";
Stabilised_10_min = "\\dc.clf.rl.ac.uk\Users\Data2\JackMorse\Public\Spectral_Interference_Project\Osc_Scope_Delay_Data\T0004CH1.CSV";
data = readtable(Stabilised_10_min, NumHeaderLines=15);
timeData = data.TIME;
voltages = data.CH1;
timeData = timeData(1:1.245e6);
voltages = 1000 * voltages(1:1.245e6); % mV

plot(timeData, voltages)
disp(std(voltages))
disp("Std deviation of signal (jitter) = " + 0.01973 * std(voltages)) % fs / mV *  mV

% Fourier transform plot
sample_time = 4; % seconds
Ts = 1/sample_time;
t = 
y = fft(voltages);
fs = 1/
n = length(timeData);
fshift = (-n/2:n/2-1) * ()