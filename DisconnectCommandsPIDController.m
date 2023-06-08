writeline(SerialPort, "XYZ")
delete(SerialPort) % Always delete after use
disconnect(m1)
delete(m1)
disp("Devices have been disconnected.")