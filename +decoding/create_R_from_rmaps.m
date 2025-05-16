
function [R, trials, outcomes] = create_R_from_rmaps(mData)

%  trials   = ... %  Vector with first odor of each trial -  1 = odor-A , 2 = odor-B
%  outcomes = ...  % (Vector of trial outcomes -  1 = Hit, 2 = False alarm, 3 = Miss, 4 = Correct rejection

%  outcomes(outcomes == 1 | outcomes == 4) = 1;                            % Split into correct
%  outcomes(outcomes == 2 | outcomes == 3) = -1;                           % And error trials

sData = mData.sData;

samplingRate = 6.2;  % Example value, replace with your actual sampling rate
windowSize = samplingRate * 1;  % 1 second window

for i = 1:size(mData.deconv.rmapsAA,3)
    signal_A(i,:,:) = [mData.deconv.rmapsAA(:,1:38,i);...
                       mData.deconv.rmapsAB(:,1:38,i)];
    
    signal_B(i,:,:) = [mData.deconv.rmapsBB(:,1:38,i);...
                       mData.deconv.rmapsBA(:,1:38,i)];
end


AA_trials= [];
AB_trials= [];
BA_trials= [];
BB_trials= [];
k=1;
for i=1:length(sData.imData.variables.trialIndices)
    if sData.imData.variables.odors(k,3)==2 && sData.imData.variables.odors(k+1,3)==2
        AA_trials(end+1) = i;
    end
    if sData.imData.variables.odors(k,3)==2 && sData.imData.variables.odors(k+1,3)==1
        AB_trials(end+1) = i;
    end
    if sData.imData.variables.odors(k,3)==1 && sData.imData.variables.odors(k+1,3)==1
        BB_trials(end+1) = i;
    end
    if sData.imData.variables.odors(k,3)==1 && sData.imData.variables.odors(k+1,3)==2
        BA_trials(end+1) = i;
    end
    k=k+2;
end

A_trials = [AA_trials AB_trials];
B_trials = [BB_trials BA_trials];

% Equalize the number of trials:
% no_trials_each = min([length(A_trials), length(B_trials)]);
% 
% % Randomly sample trials:
% A_trials = randsample(A_trials, no_trials_each);
% B_trials = randsample(B_trials, no_trials_each);

trials = NaN(length(A_trials)+length(B_trials),1);
trials(A_trials)  = 1;
trials(B_trials)  = 2;

R = NaN(size(signal_A,1),38,length(trials));
% signal= signal+ randi(10,size(signal,1),size(signal,2),size(signal,3))*0.0000000000000001;
for i = 1:length(A_trials)
    R(:,1:38,A_trials(i)) = signal_A(:,i,:);
end

for i = 1:length(B_trials)
    R(:,1:38,B_trials(i)) = signal_B(:,i,:);
end


outcomes(sData.imData.variables.hits | sData.imData.variables.CR) = 1;
outcomes(sData.imData.variables.FA | sData.imData.variables.misses) = -1;
outcomes =outcomes(1:length(sData.imData.variables.trialIndices));

end


