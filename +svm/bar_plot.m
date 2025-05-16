

save_dir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/svm';


for i =1:length(data)
   
    fig = figure('Position',[0 0 750 300]);
        for f = 1:length(data(i).sessionIDs)

            Time_cells = unique([mData(i,f).TimeA.indices;mData(i,f).TimeB.indices]);
            Odor_cells = unique([mData(i,f).OdorA.indices;mData(i,f).OdorB.indices]);

            accuracy_time_cells_all_bins(f) = nanmean(mData(i,f).('all_time_bins').accuracy(Time_cells));
            accuracy_odor_cells_all_bins(f) = nanmean(mData(i,f).('all_time_bins').accuracy(Odor_cells));
            
            accuracy_time_cells_only_time(f) = nanmean(mData(i,f).('only_time').accuracy(Time_cells));
            accuracy_odor_cells_only_odor(f) = nanmean(mData(i,f).('only_odor').accuracy(Odor_cells));
            
            if ~isfield(mData(i,f).TimeA,'accuracy'); mData(i,f).TimeA.accuracy  = [];end
            if ~isfield(mData(i,f).TimeB,'accuracy'); mData(i,f).TimeB.accuracy  = [];end
            if ~isfield(mData(i,f).OdorA,'accuracy'); mData(i,f).OdorA.accuracy  = [];end
            if ~isfield(mData(i,f).OdorB,'accuracy'); mData(i,f).OdorB.accuracy  = [];end

            accuracy_time_firing_fields(f) = nanmean([mData(i,f).TimeA.accuracy';mData(i,f).TimeB.accuracy']);
            accuracy_odor_firing_fields(f) = nanmean([mData(i,f).OdorA.accuracy';mData(i,f).OdorB.accuracy']);

        end
        
        subplot(1,3,1)
        bar([nanmean(accuracy_odor_cells_all_bins),nanmean(accuracy_time_cells_all_bins)],...
            'FaceColor',[0.7 0.7 0.7]); hold on
        errorbar([nanmean(accuracy_odor_cells_all_bins),nanmean(accuracy_time_cells_all_bins)],...
            [nanstd(accuracy_odor_cells_all_bins),nanstd(accuracy_time_cells_all_bins)],...
            'LineStyle','none','LineWidth',1.5,'Color','k')
        title('All time bins')
        ylabel('% correct odor decoding per session')

        xticks([1 2])
        xticklabels({'Odor cells','Time cells'})
        xtickangle(45)
        set(gca,'FontSize',15)
        yline(0.5,'LineWidth',1.5,'LineStyle','--' )
        yticks([0:0.1:1])
        yticklabels(100*[0:0.1:1])
        box off
        ylim([0 0.7])
        pval = signrank(accuracy_odor_cells_all_bins,accuracy_time_cells_all_bins);
        add_sig_bar.sigstar([1,2],pval)
        ylim([0 0.7])
        
        subplot(1,3,2)
        bar([nanmean(accuracy_odor_cells_only_odor),nanmean(accuracy_time_cells_only_time)],...
            'FaceColor',[0.7 0.7 0.7]); hold on
        errorbar([nanmean(accuracy_odor_cells_only_odor),nanmean(accuracy_time_cells_only_time)],...
            [nanstd(accuracy_odor_cells_only_odor),nanstd(accuracy_time_cells_only_time)],...
             'LineStyle','none','LineWidth',1.5,'Color','k')
        title('Odor vs delay time bins')
        xticks([1 2])
        xticklabels({'Odor cells','Time cells'})
        ylabel('% correct odor decoding per session')
        xtickangle(45)
        set(gca,'FontSize',15)
        types = {'all_time_bins','only_odor','only_time'};
            yline(0.5,'LineWidth',1.5,'LineStyle','--' ) 
        yticks([0:0.1:1])
        yticklabels(100*[0:0.1:1])
        box off
        ylim([0 0.7])
        pval = signrank(accuracy_odor_cells_only_odor,accuracy_time_cells_only_time);
        add_sig_bar.sigstar([1,2],pval)
        
         
        subplot(1,3,3)
        bar([nanmean(accuracy_odor_firing_fields),nanmean(accuracy_time_firing_fields)],...
            'FaceColor',[0.7 0.7 0.7]); hold on
        errorbar([nanmean(accuracy_odor_firing_fields),nanmean(accuracy_time_firing_fields)],...
            [nanstd(accuracy_odor_firing_fields),nanstd(accuracy_time_firing_fields)],...
             'LineStyle','none','LineWidth',1.5,'Color','k')
        title('Firing fields')
        xticks([1 2])
        xticklabels({'Odor cells','Time cells'})
        ylabel('% correct odor decoding per session')
        xtickangle(45)
        set(gca,'FontSize',15)
        types = {'all_time_bins','only_odor','only_time'};
            yline(0.5,'LineWidth',1.5,'LineStyle','--' )
         box off
        yticks([0:0.1:1])
        yticklabels(100*[0:0.1:1])
        pval = signrank(accuracy_time_firing_fields,accuracy_odor_firing_fields);
        add_sig_bar.sigstar([1,2],pval)
        ylim([0 0.7])
        
%         saveas(fig,fullfile(save_dir,data(i).area,'svm_sum.fig'),'fig')
%         saveas(fig,fullfile(save_dir,data(i).area,'svm_sum.png'),'png')
%         
        better_than_chance = [signrank(accuracy_time_cells_all_bins,0.5*ones(length(accuracy_odor_cells_all_bins),1),'tail','right'),...
        signrank(accuracy_odor_cells_all_bins,0.5*ones(length(accuracy_odor_cells_all_bins),1),'tail','right'),...
        signrank(accuracy_odor_cells_only_odor,0.5*ones(length(accuracy_odor_cells_all_bins),1),'tail','right'),...
        signrank(accuracy_time_cells_only_time,0.5*ones(length(accuracy_odor_cells_all_bins),1),'tail','right'),...
         signrank(accuracy_odor_firing_fields,0.5*ones(length(accuracy_odor_cells_all_bins),1),'tail','right'),...
         signrank(accuracy_time_firing_fields,0.5*ones(length(accuracy_odor_cells_all_bins),1),'tail','right')]
        
        

end