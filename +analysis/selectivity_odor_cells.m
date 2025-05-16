%% SELECTIVITY INDEX CALCULATION FOR ODOR-TIMING TRIALS
%
% This script computes a Selectivity Index (SI) for each neuron based on
% its firing rate during its preferred field across different trial types
% (Odor A vs. Odor B). It determines whether a neuron exhibits a clear
% preference for one odor, and assigns it to the corresponding sequence.
%
% ------------------------
% SELECTIVITY INDEX FORMULA
% ------------------------
%   SI = (R_i(f) - R_j(f)) / (R_i(f) + R_j(f))
%
%   Where:
%     • R_i(f): mean firing rate during odor i trials at the cell’s field f
%     • R_j(f): mean firing rate during odor j trials at the same field f
%
%   Interpretation:
%     • SI > 0 → cell prefers odor i
%     • SI < 0 → cell prefers odor j (discarded)
%     • SI = 0 → equal activation
%
% ------------------------
% CLASSIFICATION LOGIC
% ------------------------
% Cells are initially classified as:
%   • TimeA   → Odor A trials only
%   • TimeB   → Odor B trials only
%   • TimeAB  → Responsive in both conditions
%
% For TimeAB cells:
%   • If the field overlaps across odors, assign to the condition with the higher field rate.
%   • If distinct fields exist in both, keep in both groups.
%
% Only cells with SI > 0 are retained in each group.
% Cells with NaN or SI < 0 are removed.
%
% ------------------------
% TEMPORAL SIGNAL DETAILS
% ------------------------
%   • Original sampling rate: 31 Hz
%   • rMaps are temporally smoothed: 3 time bins averaged → Effective Fs = 31 / 3 Hz
%   • Low-pass filter applied: cutoff < 1 Hz
%
% ------------------------
% INPUTS
% ------------------------
%   mData        - Struct with response maps (rmaps) and classification labels.
%   data         - Struct containing session and trial info.
%
% ------------------------
% PARAMETERS
%   whichSignal  - Field in mData to use (default: 'deconv')
%   Fs           - Effective sampling rate (Hz)
%   Fpass        - Low-pass filter cutoff (Hz)
%
% ------------------------
% OUTPUTS (UPDATED IN mData)
% ------------------------
%   mData(i,f).TimeA.indices  - Cell indices assigned to Odor A sequence
%   mData(i,f).TimeB.indices  - Cell indices assigned to Odor B sequence
%   mData(i,f).TimeA.SI       - Corresponding Selectivity Indices (SI_A)
%   mData(i,f).TimeB.SI       - Corresponding Selectivity Indices (SI_B)
%
% ------------------------
% DEPENDENCIES
% ------------------------
%   • classification.find_classification_indices
%   • analysis.find_firing_field
%   • lowpass (Signal Processing Toolbox)
%
% ------------------------
% NOTES
% ------------------------
% - This method helps identify neurons that reliably fire at specific times
%   depending on odor identity.
% - Multi-field neurons (with distinct fields in both odors) are retained
%   in both sequences.
%% SELECTIVITY INDEX CALCULATION FOR ODOR-TIMING TRIALS
%
% This script computes a Selectivity Index (SI) for each neuron based on
% its firing rate during its preferred field across different trial types
% (Odor A vs. Odor B). It determines whether a neuron exhibits a clear
% preference for one odor, and assigns it to the corresponding sequence.
%
% ------------------------
% SELECTIVITY INDEX FORMULA
% ------------------------
%   SI = (R_i(f) - R_j(f)) / (R_i(f) + R_j(f))
%
%   Where:
%     • R_i(f): mean firing rate during odor i trials at the cell’s field f
%     • R_j(f): mean firing rate during odor j trials at the same field f
%
%   Interpretation:
%     • SI > 0 → cell prefers odor i
%     • SI < 0 → cell prefers odor j (discarded)
%     • SI = 0 → equal activation
%
% ------------------------
% CLASSIFICATION LOGIC
% ------------------------
% Cells are initially classified as:
%   • TimeA   → Odor A trials only
%   • TimeB   → Odor B trials only
%   • TimeAB  → Responsive in both conditions
%
% For TimeAB cells:
%   • If the field overlaps across odors, assign to the condition with the higher field rate.
%   • If distinct fields exist in both, keep in both groups.
%
% Only cells with SI > 0 are retained in each group.
% Cells with NaN or SI < 0 are removed.
%
% ------------------------
% TEMPORAL SIGNAL DETAILS
% ------------------------
%   • Original sampling rate: 31 Hz
%   • rMaps are temporally smoothed: 3 time bins averaged → Effective Fs = 31 / 3 Hz
%   • Low-pass filter applied: cutoff < 1 Hz
%
% ------------------------
% INPUTS
% ------------------------
%   mData        - Struct with response maps (rmaps) and classification labels.
%   data         - Struct containing session and trial info.
%
% ------------------------
% PARAMETERS
%   whichSignal  - Field in mData to use (default: 'deconv')
%   Fs           - Effective sampling rate (Hz)
%   Fpass        - Low-pass filter cutoff (Hz)
%
% ------------------------
% OUTPUTS (UPDATED IN mData)
% ------------------------
%   mData(i,f).TimeA.indices  - Cell indices assigned to Odor A sequence
%   mData(i,f).TimeB.indices  - Cell indices assigned to Odor B sequence
%   mData(i,f).TimeA.SI       - Corresponding Selectivity Indices (SI_A)
%   mData(i,f).TimeB.SI       - Corresponding Selectivity Indices (SI_B)
%
% ------------------------
% DEPENDENCIES
% ------------------------
%   • classification.find_classification_indices
%   • analysis.find_firing_field
%   • lowpass (Signal Processing Toolbox)
%
% ------------------------
% NOTES
% ------------------------
% - This method helps identify neurons that reliably fire at specific times
%   depending on odor identity.
% - Multi-field neurons (with distinct fields in both odors) are retained
%   in both sequences.
%
%
% Authored Anna Christina Garvert, 2023 

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
