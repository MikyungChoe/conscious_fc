function stat_biglonet_all(thp)

% normality test, paired t test, wilcoxon sign rank
% thp=15;

%% load net file
list_f = dir(['E:\#ECoGconsciousness\Connect\sub*\netwpli\sub*_binet_ch23thr' num2str(thp) '_loc.mat']);

rallccef=NaN(length(list_f),6); rallge=NaN(length(list_f),6); lallccef=NaN(length(list_f),6); lallge=NaN(length(list_f),6);  

for s=1:length(list_f)     
    subnotmp=extractBetween(list_f(s).name,'sub',['_binet_ch23thr' num2str(thp) '_loc.mat']);  
    subno=subnotmp{1};
    cd(list_f(s).folder)
    load(['sub' subno '_binet_ch23thr' num2str(thp) '_rest.mat']); rallccef(s,:)=cceffb'; rallge(s,:)=gloefb'; clear cceffb gloefb 
    load(['sub' subno '_binet_ch23thr' num2str(thp) '_loc.mat']); lallccef(s,:)=cceffb'; lallge(s,:)=gloefb'; clear cceffb gloefb   
end

%% normality test
for ff=1:size(rallccef,2)
    % Kolmogorov-Smirnov
    % clustering
    [h1,~]=kstest(rallccef(:,ff)); [h2,~]=kstest(lallccef(:,ff)); nksccef(1,ff)=h1; nksccef(2,ff)=h2; 
    % efficiency
    [h1,~]=kstest(rallge(:,ff)); [h2,~]=kstest(lallge(:,ff)); nksge(1,ff)=h1; nksge(2,ff)=h2; 
    
    % Shapiro-Wilk
    % clustering
    [h1,~]=swtest(rallccef(:,ff)); [h2,~]=swtest(lallccef(:,ff)); nswccef(1,ff)=h1; nswccef(2,ff)=h2; 
    % efficiency
    [h1,~]=swtest(rallge(:,ff)); [h2,~]=swtest(lallge(:,ff)); nswge(1,ff)=h1; nswge(2,ff)=h2; 
end

%% wilcoxon sign rank
for ff=1:size(rallge,2)
    [ptmpccef,~]=signrank(lallccef(:,ff),rallccef(:,ff),'alpha',0.05,'method','approximate');
    difftmpccef=median(lallccef(:,ff))-median(rallccef(:,ff));
    wspccef(1,ff)=ptmpccef*sign(difftmpccef);
       
    [ptmpge,~]=signrank(lallge(:,ff),rallge(:,ff),'alpha',0.05,'method','approximate');
    difftmpge=median(lallge(:,ff))-median(rallge(:,ff));
    wspge(1,ff)=ptmpge*sign(difftmpge);    
end

%% paired t test
for ff=1:size(rallge,2)
    [~,ptmpccef]=ttest(lallccef(:,ff),rallccef(:,ff),'alpha',0.05);
    difftmpccef=mean(lallccef(:,ff))-mean(rallccef(:,ff));
    tspccef(1,ff)=ptmpccef*sign(difftmpccef);
       
    [~,ptmpge]=ttest(lallge(:,ff),rallge(:,ff),'alpha',0.05);
    difftmpge=mean(lallge(:,ff))-mean(rallge(:,ff));
    tspge(1,ff)=ptmpge*sign(difftmpge);    
end

%% save file
cd(['E:\#ECoGconsciousness\Connect\all\network\wpli'])
s1=['save -v7.3 stat_binet_ch23th' num2str(thp) '.mat rallccef lallccef rallge lallge nksccef nksge nswccef nswge wspccef wspge tspccef tspge']; eval(s1);

fprintf(['...Group analysis: thr' num2str(thp) ' done....\n']);
end