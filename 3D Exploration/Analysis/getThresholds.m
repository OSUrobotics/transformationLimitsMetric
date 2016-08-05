function [ objectDataCSV ] = getThresholds( directory, numValues, write )
%% GETTHRESHOLDS Loads in the data and plots it, then saves the thresholds generated somehow
%==========================================================================
%
% USAGE
%
%       [ objectDataCSV ] = getThresholds( directory, numValues, write )
%
% INPUTS
%
%       directory   - Mandatory - Filepath String   - Matrix containing cluster results in the form of cluster numbers
%
%       numValues   - Mandatory - Integer Value     - The number of values for each step of simulation data
%
%       write       - Mandatory - Logical Value     - If true will write output to handAndAlignment/obj_dict.csv
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
objectMatching = [noStep{:,1}];
%% Sort the names based upon object number
[objectMatching,sortObjs] = sort(objectMatching);
names = names(sortObjs);
%% Get the number of objects
objectList = unique(objectMatching);
%% Preallocate an array for storing values
intersectionsMatrix = zeros(length(names),numValues,numSteps);
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
        intersectionsMatrix(uniqueNameIndex,1:numValues,currentStep) ...
                     = currentVector(:,8);
    end
end
%% Load in the initial file, so can save old data without overwriting entirely
objectDataCSV = table2cell(readtable('handAndAlignment/obj_dict.csv'));
averagesPerObjectStep = zeros(max(objectList),numSteps);
%% Loop through the objects, getting all data and averaging per step
for object = objectList
    thisObjectValues = intersectionsMatrix(objectMatching == object,:,:);
    averagedByStep = mean(thisObjectValues,2);
    averagesPerObjectStep(object,:) = mean(averagedByStep,1);
    %% Store that to matrix pre-writing, at 75% of maximum, also display
    objectDataCSV{[objectDataCSV{:,1}] == object,5} = 0.75*max(averagesPerObjectStep(object,:));
    fprintf('Object %i threshold: %f\n',object,0.75*max(averagesPerObjectStep(object,:)));
end
%% Visualize the averages per object
plot(1:numSteps,averagesPerObjectStep)
legend('show');
%% If saving, save
if nargin == 3 && write == true
    writetable(cell2table(objectDataCSV),'handAndAlignment/obj_dict.csv');
end
end