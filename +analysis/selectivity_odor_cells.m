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
% original signal was sampled with 31Hz but in rmaps 3 time points are
% always averaged
Fs = 31/3;
% lowpass filtered (< 1Hz)
Fpass = 1;

whichSignal = 'deconv';

for i = 1:length(data)
    for f = 1:length(data(i).sessionIDs)
        
        ClassifiedCells = mData(i,f).classification;
        
        [TimeAB, TimeA, TimeB] = classification.find_classification_indices(ClassifiedCells,1);
        [OdorAB, OdorA, OdorB] = classification.find_classification_indices(ClassifiedCells,2);
                
        %% decide to which sequence TimeAB cells belong
        delete_timeAB_idx = [];
        for m = 1:length(TimeAB)
            mean_rmapsA = nanmean([mData(i,f).(whichSignal).rmapsAA(:,31/3:63,TimeAB(m)); mData(i,f).(whichSignal).rmapsAB(:,31/3:63,TimeAB(m))]);
            mean_rmapsB = nanmean([mData(i,f).(whichSignal).rmapsBA(:,31/3:63,TimeAB(m)); mData(i,f).(whichSignal).rmapsBB(:,31/3:63,TimeAB(m))]);
            
            % find firing field f
            firing_field_A = analysis.find_firing_field(lowpass(mean_rmapsA,Fpass,Fs));
            firing_field_B = analysis.find_firing_field(lowpass(mean_rmapsB,Fpass,Fs));
            
            % find which sequence this should be added to
            if ~isempty(intersect(firing_field_A,firing_field_B))
                if mean_rmapsA(firing_field_A) > mean_rmapsB(firing_field_B)
                    TimeA = [TimeA; TimeAB(m)];
                else
                    TimeB = [TimeB; TimeAB(m)];
                end
                delete_timeAB_idx = m;
            end
        end
        
        TimeAB(delete_timeAB_idx)  = [];
        
        %% TimeAB cells with different fields in A and B are kept in both
        %  sequences.
        TimeA = [TimeA; TimeAB];
        TimeB = [TimeB; TimeAB];
        
        SI_A = NaN(length(TimeA),1);
        for m = 1:length(TimeA)
            mean_rmapsA = nanmean([mData(i,f).(whichSignal).rmapsAA(:,31/3:63,TimeA(m)); mData(i,f).(whichSignal).rmapsAB(:,31/3:63,TimeA(m))]);
            mean_rmapsB = nanmean([mData(i,f).(whichSignal).rmapsBA(:,31/3:63,TimeA(m)); mData(i,f).(whichSignal).rmapsBB(:,31/3:63,TimeA(m))]);
            
            firing_field_A = analysis.find_firing_field(lowpass(mean_rmapsA,Fpass,Fs));
            
            if ~isnan(firing_field_A)
                SI_A(m) =(mean_rmapsA(firing_field_A)-mean_rmapsB(firing_field_A))/(mean_rmapsA(firing_field_A)+mean_rmapsB(firing_field_A));
            end
            
        end
        
        SI_B = NaN(length(TimeB),1);
        for m = 1:length(TimeB)
            mean_rmapsA = nanmean([mData(i,f).(whichSignal).rmapsAA(:,31/3:63,TimeB(m)); mData(i,f).(whichSignal).rmapsAB(:,31/3:63,TimeB(m))]);
            mean_rmapsB = nanmean([mData(i,f).(whichSignal).rmapsBA(:,31/3:63,TimeB(m)); mData(i,f).(whichSignal).rmapsBB(:,31/3:63,TimeB(m))]);
            
            firing_field_B = analysis.find_firing_field(lowpass(mean_rmapsB,Fpass,Fs));
            if ~isnan(firing_field_B)
                SI_B(m) =(mean_rmapsB(firing_field_B)-mean_rmapsA(firing_field_B))/(mean_rmapsB(firing_field_B)+mean_rmapsA(firing_field_B));
            end
        end
        
        TimeA(SI_A<0|isnan(SI_A)) = [];
        TimeB(SI_B<0|isnan(SI_B)) = [];
        SI_A(SI_A<0|isnan(SI_A))   = [];
        SI_B(SI_B<0|isnan(SI_B))   = [];
        
        mData(i,f).TimeA.indices = TimeA;
        mData(i,f).TimeB.indices = TimeB;
        mData(i,f).TimeA.SI  = SI_A;
        mData(i,f).TimeB.SI  = SI_B;
        
        
       end
end
