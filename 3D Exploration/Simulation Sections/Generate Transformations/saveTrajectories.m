function [ transformationStruct ] = saveTrajectories( transformationStruct, filename, divisionRange, structName)
%% SAVETRAJECTORIES Uses the other functions to generate and save a 4D matrix with all of the transformations interpolated
%==========================================================================
%
% INPUTS:
%
%     transformationStruct.numTranslationDirections     - Mandatory - Integer Value     - How many directions to translate the object in, excluding rotation, when defining the values for the possible transformations
% 
%     transformationStruct.numRotationAxes              - Mandatory - Integer Value     - How many axes to rotate the object around when defining the values for the possible transformations
% 
%     transformationStruct.angleDivisions               - Mandatory - 1xN Vector        - The angle amounts for rotation around each axis, given in a -1 to 1 range which is then mapped to -pi to pi. 
% 
%     transformationStruct.numInterpolationSteps        - Mandatory - Integer Value     - The number of steps in the "animation", how many interpolated stages of the transformation are returned. 
% 
%     transformationStruct.translateScalar              - Optional  - Double Value      - The length of the interpolation path. Is roughly similar to the distance away from the origin which the object is transformed to. By default = 1.
% 
%     filename                                          - Optional  - String            - Saves to a mat file with this name, if included. Enter the string relative to the current directory and without the .mat extension, that is added later. When not included just outputs the structure. 
% 
%     divisionRange                                     - Optional  - 1xN Vector        - Saves the trajectories for only those value sets, if you select 1:100 or [1 2 5:60] it will only return the transformations for that subselection of total values. When not included saves all value sets. 
%
%     structName                                        - Optional  - String            - If the output is stored (filename exists), rename the structure in the file to this name, or default to transformationStruct.
% 
% OUTPUT: 
%
%   TRANSFORMATIONSTRUCT                                - Mandatory - Struct
%     tS.numTranslationDirections                       - Input repeated
%     tS.numRotationAxes                                - Input repeated
%     tS.angleDivisions                                 - Input repeated
%     tS.numInterpolationSteps                          - Input repeated
%     tS.translateScalar                                - Input repeated
%     tS.trajectorySteps                                - The master matrix in 4D which saves in the first 2 dimensions the 4x4 transformation matrix to get to that given step for that value, with the 3rd dimension indicating the transformation step, and the 4th dimension indicating which value set is being used in the interpolation. 
%     tS.values                                         - The outcome values based on the input settings, the end location for each possible transformaton tested, the basis of the interpolation. 
%     tS.stepValues                                     - The x,y,z position, then quaternion for a 7 value long translated position at a given step from the origin. Stored in a 7x(# values)x(# interpolation steps) matrix. 
%
%==========================================================================
%% Generate the trajectories interpolated along
values = generateTrajectories(transformationStruct.numTranslationDirections,transformationStruct.numRotationAxes,transformationStruct.angleDivisions);
%% If want subselection, apply it here
if nargin == 4
    values = values(:,divisionRange);
end
%% If no name given, use default name
if nargin <= 3
    structName = 'transformationStruct';
end
%% Set default translateScalar
if ~isfield(transformationStruct,'translateScalar');
    transformationStruct.translateScalar = 1;
end
%% Pass variables out of the transformationStruct
numInterpolationSteps = transformationStruct.numInterpolationSteps;
translateScalar = transformationStruct.translateScalar;
%% Prepare for and loop through creating the steps
trajectorySteps = zeros(4,4,transformationStruct.numInterpolationSteps,size(values,2));
numValues = size(values,2);
stepValues = zeros(7,numValues,transformationStruct.numInterpolationSteps);
for transformIndex = 1:numValues
    trajectorySteps(:,:,:,transformIndex) = trajectoryStepsEXPM(values(:,transformIndex),numInterpolationSteps,translateScalar);
    stepValues(:,transformIndex,:) = matrix2values(trajectorySteps(:,:,:,transformIndex));
end
%% Save to structure
transformationStruct.trajectorySteps = trajectorySteps;
transformationStruct.values = values;
transformationStruct.stepValues = stepValues;
%% Save to file if included
if nargin >= 2
    %% Rename structure if name specified
    eval([structName ' = transformationStruct;']);
	save([filename '.mat'],structName,'-mat');
end
end