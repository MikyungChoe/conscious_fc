function stat_glocomplx

% normality test, paired t test, wilcoxon sign rank

%% load file
cd('E:\#ECoGconsciousness\Connect\all\complexity')
load global_complexity.mat

%% 1. Global LZC (norm)
% 1) normality test (Kolmogorov-Smirnov test, n > 50)
[h1,~]=kstest(nawgclx); [h2,~]=kstest(nlocgclx); 
nks_ngclx(1,1)=h1; nks_ngclx(2,1)=h2;

% 2) wilcoxon sign rank
[ptmp,~]=signrank(nlocgclx,nawgclx,'alpha',0.05,'method','approximate');
difftmp=median(nlocgclx)-median(nawgclx);
wsp_ngclx=ptmp*sign(difftmp);

% 3) paired t test
[~,ptmp]=ttest(nlocgclx,nawgclx,'alpha',0.05);
difftmp=mean(nlocgclx)-mean(nawgclx);
tsp_ngclx=ptmp*sign(difftmp);

%% 2. Global LZC (without norm)
% 1) normality test (Kolmogorov-Smirnov test, n > 50)
[h1,~]=kstest(awgclx); [h2,~]=kstest(locgclx); 
nks_gclx(1,1)=h1; nks_gclx(2,1)=h2;

% 2) wilcoxon sign rank
[ptmp,~]=signrank(locgclx,awgclx,'alpha',0.05,'method','approximate');
difftmp=median(locgclx)-median(awgclx);
wsp_gclx=ptmp*sign(difftmp);

% 3) paired t test
[~,ptmp]=ttest(locgclx,awgclx,'alpha',0.05);
difftmp=mean(locgclx)-mean(awgclx);
tsp_gclx=ptmp*sign(difftmp);

%% save file
cd(['E:\#ECoGconsciousness\Connect\all\complexity'])
save stat_global_complexity.mat nks_ngclx wsp_ngclx tsp_ngclx nks_gclx wsp_gclx tsp_gclx

end