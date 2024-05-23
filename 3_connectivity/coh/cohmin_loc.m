function cohmin_loc(subno)

% example: coh_loc_4min('01')
% subno='01';
% subno='36'; 

%% Except NaN channels (OBA or rejected)
Nsub=string(subno);
if contains(Nsub,"_")
   Nsub=replace(Nsub,"_","."); 
end
Nsub=str2num(Nsub);
direlect=['D:\#ECoGconsciousness\ECoG electrode\Loc_Con\study\'];
% Load electrode info
load([direlect 'loc4connect\Location_Data_sub' num2str(Nsub) '.mat'])
chlist=LocData(:,6);

%% Settings
NFFT=512; sfreq=500; lengf=0.5*NFFT+1;
cond={'rest','loc'};
direct=['E:\#ECoGconsciousness\Connect\sub' subno];    

% set data length for coh analysis
load([direct '\raw\sub' subno '_rafilt_rest.mat'])
drest=data; clear data
load([direct '\raw\sub' subno '_rafilt_loc.mat'])
dloc=data; clear data
lengdd=min(length(drest),length(dloc));
clear drest dloc

%% coh analysis
for cc=1:length(cond) 
    nfile=cond{cc};
    % load data
    load([direct '\raw\sub' subno '_rafilt_' nfile '.mat'])
    data=data(:,[1:lengdd]);
    [lengch,~]=size(data); dcoh=NaN(lengch,lengch,lengf);

    %% Coherence (MSC) (dcoh=ch*ch*freq)
    for chtmp1=1:length(chlist)
        ch1=chlist(chtmp1); % real ch no.
        cdata1=data(ch1,:);    
        if sum(cdata1)==0   
           error(['ERROR: 1st CH ' num2str(ch1) ' is REJECTED channel...\n']);
        else   
           for chtmp2=1:length(chlist)
               ch2=chlist(chtmp2); % real ch no.
               cdata2=data(ch2,:);  
               if sum(cdata2)==0
                error(['ERROR: 2nd CH ' num2str(ch2) ' is REJECTED channel...\n']);
               else
               [cohtmp,freq]=mscohere(cdata1,cdata2,hanning(NFFT),floor(NFFT*0.5),NFFT,sfreq);
                dcoh(ch1,ch2,:)=cohtmp;                   
               end
           end
        end
    end

    %% Averaged Coh (fcoh=ch*ch*6 freq bands)
    % delta (1-3Hz), theta (4-7Hz), alpha (8-12Hz), beta (13-30Hz), LG (30-90Hz, except 60Hz), HG (90-140Hz, except 120Hz)
    fband1={'Delta','Theta','Alpha','Beta','LG','HG'}';
    fband2={[1:3],[4:7],[8:12],[13:30],[30:59 61:90],[90:119 121:140]}';
    fband=[fband1 fband2]; clear fband1 fband2
    rfreq=round(freq); fcoh=zeros(lengch,lengch,length(fband));

    for ff=1:length(fband)    
        [rr,~]=find(rfreq==fband{ff,2});
        fcohtmp=dcoh(:,:,rr);
        fcoh(:,:,ff)=mean(fcohtmp,3);
    end

    %% save file
    cd([direct '\coh\'])
    s1=['save -v7.3 sub' subno '_cohmin_' nfile '.mat dcoh fcoh freq rfreq fband lengdd']; eval(s1);
    fprintf(['...Coh Sub' subno ' ' nfile ' saved....\n']);

    %% Plot Coh matrix
    % all freq ver.
    fl=find(rfreq==140); % 1 ~ 140 Hz
    for i=2:fl    
        imagesc(squeeze(dcoh(:,:,i)),'AlphaData',~isnan(squeeze(dcoh(:,:,i)))); colormap(jet); caxis([0 1]); colorbar;    
        name=['Sub' subno ' ' num2str(rfreq(i)) 'Hz']; title(name,'FontSize',12);    
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);

        % save matrix fig
        cd([direct '\coh\figminver\' nfile]); fname=['dcoh_sub' subno '_' num2str(i)];
        saveas(gcf,fname, 'png'); close(gcf); 
    end

    % freq band ver.
    for ff=1:length(fband)    
        imagesc(squeeze(fcoh(:,:,ff)),'AlphaData',~isnan(squeeze(fcoh(:,:,ff)))); colormap(jet); caxis([0 1]); colorbar; 
        name=['Sub' subno ' ' fband{ff,1}]; title(name,'FontSize',12);    
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);

        % save matrix fig
        cd([direct '\coh\figminver\' nfile]); fname=['fcoh_sub' subno '_' num2str(ff) fband{ff,1}];
        saveas(gcf,fname, 'png'); close(gcf); 
    end
end
    fprintf(['+++ Coh sub ' subno ' done.... +++\n']);        
end