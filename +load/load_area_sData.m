% function mData = load_area_sData(data, varargin)
% 
% if nargin > 1
%     load_data = varargin{1};
% else
%     load_data = 1:length(data)-1;
% end
load_data = 1:length(data)-1;
load_sData_dirct = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/sDATA/areas/';

mData = struct();
% Load all sessions
for i = load_data
    for f = 1:length(data(i).sessionIDs)% 2 3 4 7 
        load(fullfile(load_sData_dirct,data(i).area,strcat(data(i).sessionIDs{f}, '.mat')));
        mData(i,f).sData = sData;
    end
end




