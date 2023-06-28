addpath("C:\Users\uxy33753\source\repos\TemporalStabilisationInsightGit\MeasuringDelayMotorSpectrometer\functions")
% 
% DataFilePath = "C:\Users\uxy33753\OneDrive - Science and Technology Facilities Council\Documents\TemporalStabilistationOfInSightProject\Python\ChangingSetpointData\27-Jun-2023_16_05_35\Spectra\Spectra_SETP_-30_mV.txt"
% dataframe = readtable(DataFilePath);
% Wavelengths_neg_30 = dataframe.Wavelengths;
% SpectralData_neg_30 = dataframe.Spectral_Data_1;
% DataFilePath_2 = "C:\Users\uxy33753\OneDrive - Science and Technology Facilities Council\Documents\TemporalStabilistationOfInSightProject\Python\ChangingSetpointData\27-Jun-2023_16_05_35\Spectra\Spectra_SETP_30_mV.txt"
% dataframe_2 = readtable(DataFilePath_2);
% Wavelengths_pos_30 = dataframe_2.Wavelengths;
% SpectralData_pos_30 = dataframe_2.Spectral_Data_1;
% DataFilePath_3 = "C:\Users\uxy33753\OneDrive - Science and Technology Facilities Council\Documents\TemporalStabilistationOfInSightProject\Python\ChangingSetpointData\27-Jun-2023_16_05_35\Spectra\Spectra_SETP_0_mV.txt"
% dataframe_3 = readtable(DataFilePath_3);
% Wavelengths_pos_0 = dataframe_3.Wavelengths;
% SpectralData_pos_0 = dataframe_3.Spectral_Data_1;

% hold on
% plot(Wavelengths_neg_30, SpectralData_neg_30, color = 'b', linewidth = 0.2)
% plot(Wavelengths_pos_30, SpectralData_pos_30, color = 'r', linewidth = 0.2)
% plot(Wavelengths_pos_0, SpectralData_pos_0, color = 'g', linewidth = 0.2)
% hold off

addpath("C:\Users\uxy33753\source\repos\TemporalStabilisationInsightGit\MeasuringDelayMotorSpectrometer\functions")
% [Wavelengths_neg_30, spectralPhase_neg_30] = ExtractSpectralPhase(Wavelengths_neg_30, SpectralData_neg_30, 90, 1025, 1055, 0.05);
% [Wavelengths_pos_0, spectralPhase_pos_0] = ExtractSpectralPhase(Wavelengths_pos_0, SpectralData_pos_0, 90, 1025, 1055, 0.05);
% [Wavelengths_pos_30, spectralPhase_pos_30] = ExtractSpectralPhase(Wavelengths_pos_30, SpectralData_pos_30, 90, 1025, 1055, 0.05);
% 
% hold on
%     plot(Wavelengths_neg_30, spectralPhase_neg_30)
%     plot(Wavelengths_pos_0, spectralPhase_pos_0)
%     plot(Wavelengths_pos_30, spectralPhase_pos_30)
% hold off


% Create data directory
[dataSaveDirectory, dataFileName] = CreateDataDirectory();
t = mkdir(fullfile(dataSaveDirectory, "\SpectralPhaseData\")); 
if t ~= 1
    disp("Could not make directory '\SpectralPhaseData\'");
    return;
end
spectralPhaseSavePath = fullfile(dataSaveDirectory, "\SpectralPhaseData\");

% Directory path
searchDirectory = 'C:\Users\uxy33753\OneDrive - Science and Technology Facilities Council\Documents\TemporalStabilistationOfInSightProject\Python\ChangingSetpointData\27-Jun-2023_16_05_35\Spectra';

% Get a list of all CSV files in the searchDirectory
fileList = dir(fullfile(searchDirectory, '*.txt'));

% Loop through each file
SETP_arr = zeros(1, length(fileList));
coeff_1_arr = zeros(1, length(fileList));
coeff_2_arr = zeros(1, length(fileList));
coeff_3_arr = zeros(1, length(fileList));
coeff_4_arr = zeros(1, length(fileList));

for i = 1:numel(fileList)
    % Get the file name
    filename = fileList(i).name;
    
    % Read data from the first two columns of the CSV file
    dataframe = readtable(fullfile(searchDirectory, filename));
    wavelengths = dataframe.Wavelengths;
    spectralData = dataframe.Spectral_Data_1;

    % Extract spectral phase
    [wavelengths, spectralPhase] = ExtractSpectralPhase(wavelengths, spectralData, 90, 1025, 1055, 0.05);

    % Perform fminsearch
    initial_params = [max(spectralPhase)-min(spectralPhase), 0.7, 1040, min(spectralPhase)];
    %plot(wavelengths, spectralPhase,wavelengths, FitFunction(initial_params,wavelengths))
    options = optimset('MaxFunEvals',1e9,'TolX',1e-7);
    optimised_params = fminsearch(@(a)sum((FitFunction(a,wavelengths)-spectralPhase).^2), initial_params, options);
    %plot(wavelengths,spectralPhase,wavelengths,FitFunction(optimised_params,lbd))

    % Identify the setpoint voltage
    % Regular expression pattern to extract the value of 'val'
    pattern = 'Spectra_SETP_(-?\d+)_mV\.txt';
    % Extracting the value of 'val' using regular expression
    tokens = regexp(filename, pattern, 'tokens');
    if ~isempty(tokens)
        SETP = str2double(tokens{1});
        disp(['Value of ''SETP'': ' num2str(SETP)]);
    else
        disp('Value of ''SETP'' not found.');
    end
    
    % Save wavelength, spectralPhase, evaluated fminsearch
    fminsearch_values = FitFunction(optimised_params, wavelengths);
    T = table(transpose(wavelengths), transpose(spectralPhase), transpose(fminsearch_values), 'VariableNames', ["wavelengths", "spectralPhase", "fminsearch_values"]);
    spectraFileName = fullfile(spectralPhaseSavePath, "SpectralPhase_" + num2str(i));
    writetable(T, spectraFileName);
    
    % Append setpoint to setpoint array, coeff_i to coeff_i array i = 1...n
    SETP_arr(i) = SETP; % = [SETP_arr, SETP];
    coeff_1_arr(i) = optimised_params(1); % = [coeff_1_arr, optimised_params(1)];
    coeff_2_arr(i) = optimised_params(2); % = [coeff_2_arr, optimised_params(2)];
    coeff_3_arr(i) = optimised_params(3); % = [coeff_3_arr, optimised_params(3)];
    coeff_4_arr(i) = optimised_params(4); % = [coeff_4_arr, optimised_params(4)];
    
    % Plot the data with a label equal to the file name
    plot(wavelengths, spectralPhase, 'DisplayName', filename);
    hold on
    plot(wavelengths, fminsearch_values)
    hold off
end

% Save setpoint and coefficients to file using writetable
T2 = table(transpose(SETP_arr), transpose(coeff_1_arr), transpose(coeff_2_arr), transpose(coeff_3_arr), transpose(coeff_4_arr), 'VariableNames', ["SetpointVoltage", "coeff_1", "coeff_2", "coeff_3", "coeff_4"]);
writetable(T2, dataFileName)










% FUNCTIONS
function f=FitFunction(a,x)
    % f=a(4)+(a(1).*(sin(a(2).*(x-a(3)).^2)).^2);
    f=a(4) .* (1 + cos(a(1) .*( x.^2 + a(2).*x + a(1))));
end

% TODO: Come back to this function and optimise the input parameters....






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% fun = @(params) myFunction(params);
% 
% initialParams = [1, 1, -2080, 1];
% optimal_params = fminsearch(fun, initialParams);
% disp("Optimal parameters:")
% disp(optimal_params)
% hold on 
% plot(wavelengths, spectralPhase)
% plot(wavelengths,Normalise( optimal_params(1) * (1 + cos(optimal_params(2) * wavelengths.^2 + optimal_params(3) * wavelengths + optimal_params(4)))))
% 
% function result = myFunction(params)
%     x = linspace(1027,1050,100);
%     a = params(1);
%     b = params(2);
%     c = params(3);
%     d = params(4);
%     result = sum(a * (1 + cos(b * x.^2 + c * x + d)));
% end
