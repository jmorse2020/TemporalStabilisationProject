function newLoc = GetFringeLocation(wavelengths, spectralData, loc, minSpectraAmplitude, envelopeSmoothness, fringeHeightTol)
    [wavelengths, spectralData, ~] = RestrictDomain(wavelengths, spectralData, 975, 1105);
    spectralData = Normalise(spectralData);
    [wavelengths, spectralData] = FilterAbove(wavelengths, spectralData, minSpectraAmplitude);
    [E_u, E_l] = envelope(spectralData,envelopeSmoothness,'peak'); % Retrieves upper and lower envelopes
    fringeHeight = mean(abs(E_u - E_l));
    if fringeHeight > fringeHeightTol
        groundedSpectralPhase = (spectralData) - abs(E_l); % Shifting the phase to zero
        E_2 = envelope(groundedSpectralPhase, envelopeSmoothness, 'peak'); % Finding the envelope of the grounded spectral phase
        boundedPhase = groundedSpectralPhase ./ E_2;
        [wavelengths, spectralPhase, inBounds] = RestrictDomain(wavelengths, boundedPhase, 1020, 1060);
        if inBounds == true
            intercepts = Intercepts(wavelengths, spectralPhase, 0.5);            
            newLoc = locUsingGaps(intercepts, 0.4);
            return;
        end
    end   
    newLoc = loc;
    return;
end