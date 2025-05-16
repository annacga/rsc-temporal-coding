function mData = field_info(mData,data, varargin)

% Calculate and save temporal field characteristics of single neurons.
%
% This function analyzes spatial-temporal response maps (rMaps) to extract
% temporal field properties of individual neurons, including:
%   - Field size (duration of activation)
%   - Field location (peak response time)
%   - Activation probability (percentage of trials with activation)
%   - Peak time variance (variability in response timing)
%
% These metrics are computed separately for each trial segment:
% TimeA, TimeB, OdorA, and OdorB — using the deconvolved response signal (by default).
%
% ------------------------
% FIELD WIDTH ESTIMATION
% ------------------------
% - Compute the mean firing rate across preferred trials.
% - Apply low-pass filtering (<1 Hz) to smooth the signal.
% - Estimate the baseline using the **mode** of the filtered signal.
% - Identify two time points around the peak where the signal drops
%   below: baseline + 0.5 × standard deviation.
% - Define the firing field width as the interval between these points.
% - If the threshold is not crossed, fallback to odor onset or delay offset.
% - Discard any field longer than 4 seconds.
%
% ➤ Interpretation: The field size approximates the time window in which the
%   neuron has the highest probability of firing. It reflects the variability
%   in activation timing across trials.
%
% ------------------------
% FIELD LOCATION ESTIMATION
% ------------------------
% - Identify the time bin where the mean firing rate is maximal across preferred trials.
% - This is stored as the field’s peak location (field index).
%
% ------------------------
% TECHNICAL NOTES
% ------------------------
% - Original sampling rate: 31 Hz
% - In rMaps, three time points are averaged together
%   → Effective sampling rate: **31 / 5 Hz**
%
% ------------------------
% DEPENDENCIES
% ------------------------
% - Run `analysis.selectivity` beforehand to determine trial preferences.
%
% INPUTS:
%   mData         - Struct array containing session data and rMaps.
%   data          - Metadata struct with:
%                     • sessionIDs: cell array of session identifiers
%                     • area: string specifying the brain region
%
%   varargin      - Optional:
%                     1) load_data: indices of sessions to process
%                     2) save_analysis: binary flag (0 or 1) to control saving
%
% OUTPUTS:
%   mData         - Updated with the following fields for each condition:
%                     • field_size
%                     • field_location
%                     • activation_probability
%                     • peak_time_variance
%
% SAVING:
%   If `save_analysis` is true, the extracted metrics will be saved per session
%   under:
%     /Fig_1/field_info_modes/[area]/[sessionID]/
%
% Written by Anna Christina Garvert, 2023.


save_analysis = 0;
if nargin == 3
    load_data     = varargin{1};
    save_analysis = varargin{2};
elseif nargin == 2
    load_data     = varargin{1};
else
    load_data = 1:length(data)-1;
end

Fs = 31/5;
% lowpass filtered (< 1Hz)
Fpass = 1;
delay = 1:44; whichSignal = 'deconv';

savedir = '/Fig_1/field_info_modes';

for i = load_data
    for f = 1:length(data(load_data(i)).sessionIDs)
        
        TimeA = mData(load_data(i),f).TimeA.indices;
        TimeB = mData(load_data(i),f).TimeB.indices;
        OdorA = mData(load_data(i),f).OdorA.indices;
        OdorB = mData(load_data(i),f).OdorB.indices;
        
        % field index, field size ,activation_probability,
        % peak_time_variance for time A cells
        
        %         [fieldSize,field_idx,peak_time_variance,activation_probability,firing_field]
        [fieldSize,field_idx, peak_time_variance,activation_probability,firing_field]...
            = single_cell_field_characteristics(mData(load_data(i),f).(whichSignal).rmapsAA,mData(load_data(i),f).(whichSignal).rmapsAB,TimeA);
        
        mData(load_data(i),f).TimeA.field_size             = fieldSize;
        mData(load_data(i),f).TimeA.field_location         = field_idx;
        mData(load_data(i),f).TimeA.activation_probability = 100*activation_probability;
        mData(load_data(i),f).TimeA.peak_time_variance     = peak_time_variance;
        mData(load_data(i),f).TimeA.firing_field           = firing_field;
        
        
        if ~exist(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f}))
            mkdir(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f}))
        end
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeA_fieldSize'),'fieldSize')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeA_field_location'),'field_idx')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeA_activation_probability'),'activation_probability')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeA_peak_time_variance'),'peak_time_variance')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeA_firing_field'),'firing_field')
        
        
        % odor A
        [fieldSize,field_idx, peak_time_variance,activation_probability,firing_field]...
            = single_cell_field_characteristics(mData(load_data(i),f).(whichSignal).rmapsAA,mData(load_data(i),f).(whichSignal).rmapsAB,OdorA);
        
        mData(load_data(i),f).OdorA.field_size             = fieldSize;
        mData(load_data(i),f).OdorA.field_location         = field_idx;
        mData(load_data(i),f).OdorA.activation_probability = 100*activation_probability;
        mData(load_data(i),f).OdorA.peak_time_variance     = peak_time_variance;
        mData(load_data(i),f).OdorA.firing_field           = firing_field;
        size(field_idx)
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorA_fieldSize'),'fieldSize')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorA_field_location'),'field_idx')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorA_activation_probability'),'activation_probability')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorA_peak_time_variance'),'peak_time_variance')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorA_firing_field'),'firing_field')
        
        % field index, field size ,activation_probability,
        % peak_time_variance for time B cells
        [fieldSize,field_idx, peak_time_variance,activation_probability,firing_field]...
            = single_cell_field_characteristics(mData(load_data(i),f).(whichSignal).rmapsBA,mData(load_data(i),f).(whichSignal).rmapsBB,TimeB);
        
        mData(load_data(i),f).TimeB.field_size             = fieldSize;
        mData(load_data(i),f).TimeB.field_location         = field_idx;
        mData(load_data(i),f).TimeB.activation_probability = 100*activation_probability;
        mData(load_data(i),f).TimeB.peak_time_variance     = peak_time_variance;
        mData(load_data(i),f).TimeB.firing_field           = firing_field;
        
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeB_fieldSize'),'fieldSize')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeB_field_location'),'field_idx')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeB_activation_probability'),'activation_probability')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeB_peak_time_variance'),'peak_time_variance')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeB_firing_field'),'firing_field')
        
        
        [fieldSize,field_idx, peak_time_variance,activation_probability,firing_field]...
            = single_cell_field_characteristics(mData(load_data(i),f).(whichSignal).rmapsBA,mData(load_data(i),f).(whichSignal).rmapsBB,OdorB);
        
        mData(load_data(i),f).OdorB.field_size             = fieldSize;
        mData(load_data(i),f).OdorB.field_location         = field_idx;
        mData(load_data(i),f).OdorB.activation_probability = 100*activation_probability;
        mData(load_data(i),f).OdorB.peak_time_variance     = peak_time_variance;
        mData(load_data(i),f).OdorB.firing_field           = firing_field;
        
        
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorB_fieldSize'),'fieldSize')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorB_field_location'),'field_idx')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorB_activation_probability'),'activation_probability')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorB_peak_time_variance'),'peak_time_variance')
        save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorB_firing_field'),'firing_field')
        
        
    end
    
    
end




function [fieldSize,field_idx,peak_time_variance,activation_probability,firing_field] = single_cell_field_characteristics(rmaps1,rmaps2,cellIdx)
        
        % original signal was sampled with 31Hz but in rmaps 3 time points are
        % always averaged
        Fs = 31/5;
        % lowpass filtered (< 1Hz)
        Fpass = 1;
        delay = 1:38;
        
        %delay = 1:105;
        
        fieldSize              = NaN(length(cellIdx),1);
        field_idx              = NaN(length(cellIdx),1);
        activation_probability = NaN(length(cellIdx),1);
        peak_time_variance     = NaN(length(cellIdx),1);
        firing_field           = cell(length(cellIdx),1);
        
        for m = 1:length(cellIdx)
            rmap                              = [rmaps1(:,delay,cellIdx(m));...
                rmaps2(:,delay,cellIdx(m))];
            mean_rmaps                        =  nanmean(rmap);
            lowpass_mean_rmaps                = lowpass(mean_rmaps,Fpass,Fs);
            
            [field_idx(m),firing_field{m}]    = analysis.find_firing_field(lowpass_mean_rmaps);
            fieldSize(m)                      = length(firing_field{m});
            
            % calcuate activation_probability
            if ~isnan(field_idx(m))
                activeTrials                     = find(sum([rmaps1(:,delay(field_idx(m)),cellIdx(m));...
                    rmaps2(:,delay(field_idx(m)),cellIdx(m))],2)>0);
                activation_probability(m)        = length(activeTrials)/size(rmap,1);
                
                % calcuate firing peak time variance
                [~,field_idx_trial] = max(rmap');
                
                peak_time_variance(m)     = nanvar(field_idx_trial*0.1613);
                
            else
                activation_probability(m) = NaN;
                peak_time_variance(m)     = NaN;
            end
            
        end
        
    end

end
