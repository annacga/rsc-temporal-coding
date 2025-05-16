
save_dir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/svm/';
for i =1:length(data)
   accuracy_time_firing_fields_all = [];
   accuracy_odor_firing_fields_all = [];
   time_firing_fields_all = [];
   odor_firing_fields_all = [];
   
   for f = 1:length(data(i).sessionIDs)
       accuracy_time_firing_fields_all = [accuracy_time_firing_fields_all;mData(i,f).TimeA.accuracy';mData(i,f).TimeB.accuracy'];
       accuracy_odor_firing_fields_all = [ accuracy_odor_firing_fields_all ;mData(i,f).OdorA.accuracy';mData(i,f).OdorB.accuracy'];
      
       time_firing_fields_all = [time_firing_fields_all;mData(i,f).TimeA.field_location;mData(i,f).TimeB.field_location];
       odor_firing_fields_all = [odor_firing_fields_all;mData(i,f).OdorA.field_location;mData(i,f).OdorB.field_location];
   end
   
   time_firing_fields_all_sig = time_firing_fields_all(accuracy_time_firing_fields_all>0.5);
   odor_firing_fields_all_sig = odor_firing_fields_all(accuracy_odor_firing_fields_all>0.5);
   accuracy_time_firing_fields_all_sig = accuracy_time_firing_fields_all(accuracy_time_firing_fields_all>0.5);
   accuracy_odor_firing_fields_all_sig= accuracy_odor_firing_fields_all(accuracy_odor_firing_fields_all>0.5);
   
   time_firing_fields_all_notsig = time_firing_fields_all(accuracy_time_firing_fields_all<=0.5);
   odor_firing_fields_all_notsig = odor_firing_fields_all(accuracy_odor_firing_fields_all<=0.5);
   accuracy_time_firing_fields_all_notsig = accuracy_time_firing_fields_all(accuracy_time_firing_fields_all<=0.5);
   accuracy_odor_firing_fields_all_notsig= accuracy_odor_firing_fields_all(accuracy_odor_firing_fields_all<=0.5);
   
   fig = figure('Position',[0 0 700, 600]); 
   subplot(4,1,[1:3])
   scatter(time_firing_fields_all_sig,accuracy_time_firing_fields_all_sig,40,'k','filled')
   hold on
   scatter(odor_firing_fields_all_sig,accuracy_odor_firing_fields_all_sig,40,'k','filled')
   scatter(time_firing_fields_all_notsig,accuracy_time_firing_fields_all_notsig,40,'r','filled')
   scatter(odor_firing_fields_all_notsig,accuracy_odor_firing_fields_all_notsig,40,'r','filled')
   yline(0.5,'LineWidth',1.5,'LineStyle','--');
%    xlabel('Firing field times (s)')
   ylabel('% correct odor decoding per sequence cell')
   
   set(gca,'FontSize',15)
   ylim([0 1])
   yticks([0:0.1:1])
   yticklabels(100*[0:0.1:1])
   xticks([0:31/5:44])
   xticklabels({'0','1','2','3','4','5','6','7'})
   xline(1*31/5,'LineWidth',1,'LineStyle','--');
   xline(6*31/5,'LineWidth',1,'LineStyle','--');
   xlim([0 44])
 
   
   if ~exist(fullfile(save_dir,data(i).area)); mkdir(fullfile(save_dir,data(i).area)); end
   
   for p = 1:44
       indices_time_p = find(time_firing_fields_all  == p);
       indices_odor_p = find(odor_firing_fields_all  == p);
       no_cells_above_chance = length(find(accuracy_time_firing_fields_all(indices_time_p)>0.5))+length(find(accuracy_odor_firing_fields_all(indices_odor_p)>0.5));
       no_cells = length(indices_time_p) +length(indices_odor_p);
       
       if isempty(no_cells ) 
           prct_cells_above_chance(p) = NaN;
       else
           prct_cells_above_chance(p) = no_cells_above_chance/no_cells ;
       end
   end
   
   subplot(4,1,4)
   bar(prct_cells_above_chance','FaceColor',[0.8 0.8 0.8])
   yticks([0:0.5:1])
   yticklabels(100*[0:0.5:1])
   xticks([0:31/5:44])
   xticklabels({'0','1','2','3','4','5','6','7'})
   xlabel('Firing field times (s)')
   ylabel('Significant decoders (%)')
   set(gca,'FontSize',15)
   xline(1*31/5,'LineWidth',1,'LineStyle','--');
   xline(6*31/5,'LineWidth',1,'LineStyle','--');
   xlim([0 44])
   box off
   
   saveas(fig,fullfile(save_dir,data(i).area,'svm_cell_sum.fig'),'fig')
   saveas(fig,fullfile(save_dir,data(i).area,'svm_cell_sum.png'),'png')
end