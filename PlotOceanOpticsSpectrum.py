#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan 12 11:06:50 2023

@author: jackmorse



This is a script to plot the readout of an tab-delimited OceanOptics file.

"""
""" Libraries """
import matplotlib.pyplot as plt
import math as math
import pandas as pd


# """ Enter the file location (should have extension .txt) """

# filename = r"/Users/jackmorse/Library/CloudStorage/OneDrive-ScienceandTechnologyFacilitiesCouncil/Documents/TemporalStabilistationOfInSightProject/SpectraDataAndImages/Spectra4on22dec2022Reference_arm.txt"


# """ Enter the plot labels """
# title = ""
# x_label = ""
# y_label = ""

# """ Code to create plot """
# df1 = pd.read_csv(filename, header = None, skiprows = 17, delimiter = "\t")

# x_dat = df1[0]
# y_dat = df1[1]
# y_min = min(y_dat)
# y_dat = y_dat - y_min
# y_max = max(y_dat)
# norm_y_dat = y_dat/y_max

# plt.xlabel(x_label)
# plt.ylabel(y_label)
# plt.title(title)
# plt.grid()
# plt.plot(x_dat, norm_y_dat, linewidth = 0.7, color = 'k')

# def f_half(x):
#     return x*0 + 0.5

# plt.plot(x_dat, f_half(x_dat), color = 'r', linestyle = 'dashed')
# #plt.plot(1011,0.5, marker = 'x', markersize = '20', color = 'orange')
# #plt.plot(1051,0.5, marker = 'x', markersize = '20', color = 'orange')

def plot(filename, title = "Title", x_label = "X_Label", y_label = "Y_Label"):
    
    """ Code to create plot """
    df1 = pd.read_csv(filename, header = None, skiprows = 17, delimiter = "\t")
    
    x_dat = df1[0]
    y_dat = df1[1]
    y_min = min(y_dat)
    y_dat = y_dat - y_min
    y_max = max(y_dat)
    norm_y_dat = y_dat/y_max
    
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.title(title)
    plt.grid()
    plt.plot(x_dat, norm_y_dat, linewidth = 0.7, color = 'k')
    
