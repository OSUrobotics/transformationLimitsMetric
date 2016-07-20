function [ transformationFP, objectFP, surfaceFP, handFP, outputFP ] = filenamesFromComponents( objectNum, subjectNum, graspNum, extreme, stepNum )
%% FILENAMESFROMCOMPONENTS Takes in filepath components and outputs the filenames for the hand, object, transformations, and output file
% stepNum - Optional - use only if want a specific output
transformationFP = sprintf('handAndAlignment/transforms/obj%i_sub%i_grasp%i_%s_object_transform.txt',objectNum,subjectNum,graspNum,extreme);
handFP = sprintf('handAndAlignment/hand/obj%i_sub%i_grasp%i_%s.stl',objectNum,subjectNum,graspNum,extreme);
if nargin == 5
    outputFP = sprintf('Output/Step%iObject%iSubject%iGrasp%i%sAreaIntersection.csv',stepNum,objectNum,subjectNum,graspNum,extreme);
else
    outputFP = sprintf('Output/Step%sObject%iSubject%iGrasp%i%sAreaIntersection.csv','%i',objectNum,subjectNum,graspNum,extreme);
end
objectLinking = table2cell(readtable('handAndAlignment/obj_dict.csv'));
objectFP = sprintf('sampleSTLs/%s',objectLinking{[objectLinking{:,1}] == objectNum,3});
surfaceFP = sprintf('sampleSTLs/%s',objectLinking{[objectLinking{:,1}] == objectNum,4});
end

