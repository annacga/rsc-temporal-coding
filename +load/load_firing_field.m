
function mData = load_firing_field(mData,data, varargin)

if nargin > 1
    load_data = varargin{1};
else
    load_data = 1:length(data)-1;
end


loaddir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/classification';

for i =load_data 
    for f = 1:length(data(load_data(i)).sessionIDs)
        
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeB_firing_field'))
        mData(i,f).TimeB.firing_field         = firing_field;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'TimeA_firing_field'))
        mData(i,f).TimeA.firing_field         = firing_field;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorB_firing_field'))
        mData(i,f).OdorB.firing_field         = firing_field;
        load(fullfile(loaddir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'OdorA_firing_field'))
        mData(i,f).OdorA.firing_field         = firing_field;
        
    end
end

end