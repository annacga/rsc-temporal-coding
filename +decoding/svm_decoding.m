
function d_data = svm_decoding(mData)
    rng(1);  % For reproducibility

    % Load all firing rates ("R" - [cells x bins x trials]) , and trial info ("Trials & trials") and sequence-cells ("Mcells")
    [R, trials, outcomes] = decoding.create_R_from_rmaps(mData);

    % Process outcomes to classify trials into correct (1) or incorrect (-1)
    outcomes(outcomes == 1 | outcomes == 4) = 1;  % Correct trials
    outcomes(outcomes == 2 | outcomes == 3) = -1; % Error trials

    % Concatenate sequence-cells from both trial types
    TimeA = mData.TimeA.indices;
    TimeB = mData.TimeB.indices;
    OdorA = mData.OdorA.indices;
    OdorB = mData.OdorB.indices;
    dcells = [OdorA; OdorB;TimeA;TimeB];

    % Select relevant bins
    dbins = 1:38;
    numBins = length(dbins); 
    accuracies = zeros(numBins, 1);  % Preallocate storage for bin-specific accuracies

    % Loop over each bin
    for b = 1:numBins
        bin = dbins(b);
        %Rtemp = R(dcells, bin, :);  % Extract data for the current bin
        Rtemp = R(dcells, bin, :);  % Extract data for the current bin

        % Split trials into training and prediction sets
        Ntr = length(trials);
        numFolds = 5;
        binAccuracies = zeros(1, 1);  % Preallocate accuracy storage for folds
        k =1;
%         for k = 1:numFolds
            idx_pred = 1:3:length(trials);
            predtrials = idx_pred;
            traintrials = setdiff([1:length(trials)]', predtrials);
            traintrials = traintrials(outcomes(traintrials)==1);
            % Equalize the number of trials between A and B
            no_trials_each = min([length(find(trials(traintrials) == 1)), length(find(trials(traintrials) == 2))]);
            A_trials = randsample(find(trials(traintrials) == 1), no_trials_each);
            B_trials = randsample(find(trials(traintrials) == 2), no_trials_each);

            traintrials = sort([A_trials; B_trials]);

            % Get the training and prediction data
            Rtrain = Rtemp(:, :, traintrials);  
            Rpred = Rtemp(:, :, predtrials);

            % Flatten the data for SVM input
            X_train = reshape(Rtrain, [], size(Rtrain, 3))';  % [trials x features]
            Y_train = trials(traintrials)';  % [trials x 1]
            X_test = reshape(Rpred, [], size(Rpred, 3))';  % [trials x features]
            Y_test = trials(predtrials)';  % [trials x 1]
            
            % Remove rows with NaN values
            nan_idx_train = all(isnan(X_train), 2);
            X_train = X_train(~nan_idx_train, :);
            Y_train = Y_train(~nan_idx_train);

            nan_idx_train = all(isnan(X_train), 1);
            X_train = X_train(:, ~nan_idx_train);
            X_test = X_test(:,~nan_idx_train);
            % Train the SVM model
            SVMModel = fitcsvm(X_train, Y_train, 'KernelFunction', 'linear', 'Standardize', true, 'ClassNames', [1, 2]);

            % Test the SVM model
            [predictions, scores] = predict(SVMModel, X_test);

            % Calculate accuracy for the current fold
            accuracy = sum(predictions == Y_test') / length(Y_test);
            binAccuracies(k) = accuracy;
%         end

        % Calculate mean accuracy for this bin
      %  accuracies(b) = mean(binAccuracies);
         accuracies(b) = binAccuracies;
        
    end

    % Store results
    d_data.accuracies = accuracies;  % Accuracy for each bin

    % Optional: display the results
    disp('Bin-specific accuracies:');
    disp(d_data.accuracies);
end