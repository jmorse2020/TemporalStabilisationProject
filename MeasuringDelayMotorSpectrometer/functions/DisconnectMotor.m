function mot_stat = DisconnectMotor(motorObj)
    try
        motorID = motorObj.serialnumber;
        disconnect(motorObj)
        delete(motorObj)
        mot_stat = "0";
        disp("Motor " + motorID + " has been disconnected successfully.");
    catch
        try
            mot_stat = motorObj.isconnected;
            if mot_stat == 0
                disp("Motor is not connected")
                delete(motorObj);
            end
        catch
            mot_stat = "0";
            disp("Unexpected error disconnecting motor.");
        end
    end

end