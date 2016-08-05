function [ outputMatrix ] = generateTrajectories( directionPoints, orientationPoints, angleDistribution )
%% GENERATETRAJECTORIES Returns a list of evenly distributed trajectories with rotation aspects for the basis of the saveTrajectories and trajectory stepping with the EXPM functions
%==========================================================================
%
% USAGE
%       [ outputMatrix ] = makeTransformationValues( directionPoints, orientationPoints, angleDistribution )
%
% INPUTS
%
%       directionPoints     - Mandatory - Integer Value     -Number of direction values desired
%
%       orientationPoints   - Mandatory - Integer Value     -Number of axes to rotate around desired
%
%       angleDistribution   - Mandatory - Vector Value      -What angles to rotate the object by around each axis on a -1 to 1 scale
%
% OUTPUTS
%
%       outputMatrix        - Mandatory - Nx7 array         -List of transformations sampled evenly, where N is the number of transformations
%
% REFERENCES
%
%   -This code uses SpiralSampleSphere by Anton Semechko
%
%==========================================================================

%% Make the translation vectors using a uniform sphere and a case for no movement
translateVectors = SpiralSampleSphere(directionPoints-1).';
translateVectors = [translateVectors [0;0;0]];
%% Make a set of normal vectors using a sphere
normalVectors = SpiralSampleSphere(orientationPoints).';
%% Make the angle values for the angle rotation
angleRotations = pi*angleDistribution;
%% Combine them into the possible combinations
outputMatrix = combvec(translateVectors,normalVectors,angleRotations);
end
