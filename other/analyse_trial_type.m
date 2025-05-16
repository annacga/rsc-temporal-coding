
save_dir_behave = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/behavior';

for i = 1:length(data)-1
    
    for f = 1:length(data(i).sessionIDs)
        hits(i,f)   = sum(mData(i,f).sData.imData.variables.hits);
        misses(i,f) = sum(mData(i,f).sData.imData.variables.misses);
        CR(i,f)     = sum(mData(i,f).sData.imData.variables.CR);
        FA(i,f)     = sum(mData(i,f).sData.imData.variables.FA);
    end
    fig = figure();
    scatter(ones(1,length(data(i).sessionIDs)),hits(i,:),50,'k');
    hold on
    scatter(2*ones(1,length(data(i).sessionIDs)),misses(i,:),50,'k');
    scatter(3*ones(1,length(data(i).sessionIDs)),CR(i,:),50,'k');
    scatter(4*ones(1,length(data(i).sessionIDs)),FA(i,:),50,'k');
    
    xticks([1:4]);
    xtickangle(45)
    xticklabels({'hits','misses','CR','FA'})
    ylabel('# Trials')
    set(gca, 'FontName','Arial','FontSize',16)
    xlim([0.5 4.5])
    saveas(fig,fullfile(save_dir_behave,data(i).area,'trial_type.fig'),'fig')
    saveas(fig,fullfile(save_dir_behave,data(i).area,'trial_type.pdf'),'pdf')
    saveas(fig,fullfile(save_dir_behave,data(i).area,'trial_type.png'),'png')
    sum(hits)
    sum(misses)
    sum(CR)
    sum(FA)
end


