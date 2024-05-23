# -*- coding: utf-8 -*-
"""
Created on Fri Aug 11 11:53:18 2023

@author: Mikchoe
"""

def wpli_min(subno,nfile):
    
    import os
    import mat73
    import scipy.io
    import numpy as np
    import matplotlib.pyplot as plt
    import mne
    from mne_connectivity import spectral_connectivity_time
    from scipy.io import savemat

    os.chdir("E:\\#ECoGconsciousness\\Connect\\sub" + subno + "\\raw")

    nmat=("sub" + subno + "_epo1min_" + nfile + ".mat")
    fmat=scipy.io.loadmat(nmat)
    data=fmat.get('edata')
    
    sfreq = 500  # sampling rate (Hz)

    Freq_Bands = {"Delta": [1.0, 3.0],
                  "Theta": [4.0, 7.0],
                  "Alpha": [8.0, 12.0],
                  "Beta": [13.0, 30.0],
                  "LG": [30.0, 90.0],
                  "HG": [90.0, 140.0]}
    min_freq = np.min(list(Freq_Bands.values()))
    max_freq = np.max(list(Freq_Bands.values()))
    freqs = np.linspace(min_freq, max_freq, int((max_freq - min_freq) + 1))
    freqs = freqs[(freqs != 60) & (freqs != 120)]

    # The dictionary with frequencies are converted to tuples for the function
    fmin = tuple([list(Freq_Bands.values())[f][0] for f in range(len(Freq_Bands))])
    fmax = tuple([list(Freq_Bands.values())[f][1] for f in range(len(Freq_Bands))])

    # Compute connectivity over time
    con_time = spectral_connectivity_time(data, freqs,method='wpli',sfreq=sfreq, 
                                          mode="cwt_morlet",fmin=fmin, fmax=fmax,
                                          faverage=True)
    
    wplimin=con_time.get_data('dense')
     
    os.chdir("E:\\#ECoGconsciousness\\Connect\\sub" + subno + "\\wpli")
    file_name = ("sub" + subno + "_wplimin_" + nfile + ".mat")
    data_to_save = {'freq': freqs,'fband': Freq_Bands, 'fwpli': wplimin}
    
    savemat(file_name, data_to_save)

    print(f"Wpli Sub {subno} {nfile} done")







    
    

    
    
    