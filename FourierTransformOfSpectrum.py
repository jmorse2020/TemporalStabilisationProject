#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 16 16:53:08 2023

@author: jackmorse


Fourier transform of spectrum from spectrometer
"""

import numpy as np
import matplotlib.pyplot as plt
import scipy as sy
from scipy import fft
import pandas as pd
import PlotOceanOpticsSpectrum
import matplotlib.patches as patches

def main(file):
    df1 = pd.read_csv(file, header = None, skiprows = 17, delimiter = "\t")
    PlotOceanOpticsSpectrum.plot(filename=file, title = "Spectrometer output", x_label = "$\lambda [nm]$", y_label = "Intensity [Norm]")
    plt.show()
    data = df1[1].to_numpy()
    print('ere')
    y = sy.fft.ifftshift(sy.fft.ifft(data))
    # y = np.log10(y)
    
    diff = max(df1[0]) - min(df1[0])
    freq = 3E17/(1040**2)*diff # Frequency window
    dt = 1 / freq
    Dt = 2048 * dt * 1E12
    domain = np.linspace(-freq/2,freq/2,2048)
    t_domain = np.linspace(-Dt/2,Dt/2,2048)
    print("t_domain is:")
    print(t_domain)
    #domain = np.log(domain)
    plt.xlim(0,Dt/10)
    plt.ylim(0,200)
    plt.plot(t_domain, abs(y), color = 'k')
    plt.title("Inverse Fourier Transform of Spectrum")
    plt.xlabel("Time [ps]", size = 13)
    plt.ylabel("$log_{10}[ \mathcal{F}\; (S(\omega)) ] $", size = 13)
    
    
def IVTdataframes(x, y, omega_0, isLog = 1):
    length = len(x)
    y = sy.fft.ifftshift(sy.fft.ifft(y))
    diff = max(x) - min(x)
    freq = 3E17/(1040**2)*diff # Frequency window /
    dt = 1 / diff
    Dt = length * dt * 1E12
    domain = np.linspace(-freq/2,freq/2,length)
    t_domain = np.linspace(-Dt/2,Dt/2,length)
    if (isLog == 1):
        y = np.log10(y)
        plt.ylabel("$ | log_{10}[ \mathcal{F}\; (S(\omega)) ] | $", size = 13)
    else:
        plt.ylabel("$| \mathcal{F}\; (S(\omega)) |$");
    plt.xlim(0,Dt/40)
    #plt.ylim(-4,0)
    plt.plot(t_domain, abs(y), color = 'k')
    plt.title("Inverse Fourier Transform of Spectrum")
    plt.xlabel("Time [ps]", size = 13)
    
            
    
    
    
    
# #
# """ FILE NAME """
filename = r"/Users/jackmorse/Library/CloudStorage/OneDrive-ScienceandTechnologyFacilitiesCouncil/Documents/TemporalStabilistationOfInSightProject/FusedSilicaRefractiveIndexData.csv"
main(file="/Users/jackmorse/Library/CloudStorage/OneDrive-ScienceandTechnologyFacilitiesCouncil/Documents/TemporalStabilistationOfInSightProject/SpectraDataAndImages/Spectra1on22dec2022BArms.txt")
    