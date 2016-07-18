function [ outputVector, usedFiles ] = prepGraspForKmeans( baseFilename )
files = dir(sprintf('Output/*%s',baseFilename));
usedFiles = {files.name};
firstFile = table2array(readtable(sprintf('Output/%s',files(1).name)));
lengthPerStep = size(firstFile,1);
outputVector = zeros(1,lengthPerStep * size(files,1));
outputVector(1,1:lengthPerStep) = firstFile(:,8).';
for currentStep = 2:size(files,1)
    currentVector = table2array(readtable(sprintf('Output/%s', ...
                                                 files(currentStep).name)));
    outputVector(1,lengthPerStep * currentStep - lengthPerStep:lengthPerStep * currentStep - 1) ...
                 = currentVector(:,8).';
end 