% savedir = "/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/";

fig_areas = figure();
hax_area_time =subplot(2,1,1); hold(hax_area_time,'on')
hax_area_odor =subplot(2,1,2); hold(hax_area_odor,'on')

odorA  = [];
odorB  = [];
time   = [];
odor   = [];

for i = 1:length(data)-1
%        fig_prct = figure();
%        hax_time = subplot(1,2,1);  hold(hax_time,'on')
% %        hax_odor = subplot(1,2,2);  hold(hax_odor,'on')
%        hax_sum  = subplot(1,2,2);  hold(hax_sum,'on')
%        timeAB = [];
%        timeA  = [];
%        timeB  = [];
%        odorAB = [];
%        odorA  = [];
%        odorB  = [];
%        time   = [];
%        odor   = [];
       for f = 1:length(data(i).sessionIDs)
           
             
            timeA{i}(f) = 100*length(mData(i,f).TimeA.indices)/length(mData(i,f).classification_chance);
            timeB{i}(f) = 100*length(mData(i,f).TimeB.indices)/length(mData(i,f).classification_chance);

            odorA{i}(f) = 100*length(mData(i,f).OdorA.indices)/length(mData(i,f).classification_chance);
            odorB{i}(f) = 100*length(mData(i,f).OdorB.indices)/length(mData(i,f).classification_chance);

            time{i}(f) = 100*length(unique([mData(i,f).TimeA.indices;mData(i,f).TimeB.indices]))/length(mData(i,f).classification_chance);
            odor{i}(f) = 100*length(unique([mData(i,f).OdorA.indices;mData(i,f).OdorB.indices]))/length(mData(i,f).classification_chance);
            
            sequenceA{i}(f) = timeA{i}(f)+odorA{i}(f);
            sequenceB{i}(f) = timeB{i}(f)+odorB{i}(f);

            
%             mData(i,f).prct_classification =classification.classifcation_plotting.getNumberClassifiedCells(mData(i,f).classification);
%             timeAB(f) = mData(i,f).prct_classification.TimeAB;
%             timeA(f) = mData(i,f).prct_classification.TimeA;
%             timeB(f) = mData(i,f).prct_classification.TimeB;
%             
%             odorAB(f) = mData(i,f).prct_classification.OdorAB;
%             odorA(f) = mData(i,f).prct_classification.OdorA;
%             odorB(f) = mData(i,f).prct_classification.OdorB;
%             
%             time(f) =sum([timeAB(f),timeA(f),timeB(f)]');
%             odor(f) =sum([odorAB(f),odorA(f),odorB(f)]');
       
%             scatter(hax_time, 1:2,[timeA{i}(f) timeB{i}(f)],50,'k')
%             scatter(hax_odor, 1:2,[odorA{i}(f) odorB{i}(f)],50,'k')
%             scatter(hax_sum, 1:2,[time{i}(f) odor{i}(f)],50,'k')

       end
       
        fig_sequence = figure('Position',[0 0 300 300]);
        hax_time = subplot(1,1,1);  hold(hax_time,'on')
        bar(hax_time,1:2,nanmean([sequenceA{i}' sequenceB{i}'],1),'FaceColor',[0.8 0.8 0.8])
        hold on
        errorbar(hax_time,1:2,nanmean([ sequenceA{i}' sequenceB{i}'],1),nanstd([ sequenceA{i}' sequenceB{i}'],1)/sqrt(length(data(i).sessionIDs)),'k','LineWidth',1.5,'LineStyle','none')
        scatter(hax_time, 1*ones(length(data(i).sessionIDs),1),sequenceA{i}' ,50,'k')
        scatter(hax_time, 2*ones(length(data(i).sessionIDs),1), sequenceB{i}',50,'k')
        
        xticks(hax_time,[1:2])
        xticklabels(hax_time,{'Sequence A','Sequence B'})
        xtickangle(hax_time,45)
%         title(hax_time,'Time cells')
        xlim(hax_time,[0.5 2.5])
        ylabel(hax_time,"Percentage(%)")
        set(hax_time,'FontName','Arial','FontSize',15)

        pval = ranksum(sequenceA{i},sequenceB{i});
        add_sig_bar.sigstar([1,2],pval)


%         bar(hax_odor,1:2,nanmean([odorA{i}' odorB{i}'],1),'FaceColor',[0.8 0.8 0.8])
%         hold on
%         errorbar(hax_odor,1:2,nanmean([ odorA{i}' odorB{i}'],1),nanstd([odorA{i}' odorB{i}'],1)/sqrt(length(data(i).sessionIDs)),'k','LineWidth',1.5,'LineStyle','none')
%         scatter(hax_odor, 1*ones(length(data(i).sessionIDs),1),odorA{i}' ,50,'k')
%         scatter(hax_odor, 2*ones(length(data(i).sessionIDs),1), odorB{i}',50,'k')
% 
%         xticks(hax_odor,[1:2])
%         xticklabels(hax_odor,{'Sequence A','Sequence B'})
%         title(hax_odor,'Odor cells')
%         xtickangle(hax_odor,45)
%         xlim(hax_odor,[0.5 2.5])
%         ylabel(hax_odor,"Percentage(%)")
%         set(hax_odor,'FontName','Arial','FontSize',15)
%     
        fig_sum = figure('Position',[0 0 300 300]);
        hax_sum = subplot(1,1,1);  hold(hax_sum,'on')
        bar(hax_sum,1:2,nanmean([time{i}' odor{i}'],1),'FaceColor',[0.8 0.8 0.8])
        hold on
        errorbar(hax_sum,1:2,nanmean([ time{i}' odor{i}'],1),nanstd([odorA{i}' odorB{i}'],1)/sqrt(length(data(i).sessionIDs)),'k','LineWidth',1.5,'LineStyle','none')
        scatter(hax_sum, 1*ones(length(data(i).sessionIDs),1),time{i}' ,50,'k')
        scatter(hax_sum, 2*ones(length(data(i).sessionIDs),1), odor{i}',50,'k')

        xticks(hax_sum,[1:2])
        xticklabels(hax_sum,{'Time','Odor'})
        xtickangle(hax_sum,45)
%         title(hax_sum,'Summary')
        xlim(hax_sum,[0.5 2.5])
        ylabel(hax_sum,"Percentage(%)")
        set(hax_sum,'FontName','Arial','FontSize',15)
        
        pval = ranksum(time{i},odor{i});
        add_sig_bar.sigstar([1,2],pval)
        
%         saveas(fig_sequence,fullfile(savedir,'plots/classification',data(i).area,'prct_sequence.pdf'),'pdf')
%         saveas(fig_sequence,fullfile(savedir,'plots/classification',data(i).area,'prct_sequence.fig'),'fig')
%         saveas(fig_sequence,fullfile(savedir,'plots/classification',data(i).area,'prct_sequence.png'),'png')
% 
%         saveas(fig_sum,fullfile(savedir,'plots/classification',data(i).area,'prct_timeVsodor.pdf'),'pdf')
%         saveas(fig_sum,fullfile(savedir,'plots/classification',data(i).area,'prct_timeVsodor.fig'),'fig')
%         saveas(fig_sum,fullfile(savedir,'plots/classification',data(i).area,'prct_timeVsodor.png'),'png')

        
        mean_area_time(i)= nanmean(time{i});
        sem_area_time(i)= nanstd(time{i})/sqrt(length(time{i}));
        mean_area_odor(i)= nanmean(odor{i});
        sem_area_odor(i)= nanstd(odor{i})/sqrt(length(odor{i}));
end       
   



for i = 1:length(data)-1
    bar(hax_area_time,i,mean_area_time(i),'FaceColor',[0.7,0.7,0.7])
    hold on
    errorbar(hax_area_time,i,mean_area_time(i),sem_area_time(i),'k','LineWidth',1.5)
    scatter(hax_area_time,i*ones(length(time{i}),1),time{i},120,'k')
end

xticks(hax_area_time,[1:length(data)])
xticklabels(hax_area_time,{'RSC','CA1','M2','PPC','S1/S2','V1/V2'})
ylabel(hax_area_time,'Percentage - time cells(%)')
set(hax_area_time,'FontName','Arial','FontSize',15)
box('off')


figure()
scatter(ones(length(cell2mat(odorA)),1),cell2mat(odorA),50,'k')
hold on
scatter(2*ones(length(cell2mat(odorA)),1),cell2mat(odorA),50,'k')
scatter(3*ones(length(cell2mat(odorA)),1),cell2mat(timeA),50,'k')
scatter(4*ones(length(cell2mat(odorA)),1),cell2mat(timeB),50,'k')
hold on
scatter(1,nanmean(cell2mat(odorA)),100,'filled','r')
scatter(2,nanmean(cell2mat(odorB)),100,'filled','r')
scatter(3,nanmean(cell2mat(timeA)),100,'filled','r')
scatter(4,nanmean(cell2mat(timeB)),100,'filled','r')
errorbar(1,nanmean(cell2mat(odorA)),nanstd(cell2mat(odorA))/sqrt(length(cell2mat(odorA))),'r','LineWidth',1.5)
errorbar(2,nanmean(cell2mat(odorB)),nanstd(cell2mat(odorB))/sqrt(length(cell2mat(odorB))),'r','LineWidth',1.5)
errorbar(3,nanmean(cell2mat(timeA)),nanstd(cell2mat(timeA))/sqrt(length(cell2mat(timeA))),'r','LineWidth',1.5)
errorbar(4,nanmean(cell2mat(timeB)),nanstd(cell2mat(timeB))/sqrt(length(cell2mat(timeB))),'r','LineWidth',1.5)
xlim([0.5 4.5])
xticks([1:4])
xticklabels({'Odor A','Odor B','Time A','Time B'})
set(gca,'FontSize',12)
ylabel('Classified cells shuffled (%)')


% calculate all pvals with ranksum 
for i = 1:5
    for j = 1:5
        pval(i,j) = ranksum(time{i}',time{j}');
    end
end

matr =triu(ones(5,5));
matr(eye(5,5)==1) = NaN;
matr(matr== 0)= NaN;
pval(isnan(matr)) = NaN;
[corrected_p, ~]=helper.bonf_holm(pval);

[row,col]  = find(corrected_p<0.05);
if ~isempty(row)
    for i = 1:length(row)
        add_sig_bar.sigstar([row(i),col(i)],corrected_p(row(i),col(i)))
    end
end




for i = 1:length(data)-1
    bar(hax_area_odor,i,mean_area_odor(i),'FaceColor',[0.7,0.7,0.7])
    hold on
    errorbar(hax_area_odor,i,mean_area_odor(i),sem_area_odor(i),'k','LineWidth',1.5)
    scatter(hax_area_odor,i*ones(length(odor{i}),1),odor{i},120,'k')
end

xticks(hax_area_odor,[1:length(data)])
xticklabels(hax_area_odor,{'RSC','CA1','M2','PPC','S1/S2','V1/V2'})
ylabel(hax_area_odor,'Percentage - odor cells(%)')
set(hax_area_odor,'FontName','Arial','FontSize',15)
box('off')


% calculate all pvals with ranksum 
for i = 1:5
    for j = 1:5
        pval(i,j) = ranksum(time{i}',time{j}');
    end
end

matr =triu(ones(5,5));
matr(eye(5,5)==1) = NaN;
matr(matr== 0)= NaN;
pval(isnan(matr)) = NaN;
[corrected_p, ~]=helper.bonf_holm(pval);

[row,col]  = find(corrected_p<0.05);
if ~isempty(row)
    for i = 1:length(row)
        add_sig_bar.sigstar([row(i),col(i)],corrected_p(row(i),col(i)))
    end
end

saveas(fig_areas,fullfile(savedir,'plots','prct_all.pdf'),'pdf')
saveas(fig_areas,fullfile(savedir,'plots','prct_all.fig'),'fig')
saveas(fig_areas,fullfile(savedir,'plots','prct_all.png'),'png')





