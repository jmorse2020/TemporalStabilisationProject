% clear;
% SerialPort = "";
% ConnectToSerialPortsAndSpectrometers(SerialPort);
function [connectedStatus, SerialPort, spectrometer] = ConnectToSerialPortsAndSpectrometer(SerialPort)% ~Establish connections to the serial port and spectrometer~%
    Port = "COM7";
    SubPort = "CONN 4";
    Escape = "'XYZ'";
    UserChar = "";
    SubPort_WEsc = SubPort + ", " + Escape;
    connectedStatus = "";
    % Mainframe serial port SIM900%
    try
        SerialPort = serialport(Port,9600); % Ensure correct comm port and baud rate
        try
            fopen(SerialPort);
        catch
        end
%         SerialPort = serialport(Port,9600); % Ensure correct comm port and baud rate
%         fopen(SerialPort);
        SerialPort.configureTerminator('CR');
        set(SerialPort, 'Timeout', 1)
    
        % Check connection:
        writeline(SerialPort, "*IDN?")
        R = readline(SerialPort);
        if (contains(R, "Stanford_Research_Systems,SIM900"))
            connectedStatus = "1";
            disp("Connection established: Serial Port")
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
        elseif (contains(R, "Stanford_Research_Systems,SIM960"))
            connectedStatus = "1";
            disp("Connection established: Serial Port")    
            try
                % writeline(SerialPort, SubPort_WEsc)
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
    return;
end