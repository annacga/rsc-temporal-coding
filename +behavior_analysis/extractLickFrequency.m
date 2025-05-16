
   
function iFrequency   = extractLickFrequency(sData,samplingRate,lickLengthThr,lickFreqThr)
% lickLengthThr  
lickSignal          = sData.imData.variables.lick;
lickStartInd        = find(diff(lickSignal) == 1)+1;
lickEndInd          = find(diff(lickSignal) == -1);
% 
% % Correct for licks not fully captured at the beginning or end of the recording
if lickSignal(1) == 1
    lickEndInd = lickEndInd(2:numel(lickEndInd));
end
if lickSignal(numel(lickSignal)) == 1
    lickStartInd= lickStartInd(1:numel(lickStartInd)-1);
end

% % convert length in sample points to length in ms
lickLength  = (lickEndInd - lickStartInd)/(samplingRate/1000); 
% 
% % convert to lick frequency
diffLickStart   = diff(lickStartInd);
lickFrequency   = samplingRate./diffLickStart;%samplingRate./diffLickStart;

lickFrequency  = [lickFrequency ,0];

iFrequency = nan(size(sData.imData.variables.lick));
iFrequency(lickStartInd) = lickFrequency;
iFrequency(1) = 0;
iFrequency = fillmissing(iFrequency,'previous'); 

lickFrequency        = helper.ifreq(sData.imData.variables.lick,100);

end