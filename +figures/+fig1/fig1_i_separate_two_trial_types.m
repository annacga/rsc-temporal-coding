whichSignal  = 'deconv';
z_score_level = 3;

% Initialize variables
rmaps_A_all_sequenceA_correct = [];
rmaps_B_all_sequenceA_correct = [];

rmaps_A_all_sequenceA_incorrect = [];
rmaps_B_all_sequenceA_incorrect = [];

rmaps_A_all_sequenceB_correct = [];
rmaps_B_all_sequenceB_correct = [];

rmaps_A_all_sequenceB_incorrect = [];
rmaps_B_all_sequenceB_incorrect = [];


for f = 1:length(data(1).sessionIDs)
    k=1; 
    AA_trial = [];
    AB_trial = [];
    BA_trial = [];
    BB_trial = [];
    for p=1:length(mData(1,f).sData.imData.variables.trialIndices)
        if mData(1,f).sData.imData.variables.odors(k,3)==2 && mData(1,f).sData.imData.variables.odors(k+1,3)==2
            AA_trial(end+1) = p;
        end
        if mData(1,f).sData.imData.variables.odors(k,3)==2 && mData(1,f).sData.imData.variables.odors(k+1,3)==1
            AB_trial(end+1) = p;
        end
        if mData(1,f).sData.imData.variables.odors(k,3)==1 && mData(1,f).sData.imData.variables.odors(k+1,3)==1
            BB_trial(end+1) = p;
        end
        if mData(1,f).sData.imData.variables.odors(k,3)==1 && mData(1,f).sData.imData.variables.odors(k+1,3)==2
            BA_trial(end+1) = p;
        end
        k=k+2;
    end
    
    
    correct_trials_AA = [find(mData(1,f).sData.imData.variables.hits(AA_trial)),find(mData(1,f).sData.imData.variables.CR(AA_trial)) ];
    incorrect_trials_AA = [find(mData(1,f).sData.imData.variables.misses(AA_trial)),find(mData(1,f).sData.imData.variables.FA(AA_trial)) ];

    correct_trials_AB = [find(mData(1,f).sData.imData.variables.hits(AB_trial)),find(mData(1,f).sData.imData.variables.CR(AB_trial)) ];
    incorrect_trials_AB = [find(mData(1,f).sData.imData.variables.misses(AB_trial)),find(mData(1,f).sData.imData.variables.FA(AB_trial)) ];

    correct_trials_BB = [find(mData(1,f).sData.imData.variables.hits(BB_trial)),find(mData(1,f).sData.imData.variables.CR(BB_trial)) ];
    incorrect_trials_BB = [find(mData(1,f).sData.imData.variables.misses(BB_trial)),find(mData(1,f).sData.imData.variables.FA(BB_trial)) ];

    correct_trials_BA = [find(mData(1,f).sData.imData.variables.hits(BA_trial)),find(mData(1,f).sData.imData.variables.CR(BA_trial)) ];
    incorrect_trials_BA = [find(mData(1,f).sData.imData.variables.misses(BA_trial)),find(mData(1,f).sData.imData.variables.FA(BA_trial)) ];
    
    print("AA")
    length(correct_trials_AA )
    length(incorrect_trials_AA )
    print("AB")
    length(correct_trials_AB )
    length(incorrect_trials_AB )

    print("BB")
    length(correct_trials_BB )
    length(incorrect_trials_BB )
    print("BA")
    length(correct_trials_BA )
    length(incorrect_trials_BA)
    
    sequence = [mData(1,f).OdorA.indices; mData(1,f).TimeA.indices];
    
    rmaps_A_correct = cat(1,mData(1,f).(whichSignal).rmapsAA(correct_trials_AA,1:60,sequence),mData(1,f).(whichSignal).rmapsAB(correct_trials_AB,1:60,sequence));
    rmaps_A_incorrect = cat(1,mData(1,f).(whichSignal).rmapsAA(incorrect_trials_AA,1:60,sequence),mData(1,f).(whichSignal).rmapsAB(incorrect_trials_AB,1:60,sequence));

    rmaps_B_correct = cat(1,mData(1,f).(whichSignal).rmapsBB(correct_trials_BB,1:60,sequence),mData(1,f).(whichSignal).rmapsBA(correct_trials_BA,1:60,sequence));
    rmaps_B_incorrect = cat(1,mData(1,f).(whichSignal).rmapsBB(incorrect_trials_BB,1:60,sequence),mData(1,f).(whichSignal).rmapsBA(incorrect_trials_BA,1:60,sequence));

    rmaps_A_correct    = reshape(nanmean(rmaps_A_correct,1),size(rmaps_A_correct,2),size(rmaps_A_correct,3));
    rmaps_A_incorrect    = reshape(nanmean(rmaps_A_incorrect,1),size(rmaps_A_incorrect,2),size(rmaps_A_incorrect,3));
    rmaps_B_correct    = reshape(nanmean(rmaps_B_correct,1),size(rmaps_B_correct,2),size(rmaps_B_correct,3));
    rmaps_B_incorrect    = reshape(nanmean(rmaps_B_incorrect,1),size(rmaps_B_incorrect,2),size(rmaps_B_incorrect,3));
    
    signal_all = [rmaps_A_correct';rmaps_A_incorrect';rmaps_B_correct';rmaps_B_incorrect'];
               
    normedSignal    = normalize(signal_all,2,'zscore');%(signal_all  - min(signal_all , [], 2))./(max(signal_all , [], 2) - min(signal_all , [], 2));
    normedSignal_A_correct     = normedSignal(1:size(rmaps_A_correct,2),:);
    normedSignal_A_incorrect   = normedSignal(size(rmaps_A_correct,2)+1:size(rmaps_A_correct,2)+size(rmaps_A_incorrect,2),:);
    normedSignal_B_correct     = normedSignal(size(rmaps_A_correct,2)+size(rmaps_A_incorrect,2)+1:size(rmaps_A_correct,2)+size(rmaps_A_incorrect,2)+size(rmaps_B_correct,2),:);
    normedSignal_B_incorrect   = normedSignal(size(rmaps_A_correct,2)+size(rmaps_A_incorrect,2)+size(rmaps_B_correct,2)+1:end,:);
    
%     normedSignal_B = normedSignal(size(rmaps_A,2)+1:end,:);
    
    rmaps_A_all_sequenceA_correct = [rmaps_A_all_sequenceA_correct;normedSignal_A_correct];
    rmaps_B_all_sequenceA_correct = [rmaps_B_all_sequenceA_correct;normedSignal_B_correct];
    
    rmaps_A_all_sequenceA_incorrect = [rmaps_A_all_sequenceA_incorrect;normedSignal_A_incorrect];
    rmaps_B_all_sequenceA_incorrect = [rmaps_B_all_sequenceA_incorrect;normedSignal_B_incorrect];

    
    sequence = [mData(1,f).OdorB.indices; mData(1,f).TimeB.indices];
     rmaps_A_correct = cat(1,mData(1,f).(whichSignal).rmapsAA(correct_trials_AA,1:60,sequence),mData(1,f).(whichSignal).rmapsAB(correct_trials_AB,1:60,sequence));
    rmaps_A_incorrect = cat(1,mData(1,f).(whichSignal).rmapsAA(incorrect_trials_AA,1:60,sequence),mData(1,f).(whichSignal).rmapsAB(incorrect_trials_AB,1:60,sequence));

    rmaps_B_correct = cat(1,mData(1,f).(whichSignal).rmapsBB(correct_trials_BB,1:60,sequence),mData(1,f).(whichSignal).rmapsBA(correct_trials_BA,1:60,sequence));
    rmaps_B_incorrect = cat(1,mData(1,f).(whichSignal).rmapsBB(incorrect_trials_BB,1:60,sequence),mData(1,f).(whichSignal).rmapsBA(incorrect_trials_BA,1:60,sequence));

    rmaps_A_correct    = reshape(nanmean(rmaps_A_correct,1),size(rmaps_A_correct,2),size(rmaps_A_correct,3));
    rmaps_A_incorrect    = reshape(nanmean(rmaps_A_incorrect,1),size(rmaps_A_incorrect,2),size(rmaps_A_incorrect,3));
    rmaps_B_correct    = reshape(nanmean(rmaps_B_correct,1),size(rmaps_B_correct,2),size(rmaps_B_correct,3));
    rmaps_B_incorrect    = reshape(nanmean(rmaps_B_incorrect,1),size(rmaps_B_incorrect,2),size(rmaps_B_incorrect,3));
    
    signal_all = [rmaps_A_correct';rmaps_A_incorrect';rmaps_B_correct';rmaps_B_incorrect'];
               
    normedSignal    = normalize(signal_all,2,'zscore');%(signal_all  - min(signal_all , [], 2))./(max(signal_all , [], 2) - min(signal_all , [], 2));
    normedSignal_A_correct     = normedSignal(1:size(rmaps_A_correct,2),:);
    normedSignal_A_incorrect   = normedSignal(size(rmaps_A_correct,2)+1:size(rmaps_A_correct,2)+size(rmaps_A_incorrect,2),:);
    normedSignal_B_correct     = normedSignal(size(rmaps_A_correct,2)+size(rmaps_A_incorrect,2)+1:size(rmaps_A_correct,2)+size(rmaps_A_incorrect,2)+size(rmaps_B_correct,2),:);
    normedSignal_B_incorrect   = normedSignal(size(rmaps_A_correct,2)+size(rmaps_A_incorrect,2)+size(rmaps_B_correct,2)+1:end,:);

   
    rmaps_A_all_sequenceB_correct = [rmaps_A_all_sequenceB_correct;normedSignal_A_correct];
    rmaps_B_all_sequenceB_correct = [rmaps_B_all_sequenceB_correct;normedSignal_B_correct];
    
    rmaps_A_all_sequenceB_incorrect = [rmaps_A_all_sequenceB_incorrect;normedSignal_A_incorrect];
    rmaps_B_all_sequenceB_incorrect = [rmaps_B_all_sequenceB_incorrect;normedSignal_B_incorrect];
    
   
end

fig = figure();
[~, idx] = max(rmaps_A_all_sequenceA_correct(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
idxMatrix = horzcat(idx, rmaps_A_all_sequenceA_correct); % Appends idx column array to the ROI matrix.
sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.

idxMatrix = horzcat(idx, rmaps_B_all_sequenceA_correct);
sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.

rmap_to_plot = sortedMatrix_A; %  ;sortedMatrix_B];
ax = subplot(2,2,1);
imagesc(rmap_to_plot(sum(isnan(rmap_to_plot),2)<size(rmap_to_plot,2),:),[0,z_score_level]);
% yline(size(sortedMatrix_A,1),'Color','w', 'linewidth', 2)

xline(1,'Color','r', 'linewidth', 1.5) ; hold on
xline(6.2,'Color','r', 'linewidth', 1.5)
xline(37.2,'Color','r', 'linewidth', 1.5)
xline(43.4,'Color','r', 'linewidth', 1.5)

set(ax,'FontSize',15)
xlabel("Time (s)")
ylabel('Sequence A cells')
title('Odor A trials - correct')

xticks([1:6.1996:60])
xticklabels([0:10])
xlim([1 60])
yticks([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
% yticklabels([1 size(sortedMatrix_A,1), size(sortedMatrix_B,1)])

rmap_to_plot = sortedMatrix_B; %  ;sortedMatrix_B];
ax = subplot(2,2,2);
imagesc(rmap_to_plot(sum(isnan(rmap_to_plot),2)<size(rmap_to_plot,2),:),[0,z_score_level]);
% yline(size(sortedMatrix_B,1),'Color','w', 'linewidth', 2)

xline(1,'Color','r', 'linewidth', 1.5) ; hold on
xline(6.2,'Color','r', 'linewidth', 1.5)
xline(37.2,'Color','r', 'linewidth', 1.5)
xline(43.4,'Color','r', 'linewidth', 1.5)

xticks([1:6.1996:60])
xticklabels([0:10])
xlim([1 60])
yticks([1 size(sortedMatrix_B,1)])%

set(ax,'FontSize',15)
xlabel("Time (s)")
title('Odor B trials - correct')


[~, idx] = max(rmaps_A_all_sequenceA_incorrect(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
idxMatrix = horzcat(idx, rmaps_A_all_sequenceA_incorrect); % Appends idx column array to the ROI matrix.
sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.

idxMatrix = horzcat(idx, rmaps_B_all_sequenceA_incorrect);
sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.

rmap_to_plot = sortedMatrix_A; %  ;sortedMatrix_B];
ax = subplot(2,2,3);
imagesc(rmap_to_plot(sum(isnan(rmap_to_plot),2)<size(rmap_to_plot,2),:),[0,z_score_level]);
% yline(size(sortedMatrix_A,1),'Color','w', 'linewidth', 2)

xline(1,'Color','r', 'linewidth', 1.5) ; hold on
xline(6.2,'Color','r', 'linewidth', 1.5)
xline(37.2,'Color','r', 'linewidth', 1.5)
xline(43.4,'Color','r', 'linewidth', 1.5)

set(ax,'FontSize',15)
xlabel("Time (s)")
ylabel('Sequence A cells')
title('Odor A trials - false')

xticks([1:6.1996:60])
xticklabels([0:10])
xlim([1 60])
yticks([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
% yticklabels([1 size(sortedMatrix_A,1), size(sortedMatrix_B,1)])

rmap_to_plot = sortedMatrix_B; %  ;sortedMatrix_B];
ax = subplot(2,2,4);
imagesc(rmap_to_plot(sum(isnan(rmap_to_plot),2)<size(rmap_to_plot,2),:),[0,z_score_level]);
% yline(size(sortedMatrix_B,1),'Color','w', 'linewidth', 2)

xline(1,'Color','r', 'linewidth', 1.5) ; hold on
xline(6.2,'Color','r', 'linewidth', 1.5)
xline(37.2,'Color','r', 'linewidth', 1.5)
xline(43.4,'Color','r', 'linewidth', 1.5)

xticks([1:6.1996:60])
xticklabels([0:10])
xlim([1 60])
yticks([1 size(sortedMatrix_B,1)])%

set(ax,'FontSize',15)
xlabel("Time (s)")
title('Odor B trials - false')


saveas(fig,fullfile(save_dir,'fig_1i_A.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig_1i_A.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig_1i_A.png'),'png')

fig = figure();
[~, idx] = max(rmaps_B_all_sequenceB_correct(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
idxMatrix = horzcat(idx, rmaps_A_all_sequenceB_correct); % Appends idx column array to the ROI matrix.
sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.

idxMatrix = horzcat(idx, rmaps_B_all_sequenceB_correct);
sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.

rmap_to_plot = sortedMatrix_B;%;sortedMatrix_B];
ax2 = subplot(2,2,1);
imagesc(rmap_to_plot(sum(isnan(rmap_to_plot),2)<size(rmap_to_plot,2),:),[0,z_score_level]);
% yline(size(sortedMatrix_A,1),'Color','w', 'linewidth', 2)

xline(1,'Color','r', 'linewidth', 1.5) ; hold on
xline(6.2,'Color','r', 'linewidth', 1.5)
xline(37.2,'Color','r', 'linewidth', 1.5)
xline(43.4,'Color','r', 'linewidth', 1.5)

xticks([1:6.1996:60])
xticklabels([0:10])
xlim([1 60])
set(ax2,'FontSize',15)
xlabel("Time (s)")
ylabel('Sequence B cells')
title('Odor B trials - correct')
% yticks([1 size(sortedMatrix_AA,1)])

yticks([1 size(sortedMatrix_B,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
yticklabels([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_B,1)])

rmap_to_plot = sortedMatrix_A;
ax2 = subplot(2,2,2);
imagesc(rmap_to_plot,[0,z_score_level]);
% yline(size(sortedMatrix_A,1),'Color','w', 'linewidth', 2)

xline(1,'Color','r', 'linewidth', 1.5) ; hold on
xline(6.2,'Color','r', 'linewidth', 1.5)
xline(37.2,'Color','r', 'linewidth', 1.5)
xline(43.4,'Color','r', 'linewidth', 1.5)

xticks([1:6.1996:60])
xticklabels([0:10])
xlim([1 60])
set(ax2,'FontSize',15)
xlabel("Time (s)")
title('Odor A trials -correct')
% yticks([1 size(sortedMatrix_AA,1)])

yticks([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
yticklabels([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_B,1)])


[~, idx] = max(rmaps_B_all_sequenceB_incorrect(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
idxMatrix = horzcat(idx, rmaps_A_all_sequenceB_incorrect); % Appends idx column array to the ROI matrix.
sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.

idxMatrix = horzcat(idx, rmaps_B_all_sequenceB_incorrect);
sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.

rmap_to_plot = sortedMatrix_B;%;sortedMatrix_B];
ax2 = subplot(2,2,3);
imagesc(rmap_to_plot(sum(isnan(rmap_to_plot),2)<size(rmap_to_plot,2),:),[0,z_score_level]);
% yline(size(sortedMatrix_A,1),'Color','w', 'linewidth', 2)

xline(1,'Color','r', 'linewidth', 1.5) ; hold on
xline(6.2,'Color','r', 'linewidth', 1.5)
xline(37.2,'Color','r', 'linewidth', 1.5)
xline(43.4,'Color','r', 'linewidth', 1.5)

xticks([1:6.1996:60])
xticklabels([0:10])
xlim([1 60])
set(ax2,'FontSize',15)
xlabel("Time (s)")
ylabel('Sequence B cells')
title('Odor B trials -false')
% yticks([1 size(sortedMatrix_AA,1)])

yticks([1 size(sortedMatrix_B,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
yticklabels([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_B,1)])

rmap_to_plot = sortedMatrix_A;
ax2 = subplot(2,2,4);
imagesc(rmap_to_plot(sum(isnan(rmap_to_plot),2)<size(rmap_to_plot,2),:),[0,z_score_level]);
% yline(size(sortedMatrix_A,1),'Color','w', 'linewidth', 2)

xline(1,'Color','r', 'linewidth', 1.5) ; hold on
xline(6.2,'Color','r', 'linewidth', 1.5)
xline(37.2,'Color','r', 'linewidth', 1.5)
xline(43.4,'Color','r', 'linewidth', 1.5)

xticks([1:6.1996:60])
xticklabels([0:10])
xlim([1 60])
set(ax2,'FontSize',15)
xlabel("Time (s)")
title('Odor A trials - false')
% yticks([1 size(sortedMatrix_AA,1)])

yticks([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
yticklabels([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_B,1)])


saveas(fig,fullfile(save_dir,'fig_1i_B.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig_1i_B.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig_1i_B.png'),'png')
