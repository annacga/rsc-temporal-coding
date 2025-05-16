function [maxloc,indices] = find_firing_field(mean_firing_rate)

% FIND_FIRING_FIELD Identify the temporal field of activation from a mean firing rate vector.
%
% This function identifies the time interval ("firing field") where a neuron
% shows the strongest and most sustained activation, based on its mean
% firing rate across preferred trials.
%
% ------------------------
% METHOD OVERVIEW
% ------------------------
% - The input firing rate is low-pass filtered (<1 Hz) before this function is called.
% - A robust baseline is estimated using the **mode** of the mean firing rate
%   (approximated by the center of the most populated histogram bin).
% - A dynamic threshold is computed as:
%       threshold = mode + 0.5 × standard deviation
% - The function locates the peak of the signal that exceeds this threshold.
% - From the peak, it searches left and right to find the full activation field,
%   i.e., all consecutive time bins where the signal remains above threshold.
% - The field indices are sorted and returned.
% - If no valid field is found, outputs are returned as NaN.
% - Fields longer than 4 seconds are discarded outside this function.
%
% ➤ Interpretation: The identified indices represent a time window where
%   the neuron is most likely active across trials, reflecting its
%   temporal tuning or selectivity.
%
% ------------------------
% INPUTS
% ------------------------
%   mean_firing_rate  - Vector (1 × time) of mean firing rates over preferred trials.
%
% ------------------------
% OUTPUTS
% ------------------------
%   maxloc   - Index of peak firing activity within the field.
%   indices  - Vector of indices where activity exceeds the threshold
%              (surrounding the peak). NaN if no valid field is found.
%
% ------------------------
% TECHNICAL NOTES
% ------------------------
% - The mode is estimated via histogram binning (Sturges’ method).
% - The input signal should be pre-smoothed and deconvolved.
% - Assumes an effective sampling rate of ~6.2 Hz (from 31 Hz / 5).
%
% ------------------------
% SEE ALSO
% ------------------------
%   field_info.m

% Written by Anna Christina Garvert, 2023.

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
