function [maxloc,indices] = find_firing_field(mean_firing_rate)

% Identify the temporal field of activation from a mean firing rate vector.
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
% - The mode is estimated via histogram binning (Sturges’ method).
% - The input signal should be pre-smoothed and deconvolved.
% - Assumes an effective sampling rate of ~6.2 Hz (from 31 Hz / 5).
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
%
% Written by Anna Christina Garvert, 2023.

% Default outputs
indices = NaN;
maxloc  = NaN;

% Estimate the mode via histogram binning (Sturges' rule)
[N, bin_edges] = histcounts(mean_firing_rate, 'BinMethod', 'sturges');

% Identify the bin with the highest count
[~, max_bin_index] = max(N);

% Compute mode as the center of the most frequent bin
if max_bin_index < length(bin_edges)
    mode_value = (bin_edges(max_bin_index) + bin_edges(max_bin_index + 1)) / 2;
else
    % Edge case: if max_bin_index is last bin, still take center
    mode_value = (bin_edges(max_bin_index) + bin_edges(max_bin_index + 1)) / 2;
end

% Define threshold as mode + 0.5 * std (tunable heuristic)
threshold = mode_value + 0.5 * std(mean_firing_rate);

% Find all indices above threshold
indices_above_threshold = find(mean_firing_rate > threshold);

% If there are no such indices, return
if isempty(indices_above_threshold)
    return
end

% Find index of maximum firing within thresholded region
[~, peakIdx] = max(mean_firing_rate(indices_above_threshold));
maxloc       = indices_above_threshold(peakIdx);

% Initialize indices with peak location
indices = maxloc;

% Expand field to the left of peak
ii = maxloc;
while ii > 1 && mean_firing_rate(ii - 1) > threshold
    ii = ii - 1;
    indices = [indices, ii];
end

% Expand field to the right of peak
ii = maxloc;
while ii < length(mean_firing_rate) && mean_firing_rate(ii + 1) > threshold
    ii = ii + 1;
    indices = [indices, ii];
end

% Sort indices to maintain time order
indices = sort(indices);

% If no valid field (e.g., if somehow empty after logic), return NaN
if isempty(indices)
    indices = NaN;
    maxloc  = NaN;
end

% Optional plot (for debugging or visualization)
%{
figure()
plot(mean_firing_rate, 'k', 'LineWidth', 1.5)
yline(threshold, 'r--', 'LineWidth', 1.2)
xticks(0:31/5:444)
xticklabels({'0','1','2','3','4','5','6','7'})
ylabel('Mean activity across trials')
xlabel('Time (s)')
set(gca, 'FontName', 'Arial', 'FontSize', 12)
%}

end
