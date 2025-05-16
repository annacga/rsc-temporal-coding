function parameters = get_parameters

%% IMAGING
% parameters.delay = 30;
% parameters.odorOne = 6;
parameters.binSize = 8;
parameters.plottingWidth=186; 
% parameters.plottingWidth=744; %If classify cells in ITI
%parameters.ITIWidth=589;
%parameters.ITIWidth=402;
parameters.ITIWidth=341;
parameters.ITIWidthLongDelay=899;
parameters.plottingWidthLongDelay=341;

%% LFP
parameters.frequency=[1 400];
parameters.samplingrate=2000;
parameters.analysisinterval = [1 14000]; %20000=1 sec

end

