function ratio = odorPreferenceRatio(rmaps,varargin)

% This function quantifies the relative preference of each neuron for two
% odor-associated time periods (landmarks) within trial-averaged temporal
% response maps (`rmaps`). The output reflects how much stronger the
% response is to one odor versus the other.
%
% ------------------------
% METHOD OVERVIEW
% ------------------------
% - For each neuron, the trial-averaged temporal activity is computed from its rMap.
% - The response is normalized to the [0, 1] range (min-max normalization).
% - Two time windows ("landmarks") are defined, each corresponding to a distinct odor.
%     → First landmark (default: bins 1–7)  → e.g., Odor A period
%     → Second landmark (default: bins 38–44) → e.g., Odor B period
% - The mean activity within each odor period is computed.
% - The preference ratio is defined as:
%       ratio = ((max_response / min_response) - 1) × 100
% - If the **first** odor has the stronger response, the ratio is made negative.
%   ➤ For example:
%       -100% → 2× stronger for Odor A
%       +100% → 2× stronger for Odor B
%       0%    → Equal responses
% - Extremely large or infinite ratios are discarded (set to NaN).
%
% ------------------------
% INPUTS
% ------------------------
%   rmaps       - 3D array (time × bin × cell) of temporal response maps.
%
%   varargin    - (Optional) struct with parameters:
%                   • first_landmark_bins: indices for Odor A period (default: 1:7)
%                   • second_landmark_bins: indices for Odor B period (default: 38:44)
%
% ------------------------
% OUTPUT
% ------------------------
%   ratio       - [1 × nCells] vector of preference ratios (in percent).
%                 Negative values indicate preference for the first odor,
%                 positive for the second. NaN if invalid (e.g., divide-by-zero).
%
% ------------------------
% NOTES
% ------------------------
% - The function normalizes each cell’s mean temporal profile independently.
% - Used to quantify odor tuning asymmetry between early and late trial epochs.
%
% Authored by Anna Christina Garvert, 2023


if ~isempty(varargin)
    params = varargin{1};
else
    params.first_landmark_bins = 1:7;
    params.second_landmark_bins = 38:44;
end

% Compute the ratio between the two, so basically dividing
% first and second landmark amplitude
ratio = [];


for c = 1:size(rmaps,3)
    
    % Create position tuning map for the cell and normalize it
    avg_tuning = normalize(nanmean(rmaps(:,:,c)),'range',[0,1]);

    % Find the max position around 50 cm +/- 15 cm and at 110 +/- 15 cm.
%     [~,first_peak] = max(avg_tuning(params.first_landmark_bins));
%     [~,second_peak] = max(avg_tuning(params.second_landmark_bins));

    % Set correct position
%     first_peak = first_peak + params.first_landmark_bins(1);
%     second_peak = second_peak + params.second_landmark_bins(1);

    % Find the average response around the two peaks in a 10 cm window
    first_response = nanmean(avg_tuning(params.first_landmark_bins));
    second_response = nanmean(avg_tuning(params.second_landmark_bins));

    % Find biggest and smallest
    [biggest_response,biggest_ind] = max([first_response,second_response]);
    smallest_response = min([first_response,second_response]);

    ratio(c) = ((biggest_response/smallest_response)-1) * 100;
    
    % If the first peak is the biggest, then set ratio to negative.
    if biggest_ind == 1
        ratio(c) = - ratio(c);
    end
    
    % this removes strong outliers, these are falsifying actual
    % distribution and are a result of the shuffling method to detect
    % landmark cells
    if isinf(ratio(c))||ratio(c)> 1000 
        ratio(c) =NaN;end
       
end

end
