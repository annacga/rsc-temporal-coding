
function mData = decode_trials_sessions(mData,data, varargin)
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

directory = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Analysis/areas/decoding/';%unchaged

if run_analysis==1
    for i = load_data
        for f = 1:length(data(i).sessionIDs)
            dir = fullfile(directory,data(i).area,'SVM_trial_sequence_cells',data(i).sessionIDs{f});
            if ~exist(dir, 'dir')
                mkdir(dir);
            end
            
            d_data_svm = decoding.svm_decoding(mData(i,f));
            mData(i,f).d_data_svm =d_data_svm;
            
            save(fullfile(dir,'d_data_svm.mat'), '-struct', 'd_data_svm');
        end
    end

else
    
     for i = load_data
        for f = 1:length(data(i).sessionIDs)
            dir = fullfile(directory,data(i).area,'SVM_trial_sequence_cells',data(i).sessionIDs{f});
            d_data_svm= load(fullfile(dir,'d_data_svm.mat'));
            mData(i,f).d_data_svm =d_data_svm;
        end
     end
     
end