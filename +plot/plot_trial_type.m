


for i = 1:length(data)
    for f = 1:length(data(i).sessionIDs)
        savedir = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/decoding',data(i).area);

        mean_var = nanmean(d_data_trial_type(i,f).d_data.accuracy);
        std_var  = nanstd(d_data_trial_type(i,f).d_data.accuracy);
        mean_var_chance = nanmean(d_data_trial_type_chance(i,f).d_data.accuracy);
        
        xdata =0:0.5:6;
        fig =figure();
        
        subplot(1,3,[1,2])
        plot(xdata,mean_var,'b','LineWidth',1.5)
        patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],'b','linestyle','none','FaceAlpha', 0.3);
        xline(1,'LineWidth',1,'LineStyle','--')
        hold on
        plot(xdata,mean_var_chance,'k','LineWidth',1.5,'LineStyle','--')
        ylabel('Correct odor decoding (%)')
        box('off')
        set(gca,'FontName','Arial','FontSize',12)
        xlabel('Time (s)')
        ylim([0.4 1])
        yticks([0.4:0.1:1])
        yticklabels(100*[0.4:0.1:1])
        
        subplot(1,3,3)
        bar([nanmean(mean_var(1:2)),nanmean(mean_var(3:end))],'FaceColor',[0.8 0.8 0.8])
        hold on
        errorbar([nanmean(mean_var(1:2)),nanmean(mean_var(3:end))],...
            [nanstd(mean_var(1:2)),nanstd(mean_var(3:end))],'k','LineStyle','none','LineWidth',1)

%         sigstar([1,2],ranksum(mean_var(1:2),mean_var(3:end)))
        
        odor = d_data_trial_type(i,f).d_data.accuracy(:,1:3);
        time = d_data_trial_type(i,f).d_data.accuracy(:,4:end);
        add_sig_bar.sigstar([1,2],ranksum(odor(:),time(:)))
        
        ylim([0.4 1])
        yticks([0.4:0.1:1])
        yticklabels(100*[0.4:0.1:1])
        xticklabels({'Odor bins','Delay bins'})
        xtickangle(45)
         ylabel('Correct odor decoding (%)')
           set(gca,'FontName','Arial','FontSize',12)
        box('off')
        

        saveas(fig,fullfile(savedir,'trial_type',data(i).sessionIDs{f},'acc.fig'),'fig')
        saveas(fig,fullfile(savedir,'trial_type',data(i).sessionIDs{f},'acc.pdf'),'pdf')
        saveas(fig,fullfile(savedir,'trial_type',data(i).sessionIDs{f},'acc.png'),'png')
        
        mean_accuracy{i}(f,:) = nanmean(d_data_trial_type(i,f).d_data.accuracy);
        mean_accuracy_chance{i}(f,:) = nanmean(d_data_trial_type_chance(i,f).d_data.accuracy);
    end
    
    close all
    
    mean_var = nanmean(mean_accuracy{i});
    std_var  = nanstd(mean_accuracy{i});
    fig =figure('Position',[600 100 600 300]);
    subplot(1,4,[1,2,3])

    plot(xdata,mean_var,'b','LineWidth',1.5)
    hold on
    patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],'b','linestyle','none','FaceAlpha', 0.3);
    xline(1,'LineWidth',1,'LineStyle','--')
    plot(xdata,mean_var_chance,'k','LineWidth',1.5,'LineStyle','--')
    ylabel('Correct odor decoding (%)')
    box('off')
    set(gca,'FontName','Arial','FontSize',15)
    xlabel('Time (s)')
    ylim([0.4 1])
    yticks([0.4:0.1:1])
    yticklabels(100*[0.4:0.1:1])

    
    subplot(1,4,4)
    bar([nanmean(mean_var(1:2)),nanmean(mean_var(3:end))],'FaceColor',[0.8 0.8 0.8])
    hold on
    errorbar([nanmean(mean_var(1:2)),nanmean(mean_var(3:end))],...
        [nanstd(mean_var(1:2)),nanstd(mean_var(3:end))],'k','LineStyle','none','LineWidth',1)
    
    ylim([0.4 1])
    yticks([0.4:0.1:1])
    yticklabels(100*[0.4:0.1:1])
    xticklabels({'Odor bins','Delay bins'})
    xtickangle(45)
    ylabel('Correct odor decoding (%)')
    set(gca,'FontName','Arial','FontSize',12)
    box('off')
    
        
    odor = mean_accuracy{i}(:,1:3);
    time = mean_accuracy{i}(:,4:end);
    add_sig_bar.sigstar([1,2],ranksum(odor(:),time(:)))
    
    saveas(fig,fullfile(savedir,'trial_type','acc.fig'),'fig')
    saveas(fig,fullfile(savedir,'trial_type','acc.pdf'),'pdf')
    saveas(fig,fullfile(savedir,'trial_type','acc.png'),'png')
    
end




fig = figure('Position',[600 100 600 300]);
for i = 1:length(data)
    for f = 1:length(data(i).sessionIDs)
        mean_session{i} = nanmean(mean_accuracy{i},2);
        mean_session_chance(i) = nanmean( mean_accuracy_chance{i}(:));
    end
    bar(i,nanmean(mean_session{i}),'FaceColor',[0.7,0.7,0.7])
    hold on
    errorbar(i,nanmean(mean_session{i}),nanstd(mean_session{i}),'k','LineWidth',1.5)
    scatter(i*ones(length(mean_session{i}),1),mean_session{i},120,'b')
end

yline(nanmean(mean_session_chance),'LineStyle','--','Color','k')
xticks([1:length(data)])
xticklabels({'RSC','CA1','M2','PPC','S1/S2','V1/V2'})
ylabel('Correct odor decoding (%)')
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

if ~isempty(find(corrected_p<0.05))
    for i  = 1:length(row)
     add_sig_bar.sigstar([row(i),col(i)],corrected_p(row(i),col(i)))
    end
end
savedir = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/decoding');

saveas(fig,fullfile(savedir,'acc.fig'),'fig')
saveas(fig,fullfile(savedir,'acc.pdf'),'pdf')
saveas(fig,fullfile(savedir,'acc.png'),'png')

