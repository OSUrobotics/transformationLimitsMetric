function [ transformationStruct ] = saveTrajectories( numTranslationDirections, numRotationAxes, numAngleDivisions, numInterpolationSteps, translateScalar, filename, divisionRange)
%% SAVETRAJECTORIES Uses the other functions to generate and save a 4D matrix with all of the transformations interpolated
% 
%% Make a parpool 
p = gcp('nocreate');
if isempty(p)
    parpool(8);
end
%% Generate the trajectories interpolated along
values = generateTrajectories(numTranslationDirections, numRotationAxes, numAngleDivisions);
%% If want subselection, apply it here
if nargin == 7
    values = values(:,divisionRange);
end
%% Prepare for and loop through creating the steps
trajectorySteps = zeros(4,4,numInterpolationSteps,size(values,2));
parfor transformIndex = 1:size(values,2)
    trajectorySteps(:,:,:,transformIndex) = trajectoryStepsEXPM(values(:,transformIndex),numInterpolationSteps,translateScalar);
    fprintf('Done with value set #%i/%i\n',transformIndex,size(values,2));
end
%% Save to structure
transformationStruct = struct;
transformationStruct.numTranslationDirections = numTranslationDirections;
transformationStruct.numRotationAxes = numRotationAxes;
transformationStruct.numAngleDivisions = numAngleDivisions;
transformationStruct.numInterpolationSteps = numInterpolationSteps;
transformationStruct.translateScalar = translateScalar;
transformationStruct.trajectorySteps = trajectorySteps;
transformationStruct.values = values;
%% Save to file
save([filename '.mat'],'transformationStruct','-mat');
end