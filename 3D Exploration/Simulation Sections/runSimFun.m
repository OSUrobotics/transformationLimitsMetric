function [ outputMatrix ] = runSimFun( transformationStruct, objectV, objectF, handV, handF, objectVoxelResolution, pmDepth, pmScale, outputFilePath )
%RUNSIMULATION Creates data representing a grasp
%   Loads an object PLY file, a pre-positioned hand STL, and some settings 
%   and returns the area overlap of the two objects at evenly distributed 
%   transformations.
%% Get the object voxels based on the voxel resolution
objectVox = getVoxelisedVerts(objectV,objectF,objectVoxelResolution);
%% Apply the saved transformations to the voxels and vertices
ptsOut = applySavedTransformations(transformationStruct.trajectorySteps,objectV,true);
voxOut = applySavedTransformations(transformationStruct.trajectorySteps,objectVox,true);
disp('Applied transformations');
%% Declare variables for output generation
volumeIntersecting = zeros(size(transformationStruct.values,2),transformationStruct.numInterpolationSteps);
numValues = size(transformationStruct.values,2);
%% Test origin case
volumeOrigin = getPercentCollisionWithVerts(objectV,objectVox,handV,handF,objectVoxelResolution,pmDepth,pmScale);
fprintf('Volume at origin: %f\n',volumeOrigin);
%% Compare with voxel method
volumeVoxels = getCollisionVoxelVoxel(handVox,objectVox,objectV,objectSurfaceArea,resolution,'cubic');

%% Loop and test all other cases
for stepIndex = 2:transformationStruct.numInterpolationSteps % Indexing from 2 to remove unnneeded origin case
    for valueIndex = 1:numValues
        volumeIntersecting(valueIndex,stepIndex) = getPercentCollisionWithVerts(ptsOut(:,:,stepIndex,valueIndex),voxOut(:,:,stepIndex,valueIndex),handV,handF,objectVoxelResolution,pmDepth,pmScale);
    end
    fprintf('Done with step %i\n',stepIndex);
end
%% Concatenate with the step values
outputMatrix = [transformationStruct.stepValues; permute(volumeIntersecting,[3 1 2])];
%% Remap output to timestamp pages
outputMatrix = permute(outputMatrix,[2 1 3]);
%% Save to file
for i = 2:size(outputMatrix,3)
    outputTable = array2table(outputMatrix(:,:,i), 'VariableNames', {'X_Translation','Y_Translation','Z_Translation','Axis_X','Axis_Y','Axis_Z','Angle_Rotated','Percent_Volume_Intersection'});
    writetable(outputTable, sprintf(outputFilePath,i-1));
    fprintf('File written for time %i\n',i-1);
end
end