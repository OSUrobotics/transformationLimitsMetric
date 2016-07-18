function [ matrixOut, names ] = load4kmeans( directory, numValues )
%% LOAD4KMEANS Takes in a directory name and returns a list of values for the data in that folder
%   Detailed explanation goes here
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
%% Preallocate an array for storing values
matrixOut = zeros(length(names),numValues*length(names));
%% Run through RyanCode
for uniqueNameIndex = 1:length(names)
    files = dir(sprintf('Output/*%s',names{uniqueNameIndex}));
    usedFiles = {files.name};
    for currentStep = 1:numSteps
        currentVector = table2array(readtable(sprintf('Output/%s', ...
                                                     usedFiles{currentStep})));
        matrixOut(uniqueNameIndex,numValues*(currentStep-1)+1:(numValues * currentStep)) ...
                     = currentVector(:,8).';
    end
end
end