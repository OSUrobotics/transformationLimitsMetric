function [ outputMatrix ] = runSimFun( transformationStruct, objectVox, objectSV, handVox, objectVoxelResolution, surfArea, outputFilePath )
%RUNSIMULATION Creates data representing a grasp
%   Loads an object PLY file, a pre-positioned hand STL, and some settings
%   and returns the area overlap of the two objects at evenly distributed
%   transformations.
%
%==========================================================================
%
% USAGE
%       [ outputMatrix ] = runSimFun( transformationStruct, objectVox, objectSV, handVox, objectVoxelResolution, surfArea, outputFilePath )
%
% INPUTS
%
%       transformationStruct    - Mandatory - Struct            -A transformationStruct variable (As created by generateTrajectories
%
%       objectVox               - Mandatory - Nx3 Matrix        -List of vertex data representing a set of voxel points inside the object where N is the number of vertices
%
%       objectSV                - Mandatory - Nx3 Matrix        -List of vertex data representing a set of points evenly distrubuted on the surface of the object where N is the number or vertices
%
%       handVox                 - Mandatory - Nx4 Matrix        -List of voxel data where the first 3 columns represent the x, y, and z locations of the voxels and the 4th column is a logical value where 1 means the point is inside the hand and 0 means the point is outside
%
%       objectVoxelResolution   - Mandatory - Integer Value     -The resolution passed to getVoxelisedVerts when generating objectVox
%
%       surfArea                - Mandatory - Double Value      -The surface area of the object
%
%       outputFilePath          - Mandatory - Filepath String   -Path to the folder you would like the simulation data to be saved in
%
% OUTPUTS
%
%       outputMatrix            - Mandatory - Nx8 Matrix        -Matrix containing all the simulation output data (x,y,z,q1,q2,q3,q4,col)
%
%==========================================================================
%% Declare variables for output generation
volumeIntersecting = zeros(size(transformationStruct.values,2),transformationStruct.numInterpolationSteps);
numValues = size(transformationStruct.values,2);
%% Test origin case
volumeOrigin = getCollisionVoxelVoxel(handVox,objectVox,objectSV,surfArea,objectVoxelResolution,'cubic');
fprintf('Volume at origin: %f\n',volumeOrigin);
%% Loop and test all other cases
indWhich = 1;
for stepIndex = 2:transformationStruct.numInterpolationSteps % Indexing from 2 to remove unnneeded origin case
    for valueIndex = 1:numValues
        %% Apply the saved transformations to the voxels and vertices
        ptsOut = applySavedTransformation(transformationStruct.trajectorySteps,indWhich,objectSV,true);
        voxOut = applySavedTransformation(transformationStruct.trajectorySteps,indWhich,objectVox,true);
        volumeIntersecting(valueIndex,stepIndex) = getCollisionVoxelVoxel(handVox,voxOut,ptsOut,surfArea,objectVoxelResolution,'cubic');
        indWhich = indWhich + 1;
    end
    fprintf('Done with step %i\n',stepIndex);
end
%% Concatenate with the step values
outputMatrix = [transformationStruct.stepValues; permute(volumeIntersecting,[3 1 2])];
%% Remap output to timestamp pages
outputMatrix = permute(outputMatrix,[2 1 3]);

%% Save to file
strNames = cell(1, 7 + transformationStruct.numInterpolationSteps - 1);
strNames(1,1:7) = {'X_Translation','Y_Translation','Z_Translation','Quat_1','Quat_2','Quat_3','Quat_4'};
for i = 1:transformationStruct.numInterpolationSteps - 1
    strNames{1,7+i} = sprintf('Step%i', i+1);
end

outputData = zeros( size(transformationStruct.stepValues,2), size(transformationStruct.stepValues,1) + transformationStruct.numInterpolationSteps - 1);
outputData(:,1:7) = squeeze( transformationStruct.stepValues(:,:,end)' );
outputData(:,8:end) = volumeIntersecting(:,2:end);

outputTable = array2table(outputData, 'VariableNames', strNames);
writetable(outputTable, outputFilePath);
% for i = 2:size(outputMatrix,3)
%     outputTable = array2table(outputMatrix(:,:,i), 'VariableNames', {'X_Translation','Y_Translation','Z_Translation','Quat_1','Quat_2','Quat_3','Quat_4','Intersection'});
%     writetable(outputTable, sprintf(outputFilePath,i-1));
% end
disp('Files written');
end