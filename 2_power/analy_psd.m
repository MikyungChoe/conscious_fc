function analy_psd(fset,stud)

% example
% fset='all';  % group analysis: all elect
% fset='BA'; % group analysis: BA elect
% fset='lobe'; 
% fset='lobe2';
% fset='01'; % subject ver: plot psd
% stud='loc'; stud='prop';
% analy_psd('all','loc')
% Mikyung Choe, 2024

%% default settings
if string(stud)=="loc" % set condition for study
   cond={'rest','loc'}; plotcolor2={'b','r'}; tcond={'Awake','Unconscious'};
   bcolor=[128 193 219]./255; ocolor1=[243 169 114]./255; plotcolor=[bcolor; ocolor1]; 
else 
   cond={'rest','propofol5','propofol4','propofol3'}; plotcolor2={'b','m','r','#D95319'};
   bcolor=[128 193 219]./255; ocolor1=[255 187 255]./255; ocolor2=[243 169 114]./255; ocolor3=[255 185 15]./255;   
   plotcolor=[bcolor; ocolor1; ocolor2; ocolor3];
end
load(['E:\#ECoGconsciousness\Connect\sub01\psdwel\sub01_psdwel_loc.mat'])
rfreq=round(wfreq); clear wpsd
lengf=length(wfreq);

%%
if string(fset)=="all" % all psd     
    %% 1. sub to all avg pow  
    if string(stud)=="loc" 
    list_f = dir(['E:\#ECoGconsciousness\Connect\sub*\psdwel\sub*_apsd_loc_4loc.mat']);
    else
    list_f = dir(['E:\#ECoGconsciousness\Connect\sub*\raw\sub*_propofol3.dat']);
    end
    allap=[];  
    % all sub psd data
    for i=1:length(list_f)   
        if string(stud)=="loc" 
        subno=extractBetween(list_f(i).name,'sub','_apsd_loc_4loc.mat'); subno=subno{1}; 
        else
    	subno=extractBetween(list_f(i).name,'sub','_propofol3.dat'); subno=subno{1};
        end
        direct=['E:\#ECoGconsciousness\Connect\sub' subno];   
        cd([direct '\psdwel'])
        subap=[];
        for c=1:length(cond)
            % load psd files        
            load(['sub' subno '_apsd_' cond{c} '_4' stud '.mat'])
            subap=[subap; allpsd];          
        end
        allap=cat(3,allap,subap);  
    end
    % mean, std psd
    mpsd=mean(allap,3);    
    % save all psd
    cd(['E:\#ECoGconsciousness\Connect\all\psdwel']);
    s1=['save all_apsd_4' stud '.mat allap mpsd rfreq wfreq']; eval(s1)
        
    %% 2. diff test: wilcoxon signed rank test
    if string(stud)=="loc" 
        awpsd=squeeze(allap(1,:,:)); locpsd=squeeze(allap(2,:,:));
        logawpsd=10*log10(awpsd); loglocpsd=10*log10(locpsd); 
        % wilcoxon signed rank test
         for ff=1:lengf
         [allp(ff,1),allh(ff,1)]=signrank(awpsd(ff,:), locpsd(ff,:),'Alpha',0.05/lengf); 
         [logallp(ff,1),~]=signrank(logawpsd(ff,:), loglocpsd(ff,:),'Alpha',0.05/lengf);
         sg=median(locpsd(ff,:))-median(awpsd(ff,:)); lsg=median(loglocpsd(ff,:))-median(logawpsd(ff,:));
         allsp(ff,1)=allp(ff,1)*sign(sg); logallsp(ff,1)=logallp(ff,1)*sign(lsg);
         end
    else % prop study
    end
    
    nalzall(1,1)="all"; nalzall(2,1)=size(awpsd,2);
    s1=['save all_wilc_apsd_4' stud '.mat allp logallp allsp logallsp wfreq rfreq nalzall']; eval(s1) 
    
    %% 3. plot psd
    % plot psd: Global ch 
    figure() 
    for i=1:length(cond)
        plot(wfreq,10*log10(mpsd(i,:)),'Color',plotcolor2{i},'LineWidth',2);
        hold on
    end            
    if string(stud)=="loc" 
    h1=find(allh==1);
         for nh=1:length(h1)
             X=[wfreq(h1(nh)) wfreq(h1(nh)+1)]; Y=[-55 -55];
             line(X, Y,'Color', 'k','LineWidth',4);
         end
    c = get(gca, 'Children'); hleg1 = legend(c(length(c)-1:length(c)), fliplr(tcond));  
    else
    c = get(gca, 'Children'); hleg1 = legend(c(1:length(tcond)), fliplr(tcond));        
    end     
    ylim([-60 60]); %xlim([0 150]); 
    xticks([rfreq(2) rfreq(5) rfreq(9) rfreq(14) rfreq(32) rfreq(93) rfreq(144) rfreq(257)]) % 1 4 8 13 30 90 140 250
    ylabel('PSD (dB/Hz)'); xlabel('Frequency (Hz)'); set(gca, 'fontsize',14,'FontWeight','bold','linewidth',2,'FontName','Arial')       
    %name=['Global']; title(name,'FontSize',12);
    set(gcf,'units','normalized','outerposition',[0 0 0.4 1]);
    %set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    % save based pow
    cd(['E:\#ECoGconsciousness\Connect\all\psdwel\fig\']); fname=['Global_4' stud];        
    saveas(gcf,fname, 'meta'); saveas(gcf,fname, 'png'); close(gcf);   
    
    % plot psd: Global ch (log scale)
    lwfreq=log10(wfreq(2:length(wfreq))); lrfreq=log10(rfreq(2:length(wfreq)));
    figure()   
    for i=1:length(cond)
        plot(lwfreq,10*log10(mpsd(i,[2:length(wfreq)])),'Color',plotcolor2{i},'LineWidth',2);
        hold on
    end            
    if string(stud)=="loc" 
    h1=find(allh==1);
         for nh=1:length(h1)
             X=[lwfreq(h1(nh)) lwfreq(h1(nh)+1)]; Y=[-55 -55];
             line(X, Y,'Color', 'k','LineWidth',4);
         end
    c = get(gca, 'Children'); hleg1 = legend(c(length(c)-1:length(c)), fliplr(tcond));  
    else
    c = get(gca, 'Children'); hleg1 = legend(c(1:length(tcond)), fliplr(tcond));  
    end 
    ylim([-60 60]); xlim([0 lrfreq(256)]); 
    xticks([lrfreq(2) lrfreq(5) lrfreq(9) lrfreq(14) lrfreq(32) lrfreq(93) lrfreq(144) lrfreq(256)]) % 1 4 8 13 30 90 140 250
    xticklabels([rfreq(2) rfreq(5) rfreq(9) rfreq(14) rfreq(32) rfreq(93) rfreq(144) rfreq(257)]) % 1 4 8 13 30 90 140 250
    ylabel('PSD (dB/Hz)'); xlabel('Frequency (Hz)'); set(gca, 'fontsize',14,'FontWeight','bold','linewidth',2,'FontName','Arial')       
    %name=['Global']; title(name,'FontSize',12);
    set(gcf,'units','normalized','outerposition',[0 0 0.4 1]);
    %set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    % save based pow
    cd(['E:\#ECoGconsciousness\Connect\all\psdwel\fig\']); fname=['Global_log_4' stud];        
    saveas(gcf,fname, 'meta'); saveas(gcf,fname, 'png'); close(gcf);       

elseif string(fset)=="BA"
    %% 1. sub to BA avg pow  
    if string(stud)=="loc" 
    list_f = dir(['E:\#ECoGconsciousness\Connect\sub*\psdwel\sub*_apsd_loc_4loc.mat']);
    else
    list_f = dir(['E:\#ECoGconsciousness\Connect\sub*\raw\sub*_propofol3.dat']);
    end  
    cd(['D:\#ECoGconsciousness\ECoG electrode\']); load BA_list4connect.mat %load BAlist4netstd.mat
    [lba,~]=size(balist);
    for b=1:lba
        repba=str2num(balist(b,4)); labelba=balist(b,2);
        %repba=str2num(balist(b,5)); labelba=balist(b,3);
        allbap=[];        
        if labelba=="V3-5" labelba="V3_5"; end
        for i=1:length(list_f)
            if string(stud)=="loc" 
            subno=extractBetween(list_f(i).name,'sub','_apsd_loc_4loc.mat'); subno=subno{1};  
            else
            subno=extractBetween(list_f(i).name,'sub','_propofol3.dat'); subno=subno{1};
            end            
            direct=['E:\#ECoGconsciousness\Connect\sub' subno]; cd([direct])
            % load eleinfo file
            load(['sub' subno '_electinfo_4' stud '.mat'])
            %load(['sub' subno '_electinfo_4' stud 'BA23.mat'])
            [r,~]=find(cell2mat(subBAlist(:,2))==repba);
            %[r,~]=find(cell2mat(subBA23list(:,2))==repba);
            if isempty(r)==1
                fprintf(['...Sub ' subno ' for ' char(labelba) ' pass....\n']);                
            else
                cd([direct '\psdwel'])
                subbap=[];
                for c=1:length(cond)                
                % load psd files        
                load(['sub' subno '_apsd_' cond{c} '_4' stud '.mat'])                 
                subbap=[subbap; bapsd(r,:)];   
                end
                allbap=cat(3,allbap,subbap);  
                fprintf(['...Sub ' subno ' for ' char(labelba) ' done....\n']);     
            end
        end
        % mean psd
        mbapsd=mean(allbap,3); 
        s1=['allbapsd.' char(labelba) '=allbap;']; eval(s1)
        s1=['mpsd.' char(labelba) '=mbapsd;']; eval(s1)
    end
    % save BA psd
    cd(['E:\#ECoGconsciousness\Connect\all\psdwel']);
    s1=['save BA_apsd_4' stud '.mat allbapsd mpsd rfreq wfreq']; eval(s1)
    
    %% 2. diff test: wilcoxon signed rank test
    if string(stud)=="loc" 
        nalzba=string(zeros(2,length(balist)));
        for i=1:length(balist)
            labelba=balist(i,2); %labelba=balist(i,3); 
            if labelba=="V3-5" labelba="V3_5"; end
            s1=['Ndim = ndims(allbapsd.' char(labelba) ');']; eval(s1)
            if Ndim==2
            s1=['awpsd=squeeze(allbapsd.' char(labelba) '(1,:));']; eval(s1)
            s1=['locpsd=squeeze(allbapsd.' char(labelba) '(2,:));']; eval(s1)
            awpsd=awpsd'; locpsd=locpsd';
            else
            s1=['awpsd=squeeze(allbapsd.' char(labelba) '(1,:,:));']; eval(s1)
            s1=['locpsd=squeeze(allbapsd.' char(labelba) '(2,:,:));']; eval(s1)
            end
            logawpsd=10*log10(awpsd); loglocpsd=10*log10(locpsd); 
            % wilcoxon signed rank test
            for ff=1:lengf
            [allp(ff,i),allh(ff,i)]=signrank(awpsd(ff,:), locpsd(ff,:),'Alpha',0.05/lengf);
            [logallp(ff,i),~]=signrank(logawpsd(ff,:), loglocpsd(ff,:),'Alpha',0.05/lengf);
            sg=median(locpsd(ff,:))-median(awpsd(ff,:)); lsg=median(loglocpsd(ff,:))-median(logawpsd(ff,:));
            allsp(ff,i)=allp(ff,i)*sign(sg); logallsp(ff,i)=logallp(ff,i)*sign(lsg);
            end
            nalzba(1,i)=labelba; nalzba(2,i)=size(awpsd,2);
        end
    else % prop study
    end
    s1=['save BA_wilc_apsd_4' stud '.mat allp logallp allsp logallsp wfreq rfreq nalzba']; eval(s1) 
    
    %% 3. plot pow: BA ch
    for b=1:lba
        repba=str2num(balist(b,4)); labelba=balist(b,2); if labelba=="V3-5" labelba="V3_5"; end
        %repba=str2num(balist(b,5)); labelba=balist(b,3); if labelba=="V3-5" labelba="V3_5"; end
        s1=['mbapsd=squeeze(mpsd.' char(labelba) ');']; eval(s1)        
        % plot psd: BA
        figure()   
        for i=1:length(cond)
            plot(wfreq,10*log10(mbapsd(i,:)),'Color',plotcolor2{i},'LineWidth',2);
            hold on
        end  
        if string(stud)=="loc" 
        h1=find(allh(:,b)==1);
             for nh=1:length(h1)
                 X=[wfreq(h1(nh)) wfreq(h1(nh)+1)]; Y=[-55 -55];
                 line(X, Y,'Color', 'k','LineWidth',4);
             end
        c = get(gca, 'Children'); hleg1 = legend(c(length(c)-1:length(c)), fliplr(tcond));  
        else
        c = get(gca, 'Children'); hleg1 = legend(c(1:length(tcond)), fliplr(tcond));      
        end             
        ylim([-60 60]); %xlim([0 150]); 
        xticks([rfreq(2) rfreq(5) rfreq(9) rfreq(14) rfreq(32) rfreq(93) rfreq(144) rfreq(257)]) % 1 4 8 13 30 90 140 250
        ylabel('PSD (dB/Hz)'); xlabel('Frequency (Hz)'); set(gca, 'fontsize',10,'FontWeight','bold','linewidth',2,'FontName','Arial')       
        %name=['BA ' num2str(repba) ' ' char(labelba)]; title(name,'FontSize',12);
        set(gcf,'units','normalized','outerposition',[0 0 0.4 1]);
        %set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        % save BA psd
        cd(['E:\#ECoGconsciousness\Connect\all\psdwel\fig\BA\' stud]); fname=['BA' num2str(repba) '_' char(labelba)];        
        saveas(gcf,fname, 'meta'); saveas(gcf,fname, 'png'); close(gcf);     
        
        % plot psd: BA (log scale)
        lwfreq=log10(wfreq(2:length(wfreq))); lrfreq=log10(rfreq(2:length(wfreq)));
        figure()  
        for i=1:length(cond)
            plot(lwfreq,10*log10(mbapsd(i,[2:length(wfreq)])),'Color',plotcolor2{i},'LineWidth',2);
            hold on
        end  
        if string(stud)=="loc" 
        h1=find(allh(:,b)==1);
             for nh=1:length(h1)
                 X=[lwfreq(h1(nh)) lwfreq(h1(nh)+1)]; Y=[-55 -55];
                 line(X, Y,'Color', 'k','LineWidth',4);
             end
        c = get(gca, 'Children'); hleg1 = legend(c(length(c)-1:length(c)), fliplr(tcond));  
        else
        c = get(gca, 'Children'); hleg1 = legend(c(1:length(tcond)), fliplr(tcond));    
        end     
        ylim([-60 60]); xlim([0 lrfreq(256)]); 
        xticks([lrfreq(2) lrfreq(5) lrfreq(9) lrfreq(14) lrfreq(32) lrfreq(93) lrfreq(144) lrfreq(256)]) % 1 4 8 13 30 90 140 250
        xticklabels([rfreq(2) rfreq(5) rfreq(9) rfreq(14) rfreq(32) rfreq(93) rfreq(144) rfreq(257)]) % 1 4 8 13 30 90 140 250
        ylabel('PSD (dB/Hz)'); xlabel('Frequency (Hz)'); set(gca, 'fontsize',14,'FontWeight','bold','linewidth',2,'FontName','Arial')       
        %name=['BA ' num2str(repba) ' ' char(labelba)]; title(name,'FontSize',12);
        set(gcf,'units','normalized','outerposition',[0 0 0.4 1]);
        %set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        % save BA psd
        cd(['E:\#ECoGconsciousness\Connect\all\psdwel\fig\BA\' stud]); fname=['BA' num2str(repba) '_log_' char(labelba)];        
        saveas(gcf,fname, 'meta'); saveas(gcf,fname, 'png'); close(gcf);   
    end
    
elseif string(fset)=="lobe"
    % %% 1. BA avg pow to lobe 
    % cd(['D:\#ECoGconsciousness\ECoG electrode\']); load BAlist4netstd.mat % 23 regions
    % cd(['E:\#ECoGconsciousness\Connect\all\psdwel\']); load(['BA_apsd_4' stud '.mat'])
    % lobelist=unique(balist(:,4)); [lba,~]=size(lobelist); 
    % for b=1:lba
    %     llabel=lobelist(b,1);       
    %     bal=find(balist(:,4)==llabel); bal2=balist(bal,3); lobep=[];         
    %     for bb=1:length(bal2)
    %         labelba=bal2(bb,1);
    %         if labelba=="V3-5"; labelba="V3_5"; end
    %         s1=['batmp=allbapsd.' char(labelba) ';']; eval(s1)
    %         lobep=cat(3,lobep,batmp);  
    %     end
    %     s1=['lobepsd.' char(llabel) '=lobep;']; eval(s1)
    %     % mean pow
    %     mlobep=mean(lobep,3); 
    %     s1=['mlobepsd.' char(llabel) '=mlobep;']; eval(s1)
    % end
    % % save lobe psd
    % cd(['E:\#ECoGconsciousness\Connect\all\psdwel']);
    % s1=['save lobe_apsd_4' stud '.mat lobepsd mlobepsd rfreq wfreq lobelist']; eval(s1)
    % 
    % %% 2. diff test: wilcoxon signed rank test
    % if string(stud)=="loc" 
    %     nalzlobe=string(zeros(2,length(lobelist)));
    %     for i=1:length(lobelist)
    %         llabel=lobelist(i,1); if llabel=="V3-5" llabel="V3_5"; end
    %         s1=['awpsd=squeeze(lobepsd.' char(llabel) '(1,:,:));']; eval(s1)
    %         s1=['locpsd=squeeze(lobepsd.' char(llabel) '(2,:,:));']; eval(s1)
    %         logawpsd=10*log10(awpsd); loglocpsd=10*log10(locpsd);            
    %         % wilcoxon signed rank test
    %         lengf=length(rfreq);
    %         for ff=1:lengf
    %         [allp(ff,i),allh(ff,i)]=signrank(awpsd(ff,:), locpsd(ff,:),'Alpha',0.05/lengf);
    %         [logallp(ff,i),~]=signrank(logawpsd(ff,:), loglocpsd(ff,:),'Alpha',0.05/lengf);
    %         sg=median(locpsd(ff,:))-median(awpsd(ff,:)); lsg=median(loglocpsd(ff,:))-median(logawpsd(ff,:));
    %         allsp(ff,i)=allp(ff,i)*sign(sg); logallsp(ff,i)=logallp(ff,i)*sign(lsg);
    %         end
    %         nalzlobe(1,i)=llabel; nalzlobe(2,i)=size(awpsd,2);
    %     end
    % else % prop study
    % end
    % s1=['save lobe_wilc_apsd_4' stud '.mat allp logallp allsp logallsp rfreq wfreq nalzlobe']; eval(s1) 
    % 
    % %% 3. plot psd
    % for lob=1:length(lobelist)
    %     llabel=lobelist(lob,1); if llabel=="V3-5" llabel="V3_5"; end
    %     s1=['mlob=squeeze(mlobepsd.' char(llabel) ');']; eval(s1)
    %     % plot pow
    %     figure()
    %     for i=1:length(cond)
    %         plot(wfreq',10*log10(mlob(i,:)),'Color',plotcolor2{i},'LineWidth',2);
    %         hold on
    %     end 
    %     if string(stud)=="loc" 
    %     h1=find(allh(:,lob)==1);
    %          for nh=1:length(h1)
    %              if h1(nh)==251
    %              else 
    %              X=[wfreq(h1(nh)) wfreq(h1(nh)+1)]; Y=[-55 -55];
    %              line(X, Y,'Color', 'k','LineWidth',4);
    %              end
    %          end
    %     c = get(gca, 'Children'); hleg1 = legend(c(length(c)-1:length(c)), fliplr(tcond));  
    %     else
    %     c = get(gca, 'Children'); hleg1 = legend(c(1:length(tcond)), fliplr(tcond));      
    %     end 
    %     ylim([-60 60]); xlim([0 250]); 
    %     xticks([rfreq(2) rfreq(5) rfreq(9) rfreq(14) rfreq(32) rfreq(93) rfreq(144) rfreq(257)]) % 1 4 8 13 30 90 140 250
    %     ylabel('PSD (dB/Hz)'); xlabel('Frequency (Hz)'); set(gca, 'fontsize',10,'FontWeight','bold','linewidth',2,'FontName','Arial')       
    %     %name=[char(llabel)]; title(name,'FontSize',12);
    %     set(gcf,'units','normalized','outerposition',[0 0 0.4 1]);
    %     %set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    %     % save psd
    %     cd(['E:\#ECoGconsciousness\Connect\all\psdwel\fig\lobe\' stud]); fname=['lobe_' char(llabel)];        
    %     saveas(gcf,fname, 'meta'); close(gcf);  
    %     %saveas(gcf,fname, 'png'); close(gcf);
    % 
    %     % plot pow (log)
    %     lwfreq=log10(wfreq(2:length(wfreq))); lrfreq=log10(rfreq(2:length(wfreq)));
    %     figure()   
    %     for i=1:length(cond)
    %         plot(lwfreq,10*log10(mlob(i,[2:length(wfreq)])),'Color',plotcolor2{i},'LineWidth',2);
    %         hold on
    %     end  
    %     if string(stud)=="loc" 
    %     h1=find(allh(:,lob)==1);
    %          for nh=1:length(h1)
    %              if h1(nh)==251 || h1(nh)==250
    %              else 
    %              X=[lwfreq(h1(nh)) lwfreq(h1(nh)+1)]; Y=[-55 -55];
    %              line(X, Y,'Color', 'k','LineWidth',4);
    %              end
    %          end
    %     c = get(gca, 'Children'); hleg1 = legend(c(length(c)-1:length(c)), fliplr(tcond));  
    %     else
    %     c = get(gca, 'Children'); hleg1 = legend(c(1:length(tcond)), fliplr(tcond));    
    %     end     
    %     ylim([-60 60]); xlim([0 lrfreq(256)]); 
    %     xticks([lrfreq(2) lrfreq(5) lrfreq(9) lrfreq(14) lrfreq(32) lrfreq(93) lrfreq(144) lrfreq(256)]) % 1 4 8 13 30 90 140 250
    %     xticklabels([rfreq(2) rfreq(5) rfreq(9) rfreq(14) rfreq(32) rfreq(93) rfreq(144) rfreq(257)]) % 1 4 8 13 30 90 140 250
    %     ylabel('PSD (dB/Hz)'); xlabel('Frequency (Hz)'); set(gca, 'fontsize',14,'FontWeight','bold','linewidth',2,'FontName','Arial')       
    %     %name=[char(llabel)]; title(name,'FontSize',12);
    %     set(gcf,'units','normalized','outerposition',[0 0 0.4 1]);
    %     %set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    %     % save psd
    %     cd(['E:\#ECoGconsciousness\Connect\all\psdwel\fig\lobe\' stud]); fname=['lobe_' char(llabel) '_log'];        
    %     saveas(gcf,fname, 'meta'); saveas(gcf,fname, 'png'); close(gcf);   
    % end 
elseif string(fset)=="lobe2"
    %% 1. sub to lobe2 avg pow  
    if string(stud)=="loc" 
    list_f = dir(['E:\#ECoGconsciousness\Connect\sub*\psdwel\sub*_apsd_loc_4loc.mat']);
    else
    list_f = dir(['E:\#ECoGconsciousness\Connect\sub*\raw\sub*_propofol3.dat']);
    end  
    load(['E:\#ECoGconsciousness\Connect\sub01\psdwel\sub01_apsd_loc_4loc.mat'])   
    clear allpsd bapsd lobe2psd 
    for l2=1:length(l2list)
        labell2=l2list(l2,1); alllap2=zeros(2,length(wfreq));        
        for i=1:length(list_f)
            if string(stud)=="loc" 
            subno=extractBetween(list_f(i).name,'sub','_apsd_loc_4loc.mat'); subno=subno{1}; 
            else
            subno=extractBetween(list_f(i).name,'sub','_propofol3.dat'); subno=subno{1};
            end            
            direct=['E:\#ECoGconsciousness\Connect\sub' subno]; cd([direct])
            cd([direct '\psdwel']); sublap2=[];
            load(['sub' subno '_apsd_' cond{1} '_4' stud '.mat'])              
            if isnan(sum(lobe2psd(l2,:)))
                fprintf(['... Sub ' subno ' ' char(l2list(l2)) ' pass....\n']);
            else
                for c=1:length(cond)                
                % load pow files        
                load(['sub' subno '_apsd_' cond{c} '_4' stud '.mat'])   
                sublap2=[sublap2; lobe2psd(l2,:)];   
                end            
            end
            alllap2=cat(3,alllap2,sublap2);  
        end
        stmp=size(alllap2,3); alllap2=alllap2(:,:,[2:stmp]);
        mlap2=mean(alllap2,3); % mean
        s1=['l2psd.' char(labell2) '=alllap2;']; eval(s1)
        s1=['ml2psd.' char(labell2) '=mlap2;']; eval(s1)        
    end
    % save lobe2 psd
    cd(['E:\#ECoGconsciousness\Connect\all\psdwel']);
    s1=['save lobe2_apsd_4' stud '.mat l2psd ml2psd l2list rfreq wfreq']; eval(s1)
    
    %% 2. diff test: wilcoxon signed rank test
    if string(stud)=="loc" 
        nalzl2=string(zeros(2,length(l2list)));
        for i=1:length(l2list)
            labell2=l2list(i,1);             
            s1=['Ndim = ndims(l2psd.' char(labell2) ');']; eval(s1)
            if Ndim==2
            s1=['awpsd=squeeze(l2psd.' char(labell2) '(1,:));']; eval(s1)
            s1=['locpsd=squeeze(l2psd.' char(labell2) '(2,:));']; eval(s1)
            awpsd=awpsd'; locpsd=locpsd';
            else
            s1=['awpsd=squeeze(l2psd.' char(labell2) '(1,:,:));']; eval(s1)
            s1=['locpsd=squeeze(l2psd.' char(labell2) '(2,:,:));']; eval(s1)
            end   
            logawpsd=10*log10(awpsd); loglocpsd=10*log10(locpsd); 
            % wilcoxon signed rank test
             for ff=1:lengf
             [allp(ff,i),allh(ff,i)]=signrank(awpsd(ff,:), locpsd(ff,:),'Alpha',0.05/lengf);
             [logallp(ff,i),~]=signrank(logawpsd(ff,:), loglocpsd(ff,:),'Alpha',0.05/lengf);
             sg=median(locpsd(ff,:))-median(awpsd(ff,:)); lsg=median(loglocpsd(ff,:))-median(logawpsd(ff,:));
             allsp(ff,i)=allp(ff,i)*sign(sg); logallsp(ff,i)=logallp(ff,i)*sign(lsg);
             end             
             nalzl2(1,i)=labell2; nalzl2(2,i)=size(awpsd,2);
        end
    else % prop study
    end
    s1=['save lobe2_wilc_apsd_4' stud '.mat allp logallp allsp logallsp wfreq rfreq nalzl2']; eval(s1) 
    
    %% 3. plot pow
    namel2={'Etc';'Frontal';'Insula';'Limbic';'Occipital';'Parietal';'Sensorimotor';'Temporal'};
    %namel2={'Frontal';'Limbic';'Occipital';'Parietal';'Sensorimotor';'Temporal'};
    for i=1:length(l2list)
        labell2=l2list(i,1); 
        s1=['ml2=squeeze(ml2psd.' char(labell2) ');']; eval(s1)
        % plot pow     
        figure()
        for c=1:length(cond)
            plot(wfreq,10*log10(ml2(c,:)),'Color',plotcolor2{c},'LineWidth',2);
            hold on
        end  
        if string(stud)=="loc" 
        h1=find(allh(:,i)==1);
             for nh=1:length(h1)
                 if h1(nh)==251
                 else 
                 X=[wfreq(h1(nh)) wfreq(h1(nh)+1)]; Y=[-55 -55];
                 line(X, Y,'Color', 'k','LineWidth',4);
                 end
             end
        c = get(gca, 'Children'); hleg1 = legend(c(length(c)-1:length(c)), fliplr(tcond));  
        else
        c = get(gca, 'Children'); hleg1 = legend(c(1:length(tcond)), fliplr(tcond));      
        end 
        ylim([-60 60]); xlim([0 250]); 
        xticks([rfreq(2) rfreq(5) rfreq(9) rfreq(14) rfreq(32) rfreq(93) rfreq(144) rfreq(257)]) % 1 4 8 13 30 90 140 250
        ylabel('PSD (dB/Hz)'); xlabel('Frequency (Hz)');
        set(gca, 'fontsize',10,'FontWeight','bold','linewidth',2,'FontName','Arial')    
        name=[namel2{i}]; title(name,'FontSize',12,'FontWeight','bold','FontName','Arial');
        set(gcf,'units','normalized','outerposition',[0 0 0.4 1]);
        %set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        % save psd
        cd(['E:\#ECoGconsciousness\Connect\all\psdwel\fig\lobe\' stud]); fname=['lobe2_' char(labell2)];        
        saveas(gcf,fname, 'meta'); saveas(gcf,fname, 'png'); close(gcf);   
        
        % plot psd (log scale)
        lwfreq=log10(wfreq(2:length(wfreq))); lrfreq=log10(rfreq(2:length(wfreq))); 
        figure()  
        for c=1:length(cond)
            plot(lwfreq,10*log10(ml2(c,[2:length(wfreq)])),'Color',plotcolor2{c},'LineWidth',2);
            hold on
        end  
        if string(stud)=="loc" 
        h1=find(allh(:,i)==1);
             for nh=1:length(h1)
                 if h1(nh)==251 || h1(nh)==250
                 else 
                 X=[lwfreq(h1(nh)) lwfreq(h1(nh)+1)]; Y=[-55 -55];
                 line(X, Y,'Color', 'k','LineWidth',4);
                 end
             end
        c = get(gca, 'Children'); hleg1 = legend(c(length(c)-1:length(c)), fliplr(tcond));  
        else
        c = get(gca, 'Children'); hleg1 = legend(c(1:length(tcond)), fliplr(tcond));    
        end     
        ylim([-60 60]); xlim([0 lrfreq(256)]); 
        xticks([lrfreq(2) lrfreq(5) lrfreq(9) lrfreq(14) lrfreq(32) lrfreq(93) lrfreq(144) lrfreq(256)]) % 1 4 8 13 30 90 140 250
        xticklabels([rfreq(2) rfreq(5) rfreq(9) rfreq(14) rfreq(32) rfreq(93) rfreq(144) rfreq(257)]) % 1 4 8 13 30 90 140 250
        ylabel('PSD (dB/Hz)'); xlabel('Frequency (Hz)'); name=[namel2{i}]; title(name,'FontSize',14,'FontWeight','bold','FontName','Arial');
        set(gca, 'fontsize',14,'FontWeight','bold','linewidth',2,'FontName','Arial')            
        %name=[char(labell2)]; title(name,'FontSize',12);
        set(gcf,'units','normalized','outerposition',[0 0 0.4 1]);
        %set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        % save psd
        cd(['E:\#ECoGconsciousness\Connect\all\psdwel\fig\lobe\' stud]); fname=['lobe2_' char(labell2) '_log'];        
        saveas(gcf,fname, 'meta'); saveas(gcf,fname, 'png'); close(gcf);   
    end 
else
    %% subject ver.
    subno=fset;  
    direct=['E:\#ECoGconsciousness\Connect\sub' subno];   
    cd(direct)
    %load(['sub' subno '_electinfo_4' stud 'BA23.mat'])
    load(['sub' subno '_electinfo_4' stud '.mat'])    
    % load psd files
    cd([direct '\psdwel\'])
    ap=[]; bap=[]; l2ap=[];
    for i=1:length(cond)
        % load psd files        
        load(['sub' subno '_apsd_' cond{i} '_4' stud '.mat'])        
        ap=[ap; allpsd]; bap=cat(3,bap,bapsd); l2ap=cat(3,l2ap,lobe2psd);      
        clear allpsd bapsd lobe2psd
    end    
    % plot psd: Global ch 
    figure()  
    for i=1:length(cond)
        plot(wfreq,10*log10(ap(i,:)),'Color',plotcolor2{i},'LineWidth',2);
        hold on
    end  
    c = get(gca, 'Children'); hleg1 = legend(c(1:length(tcond)), fliplr(tcond));      
    ylim([-80 80]); %xlim([0 150]); 
    xticks([rfreq(2) rfreq(5) rfreq(9) rfreq(14) rfreq(32) rfreq(93) rfreq(144) rfreq(257)]) % 1 4 8 13 30 90 140 250
    ylabel('PSD (dB/Hz)'); xlabel('Frequency (Hz)'); set(gca, 'fontsize',14,'FontWeight','bold','linewidth',2,'FontName','Arial')       
    %name=['Sub' subno ' Global']; title(name,'FontSize',12);
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    % save based pow
    cd([direct '\psdwel\fig\']); fname=['sub' subno '_1Global_4' stud];        
    %saveas(gcf,fname, 'meta'); close(gcf);
    saveas(gcf,fname, 'png'); close(gcf);
    
    % plot psd: each BA
    [lengba,~]=size(subBAlist); % [lengba,~]=size(subBA23list);
    for nba=1:lengba
        figure()
        for i=1:length(cond)
            plot(wfreq,10*log10(bap(nba,:,i)),'Color',plotcolor2{i},'LineWidth',2);
            hold on
        end
        c = get(gca, 'Children'); hleg1 = legend(c(1:length(tcond)), fliplr(tcond));   
        ylim([-80 80]); % xlim([0 150]);
        xticks([rfreq(2) rfreq(5) rfreq(9) rfreq(14) rfreq(32) rfreq(93) rfreq(144) rfreq(257)]) % 1 4 8 13 30 90 140 250
        ylabel('PSD (dB/Hz)'); xlabel('Frequency (Hz)'); set(gca, 'fontsize',14,'FontWeight','bold','linewidth',2,'FontName','Arial')       
        %name=['Sub' subno ' ' subBA23list{nba,3}]; title(name,'FontSize',12);
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        % save based pow
        cd([direct '\psdwel\fig\']); %fname=['sub' subno '_' subBA23list{nba,3} '_4' stud];        
        fname=['sub' subno '_' subBAlist{nba,3} '_4' stud]; 
        saveas(gcf,fname, 'meta'); saveas(gcf,fname, 'png'); close(gcf);   
    end
    
    % plot psd: lobe2
    [lengl2,~]=size(l2list);
    for nl2=1:lengl2
        if isnan(sum(l2ap(nl2,:,1)))
            fprintf(['... Sub ' subno ' ' char(l2list(nl2)) ' pass....\n']);
        else
            figure()
            for i=1:length(cond)
                plot(wfreq,10*log10(l2ap(nl2,:,i)),'Color',plotcolor2{i},'LineWidth',2);
                hold on
            end
            c = get(gca, 'Children'); hleg1 = legend(c(1:length(tcond)), fliplr(tcond));   
            ylim([-80 80]); % xlim([0 150]);
            xticks([rfreq(2) rfreq(5) rfreq(9) rfreq(14) rfreq(32) rfreq(93) rfreq(144) rfreq(257)]) % 1 4 8 13 30 90 140 250
            ylabel('PSD (dB/Hz)'); xlabel('Frequency (Hz)'); set(gca, 'fontsize',14,'FontWeight','bold','linewidth',2,'FontName','Arial')       
            %name=['Sub' subno ' ' char(l2list(nl2))]; title(name,'FontSize',12);
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            % save based pow
            cd([direct '\psdwel\fig\']); fname=['sub' subno '_' num2str(nl2) char(l2list(nl2)) '_4' stud];        
            saveas(gcf,fname, 'meta'); saveas(gcf,fname, 'png'); close(gcf);   
        end
    end

end

end