function [wavelengths, spectralPhase, inBounds] = RestrictDomain(wavelengths, BoundedSpectralPhase, lambdaMin, lambdaMax)
    fil_phas = 0;
    fil_wav = 0;
    j = 1;
    idx = find(and(wavelengths > lambdaMin, wavelengths < lambdaMax));
    for i = 1:length(wavelengths)
        if and(wavelengths(min(idx)) <= wavelengths(i), wavelengths(i) <= wavelengths(max(idx)))
            fil_wav(j) = wavelengths(i);
            fil_phas(j) = BoundedSpectralPhase(i);
            j = j + 1;
        end
    end
    wavelengths = fil_wav;
    spectralPhase = fil_phas;
    if (and(min(spectralPhase) > -0.5, max(spectralPhase) < 1.5))
        inBounds = true;
    else
        inBounds = false;
    end
    return;
end