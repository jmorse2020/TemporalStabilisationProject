function [loc, fringeHeight] = SlowFringeAnalysis(wavelengths, spectralData, minSpectraAmplitude, envelopeSmoothness, fringeHeightTol, minLambda, maxLambda, showPlots) 
            spectralData = Normalise(spectralData);
            [wavelengths, spectralData] = FilterAbove(wavelengths, spectralData, minSpectraAmplitude);
            [E_u, E_l] = envelope(spectralData,envelopeSmoothness,'peak'); % Retrieves upper and lower envelopes
            if showPlots
                plot(wavelengths, spectralData);
            % hold(app.UIAxes1, 'On');
                hold on
                    plot(wavelengths, E_u, 'color', 'red');
                    plot(wavelengths, E_l, 'color', 'blue');
                hold off
            end
            % hold(app.UIAxes1, 'Off');
            % end
            % 3a. Check whether to continue with analysis
            fringeHeight = mean(abs(E_u - E_l));
            if fringeHeight > fringeHeightTol
                groundedSpectralPhase = (spectralData) - abs(E_l); % Shifting the phase to zero
        
                E_2 = envelope(groundedSpectralPhase, envelopeSmoothness, 'peak'); % Finding the envelope of the grounded spectral phase
                % Plot of grounded phase here
    %             subplot(2,2,2);
                % plot(app.UIAxes2, wavelengths, groundedSpectralPhase);
                % hold(app.UIAxes2, 'On');
                % plot(app.UIAxes2, wavelengths, E_2, 'color', 'red')
                % hold(app.UIAxes2, 'Off');
                boundedPhase = groundedSpectralPhase ./ E_2;
                
                [wavelengths, spectralPhase, inBounds] = RestrictDomain(wavelengths, boundedPhase, minLambda, maxLambda);
                
                if inBounds == true
                    intercepts = Intercepts(wavelengths, spectralPhase, 0.5);            
                    loc = locUsingGaps(intercepts, 0.4);
    %                 subplot(2,2,[3,4])
                    % plot(app.UIAxes3, wavelengths, spectralPhase);
                    % title(app.UIAxes3, "Dividing by upper envelope")
                    % hold(app.UIAxes3, 'On');
                    % plot(app.UIAxes3, intercepts, 0.5*ones(1, length(intercepts)), 'x')
                    % plot(app.UIAxes3, loc, 0.5, 'x', 'color', 'red');
                    % hold(app.UIAxes3, 'Off');
    %                 subplot(2,2,1)
                    hold on
                        plot(loc, 0.5, 'x', 'color', 'red');
                    hold off
                else
                    loc = [];
                end
            else
                loc = [];
                fringeHeight = [];
            end    
            return;
        end        