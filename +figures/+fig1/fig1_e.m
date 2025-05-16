


% Parameters
area = 1;
session = 1;
lineWidth = 1;
deconv_color = [250,0,0]/255;%[251,176,59]/255;
ind_start = 17000; % bin in recording
ind_end =20200;%size(sData.imData.roiSignals.dff,2); % bin in recording

% Plot the landmarks
fig = figure(); clf;
c = 1; % init

% cells = [ 44 379 182 84 155 274 346  168]; 
hold on
cells = [ 379 182 84  274  168]; 


% For each of the selected landmark cells
for i = 1:length(cells) %[3,5,4,13]   tcs: [3,9,17], pcs: [11,45]
    cell_index = cells(i);
    c = c+1;
    
    sData = mData(area,session).sData;
    % Plot activity
    d = fdesign.lowpass('Fp,Fst,Ap,Ast',0.1,1,1,60); 
    dffToPlot =  smoothdata(normalize(sData.imData.roiSignals.dff(cell_index,:),'range',[0,1]),'gaussian',3);
    deconvToPlot = smoothdata(-0.2+normalize(sData.imData.roiSignals.deconv(cell_index,:),'range',[0,0.5]),'gaussian',3);

    deconvToPlot = deconvToPlot + c;
    dffToPlot = dffToPlot + c;
    
    plot(dffToPlot,'LineWidth',lineWidth,'Color','k')
    hold on
    plot(deconvToPlot(1,:),'LineWidth',lineWidth+0.5,'Color',deconv_color)
%     xlim([0,ind_end-ind_start])
%     ylim([0,6.2])
    yticks([])
%     xticks([])
    
    box off
end

odor_A  =  [142 215 150]./255; % Odor Sequence A colour
odor_B =  [55 170 235]./255; % Odor Sequence B colour

ylim_set = get(gca,'ylim');
parameters = classification.get_parameters;

k = 1;
for kk = 1:length(sData.imData.variables.trialIndices)
    if sData.imData.variables.odors(k,3)==1
        color_1 = odor_A;
    else
        color_1 = odor_B;
    end
    
    if sData.imData.variables.odors(k+1,3)==1
        color_2 = odor_A;
    else
        color_2 = odor_B;
    end


    x = [sData.imData.variables.trialIndices(kk,1),sData.imData.variables.trialIndices(kk,1)+31];
    a= patch([x(1) x(2) x(2) x(1)],[ylim_set(1),ylim_set(1),ylim_set(2),ylim_set(2)],'k');%'FaceColor',color_1)
    a.FaceColor = color_1;
    a.LineStyle = 'none';
    a.FaceAlpha = 0.55;
     
    x = [sData.imData.variables.trialIndices(kk,2)-parameters.ITIWidth,sData.imData.variables.trialIndices(kk,2)-parameters.ITIWidth+31];
    a= patch([x(1) x(2) x(2) x(1)],[ylim_set(1),ylim_set(1),ylim_set(2),ylim_set(2)],'k');%'FaceColor',color_1)
    a.FaceColor = color_2;
    a.LineStyle = 'none';
    a.FaceAlpha = 0.5;
%     patch('XData',x','YData',y','FaceColor',color_1)

%     x = [sData.imData.variables.trialIndices(kk,2)-parameters.ITIWidth,sData.imData.variables.trialIndices(kk,2)-parameters.ITIWidth+31];
%     patch('XData',x','YData',y','FaceColor',color_2)

    k = k+2;
end
xlim([ind_start,ind_end])

saveas(fig,fullfile(save_dir,'fig_1e.fig'),'fig')
saveas(fig,fullfile(save_dir,'fig_1e.pdf'),'pdf')
saveas(fig,fullfile(save_dir,'fig_1e.png'),'png')
