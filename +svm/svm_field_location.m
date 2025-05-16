
% activity_data = [activity of single cell for odor A time points; 
%           activity of single cell for odor A time points]
clearvars -except mData data type indices_to_use
close all

for i = 1:length(data)
    save_dir_hyper = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/svm/',data(i).area,'/hyper_params');
    load(fullfile(save_dir_hyper, strcat('hyperparams_',type,'.mat')));
    BoxConstraint =mdl.HyperparameterOptimizationResults.XAtMinObjective.BoxConstraint;
    KernelScale   =mdl.HyperparameterOptimizationResults.XAtMinObjective.KernelScale;

    for f = 1:length(data(i).sessionIDs)
 
        save_dir = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/svm/',data(i).area, data(i).sessionIDs{f});
        if ~exist(save_dir); mkdir(save_dir); end

        % concatenate both rmaps AA and AB
        rmapsA = cat(1,mData(i,f).deconv.rmapsAA, mData(i,f).deconv.rmapsAB);
        rmapsB = cat(1,mData(i,f).deconv.rmapsBA, mData(i,f).deconv.rmapsBB);

        % create train data (first 2/3 of the trials) and test data (last 1/3) of
        % trials
        train_trials_A  = 1:round(2*size(rmapsA,1)/3);
        test_trials_A  = round(2*size(rmapsA,1)/3)+1:size(rmapsA,1);
   
        train_trials_B  = 1:round(2*size(rmapsB,1)/3);
        test_trials_B  = round(2*size(rmapsB,1)/3)+1:size(rmapsB,1);
      
        % Put the data into one matrix, and make a vector grp that labels the class
        % of each point. 1 indicates the green class, and –1 indicates the red class.

        % find A trials and B trials, make rmaps and average across all trials of one
        % type then average across all cell activities (A trials, B trials)

%         activity_odor_a = zscore(nanmean(rmapsA,2));
%         activity_odor_b = zscore(nanmean(rmapsB,2));
%         activity_data   = [activity_odor_a;activity_odor_b];
%         
        odor_a = ones(length(train_trials_A),1);
        odor_b = -ones(length(train_trials_B),1);
        class_train = [odor_a;odor_b];
         
        odor_a = ones(length(test_trials_A),1);
        odor_b = -ones(length(test_trials_B),1);
        class_test= [odor_a;odor_b];
        
        accuracy = [];
        

       cells = [mData(i,f).TimeA.indices;mData(i,f).TimeB.indices;...
            mData(i,f).OdorA.indices;mData(i,f).OdorB.indices];
        
       firing_fields = [mData(i,f).TimeA.firing_field;
                        mData(i,f).TimeB.firing_field
                        mData(i,f).OdorA.firing_field
                        mData(i,f).OdorB.firing_field];
        
        fields = {'TimeA','TimeB','OdorA','OdorB'};
        
        for r = 1:4
             mData(i,f).(fields{r}).accuracy = [];
        for p = 1:length(mData(i,f).(fields{r}).indices)
            field_indices = mData(i,f).(fields{r}).firing_field{p}-1:mData(i,f).(fields{r}).firing_field{p}+1;
            field_indices = field_indices(field_indices<=37);
            % =mData(i,f).(fields{r}).firing_field ;%
            
            field_indices(field_indices == 0)  = [];
            rmapsA_train = reshape(nanmean(rmapsA(train_trials_A ,field_indices,mData(i,f).(fields{r}).indices(p)),2),length(train_trials_A),1);
            rmapsA_test = reshape(nanmean(rmapsA(test_trials_A ,field_indices,mData(i,f).(fields{r}).indices(p)),2),length(test_trials_A),1);

            rmapsB_train = reshape(nanmean(rmapsB(train_trials_B ,field_indices,mData(i,f).(fields{r}).indices(p)),2),length(train_trials_B),1);
            rmapsB_test = reshape(nanmean(rmapsB(test_trials_B ,field_indices,mData(i,f).(fields{r}).indices(p)),2),length(test_trials_B),1);
        
            activity_odor_a = normalize(rmapsA_train,'range',[0 1]);
            activity_odor_b = normalize(rmapsB_train,'range',[0 1]);
            activity_data_train = [activity_odor_a;activity_odor_b];
            
            activity_odor_a = normalize(rmapsA_test,'range',[0 1]);
            activity_odor_b = normalize(rmapsB_test,'range',[0 1]);
            activity_data_test = [activity_odor_a;activity_odor_b];
            
            % first 2/3 trials per day used for training the decoder and all final 1/3 trials
            if ~(sum(isnan(activity_data_train)) == length(activity_data_train))
                % Put the data into one matrix, and make a vector grp that labels the class
                % of each point. 1 indicates the green class, and –1 indicates the red class.
                
                SVMModels = fitcsvm(activity_data_train,class_train',...%'Standardize',true,...
                    'KernelFunction','rbf','BoxConstraint',BoxConstraint, 'KernelScale',KernelScale);
                
                y = predict(SVMModels,activity_data_test);
                mData(i,f).(fields{r}).accuracy(p) = sum(class_test==y)/length(y);
            else
                mData(i,f).(fields{r}).accuracy(p) = NaN;
            end
            
            end
        end
%         save(fullfile(save_dir, strcat('accuracy_',type,'.mat')),'accuracy');
%         mData(i,f).(type).accuracy = accuracy;
    end
end
    
