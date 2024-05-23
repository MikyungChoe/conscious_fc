list_f = dir(['E:\#ECoGconsciousness\Connect\all\aec\statspss\data\1Delta\aec_1Delta_*.mat']);
totalROI=string([]);
for s=1:length(list_f) 
    tmp=extractBetween(list_f(s).name,'aec_1Delta_','.mat');
    tmp=tmp{1};
    totalROI=[totalROI; tmp];

end
cd('E:\#ECoGconsciousness\Connect\all')
save totalROI.mat totalROI
writematrix(totalROI,'totalROI.txt')
