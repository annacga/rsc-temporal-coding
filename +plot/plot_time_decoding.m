    


for i = 1:length(data)
    for f = 1:length(data(i).sessionIDs)
        
        savedir = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/decoding',data(i).area);

        for p = 1:5
            [d_data_time(i,f).d_data.rmse(p),d_data_time(i,f).d_data.rmse_vs_time(p,:)] = plotDecodingTime(d_data_time(i,f).d_data.iter{p}.predTime_test,d_data_time(i,f).d_data.iter{p}.realTime_test);
        end
        
        for p = 1:5
            [d_data_time_chance(i,f).d_data.rmse(p),d_data_time_chance(i,f).d_data.rmse_vs_time(p,:)] = plotDecodingTime(d_data_time_chance(i,f).d_data.iter{p}.predTime_test,d_data_time(i,f).d_data.iter{p}.realTime_test);
        end
        
        mean_var = nanmean(d_data_time(i,f).d_data.rmse_vs_time);
        std_var  = nanstd(d_data_time(i,f).d_data.rmse_vs_time);
        
        mean_var_chance = nanmean(d_data_time_chance(i,f).d_data.rmse_vs_time);
        
        xdata =0:0.5:6;
        fig =figure();
        
        subplot(1,3,[1,2])
        plot(xdata,mean_var,'b','LineWidth',1.5)
        patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],'b','linestyle','none','FaceAlpha', 0.3);
        hold on
        xline(1,'LineWidth',1,'LineStyle','--')
        plot(xdata,mean_var_chance,'k','LineWidth',1.5,'LineStyle','--')
        ylabel('Time decoding error (s)')
        box('off')
        set(gca,'FontName','Arial','FontSize',15)
        xlabel('Time (s)')
        ylim([0 4])
        yticks([0.:4])
        
        subplot(1,3,3)
        bar([nanmean(mean_var(1:3)),nanmean(mean_var(4:end))],'FaceColor',[0.8 0.8 0.8])
        hold on
        errorbar([nanmean(mean_var(1:3)),nanmean(mean_var(4:end))],...
            [nanstd(mean_var(1:3)),nanstd(mean_var(4:end))],'k','LineStyle','none','LineWidth',1)

        odor = d_data_time(i,f).d_data.rmse_vs_time(:,1:3);
        time = d_data_time(i,f).d_data.rmse_vs_time(:,4:end);
        add_sig_bar.sigstar([1,2],ranksum(odor(:),time(:)))

        ylim([0 4])
        yticks([0:4])
        xticklabels({'Odor bins','Delay bins'})
        xtickangle(45)
         ylabel('Time decoding error (s)')
        set(gca,'FontName','Arial','FontSize',15)
        box('off')
        

        saveas(fig,fullfile(savedir,'decoding',data(i).sessionIDs{f},'rmse.fig'),'fig')
        saveas(fig,fullfile(savedir,'decoding',data(i).sessionIDs{f},'rmse.pdf'),'pdf')
        saveas(fig,fullfile(savedir,'decoding',data(i).sessionIDs{f},'rmse.png'),'png')
        
        mean_rmse{i}(f,:) = nanmean(d_data_time(i,f).d_data.rmse_vs_time);
        mean_rmse_chance{i}(f,:) = nanmean(d_data_time_chance(i,f).d_data.rmse_vs_time);
        
    end
    
    
    mean_var = nanmean(mean_rmse{i});
    std_var  = nanstd(mean_rmse{i});
    mean_var_chance = nanmean(mean_rmse_chance{i});
    fig =figure('Position',[600 100 600 300]);
    subplot(1,4,[1,2,3])

    plot(xdata,mean_var,'b','LineWidth',1.5)
    patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],'b','linestyle','none','FaceAlpha', 0.3);
    xline(1,'LineWidth',1,'LineStyle','--')
    ylabel('Time decoding error (s)')
    box('off')
    set(gca,'FontName','Arial','FontSize',15)
    xlabel('Time (s)')
    ylim([0 4])
    yticks([0.:4])
    hold on
    plot(xdata,mean_var_chance,'k','LineWidth',1.5,'LineStyle','--')
    
    subplot(1,4,4)
    bar([nanmean(mean_var(1:3)),nanmean(mean_var(4:end))],'FaceColor',[0.8 0.8 0.8])
    hold on
    errorbar([nanmean(mean_var(1:3)),nanmean(mean_var(4:end))],...
        [nanstd(mean_var(1:3)),nanstd(mean_var(4:end))],'k','LineStyle','none','LineWidth',1)
    
    ylim([0 4])
    yticks([0:4])
    xticklabels({'Odor bins','Delay bins'})
    xtickangle(45)
    ylabel('Time decoding error (s)')
    set(gca,'FontName','Arial','FontSize',12)
    box('off')
    
    
    odor = mean_rmse{i}(:,1:3);
    time = mean_rmse{i}(:,4:end);
    add_sig_bar.sigstar([1,2],ranksum(odor(:),time(:)))

    saveas(fig,fullfile(savedir,'decoding','rmse.fig'),'fig')
    saveas(fig,fullfile(savedir,'decoding','rmse.pdf'),'pdf')
    saveas(fig,fullfile(savedir,'decoding','rmse.png'),'png')
end

fig = figure('Position',[600 100 600 300]);
for i = 1:length(data)
    for f = 1:length(data(i).sessionIDs)
        mean_session{i} = nanmean(mean_rmse{i},2);
        mean_session_chance(i) = nanmean(mean_rmse_chance{i}(:));
    end
    bar(i,nanmean(mean_session{i}),'FaceColor',[0.7,0.7,0.7])
    hold on
    errorbar(i,nanmean(mean_session{i}),nanstd(mean_session{i}),'k','LineWidth',1.5)
    scatter(i*ones(length(mean_session{i}),1),mean_session{i},120,'b')
end

yline(nanmean(mean_session_chance),'LineStyle','--','Color','k')
xticks([1:length(data)])
xticklabels({'RSC','CA1','M2','PPC','S1/S2','V1/V2'})
ylabel('Time decoding error (s)')
set(gca,'FontName','Arial','FontSize',15)
box('off')



% calculate all pvals with ranksum 
for i = 1:6
    for j = 1:6
        pval(i,j) = ranksum(mean_session{i}',mean_session{j}');
    end
end

matr =triu(ones(6,6));
matr(eye(6,6)==1) = NaN;
matr(matr== 0)= NaN;
pval(isnan(matr)) = NaN;
[corrected_p, ~]=helper.bonf_holm(pval);

[row,col]  = find(corrected_p<0.05);

add_sig_bar.sigstar([row,col],corrected_p(row,col))

savedir = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/decoding');

saveas(fig,fullfile(savedir,'rmse.fig'),'fig')
saveas(fig,fullfile(savedir,'rmse.pdf'),'pdf')
saveas(fig,fullfile(savedir,'rmse.png'),'png')



function [rmse,rmse_vs_time] = plotDecodingTime(predTime, time)

timeGaps  = 0:0.5:6;

predError = zeros(size(time));
 for i = 1:length(time)
     predError(i)      = abs(time(i)-predTime(i));
 end


rmse = nanmean(predError);

timebins =unique(time);
for i =1:length(unique(time))
    rmse_vs_time(i) = nanmean(predError(find(time ==timebins(i))));
end

end