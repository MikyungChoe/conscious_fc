function wpli_BAchall(cond,nfreq)

% sort all ch data BA*BA connectivity
% BAchlabel=subject, ch info
% BAchdata=wpli value zBAchdata=fisher z(wpli value)

% example
% cond='rest'; cond='loc';
% nfreq=1;

%% setting
% load all BA info 
load(['D:\#ECoGconsciousness\ECoG electrode\BA_list4connect.mat']); 
% all subject info
list_f = dir(['E:\#ECoGconsciousness\Connect\sub*\wpli\sub*_wplimin_rest.mat']);
% frequency
fb={'Delta','Theta','Alpha','Beta','LG','HG'};

BAchlabel=[]; BAchdata=[]; zBAchdata=[]; lba=size(balist,1);

% convert: V3-5 to V3_5
tmp=find(balist(:,2)=="V3-5"); balist(tmp,2)="V3_5";

% make BA [] data
for ba1=1:lba
    for ba2=1:lba
        if ba2<ba1
            fprintf(['....Overlap BA No. pass ....\n']);  
        else
           s1=['BAchlabel.' balist{ba1,2} balist{ba2,2} '=string([]);']; eval(s1)
           s1=['BAchdata.' balist{ba1,2} balist{ba2,2} '=[];']; eval(s1)
           s1=['zBAchdata.' balist{ba1,2} balist{ba2,2} '=[];']; eval(s1)
           s1=['lnBAchdata.' balist{ba1,2} balist{ba2,2} '=[];']; eval(s1)
        end
    end
end

%% subject data
for s=1:length(list_f) 
    subno=extractBetween(list_f(s).name,'sub','_wplimin_rest.mat');  
    subno=subno{1};
    % load connect file (sub) 
    direct=['E:\#ECoGconsciousness\Connect\sub' subno];
    cd([direct]); load (['sub' subno '_electinfo_4loc.mat'])
    cd([direct '\wpli\']); load (['sub' subno '_wplimin_' cond '.mat'])
    fwpli=squeeze(fwpli); 
    ffmat1=fwpli(:,:,nfreq); ffmat2=fwpli(:,:,nfreq)';    
    ffmat=ffmat1+ffmat2; 
    zffmat=atanh(ffmat); % fisher z transformation
    lnffmat=log(ffmat); % ln(ffmat) for normal distribution

    % delete info (CoC, BS, Pu, Cd, Th)
    tmp=find(string(subBAlist(:,3))=="CoC"); 
    if isempty(tmp) else subBAlist(tmp,:)=[]; end

    tmp=find(string(subBAlist(:,3))=="BS"); 
    if isempty(tmp) else subBAlist(tmp,:)=[]; end

    tmp=find(string(subBAlist(:,3))=="Pu"); 
    if isempty(tmp) else subBAlist(tmp,:)=[]; end

    tmp=find(string(subBAlist(:,3))=="Cd"); 
    if isempty(tmp) else subBAlist(tmp,:)=[]; end

    tmp=find(string(subBAlist(:,3))=="Th"); 
    if isempty(tmp) else subBAlist(tmp,:)=[]; end

    % convert: V3-5 to V3_5
    tmp=find(string(subBAlist(:,3))=="V3-5"); 
    if isempty(tmp) else subBAlist{tmp,3}='V3_5'; end

    for ba1=1:size(subBAlist,1)
        for ba2=1:size(subBAlist,1)
            if ba2<ba1
            fprintf(['....Overlap BA No. pass ....\n']);  
            elseif ba2==ba1 % same BA
                bala1=subBAlist{ba1,3}; bala2=subBAlist{ba2,3};  
                bach1=subBAlist{ba1,4}; bach2=subBAlist{ba2,4}; 
                for bb1=1:length(bach1)
                    for bb2=1:length(bach2)
                        if bb1<bb2 % except overlap CH or same ch no
                           vlabel=string([]); vlabel(1,1)=subno; vlabel(1,2)=bach1(bb1); vlabel(1,3)=bach2(bb2);
                           vdata=ffmat(bach1(bb1),bach2(bb2)); zvdata=zffmat(bach1(bb1),bach2(bb2)); lnvdata=lnffmat(bach1(bb1),bach2(bb2));                             
    
                           s1=['BAchlabel.' bala1 bala2 '=[BAchlabel.' bala1 bala2 '; vlabel];' ]; eval(s1)
                           s1=['BAchdata.' bala1 bala2 '=[BAchdata.' bala1 bala2 '; vdata];' ]; eval(s1)
                           s1=['zBAchdata.' bala1 bala2 '=[zBAchdata.' bala1 bala2 '; zvdata];' ]; eval(s1)
                           s1=['lnBAchdata.' bala1 bala2 '=[lnBAchdata.' bala1 bala2 '; lnvdata];' ]; eval(s1)
                        end
                    end
                end
            else % main
                bala1=subBAlist{ba1,3}; bala2=subBAlist{ba2,3};  
                bach1=subBAlist{ba1,4}; bach2=subBAlist{ba2,4}; 
                for bb1=1:length(bach1)
                    for bb2=1:length(bach2)
                        %if bb1<bb2 % except overlap CH or same ch no
                           vlabel=string([]); vlabel(1,1)=subno; vlabel(1,2)=bach1(bb1); vlabel(1,3)=bach2(bb2);
                           vdata=ffmat(bach1(bb1),bach2(bb2)); zvdata=zffmat(bach1(bb1),bach2(bb2)); lnvdata=lnffmat(bach1(bb1),bach2(bb2));                             
    
                           s1=['BAchlabel.' bala1 bala2 '=[BAchlabel.' bala1 bala2 '; vlabel];' ]; eval(s1)
                           s1=['BAchdata.' bala1 bala2 '=[BAchdata.' bala1 bala2 '; vdata];' ]; eval(s1)
                           s1=['zBAchdata.' bala1 bala2 '=[zBAchdata.' bala1 bala2 '; zvdata];' ]; eval(s1)
                           s1=['lnBAchdata.' bala1 bala2 '=[lnBAchdata.' bala1 bala2 '; lnvdata];' ]; eval(s1)
                        %end
                    end
                end
            end
        end
    end
end

%% save file
cd(['E:\#ECoGconsciousness\Connect\all\wpli\BAch'])
s1=['save -v7.3 BAchall_wpli_' num2str(nfreq) fb{nfreq} '_' cond '.mat BAchlabel BAchdata zBAchdata lnBAchdata']; eval(s1);

fprintf(['...wpli sort BA all ch data done....\n']);

end