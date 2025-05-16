%% Compute odor preference ratio 
amplitude_change = [];
amplitude_change_control = [];

avg_tuning_map_A = [];
avg_tuning_map_B = [];
amplitude_session = [];
amplitude_roi_index = [];
pval = [];

i = 1;
avg_tuning_map_A = [];
amplitude_change_A       = [];
amplitude_change_B       = [];
amplitude_shuffle_A      = [];
amplitude_change_control =  [];
whichSignal = 'deconv';
for f = 1:length(data(i).sessionIDs)
           
    OdorA = mData(i,f).OdorA.indices;
    OdorB = mData(i,f).OdorB.indices;
    
    % Include only landmark cells
    cells_to_include = [OdorA ; OdorB]; 
    
    % Create averge tuning maps
%     avg_tuning_map_A = cat(1,avg_tuning_map_A,mData(i,f).(whichSignal).rmapsAA(:,:,OdorA));
%     avg_tuning_map_B = cat(1,avg_tuning_map_B,nanmean(mData(i,f).(whichSignal).rmapsAA(:,:,OdorB)));
    
    amplitude_change_A = [amplitude_change_A, analysis.odorPreferenceRatio(mData(i,f).(whichSignal).rmapsAA(:,:,OdorA))];
    amplitude_change_B = [amplitude_change_B, analysis.odorPreferenceRatio(mData(i,f).(whichSignal).rmapsBB(:,:,OdorB))];

    amplitude_shuffle_A = analysis.odorPreferenceRatioShuffle(mData(i,f).(whichSignal).rmapsAA(:,:,OdorA));
    amplitude_shuffle_B = analysis.odorPreferenceRatioShuffle(mData(i,f).(whichSignal).rmapsBB(:,:,OdorB));

    amplitude_change_control = [amplitude_change_control,amplitude_shuffle_A(:)',amplitude_shuffle_B(:)'];
end

% Compute the amplitude ratio between first and second landmark and as
% a control

[amplitude_change_sorted,sorted_amplitude_change_index] = sort(amplitude_change_A);

fprintf('Out of the %i odor A cells %.1f %% showed a bias greater than 100%% \n', length(amplitude_change_A),(sum(abs(amplitude_change_A)>100)/length(amplitude_change_A)*100))
fprintf('Out of the %i odor B cells %.1f %% showed a bias greater than 100%% \n', length(amplitude_change_B),(sum(abs(amplitude_change_B)>100)/length(amplitude_change_B)*100))

% amplitude_change_A(~isfinite(amplitude_change_A)) = [];
amplitude_change_control(~isfinite(amplitude_change_control)) = [];

fig = figure(); clf;
% col(1,:) =  [110 186 146]./255; % Odor Sequence A colour
% col(2,:) =  [53 132 178]./255; % Odor Sequence B colour
col(1,:) =  [142 215 150]./255; % Odor Sequence A colour
col(2,:) =  [55 170 235]./255; % Odor Sequence B colour

histogram(amplitude_change_control,'BinEdges',-350:20:350,'Normalization','probability','FaceColor','k','FaceAlpha',0.15);
hold on
a =histogram(amplitude_change_A,'BinEdges',-350:20:350,'Normalization','probability','FaceColor',col(1,:));
% pd= fitdist(a.BinEdges(1:end-1),a.Values,'Normal');
% figure()
% a=histfit(amplitude_change_A)
% a = pdf(pd,-350:10:350);
figure()
hold on
b = histogram(amplitude_change_B,'BinEdges',-350:25:350,'Normalization','probability','FaceColor',col(2,:));%,'FaceAlpha',0.8);
a = histogram(amplitude_change_A,'BinEdges',-350:25:350,'Normalization','probability','FaceColor',col(1,:));%,'FaceAlpha',0.8);
% 
fig =figure();
histogram(amplitude_change_control,'BinEdges',-350:25:350,'Normalization','probability','FaceColor','k','FaceAlpha',0.15);
hold on
plot(a.BinEdges(1:end-1)+a.BinWidth/2,a.Values,'Color',col(1,:),'LineWidth',2)
plot(b.BinEdges(1:end-1)+b.BinWidth/2,b.Values,'Color',col(2,:),'LineWidth',2)


hold on
ylim([0,0.2])
yticks([0,0.1,0.2])
yticklabels([0,10,20]);
ylabel('% of cells');
xlabel('% difference in amplitude');
xticks(-300:100:300)
text(0.1,0.8,'<--- Prefers first odor','FontSize',15,'Units','normalized');
text(0.65,0.8,'Prefers second odor --->','FontSize',15,'Units','normalized');
title('Amplitude difference between largest and smallest peak');
set(gca,'FontSize',16);


% create line at 75th percentile of control group: xline(-79.941)
xline(quantile(amplitude_change_control,0.05))
xline(quantile(amplitude_change_control,0.05))

xline(quantile(amplitude_change_control,0.95))
%% Show histogram of amplitude difference but split it into which is biggest, first or second landmark

fprintf('In total %.1f %% of odor A cells have more than twice the amplitude for one of the landmarks\n',(sum(abs(amplitude_change_A) > 100) / length(amplitude_change_A)) * 100)
fprintf('In total %.1f %% of odor A cells have more than three times the amplitude for one of the landmarks\n',(sum(abs(amplitude_change_A) > 200) / length(amplitude_change_A)) * 100)

fprintf('In total %.1f %% of odor A cells are below the 5th quantile of the shuffled distribution\n',(sum(amplitude_change_A < quantile(amplitude_change_control,0.05)) / length(amplitude_change_A)) * 100)
fprintf('In total %.1f %% of odor A  cells are above the 95th quantile of the shuffled distribution\n',(sum(abs(amplitude_change_A) > quantile(amplitude_change_control,0.95)) / length(amplitude_change_A)) * 100)

fprintf('In total %.1f %% of odor B cells have more than twice the amplitude for one of the landmarks\n',(sum(abs(amplitude_change_B) > 100) / length(amplitude_change_B)) * 100)
fprintf('In total %.1f %% of odor B cells have more than three times the amplitude for one of the landmarks\n',(sum(abs(amplitude_change_B) > 200) / length(amplitude_change_B)) * 100)

fprintf('In total %.1f %% of odor B cells are below the 5th quantile of the shuffled distribution\n',(sum(amplitude_change_B < quantile(amplitude_change_control,0.05)) / length(amplitude_change_B)) * 100)
fprintf('In total %.1f %% of odor B  cells are above the 95th quantile of the shuffled distribution\n',(sum(abs(amplitude_change_B) > quantile(amplitude_change_control,0.95)) / length(amplitude_change_B)) * 100)

% In total 42.1 % of odor A cells have more than twice the amplitude for one of the landmarks
% In total 22.6 % of odor A cells have more than three times the amplitude for one of the landmarks
% In total 8.6 % of odor A cells are below the 5th quantile of the shuffled distribution
% In total 9.5 % of odor A  cells are above the 95th quantile of the shuffled distribution
% In total 40.5 % of odor B cells have more than twice the amplitude for one of the landmarks
% In total 19.0 % of odor B cells have more than three times the amplitude for one of the landmarks
% In total 7.3 % of odor B cells are below the 5th quantile of the shuffled distribution
% In total 8.6 % of odor B  cells are above the 95th quantile of the shuffled distribution

saveas(fig,fullfile(save_dir,'fig_2b.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig_2b.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig_2b.png'),'png')

%% Is the difference significantly different to the control?

% We want to find out if the landmark cells consistently have a larger
% amplitude difference when comparing the first and second landmark versus
% a control. In this scenario, we choose the control to be odd vs even laps
% at the first landmark. We get the absolute value of difference in
% amplitude of both arrays and run a Wilcoxon sign rank test to test for
% consistency.

p_value = ranksum(abs(amplitude_change_A),abs(amplitude_change_B),abs(amplitude_change_control),'tail','left');

prct_aboveThreshol = 100*length(find(abs(amplitude_change_A)> 79.941))./length(amplitude_change_control);

% pvalue: p_value 