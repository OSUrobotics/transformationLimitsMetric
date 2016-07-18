function [ matrixOut ] = load4kmeans( directory )
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
numSteps = max([noStep{:,1}]);
names = unique([noStep{:,2}]);

end