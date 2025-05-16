% Load necessary data
load.load_area_info();
load.load_area_sData();
load.load_rmaps();
analysis.shuffle_rmaps();

% Set save directory
savedir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/classification_chance';
run_analysis = 1;

% Perform analysis or load existing data
if run_analysis
    for i = 1:length(data) - 1
        for f = 1:length(data(i).sessionIDs)
            sessionPath = fullfile(savedir, data(i).area, data(i).sessionIDs{f});
            if ~exist(sessionPath, 'dir')
                ClassifiedCells_chance            = analysis.classification(mData(i, f).('deconv'));
                mData(i, f).classification_chance = ClassifiedCells_chance;

                % Create directory and save results
                if ~exist(sessionPath, 'dir')
                    mkdir(sessionPath);
                end
                save(fullfile(sessionPath, 'ClassifiedCells_chance.mat'), 'ClassifiedCells_chance');
            end
        end
    end
else
    for i = 1:length(data) - 1
        for f = 1:length(data(i).sessionIDs)
            sessionPath = fullfile(savedir, data(i).area, data(i).sessionIDs{f});
            load(fullfile(sessionPath, 'ClassifiedCells_chance.mat'));
            mData(i, f).classification_chance = ClassifiedCells_chance;
        end
    end
end

% Analyze selectivity of sequence cells
analysis.selectivity_sequence_cells_chance();

% Prepare figure for plotting
fig_areas = figure();
hax_area_time = subplot(2, 1, 1);
hold(hax_area_time, 'on');
hax_area_odor = subplot(2, 1, 2);
hold(hax_area_odor, 'on');

% Initialize variables
sequenceA = [];
sequenceB = [];
odorA = [];
odorB = [];
time = [];
odor = [];

% Process and compute data
for i = 1:length(data) - 1
    for f = 1:length(data(i).sessionIDs)
        deconvSize = size(mData(i, f).deconv.rmapsAA, 3);
        
        timeA{i}(f) = 100 * length(mData(i, f).TimeA.indices) / deconvSize;
        timeB{i}(f) = 100 * length(mData(i, f).TimeB.indices) / deconvSize;

        odorA{i}(f) = 100 * length(mData(i, f).OdorA.indices) / deconvSize;
        odorB{i}(f) = 100 * length(mData(i, f).OdorB.indices) / deconvSize;

        time{i}(f) = 100 * length(unique([mData(i, f).TimeA.indices; mData(i, f).TimeB.indices])) / deconvSize;
        odor{i}(f) = 100 * length(unique([mData(i, f).OdorA.indices; mData(i, f).OdorB.indices])) / deconvSize;

        sequenceA{i}(f) = timeA{i}(f) + odorA{i}(f);
        sequenceB{i}(f) = timeB{i}(f) + odorB{i}(f);
    end
    
    mean_area_time(i) = nanmean(time{i});
    sem_area_time(i) = nanstd(time{i}) / sqrt(length(time{i}));
    mean_area_odor(i) = nanmean(odor{i});
    sem_area_odor(i) = nanstd(odor{i}) / sqrt(length(odor{i}));
end

% Display overall averages
disp(nanmean(cell2mat(timeA)));
disp(nanmean(cell2mat(timeB)));
disp(nanmean(cell2mat(odorA)));
disp(nanmean(cell2mat(odorB)));

% Plot time cell data
for i = 1:length(data) - 1
    bar(hax_area_time, i, mean_area_time(i), 'FaceColor', [0.7, 0.7, 0.7]);
    hold on;
    errorbar(hax_area_time, i, mean_area_time(i), sem_area_time(i), 'k', 'LineWidth', 1.5);
    scatter(hax_area_time, i * ones(length(time{i}), 1), time{i}, 120, 'k');
end

xticks(hax_area_time, 1:length(data) - 1);
xticklabels(hax_area_time, {'RSC', 'M2', 'PPC', 'S1/S2', 'V1/V2'});
ylabel(hax_area_time, 'Percentage - time cells(%)');
set(hax_area_time, 'FontName', 'Arial', 'FontSize', 15);
box('off');

% Compute and correct p-values
for i = 1:5
    for j = 1:5
        pval(i, j) = ranksum(time{i}', time{j}');
    end
end

% Apply Bonferroni-Holm correction
matr = triu(ones(5, 5));
matr(eye(5, 5) == 1) = NaN;
matr(matr == 0) = NaN;
pval(isnan(matr)) = NaN;
[corrected_p, ~] = helper.bonf_holm(pval);

% Add significance bars
[row, col] = find(corrected_p < 0.05);
if ~isempty(row)
    for idx = 1:length(row)
        add_sig_bar.sigstar([row(idx), col(idx)], corrected_p(row(idx), col(idx)));
    end
end

% Repeat for odor cell data
for i = 1:length(data) - 1
    bar(hax_area_odor, i, mean_area_odor(i), 'FaceColor', [0.7, 0.7, 0.7]);
    hold on;
    errorbar(hax_area_odor, i, mean_area_odor(i), sem_area_odor(i), 'k', 'LineWidth', 1.5);
    scatter(hax_area_odor, i * ones(length(odor{i}), 1), odor{i}, 120, 'k');
end

xticks(hax_area_odor, 1:length(data));
xticklabels(hax_area_odor, {'RSC', 'M2', 'PPC', 'S1/S2', 'V1/V2'});
ylabel(hax_area_odor, 'Percentage - odor cells(%)');
set(hax_area_odor, 'FontName', 'Arial', 'FontSize', 15);
box('off');

% Save figures
saveas(fig_areas, fullfile(savedir, 'plots', 'prct_all.pdf'), 'pdf');
saveas(fig_areas, fullfile(savedir, 'plots', 'prct_all.fig'), 'fig');
saveas(fig_areas, fullfile(savedir, 'plots', 'prct_all.png'), 'png');
