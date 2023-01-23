#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 13 10:43:25 2023

@author: jackmorse


This code generates a fitting function to the refractive index of Fused Silica based on data found at https://refractiveindex.info/?shelf=glass&book=fused_silica&page=Malitson
around 1 micron.
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt



def main():
    """ Enter the file location (should have extension .txt) """
    
    filename = r"/Users/jackmorse/Library/CloudStorage/OneDrive-ScienceandTechnologyFacilitiesCouncil/Documents/TemporalStabilistationOfInSightProject/FusedSilicaRefractiveIndexData.csv"
    
    
    """ Enter the plot labels """
    title = "Refractive index of Fused Silica"
    x_label = "Wavelength [nm]"
    y_label = "Refractive index, n"
    
    """ Code to create plot """
    df1 = pd.read_csv(filename, header = None, skiprows = 1)
    
    x_dat = df1[0]*1000
    y_dat = df1[1]
    
    
    #make new list x for x in a only if x less than 5
    x_1 = [x for x in x_dat if x >= 1000]
    diff_1 = len(x_dat) - len(x_1)
    y_1 = y_dat[diff_1:]
    
    x_2 = [x for x in x_1 if x <= 1100]
    diff_2 = len(x_1) - len(x_2)
    y_2 = y_1[:-diff_2]
    
    x_Filtered = x_2
    y_Filtered = y_2
    
    order = 10
    coefficients = np.polyfit(x_Filtered, y_Filtered, order)
    fit = np.poly1d(coefficients)
    # plt.xlabel(x_label)
    # plt.ylabel(y_label)
    # plt.title(title)
    
    # plt.grid()
    # plt.plot(x_Filtered, y_Filtered, linewidth = 1, color = 'k', label = 'Fused Silica')
    # plt.plot(x_Filtered, fit(x_Filtered), color = 'red', linestyle = 'dashed', label = f'Fit (Ord [order])')
    # plt.legend()
    # plt.show()
    
    # plt.grid()
    # plt.plot(x_dat, y_dat, linewidth = 1, color = 'k', label = 'Fused Silica')
    # plt.plot(x_Filtered, fit(x_Filtered), color = 'red', label = f'Fit (Ord [order])')
    # plt.legend()
    # plt.show()
    
    return fit
    
# main()

