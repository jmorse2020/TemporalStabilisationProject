function [mot_stat, motorObj] = ConnectToMotor(index) % Index of motor in listdevices, usually set to 1
    try
        motorObj = motor();
        a = motorObj.listdevices();
        connect(motorObj, a{index});
        mot_stat = "1";
        disp("Motor " + a{index} + " has been connected successfully.")
    catch
        mot_stat = "0";
        disp("Unable to connect motor.")
    end
end
