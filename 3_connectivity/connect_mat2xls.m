function connect_mat2xls(nfreq,connect)

% example
% nfreq=1; %delta
% connect='aec'; %aec,wpli,coh

fname={'Delta','Theta','Alpha','Beta','LG','HG'};
cd(['E:\#ECoGconsciousness\Connect\all\' connect '\statspss\data\' num2str(nfreq) fname{nfreq}])

load (['E:\#ECoGconsciousness\Connect\all\totalROI.mat'])
for rr=1:size(totalROI,1)
    rroi=totalROI(rr,1);
    load ([connect '_' num2str(nfreq) fname{nfreq} '_' char(rroi) '.mat'])

    fnxlsx=[connect '_' num2str(nfreq) fname{nfreq} '_' char(rroi) '.xls'];
    xlswrite(fnxlsx,roisdata);
end
fprintf(['... done....\n']);
end