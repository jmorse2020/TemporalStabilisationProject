str = "";
try
    writeline(SerialPort, "XYZ")
    delete(SerialPort) % Always delete after use
    str = "1";
catch
end
try
disconnect(spectrometer)
pause(0.2)
delete(spectrometer)
str = str + "1";
catch
end
if strcmp(str, "11")
    disp("Devices have been disconnected.")
end