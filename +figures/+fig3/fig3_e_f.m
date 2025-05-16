   
fig = figure();
col= [255,42, 42;255, 128, 87; 0 128 128;...
    194, 216, 149; 91 196 233]./255;

xdata =0:0.5:6;
for i = 1:length(data)-1
    for f = 1:length(data(i).sessionIDs)
        mean_accuracy{i}(f,:)        = nanmean(mData(i,f).d_data_svm.accuracy_test);
    end
    
   
    mean_var = nanmean(mean_accuracy{i});
    std_var  = nanstd(mean_accuracy{i})/sqrt(length(data(i).sessionIDs));

    plot(xdata,mean_var,'Color',col(i,:),'LineWidth',1.5)
    hold on
    patch(gca,[xdata  fliplr(xdata)],[mean_var+std_var fliplr(mean_var-std_var)],col(i,:),'linestyle','none','FaceAlpha', 0.3);
    xline(1,'LineWidth',1,'LineStyle','--')
    
end



yline(0.5,'k','LineWidth',1.5,'LineStyle','--')
ylabel('Correct odor decoding (%)')
box('off')
set(gca,'FontName','Arial','FontSize',15)
xlabel('Time (s)')
ylim([0.3 1])
yticks([0.4:0.1:1])
yticklabels(100*[0.4:0.1:1])

saveas(fig,fullfile(save_dir,'fig3_e.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig3_e.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig3_e.png'),'png')


fig = figure('Position',[600 100 600 300]);
for i = 1:length(data)-1
%     for f = 1:length(data(i).sessionIDs)
       mean_session{i} = nanmean(mean_accuracy{i},2);
     %  mean_session_chance(i) = nanmean( mean_accuracy_chance{i}(:));
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
ylim([0.35 1])

% check p-value:
ranksum(mean_session{5},0.5*ones(1,length(mean_session{5})))
%ranksum(mean_accuracy{1}(:),mean_accuracy_chance{1}(:))


% calculate all pvals with ranksum 
for i = 1:5
    for j = 1:5
        pval(i,j) = ranksum(mean_session{i}',mean_session{j}');
    end
end

matr =triu(ones(5,5));
matr(eye(5,5)==1) = NaN;
matr(matr== 0)= NaN;
pval(isnan(matr)) = NaN;
[corrected_p, ~]=helper.bonf_holm(pval);

figure()
% matr =triu(ones(5,5));
matr(eye(5,5)==1) = NaN;
matr(matr== 0)= NaN;

imagesc(triu(corrected_p))
hold on
alpha(matr)

xticklabels({'RSC','M2','PPC','S1','V1/V2'})
yticklabels({'RSC','M2','PPC','S1','V1/V2'})
xticks(1:5);yticks(1:5)
colorbar()
caxis([0 0.05])
title('Time cells')

groups = {[1,2],[1,3],[1,4],[1,5]};
for i = 1:length(groups)
    p_value_RSC(i) = ranksum(mean_session{groups{i}(1)}',mean_session{groups{i}(2)}','tail','right');
end
[corrected_p, h]=helper.bonf_holm(p_value_RSC);
add_sig_bar.sigstar(groups,corrected_p')


saveas(fig,fullfile(save_dir,'fig3_f.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig3_f.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig3_f.png'),'png')

