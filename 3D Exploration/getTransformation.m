function [ matrixOut, stepMatrix ] = getTransformation( startCoordinates, endCoordinates, steps, repetitions )
%GETTRANSFORMATION Takes start and end coordinates and generates 3d matrix between for n steps from one to the other
%% Create the 3d matrix for indexing
matrixOut = zeros(4, 4, steps);
%% 
for step = 1:steps
    
end
%% Repeat the transformation
if nargin == 4
    matrixOut = repmat(matrixOut, 1, 1, repetitions);
end
end