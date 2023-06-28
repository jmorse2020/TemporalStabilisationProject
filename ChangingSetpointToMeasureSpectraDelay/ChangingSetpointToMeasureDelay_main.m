% Script to obtain spectra when moving setpoint

% Parameters:
minSetpoint = -0.03; %               V
maxSetpoint = 0.03; %                V
stepSize = 0.001; %                  V
integrationTime = 100000; %          us
averageOver = 5; %    iterations
numberOfDataPoints = (maxSetpoint - minSetpoint) / stepSize;
disp("There will be " + numberOfDataPoints + " data points in this scan.");

% Connect to serialport and spectrometer
SerialPort = "";
[connectedStatus, SerialPort, spectrometer] = ConnectToSerialPortsAndSpectrometer(SerialPort);
if ~(connectedStatus == "123")
    disp("Unable to connect to SerailPort and spectrometer");
    return;
end
disp("SerialPort and spectrometer connected successfully.");
writeline(SerialPort, "SETP?")
initialSetpoint = readline(SerialPort);

% Create SaveDirectory and file in directory

[fp, dataSaveLocation] = CreateTXTFile("");


spectraDirectory = fullfile(dataSaveLocation + "\Spectra\");
if (~exist(spectraDirectory, 'dir'))
    t = mkdir(spectraDirectory); 
    if t ~= 1
        disp("Could not make directory '\Spectra\'");
        return;
    end
end
Lines(1) = "minSetPoint = " + num2str(minSetpoint) + " V\n";
Lines(2) = "maxSetpoint = " + num2str(maxSetpoint) + " V\n";
Lines(3) = "StepSize = " + num2str(stepSize) + " V\n";
Lines(4) = "Integration Time = " + num2str(integrationTime) + " us\n";
Lines(5) = "No samples = " + num2str(numberOfDataPoints) + "\n";
for i = 1:length(Lines)
    fprintf(fp, Lines(i));
end
fclose(fp);

% Move to start position
command = "SETP " + num2str(minSetpoint);
writeline(SerialPort, command);
pause(0.5)

% Obtain data
for pos = minSetpoint:stepSize:maxSetpoint
    disp(pos);
    spectra = zeros(1, averageOver);
    T = [];
    for iteration = 1:averageOver
        wavelengths = [];
        spectralData = [];
        [wavelengths, spectralData] = acquirespectrum(spectrometer, integrationTime,0,1, 0);
        pause(0.1)
        % Save the spectrum
        if iteration == 1
            T = table(wavelengths, spectralData, 'VariableNames', ["Wavelengths","Spectral_Data_1"]);
        else
            header = "Spectral_Data_" + iteration;
            T = [T, table(spectralData, 'VariableNames', {char(header)})];
        end
    end
    try
        writeline(SerialPort, "SETP?");
        currentSETP = readline(SerialPort);
        spectraSavePath = fullfile(spectraDirectory, "Spectra_SETP_" +  num2str(str2double(currentSETP)*1000) + "_mV");
        writetable(T, spectraSavePath);
    catch
        disp("Unable to save spectra");
    end
    writeline(SerialPort, "SETP?");
    currentSETP = readline(SerialPort);
    pause(0.01)
    command =  "SETP " + (str2double(currentSETP) + stepSize);
    writeline(SerialPort, command);
%     newSETP = readline(SerialPort);
%     try
%         if ~(newSETP == num2str(str2double(currentSETP) + stepSize))
%             disp("Error in moving setpoint. The new setpoint does not match the expected voltage");
%         end
%     catch
%     end
    pause(0.5);
end

% Disconnect
disp("Scan successfully completed.");
command =  "SETP " + initialSetpoint;
writeline(SerialPort, command);
disp("Setpoint moved back to initial position")
DisconnectSerialPortAndSpectrometer();