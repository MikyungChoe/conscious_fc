# -*- coding: utf-8 -*-
"""
Created on Tue Sep 26 17:25:24 2023

@author: Mik Choe
"""

def lziv_all(subno,nfile):

    import numpy as np
    import matplotlib.pyplot as plt
    import antropy as ant
    import mne
    import math
    import os
    import scipy.io
    import random
    from scipy.io import savemat
    from scipy.signal import hilbert
        
    os.chdir("E:\\#ECoGconsciousness\\Connect\\sub" + subno + "\\raw")
    nmat=("sub" + subno + "_epo1min_" + nfile + ".mat")
    fmat=scipy.io.loadmat(nmat)
    data=fmat.get('edata')
    newdata=np.squeeze(data)
    lengch,lengt=newdata.shape
        
    # hilbert, threshold
    TH=np.zeros(lengch)
    hildata=np.zeros((lengch,lengt))
    
    for i in range(lengch):
     hildata[i,:]=abs(hilbert(newdata[i,:])) 
     TH[i]=np.mean(hildata[i,:])
          
    # binary matrix (all, channel)
    biall=''
    bich=np.zeros((lengch,lengt))
    for j in range(lengt):
     for i in range(lengch):
      if hildata[i,j]>TH[i]:
       biall+='1'
       bich[i,j]=1
      else:
       biall+='0'
       bich[i,j]=0
    
    nsurro=50
    # all LZC    
    # 1. surrogate n=50     
    shlist=np.zeros(nsurro)
    for nsh in range(nsurro):
        shtmp=list(biall)
        random.shuffle(shtmp)
        
        w=''
        for i in range(len(shtmp)):
            w+=shtmp[i]
                 
        shlist[nsh]=ant.lziv_complexity(w, normalize=True)
        print(f"Sub {subno} {nfile} all surrogate {nsh+1}th done")            
                
    # 2. real data    
    alllzc=ant.lziv_complexity(biall, normalize=True)
    
    normalllzc=alllzc/np.mean(shlist)
    print(f"Sub {subno} {nfile} all done")
             
    os.chdir("E:\\#ECoGconsciousness\\Connect\\sub" + subno + "\\complexity\\lzc")
    file_name = ("sub" + subno + "_cplxmin_all_" + nfile + ".mat")
    data_to_save = {'alllzc': alllzc, 'normalllzc': normalllzc}
    
    savemat(file_name, data_to_save)

    print(f"LZ Complexity Sub {subno} {nfile} done")
    
    
def lziv_ch(subno,nfile):

    import numpy as np
    import matplotlib.pyplot as plt
    import antropy as ant
    import mne
    import math
    import os
    import scipy.io
    import random
    from scipy.io import savemat
    from scipy.signal import hilbert
        
    os.chdir("E:\\#ECoGconsciousness\\Connect\\sub" + subno + "\\raw")
    nmat=("sub" + subno + "_epo1min_" + nfile + ".mat")
    fmat=scipy.io.loadmat(nmat)
    data=fmat.get('edata')
    newdata=np.squeeze(data)
    lengch,lengt=newdata.shape
        
    # hilbert, threshold
    TH=np.zeros(lengch)
    hildata=np.zeros((lengch,lengt))
    
    for i in range(lengch):
     hildata[i,:]=abs(hilbert(newdata[i,:])) 
     TH[i]=np.mean(hildata[i,:])
          
    # binary matrix (all, channel)
    biall=''
    bich=np.zeros((lengch,lengt))
    for j in range(lengt):
     for i in range(lengch):
      if hildata[i,j]>TH[i]:
       biall+='1'
       bich[i,j]=1
      else:
       biall+='0'
       bich[i,j]=0
    
    nsurro=50    
    
    # CH LZC    
    chlzc=np.zeros(lengch)
    normchlzc=np.zeros(lengch)
    mshlist=np.zeros(lengch)
    for ch in range(lengch):
        chdatatmp=bich[ch,:]
        chdata=''
        for ccc in range(len(chdatatmp)):
            chdata+=str(int(chdatatmp[ccc]))
        
        # 1. surrogate n=50     
        shlist=np.zeros(nsurro)
        for nsh in range(nsurro):
            shtmp=list(chdata)
            random.shuffle(shtmp)
            
            w=''
            for i in range(len(shtmp)):
                w+=shtmp[i]
                     
            shlist[nsh]=ant.lziv_complexity(w, normalize=True)
            print(f"ch {ch+1} surrogate {nsh+1}th done")
        # 2. real data    
        chlzc[ch]=ant.lziv_complexity(chdata, normalize=True)
        
        normchlzc[ch]=chlzc[ch]/np.mean(shlist) 
        mshlist[ch]=np.mean(shlist)        
        print(f"ch {ch+1} complexity done")
           
    os.chdir("E:\\#ECoGconsciousness\\Connect\\sub" + subno + "\\complexity\\lzc")
    file_name = ("sub" + subno + "_cplxmin_ch_" + nfile + ".mat")
    data_to_save = {'chlzc': chlzc, 'normchlzc': normchlzc}
    
    savemat(file_name, data_to_save)

    print(f"LZ Complexity Sub {subno} {nfile} done")
    
    
def lziv_all_nonnorm(subno,nfile):

    ##### without using surrogates #####
    import numpy as np
    import matplotlib.pyplot as plt
    import antropy as ant
    import mne
    import math
    import os
    import scipy.io
    import random
    from scipy.io import savemat
    from scipy.signal import hilbert
        
    os.chdir("E:\\#ECoGconsciousness\\Connect\\sub" + subno + "\\raw")
    nmat=("sub" + subno + "_epo1min_" + nfile + ".mat")
    fmat=scipy.io.loadmat(nmat)
    data=fmat.get('edata')
    newdata=np.squeeze(data)
    lengch,lengt=newdata.shape
        
    # hilbert, threshold
    TH=np.zeros(lengch)
    hildata=np.zeros((lengch,lengt))
    
    for i in range(lengch):
     hildata[i,:]=abs(hilbert(newdata[i,:])) 
     TH[i]=np.mean(hildata[i,:])
          
    # binary matrix (all, channel)
    biall=''
    bich=np.zeros((lengch,lengt))
    for j in range(lengt):
     for i in range(lengch):
      if hildata[i,j]>TH[i]:
       biall+='1'
       bich[i,j]=1
      else:
       biall+='0'
       bich[i,j]=0
    
    # all LZC                             
    # 2. real data    
    alllzc=ant.lziv_complexity(biall, normalize=True)        
    print(f"Sub {subno} {nfile} all done")
             
    os.chdir("E:\\#ECoGconsciousness\\Connect\\sub" + subno + "\\complexity\\lzc")
    file_name = ("sub" + subno + "_cplxmin_all_nonnorm_" + nfile + ".mat")
    data_to_save = {'alllzc': alllzc}
    
    savemat(file_name, data_to_save)
    print(f"LZ Complexity Sub {subno} {nfile} done")    
    
def lziv_ch_nonnorm(subno,nfile):

    import numpy as np
    import matplotlib.pyplot as plt
    import antropy as ant
    import mne
    import math
    import os
    import scipy.io
    import random
    from scipy.io import savemat
    from scipy.signal import hilbert
        
    os.chdir("E:\\#ECoGconsciousness\\Connect\\sub" + subno + "\\raw")
    nmat=("sub" + subno + "_epo1min_" + nfile + ".mat")
    fmat=scipy.io.loadmat(nmat)
    data=fmat.get('edata')
    newdata=np.squeeze(data)
    lengch,lengt=newdata.shape
        
    # hilbert, threshold
    TH=np.zeros(lengch)
    hildata=np.zeros((lengch,lengt))
    
    for i in range(lengch):
     hildata[i,:]=abs(hilbert(newdata[i,:])) 
     TH[i]=np.mean(hildata[i,:])
          
    # binary matrix (all, channel)
    biall=''
    bich=np.zeros((lengch,lengt))
    for j in range(lengt):
     for i in range(lengch):
      if hildata[i,j]>TH[i]:
       biall+='1'
       bich[i,j]=1
      else:
       biall+='0'
       bich[i,j]=0
        
    # CH LZC    
    chlzc=np.zeros(lengch)
    normchlzc=np.zeros(lengch)
    mshlist=np.zeros(lengch)
    for ch in range(lengch):
        chdatatmp=bich[ch,:]
        chdata=''
        for ccc in range(len(chdatatmp)):
            chdata+=str(int(chdatatmp[ccc]))       

        # 2. real data    
        chlzc[ch]=ant.lziv_complexity(chdata, normalize=True)
        print(f"ch {ch+1} complexity done")
           
    os.chdir("E:\\#ECoGconsciousness\\Connect\\sub" + subno + "\\complexity\\lzc")
    file_name = ("sub" + subno + "_cplxmin_ch_nonnorm_" + nfile + ".mat")
    data_to_save = {'chlzc': chlzc}
    
    savemat(file_name, data_to_save)
    print(f"LZ Complexity Sub {subno} {nfile} done")