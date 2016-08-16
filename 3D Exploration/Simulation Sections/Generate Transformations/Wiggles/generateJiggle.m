function [ outputMatrix ] = generateJiggle(directionPoints, directionScalar, angleDistribution)
%% GENERATEJIGGLE Creates a set of small transformations given some input settings
%==========================================================================
%
% USAGE
%       [ outputMatrix ] = generateJiggle( directionPoints, directionScalar, angleDistribution)
%
% INPUTS
%
%       directionPoints     - Mandatory - Integer Value     -Number of direction values desired, also the number of rotation axes desired
%
%       directionScalar     - Mandatory - Integer Value     -How much to scale the translation by
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

%% Make the translation vectors using a uniform sphere
translateVectors = SpiralSampleSphere(directionPoints).';
% %% Subselect to those that only match the ranges for wiggle
% selectX = translateVectors(:,1) >= directionRange(1,1) & translateVectors(:,1) <= directionRange(2,1);
% selectY = translateVectors(:,2) >= directionRange(1,2) & translateVectors(:,2) <= directionRange(2,2);
% selectZ = translateVectors(:,3) >= directionRange(1,3) & translateVectors(:,3) <= directionRange(2,3);
% translateVectors = translateVectors(selectX & selectY & selectZ,:);
%% Make the angle values for the angle rotation
angleRotations = pi*angleDistribution;
%% Combine them into the possible combinations
outputMatrix = combvec(translateVectors,angleRotations);
%% Add in rotation vectors
outputMatrix = [outputMatrix(1:3,:)*directionScalar;outputMatrix(1:3,:);outputMatrix(4,:)];
%% Add in rotation no translation case
outputMatrix = [outputMatrix combvec([0;0;0],translateVectors,angleRotations)];
end
