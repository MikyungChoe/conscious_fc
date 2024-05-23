# -*- coding: utf-8 -*-
"""
Created on Fri May 17 19:07:51 2024

@author: Mikyung Choe
"""
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
plt.rcParams['font.family'] = 'Arial'
import os

#%% RSN
# Load the data
os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\connect_svm")
full_sheet = ("E:\\#ECoGconsciousness\\Connect\\all\\connect_svm\\z score_svm_4th_all.xlsx")
full_sheet = pd.read_excel(full_sheet)

full_sheet['color'] = full_sheet['ACC'].apply(lambda x: 'red' if x >= 73.4 else 'steelblue')
color_list = full_sheet['color'].tolist()

# Increase figure size for better readability
plt.figure(figsize=(16, 30))

# Create the barplot
#sns.barplot(x='ACC', y='tag', data=full_sheet)
bars = sns.barplot(x='ACC', y='tag', data=full_sheet, palette=color_list)


# Customize the plot for better readability
plt.xlim(0, 100)
plt.xlabel('Accuracy (%)', fontsize=14)
plt.ylabel('Connectivity, Frequency, RSN-RSN', fontsize=14)
plt.xticks(fontsize=12)
plt.yticks(fontsize=6)

# Adjust layout and y-axis tick label padding
plt.tight_layout()
plt.gca().yaxis.set_tick_params(pad=25)

plt.savefig('bar_rsns_all.png', dpi=500, bbox_inches='tight')

# Show the plot
plt.show()

#%% Lobe
# Load the data
os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\connect_svm_lobe")
full_sheet = ("E:\\#ECoGconsciousness\\Connect\\all\\connect_svm_lobe\\z score_svm_all.xlsx")
full_sheet = pd.read_excel(full_sheet)

full_sheet['color'] = full_sheet['ACC'].apply(lambda x: 'red' if x >= 73.8 else 'steelblue')
color_list = full_sheet['color'].tolist()

# Increase figure size for better readability
plt.figure(figsize=(16, 30))

# Create the barplot
#sns.barplot(x='ACC', y='tag', data=full_sheet)
bars = sns.barplot(x='ACC', y='tag', data=full_sheet, palette=color_list)


# Customize the plot for better readability
plt.xlim(0, 100)
plt.xlabel('Accuracy (%)', fontsize=14)
plt.ylabel('Connectivity, Frequency, Region-Region', fontsize=14)
plt.xticks(fontsize=12)
plt.yticks(fontsize=6)

# Adjust layout and y-axis tick label padding
plt.tight_layout()
plt.gca().yaxis.set_tick_params(pad=25)

plt.savefig('bar_lobes_all.png', dpi=500, bbox_inches='tight')

# Show the plot
plt.show()



