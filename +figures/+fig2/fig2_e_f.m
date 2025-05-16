 

directory = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Fig_1/decoding_smaller_res/sequence_cells';

i = 1;

for  f = 1:length(data(1).sessionIDs) 
    [d_data_time(i,f).d_data.rmse,d_data_time(i,f).d_data.rmse_vs_time(1,:)] = plotDecodingTime(mData(i,f).d_data_taxidis.predTime,mData(i,f).d_data_taxidis.realTime);
    mean_rmse{i}(f,:) = d_data_time(i,f).d_data.rmse_vs_time; 
end


fig = figure();
xdata =  0:5/31:6;
mean_var = nanmean(mean_rmse{i});
std_var  = nanstd(mean_rmse{i})/sqrt(length(data(i).sessionIDs));
fig =figure('Position',[600 100 600 300]);

plot(xdata,mean_var,'Color',col(1,:),'LineWidth',1.5)
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],col(1,:),'linestyle','none','FaceAlpha', 0.3);
xline(1,'LineWidth',1,'LineStyle','--')
ylabel('Time decoding error (s)')
box('off')
set(gca,'FontName','Arial','FontSize',15)
xlabel('Time (s)')
ylim([0 4])
yticks([0.:4])
hold on
plot(0:5/31:6,nanmean(mean_var_chance,1),'k','LineWidth',1.5,'LineStyle','--')

save_dir = '//Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Fig_1/decoding/';
saveas(fig,fullfile(save_dir,'fig_2d.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig_2d.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig_2d.png'),'png')



fig=figure();

for f = 1:length(data(i).sessionIDs)
    mean_accuracy{i}(f,:)        = mData(i,f).d_data_svm.accuracies;
end
    
 
mean_var = nanmean(mean_accuracy{1});
std_var  = nanstd(mean_accuracy{1})/sqrt(length(data(i).sessionIDs));

plot(xdata,mean_var,'Color',col(1,:),'LineWidth',1.5)
hold on
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],col(1,:),'linestyle','none','FaceAlpha', 0.3);
xline(1,'LineWidth',1,'LineStyle','--')
plot(xdata,0.5*ones(length(xdata),1),'k','LineWidth',1.5,'LineStyle','--')
ylabel('Correct odor decoding (%)')
box('off')
set(gca,'FontName','Arial','FontSize',15)
xlabel('Time (s)')
ylim([0.40 1])
yticks([0.4:0.1:1])
yticklabels(100*[0.4:0.1:1])

saveas(fig,fullfile(save_dir,'fig2_e.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig2_e.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig2_e.png'),'png')


fig = figure('Position',[600 100 600 300]);
for i = 1:length(data)-1
%     for f = 1:length(data(i).sessionIDs)
       mean_session{i} = nanmean(mean_accuracy{i},2);
       mean_session_chance(i) = nanmean( mean_accuracy_chance{i}(:));
%     end
    bar(i,nanmean(mean_session{i}),'FaceColor',[0.7,0.7,0.7])
    hold on
    errorbar(i,nanmean(mean_session{i}),nanstd(mean_session{i}),'k','LineWidth',1.5)
    scatter(i*ones(length(mean_session{i}),1),mean_session{i},120,'k','LineWidth',2)
end

yline(nanmean(mean_session_chance),'LineStyle','--','Color','k')
xticks([1:length(data)])
xticklabels({'RSC','M2','PPC','S1','V1/V2'})
ylabel('Correct odor decoding (%)')
set(gca,'FontName','Arial','FontSize',15)
box('off')
ylim([0.45 1])


function [rmse,rmse_vs_time] = plotDecodingTime(predTime, time)

timebins  =unique(time);% 0:5/31:6;%unique(time);%0:5/31:6;

predError = zeros(size(time));
 for i = 1:length(time)
     predError(i)      = abs(time(i)-predTime(i));
 end


rmse = nanmean(predError);

% timebins =unique(time);
for i =1:length(timebins)
    rmse_vs_time(i) = nanmean(predError(find(time ==timebins(i))));
end

end