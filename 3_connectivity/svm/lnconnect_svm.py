# -*- coding: utf-8 -*-
"""
Created on Thu Feb  1 22:15:42 2024

@author: Mikyung Choe / Jii Kwon
"""

def svmfband_cv(connect,fband,rois):

    import numpy as np
    from sklearn.model_selection import KFold
    from sklearn.svm import SVC
    from sklearn.metrics import accuracy_score
    from sklearn.model_selection import train_test_split, cross_val_score
    from collections import Counter
    import os
    import mat73
    import scipy.io
    from scipy.io import savemat
    import h5py
    from sklearn.metrics import balanced_accuracy_score
    
    # Assuming con and unc are your datasets (features and labels)
    # Let's say each dataset is a tuple (X, y) where X is the features and y is the labels
    
    os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\" + connect + "\\statspss\\data\\" + fband)
    
    nmat=(connect+ "_" + fband + "_" + rois + ".mat")
    
    with h5py.File(nmat, 'r') as file:
        #print(list(file.keys()))
        roisdata = file['roisdata'][:]
        #print(roisdata.shape)
        
    #msvmacc=np.empty((1, 20))
    svmacc=[]    
    for i in range(20):
        labels = roisdata[1, :]
        features = roisdata[5, :]
        features = features.reshape(-1, 1)
        
        X=features
        y=labels
        
        # Initialize 5-fold cross-validation
        kf = KFold(n_splits=5, shuffle=True, random_state=i)
        
        # Initialize SVM
        #svm = SVC()
        svm_model = SVC(kernel='rbf')  # default='rbf'        
        accuracies = []
        
        # Perform 5-fold cross validation
        for train_index, test_index in kf.split(X):
            # Split data
            X_train, X_test = X[train_index], X[test_index]
            y_train, y_test = y[train_index], y[test_index]

            # Train the model
            svm_model.fit(X_train, y_train)

            # Make predictions
            y_pred = svm_model.predict(X_test)

            # Calculate accuracy
            accuracy = accuracy_score(y_test, y_pred)
            accuracies.append(accuracy)

        # Average accuracy across all folds
        #msvmacc[0,i] = np.mean(accuracies)
        svmacc.extend(accuracies)
        
    acc_mean = np.mean(svmacc)
    acc_std = np.std(svmacc)
    return acc_mean, acc_std  

def svmfband_rsn_CV(connect,fband,rsns):

    import numpy as np
    from sklearn.model_selection import KFold
    from sklearn.svm import SVC
    from sklearn.metrics import accuracy_score
    from sklearn.model_selection import train_test_split, cross_val_score
    from collections import Counter
    import os
    import mat73
    import scipy.io
    from scipy.io import savemat
    import h5py
    from sklearn.metrics import balanced_accuracy_score
    
    # Assuming con and unc are your datasets (features and labels)
    # Let's say each dataset is a tuple (X, y) where X is the features and y is the labels
    
    os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\" + connect + "\\rsn\\data\\" + fband)
        
    nmat=(connect+ "_" + fband + "_" + rsns + ".mat")
    
    with h5py.File(nmat, 'r') as file:
        #print(list(file.keys()))
        rsnsdata = file['rsnsdata'][:]
        #print(roisdata.shape)
        
    #msvmacc=np.empty((1, 20))
    svmacc=[]    
    for i in range(20):
        labels = rsnsdata[1, :] # con=1, uncon=2
        features = rsnsdata[5, :] # ln(connect)
        features = features.reshape(-1, 1)
        
        X=features
        y=labels
        
        # Initialize 10-fold cross-validation
        kf = KFold(n_splits=10, shuffle=True, random_state=i) # random_state: tag(?)
        
        # Initialize SVM
        #svm = SVC()
        svm_model = SVC(kernel='rbf')  # default='rbf'        
        accuracies = []
        
        # Perform 10-fold cross validation
        for train_index, test_index in kf.split(X):
            # Split data
            X_train, X_test = X[train_index], X[test_index]
            y_train, y_test = y[train_index], y[test_index]

            # Train the model
            svm_model.fit(X_train, y_train)

            # Make predictions
            y_pred = svm_model.predict(X_test)

            # Calculate accuracy
            accuracy = accuracy_score(y_test, y_pred)
            accuracies.append(accuracy)

        # Average accuracy across all folds
        #msvmacc[0,i] = np.mean(accuracies)
        svmacc.extend(accuracies)
        
    acc_mean = np.mean(svmacc)
    acc_std = np.std(svmacc)
    return acc_mean, acc_std        

def svmfband_rsn(connect,fband,rsns,fig_name, threshold=4):
    
    # without cross validation. test=1 subject training=other subjects
    import numpy as np
    from sklearn.model_selection import KFold
    from sklearn.svm import SVC
    from sklearn.metrics import accuracy_score
    from sklearn.model_selection import train_test_split, cross_val_score
    from collections import Counter
    import os
    import mat73
    import scipy.io
    from scipy.io import savemat
    import h5py
    from sklearn.metrics import balanced_accuracy_score
    import seaborn as sns
    import matplotlib.pyplot as plt
    # Assuming con and unc are your datasets (features and labels)
    # Let's say each dataset is a tuple (X, y) where X is the features and y is the labels
    
    # examples
    # connect='aec'
    # fband='1Delta'
    # rsns='ANDAN'
    
    os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\" + connect + "\\rsn\\data\\" + fband)       
    nmat=(connect+ "_" + fband + "_" + rsns + ".mat")
    
    with h5py.File(nmat, 'r') as file:
        #print(list(file.keys()))
        rsnsdata = file['rsnsdata'][:]
        #print(roisdata.shape)
    sublist=list(set(rsnsdata[0, :]))
    
    svmacc=[]
    for i in sublist:
        subidx_test=np.where(rsnsdata[0, :]==i)               
        
        subdata_test=np.squeeze(rsnsdata[:,subidx_test])
        subdata_train = np.delete(rsnsdata, subidx_test , axis = 1)
        
        if subdata_test.shape[1] < threshold : 
            print('sublist '+ str(i) + ' pass: '+ str(subdata_test.shape[1]))
            continue
        
        # training
        labels = subdata_train[1, :] # con=1, uncon=2
        features = subdata_train[5, :] # ln(connect)
        features = features.reshape(-1, 1)
        
        # test set
        y_test = subdata_test[1,:]
        X_test = subdata_test[5,:]
        X_test = X_test.reshape(-1, 1)
        
        
        svm_model = SVC(kernel='rbf')
        svm_model.fit(features, labels)
        y_pred = svm_model.predict(X_test)
        accuracy = accuracy_score(y_test, y_pred)
        svmacc.append(accuracy)
        
        print('sublist '+ str(i) + ' : '+ str(round(accuracy,2)*100) + '% - #trial:' + str(X_test.shape[0]))
    
    os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\" + connect + "\\rsn\\svm\\" + fband)
    plt.figure()
    sns.histplot(svmacc)    
    plt.savefig(fig_name, dpi=300)
    plt.clf()
    
    acc_mean = np.mean(svmacc)
    acc_std = np.std(svmacc)
    acc_median = np.median(svmacc)
    
    return svmacc, acc_mean, acc_std, acc_median

def svmfband_rsn2(connect,fband,rsns,fig_name, threshold=4):
    
    # without cross validation. test=1 subject training=other subjects
    import numpy as np
    from sklearn.model_selection import KFold
    from sklearn.svm import SVC
    from sklearn.metrics import accuracy_score
    from sklearn.model_selection import train_test_split, cross_val_score
    from collections import Counter
    import os
    import mat73
    import scipy.io
    from scipy.io import savemat
    import h5py
    from sklearn.metrics import balanced_accuracy_score
    import seaborn as sns
    import matplotlib.pyplot as plt
    # Assuming con and unc are your datasets (features and labels)
    # Let's say each dataset is a tuple (X, y) where X is the features and y is the labels
    
    # examples
    # connect='aec'
    # fband='1Delta'
    # rsns='ANDAN'
    
    os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\" + connect + "\\rsn2\\data\\" + fband)       
    nmat=(connect+ "_" + fband + "_" + rsns + ".mat")
    
    with h5py.File(nmat, 'r') as file:
        #print(list(file.keys()))
        rsnsdata = file['rsnsdata'][:]
        #print(roisdata.shape)
    sublist=list(set(rsnsdata[0, :]))
    
    svmacc=[]
    for i in sublist:
        subidx_test=np.where(rsnsdata[0, :]==i)               
        
        subdata_test=np.squeeze(rsnsdata[:,subidx_test])
        subdata_train = np.delete(rsnsdata, subidx_test , axis = 1)
        
        if subdata_test.shape[1] < threshold : 
            print('sublist '+ str(i) + ' pass: '+ str(subdata_test.shape[1]))
            continue
        
        # training
        labels = subdata_train[1, :] # con=1, uncon=2
        features = subdata_train[5, :] # ln(connect)
        features = features.reshape(-1, 1)
        
        # test set
        y_test = subdata_test[1,:]
        X_test = subdata_test[5,:]
        X_test = X_test.reshape(-1, 1)
        
        
        svm_model = SVC(kernel='rbf')
        svm_model.fit(features, labels)
        y_pred = svm_model.predict(X_test)
        accuracy = accuracy_score(y_test, y_pred)
        svmacc.append(accuracy)
        
        print('sublist '+ str(i) + ' : '+ str(round(accuracy,2)*100) + '% - #trial:' + str(X_test.shape[0]))
    
    os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\" + connect + "\\rsn2\\svm\\" + fband)
    plt.figure()
    sns.histplot(svmacc)    
    plt.savefig(fig_name, dpi=300)
    plt.clf()
    
    acc_mean = np.mean(svmacc)
    acc_std = np.std(svmacc)
    acc_median = np.median(svmacc)
    
    return svmacc, acc_mean, acc_std, acc_median

def svmfband_lobe(connect,fband,lobs,fig_name, threshold=4):
    
    # without cross validation. test=1 subject training=other subjects
    import numpy as np
    from sklearn.model_selection import KFold
    from sklearn.svm import SVC
    from sklearn.metrics import accuracy_score
    from sklearn.model_selection import train_test_split, cross_val_score
    from collections import Counter
    import os
    import mat73
    import scipy.io
    from scipy.io import savemat
    import h5py
    from sklearn.metrics import balanced_accuracy_score
    import seaborn as sns
    import matplotlib.pyplot as plt
    # Assuming con and unc are your datasets (features and labels)
    # Let's say each dataset is a tuple (X, y) where X is the features and y is the labels
    
    # examples
    # connect='aec'
    # fband='1Delta'
    # lobs='frontalparietal'
    
    os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\" + connect + "\\lobe\\data\\" + fband)       
    nmat=(connect+ "_" + fband + "_" + lobs + ".mat")
    
    with h5py.File(nmat, 'r') as file:
        #print(list(file.keys()))
        lobsdata = file['lobsdata'][:]
        #print(roisdata.shape)
    sublist=list(set(lobsdata[0, :]))
    
    svmacc=[]
    for i in sublist:
        subidx_test=np.where(lobsdata[0, :]==i)               
        
        subdata_test=np.squeeze(lobsdata[:,subidx_test])
        subdata_train = np.delete(lobsdata, subidx_test , axis = 1)
        
        if subdata_test.shape[1] < threshold : 
            print('sublist '+ str(i) + ' pass: '+ str(subdata_test.shape[1]))
            continue
        
        # training
        labels = subdata_train[1, :] # con=1, uncon=2
        features = subdata_train[5, :] # ln(connect)
        features = features.reshape(-1, 1)
        
        # test set
        y_test = subdata_test[1,:]
        X_test = subdata_test[5,:]
        X_test = X_test.reshape(-1, 1)
        
        
        svm_model = SVC(kernel='rbf')
        svm_model.fit(features, labels)
        y_pred = svm_model.predict(X_test)
        accuracy = accuracy_score(y_test, y_pred)
        svmacc.append(accuracy)
        
        print('sublist '+ str(i) + ' : '+ str(round(accuracy,2)*100) + '% - #trial:' + str(X_test.shape[0]))
    
    os.chdir("E:\\#ECoGconsciousness\\Connect\\all\\" + connect + "\\lobe\\svm\\" + fband)
    plt.figure()
    sns.histplot(svmacc)    
    plt.savefig(fig_name, dpi=300)
    plt.clf()
    
    acc_mean = np.mean(svmacc)
    acc_std = np.std(svmacc)
    acc_median = np.median(svmacc)
    
    return svmacc, acc_mean, acc_std, acc_median