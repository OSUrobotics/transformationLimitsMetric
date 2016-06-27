function [ matrixOut, locations ] = local2globalTransformations( stepMatrix, startPoint, steps, origin )
%local2globalTransformations repeats local transformation n times and converts the matrices from local to global transformations
% stepMatrix: the 4x4 matrix transformation that is repeated
% startPoint: the given location of the object before transformation
% steps: the number of iterations applied to the transformation
% origin: default (0,0,0,0,0,0), where to give the transformations relative to
%% Create the 3d matrix for indexing
matrixOut = zeros(4, 4, steps);
%% 
for step = 1:steps
    
end
end