

i = 1;
number_rois =[];
for f = 1:length(data(i).sessionIDs)
    number_rois(end+1) = length(mData(i,f).sData.imData.roiSignals.rois);
end

fprintf('We measured %4.1f RSC neurons in  %4.1f FOVs \n',nansum(number_rois), length(data(i).sessionIDs))


% OdorA 
session_odorA = 10; id_odorA = 754;

% OdorB
session_odorB = 8; id_odorB = 330; 

% TimeA:
session_timeA = 4; id_timeA =  170;

% Time B:
session_timeB = 9;id_timeB = 291; 

odor_cells_color = [239,35,60]/255;
z_score_level = 4;

odor_A = [142 215 150]./255;
odor_B = [154 193 209]./255;

fig = figure('Position',[0 0 600 1200]);
ax = subplot(8,2,[1,3,5]);
rmapsAA = mData(1,session_odorA ).deconv.rmapsAA(:,:,id_odorA);
rmapsAB = mData(1,session_odorA ).deconv.rmapsAB(:,:,id_odorA);
rmapsBA = mData(1,session_odorA ).deconv.rmapsBA(:,:,id_odorA);
rmapsBB = mData(1,session_odorA ).deconv.rmapsBB(:,:,id_odorA);

rmap_to_plot = [rmapsAA;rmapsAB;rmapsBA;rmapsBB];
rmap_to_plot = smoothdata(normalize(rmap_to_plot,2),2,'gaussian','SmoothingFactor', 0.8);
imagesc(rmap_to_plot,[0,z_score_level]);
xline(1,'Color','k', 'linewidth', 2) ; hold on
xline(6,'Color','k', 'linewidth', 2)
xline(36,'Color','k', 'linewidth', 2)
xline(42,'Color','k', 'linewidth', 2)
colormap(flipud(colormap('gray')));
yline(size(rmapsAA,1),'Color','k', 'linewidth', 2)
yline(size(rmapsAA,1)+size(rmapsAB,1),'Color','k', 'linewidth', 2)
yline(size(rmapsAA,1)+size(rmapsAB,1)+size(rmapsBA,1),'Color','k', 'linewidth', 2)
xticks([])
xlim([1 60])
set(ax,'FontSize',15)
ylabel("# Trial")
% set(gcf,'Renderer', 'painters', 'Position', [1200 200 350 900])      
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
ax.LineWidth = 1.5;

ax =subplot(8,2,7);
plot(nanmean([rmapsAA;rmapsAB]),'LineWidth',1.5,'Color',odor_A)
hold on
plot(nanmean([rmapsBA;rmapsBB]),'LineWidth',1.5,'Color',odor_B)

mean_var = nanmean([rmapsAA;rmapsAB]);
std_var  = nanstd([rmapsAA;rmapsAB])/sqrt(size([rmapsBA;rmapsBB],1));
xdata = 1:length(mean_var);
patch(ax,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],odor_A,'linestyle','none','FaceAlpha', 0.3);

mean_var = nanmean([rmapsBA;rmapsBB]);
std_var  = nanstd([rmapsBA;rmapsBB])/sqrt(size([rmapsBA;rmapsBB],1));
xdata = 1:length(mean_var);
patch(ax,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],odor_B,'linestyle','none','FaceAlpha', 0.3);

xline(1,'Color','k', 'linewidth', 2) ; hold on
xline(6,'Color','k', 'linewidth', 2)
xline(36,'Color','k', 'linewidth', 2)
xline(42,'Color','k', 'linewidth', 2)
xticks([1:6:60,59])
xticklabels([0:10])
xlim([1 60])
xlabel("Time (s)")
set(gca,'FontSize',15)
box off

ax = subplot(8,2,[2,4,6]);

% session_odorB = 8; id_odorB = 39; %okay fig 12

rmapsAA = mData(1,session_odorB ).deconv.rmapsAA(:,:,id_odorB);
rmapsAB = mData(1,session_odorB ).deconv.rmapsAB(:,:,id_odorB);
rmapsBA = mData(1,session_odorB ).deconv.rmapsBA(:,:,id_odorB);
rmapsBB = mData(1,session_odorB ).deconv.rmapsBB(:,:,id_odorB);

rmap_to_plot = [rmapsAA;rmapsAB;rmapsBA;rmapsBB];
rmap_to_plot = smoothdata(normalize(rmap_to_plot,2),2,'gaussian','SmoothingFactor', 0.8);
imagesc(rmap_to_plot,[0,z_score_level]);
xline(1,'Color','k', 'linewidth', 2) ; hold on
xline(6,'Color','k', 'linewidth', 2)
xline(36,'Color','k', 'linewidth', 2)
xline(42,'Color','k', 'linewidth', 2)
colormap(flipud(colormap('gray')));
yline(size(rmapsAA,1),'Color','k', 'linewidth', 2)
yline(size(rmapsAA,1)+size(rmapsAB,1),'Color','k', 'linewidth', 2)
yline(size(rmapsAA,1)+size(rmapsAB,1)+size(rmapsBA,1),'Color','k', 'linewidth', 2)
xlim([1 60])

xticks([])
xlim([1 60])
set(gca,'FontSize',15)
ylabel("# Trial")
% set(ax,'Renderer', 'painters', 'Position', [1200 200 350 900])      
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
ax.LineWidth = 1.5;

ax =subplot(8,2,8);
plot(nanmean([rmapsAA;rmapsAB]),'LineWidth',1.5,'Color',odor_A)
hold on
plot(nanmean([rmapsBA;rmapsBB]),'LineWidth',1.5,'Color',odor_B)

mean_var = nanmean([rmapsAA;rmapsAB]);
std_var  = nanstd([rmapsAA;rmapsAB])/sqrt(size([rmapsBA;rmapsBB],1));
xdata = 1:length(mean_var);
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],odor_A,'linestyle','none','FaceAlpha', 0.3);

mean_var = nanmean([rmapsBA;rmapsBB]);
std_var  = nanstd([rmapsBA;rmapsBB])/sqrt(size([rmapsBA;rmapsBB],1));
xdata = 1:length(mean_var);
patch(ax,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],odor_B,'linestyle','none','FaceAlpha', 0.3);


xline(1,'Color','k', 'linewidth', 2) ; hold on
xline(6,'Color','k', 'linewidth', 2)
xline(36,'Color','k', 'linewidth', 2)
xline(42,'Color','k', 'linewidth', 2)
xticks([1:6:60,59])
xticklabels([0:10])
xlim([1 60])
xlabel("Time (s)")
set(ax,'FontSize',15)
box off

ax = subplot(8,2,[9,11,13]);
rmapsAA = mData(1,session_timeA ).deconv.rmapsAA(:,:,id_timeA);
rmapsAB = mData(1,session_timeA ).deconv.rmapsAB(:,:,id_timeA);
rmapsBA = mData(1,session_timeA ).deconv.rmapsBA(:,:,id_timeA);
rmapsBB = mData(1,session_timeA ).deconv.rmapsBB(:,:,id_timeA);

rmap_to_plot = [rmapsAA;rmapsAB;rmapsBA;rmapsBB];
rmap_to_plot = smoothdata(normalize(rmap_to_plot,2),2,'gaussian','SmoothingFactor', 0.8);
imagesc(rmap_to_plot,[0,z_score_level]);
xline(1,'Color','k', 'linewidth', 2) ; hold on
xline(6,'Color','k', 'linewidth', 2)
xline(36,'Color','k', 'linewidth', 2)
xline(42,'Color','k', 'linewidth', 2)
colormap(flipud(colormap('gray')));
yline(size(rmapsAA,1),'Color','k', 'linewidth', 2)
yline(size(rmapsAA,1)+size(rmapsAB,1),'Color','k', 'linewidth', 2)
yline(size(rmapsAA,1)+size(rmapsAB,1)+size(rmapsBA,1),'Color','k', 'linewidth', 2)
xticks([])
xlim([1 60])
set(ax,'FontSize',15)
ylabel("# Trial")
% set(gcf,'Renderer', 'painters', 'Position', [1200 200 350 900])      
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
ax.LineWidth = 1.5;

ax = subplot(8,2,15);
plot(nanmean([rmapsAA;rmapsAB]),'LineWidth',1.5,'Color',odor_A)
hold on
plot(nanmean([rmapsBA;rmapsBB]),'LineWidth',1.5,'Color',odor_B)

mean_var = nanmean([rmapsAA;rmapsAB]);
std_var  = nanstd([rmapsAA;rmapsAB])/sqrt(size([rmapsBA;rmapsBB],1));
xdata = 1:length(mean_var);
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],odor_A,'linestyle','none','FaceAlpha', 0.3);

mean_var = nanmean([rmapsBA;rmapsBB]);
std_var  = nanstd([rmapsBA;rmapsBB])/sqrt(size([rmapsBA;rmapsBB],1));
xdata = 1:length(mean_var);
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],odor_B,'linestyle','none','FaceAlpha', 0.3);

xline(1,'Color','k', 'linewidth', 2) ; hold on
xline(6,'Color','k', 'linewidth', 2)
xline(36,'Color','k', 'linewidth', 2)
xline(42,'Color','k', 'linewidth', 2)
xticks([1:6:60,59])
xticklabels([0:10])
xlim([1 60])
xlabel("Time (s)")
set(ax,'FontSize',15)
box off

ax = subplot(8,2,[10,12,14])
rmapsAA = mData(1,session_timeB ).deconv.rmapsAA(:,:,id_timeB);
rmapsAB = mData(1,session_timeB ).deconv.rmapsAB(:,:,id_timeB);
rmapsBA = mData(1,session_timeB ).deconv.rmapsBA(:,:,id_timeB);
rmapsBB = mData(1,session_timeB ).deconv.rmapsBB(:,:,id_timeB);

rmap_to_plot = [rmapsAA;rmapsAB;rmapsBA;rmapsBB];
rmap_to_plot = smoothdata(normalize(rmap_to_plot,2),2,'gaussian','SmoothingFactor', 0.8);
imagesc(rmap_to_plot,[0,z_score_level]);
xline(1,'Color','k', 'linewidth', 2) ; hold on
xline(6,'Color','k', 'linewidth', 2)
xline(36,'Color','k', 'linewidth', 2)
xline(42,'Color','k', 'linewidth', 2)
colormap(flipud(colormap('gray')));
yline(size(rmapsAA,1),'Color','k', 'linewidth', 2)
yline(size(rmapsAA,1)+size(rmapsAB,1),'Color','k', 'linewidth', 2)
yline(size(rmapsAA,1)+size(rmapsAB,1)+size(rmapsBA,1),'Color','k', 'linewidth', 2)
xticks([])
xlim([1 60])
set(ax,'FontSize',15)
ylabel("# Trial")
set(gcf,'Renderer', 'painters', 'Position', [1200 200 350 900])      
%ax = gca;
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
ax.LineWidth = 1.5;

subplot(8,2,16)
plot(nanmean([rmapsAA;rmapsAB]),'LineWidth',1.5,'Color',odor_A)
hold on
plot(nanmean([rmapsBA;rmapsBB]),'LineWidth',1.5,'Color',odor_B)

mean_var = nanmean([rmapsAA;rmapsAB]);
std_var  = nanstd([rmapsAA;rmapsAB])/sqrt(size([rmapsBA;rmapsBB],1));
xdata = 1:length(mean_var);
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],odor_A,'linestyle','none','FaceAlpha', 0.3);

mean_var = nanmean([rmapsBA;rmapsBB]);
std_var  = nanstd([rmapsBA;rmapsBB])/sqrt(size([rmapsBA;rmapsBB],1));
xdata = 1:length(mean_var);
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],odor_B,'linestyle','none','FaceAlpha', 0.3);

xline(1,'Color','k', 'linewidth', 2) ; hold on
xline(6,'Color','k', 'linewidth', 2)
xline(36,'Color','k', 'linewidth', 2)
xline(42,'Color','k', 'linewidth', 2)
xticks([1:6:60,59])
xticklabels([0:10])
xlim([1 60])
xlabel("Time (s)")
set(gca,'FontSize',15)
box off

saveas(fig,fullfile(save_dir,'fig_1f.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig_1f.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig_1f.png'),'png')

