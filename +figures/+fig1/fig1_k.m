

% Taxidis et al, 2020, Neuron:
CA1_odor_A = 5; %± 2;
CA1_time_A = 8.3; %± 3.7;
CA1_odor_B = 5.5; %± 2.2
CA1_time_B = 5.3; %± 2.8%
CA1_not_tuned = 100-CA1_odor_A-CA1_time_A-CA1_odor_B-CA1_time_B;

odor_A = [];
time_A = [];
odor_B = [];
time_B = [];
i = 1;

for f = 1:length(data(1).sessionIDs)
    
    time_A_session(f) = 100*length(mData(i,f).TimeA.indices)/length(mData(i,f).classification);
    time_B_session(f) = 100*length(mData(i,f).TimeB.indices)/length(mData(i,f).classification);
    
    odor_A_session(f) = 100*length(mData(i,f).OdorA.indices)/length(mData(i,f).classification);
    odor_B_session(f) = 100*length(mData(i,f).OdorB.indices)/length(mData(i,f).classification);
    
end
odor_A = nanmean(odor_A_session);
odor_B = nanmean(odor_B_session);
time_B = nanmean(time_B_session);
time_A = nanmean(time_A_session);

not_tuned = 100-odor_A -odor_B-time_A -time_B; 
 
col(1,:) =  [53 132 178]./255;
col(2,:) =  [78 149 151]./255;
col(3,:) =  [154 193 209]./255;
col(4,:) =  [22 66 113]./255;
col(5,:)=  [0.8 0.8 0.8];

fig = figure();
ax = subplot(1,2,1)

perc_pie = pie([CA1_odor_A,CA1_time_A,CA1_odor_B ,CA1_time_B,CA1_not_tuned]);
ax.Colormap = col; 


ax = subplot(1,2,2)
% ax = gca;
perc_pie = pie([odor_A,time_A,odor_B ,time_B,not_tuned]);
ax.Colormap = col; 

% RSC = 
% odor_A = 6.30 +/- 2.5% 
% odor_B = 5.7 +/- 2.7% 
% time_A = 4.7 +/- 3 % 
% time_B = 4.6 +/- 3.6% 

% 99th percentile
% RSC = 
% odor_A = 6.20 +/- 2.5% 
% odor_B = 5.4+/- 2.2% 
% time_A = 3.6 +/- 2.8 % 
% time_B = 4 +/- 2.2% 

saveas(fig,fullfile(save_dir,'fig_1k.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig_1k.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig_1k.png'),'png')


no_cells = 0; % this is 7204
for i = 1:length(data(1).sessionIDs)
    no_cells =  no_cells+size(mData(1,i).sData.imData.roiSignals.dff,1);
end

trials =[];
total_performance =[];
for i = 1:length(data)-1
    for f = 1:length(data(i).sessionIDs)
        trials(end+1) = length(mData(i,f).sData.imData.variables.response);
        total_performance(end+1) = (nansum(mData(i,f).sData.imData.variables.CR)+nansum(mData(i,f).sData.imData.variables.hits))/length(mData(i,f).sData.imData.variables.response);
    end
end

fprintf('Of all %4.1f RSC neurons recorded, we classified %4.1f %% as odor A, %4.1f %% as time A, %4.1f %% as odor B and %4.1f %% as time B responsive \n',...
    no_cells,odor_A, time_A, odor_B, time_B)
fprintf('The average percentage of odor A cells is: %4.1f %% +/- %4.1f %% (mean +/- SEM over session) \n',nanmean(100*odor_A_session),nanstd(100*odor_A_session)/sqrt(length(odor_A_session)))
fprintf('The average percentage of time A cells is: %4.1f %% +/- %4.1f %% (mean +/- SEM over session) \n',nanmean(100*time_A_session),nanstd(100*time_A_session)/sqrt(length(time_A_session)))
fprintf('The average percentage of odor B cells is: %4.1f %% +/- %4.1f %% (mean +/- SEM over session) \n',nanmean(100*odor_B_session),nanstd(100*odor_B_session)/sqrt(length(odor_B_session)))
fprintf('The average percentage of time B cells is: %4.1f %% +/- %4.1f %% (mean +/- SEM over session) \n',nanmean(100*time_B_session),nanstd(100*time_B_session)/sqrt(length(time_B_session)))


colors = [0.1, 0.2, 0.7;  % Dark Blue
          0.85, 0.33, 0.1;  % Dark Orange
          0.1, 0.7, 0.1;  % Dark Green
          0.6, 0.2, 0.8;  % Purple
          0.2, 0.7, 0.7;  % Cyan
          0.9, 0.1, 0.7;  % Magenta
          0.9, 0.9, 0.1;  % Yellow
          0.5, 0.5, 0.5]; % Gray
figure()
scatter(ones(3,1),odor_A_session(1:3),60,colors(1,:),'LineWidth',2);
hold on
scatter(ones(1,1),odor_A_session(4),60,colors(2,:),'LineWidth',2)
scatter(ones(4,1),odor_A_session(5:8),60,colors(3,:),'LineWidth',2)
scatter(ones(1,1),odor_A_session(9),60,colors(4,:),'LineWidth',2)
scatter(ones(1,1),odor_A_session(10),60,colors(5,:),'LineWidth',2)
scatter(ones(1,1),odor_A_session(11),60,colors(6,:),'LineWidth',2)
scatter(ones(1,1),odor_A_session(12),60,colors(7,:),'LineWidth',2)
scatter(ones(3,1),odor_A_session(13:15),60,colors(8,:),'LineWidth',2)

scatter(2*ones(3,1),time_A_session(1:3),60,colors(1,:),'LineWidth',2);
hold on
scatter(2*ones(1,1),time_A_session(4),60,colors(2,:),'LineWidth',2)
scatter(2*ones(4,1),time_A_session(5:8),60,colors(3,:),'LineWidth',2)
scatter(2*ones(1,1),time_A_session(9),60,colors(4,:),'LineWidth',2)
scatter(2*ones(1,1),time_A_session(10),60,colors(5,:),'LineWidth',2)
scatter(2*ones(1,1),time_A_session(11),60,colors(6,:),'LineWidth',2)
scatter(2*ones(1,1),time_A_session(12),60,colors(7,:),'LineWidth',2)
scatter(2*ones(3,1),time_A_session(13:15),60,colors(8,:),'LineWidth',2)

scatter(3*ones(3,1),odor_B_session(1:3),60,colors(1,:),'LineWidth',2);
hold on
scatter(3*ones(1,1),odor_B_session(4),60,colors(2,:),'LineWidth',2)
scatter(3*ones(4,1),odor_B_session(5:8),60,colors(3,:),'LineWidth',2)
scatter(3*ones(1,1),odor_B_session(9),60,colors(4,:),'LineWidth',2)
scatter(3*ones(1,1),odor_B_session(10),60,colors(5,:),'LineWidth',2)
scatter(3*ones(1,1),odor_B_session(11),60,colors(6,:),'LineWidth',2)
scatter(3*ones(1,1),odor_B_session(12),60,colors(7,:),'LineWidth',2)
scatter(3*ones(3,1),odor_B_session(13:15),60,colors(8,:),'LineWidth',2)

scatter(4*ones(3,1),time_B_session(1:3),60,colors(1,:),'LineWidth',2);
hold on
scatter(4*ones(1,1),time_B_session(4),60,colors(2,:),'LineWidth',2)
scatter(4*ones(4,1),time_B_session(5:8),60,colors(3,:),'LineWidth',2)
scatter(4*ones(1,1),time_B_session(9),60,colors(4,:),'LineWidth',2)
scatter(4*ones(1,1),time_B_session(10),60,colors(5,:),'LineWidth',2)
scatter(4*ones(1,1),time_B_session(11),60,colors(6,:),'LineWidth',2)
scatter(4*ones(1,1),time_B_session(12),60,colors(7,:),'LineWidth',2)
scatter(4*ones(3,1),time_B_session(13:15),60,colors(8,:),'LineWidth',2)
ylabel('Cells (%)')
xticks([1:4])
xlim([0.5 4.5])
xticklabels({'odor A','time A','odor B' ,'time B'})

scatter(1,nanmean(odor_A_session),100,'k','filled')
scatter(2,nanmean(time_A_session),100,'k','filled')
scatter(3,nanmean(odor_B_session),100,'k','filled')
scatter(4,nanmean(time_B_session),100,'k','filled')

errorbar(1,nanmean(odor_A_session),nanstd(odor_A_session)/sqrt(15),'k','LineWidth',2)
errorbar(2,nanmean(time_A_session),nanstd(time_A_session)/sqrt(15),'k','LineWidth',2)
errorbar(3,nanmean(odor_B_session),nanstd(odor_B_session)/sqrt(15),'k','LineWidth',2)
errorbar(4,nanmean(time_B_session),nanstd(time_B_session)/sqrt(15),'k','LineWidth',2)
set(gca, 'FontSize',16) 



figure()
plot(1:4,[nanmean(odor_A_session(1:3)),nanmean(time_A_session(1:3))...
    nanmean(odor_B_session(1:3)),nanmean(time_B_session(1:3))],'Color',colors(1,:),'LineWidth',2)
hold on
plot(1:4,[nanmean(odor_A_session(4)),nanmean(time_A_session(4))...
    nanmean(odor_B_session(4)),nanmean(time_B_session(4))],'Color',colors(2,:),'LineWidth',2)
plot(1:4,[nanmean(odor_A_session(5:8)),nanmean(time_A_session(5:8))...
    nanmean(odor_B_session(5:8)),nanmean(time_B_session(5:8))],'Color',colors(3,:),'LineWidth',2)
plot(1:4,[nanmean(odor_A_session(9)),nanmean(time_A_session(9))...
    nanmean(odor_B_session(9)),nanmean(time_B_session(9))],'Color',colors(4,:),'LineWidth',2)
plot(1:4,[nanmean(odor_A_session(10)),nanmean(time_A_session(10))...
    nanmean(odor_B_session(10)),nanmean(time_B_session(10))],'Color',colors(5,:),'LineWidth',2)
plot(1:4,[nanmean(odor_A_session(11)),nanmean(time_A_session(11))...
    nanmean(odor_B_session(11)),nanmean(time_B_session(11))],'Color',colors(6,:),'LineWidth',2)
plot(1:4,[nanmean(odor_A_session(12)),nanmean(time_A_session(12))...
    nanmean(odor_B_session(12)),nanmean(time_B_session(12))],'Color',colors(7,:),'LineWidth',2)
plot(1:4,[nanmean(odor_A_session(13:15)),nanmean(time_A_session(13:15))...
    nanmean(odor_B_session(13:15)),nanmean(time_B_session(13:15))],'Color',colors(8,:),'LineWidth',2)


scatter(ones(1,1),nanmean(odor_A_session(1:3)),60,colors(1,:),'filled','LineWidth',2);
hold on
scatter(ones(1,1),odor_A_session(4),60,colors(2,:),'filled','LineWidth',2)
scatter(ones(1,1),nanmean(odor_A_session(5:8)),60,colors(3,:),'filled','LineWidth',2)
scatter(ones(1,1),odor_A_session(9),60,colors(4,:),'filled','LineWidth',2)
scatter(ones(1,1),odor_A_session(10),60,colors(5,:),'filled','LineWidth',2)
scatter(ones(1,1),odor_A_session(11),60,colors(6,:),'filled','LineWidth',2')
scatter(ones(1,1),odor_A_session(12),60,colors(7,:),'filled','LineWidth',2)
scatter(ones(1,1),nanmean(odor_A_session(13:15)),60,colors(8,:),'filled','LineWidth',2)

scatter(2*ones(1,1),nanmean(time_A_session(1:3)),60,colors(1,:),'filled','LineWidth',2);
scatter(2*ones(1,1),time_A_session(4),60,colors(2,:),'filled','LineWidth',2)
scatter(2*ones(1,1),nanmean(time_A_session(5:8)),60,colors(3,:),'filled','LineWidth',2)
scatter(2*ones(1,1),time_A_session(9),60,colors(4,:),'filled','LineWidth',2)
scatter(2*ones(1,1),time_A_session(10),60,colors(5,:),'filled','LineWidth',2)
scatter(2*ones(1,1),time_A_session(11),60,colors(6,:),'filled','LineWidth',2)
scatter(2*ones(1,1),time_A_session(12),60,colors(7,:),'filled','LineWidth',2)
scatter(2*ones(1,1),nanmean(time_A_session(13:15)),60,colors(8,:),'filled','LineWidth',2)

scatter(3*ones(1,1),nanmean(odor_B_session(1:3)),60,colors(1,:),'filled','LineWidth',2);
scatter(3*ones(1,1),odor_B_session(4),60,colors(2,:),'filled','LineWidth',2)
scatter(3*ones(1,1),nanmean(odor_B_session(5:8)),60,colors(3,:),'filled','LineWidth',2)
scatter(3*ones(1,1),odor_B_session(9),60,colors(4,:),'filled','LineWidth',2)
scatter(3*ones(1,1),odor_B_session(10),60,colors(5,:),'filled','LineWidth',2)
scatter(3*ones(1,1),odor_B_session(11),60,colors(6,:),'filled','LineWidth',2)
scatter(3*ones(1,1),odor_B_session(12),60,colors(7,:),'filled','LineWidth',2)
scatter(3*ones(1,1),nanmean(odor_B_session(13:15)),60,colors(8,:),'filled','LineWidth',2)

scatter(4*ones(1,1),nanmean(time_B_session(1:3)),60,colors(1,:),'filled','LineWidth',2);
scatter(4*ones(1,1),time_B_session(4),60,colors(2,:),'filled','LineWidth',2)
scatter(4*ones(1,1),nanmean(time_B_session(5:8)),60,colors(3,:),'filled','LineWidth',2)
scatter(4*ones(1,1),time_B_session(9),60,colors(4,:),'filled','LineWidth',2)
scatter(4*ones(1,1),time_B_session(10),60,colors(5,:),'filled','LineWidth',2)
scatter(4*ones(1,1),time_B_session(11),60,colors(6,:),'filled','LineWidth',2)
scatter(4*ones(1,1),time_B_session(12),60,colors(7,:),'filled','LineWidth',2)
scatter(4*ones(1,1),nanmean(time_B_session(13:15)),60,colors(8,:),'filled','LineWidth',2)
ylabel('Cells (%)')
xticks([1:4])
xlim([0.5 4.5])
xticklabels({'odor A','time A','odor B' ,'time B'})
set(gca, 'FontSize',16) 
ylim([0 12])
box off
scatter(1,nanmean(odor_A_session),100,'k','filled')
scatter(2,nanmean(time_A_session),100,'k','filled')
scatter(3,nanmean(odor_B_session),100,'k','filled')
scatter(4,nanmean(time_B_session),100,'k','filled')

errorbar(1,nanmean(odor_A_session),nanstd(odor_A_session)/sqrt(15),'k','LineWidth',2)
errorbar(2,nanmean(time_A_session),nanstd(time_A_session)/sqrt(15),'k','LineWidth',2)
errorbar(3,nanmean(odor_B_session),nanstd(odor_B_session)/sqrt(15),'k','LineWidth',2)
errorbar(4,nanmean(time_B_session),nanstd(time_B_session)/sqrt(15),'k','LineWidth',2)
set(gca, 'FontSize',16) 

figure()
histogram([3,1,4,1,1,1,1,3],'FaceColor',[0.5 0.5 0.5])
ylim([0 5.5])
xticks([1:4])
box off
xlabel('# sessions per mouse')
ylabel('Count')
set(gca, 'FontSize',16) 
