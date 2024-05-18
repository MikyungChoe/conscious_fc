function avgpsd_loc(subno,stud)

% example: avgpsd_loc('03','loc')
% subno='01'; stud='loc'; stud='prop';
% Mikyung Choe, 2024

%% setting, load electrode info file
direct=['E:\#ECoGconsciousness\Connect\sub' subno];    
cd([direct])
if string(stud)=="loc"
    cond={'rest','loc'};
    load (['sub' subno '_electinfo_4loc.mat'])
    %load (['sub' subno '_electinfo_4locBA23.mat'])
else
    cond={'rest','propofol3','propofol4','propofol5'};
    load (['sub' subno '_electinfo_4prop.mat'])
end
load(['D:\#ECoGconsciousness\ECoG electrode\BA_list4connect.mat']); l2list=unique(balist(:,3));
%load(['D:\#ECoGconsciousness\ECoG electrode\BAlist4netstd.mat']); l2list=unique(balist(:,4));
%% sub psd
for ncd=1:length(cond)
    cd([direct '\psdwel\'])
    load (['sub' subno '_psdwel_' cond{ncd} '.mat'])
    
    [rba,~]=size(subBAlist); [~,fband]=size(wpsd); 
    %[rba,~]=size(subBA23list); [~,fband]=size(wpsd); 
    allch=[]; bapsd=NaN(rba,fband); %stdbapsd=NaN(rba,fband);
    for i=1:rba
        chl=subBAlist{i,4}'; % chl=subBA23list{i,4}';
        allch=[allch; chl];
        bapsdtmp1=wpsd(chl,:); bapsdtmp2=mean(bapsdtmp1,1); %stdbatmp2=std(bapsdtmp1,0,1);        
        bapsd(i,:)=bapsdtmp2; %stdbapsd(i,:)=stdbatmp2;        
    end
    allch=sort(allch); allpsd=mean(wpsd(allch,:)); %stdallpsd=std(wpsd(allch,:));
    
    % make lobe2 ap
    lobe2psd=[];
    for il=1:length(l2list)
        tmp=find(l2list(il)==balist(:,3)); tmp=balist(tmp,2);
        %tmp=find(l2list(il)==balist(:,4)); tmp=balist(tmp,3);
        lobe2p=[];
        for il2=1:length(tmp)
            subba=find(string(subBAlist(:,3))==tmp(il2));
            %subba=find(string(subBA23list(:,3))==tmp(il2));
            lobe2p=[lobe2p; bapsd(subba,:)];
        end
        lobe2ptmp=mean(lobe2p,1);
        lobe2psd=[lobe2psd; lobe2ptmp];
    end

    % save psd file
    %s1=['save -v7.3 sub' subno '_apsd_' cond{ncd} '_4' stud '.mat wfreq allpsd bapsd stdallpsd stdbapsd']; eval(s1);
    s1=['save -v7.3 sub' subno '_apsd_' cond{ncd} '_4' stud '.mat wfreq l2list allpsd bapsd lobe2psd']; eval(s1);
    
    fprintf(['...ALL BA PSD Sub' subno ' ' cond{ncd} ' 4' stud ' saved....\n']);
end
fprintf(['...PSD Sub' subno ' 4' stud ' done....\n']);

end