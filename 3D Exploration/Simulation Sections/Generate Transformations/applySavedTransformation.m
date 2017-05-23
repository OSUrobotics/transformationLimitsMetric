function [ ptsTransformed ] = applySavedTransformation( transformations, indexWhich, pts, verticalOut )
%% APPLYSAVEDTRANSFORMATIONS takes saved transformation steps and applies them to create a multi-dimensional indexed set of points
%   Uses the transformationStruct and applies the transformations contained to a set of points, with an option to return in vertical list format or horizontal list format, defaulting to horizontal
%==========================================================================
%
% USAGE
%       [ ptsTransformed ] = applySavedTransformations( transformations, pts, verticalOut )
%
% INPUTS
%
%       transformations     - Mandatory - Filepath String   -Path to a transformationStruct .mat file
%
%       indexWhich          - Mandatory - integer           -Which  transformation to apply
%
%       pts                 - Mandatory - Nx3 Matrix        -List of vertex data representing a mesh where N is the number of vertices
%
%       verticalOut         - Optional  - Logical Value     -If true output the ptsTransformed as a vertical matrix
%
% OUTPUTS
%
%       ptsTransformed      - Mandatory - Nx3xM Matrix      -List of vertex data where N is the number of vertices per transformed mesh and M is the number of meshes
%
%==========================================================================

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
ptsTransformed = zeros(4,size(pts,2));
%% Loop through value sets
stepIndex = floor( (indexWhich-1) / size(transformations,4) ) + 1; 
valueIndex = mod( (indexWhich-1), size(transformations,4) ) + 1; 
ptsTransformed(:,:) = transformations(:,:,stepIndex,valueIndex)*pts;

%% Remove padding and reformat if wanted
ptsTransformed = ptsTransformed(1:3,:);
if nargin == 4 && verticalOut
    ptsTransformed = ptsTransformed';
end
end
