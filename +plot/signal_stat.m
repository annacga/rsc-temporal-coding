

function signal_stat(measure,mean_measure)

figure()
subplot(1,2,1)
violin({measure{1},measure{2},measure{3},...
    measure{4},measure{5},measure{6}},'facecolor',[0.5 0.5 0.5])
xticklabels({ 'RSC', 'CA1', 'M2', 'PPT', 'S1/S2', 'V1/V2'})
xticks(gca,[1:6])
ax = gca;
ylim([0 12])
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
box off


% calculate all pvals with ranksum 
for i = 1:6
    for j = 1:6
        pval(i,j) = ranksum(mean_measure{i}',mean_measure{j}');
    end
end

matr =triu(ones(6,6));
matr(eye(6,6)==1) = NaN;
matr(matr== 0)= NaN;
pval(isnan(matr)) = NaN;
[corrected_p, ~]=helper.bonf_holm(pval);

subplot(1,2,2)
imagesc(triu(corrected_p))
hold on
alpha(matr)

xticks([1:6])
yticks([1:6])
c = colorbar('Limits',[0 0.05]);
caxis([0 0.05])

xticklabels({ 'RSC', 'CA1', 'M2', 'PPT', 'S1/S2', 'V1/V2'})
yticklabels({ 'RSC', 'CA1', 'M2', 'PPT', 'S1/S2', 'V1/V2'})

ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
xtickangle(45)

