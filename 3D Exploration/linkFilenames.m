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
valuesOut = cell(length(names),8);
for nameIndex = 1:length(names)
    %% Read in the filename
    valuesOut(nameIndex,4:7) = textscan(names{nameIndex},format4transforms);
    valuesOut{nameIndex,7} = valuesOut{nameIndex,7}{1};
    valuesOut{nameIndex,7} = valuesOut{nameIndex,7}(1:8);
    %% Get the object filepath
    valuesOut(nameIndex, 1) = strcat(path2objects,objectList(valuesOut{nameIndex,4},1));
    valuesOut(nameIndex, 2) = strcat(path2objects,objectList(valuesOut{nameIndex,4},2));
    %% Get the output hands equivalent filename
    valuesOut{nameIndex, 3} = sprintf(format4hands,valuesOut{nameIndex,4},valuesOut{nameIndex,5},valuesOut{nameIndex,6},valuesOut{nameIndex,7});
    valuesOut{nameIndex, 8} = sprintf(format4output,'%i',valuesOut{nameIndex,4},valuesOut{nameIndex,5},valuesOut{nameIndex,6},valuesOut{nameIndex,7});
end
%% Prep for saving and save
valuesOut = [strcat(repmat(path2transforms,[length(names) 1]),names.') valuesOut];
outputTable = cell2table(valuesOut,'VariableNames',tableHeaders);
writetable(outputTable,outputFilePath);
end