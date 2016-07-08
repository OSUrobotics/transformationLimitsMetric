function [ handV, handF, objectV, objectF ] = loadHandObject( handFilepath, objectTransformationFilepath, objectFilepath, handSpreadDistance, handRelativeCenter, circleRadius)
%% LOADHANDOBJECT Summary of this function goes here
%   Detailed explanation goes here

%% Read in data
[handV, handF] = stlRead(handFilepath);
[objectV, objectF] = read_ply(objectFilepath);
transformationMatrix = csvread(objectTransformationFilepath);
objectV = (transformationMatrix*(objectV.')).';
%% Calculate relative center if none given
if nargin == 5
	handRelativeCenter = [0 0 handSpreadDistance/(2*pi)]; 
end
%% Transform object and hand to new center
objectV = objectV - repmat(handRelativeCenter,[size(objectV,1) 1]);
handV = handV - repmat(handRelativeCenter,[size(handV,1) 1]);

%% Define a scale matrix based on the ratio of sphere cross section diameter over handSpreadDistance
transformationMatrix = makehgtform('scale', ...
                      (2*sqrt(circleRadius^2-handRelativeCenter(3)^2)) / ...
                       handSpreadDistance);
%% Apply scale transformation
objectV = (transformationMatrix*(objectV.')).';
handV = (transformationMatrix*(handV.')).';
end