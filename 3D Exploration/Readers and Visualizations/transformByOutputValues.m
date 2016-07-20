function [ ptsOut ] = transformByOutputValues( pts, inputOutput )
%% TRANSFORMBYOUTPUTVALUES Applies the transformations given in the putput files to a set of points
%   Detailed explanation goes here
%% Get pts to horizontal list
if size(pts,1) ~= 3
    pts = pts.';
end
%% Preallocate array for ptsOut
ptsOut = zeros(3,size(pts,2),size(inputOutput,3),size(inputOutput,1));
%% Loop through steps (3rd dimension inputOutput)
for stepIndex = 1:size(inputOutput,3)
    %% Loop through values and apply transformation to pts
    for valueIndex = 1:size(inputOutput,1)
        ptsOut(:,:,stepIndex,valueIndex) = pts;
    end
end
end