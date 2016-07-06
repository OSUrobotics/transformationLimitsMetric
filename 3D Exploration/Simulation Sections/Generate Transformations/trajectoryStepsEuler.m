function [ transformations4x4xN ] = trajectoryStepsEuler( values, stepNums, translateScalar)
%% TRAJECTORYSTEPSEULER interpolates between origin and a given set of transformation values using the Euler method, a faster yet less accurate method
%==========================================================================
%
% USAGE
%       [ transformations4x4xN ] = trajectoryStepsEuler( values, stepNums, translateScalar)
%
% INPUTS
%
%       values          - Mandatory - Vector (x,y,z,xN,yN,zN,w) - The transformation from origin intended, given in x,y,z translation and rotation about the xN,yN,zN axis w raidans
%
%       stepNums        - Mandatory - Integer Value             - The number of interpolation steps to take between start and finish
% 
%       translateScalar - Mandatory - Float Value               - A number to scale the unit translation vector up by, useful when visualizing the function
% 
% OUTPUT:
%
%       positionTransformsMatrix    - Mandatory - 4x4xN Matrix  - The main output, gets the steps between origin and position indicated by Values, in the form of a 3d matrix with each page being a step in the transformation between the two, to get to that step from the initial position 
%==========================================================================

%% Apply the scalar to the translation values
values(1:3) = translateScalar*values(1:3);
%% Get the step transformation matrix
% Rotates around the axis then translates
stepMatrix = makehgtform('translate',values(1:3)*1/stepNums,'axisrotate',values(4:6),values(7)*1/stepNums);
%% Setting up to get the transformation
transformations4x4xN = zeros(4,4,stepNums);
transformations4x4xN(:,:,1) = eye(4);
% positionTransformsVector = zeros(7,stepNums);
%% Apply the matrix iteratively to the pts
for stepIndex = 2:stepNums
    %% Figure out the transformation to get there
    transformations4x4xN(:,:,stepIndex) = stepMatrix*transformations4x4xN(:,:,stepIndex-1);
    % positionTransformsVector(1:4,stepIndex) = transformations4x4xN(:,:,stepIndex)'*[0;0;0;1]; % Get the XYZ translation for the step    
    % positionTransformsVector(4:7,stepIndex) = dcm2quat(transformations4x4xN(1:3,1:3,stepIndex)'); 
end
end

