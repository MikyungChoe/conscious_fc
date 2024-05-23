function global_complx

% global complexity using ch ver: norm (with surrogate); nonnorm (without surrogate)
% global complexity = mean of lzc in channels (lzc: lempel ziv complexity)

%% base setting
list_f = dir(['E:\#ECoGconsciousness\Connect\sub*\complexity\lzc\sub*_cplxmin_ch_loc.mat']);
sublist=string([]);

%% 1. Global LZC (norm)
nawgclx=NaN(length(list_f),1); nlocgclx=NaN(length(list_f),1);
for s=1:length(list_f) 
    subno=extractBetween(list_f(s).name,'sub','_cplxmin_ch_loc.mat'); subno=subno{1};
    sublist(s,1)=subno;
    
    cd(['E:\#ECoGconsciousness\Connect\sub' subno '\complexity\lzc\'])
    load(['sub' subno '_cplxmin_ch_rest.mat'])  % awake
    nawlzc=normchlzc; clear normchlzc
    load(['sub' subno '_cplxmin_ch_loc.mat'])  % unconscious
    nloclzc=normchlzc; clear normchlzc
    
    nawgclx(s,1)=mean(nawlzc); nlocgclx(s,1)=mean(nloclzc);
end

%% 2. Global LZC (without norm)
awgclx=NaN(length(list_f),1); locgclx=NaN(length(list_f),1);
for s=1:length(list_f) 
    subno=extractBetween(list_f(s).name,'sub','_cplxmin_ch_loc.mat'); subno=subno{1};
    %sublist(s,1)=subno;
    
    cd(['E:\#ECoGconsciousness\Connect\sub' subno '\complexity\lzc\'])
    load(['sub' subno '_cplxmin_ch_nonnorm_rest.mat'])  % awake
    awlzc=chlzc; clear chlzc
    load(['sub' subno '_cplxmin_ch_nonnorm_loc.mat'])  % unconscious
    loclzc=chlzc; clear chlzc
    
    awgclx(s,1)=mean(awlzc); locgclx(s,1)=mean(loclzc);
end

%% save file
cd(['E:\#ECoGconsciousness\Connect\all\complexity'])
save global_complexity sublist awgclx locgclx nawgclx nlocgclx
fprintf(['...Global Complexity done....\n']);

end