function mData = load_sequence_ID(mData,data, varargin)

if nargin == 3
    load_data     = varargin{1};
else
    load_data = 1:length(data)-1;
end
 


loaddir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Fig_1/classification_';

for i = load_data
    for f = 1:length(data(i).sessionIDs)
        
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'OdorA.mat'))
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'OdorB.mat'))
        
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'TimeA.mat'))
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'TimeB.mat'))
        
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'SI_odorA.mat'))
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'SI_odorB.mat'))
        
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'SI_timeA.mat'))
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'SI_timeB.mat'))
        
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

end