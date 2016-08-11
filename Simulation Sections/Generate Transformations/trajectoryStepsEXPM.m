function [ transformations4x4xN ] = trajectoryStepsEXPM( values, stepNums, translateScalar)
%% TRAJECTORYSTEPSEXPM interpolates between origin and a given set of transformation values using EXPM, a better yet slower mathematical model, outputting 4x4 transformation matrix. Called by saveTrajectories.
%==========================================================================
%
% USAGE
%       [ transformations4x4xN ] = trajectoryStepsEXPM( values, stepNums, translateScalar)
%
% INPUTS
%
%       values                      - Mandatory - Vector (x,y,z,xN,yN,zN,w) - The transformation from origin intended, given in x,y,z translation and rotation about the xN,yN,zN axis w raidans
%
%       stepNums                    - Mandatory - Integer Value             - The number of interpolation steps to take between start and finish
% 
%       translateScalar             - Mandatory - Float Value               - A number to scale the unit translation vector up by, useful when visualizing the function
% 
% OUTPUT:
%
%       positionTransformsMatrix    - Mandatory - 4x4xN Matrix  - The main output, gets the steps between origin and position indicated by Values, in the form of a 3d matrix with each page being a step in the transformation between the two, to get to that step from the initial position 
%==========================================================================
%% Apply the scalar to the translation values
values(1:3) = translateScalar*values(1:3);
%% Normalize the rotation axis vector
angleValues = values(4:6)/norm(values(4:6));
%% Setting up to get the location and orientation
transformations4x4xN = zeros(4,4,stepNums);
%% Apply the matrix iteratively to the pts
for stepIndex = 1:stepNums
    currentFactor = (stepIndex-1)/(stepNums);
    transformations4x4xN(:,:,stepIndex) = expm([0 -angleValues(3)*values(7)*currentFactor angleValues(2)*values(7)*currentFactor values(1)*currentFactor;...
        angleValues(3)*values(7)*currentFactor 0 -angleValues(1)*values(7)*currentFactor values(2)*currentFactor;...
        -angleValues(2)*values(7)*currentFactor angleValues(1)*values(7)*currentFactor 0 values(3)*currentFactor;...
        0 0 0 0]);
end
end

