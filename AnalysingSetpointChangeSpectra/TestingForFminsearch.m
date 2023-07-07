dataframe = readtable("C:\Users\uxy33753\OneDrive - Science and Technology Facilities Council\Documents\TemporalStabilistationOfInSightProject\Python\ChangingSetpointData\27-Jun-2023_16_05_35\Spectra\Spectra_SETP_4_mV.txt");
wavelengths = dataframe.Wavelengths;
spectralData = dataframe.Spectral_Data_1;

% Extract spectral phase
[wavelengths, spectralPhase] = ExtractSpectralPhase(wavelengths, spectralData, 90, 1032, 1047, 0.05);

% Perform fminsearch
%initial_params = [0.25, 1040, max(spectralPhase)-min(spectralPhase), min(spectralPhase)];
initial_params = [0.45 ,390*8E-4, -0.1,pi + 14*pi/8 + 1*pi/32];
x = linspace(1032, 1047, 1000);
initial_values = FitFunction(initial_params, x);

%plot(wavelengths, spectralPhase,wavelengths, FitFunction(initial_params,wavelengths))
options = optimset('MaxFunEvals',1e9,'TolX',1e-7);
optimised_params = fminsearch(@(a)sum((FitFunction(a,wavelengths)-spectralPhase).^2), initial_params, options);
%plot(wavelengths,spectralPhase,wavelengths,FitFunction(optimised_params,lbd))
disp(optimised_params)
fminsearch_values = FitFunction(optimised_params, x);
plot(x, initial_values)
hold on
plot(wavelengths, spectralPhase, 'DisplayName', filename);
plot(x, fminsearch_values)
hold off

function f=FitFunction(a,x)
    %f=a(4)+(a(1).*(sin(a(2).*(x-a(3)).^2)).^2);
    f=a(1) .* (1 + cos(a(2).* (x-1040).^2 + a(3).*(x-1040) + a(4)));
end