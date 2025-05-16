function [fig_activation_probability,mean_prob_temp] = activation_probability(ax,firing_fields,activation_probability,col)
    

xdata = 1:37; %105;%

for i = 1:length(xdata)
    mean_prob_temp(i) = nanmean(activation_probability(find(firing_fields == xdata(i))));
    std_prob(i) = nanstd(activation_probability(find(firing_fields == xdata(i))));
    no_cells(i) =length(find(firing_fields == xdata(i)));

end

std_prob  = std_prob(~isnan(mean_prob_temp))./sqrt(no_cells(~isnan(mean_prob_temp)));
xdata = xdata(~isnan(mean_prob_temp))*6/38;
mean_prob = mean_prob_temp(~isnan(mean_prob_temp));

fig_activation_probability = figure();
ax = subplot(1,3,[1,2]);

plot(ax,xdata,mean_prob','Color',col,'LineWidth',2)
patch(ax,[xdata  fliplr(xdata)],[mean_prob+std_prob fliplr(mean_prob-std_prob)],col,'linestyle','none','FaceAlpha', 0.4);

% xticks(ax,[0:31/5:37])
% xticklabels(ax,{'0','1','2','3','4','5','6','7'})
% xlim([0 37])
set(gca,'FontName','Arial','FontSize',12)
% yticks([0 0.05 0.1 0.15 0.2])
xlabel('Firing field times (s)')
ylabel('Activation probability (%)')
box off
xline(ax,1,'LineWidth',1,'LineStyle','--')
 



end
