function [ valuesOut ] = matrix2values( matrixIn )
%% MATRIX2VALUES A small function that takes a 4x4xN matrix in and returns a 7xN matrix of the x,y,z,rotation axis, and rotation angle for each N step
%   
%% Get and zero the translation values
valuesOut(1:3,:) = matrixIn(1:3,4,:);
matrixIn(1:3,4,:) = 0;
%% Remaining matrix to quaternion
quaternion = dcm2quat(matrixIn(1:3,1:3,:));
%% Quaternion to axis angle
valuesOut(7,:) = 2 * acos(quaternion(:,1));
valuesOut(4,:) = -quaternion(:,2)./sqrt(1-quaternion(:,1).^2); % negative to account for difference in the formats
valuesOut(5,:) = -quaternion(:,3)./sqrt(1-quaternion(:,1).^2);
valuesOut(6,:) = -quaternion(:,4)./sqrt(1-quaternion(:,1).^2);
end

