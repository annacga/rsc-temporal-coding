
    function [fig_selectivity_index,mean_SI_temp] =selectivity_index(firing_fields,SI)

    fig_selectivity_index = figure();

    xdata = 1:44;

    for i = 1:length(xdata)
        mean_SI_temp(i) = nanmean(SI(find(firing_fields == xdata(i))));
        std_SI_temp(i) = nanstd(SI(find(firing_fields == xdata(i))));

    end

    std_var  = std_SI_temp(~isnan(mean_SI_temp));
    xdata = xdata(~isnan(mean_SI_temp));
    mean_var = mean_SI_temp(~isnan(mean_SI_temp));

    figure()
    subplot(1,3,[1,2])
    plot(xdata,mean_var','b')
    patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],'b','linestyle','none','FaceAlpha', 0.4);
    xline(31/5,'LineWidth',1,'LineStyle','--')

    xticks([0:31/5:44])
    xticklabels({'0','1','2','3','4','5','6','7'})
    xlim([0 44])
    set(gca,'FontName','Arial','FontSize',12)
    % yticks([0 0.05 0.1 0.15 0.2])
    xlabel('Firing field times (s)')
    ylabel('Selectivity Index')
    corr(xdata',mean_var' ,'Type','Spearman')
    
    
    subplot(1,3,3)
    bar([nanmean(mean_SI_temp(1:6)),nanmean(mean_SI_temp(7:end))],'FaceColor',[0.8 0.8 0.8])
    hold on
    errorbar([nanmean(mean_SI_temp(1:3)),nanmean(mean_SI_temp(7:end))],...
        [nanstd(mean_SI_temp(1:6)),nanstd(mean_SI_temp(7:end))],'k','LineStyle','none','LineWidth',1)
    
    ylim([0 1.5])
    xticklabels({'Odor bins','Delay bins'})
    xtickangle(45)
    ylabel('Selectivity Index')
    set(gca,'FontName','Arial','FontSize',12)
    box('off')
    
    odor = mean_SI_temp(:,1:6);
    time = mean_SI_temp(:,7:end);
    add_sig_bar.sigstar([1,2],ranksum(odor(:),time(:)))

    box off

end