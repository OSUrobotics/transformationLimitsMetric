function [ ptsTransformed ] = applySavedTransformations( transformations, pts, verticalOut )
%% APPLYSAVEDTRANSFORMATIONS takes saved transformation steps and applies them to create a multi-dimensional indexed set of points
%   Uses the transformationStruct and applies the transformations contained to a set of points, with an option to return in vertical list format or horizontal list format, defaulting to horizontal
if ischar(transformations) % pass in nothing if have already loaded variables
    %% Read in structure
    load([transformations '.mat']);
    transformations = transformationStruct.trajectorySteps;
end    
% transformationStruct.trajectorySteps is a 4d set of transformations in [4x4 transformation matrix, step, values set index] 
%% Reformat pts if not in the right dimensions to be horizontal and pad
if size(pts,2) == 3 && size(pts,1) ~= 3 % if in a vertical format
    pts = pts.';
end
pts = [pts; ones(1,size(pts,2))];
%% Initialize matrix for output
ptsTransformed = zeros(4,size(pts,2),size(transformations,3),size(transformations,4));
%% Loop through value sets
for stepIndex = 1:size(transformations,3)
    parfor valueIndex = 1:size(transformations,4)
        ptsTransformed(:,:,stepIndex,valueIndex) = transformations(:,:,stepIndex,valueIndex)*pts;
    end
end
%% Remove padding and reformat if wanted
ptsTransformed = ptsTransformed(1:3,:,:,:);
if nargin == 3 && verticalOut
    ptsTransformed = permute(ptsTransformed,[2 1 3 4]);
end
end