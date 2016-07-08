% function [ output_args ] = visualizeSphere( input_args )
%VISUALIZESPHERE Summary of this function goes here
%   Detailed explanation goes here
%% Declare variables
numSteps = 1:9;
collisionThreshold = 0.00;
objectScaleFactor = 5;
handScaleFactor = 15;
dataFilePath = 'Output/S%iAreaIntersection.csv';
%% Read data and assign to matrix
for step = numSteps
    fromTable = readtable(sprintf(dataFilePath,step));
    data = table2array(fromTable);
    transformations(:,:,step) = data(:,:);
end
disp('Filtered and realigned transformations');
%% Get indexes of first occurance
transformationsFiltered = transformations;
for rowNum = 1:size(transformations,1)
    transformationsFiltered(rowNum,:,find(transformations(rowNum,8,:) > collisionThreshold,1):end) = 0;
end
%% Display the filtered transformations?
transformationsFiltered = permute(transformationsFiltered,[1 3 2]);
xFiltered = transformationsFiltered(:,:,1); xFiltered = xFiltered(:);
yFiltered = transformationsFiltered(:,:,2); yFiltered = yFiltered(:);
zFiltered = transformationsFiltered(:,:,3); zFiltered = zFiltered(:);
scatter3(xFiltered,yFiltered,zFiltered,'k.');
axis image;
%% Quiver?
figure;
quiver3(zeros(size(xFiltered)),zeros(size(xFiltered)),zeros(size(xFiltered)),xFiltered,yFiltered,zFiltered);
axis image;
%end