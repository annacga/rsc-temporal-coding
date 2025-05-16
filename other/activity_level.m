% Load Area Information
load.load_area_info();
load.load_area_sData();

% Initialize Variables
numAreas = 5; 
activity_level_ = cell(numAreas, 1);

activity_level_deconv = cell(numAreas, 1);
activity_level_dff = cell(numAreas, 1);
peak_DFF_ = cell(numAreas, 1);

box_input_activity_level_deconv_1 = cell(numAreas, 1);
box_input_activity_level_deconv_2 = cell(numAreas, 1);
box_input_activity_level_dff_1 = cell(numAreas, 1);
box_input_activity_level_dff_2 = cell(numAreas, 1);
box_input_dff_1 = cell(numAreas, 1);
box_input_dff_2 = cell(numAreas, 1);
box_input_SNR_1 = cell(numAreas, 1);
box_input_SNR_2 = cell(numAreas, 1);

% Process Data for Each Area
for i = 1:numAreas
    numSessions = length(data(i).sessionIDs);
    
    % Initialize Per-Area Metrics
    mean_activity_level_deconv = nan(1, numSessions);
    std_activity_level_deconv = nan(1, numSessions);
    mean_activity_level_dff = nan(1, numSessions);
    std_activity_level_dff = nan(1, numSessions);
    mean_DFF = nan(1, numSessions);
    std_DFF = nan(1, numSessions);

    % Process Each Session
    for j = 1:numSessions
        % Calculate ROI Statistics
        mData(i, j).roiStat = getStats(mData(i, j).sData);
        mData(i, j).roiStat.SNR = signal_stat.calculate_SNR(mData(i, j).sData);
        
        % Extract Metrics
        roiStat = mData(i, j).roiStat;
        
        activity_level_deconv{i} = [activity_level_deconv{i}; roiStat.activityLevel_deconv];
        activity_level_dff{i} = [activity_level_dff{i}; roiStat.activityLevel_dff];
        peak_DFF_{i} = [peak_DFF_{i}; roiStat.peakDff];

        % Compute Session-Level Metrics
        mean_activity_level_deconv(j) = nanmean(roiStat.activityLevel_deconv);
        std_activity_level_deconv(j) = nanstd(roiStat.activityLevel_deconv);
        mean_activity_level_dff(j) = nanmean(roiStat.activityLevel_dff);
        std_activity_level_dff(j) = nanstd(roiStat.activityLevel_dff);
        mean_DFF(j) = nanmean(roiStat.peakDff);
        std_DFF(j) = nanstd(roiStat.peakDff);
        
        % Prepare Data for Boxplots
        sessionIdx = j * ones(length(roiStat.activityLevel_deconv), 1);
        box_input_activity_level_deconv_1{i} = [box_input_activity_level_deconv_1{i}; roiStat.activityLevel_deconv];
        box_input_activity_level_deconv_2{i} = [box_input_activity_level_deconv_2{i}; sessionIdx];
        
        sessionIdx = j * ones(length(roiStat.activityLevel_dff), 1);
        box_input_activity_level_dff_1{i} = [box_input_activity_level_dff_1{i}; roiStat.activityLevel_dff];
        box_input_activity_level_dff_2{i} = [box_input_activity_level_dff_2{i}; sessionIdx];

        sessionIdx = j * ones(length(roiStat.peakDff), 1);
        box_input_dff_1{i} = [box_input_dff_1{i}; roiStat.peakDff];
        box_input_dff_2{i} = [box_input_dff_2{i}; sessionIdx];
        
        sessionIdx = j * ones(length(roiStat.SNR), 1);
        box_input_SNR_1{i} = [box_input_SNR_1{i}; roiStat.SNR];
        box_input_SNR_2{i} = [box_input_SNR_2{i}; sessionIdx];
    end

    % Plot Boxplots for Area
    fig = figure();
    subplotTitles = {'Activity Level (Deconv)', 'Activity Level (DFF)', 'Peak DFF', 'SNR'};
    boxInputVars = {
        {box_input_activity_level_deconv_1{i}, box_input_activity_level_deconv_2{i}},...
        {box_input_activity_level_dff_1{i}, box_input_activity_level_dff_2{i}},...
        {box_input_dff_1{i}, box_input_dff_2{i}},...
        {box_input_SNR_1{i}, box_input_SNR_2{i}}
    };

    for subplotIdx = 1:4
        subplot(4, 1, subplotIdx);
        boxplot(boxInputVars{subplotIdx}{1}, boxInputVars{subplotIdx}{2}, 'symbol', '');
        ylabel(subplotTitles{subplotIdx});
        box off;
        xticks(1:numSessions);
        xticklabels(data(i).sessionIDs);
        xtickangle(45);
    end
end

% Decay Time Plot
fig = figure();
subplot(1, 2, 1);
decayData = [decay{1}', decay{2}', decay{3}', decay{4}', decay{5}'];
decayGroup = [ones(length(decay{1}), 1); 2 * ones(length(decay{2}), 1); ...
              3 * ones(length(decay{3}), 1); 4 * ones(length(decay{4}), 1); ...
              5 * ones(length(decay{5}), 1)];
boxplot(decayData, decayGroup, 'symbol', '');
ylabel('Decay Time (ms)');
box off;
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ylim([0 4000]);
xticklabels({'RSC', 'M2', 'PPC', 'S1/S2', 'V1/V2'});

% Helper Function to Get ROI Stats
function roiStat = getStats(sData)
    dff = double(squeeze(sData.imData.roiSignals.dff));
    deconv = sData.imData.roiSignals.deconv;
    [nRois, nSamples] = size(dff);
    
    peakDff = max(dff, [], 2);
    noiseLevel = arrayfun(@(i) real(GetSn(dff(i, :))), 1:nRois)';
    dffSmooth = smoothdata(dff, 2, 'movmean', 7);
    
    activityLevel_dff = sum(dffSmooth > noiseLevel, 2) / nSamples;
    activityLevel_deconv = sum(deconv > 0, 2) / nSamples;
    
    roiStat = struct('peakDff', peakDff, ...
                     'activityLevel_deconv', activityLevel_deconv, ...
                     'activityLevel_dff', activityLevel_dff);
end
