max_segments = [];
k = 0;
for i = 1:length(data)-1
    for f = 1:length(data(i).sessionIDs)
        [fig_behavior_session,mData(i,f).behavior.performance,mData(i,f).behavior.dvalue] = plot.behavior(mData(i,f).sData);
        mData(i,f).behavior.performance(end-1:end) = [];
        close all
        max_segments = max([max_segments,length(mData(i,f).behavior.performance)]);
        k = k+1;
    end
end

performance_all = NaN(k,max_segments-2);
k = 1;
for i = 1:length(data)-1
    for f = 1:length(data(i).sessionIDs)
        mData(i,f).behavior.performance(end-1:end) = [];

        performance_all(k,1:length(mData(i,f).behavior.performance)) = mData(i,f).behavior.performance;
        k = k+1;
    end
end

fig = figure('Position',[0 0 600 300]);
mean_var = nanmean(performance_all(:,1:100) ,1);
std_var  = nanstd(performance_all(:,1:100),1)/sqrt(k-1);
xdata = 1:length(mean_var);
plot(mean_var,'Color','k','LineWidth',1.5)
hold on
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],'k','linestyle','none','FaceAlpha', 0.3);

lengthSegments =1:max_segments;
hold on

ylim([0 100])
xlim([1 100])
ylabel('Performance %')
box off
xticks([1,20:20:100])
xlabel('Trials')
set(gca,'FontName','Arial','FontSize',15)
legend('off')

ax = gca;
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
ax.LineWidth = 1.5;

trials =[];
total_performance =[];
for i = 1:length(data)-1
    for f = 1:length(data(i).sessionIDs)
        trials(end+1) = length(mData(i,f).sData.imData.variables.response);
        total_performance(end+1) = (nansum(mData(i,f).sData.imData.variables.CR)+nansum(mData(i,f).sData.imData.variables.hits))/length(mData(i,f).sData.imData.variables.response);
    end
end

fprintf('Mice complete %4.1f +/- %4.1f trials per session(mean +/- SEM) \n',nanmean(trials),nanstd(trials)/sqrt(length(trials)))
fprintf('The average performance was %4.1f %% +/- %4.1f %% trials per session (mean +/- SEM) \n',nanmean(100*total_performance),nanstd(100*total_performance)/sqrt(length(total_performance)))

saveas(fig,fullfile(save_dir,'fig_1d.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig_1d.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig_1d.png'),'png')


