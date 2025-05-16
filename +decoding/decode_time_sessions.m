function mData = decode_time_sessions(mData,data, varargin)
% Function to decode trial sessions for given data and optional parameters
% Inputs:
%   mData - Structure to hold results
%   data - Input data structure with session IDs
%   varargin - Optional arguments:
%       1. load_data (array of indices to process)
%       2. run_analysis (boolean to trigger analysis)
% Outputs:
%   mData - Updated structure with decoding results

run_analysis=0;
if nargin == 3
    load_data = varargin{1};
    run_analysis = 1; 
elseif nargin == 2
    load_data = varargin{1};
else
    load_data = 1:length(data)-1;
end

directory = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Fig_2/decoding_sequence_cells';
if run_analysis==1
    for i = 1:load_data
    
        for f = 1:length(data(i).sessionIDs)
            
            % Construct the directory for saving results
            full_save_dir = fullfile(directory, data(i).area, 'time', data(i).sessionIDs{f});
            
            % Create the directory if it does not exist
            if ~exist(full_save_dir, 'dir')
                mkdir(full_save_dir);
            end
            
            % Perform decoding and save results
            d_data_taxidis = decoding.bayesian_decoding_taxidis(mData(i, f));
            mData(i, f).d_data_taxidis = d_data_taxidis;
            
            % Save the decoding data
            save(fullfile(full_save_dir, 'd_data_taxidis.mat'), '-struct', 'd_data_taxidis');
        end
    end
else
    for i = 1:load_data
        for f = 1:length(data(i).sessionIDs)
            dir = fullfile(directory,data(load_data(i)).area,'time',data(load_data(i)).sessionIDs{f});
            d_data_taxidis = load(fullfile(dir,'d_data_taxidis.mat'));
            mData(i,f).d_data_taxidis =d_data_taxidis ;
        end
    end
end

