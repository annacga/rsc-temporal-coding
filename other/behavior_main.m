
baseSaveDir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/behavior';

% Loop through all data entries
for i = 1:length(data)
    area = data(i).area;
    areaSaveDir = fullfile(baseSaveDir, area);
    
    % Loop through all sessions within the current data entry
    for sessionIdx = 1:length(data(i).sessionIDs)
        sessionID = data(i).sessionIDs{sessionIdx};
        sessionSaveDir = fullfile(areaSaveDir, sessionID);
        
        % Ensure session directory exists
        if ~exist(sessionSaveDir, 'dir')
            mkdir(sessionSaveDir);
        end
        
        % Process session data
        sessionData = mData(i, sessionIdx).sData;
        [behaviorFigure, performance, dValue] = plot.behavior(sessionData);
        
        % Save figures and performance data
        saveFigure(behaviorFigure, sessionSaveDir, 'fig_behavior_session');
        mData(i, sessionIdx).behavior.performance = performance;
        mData(i, sessionIdx).behavior.dvalue = dValue;
    end
end

% Generate area-level performance plots
for i = 1:length(data)
    area = data(i).area;
    areaSaveDir = fullfile(baseSaveDir, area);
    areaFigure = figure();
    
    % Plot performance for each session
    for sessionIdx = 1:length(data(i).sessionIDs)
        performance = mData(i, sessionIdx).behavior.performance;
        if ~isempty(performance)
            plot(performance, 'LineWidth', 2);
            hold on;
        end
    end
    
    % Format plot
    ylim([0 100]);
    xlabel('Trial');
    ylabel('Performance (%)');
    set(gca, 'FontSize', 14, 'FontName', 'Arial');
    box off;
    
    % Save area-level figure
    saveFigure(areaFigure, areaSaveDir, 'fig_behavior_area');
end

% Helper Function: Save Figures
function saveFigure(figHandle, saveDir, fileNameBase)
    saveas(figHandle, fullfile(saveDir, [fileNameBase, '.fig']));
    saveas(figHandle, fullfile(saveDir, [fileNameBase, '.png']));
    close(figHandle); % Close figure after saving to save memory
end
