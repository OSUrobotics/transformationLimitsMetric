function [ matrixOut, names, collisionTime ] = load4kmeans( directory, numValues )
%% LOAD4KMEANS Takes in a directory name and returns a list of values for the data in that folder
%==========================================================================
%
% USAGE
%       [ matrixOut, names ] = load4kmeans( directory, numValues )
%
% INPUTS
%
%       directory   - Mandatory - Filepath String   - Path to the folder that contains all of the output csv files you want to give to kmeans
%
%       numValues   - Mandatory - Integer Value     - Number of collision values recorded per step
%
% OUTPUTS
%
%       matrixOut   - Mandatory - NxM Matrix        - Array of collision values where N is the number of unique grasps and M is the number of values per step * number of steps
%
%       names       - Optional  - Nx1 Cell Array    - List of unique grasp names organized by row to match up with matrixOut (The values in the first row of matrixOut coorespond to the name in the first row of names)
%
% EXAMPLE
%
%       To prepare all the grasps in a folder called 'Output' where each step has 588 values:
%       >>  [ matrixOut, names ] = load4kmeans( 'Output', 588 )
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
%% Preallocate an array for storing values
matrixOut = zeros(length(names),numValues * numSteps);
%% Loop through each grasp scenario and append all their collision values 
%  into one long vector, then stack the scenarios on top of each other.
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
% Reorient names to match the collumns of matrixOut
names = names.';

%Do capping stuff

% for i = 1:size(matrixOut,1) %For each grasp system
%     for j = 1:numValues %For each directionOrientationThing
%         triggered = false;
%         triggeredValue = 0;
%         for k = 0:8 %For each step
%             if matrixOut(i,k*numValues+j) > 0.0055
%                 triggered = true;
%                 triggeredValue = matrixOut(i,k*numValues+j);
%             end
%             if triggered == true
%                 matrixOut(i,k*numValues+j) = triggeredValue;
%             end
%         end
%     end
% end

% stepNow = matrixOut(:,1:numValues) > 0.0055;
% logicTotal = stepNow;
% for step = 1:numSteps-1
%     stepNow = (matrixOut(:,step*numValues+1:(step+1)*numValues) > 0.0055) | (stepNow);
%     logicTotal = [logicTotal stepNow];
% end
% matrixOut(logicTotal) = 0.0055;

waldo = reshape(matrixOut,[149,numValues,numSteps]);
collisionTime = zeros(size(waldo,1),size(waldo,2));
for system = 1:size(waldo,1)
    for direction = 1:size(waldo,2)
        where = find(waldo(system,direction,:) > 0.0055,1);
        if isempty(where)
            where = numSteps+1;
        end
        collisionTime(system,direction) = where;
    end
end

end