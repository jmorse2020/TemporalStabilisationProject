% This script yields the relationship between delay in spectrometer (nm)
% and physicsal delay, Motor movement (mm)
addpath('functions');

% Parameters:
motorStartPosition = 8; %           mm
motorEndPosition = 12; %            mm
motorStepSize = 1e-3; %             mm
numberOfDataPoints = (motorEndPosition - motorStartPosition) / motorStepSize;
disp("There will be " + numberOfDataPoints + " data points in this scan.");
averageFringeLocationOver = 5; %    iterations

% Connect to motor and spectrometer
[mot_stat, motorObj] = ConnectToMotor(1);
mot_stat = DisconnectMotor(motorObj);
[spec_stat, spectrometerObj] = ConnectToSpectrometer();
if ~(mot_stat + spec_stat == "11")
    return;
end
disp("Motor and spectrometer connected successfully.");


% Create save locations:
[fp, dataSaveLocation] = CreateTXTFile();
spectraDirectory = fullfile(dataSaveLocation + "\Spectra\");
if (~exist(spectraDirectory, 'dir'))
    t = mkdir(spectraDirectory); 
    if t ~= 1
        disp("Could not make directory '\Spectra\'");
        return;
    end
end
line = "AverageFringeLocation,MotorPosition,";
for i = 1:averageFringeLocationOver
    line = line + "Fringe_" + i + ",";
end
% Move to start position
motorObj.moveto(motorStartPosition);

% Get measurements
spectraCount = 1;
for pos = motorStartPosition:motorStepSize:motorEndPosition
    fringeLocations = zeros(1, averageFringeLocationOver);
    for iteration = 1:averageFringeLocationOver
        wavelengths = [];
        spectralData = [];
        loc = -1;
        while (loc == -1)
            % Get spectrum
            [wavelenghts, spectralData] = acquirespectrum();
            % Get fringe location
            loc = GetFringeLocation(loc);
        end
        % Save the spectrum
        try
            spectraSavePath = fullfile(spectraDirectory, "Spectra_" + spectraCount);
            T = table(wavelenghts, spectralData, 'VariableNames', ["Wavelengths","Spectral_Data"]); 
            writetable(T, spectraSavePath);
            spectraCount = spectraCount + 1;
        catch
            disp("Unable to save spectra");
        end
        fringeLocations(iteration) = loc;
    end
    averageFringeLocation = mean(fringeLocations);
    currentMotorPosition = motorObj.position;
    
    % Save data to file
    line = averageFringeLocation + "," + currentMotorPosition + ",";
    for i = 1:length(fringeLocations)
        line = line + fringeLocations(i) + ",";
    end
    fprintf(fp, line);
    motorObj.moveto(motorObj.position + motorStepSize)
end
disp("Scan successfully completed.");

mot_stat = DisconnectMotor(motorObj);
spec_stat = DisconnectSpectrometer(specObj);
if mot_stat + spec_stat == "11"
    disp("Devices successfully disconnected");
end
