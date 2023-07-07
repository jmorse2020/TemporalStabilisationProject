data = readtable("C:\Users\uxy33753\source\repos\TemporalStabilisationInsightGit\AnalysingSetpointChangeSpectra\Data\30-Jun-2023_11_49_34\Scan1.txt");
SetpointVoltages = data.SetpointVoltage;
coeff_1s = data.coeff_1;
coeff_2s = data.coeff_2;
coeff_3s = data.coeff_3;
coeff_4s = data.coeff_4;
nm_delay = data.nm_delay;

removeIndex = find(SetpointVoltages == -13);
SetpointVoltages(removeIndex) = [];
coeff_1s(removeIndex) = [];
coeff_2s(removeIndex) = [];
coeff_3s(removeIndex) = [];
coeff_4s(removeIndex) = [];
nm_delay(removeIndex) = [];


% Convert coeff_4s (phase change) to delay
delay_s = (coeff_4s / (2 * pi) ) * 3.467e-15;
plot(SetpointVoltages, coeff_4s, 'x')
hold on
% plot(SetpointVoltages, coeff_2s, 'x')
% plot(SetpointVoltages, coeff_3s, 'x')
% plot(SetpointVoltages, coeff_4s, 'x')

% Fit for coeff_4s, phase change
coefficients = polyfit(SetpointVoltages, coeff_4s, 1);
x_fit = linspace(min(SetpointVoltages), max(SetpointVoltages));
y_fit = polyval(coefficients, x_fit);
plot(x_fit, y_fit)
hold off
disp("y = " + coefficients(1) + "x + " + coefficients(2));

% figure;
% plot(SetpointVoltages, nm_delay, 'x')
% figure
% plot(SetpointVoltages, delay_s,'x', "Color",'r')
xlabel("Setpoint, V")
ylabel("delay, s");
ind = find(SetpointVoltages == 0);
time_from_calibration = ((nm_delay -1040) / (5.308950353804167))*1e-12 ; % Converting the measured fringe location in nm to time from calibration
time_from_calibration = time_from_calibration - mean(time_from_calibration) + mean(delay_s); % Shift to be on top
plot(SetpointVoltages, time_from_calibration, 'x', "DisplayName","time from calibration")
hold on
plot(SetpointVoltages, delay_s,'x',"DisplayName","delay from phase");
title("Time calibration and phase extraction")
xlabel("mV")
ylabel("seconds")
legend()