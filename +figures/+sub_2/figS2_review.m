% 
col(3,:) = [43 122 123]./255;
col(2,:) = [238 132 92]./255;
col(1,:) = [235 57 43]./255;
col(4,:) = [199 217 158]./255;
col(5,:) = [84 136 194]./255;

% %mData = analysis.field_info(mData,data);
fig = figure();
for i =1:5
firing_fields_A = [];
firing_fields_B = [];
for f = 1:length(data(i).sessionIDs)
    
    firing_fields_A = [firing_fields_A;mData(i,f).OdorA.field_location;mData(i,f).TimeA.field_location];
    firing_fields_B = [firing_fields_B;mData(i,f).OdorB.field_location;mData(i,f).TimeB.field_location];
    firing_field_session = [mData(i,f).OdorA.field_location;mData(i,f).TimeA.field_location;...
        mData(i,f).OdorB.field_location;mData(i,f).TimeB.field_location];
    [N, Edges] = histcounts(firing_field_session,22,'Normalization','probability','BinWidth',1,'BinEdges',[0:2:44]);%%[0:2:104]);%%
    sessionval{i}(f) = nansum(N(1:4));
end
firing_fields   = [firing_fields_A(:);firing_fields_A(:)];

  
% x = [0 31/5];

[N, Edges] = histcounts(firing_fields,22,'Normalization','probability','BinWidth',1,'BinEdges',[0:2:44]);%%[0:2:104]);%%
hold on
plot(Edges(1:end-1)+1,N,'LineWidth',1.5,'Color',col(i,:))
%sessionval{i} = N;
end
xticks([0:31/5:44])
xticklabels({'0','1','2','3','4','5','6','7'})
xlim([-0.5 44])
set(gca,'FontName','Arial','FontSize',12)
yticks([0 0.05 0.1 0.15 0.2 0.25 0.3 0.35])
yticklabels([0 5 10 15 20 25 30 35])
ylim([0 0.40])
box off

xline(1*31/5,'LineWidth',1,'LineStyle','--')
xline(6*31/5,'LineWidth',1,'LineStyle','--')

xlabel('Firing field times (s)')
ylabel('Sequence cells (%)')

legend({'RSC','M2','PPC','S1/S2','V1/V2'})



figure()
for i =1:5
    bar(i,nanmean(sessionval{i}),'FaceColor','None')
    hold on
    errorbar(i,nanmean(sessionval{i}),nanstd(sessionval{i})/sqrt(length(sessionval{i})),'LineWidth',1.5,'Color',[0 0 0])
    scatter(i*ones(length(sessionval{i}),1),sessionval{i},70,'k')
end

yticks([0 0.05 0.1 0.15 0.2 0.25 0.3 0.35])
yticklabels([0 5 10 15 20 25 30 35])
xticks([1:5])
xticklabels({'RSC','M2','PPC','S1/S2','V1/V2'})
ylabel('Sequence cells during first odor presentation(%)')
set(gca,'FontName','Arial','FontSize',12)
box off

for i = 1:5
    for j = 1:5
        pval(i,j) = ranksum(sessionval{i}',sessionval{j}');
    end
end

matr =triu(ones(5,5));
matr(eye(5,5)==1) = NaN;
matr(matr== 0)= NaN;
pval(isnan(matr)) = NaN;
[corrected_p, ~]=helper.bonf_holm(pval);

[row,column]  = find(corrected_p<0.05);

for i = 1:length(row)
    add_sig_bar.sigstar([row(i),column(i)],corrected_p(row(i),column(i)))
end

whichSignal  = 'deconv';
z_score_level = 3;
fig = figure();
ax1 = subplot(2,1,1);
ax2 = subplot(2,1,2);
    
for i = 1:length(data)-1
    rmaps_A_all_sequenceA =  [];
    rmaps_B_all_sequenceA =  [];

    rmaps_A_all_sequenceB = [];
    rmaps_B_all_sequenceB = [];

    for f = 1:length(data(i).sessionIDs)

        sequence = [mData(i,f).OdorA.indices; mData(i,f).TimeA.indices];
        rmaps_A = cat(1,mData(i,f).(whichSignal).rmapsAA(:,1:60,sequence),mData(i,f).(whichSignal).rmapsAB(:,1:60,sequence));
        rmaps_B = cat(1,mData(i,f).(whichSignal).rmapsBB(:,1:60,sequence),mData(i,f).(whichSignal).rmapsBA(:,1:60,sequence));

        rmaps_A  = reshape(nanmean(rmaps_A,1),size(rmaps_A,2),size(rmaps_A,3));
        rmaps_B  = reshape(nanmean(rmaps_B,1),size(rmaps_B,2),size(rmaps_B,3));

        signal_all = [rmaps_A';rmaps_B'];
        normedSignal    = normalize(signal_all,2,'zscore');%(signal_all  - min(signal_all , [], 2))./(max(signal_all , [], 2) - min(signal_all , [], 2));
        normedSignal_A = normedSignal(1:size(rmaps_A,2),:);
        normedSignal_B = normedSignal(size(rmaps_A,2)+1:end,:);

        rmaps_A_all_sequenceA = [rmaps_A_all_sequenceA;normedSignal_A];
        rmaps_B_all_sequenceA = [rmaps_B_all_sequenceA;normedSignal_B];

        sequence = [mData(i,f).OdorB.indices; mData(i,f).TimeB.indices];

        rmaps_A = cat(1,mData(i,f).(whichSignal).rmapsAA(:,1:60,sequence),mData(i,f).(whichSignal).rmapsAB(:,1:60,sequence));
        rmaps_B = cat(1,mData(i,f).(whichSignal).rmapsBB(:,1:60,sequence),mData(i,f).(whichSignal).rmapsBA(:,1:60,sequence));

        rmaps_A  = reshape(nanmean(rmaps_A,1),size(rmaps_A,2),size(rmaps_A,3));
        rmaps_B  = reshape(nanmean(rmaps_B,1),size(rmaps_B,2),size(rmaps_B,3));

        signal_all = [rmaps_A';rmaps_B'];
        normedSignal   = normalize(signal_all,2,'zscore');%(signal_all  - min(signal_all , [], 2))./(max(signal_all , [], 2) - min(signal_all , [], 2));
        normedSignal_A = normedSignal(1:size(rmaps_A,2),:);
        normedSignal_B = normedSignal(size(rmaps_A,2)+1:end,:);

        rmaps_A_all_sequenceB = [rmaps_A_all_sequenceB;normedSignal_A];
        rmaps_B_all_sequenceB = [rmaps_B_all_sequenceB;normedSignal_B];
    end
    
   

    [~, idx] = max(rmaps_A_all_sequenceA(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
   
    [N, Edges] = histcounts(idx,22,'Normalization','probability','BinWidth',1,'BinEdges',[0:2:44]);%%[0:2:104]);%%
    plot(ax1,Edges(1:end-1)+1,N,'LineWidth',1.5,'Color',col(i,:))
    hold(ax1,'on')
    hold(ax2,'on')

    [~, idx] = max(rmaps_B_all_sequenceB(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
    [N, Edges] = histcounts(idx,22,'Normalization','probability','BinWidth',1,'BinEdges',[0:2:44]);%%[0:2:104]);%%
    plot(ax2,Edges(1:end-1)+1,N,'LineWidth',1.5,'Color',col(i,:))
  
  
end

set(ax1,'FontSize',15)
xlabel(ax1,"Peak time (s)")
ylabel(ax1,'Sequence A cells (%)')
title(ax1,'Odor A trials')
    
set(ax2,'FontSize',15)
xlabel(ax2,"Peak time (s)")
ylabel(ax2,'Sequence B cells (%)')
title(ax2,'Odor B trials')

xline(ax1,1*31/5,'LineWidth',1,'LineStyle','--')
xline(ax1,6*31/5,'LineWidth',1,'LineStyle','--')
xline(ax2,1*31/5,'LineWidth',1,'LineStyle','--')
xline(ax2,6*31/5,'LineWidth',1,'LineStyle','--')

xticks(ax1,[0:31/5:44])
xticklabels(ax1,{'0','1','2','3','4','5','6','7'})
xlim(ax1,[-0.5 44])
yticks(ax1,[0 0.1  0.2  0.3 0.4])
yticklabels(ax1,[0 10 20 30 40])
ylim(ax1,[0 0.45])
box(ax1,'off')


xticks(ax2,[0:31/5:44])
xticklabels(ax2,{'0','1','2','3','4','5','6','7'})
xlim(ax2,[-0.5 44])
yticks(ax2,[0 0.1  0.2  0.3 0.4])
yticklabels(ax2,[0 10 20 30 40])
ylim(ax2,[0 0.45])
box(ax2,'off')

