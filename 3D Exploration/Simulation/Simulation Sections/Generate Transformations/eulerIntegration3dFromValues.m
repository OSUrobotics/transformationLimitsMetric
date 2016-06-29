function [ ptsOut, positionTransformsVector, positionTransformsMatrix ] = eulerIntegration3dFromValues( values, pts, stepNums, translateScalar)
%%EULERINTEGRATION3DFROMVALUES interpolates between origin and a given set of transformation values
% INPUTS:
% values(x,y,z,xN,yN,zN,w): the transformation from origin intended, given in x,y,z translation and rotation about the xN,yN,zN axis w raidans
% pts: the set of points to transform, with each row being one point
% stepNums: the number of interpolation steps to take between start and finish
% translateScalar: a number to scale the unit translation vector up by, useful when visualizing the function
% OUTPUT:
% ptsOut: a 3d matrix with size [number of pts, 3, stepNums], with each index in the stepNums dimension being a frame of translation
% positionTransformsVector: a 2d matrix with size [7, stepNums], which has, in order of row, x, y, z translation values to get from the origin to that step, then a 4 long quaternion which details the rotation transformation from natural position. The order of application to reproduce the points at a given step is rotation then translation
% positionTransformsMatrix: a 3d matrix with size [4, 4, stepNums], detailing the transformation matrix to get from origin to that step of the animation, to be multiplied after the vertical points list 

%% Apply the scalar to the translation values
values(1:3) = translateScalar*values(1:3);
%% Get the step transformation matrix
% Rotates around the axis then translates
stepMatrix = makehgtform('translate',values(1:3)*1/stepNums,'axisrotate',values(4:6),values(7)*1/stepNums).';
%% Establish the finish points matrix
ptsOut = ones(size(pts,1),4,stepNums); % Done strange so padding 1 for 4x4 transformations
ptsOut(:,1:3,1) = pts;
%% Setting up to get the location and orientation
positionTransformsMatrix = zeros(4,4,stepNums);
positionTransformsMatrix(:,:,1) = eye(4);
positionTransformsVector = zeros(7,stepNums);
%% Apply the matrix iteratively to the pts
for stepIndex = 2:stepNums
    ptsOut(:,:,stepIndex) = ptsOut(:,:,stepIndex-1)*stepMatrix;
    %% Figure out the transformation to get there
    positionTransformsMatrix(:,:,stepIndex) = (positionTransformsMatrix(:,:,stepIndex-1)*stepMatrix);
    positionTransformsVector(1:4,stepIndex) = positionTransformsMatrix(:,:,stepIndex)'*[0;0;0;1]; % Get the XYZ translation for the step    
    positionTransformsVector(4:7,stepIndex) = dcm2quat(positionTransformsMatrix(1:3,1:3,stepIndex)'); 
end
%% Remove the unneeded 1 column used for transformations
ptsOut = ptsOut(:,1:3,:);
end