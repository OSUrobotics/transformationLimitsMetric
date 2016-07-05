function [ ptsTransformed ] = applySavedTransformations( transformsFilename, pts, verticalOut )
%% APPLYSAVEDTRANSFORMATIONS takes saved transformation steps and applies them to create a multi-dimensional indexed set of points
%   Detailed explanation goes here
%% Read in structure
load([transformsFilename '.mat']);
% transformationStruct.trajectorySteps is a 4d set of transformations in [4x4 transformation matrix, step, values set index] 
%% Reformat pts if not in the right dimensions to be horizontal and pad
if size(pts,2) == 3 && size(pts,1) ~= 3 % if in a vertical format
    pts = pts.';
end
pts = [pts; ones(1,size(pts,2))];
%% Initialize matrix for output
ptsTransformed = zeros(4,size(pts,2),size(transformationStruct.trajectorySteps,3),size(transformationStruct.trajectorySteps,4));
%% Loop through value sets
for valueIndex = 1:size(transformationStruct.trajectorySteps,4)
    for stepIndex = 1:size(transformationStruct.trajectorySteps,3)
        ptsTransformed(:,:,stepIndex,valueIndex) = transformationStruct.trajectorySteps(:,:,stepIndex,valueIndex)*pts;
    end
end
%% Remove padding and reformat if wanted
ptsTransformed = ptsTransformed(1:3,:,:,:);
if nargin == 3
    if verticalOut
        ptsTransformed = permute(ptsTransformed,[2 1 3 4]);
    end
end
end