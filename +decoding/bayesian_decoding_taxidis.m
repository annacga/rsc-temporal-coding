function [t_error,tt_accuracy,decodedbins,t_pred_all] = bayesian_decoding_taxidis(Rm,Rpred,traintrials,predtrials,bins,bout)
    
ttypes = length(bout);

lpred = length(predtrials);
ldc = size(Rpred,1);
ldb = length(bins);

dt = bins(2) - bins(1);   %0.5;%                                             % Distance of bin times
sigma = (dt*ldb)/2;                                                         % SD for gaussian (= half delay duration)
bins_vec = [-bins bins];                                                    % Double the bin time (make trial-A negative)

%% COMPUTE PROBABILITY OF TRIAL TYPE
Ptt = zeros(1,ttypes);
for tt = 1:ttypes                                                           % For each trial type
    Ptt(tt) = sum(traintrials == tt)/length(traintrials);                   % Compute ratio of training trials of that type             
end

%% REMOVE BINS WITH NO SPIKING IN EITHER TRIAL TYPE (UNDECODABLE)
bout = bout{1} .* bout{2};                                                  % bins with no spikes in either trial type
bout = logical([bout, bout]);                                               % Double the empty bin vector (to remove from both types)

Rm(:,bout) = [];                                                            % Remove from both trial types
Ptt = [Ptt(1)*ones(1,ldb), Ptt(2)*ones(1,ldb)];                             % Assign trial type probabilities to the whole bins vector
Ptt(bout) = [];                                                             % And type-probabilities

bins_vec(bout) = [];                                                        % Remove these bins
ldb2d = length(bins_vec);

%% DECODING
t_error = cell(1,lpred);
tt_acc = cell(1,lpred);
decodedbins = cell(1,lpred);

A = exp(-dt*nansum(Rm,1));                                                     % Compute exp component over all bins
    
% figure()
% imagesc(Rm)
% ylabel('Firing ratesSequence cells')
% xticks([38/2 3*38/2])
% xticklabels({'Delay periods after Odor A','Delay periods after Odor B'})
% set(gca,'FontName','Arial','FontSize',16)
t_pred_all=[];
for tr = 1:lpred                                                            % For each trial to decode
    Rpr = squeeze(Rpred(:,:,tr));                                           % keep its firing rates (cells x bins)
    
    t_error{tr} = nan(1,ldb);                                               % SET TO NAN SO THAT NON-DECODED BINS CAN BE TAKEN OUT
    tt_acc{tr} = nan(1,ldb);
    t_pred_all{tr}= nan(1,ldb);
    tprev = 0;
    
    for b = 1:ldb                                                           % for each timepoint of the trial
        if nansum(Rpr(:,b)) > 0 && ~any(bout == b)                             % If at least one cell spiked and the bin is not to be skipped
            Pred = zeros(ldc,ldb2d);
             for c = 1:ldc                                                   % for each cell
                 ni = dt*Rpr(c,b);                                           % Keep its 'spike number' in that bin
                 Pred(c,:) = dt*(Rm(c,:).^ni);                               % Compute component of posterior probability
             end
            
            
            Pred = prod(Pred,1);                                            % Product probability over all cells for all bins
            Pred = (Pred .* A).* Ptt;                                       % Bayesian probability for all bins
            Pred = Pred / nansum(Pred);                                        % Normalize to sum to 1 (not necessary)
            
            if tprev > 0                                                    % If this is not the first bin to be decoded in this trial
                K = exp(-(abs(bins_vec) - abs(bins_vec(tprev))).^2/(2*sigma^2)); % Compute distance gaussian probability
                K = K / sum(K);                                             % Normalize to sum to 1 (no necessary)
                Pred = Pred.* K;                                            % Mulitply with previous to restrict distance
              %  figure;plot(bins_vec,K,'o')
            end
            
            Pred(isnan(Pred)) = 0;
            if sum(Pred) == 0
                Pred = rand(size(Pred));
            end

            [~,t_pred] = nanmax(Pred);                                         % Find the peak location
            tprev = t_pred;                                                 % Store the decoded bin to use in restricting next bin
            
            t_pred = bins_vec(t_pred);                                      % Turn decoded bin to time bin

            if t_pred < 0                                                   % If it s negative
                t_pred = -t_pred;                                           % Turn to positive
                tt_pred = 1;                                                % And set to trial type 1
            else
                tt_pred = 2;                                                % Else type 2
            end

            t_error{tr}(b) = bins(b) - t_pred;                              % Store decoded time error
            tt_acc{tr}(b) = (tt_pred == predtrials(tr));     
            t_pred_all{tr}(b) = t_pred;  % And whether trial type was correct
            
        end
    end
    decodedbins{tr} = bins(~isnan(t_error{tr}));     
    % Keep bins that were decoded
    t_error{tr}(isnan(t_error{tr})) = [];                                   % Remove undecoded bins
    tt_acc{tr}(isnan(tt_acc{tr})) = [];
    t_pred_all{tr}(isnan(t_pred_all{tr})) =[];
end

decodedbins = cell2mat(decodedbins);                                        % Concatenate ALL bins from all trials
t_error = cell2mat(t_error);
tt_acc  = cell2mat(tt_acc);
t_pred_all = cell2mat(t_pred_all);

%% COMPUTE TRIAL-TYPE ACCURACY PER BIN
tt_accuracy = nan(1,unique(ldb));
for b = 1:unique(ldb)%ldb                                                               % For each bin
    k = (decodedbins == bins(b));                                           % Find all entries where this bin was decoded 
    tt_accuracy(b) = 100*sum(tt_acc(k))/sum(k);                             % Turn acccuracy into percentage over number times the bin was decoded
end

