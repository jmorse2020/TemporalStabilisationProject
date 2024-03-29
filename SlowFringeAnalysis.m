function [loc, fringeHeight] = SlowFringeAnalysis(wavelengths, spectralData, minSpectraAmplitude, envelopeSmoothness, fringeHeightTol, minLambda, maxLambda, showPlots, savePath) 
            spectralData = Normalise(spectralData);
            [wavelengths, spectralData] = FilterAbove(wavelengths, spectralData, minSpectraAmplitude);
            [E_u, E_l] = envelope(spectralData,envelopeSmoothness,'peak'); % Retrieves upper and lower envelopes
            wavelengths_2 = wavelengths;

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
                    
                else
                    loc = [];
                end
            else
                loc = [];
                fringeHeight = [];
            end    
            if showPlots 
                startIndex = find(wavelengths_2 >= minLambda, 1);
                endIndex = find(wavelengths_2 <= maxLambda, 1, 'last');
                plot(wavelengths_2(startIndex:endIndex), spectralData(startIndex:endIndex));
                hold on
                    plot(wavelengths_2(startIndex:endIndex), E_u(startIndex:endIndex), 'color', 'red');
                    plot(wavelengths_2(startIndex:endIndex), E_l(startIndex:endIndex), 'color', 'blue');
                    if ~isempty(loc)
                        plot(loc, 0.5, 'x', 'color', 'red')
                    end
                hold off
                if ~isempty(loc)
                    saveas(gcf, savePath)
                end
            end
            return;
        end        