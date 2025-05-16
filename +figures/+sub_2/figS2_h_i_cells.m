load.load_area_info()
load.load_area_sData()

figure()
subplot(1,2,1)
for i = 1:length(data)-1
    for f = 1:length(data(i).sessionIDs)
        noCells{i}(f)= size(mData(i,f).sData.imData.roiSignals.dff,1);
    end
    scatter(i*ones(length(noCells{i}),1),noCells{i},50,'k','LineWidth',1.5)
    mean_cell_no(i) = nanmean(noCells{i});
    sem_cell_no(i) = nanstd(noCells{i})/sqrt(length(noCells{i}));

    hold on
end


scatter(1:5,mean_cell_no,50,'k','filled')
errorbar(1:5,mean_cell_no,sem_cell_no,'k','LineStyle','none','LineWidth',1.5)
ylabel('# Cells')
box off
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
xlim([0.5 5.5])
xticklabels({'RSC','M2','PPC','S1/S2','V1/V2'})




subplot(1,2,2)
for i = 1:5
    for j = 1:5
        pval(i,j) = ranksum(noCells{i}',noCells{j}');
    end
end

matr =triu(ones(5,5));
matr(eye(5,5)==1) = NaN;
matr(matr== 0)= NaN;

subplot(1,2,2)
pval(isnan(matr)) = NaN;
[corrected_p, h]=helper.bonf_holm(pval);
imagesc(triu(corrected_p))
hold on
alpha(matr)
colorbar()
caxis([0 0.05])

xticklabels({'RSC','M2','PPC','S1/S2','V1/V2'})
yticklabels({'RSC','M2','PPC','S1/S2','V1/V2'})
xticks(1:5);yticks(1:5)
colorbar()
xticklabels({'RSC','M2','PPC','S1/S2','V1/V2'})

ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];