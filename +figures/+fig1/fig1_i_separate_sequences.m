

whichSignal  = 'deconv';
z_score_level = 3;

rmaps_A_all_sequenceA_hits =[];
rmaps_B_all_sequenceA_hits = [];

rmaps_A_all_sequenceA_CR = [];
rmaps_B_all_sequenceA_CR = [];

rmaps_A_all_sequenceA_misses = [];
rmaps_B_all_sequenceA_misses = [];

rmaps_A_all_sequenceA_FA = [];
rmaps_B_all_sequenceA_FA = [];

rmaps_A_all_sequenceB_hits =[];
rmaps_B_all_sequenceB_hits = [];

rmaps_A_all_sequenceB_CR = [];
rmaps_B_all_sequenceB_CR = [];

rmaps_A_all_sequenceB_misses = [];
rmaps_B_all_sequenceB_misses = [];

rmaps_A_all_sequenceB_FA = [];
rmaps_B_all_sequenceB_FA = [];

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
    
    hits_AA   = mData(1,f).sData.imData.variables.hits(AA_trial);
    misses_AA = mData(1,f).sData.imData.variables.misses(AA_trial);
    CR_AA     = mData(1,f).sData.imData.variables.CR(AA_trial);
    FA_AA     = mData(1,f).sData.imData.variables.FA(AA_trial);
    
    hits_AB   = mData(1,f).sData.imData.variables.hits(AB_trial);
    misses_AB = mData(1,f).sData.imData.variables.misses(AB_trial);
    CR_AB     = mData(1,f).sData.imData.variables.CR(AB_trial);
    FA_AB     = mData(1,f).sData.imData.variables.FA(AB_trial);
    
    hits_BA   = mData(1,f).sData.imData.variables.hits(BA_trial);
    misses_BA = mData(1,f).sData.imData.variables.misses(BA_trial);
    CR_BA     = mData(1,f).sData.imData.variables.CR(BA_trial);
    FA_BA     = mData(1,f).sData.imData.variables.FA(BA_trial);
    
    hits_BB   = mData(1,f).sData.imData.variables.hits(BB_trial);
    misses_BB = mData(1,f).sData.imData.variables.misses(BB_trial);
    CR_BB     = mData(1,f).sData.imData.variables.CR(BB_trial);
    FA_BB     = mData(1,f).sData.imData.variables.FA(BB_trial);
    
    sequence = [mData(1,f).OdorA.indices; mData(1,f).TimeA.indices];
    
    rmaps_A_hits = cat(1,mData(1,f).(whichSignal).rmapsAA(find(hits_AA),1:60,sequence),mData(1,f).(whichSignal).rmapsAB(find(hits_AB),1:60,sequence));
    rmaps_A_CR = cat(1,mData(1,f).(whichSignal).rmapsAA(find(CR_AA),1:60,sequence),mData(1,f).(whichSignal).rmapsAB(find(CR_AB),1:60,sequence));
    rmaps_A_misses = cat(1,mData(1,f).(whichSignal).rmapsAA(find(misses_AA),1:60,sequence),mData(1,f).(whichSignal).rmapsAB(find(misses_AB),1:60,sequence));
    rmaps_A_FA = cat(1,mData(1,f).(whichSignal).rmapsAA(find(FA_AA),1:60,sequence),mData(1,f).(whichSignal).rmapsAB(find(FA_AB),1:60,sequence));

    rmaps_B_hits = cat(1,mData(1,f).(whichSignal).rmapsBB(find(hits_BB),1:60,sequence),mData(1,f).(whichSignal).rmapsBA(find(hits_BA),1:60,sequence));
    rmaps_B_CR = cat(1,mData(1,f).(whichSignal).rmapsBB(find(CR_BB),1:60,sequence),mData(1,f).(whichSignal).rmapsBA(find(CR_BA),1:60,sequence));
    rmaps_B_misses = cat(1,mData(1,f).(whichSignal).rmapsBB(find(misses_BB),1:60,sequence),mData(1,f).(whichSignal).rmapsBA(find(misses_BA),1:60,sequence));
    rmaps_B_FA = cat(1,mData(1,f).(whichSignal).rmapsBB(find(FA_BB),1:60,sequence),mData(1,f).(whichSignal).rmapsBA(find(FA_BA),1:60,sequence));

%     rmaps_B = cat(1,mData(1,f).(whichSignal).rmapsBB(:,1:60,sequence),mData(1,f).(whichSignal).rmapsBA(:,1:60,sequence));
    
    rmaps_A_hits    = reshape(nanmean(rmaps_A_hits,1),size(rmaps_A_hits,2),size(rmaps_A_hits,3));
    rmaps_A_CR      = reshape(nanmean(rmaps_A_CR,1),size(rmaps_A_CR,2),size(rmaps_A_CR,3));
    rmaps_A_misses  = reshape(nanmean(rmaps_A_misses,1),size(rmaps_A_misses,2),size(rmaps_A_misses,3));
    rmaps_A_FA      = reshape(nanmean(rmaps_A_FA,1),size(rmaps_A_FA,2),size(rmaps_A_FA,3));

    rmaps_B_hits    = reshape(nanmean(rmaps_B_hits,1),size(rmaps_B_hits,2),size(rmaps_B_hits,3));
    rmaps_B_CR      = reshape(nanmean(rmaps_B_CR,1),size(rmaps_B_CR,2),size(rmaps_B_CR,3));
    rmaps_B_misses  = reshape(nanmean(rmaps_B_misses,1),size(rmaps_B_misses,2),size(rmaps_B_misses,3));
    rmaps_B_FA      = reshape(nanmean(rmaps_B_FA,1),size(rmaps_B_FA,2),size(rmaps_B_FA,3));

%     rmaps_B  = reshape(nanmean(rmaps_B,1),size(rmaps_B,2),size(rmaps_B,3));
    
    signal_all = [rmaps_A_hits';rmaps_A_CR';rmaps_A_misses';rmaps_A_FA';...
                   rmaps_B_hits';rmaps_B_CR';rmaps_B_misses';rmaps_B_FA'];
               
    normedSignal    = normalize(signal_all,2,'zscore');%(signal_all  - min(signal_all , [], 2))./(max(signal_all , [], 2) - min(signal_all , [], 2));
    normedSignal_A_hits     = normedSignal(1:size(rmaps_A_hits,2),:);
    normedSignal_A_CR       = normedSignal(size(rmaps_A_hits,2)+1:size(rmaps_A_hits,2)+size(rmaps_A_CR,2),:);
    normedSignal_A_misses   = normedSignal(size(rmaps_A_hits,2)+size(rmaps_A_CR,2)+1:size(rmaps_A_hits,2)+size(rmaps_A_CR,2)+size(rmaps_A_misses,2),:);
    normedSignal_A_FA       = normedSignal(size(rmaps_A_hits,2)+size(rmaps_A_CR,2)+size(rmaps_A_misses,2)+1:size(rmaps_A_hits,2)+size(rmaps_A_CR,2)+size(rmaps_A_misses,2)+size(rmaps_A_FA,2),:);
    
    size_A   = size(rmaps_A_hits,2)+size(rmaps_A_CR,2)+size(rmaps_A_FA,2)+size(rmaps_A_misses,2);
   
    normedSignal_B_hits     = normedSignal(size_A+1:size_A+size(rmaps_B_hits,2),:);
    normedSignal_B_CR       = normedSignal(size_A+size(rmaps_B_hits,2)+1:size_A+size(rmaps_B_hits,2)+size(rmaps_B_CR,2),:);
    normedSignal_B_misses   = normedSignal(size_A+size(rmaps_B_hits,2)+size(rmaps_B_CR,2)+1:size_A+size(rmaps_B_hits,2)+size(rmaps_B_CR,2)+size(rmaps_B_misses,2),:);
    normedSignal_B_FA       = normedSignal(size_A+size(rmaps_B_hits,2)+size(rmaps_B_CR,2)+size(rmaps_B_misses,2)+1:end,:);

%     normedSignal_B = normedSignal(size(rmaps_A,2)+1:end,:);
    
    rmaps_A_all_sequenceA_hits = [rmaps_A_all_sequenceA_hits;normedSignal_A_hits];
    rmaps_B_all_sequenceA_hits = [rmaps_B_all_sequenceA_hits;normedSignal_B_hits];
    
    rmaps_A_all_sequenceA_CR = [rmaps_A_all_sequenceA_CR;normedSignal_A_CR];
    rmaps_B_all_sequenceA_CR = [rmaps_B_all_sequenceA_CR;normedSignal_B_CR];
    
    rmaps_A_all_sequenceA_misses = [rmaps_A_all_sequenceA_misses;normedSignal_A_misses];
    rmaps_B_all_sequenceA_misses = [rmaps_B_all_sequenceA_misses;normedSignal_B_misses];
    
    rmaps_A_all_sequenceA_FA     = [rmaps_A_all_sequenceA_FA;normedSignal_A_FA];
    rmaps_B_all_sequenceA_FA     = [rmaps_B_all_sequenceA_FA;normedSignal_B_FA];
    
    sequence = [mData(1,f).OdorB.indices; mData(1,f).TimeB.indices];
    
    rmaps_A_hits = cat(1,mData(1,f).(whichSignal).rmapsAA(find(hits_AA),1:60,sequence),mData(1,f).(whichSignal).rmapsAB(find(hits_AB),1:60,sequence));
    rmaps_A_CR = cat(1,mData(1,f).(whichSignal).rmapsAA(find(CR_AA),1:60,sequence),mData(1,f).(whichSignal).rmapsAB(find(CR_AB),1:60,sequence));
    rmaps_A_misses = cat(1,mData(1,f).(whichSignal).rmapsAA(find(misses_AA),1:60,sequence),mData(1,f).(whichSignal).rmapsAB(find(misses_AB),1:60,sequence));
    rmaps_A_FA = cat(1,mData(1,f).(whichSignal).rmapsAA(find(FA_AA),1:60,sequence),mData(1,f).(whichSignal).rmapsAB(find(FA_AB),1:60,sequence));

    rmaps_B_hits = cat(1,mData(1,f).(whichSignal).rmapsBB(find(hits_BB),1:60,sequence),mData(1,f).(whichSignal).rmapsBA(find(hits_BA),1:60,sequence));
    rmaps_B_CR = cat(1,mData(1,f).(whichSignal).rmapsBB(find(CR_BB),1:60,sequence),mData(1,f).(whichSignal).rmapsBA(find(CR_BA),1:60,sequence));
    rmaps_B_misses = cat(1,mData(1,f).(whichSignal).rmapsBB(find(misses_BB),1:60,sequence),mData(1,f).(whichSignal).rmapsBA(find(misses_BA),1:60,sequence));
    rmaps_B_FA = cat(1,mData(1,f).(whichSignal).rmapsBB(find(FA_BB),1:60,sequence),mData(1,f).(whichSignal).rmapsBA(find(FA_BA),1:60,sequence));

%     rmaps_B = cat(1,mData(1,f).(whichSignal).rmapsBB(:,1:60,sequence),mData(1,f).(whichSignal).rmapsBA(:,1:60,sequence));
    
    rmaps_A_hits    = reshape(nanmean(rmaps_A_hits,1),size(rmaps_A_hits,2),size(rmaps_A_hits,3));
    rmaps_A_CR      = reshape(nanmean(rmaps_A_CR,1),size(rmaps_A_CR,2),size(rmaps_A_CR,3));
    rmaps_A_misses  = reshape(nanmean(rmaps_A_misses,1),size(rmaps_A_misses,2),size(rmaps_A_misses,3));
    rmaps_A_FA      = reshape(nanmean(rmaps_A_FA,1),size(rmaps_A_FA,2),size(rmaps_A_FA,3));

    rmaps_B_hits    = reshape(nanmean(rmaps_B_hits,1),size(rmaps_B_hits,2),size(rmaps_B_hits,3));
    rmaps_B_CR      = reshape(nanmean(rmaps_B_CR,1),size(rmaps_B_CR,2),size(rmaps_B_CR,3));
    rmaps_B_misses  = reshape(nanmean(rmaps_B_misses,1),size(rmaps_B_misses,2),size(rmaps_B_misses,3));
    rmaps_B_FA      = reshape(nanmean(rmaps_B_FA,1),size(rmaps_B_FA,2),size(rmaps_B_FA,3));

    
    %rmaps_A = cat(1,mData(1,f).(whichSignal).rmapsAA(:,1:60,sequence),mData(1,f).(whichSignal).rmapsAB(:,1:60,sequence));
    %rmaps_B = cat(1,mData(1,f).(whichSignal).rmapsBB(:,1:60,sequence),mData(1,f).(whichSignal).rmapsBA(:,1:60,sequence));
    
   % rmaps_A  = reshape(nanmean(rmaps_A,1),size(rmaps_A,2),size(rmaps_A,3));
   % rmaps_B  = reshape(nanmean(rmaps_B,1),size(rmaps_B,2),size(rmaps_B,3));
    
   signal_all = [rmaps_A_hits';rmaps_A_CR';rmaps_A_misses';rmaps_A_FA';...
       rmaps_B_hits';rmaps_B_CR';rmaps_B_misses';rmaps_B_FA'];
   
   normedSignal    = normalize(signal_all,2,'zscore');%(signal_all  - min(signal_all , [], 2))./(max(signal_all , [], 2) - min(signal_all , [], 2));
    normedSignal_A_hits     = normedSignal(1:size(rmaps_A_hits,2),:);
    normedSignal_A_CR       = normedSignal(size(rmaps_A_hits,2)+1:size(rmaps_A_hits,2)+size(rmaps_A_CR,2),:);
    normedSignal_A_misses   = normedSignal(size(rmaps_A_hits,2)+size(rmaps_A_CR,2)+1:size(rmaps_A_hits,2)+size(rmaps_A_CR,2)+size(rmaps_A_misses,2),:);
    normedSignal_A_FA       = normedSignal(size(rmaps_A_hits,2)+size(rmaps_A_CR,2)+size(rmaps_A_misses,2)+1:size(rmaps_A_hits,2)+size(rmaps_A_CR,2)+size(rmaps_A_misses,2)+size(rmaps_A_FA,2),:);
    
    size_A   = size(rmaps_A_hits,2)+size(rmaps_A_CR,2)+size(rmaps_A_FA,2)+size(rmaps_A_misses,2);
   
    normedSignal_B_hits     = normedSignal(size_A+1:size_A+size(rmaps_B_hits,2),:);
    normedSignal_B_CR       = normedSignal(size_A+size(rmaps_B_hits,2)+1:size_A+size(rmaps_B_hits,2)+size(rmaps_B_CR,2),:);
    normedSignal_B_misses   = normedSignal(size_A+size(rmaps_B_hits,2)+size(rmaps_B_CR,2)+1:size_A+size(rmaps_B_hits,2)+size(rmaps_B_CR,2)+size(rmaps_B_misses,2),:);
    normedSignal_B_FA       = normedSignal(size_A+size(rmaps_B_hits,2)+size(rmaps_B_CR,2)+size(rmaps_B_misses,2)+1:end,:);
   
   
    rmaps_A_all_sequenceB_hits = [rmaps_A_all_sequenceB_hits;normedSignal_A_hits];
    rmaps_B_all_sequenceB_hits = [rmaps_B_all_sequenceB_hits;normedSignal_B_hits];
    
    rmaps_A_all_sequenceB_CR = [rmaps_A_all_sequenceB_CR;normedSignal_A_CR];
    rmaps_B_all_sequenceB_CR = [rmaps_B_all_sequenceB_CR;normedSignal_B_CR];
    
    rmaps_A_all_sequenceB_misses = [rmaps_A_all_sequenceB_misses;normedSignal_A_misses];
    rmaps_B_all_sequenceB_misses = [rmaps_B_all_sequenceB_misses;normedSignal_B_misses];
    
    rmaps_A_all_sequenceB_FA = [rmaps_A_all_sequenceB_FA;normedSignal_A_FA];
    rmaps_B_all_sequenceB_FA = [rmaps_B_all_sequenceB_FA;normedSignal_B_FA];
  
%     signal_all = [rmaps_A';rmaps_B'];
%     normedSignal   = normalize(signal_all,2,'zscore');%(signal_all  - min(signal_all , [], 2))./(max(signal_all , [], 2) - min(signal_all , [], 2));
%     normedSignal_A = normedSignal(1:size(rmaps_A,2),:);
%     normedSignal_B = normedSignal(size(rmaps_A,2)+1:end,:);
%     
%     rmaps_A_all_sequenceB = [rmaps_A_all_sequenceB;normedSignal_A];
%     rmaps_B_all_sequenceB = [rmaps_B_all_sequenceB;normedSignal_B];
end

fig = figure();
[~, idx] = max(rmaps_A_all_sequenceA_hits(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
idxMatrix = horzcat(idx, rmaps_A_all_sequenceA_hits); % Appends idx column array to the ROI matrix.
sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.

idxMatrix = horzcat(idx, rmaps_B_all_sequenceA_hits);
sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.

rmap_to_plot = sortedMatrix_A; %  ;sortedMatrix_B];
ax = subplot(4,2,1);
imagesc(rmap_to_plot,[0,z_score_level]);
% yline(size(sortedMatrix_A,1),'Color','w', 'linewidth', 2)

xline(1,'Color','r', 'linewidth', 1.5) ; hold on
xline(6.2,'Color','r', 'linewidth', 1.5)
xline(37.2,'Color','r', 'linewidth', 1.5)
xline(43.4,'Color','r', 'linewidth', 1.5)

set(ax,'FontSize',15)
xlabel("Time (s)")
ylabel('Sequence A cells')
title('Odor A trials - hits')

xticks([1:6.1996:60])
xticklabels([0:10])
xlim([1 60])
yticks([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
% yticklabels([1 size(sortedMatrix_A,1), size(sortedMatrix_B,1)])

rmap_to_plot = sortedMatrix_B; %  ;sortedMatrix_B];
ax = subplot(4,2,2);
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
title('Odor B trials -hits')


% [~, idx] = max(rmaps_A_all_sequenceA_CR(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
idxMatrix = horzcat(idx, rmaps_A_all_sequenceA_CR); % Appends idx column array to the ROI matrix.
sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.

idxMatrix = horzcat(idx, rmaps_B_all_sequenceA_CR);
sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.

rmap_to_plot = sortedMatrix_A; %  ;sortedMatrix_B];
ax = subplot(4,2,3);
imagesc(rmap_to_plot,[0,z_score_level]);
% yline(size(sortedMatrix_A,1),'Color','w', 'linewidth', 2)

xline(1,'Color','r', 'linewidth', 1.5) ; hold on
xline(6.2,'Color','r', 'linewidth', 1.5)
xline(37.2,'Color','r', 'linewidth', 1.5)
xline(43.4,'Color','r', 'linewidth', 1.5)

set(ax,'FontSize',15)
xlabel("Time (s)")
ylabel('Sequence A cells')
title('Odor A trials - CR')

xticks([1:6.1996:60])
xticklabels([0:10])
xlim([1 60])
yticks([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
% yticklabels([1 size(sortedMatrix_A,1), size(sortedMatrix_B,1)])

rmap_to_plot = sortedMatrix_B; %  ;sortedMatrix_B];
ax = subplot(4,2,4);
imagesc(rmap_to_plot,[0,z_score_level]);
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
title('Odor B trials -CR')


% [~, idx] = max(rmaps_A_all_sequenceA_misses(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
idxMatrix = horzcat(idx, rmaps_A_all_sequenceA_misses); % Appends idx column array to the ROI matrix.
sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.

idxMatrix = horzcat(idx, rmaps_B_all_sequenceA_misses);
sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.

rmap_to_plot = sortedMatrix_A; %  ;sortedMatrix_B];
ax = subplot(4,2,5);
imagesc(rmap_to_plot,[0,z_score_level]);
% yline(size(sortedMatrix_A,1),'Color','w', 'linewidth', 2)

xline(1,'Color','r', 'linewidth', 1.5) ; hold on
xline(6.2,'Color','r', 'linewidth', 1.5)
xline(37.2,'Color','r', 'linewidth', 1.5)
xline(43.4,'Color','r', 'linewidth', 1.5)

set(ax,'FontSize',15)
xlabel("Time (s)")
ylabel('Sequence A cells')
title('Odor A trials - Misses')

xticks([1:6.1996:60])
xticklabels([0:10])
xlim([1 60])
yticks([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
% yticklabels([1 size(sortedMatrix_A,1), size(sortedMatrix_B,1)])

rmap_to_plot = sortedMatrix_B; %  ;sortedMatrix_B];
ax = subplot(4,2,6);
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
title('Odor B trials -Misses')


% [~, idx] = max(rmaps_A_all_sequenceA_FA(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
idxMatrix = horzcat(idx, rmaps_A_all_sequenceA_FA); % Appends idx column array to the ROI matrix.
sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.

idxMatrix = horzcat(idx, rmaps_B_all_sequenceA_FA);
sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.

rmap_to_plot = sortedMatrix_A; %  ;sortedMatrix_B];
ax = subplot(4,2,7);
imagesc(rmap_to_plot(sum(isnan(rmap_to_plot),2)<size(rmap_to_plot,2),:),[0,z_score_level]);
% yline(size(sortedMatrix_A,1),'Color','w', 'linewidth', 2)

xline(1,'Color','r', 'linewidth', 1.5) ; hold on
xline(6.2,'Color','r', 'linewidth', 1.5)
xline(37.2,'Color','r', 'linewidth', 1.5)
xline(43.4,'Color','r', 'linewidth', 1.5)

set(ax,'FontSize',15)
xlabel("Time (s)")
ylabel('Sequence A cells')
title('Odor A trials - FA')

xticks([1:6.1996:60])
xticklabels([0:10])
xlim([1 60])
yticks([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
% yticklabels([1 size(sortedMatrix_A,1), size(sortedMatrix_B,1)])

rmap_to_plot = sortedMatrix_B; %  ;sortedMatrix_B];
ax = subplot(4,2,8);
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
title('Odor B trials -FA')

saveas(fig,fullfile(save_dir,'fig_1i_separate_trial_type_A.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig_1i_separate_trial_type_A.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig_1i_separate_trial_type_A.png'),'png')

fig = figure();
[~, idx] = max(rmaps_B_all_sequenceB_hits(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
idxMatrix = horzcat(idx, rmaps_A_all_sequenceB_hits); % Appends idx column array to the ROI matrix.
sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.

idxMatrix = horzcat(idx, rmaps_B_all_sequenceB_hits);
sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.

rmap_to_plot = sortedMatrix_B;%;sortedMatrix_B];
ax2 = subplot(4,2,1);
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
ylabel('Sequence B cells')
title('Odor B trials -hits')
% yticks([1 size(sortedMatrix_AA,1)])

yticks([1 size(sortedMatrix_B,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
yticklabels([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_B,1)])

rmap_to_plot = sortedMatrix_A;
ax2 = subplot(4,2,2);
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
title('Odor A trials -hits')
% yticks([1 size(sortedMatrix_AA,1)])

yticks([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
yticklabels([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_B,1)])


% [~, idx] = max(rmaps_B_all_sequenceB_CR(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
idxMatrix = horzcat(idx, rmaps_A_all_sequenceB_CR); % Appends idx column array to the ROI matrix.
sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.

idxMatrix = horzcat(idx, rmaps_B_all_sequenceB_CR);
sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.

rmap_to_plot = sortedMatrix_B;%;sortedMatrix_B];
ax2 = subplot(4,2,3);
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
ylabel('Sequence B cells')
title('Odor B trials -CR')
% yticks([1 size(sortedMatrix_AA,1)])

yticks([1 size(sortedMatrix_B,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
yticklabels([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_B,1)])

rmap_to_plot = sortedMatrix_A;
ax2 = subplot(4,2,4);
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
title('Odor A trials -CR')
% yticks([1 size(sortedMatrix_AA,1)])

yticks([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
yticklabels([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_B,1)])

% [~, idx] = max(rmaps_B_all_sequenceB_hits(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
idxMatrix = horzcat(idx, rmaps_A_all_sequenceB_misses); % Appends idx column array to the ROI matrix.
sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.

idxMatrix = horzcat(idx, rmaps_B_all_sequenceB_misses);
sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.

rmap_to_plot = sortedMatrix_B;%;sortedMatrix_B];
ax2 = subplot(4,2,5);
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
ylabel('Sequence B cells')
title('Odor B trials -Misses')
% yticks([1 size(sortedMatrix_AA,1)])

yticks([1 size(sortedMatrix_B,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
yticklabels([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_B,1)])

rmap_to_plot = sortedMatrix_A;
ax2 = subplot(4,2,6);
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
title('Odor A trials -Misses')
% yticks([1 size(sortedMatrix_AA,1)])

yticks([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
yticklabels([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_B,1)])


% [~, idx] = max(rmaps_B_all_sequenceB_FA(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
idxMatrix = horzcat(idx, rmaps_A_all_sequenceB_FA); % Appends idx column array to the ROI matrix.
sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.

idxMatrix = horzcat(idx, rmaps_B_all_sequenceB_FA);
sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.

rmap_to_plot = sortedMatrix_B;%;sortedMatrix_B];
ax2 = subplot(4,2,7);
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
ylabel('Sequence B cells')
title('Odor B trials -FA')
% yticks([1 size(sortedMatrix_AA,1)])

yticks([1 size(sortedMatrix_B,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
yticklabels([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_B,1)])

rmap_to_plot = sortedMatrix_A;
ax2 = subplot(4,2,8);
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
title('Odor A trials -FA')
% yticks([1 size(sortedMatrix_AA,1)])

yticks([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
yticklabels([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_B,1)])


saveas(fig,fullfile(save_dir,'fig_1i_separate_trial_type_B.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig_1i_separate_trial_type_B.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig_1i_separate_trial_type_B.png'),'png')

