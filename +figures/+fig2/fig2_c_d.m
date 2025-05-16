%% field location 
% the mean firing rate over preffered trials is calculated and the time bin where 
% the mean firing rate is maximal is considered the cell's field time point

% original signal was sampled with 31Hz but in rmaps 3 time points are
% always averaged


i = 1;

field_idx  = [];
peak_time_variance=[];
activation_probability = [];
for f = 1:length(data(i).sessionIDs)

    field_idx =  [field_idx ;mData(i,f).OdorA.field_location;mData(i,f).OdorB.field_location;...
        mData(i,f).TimeA.field_location;mData(i,f).TimeB.field_location];

    peak_time_variance=[peak_time_variance;mData(i,f).OdorA.peak_time_variance;mData(i,f).OdorB.peak_time_variance;...
        mData(i,f).TimeA.peak_time_variance;mData(i,f).TimeB.peak_time_variance];

    activation_probability = [ activation_probability;mData(i,f).OdorA.activation_probability;mData(i,f).OdorB.activation_probability;...
        mData(i,f).TimeA.activation_probability;mData(i,f).TimeB.activation_probability];

end


close all
uiopen('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Figures/Paper/fig2/taxidis/SI_Part_Var.fig')    
fig1 = figure(1);

[fig_c,mean_activation_probability] = plot.activation_probability([],field_idx ,activation_probability,col(1,:));
ylim([0 40])
saveas(fig_c,fullfile(save_dir,'fig_2c.fig'),'fig')
saveas(fig_c,fullfile(save_dir,'fig_2c.pdf'),'pdf')
saveas(fig_c,fullfile(save_dir,'fig_2c.png'),'png')

close all

[fig_c,mean_peak_time_variance] = plot.firing_peak_time_variance(field_idx ,peak_time_variance,col(1,:));
ylim([0 5])
saveas(fig_c,fullfile(save_dir,'fig_2d.fig'),'fig')
saveas(fig_c,fullfile(save_dir,'fig_2d.pdf'),'pdf')
saveas(fig_c,fullfile(save_dir,'fig_2d.png'),'png')


ax = gca;
uiopen('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Figures/Paper/fig2/taxidis/SI_Part_Var.fig')    
fig1 = figure(1);
saveas(fig1,fullfile(save_dir,'fig_2c_taxidis.fig'),'fig')
saveas(fig1,fullfile(save_dir,'fig_2c_taxidis.pdf'),'pdf')
saveas(fig1,fullfile(save_dir,'fig_2c_taxidis.png'),'png')



% reviews: 
i = 1;

field_idx_A  = [];
peak_time_variance_A=[];
activation_probability_A = [];

field_idx_B  = [];
peak_time_variance_B=[];
activation_probability_B = [];
for f = 1:length(data(i).sessionIDs)

    field_idx_A =  [field_idx_A ;mData(i,f).OdorA.field_location; mData(i,f).TimeA.field_location];
    field_idx_B =  [field_idx_B ;mData(i,f).OdorB.field_location; mData(i,f).TimeB.field_location];
    
    peak_time_variance_A=[peak_time_variance_A;mData(i,f).OdorA.peak_time_variance; mData(i,f).TimeA.peak_time_variance];
    peak_time_variance_B=[peak_time_variance_B;mData(i,f).OdorB.peak_time_variance; mData(i,f).TimeB.peak_time_variance];
    activation_probability_A = [ activation_probability_A;mData(i,f).OdorA.activation_probability; mData(i,f).TimeA.activation_probability];
    activation_probability_B = [ activation_probability_B;mData(i,f).OdorB.activation_probability; mData(i,f).TimeB.activation_probability];

end


close all
uiopen('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Figures/Paper/fig2/taxidis/SI_Part_Var.fig')    
fig = figure();

xdata = 1:37; %105;%
firing_fields = field_idx_A ;
activation_probability = activation_probability_A;
for i = 1:length(xdata)
    mean_prob_temp(i) = nanmean(activation_probability(find(firing_fields == xdata(i))));
    std_prob(i) = nanstd(activation_probability(find(firing_fields == xdata(i))));
    no_cells(i) =length(find(firing_fields == xdata(i)));

end

std_prob  = std_prob(~isnan(mean_prob_temp))./sqrt(no_cells(~isnan(mean_prob_temp)));
xdata = xdata(~isnan(mean_prob_temp))*6/38;
mean_prob = mean_prob_temp(~isnan(mean_prob_temp));

ax = subplot(1,1,1);

col(1,:) =  [142 215 150]./255; % Odor Sequence A colour
col(2,:) =  [154 193 209]./255; % Odor Sequence B colour

plot(ax,xdata,mean_prob','Color',col(1,:,:),'LineWidth',2)
patch(ax,[xdata  fliplr(xdata)],[mean_prob+std_prob fliplr(mean_prob-std_prob)],col(1,:,:),'linestyle','none','FaceAlpha', 0.4);
hold on

firing_fields = field_idx_B ;
activation_probability = activation_probability_B;
xdata = 1:37; 
for i = 1:length(xdata)
    mean_prob_temp(i) = nanmean(activation_probability(find(firing_fields == xdata(i))));
    std_prob(i) = nanstd(activation_probability(find(firing_fields == xdata(i))));
    no_cells(i) =length(find(firing_fields == xdata(i)));
end

std_prob  = std_prob(~isnan(mean_prob_temp))./sqrt(no_cells(~isnan(mean_prob_temp)));
xdata = xdata(~isnan(mean_prob_temp))*6/38;
mean_prob = mean_prob_temp(~isnan(mean_prob_temp));
hold on


plot(ax,xdata,mean_prob','Color',col(2,:,:),'LineWidth',2)
patch(ax,[xdata  fliplr(xdata)],[mean_prob+std_prob fliplr(mean_prob-std_prob)],col(2,:,:),'linestyle','none','FaceAlpha', 0.4);

% xticks(ax,[0:31/5:37])
% xticklabels(ax,{'0','1','2','3','4','5','6','7'})
% xlim([0 37])
set(gca,'FontName','Arial','FontSize',12)
% yticks([0 0.05 0.1 0.15 0.2])
xlabel('Firing field times (s)')
ylabel('Activation probability (%)')
box off
xline(ax,1,'LineWidth',1,'LineStyle','--')


[fig_c,mean_activation_probability] = plot.activation_probability([],field_idx_B ,activation_probability_B,col(1,:));


close all

[fig_c,mean_peak_time_variance] = plot.firing_peak_time_variance(field_idx ,peak_time_variance,col(1,:));
ylim([0 5])
saveas(fig_c,fullfile(save_dir,'fig_2d.fig'),'fig')
saveas(fig_c,fullfile(save_dir,'fig_2d.pdf'),'pdf')
saveas(fig_c,fullfile(save_dir,'fig_2d.png'),'png')

fig =figure();
peak_time_var_inTime = peak_time_variance_A; % from no of indices to time
firing_fields = firing_fields_A;
xdata = 1:37;%99;%

for i = 1:length(xdata)
    mean_var_temp(i) = nanmean(peak_time_var_inTime(find(firing_fields == xdata(i))));
    std_var_temp(i) = nanstd(peak_time_var_inTime(find(firing_fields == xdata(i))));
    no_cells(i) =length(find(firing_fields == xdata(i)));

end

std_var  = std_var_temp(~isnan(mean_var_temp))/sqrt(no_cells(~isnan(mean_var_temp)));
xdata = xdata(~isnan(mean_var_temp));
mean_var = mean_var_temp(~isnan(mean_var_temp));

plot(gca,xdata,mean_var','Color',col(1,:,:),'LineWidth',2)
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],col(1,:,:),'linestyle','none','FaceAlpha', 0.4);

peak_time_var_inTime = peak_time_variance_B; % from no of indices to time
firing_fields = firing_fields_B;
xdata = 1:37;

for i = 1:length(xdata)
    mean_var_temp(i) = nanmean(peak_time_var_inTime(find(firing_fields == xdata(i))));
    std_var_temp(i) = nanstd(peak_time_var_inTime(find(firing_fields == xdata(i))));
    no_cells(i) =length(find(firing_fields == xdata(i)));
end

hold on
std_var  = std_var_temp(~isnan(mean_var_temp))/sqrt(no_cells(~isnan(mean_var_temp)));
xdata = xdata(~isnan(mean_var_temp));
mean_var = mean_var_temp(~isnan(mean_var_temp));

plot(gca,xdata,mean_var','Color',col(2,:,:),'LineWidth',2)
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],col(2,:,:),'linestyle','none','FaceAlpha', 0.4);

xticks([0:31/5:38])
xticklabels({'0','1','2','3','4','5','6','7'})
% xlim([0 37])
set(gca,'FontName','Arial','FontSize',12)
% yticks([0 0.05 0.1 0.15 0.2])
xlabel('Firing field times (s)')
ylabel('Firing peak-time variance')
box off
xline(31/5,'LineWidth',1,'LineStyle','--')

ax = gca;
uiopen('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Figures/Paper/fig2/taxidis/SI_Part_Var.fig')    
fig1 = figure(1);
saveas(fig1,fullfile(save_dir,'fig_2c_taxidis.fig'),'fig')
saveas(fig1,fullfile(save_dir,'fig_2c_taxidis.pdf'),'pdf')
saveas(fig1,fullfile(save_dir,'fig_2c_taxidis.png'),'png')


