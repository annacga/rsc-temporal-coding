  
function [decay,rise] = calculate_rise_decay(sData) % testDeconvolution

dff = sData.imData.roiSignals.dff;
% function from Eivind
fps = 31;
nRois = size(dff,1);
nSamples = size(dff,2);

% First, simply estimate time constants.
tauDR   = zeros(nRois, 2);
tauDRms = zeros(nRois, 2);

for i = 1:nRois
    
    if ~(sum(isnan(dff(i,:))) == length(dff(i,:)))

        g=  estimate_time_constant(dff(i,:), 2,GetSn(dff(i,:)));
        [tauRise, tauDecay] = signalExtraction.CaImAn.getArConstantsInMs(g, fps);
        tauDRms(i, :) = [tauRise, tauDecay];
  
    end
    
end

decay  = tauDRms(:,2)';
rise   = tauDRms(:,1)';
end