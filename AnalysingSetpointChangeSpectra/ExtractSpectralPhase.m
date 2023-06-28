function [wavelengths, spectralPhase] = ExtractSpectralPhase(wavelengths, spectralData, envelopeSmoothness, lambdaMin, lambdaMax, fringeHeightTolerence)
    normalised_spectralData = Normalise(spectralData);
    % hold on
    % plot(wavelengths, normalised_spectralData)    
    [E_u, E_l] = envelope(normalised_spectralData,envelopeSmoothness,'peak'); % Retrieves upper and lower envelopes
    % plot(wavelengths, E_l)
    % plot(wavelengths, E_u)
    fringeHeight = mean(abs(E_u - E_l));
    if fringeHeight > fringeHeightTolerence
        groundedSpectralPhase = (normalised_spectralData) - abs(E_l); % Shifting the phase to zero
        % plot(wavelengths, groundedSpectralPhase)
        [E_u_2, ~] = envelope(groundedSpectralPhase,envelopeSmoothness,'peak'); % Retrieves upper and lower envelopes
        % hold off
        % plot(wavelengths, E_u_2)
        % hold on 
        % plot(wavelengths, groundedSpectralPhase)
        boundedPhase = groundedSpectralPhase ./ E_u_2;
        % plot(wavelengths, boundedPhase)
        [wavelengths, spectralPhase, ~] = RestrictDomain(wavelengths, boundedPhase, lambdaMin, lambdaMax);
        spectralPhase = Normalise(spectralPhase);
        % plot(wavelengths, spectralPhase)
        % hold off
        return;
    end
    wavelengths = [];
    spectralPhase = [];
end