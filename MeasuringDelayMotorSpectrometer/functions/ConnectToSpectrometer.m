function [spec_stat, spectrometerObj] = ConnectToSpectrometer() % Index of motor in listdevices, usually set to 1
    try
        spectrometerObj = icdevice('OceanOptics_OmniDriver.mdd');
        connect(spectrometerObj)
        spec_stat = "1";
        disp("Spectrometer has been connected successfully.")
    catch
        spec_stat = "0";
        disp("Unable to connect spectrometer.")
    end 
end