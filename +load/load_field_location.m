function mData = load_field_location(mData,data, varargin)

if nargin > 1
    load_data = varargin{1};
else
    load_data = 1:length(data)-1;
end

loaddir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/classification';
loaddir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Fig_1/field_info_modes/';

for i = load_data
    for f = 1:length(data(load_data(i)).sessionIDs)
        
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeB_field_location'))
        mData(i,f).TimeB.field_location         = field_idx;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeA_field_location'))
        mData(i,f).TimeA.field_location        = field_idx;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorB_field_location'))
        mData(i,f).OdorB.field_location         = field_idx;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorA_field_location'))
        mData(i,f).OdorA.field_location         = field_idx;
        
    end
end

end