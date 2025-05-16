function mData = sequence_ID(mData,data, varargin)

save_analysis = 0;
if nargin == 4
    load_data     = varargin{1};
    save_analysis = varargin{2};
elseif nargin == 3
    load_data     = varargin{1};
else
    load_data = 1:length(data)-1;
end

%% calculation of selectivity

% selectivity index
% SI = (Ri_f - Rj_f)/(Ri_f+Rj_f)
% Ri_f : cell mean firing rate at its firing field f over all type odor i-trials
% Rj_f : cells mean firing rate at its firing field f over opposite odor j-trials
% cells with negative SI were discarded from corresponding sequence
% if a cell had a field at the same time bins during both trial types, it was
% assigned to the sequency where its field rate was highest(positive SI)
% this condition was removed from analysis of multi field cells
% cells with different fields in A and B are kept in both sequences

% to find peak we use lowpass filtered signal
% original signal was sampled with 31Hz but in rmaps 10 time points are
% always averaged
Fs = 31/5;
% lowpass filtered (< 1Hz)
Fpass = 1;

whichSignal = 'deconv';
savedir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Fig_1/classification_';
for i = 1%:5 %load_data
    for f = 1:length(data(i).sessionIDs)
        
        ClassifiedCells = mData(i,f).classification;
        
        [TimeAB, TimeA, TimeB] = classification.find_classification_indices(ClassifiedCells,1);
        [OdorAB, OdorA, OdorB] = classification.find_classification_indices(ClassifiedCells,2);
        
        %% decide to which sequence TimeAB cells belong
        delete_timeAB_idx = [];
        for m = 1:length(TimeAB)

            mean_rmapsA = nanmean(ClassifiedCells{TimeAB(m),4}(:,1:38));
            mean_rmapsB = nanmean(ClassifiedCells{TimeAB(m),8}(:,1:38));
            
            % find firing field f
           
            [firing_field_A,indices_A] = analysis.find_firing_field(lowpass(mean_rmapsA,Fpass,Fs));
            [firing_field_B,indices_B] = analysis.find_firing_field(lowpass(mean_rmapsB,Fpass,Fs));
            
            
            % find which sequence this should be added to
            if ~isempty(intersect(firing_field_A,firing_field_B))
                if nanmean(mean_rmapsA(indices_A)) > nanmean(mean_rmapsB(indices_B))
                    TimeA = [TimeA; TimeAB(m)];
                else
                    TimeB = [TimeB; TimeAB(m)];
                end
                delete_timeAB_idx = [delete_timeAB_idx, m];
            end
        end
        
        TimeAB(delete_timeAB_idx)  = [];
        
        %% TimeAB cells with different fields in A and B are kept in both
        %  sequences.
        TimeA = [TimeA; TimeAB];
        TimeB = [TimeB; TimeAB];
        
        %% repeat the same for odor cells
        delete_odorAB_idx = [];
        for m = 1:length(OdorAB)
           
            mean_rmapsA = nanmean(ClassifiedCells{OdorAB(m),4}(:,1:38));
            mean_rmapsB = nanmean(ClassifiedCells{OdorAB(m),8}(:,1:38));
            % find firing field f
            [firing_field_A,indices_A] = analysis.find_firing_field(lowpass(mean_rmapsA,Fpass,Fs));
            [firing_field_B,indices_B] = analysis.find_firing_field(lowpass(mean_rmapsB,Fpass,Fs));
            
            % find which sequence this should be added to
            if ~isempty(intersect(firing_field_A,firing_field_B))
                if nanmean(mean_rmapsA(indices_A)) > nanmean(mean_rmapsB(indices_B))
                    OdorA = [OdorA; OdorAB(m)];
                else
                    OdorB = [OdorB; OdorAB(m)];
                end
                delete_odorAB_idx = [delete_odorAB_idx, m];
            end
        end
        
        OdorAB(delete_odorAB_idx)  = [];
        
        %% TimeAB cells with different fields in A and B are kept in both
        %  sequences.
        OdorA = [OdorA; OdorAB];
        OdorB = [OdorB; OdorAB];
        
        % sequence cells:
        
        %% calculate selectivity index for time cells
        SI_timeA = NaN(length(TimeA),1);
        for m = 1:length(TimeA)
       
            mean_rmapsA = nanmean(ClassifiedCells{TimeA(m),4}(:,1:38));
            mean_rmapsB = nanmean(ClassifiedCells{TimeA(m),8}(:,1:38));
            
            firing_field_A = analysis.find_firing_field(lowpass(mean_rmapsA,Fpass,Fs));
            
            if ~isnan(firing_field_A)
                SI_timeA(m) =(mean_rmapsA(firing_field_A)-mean_rmapsB(firing_field_A))/(mean_rmapsA(firing_field_A)+mean_rmapsB(firing_field_A));
            end
            
        end
        
        SI_timeB = NaN(length(TimeB),1);
        for m = 1:length(TimeB)
 
            mean_rmapsA = nanmean(ClassifiedCells{TimeB(m),4}(:,1:38));
            mean_rmapsB = nanmean(ClassifiedCells{TimeB(m),8}(:,1:38));
            
            firing_field_B = analysis.find_firing_field(lowpass(mean_rmapsB,Fpass,Fs));
            if ~isnan(firing_field_B)
                SI_timeB(m) =(mean_rmapsB(firing_field_B)-mean_rmapsA(firing_field_B))/(mean_rmapsB(firing_field_B)+mean_rmapsA(firing_field_B));
            end
        end
        
        %% calculate selectivity index for odor cells
        SI_odorA = NaN(length(OdorA),1);
        for m = 1:length(OdorA)

            mean_rmapsA = nanmean(ClassifiedCells{OdorA(m),4}(:,1:38));
            mean_rmapsB = nanmean(ClassifiedCells{OdorA(m),8}(:,1:38));
            
            firing_field_A = analysis.find_firing_field(lowpass(mean_rmapsA,Fpass,Fs));
            
            if ~isnan(firing_field_A)
                SI_odorA(m) =(mean_rmapsA(firing_field_A)-mean_rmapsB(firing_field_A))/(mean_rmapsA(firing_field_A)+mean_rmapsB(firing_field_A));
            end
            
        end
        
        SI_odorB = NaN(length(OdorB),1);
        for m = 1:length(OdorB)
    
            mean_rmapsA = nanmean(ClassifiedCells{OdorB(m),4}(:,1:38));
            mean_rmapsB = nanmean(ClassifiedCells{OdorB(m),8}(:,1:38));
       
            firing_field_B = analysis.find_firing_field(lowpass(mean_rmapsB,Fpass,Fs));
            if ~isnan(firing_field_B)
                SI_odorB(m) =(mean_rmapsB(firing_field_B)-mean_rmapsA(firing_field_B))/(mean_rmapsB(firing_field_B)+mean_rmapsA(firing_field_B));
            end
        end
        
        TimeA(SI_timeA<0|isnan(SI_timeA)) = [];
        TimeB(SI_timeB<0|isnan(SI_timeB)) = [];
        SI_timeA(SI_timeA<0|isnan(SI_timeA))   = [];
        SI_timeB(SI_timeB<0|isnan(SI_timeB))   = [];
        
        mData(i,f).TimeA.indices = TimeA;
        mData(i,f).TimeB.indices = TimeB;
        mData(i,f).TimeA.SI  = SI_timeA;
        mData(i,f).TimeB.SI  = SI_timeB;
        
        OdorA(SI_odorA<0|isnan(SI_odorA)) = [];
        OdorB(SI_odorB<0|isnan(SI_odorB)) = [];
        SI_odorA(SI_odorA<0|isnan(SI_odorA)) = [];
        SI_odorB(SI_odorB<0|isnan(SI_odorB)) = [];
        
        mData(i,f).OdorA.indices = OdorA;
        mData(i,f).OdorB.indices = OdorB;
        mData(i,f).OdorA.SI  = SI_odorA;
        mData(i,f).OdorB.SI  = SI_odorB;
        
        
        if save_analysis
            
            save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'OdorA.mat'),'OdorA')
            save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'OdorB.mat'),'OdorB')
            
            save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'TimeA.mat'),'TimeA')
            save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'TimeB.mat'),'TimeB')
            
            save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'SI_odorA.mat'),'SI_odorA')
            save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'SI_odorB.mat'),'SI_odorB')
            
            save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'SI_timeA.mat'),'SI_timeA')
            save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'SI_timeB.mat'),'SI_timeB')
        end
    end
end


