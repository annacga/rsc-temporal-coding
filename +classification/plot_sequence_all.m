
whichSignal  = 'deconv';
savedir = "/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/";

z_score_level = 3;
for i = 1:length(data)
    
    rmaps_AA_all_sequenceA =  [];
    rmaps_AB_all_sequenceA =  [];
    rmaps_BA_all_sequenceA =  [];
    rmaps_BB_all_sequenceA =  [];
    
    rmaps_AA_all_sequenceB = [];
    rmaps_AB_all_sequenceB = [];
    rmaps_BA_all_sequenceB =  [];
    rmaps_BB_all_sequenceB =  [];
    for f = 1:length(data(i).sessionIDs)
        
        sequence = [mData(i,f).OdorA.indices; mData(i,f).TimeA.indices];
        rmaps_AA = nanmean(mData(i,f).(whichSignal).rmapsAA(:,1:60,sequence),1);rmaps_AA = reshape(rmaps_AA,size(rmaps_AA,2),size(rmaps_AA,3));
        rmaps_AB = nanmean(mData(i,f).(whichSignal).rmapsAB(:,1:60,sequence),1);rmaps_AB = reshape(rmaps_AB,size(rmaps_AB,2),size(rmaps_AB,3));
        rmaps_BA = nanmean(mData(i,f).(whichSignal).rmapsBA(:,1:60,sequence),1);rmaps_BA = reshape(rmaps_BA,size(rmaps_BA,2),size(rmaps_BA,3));
        rmaps_BB = nanmean(mData(i,f).(whichSignal).rmapsBB(:,1:60,sequence),1);rmaps_BB = reshape(rmaps_BB,size(rmaps_BB,2),size(rmaps_BB,3));
        
        signal_all = [rmaps_AA';rmaps_AB' ;rmaps_BA' ;rmaps_BB'];
        normedSignal    = normalize(signal_all,2,'zscore');%(signal_all  - min(signal_all , [], 2))./(max(signal_all , [], 2) - min(signal_all , [], 2));
        normedSignal_AA = normedSignal(1:size(rmaps_AA,2),:);
        normedSignal_AB = normedSignal(size(rmaps_AA,2)+1:size(rmaps_AA,2)+size(rmaps_AB,2),:);
        normedSignal_BA = normedSignal(size(rmaps_AA,2)+size(rmaps_AB,2)+1:size(rmaps_AA,2)+size(rmaps_AB,2)+size(rmaps_BA,2),:);
        normedSignal_BB = normedSignal(size(rmaps_AA,2)+size(rmaps_AB,2)+size(rmaps_BA,2)+1:end,:);
        
        rmaps_AA_all_sequenceA = [rmaps_AA_all_sequenceA;normedSignal_AA];
        rmaps_AB_all_sequenceA = [rmaps_AB_all_sequenceA;normedSignal_AB];
        rmaps_BA_all_sequenceA = [rmaps_BA_all_sequenceA;normedSignal_BA];
        rmaps_BB_all_sequenceA = [rmaps_BB_all_sequenceA;normedSignal_BB];
        
        sequence = [mData(i,f).OdorB.indices; mData(i,f).TimeB.indices];
        
        rmaps_AA = nanmean(mData(i,f).(whichSignal).rmapsAA(:,1:60,sequence),1);rmaps_AA = reshape(rmaps_AA,size(rmaps_AA,2),size(rmaps_AA,3));
        rmaps_AB = nanmean(mData(i,f).(whichSignal).rmapsAB(:,1:60,sequence),1);rmaps_AB = reshape(rmaps_AB,size(rmaps_AB,2),size(rmaps_AB,3));
        rmaps_BA = nanmean(mData(i,f).(whichSignal).rmapsBA(:,1:60,sequence),1);rmaps_BA = reshape(rmaps_BA,size(rmaps_BA,2),size(rmaps_BA,3));
        rmaps_BB = nanmean(mData(i,f).(whichSignal).rmapsBB(:,1:60,sequence),1);rmaps_BB = reshape(rmaps_BB,size(rmaps_BB,2),size(rmaps_BB,3));
        
        signal_all = [rmaps_AA';rmaps_AB' ;rmaps_BA' ;rmaps_BB'];
        normedSignal    = normalize(signal_all,2,'zscore');%(signal_all  - min(signal_all , [], 2))./(max(signal_all , [], 2) - min(signal_all , [], 2));
        normedSignal_AA = normedSignal(1:size(rmaps_AA,2),:);
        normedSignal_AB = normedSignal(size(rmaps_AA,2)+1:size(rmaps_AA,2)+size(rmaps_AB,2),:);
        normedSignal_BA = normedSignal(size(rmaps_AA,2)+size(rmaps_AB,2)+1:size(rmaps_AA,2)+size(rmaps_AB,2)+size(rmaps_BA,2),:);
        normedSignal_BB = normedSignal(size(rmaps_AA,2)+size(rmaps_AB,2)+size(rmaps_BA,2)+1:end,:);
        
        rmaps_AA_all_sequenceB = [rmaps_AA_all_sequenceB;normedSignal_AA];
        rmaps_AB_all_sequenceB = [rmaps_AB_all_sequenceB;normedSignal_AB];
        rmaps_BA_all_sequenceB = [rmaps_BA_all_sequenceB;normedSignal_BA];
        rmaps_BB_all_sequenceB = [rmaps_BB_all_sequenceB;normedSignal_BB];
        
    end
    
    fig = figure();
    [~, idx] = max(rmaps_AA_all_sequenceA, [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
    idxMatrix = horzcat(idx, rmaps_AA_all_sequenceA); % Appends idx column array to the ROI matrix.
    sortedMatrix_AA = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix_AA(: , 1) = []; % Removes indexes from first column of sortedMatrix.
    
    idxMatrix = horzcat(idx, rmaps_AB_all_sequenceA);
    sortedMatrix_AB = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix_AB(: , 1) = []; % Removes indexes from first column of sortedMatrix.
    
    idxMatrix = horzcat(idx, rmaps_BA_all_sequenceA);
    sortedMatrix_BA = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix_BA(: , 1) = []; % Removes indexes from first column of sortedMatrix.
    
    idxMatrix = horzcat(idx, rmaps_BB_all_sequenceA);
    sortedMatrix_BB = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix_BB(: , 1) = []; % Removes indexes from first column of sortedMatrix.
    
    rmap_to_plot = [sortedMatrix_AA;sortedMatrix_AB;sortedMatrix_BA;sortedMatrix_BB];
    ax = subplot(1,2,1);
    imagesc(rmap_to_plot,[0,z_score_level]);
    yline(size(sortedMatrix_AA,1),'Color','w', 'linewidth', 2)
    yline(size(sortedMatrix_AA,1)+size(sortedMatrix_AB,1),'Color','w', 'linewidth', 2)
    yline(size(sortedMatrix_AA,1)+size(sortedMatrix_AB,1)+size(sortedMatrix_BA,1),'Color','w', 'linewidth', 2)
    
    xline(1,'Color','r', 'linewidth', 1.5) ; hold on
    xline(6.2,'Color','r', 'linewidth', 1.5)
    xline(37.2,'Color','r', 'linewidth', 1.5)
    xline(43.4,'Color','r', 'linewidth', 1.5)
    
    xticks([1:6.1996:60])
    xticklabels([0:10])
    xlim([1 60])
    yticks([1 size(sortedMatrix_AA,1)])
    set(ax,'FontSize',15)
    xlabel("Time (s)")
    ylabel('Sequence A cells')
    title('Sequence A')
    
    
    
    [~, idx] = max(rmaps_BB_all_sequenceB, [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
    idxMatrix = horzcat(idx, rmaps_AA_all_sequenceB); % Appends idx column array to the ROI matrix.
    sortedMatrix_AA = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix_AA(: , 1) = []; % Removes indexes from first column of sortedMatrix.
    
    idxMatrix = horzcat(idx, rmaps_AB_all_sequenceB);
    sortedMatrix_AB = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix_AB(: , 1) = []; % Removes indexes from first column of sortedMatrix.
    
    idxMatrix = horzcat(idx, rmaps_BA_all_sequenceB);
    sortedMatrix_BA = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix_BA(: , 1) = []; % Removes indexes from first column of sortedMatrix.
    
    idxMatrix = horzcat(idx, rmaps_BB_all_sequenceB);
    sortedMatrix_BB = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix_BB(: , 1) = []; % Removes indexes from first column of sortedMatrix.
    
    
    rmap_to_plot = [sortedMatrix_AA;sortedMatrix_AB;sortedMatrix_BA;sortedMatrix_BB];
    ax2 = subplot(1,2,2);
    imagesc(rmap_to_plot,[0,z_score_level]);
    yline(size(sortedMatrix_AA,1),'Color','w', 'linewidth', 2)
    yline(size(sortedMatrix_AA,1)+size(sortedMatrix_AB,1),'Color','w', 'linewidth', 2)
    yline(size(sortedMatrix_AA,1)+size(sortedMatrix_AB,1)+size(sortedMatrix_BA,1),'Color','w', 'linewidth', 2)
    
    xline(1,'Color','r', 'linewidth', 1.5) ; hold on
    xline(6.2,'Color','r', 'linewidth', 1.5)
    xline(37.2,'Color','r', 'linewidth', 1.5)
    xline(43.4,'Color','r', 'linewidth', 1.5)
    
    
    xticks([1:6.1996:60])
    xticklabels([0:10])
    xlim([1 60])
    set(ax2,'FontSize',15)
    xlabel("Time (s)")
    title('Sequence B')
    ylabel('Sequence B cells')
    yticks([1 size(sortedMatrix_AA,1)])
    
    
    saveas(fig,fullfile(savedir,'plots/classification',data(i).area,'plot_sequence.pdf'),'pdf')
    saveas(fig,fullfile(savedir,'plots/classification',data(i).area,'plot_sequence.fig'),'fig')
    saveas(fig,fullfile(savedir,'plots/classification',data(i).area,'plot_sequence.png'),'png')
    
end



