function mData = load_rmaps(mData, data, varargin)

if nargin > 2
    load_data = varargin{1};
else
    load_data = 1:length(data)-1;
end

loaddir =  '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/rmaps_new';
loaddir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Fig_1/rmaps';

for i = 1:5%load_data
    for f = 1:length(data(i).sessionIDs)
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'deconv','rmapsAA.mat'))
        mData(i,f).deconv.rmapsAA = rmapsAA;
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'deconv','rmapsAB.mat'))
        mData(i,f).deconv.rmapsAB = rmapsAB;
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'deconv','rmapsBA.mat'))
        mData(i,f).deconv.rmapsBA = rmapsBA;
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'deconv','rmapsBB.mat'))
        mData(i,f).deconv.rmapsBB = rmapsBB;
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'dff','rmapsAA.mat'))
        mData(i,f).dff.rmapsAA = rmapsAA;
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'dff','rmapsAB.mat'))
        mData(i,f).dff.rmapsAB = rmapsAB;
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'dff','rmapsBA.mat'))
        mData(i,f).dff.rmapsBA = rmapsBA;
        load(fullfile(loaddir,data(i).area,data(i).sessionIDs{f},'dff','rmapsBB.mat'))
        mData(i,f).dff.rmapsBB = rmapsBB;
    end
end

end