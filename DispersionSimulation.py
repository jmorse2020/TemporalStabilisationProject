#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan 12 10:51:19 2023

@author: jackmorse


This code will plot spectral interference,
simulating what is seen at the output of 
the spectrometer in Insight stabilisation 
project.
"""

""" 
        Libraries 
"""
import matplotlib.pyplot as plt
import numpy as np
import FusedSilicaRefractiveIndexFitFunction
import FourierTransformOfSpectrum



"""
        Global Variables
"""
c = 3E17  # 17 gives Speed of light in vacuum (nm/s)
""" 
        Functions 
"""

""" 
        Defining the Gaussian:
            E(w) = |E(w)| exp(i * phi(w))
            where 
                |E(w)| = exp(-1/2 * w^2 / sigma^2) is a gaussian
"""

# Electric field amplitude: |E(w)|    
def eFieldAmplitude(omega, omega_0, sigma): #(omega, omega_0, sigma):
    return np.exp(-(1/2)*(omega - omega_0)**2/sigma**2) #np.exp(-(1/2)*(omega - omega_0)**2/sigma**2)

# Spectral phase:
def SpectralPhase(omega, L_air, L_fibre):
    return 2*(1 + np.cos((DeltaPhi(omega, L_air, L_fibre))))

# Phase angle between pulses:
def DeltaPhi(omega, L_air, L_fibre):
    #Wavelength = 2*np.pi * c / omega
    A = omega_0/c * L_air + k(Wavelength_0, n_fs) * L_fibre
    
    B = 0#0.1E-11#(1/c) * (n_fs(Wavelength_0) + omega_0 * n_fs_1Derivative(Wavelength_0)) * L_fibre + L_air/c
    
    C = (1/(2*c)) * (2 * n_fs_1Derivative(Wavelength_0) + omega_0 * n_fs_2Derivative(Wavelength_0)) * L_fibre
    return (A + B * (omega - omega_0) +   C * (omega - omega_0)**2)
    # return 10000000000000000*(omega-omega_0)**2
    # return k(omega, n_air) * L_air + k(Wavelength, n_fs) * L_fibre

# Wavenumber: k = omega * refractiveIndex / c (Vac.)
def k(Wavelength, refractiveIndex):
    
    return 2*np.pi / Wavelength * refractiveIndex(Wavelength) 


# Refractive Index:
n_fs = FusedSilicaRefractiveIndexFitFunction.main() # IN Wavelength nm
def n_air(omega):
    return 1



"""                 CODE               """
Wavelength_0 = 1040 #nm
Wavelength = np.linspace(950,1140,10000)
omega = 2 * np.pi * (c / Wavelength)
omega_0 = 2 * np.pi* (c / Wavelength_0) 
sigma = 20/Wavelength_0 * omega_0

n_fs_1Derivative = n_fs.deriv()*(-2*np.pi*c/omega_0**2)
n_fs_2Derivative = n_fs_1Derivative.deriv()*(-2*np.pi*c/omega_0**2)**2
n_group = Wavelength_0 * n_fs_1Derivative(Wavelength_0) - n_fs(Wavelength_0)
L_air =  100E6 #0.3E6
L_fibre =- 1/n_group * L_air #100E6#3.83


"""
        Plots
"""
e_field = eFieldAmplitude(omega, omega_0, sigma)**2
plt.plot(omega, eFieldAmplitude(omega, omega_0, sigma)**2)
plt.title("E field")
plt.show()
Spectral_Interference = eFieldAmplitude(omega, omega_0, sigma)**2 *2* SpectralPhase(omega, L_air, L_fibre)#
#plt.xlim(-1, 1)
plt.plot(omega,Spectral_Interference, color = 'k', linewidth = 0.8)
#air = {"air"}
SiTitle = "Spectral Interference\n [$L_\mathrm{air} = $" + f"{round(L_air/1E6, 1)} mm, " + "$L_\mathrm{fibre} = $" + f"{round(L_fibre/1E6, 1)} mm]"
plt.title(SiTitle)
plt.xlabel("$\omega$ [rad$^{-1}$]")
plt.show()
plt.plot(omega, SpectralPhase(omega, L_air, L_fibre))
plt.title("Spectral Phase, $2\cdot [1 + \cos(\Delta \phi)]$")
plt.show()
plt.plot(omega, DeltaPhi(omega, L_air, L_fibre), color = 'k')
# plt.plot(omega, (omega-omega_0)**2) #A + B * (omega - omega_0) + C * (omega - omega_0)**2
plt.title('$\Delta \Phi$')
plt.show()
FourierTransformOfSpectrum.IVTdataframes(omega, Spectral_Interference, omega_0, 0)
plt.show()