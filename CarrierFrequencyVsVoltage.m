% This is a piece of code to practically measure the delay given a change
% in path length. The result leads to a plot of the position of the
% carrier frequency agains voltage setpoint of fibre stetcher, which gives
% a measure of stretch and thus delay.

% ~Parameters~ %
minLambda = 1000;           % nm
maxLambda = 1100;           % nm
minVoltageSetpoint = -5;    % PID setpoint voltage (Lower)
maxVoltageSetpoint = 5;     % PID setpoint voltage (Upper)
numberOfDataPoints = 100;   % Determines voltage step-size
averageFrequencyOver = 2;   % Number of times to average the measurement of the carrier frequency over
integrationTime = 1000;     % micro seconds
minSpectraAmplitude = 0.05;
envelopeSmoothing = 90;
fringeHeightTol = 0.15;

connectedStatus = "";


% ~Create .txt file to store data~ %
dataDirectory = fullfile(pwd, "\Data\");
if (~exist(dataDirectory, 'dir'))
    t = mkdir(dataDirectory); 
    if t ~= 1
        disp("Could not make directory '\Data'");
    end
end
currentDate = datestr(datetime('today'));
if ~exist(fullfile(dataDirectory, currentDate), "dir")
    mkdir(fullfile(dataDirectory, currentDate))
end
currentTime = datestr(datetime('now'), 'HH:MM:SS');
fileList = dir(fullfile(fullfile(dataDirectory, currentDate), '*.txt'));  
count = 1;
arr = [];
for i = 1:numel(fileList)
    if (contains(fileList(i).name, 'Scan'))
        count = count + 1;
        if fileList(i).name(6:9) == ".txt" % Allows up to 99 files in one folder
            arr(i) = fileList(i).name(5) - '0';
        else
            nm = fileList(i).name(5:6) - '0';
            int = 10 * nm(1) + nm(2);
            arr(i) = int;
        end
    end
end
filePath = fullfile("Data\" + currentDate + "\" + "Scan" + num2str(max(arr) + 1) + ".txt");
if ~(max(arr) + 1 == count)
    disp("You may not have consecutive numbering in this folder. A file with the max scan number + 1 has been created")
end
fp = fopen(filePath, 'w+');
Header = "This file contains details of scan " + num2str(max(arr) + 1) + ".\n\n";
Line(1) = "Parameters:\n";
Line(2) = "\tDate: " + currentDate + "\n";
Line(3) = "\tTime: " + currentTime + "\n";
Line(4) = "\tminLambda: " + num2str(minLambda) + " nm\n";
Line(5) = "\tmaxLambda: " + num2str(maxLambda) + " nm\n";
Line(6) = "\tminVoltageSetpoint: " + num2str(minVoltageSetpoint) + " V\n";
Line(7) = "\tmaxVoltageSetpoint: " + num2str(maxVoltageSetpoint) + " V\n";
Line(8) = "\tnumberOfDataPoints: " + num2str(numberOfDataPoints) + "\n";
Line(9) = "\taverageFrequencyOver: " + num2str(averageFrequencyOver) + "\n";
Line(10) = "\tintegrationTime: " + num2str(integrationTime) + " us\n";
Line(11) = "\tminSpectraAmplitude: " + num2str(minSpectraAmplitude) + "\n";
Line(12) = "\tenvelopeSmoothing: " + num2str(envelopeSmoothing) + "\n";
Line(13) = "\tfringeHeightTol: " + num2str(fringeHeightTol) + "\n";

fprintf(fp, Header);
for i = 1:length(Line)
    fprintf(fp, Line(i));
end
fclose(fp);
clear Line
% ~Establish connections to the serial port and spectrometer~%
Port = "COM6";
SubPort = "CONN 4";
Escape = "'XYZ'";
UserChar = "";
SubPort_WEsc = SubPort + ", " + Escape;

% Mainframe serial port SIM900%
try
    SerialPort = serialport(Port,9600); % Ensure correct comm port and baud rate
    fopen(SerialPort);
    SerialPort.configureTerminator('CR');
    set(SerialPort, 'Timeout', 1)

    % Check connection:
    writeline(SerialPort, "*IDN?")
    R = readline(SerialPort);
    if (contains(R, "Stanford_Research_Systems,SIM900"))
        connectedStatus = "1";
        disp("Connection established: Serial Port")
    else
        disp("Connection failed");
        disp("Exiting...")
        return
    end
catch
    disp("Failed. Check port is not already in use")
    disp("Exiting...");
    return;
end

% Connect to SIM960 device
try
    writeline(SerialPort, SubPort_WEsc)
    writeline(SerialPort, "*idn?")
    R = readline(SerialPort);
    if contains(R, "SIM960")
        connectedStatus = connectedStatus + "2";
        disp("Connection established to SIM960 at SubPort: " + SubPort)
    else
        disp("Failed. Could not connect to SubPort with command: " + SubPort_WEsc)
        disp("Exiting...");
        return;
    end
catch
    disp("Failed to connect to subport");
    disp("Exiting...");
    return;
end

% Connect to spectrometer
try
    spectrometer = icdevice('OceanOptics_OmniDriver.mdd');
    connect(spectrometer)
    connectedStatus = connectedStatus + "3";
    disp("Connection established to spectrometer")
catch
    disp("Failed to connect to spectrometer.")
    disp("Exiting...");
    return;
end



% Confirm connection
if connectedStatus == "123"
    
    % change set point
    %measure fring location as many times as needed
    %find average fringe location
    %add points to file and array
    %repeat
    %plot and disconnect
    for i = 1:2
    end
    loc = [];
    while loc == []
        [wavelengths, spectralData] = acquirespectrum(spectrometer, integrationTime, 0, 1, 0);
        pause(1);
        [loc, fringeHeight] = SlowFringeAnalysis(wavelengths, spectralData, minSpectraAmplitude, envelopeSmoothing, fringeHeightTol);  
    end
    
end
%SETP(?) {f}
