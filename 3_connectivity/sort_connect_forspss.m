function sort_connect_forspss(nfreq,connect)

% example
% nfreq=1; %delta
% connect='aec'; %aec,wpli,coh

%% settings
fname={'Delta','Theta','Alpha','Beta','LG','HG'};
cd(['E:\#ECoGconsciousness\Connect\all\' connect '\BAch'])
s1=['load BAchall_' connect '_' num2str(nfreq) fname{nfreq} '_rest.mat']; eval(s1)

list_roi=fieldnames(BAchdata);
for rr=1:length(list_roi)
    ROIs=list_roi{rr};
    s1=['roidata=BAchdata.' ROIs ';']; eval(s1)
    s1=['subroi=BAchlabel.' ROIs ';']; eval(s1)
    if isempty(subroi)
       subroi=string([]);
    else subroi=subroi(:,1); subroi=unique(subroi);
    end

    r1=ROIs([1:floor(length(ROIs)/2)]); r2=ROIs([floor(length(ROIs)/2+1):length(ROIs)]);
    
    if size(subroi,1)<=1 || size(roidata,1)<=1 % subject length=<1 or data length=<1
    elseif string(r1)==string(r2) % except same ROIs
    else
        % conscious
        cd(['E:\#ECoGconsciousness\Connect\all\' connect '\BAch'])
        s1=['load BAchall_' connect '_' num2str(nfreq) fname{nfreq} '_rest.mat']; eval(s1)
        s1=['list=BAchlabel.' ROIs ';']; eval(s1)
        s1=['tmpdata(:,1)=BAchdata.' ROIs ';']; eval(s1)
        s1=['tmpdata(:,2)=lnBAchdata.' ROIs ';']; eval(s1)
        s1=['tmpdata(:,3)=zBAchdata.' ROIs ';']; eval(s1)

        roisdata1=string([]);
        for ss=1:size(list,1)
            nsubtmp=list(ss,1); nsubtmp = strrep(nsubtmp,"_",".");            
            roisdata1(ss,1)=nsubtmp;
            roisdata1(ss,2)=1; % rest=1, loc=2    
            roisdata1(ss,3:4)=list(ss,2:3);
            roisdata1(ss,5:7)=tmpdata(ss,1:3);           
        end
        roisdata1=double(roisdata1); roisdata1(:,1)=floor(roisdata1(:,1)); 
        clearvars tmpdata list

        % unconscious
        cd(['E:\#ECoGconsciousness\Connect\all\' connect '\BAch'])
        s1=['load BAchall_' connect '_' num2str(nfreq) fname{nfreq} '_loc.mat']; eval(s1)
        s1=['list=BAchlabel.' ROIs ';']; eval(s1)
        s1=['tmpdata(:,1)=BAchdata.' ROIs ';']; eval(s1)
        s1=['tmpdata(:,2)=lnBAchdata.' ROIs ';']; eval(s1)
        s1=['tmpdata(:,3)=zBAchdata.' ROIs ';']; eval(s1)

        roisdata2=string([]);
        for ss=1:size(list,1)
            nsubtmp=list(ss,1); nsubtmp = strrep(nsubtmp,"_",".");            
            roisdata2(ss,1)=nsubtmp;
            roisdata2(ss,2)=2; % rest=1, loc=2    
            roisdata2(ss,3:4)=list(ss,2:3);
            roisdata2(ss,5:7)=tmpdata(ss,1:3);           
        end
        roisdata2=double(roisdata2); roisdata2(:,1)=floor(roisdata2(:,1));    
        roisdata=[roisdata1; roisdata2];
        %% save file
        cd(['E:\#ECoGconsciousness\Connect\all\' connect '\statspss\data\' num2str(nfreq) fname{nfreq}])
        s1=['save -v7.3 ' connect '_' num2str(nfreq) fname{nfreq} '_' ROIs '.mat roisdata']; eval(s1);
    end
    clearvars roisdata roisdata1 roisdata2 nsubtmp roidata subroi tmpdata list  
end
    fprintf(['... done....\n']);
end
