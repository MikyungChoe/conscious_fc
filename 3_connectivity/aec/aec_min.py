# -*- coding: utf-8 -*-
"""
Created on Mon Aug 14 11:22:38 2023

@author: soekhyun Lee and MK Choe
"""

import os
import scipy.io
import numpy as np
import mne
from mne_connectivity import envelope_correlation as aec # aec stands for amplitude envelope correlation # using Hilbert transform
from scipy.io import savemat

############# create list of sub number ###############
subno_list = []
folder_path= 'E:\\#ECoGconsciousness\\Connect'
for root, dirs, files in os.walk(folder_path):
    for dir_name in dirs:
        if dir_name.startswith('sub') == True:
            subno_list.append(dir_name.lstrip('sub'))
            
for subno in subno_list:
        
    for data_type in ["rest", "loc"]:
        os.chdir("E:\\#ECoGconsciousness\\Connect\\sub" + subno + "\\raw")
        nmat = "sub" + subno + "_epo1min_"+ data_type +".mat"        
        fmat = scipy.io.loadmat(nmat)        
        data = fmat.get('edata')
        
        sfreq = 500  # sampling rate (Hz)
        
        Freq_Bands = {"Delta": [1.0, 3.0],
                      "Theta": [4.0, 7.0],
                      "Alpha": [8.0, 12.0],
                      "Beta": [13.0, 30.0],
                      "LG": [30.0, 90.0],
                      "HG": [90.0, 140.0]}
    
        aec_result_np_list=list()
        
        for fband in Freq_Bands.keys():
            ffdata = mne.filter.filter_data(data=data, sfreq=sfreq, l_freq=Freq_Bands[fband][0], h_freq=Freq_Bands[fband][1], picks=None, filter_length='auto', l_trans_bandwidth='auto', h_trans_bandwidth='auto', n_jobs=None, method='fir', iir_params=None, copy=True, phase='zero', fir_window='hamming', fir_design='firwin', pad='reflect_limited', verbose=None)
        
            aec_result = aec(ffdata, names=None, orthogonalize='pairwise', log=False, absolute=True, verbose=None)
            
            aec_result_np = aec_result.get_data('dense')
            aec_result_np_squeezed = np.squeeze(aec_result_np)
            aec_result_np_list.append(aec_result_np_squeezed)

        result_stacked = np.stack((aec_result_np_list), axis=-1)
        # print(result_stacked.shape)
        
        os.chdir("E:\\#ECoGconsciousness\\Connect\\sub" + subno + "\\aec")
        file_name = ("sub" + subno + "_aecmin_" + data_type + ".mat")
        data_to_save = {'fband': Freq_Bands, 'faec': result_stacked}
        
        savemat(file_name, data_to_save)
    
        print(f"faec Sub{subno} {data_type} done")
    #input()
