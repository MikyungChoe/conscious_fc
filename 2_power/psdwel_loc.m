function psdwel_loc(subno,nfile)

% example: psdwel_loc('01','loc')
% subno='09'; nfile='loc';
% subno='77_2'; nfile='loc';
% Mikyung Choe, 2024

%% Settings
NFFT=512; sfreq=500; lengf=0.5*NFFT+1;

% load data
direct=['E:\#ECoGconsciousness\Connect\sub' subno];    
cd([direct '\raw\'])
load(['sub' subno '_rafilt_' nfile '.mat'])

[lengch,~]=size(data); wpsd=NaN(lengch,lengf);

%% PSD (non log scale)
for ch=1:lengch
    if sum(data(ch,:))==0 
       fprintf(['... Sub' subno ' ' nfile ' CH ' num2str(ch)  ' pass....\n']);
    else
    [wpsdch,wfreq]=pwelch(data(ch,:),hanning(NFFT),floor(NFFT*0.5),NFFT,sfreq);
    wpsd(ch,:)=wpsdch'; 
    end
end

% save welpsd
cd([direct '\psdwel\'])
s1=['save -v7.3 sub' subno '_psdwel_' nfile '.mat wpsd wfreq']; eval(s1);
fprintf(['...PSD Sub' subno ' ' nfile ' saved....\n']);

end