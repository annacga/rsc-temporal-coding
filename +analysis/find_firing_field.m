function [maxloc,indices] = find_firing_field(mean_firing_rate)

% find indices where the mean firing rate is above threrhold baseline +1/2
% standard deviation 
% field sizes >4 s are discarded
% mode value: the weighted average fluorescence from all the pixels in the 
% ROI after removing overlapping components and neuropil contamination and prior to the ΔF/F transformation


% the mean firing rate over prefered trials is calculated and lowpass
% filtered (< 1Hz), its baseline was approximated by its mode value
% the time two points around the peak where the filtered mean signal drops
% below the threshold baseline +1/2 standard deviation are identified 
% the field size is given by the time interval between these two time
% points
% If the mean firign rate didnt drop below the value, the odor onset or
% delay offseet was used accordingly
% Field sizes >4 s were discarded

% field sizes should be considered as an approximation of the time interval 
% where the cell had the highest activation probability relative to the rest 
% of the trial, and as such its length represents the variability in 
% activation time for the cell.
% we increased the threshold
indices = NaN;
maxloc  = NaN;

[N,XEDGES,YEDGES] = histcounts(mean_firing_rate, 'BinMethod', 'sturges');% bin method can be adjusted

% Get the bin counts and bin edges
bin_counts = N;
bin_edges  = XEDGES;

% Find the bin with the highest count
[~, max_bin_index] = max(bin_counts);

% Calculate the mode as the center of the bin with the highest count
if max_bin_index < length(bin_edges)
    mode_value = (bin_edges(max_bin_index) + bin_edges(max_bin_index + 1)) / 2;
else
   mode_value = (bin_edges(max_bin_index) + bin_edges(max_bin_index + 1)) / 2;
end

%threshold                = min(mean_firing_rate)+2*std(mean_firing_rate);
threshold                = mode_value+1/2*std(mean_firing_rate);
% threshold                = mode_value+std(mean_firing_rate);

indices_above_threshold  = find(mean_firing_rate>threshold);
[~,peakIdx]              = max(mean_firing_rate(indices_above_threshold));
maxloc                   = indices_above_threshold(peakIdx);

% find field beginning
indices = maxloc;
ii      = maxloc;
if ii-1 > 0
    while ii-1 > 0 && (mean_firing_rate(ii-1) > threshold) 
        indices = [indices,ii-1];
        ii      = ii-1;
    end
end

% find field end
ii      = maxloc;
if ii+1 < length(mean_firing_rate)
    while ii+1 < length(mean_firing_rate) && (mean_firing_rate(ii+1) > threshold) 
        indices = [indices,ii+1];
        ii      = ii+1;
    end
end

indices = sort(indices);
% if length(indices)> 31/5*4 || isempty(indices)
if isempty(indices)
    indices = NaN;
    maxloc  = NaN;
end

% % find centroid
% if ~isnan(maxloc)
%     p = polyshape(indices,mean_firing_rate(indices));
%     centroidloc = centroid(p);
% end

% figure()
% plot(mean_firing_rate,'k','LineWidth',1.5)
% yline(threshold,'r','LineWidth',1.5)
% xticks([0:31/5:444])
% xticklabels({'0','1','2','3','4','5','6','7'})
% ylabel("Mean activity across trials")
% xlabel("Time (s)")
% set(gca,'FontName','Arial','FontSize',12)

end