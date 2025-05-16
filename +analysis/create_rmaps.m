function mData = create_rmaps(mData,data, varargin)

% Generate and optionally save response maps (rMaps) for each ROI.
%
% This function processes session data to compute response maps (rMaps) 
% from neural activity traces for four odor pairings: AA, AB, BA, and BB. 
% It supports both deconvolved and dF/F signals. Optionally, the results 
% can be saved to disk.
%
% INPUTS:
%   mData         - Struct containing session and signal data, which will be 
%                   updated with computed rMaps.
%
%   data          - Metadata struct containing fields:
%                     - sessionIDs: Cell array of session identifiers.
%                     - area: String indicating brain area.
%
%   varargin      - Optional arguments:
%                   1) load_data: Indices of entries in `data` to process.
%                   2) save_analysis: Binary flag (0 or 1) to enable saving 
%                      of computed rMaps.
%                   If only one argument is provided, it is interpreted as `load_data`.
%
% OUTPUTS:
%   mData         - Updated input struct with fields:
%                     mData(i,f).deconv.rmapsXX
%                     mData(i,f).dff.rmapsXX
%                   where XX ∈ {AA, AB, BA, BB}, and each contains the trial-aligned 
%                   and binned neural response for each ROI.
%
% PROCESS:
%   - For each ROI in each session, compute response maps using `calculate_rmap`.
%   - Populate the `mData` struct with the result.
%   - Optionally save the result to a predefined folder structure by area/session.
%
%
% Written by Anna Christina Garvert, 2023.

save_analysis = 0;
if nargin == 3
    load_data     = varargin{1};
    save_analysis = varargin{2};
elseif nargin == 2
    load_data     = varargin{1};
else
    load_data = 1:length(data)-1;
end

% load results or run analysis
savedir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Fig_1/rmaps';

for i = load_data
    for f = 1:length(data(load_data(i)).sessionIDs)
        mData(i,f).deconv.rmapsAA = [];
        mData(i,f).deconv.rmapsAB= [];
        mData(i,f).deconv.rmapsBA= [];
        mData(i,f).deconv.rmapsBB= [];
        
        mData(i,f).dff.rmapsAA = [];
        mData(i,f).dff.rmapsAB= [];
        mData(i,f).dff.rmapsBA= [];
        mData(i,f).dff.rmapsBB= [];
        
        signal = mData(i,f).sData.imData.roiSignals.deconv;
        signal_dff = mData(i,f).sData.imData.roiSignals.deconv;
        
        for l= 1:size(signal,1)
            [mData(i,f).deconv.rmapsAA(:,:,l),mData(i,f).deconv.rmapsAB(:,:,l),mData(i,f).deconv.rmapsBA(:,:,l),mData(i,f).deconv.rmapsBB(:,:,l)] = analysis.calculate_rmap(mData(i,f).sData,signal,l);
            [mData(i,f).dff.rmapsAA(:,:,l),mData(i,f).dff.rmapsAB(:,:,l),mData(i,f).dff.rmapsBA(:,:,l),mData(i,f).dff.rmapsBB(:,:,l)]             = analysis.calculate_rmap(mData(i,f).sData,signal_dff,l);
        end
        
        %% save of rmaps
        if save_analysis
            if ~exist(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f}),'dir')
                mkdir(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'deconv'))
                mkdir(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'dff'))
            end
            
            rmapsAA = mData(i,f).deconv.rmapsAA;
            save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'deconv','rmapsAA.mat'),'rmapsAA')
            rmapsAB = mData(i,f).deconv.rmapsAB;
            save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'deconv','rmapsAB.mat'),'rmapsAB')
            rmapsBA = mData(i,f).deconv.rmapsBA;
            save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'deconv','rmapsBA.mat'),'rmapsBA')
            rmapsBB = mData(i,f).deconv.rmapsBB;
            save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'deconv','rmapsBB.mat'),'rmapsBB')
            
            rmapsAA = mData(i,f).dff.rmapsAA;
            save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'dff','rmapsAA.mat'),'rmapsAA')
            rmapsAB = mData(i,f).dff.rmapsAB;
            save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'dff','rmapsAB.mat'),'rmapsAB')
            rmapsBA = mData(i,f).dff.rmapsBA;
            save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'dff','rmapsBA.mat'),'rmapsBA')
            rmapsBB = mData(i,f).dff.rmapsBB;
            save(fullfile(savedir,data(load_data(i)).area,data(load_data(i)).sessionIDs{f},'dff','rmapsBB.mat'),'rmapsBB')
        end
    end
end

% end

