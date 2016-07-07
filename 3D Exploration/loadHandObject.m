function [ handV, handF, objectV, objectF ] = loadHandObject( handFilepath, objectTransformationFilepath, objectFilepath, handSpreadDistance, handRelativeCenter)
%% LOADHANDOBJECT Summary of this function goes here
%   Detailed explanation goes here
[handV, handF] = stlRead(handFilepath);
[objectV, objectF] = read_ply(objectFilepath);
transformationMatrix = csvread(objectTransformationFilepath);
objectV = (transformationMatrix*(objectV.')).';
if nargin == 5
	handRelativeCenter = [0 0 handSpreadDistance/(2*pi)]; 
end
objectV = objectV + handRelative;
end