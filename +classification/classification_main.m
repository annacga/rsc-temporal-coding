function mData = classification_main(mData,data, varargin)

save_analysis = 0;
if nargin == 4
    load_data     = varargin{1};
    save_analysis = varargin{2};
elseif nargin == 3
    if isempty(varargin{1})
        load_data = 1:length(data)-1;
    else
        load_data     = varargin{1};
    end
else
    load_data = 1:length(data)-1;
end

for i = 1:length(data)-1
    for f = 1:length(data(i).sessionIDs)
        
%         % this finds significant responses in odor A and odor B trials
%         ClassifiedCells_chance  = classification.cellClassificationGolshani_shuffle(mData(i,f).sData);
%         mData(i,f).classification_chance = ClassifiedCells_chance;

        ClassifiedCells  = classification.cellClassificationGolshani(mData(i,f).sData);
        mData(i,f).classification = ClassifiedCells;
   
        if save_analysis
            savedir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Fig_1/classification';
            if ~exist(fullfile(savedir,data(i).area,data(i).sessionIDs{f}),'dir')
                mkdir(fullfile(savedir,data(i).area,data(i).sessionIDs{f}))
            end
            save(fullfile(savedir,data(i).area,data(i).sessionIDs{f},'ClassifiedCells.mat'),'ClassifiedCells')
 
        end
    end
end

mData = classification.sequence_ID(mData,data,load_data,save_analysis);


end
