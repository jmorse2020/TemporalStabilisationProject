function [wavelengths, spectralData] = acquirespectrum(spectrometerObj,integrationTime,channelIndex,enable, spectrometerIndex)
% spectrometersetup.m Function to connect to spectrometer at address
% spectrometerindex and setup the parameters needed prior to recording.

% numOfSpectrometers = invoke(spectrometerObj, 'getNumberOfSpectrometersFound');

% disp(['Found ' num2str(numOfSpectrometers) ' Ocean Optics spectrometer(s).'])

% Get spectrometer name.
% spectrometerName = invoke(spectrometerObj, 'getName', spectrometerIndex);
% Get spectrometer serial number.
% spectrometerSerialNumber = invoke(spectrometerObj, 'getSerialNumber', spectrometerIndex);
% disp(['Model Name : ' spectrometerName])
% disp(['Model S/N  : ' spectrometerSerialNumber])

% Set integration time.
invoke(spectrometerObj, 'setIntegrationTime', spectrometerIndex, channelIndex, integrationTime);
% Enable correct for detector non-linearity.
invoke(spectrometerObj, 'setCorrectForDetectorNonlinearity', spectrometerIndex, channelIndex, enable);
% Enable correct for electrical dark.
invoke(spectrometerObj, 'setCorrectForElectricalDark', spectrometerIndex, channelIndex, enable);

wavelengths = invoke(spectrometerObj, 'getWavelengths', spectrometerIndex, channelIndex);
% Get the wavelengths of the first spectrometer and save them in a double
% array.
spectralData = invoke(spectrometerObj, 'getSpectrum', spectrometerIndex);

end

