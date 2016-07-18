function [ outputMatrix ] = runSimFun( transformationStruct, objectVox, objectSV, handVox, objectVoxelResolution, surfArea, outputFilePath )
%RUNSIMULATION Creates data representing a grasp
%   Loads an object PLY file, a pre-positioned hand STL, and some settings 
%   and returns the area overlap of the two objects at evenly distributed 
%   transformations.
%% Apply the saved transformations to the voxels and vertices
ptsOut = applySavedTransformations(transformationStruct.trajectorySteps,objectSV,true);
voxOut = applySavedTransformations(transformationStruct.trajectorySteps,objectVox,true);
disp('Applied transformations');
%% Declare variables for output generation
volumeIntersecting = zeros(size(transformationStruct.values,2),transformationStruct.numInterpolationSteps);
numValues = size(transformationStruct.values,2);
%% Test origin case
volumeOrigin = getCollisionVoxelVoxel(handVox,objectVox,objectSV,surfArea,objectVoxelResolution,'cubic');
fprintf('Volume at origin: %f\n',volumeOrigin);
%% Loop and test all other cases
for stepIndex = 2:transformationStruct.numInterpolationSteps % Indexing from 2 to remove unnneeded origin case
    parfor valueIndex = 1:numValues
        volumeIntersecting(valueIndex,stepIndex) = getCollisionVoxelVoxel(handVox,voxOut(:,:,stepIndex,valueIndex),ptsOut(:,:,stepIndex,valueIndex),surfArea,objectVoxelResolution,'cubic');
    end
    fprintf('Done with step %i\n',stepIndex);
end
%% Concatenate with the step values
outputMatrix = [transformationStruct.stepValues; permute(volumeIntersecting,[3 1 2])];
%% Remap output to timestamp pages
outputMatrix = permute(outputMatrix,[2 1 3]);
%% Save to file
for i = 2:size(outputMatrix,3)
    outputTable = array2table(outputMatrix(:,:,i), 'VariableNames', {'X_Translation','Y_Translation','Z_Translation','Quat_1','Quat_2','Quat_3','Quat_4','Intersection'});
    writetable(outputTable, sprintf(outputFilePath,i-1));
end
disp('Files written');
end