%% Declaring variables
path2transforms = 'handAndAlignment/transforms';
format4hands = 'handAndAlignment/hand/obj%i_sub%i_grasp%i_%s.stl';
format4transforms = 'obj%d_sub%d_grasp%d_%s_object_transform.txt';
path2numObjectReference = 'handAndAlignment/obj_dict.csv';
path2objects = 'sampleSTLs/';
outputFilePath = 'pathMapping.csv';
tableHeaders = {'TransformsFilepath','ObjectFilepath','HandFilepath','ObjectNum','SubjectNum','GraspNum','Extreme'};
%% Get the object number to filepath link
fID = fopen(path2numObjectReference);
objectMapping = textscan(fID,'%d %s %s','Delimiter',',');
%% Remap objects to different system
objectList(objectMapping{1}) = objectMapping{3};
%% Get the filenames in all of transforms
dirOut = dir(path2transforms);
names = {dirOut.name};
names = names(3:end); % Prune . and ..
%% Scan in the format for the transformation names
valuesOut = cell(length(names),6);
for nameIndex = 1:length(names)
    %% Read in the filename
    valuesOut(nameIndex,3:6) = textscan(names{nameIndex},format4transforms);
    valuesOut(nameIndex,6) = valuesOut{nameIndex,6}; % Get remaining string out of its array
    valuesOut{nameIndex,6} = valuesOut{nameIndex,6}(1:8);
    %% Get the object filepath
    valuesOut{nameIndex, 1} = objectList(valuesOut{nameIndex,3});
    %% Get the output hands equivalent filename
    valuesOut{nameIndex, 2} = sprintf(format4hands,valuesOut{nameIndex,3},valuesOut{nameIndex,4},valuesOut{nameIndex,5},valuesOut{nameIndex,6});
end
%% Prep for saving and save
valuesOut = [names.' valuesOut];
outputTable = cell2table(valuesOut,'VariableNames',tableHeaders);
writetable(outputTable,outputFilePath);