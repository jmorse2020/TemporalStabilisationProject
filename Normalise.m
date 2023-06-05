function spectralData = Normalise(spectralData)
    spectralData = (spectralData - min(spectralData))/ max(spectralData - min(spectralData));    
    return;
end