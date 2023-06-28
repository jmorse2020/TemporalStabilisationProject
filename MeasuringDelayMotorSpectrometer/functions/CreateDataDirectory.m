function [dataSaveLocation, dataFileName] = CreateDataDirectory()
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
    dataFileName = fullfile("Data\" + currentDateTime + "\" + "Scan" + num2str(max(arr) + 1) + ".txt");
    if ~(max(arr) + 1 == count)
        disp("You may not have consecutive numbering in this folder. A file with the max scan number + 1 has been returned")
    end
end