function set_rejch_locdata(subno,nfile)
% for neuroscan file (except grass, labeled file)
% example: set_rejch_locdata('03','loc')
% subno='01'; nfile='loc';

% Created by Mikyung Choe, 2024

    cd(['D:\#ECoGconsciousness\ECoG electrode\Loc_Con\raw'])
    load numelectrode_raw.mat
    
    %% sub no (double ver.)
    if contains(subno,'_')
       dsub = str2double(strrep(subno,'_','.'));
    else dsub=str2double(subno);
    end    

    %% load data
    direct=['E:\#ECoGconsciousness\Connect\\sub' subno];    
    cd([direct '\raw\'])
    
    s1=['load sub' subno '_' nfile '.dat;']; eval(s1); 
    s1=['dtmp = sub' subno '_' nfile ';']; eval(s1);
    s1=['clear sub' subno '_' nfile ';']; eval(s1);

    %% Channel num (raw)
    [nlist,~]=find(elenum(:,1)==dsub);
    rawch=elenum(nlist,2);

    %% 0. set chanrl
    [r,c]=size(dtmp); 
    test=(r==rawch);
    if test==1
        dtmp=dtmp(:,[2:c]);
    else predtmp=dtmp;
        dtmp = zeros(rawch, c-1);
        for i=1:r
            realch=predtmp(i,1);
            dtmp(realch,:)=predtmp(i,[2:c]);           
        end  
    end
    %%
    sfreq=500;
    % 1. Notch filter (60, 120, 180, 240 Hz)
    dtmp = NotchFilter_ryun(dtmp,sfreq,60);
    dtmp = NotchFilter_ryun(dtmp,sfreq,120);
    dtmp = NotchFilter_ryun(dtmp,sfreq,180);
    dtmp = NotchFilter_ryun(dtmp,sfreq,240);

    % 2. filtering < 200Hz (low pass filter) - canceled
    %[data]=eegfilt(dtmp,sfreq,0,200);
    data=dtmp;
    s1=['save -v7.3 sub' subno '_rafilt_' nfile '.mat data']; eval(s1);

fprintf(['...Sub ' subno ' ' nfile ' Done....\n']);
end
