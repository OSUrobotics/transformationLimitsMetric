function [ ptsOutEXPM, positionTransformsEXPM ] = eulerIntegration3dFromValuesEXPM( values, pts, stepNums, translateScalar)
%% EULERINTEGRATION3DFROMVALUESEXPM interpolates between origin and a given set of transformation values
%==========================================================================
%
% USAGE
%       [ ptsOut, positionTransformsVector, positionTransformsMatrix ] = eulerIntegration3dFromValues( values, pts, stepNums, translateScalar)
%
% INPUTS
%
%       values          - Mandatory - Vector (x,y,z,xN,yN,zN,w) - The transformation from origin intended, given in x,y,z translation and rotation about the xN,yN,zN axis w raidans
%
%       pts             - Mandatory - Nx3 Array                 - The set of points to transform, with each row being one point
%
%       stepNums        - Mandatory - Integer Value             - The number of interpolation steps to take between start and finish
% 
%       translateScalar - Mandatory - Float Value               - A number to scale the unit translation vector up by, useful when visualizing the function
% 
% OUTPUT:
%
%       ptsOut                      - Mandatory - Nx3xS Array   - a 3d matrix with size [number of pts, 3, stepNums], 
%                                                                 with each index in the stepNums dimension being 
%                                                                 a frame of translation
%
%       positionTransformsVector    - Mandatory - 7xS Array     - A 2d matrix with size [7, stepNums], which has, 
%                                                                 in order of row, x, y, z translation values to 
%                                                                 get from the origin to that step, then a 4 long 
%                                                                 quaternion which details the rotation transformation 
%                                                                 from natural position. The order of application to reproduce 
%                                                                 the points at a given step is rotation then translation
%
%       positionTransformsMatrix    - Mandatory - 4x4xS Array   - A 3d matrix with size [4, 4, stepNums], detailing the 
%                                                                 transformation matrix to get from origin to that 
%                                                                 step of the animation, to be multiplied after the vertical points list
%==========================================================================
%% Apply the scalar to the translation values
values(1:3) = translateScalar*values(1:3);
%% Establish the finish points matrix
ptsOutEXPM = ones(4,size(pts,1),stepNums); % Done strange so padding 1 for 4x4 transformations
ptsOutEXPM(1:3,:,1) = pts';
%% Setting up to get the location and orientation
positionTransformsEXPM = zeros(4,4,stepNums);
%% Apply the matrix iteratively to the pts
for stepIndex = 1:stepNums
    currentFactor = (stepIndex-1)/stepNums;
    disp();
    positionTransformsEXPM(:,:,stepIndex) = expm([0 -values(6)*values(7)*currentFactor values(5)*values(7)*currentFactor values(1)*currentFactor;values(6)*values(7)*currentFactor 0 -values(4)*values(7)*currentFactor values(2)*currentFactor;-values(5)*values(7)*currentFactor values(4)*values(7)*currentFactor 0 values(3)*currentFactor; 0 0 0 0]);
    ptsOutEXPM(:,:,stepIndex) = positionTransformsEXPM(:,:,stepIndex)*ptsOutEXPM(:,:,1);
end
%% Remove the unneeded 1 column used for transformations
ptsOutEXPM = permute(ptsOutEXPM(1:3,:,:),[2 1 3]);
end