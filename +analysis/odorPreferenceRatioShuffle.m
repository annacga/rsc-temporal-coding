function ratio = odorPreferenceRatioShuffle(rmaps,varargin)
% Compute the ratio of preference for each cell between the two landmark
% positions. If the first landmark is twice as big as the second, it will
% be given a score of -100%, indicating a 100% increase difference towards 
% where - means it is the first landmark. 

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