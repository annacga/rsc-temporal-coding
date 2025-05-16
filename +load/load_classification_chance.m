function mData = load_classification_chance(mData,data, varargin)

if nargin > 2
    load_data = varargin{1};
else
    load_data = 1:length(data)-1;
end

loaddir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Fig_1/classification_chance_include_ITI';
for i = load_data
    for f = 1:length(data(i).sessionIDs)
                          
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'OdorA.mat'))
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'OdorB.mat'))
        
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'TimeA.mat'))
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'TimeB.mat'))
        
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'ClassifiedCells.mat'))
        
        mData(i,f).TimeA_chance.indices = TimeA;
        mData(i,f).TimeB_chance.indices = TimeB;
        
        mData(i,f).OdorA_chance.indices = OdorA;
        mData(i,f).OdorB_chance.indices = OdorB;
        
        mData(i,f).classification_chance = ClassifiedCells_chance;
    end
end

end