function [ valuesOut ] = matrix2values( matrixIn )
%% MATRIX2VALUES A small function that takes a 4x4xN matrix in and returns a 7xN matrix of the x,y,z,and quaternion for each N step
%   
%% Get and zero the translation values
valuesOut(1:3,:) = matrixIn(1:3,4,:);
%% Remaining matrix to quaternion
valuesOut(4:7,:) = dcm2quat(matrixIn(1:3,1:3,:))';
end