
% load FOV
folderPath = '/Volumes/Seagate Backup Plus Drive/PROCESSED/2019_08_22/20190822_11_18_36_m3069-20190822-/two_photon_images_reg';
fileList= dir(fullfile(folderPath, '*.tif'));
      
nParts = length(fileList);
stacks = cell(1, nParts);
for i = 1:nParts
%         msg = sprintf('Please wait... Loading calcium images (part %d/%d, ch %d/%d)...', i, nParts, ch, nChannels);
%         stacks{i} = load.tiffs2mat(imFilePath{i}, true, msg, 1, -1);
        stacks{1,i} = load.tiffs2mat(fullfile(folderPath,fileList(i).name));
end
            
for i = 1:nParts
    stacks_subsampled{1,i} = stacks{1,i}(:,:,1:2:end);
end
clear stacks
imgTseries = cat(3, stacks_subsampled{1,:});
imgAvg = uint8(mean(imgTseries, 3));
imgMax = max(imgTseries, [], 3);

rois =  mData(1,9).sData.imData.roiSignals.rois;

f = figure('visible', 'on', 'Position', [1,1,size(imgAvg)]);
ax = axes('Parent', f, 'Position', [0,0,1,1]);
imshow(imgAvg,[10 30], 'Parent', ax, 'InitialMagnification', 'fit'); hold on;
hrois = plotbox.drawRoiOutlines(fig.Children, rois, false);
set(hrois(mData(1,9).OdorA.indices), 'LineWidth', 2, 'Color', [142 215 150]./255)
set(hrois(mData(1,9).OdorB.indices), 'LineWidth', 2, 'Color', [55 170 235]./255)
set(hrois(mData(1,9).TimeA.indices), 'LineWidth', 2, 'Color', [78 149 151]./255)
set(hrois(mData(1,9).TimeB.indices), 'LineWidth', 2, 'Color', [22 66 113]./255)

saveas(f,fullfile(save_dir,'fig_1j.fig'),'fig')
saveas(f,fullfile(save_dir,'fig_1j.pdf'),'pdf')
saveas(f,fullfile(save_dir,'fig_1j.png'),'png')


