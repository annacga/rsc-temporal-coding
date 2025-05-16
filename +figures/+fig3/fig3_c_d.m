col(3,:) = [43 122 123]./255;
col(2,:) = [238 132 92]./255;
col(1,:) = [235 57 43]./255;
col(4,:) = [199 217 158]./255;
col(5,:) = [84 136 194]./255;

xdata = 0:0.1613:6;
 fig =figure('Position',[600 100 600 300]);
 for i = 1:5%length(data)-1
     for f = 1:length(data(i).sessionIDs)
         
         [d_data_time(i,f).d_data.rmse(1),d_data_time(i,f).d_data.rmse_vs_time(1,:)] = plotDecodingTime(mData(i,f).d_data_taxidis.predTime,mData(i,f).d_data_taxidis.realTime);
         [d_data_time_chance(i,f).d_data.rmse(1),d_data_time_chance(i,f).d_data.rmse_vs_time(1,:)] = plotDecodingTime(mData(i,f).d_data_taxidis.predTime_sh,mData(i,f).d_data_taxidis.realTime_sh);
         
         mean_rmse{i}(f,:)= nanmean(d_data_time(i,f).d_data.rmse_vs_time,1);
         mean_rmse_chance{i}(f,:) = nanmean(d_data_time_chance(i,f).d_data.rmse_vs_time,1);%nanmean(d_data_time(i,f).d_data.rmse_vs_time);
         
         [rmse_sh(p),mData(i,f).d_data_time.rmse_vs_time_sh] = plotDecodingTime(mData(i,f).d_data_taxidis.predTime_sh,mData(i,f).d_data_taxidis.realTime_sh);
         mean_rmse_chance{i}(f,:) =mData(i,f).d_data_time.rmse_vs_time_sh;
     end
     
   % xdata =unique(mData(i,f).d_data_taxidis.iter{p}.realTime);
    mean_var = nanmean(mean_rmse{i});
    std_var  = nanstd(mean_rmse{i})/sqrt(size(mean_rmse{i},1));
    mean_var_chance(i,:) = nanmean(mean_rmse_chance{i});


    plot(xdata,mean_var,'Color',col(i,:),'LineWidth',1.5)
    patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],col(i,:),'linestyle','none','FaceAlpha', 0.3);
    xline(1,'LineWidth',1,'LineStyle','--')
    ylabel('Time decoding error (s)')
    box('off')
    set(gca,'FontName','Arial','FontSize',15)
    xlabel('Time (s)')
    ylim([0 4])
    yticks([0.:4])
    hold on
    
    ylim([0 4])
    yticks([0:6])
%     xticklabels({'Odor bins','Delay bins'})
   % xtickangle(0)
    ylabel('Time decoding error (s)')
    set(gca,'FontName','Arial','FontSize',12)
    box('off')
    
end

plot(xdata,nanmean(mean_var_chance),'k','LineWidth',1.5,'LineStyle','--')
save_dir = '//Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Fig_1/decoding/';
saveas(fig,fullfile(save_dir,'decoding_taxidis_sequence_cells.fig'),'fig')
saveas(fig,fullfile(save_dir,'decoding_taxidis_sequence_cells.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'decoding_taxidis_sequence_cells.png'),'png')

  

fig = figure('Position',[600 100 600 300]);
for i = 1:length(data)-1
    %for f = 1:length(data(i).sessionIDs)
        mean_session{i} = nanmean(mean_rmse{i},2);
        mean_session_chance{i} = nanmean(mean_rmse_chance{i},2);
        mean_chance(i) = nanmean(mean_session_chance{i});
   % end
    bar(i,nanmean(mean_session{i}),'FaceColor',[0.7,0.7,0.7],'EdgeColor','none')
    hold on
    errorbar(i,nanmean(mean_session{i}),nanstd(mean_session{i}),'k','LineWidth',2)
    scatter(i*ones(length(mean_session{i}),1),mean_session{i},120,'k','LineWidth',2)
   
end

yline(nanmean(mean_chance),'LineStyle','--','Color','k')
xticks([1:length(data)-1])
xticklabels({'RSC','M2','PPC','S1','V1/V2'})
ylabel('Time decoding error (s)')
set(gca,'FontName','Arial','FontSize',15)
box('off')

% check p-value:
ranksum(mean_rmse{}(:),mean_rmse_chance{4}(:),'tail','left')


i = 1;
for j = 2:5
    pval(j-1) = ranksum(mean_session{i}',mean_session{j}','tail','left');
 end

[corrected_p, ~]=helper.bonf_holm(pval);

column  = find(corrected_p<0.05)+1;
row = ones(length(column),1);
for i = 1:length(row)
    add_sig_bar.sigstar([row(i),column(i)],corrected_p(i))
end

saveas(fig,fullfile(save_dir,'decoding_taxidis_sequence_cells_mean.fig'),'fig')
saveas(fig,fullfile(save_dir,'decoding_taxidis_sequence_cells_mean.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'decoding_taxidis_sequence_cells_mean.png'),'png')

function [rmse,rmse_vs_time] = plotDecodingTime(predTime, time)

% timebins_temp  =  [0    0.1613    0.3226    0.4839    0.6452    0.8065    0.9677    1.1290    1.2903    1.4516    1.6129...
%     1.7742    1.9355    2.0968    2.2581    2.4194    2.5806    2.7419    2.9032    3.0645    3.2258    3.3871...
%      3.5484    3.7097    3.8710    4.0323    4.1935    4.3548    4.5161    4.6774    4.8387    5.0000    5.1613...
%       5.3226    5.4839    5.6452    5.8065    5.9677];%0:0.1613:6;
% 

predError = zeros(size(time));
 for i = 1:length(time)
     predError(i)      = abs(time(i)-predTime(i));
 end


rmse = nanmean(predError);

% timebins =unique(time);
% timebins = [timebins timebins_temp()]
timebins = 0:5/31:6;
rmse_vs_time = NaN(1,length(timebins));
for i =1:length(unique(time))
    rmse_vs_time(i) = nanmean(predError(find(time ==timebins(i))));
end

end