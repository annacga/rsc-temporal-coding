
%% field location 
% the mean firing rate over preffered trials is calculated and the time bin where 
% the mean firing rate is maximal is considered the cell's field time point


field_size_area_A = cell(length(data),1);
field_size_area_B = cell(length(data),1);

field_idx_area_A  = cell(length(data),1);
field_idx_area_B  = cell(length(data),1);

activation_probability_area_A = cell(length(data),1);
activation_probability_area_B = cell(length(data),1);

peak_time_variance_area_A = cell(length(data),1);
peak_time_variance_area_B = cell(length(data),1);


SI_area_A = cell(length(data),1);
SI_area_B = cell(length(data),1);


for i = 1%:length(data)
    for f = 1:length(data(i).sessionIDs)
      
       field_idx_area_A{i} = [field_idx_area_A{i};mData(i,f).TimeA.field_location;mData(i,f).OdorA.field_location];
       field_idx_area_B{i} = [field_idx_area_B{i};mData(i,f).TimeB.field_location;mData(i,f).OdorB.field_location];
       activation_probability_area_A{i} = [activation_probability_area_A{i};mData(i,f).TimeA.activation_probability;mData(i,f).OdorA.activation_probability];
       activation_probability_area_B{i} = [activation_probability_area_B{i};mData(i,f).TimeB.activation_probability;mData(i,f).OdorB.activation_probability];
       peak_time_variance_area_A{i} = [peak_time_variance_area_A{i};mData(i,f).TimeA.peak_time_variance;mData(i,f).OdorA.peak_time_variance];
       peak_time_variance_area_B{i} = [peak_time_variance_area_B{i};mData(i,f).TimeB.peak_time_variance;mData(i,f).OdorB.peak_time_variance];
       SI_area_A{i} = [SI_area_A{i};mData(i,f).TimeA.SI;mData(i,f).OdorA.SI];
       SI_area_B{i} = [SI_area_B{i};mData(i,f).TimeB.SI;mData(i,f).OdorB.SI];

    end

    plot.distribution_firing_field(field_idx_area_A{i},field_idx_area_B{i})
    plot.firing_peak_time_variance([field_idx_area_A{i};field_idx_area_B{i}],[peak_time_variance_area_A{i};peak_time_variance_area_B{i}])
    plot.selectivity_index([field_idx_area_A{i};field_idx_area_B{i}],[SI_area_A{i};SI_area_B{i}])
    plot.activation_probability([field_idx_area_A{i};field_idx_area_B{i}],[activation_probability_area_A{i};activation_probability_area_B{i}])

end


