function bignet_coh_sub_thrval(subno,nfile,thp)

% clustering coefficient
% global efficiency
% using binary matrix
% subno='01'; nfile='rest'; 
% thp=15; (15 ~ 35 increasing 1%)

%% load BAmax cohmin file
direct=['E:\#ECoGconsciousness\Connect\sub' subno];    
cd([direct '\netcoh\'])
load (['sub' subno '_thre_cohminch23_thr' num2str(thp) '_' nfile '.mat'])

fband1={'Delta','Theta','Alpha','Beta','LG','HG'}';

%% Network analysis (clustering coefficient, efficiency, entropy)
lengfb=size(bnetf,3); cceffb=NaN(lengfb,1); gloefb=NaN(lengfb,1); sepfb=NaN(lengfb,1);
for ff=1:lengfb
    fbmat=bnetf(:,:,ff);
    % clustering coef
    cceftmp=clustering_coef_bu(fbmat); cceffb(ff,1)=mean(cceftmp);
    % global efficiency
    ge=efficiency_bin(fbmat,0); gloefb(ff,1)=ge;
    % % degree
    % degff=degrees_und(fbmat); degfb(ff,:)=degff;
    % % degree distribution
    % valdeg=unique(degff'); degtmp=NaN(length(valdeg),3); degtmp(:,1)=valdeg;
    % for i=1:length(valdeg)
    %     degtmp(i,2)=length(find(valdeg(i,1)==degff));
    %     degtmp(i,3)=length(find(valdeg(i,1)==degff))/lch;
    % end
    % s1=['degdist.' fband1{ff} '=degtmp;']; eval(s1)
    % % Shannon entropy
    % septmp=NaN(length(valdeg),1);
    % for i=1:length(valdeg)
    %     septmp(i,1)=degtmp(i,3)*log(degtmp(i,3));
    % end
    % sumseptmp=-sum(septmp,1); sepfb(ff,1)=sumseptmp;    
    
    % modularity
    %[~,Q]=modularity_und(fbmat); modfb(ff,1)=Q;
end
%% save file
cd([direct '\netcoh\'])
s1=['save -v7.3 sub' subno '_binet_ch23thr' num2str(thp) '_' nfile '.mat cceffb gloefb']; eval(s1);
fprintf(['...bi Sub' subno ' ' nfile ' network done....\n']);
end