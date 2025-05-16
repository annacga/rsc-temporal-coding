%% field location 
% the mean firing rate over preffered trials is calculated and the time bin where 
% the mean firing rate is maximal is considered the cell's field time point

% original signal was sampled with 31Hz but in rmaps 3 time points are
% always averaged
Fs = 31/5;
% lowpass filtered (< 1Hz)
Fpass = 1;

field_size_area_odor = cell(length(data),1);
field_size_area_time = cell(length(data),1);

field_idx_area_odor  = cell(length(data),1);
field_idx_area_time  = cell(length(data),1);

activation_probability_area_odor = cell(length(data),1);
activation_probability_area_time = cell(length(data),1);

peak_time_variance_area_odor = cell(length(data),1);
peak_time_variance_area_time = cell(length(data),1);

SI_area_odor = cell(length(data),1);
SI_area_time = cell(length(data),1);



for i = 1:length(data)
    firing_fields_A = [];
    firing_fields_B = [];
    for f = 1:length(data(i).sessionIDs)
      
       savedir = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/plots/field_info',data(i).area,data(i).sessionIDs{f});

       if ~exist(savedir)
           mkdir(savedir);
       end
       activation_probability_area_time{i} = [activation_probability_area_time{i};mData(i,f).TimeA.activation_probability;mData(i,f).TimeB.activation_probability];
       activation_probability_area_odor{i} = [activation_probability_area_odor{i};mData(i,f).OdorA.activation_probability;mData(i,f).OdorB.activation_probability];
       peak_time_variance_area_odor{i} = [peak_time_variance_area_odor{i};mData(i,f).OdorA.peak_time_variance;mData(i,f).OdorB.peak_time_variance];
       peak_time_variance_area_time{i} = [peak_time_variance_area_time{i};mData(i,f).TimeA.peak_time_variance;mData(i,f).TimeB.peak_time_variance];

       SI_area_odor{i} = [SI_area_odor{i};mData(i,f).OdorA.SI;mData(i,f).OdorB.SI];
       SI_area_time{i} = [SI_area_time{i};mData(i,f).TimeA.SI;mData(i,f).TimeB.SI];
       
       field_idx_area_odor{i}  = [field_idx_area_odor{i};mData(i,f).OdorA.field_location;mData(i,f).OdorB.field_location];
       field_idx_area_time{i}  = [field_idx_area_time{i};mData(i,f).TimeA.field_location;mData(i,f).TimeB.field_location];

%        field_idx_area_A{i} = [field_idx_area_A{i};]

%         peak_time_var_inTime = peak_time_var*(3/31); % from no of indices to time
%         fig_firing_peak_time = figure();

        firing_fields_session =[mData(i,f).OdorA.field_location;mData(i,f).OdorB.field_location;...
            mData(i,f).TimeA.field_location;mData(i,f).TimeB.field_location];
        
        peak_time_variance_session=[mData(i,f).OdorA.peak_time_variance;mData(i,f).OdorB.peak_time_variance;...
            mData(i,f).TimeA.peak_time_variance;mData(i,f).TimeB.peak_time_variance];
        
        SI_session = [mData(i,f).OdorA.SI;mData(i,f).OdorB.SI ;mData(i,f).TimeA.SI;mData(i,f).TimeB.SI];
        
        activation_probability_session = [mData(i,f).OdorA.activation_probability;mData(i,f).OdorB.activation_probability;...
            mData(i,f).TimeA.peak_time_variance;mData(i,f).TimeB.peak_time_variance];
        
         [fig,mean_peak_time_variance{i}(f,:)] = plot.firing_peak_time_variance(firing_fields_session,...
             peak_time_variance_session);
         
         saveas(fig,fullfile(savedir,'peak_time_variance.fig'),'fig')
         saveas(fig,fullfile(savedir,'peak_time_variance.pdf'),'pdf')
         saveas(fig,fullfile(savedir,'peak_time_variance.png'),'png')
         
         [fig,mean_SI_area{i}(f,:)] = plot.selectivity_index(firing_fields_session,SI_session);
         
         saveas(fig,fullfile(savedir,'SI.fig'),'fig')
         saveas(fig,fullfile(savedir,'SI.pdf'),'pdf')
         saveas(fig,fullfile(savedir,'SI.png'),'png')
         
         [fig,mean_activation_probability{i}(f,:)] = plot.activation_probability(firing_fields_session,activation_probability_session);
         
         saveas(fig,fullfile(savedir,'activation_probab.fig'),'fig')
         saveas(fig,fullfile(savedir,'activation_probab.pdf'),'pdf')
         saveas(fig,fullfile(savedir,'activation_probab.png'),'png')
         
         firing_fields_A = [firing_fields_A;mData(i,f).OdorA.field_location;mData(i,f).TimeA.field_location];
         firing_fields_B = [firing_fields_B;mData(i,f).OdorB.field_location;mData(i,f).TimeB.field_location];

       close all
     
    end

    savedir = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/plots/field_info',data(i).area);
    
    
    fig=plot.distribution_firing_field(firing_fields_A,firing_fields_B);
    xline(31/5,'LineWidth',1,'LineStyle','--')
    xline(6*31/5,'LineWidth',1,'LineStyle','--')
%     ylim([0 0.2])
    legend('off')
    saveas(fig,fullfile(savedir,'field_distribution.fig'),'fig')
    saveas(fig,fullfile(savedir,'field_distribution.pdf'),'pdf')
    saveas(fig,fullfile(savedir,'field_distribution.png'),'png')
    
    
    fig = figure();
    mean_var = nanmean(mean_peak_time_variance{i});
    std_var  = nanstd(mean_peak_time_variance{i})/sqrt(length(data(i).sessionIDs));
    xdata       = 1:44;
    
%     
%     xdata       = xdata(~isnan(mean_var))';
%     std_var     = std_var(~isnan(mean_var))';
%     mean_var    = mean_var(~isnan(mean_var))';
    std_var(mean_var == 0) = NaN;
    mean_var(mean_var == 0) = NaN;

%     xdata = xdata';
%     mean_var = mean_var';
%     std_var=std_var';
    subplot(3,3,[1,2])
    plot(xdata,mean_var,'b')
    hold on
%     errorbar(xdata,mean_var,std_var)
    patch([xdata(~isnan(mean_var))  fliplr(xdata(~isnan(mean_var)))],[mean_var(~isnan(mean_var))-std_var(~isnan(mean_var)) fliplr(mean_var(~isnan(mean_var))+std_var(~isnan(mean_var)))],'b','LineStyle','none','FaceAlpha', 0.4);

    xticks([0:31/5:44])
    xticklabels({'0','1','2','3','4','5','6','7'})
    xlim([1 44])
    set(gca,'FontName','Arial','FontSize',12)
    % yticks([0 0.05 0.1 0.15 0.2])
    xlabel('Firing field times (s)')
    ylabel('Firing peak-time variance')
    box off
    xline(31/5,'LineWidth',1,'LineStyle','--')
    xline(6*31/5,'LineWidth',1,'LineStyle','--')

    subplot(3,3,3)
    bar([nanmean(mean_var(1:6)),nanmean(mean_var(7:end))],'FaceColor',[0.8 0.8 0.8])
    hold on
    errorbar([nanmean(mean_var(1:6)),nanmean(mean_var(7:end))],...
        [nanstd(mean_var(1:6)),nanstd(mean_var(7:end))],'k','LineStyle','none','LineWidth',1)

    ylim([0 40])
    xticklabels({'Odor bins','Delay bins'})
    xtickangle(45)
    ylabel('Firing peak-time variance')
    set(gca,'FontName','Arial','FontSize',12)
    box('off')

    odor = mean_var(:,1:6);
    time = mean_var(:,7:end);
    add_sig_bar.sigstar([1,2],ranksum(odor(:),time(:)))
    ylim([0 8])
    corr_val = corr(xdata(~isnan(mean_var))',mean_var(~isnan(mean_var))' ,'Type','Spearman') 
    
    
%     saveas(fig_var,fullfile(savedir,'peak_time_variance.fig'),'fig')
%     saveas(fig_var,fullfile(savedir,'peak_time_variance.pdf'),'pdf')
%     saveas(fig_var,fullfile(savedir,'peak_time_variance.png'),'png')
%  
    
    
     
%     fig_SI = figure();
    mean_SI = nanmean(mean_SI_area{i});
    std_SI  = nanstd(mean_SI_area{i})/sqrt(length(data(i).sessionIDs));
    xdata       = 0:43;
    std_SI(mean_SI == 0) =NaN;
    mean_SI(mean_SI == 0) =NaN;
%     xdata       = xdata(~isnan(mean_var))';
%     std_var     = std_var(~isnan(mean_var))';
%     mean_var    = mean_var(~isnan(mean_var))';

    subplot(3,3,[4,5])
    plot(xdata,mean_SI,'b')
    hold on
%     errorbar(xdata,mean_SI,std_SI)
   patch([xdata(~isnan(mean_SI))  fliplr(xdata(~isnan(mean_SI)))],[mean_SI(~isnan(mean_SI))-std_SI(~isnan(mean_SI)) fliplr(mean_SI(~isnan(mean_SI))+std_SI(~isnan(mean_SI)))],'b','LineStyle','none','FaceAlpha', 0.4);

    %    patch(gca,[xdata  fliplr(xdata)],[mean_var-std_var fliplr(mean_var+std_var)],'FaceAlpha', 0.4);

    xticks([0:31/5:44])
    xticklabels({'0','1','2','3','4','5','6','7'})
    xlim([0 44])
    set(gca,'FontName','Arial','FontSize',12)
    % yticks([0 0.05 0.1 0.15 0.2])
    xlabel('Firing field times (s)')
    ylabel('Selectivity Index')
    box off
    ylim([0 1])
    xline(31/5,'LineWidth',1,'LineStyle','--')
    xline(6*31/5,'LineWidth',1,'LineStyle','--')

    subplot(3,3,6)
    bar([nanmean(mean_SI(1:6)),nanmean(mean_SI(7:end))],'FaceColor',[0.8 0.8 0.8])
    hold on
    errorbar([nanmean(mean_SI(1:6)),nanmean(mean_SI(7:end))],...
        [nanstd(mean_SI(1:6)),nanstd(mean_SI(7:end))],'k','LineStyle','none','LineWidth',1)

    ylim([0 1])
    xticklabels({'Odor bins','Delay bins'})
    xtickangle(45)
    ylabel('Selectivity Index')
    set(gca,'FontName','Arial','FontSize',12)
    box('off')

    odor = mean_SI(:,1:6);
    time = mean_SI(:,7:end);
    add_sig_bar.sigstar([1,2],ranksum(odor(:),time(:)))

    corr_val = corr(xdata(~isnan(mean_var))',mean_var(~isnan(mean_var))' ,'Type','Spearman')


%     saveas(fig_SI,fullfile(savedir,'SI.fig'),'fig')
%     saveas(fig_SI,fullfile(savedir,'SI.pdf'),'pdf')
%     saveas(fig_SI,fullfile(savedir,'SI.png'),'png')
    
    

%     fig_activation_probability = figure();
    subplot(3,3,[7,8])
    mean_prob = nanmean(mean_activation_probability{i});
    std_prob = nanstd(mean_activation_probability{i})/sqrt(length(data(i).sessionIDs));

    std_prob(mean_prob ==0) = NaN;
    mean_prob(mean_prob ==0) = NaN;
    plot(xdata,mean_prob','b')
%     errorbar(xdata,mean_prob,std_prob)
    patch([xdata(~isnan(mean_prob))  fliplr(xdata(~isnan(mean_prob)))],[mean_prob(~isnan(mean_prob))-std_prob(~isnan(mean_prob)) fliplr(mean_prob(~isnan(mean_prob))+std_prob(~isnan(mean_prob)))],'b','LineStyle','none','FaceAlpha', 0.4);


%     patch(gca,[xdata  fliplr(xdata)],[mean_prob+std_prob fliplr(mean_prob-std_prob)],'b','linestyle','none','FaceAlpha', 0.4);

    xticks([0:31/5:44])
    xticklabels({'0','1','2','3','4','5','6','7'})
    xlim([0 44])
    set(gca,'FontName','Arial','FontSize',12)
    % yticks([0 0.05 0.1 0.15 0.2])
    xlabel('Firing field times (s)')
    ylabel('Activation probability (%)')
    box off
    xline(31/5,'LineWidth',1,'LineStyle','--')
    ylim([0 30])

    subplot(3,3,9)
    bar([nanmean(mean_prob(1:6)),nanmean(mean_prob(7:end))],'FaceColor',[0.8 0.8 0.8])
    hold on
    errorbar([nanmean(mean_prob(1:6)),nanmean(mean_prob(7:end))],...
        [nanstd(mean_prob(1:6)),nanstd(mean_prob(7:end))],'k','LineStyle','none','LineWidth',1)

    ylim([0 30])
    xticklabels({'Odor bins','Delay bins'})
    xtickangle(45)
    ylabel('Activation probability (%)')
    set(gca,'FontName','Arial','FontSize',12)
    box('off')

    odor = mean_prob(:,1:6);
    time = mean_prob(:,7:end);
    add_sig_bar.sigstar([1,2],ranksum(odor(:),time(:)))

    corr_prob = corr(xdata(~isnan(mean_var))',mean_prob(~isnan(mean_var))' ,'Type','Spearman') ;
     xline(6*31/5,'LineWidth',1,'LineStyle','--')

    saveas(fig,fullfile(savedir,'info.fig'),'fig')
    saveas(fig,fullfile(savedir,'info.pdf'),'pdf')
    saveas(fig,fullfile(savedir,'info.png'),'png')
    
    close all
    
%    plot.distribution_firing_fields()
% %     plot.odor_vs_time(field_idx_area_odor{i},field_idx_area_time{i})
%     plot.firing_peak_time_variance([field_idx_area_odor{i};field_idx_area_time{i}],[peak_time_variance_area_odor{i};peak_time_variance_area_time{i}])
%     plot.selectivity_index([field_idx_area_odor{i};field_idx_area_time{i}],[SI_area_odor{i};SI_area_time{i}])
%     plot.activation_probability([field_idx_area_odor{i};field_idx_area_time{i}],[activation_probability_area_odor{i};activation_probability_area_time{i}])
%     
    
end
