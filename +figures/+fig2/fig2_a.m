 
firing_fields_A = [];
firing_fields_B = [];
for f = 1:length(data(1).sessionIDs)
    
    firing_fields_A = [firing_fields_A;mData(1,f).OdorA.field_location;mData(1,f).TimeA.field_location];
    firing_fields_B = [firing_fields_B;mData(1,f).OdorB.field_location;mData(1,f).TimeB.field_location];

end
    

fig = plot.distribution_firing_field(firing_fields_A,firing_fields_B);

saveas(fig,fullfile(save_dir,'fig_2a.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig_2a.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig_2a.png'),'png')

uiopen('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Figures/Paper/fig2/taxidis/Fields_distribution.fig')    
ax = gca;
figure();
plot(ax.Children(1).XData-1,ax.Children(1).YData,'LineWidth',1.5,'Color','r')
ylim([0 20])
saveas(gca,fullfile(save_dir,'fig_2a_taxidis.fig'),'fig')
saveas(gca,fullfile(save_dir,'fig_2a_taxidis.pdf'),'pdf')
saveas(gca,fullfile(save_dir,'fig_2a_taxidis.png'),'png')
    
    