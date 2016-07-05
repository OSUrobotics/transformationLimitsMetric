function [ ptsTransformed ] = applySavedTransformations( transformsFilename, pts, vertical )
%% APPLYSAVEDTRANSFORMATIONS takes saved transformation steps and applies them to create a multi-dimensional indexed set of points
%   Detailed explanation goes here
%% Read in and reshape to proper size
read([transformsFilename '.mat']);
transformSteps = transformsFilename;
%% Reformat pts if not in the right dimensions to be horizontal and pad
if size(pts,2) == 3 && size(pts,1) ~= 3 % if in a vertical format
    pts = pts.';
end
pts = [pts; ones(1,size(pts,2))];
%% Initialize matrix for output
ptsTransformed = zeros(4,size(pts,2),size(transformSteps,3));
%% Loop and apply the transformation
for stepIndex = 1:size(transformSteps,3)
    ptsTransformed(:,:,stepIndex) = transformSteps(:,:,stepIndex) * pts;
end
%% Remove padding and reformat if wanted
ptsTransformed = ptsTransformed(1:3,:,:);
if nargin == 3
    if vertical
        ptsTransformed = permute(ptsTransformed,[2 1 3]);
    end
end
end