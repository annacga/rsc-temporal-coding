function [d_data_time,d_data_time_chance, d_data_trial_type, d_data_trial_type_chance] = load_decoding(data, varargin)

if nargin > 1
    load_data = varargin{1};
else
    load_data = 1:length(data)-1;
end

loaddir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Fig_2/decoding_sequence_cells';

d_data_time              = struct();
d_data_trial_type        = struct();
d_data_time_chance       = struct();
d_data_trial_type_chance = struct();

for i = load_data
    for f = 1:length(data(i).sessionIDs)
        d_data_time(i,f).d_data = load(fullfile(loaddir,data(i).area,'decoding',data(i).sessionIDs{f},'d_data.mat'));
    end  
end


for i = load_data
    for f = 1:length(data(i).sessionIDs)
        d_data_time_chance(i,f).d_data = load(fullfile(loaddir,data(i).area,'decoding_chance',data(i).sessionIDs{f},'d_data.mat'));
    end  
end

end