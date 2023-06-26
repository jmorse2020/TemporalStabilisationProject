function spec_stat = DisconnectSpectrometer(spectrometerObj)
    try
        disconnect(spectrometerObj)
        delete(spectrometerObj)
        spec_stat = "0";
        disp("Spectrometer has been disconnected successfully");
    catch
        try
            spec_stat = spectrometerObj.isconnected;
        catch
            spec_stat = "0";
        end
        disp("Unexpected error disconnecting spectrometer");
    end
end