save_dir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Figures/Paper/fig3';
col(1,:) =  [234,245,234]./255;
col(3,:) =  [189,205,246]./255;
col(2,:) =  [90 197 118]./255;
col(4,:) =  [38 119 246]./255;
col(5,:)=  [0.8 0.8 0.8];

odor_A = [];
time_A = [];
odor_B = [];
time_B = [];

fig = figure();
i = 5;
for j = 1:length(data)-1

    odor_A_session =[];
    odor_B_session=[];
    time_A_session = [];
    time_B_session = [];
    for i = 1:length(data(j).sessionIDs)
        odor_A_session(i) = length(mData(j,i).OdorA.indices)/length(mData(j,i).classification);
        odor_B_session(i) = length(mData(j,i).OdorB.indices)/length(mData(j,i).classification);
        time_A_session(i) = length(mData(j,i).TimeA.indices)/length(mData(j,i).classification);
        time_B_session(i) = length(mData(j,i).TimeB.indices)/length(mData(j,i).classification);
    end
     odor_A = 100*nanmean(odor_A_session);
% %     odor_A_std = 100*nanstd(odor_A_session)
     odor_B = 100*nanmean(odor_B_session);
% %     odor_B_std = 100*nanstd(odor_B_session)
     time_B = 100*nanmean(time_B_session);
% %     time_B_std = 100*nanstd(time_B_session)
     time_A = 100*nanmean(time_A_session);
%     time_A_std = 100*nanmean(time_A_session)
     not_tuned = 100-odor_A -odor_B-time_A -time_B;
    
    ax = subplot(1,length(data)-1,j);
    
%     ax = gca;
    perc_pie = pie([odor_A,time_A,odor_B ,time_B,not_tuned]);
     [odor_A,time_A,odor_B ,time_B,not_tuned]
     [100*nanstd(odor_A_session) 100*nanstd(time_A_session) 100*nanstd(odor_B_session) 100*nanstd(time_B_session)]

    ax.Colormap = col;
    title(data(j).area)
end

for j = 1:length(data)-1

    odor_A_session =[];
    odor_B_session=[];
    time_A_session = [];
    time_B_session = [];
    for i = 1:length(data(j).sessionIDs)
        odor_A_session{j}(i) = length(mData(j,i).OdorA.indices)/length(mData(j,i).classification);
        odor_B_session{j}(i) = length(mData(j,i).OdorB.indices)/length(mData(j,i).classification);
        time_A_session{j}(i) = length(mData(j,i).TimeA.indices)/length(mData(j,i).classification);
        time_B_session{j}(i) = length(mData(j,i).TimeB.indices)/length(mData(j,i).classification);
    end
    sequence_cells_A{j} = odor_A_session{j}+time_A_session{j};
    sequence_cells_B{j} = odor_B_session{j}+time_B_session{j};
    sequence_cells{j} = sequence_cells_A{j}+sequence_cells_B{j};

end




fig = figure('Position',[600 100 600 300]);
for i = 1:length(data)-1
    mean_session{i} = sequence_cells{i};

    bar(i,nanmean(mean_session{i}),'FaceColor',[0.7,0.7,0.7],'EdgeColor','none')
    hold on
    errorbar(i,nanmean(mean_session{i}),nanstd(mean_session{i})/sqrt(length(mean_session{i})),'k','LineWidth',2)
    scatter(i*ones(length(mean_session{i}),1),mean_session{i},120,'k','LineWidth',2)
   
end

xticks([1:length(data)-1])
xticklabels({'RSC','M2','PPC','S1','V1/V2'})
ylabel('Sequence cells (%)')
set(gca,'FontName','Arial','FontSize',15)
box('off')
yticks([0:0.1:0.5])
yticklabels(100*[0:0.1:0.5])

% check p-value:
% calculate all pvals with ranksum 
i = 1;
for j = 2:5
    pval(j-1) = ranksum(mean_session{i}',mean_session{j}','tail','right');
 end

[corrected_p, ~]=helper.bonf_holm(pval);

column  = find(corrected_p<0.05)+1;
row = ones(length(column),1);
for i = 1:length(row)
    add_sig_bar.sigstar([row(i),column(i)],corrected_p(i))
end
%% RSC 
% The average percentage of odor A cells is:  6.2 % +/-  1.6 % (mean +/- SEM over session) 
% The average percentage of time A cells is:  4.8 % +/-  0.2 % (mean +/- SEM over session) 
% The average percentage of odor B cells is:  5.7 % +/-  0.18 % (mean +/- SEM over session) 
% The average percentage of time B cells is:  4.7 % +/-  0.25 % (mean +/- SEM over session) 

% % M2 = 
% The average percentage of odor A cells is:  4.9 % +/-  1.8 % (mean +/- SM over session) 
% The average percentage of time A cells is:  2.4 % +/-  0.7 % (mean +/- SEM over session) 
% The average percentage of odor B cells is:  2.9 % +/-  1.3 % (mean +/- SEM over session) 
% The average percentage of time B cells is:  1.8 % +/-  0.6 % (mean +/- SEM over session) 
% 
% % PPC = 
% The average percentage of odor A cells is:  2.4 % +/-  0.9 % (mean +/- SEM over session) 
% The average percentage of time A cells is:  1.9 % +/-  0.4 % (mean +/- SEM over session) 
% The average percentage of odor B cells is:  1.4 % +/-  0.4 % (mean +/- SEM over session) 
% The average percentage of time B cells is:  1.1 % +/-  0.2 % (mean +/- SEM over session) 
% % % % 
%  
% % S1 & S2
% The average percentage of odor A cells is:  3.5 % +/-  0.9 % (mean +/- SEM over session) 
% The average percentage of time A cells is:  1.5 % +/-  0.7 % (mean +/- SEM over session) 
% The average percentage of odor B cells is:  2.8 % +/-  1.7 % (mean +/- SEM over session) 
% The average percentage of time B cells is:  0.9 % +/-  0.5 % (mean +/- SEM over session) 

%  
% % V1 & V2
% The average percentage of odor A cells is:  1.4 % +/-  0.1 % (mean +/- SEM over session) 
% The average percentage of time A cells is:  2.3 % +/-  0.1 % (mean +/- SEM over session) 
% The average percentage of odor B cells is:  0.6 % +/-  0.1 % (mean +/- SEM over session) 
% The average percentage of time B cells is:  1.1 % +/-  0.1 % (mean +/- SEM over session) 

saveas(fig,fullfile(save_dir,'fig_3b.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig_3b.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig_3b.png'),'png')

for j = 1:length(data)-1
    no_cells(j) = 0;
    for i = 1:length(data(j).sessionIDs)
        no_cells(j) =  no_cells(j)+length(mData(j,i).classification);
    end
end

fprintf('M2: 4 mice,%4.0f FOVs, %4.0f cells recorded in total \n',length(data(2).sessionIDs),no_cells(2))
fprintf('PPC: 4 mice,%4.0f FOVs, %4.0f cells recorded in total \n',length(data(3).sessionIDs),no_cells(3))
fprintf('S1/S2: 4 mice,%4.0f FOVs, %4.0f cells recorded in total \n',length(data(4).sessionIDs),no_cells(4))
fprintf('V1/V2: 5 mice,%4.0f FOVs, %4.0f cells recorded in total \n',length(data(5).sessionIDs),no_cells(5))

% M2: 4 mice,   6 FOVs, 1927 cells recorded in total 
% PPC: 4 mice,   7 FOVs, 2888 cells recorded in total 
% S1/S2: 4 mice,   6 FOVs, 2359 cells recorded in total 
% V1/V2: 5 mice,   7 FOVs, 2911 cells recorded in total 

fprintf('Of all %4.1f RSC neurons recorded, we classified %4.1f %% as odor A, %4.1f %% as time A, %4.1f %% as odor B and %4.1f %% as time B responsive \n',...
    no_cells(j),odor_A, time_A, odor_B, time_B)
fprintf('The average percentage of odor A cells is: %4.1f %% +/- %4.1f %% (mean +/- SEM over session) \n',nanmean(100*odor_A_session),nanstd(100*odor_A_session)/sqrt(length(odor_A_session)))
fprintf('The average percentage of time A cells is: %4.1f %% +/- %4.1f %% (mean +/- SEM over session) \n',nanmean(100*time_A_session),nanstd(100*time_A_session)/sqrt(length(time_A_session)))
fprintf('The average percentage of odor B cells is: %4.1f %% +/- %4.1f %% (mean +/- SEM over session) \n',nanmean(100*odor_B_session),nanstd(100*odor_B_session)/sqrt(length(odor_B_session)))
fprintf('The average percentage of time B cells is: %4.1f %% +/- %4.1f %% (mean +/- SEM over session) \n',nanmean(100*time_B_session),nanstd(100*time_B_session)/sqrt(length(time_B_session)))



no_cells = 0;
for i = 1:length(data(2).sessionIDs)
    no_cells =  no_cells+length(mData(2,i).classification);
end

