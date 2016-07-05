function saveTrajectories( numTranslationDirections, numRotationAxes, numAngleDivisions, numInterpolationSteps, translateScalar, filename)
%% SAVETRAJECTORIES Uses the other functions to generate and save a 4D matrix with all of the transformations interpolated
%   
%% Generate the trajectories interpolated along
values = generateTrajectories(numTranslationDirections, numRotationAxes, numAngleDivisions);
%% Prepare for and loop through creating the steps
trajectorySteps = zeros(4,4,numInterpolationSteps,size(values,1));
for transformIndex = 1:size(values,1)
    trajectorySteps(:,:,:,transformIndex) = trajectoryStepsEXPM(values(transformIndex,:),numInterpolationSteps,translateScalar);
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

