function [ valuesOut ] = linkFilenames( outputFilePath )
%% LINKFILENAMES scans the handAndAlignment directories and files to create a csv file of the relations between those files, with one line per object-person-grasp-extremism set, with a filepath for the object STL, hand STL, and transformation matrices and output data filepaths
%% Declaring variables
path2transforms = 'handAndAlignment/transforms/';
format4transforms = 'obj%d_sub%d_grasp%d_%s_Transformation.txt';
tableHeaders = {'TransformsFilepath','ObjectFilepath','ObjectSurfaceFilepath','HandFilepath','ObjectNum','SubjectNum','GraspNum','Extreme','OutputFormat'};
%% Get the filenames in all of transforms
dirOut = dir(path2transforms);
names = {dirOut.name};
names = names(3:end); % Prune . and ..
%% Scan in the format for the transformation names
valuesOut = cell(length(names),8);
for nameIndex = 1:length(names)
    %% Read in the filename of the transformation
    valuesOut(nameIndex,5:8) = textscan(names{nameIndex},format4transforms);
    %% Get only string out
    valuesOut{nameIndex,8} = valuesOut{nameIndex,8}{1};
    valuesOut{nameIndex,8} = valuesOut{nameIndex,8}(1:15);
    %% Extract other filepaths
    [valuesOut{nameIndex,1}, valuesOut{nameIndex,2}, valuesOut{nameIndex,3}, valuesOut{nameIndex,4}, valuesOut{nameIndex,9}] = ...
        filenamesFromComponents(valuesOut{nameIndex,5},valuesOut{nameIndex,6},valuesOut{nameIndex,7}, ...
                                valuesOut{nameIndex,8});
end
%% Prep for saving and save
outputTable = cell2table(valuesOut,'VariableNames',tableHeaders);
writetable(outputTable,outputFilePath);
end