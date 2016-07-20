function [ valuesOut ] = linkFilenames( outputFilePath )
%% LINKFILENAMES scans the handAndAlignment directories and files to create a csv file of the relations between those files, with one line per object-person-grasp-extremism set, with a filepath for the object STL, hand STL, and transformation matrices and output data filepaths
%% Declaring variables
path2transforms = 'handAndAlignment/transforms/';
format4hands = 'handAndAlignment/hand/obj%i_sub%i_grasp%i_%s.stl';
format4output = 'Output/Step%sObject%iSubject%iGrasp%i%sAreaIntersection.csv';
format4transforms = 'obj%d_sub%d_grasp%d_%s_object_transform.txt';
path2numObjectReference = 'handAndAlignment/obj_dict.csv';
path2objects = 'sampleSTLs/';
tableHeaders = {'TransformsFilepath','ObjectFilepath','ObjectSurfaceFilepath','HandFilepath','ObjectNum','SubjectNum','GraspNum','Extreme','OutputFormat'};
%% Get the object number to filepath link
objectMapping = table2cell(readtable(path2numObjectReference));
%% Remap objects to different system
objectList([objectMapping{:,1}],1:2) = [objectMapping(:,3) objectMapping(:,4)];
%% Get the filenames in all of transforms
dirOut = dir(path2transforms);
names = {dirOut.name};
names = names(3:end); % Prune . and ..
%% Scan in the format for the transformation names
valuesOut = cell(length(names),9);
for nameIndex = 1:length(names)
    %% Read in the filename of the transformation
    valuesOut(nameIndex,5:8) = textscan(names{nameIndex},format4transforms);
    %% Get only string out
    valuesOut{nameIndex,8} = valuesOut{nameIndex,8}{1};
    valuesOut{nameIndex,8} = valuesOut{nameIndex,8}(1:8);
    %% Extract other filepaths
    [valuesOut{nameIndex,1}, valuesOut{nameIndex,2}, valuesOut{nameIndex,3}, valuesOut{nameIndex,4}, valuesOut{nameIndex,9}] = ...
        filenamesFromComponents(valuesOut{nameIndex,5},valuesOut{nameIndex,6},valuesOut{nameIndex,7}, ...
                                valuesOut{nameIndex,8});
end
%% Prep for saving and save
outputTable = cell2table(valuesOut,'VariableNames',tableHeaders);
writetable(outputTable,outputFilePath);
end