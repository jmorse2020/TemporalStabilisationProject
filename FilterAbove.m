function [wavelengths, spectralData] = FilterAbove(wavelengths, spectralData, threshold)
    fil_spe = 0;
    fil_wav = 0;
    j = 1;
    idx = find(spectralData > threshold);
    for i = 1:length(wavelengths)
        if ((wavelengths(min(idx)) <= wavelengths(i)) && (wavelengths(i) <= wavelengths(max(idx))))
            fil_wav(j) = wavelengths(i);
            fil_spe(j) = spectralData(i);
            j = j + 1;
        end
    end
    wavelengths = fil_wav;
    spectralData = fil_spe;
    return;
end