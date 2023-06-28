function [fp, dataSaveLocation] = CreateTXTFile(filename)
    dataDirectory = fullfile(pwd, "\Data\");
    if (~exist(dataDirectory, 'dir'))
        t = mkdir(dataDirectory); 
        if t ~= 1
            disp("Could not make directory '\Data'");
        end
    end
    currentDate = datestr(datetime('today'));
    currentTime = datestr(datetime('now'), 'HH_MM_SS');
    currentDateTime = currentDate + "_" + currentTime;
    if ~exist(fullfile(dataDirectory, currentDateTime), "dir")
        mkdir(fullfile(dataDirectory, currentDateTime))
    end
    
    fileList = dir(fullfile(fullfile(dataDirectory, currentDateTime), '*.txt'));  
    count = 1;
    arr = [0]; %#ok<NBRAK2>
    for i = 1:numel(fileList)
        if (contains(fileList(i).name, 'Scan') && length(fileList(i).name) >= 9)
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
    dataSaveLocation = fullfile("Data\" + currentDateTime + "\");
    if filename == ""
        filePath = fullfile("Data\" + currentDateTime + "\" + "Scan" + num2str(max(arr) + 1) + ".txt");
        if ~(max(arr) + 1 == count)
            disp("You may not have consecutive numbering in this folder. A file with the max scan number + 1 has been created")
        end
        fp = fopen(filePath, 'w+');
        Header = "This file contains details of scan " + num2str(max(arr) + 1) + ".\n\n";
        % Line(1) = "Parameters:\n";
        % Line(2) = "\tDate: " + currentDate + "\n";
        % Line(3) = "\tTime: " + currentTime + "\n";
        % Line(4) = "\tminLambda: " + num2str(minLambda) + " nm\n";
        % Line(5) = "\tmaxLambda: " + num2str(maxLambda) + " nm\n";
        % Line(6) = "\tminVoltageSetpoint: " + num2str(minVoltageSetpoint) + " V\n";
        % Line(7) = "\tmaxVoltageSetpoint: " + num2str(maxVoltageSetpoint) + " V\n";
        % Line(8) = "\tnumberOfDataPoints: " + num2str(numberOfDataPoints) + "\n";
        % Line(9) = "\taverageFrequencyOver: " + num2str(averageFrequencyOver) + "\n";
        % Line(10) = "\tintegrationTime: " + num2str(integrationTime) + " us\n";
        % Line(11) = "\tminSpectraAmplitude: " + num2str(minSpectraAmplitude) + "\n";
        % Line(12) = "\tenvelopeSmoothing: " + num2str(envelopeSmoothing) + "\n";
        % Line(13) = "\tfringeHeightTol: " + num2str(fringeHeightTol) + "\n";

        fprintf(fp, Header);
    else
        filePath = fullfile("Data\" + currentDateTime + "\" + filename + ".txt");
        fp = fopen(filePath, 'w+');
    end
    % for i = 1:length(Line)
    %     fprintf(fp, Line(i));
    % end
end