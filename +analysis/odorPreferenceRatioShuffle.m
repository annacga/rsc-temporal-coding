function ratio = odorPreferenceRatioShuffle(rmaps,varargin)

% Compute shuffled odor preference ratios as a control.
%
% This function computes a null distribution of odor preference ratios
% using circularly shuffled trial-averaged response maps (`rmaps`). It serves
% as a control to estimate whether observed odor selectivity is statistically
% meaningful by breaking the temporal structure of the data.
%
% ------------------------
% METHOD OVERVIEW
% ------------------------
% For each neuron:
%   - The response map (trials × time) is randomly circularly shifted within each trial.
%   - The shuffled rMap is averaged across trials (per shuffle iteration).
%   - Mean activity is computed within two predefined time windows corresponding to
%     different odors (Odor A and Odor B).
%   - A preference ratio is computed for each shuffle:
%         ratio = ((max_response / min_response) - 1) × 100
%     ➤ If the first odor has the higher response, the value is made negative.
%         → -100% = 2× stronger for Odor A
%         → +100% = 2× stronger for Odor B
%         → 0%    = no preference
%
% This process is repeated 1000 times per cell to build a distribution of
% preference values under the null hypothesis of no temporal tuning.
%
% ------------------------
% INPUTS
% ------------------------
%   rmaps       - 3D array (trial × time × cell) of temporal response maps.
%
%   varargin    - (Optional) struct with parameters:
%                   • first_landmark_bins: time indices for Odor A (default: 1:7)
%                   • second_landmark_bins: time indices for Odor B (default: 38:44)
%
% ------------------------
% OUTPUT
% ------------------------
%   ratio       - [1000 × nCells] matrix of shuffled preference ratios.
%                 Each column contains the shuffled distribution for one neuron.
%                 Negative values = preference for Odor A
%                 Positive values = preference for Odor B
%
% ------------------------
% NOTES
% ------------------------
% - Circular shuffling preserves within-trial firing structure but destroys alignment
%   to real-time events, providing a strong null control.
% - This function is typically used in combination with the true preference
%   (from `odorPreferenceRatio`) to compute p-values or z-scores.
%
% Authored by Anna Christina Garvert


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
%     avg_tuning = normalize(nanmean(rmaps(:,:,c)),'range',[0,1]);
    rmap = rmaps(:,:,c);
    
      % Shuffle 1000 times
    shuffled_avg = zeros(1000,size(rmap,2));
    for i = 1:1000

        % Init zeroed matrix
        shuffled_rmap = zeros(size(rmap,1),size(rmap,2));

        % Shuffle for each lap
        for l = 1:size(rmap,1)
           shuffled_rmap(l,:) = circshift(rmap(l,:),randi(size(rmap,2))); 
        end

        shuffled_avg(i,:) = nanmean(shuffled_rmap);            

        first_response = nanmean(shuffled_avg(i,params.first_landmark_bins));
        second_response = nanmean(shuffled_avg(i,params.second_landmark_bins));
        
        % Find biggest and smallest
        [biggest_response,biggest_ind] = max([first_response,second_response]);
        smallest_response = min([first_response,second_response]);
        
        ratio(i,c) = ((biggest_response/smallest_response)-1) * 100;
        
         % If the first peak is the biggest, then set ratio to negative.

        if biggest_ind == 1
            ratio(i,c) = - ratio(i,c);
        end
        
    end

%     pval(c) =  length(find(abs(amplitude_change(c)) < abs(ratio(:,c))))/1000;

end

end
