function analy_psd_fband(fset,stud)

% example
% fset='all';  % group analysis: all elect
% fset='BA'; % group analysis: BA elect
% fset='lobe2';
% stud='loc'; 
% Mikyung Choe, 2024

%% default settings
% delta (1-3Hz), theta (4-7Hz), alpha (8-12Hz), beta (13-30Hz), LG (30-90Hz), HG (90-140Hz)
fband1={'Delta','Theta','Alpha','Beta','Low gamma','High gamma'}';
fband2={[1:3],[4:7],[8:12],[13:30],[30:59 61:90],[90:119 121:140]}'; % except 60, 120 Hz
fband=[fband1 fband2]; clear fband1 fband2

% load apsd files
cd(['E:\#ECoGconsciousness\Connect\all\psdwel'])
load([fset '_apsd_4loc.mat'])

%%
if strcmp(fset,'all')   
   totalfpsd=[]; ffgroup=[];
   position = [1:3*size(fband,1)]; position([3:3:3*size(fband,1)])=[];
    for ff=1:size(fband,1)                
        [rr,~]=find(rfreq==fband{ff,2});
        tmpawpsd=squeeze(allap(1,rr,:)); tmplocpsd=squeeze(allap(2,rr,:));
        awpsd=mean(tmpawpsd,1)'; locpsd=mean(tmplocpsd,1)';
        logawpsd=10*log10(awpsd); loglocpsd=10*log10(locpsd); 
        
        [allp(ff,1),~]=signrank(awpsd, locpsd,'Alpha',0.05); 
        [logallp(ff,1),~]=signrank(logawpsd, loglocpsd,'Alpha',0.05);
        
        allsp(ff,1)=allp(ff,1)*sign(median(locpsd)-median(awpsd)); 
        logallsp(ff,1)=logallp(ff,1)*sign(median(loglocpsd)-median(logawpsd));      
        
        totalfpsd=[totalfpsd; logawpsd; loglocpsd];
        gaw=repmat(2*ff-1,length(awpsd),1); gloc=repmat(2*ff,length(locpsd),1); ffgroup=[ffgroup; gaw; gloc];
    end
    % save file
    cd(['E:\#ECoGconsciousness\Connect\all\psdwel'])
    s1=['save all_psdf_wilc_4' stud '.mat allp logallp allsp logallsp wfreq rfreq']; eval(s1)   
    % boxplot
    figure()   
    boxplot(totalfpsd,ffgroup,'positions',position)    % totalfpsd = log value
    color = repmat([0.8500 0.3250 0.0980; 0 0.4470 0.7410],size(fband,1),1);
    h = findobj(gca,'Tag','Box');
    for j=1:length(h)
        patch(get(h(j),'XData'),get(h(j),'YData'),color(j,:),'FaceAlpha',.5);
    end  
    xticloc = [1.5:3:3*size(fband,1)+1.5]; set(gca,'XTickLabel',fband(:,1),'XTick',xticloc);
    ylabel('PSD (dB/Hz)'); xlabel('Frequency (Hz)');    
    bx = findobj('Tag','boxplot');
    bxtmp=bx.Children; set(bxtmp,'LineWidth',2);
    c = get(gca, 'Children'); hleg1 = legend(c(1:2), 'Awake', 'Unconscious');
    set(gca,'FontSize',14,'FontWeight','bold','linewidth',2,'FontName','Arial');
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    % save boxplot
    cd(['E:\#ECoGconsciousness\Connect\all\psdwel\fig'])
    fname=['box_glog_fband_4' stud]; 
    saveas(gcf,fname, 'meta'); saveas(gcf,fname, 'png'); close(gcf); 

elseif strcmp(fset,'BA')
    for ff=1:size(fband,1)        
        [rr,~]=find(rfreq==fband{ff,2}); %lba=length(fieldnames(allbapsd));         
        listba=string({'SMA';'FEF';'DLPFC';'aPFC';'OFC';'IFG';'ITG';'MTG';'STG';'FuG';'TPC';'A1'; ... 
            'SPL';'AnG';'SMG';'V2';'V3_5';'S1';'M1';'GC';'PRC';'Amg';'Hi';'INS'});
        labelba=listba; lba=length(listba);
        position = [1:3*lba]; position([3:3:3*lba])=[];
        bagroup=[]; totalpsd=[];            
        for bba=1:lba           
            s1=['tmpawpsd=squeeze(' 'allbapsd.' listba{bba,1} '(1,rr,:));']; eval(s1)
            s1=['tmplocpsd=squeeze(' 'allbapsd.' listba{bba,1} '(2,rr,:));']; eval(s1)   
            
            awpsd=mean(tmpawpsd,1)'; locpsd=mean(tmplocpsd,1)';
            logawpsd=10*log10(awpsd); loglocpsd=10*log10(locpsd); 

            [allp(ff,bba),~]=signrank(awpsd, locpsd,'Alpha',0.05); 
            [logallp(ff,bba),~]=signrank(logawpsd, loglocpsd,'Alpha',0.05);

            allsp(ff,bba)=allp(ff,bba)*sign(median(locpsd)-median(awpsd)); 
            logallsp(ff,bba)=logallp(ff,bba)*sign(median(loglocpsd)-median(logawpsd));
            
            gaw=repmat(2*bba-1,length(awpsd),1); gloc=repmat(2*bba,length(locpsd),1); bagroup=[bagroup; gaw; gloc]; 
            totalpsd=[totalpsd; logawpsd; loglocpsd];  
        end
        figure()    
        boxplot(totalpsd,bagroup,'positions',position)  
        color = repmat([0.8500 0.3250 0.0980; 0 0.4470 0.7410],lba,1);
            h = findobj(gca,'Tag','Box');
        for j=1:length(h)
            patch(get(h(j),'XData'),get(h(j),'YData'),color(j,:),'FaceAlpha',.5);
        end  
        xticloc = [1.5:3:3*lba+1.5]; set(gca,'XTickLabel',labelba,'XTick',xticloc);
        ylabel('PSD (dB/Hz)'); %xlabel('Frequency (Hz)');
        name=fband{ff,1}; title(name,'FontSize',20,'FontWeight','bold','FontName','Arial');
        set(gca,'FontSize',16,'FontWeight','bold','linewidth',2,'FontName','Arial');
        bx = findobj('Tag','boxplot');
        bxtmp=bx.Children; set(bxtmp,'LineWidth',2);
        c = get(gca, 'Children'); hleg1 = legend(c(1:2), 'Conscious', 'Unconscious');
        if ff==1; ylim([0 55])
        elseif ff==2; ylim([-10 40])
        elseif ff==3; ylim([-10 40])
        elseif ff==4; ylim([-15 35])
        elseif ff==5; ylim([-30 20])
        elseif ff==6; ylim([-40 5])
        end   
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        % save boxplot
        cd(['E:\#ECoGconsciousness\Connect\all\psdwel\fig\BA\' stud])
        fname=['box_BAlog_' num2str(ff) fband{ff,1} '_4' stud]; 
        saveas(gcf,fname, 'png'); saveas(gcf,fname, 'meta'); close(gcf);  
    end
    % save file
    cd(['E:\#ECoGconsciousness\Connect\all\psdwel'])
    s1=['save BA_psdf_wilc_4' stud '.mat allp logallp allsp logallsp wfreq rfreq listba']; eval(s1) 

elseif strcmp(fset,'lobe2') 
    for ff=1:size(fband,1)     
        nlistl2=string({'frontal';'temporal';'parietal';'occipital';'senmotor';'limbic'});
        [rr,~]=find(rfreq==fband{ff,2});        
        position = [1:3*length(nlistl2)]; position([3,6,9,12,15,18])=[];
        l2group=[]; totalpsd=[];            
        
        for bba=1:length(nlistl2)                      
            s1=['tmpawpsd=squeeze(' 'l2psd.' nlistl2{bba,1} '(1,rr,:));']; eval(s1)
            s1=['tmplocpsd=squeeze(' 'l2psd.' nlistl2{bba,1} '(2,rr,:));']; eval(s1)   
            
            awpsd=mean(tmpawpsd,1)'; locpsd=mean(tmplocpsd,1)';
            logawpsd=10*log10(awpsd); loglocpsd=10*log10(locpsd); 

            [allp(ff,bba),~]=signrank(awpsd, locpsd,'Alpha',0.05); 
            [logallp(ff,bba),~]=signrank(logawpsd, loglocpsd,'Alpha',0.05);

            allsp(ff,bba)=allp(ff,bba)*sign(median(locpsd)-median(awpsd)); 
            logallsp(ff,bba)=logallp(ff,bba)*sign(median(loglocpsd)-median(logawpsd));
            
            gaw=repmat(2*bba-1,length(awpsd),1); gloc=repmat(2*bba,length(locpsd),1); l2group=[l2group; gaw; gloc]; 
            totalpsd=[totalpsd; logawpsd; loglocpsd];  
        end
        figure()    
        boxplot(totalpsd,l2group,'positions',position)  
        color = repmat([0.8500 0.3250 0.0980; 0 0.4470 0.7410],length(l2list),1);
            h = findobj(gca,'Tag','Box');
        for j=1:length(h)
            patch(get(h(j),'XData'),get(h(j),'YData'),color(j,:),'FaceAlpha',.5);
        end  
        xticloc = [1.5:3:16.5]; 
        namel2={'Frontal';'Temporal';'Parietal';'Occipital';'Sensorimotor';'Limbic'}; set(gca,'XTickLabel',namel2,'XTick',xticloc);
        ylabel('PSD (dB/Hz)'); %xlabel('Frequency (Hz)');
        name=fband{ff,1}; %title(name,'FontSize',14,'FontWeight','bold','FontName','Arial');
        set(gca,'FontSize',7,'linewidth',1,'FontName','Arial');
        %set(gca,'FontSize',14,'FontWeight','bold','linewidth',2,'FontName','Arial');
        bx = findobj('Tag','boxplot');
        bxtmp=bx.Children; set(bxtmp,'LineWidth',1);
        c = get(gca, 'Children'); hleg1 = legend(c(1:2), 'Awake', 'Unconscious');
        if ff==1; ylim([0 55])
        elseif ff==2; ylim([-10 40])
        elseif ff==3; ylim([-10 40])
        elseif ff==4; ylim([-15 35])
        elseif ff==5; ylim([-30 20])
        elseif ff==6; ylim([-40 5])
        end                       
        %set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        set(gcf,'units','normalized','outerposition',[0 0 0.25 0.5]);
        
        % save boxplot
        cd(['E:\#ECoGconsciousness\Connect\all\psdwel\fig\lobe\' stud])
        fname=['box_lobe2log_' num2str(ff) fband{ff,1} '_4' stud]; 
        saveas(gcf,fname, 'png'); saveas(gcf,fname, 'meta'); close(gcf);
    end
    % save file
    cd(['E:\#ECoGconsciousness\Connect\all\psdwel'])
    s1=['save lobe2_psdf_wilc_4' stud '.mat allp logallp allsp logallsp wfreq rfreq nlistl2 namel2']; eval(s1) 
end

end