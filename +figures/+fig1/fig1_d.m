
savedir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Figures/Paper/fig1';

FA      = [];
CR      = [];
hit     = [];
miss    = [];

for i = 1:length(data)-1
    for f = 1:length(data(i).sessionIDs)
        sData = mData(i,f).sData;
        lickFrequency = behavior_analysis.extractLickFrequency(sData,100,15,15);
         trialed_lick_frequency = [];
        for n = 1: numel(sData.imData.variables.trialIndices(:,1))
            trial_indices = find(sData.imData.variables.trials==n);
            stage=sData.imData.variables.stage(trial_indices);
            
            odor1= trial_indices(stage==4);
            odor2= trial_indices(stage==6);
            delay= trial_indices(stage==5);
            
            preResponse=trial_indices(stage==7);
            responseWin=trial_indices(stage==8);
            ITI=trial_indices(stage==9);

    
            indices = [odor1,delay,odor2,preResponse,responseWin(1:end-1),ITI(2:end)];
            if length(indices) < 1200
                trialed_lick_frequency_temp = [lickFrequency(indices) NaN(1,1200-length(indices))];
            else
                trialed_lick_frequency_temp = lickFrequency(indices(1:1200));
            end

            trialed_lick_frequency(n,:) = trialed_lick_frequency_temp;
     
            
        end
        
        FA_trials = find(sData.imData.variables.FA(1:numel(sData.imData.variables.trialIndices(:,1))));
        CR_trials = find(sData.imData.variables.CR(1:numel(sData.imData.variables.trialIndices(:,1))));
        hit_trials = find(sData.imData.variables.hits(1:numel(sData.imData.variables.trialIndices(:,1))));
        miss_trials = find(sData.imData.variables.misses(1:numel(sData.imData.variables.trialIndices(:,1))));

        FA = [FA;nanmean(trialed_lick_frequency(FA_trials,:),1)];
        CR = [CR; nanmean(trialed_lick_frequency(CR_trials,:),1)];
        hit = [ hit ; nanmean(trialed_lick_frequency(hit_trials,:),1)];
        miss = [miss; nanmean(trialed_lick_frequency(miss_trials,:),1)];
    end
end


fig = figure('Position',[0 0 600 300]);

mean_var = nanmean(FA ,1);
std_var  = nanstd(FA ,1)/sqrt(size(FA,1));
xdata = 1:length(mean_var);
plot(nanmean(FA ,1),'Color','r','LineWidth',2)
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],'r','linestyle','none','FaceAlpha', 0.3);
hold on

mean_var = nanmean(CR ,1);
std_var  = nanstd(CR ,1)/sqrt(size(CR,1));
xdata = 1:length(mean_var);
plot(nanmean(CR,1),'Color','b','LineWidth',2)
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],'b','linestyle','none','FaceAlpha', 0.3);

mean_var = nanmean(hit ,1);
std_var  = nanstd(hit ,1)/sqrt(size(hit,1));
xdata = 1:length(mean_var);
plot(nanmean(hit,1),'Color','k','LineWidth',2)
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],'k','linestyle','none','FaceAlpha', 0.3);

mean_var = nanmean(miss ,1);
std_var  = nanstd(miss ,1)/sqrt(size(miss,1));
xdata = 1:length(mean_var);
plot(nanmean(miss,1),'Color',[1 0.5 0.0980],'LineWidth',2)
patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],[1 0.5 0.0980],'linestyle','none','FaceAlpha', 0.3);


xticks([0:100:1200])
xticklabels([1:12])
xlabel('Time')
ylabel('Lick rate (Hz)')
box off
xline(100,'k',[0.5 0.5 0.5],'LineStyle','--')
xline(6*100,'k',[0.5 0.5 0.5],'LineStyle','--')
xline(7*100,'k',[0.5 0.5 0.5],'LineStyle','--')
ax = gca;
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
ax.LineWidth = 1.5;


set(gca,'FontName','Arial','FontSize',15)
legend('off')

saveas(fig,fullfile(save_dir,'fig_1c.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig_1c.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig_1c.png'),'png')


mean_session{1} = nanmean(FA(:,1:600) ,2);
mean_session{2} = nanmean(miss(:,1:600) ,2);
mean_session{3} = nanmean(CR(:,1:600) ,2);
mean_session{4} = nanmean(hit(:,1:600) ,2);


fig = figure('Position',[0 0 300 300]);
scatter(1,nanmean(mean_session{1}),70,'filled','k')
hold on
errorbar(1,nanmean(mean_session{1}),nanstd(mean_session{1}),'k','LineWidth',1.5)
scatter(2,nanmean(mean_session{2}),70,'filled','k')
errorbar(2,nanmean(mean_session{2}),nanstd(mean_session{2}),'k','LineWidth',1.5)
scatter(3,nanmean(mean_session{3}),70,'filled','k')
errorbar(3,nanmean(mean_session{3}),nanstd(mean_session{3}),'k','LineWidth',1.5)
scatter(4,nanmean(mean_session{4}),70,'filled','k')
errorbar(4,nanmean(mean_session{4}),nanstd(mean_session{4}),'k','LineWidth',1.5)
ylabel('Lick rate (Hz)')
xticks([1:4])
xlim([0.5 4.5])
xticklabels({'FA','miss','CR','hit'})


for i = 1:4
    for j = 1:4
        pval(i,j) = ranksum(mean_session{i}(~isnan(mean_session{i})),mean_session{j}(~isnan(mean_session{j})));
    end
end

matr =triu(ones(4,4));
matr(eye(4,4)==1) = NaN;
matr(matr== 0)= NaN;
pval(isnan(matr)) = NaN;
[corrected_p, ~]=helper.bonf_holm(pval);

[row,column]  = find(corrected_p<0.05);

for i = 1:length(row)
    add_sig_bar.sigstar([row(i),column(i)],corrected_p(row(i),column(i)))
end