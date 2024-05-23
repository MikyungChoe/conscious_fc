# -*- coding: utf-8 -*-
"""
Created on Tue Mar 26 11:20:16 2024

@author: Mikyung Choe
"""

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
plt.rcParams['font.family'] = 'Arial'
import os

indx1 = results.loc[results[:,'aec_1Delta':'wpli_6HG']>0.75]
indx1 = results.loc[:,'aec_1Delta':'wpli_6HG']>0.75

filtered_df = results.where(indx1)
indx2 = [(index, value) for index, value in np.ndenumerate(filtered_df) if not pd.isnull(value)]



ridx1=results.iloc[6,0]
ridx2=results.iloc[6,1]


#%%

xxx = pd.DataFrame({'tag':['aec Theta VN-VN','aec Delta VN-VN',	'wpli Beta DMN-VN',	'aec Alpha VN-VN','wpli Beta Limbic-VN','wpli Beta VN-VN',	
                           'wpli Beta VAN-VN','aec Beta VN-VN',	'aec Delta DMN-VN',	'wpli Beta SMN-VN',	'aec Theta DMN-VN',	'wpli LG Limbic-VN',
                           'wpli Beta DAN-VN','aec Theta DAN-VN'],                   
                    'ACC':[0.828596904,	0.820502366,0.792442352,0.787686235,0.787382943,0.779311501,0.770323939,0.764094153,0.763352102,
                           0.762783217,	0.76253793,	0.760763522, 0.759172402,0.757216234]})


sns.barplot(x='ACC', y='tag', data=xxx, palette='Set2')
plt.xlim(0, 1)
plt.xlabel('Accuracy')
plt.ylabel('Connectivity, Frequency, RSNs')




plt.legend(title='Connectivity')
plt.tight_layout()
fname='bar_global_th10'
os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\connect_svm\\4th")
plt.savefig(fname + '.tiff', dpi=300)
plt.savefig(fname + '.png', dpi=300)
plt.show()   

#%%

ACCtmp=[0.792442352,	0.787382943,	0.770323939,	0.763352102,	0.762783217,	0.76253793,	0.760763522,	
       0.759172402,	0.757216234,	0.737597122,	0.737054601,	0.736874064,	0.734564316,	0.73443622]
ACC_scaled = [x * 100 for x in ACCtmp]

#xxx = pd.DataFrame({'tag':['wPLI Beta DMN-VN', 'wPLI Beta Limbic-VN','wPLI Beta VAN-VN','AEC Delta DMN-VN','wPLI Beta SMN-VN','AEC Theta DMN-VN',
#                           'wPLI LG Limbic-VN','wPLI Beta DAN-VN','AEC Theta DAN-VN','wPLI LG SMN-VN','AEC Theta VAN-VN','AEC Theta SMN-VN',	
#                           'AEC Theta DAN-VAN','wPLI LG FPN-VN'],                   
#                    'ACC':ACC_scaled})

xxx = pd.DataFrame({'tag':['wPLI Beta DMN-VN', 'wPLI Beta Limbic-VN','wPLI Beta VAN-VN','AEC Delta DMN-VN','wPLI Beta SMN-VN','AEC Theta DMN-VN',
                           'wPLI Low gamma Limbic-VN','wPLI Beta DAN-VN','AEC Theta DAN-VN','wPLI Low gamma SMN-VN','AEC Theta VAN-VN','AEC Theta SMN-VN',	
                           'AEC Theta DAN-VAN','wPLI Low gamma FPN-VN'],                   
                    'ACC':ACC_scaled})

#plt.figure(figsize=(20,20))
sns.barplot(x='ACC', y='tag', data=xxx)
plt.tight_layout()
plt.xlim(0, 100)
plt.xlabel('Accuracy (%)')
plt.ylabel('Connectivity, Frequency, RSN-RSN')


fname='bar_global_th10'
os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\connect_svm\\4th")
plt.savefig(fname + '.tiff', dpi=300)
plt.savefig(fname + '.png', dpi=300)
plt.show()   