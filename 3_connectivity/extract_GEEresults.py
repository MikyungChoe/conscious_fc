# -*- coding: utf-8 -*-
"""
Created on Tue Jan  9 14:24:04 2024

@author: Mikyung Choe / Yunhee Choi
"""

def rois(connect,fband,roi):
    import numpy as np
    import pandas as pd
    
    full_sheet = ("E:\\#ECoGconsciousness\\Connect\\all\\" + connect + "\\statspss\\lnresults\\" + fband + '\\' + connect + '_' + fband + '_' + roi + '.xlsx')
    full_sheet = pd.read_excel(full_sheet)
    
    contains_string = full_sheet['Unnamed: 0'].str.contains('!GEE_lnconnect iPath', na=False)
    indx1 = full_sheet.index[contains_string].tolist()
    indx1 =indx1[0]
        
    if roi in str(full_sheet.loc[indx1, 'Unnamed: 0']):
        print(f"{roi} is in the string")
    else:
        raise ValueError(f"{roi} is not in the string ERROR!!!!!!!!!")
    
    # find number of subject
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '상관 데이터 요약'].tolist()
    indx1 =indx1[0]
    
    idxtmp=full_sheet.loc[indx1+1,'Unnamed: 2']
    if idxtmp=='subject':
        nsub=full_sheet.loc[indx1+1,'Unnamed: 3']
    else:
        print('nsub ERROR!!!!!!!!!')
    
    # find data Number
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '범주형 변수 정보'].tolist()
    indx1 =indx1[0]
    
    idxtmp=full_sheet.loc[indx1+1,'Unnamed: 3']
    if idxtmp=='N':
        ndata=full_sheet.loc[indx1+2,'Unnamed: 3']
    else:
        print('N ERROR!!!!!!!!!')
        
    # find mean value during states
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '추정 주변 평균: con_state'].tolist()
    indx1 =indx1[0]
    
    idxtmp=full_sheet.loc[indx1+5,'Unnamed: 0']
    idxtmp2=full_sheet.loc[indx1+6,'Unnamed: 0']
    
    if idxtmp=='1' and idxtmp2=='2':
       mean1=full_sheet.loc[indx1+5,'Unnamed: 1']
       mean2=full_sheet.loc[indx1+6,'Unnamed: 1']
    else:
       print('mean ERROR!!!!!!!!!')
    
    # diff mean between states
    mean3=mean2-mean1 # loc - awake
    
    # find pvalue
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '모수 추정값'].tolist()
    indx1 =indx1[0]
    
    idxtmp=full_sheet.loc[indx1+4,'Unnamed: 0']
    if idxtmp=='[con_state=1]':
        pval=full_sheet.loc[indx1+4,'Unnamed: 7']
    else:
        print('p val ERROR!!!!!!!!!')
    
    # find corr N and value
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '상관행렬 차원'].tolist()      
    indx1 =indx1[0]
    ncorr=full_sheet.loc[indx1,'Unnamed: 3'] # row number of corr matrix
    
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '상관행렬 작업'].tolist()
    if len(indx1)==0:
        indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '상관행렬 작업a'].tolist()
    indx1 =indx1[0]
    idxtmp=full_sheet.loc[indx1+4,'Unnamed: 0']
    if idxtmp=='2':
        corrval=full_sheet.loc[indx1+4,'Unnamed: 1']
    else:
        print('corr ERROR!!!!!!!!!')
    
    subresult=np.array([nsub, ndata, mean1, mean2, mean3, pval, ncorr/2, ncorr, corrval])
    subresult=subresult.reshape(1,9)
    
    return subresult

def rsns(connect,fband,nrsn):
    import numpy as np
    import pandas as pd
    
    full_sheet = ("E:\\#ECoGconsciousness\\Connect\\all\\" + connect + "\\rsn2\\lnresults\\" + fband + '\\' + connect + '_' + fband + '_' + nrsn + '.xlsx')
    #full_sheet = ("E:\\#ECoGconsciousness\\Connect\\all\\" + connect + "\\rsn\\lnresults\\" + fband + '\\' + connect + '_' + fband + '_' + nrsn + '.xlsx')
    full_sheet = pd.read_excel(full_sheet)
    
    if nrsn=='DMNSMN' or nrsn=='DMNFPN' or nrsn=='SMNVAN':
        contains_string = full_sheet['Unnamed: 0'].str.contains('!GEE_lnconnect_4bigdata iPath', na=False)
    else:
        contains_string = full_sheet['Unnamed: 0'].str.contains('!GEE_lnconnect iPath', na=False)
    indx1 = full_sheet.index[contains_string].tolist()
    indx1 =indx1[0]
        
    if nrsn in str(full_sheet.loc[indx1, 'Unnamed: 0']):
        print(f"{nrsn} is in the string")
    else:
        raise ValueError(f"{nrsn} is not in the string ERROR!!!!!!!!!")
    
    # find number of subject
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '상관 데이터 요약'].tolist()
    indx1 =indx1[0]
    
    idxtmp=full_sheet.loc[indx1+1,'Unnamed: 2']
    if idxtmp=='subject':
        nsub=full_sheet.loc[indx1+1,'Unnamed: 3']
    else:
        print('nsub ERROR!!!!!!!!!')
    
    # find data Number
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '범주형 변수 정보'].tolist()
    indx1 =indx1[0]
    
    idxtmp=full_sheet.loc[indx1+1,'Unnamed: 3']
    if idxtmp=='N':
        ndata=full_sheet.loc[indx1+2,'Unnamed: 3']
    else:
        print('N ERROR!!!!!!!!!')
        
    # find mean value during states
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '추정 주변 평균: con_state'].tolist()
    indx1 =indx1[0]
    
    idxtmp=full_sheet.loc[indx1+5,'Unnamed: 0']
    idxtmp2=full_sheet.loc[indx1+6,'Unnamed: 0']
    
    if idxtmp=='1' and idxtmp2=='2':
       mean1=full_sheet.loc[indx1+5,'Unnamed: 1']
       mean2=full_sheet.loc[indx1+6,'Unnamed: 1']
    else:
       print('mean ERROR!!!!!!!!!')
    
    # diff mean between states
    mean3=mean2-mean1 # loc - awake
    
    # find pvalue
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '모수 추정값'].tolist()
    indx1 =indx1[0]
    
    idxtmp=full_sheet.loc[indx1+4,'Unnamed: 0']
    if idxtmp=='[con_state=1]':
        pval=full_sheet.loc[indx1+4,'Unnamed: 7']
    else:
        print('p val ERROR!!!!!!!!!')
    
    # find corr N and value     
    if nrsn=='DMNSMN' or nrsn=='DMNFPN' or nrsn=='SMNVAN':
       big_sheet = ("E:\\#ECoGconsciousness\\Connect\\all\\rsn2_biginfo.xlsx")
       big_sheet = pd.read_excel(big_sheet) 
       indx1 = big_sheet.index[big_sheet['Unnamed: 0'] == connect].tolist()
       indx1 =indx1[0]
       nf = int(''.join(filter(str.isdigit, fband)))
              
       if nrsn=='DMNSMN': idxrsn=indx1+2
       elif nrsn=='DMNFPN': idxrsn=indx1+3
       elif nrsn=='SMNVAN': idxrsn=indx1+4
       
       ncorr=big_sheet.loc[idxrsn,'Unnamed: 1']
       corrval=big_sheet.loc[idxrsn,'Unnamed: '+ str(2*nf)]        
    else:
        indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '상관행렬 차원'].tolist()      
        indx1 =indx1[0]
        ncorr=full_sheet.loc[indx1,'Unnamed: 3'] # row number of corr matrix
        
        indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '상관행렬 작업'].tolist()
        if len(indx1)==0:
            indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '상관행렬 작업a'].tolist()
        indx1 =indx1[0]
        idxtmp=full_sheet.loc[indx1+4,'Unnamed: 0']
        if idxtmp=='2':
            corrval=full_sheet.loc[indx1+4,'Unnamed: 1']
        else:
            print('corr ERROR!!!!!!!!!')
    
    subresult=np.array([nsub, ndata, mean1, mean2, mean3, pval, ncorr/2, ncorr, corrval])
    subresult=subresult.reshape(1,9)
    
    return subresult

def lobe(connect,fband,nlobe):
    import numpy as np
    import pandas as pd
    
    full_sheet = ("E:\\#ECoGconsciousness\\Connect\\all\\" + connect + "\\lobe\\lnresults\\" + fband + '\\' + connect + '_' + fband + '_' + nlobe + '.xlsx')
    full_sheet = pd.read_excel(full_sheet)
    
    if nlobe=='frontalparietal' or nlobe=='parietalsenmotor':
        contains_string = full_sheet['Unnamed: 0'].str.contains('!GEE_lnconnect_4bigdata iPath', na=False)
    else:
        contains_string = full_sheet['Unnamed: 0'].str.contains('!GEE_lnconnect iPath', na=False)
    indx1 = full_sheet.index[contains_string].tolist()
    indx1 =indx1[0]
        
    if nlobe in str(full_sheet.loc[indx1, 'Unnamed: 0']):
        print(f"{nlobe} is in the string")
    else:
        raise ValueError(f"{nlobe} is not in the string ERROR!!!!!!!!!")
    
    # find number of subject
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '상관 데이터 요약'].tolist()
    indx1 =indx1[0]
    
    idxtmp=full_sheet.loc[indx1+1,'Unnamed: 2']
    if idxtmp=='subject':
        nsub=full_sheet.loc[indx1+1,'Unnamed: 3']
    else:
        print('nsub ERROR!!!!!!!!!')
    
    # find data Number
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '범주형 변수 정보'].tolist()
    indx1 =indx1[0]
    
    idxtmp=full_sheet.loc[indx1+1,'Unnamed: 3']
    if idxtmp=='N':
        ndata=full_sheet.loc[indx1+2,'Unnamed: 3']
    else:
        print('N ERROR!!!!!!!!!')
        
    # find mean value during states
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '추정 주변 평균: con_state'].tolist()
    indx1 =indx1[0]
    
    idxtmp=full_sheet.loc[indx1+5,'Unnamed: 0']
    idxtmp2=full_sheet.loc[indx1+6,'Unnamed: 0']
    
    if idxtmp=='1' and idxtmp2=='2':
       mean1=full_sheet.loc[indx1+5,'Unnamed: 1']
       mean2=full_sheet.loc[indx1+6,'Unnamed: 1']
    else:
       print('mean ERROR!!!!!!!!!')
    
    # diff mean between states
    mean3=mean2-mean1 # loc - awake
    
    # find pvalue
    indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '모수 추정값'].tolist()
    indx1 =indx1[0]
    
    idxtmp=full_sheet.loc[indx1+4,'Unnamed: 0']
    if idxtmp=='[con_state=1]':
        pval=full_sheet.loc[indx1+4,'Unnamed: 7']
    else:
        print('p val ERROR!!!!!!!!!')
    
    # find corr N and value     
    if nlobe=='frontalparietal' or nlobe=='parietalsenmotor':
       big_sheet = ("E:\\#ECoGconsciousness\\Connect\\all\\lobe_biginfo.xlsx")
       big_sheet = pd.read_excel(big_sheet) 
       indx1 = big_sheet.index[big_sheet['Unnamed: 0'] == connect].tolist()
       indx1 =indx1[0]
       nf = int(''.join(filter(str.isdigit, fband)))
              
       if nlobe=='frontalparietal': idxlobe=indx1+2
       elif nlobe=='parietalsenmotor': idxlobe=indx1+3
              
       ncorr=big_sheet.loc[idxlobe,'Unnamed: 1']
       corrval=big_sheet.loc[idxlobe,'Unnamed: '+ str(2*nf)]        
    else:
        indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '상관행렬 차원'].tolist()      
        indx1 =indx1[0]
        ncorr=full_sheet.loc[indx1,'Unnamed: 3'] # row number of corr matrix
        
        indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '상관행렬 작업'].tolist()
        if len(indx1)==0:
            indx1 = full_sheet.index[full_sheet['Unnamed: 0'] == '상관행렬 작업a'].tolist()
        indx1 =indx1[0]
        idxtmp=full_sheet.loc[indx1+4,'Unnamed: 0']
        if idxtmp=='2':
            corrval=full_sheet.loc[indx1+4,'Unnamed: 1']
        else:
            print('corr ERROR!!!!!!!!!')
    
    subresult=np.array([nsub, ndata, mean1, mean2, mean3, pval, ncorr/2, ncorr, corrval])
    subresult=subresult.reshape(1,9)
    
    return subresult