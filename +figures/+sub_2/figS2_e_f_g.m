saveDir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Figures/Paper/sub_2/E_G';

% load.load_area_info()
% load.load_area_sData()


% Load all sessions
for i = 1:length(data)-1
    for f = 1:length(data(i).sessionIDs)
       mData(i,f).SNR = signal_stat.calculate_SNR(mData(i,f).sData);
       [mData(i,f).decay,mData(i,f).rise] = signal_stat.calculate_rise_decay(mData(i,f).sData);
       % Load all sessions
    end
end

for i = 1:length(data)-1
    for f = 1:length(data(i).sessionIDs)
       mData(i,f).roiStat  =  getStats(mData(i,f).sData);
       mData(i,f).activity_level =  mData(i,f).roiStat.activityLevel_dff;
    end
end


for i = 1:length(data)-1
    decay{i}   = [];
    rise{i}    = [];
    snr{i}     = [];
    activity{i} = [];
    for f = 1:length(data(i).sessionIDs)
        decay{i} = [decay{i}, mData(i,f).decay];
        rise{i} = [rise{i}, mData(i,f).rise];
        snr{i} = [snr{i}; mData(i,f).SNR];
        activity{i} = [activity{i}; mData(i,f).activity_level];
        
        decayMean{i}(f) = nanmean( mData(i,f).decay);
        riseMean{i}(f) = nanmean( mData(i,f).rise);
        snrMean{i}(f) = nanmean(mData(i,f).SNR);
        activityMedian{i}(f) = nanmean(mData(i,f).activity_level);

    end
end

fig=figure();
ax =subplot(1,2,1);
boxplot([decay{1}';decay{2}';decay{3}';decay{4}';decay{5}'],...
    [ones(length(decay{1}),1);2*ones(length(decay{2}),1);3*ones(length(decay{3}),1);...
    4*ones(length(decay{4}),1),...
    ;5*ones(length(decay{5}),1)],'symbol','');
hold on
ylabel('Decay time(ms)')
box off
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
ylim([0 4000])
xlim([0.5 5.5])
xticklabels({'RSC','M2','PPC','S1/S2','V1/V2'})



for i = 1:5
    for j = 1:5
        pval(i,j) = ranksum(decayMean{i}',decayMean{j}');
    end
end

matr =triu(ones(5,5));
matr(eye(5,5)==1) = NaN;
matr(matr== 0)= NaN;

subplot(1,2,2)
pval(isnan(matr)) = NaN;
[corrected_p, h]=helper.bonf_holm(pval);
imagesc(triu(corrected_p))
hold on
alpha(matr)

xticklabels({'RSC','M2','PPC','S1','V1/V2'})
yticklabels({'RSC','M2','PPC','S1','V1/V2'})
xticks(1:5);yticks(1:5)
colorbar()
xticklabels({'RSC','M2','PPC','S1','V1/V2'})



for i = 1:5
    for j = 1:5
        pval(i,j) = ranksum(decayMean{i}',decayMean{j}');
    end
end

matr =triu(ones(5,5));
matr(eye(5,5)==1) = NaN;
matr(matr== 0)= NaN;

subplot(1,2,2)
pval(isnan(matr)) = NaN;
[corrected_p, h]=helper.bonf_holm(pval);
imagesc(triu(corrected_p))
hold on
alpha(matr)

xticklabels({'RSC','M2','PPC','S1','V1/V2'})
yticklabels({'RSC','M2','PPC','S1','V1/V2'})
xticks(1:5);yticks(1:5)
colorbar()
caxis([0 0.05])

ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];

caxis([0 0.05])

ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
    
saveas(fig, fullfile(saveDir,'sumDecay.fig'),'fig')
saveas(fig, fullfile(saveDir,'sumDecay.png'),'png')
saveas(fig, fullfile(saveDir,'sumDecay.pdf'),'pdf')


fig=figure();
ax = subplot(1,2,1);

boxplot([rise{1}';rise{2}';rise{3}';rise{4}';rise{5}'],...
    [ones(length(rise{1}),1);2*ones(length(rise{2}),1);3*ones(length(rise{3}),1);...
    4*ones(length(rise{4}),1),...
    ;5*ones(length(rise{5}),1)],'symbol','');
hold on
ylabel('Rise time(ms)')
box off
% ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
ylim([16 20])
xlim([0.5 5.5])
xticklabels({'RSC','M2','PPC','S1','V1/V2'})

for i = 1:5
    for j = 1:5
        pval(i,j) = ranksum(riseMean{i}',riseMean{j}');
    end
end


subplot(1,2,2)
pval(isnan(matr)) = NaN;
[corrected_p, h]=helper.bonf_holm(pval);

matr =triu(ones(5,5));
matr(eye(5,5)==1) = NaN;
matr(matr== 0)= NaN;

subplot(1,2,2)
pval(isnan(matr)) = NaN;
[corrected_p, h]=helper.bonf_holm(pval);
imagesc(triu(corrected_p))
hold on
alpha(matr)

xticklabels({'RSC','M2','PPC','S1','V1/V2'})
yticklabels({'RSC','M2','PPC','S1','V1/V2'})
xticks(1:5);yticks(1:5)
colorbar()
caxis([0 0.05])

ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];

saveas(fig, fullfile(saveDir,'sumRise.fig'),'fig')
saveas(fig, fullfile(saveDir,'sumRise.png'),'png')
saveas(fig, fullfile(saveDir,'sumRise.pdf'),'pdf')



fig=figure();
subplot(1,2,1)

% violin(snr)
boxplot([snr{1};snr{2};snr{3};snr{4};snr{5}],...
    [ones(length(snr{1}),1);2*ones(length(snr{2}),1);3*ones(length(snr{3}),1);...
    4*ones(length(snr{4}),1),...
    ;5*ones(length(snr{5}),1)],'symbol','');
hold on
ylabel('SNR')
box off
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
ylim([0 10])
xticklabels({'RSC','M2','PPC','S1/S2','V1/V2'})

for i = 1:5
    for j = 1:5
        pval(i,j) = ranksum(snrMean{i}',snrMean{j}');
    end
end


subplot(1,2,2)
pval(isnan(matr)) = NaN;
[corrected_p, h]=helper.bonf_holm(pval);

matr =triu(ones(5,5));
matr(eye(5,5)==1) = NaN;
matr(matr== 0)= NaN;

subplot(1,2,2)
pval(isnan(matr)) = NaN;
[corrected_p, h]=helper.bonf_holm(pval);
imagesc(triu(corrected_p))
hold on
alpha(matr)

xticklabels({'RSC','M2','PPC','S1/S2','V1/V2'})
yticklabels({'RSC','M2','PPC','S1/S2','V1/V2'})
xticks(1:5);yticks(1:5)
colorbar()
caxis([0 0.05])

ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];

saveas(fig, fullfile(saveDir,'SNR.fig'),'fig')
saveas(fig, fullfile(saveDir,'SNR.png'),'png')
saveas(fig, fullfile(saveDir,'SNR.pdf'),'pdf')


fig=figure();
subplot(1,2,1)

% violin(snr)
boxplot([activity{1};activity{2};activity{3};activity{4};activity{5}],...
    [ones(length(activity{1}),1);2*ones(length(activity{2}),1);3*ones(length(activity{3}),1);...
    4*ones(length(activity{4}),1),...
    ;5*ones(length(activity{5}),1)],'symbol','');
hold on
ylabel('Activity level')
box off
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
ylim([0 1])
xticklabels({'RSC','M2','PPC','S1','V1/V2'})

for i = 1:5
    for j = 1:5
        pval(i,j) = ranksum(activityMedian{i}',activityMedian{j}');
    end
end


subplot(1,2,2)
pval(isnan(matr)) = NaN;
[corrected_p, h]=helper.bonf_holm(pval);

matr =triu(ones(5,5));
matr(eye(5,5)==1) = NaN;
matr(matr== 0)= NaN;

subplot(1,2,2)
pval(isnan(matr)) = NaN;
[corrected_p, h]=helper.bonf_holm(pval);
imagesc(triu(corrected_p))
hold on
alpha(matr)

xticklabels({'RSC','M2','PPC','S1','V1/V2'})
yticklabels({'RSC','M2','PPC','S1','V1/V2'})
xticks(1:5);yticks(1:5)
colorbar()
caxis([0 0.05])

ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];

saveas(fig, fullfile(saveDir,'activity.fig'),'fig')
saveas(fig, fullfile(saveDir,'activity.png'),'png')
saveas(fig, fullfile(saveDir,'activity.pdf'),'pdf')




function roiStat = getStats(sData)
%getRoiActivityStats Return struct of different roi activity statistics
%
%   roiStat = getRoiActivityStats(sData) Returns struct with statistics
%   about the roi signal for all rois in sData. 
%
%   roiStat = getRoiActivityStats(sData, CH) calculates the roiStat on the
%   specified channel number CH. CH is an integer. The default value is 2.
%
%   Output, roiStat contains the following fields:
%       peakDff         : Peak dff of the roi time series. 
%       signalToNoise   : Signal to noise 
%       activityLevel   : Fraction of time where activity is above noise
%   
    
% %     pstr = getFilePath(sData.sessionID, 'roiStat');
% %     if exist(pstr, 'file')
% %         roiStat = loaddata(sData.sessionID, 'roiStat');
% %         return
% %     end
    
    if nargin < 2
        CH = 2; % Most of us are imaging on ch2?
    end
    
    dff = double(squeeze(sData.imData.roiSignals.dff));
    deconv =  sData.imData.roiSignals.deconv;

    [nRois, nSamples] = size(dff);
    

    % Get max DFF of all rois.
    peakDff = max(dff, [], 2);
    
    
    % Get SNR of all Rois.
%     signalToNoise = zeros(nRois, 1);
    noiseLevel = zeros(nRois, 1);
    for i = 1:nRois
        noiseLevel(i) = real(GetSn(dff(i, :)));
    end
    
    dffSmooth = smoothdata(dff, 2, 'movmean', 7); % Smooth again with movmean
    
    isHigh = dffSmooth > noiseLevel;
    activityLevel_dff = sum(isHigh, 2) ./ nSamples;
    
    isHigh = deconv > 0;  
    activityLevel_deconv = sum(isHigh, 2) ./ nSamples;
    
    roiStat = struct('peakDff', peakDff, ...
                     'activityLevel_deconv', activityLevel_deconv,...
                     'activityLevel_dff',activityLevel_dff);

end