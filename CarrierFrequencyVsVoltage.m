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

% ~Create .txt file to store data~ %
if (~exist('\Data', 'dir'))
    mkdir('Data'); 
end
currentDate = datestr(datetime('today'));
if ~exist(fullfile("\Data", + currentDate), "dir")
    mkdir(fullfile("\Data", + currentDate))
end
currentTime = datestr(datetime('now'), 'HH:MM:SS');
fileList = dir(fullfile('\Data', '*.txt'));  
count = 0;
for i = 1:numel(fileList)
    if (contains(fileList(i), 'Scan'))
        count = count + 1;
    end
end
filePath = fullfile("Data\" + currentDate + "\" + "Scan" + num2str(count + 1) + ".txt");
fp = fopen(filePath,'w+');
Header = "This file contains details of scan " + num2str(count + 1) + ".\n\n";
Line = zeros(1, 9);
Line(1) = "Parameters:\n";
Line(2) = "\tTime: " + currentTime + "\n";
Line(3) = "\tminLambda: " + num2str(minLambda) + " nm\n";
Line(4) = "\tmaxLambda: " + num2str(maxLambda) + " nm\n";
Line(5) = "\tminVoltageSetpoint: " + num2str(minVoltageSetpoint) + " V\n";
Line(6) = "\tmaxVoltageSetpoint: " + num2str(maxVoltageSetpoint) + " V\n";
Line(7) = "\tnumberOfDataPoints: " + num2str(numberOfDataPoints) + "\n";
Line(8) = "\taverageFrequencyOver: " + num2str(averageFrequencyOver) + "\n";
Line(9) = "\tintegrationTime: " + num2str(integrationTime) + " us\n\n";

fprintf(fp, Header);
for i = 1:9
    fprintf(fp, Line(i));
end
fclose(fp);

