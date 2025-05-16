function mData = load_all_field_info(mData,data, varargin)

if nargin > 1
    load_data = varargin{1};
else
    load_data = 1:length(data)-1;
end


loaddir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Fig_1/field_info_modes';

for i = load_data 
    for f = 1:length(data(load_data(i)).sessionIDs)
        
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeB_field_location'))
        mData(load_data(i),f).TimeB.field_location         = field_idx;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeA_field_location'))
        mData(load_data(i),f).TimeA.field_location         = field_idx;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorB_field_location'))
        mData(load_data(i),f).OdorB.field_location         = field_idx;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorA_field_location'))
        mData(load_data(i),f).OdorA.field_location         = field_idx;
        
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeA_fieldSize'))
        mData(load_data(i),f).TimeA.field_size             = fieldSize;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeB_fieldSize'))
        mData(load_data(i),f).TimeB.field_size             = fieldSize;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorA_fieldSize'))
        mData(load_data(i),f).OdorA.field_size             = fieldSize;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorB_fieldSize'))
        mData(load_data(i),f).OdorB.field_size             = fieldSize;
        
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeA_activation_probability'))
        mData(load_data(i),f).TimeA.activation_probability             = 100*activation_probability*5/31;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeB_activation_probability'))
        mData(load_data(i),f).TimeB.activation_probability             = 100*activation_probability*5/31;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorA_activation_probability'))
        mData(load_data(i),f).OdorA.activation_probability             = 100*activation_probability*5/31;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorB_activation_probability'))
        mData(load_data(i),f).OdorB.activation_probability             = 100*activation_probability*5/31;
        
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeA_peak_time_variance'))
        mData(load_data(i),f).TimeA.peak_time_variance              = peak_time_variance*5/31;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeB_peak_time_variance'))
        mData(load_data(i),f).TimeB.peak_time_variance              = peak_time_variance*5/31;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorA_peak_time_variance'))
        mData(load_data(i),f).OdorA.peak_time_variance              = peak_time_variance*5/31;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorB_peak_time_variance'))
        mData(load_data(i),f).OdorB.peak_time_variance              = peak_time_variance*5/31;
        
    end
end

end