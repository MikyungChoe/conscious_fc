# -*- coding: utf-8 -*-
"""
Created on Mon May 13 21:41:07 2024

@author: Mikyung Choe
"""

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
plt.rcParams['font.family'] = 'Arial'
import os

#%%

xxx = pd.DataFrame({'tag':['wpli Beta Limbic-Occipital','aec Theta Occipital-Parietal','wpli Beta Occipital-Parietal'
                           ,'wpli Beta Occipital-Temporal','aec Delta Occipital-Parietal','wpli LG Occipital-Parietal'
                           ,'aec Delta Limbic-Occipital','aec Theta Occipital-Temporal','wpli LG Occipital-Temporal'
                           ,'coh LG Insula-Temporal','aec Theta Limbic-Occipital'],                 
                    'ACC':[0.791913098,0.78258718,0.780546379,0.772045871,0.767292772,0.754785204,
                           0.752754734,0.747520434,0.741161904,0.738427744,0.738287285]})

sns.barplot(x='ACC', y='tag', data=xxx, palette='Set2')
plt.xlim(0, 1)
plt.xlabel('Accuracy')
plt.ylabel('Connectivity, Frequency, Region-Region')

#plt.legend(title='Connectivity')
plt.tight_layout()
fname='bar_global_th10'
os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\connect_svm_lobe")
plt.savefig(fname + '.tiff', dpi=300)
plt.savefig(fname + '.png', dpi=300)
plt.show()   

#%%

ACCtmp=[0.791913098,0.78258718,0.780546379,0.772045871,0.767292772,0.754785204,
       0.752754734,0.747520434,0.741161904,0.738427744,0.738287285]
ACC_scaled = [x * 100 for x in ACCtmp]

xxx = pd.DataFrame({'tag':['wpli Beta Limbic-Occipital','aec Theta Occipital-Parietal','wpli Beta Occipital-Parietal'
                           ,'wpli Beta Occipital-Temporal','aec Delta Occipital-Parietal','wpli LG Occipital-Parietal'
                           ,'aec Delta Limbic-Occipital','aec Theta Occipital-Temporal','wpli LG Occipital-Temporal'
                           ,'coh LG Insula-Temporal','aec Theta Limbic-Occipital'],                   
                    'ACC':ACC_scaled})

#plt.figure(figsize=(20,20))
sns.barplot(x='ACC', y='tag', data=xxx)
plt.tight_layout()
plt.xlim(0, 100)
plt.xlabel('Accuracy (%)')
plt.ylabel('Connectivity, Frequency, Region-Region')


fname='bar100_global_th10'
os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\connect_svm_lobe")
plt.savefig(fname + '.tiff', dpi=300)
plt.savefig(fname + '.png', dpi=300)
plt.show()   
