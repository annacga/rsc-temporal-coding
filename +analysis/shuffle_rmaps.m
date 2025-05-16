rng(5)

whichSignal = 'deconv';
for i = 1:length(data)-1
    for f = 1:length(data(i).sessionIDs)

        numCells = size(mData(i,f).(whichSignal).rmapsAA,3);
        for m = 1:length(numCells)
            
            numRows = size(mData(i,f).(whichSignal).rmapsAA,1);
            numCols = size(mData(i,f).(whichSignal).rmapsAA,2);
            
            for iii = 1:numRows
                shiftValue = randi([1, numCols-1]);
                mData(i,f).(whichSignal).rmapsAA(iii, :,m) = circshift(mData(i,f).(whichSignal).rmapsAA(iii, :,m), shiftValue);
            end
            
            numRows = size(mData(i,f).(whichSignal).rmapsAB,1);
            numCols = size(mData(i,f).(whichSignal).rmapsAB,2);
            
            for iii = 1:numRows
                shiftValue = randi([1, numCols-1]);
                mData(i,f).(whichSignal).rmapsAB(iii, :,m) = circshift(mData(i,f).(whichSignal).rmapsAB(iii, :,m), shiftValue);
            end
            
            numRows = size(mData(i,f).(whichSignal).rmapsBA,1);
            numCols = size(mData(i,f).(whichSignal).rmapsBA,2);
            
            for iii = 1:numRows
                shiftValue = randi([1, numCols-1]);
                mData(i,f).(whichSignal).rmapsBA(iii, :,m) = circshift(mData(i,f).(whichSignal).rmapsBA(iii, :,m), shiftValue);
            end
            
            numRows = size(mData(i,f).(whichSignal).rmapsBB,1);
            numCols = size(mData(i,f).(whichSignal).rmapsBB,2);
            
            for iii = 1:numRows
                shiftValue = randi([1, numCols-1]);
                mData(i,f).(whichSignal).rmapsBB(iii, :,m) = circshift(mData(i,f).(whichSignal).rmapsBB(iii, :,m), shiftValue);
            end
            
        end
    end
end