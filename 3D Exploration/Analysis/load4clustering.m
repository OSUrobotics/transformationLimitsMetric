function [ matrixOut, matrixFlattened, names, collisionTime ] = load4clustering( directory, numValues )
%% LOAD4CLUSTERING Takes in a directory name and returns a list of values for the data in that folder
%==========================================================================
%
% USAGE
%       [ matrixOut, matrixFlattened, names, collisionTime ] = load4clustering( directory, numValues )
%
% INPUTS
%
%       directory   - Mandatory - Filepath String   - Path to the folder that contains all of the output csv files you want to give to kmeans
%
%       numValues   - Mandatory - Integer Value     - Number of collision values recorded per step
%
% OUTPUTS
%
%       matrixOut           - NxM Matrix            - Array of collision values where N is the number of unique grasps and M is the number of values per step * number of steps
%       
%       matrixFlattened     - NxM Matrix            - An array of processed data, raw data found in matrixOut. Comes in the form of normalized to one values, where after surpassing a threshold, later steps are automatically set to that threshold, then normalized
%
%       names               - Nx1 Cell Array        - List of unique grasp names organized by row to match up with matrixOut (The values in the first row of matrixOut coorespond to the name in the first row of names)
%
%       collisionTime       - NxP Matrix            - Array featuring the step timestamp of collision above a threshold. 
%
% EXAMPLE
%
%       To prepare all the grasps in a folder called 'Output' where each step has 588 values:
%       >>  [ matrixOut, matrixFlattened, names, collisionTime ] = load4clustering( 'Output', 588 )
%
% NOTES
%
%   -All the files must have the same number of values per step
%
%==========================================================================
%% Load in the directory files
dirOut = dir(directory);
names = {dirOut.name};
names = names(3:end); % Prune . and ..
%% Get the step-rest-of-string linking
noStep = cell(length(names),2);
for nameIndex = 1:length(names)
    noStep(nameIndex,:) = textscan(names{nameIndex},'Step%d%s');
end
%% Simplify array down
names = unique([noStep{:,2}]);
numSteps = max([noStep{:,1}]);
%% Get objects ids out
noStep = cell(length(names),2);
for nameIndex = 1:length(names)
    noStep(nameIndex,:) = textscan(names{nameIndex},'obj%d%s');
end
%% Simplify array down
objectNums = [noStep{:,1}];
%% Sort the names based upon object number
[objectNums,sortObjs] = sort(objectNums);
names = names(sortObjs);
%% Preallocate an array for storing values
matrixOut = zeros(length(names),numValues,numSteps);
%% Loop through each grasp scenario and append all their collision values 
%  into one long vector, then stack the scenarios on top of each other.
for uniqueNameIndex = 1:length(names)
    %% Get the filenames for that grasp system
    files = dir(sprintf('Output/*%s',names{uniqueNameIndex}));
    usedFiles = {files.name};
    %% Loop through steps, loading each file and saving the data in the row
    for currentStep = 1:numSteps
        currentVector = table2array(readtable(sprintf('Output/%s', ...
                                                     usedFiles{currentStep})));
        matrixOut(uniqueNameIndex,1:numValues,currentStep) ...
                     = currentVector(:,8);
    end
end
%% Get the corresponding object threshold, as defined in obj_dict.csv, or in user input
objectLinking = table2cell(readtable('handAndAlignment/obj_dict.csv'));
%% Get the collision step number and save that information
collisionTime = zeros(size(matrixOut,1),numValues);
matrixFlattened = matrixOut;
for system = 1:size(matrixOut,1)
    threshold = objectLinking{[objectLinking{:,1}] == objectNums(system),5};
    for direction = 1:numValues
        %% Do the collision thresholding indexing 
        where = find(matrixOut(system,direction,:) >= threshold,1);
        if isempty(where)
            where = numSteps+1;
        end
        collisionTime(system,direction) = where;
    end
    %% Do the flattening after first occurance
    stepLogical = false(length(names),numValues,numSteps);
    stepLogical(system,:,1) = matrixOut(system,:,1) >= threshold;
    for step = 2:numSteps
        stepLogical(system,:,step) = matrixOut(system,:,step) >= threshold | stepLogical(system,:,step-1);
    end
    matrixFlattened(stepLogical) = threshold;
	matrixFlattened(system,:,:) = matrixFlattened(system,:,:)/threshold;
end
%% Reorient names to match the collumns of matrixOut
names = names.';
%% Reshape matrixOut into expected form
matrixOut = reshape(matrixOut,length(names),[]);
matrixFlattened = reshape(matrixFlattened,length(names),[]);
end