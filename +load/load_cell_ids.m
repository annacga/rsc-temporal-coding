function mData = load_cell_ids(mData,data, varargin)

if nargin > 1
    load_data = varargin{1};
else
    load_data = 1:length(data)-1;
end


loaddir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/classification';


for i = load_data 
    for f = 1:length(datat(load_data(i)).sessionIDs)
       load(fullfile(loaddir,datat(load_data(i)).area,datat(load_data(i)).sessionIDs{f},'OdorA'))
       load(fullfile(loaddir,datat(load_data(i)).area,datat(load_data(i)).sessionIDs{f},'OdorB'))
       mData(i,f).OdorA.indices = OdorA;
       mData(i,f).OdorB.indices = OdorB;
       
       load(fullfile(loaddir,datat(load_data(i)).area,datat(load_data(i)).sessionIDs{f},'TimeA'))
       load(fullfile(loaddir,datat(load_data(i)).area,datat(load_data(i)).sessionIDs{f},'TimeB'))
       mData(i,f).TimeA.indices = TimeA;
       mData(i,f).TimeB.indices = TimeB;
    end
end

end