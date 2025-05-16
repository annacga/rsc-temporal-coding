
 
firing_fields_A = [];
firing_fields_B = [];
field_size_A = [];
field_size_B = [];

for f = 1:length(data(1).sessionIDs)
    
    firing_fields_A = [firing_fields_A;mData(1,f).OdorA.field_location;mData(1,f).TimeA.field_location];
    firing_fields_B = [firing_fields_B;mData(1,f).OdorB.field_location;mData(1,f).TimeB.field_location];
    
    field_size_A = [firing_fields_A;mData(1,f).OdorA.field_size;mData(1,f).TimeA.field_size];
    field_size_B = [firing_fields_B;mData(1,f).OdorB.field_size;mData(1,f).TimeB.field_size];

end
    


firing_fields =  [firing_fields_A;firing_fields_B];
field_size =  [field_size_A;field_size_B]./ (31/5);

% Determine the new range based on grouping by twos
xdata = 1:18;

% Determine the mapping
mappedValues = ceil(firing_fields  / 2);

% Ensure mappedValues is within the newRange
mappedValues(mappedValues > length(xdata)) = length(xdata);


for i = 1:length(xdata)
    mean_var_temp(i) = nanmean(field_size(find(mappedValues == xdata(i))));
    std_var_temp(i) = nanstd(field_size(find(mappedValues == xdata(i))));
    no_cells(i) =length(find(firing_fields == xdata(i)));
end


figure()
std_var  = std_var_temp(~isnan(mean_var_temp))/sqrt(no_cells(~isnan(mean_var_temp)));
xdata = xdata(~isnan(mean_var_temp));
mean_var = mean_var_temp(~isnan(mean_var_temp));
plot(gca,xdata,mean_var','Color',col(1,:),'LineWidth',2)
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],col(1,:),'linestyle','none','FaceAlpha', 0.4);

xticks([0.5:31/5/2:39])
xticklabels({'0','1','2','3','4','5','6','7'})
xlim([0 20])
set(gca,'FontName','Arial','FontSize',12)
% yticks([0 0.05 0.1 0.15 0.2])
xlabel('Firing field times (s)')
ylabel('Firing field size(s)')
box off
xline(31/5/2,'LineWidth',1,'LineStyle','--')
ylim([0 4])
%xline(5*31/5+6*31/5,'LineWidth',1,'LineStyle','--')


%% separate trial types

whichSignal  = 'deconv';
z_score_level = 1;

rmaps_A_all_sequenceA =  [];
rmaps_B_all_sequenceA =  [];

rmaps_A_all_sequenceB = [];
rmaps_B_all_sequenceB = [];

for f = 1:length(data(1).sessionIDs)
    
    sequence = [mData(1,f).OdorA.indices; mData(1,f).TimeA.indices];
    rmaps_A = cat(1,mData(1,f).(whichSignal).rmapsAA(:,1:111,sequence),mData(1,f).(whichSignal).rmapsAB(:,1:111,sequence));
    rmaps_B = cat(1,mData(1,f).(whichSignal).rmapsBB(:,1:111,sequence),mData(1,f).(whichSignal).rmapsBA(:,1:111,sequence));
    
    rmaps_A  = reshape(nanmean(rmaps_A,1),size(rmaps_A,2),size(rmaps_A,3));
    rmaps_B  = reshape(nanmean(rmaps_B,1),size(rmaps_B,2),size(rmaps_B,3));
    
    signal_all = [rmaps_A';rmaps_B'];
    normedSignal    = normalize(signal_all,2,'zscore');%(signal_all  - min(signal_all , [], 2))./(max(signal_all , [], 2) - min(signal_all , [], 2));
    normedSignal_A = normedSignal(1:size(rmaps_A,2),:);
    normedSignal_B = normedSignal(size(rmaps_A,2)+1:end,:);
    
    rmaps_A_all_sequenceA = [rmaps_A_all_sequenceA;normedSignal_A];
    rmaps_B_all_sequenceA = [rmaps_B_all_sequenceA;normedSignal_B];
    
    sequence = [mData(1,f).OdorB.indices; mData(1,f).TimeB.indices];
    
    rmaps_A = cat(1,mData(1,f).(whichSignal).rmapsAA(:,1:111,sequence),mData(1,f).(whichSignal).rmapsAB(:,1:111,sequence));
    rmaps_B = cat(1,mData(1,f).(whichSignal).rmapsBB(:,1:111,sequence),mData(1,f).(whichSignal).rmapsBA(:,1:111,sequence));
    
    rmaps_A  = reshape(nanmean(rmaps_A,1),size(rmaps_A,2),size(rmaps_A,3));
    rmaps_B  = reshape(nanmean(rmaps_B,1),size(rmaps_B,2),size(rmaps_B,3));
    
    signal_all = [rmaps_A';rmaps_B'];
    normedSignal   = normalize(signal_all,2,'zscore');%(signal_all  - min(signal_all , [], 2))./(max(signal_all , [], 2) - min(signal_all , [], 2));
    normedSignal_A = normedSignal(1:size(rmaps_A,2),:);
    normedSignal_B = normedSignal(size(rmaps_A,2)+1:end,:);
    
    rmaps_A_all_sequenceB = [rmaps_A_all_sequenceB;normedSignal_A];
    rmaps_B_all_sequenceB = [rmaps_B_all_sequenceB;normedSignal_B];
end

% Define the middle column index (reference for alignment)
middle_col = round(size(rmaps_A_all_sequenceA, 2) / 2);
time_points = size(rmaps_A_all_sequenceA, 2);
time_interval = 10; % Duration in seconds
xtick_interval = 1; % Interval for x-ticks in seconds

% Sequence A cells during sequence A trials
[alignedMatrix_A_sequenceA, idx_A_sequenceA] = sort_and_align(rmaps_A_all_sequenceA, middle_col);
 
idxMatrix = horzcat(idx_A_sequenceA, rmaps_B_all_sequenceA); % Appends idx column array to the ROI matrix
sortedMatrix_B_sequenceA = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order
sortedMatrix_B_sequenceA(:, 1) = []; % Removes indexes from first column of sortedMatrix
idx_A_sequenceA = sortrows(idx_A_sequenceA(:, 1)); % Extract the sorting indices
alignedMatrix_B_sequenceA = NaN(size(sortedMatrix_B_sequenceA));
for i = 1:size(sortedMatrix_B_sequenceA, 1)
    peak_idx     = idx_A_sequenceA(i);
    shift_amount = middle_col - peak_idx;
    alignedMatrix_B_sequenceA(i, :) = circshift(sortedMatrix_B_sequenceA(i, :), shift_amount, 2);
end

% alignedMatrix_B_sequenceA = sortedMatrix_B_sequenceA;


% Sequence A cells during sequence B trials
[alignedMatrix_B_sequenceB, idx_B_sequenceB] = sort_and_align(rmaps_B_all_sequenceB, middle_col);

% Sequence B cells during sequence B trials using the same sorting as for Sequence A cells
idxMatrix = horzcat(idx_B_sequenceB, rmaps_A_all_sequenceB); % Appends idx column array to the ROI matrix
sortedMatrix_A_sequenceB = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order
sortedMatrix_A_sequenceB(:, 1) = []; % Removes indexes from first column of sortedMatrix
idx_B_sequenceB = sortrows(idx_B_sequenceB(:, 1)); % Extract the sorting indices
alignedMatrix_A_sequenceB = NaN(size(sortedMatrix_A_sequenceB));
for i = 1:size(sortedMatrix_A_sequenceB, 1)
    peak_idx     = idx_B_sequenceB(i);
    shift_amount = middle_col - peak_idx;
    alignedMatrix_A_sequenceB(i, :) = circshift(sortedMatrix_A_sequenceB(i, :), shift_amount, 2);
end

% alignedMatrix_A_sequenceB = sortedMatrix_A_sequenceB;

% Plot the aligned matrices
figure;

% Sequence A cells during sequence A trials
rmap_to_plot = alignedMatrix_A_sequenceA;
ax = subplot(2, 2, 1);
imagesc(rmap_to_plot, [0, z_score_level]);
xline(middle_col, 'Color', 'r', 'LineWidth', 1.5); hold on
% xline(37, 'Color', 'r', 'LineWidth', 1.5); hold on

xticks([1:6.2:111,111])
xticklabels([-9:9])
% xticklabels([0:18])
xlim([1 60])
xlim([1 time_points]);
set(ax, 'FontSize', 15);
xlabel("Time (s)");
ylabel('Sequence A cells');
title('Odor A trials');
yticks([1 size(alignedMatrix_A_sequenceA, 1)]);
yticklabels([1 size(alignedMatrix_A_sequenceA, 1)]);

% Sequence B cells during sequence A trials
rmap_to_plot = alignedMatrix_B_sequenceA;
ax = subplot(2, 2, 2);
imagesc(rmap_to_plot, [0, z_score_level]);
xline(middle_col, 'Color', 'r', 'LineWidth', 1.5); hold on
% xline(37, 'Color', 'r', 'LineWidth', 1.5); hold on

xticks([1:6.2:111,111])
xticklabels([-9:9])
% xticklabels([0:18])
xlim([1 time_points]);
set(ax, 'FontSize', 15);
xlabel("Time (s)");
title('Odor B trials');
yticks([1 size(alignedMatrix_B_sequenceA, 1)]);
yticklabels([1 size(alignedMatrix_B_sequenceA, 1)]);

% Sequence A cells during sequence B trials
rmap_to_plot = alignedMatrix_A_sequenceB;
ax = subplot(2, 2, 3);
imagesc(rmap_to_plot, [0, z_score_level]);
xline(middle_col, 'Color', 'r', 'LineWidth', 1.5); hold on
% xline(37, 'Color', 'r', 'LineWidth', 1.5); hold on

xticks([1:6.2:111,111])
xticklabels([-9:9])
% xticklabels([0:18])
xlim([1 time_points]);
set(ax, 'FontSize', 15);
xlabel("Time (s)");
ylabel('Sequence B cells');
yticks([1 size(alignedMatrix_A_sequenceB, 1)]);
yticklabels([1 size(alignedMatrix_A_sequenceB, 1)]);

% Sequence B cells during sequence B trials
rmap_to_plot = alignedMatrix_B_sequenceB;
ax = subplot(2, 2, 4);
imagesc(rmap_to_plot, [0, z_score_level]);
xline(middle_col, 'Color', 'r', 'LineWidth', 1.5); hold on
% xline(37, 'Color', 'r', 'LineWidth', 1.5); hold on

xticks([1:6.2:111,111])
xticklabels([-9:9])
% xticklabels([0:18])
xlim([1 time_points]);
set(ax, 'FontSize', 15);
xlabel("Time (s)");
yticks([1 size(alignedMatrix_B_sequenceB, 1)]);
yticklabels([1 size(alignedMatrix_B_sequenceB, 1)]);



% Helper function to sort and align rows
function [alignedMatrix, idx] = sort_and_align(rmaps, middle_col)
    % Sort rows by peak activity time
    [~, idx] = max(rmaps(:, 1:37), [], 2); % Finds the peak column index for each row
    idxMatrix = horzcat(idx, rmaps); % Appends idx column array to the ROI matrix
    sortedMatrix = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order
    sortedIndices = sortrows(idxMatrix(:, 1)); % Extract the sorting indices
    sortedMatrix(:, 1) = []; % Removes indexes from first column of sortedMatrix

    % Align sorted rows so that the peaks are in the middle
    alignedMatrix = NaN(size(sortedMatrix));
    for i = 1:size(sortedMatrix, 1)
        peak_idx = sortedIndices(i);
        shift_amount = middle_col - peak_idx;
        alignedMatrix(i, :) = circshift(sortedMatrix(i, :), shift_amount, 2);
    end
%     alignedMatrix = sortedMatrix;
end