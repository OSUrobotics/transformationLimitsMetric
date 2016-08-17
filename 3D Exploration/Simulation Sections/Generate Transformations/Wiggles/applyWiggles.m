function [ output_args ] = applyWiggles()
%APPLYWIGGLES Summary of this function goes here
%% Load the wiggle vectors in
load('wigglesStored.mat');
%% Prepare for and loop through creating the steps
trajectorySteps = zeros(4,4,size(wiggles,2));
numValues = size(wiggles,2);
stepValues = zeros(7,numValues,transformationStruct.numInterpolationSteps);
parfor transformIndex = 1:numValues
    trajectorySteps(:,:,:,transformIndex) = trajectoryStepsEXPM(wiggles(:,transformIndex),numInterpolationSteps,translateScalar);
    stepValues(:,transformIndex,:) = matrix2values(trajectorySteps(:,:,:,transformIndex));
end
pts = [pts; ones(1,size(pts,2))];
%% Initialize matrix for output
ptsTransformed = zeros(4,size(pts,2),size(transformations,3),size(transformations,4));
%% Loop through value sets
for stepIndex = 1:size(transformations,3)
    parfor valueIndex = 1:size(transformations,4)
        ptsTransformed(:,:,stepIndex,valueIndex) = transformations(:,:,stepIndex,valueIndex)*pts;
    end
end
end

