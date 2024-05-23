function bignet_aec_sub_thrval(subno,nfile,thp)

% clustering coefficient and global efficiency using binary matrix
% subno='01'; nfile='rest'; 
% thp=15; (15 ~ 35)

%% load BAmax cohmin file
direct=['E:\#ECoGconsciousness\Connect\sub' subno];    
cd([direct '\netaec\'])
load (['sub' subno '_thre_aecminch23_thr' num2str(thp) '_' nfile '.mat'])

fband1={'Delta','Theta','Alpha','Beta','LG','HG'}';

%% Network analysis (clustering coefficient, efficiency, entropy)
lengfb=size(bnetf,3); cceffb=NaN(lengfb,1); gloefb=NaN(lengfb,1); %sepfb=NaN(lengfb,1);
for ff=1:lengfb
    fbmat=bnetf(:,:,ff);
    % clustering coef
    cceftmp=clustering_coef_bu(fbmat); cceffb(ff,1)=mean(cceftmp);
    % global efficiency
    ge=efficiency_bin(fbmat,0); gloefb(ff,1)=ge;
end
%% save file
cd([direct '\netaec\'])
s1=['save -v7.3 sub' subno '_binet_ch23thr' num2str(thp) '_' nfile '.mat cceffb gloefb']; eval(s1);
fprintf(['...bi Sub' subno ' ' nfile ' network done....\n']);
end