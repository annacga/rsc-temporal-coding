
% Randomly circularly shift rate maps within each row and cell 
%
% This script performs a within-row circular shift on population rate maps
% (`rmapsAA`, `rmapsAB`, `rmapsBA`, and `rmapsBB`) for each cell, session, 
% and data group. The goal is to preserve the row-wise structure while 
% disrupting the temporal alignment across maps (used in shuffling controls).
%
% ------------------------
% METHOD DETAILS
% ------------------------
% - For each dataset and session:
%   - Each row of the rate map is circularly shifted along the time axis.
%   - A random shift value is generated uniformly in [1, numCols-1].
%   - This is done independently for each cell and condition (AA, AB, BA, BB).
% - The signal type to process is specified by `whichSignal`, e.g., 'deconv'.
% - The RNG is seeded for reproducibility.
%
% ------------------------
% INPUT VARIABLES
% ------------------------
%   data      - Structure array where each element represents a data group.
%   mData     - Nested structure with precomputed rate maps per session/cell.
%   whichSignal - String specifying the signal field to shuffle ('deconv', etc.)
%
% ------------------------
% OUTPUT
% ------------------------
%   mData.(signal).rmapsXX - Same structure, but each row of each rate map
%                            has been circularly shifted independently.
%
% Written by Anna Christina Garvert, 2025.


rng(5)  % Set random seed for reproducibility

whichSignal = 'deconv';  % Select the signal type to manipulate

% Loop over data groups
for i = 1:length(data)-1

    % Loop over sessions within each group
    for f = 1:length(data(i).sessionIDs)

        % Get number of cells for this session
        numCells = size(mData(i,f).(whichSignal).rmapsAA, 3);

        % Loop over cells
        for m = 1:numCells

            % --- Shuffle rmapsAA ---
            numRows = size(mData(i,f).(whichSignal).rmapsAA, 1);
            numCols = size(mData(i,f).(whichSignal).rmapsAA, 2);

            for iii = 1:numRows
                % Generate a random circular shift amount (non-zero)
                shiftValue = randi([1, numCols - 1]);
                % Apply circular shift along the time axis (columns)
                mData(i,f).(whichSignal).rmapsAA(iii, :, m) = ...
                    circshift(mData(i,f).(whichSignal).rmapsAA(iii, :, m), shiftValue);
            end

            % --- Shuffle rmapsAB ---
            numRows = size(mData(i,f).(whichSignal).rmapsAB, 1);
            numCols = size(mData(i,f).(whichSignal).rmapsAB, 2);

            for iii = 1:numRows
                shiftValue = randi([1, numCols - 1]);
                mData(i,f).(whichSignal).rmapsAB(iii, :, m) = ...
                    circshift(mData(i,f).(whichSignal).rmapsAB(iii, :, m), shiftValue);
            end

            % --- Shuffle rmapsBA ---
            numRows = size(mData(i,f).(whichSignal).rmapsBA, 1);
            numCols = size(mData(i,f).(whichSignal).rmapsBA, 2);

            for iii = 1:numRows
                shiftValue = randi([1, numCols - 1]);
                mData(i,f).(whichSignal).rmapsBA(iii, :, m) = ...
                    circshift(mData(i,f).(whichSignal).rmapsBA(iii, :, m), shiftValue);
            end

            % --- Shuffle rmapsBB ---
            numRows = size(mData(i,f).(whichSignal).rmapsBB, 1);
            numCols = size(mData(i,f).(whichSignal).rmapsBB, 2);

            for iii = 1:numRows
                shiftValue = randi([1, numCols - 1]);
                mData(i,f).(whichSignal).rmapsBB(iii, :, m) = ...
                    circshift(mData(i,f).(whichSignal).rmapsBB(iii, :, m), shiftValue);
            end

        end
    end
end
