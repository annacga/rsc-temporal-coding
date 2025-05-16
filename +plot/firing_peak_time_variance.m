function   [fig, mean_var_temp] = firing_peak_time_variance(firing_fields,peak_time_var,col)

peak_time_var_inTime = peak_time_var; % from no of indices to time
% fig_firing_peak_time = figure();

xdata = 1:37;%99;%

for i = 1:length(xdata)
    mean_var_temp(i) = nanmean(peak_time_var_inTime(find(firing_fields == xdata(i))));
    std_var_temp(i) = nanstd(peak_time_var_inTime(find(firing_fields == xdata(i))));
    no_cells(i) =length(find(firing_fields == xdata(i)));

end


std_var  = std_var_temp(~isnan(mean_var_temp))/sqrt(no_cells(~isnan(mean_var_temp)));
xdata = xdata(~isnan(mean_var_temp));
mean_var = mean_var_temp(~isnan(mean_var_temp));
fig =figure();
subplot(1,3,[1,2])
plot(gca,xdata,mean_var','Color',col,'LineWidth',2)
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],col,'linestyle','none','FaceAlpha', 0.4);

xticks([0:31/5:38])
xticklabels({'0','1','2','3','4','5','6','7'})
% xlim([0 37])
set(gca,'FontName','Arial','FontSize',12)
% yticks([0 0.05 0.1 0.15 0.2])
xlabel('Firing field times (s)')
ylabel('Firing peak-time variance')
box off
xline(31/5,'LineWidth',1,'LineStyle','--')


end