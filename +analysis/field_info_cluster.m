
%% calculation of firing field width
% the mean firing rate over prefered trials is calculated and lowpass
% filtered (< 1Hz), its baseline was approximated by its mode value
% the time two points around the peak where the filtered mean signal drops
% below the threshold baseline +1/2 standard deviation are identified 
% the field size is given by the time interval between these two time
% points
% If the mean firign rate didnt drop below the value, the odor onset or
% delay offseet was used accordingly
% Field sizes >4 s were discarded

% field sizes should be considered as an approximation of the time interval 
% where the cell had the highest activation probability relative to the rest 
% of the trial, and as such its length represents the variability in 
% activation time for the cell.

% apply first the analysis.selectivity script


%% field location 
% the mean firing rate over preffered trials is calculated and the time bin where 
% the mean firing rate is maximal is considered the cell's field time point

% original signal was sampled with 31Hz but in rmaps 3 time points are
% always averaged

savedir_classification = '/cluster/work/users/annacga/Malte/RSC/classification';
for i = 1:length(data)
    for f = 1:length(data(i).sessionIDs)
                
               
        load(fullfile(savedir_classification,data(i).area,data(i).sessionIDs{f},'OdorA.mat'))
        load(fullfile(savedir_classification,data(i).area,data(i).sessionIDs{f},'OdorB.mat'))
        
        load(fullfile(savedir_classification,data(i).area,data(i).sessionIDs{f},'TimeA.mat'))
        load(fullfile(savedir_classification,data(i).area,data(i).sessionIDs{f},'TimeB.mat'))
        
        load(fullfile(savedir_classification,data(i).area,data(i).sessionIDs{f},'SI_odorA.mat'))
        load(fullfile(savedir_classification,data(i).area,data(i).sessionIDs{f},'SI_odorB.mat'))
             
        load(fullfile(savedir_classification,data(i).area,data(i).sessionIDs{f},'SI_timeA.mat'))
        load(fullfile(savedir_classification,data(i).area,data(i).sessionIDs{f},'SI_timeB.mat'))
        
        mData(i,f).TimeA.indices = TimeA;
        mData(i,f).TimeB.indices = TimeB;
        mData(i,f).TimeA.SI  = SI_timeA;
        mData(i,f).TimeB.SI  = SI_timeB;
        
        mData(i,f).OdorA.indices = OdorA;
        mData(i,f).OdorB.indices = OdorB;
        mData(i,f).OdorA.SI  = SI_odorA;
        mData(i,f).OdorB.SI  = SI_odorB;

        
    end
end


Fs = 31/5;
% lowpass filtered (< 1Hz)
Fpass = 1;

delay = 1:44; whichSignal = 'deconv';

savedir = '/cluster/work/users/annacga/Malte/RSC/field_info';

for i = 1%:3%length(data)
    for f = 1:length(data(i).sessionIDs)
       
        TimeA = mData(i,f).TimeA.indices;
        TimeB = mData(i,f).TimeB.indices;
        OdorA = mData(i,f).OdorA.indices;
        OdorB = mData(i,f).OdorB.indices;
        
       % field index, field size ,activation_probability,
       % peak_time_variance for time A cells
  
       
       [fieldSize,field_idx, peak_time_variance,activation_probability,firing_field]...
           = single_cell_field_characteristics(mData(i,f).(whichSignal).rmapsAA,mData(i,f).(whichSignal).rmapsAB,TimeA);

       mData(i,f).TimeA.field_size             = fieldSize;
       mData(i,f).TimeA.field_location         = field_idx;
       mData(i,f).TimeA.activation_probability = 100*activation_probability;
       mData(i,f).TimeA.peak_time_variance     = peak_time_variance;
       mData(i,f).TimeA.firing_field           = firing_field;

       
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'TimeA_fieldSize'),'fieldSize')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'TimeA_field_location'),'field_idx')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'TimeA_activation_probability'),'activation_probability')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'TimeA_peak_time_variance'),'peak_time_variance')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'TimeA_firing_field'),'firing_field')

       
       % odor A
       [fieldSize,field_idx, peak_time_variance,activation_probability,firing_field]...
           = single_cell_field_characteristics(mData(i,f).(whichSignal).rmapsAA,mData(i,f).(whichSignal).rmapsAB,OdorA);
       
       mData(i,f).OdorA.field_size             = fieldSize;
       mData(i,f).OdorA.field_location         = field_idx;
       mData(i,f).OdorA.activation_probability = 100*activation_probability;
       mData(i,f).OdorA.peak_time_variance     = peak_time_variance;
       mData(i,f).OdorA.firing_field           = firing_field;

       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'OdorA_fieldSize'),'fieldSize')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'OdorA_field_location'),'field_idx')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'OdorA_activation_probability'),'activation_probability')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'OdorA_peak_time_variance'),'peak_time_variance')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'OdorA_firing_field'),'firing_field')

       % field index, field size ,activation_probability,
       % peak_time_variance for time B cells
       [fieldSize,field_idx, peak_time_variance,activation_probability,firing_field]...
           = single_cell_field_characteristics(mData(i,f).(whichSignal).rmapsBA,mData(i,f).(whichSignal).rmapsBB,TimeB);
       
       mData(i,f).TimeB.field_size             = fieldSize;
       mData(i,f).TimeB.field_location         = field_idx;
       mData(i,f).TimeB.activation_probability = 100*activation_probability;
       mData(i,f).TimeB.peak_time_variance     = peak_time_variance;
       mData(i,f).TimeB.firing_field           = firing_field;

       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'TimeB_fieldSize'),'fieldSize')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'TimeB_field_location'),'field_idx')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'TimeB_activation_probability'),'activation_probability')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'TimeB_peak_time_variance'),'peak_time_variance')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'TimeB_firing_field'),'firing_field')

       
       [fieldSize,field_idx, peak_time_variance,activation_probability,firing_field]...
           = single_cell_field_characteristics(mData(i,f).(whichSignal).rmapsBA,mData(i,f).(whichSignal).rmapsBB,OdorB);
      
       mData(i,f).OdorB.field_size             = fieldSize;
       mData(i,f).OdorB.field_location         = field_idx;
       mData(i,f).OdorB.activation_probability = 100*activation_probability;
       mData(i,f).OdorB.peak_time_variance     = peak_time_variance;
       mData(i,f).OdorB.firing_field           = firing_field;
       
       
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'OdorB_fieldSize'),'fieldSize')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'OdorB_field_location'),'field_idx')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'OdorB_activation_probability'),'activation_probability')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'OdorB_peak_time_variance'),'peak_time_variance')
       save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'OdorB_firing_field'),'firing_field')

       
    end


end




function [fieldSize,field_idx,peak_time_variance,activation_probability,firing_field] = single_cell_field_characteristics(rmaps1,rmaps2,cellIdx)

% original signal was sampled with 31Hz but in rmaps 3 time points are
% always averaged
Fs = 31/5;
% lowpass filtered (< 1Hz)
Fpass = 1;
delay = 1:44;

fieldSize              = NaN(length(cellIdx),1);
field_idx              = NaN(length(cellIdx),1);
activation_probability = NaN(length(cellIdx),1);
peak_time_variance     = NaN(length(cellIdx),1);
firing_field           = cell(length(cellIdx),1);


for m = 1:length(cellIdx)
        rmap                          =  [rmaps1(:,delay,cellIdx(m));...
                                         rmaps2(:,delay,cellIdx(m))];
    
    mean_rmaps                        =  nanmean(rmap);
    lowpass_mean_rmaps                = lowpass(mean_rmaps,Fpass,Fs);
    [field_idx(m),firing_field{m}]    = analysis.find_firing_field(lowpass_mean_rmaps);
    fieldSize(m)                      = length(firing_field);
    
    % calcuate activation_probability
    if ~isnan(field_idx(m))
        activeTrials                     = find(sum([rmaps1(:,delay(firing_field{m}),cellIdx(m));...
                                                rmaps2(:,delay(firing_field{m}),cellIdx(m))],2)>0);
        activation_probability(m)        = length(activeTrials)/size(rmap,1);
        
        % calcuate firing peak time variance
        field_idx_trial = NaN(length(cellIdx),1);
        for k = 1:length(activeTrials)
            field_idx_trial(k)    = find_firing_field(lowpass(rmap(activeTrials(k),:),Fpass,Fs));
        end
        
        peak_time_variance(m)     = nanvar(field_idx_trial);
    else
        activation_probability(m) = NaN;
        peak_time_variance(m)     = NaN;
    end
    
end

end


function [maxloc,indices] = find_firing_field(mean_firing_rate)

% find indices where the mean firing rate is above threrhold baseline +1/2
% standard deviation 
% field sizes >4 s are discarded
% mode value: the weighted average fluorescence from all the pixels in the 
% ROI after removing overlapping components and neuropil contamination and prior to the ΔF/F transformation


% the mean firing rate over prefered trials is calculated and lowpass
% filtered (< 1Hz), its baseline was approximated by its mode value
% the time two points around the peak where the filtered mean signal drops
% below the threshold baseline +1/2 standard deviation are identified 
% the field size is given by the time interval between these two time
% points
% If the mean firign rate didnt drop below the value, the odor onset or
% delay offseet was used accordingly
% Field sizes >4 s were discarded

% field sizes should be considered as an approximation of the time interval 
% where the cell had the highest activation probability relative to the rest 
% of the trial, and as such its length represents the variability in 
% activation time for the cell.
% we increased the threshold

threshold                = min(mean_firing_rate)+2*std(mean_firing_rate);
indices_above_threshold  = find(mean_firing_rate>threshold);
[~,peakIdx]              = max(mean_firing_rate(indices_above_threshold));
maxloc                   = indices_above_threshold(peakIdx);

% find field beginning
indices = maxloc;
ii      = maxloc;
while ii-1 > 0 && (mean_firing_rate(ii-1) > threshold) 
    indices = [indices,ii-1];
    ii      = ii-1;
end

% find field beginning
ii      = maxloc;
while ii+1 < length(mean_firing_rate) && (mean_firing_rate(ii+1) > threshold) 
    indices = [indices,ii+1];
    ii      = ii+1;
end

indices = sort(indices);
if length(indices)> 31/5*4
    indices = NaN;
    maxloc  = NaN;
end

% % find centroid
% if ~isnan(maxloc)
%     p = polyshape(indices,mean_firing_rate(indices));
%     centroidloc = centroid(p);
% end



end