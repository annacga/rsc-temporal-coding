
snr     = cell(1,length(data));
decay   = cell(1,length(data));
rise    = cell(1,length(data));

for i = 1:length(data)
    for f = 1:length(data(i).sessionIDs)
        
        savedir = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/signal_statistics',data(i).area,data(i).sessionIDs{f});
        if ~exist(savedir)
            mkdir(savedir);
        end
        
        SNR = signal_stat.calculate_SNR(mData(i,f).sData);
        save(fullfile(savedir,'SNR.mat'),'SNR')
        
        
        tau             =  signal_stat.calculate_rise_decay(mData(i,f).sData);
        save(fullfile(savedir,'tau'),'tau')
        
        snr{i}    = [snr{i} SNR'];
        decay{i}  = [decay{i} tau(:,2)'];
        rise{i}   = [rise{i} tau(:,1)'];
        
        mean_snr{i}(f)    = nanmean(SNR);
        mean_decay{i}(f)  = nanmean(tau(:,2)');
        mean_rise{i}(f)   = nanmean(tau(:,1)');
    end
end


for i = 1:length(data)
    for f = 1:length(data(i).sessionIDs)
        loaddir = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/signal_statistics',data(i).area,data(i).sessionIDs{f});

        load(fullfile(loaddir,'tau'))
        load(fullfile(loaddir,'SNR'))
        
        snr{i}    = [snr{i} SNR'];
        decay{i}  = [decay{i} tau(:,2)'];
        rise{i}   = [rise{i} tau(:,1)'];

    end
    mean_snr{i}(f)    = nanmean(SNR);
    mean_decay{i}(f)  = nanmean(tau(:,2)');
    mean_rise{i}(f)   = nanmean(tau(:,1)');
end

plot.signal_stat(snr,mean_snr)

plot.signal_stat(decay,mean_decay)

plot.signal_stat(rise,mean_rise)




