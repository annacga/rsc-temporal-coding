
% activity_data = [activity of single cell for odor A time points; 
%           activity of single cell for odor A time points]
 clearvars -except mData data type indices_to_use
close all

for i = 1:length(data)
    save_dir_hyper = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/svm/',data(i).area,'/hyper_params');
    load(fullfile(save_dir_hyper, strcat('hyperparams_',type,'.mat')));
    BoxConstraint = mdl.HyperparameterOptimizationResults.XAtMinObjective.BoxConstraint;
    KernelScale   = mdl.HyperparameterOptimizationResults.XAtMinObjective.KernelScale;

    for f = 1:length(data(i).sessionIDs)
 
        save_dir = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/svm/',data(i).area, data(i).sessionIDs{f});
        if ~exist(save_dir); mkdir(save_dir); end

        % concatenate both rmaps AA and AB
        rmapsA = cat(1,mData(i,f).deconv.rmapsAA, mData(i,f).deconv.rmapsAB);
        rmapsB = cat(1,mData(i,f).deconv.rmapsBA, mData(i,f).deconv.rmapsBB);

        % create train data (first 2/3 of the trials) and test data (last 1/3) of
        % trials
        train_trials  = 1:round(2*size(rmapsA,1)/3);
        test_trials  = round(2*size(rmapsA,1)/3)+1:size(rmapsA,1);
        rmapsA_train = reshape(nanmean(rmapsA(train_trials ,indices_to_use,:),2),length(train_trials),size(rmapsA,3));
        rmapsA_test = reshape(nanmean(rmapsA(test_trials ,indices_to_use,:),2),length(test_trials),size(rmapsA,3));

        train_trials  = 1:round(2*size(rmapsB,1)/3);
        test_trials  = round(2*size(rmapsB,1)/3)+1:size(rmapsB,1);
        rmapsB_train = reshape(nanmean(rmapsB(train_trials ,indices_to_use,:),2),length(train_trials) ,size(rmapsB,3));
        rmapsB_test = reshape(nanmean(rmapsB(test_trials ,indices_to_use,:),2),length(test_trials),size(rmapsB,3));

        odor_a = ones(size(rmapsA,1),1);
        odor_b = -ones(size(rmapsB,1),1);
        class = [odor_a;odor_b];   

        % Put the data into one matrix, and make a vector grp that labels the class
        % of each point. 1 indicates the green class, and –1 indicates the red class.

        % find A trials and B trials, make rmaps and average across all trials of one
        % type then average across all cell activities (A trials, B trials)

        activity_odor_a = zscore(nanmean(rmapsA,2));
        activity_odor_b = zscore(nanmean(rmapsB,2));
        activity_data   = [activity_odor_a;activity_odor_b];
        c = cvpartition(length(activity_data),'KFold',10);
        
        odor_a = ones(size(rmapsA_train,1),1);
        odor_b = -ones(size(rmapsB_train,1),1);
        class_train = [odor_a;odor_b];
        
        odor_a = ones(size(rmapsA_test,1),1);
        odor_b = -ones(size(rmapsB_test,1),1);
        class_test= [odor_a;odor_b];
        accuracy = [];
        
        for p = 1:size(rmapsA_train,2)
            
            activity_odor_a = normalize(rmapsA_train(:,p),'range',[0 1]);
            activity_odor_b = normalize(rmapsB_train(:,p),'range',[0 1]);
            activity_data_train = [activity_odor_a;activity_odor_b];
            
            activity_odor_a = normalize(rmapsA_test(:,p),'range',[0 1]);
            activity_odor_b = normalize(rmapsB_test(:,p),'range',[0 1]);
            activity_data_test = [activity_odor_a;activity_odor_b];
            
            % first 2/3 trials per day used for training the decoder and all final 1/3 trials
            if ~(sum(isnan(activity_data_train)) == length(activity_data_train))
                % Put the data into one matrix, and make a vector grp that labels the class
                % of each point. 1 indicates the green class, and –1 indicates the red class.
                
                SVMModels = fitcsvm(activity_data_train,class_train',...%'Standardize',true,...
                    'KernelFunction','rbf','BoxConstraint',BoxConstraint, 'KernelScale',KernelScale);
                
                y = predict(SVMModels,activity_data_test);
                accuracy(p) = sum(class_test==y)/length(y);
            else
                accuracy(p) = NaN;
            end
            
        end
%         save(fullfile(save_dir, strcat('accuracy_',type,'.mat')),'accuracy');
        mData(i,f).(type).accuracy = accuracy;
    end
end
    
