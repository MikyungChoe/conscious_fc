function sort_net_result_coh(lmtch)

% lmt=15, 20, 25 (limit ch)
% lmtch=20;

cd(['E:\#ECoGconsciousness\Connect\all\network\coh'])

allksccef=[]; allksge=[]; allswccef=[]; allswge=[]; 
allwspccef=[]; allwspge=[]; alltspccef=[]; alltspge=[];
mccfloc=[]; sccfloc=[]; mccfrest=[]; sccfrest=[]; 
mgeloc=[]; sgeloc=[]; mgerest=[]; sgerest=[]; 

for nthp=15:45    
    load (['stat_binet_ch23th' num2str(nthp) '.mat'])
    
    % 1. norm test 
    tmp=[nksccef(1,:) nksccef(2,:)]; allksccef=[allksccef; tmp]; clear tmp    
    tmp=[nksge(1,:) nksge(2,:)]; allksge=[allksge; tmp]; clear tmp
    
    tmp=[nswccef(1,:) nswccef(2,:)]; allswccef=[allswccef; tmp]; clear tmp    
    tmp=[nswge(1,:) nswge(2,:)]; allswge=[allswge; tmp]; clear tmp

    % 2. wilx test
    allwspccef=[allwspccef; wspccef]; allwspge=[allwspge; wspge];  
    
    % 3. ttest
    alltspccef=[alltspccef; tspccef]; alltspge=[alltspge; tspge];  

    % 4. mean, std
    ml=mean(lallccef,1); sl=std(lallccef,1); mr=mean(rallccef,1); sr=std(rallccef,1);
    mccfloc=[mccfloc; ml]; sccfloc=[sccfloc; sl]; mccfrest=[mccfrest; mr]; sccfrest=[sccfrest; sr]; 

    ml=mean(lallge,1); sl=std(lallge,1); mr=mean(rallge,1); sr=std(rallge,1);
    mgeloc=[mgeloc; ml]; sgeloc=[sgeloc; sl]; mgerest=[mgerest; mr]; sgerest=[sgerest; sr]; 
end
clear nksccef nksge nswccef nswge lallccef rallccef lallge rallge tspccef tspge wspccef wspge nthp ml mr sl sr

save (['result_net_limitch' num2str(lmtch) '_coh.mat'])
end