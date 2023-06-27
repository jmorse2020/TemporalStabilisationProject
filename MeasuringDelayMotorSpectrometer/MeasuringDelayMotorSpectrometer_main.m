% This script yields the relationship between delay in spectrometer (nm)
% and physicsal delay, Motor movement (mm)
addpath('functions');

% Parameters:
motorStartPosition = 21; %           mm
motorEndPosition = 21.6; %            mm
motorStepSize = 1e-2; %             mm
integrationTime = 100000; %          us
minSpectraAmplitude = 0.05;
envelopeSmoothness = 90;
fringeHeightTol = 0.05;
numberOfDataPoints = (motorEndPosition - motorStartPosition) / motorStepSize;
disp("There will be " + numberOfDataPoints + " data points in this scan.");
averageFringeLocationOver = 5; %    iterations

% Connect to motor and spectrometer
[mot_stat, motorObj] = ConnectToMotor(1);
[spec_stat, spectrometerObj] = ConnectToSpectrometer();
if ~(mot_stat + spec_stat == "11")
    return;
end
disp("Motor and spectrometer connected successfully.");
initialMotorPosition = motorObj.position;

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
fprintf(fp, line + "\n");
% Move to start position
motorObj.moveto(motorStartPosition);
pause(0.5)
% Get measurements
spectraCount = 1;
for pos = motorStartPosition:motorStepSize:motorEndPosition
    disp(pos);
    fringeLocations = zeros(1, averageFringeLocationOver);
    for iteration = 1:averageFringeLocationOver
        wavelengths = [];
        spectralData = [];
        loc = -1;
        while (loc == -1)
            % Get spectrum
            [wavelengths, spectralData] = acquirespectrum(spectrometerObj, integrationTime,0,1, 0);
            % Get fringe location
            loc = GetFringeLocation(wavelengths, spectralData, loc, minSpectraAmplitude, envelopeSmoothness, fringeHeightTol);
            if ~(1020 <= loc && loc <= 1060)
                loc = -1;
            end
        end
        % Save the spectrum
        try
            spectraSavePath = fullfile(spectraDirectory, "Spectra_" + spectraCount);
            T = table(wavelengths, spectralData, 'VariableNames', ["Wavelengths","Spectral_Data"]); 
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
    fprintf(fp, line + "\n");
    motorObj.moveto(motorObj.position + motorStepSize)
    pause(0.5);
end
disp("Scan successfully completed.");
motorObj.moveto(21.1697);
disp("Motor moved back to initial position")
mot_stat = DisconnectMotor(motorObj);
spec_stat = DisconnectSpectrometer(spectrometerObj);
if mot_stat + spec_stat == "11"
    disp("Devices successfully disconnected");
end
